> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Madhavi collaboration daemon

This directory contains two deliberately separate processes.

`session-watchdog.sh` is long-lived. It resumes explicitly configured existing
Codex and Claude session IDs. When either CLI exits—whether from a crash, a
completed final answer, or an external termination—the provider loop waits two
seconds and invokes the CLI's resume operation on the **same session ID**. It
never starts an ephemeral turn or invents a replacement identity. `launchd`
keeps the watchdog itself alive.

`collab-daemon.sh` is only the 90-second Git heartbeat. It:

1. acquire a nonblocking local lock;
2. fetch the private remote;
3. fast-forward `main` only from a clean shared checkout;
4. append unseen collaborator-message blob ids to a local ingestion ledger;
5. commit changes only under the configured owned-path allowlist;
6. refetch and push only when remote history is an ancestor;
7. push only `main`.

Runtime logs and ingestion state are append-only and ignored by Git. Conflicts
create timestamped Markdown messages under `collab/messages/madhavi/`; the
daemon never resets, rebases, force-pushes, overwrites a dirty worktree, or
commits an index already staged by another process.

## Install

```sh
cd /Users/avikjain/Desktop/math
cp collab/daemon/madhavi/config.example collab/daemon/madhavi/config.local
chmod +x collab/daemon/madhavi/collab-daemon.sh
chmod +x collab/daemon/madhavi/session-watchdog.sh
plutil -lint collab/daemon/madhavi/com.avikj.math-collab-heartbeat-madhavi.plist
plutil -lint collab/daemon/madhavi/com.avikj.math-session-watchdog-madhavi.plist
cp collab/daemon/madhavi/com.avikj.math-collab-heartbeat-madhavi.plist \
  collab/daemon/madhavi/com.avikj.math-session-watchdog-madhavi.plist \
  "$HOME/Library/LaunchAgents/"
launchctl bootstrap "gui/$(id -u)" \
  "$HOME/Library/LaunchAgents/com.avikj.math-collab-heartbeat-madhavi.plist"
launchctl bootstrap "gui/$(id -u)" \
  "$HOME/Library/LaunchAgents/com.avikj.math-session-watchdog-madhavi.plist"
```

Installation is deliberately manual because enabling a persistent background
process is a host-level action. The daemon fails closed unless both its
configuration and checkout are on `main`.

Before installation, put the existing Codex and Claude UUIDs in `config.local`,
or point `*_SESSION_RECORD` at an existing flat JSON record containing a
`session_id`. The retired worker supervisor must not be run to create one.
An empty ID disables that provider; this is fail-closed and prevents accidental
fresh sessions. The default resume commands use normal workspace permissions
and never pass a permission-bypass flag.

## Persistent session contract

The session itself reads and writes the canonical shared checkout on `main`.
The watchdog contributes no prompts except the configured
continuation instruction. Provider stdout/stderr are appended separately. Git
heartbeat and model lifetime are independent: a fetch cycle never resets model
context, and a model exit never forces a Git operation.

Run one foreground cycle with:

```sh
MATH_COLLAB_CONFIG=/path/to/test-config \
  collab/daemon/madhavi/collab-daemon.sh
```

Inspect `runtime/daemon.log` for Git cycles and `runtime/watchdog.log` for
session resumes. Empty session IDs disable their providers rather than creating
new sessions.

## Start, stop, and status

```sh
# Status
launchctl print "gui/$(id -u)/com.avikj.math-session-watchdog-madhavi"
launchctl print "gui/$(id -u)/com.avikj.math-collab-heartbeat-madhavi"
tail -f collab/daemon/madhavi/runtime/watchdog.log

# Stop without deleting session identity/history
launchctl bootout "gui/$(id -u)/com.avikj.math-session-watchdog-madhavi"
launchctl bootout "gui/$(id -u)/com.avikj.math-collab-heartbeat-madhavi"

# Start again from the same configured session records
launchctl bootstrap "gui/$(id -u)" \
  "$HOME/Library/LaunchAgents/com.avikj.math-session-watchdog-madhavi.plist"
launchctl bootstrap "gui/$(id -u)" \
  "$HOME/Library/LaunchAgents/com.avikj.math-collab-heartbeat-madhavi.plist"
```

Duplicate supervisors are prevented twice: `launchd` labels are unique, and
the watchdog acquires an atomic runtime directory lock before launching either
provider loop. A second manual invocation exits without touching the sessions.
