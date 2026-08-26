/-
The common mathematical kernel of finite observed action systems.

Two states are future-equivalent when every finite action word produces the
same observation.  The relation is an equivalence and a congruence for every
action.  These facts justify taking the behavioral quotient computed by
`machinery/natural_crystal.py`.
-/
namespace Pairfield

universe u v w z

variable {X : Type u} {A : Type v} {O : Type w}

/-- Apply a word of actions from left to right. -/
def run (step : X → A → X) : X → List A → X
  | x, [] => x
  | x, action :: word => run step (step x action) word

/-- The complete observable future of one state. -/
def behavior (step : X → A → X) (observe : X → O) (x : X) : List A → O :=
  fun word => observe (run step x word)

/-- Equality under every finite future experiment. -/
def FutureEq (step : X → A → X) (observe : X → O) (x y : X) : Prop :=
  ∀ word, behavior step observe x word = behavior step observe y word

theorem futureEq_refl (step : X → A → X) (observe : X → O) (x : X) :
    FutureEq step observe x x := by
  intro word
  rfl

theorem futureEq_symm (step : X → A → X) (observe : X → O) {x y : X}
    (h : FutureEq step observe x y) : FutureEq step observe y x := by
  intro word
  exact (h word).symm

theorem futureEq_trans (step : X → A → X) (observe : X → O) {x y z : X}
    (hxy : FutureEq step observe x y) (hyz : FutureEq step observe y z) :
    FutureEq step observe x z := by
  intro word
  exact (hxy word).trans (hyz word)

/-- Future equality is preserved when the same action is taken on both sides. -/
theorem futureEq_step (step : X → A → X) (observe : X → O) {x y : X}
    (h : FutureEq step observe x y) (action : A) :
    FutureEq step observe (step x action) (step y action) := by
  intro word
  exact h (action :: word)

/-- The relation is literally equality of the two behavior functions. -/
theorem futureEq_iff_behavior_eq (step : X → A → X) (observe : X → O) (x y : X) :
    FutureEq step observe x y ↔ behavior step observe x = behavior step observe y := by
  constructor
  · intro h
    funext word
    exact h word
  · intro h word
    exact congrFun h word

/-- Future equality as an actual quotient relation. -/
def futureSetoid (step : X → A → X) (observe : X → O) : Setoid X where
  r := FutureEq step observe
  iseqv := {
    refl := futureEq_refl step observe
    symm := futureEq_symm step observe
    trans := futureEq_trans step observe
  }

/-- Every action descends to the quotient because future equality is a congruence. -/
def quotientStep (step : X → A → X) (observe : X → O) (action : A) :
    Quotient (futureSetoid step observe) → Quotient (futureSetoid step observe) :=
  Quotient.lift (fun x => Quotient.mk _ (step x action)) (by
    intro x y h
    apply Quotient.sound
    exact futureEq_step step observe h action)

/-- The present observation descends because the empty future is among all futures. -/
def quotientObserve (step : X → A → X) (observe : X → O) :
    Quotient (futureSetoid step observe) → O :=
  Quotient.lift observe (by
    intro x y h
    exact h [])

theorem quotientStep_mk (step : X → A → X) (observe : X → O)
    (action : A) (x : X) :
    quotientStep step observe action (Quotient.mk _ x) =
      Quotient.mk _ (step x action) := rfl

/-- Apply an entire action word directly on the quotient. -/
def quotientRun (step : X → A → X) (observe : X → O) :
    Quotient (futureSetoid step observe) → List A →
      Quotient (futureSetoid step observe)
  | meaning, [] => meaning
  | meaning, action :: word =>
      quotientRun step observe (quotientStep step observe action meaning) word

/-- Executing before or after quotienting gives the same meaning. -/
theorem quotientRun_mk (step : X → A → X) (observe : X → O)
    (x : X) (word : List A) :
    quotientRun step observe (Quotient.mk _ x) word =
      Quotient.mk _ (run step x word) := by
  induction word generalizing x with
  | nil => rfl
  | cons action word induction =>
      exact induction (step x action)

/-- A finer observation can split old meanings but cannot merge them. -/
theorem futureEq_of_finer {Fine : Type z}
    (step : X → A → X) (coarse : X → O) (fine : X → Fine)
    (forget : Fine → O) (hforget : ∀ x, forget (fine x) = coarse x)
    {x y : X} (h : FutureEq step fine x y) :
    FutureEq step coarse x y := by
  intro word
  change coarse (run step x word) = coarse (run step y word)
  rw [← hforget (run step x word), ← hforget (run step y word)]
  exact congrArg forget (h word)

/-- Joint observation preserves exactly the intersection of two distinctions. -/
theorem futureEq_pair_iff {P : Type z}
    (step : X → A → X) (left : X → O) (right : X → P) (x y : X) :
    FutureEq step (fun state => (left state, right state)) x y ↔
      FutureEq step left x y ∧ FutureEq step right x y := by
  constructor
  · intro h
    constructor
    · intro word
      exact congrArg Prod.fst (h word)
    · intro word
      exact congrArg Prod.snd (h word)
  · rintro ⟨hleft, hright⟩ word
    exact Prod.ext (hleft word) (hright word)

theorem quotientObserve_mk (step : X → A → X) (observe : X → O) (x : X) :
    quotientObserve step observe (Quotient.mk _ x) = observe x := rfl

/-- Every quantity constant on future-equivalence classes factors through meaning. -/
def quotientLift {T : Type z} (step : X → A → X) (observe : X → O)
    (target : X → T)
    (constant : ∀ ⦃x y⦄, FutureEq step observe x y → target x = target y) :
    Quotient (futureSetoid step observe) → T :=
  Quotient.lift target (fun _ _ h => constant h)

theorem quotientLift_mk {T : Type z} (step : X → A → X) (observe : X → O)
    (target : X → T)
    (constant : ∀ ⦃x y⦄, FutureEq step observe x y → target x = target y)
    (x : X) :
    quotientLift step observe target constant (Quotient.mk _ x) = target x := rfl

/-- A meaning has a complete observable behavior independent of representative. -/
def quotientBehavior (step : X → A → X) (observe : X → O) :
    Quotient (futureSetoid step observe) → (List A → O) :=
  quotientLift step observe (behavior step observe) (by
    intro x y h
    exact (futureEq_iff_behavior_eq step observe x y).mp h)

/-- Distinct meanings have distinct complete futures. -/
theorem quotientBehavior_injective (step : X → A → X) (observe : X → O) :
    Function.Injective (quotientBehavior step observe) := by
  intro left right
  refine Quotient.inductionOn₂ left right ?_
  intro x y h
  apply Quotient.sound
  change behavior step observe x = behavior step observe y at h
  exact (futureEq_iff_behavior_eq step observe x y).mpr h

end Pairfield
