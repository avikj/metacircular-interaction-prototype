---
id: R0024
title: Least-factor reflection is noncommuting but scalar entropy capacities are pair-blind
status: formalizing
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: least-factor-reflection-transport
dependencies: none
statement_hash: 0e05dfcd103ed800137f036d5aeae336e946763192f8a35decb55ef088394621
cycle: 2
max_cycles: 4
owner: codex-transport
breaker: invited — audit the entropy optimization, endpoint convention, and reflection-pair concentration bound
source: notes/LEAST_FACTOR_REFLECTION_TRANSPORT.md
supersedes: none
updated: 2026-08-12
---

# Tension

Additive reflection and least-prime-factor stopping genuinely do not commute,
so a hypothetical Goldbach exception partitions primes into oriented sifted
residue fibers. This retains more structure than a fixed charge coefficient,
but scalar entropy may still erase the decisive reflected incidence.

# Rosetta bridge

The common object is the stopping-time partition
`P_q(N)={p prime:P^-(N-p)=q}` under a Goldbach exception. The multiplicative
chart is `N-p=qm` with `q<=m` and `P^-(m)>=q`; the proposed scalar realization
retains only the fiber masses and their independent analytic capacities.

# Exact statement

For an even Goldbach exception `N`, apart from the possible endpoint `p=N-1`,
the primes below `N` partition uniquely by `q=P^-(N-p)<sqrt(N)`. If
`s_q=|P_q(N)|` and only independent bounds `s_q<=C_q` are retained, then the
strongest Hall/entropy contradiction is exactly `sum_q C_q<sum_q s_q`; the
box-simplex of scalar data is otherwise nonempty. Moreover, when an even
`W` divides `N`, the `W`-coprime universe splits into reflection pairs and a
symmetric random orientation has every prescribed one-point marginal while
identically forbidding `a,N-a` from both being selected. Hoeffding plus a
union bound matches any fixed finite family of one-point tests up to
square-root discrepancy.

# Preservation ledger

- Retains the exact least-factor address and ordered boundary `q<=m`.
- The commutator with reflection is genuinely nonzero before scalarization.
- Scalar fiber masses forget all incidence between primality at `p` and the
  reflected endpoint.
- The false model preserves one-point residue, roughness, and stopping-fiber
  expectations while destroying every target reflected pair.
- No claim covers signed bilinear, Type-II, dispersion, or adjacent-level
  constraints; those deliberately remain possible successors.

# Proof obligations

1. Check the exceptional endpoint and unique least-factor partition.
2. Compute the conditional entropy on the disjoint fibers.
3. Prove the box-simplex capacity criterion, including integral rounding.
4. Verify reflection preserves the `W`-coprime universe and has no fixed point.
5. Prove the symmetric-orientation marginal, pair exclusion, and simultaneous
   Hoeffding bound.

# Falsification

- Find a prime endpoint omitted from the declared convention.
- Exhibit scalar capacities satisfying the total-capacity condition but an
  empty box-simplex.
- Find a one-point test whose expectation is not preserved by the symmetric
  orientation model.
- Find a fixed point of reflection in the even `W`-coprime universe.
- Supply a genuinely joint inequality derived from existing input; this
  escapes rather than refutes the scoped no-go.

# Evidence

`notes/LEAST_FACTOR_REFLECTION_TRANSPORT.md` contains the finite proofs. No
numerics are used.

# Independent audit

Open. A breaker should rederive the entropy identity and concentration bound,
and test whether the stated scope accidentally includes a joint sieve input.

# Prior art

Least-factor stopping/Buchstab decomposition, sieve parity, entropy bounds,
and Hoeffding concentration are standard. No novelty is claimed. The result's
value is the exact scope boundary and false-model control for this proposed
route.

# Successor seeds

- Retain a signed bilinear form across adjacent stopping levels.
- Formulate the weakest Type-II estimate on `(q,m)` that the reflection-pair
  model cannot satisfy.
- Compare dispersion in the moving classes `p=N mod q` before absolute values.
- Ask whether adjacent Buchstab levels obey a conservation law with a
  prime-specific, rather than arbitrary-coloring, residual.

# Event log

- 2026-08-12: registered in formalizing after the exact derivation killed the
  scalar entropy/Hall route and isolated the required two-point datum.
