---
id: R0037
title: The mixed-rank Smith stabilizer is parabolic tails over a flag congruence corner
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-FLAG_CONGRUENCE_SMITH_STABILIZER
dependencies: R0032, R0036
statement_hash: 019ac30e3d06c4ba25a519f127c51741f6ddf253d7a423c5d2ba5d897b94b3e5
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/MIXED_RANK_SMITH_STABILIZER.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0032 computed a one-sided rank-one stabilizer (infinite dihedral); R0036
the two-sided full-rank stabilizer (flag congruence group).  Rank-deficient
endpoints sat between them, and the corner discrepancy (identity versus a
full congruence group) needed an exact reconciliation.

# Rosetta bridge

The common object is the block decomposition of a stabilizing pair at the
rank of the endpoint.  The nonsingular block reproduces R0036's corner
arithmetic; the kernel and cokernel directions contribute free parabolic
tails; one-sidedness is the specialization that deletes the partner and
collapses the corner.

# Exact statement

Let D=blockdiag(D_r,0) in n x n with 0<r<n and D_r=diag(d_1..d_r), d_i nonzero, d_i | d_j for i<=j. Then (H,K) in GL_n(Z)^2 satisfies HDK=D iff H=((A,B),(0,E)) and K=((D_r^-1 A^-1 D_r,0),(R,S)) in r/(n-r) blocks with A in Gamma_0(D_r), B and R arbitrary integer blocks, and E,S in GL_{n-r}(Z). The stabilizer is a split extension of Gamma_0(D_r) by (Z^{r x (n-r)} semidirect GL_{n-r}(Z)) x (Z^{(n-r) x r} semidirect GL_{n-r}(Z)). The one-sided stabilizer {H: HD=D} is the subgroup with corner exactly I and C=0, which at n=2, r=1 is precisely R0032's infinite dihedral group; the corner discrepancy between one- and two-sided stabilization is exact: HD=D forces A=I while HDK=D allows all of Gamma_0(D_r).

# Preservation ledger

- Preserves R0032 (one-sided, n=2, r=1) and R0036 (two-sided, r=n) as the
  two boundary specializations.
- Adds only the block computation and the extension structure; corner
  arithmetic is unchanged from R0036.
- Normalized endpoints only (zero rows trailing); interleaved zeros differ
  by a permutation conjugation, not treated separately.
- Payload consequence: rank-r replay payload = Gamma_0(D_r) corner plus
  four tail coordinates, none endpoint-recoverable.

# Proof obligations

1. Block computation: forced shapes of H and K, corner membership, free
   tails.
2. Split extension structure with the parabolic composition law.
3. One-sided collapse to corner I and its R0032 specialization.

# Falsification

- Exhibit a stabilizing pair with C nonzero, Q nonzero, or corner outside
  Gamma_0(D_r); or a member H-shape with no unimodular partner.
- Exhibit a corner-map composition failure on members.
- Exhibit a one-sided stabilizer element with corner different from I, or
  a mismatch with R0032's dihedral family at n=2, r=1.

# Evidence

Proof: notes/MIXED_RANK_SMITH_STABILIZER.md.  Exact replay:
machinery/mixed_rank_smith_stabilizer.py and
machinery/test_mixed_rank_smith_stabilizer.py (five tests: the iff with
brute-force partner search at (2,1); the iff at (3,1) and (3,2) over the
full unimodular window; one-sided collapse; the R0032 cross-check; corner
homomorphism with kernel shape).  The replay exposed and fixed an empty-
matrix determinant base case in the R0036 module (0x0 det must be 1 for
1x1 cofactor inversion); R0036's own tests were insensitive to it and stay
green.

# Independent audit

Unclaimed.  Scope precision inherited from R0039: the split-extension
structure is with respect to the two-sided law (H,K)(H',K') = (HH', K'K);
the extension's kernel and the corner map are as computed there, and the
componentwise product stabilizes iff corners commute.

Preferred audit: attack the normalization assumption (trailing
zeros), the claim that tails are genuinely free on the K side as well, and
whether the split section respects the GL_2-versus-SL_2 sign conventions
used across R0033/R0035.

# Prior art

Parabolic subgroups and stabilizers of degenerate forms are classical; the
computation is standard linear algebra over Z.  No novelty is claimed.  The
content is the exact unification of the repository's stabilizer results
across every rank, completing the payload chain R0032-R0036.

# Successor seeds

- Payload normal form: canonical coordinates for the four tails relative to
  a computable section, extending the R0035 payload calculus to rank-r.
- Coset geometry of the mixed-rank stabilizer in GL_n(Z) and the assembly
  identity analogue (R0034 for rank-deficient strata: counting sublattices
  together with a marked kernel flag).
- Agda payload type for the full extension once a 2.8 toolchain exists.

# Event log

- 2026-08-12: seeded and proved as the mixed-rank unification; five-test
  exact replay including a brute-force iff at (2,1).
