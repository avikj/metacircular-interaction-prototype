import Mathlib.Order.BooleanAlgebra.Basic

namespace Pairfield

universe u

variable {B : Type u} [BooleanAlgebra B]

def pointwiseRevision (project : B → B) (update current : B) : B :=
  update ⊓ ((project (update ⊓ current))ᶜ ⊔ current)

theorem pointwiseRevision_eq
    (project : B → B) (update current : B) :
    pointwiseRevision project update current =
      (update ⊓ (project (update ⊓ current))ᶜ) ⊔ (update ⊓ current) := by
  simp only [pointwiseRevision, inf_sup_left]

theorem pointwiseRevision_le_update
    (project : B → B) (update current : B) :
    pointwiseRevision project update current ≤ update :=
  inf_le_left

theorem pointwiseRevision_of_project_eq_bot
    (project : B → B) (update current : B)
    (h : project (update ⊓ current) = ⊥) :
    pointwiseRevision project update current = update := by
  simp [pointwiseRevision, h]

theorem pointwiseRevision_of_project_eq_top
    (project : B → B) (update current : B)
    (h : project (update ⊓ current) = ⊤) :
    pointwiseRevision project update current = update ⊓ current := by
  simp [pointwiseRevision, h]

theorem pointwiseRevision_inf_current
    (project : B → B) (update current : B) :
    pointwiseRevision project update current ⊓ current = update ⊓ current := by
  simp [pointwiseRevision, inf_left_comm, inf_comm]

theorem pointwiseRevision_inf_project_le_current
    (project : B → B) (update current : B) :
    pointwiseRevision project update current ⊓
        project (update ⊓ current) ≤ current := by
  let compatible := project (update ⊓ current)
  change (update ⊓ (compatibleᶜ ⊔ current)) ⊓ compatible ≤ current
  calc
    (update ⊓ (compatibleᶜ ⊔ current)) ⊓ compatible ≤
        (compatibleᶜ ⊔ current) ⊓ compatible :=
      inf_le_inf_right compatible inf_le_right
    _ = (compatibleᶜ ⊓ compatible) ⊔ (current ⊓ compatible) :=
      inf_sup_right _ _ _
    _ ≤ current := by simp

theorem le_pointwiseRevision_iff
    (project : B → B) (update current candidate : B) :
    candidate ≤ pointwiseRevision project update current ↔
      candidate ≤ update ∧
      candidate ⊓ project (update ⊓ current) ≤ current := by
  let compatible := project (update ⊓ current)
  change candidate ≤ update ⊓ (compatibleᶜ ⊔ current) ↔
    candidate ≤ update ∧ candidate ⊓ compatible ≤ current
  rw [le_inf_iff]
  constructor
  · rintro ⟨hupdate, hguard⟩
    refine ⟨hupdate, ?_⟩
    calc
      candidate ⊓ compatible ≤ (compatibleᶜ ⊔ current) ⊓ compatible :=
        inf_le_inf_right compatible hguard
      _ = (compatibleᶜ ⊓ compatible) ⊔ (current ⊓ compatible) :=
        inf_sup_right _ _ _
      _ ≤ current := by simp
  · rintro ⟨hupdate, hcompatible⟩
    refine ⟨hupdate, ?_⟩
    calc
      candidate = (candidate ⊓ compatible) ⊔ (candidate ⊓ compatibleᶜ) := by
        rw [← inf_sup_left]
        simp
      _ ≤ current ⊔ compatibleᶜ :=
        sup_le (hcompatible.trans le_sup_left) (inf_le_right.trans le_sup_right)
      _ = compatibleᶜ ⊔ current := sup_comm _ _

theorem pointwiseRevision_eq_update_iff
    (project : B → B) (update current : B) :
    pointwiseRevision project update current = update ↔
      update ⊓ project (update ⊓ current) ≤ current := by
  rw [pointwiseRevision, inf_eq_left]
  let compatible := project (update ⊓ current)
  change update ≤ compatibleᶜ ⊔ current ↔ update ⊓ compatible ≤ current
  constructor
  · intro h
    calc
      update ⊓ compatible ≤ (compatibleᶜ ⊔ current) ⊓ compatible :=
        inf_le_inf_right compatible h
      _ = (compatibleᶜ ⊓ compatible) ⊔ (current ⊓ compatible) :=
        inf_sup_right _ _ _
      _ ≤ current := by simp
  · intro h
    calc
      update = (update ⊓ compatible) ⊔ (update ⊓ compatibleᶜ) := by
        rw [← inf_sup_left]
        simp
      _ ≤ current ⊔ compatibleᶜ :=
        sup_le (h.trans le_sup_left) (inf_le_right.trans le_sup_right)
      _ = compatibleᶜ ⊔ current := sup_comm _ _

end Pairfield
