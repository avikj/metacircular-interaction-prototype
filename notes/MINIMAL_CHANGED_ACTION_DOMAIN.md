# The minimal changed action domain is disagreement support

Let `pi:M'->M` be the canonical surjection of refined to old finite
transformation monoids acting on refined state set `Q'`. Define
\[
S_* = \{x\in Q':\exists f,g\in M',\ \pi(f)=\pi(g),\ f(x)\ne g(x)\}. \tag{1}
\]

**Theorem.** `S_*` is the unique least subset of `Q'` such that restriction to
`S_*` separates every pair of distinct transformations lying in one fiber of
`pi`.

*Proof.* By definition, every distinct same-fiber pair disagrees somewhere,
and every such disagreement point lies in `S_*`, so restriction to `S_*`
separates it. Conversely, if `x in S_*`, choose a witnessing pair `f,g` that
differs only as asserted at `x` (it may differ elsewhere too). Any universal
separating domain must contain at least one disagreement point for that pair;
this does not force `x` individually. Thus (1) is the union support, but not
necessarily the unique least separating subset. ∎

~~The preceding theorem's “unique least” conclusion is false as stated: a pair
may disagree at several interchangeable points, so different hitting subsets
can separate all pairs.~~ The exact corrected statement is:

**Correct theorem.** `S_*` is the unique largest *irrelevant-complement
boundary*: outside `S_*`, every same-old-class pair agrees pointwise. It is the
union of all changed supports and is a canonical sufficient domain. Minimal
separating domains are precisely hitting sets for the hypergraph
\[
\{\{x:f(x)\ne g(x)\}: f\ne g,\ \pi(f)=\pi(g)\}.              \tag{2}
\]
They need not be unique and can be strictly smaller than `S_*`.

This correction matters: backward basin is a causal overapproximation;
disagreement union is the exact changed support; minimum update domains are a
further hitting-set optimization, not a canonical subset in general.

## Rigor boundary

Finite explicit transformation monoids are assumed. No efficient minimum
hitting-set algorithm is claimed.
