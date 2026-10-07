# Data plane — document access, SQL++, and schema

The document-access and query tools operate on documents and query results directly. Check which of the document tools are actually present on your connected server before assuming a capability is missing (see the note in `SKILL.md` about read-only mode).

## Document access

| Tool | What it does | Read-only? |
|---|---|---|
| `get_document_by_id` | Get a single document by ID. Returns the full document or an error | ✓ |

**No dedicated write or multi-get tool on this server.** If you need to insert, upsert, replace, delete, or batch-get documents, use `run_sql_plus_plus_query`:

```sql
UPSERT INTO `bucket`.`scope`.`collection` (KEY k, VALUE v)
  VALUES ("user_42", {"name": "Alice", "tier": "gold"})
```

```sql
DELETE FROM `bucket`.`scope`.`collection` USE KEYS ["user_42"]
```

```sql
SELECT * FROM `bucket`.`scope`.`collection` USE KEYS ["user_42", "user_43", "user_44"]
```

INSERT (fails on existing key) and UPDATE (fails if the key doesn't exist, and can target specific fields) work the same way — see `couchbase-coding-standards` skill for parameterization and CAS-based concurrency patterns. If your connected server does expose `upsert_document_by_id` / `insert_document_by_id` / `replace_document_by_id` / `delete_document_by_id`, prefer those for single-document writes — they're simpler and avoid building SQL++ by hand.

**No subdocument tool on this server.** There's no equivalent of a lookup-in/mutate-in call. SQL++ UPDATE can target a nested path directly without rewriting the whole document:

```sql
UPDATE `bucket`.`scope`.`collection` USE KEYS ["user_42"]
SET lastLogin = "2026-05-21T10:00:00Z",
    loginCount = loginCount + 1
```

This still round-trips through the query service rather than a true binary subdoc op, so it's not a performance-equivalent substitute for high-frequency single-field updates — just the only path available via this MCP.

## SQL++ (N1QL) queries

For anything that isn't a single-doc-by-ID lookup.

| Tool | What it does | Read-only? |
|---|---|---|
| `run_sql_plus_plus_query` | Run a SQL++ statement against the cluster | Depends on statement |
| `explain_sql_plus_plus_query` | Get the query plan for a SQL++ statement. Use BEFORE optimizing a slow query | ✓ |
| `get_schema_for_collection` | Infer the schema (field paths + types) of a collection from a sample of documents | ✓ |

**Read-only mode and queries:** if `CB_MCP_READ_ONLY_MODE` / `CB_MCP_READ_ONLY_QUERY_MODE` is set on the server, `run_sql_plus_plus_query` blocks statements that modify data (UPDATE / INSERT / UPSERT / DELETE / DDL). SELECTs and EXPLAINs still work.

**EXPLAIN before optimizing:** when asked "why is this query slow?", run `explain_sql_plus_plus_query` first. The plan reveals primary-index scans (typically the slowness culprit), missing covering indexes, and unusual join shapes. Then use `get_index_advisor_recommendations` (see `diagnostics.md`) to get suggested index DDL.

**Schema inference for unknown data:** `get_schema_for_collection` is the right tool when the user asks "what's in this collection?" — it samples documents and returns a flattened schema. Much more concise than running `SELECT * LIMIT 5` and asking the user to interpret it.

**Transactions:** there's no dedicated transaction tool. Multi-statement ACID transactions are reachable via SQL++ itself:

```sql
BEGIN WORK;
UPDATE `bank`.`_default`.`accounts` USE KEYS ["account_a"] SET balance = balance - 100;
UPDATE `bank`.`_default`.`accounts` USE KEYS ["account_b"] SET balance = balance + 100;
COMMIT WORK;
```

Run each statement through `run_sql_plus_plus_query` in sequence within the same session/connection context the underlying SDK maintains; if anything fails, issue `ROLLBACK WORK` instead of `COMMIT WORK`.

## Full-text search and Analytics — not exposed as dedicated tools

There's no FTS-search or Analytics-query tool on this server. Both are still reachable through SQL++:

- **FTS search:** use the `SEARCH()` function inside `run_sql_plus_plus_query` (Couchbase 7.6+) against an existing FTS index: `SELECT * FROM \`bucket\`.\`scope\`.\`collection\` WHERE SEARCH(collection, {"query": {"match": "..."}})`. Creating/editing the FTS index itself is not reachable via this MCP — see `cluster-admin.md`.
- **Analytics service queries:** if the cluster has Analytics enabled, some SQL++ statements can target Analytics datasets directly; otherwise this requires the Analytics REST API. This server has no dedicated Analytics-query tool.

## Quick decision tree

- **"I need to read one document by ID"** → `get_document_by_id`
- **"I need to read many documents by ID"** → `run_sql_plus_plus_query` with `USE KEYS [...]`
- **"I need to read/update certain fields of a document"** → `run_sql_plus_plus_query` with a targeted `SELECT`/`UPDATE ... SET`
- **"I need to write a whole document"** → `run_sql_plus_plus_query` with UPSERT/INSERT/UPDATE (or the dedicated write tools, if your connected server exposes them)
- **"I need to query across documents"** → `run_sql_plus_plus_query`
- **"I need a search-engine-style query"** → `run_sql_plus_plus_query` with `SEARCH()`, against an index that already exists
- **"I need atomicity across multiple docs"** → `run_sql_plus_plus_query` with `BEGIN WORK` / `COMMIT WORK` / `ROLLBACK WORK`
- **"I want to understand the schema"** → `get_schema_for_collection`
- **"I want to see why a query is slow"** → `explain_sql_plus_plus_query`, then read `diagnostics.md`
