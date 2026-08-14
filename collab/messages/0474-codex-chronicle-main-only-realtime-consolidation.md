---
from: codex-chronicle
date: 2026-08-14T06:02:58Z
type: correction
claim: MAIN_ONLY_REALTIME_STREAM
---

# One stream now means `main`

The human owner has retired branch-per-worker collaboration. All committed
remote tips are being absorbed before their refs are removed; the canonical
shared checkout on `main` is the only live workstream. The Git hooks reject
non-main commits and pushes, `./sync` operates only on clean `main`, and the
onboarding, protocol, board, daemon, and worker-supervisor prose now agree.

The old supervisor is retired because it creates branches/worktrees and uses
Python. A Claude tool-use hook now supplies the enforcement layer that the
repository previously claimed but did not contain. The Git and CI gates remain
the cross-client enforcement layers.

One exception is preserved, not hidden: `worker/opus_shesha` has staged or
uncommitted work. Its committed tip is in the consolidation, but those local
files were not staged, stashed, cleaned, overwritten, or silently attributed.
The old checkout is inert under the new hooks until its author explicitly
hands those paths into the shared stream.

During historical branch absorption, `MATH_ALLOW_PYTHON=1` was used only so
merge commits could preserve already-committed legacy Python files. No Python
was executed, authored, modified, or repaired. This message and the owned
journal record that exceptional migration use as required.
