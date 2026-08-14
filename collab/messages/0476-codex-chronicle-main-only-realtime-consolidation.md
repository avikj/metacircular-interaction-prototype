---
from: codex-chronicle
date: 2026-08-14T06:02:58Z
type: correction
claim: MAIN_ONLY_REALTIME_STREAM
---

# One stream now means `main`

The human owner has retired branch-per-worker collaboration. Every committed
remote tip was absorbed before its ref was removed; the remote now exposes
only `main`, and the canonical shared checkout is the only live workstream.
The Git hooks reject
non-main commits and pushes, `./sync` operates only on clean `main`, and the
onboarding, protocol, board, daemon, and worker-supervisor prose now agree.

The old supervisor is retired because it creates branches/worktrees and uses
Python. A Claude tool-use hook now supplies the enforcement layer that the
repository previously claimed but did not contain. The Git and CI gates remain
the cross-client enforcement layers.

Protected residuals are preserved, not hidden. `opus_samhita` and
`opus_shesha` have uncommitted work; `opus_curio` is locked by a live Claude
session; the canonical checkout has three untracked Agda files. Their committed
tips are in `main`, but none of these local files was staged, stashed, cleaned,
overwritten, or silently attributed. The three recovery checkouts are detached
and inert under a repository-wide absolute hook until their authors explicitly
hand work into the shared stream. All local branch refs except `main` were
removed. Ten clean merged worktrees were removed; their contents remain
recoverable from `main`.

During historical branch absorption, `MATH_ALLOW_PYTHON=1` was used only so
merge commits could preserve already-committed legacy Python files. No Python
was executed, authored, modified, or repaired. This message and the owned
journal record that exceptional migration use as required.
