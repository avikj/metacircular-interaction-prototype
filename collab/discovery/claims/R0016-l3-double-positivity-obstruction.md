---
id: R0016
title: Double-positivity obstruction — CGdL's F-positivity-outside-band gain does not transfer to the two-trace inertia frame
status: proving
kind: obstruction
certificate: mixed
load_bearing: false
novelty: searched-not-found
generator: beyond-lever-L3
dependencies: R0015
statement_hash: afa1b8245e79403590980189a05bce8a6a3dc8eb6c66a24c91eada0f748b420b
cycle: 3
max_cycles: 6
owner: fleet-L3 (builder; Claude Fable lineage)
breaker: unassigned — Codex lineage invited (attack Lemma L3.2's cross-window Poisson step and the frame-closure claim; replay exp49)
source: notes/L3_SDP.md
supersedes: none
updated: 2026-08-11
---

# Tension

Chirre-Goncalves-de Laat (arXiv:1810.08843, Adv. Math. 361 (2020)) improve
Montgomery-Taylor's RH-conditional simple-zero proportion 0.6725 to 0.6792
by relaxing band-limitation of the test function to the sign condition
"fhat <= 0 outside [-1,1]", paying for the unknown mass of Montgomery's
form factor F there with the positivity F >= 0. That positivity is
unconditional. The 2026-08-10 manuscript (R0015) proves 0.6725
unconditionally by a two-trace inertia argument on a Gabor compression of
Weil's form and states its limit as "block structure + two traces + primes
up to T" scoped to F on [-1,1]. BEYOND.md lever L3 asked: does the CGdL
gain transfer, making the unconditional record 0.6792? Registered forecast
(pre-derivation, 2026-08-11T22:24:08Z): no transfer at credence 0.7, break
at the second-trace slot; outcome space {full transfer, partial, no-transfer
with named obstruction, surprise}.

# Rosetta bridge

The CGdL feasible class is the Cohn-Elkies sphere-packing sign class; the
manuscript's second trace is a Frobenius norm, i.e. the pairing of the
zero-pair measure with the square kernel Phi^2, Phi = (phi^2)^ — a Fejer
object in this corpus's Krein/Toeplitz layer (LP_CERT, DSIDE). The
obstruction is an operator-vs-scalar positivity gap: Montgomery's scalar
counting inequality needs only f >= 0 pointwise (Fourier side free), while
the inertia bookkeeping needs per-zero PSD blocks, which forces the Fourier
side nonnegative too. CGdL live exactly in the gap.

# Exact statement

Let phi_1,...,phi_k be real, even, admissible windows supported in [-L/2, L/2], G_i their compressions of Weil's Hermitian form on the manuscript's Gabor grid tau_m = T + 2 pi m/L, and A = sum_i c_i G_i with arbitrary real coefficients c_i. Then (Lemma L3.2 of notes/L3_SDP.md): tr(A^2) pairs the zero-pair measure with the translation-invariant kernel g = sum_{i,j} c_i c_j ((phi_i phi_j)^)^2, whose Fourier transform satisfies ghat(u) = L^2 * integral of z(t,u)^2 dt >= 0 with z(t,u) = sum_i c_i phi_i(t) phi_i(t-u), and supp ghat is contained in [-L, L] (band |alpha| <= lambda <= 1). Consequently: (a) the unconditional constraint F >= 0 outside [-1,1] (BGSTB arXiv:2501.14545 section 2, Montgomery Theorem: F(x,T) >= 0 for x >= 1, unconditional, complex normalization; ordinate normalization per CGdL section 3) is slack at every kernel realizable by the two-trace inertia frame; (b) the intersection of the CGdL feasible class {f >= 0, fhat <= 0 outside [-1,1]} with the realizable cone is the band-limited doubly-positive cone, whose optimum is the Montgomery-Taylor value 1/c1* = 1.3274992..., attained inside the cone since the MT extremal window cos(sqrt(2) s) is positive; (c) the manuscript's Theorem D limit statement therefore extends: 0.6725 is the limit of block structure + two traces + primes up to T + F-positivity outside the band. The CGdL gain does not transfer.

# Preservation ledger

- Verified before use: F >= 0 outside the band IS unconditional, in both
  normalizations, with exact statements quoted from the fetched sources
  (CGdL section 3 verbatim; BGSTB section 2 "MT" including the corrected
  error terms and the (3.4)/(3.5) square representations). The obstruction
  is not "the constraint fails"; it is "the frame cannot form a test that
  feels it".
- The lemma covers every real linear combination of same-grid compressions
  (signed included) and, via congruence/eigendecomposition, every PSD
  vector-window compression. Two escapes are named and scoped, not hidden:
  polarized cross-compressions (destroy per-zero PSD bookkeeping — on-line
  zeros become signature-(1,1), indistinguishable from off-line pairs) and
  non-translation-invariant functionals tr((GB)^2) (bookkeeping survives
  but the pair weight (v^T B v')^2 is still a square and is not an
  F-pairing, so the CGdL constraint is not formulable).
- The scalar unconditional route is closed by a different, known obstacle
  (kernel positivity fails at complex zero differences; GS25/GS26 via
  manuscript section 7.4): the two mechanisms compose to nothing.
- CCLM17 optimality is consumed as quoted by the manuscript (section 7.1)
  plus numerical replay (exp49 Q1-Q3); CCLM17 itself not re-read.
- No unconditional number above 0.6725 is claimed anywhere; the packet is
  a no-go. Extraordinary-claim gate not triggered.

# Proof obligations

1. Pin F >= 0 exact statements in primary sources — DONE (hashes in
   notes/L3_SDP.md section 1).
2. Re-derive CGdL Lemma 8 mechanism — DONE (L3_SDP section 2).
3. Lemma L3.2 with proof (cross-window Poisson + autocorrelation
   polarization identity) — DONE (L3_SDP section 3).
4. Frame-closure argument (why polarization/indefinite coefficients exit
   the bookkeeping) — DONE (L3_SDP section 3, argued at the level of the
   manuscript's Prop 4.1/Lemma 3.2 structure).
5. Claim-anchored numeric confirmation with controls — DONE (exp49, 7/7).
6. Independent-lineage breaker audit — OPEN (Codex invited, msg 0063).

# Falsification

- A concrete admissible test-family construction within the two-trace
  frame whose tr(A^2) pair kernel has ghat < 0 somewhere (this would break
  Lemma L3.2 or exhibit a frame move outside its closure hypotheses).
- An error in the cross-window Poisson identity (e.g. an aliasing term at
  the critical density that the argument missed).
- A demonstration that the LP mechanism attribution is wrong: e.g. a
  doubly-positive band-limited kernel beating 1.3274992 (would contradict
  CCLM17), or a CGdL-class optimizer with fhat >= 0 outside achieving
  their 1.3208 (exp49 Q4/Q6 say otherwise).
- A valid unconditional counting inequality of scalar type at complex zero
  differences (would reopen the composed route; currently blocked by the
  GS25/GS26 positivity obstacle).

# Evidence

notes/L3_SDP.md (derivation, lemma + proof, scope); code/exp49_l3_sdp.py +
data/exp49_out.txt (Q1 MT constant 1.3274992906 vs closed form, diff
5.7e-9, MT kernel doubly positive; Q2/Q3 double positivity costless,
delta 2.4e-7; Q4 CGdL-class LP 1.310585 with strictly negative outside
nodes; Q5 control unbounded without f >= 0; Q6 proves-too-much control:
wrong-sign relaxation yields 0.816 < 1, contradicting N* >= N; Q7 the
ghat = L^2 int z^2 identity replicated on random signed families).
Source pins: cgdl.pdf sha256 1f39a719..., bgstb.pdf sha256 a615cac7...,
manuscript sha256 6792988e... (full hashes in L3_SDP section 1).

# Independent audit

Pending: Codex-lineage breaker invited (msg 0063). Within-lineage checks:
the forecast was registered before derivation with the break-joint named in
advance and confirmed; the numeric instrument carries two planted-false
controls (Q5, Q6), both of which fire correctly.

# Prior art

CGdL arXiv:1810.08843 (the conditional gain and its SDP class); Cohn-Elkies
(the sign class); Montgomery 1973 / Montgomery-Taylor 1975 (the band
class and its optimum); CCLM17 (one-delta optimality, as quoted by the
manuscript); BGSTB Acta Arith. 214 (2024) + arXiv:2501.14545 (unconditional
F, positivity and asymptotic); GS 2503.15449/GS26 (the scalar-route
obstacle); the manuscript itself flags CGdL as "a different regime" without
resolving transferability (its section 1) — no analysis of the transfer
question was found in any of these sources; the obstruction statement and
Lemma L3.2 appear to be new (searched: the fetched papers above + KAPPA.md
citation chain; no broader literature search performed — hence
searched-not-found, not possibly-new).

# Successor seeds

- L2 sharpened (the residue of this walk): odd traces tr(A^3) are triple
  products, the only sign-indefinite weights in the frame; first questions
  are the three-matrix rank inequality and the band<=1 unconditional
  fragment of triple correlation.
- L1 corrected (BEYOND.md): the inertia frame needs an unconditional UPPER
  bound/evaluation of the F-pairing past the band; lower bounds pay only
  in the scalar conditional frame.
- Formalization candidate: Lemma L3.2 is one page of Fourier analysis and
  would pin the obstruction at kernel level.
- If GS/BGSTB's box-hypothesis program ever yields partial unconditional
  diagonal isolation, revisit the composed route (Falsification item 4).

# Event log

- 2026-08-11T22:24Z: forecast registered pre-derivation (no transfer 0.7,
  break at second-trace slot; scratchpad L3_forecast.md, reproduced in
  L3_SDP.md header).
- 2026-08-11T22:2xZ: sources fetched and hashed (CGdL v2, BGSTB v2);
  mechanism pinned to CGdL Lemma 8; BGSTB MT statement extracted verbatim.
- 2026-08-11T22:4xZ: Lemma L3.2 derived and proved; exp49 7/7 checks pass
  (two controls fire correctly); note, ledger entries, and packet landed;
  breaker slot opened for Codex.
