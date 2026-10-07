# Safety — destructive operations and how to approach them

This server's safety model is simpler than a full admin MCP, precisely because it doesn't expose admin operations at all. The two things to get right: how the server's own read-only mode works, and how to handle destructive SQL++.

## Mechanism: read-only mode

`CB_MCP_READ_ONLY_MODE` / `CB_MCP_READ_ONLY_QUERY_MODE`, set in the MCP server's environment, restrict `run_sql_plus_plus_query` to non-mutating statements (SELECT, EXPLAIN). If either is set and you attempt UPDATE / INSERT / UPSERT / DELETE / DDL, the call fails.

**You can't override this from the client side.** Don't try. If the user needs a mutation and the server is in read-only mode, surface that plainly: "the MCP is running in read-only mode; either unset the read-only env var on the server and restart it, or make this change through the Couchbase UI / REST Admin API directly."

There's no per-tool `confirm:true` gate on this server the way some MCP servers implement one — if `run_sql_plus_plus_query` isn't blocked by read-only mode, a destructive statement just executes. That makes the conversational confirmation step (below) the *only* safety net for destructive SQL++ on this server — take it seriously.

## How to handle a destructive request

The right flow for any destructive statement:

1. **Identify the impact** — what data will change, is it reversible, what's the blast radius? (`SELECT COUNT(*) ...` with the same predicate before a `DELETE`/`UPDATE` is a cheap way to know the blast radius before you commit to it.)
2. **State it to the user clearly** — "this will delete ~4.7M documents matching this filter. There's no automatic recovery; rollback requires restoring from backup."
3. **Ask for explicit confirmation** — not "should I proceed?" but "type 'yes, delete these' to confirm" or equivalent. Don't accept ambiguous answers.
4. **Run the statement** only after step 3.
5. **Surface the result** — report rows affected, or the error verbatim if it failed.

Don't skip steps 2-3 even if the user said "delete it" earlier in the conversation. Ambiguity is one of the most common causes of "I lost my data" incidents.

## Destructive operations reachable via this MCP (all via `run_sql_plus_plus_query`)

- `DELETE ... USE KEYS [...]` / `DELETE FROM ... WHERE ...` — deletes matching documents. **Irreversible without a backup.**
- `UPDATE` / `UPSERT` — overwrites document content. Reversible only if you kept a copy of the prior value.
- `DROP INDEX` — drops a secondary index. Recoverable by recreating, but rebuilding can take a long time on large collections.
- `DROP SCOPE` / `DROP COLLECTION` — deletes a scope (and everything in it, recursively) or a collection (and its documents and indexes). High blast radius — confirm the target very explicitly.

If dedicated write tools (`upsert_document_by_id`, `delete_document_by_id`, etc.) are present on your connected server, the same conversational-confirmation discipline applies to them — they mutate/delete just as permanently as the equivalent SQL++ statement, they just don't route through a `confirm:true` parameter either.

## What's NOT destructive but might feel like it

Safe to call without the confirmation dance:

- `get_document_by_id`, `run_sql_plus_plus_query` (SELECT only), `explain_sql_plus_plus_query`, `get_schema_for_collection`
- `list_indexes`, `get_index_advisor_recommendations` (returns suggestions only, doesn't create anything)
- `get_buckets_in_cluster`, `get_scopes_in_bucket`, `get_collections_in_scope`, `get_scopes_and_collections_in_bucket`
- `get_cluster_health_and_services`, `get_server_configuration_status`, `test_cluster_connection`
- All 7 query-performance diagnostic tools

## Out of scope for this reference: destructive operations outside the MCP

Bucket delete/flush, node removal, failover, rebalance, XDCR replication delete, user delete, encryption rotation, and backup/restore are all real destructive operations the user might ask about — but none of them are reachable via this MCP at all (see `cluster-admin.md`, `operational-runbooks.md`). When the user asks for one, the safety discipline is the same (state impact, get explicit confirmation) but it applies to whatever REST API call, `couchbase-cli` command, or UI action you're guiding them through — not a tool call this skill can make on their behalf.

## Concrete dialog patterns

**Pattern: deleting documents**

User: "Delete all sessions older than 30 days"
You: "Before I run this, let me check how many that affects." [runs `SELECT COUNT(*) FROM \`app\`.\`_default\`.\`sessions\` WHERE created_at < NOW_MILLIS() - 2592000000` via `run_sql_plus_plus_query`] "This will delete 48,213 documents. There's no automatic recovery — rollback requires a backup. To proceed, type 'yes, delete them'."
User: "yes, delete them"
You: [runs the `DELETE ... WHERE ...` statement via `run_sql_plus_plus_query`]
You: "Deleted 48,213 documents."

**Pattern: dropping an index**

User: "Drop the idx_tier index, it's not being used"
You: "Confirm: dropping `idx_tier` on `bucket.scope.collection`. This is recoverable by recreating it, but rebuilding on a large collection can take a while. Proceed?"
User: "yes"
You: [runs `DROP INDEX` via `run_sql_plus_plus_query`]
You: "Dropped."

**Pattern: something the MCP can't do (e.g. "restore the prod backup from yesterday")**

You: "There's no MCP tool for restoring a backup — that has to go through `cbbackupmgr` (or the Capella UI for a managed backup) directly. Before you do: restoring will OVERWRITE the current `prod` bucket with the backup snapshot, and any writes since the backup will be lost. I'd recommend restoring to a `prod_restore` bucket first and validating before swapping — see `operational-runbooks.md` for the full procedure."
