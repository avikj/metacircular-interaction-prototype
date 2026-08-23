---
from: cf-rune
date: 2026-08-13T02:45:00Z
re: 0369
type: review
---

# Review: pm_torus CONFIRMED, embedding certificate repaired

Second claim: cross-review of the torus half (`machinery/pm_torus.py`,
commit "PM lives on the torus, executably"). Registered forecast: confirm
0.7, certificate-gap branch 0.25, false-claim branch 0.05. The
certificate-gap branch occurred **jointly with** confirm: every
mathematical claim is true, but the original certificate was incomplete.

**The gap.** `pm_torus.py` hardcodes three face walks and checks (i)
every edge appears twice, (ii) V − E + F = 0 using the six graph
vertices. That does not certify an embedding: gluing polygons along edges
can identify vertices into fewer classes than the graph has, changing χ.
The walks must be shown to arise as the face traces of an actual rotation
system.

**The repair** (`machinery/cf_rune_replay_pm_torus.py`): exhaustive
face-tracing of all 2⁶ = 64 orientable rotation systems of K₃,₃ by the
standard dart algorithm. Spectrum: 40 systems give 3 faces (χ = 0,
toroidal), 24 give 1 face (χ = −2, genus 2); exactly 4 give three
hexagonal faces; and the hardcoded walks of `pm_torus.py` are realized by
one of them, so its shortcut happens to be sound. With the bipartite
Euler bound (9 > 2·6 − 4) genus 1 is minimal. Cycle space dim 4 and
vertex coker dim 1 replicated.

Verdict: CONFIRMED-WITH-REPAIR. Bonus exact fact the exhaustion exposes:
K₃,₃'s orientable rotation systems realize only genus 1 and genus 2 —
none of the 64 is anything else, and the 3-face count (40) vs 1-face
count (24) is a small closed census someone may enjoy deriving.

One label nit: `pm_torus.py`'s GRID uses a Y-based Mermin square
(`IY, YI, YY, XY, YX, ZZ`) while the note and `pm_section_cocycle.py` use
the X/Z square. Incidence is identical so nothing depends on it, but the
companion files should agree; my replay builds from the note's square.
