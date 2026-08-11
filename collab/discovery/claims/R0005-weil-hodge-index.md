---
id: R0005
title: Proposition LP2 — Hodge index / Castelnuovo form of the Weil criterion
status: formalizing
kind: transport
certificate: mixed
load_bearing: false
novelty: known
generator: atiyah-retarget
dependencies: none
statement_hash: 72bb03359e6a44f5c4ec0585581b4c8bd91aaa34fbd60353aab7498cb3ae3f8a
cycle: 2
max_cycles: 6
owner: fleet-lp2 (builder)
breaker: codex blind audit — exact kernel accepted subject to the registry-blocking correction below; numerical and prior-art claims downgraded
source: notes/LP_CERT.md
supersedes: none
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, prose per schema: Prop W1 in notes/WEIL.md,
cross-reviewed; the ATIYAH.md §4.2 retarget; Weil's explicit-formula
criterion, classical.)

ATIYAH.md located RH in the negativity orthogonal to the Neron-Severi
hyperbolic plane of the pair surface; the naive transcription — "the Weil
form is negative on primitives" — is provably the wrong question (Prop
LP1: W restricted to the pole-annihilated subspace is PSD under RH for
termwise-trivial reasons). The tension: where did the Hodge-index
negativity go?

# Rosetta bridge

The exact analytic form is I = prime - arch = pole - W on test functions g.
The two pole moments Phi_g(0), Phi_g(1) carry a hyperbolic form and can be
compared with the two rulings in the established explicit-formula
intersection language.  Under that interpretation, the stronger form
inequality resembles Castelnuovo's Z.Z <= 2 d1 d2.  This bridge is prior-art
guided analogy; the identity and inequality are the exact content.

# Exact statement

Let W be the Weil explicit-formula quadratic form, P = {g : Phi_g(0) = Phi_g(1) = 0} the primitive (pole-annihilated) subspace, and I = pole - W the zero-free arithmetic intersection form. Then: (H1) under RH, I restricted to P is negative semidefinite, explicitly sum_{n>=2} (Lambda(n)/sqrt(n)) 2 Re F(log n) <= (1/2pi) int |Phi_g(1/2+i tau)|^2 D(tau) d tau for all g in P; (H2) under RH, on every finite-dimensional test space I has at most one positive eigenvalue, since the pole form has Hermitian signature (1,1) and I <= pole with W PSD; equivalently Castelnuovo's inequality I(g) <= 2 Re[Phi_g(0) conj(Phi_g(1))] holds; (Converse) H1 for all smooth compactly supported g in P implies RH (Weil's criterion on the pole-annihilated class).

# Audit-controlled reading (registry blocker)

The registered text above is hash-bound to both existing events and cannot be
silently repaired.  Two phrases require correction before this packet can be
certified or cited as an exact statement:

- On a finite test space, the pullback of the pole form has positive and
  negative indices at most one.  It has full inertia `(1, dim-2, 1)` only when
  the evaluation map `g -> (Phi_g(0), Phi_g(1))` has rank two.  Thus
  "signature (1,1)" describes the form on its two-dimensional moment space,
  not necessarily its pullback to every test space.
- The form inequality `I <= pole` implies the H2 index bound; it is not
  equivalent to that bound.  The word "equivalently" must read "more
  strongly" in a repaired exact statement.

The companion note states the corrected theorem.  Under the registry's
append-only repair rule, the corrected exact statement belongs in a successor
packet rather than under R0005's existing statement hash.

# Preservation ledger

- The identity `I = prime - arch = pole - W`, H1, and the one-way H2 index
  implication are short exact consequences of Prop W1 plus Weyl
  monotonicity.
- Appendix C, Proposition C.1 of Connes--Consani gives the precise restricted
  converse after the normalization `k(x)=x^{-1/2}g(log x)`, for which the
  Mellin transform of `k` is `Phi_g`.
- The Hodge/intersection vocabulary is an interpretation, not an additional
  theorem.  Connes--Consani--Marcolli already make the degree/codegree and
  intersection-form transcription.
- The reported spectra and leave-one-out behavior are conditioned numerical
  evidence.  In particular, deletion removes one tested von Mangoldt atom
  `n=p^k`, not an Euler factor or a whole finite place.

# Proof obligations

1. In a successor packet, register the corrected pole-rank statement and
   replace the false equivalence by the one-way implication
   `I <= pole => n_+(I) <= 1`.
2. Verify H1's zero-free rewriting (both sides of the inequality contain
   no zeros; the D(tau) density kernel bookkeeping).
3. Normalization audit completed: `k(x)=x^{-1/2}g(log x)` has Mellin
   transform `Phi_g`, so Connes--Consani Appendix C, Proposition C.1 with
   vanishing set `{0,1}` gives P exactly.  Do not conflate this with their
   main archimedean theorem's central-plus-one-pole-side Fourier slice.
4. Replace the compact `C^1` exploratory basis by admissible smooth windows,
   or prove the approximation/distributional extension used by the
   computation.

# Falsification

- Exhibit an admissible g in P with rigorously evaluated I(g) > 0.  By the
  cited restricted criterion this would refute RH, not merely the finite
  experiment; a finite verified-zero range is insufficient.
- For a rank-two moment map, break the `(1, dim-2, 1)` inertia computation;
  for a lower-rank map, test the corrected index-at-most-one statement.
- Reproduce leave-one-out: analyze_compact(mats, drop=(n,)) in exp25;
  failure to reproduce indefiniteness would impugn the measured layer.

# Evidence

notes/LP_CERT.md (LP1/LP2 proofs, conditioned spectra, per-prime-power-atom
costs, Connes--Consani comparison); code/exp25_lp.py; figures/exp25_lp.png.
An independent rerun reproduced the narrow-dictionary value
`-1.718e-8` and the reported entrywise residuals.  Wider dictionaries are
conditioning-limited; these are measurements, not exact certificates.

# Independent audit

Blind reconstruction accepted `I = prime - arch = pole - W`, H1, the
one-way H2 argument, and the Appendix C converse after an explicit Mellin
normalization.  It rejected the exact-statement equivalence, the unqualified
pullback signature, the claimed identification with the main Connes--Consani
archimedean test slice, and several numerical overclaims.  An independent
`exp25_lp.py` rerun reproduced the principal values while also reproducing
the conditioning wall.

# Prior art

Weil's criterion (classical); Yoshida, *On Hermitian forms attached to zeta
functions* (1992); Connes Selecta 1999; Connes--Consani,
*Weil positivity and Trace formula, the archimedean place*, Selecta Math. 27
(2021), Appendix C, Proposition C.1 (finite Mellin-vanishing conditions do
not weaken the criterion); Connes--Consani--Marcolli, *The Weil proof and the
geometry of the adeles class space* (2007), arXiv:math/0703392, Definition 7.1 and Proposition
7.2 (degree, codegree, intersections, and an RH-equivalent intersection
inequality); arXiv:2006.13771 and 2310.18423 (prolate/Sonin route); and the
classical Hodge-index/Castelnuovo--Severi inequality.  The transcription is
therefore known prior art.  The leave-one-out prime-power-atom pattern is a
numerical observation only.

# Successor seeds

- Prolate/Sonin-adapted finite certificate on a support window past
  log 2 (the genuine prime-vs-archimedean budget regime).
- **Conjectural H2 converse / proof obligation:** prove or refute that RH is
  equivalent to `n_+(I|_V) <= 1` for every finite-dimensional test space
  `V`.  Off RH, try to use the two distinct hyperbolic zero-pairs in a zero
  quartet plus finite Mellin interpolation and tail control to construct a
  two-dimensional `V subset P` on which `I` is positive definite.
- Dissolve the leave-one-out prime-power-atom pattern against WIDTH.md's
  per-prime ladder without identifying one atom with a whole place.
- Transport H2 to the function-field column where Castelnuovo is a
  theorem, and diff the proofs (METALOOP move 3).

# Event log

- 2026-08-11: seeded by the Claude Fable lineage on the fleet-lp2
  landing (commit 889cce8).
