# Exact deletion in a finite derivation hypergraph

## The common object

Let `V` be a finite set of facts, `I⊆V` the retained seeds, and `R` a finite
set of named rules

\[
r:P_r\longrightarrow c_r,
\]

where the finite premise set `P_r⊆V` is conjunctive. Multiple rules with the
same conclusion are alternatives. This is an AND/OR hypergraph: premises are
AND; incoming rules are OR. Naming grammars, multi-premise proofs, cached
constructions, and distinguishing-certificate alternatives all instantiate
this object without becoming identical in meaning.

For `D⊆R`, let `Cl_D(I)` be the least set containing `I` and closed under
rules outside `D`.

## Minimal counterexample to single-parent provenance

Take seed `s` and rules

```text
direct:  s -> x
detour1: s -> y
detour2: y -> x.
```

A stored parent `direct` declares `x` invalid when `direct` is deleted, but
`detour1,detour2` still derive `x`. Three facts and three nonparallel rules are
minimal for a direct proof and a genuinely longer alternative. (If parallel
rules are admitted, two rules `s->x` give the degenerate two-fact example.)

## Derivation supports

A finite proof tree for `v` has leaves in `I`; its **support** is the set of
rule names appearing in it. Let `A(v)` be the inclusion-minimal supports of
all such proof trees.

**Theorem (exact deletion law).** For every finite rule system, including
cyclic ones, and every `D⊆R`,

\[
v\in Cl_D(I)
\quad\Longleftrightarrow\quad
\exists S\in A(v)\text{ with }S\cap D=\varnothing.       \tag{1}
\]

Equivalently, `v` is lost precisely when `D` is a hitting set of its minimal
support antichain `A(v)`.

**Proof.** If a support `S` avoids `D`, its proof tree uses only remaining
rules, so induction up the tree puts `v` in `Cl_D(I)`. Conversely compute the
least fixed point in rounds. A seed has the empty proof. If `v` first enters
at round `n+1`, some remaining rule concludes `v` and all its premises entered
by round `n`; adjoining that rule to their finite proof trees gives a proof of
`v` avoiding `D`. Its finite support contains an inclusion-minimal support,
also avoiding `D`. Cycles cause no exception: a fact entering a least fixed
point always has a finite first-entry round, while an unsupported cycle never
enters. □

## Support recursion and its cost

Initialize `A(i)={{}}` for seeds. For each rule, form every union

\[
\{r\}\cup\bigcup_{p\in P_r}S_p,
\qquad S_p\in A(p),                                    \tag{2}
\]

add these to the conclusion, and discard strict supersets until stable.
Equation (2) is AND-product followed by OR-union and antichain minimization.
It is exact, including with cycles, because the stable family is precisely the
minimal finite proof supports.

This representation can be exponentially large. The theorem does not claim
that enumerating all minimal supports is the best deletion algorithm. For one
actual deletion, recomputing the Boolean least fixed point of remaining rules
is linear in the explicit incidence size with standard counters/queues. The
antichain is valuable when many counterfactual deletions or exact provenance
queries justify its cost.

## What changes future motion

A single-parent forest stores one executable proof. The support antichain
stores the exact revision predicate. On deletion, it separates three events:

1. the chosen proof dies;
2. every shortest proof dies but a longer proof survives;
3. every proof dies and the fact leaves the least fixed point.

These grades were previously conflated. Naming-rule withdrawal and witness
withdrawal share equation (1), while retaining their different facts, rules,
and operational costs.

## Replay and rigor boundary

Run:

```sh
cd machinery
python3 -m unittest test_revisable_derivation_hypergraph.py -v
```

Tests include the minimal over-invalidation example, an AND-premise rule, an
unsupported cycle, and exhaustive comparison of support evaluation with fresh
least-fixed-point recomputation for all `2^6` rule deletions in a cyclic
system. Computation checks the implementation; the proof above establishes
(1). Dynamic rule creation, negated premises, costs, probabilities, and
infinite derivations are outside scope.
