/-
Checked Mathlib adapter for `notes/INFINITE_VALUATION.md` section 4.

The native finite chart through `x` is a product of affine residue classes.
Mathlib's `MvPolynomial.funext_set` says that a polynomial vanishing on a box
with every side infinite must be zero.  Its contrapositive supplies a nonroot
in every nonzero-modulus chart through a root of a nonzero polynomial.
-/
import Mathlib.Algebra.MvPolynomial.Funext
import Mathlib.Data.Int.ModEq
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Tactic

namespace Pairfield.InfiniteValuationFiberAdapter

open MvPolynomial Set

/-- One coordinate side of the residue chart through `a` modulo `m`. -/
def affineResidueSide (m a : ℤ) : Set ℤ :=
  Set.range fun z : ℤ ↦ a + m * z

/-- A nonzero-modulus affine residue class in `ℤ` is infinite. -/
theorem affineResidueSide_infinite {m a : ℤ} (hm : m ≠ 0) :
    (affineResidueSide m a).Infinite := by
  apply Set.infinite_range_of_injective
  intro u v huv
  apply mul_left_cancel₀ hm
  exact add_left_cancel huv

/-- Coordinatewise membership in the native residue chart. -/
def SameResidueChart {σ : Type*} (m : ℤ) (x y : σ → ℤ) : Prop :=
  ∀ i, x i ≡ y i [ZMOD m]

/-- The affine-side and modular-congruence presentations agree exactly. -/
theorem mem_affineResidueSide_iff_modEq {m a b : ℤ} :
    b ∈ affineResidueSide m a ↔ a ≡ b [ZMOD m] := by
  simp only [affineResidueSide, Set.mem_range, Int.modEq_iff_add_fac]
  constructor
  · rintro ⟨z, rfl⟩
    exact ⟨z, rfl⟩
  · rintro ⟨z, hz⟩
    exact ⟨z, hz.symm⟩

/-- Polynomial evaluation respects the native coordinatewise residue chart. -/
theorem eval_modEq_of_sameResidueChart {σ : Type*} {m : ℤ}
    {x y : σ → ℤ} (f : MvPolynomial σ ℤ)
    (hxy : SameResidueChart m x y) :
    eval x f ≡ eval y f [ZMOD m] := by
  rw [← Int.modEq_natAbs, ← ZMod.intCast_eq_intCast_iff]
  change
    Int.castRingHom (ZMod m.natAbs) (eval x f) =
      Int.castRingHom (ZMod m.natAbs) (eval y f)
  rw [MvPolynomial.eval₂_comp, MvPolynomial.eval₂_comp]
  apply MvPolynomial.eval₂_congr
  intro i _c _hi _hc
  exact (ZMod.intCast_eq_intCast_iff _ _ _).mpr
    (Int.modEq_natAbs.mpr (hxy i))

/-- The Boolean zero/infinity status is determined at `x` by the modulus-`m`
chart when every same-chart point has the same zero status as `x`. -/
def ZeroStatusDeterminedAt {σ : Type*} (m : ℤ)
    (f : MvPolynomial σ ℤ) (x : σ → ℤ) : Prop :=
  ∀ y, SameResidueChart m x y → (eval y f = 0 ↔ eval x f = 0)

/-- Exact multivariate native witness: every nonzero-modulus residue chart
contains a nonroot of every nonzero integral polynomial. -/
theorem exists_sameResidueChart_eval_ne_zero {σ : Type*}
    (f : MvPolynomial σ ℤ) (hf : f ≠ 0) (m : ℤ) (hm : m ≠ 0)
    (x : σ → ℤ) :
    ∃ y, SameResidueChart m x y ∧ eval y f ≠ 0 := by
  by_contra hno
  have hall : ∀ y, SameResidueChart m x y → eval y f = 0 := by
    intro y hy
    by_contra hne
    exact hno ⟨y, hy, hne⟩
  apply hf
  apply MvPolynomial.funext_set (s := fun i ↦ affineResidueSide m (x i))
    (fun i ↦ affineResidueSide_infinite hm)
  intro y hy
  have hchart : SameResidueChart m x y := by
    intro i
    exact mem_affineResidueSide_iff_modEq.mp (hy i (Set.mem_univ i))
  simpa using hall y hchart

/-- At a root, no nonzero-modulus residue chart determines the zero/infinity
status of a nonzero polynomial. -/
theorem zeroStatus_not_determined_at_root {σ : Type*}
    (f : MvPolynomial σ ℤ) (hf : f ≠ 0) (m : ℤ) (hm : m ≠ 0)
    (x : σ → ℤ) (hx : eval x f = 0) :
    ¬ ZeroStatusDeterminedAt m f x := by
  obtain ⟨y, hy, hfy⟩ :=
    exists_sameResidueChart_eval_ne_zero f hf m hm x
  intro hdet
  exact hfy ((hdet y hy).mpr hx)

/-- Native prime-power specialization: every finite `p`-adic residue chart
through a root contains a point with finite (non-infinite) zero status. -/
theorem primePower_zeroStatus_not_determined {σ : Type*}
    (f : MvPolynomial σ ℤ) (hf : f ≠ 0) (p k : ℕ) [hp : Fact p.Prime]
    (x : σ → ℤ) (hx : eval x f = 0) :
    ¬ ZeroStatusDeterminedAt ((p : ℤ) ^ k) f x := by
  apply zeroStatus_not_determined_at_root f hf ((p : ℤ) ^ k) ?_ x hx
  exact pow_ne_zero k (Int.ofNat_ne_zero.mpr hp.out.ne_zero)

/-- Complementary finite row: at a nonroot, the prime-power chart one digit
deeper than the `p`-adic valuation already determines Boolean zero status. -/
theorem primePower_zeroStatus_determined_at_nonroot {σ : Type*}
    (f : MvPolynomial σ ℤ) (p : ℕ) [hp : Fact p.Prime]
    (x : σ → ℤ) (hx : eval x f ≠ 0) :
    ZeroStatusDeterminedAt
      ((p : ℤ) ^ (padicValInt p (eval x f) + 1)) f x := by
  intro y hy
  have hmod := eval_modEq_of_sameResidueChart f hy
  have hfy : eval y f ≠ 0 := by
    intro hyzero
    have hdvd :
        (p : ℤ) ^ (padicValInt p (eval x f) + 1) ∣ eval x f := by
      rw [← Int.modEq_zero_iff_dvd]
      simpa [hyzero] using hmod
    rcases (padicValInt_dvd_iff _ _).mp hdvd with hzero | hle
    · exact hx hzero
    · exact (Nat.not_succ_le_self (padicValInt p (eval x f))) hle
  exact iff_of_false hfy hx

/-- Exact Boolean classification of the native infinity fiber: for a nonzero
integral polynomial, a point is a root exactly when no finite prime-power
residue chart determines its zero/infinity status. -/
theorem eval_eq_zero_iff_no_primePower_zeroStatus_chart {σ : Type*}
    (f : MvPolynomial σ ℤ) (hf : f ≠ 0) (p : ℕ) [hp : Fact p.Prime]
    (x : σ → ℤ) :
    eval x f = 0 ↔
      ∀ k : ℕ, ¬ ZeroStatusDeterminedAt ((p : ℤ) ^ k) f x := by
  constructor
  · intro hx k
    exact primePower_zeroStatus_not_determined f hf p k x hx
  · intro hall
    by_contra hx
    exact hall (padicValInt p (eval x f) + 1)
      (primePower_zeroStatus_determined_at_nonroot f p x hx)

/-- Positive concrete control: `X` at zero and the depth-two `3`-adic chart
has the explicit same-chart nonroot `9`. -/
theorem linear_nine_control :
    SameResidueChart 9 (fun _ : Unit ↦ 0) (fun _ ↦ 9) ∧
      eval (fun _ : Unit ↦ 9) (X () : MvPolynomial Unit ℤ) = 9 := by
  constructor
  · intro i
    norm_num [Int.ModEq]
  · simp

/-- The polynomial-nonzero hypothesis is load-bearing: the zero polynomial's
zero status is determined on every chart. -/
theorem zero_polynomial_control {σ : Type*} (m : ℤ) (x : σ → ℤ) :
    ZeroStatusDeterminedAt m (0 : MvPolynomial σ ℤ) x := by
  intro y _hy
  simp

/-- The modulus-nonzero hypothesis is load-bearing: modulus zero makes
coordinatewise congruence literal equality. -/
theorem zero_modulus_control {σ : Type*} (f : MvPolynomial σ ℤ)
    (x : σ → ℤ) :
    ZeroStatusDeterminedAt 0 f x := by
  intro y hy
  have hxy : x = y := by
    funext i
    exact Int.modEq_zero_iff.mp (hy i)
  subst y
  rfl

/-- Infinitude alone is insufficient in several variables: the nonzero
polynomial `X false` vanishes on the infinite `true`-coordinate axis. -/
theorem arbitrary_infinite_set_control :
    (X false : MvPolynomial Bool ℤ) ≠ 0 ∧
      (Set.range (fun z : ℤ ↦ fun b : Bool ↦ if b then z else 0)).Infinite ∧
      ∀ y ∈ Set.range (fun z : ℤ ↦ fun b : Bool ↦ if b then z else 0),
        eval y (X false : MvPolynomial Bool ℤ) = 0 := by
  constructor
  · simp
  constructor
  · apply Set.infinite_range_of_injective
    intro u v huv
    have h := congrFun huv true
    simpa using h
  · intro y hy
    obtain ⟨z, rfl⟩ := hy
    simp

end Pairfield.InfiniteValuationFiberAdapter
