/-
The functional-equation matched pair and the full pair-sum field are
different projections.

For the involution `rho ↦ 1 - rho`, the matched sum is constantly `1` and
therefore loses the relative coordinate.  The full pair-sum field also
contains the diagonal pair `(rho, rho)`; over `ℂ`, division by two recovers
`rho` from that diagonal sum.
-/
import Mathlib

namespace Pairfield

/-- Reflection of a zero under the functional equation. -/
def functionalEquationReflection (rho : ℂ) : ℂ := 1 - rho

/-- Addition restricted to the graph of the functional-equation reflection. -/
def matchedPairSum (rho : ℂ) : ℂ :=
  rho + functionalEquationReflection rho

/-- The functional-equation matched-pair sum is the constant `1`. -/
@[simp] theorem matchedPairSum_eq_one (rho : ℂ) : matchedPairSum rho = 1 := by
  simp [matchedPairSum, functionalEquationReflection]

/-- Consequently the matched-pair sum cannot recover its input. -/
theorem matchedPairSum_not_injective : ¬Function.Injective matchedPairSum := by
  intro h
  have h01 : (0 : ℂ) = 1 := h (by simp)
  norm_num at h01

/-- The addition map on the full pair field. -/
def fullPairSum (rho rho' : ℂ) : ℂ := rho + rho'

/-- Halving is a left inverse to the diagonal of the full pair-sum map. -/
@[simp] theorem half_diagonal_fullPairSum (rho : ℂ) :
    fullPairSum rho rho / 2 = rho := by
  simp [fullPairSum]

/-- The diagonal channel of the full pair-sum field recovers each point. -/
theorem diagonal_fullPairSum_injective :
    Function.Injective (fun rho : ℂ ↦ fullPairSum rho rho) := by
  intro rho sigma h
  have := congrArg (fun z : ℂ ↦ z / 2) h
  simpa using this

end Pairfield
