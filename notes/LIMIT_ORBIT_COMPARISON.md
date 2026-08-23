# When orbit quotient commutes with compatible sections

Let a group `G` act on every set in a finite diagram `X`, and let every
restriction map be equivariant. There is a canonical comparison

```text
c : (lim X)/G -> lim (X/G),
```

where `G` acts diagonally on compatible families and `X/G` means the
objectwise orbit-set diagram. Equivariance is exactly what makes each
restriction map descend to orbit sets, so the quotient diagram is
well-defined.

The map need not be injective or surjective. These failures are different.

## Exact criterion

Write a compatible family as `x=(x_i)`. Then:

- `c` is injective iff whenever two compatible families `x,y` satisfy
  `y_i=g_i.x_i` locally for some possibly different `g_i`, there is one
  `g in G` with `y_i=g.x_i` for every `i`.
- `c` is surjective iff every objectwise orbit family compatible in the
  quotient diagram admits representatives which are compatible in the
  original diagram.

This is immediate from the definition of the two limits and the diagonal
orbit map, but it names the exact residual: injectivity is **global alignment
of local phases**; surjectivity is **existence of compatible
representatives**.

## Two smallest failures

Take the regular action of `C2` on `{0,1}`.

First use the connected span diagram

```text
X -> * <- Y
```

with `X=Y=C2`. Its limit is `X x Y`. The diagonal action has two orbits,
classified by relative phase:

```text
{(0,0),(1,1)}  and  {(0,1),(1,0)}.
```

Both map to the unique element of `(X/G) x (Y/G)`. Thus `c` is not
injective. Objectwise quotient erased the relative alignment between two
local sections.

Second take the equalizer of the two equivariant maps

```text
id, flip : C2 -> C2.
```

Their raw equalizer is empty. After orbit quotient, source and target are
singletons and the induced maps are equal, so the quotient equalizer has one
element. Thus `c` is not surjective. Quotienting made a square commute by
identifying its discrepancy, but supplied no coherent representative.

The first failure already occurs for a connected indexing category; mere
connectedness is insufficient. The second is the finite one-loop form of a
descent obstruction.

## Two sufficient conditions

**Injectivity.** Suppose the underlying undirected indexing graph is connected
and every `G`-action in the diagram is free. If `y_i=g_i.x_i` and `i->j` is
an arrow, compatibility and equivariance give

```text
g_i.x_j = g_i.f(x_i) = f(y_i) = y_j = g_j.x_j.
```

Freeness implies `g_i=g_j`. Connectedness propagates this equality, so all
local phases are one diagonal `g`; hence `c` is injective. The span
counterexample shows why freeness at a terminal object matters: its singleton
action is not free.

**Surjectivity.** Suppose the indexing diagram is a rooted outward tree:
every non-root object has exactly one incoming generating arrow, and there
are no additional relations. Choose any representative of the root orbit and
propagate it along the unique paths. Equivariance ensures each propagated
value lies in the prescribed target orbit. The resulting family is compatible,
so `c` is surjective. The equalizer counterexample shows why adding a second
parallel constraint can destroy this property.

These conditions are sufficient, not necessary. The exact criteria above are
the boundary.

## Relation to the preceding descent theorem

`HOLONOMY_DESCENT.md` concerns one consumer: a function descends through an
orbit quotient exactly when it equalizes the action arrows. The comparison
here concerns several local producers and a limit. Applying the earlier
coequalizer objectwise is legitimate, but a limit asks for simultaneous
representatives. The comparison map measures precisely what the exchange of
these operations loses.

Replay:

```text
python3 machinery/limit_orbit_comparison.py
python3 -m unittest machinery/test_limit_orbit_comparison.py
```
