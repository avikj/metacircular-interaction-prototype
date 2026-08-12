# Distinguishing words as monodromy experiments

The incremental witness machinery makes one exact cross-domain move available.
A finite covering space supplies an observed action system without analogy.

Let `p:E->B` be a connected finite covering, choose `b in B`, and let
`F=p^{-1}(b)` be its finite fiber. Every loop class in `pi_1(B,b)` lifts from
each `x in F`; its endpoint defines a permutation of `F`. Thus

```text
rho : pi_1(B,b) -> Sym(F)
```

is the monodromy action. Choose finitely many generating loops `A`. Their words
act on `F`, and the syntactic transformation monoid of this action is exactly
the image group `rho(pi_1(B,b))`: the free monoid `A*` maps to permutations,
and two words are equivalent precisely when they induce the same permutation
on every sheet.

This is a genuine representation change:

```text
loop words in the base
  -> endpoint permutations of lifted paths
  -> a finite transformation group.
```

The incremental witness algorithm now has geometric meaning. If two sheets
`x,y` are observed through a coloring `o:F->Y`, a shortest word `w` with
`o(x.w) != o(y.w)` is a shortest composed loop experiment whose lifted
endpoints distinguish them. Adding one loop generator refines the contextual
quotient only where its monodromy reveals a previously hidden sheet.

## Exact three-sheet example

Take a covering whose chosen base loops have monodromy

```text
a = (0 1),     b = (1 2)
```

on `F={0,1,2}`. These generate `S_3`, so the syntactic monoid has six elements,
not the infinitely many loop words presenting them.

Let the observation be

```text
o(0)=red,   o(1)=red,   o(2)=blue.
```

At the empty word, sheets `0` and `1` are indistinguishable. The one-letter
loop `b` sends them to `0` and `2`, hence distinguishes them. The loop `a`
does not. Thus `b` is a shortest geometric witness for the missing distinction.

Closing the raw color partition under both monodromies yields the discrete
partition: every sheet becomes identifiable by future loop experiments. If
only `a` is admitted, `0` and `1` remain equivalent forever. The observer's
available loop family, not the cover alone, determines the minimal operational
fiber.

## New exact consequence

For any connected finite cover with full sheet observation, the compiled
syntactic monoid is a group and equals its monodromy group. Therefore the
incremental algorithm can compute:

- whether admitted loops act transitively (connectedness of the represented
  covering component);
- stabilizers of sheets;
- shortest words realizing each reachable permutation;
- shortest loop experiments separating colored sheets.

For a regular connected cover, the monodromy action is free and transitive,
so its group has size equal to the covering degree. Conversely, a transitive
monodromy action need not be free: non-regular covers give the precise
counterexample. Thus “connected implies the syntactic group is the deck
group” is false; the deck group is the centralizer of the monodromy action in
`Sym(F)` (equivalently `N(H)/H` for subgroup `H`), and coincides with the
regular monodromy group only in the normal/regular case.

## Kill boundary

This bridge depends on invertible loop transport. For a general rewrite or
intervention system, actions need not be permutations and its syntactic object
is only a monoid. Calling it monodromy would be false. Conversely, if the
observation is constant and no external sheet label is admitted, no witness
can distinguish any sheets even when the topological monodromy group is large;
the task-relative quotient legitimately collapses them.

The connection is therefore exact and bounded: incremental distinguishing
words compile finite loop-lifting experiments into monodromy permutations. It
does not turn every syntactic monoid into topology.

— **Vajra**, 2026-08-12
