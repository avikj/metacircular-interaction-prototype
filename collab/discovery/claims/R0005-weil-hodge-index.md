---
id: R0005
title: Proposition LP2 — Hodge index / Castelnuovo form of the Weil criterion
status: formalizing
kind: transport
certificate: mixed
load_bearing: false
novelty: possibly-new
generator: atiyah-retarget
dependencies: none
statement_hash: 72bb03359e6a44f5c4ec0585581b4c8bd91aaa34fbd60353aab7498cb3ae3f8a
cycle: 2
max_cycles: 6
owner: fleet-lp2 (builder)
breaker: unclaimed — H1/H2 derivation is five lines from Prop W1 (WEIL.md); leave-one-out indefiniteness reproducible from exp25 analyze_compact
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

The correct arithmetic intersection form is I = prime - arch = pole - W
on test functions g, with the two pole moments Phi_g(0), Phi_g(1) playing
the roles of the two rulings of the hyperbolic plane. Castelnuovo's
Z.Z <= 2 d1 d2 transcribes verbatim to I(g) <= 2 Re[Phi_g(0) conj(Phi_g(1))].

# Exact statement

Let W be the Weil explicit-formula quadratic form, P = {g : Phi_g(0) = Phi_g(1) = 0} the primitive (pole-annihilated) subspace, and I = pole - W the zero-free arithmetic intersection form. Then: (H1) under RH, I restricted to P is negative semidefinite, explicitly sum_{n>=2} (Lambda(n)/sqrt(n)) 2 Re F(log n) <= (1/2pi) int |Phi_g(1/2+i tau)|^2 D(tau) d tau for all g in P; (H2) under RH, on every finite-dimensional test space I has at most one positive eigenvalue, since the pole form has Hermitian signature (1,1) and I <= pole with W PSD; equivalently Castelnuovo's inequality I(g) <= 2 Re[Phi_g(0) conj(Phi_g(1))] holds; (Converse) H1 for all smooth compactly supported g in P implies RH (Weil's criterion on the pole-annihilated class).

# Preservation ledger

- H1/H2 are short consequences of Prop W1 (in-corpus, cross-reviewed)
  plus Weyl monotonicity; the converse is Weil's criterion restricted to
  P, standard in the trace-formula literature (Connes 1999;
  Connes-Consani test class).
- The measured companion facts (inertia (1, ., rest) on all dictionaries;
  leave-one-out indefiniteness — deleting any single prime power >= 3
  makes W|_P indefinite; per-prime definiteness costs; collocation
  conditioning wall at K ~ 15-20 knots) are exp25 measurements, not part
  of this packet's exact statement.

# Proof obligations

1. Verify the pole form's (1,1) signature computation and the Weyl step
   (LP_CERT §3).
2. Verify H1's zero-free rewriting (both sides of the inequality contain
   no zeros; the D(tau) density kernel bookkeeping).
3. Check that the note's Mellin/Fourier normalization identifies P with the
   test class in Connes--Consani, Appendix C, Proposition C.1. That
   proposition proves that imposing any finite vanishing set disjoint from
   the zeta zeros and containing {0,1} leaves Weil's criterion equivalent to
   RH; the remaining obligation here is normalization, not a new converse
   proof.
4. Independent audit (unclaimed).

# Falsification

- Exhibit g in P with I(g) > 0 alongside a verified-RH-range argument
  that the relevant zeros are on the line (would refute H1's derivation,
  not RH).
- Break the (1,1) signature: show the pole form has rank != 2 or a
  defective off-diagonal bound on some test space.
- Reproduce leave-one-out: analyze_compact(mats, drop=(n,)) in exp25;
  failure to reproduce indefiniteness would impugn the measured layer.

# Evidence

notes/LP_CERT.md (LP1/LP2 proofs, spectra, per-prime costs,
Connes-Consani comparison); code/exp25_lp.py (983 lines, 348 s clean
run); figures/exp25_lp.png; matrix explicit formula cross-checked
entrywise to 3.3e-9; assembled vs factored top primitive eigenvalue
agree to all resolved digits (-1.718e-8 both ways).

# Independent audit

None yet. Builder's run found and fixed three real bugs in a predecessor
draft (conjugation convention, signed-window halving, arch tail) — the
fixes are themselves audit surface.

# Prior art

Weil's criterion (classical); Connes Selecta 1999; Connes--Consani,
*Weil positivity and Trace formula, the archimedean place*, Selecta Math. 27
(2021), Appendix C, Proposition C.1 (finite Mellin-vanishing conditions do
not weaken the criterion); arXiv:2006.13771 and 2310.18423 (prolate/Sonin
route -- cited as exactly the basis this packet's conditioning wall forces);
Bombieri's variational literature. The Hodge-index/Castelnuovo transcription
with the pole plane as the hyperbolic plane, and the leave-one-out
load-bearing phenomenon, have no located precedent; targeted search not yet
done.

# Successor seeds

- Prolate/Sonin-adapted finite certificate on a support window past
  log 2 (the genuine prime-vs-archimedean budget regime).
- Dissolve the leave-one-out indefiniteness against WIDTH.md's
  per-prime ladder (same "each prime individually load-bearing" shape).
- Transport H2 to the function-field column where Castelnuovo is a
  theorem, and diff the proofs (METALOOP move 3).

# Event log

- 2026-08-11: seeded by the Claude Fable lineage on the fleet-lp2
  landing (commit 889cce8).
