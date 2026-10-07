# Couchbase 8.x specific features

None of these have a dedicated MCP tool on this server. Where the feature is reachable via SQL++ DDL, use `run_sql_plus_plus_query`; otherwise it needs the REST Admin API, `couchbase-cli`, or the UI. Check the server version first — `get_server_configuration_status` or `get_cluster_health_and_services` should report it.

## Vector indexes (search-driven similarity) — via SQL++ DDL

Two flavors, both for indexing high-dimensional vector embeddings:

| Type | When to pick it |
|---|---|
| Composite vector index | The default. Combines vector field with other scalar fields in one index. Cheaper, fits most workloads under ~10M vectors |
| Hyperscale vector index | For very large vector corpora (10M+ vectors) or when search latency on huge indexes is the bottleneck. More expensive in storage and index-build time, but scales further |

```sql
CREATE VECTOR INDEX idx_embeddings
  ON `my-bucket`.`_default`.`_default`(embedding VECTOR)
  WITH {
    "dimension": 1536,
    "similarity": "COSINE",
    "description": "IVF,SQ8"
  };
```

Run this through `run_sql_plus_plus_query`. Consult the current Couchbase Server SQL++ vector-index DDL reference for the exact `WITH` options distinguishing Composite from Hyperscale in your server version — the option names have moved between releases; don't hardcode a specific shape from memory here.

**Picking `similarity`:**
- `COSINE` — measures angle, ignores magnitude. Default for most semantic-search use cases with OpenAI / Voyage / Cohere embeddings
- `DOT_PRODUCT` — assumes vectors are already normalized; faster than COSINE if so
- `L2_SQUARED` — Euclidean distance squared. For embeddings where magnitude carries meaning (rare)

If unsure, use `COSINE` — it's what the popular embedding providers expect.

**Picking `dimension`:**
- OpenAI `text-embedding-3-small`: 1536
- OpenAI `text-embedding-3-large`: 3072 (or 1024 with `dimensions` param)
- Voyage `voyage-3`: 1024
- Cohere `embed-english-v3.0`: 1024

Get the dimension wrong and inserts fail at write time, not index-create time — so triple-check.

## Synonyms (FTS) — not available via MCP

Couchbase 8.x adds synonym groups that map terms together for full-text search (e.g., "automobile" / "car" / "vehicle" all match the same docs). The synonym-set documents themselves are regular Couchbase documents, so creating/reading/deleting them is reachable via `run_sql_plus_plus_query` (UPSERT/SELECT/DELETE against the collection you store them in). But wiring the FTS index definition to reference a synonym source (`params.mapping.analysis.synonym_sources`) requires the FTS REST API or the UI — no tool on this server edits FTS index definitions.

## User lock / unlock and temporary users — not available via MCP

Couchbase 8.x adds an account-state field to users so admins can lock accounts without deleting them, and supports temporary users that auto-expire. Both require the REST Admin API (`/settings/rbac/users/local/<user>`) or `couchbase-cli` — no tool here manages users at all. See `security-best-practices.md`.

## XDCR conflict log readback — not available via MCP

Couchbase 8.x can persist the losing side of a concurrent-update conflict to a conflict-log bucket. The conflict-log *bucket* itself is a regular collection, so reading recent entries is a `run_sql_plus_plus_query` SELECT once you know where it's configured to write. Querying the replication's conflict-log *configuration* requires the XDCR REST API.

## DARE + KMIP (encryption at rest) — not available via MCP

Enabling/disabling DARE, rotating keys, and configuring KMIP all require the REST Admin API or the UI. See `security-best-practices.md` for when KMIP is warranted and `operational-runbooks.md` for the rotation procedure.

## Per-user query stats — not available via MCP

The 8.x per-user breakdown of query stats (who's running the slow queries) isn't broken out by the diagnostic tools on this server — `get_most_frequent_queries` / `get_longest_running_queries` etc. return the top-N queries but not grouped by authenticating user. Getting a per-user view requires the REST Admin API's query stats endpoints or `SELECT` against `system:completed_requests` directly via `run_sql_plus_plus_query` (it has a `users` field you can filter/group on).

## How these fail against a 7.x cluster

`CREATE VECTOR INDEX` and other 8.x-only SQL++ syntax return a parse/execution error if run against a 7.x cluster — check the server version first via `get_cluster_health_and_services` or `get_server_configuration_status` if the user hasn't said which version they're on.

## Quick decision tree

- **"Create a vector index"** → `CREATE VECTOR INDEX` DDL via `run_sql_plus_plus_query` (confirm Composite vs Hyperscale option shape against current docs for the connected version)
- **"Set up synonyms for FTS"** → synonym-set documents via `run_sql_plus_plus_query`; wiring the index to them needs the FTS REST API/UI
- **"Lock a user account (incident response)"** → not via MCP — REST Admin API/UI
- **"Create a temp account for a contractor"** → not via MCP — REST Admin API/UI
- **"Read XDCR conflict log"** → `run_sql_plus_plus_query` SELECT against the conflict-log bucket, once you know its name/location
- **"Enable encryption at rest"** → not via MCP — REST Admin API/UI
- **"Find which user is running the slow queries"** → `run_sql_plus_plus_query` against `system:completed_requests`, filtering/grouping on `users`
