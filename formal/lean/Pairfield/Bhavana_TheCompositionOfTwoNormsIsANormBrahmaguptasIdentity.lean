/-
  भावना · bhāvanā — "the composition (of two forms)".

  Source: Brahmagupta, Brāhmasphuṭasiddhānta, chapter 18 (Kuṭṭakādhyāya /
  Vargaprakṛti), 628 CE. Brahmagupta states the composition law (samāsa- and
  antara-bhāvanā) by which two solutions of x² − N y² = k compose into a third,
  resting on the identity that the norm of ℤ[√−N] (equivalently the form
  a² + N b²) is multiplicative. This is the engine beneath the vargaprakṛti /
  cakravāla treatment of what is now miscalled "Pell's equation".

  Scope of the claim. CLAIMED of the source: the composition law / bhāvanā —
  that two "norms" a² + N b² and c² + N d² compose into a single norm, in both
  the additive (samāsa) and subtractive (antara) signs. NOT claimed of the
  source: the statement over a general commutative ring, and the `ring`-checked
  Lean proof below — those are ours, a substrate the identity is verified in,
  not a contribution attributed to Brahmagupta.
-/

import Mathlib

namespace Pairfield.BhavanaLean

variable (R : Type*) [CommRing R] (N a b c d : R)

/-- Samāsa-bhāvanā (the "same sign" composition): the product of two norms
    `a² + N b²` and `c² + N d²` is itself a norm. -/
theorem bhavana_samasa :
    (a ^ 2 + N * b ^ 2) * (c ^ 2 + N * d ^ 2)
      = (a * c + N * b * d) ^ 2 + N * (a * d - b * c) ^ 2 := by
  ring

/-- Antara-bhāvanā (the "other sign" companion): the same product expressed
    with the conjugate cross-terms. -/
theorem bhavana_antara :
    (a ^ 2 + N * b ^ 2) * (c ^ 2 + N * d ^ 2)
      = (a * c - N * b * d) ^ 2 + N * (a * d + b * c) ^ 2 := by
  ring

end Pairfield.BhavanaLean
