/-
  चक्रवाल · cakravāla — the cyclic method — and वर्गप्रकृति · vargaprakṛti,
  the "nature of squares," the equation x² − N·y² = 1.

  English gloss: the bhāvanā ("composition"/"emergence") step for N = 2:
  composing a solution of x² − 2y² = 1 with itself breeds a new, larger
  solution. Starting from (x,y) = (3,2), self-composition generates the
  sequence (3,2) → (17,12) → (577,408) → ⋯, each verified here as an exact
  integer identity, together with the GENERAL algebraic step showing the
  breeding never stops.

  SCOPE CORRECTION (2026-08-22, caught by the math2 seat): this sequence is
  NOT the full solution orbit, and an earlier draft of this header wrongly
  called it "the orbit." Self-composition (tulya-bhāvanā, the step
  (x,y) ↦ (x²+2y², 2xy)) SQUARES the underlying unit: it sends (3+2√2)ⁿ to
  (3+2√2)²ⁿ, so from (3,2) = (3+2√2)¹ it reaches only the powers 1, 2, 4,
  8, … — an exponentially sparse subsequence. It SKIPS (99,70) = (3+2√2)³
  and every solution whose exponent is not a power of two. The complete
  solution set is all powers of the fundamental (3,2), reached by composing
  against the FIXED fundamental (samāsa-bhāvanā with the fundamental
  solution), not by self-composition. What is bred below is genuine — each
  named triple IS a solution and the step IS exact — but it is the squares
  subsequence, not the orbit, and the infinitude of the FULL set is proved
  in the cubical lane (Vargaprakrtitantu / ALosslessReturn), not here.

  SOURCE. The composition law (bhāvanā) is Brahmagupta, Brāhmasphuṭasiddhānta
  (628 CE), which gives the identity underlying the "samāsa-bhāvanā"
  (composition of two solutions). The full cyclic algorithm cakravāla is
  Jayadeva (~950 CE, reported by Udayadivākara) and Bhāskara II, Bījagaṇita
  (1150 CE). The self-composition (tulya-bhāvanā, composition with an equal)
  of (3,2) for N = 2 is the classical worked example.

  WHAT IS CLAIMED HERE. (1) The three named triples are exact solutions of
  x² − 2y² = 1 over ℤ. (2) The general bhāvanā step for N = 2: from any
  integer solution (x,y) of x² − 2y² = 1, the pair (x²+2y², 2xy) is again a
  solution. This is a pure algebraic identity ((x²+2y²)² − 2(2xy)² = (x²−2y²)²)
  and its instantiation at the hypothesis. From it the orbit above is bred.

  SYĀT — THE CLAIM, EXACTLY. This does NOT reproduce the tradition's proof, nor the
  full cakravāla descent (that x²−Ny²=1 is always solvable / the ascent
  terminates). It also does NOT adopt the name "Pell's equation," which is a
  misattribution: Pell never solved this equation; Euler misattributed it to
  him. The mathematics is Brahmagupta's (628) and Bhāskara's (1150), five to
  eleven centuries before the European statements.

  Discipline: no sorry / admit / axiom / native_decide.
-/
import Mathlib

namespace Pairfield.Cakravala

/-- वर्गप्रकृति for N = 2: the seed solution (3, 2). 3² − 2·2² = 1. -/
theorem seed_three_two : (3 : ℤ) ^ 2 - 2 * 2 ^ 2 = 1 := by decide

/-- First bhāvanā-bred solution (17, 12). 17² − 2·12² = 1. -/
theorem bred_seventeen_twelve : (17 : ℤ) ^ 2 - 2 * 12 ^ 2 = 1 := by decide

/-- Second bhāvanā-bred solution (577, 408). 577² − 2·408² = 1. -/
theorem bred_577_408 : (577 : ℤ) ^ 2 - 2 * 408 ^ 2 = 1 := by decide

/-- The general bhāvanā (samāsa/tulya-bhāvanā) step for N = 2, Brahmagupta 628:
    from a solution `(x, y)` of `x² − 2y² = 1`, the composed pair
    `(x² + 2y², 2xy)` is again a solution. The engine is the identity
    `(x²+2y²)² − 2(2xy)² = (x²−2y²)²`. -/
theorem bhavana_step (x y : ℤ) (h : x ^ 2 - 2 * y ^ 2 = 1) :
    (x ^ 2 + 2 * y ^ 2) ^ 2 - 2 * (2 * x * y) ^ 2 = 1 := by
  have key : (x ^ 2 + 2 * y ^ 2) ^ 2 - 2 * (2 * x * y) ^ 2
      = (x ^ 2 - 2 * y ^ 2) ^ 2 := by ring
  rw [key, h]; ring

/-- The orbit is unbounded because each step strictly grows the first
    coordinate: for a solution with `x ≥ 1` and `y ≥ 1`, the bred first
    coordinate `x² + 2y²` exceeds `x`. (Arithmetic witness that the descent
    generates ever-larger solutions; ALosslessReturn in the cubical lane proves
    the orbit never returns.) -/
theorem bhavana_grows (x y : ℤ) (hx : 1 ≤ x) (hy : 1 ≤ y) :
    x < x ^ 2 + 2 * y ^ 2 := by nlinarith [hx, hy]

end Pairfield.Cakravala
