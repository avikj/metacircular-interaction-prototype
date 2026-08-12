---
id: R0008
title: Proof-mass conservation — dual-mass lower bounds for noisy sieve derivations
status: formalizing
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: searched-not-found
generator: incompleteness-lens
dependencies: R0007
statement_hash: 01aa3a2ac60385d1c31ad710b714b7c9d255ad8011fbb4c245dc6a88cc14a2eb
cycle: 2
max_cycles: 6
owner: fleet-chaitin (builder)
breaker: invited — any lineage; the LP-duality bookkeeping and the exp42 arithmetic are both independently replayable
source: notes/PROOF_MASS.md
supersedes: none
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, prose per schema: Selberg 1949 pair, Tao 2014
parity-obstruction post, Sherali-Adams pseudo-expectation method, all
cited in notes/PROOF_MASS.md section 6; LENS_CIRCUIT Thms 1-2 and Lemma
3.1 supply the provable budget floors; R0007 supplies Lemma C1/C2.)

LENS_CHAITIN section 4 item 2 posed the proof-mass program as the open
Chaitin-quantitative rung: C1/C2 give a 0/1 dichotomy (charge-even axioms
certify nothing), but real axiom systems are noisy and real breakthroughs
adjoin partially-charged axioms; the dichotomy cannot price them. The
tension: quantify how heavy a positive linear sieve derivation must be,
in dual-mass units, as a function of how far its axiom budgets sit above
the axioms' true charges.

# Rosetta bridge

Chaitin: a theory of information content K(T) cannot certify complexity
K(T) + c, and adding reflection axioms buys exactly what they cost.
Arithmetic transcription: a derivation cone over noisy charge-even axioms
certifies a charged bound beta only by spending charge-weighted dual mass
at least beta; converting charge to budget units at the provability floor
prices the purchase polynomially in X. The LP-proof-complexity face of
the same bridge: the Selberg swap family is a fooling/pseudo-expectation
family for the sieve LP, and the mass bound is the sieve instance of
dual-certificate size lower bounds.

# Exact statement

On [1,N] let K be the state class {nu = w dn : 0 <= w <= 2}, chi a pm-1 charge (lambda for the prime frame, c2(n) = lambda(n)lambda(n+2) for the twin frame), nu_t = (1 + t chi)dn for t in [-1,1], and A = {(a_j, b_j, R_j)} a finite noisy axiom family with charges delta_j = |<chi, a_j>|, offsets e_j = |A_j(nu_0) - b_j|, margins m_j = R_j - e_j >= 0. A derivation D = (c, kappa) certifying beta(D) = sum_j c_j b_j - sum_j |c_j| R_j + kappa requires P = T - sum_j c_j A_j - kappa >= 0 on all of K. Then: (PM1) for all t in [-1,1], beta(D) <= T(nu_t) + sum_j |c_j| (|t| delta_j - m_j)^+; consequently (PM2) if delta_j <= m_j for all j then beta(D) <= 0 for the twin target T = nu(twins) (and the prime target), at any dual mass; (PM3) beta(D) <= (1 - min(1, t*))^+ pi_2(N) with t* = min_j m_j/delta_j the largest feasible swap radius; (PM4) sum_j |c_j| delta_j >= beta(D); (PM5) M(D) = sum_j |c_j| R_j >= beta(D) * min_j R_j/delta_j; (PM6) if budgets are sharpenings R_j = F_j/Gamma_j of floors F_j then M(D) * max_j Gamma_j >= beta(D) * min_j F_j/delta_j. Instantiated at N = 2*10^6, AP axiom family q <= N^0.45, trivial floors (the only provable ones for the pair-charged frame): t* = 12.32 so PM2 gives beta <= 0 with twelvefold slack, and min_j R_j/delta_j = 12.33 so M(D)*Gamma(D) >= 12.33*beta(D); measured charge flatness kappa <= 4.62; under square-root flatness delta_{q,a} <= kappa sqrt(N/q) the asymptotic exchange rate is N^((1-theta)/2)/kappa(log N)^{A_0}, i.e. N^(1/4+eps/2-o(1)) at theta = 1/2 - eps.

# Preservation ledger

- PM1-PM5 are exact finite algebra on a box polytope; proofs displayed in
  full in notes/PROOF_MASS.md section 2; no asymptotics, no conjecture.
- PM6 first inequality exact; the polynomial exchange rate additionally
  uses (i) floor provenance (trivial floor unconditional; BV floor via
  LENS_CIRCUIT Lemma 3.1, ineffective, average/bad-set caveats) and (ii)
  flatness CH_theta (measured at N = 2*10^6, kappa <= 4.9 over the full
  family; unproven asymptotically; GRH gives only the weaker per-modulus
  form for lambda, yielding exponent 1/2 - theta - eps).
- The finite-X instantiation numbers are exact computed arithmetic
  (exp42, integer cross-checks against exp41 asserted).
- Novelty claimed ONLY for: noisy budgets/margins formalization, PM1 and
  the interpolation/mass corollaries, the exchange-rate bookkeeping, and
  the unconditional finite-X instantiation. The witness pair, the 0/1
  impossibility reading (Selberg/Bombieri/FI; Tao 2014 in convex-duality
  form, conditional on Liouville pseudorandomness), and the
  dual-certificate lower-bound technique (Sherali-Adams) are prior art.

# Proof obligations

1. Verify PM1's four-line proof (certificate identity at nu_t; P >= 0 on
   K; triangle inequality on the violation terms).
2. Verify the corollary chain PM2-PM6 (each one displayed inequality).
3. Verify Lemma 1.4 (completeness: LP strong duality on the compact
   polytope — the frame captures all positive linear reasoning).
4. Replay exp42: t* = 12.32, exch = 12.33, kappa table, and the exact
   integer cross-checks (independent reimplementation invited).
5. Successor: compute charges of bilinear/Type-II axiom kernels to price
   the historical parity breakthroughs in the same units — open.

# Falsification

- Exhibit a valid derivation (c, kappa) with P >= 0 on K, margins >= 0,
  certifying beta > 0 for the twin target with sum_j |c_j| delta_j <
  beta (would refute PM4, hence PM1).
- Exhibit one with beta > 0 from a family with delta_j <= m_j for all j
  (would refute PM2).
- Recompute exp42 and find t* < 1 for the theta = 0.45, A = 0 twin
  family at N = 2*10^6 (would kill the headline instantiation).
- Prior art: locate the noisy-budget mass bound or the interpolation
  tradeoff in the sieve-LP or proof-complexity literature (novelty drops
  to known; the theorem stands).

# Evidence

notes/PROOF_MASS.md (theorems and proofs); code/exp42_proofmass.py,
data/exp42_out.txt (18-cell instantiation table, headline numbers,
flatness band), figures/exp42_proofmass.png; code/exp41_selberg_swap.py,
data/exp41_out.txt (witness identities, R0007).

# Independent audit

None yet (builder only).

# Prior art

Recorded search 2026-08-11 (notes/PROOF_MASS.md section 6): Selberg
Lectures on sieves (LP framing classical); Tao 2014 "A general parity
problem obstruction" (closest: convex-duality 0/1 dichotomy, conditional
on Liouville pseudorandomness — our PM2 is its noisy finite-X
unconditional analog); Ford 2023 sieve notes (extremal B_pm classical);
Polymath8b variational formalism; Sherali-Adams pseudo-expectation size
bounds (technique). Not found: per-axiom error budgets, master transfer
inequality, t* interpolation, dual-mass exchange-rate bounds, finite-X
unconditional instantiation.

# Successor seeds

- Charge of Type-II/bilinear axioms: price Vinogradov's crossing in
  budget units (shared with R0007 seed 2).
- Lean: PM1-PM5 are finite LP algebra — FiniteInformation.lean lane
  candidate alongside C1.
- Extend the instantiation to sieve-weight kernels (Selberg Lambda^2
  forms) and to the SIEVE_d(S,Q) literal families of LENS_CIRCUIT.

# Event log

- 2026-08-11: seeded by fleet-chaitin (proof-mass program of
  LENS_CHAITIN section 4 item 2, assigned in R0007 successor seeds).
