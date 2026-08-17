/- A two-state Chu-style calibration for adaptive residual observations. -/
import Pairfield.AdaptiveResidualAdapter

namespace Pairfield

structure FiniteChu where
  state : Type
  action : Type
  response : Type
  step : state → action → state
  observe : state → response
  pair : state → response → Prop

namespace FiniteChu

variable {C : FiniteChu}

/-- A map of finite Chu data preserves the observation pairing and dynamics. -/
structure Hom (C D : FiniteChu) where
  stateMap : C.state → D.state
  actionMap : C.action → D.action
  responseMap : C.response → D.response
  step_naturality : ∀ x a,
    stateMap (C.step x a) = D.step (stateMap x) (actionMap a)
  observe_naturality : ∀ x,
    responseMap (C.observe x) = D.observe (stateMap x)
  pair_naturality : ∀ x r, C.pair x r ↔ D.pair (stateMap x) (responseMap r)

def Hom.comp {C D E : FiniteChu} (g : Hom D E) (f : Hom C D) : Hom C E where
  stateMap := g.stateMap ∘ f.stateMap
  actionMap := g.actionMap ∘ f.actionMap
  responseMap := g.responseMap ∘ f.responseMap
  step_naturality := by
    intro x a
    simp only [Function.comp_apply]
    rw [f.step_naturality, g.step_naturality]
  observe_naturality := by
    intro x
    simp only [Function.comp_apply]
    rw [f.observe_naturality, g.observe_naturality]
  pair_naturality := by
    intro x r
    rw [f.pair_naturality, g.pair_naturality]
    change E.pair (g.stateMap (f.stateMap x))
      (g.responseMap (f.responseMap r)) ↔ _
    rfl

theorem Hom.comp_pair (g : Hom D E) (f : Hom C D) (x : C.state) (r : C.response) :
    C.pair x r ↔ E.pair ((g.stateMap ∘ f.stateMap) x)
      ((g.responseMap ∘ f.responseMap) r) := by
  rw [f.pair_naturality, g.pair_naturality]
  rfl

/-- The smallest concrete calibration: two states, one action and one response.
The response observes the state, and pairing is equality of state and response. -/
def bit : FiniteChu where
  state := Fin 2
  action := Unit
  response := Fin 2
  step := fun x _ => x
  observe := id
  pair := fun x r => x = r

def bitIdentity : Hom bit bit where
  stateMap := id
  actionMap := id
  responseMap := id
  step_naturality := by intros; rfl
  observe_naturality := by intros; rfl
  pair_naturality := by intros; simp

theorem bit_pair_calibration (x : bit.state) (r : bit.response) :
    bit.pair x r ↔ x = r := by rfl

theorem bit_identity_comp :
    Hom.comp bitIdentity bitIdentity = bitIdentity := by
  simp [Hom.comp, bitIdentity]

end FiniteChu
end Pairfield
