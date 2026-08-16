---
from: cf-corner (Claude Fable 5)
to: all; owner
date: 2026-08-14
re: sixteen-lens fleet launch — death by shared session limit, three salvages
type: incident record + result
---

# Sixteen-lens fleet: launched, died on the shared account limit, three artifacts salvaged

Per the owner's direction, sixteen subagents with distinct method lenses
(Erdős, Gauss, Noether, Ramanujan, Selberg, Kolmogorov, Weil, Hilbert,
Littlewood, Turán, Gelfand, Dirichlet, Euler, Sylvester, Hopper, Poincaré)
were launched in parallel on tasks drawn from the live queue (Factory IV
program, W4b, the e_b(q) merge, the aggregate green map, ATLAS §5.5's
spectral-flow setup).

**All sixteen terminated early on the shared account session limit** (resets
20:30 UTC). This is the same failure mode as the first recorded swarm launch
(`collab/orchestration/draws/README.md`: "All 16 agents terminated early on a
shared account-level API budget… Recorded because the alternative would make
the swarm look cheaper than it is"). Recorded again for the same reason.

**Salvaged — three agents finished their artifact before dying:**

1. `formal/cubical/NaturalMachine/CornerProjectors.agda` (cf-swarm-noether) —
   Factory IV §XI at the type level: pointwise filters commute
   (`filter-and`/`filters-commute`, then the radius/charge instance), and the
   marginal-to-joint gap CONSTRUCTED (`marginal-to-joint-gap`: a two-witness
   world with both marginals nonempty and the joint corner empty, in both
   filter orders). **Integrator-checked in this container: exit 0**
   (Agda 2.6.3 + cubical v0.5), since the author died before reporting.
2. `notes/ANTI_SATURATION_MISSING_STRUCTURE_CERTIFICATE.md`
   (cf-swarm-selberg) — the DIRECT Workstream B certificate for the
   anti-saturation estimate on the truncated Chen set; includes a new proved
   lemma (§3.D) and closures/gaps classification; prior art flagged
   UNVERIFIED throughout.
3. `notes/MARGINAL_TO_JOINT_CORNER.md` (cf-swarm-kolmogorov) — the corner as
   finite measure theory: the constraint polytope on {1..R}×{1,2}, its
   vertices, and the one scalar that decides; complete hand-checkable proofs.

The other thirteen artifacts did not land. Relaunch armed for after the
limit reset; the thirteen lens briefs are reproducible from this session's
transcript and will be re-issued verbatim.

Integrator note: the three salvaged files are committed with their dead
authors' signatures intact; the only integrator addition is the Agda check
of (1), performed and recorded here because a green is an exit code and the
author could not run it to completion.
