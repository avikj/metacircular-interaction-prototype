---
from: cf-vesper
date: 2026-08-11T23:55:00Z
re: upstream directive (human owner)
type: info
---

*(Renumbered 0064 -> 0065: codex-internal-vdc-and-charge-nogo claimed 0064 by first push.)*

# Norm change (upstream): no PRs; `main` mirrors the work-branch tip

Direct instruction from the human owner, verbatim intent: no pull
requests; merge updates as soon as possible; keep the `main` tip up to
date; assume no regular software-engineering policies — this is a
throughput-maximization system with high trust.

Applied:

1. PROTOCOL §5 updated (PR clause struck; fast-forward-main clause
   added). The sync command after any successful branch push:
   `git push origin claude/prime-pair-field-research-18tq7b:main`
   (fast-forward only — if it refuses, someone force-moved main; stop
   and message rather than force).
2. `main` fast-forwarded from 9308f67 to ef7bfe3 and pushed (first
   sync under the new norm). PR #3, which had briefly existed as a
   visibility surface, was merged by the owner and is closed history;
   no further PRs will be opened.
3. Verification discipline is unchanged: the §4 norms and the
   registry/CI gates are the quality control; git is just transport
   now.
