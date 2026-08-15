/-
# Singleton-parity rigidity (Theorem A′′ of `notes/REPORT.md` §2.1,
  stated in full in `notes/PARITY_RIGIDITY.md`)

The note's proposition has three layers.  Two of them are checked here; the
third is identified precisely and is *not*.

WHAT IS FORMALIZED HERE
-----------------------
* **Layer 2 (the algebraic core), `core`.**  For Laurent polynomials
  `U V : ℤ[T;T⁻¹]` all of whose exponents are *odd*,
  `(1+U)·(1+U)* = (1+V)·(1+V)*` implies `U = V` or `U = V*`, where `*` is
  `LaurentPolynomial.invert` (`T n ↦ T (-n)`).  This is the only step of the
  note's proof that is not bookkeeping: it splits the autocorrelation
  identity by parity of exponent and then uses that `ℤ[T;T⁻¹]` is an
  integral domain.  No `0`–`1` hypothesis on coefficients is used.

* **Layer 3 (the set-level conclusion), `rigidity_normalized`.**  For finite
  `A B ⊆ ℤ` each containing `0` and otherwise consisting of odd integers —
  the *normalized* form of "one parity class is a singleton" — equality of
  the full pairwise-difference multisets forces `B = A` or `B = -A`.
  `coeff_autocorr` is the bridge that makes the polynomial hypothesis of
  `rigidity_normalized` literally the difference-multiset hypothesis: the
  `n`-th coefficient of `ind A * invert (ind A)` is
  `#{(a,a') ∈ A×A : a - a' = n}`.  `rigidity_normalized_diff` states the
  theorem with that combinatorial hypothesis directly.

WHAT IS **NOT** FORMALIZED HERE
-------------------------------
* **Layer 1**, the reduction of the general statement to the normalized one.
  Its arithmetic half *is* checked: `parity_class_sizes` is the note's
  `e + o = N`, `e·o = N - 1`, hence `(e-1)(e-(N-1)) = 0` step, which is what
  forces `B` to have a singleton parity class too.  What is missing is the
  *translation bookkeeping*: that `c_A(0) = |A|`, that the positive odd part
  of `c_A` counts opposite-parity pairs, and that translating each singleton
  to `0` (after an odd translation swapping the names of the parity classes
  if necessary) puts both sets in normalized form.  Each of those is
  routine; none of it is here.  Consequently the general Theorem A′′ as
  stated in `notes/PARITY_RIGIDITY.md` is **not** a checked term — its two
  substantive layers are.
* The prime-prefix corollary, and `Conjecture A″_alg` (irreducibility of the
  non-cyclotomic part of `F_X`), which is strictly stronger and separate;
  nothing below bears on it.

Non-vacuity controls are in the final section: a rigidity statement of this
shape is satisfied by empty/zero data, and the reflection disjunct could be
spurious.  The controls rule both out.
-/
import Mathlib

namespace Pairfield.ParityRigidity

open LaurentPolynomial

set_option maxRecDepth 8000

/-- Laurent polynomials over `ℤ`: the ambient integral domain of the proof. -/
abbrev L := ℤ[T;T⁻¹]

/-- Every exponent occurring in `f` is odd. -/
def OddS (f : L) : Prop := ∀ n : ℤ, f.coeff n ≠ 0 → Odd n

/-- Every exponent occurring in `f` is even. -/
def EvenS (f : L) : Prop := ∀ n : ℤ, f.coeff n ≠ 0 → Even n

/-! ## Coefficient bookkeeping -/

section Coeff

lemma coeff_one_of_ne {n : ℤ} (h : n ≠ 0) : (1 : L).coeff n = 0 := by
  rw [AddMonoidAlgebra.one_def]
  simp only [AddMonoidAlgebra.coeff_single, Finsupp.single_apply]
  exact if_neg (Ne.symm h)

lemma coeff_T (a n : ℤ) : (T a : L).coeff n = if n = a then 1 else 0 := by
  simp only [LaurentPolynomial.T, AddMonoidAlgebra.coeff_single, Finsupp.single_apply]
  by_cases h : n = a
  · rw [if_pos h.symm, if_pos h]
  · rw [if_neg (Ne.symm h), if_neg h]

end Coeff

/-! ## The parity grading -/

section Support

private lemma coeff_ne_or {f g : L} {n : ℤ} (h : (f + g).coeff n ≠ 0) :
    f.coeff n ≠ 0 ∨ g.coeff n ≠ 0 := by
  by_contra hc
  push_neg at hc
  exact h (by simp [hc.1, hc.2])

private lemma coeff_ne_or' {f g : L} {n : ℤ} (h : (f - g).coeff n ≠ 0) :
    f.coeff n ≠ 0 ∨ g.coeff n ≠ 0 := by
  by_contra hc
  push_neg at hc
  exact h (by simp [hc.1, hc.2])

lemma eq_zero_of_oddS_evenS {f : L} (h₁ : OddS f) (h₂ : EvenS f) : f = 0 := by
  ext n
  by_contra hc
  have hn : f.coeff n ≠ 0 := by simpa using hc
  exact (Int.not_even_iff_odd.2 (h₁ n hn)) (h₂ n hn)

lemma OddS.add {f g : L} (hf : OddS f) (hg : OddS g) : OddS (f + g) := fun n hn =>
  (coeff_ne_or hn).elim (hf n) (hg n)

lemma OddS.sub {f g : L} (hf : OddS f) (hg : OddS g) : OddS (f - g) := fun n hn =>
  (coeff_ne_or' hn).elim (hf n) (hg n)

lemma EvenS.add {f g : L} (hf : EvenS f) (hg : EvenS g) : EvenS (f + g) := fun n hn =>
  (coeff_ne_or hn).elim (hf n) (hg n)

lemma EvenS.sub {f g : L} (hf : EvenS f) (hg : EvenS g) : EvenS (f - g) := fun n hn =>
  (coeff_ne_or' hn).elim (hf n) (hg n)

lemma OddS.invert {f : L} (hf : OddS f) : OddS (LaurentPolynomial.invert f) := by
  intro n hn
  rw [LaurentPolynomial.invert_apply] at hn
  simpa using (hf (-n) hn)

/-- The product of two odd-supported Laurent polynomials is even-supported.
This is the parity grading that separates the note's two identities. -/
lemma EvenS.mul {f g : L} (hf : OddS f) (hg : OddS g) : EvenS (f * g) := by
  intro n hn
  have hmem : n ∈ (f * g).coeff.support := Finsupp.mem_support_iff.2 hn
  rcases Finset.mem_add.1 (AddMonoidAlgebra.support_coeff_mul_subset f g hmem) with
    ⟨a, ha, b, hb, hab⟩
  exact hab ▸ (hf a (Finsupp.mem_support_iff.1 ha)).add_odd (hg b (Finsupp.mem_support_iff.1 hb))

lemma evenS_one : EvenS (1 : L) := by
  intro n hn
  by_contra _
  exact hn (coeff_one_of_ne (by rintro rfl; exact hn (by simp) ))

/-- An odd-supported summand and an even-supported summand are determined
separately: the "separate odd and even Laurent coefficients" step. -/
lemma split {o₁ e₁ o₂ e₂ : L} (ho₁ : OddS o₁) (he₁ : EvenS e₁)
    (ho₂ : OddS o₂) (he₂ : EvenS e₂) (h : o₁ + e₁ = o₂ + e₂) :
    o₁ = o₂ ∧ e₁ = e₂ := by
  have key : o₁ - o₂ = e₂ - e₁ := by linear_combination h
  have hz : o₁ - o₂ = 0 :=
    eq_zero_of_oddS_evenS (ho₁.sub ho₂) (key ▸ he₂.sub he₁)
  exact ⟨by linear_combination hz, by linear_combination h - hz⟩

end Support

/-! ## Layer 2 — the algebraic core -/

/-- **Singleton-parity rigidity, algebraic core.**
If `U, V ∈ ℤ[T;T⁻¹]` have all exponents odd and `1+U`, `1+V` have equal
autocorrelation, then `U = V` or `U` is the reflection of `V`. -/
theorem core (U V : L) (hU : OddS U) (hV : OddS V)
    (h : (1 + U) * LaurentPolynomial.invert (1 + U)
       = (1 + V) * LaurentPolynomial.invert (1 + V)) :
    U = V ∨ U = LaurentPolynomial.invert V := by
  set U' := LaurentPolynomial.invert U with hU'def
  set V' := LaurentPolynomial.invert V with hV'def
  have hUi : OddS U' := hU.invert
  have hVi : OddS V' := hV.invert
  have hinvU : LaurentPolynomial.invert (1 + U) = 1 + U' := by simp [hU'def]
  have hinvV : LaurentPolynomial.invert (1 + V) = 1 + V' := by simp [hV'def]
  rw [hinvU, hinvV] at h
  -- split the identity into its odd-exponent and even-exponent parts
  have hsplit : (U + U') + (1 + U * U') = (V + V') + (1 + V * V') := by
    linear_combination h
  obtain ⟨hodd, heven⟩ :=
    split (hU.add hUi) (evenS_one.add (EvenS.mul hU hUi))
          (hV.add hVi) (evenS_one.add (EvenS.mul hV hVi)) hsplit
  have heven' : U * U' = V * V' := by linear_combination heven
  set W := U - V with hWdef
  -- `W* = -W`
  have hWstar : U' - V' = -W := by rw [hWdef]; linear_combination hodd
  have hUW : U = V + W := by rw [hWdef]; ring
  have hUW' : U' = V' - W := by linear_combination hWstar
  -- `W · (V* - V - W) = 0`, and `ℤ[T;T⁻¹]` is a domain
  have hprod : W * (V' - V - W) = 0 := by
    rw [hUW, hUW'] at heven'; linear_combination heven'
  rcases mul_eq_zero.1 hprod with hz | hz
  · left; rw [hWdef] at hz; linear_combination hz
  · right; rw [hWdef] at hz; linear_combination -hz

/-! ## Layer 1 — the parity-class count (arithmetic half only) -/

/-- If the two parity classes of `A` have sizes `e, o` with `e + o = N` and
`e·o = N - 1` (the count of opposite-parity unordered pairs), then one class
is a singleton.  This is the step that transfers the singleton hypothesis
from `A` to any `B` with the same difference multiset. -/
theorem parity_class_sizes (e o : ℕ) (h : e * o + 1 = e + o) : e = 1 ∨ o = 1 := by
  have h' : ((e : ℤ) - 1) * ((o : ℤ) - 1) = 0 := by push_cast; linarith [h, congrArg (Nat.cast : ℕ → ℤ) h]
  rcases mul_eq_zero.1 h' with hz | hz
  · left; omega
  · right; omega

/-! ## Layer 3 — the set-level statement -/

/-- The indicator Laurent polynomial of a finite set of integers. -/
noncomputable def ind (A : Finset ℤ) : L := ∑ a ∈ A, T a

@[simp] lemma coeff_ind (A : Finset ℤ) (n : ℤ) :
    (ind A).coeff n = if n ∈ A then 1 else 0 := by
  unfold ind
  have : (∑ a ∈ A, (T a : L)).coeff n = ∑ a ∈ A, (T a : L).coeff n := by simp
  rw [this]
  simp only [coeff_T]
  rw [Finset.sum_ite_eq' A n (fun _ => (1 : ℤ))]

lemma ind_injective {A B : Finset ℤ} (h : ind A = ind B) : A = B := by
  ext n
  have := congrArg (fun f => LaurentPolynomial.coeff f n) h
  simp only [coeff_ind] at this
  by_cases hA : n ∈ A <;> by_cases hB : n ∈ B <;> simp_all

lemma invert_ind (A : Finset ℤ) :
    LaurentPolynomial.invert (ind A) = ind (A.image (fun x => -x)) := by
  ext n
  rw [LaurentPolynomial.invert_apply]
  simp only [coeff_ind, Finset.mem_image]
  by_cases h : -n ∈ A
  · rw [if_pos h, if_pos ⟨-n, h, by ring⟩]
  · rw [if_neg h, if_neg]
    rintro ⟨x, hx, rfl⟩
    exact h (by simpa using hx)

/-- **The bridge.** The `n`-th coefficient of `ind A * invert (ind A)` is the
number of ordered pairs of `A` with difference `n`: the autocorrelation
`c_A(n)` of `notes/PARITY_RIGIDITY.md`. -/
theorem coeff_autocorr (A : Finset ℤ) (n : ℤ) :
    (ind A * LaurentPolynomial.invert (ind A)).coeff n
      = (((A ×ˢ A).filter (fun p => p.1 - p.2 = n)).card : ℤ) := by
  have hmul : ind A * LaurentPolynomial.invert (ind A)
      = ∑ p ∈ A ×ˢ A, (T (p.1 - p.2) : L) := by
    rw [invert_ind]
    unfold ind
    rw [Finset.sum_mul_sum]
    rw [Finset.sum_product]
    refine Finset.sum_congr rfl (fun a _ => ?_)
    rw [← Finset.sum_image (f := fun b => (T a : L) * T b)
        (g := fun x => -x) (s := A) (by intro x _ y _ h; omega)]
    exact Finset.sum_congr rfl (fun b _ => by rw [← T_add]; ring_nf)
  rw [hmul]
  have : (∑ p ∈ A ×ˢ A, (T (p.1 - p.2) : L)).coeff n
      = ∑ p ∈ A ×ˢ A, (T (p.1 - p.2) : L).coeff n := by simp
  rw [this]
  simp only [coeff_T]
  rw [Finset.sum_ite_eq_card_filter_of_eq (s := A ×ˢ A)]
  · simp
  · intro p _; rfl

/-- **Singleton-parity rigidity, normalized set form.**
`A` and `B` are finite sets of integers, each containing `0` and otherwise
consisting of odd numbers — i.e. each has `{0}` as its even parity class,
after the translation of `notes/PARITY_RIGIDITY.md`.  If they have the same
full pairwise-difference data, then `B = A` or `B = -A`. -/
theorem rigidity_normalized (A B : Finset ℤ)
    (hA0 : (0 : ℤ) ∈ A) (hAodd : ∀ a ∈ A, a ≠ 0 → Odd a)
    (hB0 : (0 : ℤ) ∈ B) (hBodd : ∀ b ∈ B, b ≠ 0 → Odd b)
    (h : ind A * LaurentPolynomial.invert (ind A)
       = ind B * LaurentPolynomial.invert (ind B)) :
    A = B ∨ A = B.image (fun x => -x) := by
  have hUodd : OddS (ind A - 1) := by
    intro n hn
    rcases coeff_ne_or' hn with hc | hc
    · rw [coeff_ind] at hc
      have hnA : n ∈ A := by by_contra hx; exact hc (if_neg hx)
      refine hAodd n hnA ?_
      rintro rfl
      exact hn (by simp [coeff_ind, hA0, AddMonoidAlgebra.one_def,
        AddMonoidAlgebra.coeff_single, Finsupp.single_apply])
    · exfalso
      by_cases hn0 : n = 0
      · subst hn0
        exact hn (by simp [coeff_ind, hA0, AddMonoidAlgebra.one_def,
          AddMonoidAlgebra.coeff_single, Finsupp.single_apply])
      · exact hc (coeff_one_of_ne hn0)
  have hVodd : OddS (ind B - 1) := by
    intro n hn
    rcases coeff_ne_or' hn with hc | hc
    · rw [coeff_ind] at hc
      have hnB : n ∈ B := by by_contra hx; exact hc (if_neg hx)
      refine hBodd n hnB ?_
      rintro rfl
      exact hn (by simp [coeff_ind, hB0, AddMonoidAlgebra.one_def,
        AddMonoidAlgebra.coeff_single, Finsupp.single_apply])
    · exfalso
      by_cases hn0 : n = 0
      · subst hn0
        exact hn (by simp [coeff_ind, hB0, AddMonoidAlgebra.one_def,
          AddMonoidAlgebra.coeff_single, Finsupp.single_apply])
      · exact hc (coeff_one_of_ne hn0)
  have hA1 : (1 : L) + (ind A - 1) = ind A := by ring
  have hB1 : (1 : L) + (ind B - 1) = ind B := by ring
  have hcore := core (ind A - 1) (ind B - 1) hUodd hVodd (by rw [hA1, hB1]; exact h)
  rcases hcore with hc | hc
  · left
    exact ind_injective (by linear_combination hc)
  · right
    refine ind_injective ?_
    rw [← invert_ind]
    have : LaurentPolynomial.invert (ind B) = 1 + LaurentPolynomial.invert (ind B - 1) := by
      have : ind B = 1 + (ind B - 1) := by ring
      rw [this]; simp
    rw [this]
    linear_combination hc

/-- The same theorem with the hypothesis stated combinatorially, via
`coeff_autocorr`: equal difference multisets, in the literal sense of equal
counts of ordered pairs at every difference. -/
theorem rigidity_normalized_diff (A B : Finset ℤ)
    (hA0 : (0 : ℤ) ∈ A) (hAodd : ∀ a ∈ A, a ≠ 0 → Odd a)
    (hB0 : (0 : ℤ) ∈ B) (hBodd : ∀ b ∈ B, b ≠ 0 → Odd b)
    (h : ∀ n : ℤ, ((A ×ˢ A).filter (fun p => p.1 - p.2 = n)).card
                = ((B ×ˢ B).filter (fun p => p.1 - p.2 = n)).card) :
    A = B ∨ A = B.image (fun x => -x) := by
  refine rigidity_normalized A B hA0 hAodd hB0 hBodd ?_
  ext n
  rw [coeff_autocorr, coeff_autocorr, h n]

/-! ## Non-vacuity controls

Without these the statements above would be compatible with there being no
data satisfying their hypotheses, or with the reflection disjunct being
removable. -/

section Controls

/-- C1: the hypotheses of `core` are satisfiable by nonzero data. -/
example : OddS (T 1 + T 3 : L) := by
  intro n hn
  have h1 : (T 1 + T 3 : L).coeff n = (if n = 1 then 1 else 0) + (if n = 3 then 1 else 0) := by
    simp [coeff_T]
  rw [h1] at hn
  by_cases ha : n = 1
  · exact ha ▸ ⟨0, by ring⟩
  · by_cases hb : n = 3
    · exact hb ▸ ⟨1, by ring⟩
    · exact absurd (by rw [if_neg ha, if_neg hb]; ring) hn

/-- C2: the reflection disjunct of `rigidity_normalized` is not removable —
`A = {0,1,3}` and `B = -A` satisfy every hypothesis and are distinct. -/
example : ({0, 1, 3} : Finset ℤ) ≠ ({0, -1, -3} : Finset ℤ) := by decide

/-- C3: `{0,-1,-3}` really is the image of `{0,1,3}` under negation, so C2
exhibits the second disjunct rather than a failure. -/
example : ({0, 1, 3} : Finset ℤ).image (fun x => -x) = ({0, -1, -3} : Finset ℤ) := by decide

/-- C4: the normalization hypothesis is genuinely restrictive.  The minimal
homometric pair of `notes/REPORT.md` §2 — `{0,1,2,6,8,11}` and
`{0,1,6,7,9,11}`, which are *not* translates or reflections of one another —
fails it: `{0,1,2,6,8,11}` has three even elements, not one. -/
example : ¬ (∀ a ∈ ({0, 1, 2, 6, 8, 11} : Finset ℤ), a ≠ 0 → Odd a) := by decide

/-- C5: the count in `parity_class_sizes` is not vacuous — `e = 1, o = 4`
(a five-element set with a singleton even class) satisfies it. -/
example : 1 * 4 + 1 = 1 + 4 := by rfl

/-- C6: and `parity_class_sizes` is not trivially true of all `e, o`:
`e = o = 2` violates its hypothesis. -/
example : ¬ (2 * 2 + 1 = 2 + 2) := by decide

end Controls

end Pairfield.ParityRigidity
