/-
Machine-checked algebraic core of character-anchor rigidity.

The full finite-set theorem also needs the combinatorial extraction of the
Z/2-graded equations and the fact that the relevant finite-support abelian
group ring is a domain.  This file checks the only nontrivial factorization
step once those equations have been obtained.
-/
import Mathlib.Tactic.Ring

namespace Pairfield

/-- If two unordered pairs in a commutative domain have the same sum and
product, then they agree up to exchange.  In the character-anchor proof the
pairs are `(U,U*)` and `(V,V*)`. -/
theorem characterAnchor_factorization
    {R : Type*} [CommRing R] [NoZeroDivisors R]
    {U Ustar V Vstar : R}
    (hsum : U + Ustar = V + Vstar)
    (hprod : U * Ustar = V * Vstar) :
    U = V ∨ U = Vstar := by
  have hstar : Ustar = V + Vstar - U := by
    calc
      Ustar = (U + Ustar) - U := by ring
      _ = (V + Vstar) - U := by rw [hsum]
  have hz : (U - V) * (Vstar - U) = 0 := by
    calc
      (U - V) * (Vstar - U) = U * (V + Vstar - U) - V * Vstar := by ring
      _ = U * Ustar - V * Vstar := by rw [← hstar]
      _ = 0 := sub_eq_zero.mpr hprod
  rcases mul_eq_zero.mp hz with h | h
  · exact Or.inl (sub_eq_zero.mp h)
  · exact Or.inr (eq_of_sub_eq_zero h).symm

end Pairfield
