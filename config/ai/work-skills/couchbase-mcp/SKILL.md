---
name: couchbase-mcp
description: "Operate a Couchbase cluster through the connected Couchbase MCP server — 20 tools covering document lookup by ID, SQL++ query/EXPLAIN, schema inference, index listing and Index Advisor, bucket/scope/collection discovery, cluster health, connection testing, and 7 query-performance diagnostic reports. Use whenever the user mentions Couchbase, buckets, scopes, collections, SQL++ / N1QL, documents, query performance, Index Advisor, or schema exploration. Distinct from cluster administration (bucket/user/index/XDCR/eventing/backup/encryption management), RBAC, and Capella control-plane operations — none of those are exposed as MCP tools on this server; they require the Couchbase REST Admin API, couchbase-cli, cbbackupmgr, or the Couchbase/Capella UI. Use proactively for troubleshooting Couchbase errors and query performance investigation."
license: MIT
---

# Couchbase MCP

A skill for operating Couchbase through the connected Couchbase MCP server. This server is data-plane and read-only-diagnostics only — it does not expose cluster administration, security/RBAC management, XDCR, eventing, backup, encryption, or Capella control-plane tools. Where the user asks for one of those, say so plainly and point them at the right non-MCP path (REST Admin API, `couchbase-cli`/`cbbackupmgr`, or the Couchbase/Capella UI) rather than inventing a tool call that doesn't exist.

## The 20 tools

**Document access**
- `get_document_by_id` — fetch one document by key

**Query & schema**
- `run_sql_plus_plus_query` — execute a SQL++ statement (SELECT, and DML/DDL if the server isn't in read-only mode)
- `explain_sql_plus_plus_query` — get the query plan without executing
- `get_schema_for_collection` — infer a flattened schema from a document sample

**Indexes**
- `list_indexes` — list existing indexes
- `get_index_advisor_recommendations` — suggested index DDL for a given statement

**Bucket / scope / collection discovery**
- `get_buckets_in_cluster`
- `get_scopes_in_bucket`
- `get_collections_in_scope`
- `get_scopes_and_collections_in_bucket` — combined listing in one call

**Cluster & connection**
- `get_cluster_health_and_services`
- `get_server_configuration_status`
- `test_cluster_connection`

**Query performance diagnostics** (all read the `system:completed_requests` catalog)
- `get_longest_running_queries`
- `get_most_frequent_queries`
- `get_queries_not_selective`
- `get_queries_not_using_covering_index`
- `get_queries_using_primary_index`
- `get_queries_with_large_result_count`
- `get_queries_with_largest_response_sizes`

**On dedicated write/mutation tools:** some deployments of this server also expose `upsert_document_by_id` / `insert_document_by_id` / `replace_document_by_id` / `delete_document_by_id`. If they're not in your connected tool list, either the server is running with `CB_MCP_READ_ONLY_MODE=true`, or this deployment simply doesn't enable them — either way, mutations still work through `run_sql_plus_plus_query` with UPSERT/INSERT/UPDATE/DELETE ... USE KEYS statements. Check what's actually connected before telling a user a mutation is impossible.

## When this skill applies

Any time the user is working with Couchbase data, queries, schema, or query performance. If the ask is cluster administration, security, XDCR, eventing, backup, encryption, or Capella control-plane — this skill still applies (to tell the user how to do it correctly), but the answer routes to a non-MCP path, not a tool call.

## Pick the right reference

| Task domain | Read this reference |
|---|---|
| Document lookup, SQL++ query/DDL/DML, EXPLAIN, schema inference | `references/data-plane.md` |
| Bucket/scope/collection discovery, cluster health, connection test — plus what real admin operations require (bucket/user/index/XDCR management) | `references/cluster-admin.md` |
| Query performance analysis, EXPLAIN plan reading, Index Advisor workflow | `references/diagnostics.md` |
| Vector indexes and other 8.x features reachable via SQL++ DDL, plus what's gated | `references/couchbase-8x.md` |
| Monitoring, alerting, what metrics matter, Prometheus integration | `references/observability.md` |
| Multi-step procedures (rolling upgrade, node add/remove, failover recovery, restore, credential rotation) — none executable via this MCP, but the reference tells you the real path | `references/operational-runbooks.md` |
| RBAC design, audit strategy, password policy, KMIP-vs-DARE, network isolation | `references/security-best-practices.md` |
| Errors and unexpected results | `references/troubleshooting.md` |
| "What's the tool name for X?" | `references/tool-index.md` |

Capella control-plane operations (organizations, projects, clusters, allowed CIDRs, API keys, app services) have no MCP tool on this server at all — direct the user to the Capella UI or the Capella public API v4 directly.

Each reference is self-contained.

## Conventions for tool calls

**Connection scoping:** tools take bucket/scope/collection as arguments when the operation needs them; check the specific tool's parameters rather than assuming an env-var default exists.

**JSON in / JSON out:** all tools return JSON. `get_document_by_id` returns the document itself; `run_sql_plus_plus_query` returns the result rows; the diagnostic tools return arrays of query-catalog entries.

**Read-only mode:** if the server is running with `CB_MCP_READ_ONLY_MODE` / `CB_MCP_READ_ONLY_QUERY_MODE` set, mutating DML in `run_sql_plus_plus_query` will be rejected. SELECT/EXPLAIN and all the discovery/diagnostic tools still work.

## How to pick a tool when given a task

1. **Read one document by ID?** → `get_document_by_id`
2. **Anything else touching documents (write, filter, join, aggregate)?** → `run_sql_plus_plus_query`
3. **Why is this query slow?** → `explain_sql_plus_plus_query`, then `get_index_advisor_recommendations`
4. **What indexes exist / should exist?** → `list_indexes` / `get_index_advisor_recommendations`
5. **What's in this bucket/scope/collection?** → `get_buckets_in_cluster` → `get_scopes_and_collections_in_bucket` → `get_schema_for_collection`
6. **Is the cluster up? Can I reach it?** → `test_cluster_connection`, `get_cluster_health_and_services`
7. **General "queries are slow"?** → the `get_queries_*` / `get_*_running_queries` / `get_most_frequent_queries` family — see `references/diagnostics.md`
8. **Anything about buckets/users/indexes-as-DDL-objects/XDCR/eventing/backup/encryption/Capella management?** → there's no tool for it. Say so, then point to the REST Admin API, `couchbase-cli`, `cbbackupmgr`, or the UI as appropriate. Check `references/tool-index.md` before concluding "not possible" for anything data/query-shaped.

## Examples of correct use

**Example 1 — User asks "show me my buckets":**

Call `get_buckets_in_cluster`.

**Example 2 — User asks "what's slow in my workload?":**

Read `references/diagnostics.md`, then call `get_longest_running_queries` and `get_most_frequent_queries` for a starting picture. Follow up with `get_queries_not_using_covering_index` to find missing-index opportunities.

**Example 3 — User asks "create a vector index on my embedding field":**

There's no dedicated vector-index tool. Read `references/couchbase-8x.md` for the CREATE VECTOR INDEX SQL++ DDL syntax (Hyperscale vs Composite), then run it via `run_sql_plus_plus_query`.

**Example 4 — User asks "create a new bucket" or "add a user" or "set up XDCR":**

None of these have an MCP tool on this server. Tell the user plainly, then point them at the REST Admin API / `couchbase-cli` / the Couchbase UI (or the Capella UI for a Capella-hosted cluster). Read `references/cluster-admin.md`, `references/security-best-practices.md`, or `references/operational-runbooks.md` for the specifics of what's needed.

**Example 5 — User asks "delete this document" / "drop this index":**

Both are possible via `run_sql_plus_plus_query` (`DELETE ... USE KEYS`, `DROP INDEX ...`), unless the server is in read-only mode. Confirm the target and impact with the user before running destructive DML/DDL — there's no `confirm:true` gate on this server, the statement just executes.
