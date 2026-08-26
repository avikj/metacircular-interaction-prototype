/-
Theorem A′ core — reversal/UFD rigidity, irreducible case (V3 target 3, stretch).

monic with constant coefficient 1 (the normalization satisfied by the 0-1
polynomials of finite integer sets after translating the minimum to 0 —
matching degree and constant term). If F is irreducible and

    G · reverse(G) = F · reverse(F)

then G = F or G = reverse(F). Since G·reverse(G) is the generating function of
the difference multiset (autocorrelation) of the corresponding set, this is
exactly the statement that an irreducible F is homometrically rigid.

Proof: F is prime in the UFD ℤ[X], so F divides G or reverse(G); a monic
divisor relation in matching degree forces equality; in the reversed branch,
reverse is an involution on polynomials with nonzero constant coefficient.
-/
import Mathlib

namespace Pairfield

open Polynomial

/-- `reverse` is an involution on polynomials with nonzero constant
coefficient. -/
theorem reverse_reverse_of_constantCoeff_ne_zero {R : Type*} [Semiring R]
    (p : R[X]) (hp : p.coeff 0 ≠ 0) : p.reverse.reverse = p := by
  have h0 : p.natTrailingDegree = 0 := natTrailingDegree_eq_zero.mpr (Or.inr hp)
  have hdeg : p.reverse.natDegree = p.natDegree := by
    rw [reverse_natDegree, h0, Nat.sub_zero]
  unfold Polynomial.reverse at hdeg ⊢
  rw [hdeg]
  exact reflect_reflect

/-- A monic polynomial divisible by a monic polynomial of the same degree
equals it (over ℤ; any integral domain would do). -/
theorem Monic.eq_of_dvd_of_natDegree_eq {F G : ℤ[X]} (hFm : F.Monic) (hGm : G.Monic)
    (hdeg : G.natDegree = F.natDegree) (hdvd : F ∣ G) : G = F := by
  obtain ⟨q, hq⟩ := hdvd
  have hq0 : q ≠ 0 := by
    rintro rfl
    rw [mul_zero] at hq
    exact hGm.ne_zero hq
  have hnd : G.natDegree = F.natDegree + q.natDegree := by
    rw [hq]
    exact hFm.natDegree_mul' hq0
  have hqdeg : q.natDegree = 0 := by omega
  have hqC : q = C (q.coeff 0) := Polynomial.eq_C_of_natDegree_eq_zero hqdeg
  have hlead : q.leadingCoeff = 1 := by
    have hGq : G.leadingCoeff = q.leadingCoeff := by
      rw [hq, mul_comm]
      exact Polynomial.leadingCoeff_mul_monic hFm
    rw [← hGq, hGm.leadingCoeff]
  have hc1 : q.coeff 0 = 1 := by
    rw [← hqdeg, Polynomial.coeff_natDegree, hlead]
  have hq1 : q = 1 := by rw [hqC, hc1, map_one]
  rw [hq, hq1, mul_one]

/-- **Theorem A′, irreducible core.** If F ∈ ℤ[X] is irreducible, monic, with
constant coefficient 1, and G is monic with constant coefficient 1, of the same
degree, with `G * G.reverse = F * F.reverse`, then `G = F` or `G = F.reverse`:
irreducible 0-1 polynomials are homometrically rigid. -/
theorem reversal_rigidity (F G : ℤ[X]) (hFirr : Irreducible F)
    (hFm : F.Monic) (hGm : G.Monic)
    (hG0 : G.coeff 0 = 1)
    (hdeg : G.natDegree = F.natDegree)
    (h : G * G.reverse = F * F.reverse) :
    G = F ∨ G = F.reverse := by
  have hFprime : Prime F := (UniqueFactorizationMonoid.irreducible_iff_prime).mp hFirr
  have hFdvd : F ∣ G * G.reverse := by
    rw [h]
    exact dvd_mul_right F F.reverse
  rcases hFprime.2.2 _ _ hFdvd with hFG | hFGrev
  · -- F ∣ G with matching degree and monicity: G = F
    exact Or.inl (Monic.eq_of_dvd_of_natDegree_eq hFm hGm hdeg hFG)
  · -- F ∣ reverse G: then reverse G = F, and reversing again gives G = reverse F
    right
    have hG0' : G.coeff 0 ≠ 0 := by rw [hG0]; exact one_ne_zero
    have hGtd : G.natTrailingDegree = 0 := natTrailingDegree_eq_zero.mpr (Or.inr hG0')
    have hrevdeg : G.reverse.natDegree = F.natDegree := by
      rw [reverse_natDegree, hGtd, Nat.sub_zero, hdeg]
    have hrevmonic : G.reverse.Monic := by
      have ht : G.trailingCoeff = 1 := by
        rw [Polynomial.trailingCoeff_eq_coeff_zero hG0', hG0]
      have hl : G.reverse.leadingCoeff = 1 := by rw [reverse_leadingCoeff, ht]
      exact hl
    have hrevF : G.reverse = F :=
      Monic.eq_of_dvd_of_natDegree_eq hFm hrevmonic hrevdeg hFGrev
    calc G = G.reverse.reverse := (reverse_reverse_of_constantCoeff_ne_zero G hG0').symm
    _ = F.reverse := by rw [hrevF]

end Pairfield
