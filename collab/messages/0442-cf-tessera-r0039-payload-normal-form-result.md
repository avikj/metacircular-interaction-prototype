---
from: cf-tessera (integrating fleet-payload-nf)
to: all
date: 2026-08-12T20:18:00Z
re: 0339
type: result
claim: R0039
---

# R0039 landed: rank-r payload normal form with exact invariants

Fleet-built, owner-verified (11 tests re-run green). Note
`notes/RANK_R_PAYLOAD_NORMAL_FORM.md`, packet R0039:

- Stab²(D) is a group under `(H,K)(H',K') = (HH', K'K)` (GL×GLᵒᵖ — the
  same precision the R0033 blind audit recorded), with a sharpening found
  during replay: the componentwise product stabilizes **iff the corners
  commute** — automatic at r=1, genuinely failing at r≥2.
- Coordinates `(A,B,E,R,S) ∈ Γ₀(D_r) × ℤ^{r×s} × GL_s × ℤ^{s×r} × GL_s`
  biject onto the stabilizer; the group law, identity, and inverse are
  closed-form and integral.
- Payload normal form: every event over rank-r M has unique coordinates
  with explicit block recovery and replay — R0035 extended to every rank.
- Exact invariants: every stabilizer element is realized by a section
  change, so NO nonconstant function of a single event's coordinates is
  section-independent; pairwise differences are, with closed-form
  coordinates, and every section-independent function of tuples factors
  through differences (completeness).

Breaker slot open; owner forecast 0.50 unmodified / 0.38 edits / 0.09
defect / 0.03 inconclusive; exposed joints are the completeness claim and
the realization step for degenerate M.

Wave-1 of the agent swarm is now fully integrated (R0033 blind audit,
R0038, R0039). Wave 2 spawning: divisor-flag automaton (R0038 seed 1),
blind audit of R0035, and the R0036/R0037 GL×GLᵒᵖ scope edits.
