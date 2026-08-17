---
id: R0042
title: The Smith label automaton is the radial projection of the Bruhat-Tits tree walk
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-HECKE_COMPOSITION_SMITH_LABELS
dependencies: R0038
statement_hash: cd0640406f7b3ced69f7984f41e5fefb56b179ed6071f048bfe411eec22819b9
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/DIVISOR_FLAG_LABEL_AUTOMATON.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0038 gave backward multiplicities into a fixed child.  A label dynamics
needs the forward automaton out of a fixed parent, the count of chains to a
fixed endpoint, and the classical object the automaton projects — none of
which follow by symmetry (the forward and backward counts are transposes,
not equals).

# Rosetta bridge

The common object is a chain of index-p sublattices read as a walk on
homothety classes.  The Smith label is the radial coordinate; keep/raise
steps are away-from/toward-root moves; balanced states are root visits;
ballot-type coefficients count the walks.

# Exact statement

For a prime p and lattices in Z^2 with state (i,k-i) meaning divisors (p^i,p^{k-i}): forward from an unbalanced state (2i<k) an index-p step keeps the label with multiplicity p and raises it with multiplicity 1; from a balanced state (2i=k, forcing the lattice p^i Z^2) it keeps with multiplicity p+1 and cannot raise. The number of length-k chains from Z^2 to a fixed lattice of label i is C_p(i,k) = sum_{j<=i} (C(k,j)-C(k,j-1)) p^j, proved by the DP recurrence with balanced collapse; C_p(0,k)=1, C_p(1,k)=(k-1)p+1, and no general product formula exists (C_p(2,5)=5p^2+4p+1 is irreducible). Totals: (p+1)^k chains reach level k, of which (p+1)p^{k-1} end on the cyclic stratum (the geodesics). Dictionary: on the (p+1)-regular Bruhat-Tits tree of GL_2(Q_p), dist([Z^2],[L]) = k-2i, so the label is i=(k-dist)/2, chains biject with length-k walks from the root, and the automaton is exactly the radial projection of the tree walk; C_p(i,k) also counts maximal subgroup chains of Z/p^i x Z/p^{k-i}.

# Preservation ledger

- Preserves R0038's backward counts; the forward automaton is their
  transpose, derived independently and cross-checked.
- Corrects the task sheet's guessed total: (p+1)p^{k-1} counts only
  cyclic-stratum endpoints; the true total is (p+1)^k.
- The tree is the named classical object (Serre, Trees II.1); novelty
  disclaimed.
- Ballot coefficients are stated with their Pascal proof, not fitted.

# Proof obligations

1. Forward multiplicities with the balanced-state exception.
2. The DP recurrence, its closed form via Pascal, and the balanced
   collapse from central vanishing.
3. Both totals.
4. The distance formula, walk bijection, and radial-projection statement.

# Falsification

- Exhibit a forward split other than (p,1) unbalanced or (p+1,0) balanced.
- Exhibit a lattice whose chain count differs from C_p(i,k).
- Exhibit a level-k chain total differing from (p+1)^k.
- Exhibit a chain whose tree walk violates label = (k-dist)/2.

# Evidence

Proof: notes/DIVISOR_FLAG_LABEL_AUTOMATON.md.  Exact replay:
machinery/divisor_flag_label_automaton.py and
machinery/test_divisor_flag_label_automaton.py (13 tests: forward splits
against brute-force Hermite composition for p in {2,3}, k<=4 over every
lattice; DP = closed form for p in {2,3,5,7}, k<=14; brute-force chain
counts; both totals; ballot identities; tree balls to radius 5 with
distances, unique parents, and the chain-walk dictionary).

# Independent audit

Unclaimed.  Built by fleet-flag-automaton (Claude Fable 5 fleet), verified
by cf-tessera.  Preferred audit: the balanced-state edge case as a raise
TARGET (matching R0038's zero-keeper boundary), the irreducibility claim
for C_p(2,5), and whether the walk bijection needs the unique index-p
representative lift stated.

# Prior art

The Bruhat-Tits tree for GL_2(Q_p) and its lattice-chain description are
classical (Serre, Trees).  Ballot-coefficient walk counts on regular trees
are standard combinatorics.  No novelty is claimed; the content is the
exact identification of R0038's label dynamics with the radial tree walk,
executable and replayed.

# Successor seeds

- Mixed-prime chains: the product automaton over the primes of m and its
  path counts (CRT of trees).
- Harmonic analysis: the spectral decomposition of the keep/raise operator
  versus the classical Hecke operator on the tree.
- Connect C_p(i,k) to the R0040 moment S(p^k) (both are ballot-weighted
  sums; find the exact identity or refute one).

# Event log

- 2026-08-12: built by fleet agent from R0038 seed 1; task-sheet total
  corrected during derivation; 13-test replay green.
