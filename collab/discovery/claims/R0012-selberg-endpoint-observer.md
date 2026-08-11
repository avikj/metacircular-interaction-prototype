---
id: R0012
title: Selberg endpoint observer and scoped two-model obstruction
status: formalizing
kind: synthesis
certificate: exact-finite
load_bearing: false
novelty: known
generator: observer-kernel-audit
dependencies: none
statement_hash: 00a7b2afeded0f18651896a8ca0cc1b738fec46a7c8bfb0533d84053e5bbb9a1
cycle: 2
max_cycles: 6
owner: Codex observer-kernel repair (builder)
breaker: invited — independent lineage must rederive the endpoint/channel scopes
source: notes/LENS_CHAITIN.md
supersedes: R0007
updated: 2026-08-11
---

# Tension

R0007 sought an exact one-bit witness for sieve parity, but its companion note
declared the state class to be the whole pointwise cube while computing the
fiber only on two endpoints.  It also mixed normalized expectations with
finite measures, treated measured AP discrepancies as exact equality, and
used the global Liouville flip for a pair charge that the flip actually fixes.

# Rosetta bridge

The common object is a finite deterministic channel on a declared two-element
state set.  Fiber cardinality controls zero-error side information; image
cardinality controls deterministic Shannon capacity; and a two-model semantic
argument controls only conclusions valid on every state in the declared axiom
fiber.  These quantities become exact once the domain and maps are typed.

# Exact statement

Fix X >= 2, Omega_X = {1,...,X}, L(X) = sum_{n <= X} lambda(n), and finite measures nu_pm(f) = sum_{n <= X} (1 pm lambda(n)) f(n). Then nu_pm are nonnegative, nu_pm(1) = X pm L(X), nu_+(f) - nu_-(f) = 2 sum_{n <= X} lambda(n)f(n), and their prime totals are 0 and 2 pi(X). On S_lambda = {nu_+,nu_-}, let sigma exchange the endpoints and let q be the constant common-shadow channel. Every sigma-invariant state observable agrees on the endpoints; q has image cardinality one and hence deterministic Shannon and zero-error capacity zero; recovering the endpoint, or the prime-total target, needs and admits a side alphabet of size two, equivalently one fixed-length bit. This one-bit claim is only for S_lambda. Separately, for X >= 5 on Omega_X^(2) = {1,...,X-2}, set c_2(n) = lambda(n)lambda(n+2) and eta_pm = (1 pm c_2(n))dn; if sigma_2 exchanges eta_+ and eta_-, then the twin totals are 2 pi_2(X) and 0. The action sigma_2 is not induced by lambda -> -lambda. Finally, if a declared class K contains either endpoint pair, every axiom A in a family has equal values on that pair, and a conclusion T(nu) >= beta is valid for every state in K with those axiom values, then beta <= min(T(endpoint +), T(endpoint -)); thus the corresponding prime or twin lower bound is at most zero.

# Preservation ledger

- The integral, mass, prime, and twin identities are exact finite sums.
- The capacity computation uses the unconstrained-input deterministic channel
  on exactly two states.  Its zero-bit observer capacity is distinct from the
  one-bit side supplement.
- The endpoint set is introduced explicitly.  No claim is made that a whole
  affine segment or pointwise cube has a two-point fiber.
- Ordinary AP counts and smooth linear sums agree only when their explicit
  Liouville correlation vanishes.  No named sieve family is silently placed
  in the exact common shadow.
- The twin involution is a separate formal endpoint exchange because the
  global sign change of lambda fixes c_2.
- C1 is semantic model comparison relative to K and the stated axioms, not an
  incompleteness theorem for an unspecified proof system.

# Proof obligations

1. Expand the two finite sums to verify masses and integral difference.
2. Use lambda(p) = -1 to verify the prime totals; use c_2(n) = +1 when both
   n and n+2 are prime to verify the twin totals on n <= X-2.
3. Apply the finite observer theorem to the constant two-state channel:
   image size one, maximum state/target fiber size two.
4. Prove C1 by evaluating the universally valid conclusion at each feasible
   endpoint and taking the minimum.
5. Obtain an independent-lineage audit before any promotion.

# Falsification

- Produce X >= 2 for which either mass/integral/prime identity fails.
- Find a state observer F with F o sigma = F but F(nu_+) != F(nu_-).
- Reinterpret the domain as the whole segment or cube and retain the
  two-element full-state fiber; that would falsify the claimed scope, not
  strengthen it.
- Give a C1 instance in which both endpoints satisfy the exact axiom values
  but a universal lower bound exceeds one endpoint target.

# Evidence

notes/LENS_CHAITIN.md contains the expanded proof and audit boundary.
code/exp41_selberg_swap.py replays the exact integer prime/twin identities and
reports AP discrepancies explicitly as nonzero; floating output is not used
to establish the algebraic integral identity.  machinery/observer_channel.py
implements the finite capacity and minimum-side-alphabet calculation.

# Independent audit

The Codex observer audit refuted R0007's enlarged domain and ambiguous
normalization, then reconstructed this successor.  Because that audit also
generated the repair, a fresh independent lineage is still required for
R0012 itself.

# Prior art

The Selberg pair and parity phenomenon are classical (Selberg; Bombieri;
Friedlander--Iwaniec, Opera de Cribro, Chapter 16).  Constant-channel capacity,
two-symbol zero-error side information, and unfavorable-model evaluation are
elementary.  Chaitin supplies analogy, not a novelty claim or dependency.

# Successor seeds

- Formalize the endpoint channel and C1 in FiniteInformation.lean.
- State a separate noisy interval-axiom theorem with explicit centers,
  radii, endpoint charges, and aggregation norm; audit R0008 against it.
- Identify an actual sieve axiom map proved to contain both endpoints before
  drawing a named proof-system obstruction.

# Event log

- 2026-08-11: created as the hash-preserving audit repair of R0007.
