# Conjunctive proof support is exactly the boundary of submodularity

## Exact observable

In a finite AND/OR derivation hypergraph, fix one derivable nonseed fact `v`.
Let `A(v)` be the inclusion-minimal nonempty rule-name supports of its finite
proofs, as in `REVISION_DERIVATION_HYPERGRAPH`.  For a retained rule set `S`,
define the replayability observable

`q_v(S) = 1  iff  some A in A(v) satisfies A subset S`.

This is the formation-side dual of the deletion law: deleted rules kill `v`
iff they hit every minimal support; retained rules replay `v` iff they contain
one complete minimal support.

## Theorem (exact complementarity boundary)

The monotone Boolean function `q_v` is submodular if and only if every minimal
proof support of `v` has cardinality one.

### Proof

If every minimal support is a singleton, let `U` be the set of rules that
individually prove `v`.  Then `q_v(S)=1[S intersects U]`, the rank-one coverage
function.  Its marginal is one only before any member of `U` has been retained,
so it has diminishing returns.

Conversely suppose `A` is a minimal support with `|A|>=2`.  Choose `r in A`
and put `B=A\{r}`.  Minimality of `A` implies `q_v(B)=0`.  It also implies
`q_v({r})=0`, since a singleton support `{r}` would be a strict subset of `A`.
But `q_v(A)=1` and `q_v(empty)=0`.  Hence

`q_v(B)+q_v({r}) = 0 < 1 = q_v(A)+q_v(empty)`,

which violates the submodular inequality. ∎

Thus alternative proofs (OR) do not themselves destroy diminishing returns:
several singleton proofs remain a coverage observable.  A genuinely
conjunctive support (AND) is exactly what produces increasing returns.

## One-shot arithmetic formation event

Take seed `1` and two named addition rules

```text
r2: 1 + 1 -> 2
r3: 2 + 1 -> 3.
```

The unique minimal support for `3` is `{r2,r3}`.  Retaining neither rule or
`r3` alone leaves only `1`; retaining `r2` alone replays `2`; retaining both
replays `3`.  Therefore the marginal capability of retaining `r3` is zero
from the empty cache and one after `r2` has been retained.  The first action
changes the value of the next action, and the second action forms the new
transferable observable `3` in one shot.

This is not merely a numerical pattern.  Least-fixed-point closure executes
the rules, and the theorem proves why the increasing return occurs.

Replay:

```sh
cd machinery
python3 proof_support_complementarity.py
python3 -m unittest test_proof_support_complementarity -v
```

The exhaustive three-rule antichain check is a falsifier for the
implementation, not the proof.

## What changes at the frontier

The preceding tree results split by retained-object type:

1. freely usable retained values give a monotone submodular maximum-depth
   observable;
2. complete unique-parent proofs impose ancestor closure and telescope value
   to a modular sum, making greedy exact;
3. selectable pieces of conjunctive proof support create complementarity and
   can violate submodularity at two rules.

This is the exact obstruction requested after `ANCESTOR_CLOSED_CACHE_FORMATION`.
It also refines temporal nesting: multiplicative or accelerating benefit is
not inferred from the number of stages; it begins at the first minimal support
whose rules must jointly be present.

## Scope limits

The iff concerns the Boolean replayability of one fixed nonseed fact as a
function of retained **rule names**.  It assumes finite positive-premise proof
systems and exact minimal supports.  Seeds have the empty support and constant
observable; they are excluded from the normalized statement.  Weighted sums
over several facts can mix positive and negative submodularity defects, so the
single-fact criterion is sufficient but not asserted necessary for a whole
system objective.  Support antichains may be exponentially large; the theorem
does not make their enumeration cheap.
