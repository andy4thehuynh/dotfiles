# Observability — what to monitor and how

A reference for setting up monitoring, picking the right stats, and knowing what to alert on. The connected MCP server exposes exactly one slice of this — query performance — via the diagnostic tools in `diagnostics.md`. Everything else (bucket/node/index/XDCR/eventing stats, logs, system events, Prometheus scrape) requires the REST Admin API, the Prometheus exporter endpoint directly, or the UI. This reference keeps the "what matters and why" knowledge either way.

## The stats hierarchy

Couchbase exposes stats at several levels:

1. **Cluster-wide** — overall health, node count, services up
2. **Per-node** — CPU, RAM, disk, network for each node
3. **Per-service** — Data, Query, Index, FTS, Eventing, Analytics each have their own stats
4. **Per-bucket** — write/read ops, memory usage, item count, replicas
5. **Per-collection / per-scope** — more granular, useful for multi-tenant
6. **Per-query / per-index** — drilling into specific items

Always start broad (cluster) and drill down to the layer where the symptom appears.

## What's reachable via this MCP vs. not

| Need | Path |
|---|---|
| Cluster health snapshot | `get_cluster_health_and_services` (MCP tool) |
| Query performance (slow/frequent/large-result queries) | The `get_*` diagnostic family — see `diagnostics.md` (MCP tools) |
| Per-bucket / per-node / per-service stats (KV, index, FTS, XDCR, eventing, analytics) | Not via MCP — REST Admin API `/pools/default/buckets/<bucket>/stats`, or the UI |
| Cluster logs | Not via MCP — REST Admin API `/logs`, `couchbase-cli`, or the UI |
| System events (failovers, config changes) | Not via MCP — REST Admin API `/eventLogging`, or the UI |
| Prometheus scrape | Not via MCP — the cluster's own Prometheus-format endpoint (`:8091/metrics` on recent versions), scraped directly by your Prometheus server |

## Metrics that matter

Of the hundreds of metrics Couchbase exposes, these are the ones to actually watch, regardless of how you're pulling them.

### Data service (KV)

| Metric | What it tells you | Alert threshold |
|---|---|---|
| `cache_miss_ratio` | % of reads that had to fetch from disk | > 5% sustained = working set too big for RAM |
| `ep_resident_items_rate` | % of items in RAM (valueOnly eviction) | < 90% = consider more RAM or fullEviction |
| `ep_oom_errors` | Out-of-memory rejections | > 0 = immediate alert, writes are failing |
| `disk_write_queue` | Pending writes to disk | > 1M sustained = disk can't keep up |
| `ep_tmp_oom_errors` | Temporary OOM (transient) | > 0 sustained = memory pressure |
| `vb_active_resident_items_ratio` | Working set resident in RAM | < 85% = working set under-sized |
| `bytes_read` / `bytes_written` | Network throughput per bucket | Trend monitoring for capacity planning |

### Query service

| Metric | What it tells you | Alert threshold |
|---|---|---|
| `n1ql_requests` | Query rate | Baseline for capacity planning |
| `n1ql_errors` | Failed queries | > 1% of requests = investigate |
| `n1ql_slow_queries` | Queries over the slow-query threshold | Spike = something changed |
| `n1ql_active_requests` | Currently running | > query-service-thread-count sustained = thread pool exhausted |

The query-side numbers here overlap with what the MCP's diagnostic tools surface at the individual-query level (see `diagnostics.md`) — these are the aggregate/rate view instead.

### Index service

| Metric | What it tells you | Alert threshold |
|---|---|---|
| `index_resident_percent` | % of index in RAM | < 100% = index doesn't fit; slower scans |
| `index_data_size` | Total index bytes | Trend monitoring |
| `index_num_pending_requests` | Scan queue depth | > thread count sustained = scan throughput limited |
| `indexer_state` | Active / Paused / Recovery | anything other than Active = problem |

### XDCR

| Metric | What it tells you | Alert threshold |
|---|---|---|
| `changes_left` | Documents not yet replicated | Growing trend = replication falling behind |
| `bandwidth_usage` | Replication bandwidth | Useful for capacity planning |
| `docs_processed` | Replication throughput | Compare against write rate on source |
| `data_replicated_age` | Lag of replication (seconds) | > 60 seconds sustained = investigate |

### Eventing

| Metric | What it tells you | Alert threshold |
|---|---|---|
| `processing_status` | Function active or paused | Paused unexpectedly = alert |
| `success_count` / `failure_count` | Per-function execution outcomes | failure ratio > 1% = investigate |
| `on_update_latency` | How long function takes per invocation | Trending up = function slowing down |
| `dcp_backlog` | Backlog of mutations the function hasn't processed | Growing = function can't keep up |

### Cluster-wide

| Metric | What it tells you | Alert threshold |
|---|---|---|
| `rebalance_running` | Whether a rebalance is active | True for hours = stuck rebalance |
| `node_status` (per node) | Up / Warmup / Failed | Anything not "Up" = investigate |
| `autofailover_count` | Autofailovers triggered recently | > 0 = at least one node failed |
| `disk_used_percent` (per node) | Disk fill | > 80% = scale soon; > 90% = scale now |

## Prometheus integration

Configure your Prometheus server to scrape the cluster's Prometheus-format endpoint directly — this is not reachable via the MCP:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'couchbase'
    metrics_path: /metrics
    static_configs:
      - targets: ['cb-node-1:8091', 'cb-node-2:8091', 'cb-node-3:8091']
    basic_auth:
      username: 'monitor_user'
      password: '<password>'
```

Once scraped, Couchbase metrics flow into your existing Prometheus + Grafana stack alongside everything else. Dedicated Couchbase dashboards exist on Grafana Labs' dashboard registry — search "Couchbase" there for community-maintained ones.

## Recommended alerts

A starter alert set for production:

**Critical (page someone):**
- `node_status != Up` for any node, sustained > 2 minutes
- `ep_oom_errors > 0` on any bucket (writes failing)
- `disk_used_percent > 90` on any node
- `autofailover_count` increased in the last 5 minutes
- `rebalance_running == true` for > 4 hours (likely stuck)

**Warning (notify on-call channel):**
- `cache_miss_ratio > 10%` sustained 10+ minutes
- `disk_used_percent > 80` on any node
- XDCR `changes_left` growing over 30+ minutes
- `n1ql_errors / n1ql_requests > 1%` sustained 5+ minutes
- Any Eventing function with `failure_count / success_count > 5%`
- Any index in `errored` or `paused` state

**Informational (log only):**
- Slow query count increasing
- Index size growing (capacity planning)
- Per-bucket op rate trending up (capacity planning)

## Logs and system events — not available via MCP

Cluster logs and the structured system-event log both require the REST Admin API or the UI:

- **Logs**: error/warning messages from the cluster manager. Free-text, intended for human reading. File location for self-managed: `/opt/couchbase/var/lib/couchbase/logs/`. Capella: log access via the Capella UI; programmatic access requires support tickets currently.
- **System events**: structured log of state changes (failovers, config updates, user actions). Intended for machine consumption.

For "what's broken right now" → logs. For "what changed in the cluster yesterday" → system events. Ship both to your central log aggregation for retention beyond the cluster's own window; audit logs (when enabled) are separate and go to their own file — ship these to a security log aggregator with appropriate access controls.

## Per-collection observability (8.x)

Couchbase 8.x exposes per-collection stats — useful when one collection's behavior matters separately from the rest of the bucket. Not reachable via this MCP; pull it from the REST Admin API's per-bucket stats endpoint with scope/collection parameters. For multi-tenant deployments using scope-per-tenant, this lets you see per-tenant load without exposing per-tenant queries.

## What to put on a dashboard

A useful 6-panel dashboard:

1. **Cluster health** — node count + status, current alerts, autofailover history
2. **Throughput** — KV ops/sec + N1QL queries/sec + FTS searches/sec, stacked
3. **Latency** — KV p99 + N1QL p99 + FTS p99 (separate lines)
4. **Memory** — per-bucket memory used vs quota; cache miss ratio
5. **Disk** — per-node disk fill %; disk write queue depth
6. **XDCR** — per-replication lag (changes_left); replication throughput

Build this once and it'll answer 80% of "is the cluster OK" questions at a glance.

## Quick decision tree

- **"Is the cluster healthy?"** → `get_cluster_health_and_services` (MCP), then per-node/service stats via REST API if you need more depth
- **"Why is a query slow?"** → `explain_sql_plus_plus_query` first (MCP); if it's a pattern, the `get_*` diagnostic family from `diagnostics.md` (MCP)
- **"Why is the cluster slow generally?"** → not fully answerable via MCP — cache miss ratio, disk queue, and OOM errors live in per-bucket/node stats via the REST API
- **"What changed recently?"** → not via MCP — system events / logs via REST API or UI
- **"Setting up external monitoring"** → not via MCP — scrape the cluster's Prometheus endpoint directly
- **"Per-function eventing health"** → not via MCP — REST API eventing stats
- **"XDCR keeping up?"** → not via MCP — REST API XDCR stats, watch `changes_left` and `data_replicated_age`
