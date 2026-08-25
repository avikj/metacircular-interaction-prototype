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

private theorem partition (a u : B) :
    u = (a ⊓ u) ⊔ (aᶜ ⊓ u) := by
  calc
    u = ⊤ ⊓ u := (top_inf_eq u).symm
    _ = (a ⊔ aᶜ) ⊓ u := by rw [sup_compl_eq_top]
    _ = (a ⊓ u) ⊔ (aᶜ ⊓ u) := inf_sup_right a aᶜ u

private theorem select_left (a u v : B) :
    a ⊓ ((a ⊓ u) ⊔ (aᶜ ⊓ v)) = a ⊓ u := by
  rw [inf_sup_left]
  simp [← inf_assoc]

private theorem select_right (a u v : B) :
    aᶜ ⊓ ((a ⊓ u) ⊔ (aᶜ ⊓ v)) = aᶜ ⊓ v := by
  rw [inf_sup_left]
  simp [← inf_assoc]

private theorem select_inf_left (a u v r s : B) :
    a ⊓ (((a ⊓ u) ⊔ (aᶜ ⊓ v)) ⊓ ((a ⊓ r) ⊔ (aᶜ ⊓ s))) =
      a ⊓ (u ⊓ r) := by
  let p := (a ⊓ u) ⊔ (aᶜ ⊓ v)
  let q := (a ⊓ r) ⊔ (aᶜ ⊓ s)
  calc
    a ⊓ (p ⊓ q) = (a ⊓ a) ⊓ (p ⊓ q) := by rw [inf_idem]
    _ = (a ⊓ p) ⊓ (a ⊓ q) := by ac_rfl
    _ = (a ⊓ u) ⊓ (a ⊓ r) := by rw [select_left, select_left]
    _ = (a ⊓ a) ⊓ (u ⊓ r) := by ac_rfl
    _ = a ⊓ (u ⊓ r) := by rw [inf_idem]

private theorem select_inf_right (a u v r s : B) :
    aᶜ ⊓ (((a ⊓ u) ⊔ (aᶜ ⊓ v)) ⊓ ((a ⊓ r) ⊔ (aᶜ ⊓ s))) =
      aᶜ ⊓ (v ⊓ s) := by
  let p := (a ⊓ u) ⊔ (aᶜ ⊓ v)
  let q := (a ⊓ r) ⊔ (aᶜ ⊓ s)
  calc
    aᶜ ⊓ (p ⊓ q) = (aᶜ ⊓ aᶜ) ⊓ (p ⊓ q) := by rw [inf_idem]
    _ = (aᶜ ⊓ p) ⊓ (aᶜ ⊓ q) := by ac_rfl
    _ = (aᶜ ⊓ v) ⊓ (aᶜ ⊓ s) := by rw [select_right, select_right]
    _ = (aᶜ ⊓ aᶜ) ⊓ (v ⊓ s) := by ac_rfl
    _ = aᶜ ⊓ (v ⊓ s) := by rw [inf_idem]

private theorem select_sup_left (a u v r s : B) :
    a ⊓ (((a ⊓ u) ⊔ (aᶜ ⊓ v)) ⊔ ((a ⊓ r) ⊔ (aᶜ ⊓ s))) =
      a ⊓ (u ⊔ r) := by
  simp [inf_sup_left, ← inf_assoc]

private theorem select_sup_right (a u v r s : B) :
    aᶜ ⊓ (((a ⊓ u) ⊔ (aᶜ ⊓ v)) ⊔ ((a ⊓ r) ⊔ (aᶜ ⊓ s))) =
      aᶜ ⊓ (v ⊔ s) := by
  simp [inf_sup_left, ← inf_assoc]

private theorem select_compl_left (a u v : B) :
    a ⊓ ((a ⊓ u) ⊔ (aᶜ ⊓ v))ᶜ = a ⊓ uᶜ := by
  rw [← sdiff_eq, ← sdiff_eq]
  exact sdiff_eq_sdiff_iff_inf_eq_inf.mpr (select_left a u v)

private theorem select_compl_right (a u v : B) :
    aᶜ ⊓ ((a ⊓ u) ⊔ (aᶜ ⊓ v))ᶜ = aᶜ ⊓ vᶜ := by
  rw [← sdiff_eq, ← sdiff_eq]
  exact sdiff_eq_sdiff_iff_inf_eq_inf.mpr (select_right a u v)

private theorem eq_of_select (a u v : B)
    (left : a ⊓ u = a ⊓ v)
    (right : aᶜ ⊓ u = aᶜ ⊓ v) : u = v := by
  rw [partition a u, partition a v, left, right]

theorem eval_patch (p : BooleanFunction B n) (a : B) (z x : Fin n → B) :
    eval p (patch a z x) = (a ⊓ eval p z) ⊔ (aᶜ ⊓ eval p x) := by
  induction p with
  | var i => rfl
  | const c => exact partition a c
  | bot => simp [eval]
  | top => simp [eval]
  | inf p q ihp ihq =>
      rw [eval, ihp, ihq, eval, eval]
      apply eq_of_select a
      · rw [select_inf_left, select_left]
      · rw [select_inf_right, select_right]
  | sup p q ihp ihq =>
      rw [eval, ihp, ihq, eval, eval]
      apply eq_of_select a
      · rw [select_sup_left, select_left]
      · rw [select_sup_right, select_right]
  | compl p ih =>
      rw [eval, ih, eval, eval]
      apply eq_of_select a
      · rw [select_compl_left, select_left]
      · rw [select_compl_right, select_right]

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
