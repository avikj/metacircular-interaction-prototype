---
id: R0013
title: Proof-mass conservation — dual-mass lower bounds for noisy sieve derivations
status: proving
kind: obstruction
certificate: exact-finite
load_bearing: false
novelty: known
generator: incompleteness-lens
dependencies: none
statement_hash: e969490c57f93ae358abc2af1783253126e5245b33863da39999cf19d6ff0814
cycle: 4
max_cycles: 6
owner: Codex octic-frontier (repair builder)
breaker: Codex octic-frontier + independent Dalton lineage — conditional accept for the narrow finite LP algebra; broader packaging rejected. Cross-lineage re-audit fleet-breaker (Claude Fable, 2026-08-11): PM1-PM6 verified, exp42 replayed exactly, CONFIRMED (msg 0069)
source: notes/PROOF_MASS.md
supersedes: R0008
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, prose per schema: Selberg 1949 pair, Tao 2014
parity-obstruction post, Sherali-Adams pseudo-expectation method, all
cited in notes/PROOF_MASS.md section 6; LENS_CIRCUIT Thms 1-2 and Lemma
3.1 supply the provable budget floors; R0007 supplies Lemma C1/C2.)

LENS_CHAITIN section 4 item 2 posed a quantitative question: what does the
Selberg swap witness imply when a *specified finite affine LP* uses noisy
slab axioms rather than exact equalities? This packet answers that restricted
question. It does not quantify arbitrary sieve proofs, Type-II arguments, or
general proof complexity.

# Rosetta bridge

The exact bridge is robust LP duality: the Selberg swap path is a finite
fooling-state family, and evaluating a dual certificate along that path
bounds what the fixed box-and-slab affine cone can certify. Any Chaitin or
"reflection axiom" reading is interpretive and is not part of the theorem.

# Exact statement

On $[1,N]$ let $K=\{w\,dn:0\le w\le2\}$, let
$\chi:[1,N]\to\{\pm1\}$, and put $\nu_t=(1+t\chi)dn$ for
$t\in[-1,1]$. For a finite slab family $(a_j,b_j,R_j)$ define
$\delta_j=|\langle\chi,a_j\rangle|$,
$e_j=|A_j(\nu_0)-b_j|$, and margins $m_j=R_j-e_j\ge0$. A derivation
$D=(c,\kappa)$ is restricted to the finite box-and-slab LP cone:
$P=T-\sum_jc_jA_j-\kappa\ge0$ on all of $K$, with
$\beta(D)=\sum_jc_jb_j-\sum_j|c_j|R_j+\kappa$. Then PM1 gives
$$\beta(D)\le T(\nu_t)+\sum_j|c_j|(|t|\delta_j-m_j)^+.$$
PM2 follows when $\delta_j\le m_j$. For PM3, set
$t^*=\min_{\delta_j>0}m_j/\delta_j$, with $t^*=+\infty$ if all charges
vanish; this is the largest **symmetric** radius for which every
$\nu_t$, $|t|\le t^*$, is feasible. PM4 gives
$\sum_j|c_j|\delta_j\ge\beta(D)$. For $\beta(D)>0$, let
$J_c^+=\{j\in\operatorname{supp}(c):\delta_j>0\}$; then PM5 gives
$$M(D)=\sum_j|c_j|R_j\ge\beta(D)\min_{j\in J_c^+}R_j/\delta_j.$$
If $R_j=F_j/\Gamma_j$ for explicitly chosen certified baselines $F_j$,
PM6 gives
$$M(D)\max_{j\in\operatorname{supp}(c)}\Gamma_j
\ge\beta(D)\min_{j\in J_c^+}F_j/\delta_j.$$
Its $N^{(1-\theta)/2}$ specialization is conditional on CH$_\theta$ and
the stated baseline lower bound. Exp42 numerically evaluates one AP family
at $N=2\cdot10^6$: exact integer target/swap checks, but float64 budgets,
ratios, minima, and $\kappa$. With $q\le\lfloor N^{0.45}\rfloor=684$ and
the selected centered budget $R_q=N/q$, it finds $t^*=12.32$ and exchange
ratio $12.33$; this is a finite diagnostic, not an exact arithmetic
certificate or an unrestricted sieve-proof lower bound.

# Preservation ledger

- PM1-PM5 are exact finite algebra for the explicitly defined box-and-slab
  affine LP cone, subject to the stated nonnegative-margin and zero-charge
  conventions. They say nothing about proofs outside that cone.
- PM6's first inequality is exact under the same hypotheses. Its polynomial
  specialization additionally assumes a certified baseline and
  CH$_\theta$; for $c_2$, CH$_\theta$ is unproved. A positive-proportion
  $N^{5/4+o(1)}$ reading would separately assume
  $\pi_2(N)=N^{1-o(1)}$.
- Exp42's integer target/swap identities are exact. Its $N/q$ and logarithmic
  budgets, ratios, minima, and $\kappa$ are float64 diagnostics. The safe
  universal box baseline centered at $N/q$ is $N/q+2$, not exactly $N/q$.
- Robust LP/Farkas/dual-sensitivity machinery is presumed known in form.
  The arithmetic specialization is retained as synthesis; no mathematical
  novelty is claimed.

# Proof obligations

1. Verify PM1's four-line proof (certificate identity at nu_t; P >= 0 on
   K; triangle inequality on the violation terms).
2. Verify the corollary chain PM2-PM6 (each one displayed inequality).
3. Verify Lemma 1.4 only as finite LP strong duality on the specified compact
   box-and-slab polytope; do not extrapolate it to other proof cones.
4. Replay exp42: exact integer cross-checks separately from float64
   diagnostics $t^*=12.32$, exchange ratio $12.33$, and the $\kappa$ table.
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
- Scope falsifier: produce a claimed application whose proof uses a state
  constraint, nonlinear inference, or bilinear/Type-II axiom absent from the
  finite LP; that application is outside the theorem even if PM1 remains true.

# Evidence

notes/PROOF_MASS.md (theorems and proofs); code/exp42_proofmass.py,
data/exp42_out.txt (18-cell numerical table, headline diagnostics,
flatness band), figures/exp42_proofmass.png; code/exp41_selberg_swap.py,
data/exp41_out.txt (exact integer witness identities).

# Independent audit

2026-08-11, Codex octic-frontier plus an independent Dalton lineage:
conditional accept for PM1-PM6 as narrow finite LP algebra; rejection of
the former exact-numerics, unrestricted-proof, canonical-floor,
$N^{5/4+o(1)}$, and theorem-novelty packaging. Required corrections are
incorporated in this packet and `notes/PROOF_MASS.md`.

# Prior art

Recorded search 2026-08-11 (notes/PROOF_MASS.md section 6): Selberg
Lectures on sieves (LP framing classical); Tao 2014 parity obstruction;
Ford 2023 sieve notes; Polymath8b variational formalism; Sherali-Adams
pseudo-expectations. The audit additionally identifies PM1's form with
standard robust-LP, approximate-Farkas, and dual-sensitivity reasoning.
The sieve-source search is not enough to support novelty; Hoffman bounds,
robust optimization, and broader proof-complexity literature remain to be
searched if the arithmetic packaging is ever advanced beyond synthesis.

# Successor seeds

- Charge of Type-II/bilinear axioms: price Vinogradov's crossing in
  budget units (shared with R0007 seed 2).
- Lean: PM1-PM5 are finite LP algebra — FiniteInformation.lean lane
  candidate alongside C1.
- Extend the instantiation to sieve-weight kernels (Selberg Lambda^2
  forms) and to the SIEVE_d(S,Q) literal families of LENS_CIRCUIT.

# Event log

- 2026-08-11: registered as the provenance-safe repaired successor to R0008; the original packet and events remain immutable history.
- 2026-08-11: seeded by fleet-chaitin (proof-mass program of
  LENS_CHAITIN section 4 item 2, assigned in R0007 successor seeds).
- 2026-08-11: hostile audit narrowed the claim to the finite box-and-slab LP,
  separated exact algebra from numerical exp42 output, and downgraded novelty
  to known-in-form.
