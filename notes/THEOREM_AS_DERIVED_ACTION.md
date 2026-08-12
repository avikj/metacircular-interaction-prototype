# A theorem as a derived action

## Exact finite joint

Let a finite transformation monoid `M` act on a finite state set `Q`, generated
by actions `G={g_i}` with nonnegative access costs.  A word

```text
w = g_(i1) ... g_(ir)
```

induces an already existing transformation `m_w in M`.  Suppose the word has
been checked and install `m_w` as a new atomic generator of cost `c`, while
retaining `w` as its validation expansion.

Then:

1. the generated transformation monoid is unchanged;
2. the orbits and every task quotient defined by the action are unchanged;
3. validation cost remains the expanded cost of `w`;
4. access geometry changes by adding, for every `s in M`, the edge

   ```text
   s -> s m_w
   ```

   of cost `c` to the weighted right Cayley graph;
5. the new exact distance is the shortest-path metric after adjoining this
   entire context-indexed edge family. In general the macro may occur more
   than once in a shortest path, so neither a single rank-one update nor one
   pass over the family is sufficient.

## Proof

Since `m_w` is already the value of a word over `G`, adjoining it does not add
an endomap and therefore does not change `M`, its orbits, or its invariant
quotients. Every new Cayley edge has the displayed form, so exact all-pairs
shortest paths on the augmented finite graph give the new metric.

The stronger one-use formula is false. In the cyclic group of order five, let
`step` cost one and install `step^2` at cost one. The old cost of `step^4` is
four, while the new cost is two by using the macro twice. Every path using it
at most once costs at least three. Reusable action compilation is therefore an
iterative metric closure, unlike installation of one isolated directed proof
edge.

## Why this is the machine's central finite law

`CONTEXT_TRANSFORMATION_MONOID.md` constructs the effective algebra of linear
experiments acting on a contextual crystal.  `PROOF_METRIC_COMPILER.md` shows
that a checked path can become a cheaper atomic proof edge.  The theorem above
identifies their common motion:

```text
proved composite action
→ retain its checked expansion
→ install it as a new generator
→ preserve semantic closure
→ recompute the exact influence cone in the action metric.
```

Thus a theorem does not merely join a library.  When it denotes a reusable
operation, it enlarges the generating presentation without enlarging the
represented monoid.  What changes is which later transformations are cheaply
reachable.  This is an exact finite form of mathematics rewriting its own
future execution.

The cyclic three-state control makes the law visible.  A unit-cost step
generates a three-element group.  The checked composite `step;step` originally
costs two.  Installing it at cost one leaves the group unchanged and shortens
exactly three ordered routes, one from each current group context.

## Relation to Horn weakening

A derived Horn rule `U -> b` similarly acts in every partial premise context
`S superset U`.  It therefore compiles to a family

```text
S -> S union {b},
```

not one fixed edge.  The action-monoid and Horn formulas share the same reason:
reuse is contextual.  Fully closing every premise state under the original
theory would erase this access dynamic, since every closed `S` containing `U`
already contains `b`.

## Artifact and boundary

`machinery/action_metric.py` generates the finite monoid, validates the macro
word, builds the weighted Cayley graph, recomputes its exact distances, and
returns the strict influence cone. The tests include cyclic shortening, the
order-five counterexample to one-use relaxation, non-improving installation,
malformed actions, unknown expansions, and negative costs.

This finite theorem does not yet handle multi-premise proof DAGs, variable
binding, nonmonotone resource consumption, stochastic actions, or an evolving
state carrier.  It does identify the interface they must generalize: a checked
derived operation acts naturally over every admissible context, while its
installation changes access cost without silently changing semantics.
