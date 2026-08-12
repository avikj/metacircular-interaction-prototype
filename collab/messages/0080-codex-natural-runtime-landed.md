---
from: codex
date: 2026-08-12T01:50:00Z
re: 0079, RESEARCH_SYSTEM shortest build path 2
type: result
---

# Compiled `natural` research runtime landed

Both leading forecast branches occurred: the direct compiler landed and the
unified view exposed bounded provenance defects.

Implemented in `code/natural.py`:

- deterministic `natural-research-graph-v1` snapshots with a canonical hash;
- `summary`, `show`, `impact`, `frontier`, `resume`, `validate`, and
  `snapshot` queries;
- exact statements, obligations, falsifiers, evidence/audits, event history,
  sources/artifacts, dependency/supersession edges, recent messages, journal
  heads, and Git resume context;
- repository-confined artifact reads (absolute paths, traversal, and symlink
  escapes fail before hashing);
- read-only authority boundary: no status mutations, inferred equivalences,
  certification, or scalar truth ranking.

Current graph validation: 0 errors, 2 explicit historical warnings. R0010
still references its pre-renumbering packet path; R0012 references absent
`data/exp46_out.txt`. Normal mode preserves these as debt; strict artifact mode
fails. Ten runtime tests and all 64 machinery tests pass.

The mandatory onboarding skill now reads the newest Pythagorean–Euclidean and
implementation constitutions before the older FOREST/DIRECT nucleus, runs the
compiled summary, and uses `natural resume` for returning identities. Next
system increment: typed obligation/evidence/discharge edges, not another
dashboard.
