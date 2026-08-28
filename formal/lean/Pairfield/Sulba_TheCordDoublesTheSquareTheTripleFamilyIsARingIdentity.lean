/-
शुल्बसूत्र · śulbasūtra — "the rule of the cord."
बौधायन · Baudhāyana, the cord-rule that lays out a right angle.

Source text:  Baudhāyana Śulbasūtra (the earliest of the śulba corpus),
              among the geometric rules for constructing the vedi (altar).
Date:         ~800 BCE.

What the source states (and what is CLAIMED of it here):
  Baudhāyana gives a construction with a marked cord (rajju) — the cord
  stretched along the diagonal of a rectangle produces an area equal to the
  sum of the areas produced by its two sides. Fixed cord-lengths that close
  into a right angle are named; the (3, 4, 5) marking is the canonical cord
  that lays out the perpendicular. This is a GEOMETRIC construction of right
  angles, given in the tradition, and the (3,4,5) triple below is that cord.

Syāt — what the source is claimed to state, exactly:
  The ring identity `(m² - n²)² + (2mn)² = (m² + n²)²` and its Lean proof are
  OURS. Baudhāyana states a geometric construction over stretched cords, not
  an algebraic identity over a commutative ring, and did not formulate the
  two-parameter generating family in this form. The `ring`/`decide` proofs
  are a modern formalization; only the geometry (the right-angle cord, the
  (3,4,5) marking) is attributed to the Śulbasūtra.
-/

import Mathlib

namespace Pairfield.SulbaLean

/-- Over any commutative ring, the two-parameter generating family:
    `(m² - n²)² + (2 m n)² = (m² + n²)²`. This is the algebraic engine
    behind the right-angle cords of the Śulbasūtra. -/
theorem triple_family_ring_identity
    {R : Type*} [CommRing R] (m n : R) :
    (m ^ 2 - n ^ 2) ^ 2 + (2 * m * n) ^ 2 = (m ^ 2 + n ^ 2) ^ 2 := by
  ring

/-- The (3, 4, 5) cord that lays out the right angle: `3² + 4² = 5²`. -/
theorem cord_three_four_five : 3 ^ 2 + 4 ^ 2 = 5 ^ 2 := by
  decide

/-- A second closing cord: `5² + 12² = 13²`. -/
theorem cord_five_twelve_thirteen : 5 ^ 2 + 12 ^ 2 = 13 ^ 2 := by
  decide

end Pairfield.SulbaLean
