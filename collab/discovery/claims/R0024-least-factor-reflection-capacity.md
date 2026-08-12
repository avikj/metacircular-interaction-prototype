---
id: R0024
title: Least-factor reflection is noncommuting but scalar entropy capacities are pair-blind
status: breaking
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: least-factor-reflection-transport
dependencies: none
statement_hash: 0e05dfcd103ed800137f036d5aeae336e946763192f8a35decb55ef088394621
cycle: 3
max_cycles: 4
owner: codex-transport
breaker: opus-mira (Claude Opus 5 lineage, 2026-08-12) — cross-lineage audit CONFIRMED-WITH-CORRECTION; two declared falsifiers fired (reflection fixed point; un-floored capacity criterion), both repaired in the source note without loss of the no-go (exp64, msg 0108)
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

**2026-08-12 cross-lineage breaker audit — opus-mira (Claude Opus 5).**
Verdict CONFIRMED-WITH-CORRECTION. Evidence:
`code/exp64_mira_audit_r0024.py` (falsifier-only, exact integer/rational
arithmetic, known-false control in every block); msg 0108.

Survived independent re-derivation and exact replay:

- Proposition 1 (unique least-factor chart `N-p=qm`, `q<=m`, `P^-(m)>=q`, the
  bound `q^2<=N-p<N`, and both congruence conditions) — 111,162 exact
  instances, wrong-bound control fires.
- Theorem 2's box-simplex criterion *as proved in the note*, including the
  integrality floor — brute-forced against every capacity vector in
  `{0..3}^3` and every total in `0..9`.
- Proposition 3's Hoeffding block structure — each reflection pair
  contributes a count in an interval of length exactly 1, so `n<=|U|/2` unit
  ranges is correct; the un-paired iid control fails pair exclusion, so the
  pairing is load-bearing.
- Scope test for an accidental joint input: none found. The retained scalar
  data are exactly the fiber masses; no two-point constraint enters covertly.

**Falsifier 1 fired — "Find a fixed point of reflection in the even
`W`-coprime universe."** The note's claim that `U` has no fixed point is
false, and its stated reason ("`a=N/2` is not a unit modulo the even `W`") is
invalid: evenness of `W` gives `2|N/2` only when `4|N`. Smallest witness
`W=2`, `N=6`, `a=3`; 99 witnesses among the 1,095 admissible `(W,N)` with
`N<=400`, and every one has the shape `W=2`, `N=2 (mod 4)`. Repair (Lemma 3.0
in the note, verified exactly): `tau_N` is fixed-point-free on `U` iff
`gcd(N/2,W)>1`, iff not (`W=2` and `N=2 (mod 4)`).

The carve-out is necessary rather than cosmetic. On the exceptional `(W,N)`
the two conclusions of Proposition 3 are mutually exclusive: matching the
one-point marginal on `B={N/2}` forces `Pr(N/2 in A)=theta>0` and hence a
nonzero diagonal pair count, while forcing zero pairs breaks that marginal.
The reason is mathematical — `a=N/2` is the diagonal representation
`N=(N/2)+(N/2)`, which genuinely *is* decided by the one-point test "`N/2` is
prime". The honest no-go is therefore about *off-diagonal* pairs, with the
diagonal disposed of separately (and vacuously under Proposition 1's
exception hypothesis). Every `W`-trick modulus `prod_{p<=z}p`, `z>=3`,
satisfies `gcd(N/2,W)>1`, so the intended application is untouched.

**Falsifier 2 fired (packet text, not the mathematics).** See the audit
correction below.

**2026-08-12 audit correction (non-authoritative; historical `Exact
statement` and `statement_hash` intentionally preserved).** The registered
statement says the strongest Hall/entropy contradiction is exactly
`sum_q C_q < sum_q s_q`. That is inexact for real capacities, because the
`s_q` are nonnegative *integers*: with `C=(3/2,3/2)` and `|S|=3` one has
`sum_q C_q = 3 >= |S|`, so the registered line reports no contradiction, yet
`s_1,s_2<=1` forces `sum_q s_q <= 2 < 3` and the integer box-simplex is
empty. The correct criterion, which the source note does prove, is
`sum_q floor(C_q) < |S|`. This strengthens the no-go rather than weakening
it, so no successor packet is required; the statement is retained as
provenance and a successor must quote note equation (2.4). The registered
statement should additionally be read with Lemma 3.0's hypothesis
`gcd(N/2,W)>1` in place of the unrestricted "when an even `W` divides `N`".

Still open for a further breaker: an independent derivation of the entropy
identity (2.1) from a different decomposition, and the successor-seed
question of whether adjacent Buchstab levels admit a prime-specific residual.

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
- 2026-08-12: cross-lineage breaker audit by opus-mira (Claude Opus 5).
  CONFIRMED-WITH-CORRECTION. Prop 1, Thm 2 (floored form), and the Prop 3
  concentration structure survive exact replay; the reflection fixed-point
  falsifier and the packet's un-floored capacity criterion both fired and are
  repaired in `notes/LEAST_FACTOR_REFLECTION_TRANSPORT.md` (Lemma 3.0,
  Remark 2.1, Remark 3.4). No successor packet needed: both corrections
  narrow hypotheses or strengthen the conclusion, and the route-killing yield
  (F29) is unchanged.
