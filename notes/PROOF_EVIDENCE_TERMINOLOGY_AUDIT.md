# Proof and executable evidence terminology audit

**Status:** repository terminology correction, scoped to authoritative notes,
formal interfaces, and the claims board.

## Distinctions

- A Python unit test is regression or falsification evidence.  Passing tests
  do not prove the universally quantified statement exercised by examples.
- An exact Python certificate is proof evidence only when a separately proved
  reduction makes certificate checking sufficient for the stated theorem and
  the trusted checker is named.
- An Arb result is a certified numerical enclosure.  It is not thereby a
  formal theorem.
- An Agda or Lean term accepted without holes or extra axioms is a
  kernel-checked judgment.  Semantic alignment with prose and novelty remain
  separate obligations.

## Audit result

The authoritative mathematical notes generally observe these distinctions:
they place proofs in prose or a proof assistant and describe Python tests as
replay, bounded checks, regressions, or falsifiers.  The audit found no
substantive theorem whose only stated proof was a passing Python unit-test
suite.

Two ambiguous surfaces were corrected:

1. `RATIONAL_FIBER_SPECTRUM.md` now calls Arb output a certified numerical
   enclosure rather than leaving “certifies” unqualified.
2. The claims board no longer couples the formal symmetry-action status to a
   Python test count.

## Complete replacement

`NaturalMachine.SymmetryArithmeticAction` contains the executable theorem that
fully replaces the former Python module `symmetry_arithmetic_action.py`:

```agda
identity-fixed-value : actObservation (idEquiv ℕ) successorRegister zero ≡ 1
swap-fixed-value : actObservation swap01-Equiv successorRegister zero ≡ 2
swap-transported-value :
  transportObservation swap01-Equiv successorRegister zero ≡ 1
```

Together with `permuteRegisters-comp` and
`transportObservation-invariant`, these terms contain every load-bearing
operation and boundary formerly illustrated in Python.  The Python
implementation and its tests were therefore removed rather than retained as a
second authority.

## Boundary

This audit does not downgrade exact certificate checkers whose completeness
reduction is proved, and it does not claim that proof-assistant acceptance
establishes intended meaning, empirical truth, or novelty.  “Executable” means
normalization of the checked term here, not that all downstream arithmetic has
been formalized.
