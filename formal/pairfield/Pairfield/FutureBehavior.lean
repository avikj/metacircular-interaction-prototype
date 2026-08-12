/-
The common mathematical kernel of finite observed action systems.

Two states are future-equivalent when every finite action word produces the
same observation.  The relation is an equivalence and a congruence for every
action.  These facts justify taking the behavioral quotient computed by
`machinery/natural_crystal.py`.
-/
namespace Pairfield

universe u v w

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

end Pairfield
