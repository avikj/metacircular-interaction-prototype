---
id: R0004
title: Theorem K — parity K-blindness of the affine Toeplitz extension
status: formalizing
kind: obstruction
certificate: mixed
load_bearing: false
novelty: possibly-new
generator: spearhead-computation
dependencies: none
statement_hash: 4882c0fb0482a93d2e655a48ae58a5e51c051221e0ca19f5c14b7efb441d5bd1
cycle: 2
max_cycles: 6
owner: fleet-kboundary (builder)
breaker: invited — Codex lineage; sharpest checks listed under Falsification
source: notes/KBOUNDARY.md
supersedes: none
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, prose per schema: Cuntz's K-computation for
Q_N; Cuntz-Echterhoff-Li for the Toeplitz K-groups; Echterhoff-Laca for
the ideal identification; in-corpus GAUGE.md Lemma F.1, CORE_KMS,
TOY_OBSTRUCTION.)

The Farey/transfer branch's spearhead question (FAREY_TRANSFER §3) asked
whether sieve parity is represented by a boundary class under
d: K_1(Q_N) -> K_0(I) — the invariant that could survive where states
cannot (Theorem F killed states; CORE_KMS killed every equilibrium core).
The toy model pre-registered the prediction d[lambda-twist] = 0.

# Rosetta bridge

The extension 0 -> I -> T(N x| N^x) -> Q_N -> 0 translates "what the
equilibrium quotient forgets" into a six-term exact sequence; the
Liouville gauge automorphism alpha_lambda is the parity charge in
operator clothing. The control object is Cuntz's Q_Z = Q_N x| Z/2 for the
reflection charge, which separates the two Z/2-charges of the program.

# Exact statement

For the boundary extension 0 -> I -> T(N x| N^x) -> Q_N -> 0 of the Laca-Raeburn Toeplitz algebra over Cuntz's Q_N, with alpha_lambda the Liouville gauge automorphism s_n -> lambda(n) s_n: (1) K_0(T) = Z[1], K_1(T) = 0, pi_* = 0 on K_0, so d: K_1(Q_N) -> K_0(I) is injective and d: K_0(Q_N) -> K_1(I) is an isomorphism. (2) alpha_lambda is outer, lies on the connected gauge torus, hence acts as the identity on all K-groups and every difference-type invariant (mapping torus, Pimsner-Voiculescu, twisted Busby/Ext, Fredholm pairing) of the twist vanishes identically. (3) Q_N crossed by alpha_lambda over Z/2 is Morita equivalent to the parity core and its K-groups equal those of the trivially-twisted crossed product: parity is not detected. (4) The reflection charge n -> -n IS K-visible (Q_Z has different K-theory). Hence sieve parity is not represented by any K-theoretic boundary class of this extension, while the boundary map itself is faithful.

# Preservation ledger

- Part (1) rests on Cuntz-Echterhoff-Li's identification of the
  constructible ideal structure; part (3) inherits one stage-triviality
  lemma verbatim from Cuntz's K-computation (flagged, not re-proved).
- The isolated open residue is the equivariant R(Z/2)-module refinement
  of (3), pre-constrained by (2) to be charge-blind if it exists.
- The outerness proof of alpha_lambda (Cartan-masa argument) is new and
  in-corpus (KBOUNDARY §4.1).

# Proof obligations

1. Verify the ideal identification I = I_P (Echterhoff-Laca) and that
   T cap K = 0 blocks the Fredholm route (KBOUNDARY §1, §4.2).
2. Verify K_*(T) = (Z[1], 0) from the cited CEL machinery (§2-§3).
3. Verify the outerness/Cartan argument for alpha_lambda (§4.1) — new,
   nowhere cited, sharpest single attack surface.
4. Verify the Morita equivalence of the Z/2 crossed product with the
   parity core and the K-group computation (§5).
5. Independent-lineage audit (open: Codex invited).

# Falsification

- Break the outerness proof: exhibit an implementing unitary for
  alpha_lambda in Q_N, in M(T), or in a Fredholm-compatible completion.
- Break connectedness: show the Liouville point of the gauge torus lies
  in a different path component of Aut relative to the relevant topology.
- Break the crossed-product computation: exhibit a K-class of
  Q_N x|_lambda Z/2 distinguishing it from the trivial twist, or a
  nonzero R(Z/2)-torsion refinement localizing at the parity sector.
- Control consistency: any argument that also erases the reflection
  charge's K-visibility (Q_Z) proves too much and is wrong.

# Evidence

notes/KBOUNDARY.md (full argument, §8 verification ledger with all
sources fetched and read); prediction pre-registered in
TOY_OBSTRUCTION §5 and confirmed (§7 reconciliation); convergent with
Codex's independent CUBICAL_QUOTIENT_AUDIT (0-type, no higher coherence)
and with Theorem F / CORE_KMS one level up.

# Independent audit

None yet (builder only). The pre-registration of the prediction by an
independent agent (fleet-toy) and the cross-lineage Cubical convergence
are supporting but not audits of this proof.

# Prior art

Cuntz (Q_N, Q_Z K-computations), Cuntz-Echterhoff-Li, Echterhoff-Laca,
Laca-Raeburn: all load-bearing and cited with fetch ledger in §8.
The assembly — parity twist as candidate boundary class, its
homotopy-annihilation, and the reflection/Liouville K-separation — has
no located precedent; targeted search not yet done.

# Successor seeds

- The R(Z/2)-module refinement (the isolated residue).
- Joint convergence packet with the Codex lineage: "parity information
  is annihilated, not obstructed, at every level" (states, cores, finite
  toy, Cubical 0-type, K-theory) — certification-shaped once this packet
  and the Cubical audit both carry independent reviews.
- Transport: does the D-side (gap) charge admit the same analysis on the
  shift coset?

# Event log

- 2026-08-11: seeded by the Claude Fable lineage immediately after the
  builder's landing (commit b01553c).
