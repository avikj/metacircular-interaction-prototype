import Mathlib

/-!
# The autonomous mod-five multiplier profile

Install `a : ZMod 5`, start at one, repeatedly apply multiplication by `a`,
and observe only whether the current value is zero, one, or other.  Complete
trace equality stabilizes after exponent two and has exactly four classes.

This is a finite deterministic profile theorem.  It does not formalize a
Hilbert-space encoding or make the multipliers externally selectable.
-/

namespace Pairfield.ModFiveAutonomousProfile

inductive Response where
  | zero
  | one
  | other
  deriving DecidableEq, Repr

def observe (value : ZMod 5) : Response :=
  if value = 0 then .zero else if value = 1 then .one else .other

def responseAt (multiplier : ZMod 5) (exponent : ℕ) : Response :=
  observe (multiplier ^ exponent)

def horizonOneProfile (multiplier : ZMod 5) : Response × Response :=
  (responseAt multiplier 0, responseAt multiplier 1)

def HorizonOneEq (left right : ZMod 5) : Prop :=
  horizonOneProfile left = horizonOneProfile right

def horizonTwoProfile (multiplier : ZMod 5) :
    Response × Response × Response :=
  (responseAt multiplier 0, responseAt multiplier 1,
    responseAt multiplier 2)

def HorizonTwoEq (left right : ZMod 5) : Prop :=
  horizonTwoProfile left = horizonTwoProfile right

def firstFiveProfile (multiplier : ZMod 5) :
    Response × Response × Response × Response × Response :=
  (responseAt multiplier 0, responseAt multiplier 1,
    responseAt multiplier 2, responseAt multiplier 3,
    responseAt multiplier 4)

def FirstFiveEq (left right : ZMod 5) : Prop :=
  firstFiveProfile left = firstFiveProfile right

def ForeverEq (left right : ZMod 5) : Prop :=
  ∀ exponent : ℕ, responseAt left exponent = responseAt right exponent

/-! ## Four-step recurrence after the common seed -/

theorem pow_five_eq_self (multiplier : ZMod 5) :
    multiplier ^ 5 = multiplier := by
  revert multiplier
  native_decide

/-- Exponents `n+5` and `n+1` have the same response.  Equivalently, after
the seed at exponent zero, every response trace has period dividing four. -/
theorem response_period_four (multiplier : ZMod 5) (n : ℕ) :
    responseAt multiplier (n + 5) = responseAt multiplier (n + 1) := by
  apply congrArg observe
  calc
    multiplier ^ (n + 5) = multiplier ^ n * multiplier ^ 5 := by
      rw [pow_add]
    _ = multiplier ^ n * multiplier := by
      rw [pow_five_eq_self]
    _ = multiplier ^ (n + 1) := (pow_succ multiplier n).symm

/-- On this five-element carrier, agreement through exponent two already
forces agreement through exponent four.  This is the only finite case table
used by the stabilization proof. -/
theorem horizonTwo_implies_firstFive (left right : ZMod 5) :
    HorizonTwoEq left right → FirstFiveEq left right := by
  change horizonTwoProfile left = horizonTwoProfile right →
    firstFiveProfile left = firstFiveProfile right
  fin_cases left <;> fin_cases right <;> native_decide

private theorem firstFive_eq_at {left right : ZMod 5}
    (initial : FirstFiveEq left right) {n : ℕ} (small : n < 5) :
    responseAt left n = responseAt right n := by
  have h0 := congrArg (fun profile => profile.1) initial
  have h1 := congrArg (fun profile => profile.2.1) initial
  have h2 := congrArg (fun profile => profile.2.2.1) initial
  have h3 := congrArg (fun profile => profile.2.2.2.1) initial
  have h4 := congrArg (fun profile => profile.2.2.2.2) initial
  interval_cases n
  · simpa [FirstFiveEq, firstFiveProfile] using h0
  · simpa [FirstFiveEq, firstFiveProfile] using h1
  · simpa [FirstFiveEq, firstFiveProfile] using h2
  · simpa [FirstFiveEq, firstFiveProfile] using h3
  · simpa [FirstFiveEq, firstFiveProfile] using h4

theorem firstFive_implies_forever {left right : ZMod 5}
    (initial : FirstFiveEq left right) : ForeverEq left right := by
  intro exponent
  refine Nat.strong_induction_on exponent ?_
  intro n earlier
  by_cases small : n < 5
  · exact firstFive_eq_at initial small
  · let k := n - 5
    have n_eq : n = k + 5 := by
      dsimp [k]
      omega
    calc
      responseAt left n = responseAt left (k + 1) := by
        rw [n_eq]
        exact response_period_four left k
      _ = responseAt right (k + 1) := earlier (k + 1) (by
        dsimp [k]
        omega)
      _ = responseAt right n := by
        rw [n_eq]
        exact (response_period_four right k).symm

/-- The exact finite-horizon theorem: complete autonomous behavior is already
determined by the observations at exponents zero, one, and two. -/
theorem foreverEq_iff_horizonTwo (left right : ZMod 5) :
    ForeverEq left right ↔ HorizonTwoEq left right := by
  constructor
  · intro forever
    apply Prod.ext
    · exact forever 0
    apply Prod.ext
    · exact forever 1
    · exact forever 2
  · intro horizon
    exact firstFive_implies_forever
      (horizonTwo_implies_firstFive left right horizon)

/-! ## The exact four-class quotient -/

/-- Class labels are `{0}`, `{1}`, `{4}`, and `{2,3}`, in that order. -/
def predictiveClass (multiplier : ZMod 5) : Fin 4 :=
  if multiplier = 0 then 0
  else if multiplier = 1 then 1
  else if multiplier = 4 then 2
  else 3

theorem horizonTwoEq_iff_class_eq (left right : ZMod 5) :
    HorizonTwoEq left right ↔ predictiveClass left = predictiveClass right := by
  change horizonTwoProfile left = horizonTwoProfile right ↔
    predictiveClass left = predictiveClass right
  fin_cases left <;> fin_cases right <;> native_decide

/-- The class map is exactly the kernel of complete autonomous trace
equality, not merely a sound finite approximation. -/
theorem foreverEq_iff_class_eq (left right : ZMod 5) :
    ForeverEq left right ↔ predictiveClass left = predictiveClass right :=
  (foreverEq_iff_horizonTwo left right).trans
    (horizonTwoEq_iff_class_eq left right)

def representative (label : Fin 4) : ZMod 5 :=
  if label = 0 then 0
  else if label = 1 then 1
  else if label = 2 then 4
  else 2

theorem class_representative :
    Function.RightInverse representative predictiveClass := by
  intro label
  fin_cases label <;> native_decide

theorem predictiveClass_surjective : Function.Surjective predictiveClass :=
  class_representative.surjective

/-! ## Two strict controls -/

/-- Horizon one is genuinely too short: installed multipliers two and four
have the same seed and first response. -/
theorem two_four_horizonOne_collision : HorizonOneEq 2 4 := by
  change horizonOneProfile 2 = horizonOneProfile 4
  native_decide

/-- Their square responses differ, so horizon two strictly refines horizon
one. -/
theorem two_four_square_separation :
    responseAt 2 2 = .other ∧ responseAt 4 2 = .one := by
  native_decide

theorem two_four_not_horizonTwo : ¬ HorizonTwoEq 2 4 := by
  change ¬ horizonTwoProfile 2 = horizonTwoProfile 4
  native_decide

/-- Constructor identity is strictly finer than predictive identity: two and
three are distinct installed multipliers with the same complete trace. -/
theorem two_ne_three : (2 : ZMod 5) ≠ 3 := by
  native_decide

theorem two_three_foreverEq : ForeverEq 2 3 := by
  rw [foreverEq_iff_class_eq]
  native_decide

/-! ## Exact finite code lower bound and attainment -/

/-- If a code decodes the four predictive class labels for every installed
multiplier, the four chosen class representatives inject into the code. -/
theorem representatives_inject_into_exact_code
    {Code : Type*} (encode : ZMod 5 → Code) (decode : Code → Fin 4)
    (replay : ∀ multiplier, decode (encode multiplier) =
      predictiveClass multiplier) :
    Function.Injective (fun label ↦ encode (representative label)) := by
  intro left right sameCode
  calc
    left = predictiveClass (representative left) :=
      (class_representative left).symm
    _ = decode (encode (representative left)) := (replay _).symm
    _ = decode (encode (representative right)) := congrArg decode sameCode
    _ = predictiveClass (representative right) := replay _
    _ = right := class_representative right

/-- Every finite exact class code has at least four symbols. -/
theorem four_le_card_of_exact_code
    {Code : Type*} [Fintype Code]
    (encode : ZMod 5 → Code) (decode : Code → Fin 4)
    (replay : ∀ multiplier, decode (encode multiplier) =
      predictiveClass multiplier) :
    4 ≤ Fintype.card Code := by
  simpa using Fintype.card_le_of_injective
    (fun label ↦ encode (representative label))
    (representatives_inject_into_exact_code encode decode replay)

/-- The four class labels themselves attain the lower bound. -/
def optimalEncode : ZMod 5 → Fin 4 := predictiveClass

def optimalDecode : Fin 4 → Fin 4 := id

theorem optimal_replay (multiplier : ZMod 5) :
    optimalDecode (optimalEncode multiplier) = predictiveClass multiplier :=
  rfl

theorem optimal_code_card : Fintype.card (Fin 4) = 4 := by
  simp

end Pairfield.ModFiveAutonomousProfile
