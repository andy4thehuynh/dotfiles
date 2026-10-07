# Tool index — the full list

A flat listing of all 20 tools on the connected server, plus a reverse "what do I want to do" index. When you know what you want to do and just need the exact tool name, this is the page.

## All 20 tools, by group

**Document access**
- `get_document_by_id`

**Query & schema**
- `run_sql_plus_plus_query`
- `explain_sql_plus_plus_query`
- `get_schema_for_collection`

**Indexes**
- `list_indexes`
- `get_index_advisor_recommendations`

**Bucket / scope / collection discovery**
- `get_buckets_in_cluster`
- `get_scopes_in_bucket`
- `get_collections_in_scope`
- `get_scopes_and_collections_in_bucket`

**Cluster & connection**
- `get_cluster_health_and_services`
- `get_server_configuration_status`
- `test_cluster_connection`

**Query performance diagnostics**
- `get_longest_running_queries`
- `get_most_frequent_queries`
- `get_queries_not_selective`
- `get_queries_not_using_covering_index`
- `get_queries_using_primary_index`
- `get_queries_with_large_result_count`
- `get_queries_with_largest_response_sizes`

Some deployments additionally expose `upsert_document_by_id`, `insert_document_by_id`, `replace_document_by_id`, `delete_document_by_id` — check your connected tool list rather than assuming either way.

## Task → tool mapping

| Task | Tool |
|---|---|
| Check connectivity | `test_cluster_connection` |
| Read a document | `get_document_by_id` |
| Read many documents | `run_sql_plus_plus_query` with `USE KEYS [...]` |
| Read/modify a field inside a document | `run_sql_plus_plus_query` (`SELECT`/`UPDATE ... SET`) — no subdoc tool |
| Write a document | `run_sql_plus_plus_query` (UPSERT/INSERT/UPDATE), or the dedicated write tools if your server exposes them |
| Delete a document | `run_sql_plus_plus_query` (`DELETE ... USE KEYS`), or `delete_document_by_id` if exposed |
| Run SQL++ | `run_sql_plus_plus_query` |
| See query plan | `explain_sql_plus_plus_query` |
| Explore schema | `get_schema_for_collection` |
| Full-text search | `run_sql_plus_plus_query` with `SEARCH()` (7.6+), against an existing FTS index |
| Suggest indexes for a query | `get_index_advisor_recommendations` |
| List existing indexes | `list_indexes` |
| Create/drop an index | `run_sql_plus_plus_query` DDL (`CREATE INDEX` / `DROP INDEX`) |
| Find slow queries | `get_longest_running_queries` |
| Find frequent queries | `get_most_frequent_queries` |
| Find queries doing full scans | `get_queries_using_primary_index` |
| Find queries not using a covering index | `get_queries_not_using_covering_index` |
| Find low-selectivity queries | `get_queries_not_selective` |
| Find queries returning huge payloads | `get_queries_with_largest_response_sizes` |
| Find queries returning many rows | `get_queries_with_large_result_count` |
| List buckets | `get_buckets_in_cluster` |
| List scopes / collections | `get_scopes_in_bucket` / `get_collections_in_scope` / `get_scopes_and_collections_in_bucket` |
| Get cluster health | `get_cluster_health_and_services` |
| Get server/version info | `get_server_configuration_status` |
| Create a bucket / scope / collection | Scopes/collections: `run_sql_plus_plus_query` DDL. Buckets: not via MCP — REST Admin API/CLI/UI |
| List / create / lock users | Not via MCP — REST Admin API/CLI/UI |
| Rebalance, failover, node add/remove | Not via MCP — REST Admin API/CLI/UI, see `operational-runbooks.md` |
| Set up XDCR | Not via MCP — REST Admin API/UI |
| Create a vector index (8.x) | `run_sql_plus_plus_query` DDL (`CREATE VECTOR INDEX`) |
| Deploy an Eventing function | Not via MCP — REST Admin API/UI |
| Run a backup / restore | Not via MCP — `cbbackupmgr` or Capella managed backups |
| Enable encryption at rest (8.x) | Not via MCP — REST Admin API/UI |
| Anything Capella control-plane (orgs, projects, clusters, allowlists, API keys) | Not via MCP at all — Capella UI or public API v4 |
