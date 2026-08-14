# Compositional contexts compile to the future-behavior quotient

**Status:** machine-checked Cubical adapter for the binary-operation core of
`COMPOSITIONAL_CRYSTAL_THEOREM.md`; no novelty claim.

## Exact result

Let `X` carry a binary operation `operation : X → X → X` and an observation
`observe : X → O`.  Use the two elementary one-hole translations

```text
x ↦ operation x fixed
x ↦ operation fixed x
```

as the action alphabet.  A finite word in this alphabet is a generated unary
context.  The relation

```text
ContextEq x y := every generated unary context gives equal observations
```

is therefore definitionally the existing
`FutureBehavior.FutureEq (contextStep operation) observe x y`.

`formal/cubical/NaturalMachine/CompositionalContextAdapter.agda` first defines
the inductive one-hole grammar `OneHoleContext`, compiles it to translation
words, and proves `plug-compile`.  `syntactic-futureIso` then identifies
equality under every syntactic context with the existing `FutureEq` proof
space (for set-valued observations).  It checks the missing algebraic joint:

1. `contextEq-respects-operation`: `ContextEq` is stable under the original
   binary operation.  The proof changes the left input in a left-hole context,
   then the right input in a right-hole context, and composes the two future
   equalities.
2. `contextEq-isMagmaCongruence`: the relation is an equivalence, lies in the
   observation kernel, and is a magma congruence.
3. `magmaCongruence→contextEq`: every observation-compatible magma congruence
   is contained in it.  The adapter converts a magma congruence to the native
   `FutureBehavior.isBehavioralCongruence` interface, then reuses the already
   checked greatest-congruence theorem.
4. `ContextQuotient._opQ_`: the binary operation descends through Cubical's
   effective set quotient.  The two `SQ.rec2` obligations are discharged by
   the two one-hole actions; no quotient representative or choice principle is
   used.

For this binary fragment, items (1)–(3) of the finite compositional-crystal
theorem are thus one theorem already present in the Cubical library surface:
the Myhill–Nerode future quotient, instantiated at elementary translations.
The proof does not need finiteness.  Finiteness belongs to the algorithmic
partition-refinement and shortest-context claims, which are not formalized
here.

## Translation killed

The tempting shortcut

```text
quotient by ker(observe), then descend operation
```

is false.  The module includes a four-state control `Bool × Bool`.  Observation
reads the first bit, while

```text
leakingOperation left right = (hidden-left, visible-right).
```

The states `(false,false)` and `(false,true)` have the same current
observation, but one left-hole context exposes their hidden bits as distinct
observations.  Accordingly:

- `not-contextually-equal` rejects their `ContextEq`; and
- `now-kernel-not-magma-congruence` proves the raw observation kernel cannot
  inhabit the magma-congruence interface.

This is the exact form of the obstruction in the source note's engine law:
context closure is not an implementation refinement.  It is the hypothesis
that makes the quotient compositional.

## Operation-family refinement

The continuation in the same checked module separates intervention refinement
from observation refinement.

`futureEq-restrict-actions` proves a general action-reindexing theorem.  If a
large machine realizes every action of a small machine along an embedding,
then equality under all large-machine experiments implies equality under all
small-machine experiments.  The proof is an induction showing execution
commutes with reindexing words; it does not enumerate either alphabet.

For binary operations this specializes to `adding-operation-refines`:

```text
ContextEq under {old,new}  →  ContextEq under {old}.
```

The converse is false.  With the old operation equal to left projection, the
two control states remain indistinguishable under every old context.  Adding
`leakingOperation` exposes their hidden coordinate in one step.
`adding-operation-converse-fails` packages both closed terms.  Thus a claim
that two contextual quotients coincide needs equality of their generated
unary action clones (or another simulation in both directions), not merely a
comparison of raw operation lists.

## Scope and provenance

- **PROVED/CHECKED:** the one-hole syntax/word `Iso`, binary adapter,
  greatestness, quotient descent, action-reindexing monotonicity, strict
  operation-addition control, and the hostile observation-kernel
  counterexample.
- **SOURCE:** `notes/COMPOSITIONAL_CRYSTAL_THEOREM.md`, whose universal-
  algebraic/Myhill–Nerode theorem is explicitly classical and makes no novelty
  claim.
- **NOT CLAIMED:** a general finitary signature, dependent operations, binders,
  a finite partition-refinement algorithm, shortest separating contexts,
  contextual dimension, or Voevodsky initiality.
- **LIBRARY AUDIT:** the installed Cubical tree contains set quotients and the
  repository already contained `FutureBehavior`'s greatest behavioral
  congruence, but no located module stated this binary elementary-translation
  adapter.  This is a reuse/connection result, not evidence of literature
  novelty.

## Designed annihilation

The adapter is killed by any binary operation and observation for which the
two translations above do not generate the declared unary contexts, or by a
failure of `ContextEq` to respect the binary operation.  The first possibility
is excluded only for the binary term language declared here; it is why no
claim is made for binders or dependent operations.  The second is exactly what
`contextEq-respects-operation` checks.
