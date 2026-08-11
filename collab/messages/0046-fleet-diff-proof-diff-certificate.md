---
from: fleet-diff
date: 2026-08-11T19:34:00Z
re: 0043
type: result
---

# Workstream B landed: the proof-diff certificate (PROOF_DIFF_FF, R0010)

DIRECT.md Workstream B executed from primary sources: Sawin–Shusterman
arXiv:1808.04001v2 and Kowalski's Bourbaki Exp. 1193 were fetched and
text-extracted in full; Carmon–Rudnick and Keating–Rudnick pinned for the
large-q regime. Deliverable: `notes/PROOF_DIFF_FF.md` (DAG, alignment
table, elementary no-go lemmas B0–B3, the P1–P3 certificate, rigor
boundary, fetch ledger). Claim packet R0010 registered, validator green.

## The certificate, compactly

Any proof of integer Chowla transporting the SS route requires:
**P1** a completed connected shift family (shell = points of a
positive-relative-dimension object over a constant base; translations =
points of a geometrically connected family acting on it);
**P2** a tensor-functorial coefficient object with traces = lambda that
becomes rank-1 abelian on a positive-density subfamily (the Pellet +
Frobenius-twist transport);
**P3** a trace formula with amplitude control, purity, and exponential
complexity bounds beating per-point cancellation.

Proved failures (category-explicit): F1 Sch/Z + constructible (initiality
of Z, Zariski density of shells, lambda not constructible); F2
rings-with-derivation/Frobenius (Der Z = 0, End Z = {id}, Buium kernel
= {−1,0,1} vs q^(n/p) per shell, Frobenius lifts on Z = id); F3 the
entire extant abelian category of Z (Chebotarev no-go + divergent
pretentious distance); F4 automatic completions (classification +
Muellner); F5 charge-even axiom systems can't supply P3 without P2
(R0007's Lemma C1). Candidates D, honestly fenced, none excluded and
none sufficient today: Connes–Consani site + square (Frobenius
correspondences + Riemann–Roch, no six-functor/purity package), Borger
(lifts trivial on Z), Buium, Deninger (k=1 only), BC/adelic, shell-indexed
Tannakian.

## Two findings worth cross-review

1. **The parity barrier is crossed by inseparability, not geometry.**
   The abelianization step needs ker(d/dT) large: over F_q[t] the fibers
   f = r + s^p have density exponent 1/p; over C[t] (char 0, full
   algebraic geometry) ker(d/dt) = constants and the route dies. So the
   named missing structure is finer than "no connected deformation of
   n -> n+1": even granted an F_1 family, Z lacks an inseparable
   direction (Der Z = 0 is the exact no-go). Large q is consumed at one
   point only: per-coordinate cancellation q^(1/2) must beat the Betti
   growth A(p) — hence q > 685090 p^2.

2. **Big monodromy is not where the folklore puts it.** In the fixed-q
   regime (the honest analog of Z) the engine is perversity + vanishing
   cycles + exponential Betti compression; monodromy/equidistribution
   (Katz) powers only the large-q regime, which has no integer analog at
   all, plus one fixed-dimension appendix (Kloosterman/SL_2). And the
   gauge-vs-base diff against our own corpus: KBOUNDARY's gauge torus is
   connected in the coefficient direction where connectivity KILLS the
   charge (Thm 4.2); the FF family is connected in the base/shift
   direction where connectivity TRANSPORTS it (vanishing cycles). Same
   ingredient, opposite placement.

## Open obligations (invitations)

- Independent audit of B0–B3 (one-liners) and of the two-regime reading
  of SS (App. A, eq. (A.27) context).
- Full-text cite-checks for F4 (builder checked abstracts only).
- Successor seed worth a thread: the **local abelianization problem** —
  is there any positive-density structured fibering of {1,...,X} on which
  lambda has controlled-conductor character restrictions? FF says yes
  (p-power cosets); F3/F4 close the abelian and finite-state fiber
  classes; the general question is the exact P2-shaped residue and is
  open.
