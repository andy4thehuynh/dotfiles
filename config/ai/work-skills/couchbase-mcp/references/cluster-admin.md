# Cluster discovery, and what real admin operations require

This server exposes discovery/read tools for buckets, scopes, collections, and cluster health — but no bucket/scope/collection/user/index-DDL/XDCR/FTS management tools. This reference covers both: what you *can* call, and what the domain knowledge is for the operations you can't reach via MCP.

## Discovery tools (available)

| Tool | Read-only? | Notes |
|---|---|---|
| `get_buckets_in_cluster` | ✓ | List all buckets |
| `get_scopes_in_bucket` | ✓ | All scopes in a bucket |
| `get_collections_in_scope` | ✓ | Collections in a scope |
| `get_scopes_and_collections_in_bucket` | ✓ | Combined listing in one call — prefer this over the two calls above when you need both |
| `get_cluster_health_and_services` | ✓ | Overall cluster health, node/service status |
| `get_server_configuration_status` | ✓ | Server configuration/version info |
| `test_cluster_connection` | ✓ | Verify connectivity |

## Bucket, scope, and collection management — not available via MCP

Creating, deleting, flushing, or reconfiguring buckets; creating or dropping scopes and collections — none of these have a tool on this server.

- **Scopes and collections** are reachable via SQL++ DDL through `run_sql_plus_plus_query`: `CREATE SCOPE`, `DROP SCOPE`, `CREATE COLLECTION`, `DROP COLLECTION`.
- **Bucket create/delete/flush/settings/autoscale** have no SQL++ equivalent — these require the Couchbase REST Admin API (`/pools/default/buckets`), `couchbase-cli` (`bucket-create`, `bucket-delete`, `bucket-flush`, `bucket-edit`), or the Couchbase/Capella UI.

**Bucket types:** `couchbase` (typical), `memcached` (cache-only, deprecated), `ephemeral` (in-memory + replicated). Pick `couchbase` unless you specifically know you need ephemeral semantics.

**Eviction policy:** `valueOnly` (default — evict values only, keep metadata in memory) vs `fullEviction` (evict everything — better for large datasets). For working sets larger than RAM, `fullEviction` is correct.

**Deleting a scope drops all its collections; deleting a collection drops its indexes too** — surface that impact to the user before running the DDL.

## Users, groups, roles (RBAC) — not available via MCP

No tool on this server lists, creates, updates, or deletes users, groups, or roles. This requires the REST Admin API (`/settings/rbac/users`, `/settings/rbac/groups`, `/settings/rbac/roles`), `couchbase-cli` (`user-manage`), or the Couchbase UI.

See `security-best-practices.md` for RBAC design guidance and `operational-runbooks.md` for credential rotation. The **role names** themselves are still useful to know when writing the REST payload or CLI command:

- `admin` — full cluster admin
- `cluster_admin` — admin minus security
- `bucket_admin[bucket]` — manage one bucket
- `data_reader[bucket]` — read documents
- `data_writer[bucket]` — write documents
- `query_select[bucket]` — run SELECT queries
- `query_manage_index[bucket]` — create/drop indexes

Roles are bucket-scoped where shown with `[bucket]`. Pass `*` for all buckets.

## Audit & security policy — not available via MCP

Audit configuration, password policy, and cluster-wide security settings (TLS enforcement, encryption-in-transit) all require the REST Admin API (`/settings/audit`, `/settings/passwordPolicy`, `/settings/security`) or the UI. See `security-best-practices.md` for what to actually configure.

## Cluster topology — not available via MCP

Node add/remove, rebalance, failover, recovery, autofailover/autocompaction config, alerts, and server groups have no MCP tool. These require the REST Admin API, `couchbase-cli` (`server-add`, `server-eject`, `rebalance`, `failover`, `setting-autofailover`, `setting-autocompaction`, `server-group-manage`), or the UI.

See `operational-runbooks.md` for the step-by-step procedures — they're written against the correct non-MCP tooling.

## Indexes (GSI) — DDL only, no dedicated management tool

There's no `create index` / `drop index` / `build index` / `alter index` tool. All of it is SQL++ DDL through `run_sql_plus_plus_query`:

```sql
CREATE INDEX idx_tier ON `bucket`.`scope`.`collection`(tier) WITH {"defer_build": true};
BUILD INDEX ON `bucket`.`scope`.`collection`(idx_tier);
DROP INDEX `bucket`.`scope`.`collection`.idx_tier;
```

**Defer index builds during bulk loads:** create multiple indexes with `defer_build: true`, then issue one `BUILD INDEX` statement listing all of them — this batches the actual building into a single scan pass.

**Primary indexes are expensive:** only create one (`CREATE PRIMARY INDEX`) when the user explicitly wants one. Standard practice is secondary indexes covering the actual query patterns.

Read-only reporting on existing indexes is available via `list_indexes` and `get_index_advisor_recommendations` — see `diagnostics.md`.

## FTS index management — not available via MCP

Creating, updating, deleting, pausing, or resuming FTS indexes, and alias management, all require the FTS REST API or the UI. Running a search against an *existing* FTS index is possible via SQL++'s `SEARCH()` function — see `data-plane.md`.

## XDCR — not available via MCP

Setting up remote-cluster references, replications, or reading conflict logs requires the REST Admin API (`/pools/default/remoteClusters`, `/controller/createReplication`) or the UI. See the `couchbase-xdcr` skill for topology/conflict-resolution design, and `operational-runbooks.md`/`security-best-practices.md` in this skill for where XDCR setup fits into a broader procedure.

## Stats & observability — not available via MCP (except query-performance)

There's no general stats/logs/Prometheus/system-events tool on this server. The 7 query-performance diagnostic tools (`get_longest_running_queries`, etc. — see `diagnostics.md`) are the one exception; everything else (bucket stats, index stats, XDCR stats, eventing stats, cluster logs, system events, Prometheus scrape) requires the REST Admin API, the Prometheus exporter endpoint directly, or the UI. See `observability.md`.

## Quick decision tree

- **"Show me my buckets/scopes/collections"** → `get_buckets_in_cluster` / `get_scopes_in_bucket` / `get_collections_in_scope` / `get_scopes_and_collections_in_bucket`
- **"Get cluster health"** → `get_cluster_health_and_services`
- **"Is the connection working?"** → `test_cluster_connection`
- **"Create a new bucket / scope / collection"** → scopes/collections via SQL++ `CREATE SCOPE`/`CREATE COLLECTION`; buckets are not reachable via MCP at all — REST API/CLI/UI
- **"Who has access?"** → not available via MCP — REST API/CLI/UI; see `security-best-practices.md`
- **"Add / remove a node", "rebalance", "failover"** → not available via MCP — see `operational-runbooks.md` for the real procedure
- **"Set up XDCR"** → not available via MCP — REST API/UI; see `couchbase-xdcr` skill for design
- **"Create / drop an index"** → SQL++ DDL via `run_sql_plus_plus_query`
