# Diagnostics & query performance analysis

The `get_*` query-performance family and the index/schema tools answer "what's slow?" / "what's wrong?" questions. They don't change anything — all read-only — but they're the right starting point for any optimization or incident-response task.

## When to reach for diagnostics

- User says "queries are slow" / "the app is slow" / "Couchbase is slow"
- User asks "why is this query slow" (specific query) → use `explain_sql_plus_plus_query` (see `data-plane.md`) before the `get_queries_*` family
- User asks "what should I index" → `get_index_advisor_recommendations` is the most direct answer
- User asks "what's in this collection" (exploratory) → `get_schema_for_collection`

## The query-performance family

Each tool returns the top N queries (check the tool's own parameters for the exact limit/default) along the named dimension. The underlying data source is the `system:completed_requests` catalog — so it covers queries the query service has logged. Long-running or otherwise notable queries are typically there; trivial subsecond queries may not be, depending on the cluster's completed-requests threshold configuration.

| Tool | Returns queries by… |
|---|---|
| `get_longest_running_queries` | Maximum elapsed time |
| `get_most_frequent_queries` | Execution count |
| `get_queries_with_largest_response_sizes` | Result payload size in bytes |
| `get_queries_with_large_result_count` | Number of result rows returned |
| `get_queries_not_using_covering_index` | Queries that fetched docs from the data service instead of being satisfied entirely by indexes |
| `get_queries_using_primary_index` | Queries forced to scan the primary index (often a smell) |
| `get_queries_not_selective` | Queries with low selectivity (returning a high fraction of scanned docs) |

There's no per-user breakdown tool on this server — see the note in `couchbase-8x.md` on getting that via a direct `system:completed_requests` query instead.

## Investigative workflow

A typical "find the worst offenders" walk:

1. **`get_longest_running_queries`** and **`get_most_frequent_queries`** — a query that runs 10,000 times at 50ms is usually a bigger problem than one that runs once at 30 seconds, so look at both angles.
2. **For each suspect, run `explain_sql_plus_plus_query`** — gets the plan, reveals whether it's using the primary index, has covering-index gaps, etc.
3. **`get_index_advisor_recommendations`** with that query — gets the recommended index DDL.
4. **Run the recommended `CREATE INDEX` DDL** via `run_sql_plus_plus_query`, optionally `WITH {"defer_build": true}` if creating several at once.
5. **`BUILD INDEX`** at the end (also via `run_sql_plus_plus_query`) to actually build all deferred indexes in one pass.

## Index advisor

| Tool | What it does |
|---|---|
| `get_index_advisor_recommendations` | Returns suggested index DDL for a given SQL++ statement |

Pass a SQL++ statement; the advisor returns a list of `CREATE INDEX` recommendations sorted by estimated impact. The advisor considers:
- The WHERE clause predicates (which fields to index)
- The SELECT projection (whether the index can cover the query)
- Existing indexes (won't suggest duplicates)

It does NOT consider:
- Write throughput cost of the new index
- Disk space cost
- Whether the suggested index would compete with existing ones for the index service's memory budget

So treat the advisor's output as *candidates*, not commands. For each suggestion, ask:
- How often does this query actually run?
- How big is the collection (5K docs ≠ 50M docs)?
- Is there an existing index that's *almost* the right shape that could be extended instead? Check with `list_indexes`.

## Schema inference

| Tool | What it does |
|---|---|
| `get_schema_for_collection` | Samples documents from a collection and returns a flattened schema |

Output looks like:

```json
{
  "fields": [
    {"path": "id", "types": ["string"], "occurrence": 1.0},
    {"path": "user.name", "types": ["string"], "occurrence": 0.98},
    {"path": "user.age", "types": ["number"], "occurrence": 0.85},
    {"path": "addresses[]", "types": ["array"], "occurrence": 0.6}
  ],
  "sample_size": 100
}
```

`occurrence` is the fraction of sampled documents containing that field. Useful for:
- Understanding a new collection's shape before querying it
- Spotting schema drift (low-occurrence fields are usually accidental writes)
- Picking which fields to index

## EXPLAIN

| Tool | What it does |
|---|---|
| `explain_sql_plus_plus_query` | Returns the query plan for a SQL++ statement (no execution) |

The plan is a tree of operators with cost estimates. The relevant pieces for diagnosis:

- **`#operator`**: the type of node (IndexScan, PrimaryScan, Fetch, Filter, Project, Order, etc.)
- **`index`** on an IndexScan: which index it's using. Missing → primary scan
- **`covers`**: array of field paths the index can serve without a Fetch. A query that doesn't need a Fetch is "covered"
- **`cardinality`** estimates: rows expected at each stage

**Red flags in plans:**
- A `PrimaryScan` near the root → no useful secondary index; advisor will suggest one
- A `Fetch` after `IndexScan` → index isn't covering; could extend it to cover
- A `Sort` not backed by an index → result set is being sorted in memory
- A `Nested Join` between large collections → likely missing a join key index

## Currently-executing queries — not available via MCP

There's no tool for a live snapshot of in-flight queries on this server. That requires a direct `SELECT * FROM system:active_requests` via `run_sql_plus_plus_query`, or the Query Monitoring UI. Cancelling a specific runaway query also requires the REST Admin API (`/admin/{active,completed}_requests/<requestId>` DELETE) or the UI — not available here.

## Quick decision tree

- **"Queries are slow generally"** → `get_longest_running_queries` and `get_most_frequent_queries` first, then drill into top offenders
- **"This specific query is slow"** → `explain_sql_plus_plus_query` then `get_index_advisor_recommendations`
- **"What indexes should I have?"** → `get_index_advisor_recommendations` on representative queries
- **"What indexes exist already?"** → `list_indexes`
- **"What's in this collection?"** → `get_schema_for_collection`
- **"Who's running queries right now?"** → not available via MCP; `SELECT * FROM system:active_requests` via `run_sql_plus_plus_query`
- **"Why am I returning so much data?"** → `get_queries_with_largest_response_sizes` or `get_queries_with_large_result_count`
- **"Why is this query doing a full scan?"** → `get_queries_using_primary_index` (lists all candidates) or `explain_sql_plus_plus_query` (for one query)
- **"Per-user breakdown of query stats"** → not a dedicated tool; query `system:completed_requests` directly, see `couchbase-8x.md`
