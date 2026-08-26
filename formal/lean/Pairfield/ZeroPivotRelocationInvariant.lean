import Pairfield.SmithContent

/-!
# Zero-pivot relocation preserves presentation invariants

The total `GeneralSmith2x2.smith` producer already handles every zero-pivot
matrix.  This leaf extracts its first chart change as a small typed API: choose
the lower-left entry first, otherwise the upper-right entry, otherwise stop at
the diagonal endpoint.  Relocation can increase the visible pivot, while the
determinant magnitude and matrix content remain invariant.
-/

namespace Pairfield.ZeroPivotRelocationInvariant

inductive Route where
  | endpoint
  | row
  | column
  deriving DecidableEq, Repr

/-- Canonical row-first route.  It is intended for matrices with zero leading
pivot; keeping the definition total makes the branch equations reusable. -/
def route (A : IntMat2) : Route :=
  if A.a10 ≠ 0 then .row
  else if A.a01 ≠ 0 then .column
  else .endpoint

theorem route_eq_row_iff (A : IntMat2) :
    route A = .row ↔ A.a10 ≠ 0 := by
  constructor
  · intro hroute hlower
    by_cases hupper : A.a01 = 0
    · simp [route, hlower, hupper] at hroute
    · simp [route, hlower, hupper] at hroute
  · intro hlower
    simp [route, hlower]

theorem route_eq_column_iff (A : IntMat2) :
    route A = .column ↔ A.a10 = 0 ∧ A.a01 ≠ 0 := by
  constructor
  · intro hroute
    by_cases hlower : A.a10 = 0
    · refine ⟨hlower, ?_⟩
      intro hupper
      simp [route, hlower, hupper] at hroute
    · simp [route, hlower] at hroute
  · rintro ⟨hlower, hupper⟩
    simp [route, hlower, hupper]

theorem route_eq_endpoint_iff (A : IntMat2) :
    route A = .endpoint ↔ A.a10 = 0 ∧ A.a01 = 0 := by
  constructor
  · intro hroute
    by_cases hlower : A.a10 = 0
    · refine ⟨hlower, ?_⟩
      by_cases hupper : A.a01 = 0
      · exact hupper
      · simp [route, hlower, hupper] at hroute
    · simp [route, hlower] at hroute
  · rintro ⟨hlower, hupper⟩
    simp [route, hlower, hupper]

/-- The lower-left witness wins even when the upper-right entry is also
nonzero. -/
theorem row_precedence (A : IntMat2) (hlower : A.a10 ≠ 0) :
    route A = .row :=
  (route_eq_row_iff A).2 hlower

/-- One exact unimodular presentation change, aligned with `route`. -/
def relocate (A : IntMat2) : Reduction A :=
  if _hlower : A.a10 ≠ 0 then
    Reduction.byLeft A IntMat2.swap IntMat2.swap_unimodular
  else if _hupper : A.a01 ≠ 0 then
    Reduction.byRight A IntMat2.swap IntMat2.swap_unimodular
  else
    Reduction.id A

theorem relocate_target_of_row {A : IntMat2} (hlower : A.a10 ≠ 0) :
    (relocate A).target = IntMat2.swap * A := by
  simp [relocate, hlower, Reduction.byLeft]

theorem relocate_target_of_column {A : IntMat2}
    (hlower : A.a10 = 0) (hupper : A.a01 ≠ 0) :
    (relocate A).target = A * IntMat2.swap := by
  simp [relocate, hlower, hupper, Reduction.byRight]

theorem relocate_target_of_endpoint {A : IntMat2}
    (hlower : A.a10 = 0) (hupper : A.a01 = 0) :
    (relocate A).target = A := by
  simp [relocate, hlower, hupper, Reduction.id]

theorem relocated_pivot_of_row {A : IntMat2} (hlower : A.a10 ≠ 0) :
    (relocate A).target.a00 = A.a10 := by
  rw [relocate_target_of_row hlower]
  simp [IntMat2.mul_def, IntMat2.mul, IntMat2.swap]

theorem relocated_pivot_of_column {A : IntMat2}
    (hlower : A.a10 = 0) (hupper : A.a01 ≠ 0) :
    (relocate A).target.a00 = A.a01 := by
  rw [relocate_target_of_column hlower hupper]
  simp [IntMat2.mul_def, IntMat2.mul, IntMat2.swap]

/-- Under the zero-pivot premise, the endpoint branch is exactly the already
diagonal matrix `diag(0,d)`.  This local endpoint is not normalized further. -/
theorem endpoint_iff_diagonal {A : IntMat2} (hpivot : A.a00 = 0) :
    route A = .endpoint ↔ A = IntMat2.diagonal 0 A.a11 := by
  rw [route_eq_endpoint_iff]
  constructor
  · rintro ⟨hlower, hupper⟩
    apply IntMat2.ext <;>
      simp [IntMat2.diagonal, hpivot, hlower, hupper]
  · intro hdiag
    constructor
    · have h := congrArg IntMat2.a10 hdiag
      simpa [IntMat2.diagonal] using h
    · have h := congrArg IntMat2.a01 hdiag
      simpa [IntMat2.diagonal] using h

/-! ## The presentation invariants -/

/-- Every exact `Reduction`, not only relocation, preserves determinant
magnitude because both replay matrices are unimodular. -/
theorem reduction_det_natAbs_preserved {A : IntMat2} (red : Reduction A) :
    red.target.det.natAbs = A.det.natAbs := by
  have hdet := congrArg IntMat2.det red.replay
  rw [IntMat2.det_mul, IntMat2.det_mul] at hdet
  rw [hdet, Int.natAbs_mul, Int.natAbs_mul,
    red.left_unimodular, red.right_unimodular]
  simp

/-- Matrix content is likewise invariant under the two unimodular replay
coordinates. -/
theorem reduction_content_preserved {A : IntMat2} (red : Reduction A) :
    red.target.content = A.content := by
  rw [red.replay,
    IntMat2.content_mul_right _ _ red.right_unimodular,
    IntMat2.content_mul_left _ _ red.left_unimodular]

theorem relocate_det_natAbs (A : IntMat2) :
    (relocate A).target.det.natAbs = A.det.natAbs :=
  reduction_det_natAbs_preserved (relocate A)

theorem relocate_content (A : IntMat2) :
    (relocate A).target.content = A.content :=
  reduction_content_preserved (relocate A)

/-! ## Raw pivot is not a descent measure -/

/-- Every nonendpoint relocation from a zero pivot strictly raises its
absolute pivot from zero to the chosen nonzero entry. -/
theorem zero_pivot_relocation_increases {A : IntMat2}
    (hpivot : A.a00 = 0) (nonendpoint : route A ≠ .endpoint) :
    A.a00.natAbs < (relocate A).target.a00.natAbs := by
  rw [hpivot]
  simp only [Int.natAbs_zero]
  by_cases hlower : A.a10 ≠ 0
  · rw [relocated_pivot_of_row hlower]
    exact Int.natAbs_pos.mpr hlower
  · have hlowerZero : A.a10 = 0 := not_ne_iff.mp hlower
    have hupper : A.a01 ≠ 0 := by
      intro hupperZero
      apply nonendpoint
      exact (route_eq_endpoint_iff A).2 ⟨hlowerZero, hupperZero⟩
    rw [relocated_pivot_of_column hlowerZero hupper]
    exact Int.natAbs_pos.mpr hupper

/-- Both possible witnesses are present; the row-first rule chooses `3`. -/
def rowPrecedenceControl : IntMat2 := ⟨0, 7, 3, 11⟩

theorem rowPrecedenceControl_route : route rowPrecedenceControl = .row := by
  native_decide

theorem rowPrecedenceControl_pivot_rises :
    rowPrecedenceControl.a00.natAbs <
      (relocate rowPrecedenceControl).target.a00.natAbs := by
  exact zero_pivot_relocation_increases (by decide) (by decide)

/-- Consequently raw pivot magnitude cannot strictly decrease at every
nonendpoint operation in a reducer that includes relocation. -/
theorem raw_pivot_not_global_descent :
    ¬ ∀ A : IntMat2, route A ≠ .endpoint →
      (relocate A).target.a00.natAbs < A.a00.natAbs := by
  intro globalDescent
  have decreases := globalDescent rowPrecedenceControl (by decide)
  exact (Nat.not_lt_of_ge
    (Nat.le_of_lt rowPrecedenceControl_pivot_rises)) decreases

end Pairfield.ZeroPivotRelocationInvariant
