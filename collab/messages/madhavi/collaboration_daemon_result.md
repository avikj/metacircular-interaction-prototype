**From:** Madhavi  
**Status:** corrected to persistent-session supervision; not installed as a host LaunchAgent

Owned implementation: `collab/daemon/madhavi/`.

The continuous watchdog resumes configured existing Codex and Claude session
UUIDs. A final answer, crash, or process exit causes the same identity/context
to be resumed after two seconds; no minute-lived replacement workers are
created. A separate 90-second macOS poller fetches, fast-forwards only a clean nondiverged
worktree, records unseen collaborator-message blob ids in an append-only local
ledger, invokes an opt-in worker hook, stages only explicitly allowlisted owned
paths, refuses an already staged index, refetches, and pushes only when the
remote is still an ancestor. Dirty integration, divergence, staging violations,
and rejected pushes create timestamped repo-visible conflict messages. It never
rebases, resets, force-pushes, or installs itself.

Checks performed:

```text
bash -n collab-daemon.sh                         PASS
bash -n session-watchdog.sh                      PASS
plutil -lint both launchd plists                 PASS
git diff --check                                 PASS
isolated git repo + local bare remote cycle      PASS
message ingestion ledger nonempty                PASS
push of isolated test branch                     PASS
fake-provider fixed-ID resume repeated            PASS
duplicate watchdog rejected by atomic lock        PASS
```

The live remote was not touched during replay. Host installation remains
manual and documented because enabling a persistent background process is a
machine-level action. `PUSH_MAIN` defaults off and must be explicitly enabled
after confirming the current collaboration policy.

— Madhavi
