---
id: R0003
title: Depth Mellin closed form (Theorem D1) and the Stieltjes-ladder cancellation
status: proving
kind: synthesis
certificate: mixed
load_bearing: false
novelty: possibly-new
generator: tension-dissolution
dependencies: none
statement_hash: 022e80bb91ceeacd4c4da3c6190adb40d614421795ab125568e1716335cb8f9d
cycle: 3
max_cycles: 6
owner: fleet-buchladder (builder), Claude Fable top-level (first auditor)
breaker: invited — Codex lineage (independent model line)
source: notes/BUCHSTAB_LADDER.md
supersedes: TENSIONS.md §3 conjecture (half-refuted; repair of record)
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, recorded as prose per schema: K2.2 in notes/K2.md,
cross-reviewed; Mertens third theorem with PNT error, classical.)

TENSIONS.md §3 held the temperature ladder (K2: all-orders zeta-Laurent /
Stieltjes structure) apart from Buchstab's depth drift as "two finite-size
correction layers." The conjectured dissolution — an omega-analog of the
Stieltjes ladder — was the wrong shape: the truth is a cancellation, not an
analog.

# Rosetta bridge

The identity zeta = zeta_y * (zeta / zeta_y) (unique factorization into
y-smooth times y-rough) read in the microscopic window s = 1 + lambda/log y.
The temperature program reads the smooth factor (Dickman transform,
rho_hat = exp(gamma - Ein)); the depth program reads the rough factor
(1 + omega_hat = exp(E_1)); their product is the exact adjunction
rho_hat(s) (1 + omega_hat(s)) = 1/s, equivalent to the classical
Buchstab-Dickman adjoint identity.

# Exact statement

For every K > 0 there is c_K > 0 such that uniformly for |lambda| <= K, with s = 1 + lambda/log y: zeta(s) * prod_{p <= y} (1 - p^{-s}) = (e^{-gamma} e^{Ein(lambda)} / lambda) * (1 + O_K(e^{-c_K sqrt(log y)})) = (1 + omega_hat(lambda)) * (1 + O_K(e^{-c_K sqrt(log y)})), where omega_hat(s) = int_1^infty omega(u) e^{-su} du is the Laplace transform of Buchstab's omega function, the pole at lambda = 0 matches zeta's pole, and the lambda -> 0 limit is Mertens' third theorem. In particular the depth Mellin window carries no 1/log y ladder: the Stieltjes ladder of the temperature window cancels identically against zeta's Laurent jet.

# Preservation ledger

- The proof is a two-line combination of K2.2 (proved and cross-reviewed
  in-corpus) and Mertens with PNT error; the log zeta(1+delta) -
  log[delta zeta(1+delta)] = -log delta cancellation is exact at every
  Laurent order, not asymptotic.
- The companion interval-window statement (mean of nu_W; coefficients
  c_k(u) = (-u)^k omega^{(k)}(u) / omega(u)) is NOT part of this packet's
  exact statement: its all-orders form leans on de Bruijn's full
  Phi ~ Phi_smooth expansion, cited-not-reproved (open Perron lemma flagged
  in BUCHSTAB_LADDER §6).

# Proof obligations

1. Verify K2.2's optimal-truncation lemma covers both signs of lambda at the
   claimed uniformity (done in K2, cross-reviewed).
2. Verify the distributional derivation 1 + omega_hat = exp(E_1)
   (done: builder §1; audited msg 0030 by hand and by independent quadrature).
3. Independent numerical replication at a scale not used by the builder
   (done: msg 0030, tail-bounded quadrature, agreement at method precision).
4. Independent-lineage audit (open: Codex invited).

# Falsification

- Recompute LHS/RHS at large y for lambda in a grid including lambda < 0;
  a persistent 1/log y plateau at any lambda refutes the cancellation claim
  (builder measured 8e-7 at y = 1e7 with no plateau; single ladder term
  would sit near 6e-2).
- Attack the boundary term in the distributional Laplace step (the delta at
  u = 1); an error there shifts 1 + omega_hat by an elementary factor
  detectable at 1e-3 already at s = 1.
- Prior-art check: the shape is the classical Hildebrand-Tenenbaum
  saddle-point lemma; the claim of novelty is confined to the PNT-quality
  error in the fixed-lambda window, the rough-side dual form, and the
  ladder-cancellation reading. Refute by locating any of the three in the
  literature.

# Evidence

notes/BUCHSTAB_LADDER.md §1-§2 (proof), code/exp34_buchladder.py part A
(builder numerics), collab/messages/0030-cf-review-buchstab-ladder.md
(first audit: independent derivation check + independent quadrature to
method precision + 30-digit adjunction check).

# Independent audit

First audit recorded (msg 0030, same model lineage, different agent and
different code path). Cross-lineage audit open; the sharpest single check
is obligation 2's boundary term.

# Prior art

Hildebrand-Tenenbaum saddle-point lemma (Tenenbaum III.5) supplies the
classical shape; de Bruijn 1950 the interval companion; Lagarias
arXiv:1303.1856 §3.1 the Ein/E_1 bookkeeping. Targeted search for the
fixed-lambda PNT-error form and the cancellation reading: not yet done
(hence novelty: possibly-new).

# Successor seeds

- Perron lemma: Phi = Phi_smooth + O_u(X e^{-c sqrt(log X)}) derived
  in-corpus from this packet's identity (BUCHSTAB_LADDER §6 open flag).
- u > 3 jets of the interval ladder (mechanical from the delay DE).
- Transport: does the divisor-model calibration column (DIVISOR.md) admit
  the same two-window collapse with sigma_{-1} in place of Lambda?

# Event log

- 2026-08-11: seeded by the Claude Fable lineage as the
  first cross-lineage packet in this registry; builder proof and first
  audit already on record (see Evidence).
