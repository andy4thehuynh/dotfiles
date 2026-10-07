# Troubleshooting

When the MCP returns an error or a tool's result doesn't match what the user expects, work through these patterns. Each section starts with the symptom, then gives the likely causes and the diagnostic tool to confirm — noting where the diagnosis has to leave the MCP entirely.

## Connection failures

### Symptom: "could not connect to cluster" / "connection refused"

**Likely causes (in order of frequency):**

1. **Wrong connection string scheme.** `couchbase://` for non-TLS, `couchbases://` for TLS. Capella requires `couchbases://`. Mixing them up is the most common error.
2. **Wrong management port.** Default is 8091 for self-managed clusters, 18091 for Capella.
3. **TLS cert not trusted.** Self-signed certs need the server's CA trust configured; otherwise the SDK refuses the connection.
4. **Network firewall blocking** the data ports (11207 for TLS KV, 11210 for non-TLS KV). The cluster manager port (8091/18091) responds but actual data ops fail.
5. **Cluster is genuinely down.** Rare but happens.

**Diagnostic flow:**
- Call `test_cluster_connection` first — this is the cheapest connectivity test
- If it fails: check the connection string, port, and credentials configured for the MCP server itself; nothing else matters until basic connectivity works
- If it succeeds but specific operations still fail: the issue is scoped to that operation (permissions, missing resource), not connectivity

### Symptom: connection works, then drops after a while

Almost always TCP keepalive issues. The SDK's idle connections get reaped by a NAT or load balancer. Set the SDK's keepalive interval shorter than the network's idle timeout. Not something the MCP exposes — it's SDK/environment config the user must adjust in their environment.

## Authentication failures

### Symptom: "Unauthorized" / "401" / "user not found"

**Likely causes:**

1. **Wrong username or password** configured for the MCP server. Most common.
2. **User exists but doesn't have the role for this operation.** The error often says "Forbidden" rather than "Unauthorized" in this case. There's no `whoami`-equivalent tool on this server to confirm effective roles directly — check `get_server_configuration_status` for anything it surfaces, otherwise this needs the REST Admin API or UI to inspect the user's role assignments.
3. **User was locked** (8.x) — not diagnosable via MCP; check via REST Admin API or UI.

**Diagnostic flow:**
- `test_cluster_connection` to confirm the credentials work for basic connectivity
- If connection succeeds but a specific query/operation fails with Forbidden: the authenticated user lacks the role for that bucket/scope/collection — check role assignment via REST Admin API/UI (see `security-best-practices.md` for the role list)
- If connection itself fails: the credentials are wrong

## Query errors

### Symptom: "syntax error" in SQL++

Couchbase's SQL++ has a few syntactic differences from standard SQL:
- Identifiers with special characters or keywords need backticks: `` SELECT * FROM `my-bucket`.`scope`.`collection` ``
- Date literals: `STR_TO_MILLIS("2026-01-01")` or `MILLIS_TO_STR(...)` — no native DATE type
- ARRAY syntax for filtering arrays: `ANY x IN array SATISFIES x.field = "value" END`

Run `explain_sql_plus_plus_query` to confirm parse — it will surface syntax errors with line/column info.

### Symptom: query is correct but returns wrong results

Common cause: a stale or partial index. Indexes in Couchbase are eventually consistent by default. To force consistency, pass `scan_consistency: "request_plus"` in the `run_sql_plus_plus_query` call:

```json
{
  "tool": "run_sql_plus_plus_query",
  "arguments": {
    "statement": "SELECT * FROM users WHERE tier = 'gold'",
    "scan_consistency": "request_plus"
  }
}
```

`request_plus` makes the query wait for the index to catch up to the current sequence number before returning. Slower but correct.

### Symptom: "no index available" / very slow query

The query is doing a primary scan or no scan at all. Run `explain_sql_plus_plus_query` — look for `PrimaryScan` in the plan. Then call `get_index_advisor_recommendations` with the same statement to get suggested index DDL.

## Index issues

### Symptom: "Index not found" when querying

Either the index doesn't exist (check `list_indexes`) or it was created but never built. Indexes created with `defer_build: true` need a follow-up `BUILD INDEX` statement via `run_sql_plus_plus_query`.

### Symptom: index exists but query plan ignores it

The optimizer didn't pick it. Common reasons:
- The WHERE clause doesn't match the index keys (leading fields)
- The index is on a different scope/collection than the query thinks
- The index is in an errored state — check with `list_indexes`

Use `explain_sql_plus_plus_query` to see which index (if any) the optimizer chose, then compare against `list_indexes`.

### Symptom: index stays in "building" status forever

For large collections, builds can legitimately take hours. But if it's been > 1 day and the cluster is otherwise idle, it may be stuck. Build progress isn't exposed by any tool here — check via the REST Admin API or UI. If progress is stuck at 0%, drop and recreate the index (`DROP INDEX` / `CREATE INDEX` via `run_sql_plus_plus_query`) — the build worker may have crashed.

## XDCR replication lag

Not diagnosable via this MCP at all — replication state, `changes_left`, and conflict logs require the XDCR REST API or the UI. See `couchbase-xdcr` skill for the underlying topology/conflict-resolution concepts and `cluster-admin.md` in this skill for what's reachable here vs. not.

## Eventing function failures

Not diagnosable via this MCP — deploy status, function errors, and processing state require the Eventing REST API or the UI. See the `couchbase-eventing` skill for the underlying concepts.

## Backup / restore failures

Not diagnosable via this MCP — backup/restore status comes from `cbbackupmgr` output or the Capella UI. See `operational-runbooks.md` for the safe restore pattern (restore to a scratch bucket first). Once data lands in a bucket, `run_sql_plus_plus_query` (MCP) is the fastest way to spot-check whether the restore actually landed the expected data.

## KMIP failures

Not diagnosable via this MCP — KMIP connectivity and key-rotation errors require the REST Admin API or KMIP server's own logs. See `security-best-practices.md` for when KMIP is warranted at all.

## Capella-specific errors

Not diagnosable via this MCP — there are no Capella control-plane tools on this server. Cluster lookup, project/org hierarchy issues, and rate limiting are all Capella UI / public API v4 territory.

## Generic catch-all

### Symptom: tool returns an error you don't understand

If the error response includes a hint or detail field, read it before going further — it usually points to the specific check that failed. If it's empty or unhelpful, and the operation you're trying to do has no MCP tool at all (check `tool-index.md` before concluding that), the underlying detail likely lives in the Couchbase cluster logs, reachable via the REST Admin API or UI, not through this MCP.

If you've exhausted these and don't know what to do, surface the full error to the user verbatim and ask them to check the Couchbase admin console for additional context. This MCP doesn't see everything the cluster sees.
