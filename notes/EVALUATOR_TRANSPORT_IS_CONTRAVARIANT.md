# Evaluator transport is contravariant, and conservation determines it

**Status:** exact standard theorem, checked in safe Cubical Agda. This note is
a bounded return from a literal random encounter with the archived
`ECOLOGY.md`; it does not reactivate that note's biological metaphor or build
order.

## 1. The sampled seam

`ECOLOGY.md` keeps candidate identity separate from evaluation:

```text
(candidate, environment, model, tasks, evaluator, result).
```

Its trust correction is sharper than the earlier transport proposal. A result
cannot be copied between presentations merely because they agree on a finite
test set, or because some untyped similarity has been asserted. Reuse requires
a checked equivalence and a verified law saying how the evaluator transforms.

The exact mathematical core does not require scores, probabilities, or a
population. Let `e : A ≃ B` be an equivalence and let `scoreA : A -> R` be an
evaluator, for an arbitrary result type `R`. Define the evaluator on `B` by
inverse precomposition:

```text
transportEvaluator e scoreA b = scoreA (e^-1 b).
```

The inverse direction is forced: candidates move forward by `e`, so evaluators
move contravariantly.

## 2. Conservation and uniqueness

Call `scoreB : B -> R` preserving when

```text
scoreB (e x) = scoreA x       for every x : A.
```

Two exact statements follow.

1. `transportEvaluator e scoreA` is preserving, because
   `e^-1 (e x) = x`.
2. It is the unique preserving evaluator. Given `b : B`, surjectivity writes
   it as `e (e^-1 b)`; preservation at `e^-1 b` then gives

   ```text
   scoreB b = scoreB (e (e^-1 b)) = scoreA (e^-1 b).
   ```

Thus the paired frame `(scoreA , x)` transports to

```text
(scoreA o e^-1 , e x),
```

and its result is conserved. The invariant belongs to the **pair**, not to the
candidate alone. In the sampled six-coordinate record this means that a
candidate-presentation change cannot silently retain the old evaluator field;
either the evaluator is transported with a checked law or a new observation is
being made.

## 3. What the theorem does not license

`NaturalMachine.SymmetryArithmeticAction` already checked the homogeneous
`A = B`, `R = Nat` moving-port instance. The new module makes the interface
heterogeneous, result-polymorphic, and proves uniqueness. It deliberately does
not claim that:

- finite observational agreement constructs an equivalence;
- an evaluator is sound, unbiased, or safe to self-modify;
- empirical measurements transport across changed environments, models, task
  sets, seeds, or resource policies; or
- a numerical discount repairs a missing invariance theorem.

Those coordinates remain part of the evaluation identity. The checked result
only says what happens after the relevant equivalence has been supplied.

## 4. Killer control and replay

Transporting only the candidate need not conserve a score. The module reuses
the existing checked `successorRegister`/`swap01-Equiv` control: the fixed
evaluator distinguishes identity from the swap. Therefore the simultaneous
transport premise is load-bearing, rather than notation around an invariant
candidate score.

The machine-checked terms are in
`formal/cubical/NaturalMachine/EvaluatorTransport.agda`:

- `transportEvaluator-preserves`;
- `transportEvaluator-unique`;
- `transportEvaluation-invariant`; and
- `fixed-evaluator-killer`.

Replay from `formal/cubical/`:

```text
LC_ALL=C.UTF-8 LANG=C.UTF-8 \
  agda --ignore-interfaces NaturalMachine/EvaluatorTransport.agda
```

Agda 2.8.0 exits successfully under `--cubical --guardedness --safe
--no-import-sorts`; the file contains no holes or postulates. It is standalone,
so no aggregate-green claim is made. This is standard transport of functions
along an equivalence; no novelty claim is made.
