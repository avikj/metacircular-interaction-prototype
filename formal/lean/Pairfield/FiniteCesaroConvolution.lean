/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The finite counting-measure skeleton of E2B_PROOF Lemma C1.  A split point
`u` contributes the pair `(m,n)` exactly when `m ≤ u` and `n < N-u`;
equivalently it contributes one of the `N-m-n` witnesses over that pair.

This file proves only the finite reindexing and its semiring convolution
corollary.  It contains no integral, von Mangoldt function, explicit formula,
RH assumption, Gamma/Beta weight, zero sum, or asymptotic estimate.
-/
import Mathlib

namespace Pairfield.FiniteCesaroConvolution

open scoped BigOperators

private def cube (N : ℕ) : Finset (ℕ × ℕ × ℕ) :=
  Finset.range N ×ˢ (Finset.range N ×ˢ Finset.range N)

/-- Triples `(u,m,n)` for which `u` is a split point between the two prefixes.
The strict right endpoint `n < N-u` and inclusive left endpoint `m ≤ u` are
the discrete counterpart of the interval `[m,N-n]` having length `N-m-n`. -/
def splitTriples (N : ℕ) : Finset (ℕ × ℕ × ℕ) :=
  (cube N).filter fun x ↦ x.2.1 ≤ x.1 ∧ x.2.2 < N - x.1

/-- Triples `(m,n,j)` where `j` chooses one of the `N-m-n` copies of `(m,n)`. -/
def weightedTriples (N : ℕ) : Finset (ℕ × ℕ × ℕ) :=
  (cube N).filter fun x ↦ x.2.2 < N - x.1 - x.2.1

/-- Exact reindexing between split-point witnesses and weight witnesses. -/
theorem sum_splitTriples_eq_sum_weightedTriples
    {A : Type*} [AddCommMonoid A] (h : ℕ → ℕ → A) (N : ℕ) :
    (∑ x ∈ splitTriples N, h x.2.1 x.2.2) =
      ∑ x ∈ weightedTriples N, h x.1 x.2.1 := by
  apply Finset.sum_bij
    (fun x _ ↦ (x.2.1, x.2.2, x.1 - x.2.1))
  · intro x hx
    simp only [splitTriples, Finset.mem_filter, cube, Finset.mem_product,
      Finset.mem_range] at hx
    simp only [weightedTriples, Finset.mem_filter, cube, Finset.mem_product,
      Finset.mem_range]
    omega
  · intro x₁ hx₁ x₂ hx₂ heq
    simp only [splitTriples, Finset.mem_filter, cube, Finset.mem_product,
      Finset.mem_range] at hx₁ hx₂
    rcases x₁ with ⟨u₁, ⟨m₁, n₁⟩⟩
    rcases x₂ with ⟨u₂, ⟨m₂, n₂⟩⟩
    simp at hx₁ hx₂
    have hm : m₁ = m₂ := congrArg Prod.fst heq
    have hn : n₁ = n₂ := congrArg (fun z ↦ z.2.1) heq
    have hj : u₁ - m₁ = u₂ - m₂ := congrArg (fun z ↦ z.2.2) heq
    subst m₂
    subst n₂
    have hu : u₁ = u₂ := by omega
    subst u₂
    rfl
  · intro y hy
    simp only [weightedTriples, Finset.mem_filter, cube, Finset.mem_product,
      Finset.mem_range] at hy
    rcases y with ⟨m, ⟨n, j⟩⟩
    simp at hy
    refine ⟨(m + j, (m, n)), ?_, ?_⟩
    · simp only [splitTriples, Finset.mem_filter, cube, Finset.mem_product,
        Finset.mem_range]
      omega
    · simp only [Nat.add_sub_cancel_left]
  · intro x hx
    rfl

private theorem sum_range_ite_lt_fun
    {A : Type*} [AddCommMonoid A] (a : ℕ → A) (N K : ℕ) (hK : K ≤ N) :
    (∑ j ∈ Finset.range N, if j < K then a j else 0) =
      ∑ j ∈ Finset.range K, a j := by
  rw [← Finset.sum_filter]
  have hf : (Finset.range N).filter (fun j ↦ j < K) = Finset.range K := by
    ext j
    simp
    omega
  rw [hf]

private theorem sum_range_ite_lt
    {A : Type*} [AddCommMonoid A] (a : A) (N K : ℕ) (hK : K ≤ N) :
    (∑ j ∈ Finset.range N, if j < K then a else 0) = K • a := by
  rw [sum_range_ite_lt_fun (fun _ ↦ a) N K hK,
    Finset.sum_const, Finset.card_range]

/-- Summing out `j` turns the witness fiber into natural-number scalar weight. -/
theorem sum_weightedTriples_eq_tent
    {A : Type*} [AddCommMonoid A] (h : ℕ → ℕ → A) (N : ℕ) :
    (∑ x ∈ weightedTriples N, h x.1 x.2.1) =
      ∑ m ∈ Finset.range N, ∑ n ∈ Finset.range N,
        (N - m - n) • h m n := by
  simp only [weightedTriples, cube, Finset.sum_filter, Finset.sum_product]
  apply Finset.sum_congr rfl
  intro m hm
  apply Finset.sum_congr rfl
  intro n hn
  exact sum_range_ite_lt (h m n) N (N - m - n) (by omega)

/-- Generic finite layer-cake/Fubini identity.  No multiplication is needed:
each value `h m n` appears once per admissible split point and therefore
exactly `N-m-n` times. -/
theorem finite_layer_cake
    {A : Type*} [AddCommMonoid A] (h : ℕ → ℕ → A) (N : ℕ) :
    (∑ x ∈ splitTriples N, h x.2.1 x.2.2) =
      ∑ m ∈ Finset.range N, ∑ n ∈ Finset.range N,
        (N - m - n) • h m n :=
  (sum_splitTriples_eq_sum_weightedTriples h N).trans
    (sum_weightedTriples_eq_tent h N)

/-! ## Semiring specialization: products of prefix sums -/

/-- Exclusive prefix sum: `partialSum f k = f 0 + ⋯ + f (k-1)`. -/
def partialSum {R : Type*} [AddCommMonoid R] (f : ℕ → R) (k : ℕ) : R :=
  ∑ n ∈ Finset.range k, f n

/-- The split-triple sum is exactly a sum of complementary prefix products.
The endpoints are `u+1` on the left and `N-u` on the right. -/
theorem sum_splitTriples_eq_sum_prefix_mul_prefix
    {R : Type*} [CommSemiring R] (f g : ℕ → R) (N : ℕ) :
    (∑ x ∈ splitTriples N, f x.2.1 * g x.2.2) =
      ∑ u ∈ Finset.range N, partialSum f (u + 1) * partialSum g (N - u) := by
  simp only [splitTriples, cube, Finset.sum_filter, Finset.sum_product]
  apply Finset.sum_congr rfl
  intro u hu
  have huN : u < N := Finset.mem_range.mp hu
  rw [partialSum, partialSum, Finset.sum_mul_sum]
  have hinner : ∀ m : ℕ,
      (∑ n ∈ Finset.range N,
        if m ≤ u ∧ n < N - u then f m * g n else 0) =
        if m ≤ u then ∑ n ∈ Finset.range (N - u), f m * g n else 0 := by
    intro m
    by_cases hm : m ≤ u
    · simp only [hm, true_and, if_true]
      exact sum_range_ite_lt_fun (fun n ↦ f m * g n) N (N - u) (by omega)
    · simp [hm]
  simp_rw [hinner]
  simpa only [Nat.lt_succ_iff] using
    (sum_range_ite_lt_fun
      (fun m ↦ ∑ n ∈ Finset.range (N - u), f m * g n)
      N (u + 1) (by omega))

/-- Tent-weighted pair sum, before grouping pairs by their antidiagonal. -/
def tentPairSum {R : Type*} [CommSemiring R]
    (f g : ℕ → R) (N : ℕ) : R :=
  ∑ m ∈ Finset.range N, ∑ n ∈ Finset.range N,
    (N - m - n) • (f m * g n)

/-- Finite C1: the tent-weighted pair sum equals the complementary-prefix sum. -/
theorem tentPairSum_eq_sum_prefix_mul_prefix
    {R : Type*} [CommSemiring R] (f g : ℕ → R) (N : ℕ) :
    tentPairSum f g N =
      ∑ u ∈ Finset.range N, partialSum f (u + 1) * partialSum g (N - u) := by
  rw [tentPairSum, ← finite_layer_cake (fun m n ↦ f m * g n) N,
    sum_splitTriples_eq_sum_prefix_mul_prefix]

/-! ## Regrouping by additive antidiagonals -/

/-- The additive convolution coefficient at centre `k`. -/
def additiveConvolution {R : Type*} [CommSemiring R]
    (f g : ℕ → R) (k : ℕ) : R :=
  ∑ p ∈ Finset.HasAntidiagonal.antidiagonal k, f p.1 * g p.2

/-- The order-one finite Cesàro/tent sum of additive convolution coefficients. -/
def finiteCesaro {R : Type*} [CommSemiring R]
    (f g : ℕ → R) (N : ℕ) : R :=
  ∑ k ∈ Finset.range N, (N - k) • additiveConvolution f g k

private def antidiagonalParameters (N : ℕ) : Finset (ℕ × ℕ) :=
  (Finset.range N ×ˢ Finset.range N).filter fun x ↦ x.2 ≤ x.1

private def belowPairs (N : ℕ) : Finset (ℕ × ℕ) :=
  (Finset.range N ×ˢ Finset.range N).filter fun x ↦ x.1 + x.2 < N

private theorem sum_antidiagonalParameters_eq_sum_belowPairs
    {A : Type*} [AddCommMonoid A] (h : ℕ → ℕ → A) (N : ℕ) :
    (∑ x ∈ antidiagonalParameters N,
      (N - x.1) • h x.2 (x.1 - x.2)) =
      ∑ x ∈ belowPairs N, (N - x.1 - x.2) • h x.1 x.2 := by
  apply Finset.sum_bij (fun x _ ↦ (x.2, x.1 - x.2))
  · intro x hx
    simp only [antidiagonalParameters, Finset.mem_filter, Finset.mem_product,
      Finset.mem_range] at hx
    simp only [belowPairs, Finset.mem_filter, Finset.mem_product, Finset.mem_range]
    omega
  · intro x₁ hx₁ x₂ hx₂ heq
    simp only [antidiagonalParameters, Finset.mem_filter, Finset.mem_product,
      Finset.mem_range] at hx₁ hx₂
    have hm : x₁.2 = x₂.2 := congrArg Prod.fst heq
    have hn : x₁.1 - x₁.2 = x₂.1 - x₂.2 := congrArg Prod.snd heq
    apply Prod.ext
    · omega
    · exact hm
  · intro y hy
    simp only [belowPairs, Finset.mem_filter, Finset.mem_product, Finset.mem_range] at hy
    refine ⟨(y.1 + y.2, y.1), ?_, ?_⟩
    · simp only [antidiagonalParameters, Finset.mem_filter, Finset.mem_product,
        Finset.mem_range]
      omega
    · simp only [Nat.add_sub_cancel_left]
  · intro x hx
    simp only [antidiagonalParameters, Finset.mem_filter, Finset.mem_product,
      Finset.mem_range] at hx
    have hcoeff : N - x.1 = N - x.2 - (x.1 - x.2) := by omega
    change (N - x.1) • h x.2 (x.1 - x.2) =
      (N - x.2 - (x.1 - x.2)) • h x.2 (x.1 - x.2)
    rw [hcoeff]

private theorem sum_belowPairs_eq_tent
    {A : Type*} [AddCommMonoid A] (h : ℕ → ℕ → A) (N : ℕ) :
    (∑ x ∈ belowPairs N, (N - x.1 - x.2) • h x.1 x.2) =
      ∑ m ∈ Finset.range N, ∑ n ∈ Finset.range N,
        (N - m - n) • h m n := by
  simp only [belowPairs, Finset.sum_filter, Finset.sum_product]
  apply Finset.sum_congr rfl
  intro m hm
  apply Finset.sum_congr rfl
  intro n hn
  by_cases hmn : m + n < N
  · simp [hmn]
  · have hz : N - m - n = 0 := by omega
    simp [hmn, hz]

private theorem sum_antidiagonalParameters_eq_finiteCesaro
    {R : Type*} [CommSemiring R] (f g : ℕ → R) (N : ℕ) :
    (∑ x ∈ antidiagonalParameters N,
      (N - x.1) • (f x.2 * g (x.1 - x.2))) = finiteCesaro f g N := by
  have hadd : ∀ k : ℕ,
      additiveConvolution f g k =
        ∑ m ∈ Finset.range (k + 1), f m * g (k - m) := by
    intro k
    exact Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun m n ↦ f m * g n) k
  simp only [antidiagonalParameters, Finset.sum_filter, Finset.sum_product,
    finiteCesaro]
  simp_rw [hadd, Finset.smul_sum]
  apply Finset.sum_congr rfl
  intro k hk
  have hkN : k < N := Finset.mem_range.mp hk
  simpa only [Nat.lt_succ_iff] using
    (sum_range_ite_lt_fun
      (fun m ↦ (N - k) • (f m * g (k - m))) N (k + 1) (by omega))

/-- Antidiagonal regrouping introduces no new arithmetic: it is exactly the
same tent-weighted pair sum, indexed by `k = m+n`. -/
theorem finiteCesaro_eq_tentPairSum
    {R : Type*} [CommSemiring R] (f g : ℕ → R) (N : ℕ) :
    finiteCesaro f g N = tentPairSum f g N := by
  rw [← sum_antidiagonalParameters_eq_finiteCesaro]
  exact (sum_antidiagonalParameters_eq_sum_belowPairs
      (fun m n ↦ f m * g n) N).trans
    (sum_belowPairs_eq_tent (fun m n ↦ f m * g n) N)

/-- Finite Cesàro convolution identity with exact endpoint conventions. -/
theorem finiteCesaro_eq_sum_prefix_mul_prefix
    {R : Type*} [CommSemiring R] (f g : ℕ → R) (N : ℕ) :
    finiteCesaro f g N =
      ∑ u ∈ Finset.range N, partialSum f (u + 1) * partialSum g (N - u) :=
  (finiteCesaro_eq_tentPairSum f g N).trans
    (tentPairSum_eq_sum_prefix_mul_prefix f g N)

/-! ## Endpoint control -/

/-- Unit mass at zero, used only to expose the two endpoint choices. -/
def deltaZero : ℕ → ℕ
  | 0 => 1
  | _ + 1 => 0

/-- At `N=1`, the tent-weighted convolution of the two unit masses is one. -/
theorem delta_one_finiteCesaro : finiteCesaro deltaZero deltaZero 1 = 1 := rfl

/-- The proved endpoint convention reproduces that one surviving contribution. -/
theorem delta_one_correct_endpoints :
    (∑ u ∈ Finset.range 1,
      partialSum deltaZero (u + 1) * partialSum deltaZero (1 - u)) = 1 := rfl

/-- Using the exclusive left prefix `u` instead of the inclusive `u+1`
already loses the unit contribution at `N=1`. -/
theorem delta_one_wrong_left_endpoint :
    (∑ u ∈ Finset.range 1,
      partialSum deltaZero u * partialSum deltaZero (1 - u)) = 0 := rfl

/-- Removing the right endpoint by replacing `N-u` with `N-u-1` also loses it. -/
theorem delta_one_wrong_right_endpoint :
    (∑ u ∈ Finset.range 1,
      partialSum deltaZero (u + 1) * partialSum deltaZero (1 - u - 1)) = 0 := rfl

end Pairfield.FiniteCesaroConvolution
