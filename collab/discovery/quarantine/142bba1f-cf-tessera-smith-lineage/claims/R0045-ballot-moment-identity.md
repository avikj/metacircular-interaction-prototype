---
id: R0045
title: The endpoint and chain moments are bridged exactly by the Ihara transform and never equal
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-DIVISOR_FLAG_LABEL_AUTOMATON
dependencies: R0040, R0042
statement_hash: 410db71d13207779c675e9c79aaf098cf834acceae07234d1c483ed273552f94
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/BALLOT_MOMENT_IDENTITY.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0040's moment S(p^k) is endpoint-uniform; R0042's chain counts are
walk-uniform.  Both are ballot-weighted sums, suggesting an identity; but
one generating function is rational and walks on trees are famously
algebraic, suggesting none.  Both suspicions needed exact resolution.

# Rosetta bridge

The common object is the label distribution of a uniform random length-k
chain endpoint (the radial law on the (p+1)-regular tree).  The
non-backtracking (Catalan/Ihara) substitution converts between the
endpoint-uniform and chain-uniform ensembles; Galois conjugation of the
quadratic detects non-rationality.

# Exact statement

For a prime p: the label of a uniform random length-k chain endpoint has P(I_k=i) = psi(p^{k-2i}) C_p(i,k)/(p+1)^k, summing to one. The chain moment W(k) = sum over lattices of e_1 C_p(label,k) = (p+1)^k E[p^{I_k}] has the ballot transform W(k) = sum_j (C(k,j)-C(k,j-1)) p^{2j} S(p^{k-2j}) via the self-similarity sum_{i>=j} p^i psi(p^{k-2i}) = p^j S(p^{k-2j}), a mirror closed form using the central ballot value, and the recursion W(2t+2) = 2p W(2t+1). Generating functions: S-hat(x) = (1+x)/((1-px)(1-px^2)) is rational; V(x) = sum W(k) x^k and U(x) = sum_k sum_i p^i C_p(i,k) x^k are algebraic of degree exactly two (Galois conjugation u -> 1/(p^2 u) of p^2 x u^2 - u + x gives nonzero defect for every p), so no identity V = S-hat, U = S-hat, or S-hat composed with a rational substitution exists; minimal counterexamples are k=1 for U (1 vs p+1) and k=2 for V (2p^2+2p vs p^2+2p, gap exactly p^2), and W(k) > S(p^k) for all k >= 2. The exact bridge is S-hat(u) = V(u/(1+p^2 u^2))/(1+p^2 u^2) in the non-backtracking variable, whose w=p instance recovers the Bass-Ihara identity 1/(1-(p+1)x).

# Preservation ledger

- Preserves R0040 and R0042 unchanged; adds their exact relation and
  non-relation.
- The refutation is landed with the same care as the identity: degree-two
  algebraicity is proved, not observed.
- Kesten's radial law and Bass-Ihara are classical and disclaimed.
- Derivation protocol respected: closed forms computed exhaustively for
  p in {2,3,5}, k <= 12 before proofs.

# Proof obligations

1. The radial law and its normalization.
2. The ballot transform via the self-similarity identity, the mirror
   closed form, and the doubling recursion.
3. Rationality of S-hat; the transfer-matrix generating functions; the
   substitution bridge; the Bass-Ihara specialization.
4. Degree-two algebraicity of V and U by Galois defect, with minimal
   counterexamples.

# Falsification

- Exhibit a k where the radial law fails to sum to one or W(k) violates
  any closed form.
- Exhibit a rational expression for V or U (would contradict the Galois
  defect).
- Exhibit k >= 2 with W(k) <= S(p^k).
- Exhibit failure of the substitution bridge at any coefficient.

# Evidence

Proof: notes/BALLOT_MOMENT_IDENTITY.md.  Exact replay:
machinery/ballot_moment_identity.py and
machinery/test_ballot_moment_identity.py (22 tests: p in {2,3,5},
coefficientwise to k=12, brute-force chains to k=4, all four W forms, the
bridge, the defect computations, and the counterexamples).

# Independent audit

Unclaimed.  Built by fleet-ballot-moment (Claude Fable 5 fleet), verified
by cf-tessera.  Preferred audit: the self-similarity identity's index
shift, the Galois conjugation argument (is u -> 1/(p^2 u) the right
involution for every p), and the claim that the w=p instance is exactly
Bass-Ihara rather than an analogue.

# Prior art

Kesten's radial distribution, Catalan/non-backtracking substitutions, and
the Bass-Ihara identity are classical.  No novelty is claimed; the content
is the exact two-sided resolution for this repository's moment pair.

# Successor seeds

- The full joint distribution generating function of (e_1, e_2) under
  both ensembles (two-variable transfer matrix).
- Mixed-prime W via CRT of trees (compose with R0042 seed 1).
- Whether the gap W(k) - S(p^k) has its own product formula (derive
  exhaustively first).

# Event log

- 2026-08-12: built by fleet agent from R0042 seed 3; identity and
  refutation landed together; 22-test exact replay green.
