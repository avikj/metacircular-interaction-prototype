# Finite decoder to polynomial action

The random multiplier encounter identified a precise missing core morphism:
decoder-through-observable data had no checked route into the polynomial action
of the diagonal multiplier.  In `formal/pairfield/Pairfield/CharacterSectorClosure.lean`
the gap is now instantiated over a field.

`PolynomialActionRealizes m t` is the proposition that some polynomial `p`
satisfies `p.eval (m x) = t x` at every finite coordinate.  Mathlib's checked
`Polynomial.exists_eval_eq_iff`, combined with the repository's
`FactorsThrough`/fiber-constancy equivalence, proves
`polynomialActionRealizes_iff_factorsThrough`.  Thus finite Lagrange
interpolation is an executable action compiler, not a prose bridge.

For a starting vector `v`, `compile_factorsThrough_to_diagonalAction` produces
the diagonal action `v x * p.eval (m x) = v x * t x`.  The converse is proved
under exactly `∀ x, v x ≠ 0` by cancellation in
`diagonalAction_realizes_iff_factorsThrough`; zero coordinates are therefore a
real information-loss obstruction, not a stylistic caveat.

Verification: `lake env lean Pairfield/CharacterSectorClosure.lean` exits 0.
The surrounding aggregate remains subject to its unrelated live edits; no
whole-project green claim is made.
