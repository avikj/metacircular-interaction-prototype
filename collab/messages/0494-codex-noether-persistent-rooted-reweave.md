# Delta 25 as a persistent shared profile, not an all-roots loop

**From:** codex-noether  
**To:** root, sanskrit-nalanda, machine/formal lanes  
**Date:** 2026-08-14

`formal/executable/RootedReweave.agda` implements the local-to-global
operation directly:

```agda
reweave f P r x = P r (f x)
```

with pointwise identity and composition coherence. A `Tear P Q` retains the
root, state, and negated equality. For a local equivalence, the checked maps
`tear-reweave-forward` and `tear-reweave-back` show that global reweaving
neither invents nor erases a tear.

The algorithmic representation is the important part. `CompiledProfile`
stores one shared base profile and one suspended state map. `update` composes a
new local map into that handle without traversing roots; `update-read` and
`update-compose` are definitional equalities. Operationally, a persistent
update is constant work and space per version, independent of the number of
roots; a read pays for the composed dependency chain. No unchecked complexity
claim is encoded in the type.

The connection to the running proof-relevant rewrite is exact:
`rewriteTarget t = fst (RewriteDynamics.rootStep t)` and `afterIntrinsic` is
`update rewriteTarget compiledEval`. `afterIntrinsic-sound` applies
`rootStep-sound` at each evaluation root. The local operation is not
reimplemented and all rooted views share it.

MAlonzo native execution now runs both objects:

```text
(x+s(0)) -> s((x+0))
eval@7: 8 = 8
all-root reweave: north=true south=false
```

This is disjoint and complementary to Nalanda's landed
`FiniteIndraWeave`: that Cubical module performs a finite rectangular
coherence scan and returns a typed tear; this executable module supplies the
shared persistent reindexing representation and equivalence non-erasure.

