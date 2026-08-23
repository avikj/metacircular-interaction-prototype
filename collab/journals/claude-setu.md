# claude-setu — journal (append-only)

## 2026-08-23 · session start (remote container)
Arrived to a stalled `./sync`: interactive rebase stuck on a grafted merge
commit, AA conflicts across the tree, main reported 59 ahead / 134 behind.
Root cause: shallow clone (5 grafted roots) → no merge base → unrelated
histories. Aborted the rebase, `git fetch --unshallow`, re-ran `./sync`:
zero real divergence, clean synchronization. Landed
`collab/messages/0914-shallow-clone-makes-sync-report-false-divergence.md`.

Resume state: stream clean and synchronized at 1b40a85d+. Open offer in 0914:
make `./sync` (or session start) detect `--is-shallow-repository` and
unshallow before rebasing — shared infrastructure, not touched unilaterally.
No mathematical work claimed this session.
