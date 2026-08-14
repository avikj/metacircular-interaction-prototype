import Mathlib.Data.Bool.Basic
import Mathlib.Order.BooleanAlgebra.Basic
import Mathlib.Tactic

namespace Pairfield

universe u

inductive BooleanFunction (B : Type u) (n : Nat)
  | var : Fin n → BooleanFunction B n
  | const : B → BooleanFunction B n
  | bot : BooleanFunction B n
  | top : BooleanFunction B n
  | inf : BooleanFunction B n → BooleanFunction B n → BooleanFunction B n
  | sup : BooleanFunction B n → BooleanFunction B n → BooleanFunction B n
  | compl : BooleanFunction B n → BooleanFunction B n

namespace BooleanFunction

variable {B : Type u} [BooleanAlgebra B] {n : Nat}

def eval : BooleanFunction B n → (Fin n → B) → B
  | .var i, x => x i
  | .const c, _ => c
  | .bot, _ => ⊥
  | .top, _ => ⊤
  | .inf p q, x => eval p x ⊓ eval q x
  | .sup p q, x => eval p x ⊔ eval q x
  | .compl p, x => (eval p x)ᶜ

def patch (a : B) (z x : Fin n → B) : Fin n → B :=
  fun i => (a ⊓ z i) ⊔ (aᶜ ⊓ x i)

theorem eval_patch (p : BooleanFunction B n) (a : B) (z x : Fin n → B) :
    eval p (patch a z x) = (a ⊓ eval p z) ⊔ (aᶜ ⊓ eval p x) := by
  induction p <;>
    simp_all [eval, patch, inf_sup_left, inf_sup_right, compl_inf, compl_sup]

def lowenheimBA (p : BooleanFunction B n) (zero x : Fin n → B) : Fin n → B :=
  patch (eval p x) zero x

theorem lowenheimBA_isZero (p : BooleanFunction B n) (zero x : Fin n → B)
    (hz : eval p zero = ⊥) : eval p (lowenheimBA p zero x) = ⊥ := by
  rw [lowenheimBA, eval_patch, hz]
  simp

theorem lowenheimBA_fixed (p : BooleanFunction B n) (zero x : Fin n → B)
    (hx : eval p x = ⊥) : lowenheimBA p zero x = x := by
  funext i
  simp [lowenheimBA, patch, hx]

theorem lowenheimBA_fixed_iff (p : BooleanFunction B n) (zero x : Fin n → B)
    (hz : eval p zero = ⊥) : lowenheimBA p zero x = x ↔ eval p x = ⊥ := by
  constructor
  · intro hfixed
    have hzero := lowenheimBA_isZero p zero x hz
    simpa [hfixed] using hzero
  · exact lowenheimBA_fixed p zero x

theorem lowenheimBA_idempotent (p : BooleanFunction B n) (zero x : Fin n → B)
    (hz : eval p zero = ⊥) :
    lowenheimBA p zero (lowenheimBA p zero x) = lowenheimBA p zero x :=
  lowenheimBA_fixed p zero _ (lowenheimBA_isZero p zero x hz)

theorem lowenheimBA_range_iff (p : BooleanFunction B n) (zero y : Fin n → B)
    (hz : eval p zero = ⊥) :
    (∃ x, lowenheimBA p zero x = y) ↔ eval p y = ⊥ := by
  constructor
  · rintro ⟨x, h⟩
    rw [← h]
    exact lowenheimBA_isZero p zero x hz
  · intro hy
    exact ⟨y, lowenheimBA_fixed p zero y hy⟩

end BooleanFunction

/-- Löwenheim's general reproductive solution, specialized to Boolean cubes. -/
def lowenheim {n : Nat} (f : (Fin n → Bool) → Bool)
    (zero x : Fin n → Bool) : Fin n → Bool :=
  fun i => (zero i && f x) || (x i && !(f x))

theorem lowenheim_of_zero {n : Nat} (f : (Fin n → Bool) → Bool)
    (zero x : Fin n → Bool) (hz : f zero = false) :
    f (lowenheim f zero x) = false := by
  cases hx : f x
  · have hphi : lowenheim f zero x = x := by
      funext i
      simp [lowenheim, hx]
    rw [hphi, hx]
  · have hphi : lowenheim f zero x = zero := by
      funext i
      simp [lowenheim, hx]
    rw [hphi, hz]

theorem lowenheim_fixed {n : Nat} (f : (Fin n → Bool) → Bool)
    (zero x : Fin n → Bool) (hx : f x = false) :
    lowenheim f zero x = x := by
  funext i
  simp [lowenheim, hx]

theorem lowenheim_fixed_iff {n : Nat} (f : (Fin n → Bool) → Bool)
    (zero x : Fin n → Bool) (hz : f zero = false) :
    lowenheim f zero x = x ↔ f x = false := by
  constructor
  · intro hfixed
    have hzero := lowenheim_of_zero f zero x hz
    simpa [hfixed] using hzero
  · exact lowenheim_fixed f zero x

theorem lowenheim_idempotent {n : Nat} (f : (Fin n → Bool) → Bool)
    (zero x : Fin n → Bool) (hz : f zero = false) :
    lowenheim f zero (lowenheim f zero x) = lowenheim f zero x :=
  lowenheim_fixed f zero (lowenheim f zero x) (lowenheim_of_zero f zero x hz)

/-- The image of Löwenheim's reproductive solution is exactly the zero-set. -/
theorem lowenheim_range_iff {n : Nat} (f : (Fin n → Bool) → Bool)
    (zero y : Fin n → Bool) (hz : f zero = false) :
    (∃ x, lowenheim f zero x = y) ↔ f y = false := by
  constructor
  · rintro ⟨x, h⟩
    rw [← h]
    exact lowenheim_of_zero f zero x hz
  · intro hy
    exact ⟨y, lowenheim_fixed f zero y hy⟩

end Pairfield
