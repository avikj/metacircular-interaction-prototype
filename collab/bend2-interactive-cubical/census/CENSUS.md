# The corpus's own behavioral quotient, computed by evaluation

`Meaning = X / FutureEq` — proven total, `--safe`, in the corpus
(`FutureBehavior`, `CorpusPresentation`, `CorpusBehavioralMeaning`), where
Agda can only *assert* the quotient exists and OOMs (~13 GB) trying to
compute it. Here the same quotient is a **value**: run by evaluation on the
HVM interaction-net runtime, over the corpus's own reflected theorem-types.

This is the corpus used for its own ends — its coinductive behavioral-meaning
construction, made effective on the optimal parallel runtime it was ported to.

## The machine (exactly the corpus's `FutureBehavior`)

For a reflected type `Term`:

| corpus notion | here |
|---|---|
| state `X` | `Shape` — a node's `headCode` and the shapes of its children |
| action `A` | a child address `Nat` |
| `step`  = `ReflectedFormation.child` | `childAt` — nth child, **self-loop** on out-of-range (`nth … fallback = self`) |
| `observe` = `ReflectedFormation.headCode` | `obs` — the outermost syntactic constructor (0..9) |
| `FutureEq x y` = `∀ w. observe(run x w) ≡ observe(run y w)` | `bisimD` (exact bisimulation) / `shapeEq` (structural) |

`FutureEq` is genuine **bisimulation**, coarser than structural equality: the
out-of-range self-loop means `N(5,[])` and `N(5,[N(5,[])])` observe `5` on
every word, so they are FutureEq though structurally distinct. `census.bend`
validates exactly this (`bisimD(leaf5, self5) = True`, `≠ mixed5`).

## The run

- **Data**: `CensusEmitBig.agda` reflects **159 real declarations across 17
  corpus modules** (number, logic, order, automata, lattices, cost) — their
  elaborated type `Term`s serialized to bend `Shape` literals
  (`corpus_shapes.txt`) by a `getType`-driven macro.
- **Compute**: `census.bend` implements the machine and partitions the shapes
  by `FutureEq`. Compiled to HVM (`census_corpus.hvm`) and run on the HVM3
  interaction-net runtime.

### Result — 159 reflected theorem-types → **91 FutureEq classes**

A 43% behavioral collapse. Cross-checked two independent ways that agree
exactly (91 = 91):

1. **HVM** (`hvm run census_corpus.hvm`) — the interaction-net evaluation.
2. An independent structural canonicaliser (`census_result.json`).

On this data the structural quotient **equals** the exact bisimulation
quotient (validated: `bisimD` at depth 6 also returns 91) — no self-loop
coarsening occurs among real type signatures, so the fast structural census
*is* the FutureEq census here.

Class-size histogram (size : #classes):

    22:1   13:1   10:1   8:1   4:2   3:2   2:9   1:74

### Named behavioral-equivalence classes (the collisions the corpus's own quotient makes)

- **[8]** `turn0 ≡ turn1 ≡ … ≡ turn7` — eight automaton states, one behavioral type-shape.
- **[3]** `peel ≡ askBool ≡ pow`, and **[2]** `peel-step ≡ ask-step`
  (`(a b:ℕ) → f(suc a)(suc b) ≡ f a b`, two differently-named theorems).
- Cross-module identifications: `Vec ≡ Coprimes`, `BezN ≡ NontrivialFactor`,
  `gcd-3-15 ≡ one-gives-back-N`, `notOne15 ≡ notMinusOne15`, …
- Large skeleton classes of size 22 / 13 / 10 gathering all maps / all
  `Set`-valued families / all propositional fibres of a shared arity.

The full assignment (every name → class) is in `census_result.json`.

## Reproduce

    # 1. reflect corpus types -> bend shapes  (Agda 2.8.0 + cubical v0.9)
    agda formal/cubical/CensusEmitBig.agda    # stderr carries BEND_SHAPES

    # 2. partition by FutureEq on the interaction-net runtime
    bend census/census_corpus.bend --to-hvm > census/census_corpus.hvm
    hvm run census/census_corpus.hvm          # the class assignment

`census.bend` is standalone (self-validating on the leaf5/self5/mixed5
probe); `census_corpus.bend` is it plus the reflected corpus data and the
partition `main`.

## Why this is the point

The corpus proves its behavioral quotient is total, effective, and terminal —
but the proof is a *description* an `--safe` checker cannot run. Compiling the
same `child`/`headCode`/`FutureEq` onto interaction nets turns the description
into a computation: the corpus reads its own theorems' behavioral structure by
evaluating itself, on a runtime where the work is Lévy-optimal and parallel.
That is the instrument computing its own meaning — not a proof about it.
