# Bounded binary-prefix retention is monotone submodular

Fix the left-to-right binary construction policy.  Its trace `P(t)` for a
positive target `t` starts at `1`; each edge is either `x -> 2x` or
`x -> 2x+1` and costs one addition.  Let a finite declared future carry
nonnegative integer weights `w_t`.  If `S` is a set of previously formed
integers retained at zero future acquisition cost, define

`F(S) = sum_t w_t max {i : P(t)[i] is in S union {1}}`.

Thus `F(S)` is exactly the weighted number of fixed-policy additions saved by
resuming each construction at its deepest retained prefix.

## Theorem (retention formation)

`F` is normalized, monotone, and submodular.  Consequently the cardinality
`B` greedy rule attains at least

`1 - (1 - 1/B)^B >= 1 - 1/e`

of the optimal saved work.  The selected retained support is a newly formed,
task-indexed observable: it compiles the declared future into changed marginal
construction costs.

### Proof

For one target write `d_t(x)=i` when `x=P(t)[i]`, and leave it undefined off
the path.  Its contribution is the maximum of the nonnegative singleton
scores `w_t d_t(x)` over `x in S`, with the root score zero.  If `A subset B`
and `x notin B`, its marginal contribution is

`max(0, w_t d_t(x) - F_t(A)) >= max(0, w_t d_t(x) - F_t(B))`.

So every target contribution has diminishing returns; summing preserves
normalization, monotonicity, and submodularity.

For completeness, if greedy has value `G_i` after `i` choices and the optimum
has value `O`, submodularity implies that one of the at most `B` optimal
elements has marginal at least `(O-G_i)/B`.  Hence
`O-G_(i+1) <= (1-1/B)(O-G_i)`, and iteration gives the displayed bound. ∎

## Exact tree correction

The earlier suspicion that two binary-prefix traces might diverge and later
reconverge was false.  The recorded addition trace has the unique-parent rule

- `parent(n)=n/2` for even `n>1`;
- `parent(n)=n-1` for odd `n>1`.

(The claim message incorrectly compressed doubling followed by increment into
one edge `x -> 2x+1`; the executable check exposed this.)  Iterating the
correct parent rule gives exactly `P(n)`, so equality of nodes forces equality
of their entire root paths.  Two target traces meet in exactly their common
initial segment.

This tree fact is stronger structural information than the submodularity
proof needs.  It does **not** by itself establish an exact polynomial budget
algorithm; that remains open here.

## Executable one-shot event

For equally weighted future targets `10,11,12,13` and retention budget two,
the executable greedy rule retains `{10,12}`.  Each choice saves eight
additions over its two-target branch, totaling `16`.  Exhaustive finite
optimization certifies `16` is optimal for this instance.

Replay:

```sh
cd machinery
python3 cache_retention.py
python3 -m unittest test_cache_retention -v
```

## Relation to the swarm no-go and scope

`WITNESS_FOREST_STORAGE_NO_GO` proves that changing shortest parents in a
canonical one-pointer witness forest cannot change node or pointer counts.
There is no contradiction: the present ground set is a collection of
already-formed arithmetic nodes that may be discarded or retained under a
budget, and the objective is future saved additions, not certificate size.

The theorem is exact only for a declared weighted target family, fixed binary
paths, free access to retained nodes, additive future demand, and a cardinality
budget.  It does not price acquisition, reversible memory, alternative
addition chains, withdrawals, or interactions between future targets.  A
numerical exhaustive optimizer is a checker for finite instances, not the
proof of submodularity or of the approximation bound.
