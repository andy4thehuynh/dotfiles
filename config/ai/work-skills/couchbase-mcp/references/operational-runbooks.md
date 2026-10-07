# Operational runbooks

None of the procedures below are executable through the connected MCP server — it has no cluster-topology, bucket-lifecycle, or backup/restore tools. What follows is the correct *sequence and reasoning* for each procedure; the actual steps go through the Couchbase REST Admin API, `couchbase-cli`, `cbbackupmgr`, or the Couchbase/Capella UI. Where a step is genuinely a SQL++ statement, it's called out as MCP-reachable via `run_sql_plus_plus_query`.

Use `get_cluster_health_and_services` (MCP) to check cluster state before and after each procedure below — that part *is* reachable via MCP.

## Rolling upgrade

**When to use:** upgrading Couchbase Server from version N to N+1 across all nodes, without taking the cluster offline.

**Preconditions:**
- Cluster is healthy (`get_cluster_health_and_services` reports healthy)
- Replicas ≥ 1 for every bucket (otherwise upgrading a node loses availability for any data only on that node)
- A recent backup exists (`cbbackupmgr info`, or Capella's managed backup status)

**Procedure:**

1. `get_cluster_health_and_services` (MCP) — record current node count, services per node, and replica counts. Save this somewhere outside the cluster
2. Pick the first node to upgrade (start with a non-orchestrator node if possible)
3. Surface to user: "I'm about to remove node X from rotation, upgrade it, and add it back. The cluster stays online but throughput on the data services on this node drops to its replicas during the process. Continue?"
4. Graceful failover the node via `couchbase-cli failover --hard=false` (drains active traffic to replicas first) or the UI
5. Verify failover completed (cluster status shows the node inactive)
6. **Out-of-band step:** the user manually upgrades the Couchbase binary on that node and starts the service. Nothing in this stack — MCP, REST API, or CLI on another node — can do this; it's a shell/service operation on the node itself
7. Set recovery type via `couchbase-cli recovery --recovery-type=delta` (faster — only re-syncs changed data) or `--recovery-type=full` if the node was offline longer than the typical replication window
8. Trigger rebalance via `couchbase-cli rebalance` to integrate the upgraded node back into the cluster
9. Poll rebalance status until complete (`couchbase-cli rebalance-status`, or the UI)
10. Verify: cluster health shows the node active again, on the new version
11. Repeat steps 2-10 for each remaining node
12. After ALL nodes are upgraded, the cluster compatibility version updates automatically. Verify via `get_cluster_health_and_services` (MCP) or `couchbase-cli server-info`

**If it goes wrong:**
- During steps 4-7 (node failed over but upgrade itself failed): downgrade the binary, then re-run the recovery + rebalance steps to bring the node back at the original version. The cluster never went offline; you just have one less node temporarily
- During step 8 (rebalance fails partway): stop the rebalance (`couchbase-cli rebalance-stop`), investigate via cluster logs. The cluster is left in a partially-rebalanced state but data is safe. Don't proceed to the next node until the current one's rebalance completes successfully

## Adding a node to expand capacity

**When to use:** scaling up the cluster — adding a node to increase RAM, disk, or query throughput.

**Preconditions:**
- The new node has Couchbase Server installed at the same version as the existing cluster
- The new node can reach the cluster manager (port 8091/18091) network-wise
- An admin user exists on the cluster

**Procedure:**

1. `get_cluster_health_and_services` (MCP) — note current node count and per-node memory/storage
2. `couchbase-cli server-add` with the new node's hostname/IP, admin credentials, and the services to enable on it (`data`, `query`, `index`, `fts`, `eventing`, `analytics`, `backup`)
3. Verify: the new node shows as added but not yet serving traffic
4. Surface to user: "Node added. To start serving traffic, I need to rebalance — this redistributes data across the new node set. Estimated time depends on data volume, typically minutes to hours. Continue?"
5. `couchbase-cli rebalance`
6. Poll rebalance status until complete
7. Verify: `get_cluster_health_and_services` (MCP) shows the new node active

**If it goes wrong:**
- Step 2 fails ("node already in cluster" / "version mismatch"): the new node was either previously added or is on a different version (upgrade it first)
- Steps 5-6 (rebalance fails): stop it, fix the root cause from logs, then resume by rebalancing again. The cluster is fine in the meantime — the new node just isn't yet serving traffic

## Removing a node to scale down or replace hardware

**When to use:** taking a node out of the cluster for hardware replacement or to reduce capacity.

**Preconditions:**
- Replicas ≥ 1 on all buckets (otherwise removing a node loses data)
- Remaining nodes have enough capacity to hold this node's data and traffic after redistribution

**Procedure:**

1. `get_cluster_health_and_services` (MCP) — record current state, especially this node's data footprint
2. Check current cluster utilization via the REST Admin API's stats endpoints or the UI. If you're already at 80%+ RAM, removing a node may push you over the edge
3. Surface to user with calculated impact: "removing this node will cause its ~X GB of data to be redistributed; expected RAM utilization after removal: Y%"
4. `couchbase-cli server-eject` (or mark for removal via the UI) for the target node
5. `couchbase-cli rebalance` — this is what actually redistributes the data
6. Poll rebalance status until complete
7. Verify: the removed node no longer appears in `get_cluster_health_and_services` (MCP)
8. (User step): shut down Couchbase on the removed node, repurpose / decommission

**If it goes wrong:**
- Rebalance fails because remaining nodes are out of capacity: stop it, add a replacement node first via the "adding a node" runbook, then retry the removal

## Post-failover recovery

**When to use:** a node was auto-failed-over or hard-failed-over. You need to bring it back.

**Preconditions:**
- The reason for the failover is known and resolved (network was restored, disk was replaced, etc.)
- The failed node is reachable again

**Procedure:**

1. `get_cluster_health_and_services` (MCP) — confirm the node is in a failed-over state
2. Check cluster logs (REST API/UI) — understand what caused the original failover so you know whether to use delta or full recovery
3. `couchbase-cli recovery`:
   - `--recovery-type=delta` if the node was offline less than the bucket's metadata retention window (faster, only re-syncs changes)
   - `--recovery-type=full` if it was offline longer, or if the disk was replaced
4. `couchbase-cli rebalance`
5. Poll rebalance status until complete
6. Verify: `get_cluster_health_and_services` (MCP) shows the node active

**If it goes wrong:**
- Delta recovery fails ("changes too large"): switch to full recovery and retry
- The node simply can't be recovered (disk corruption, etc.): treat it as a permanent loss — remove it from the cluster and add a fresh node

## Restoring from backup (safely)

**When to use:** recovering from data loss or rolling back a bad change.

**Preconditions:**
- A valid backup exists (`cbbackupmgr info`, or the Capella managed-backup listing)
- You have a clear answer to "restore to where?" — typically NOT directly over production

**Procedure — the safe way:**

1. `cbbackupmgr info` (or Capella UI) — find the snapshot. Note its ID and timestamp
2. Surface to user: "Restoring directly over the current bucket is risky — any writes since the backup will be lost. I recommend restoring to a temporary bucket first, validating, then deciding whether to swap. Proceed with the safe pattern?"
3. Create a new bucket named `<original>_restore_<date>` with the same settings as the original, via the REST Admin API or `couchbase-cli bucket-create`
4. `cbbackupmgr restore` targeting the new bucket
5. Wait for completion (`cbbackupmgr` reports status; poll if run in the background)
6. User validates the restored data — `run_sql_plus_plus_query` (MCP) against the new bucket is the fastest way to spot-check
7. If valid: the user decides whether to keep the original (this is a recovery copy for reference) or swap. Swapping is application-specific — usually it means redirecting client config to the new bucket, then deleting the old one days/weeks later
8. If invalid: delete the restore bucket (REST API/`couchbase-cli bucket-delete`); the original is untouched

**Procedure — the unsafe way (when the user insists on restoring over production):**

1. `cbbackupmgr info` (or Capella UI) — find the snapshot. Note its ID
2. Surface to user EXPLICITLY: "This will OVERWRITE the current `<bucket>` bucket. Any writes since the backup timestamp `<timestamp>` will be permanently lost. There is no automatic rollback. Confirm with 'yes, overwrite <bucket>'"
3. Wait for unambiguous confirmation
4. `cbbackupmgr restore` targeting the production bucket
5. Wait for completion
6. Validate via `run_sql_plus_plus_query` (MCP) on representative data

**If it goes wrong:**
- The restore failed partway: the target bucket is in an inconsistent state (some docs from the backup, possibly some pre-existing docs). Either flush the bucket (if no recovery is needed) then restart the restore, or attempt incremental recovery by re-restoring (depends on `cbbackupmgr` version)

## Enabling DARE on existing data

**When to use:** turning on Data-at-Rest Encryption for a cluster that already has data.

**Preconditions:**
- KMIP server is configured and reachable, if using KMIP
- The cluster has spare I/O — re-encryption is I/O-intensive

**Procedure:**

1. Confirm current state is "disabled" via the REST Admin API or UI
2. Surface to user: "Enabling DARE triggers a background re-encryption pass on existing data. The cluster stays online but I/O is heavier for the duration. Estimated time scales with total data size — typically hours for production-scale buckets. Continue?"
3. Enable DARE via the REST Admin API or UI
4. Poll re-encryption progress via the REST Admin API or UI
5. Verify completion the same way

**If it goes wrong:**
- Re-encryption stalls: check cluster stats for I/O saturation; throttle other work, or accept slower progress
- KMIP becomes unreachable mid-encryption: the cluster stops accepting new writes until KMIP is restored. Fix KMIP connectivity first

## Rotating credentials

**When to use:** credential rotation (suspected compromise, regular schedule, employee departure).

### Rotating a database user's password

1. Confirm the user exists and note their current roles via the REST Admin API or UI
2. Generate a new strong password
3. Update the password via the REST Admin API (`/settings/rbac/users/local/<user>`) or `couchbase-cli user-manage`
4. Distribute the new password to all systems using this credential
5. Validate connectivity from those systems — `test_cluster_connection` (MCP) is a quick check from this side
6. Done — the old password is now invalid

### Rotating a Capella API key

The MCP has no Capella control-plane tools at all. This must be done via the Capella web UI (or its public API v4 directly):

1. In Capella UI, create a new API key with the same roles as the old one
2. Update systems that use the old key to use the new key
3. Validate the new key works against the Capella API
4. In Capella UI, revoke the old key

### Rotating the DARE master key

1. Confirm current state and key ID via the REST Admin API or UI
2. Surface to user: "Key rotation triggers a re-encryption pass with the new master key. Cluster stays online but I/O is heavier. Continue?"
3. Trigger rotation via the REST Admin API or UI
4. Poll re-encryption progress
5. Verify the new key ID is in effect

For KMIP-managed keys, the KMIP server generates the new key; Couchbase initiates re-encryption with the new key reference the same way.

## A general pattern for any "I want to do X" runbook the user invents

If the user asks for a procedure not listed here, follow this shape:

1. **Preconditions** — what must be true before starting (replica count, recent backup, version, etc.)
2. **Step-by-step** — concrete actions, with what to verify between them, and which parts (if any) are reachable via `run_sql_plus_plus_query` or another MCP tool vs. require the REST Admin API / CLI / UI
3. **Rollback** — what to do if any step fails
4. **Confirmation** — describe the impact of destructive steps and get explicit user confirmation before executing them, whether that's a SQL++ statement or an out-of-band command you're telling the user to run

Don't skip the rollback step. Real operational pain comes from being mid-procedure when something fails and not knowing what state the system is in.
