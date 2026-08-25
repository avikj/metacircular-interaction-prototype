import Pairfield.EuclidCoefficientCutBound
import Mathlib.Data.Finset.Union
import Mathlib.Data.Finset.Max
import Mathlib.Data.Int.Interval

/-!
# Finite-target formation on the signed-unit integer line

For a finite set of requested integer coefficients, a formation chooses one
replayable signed-unit trace from zero to every target and pays once for each
undirected unit cut used by any trace.  Direct monotone traces are universally
minimal.  Their shared cut set is exactly the half-open interval from the
minimum to the maximum of `targets ∪ {0}`, so the minimum cost is its width.

Thus the fixed `{2,-1}` cut certificate was not exceptional: in the unary
grammar every finite formation collapses to one interval, and detours or
displayed shared prefixes cannot improve it.
-/

namespace Pairfield

/-- Repeating increments translates the starting coefficient by `n`. -/
theorem runCoefficientTrace_replicate_inc (z : Int) (n : Nat) :
    runCoefficientTrace z (List.replicate n .inc) = z + (n : Int) := by
  induction n generalizing z with
  | zero => simp [runCoefficientTrace]
  | succ n ih =>
      rw [List.replicate_succ]
      simp only [runCoefficientTrace, SignedUnitStep.apply]
      rw [ih]
      omega

/-- Repeating decrements translates the starting coefficient by `-n`. -/
theorem runCoefficientTrace_replicate_dec (z : Int) (n : Nat) :
    runCoefficientTrace z (List.replicate n .dec) = z - (n : Int) := by
  induction n generalizing z with
  | zero => simp [runCoefficientTrace]
  | succ n ih =>
      rw [List.replicate_succ]
      simp only [runCoefficientTrace, SignedUnitStep.apply]
      rw [ih]
      omega

/-- Incrementing `n` times crosses exactly the cuts in `[z,z+n)`. -/
theorem mem_coefficientTraceCuts_replicate_inc
    (z k : Int) (n : Nat) :
    k ∈ coefficientTraceCuts z (List.replicate n .inc) ↔
      z ≤ k ∧ k < z + (n : Int) := by
  induction n generalizing z with
  | zero => simp [coefficientTraceCuts]
  | succ n ih =>
      rw [List.replicate_succ]
      simp only [coefficientTraceCuts, SignedUnitStep.cut,
        SignedUnitStep.apply, Finset.mem_insert]
      rw [ih]
      omega

/-- Decrementing `n` times crosses exactly the cuts in `[z-n,z)`. -/
theorem mem_coefficientTraceCuts_replicate_dec
    (z k : Int) (n : Nat) :
    k ∈ coefficientTraceCuts z (List.replicate n .dec) ↔
      z - (n : Int) ≤ k ∧ k < z := by
  induction n generalizing z with
  | zero => simp [coefficientTraceCuts]
  | succ n ih =>
      rw [List.replicate_succ]
      simp only [coefficientTraceCuts, SignedUnitStep.cut,
        SignedUnitStep.apply, Finset.mem_insert]
      rw [ih]
      omega

/-- The monotone signed-unit trace from zero to an arbitrary integer. -/
def directCoefficientTrace : Int → List SignedUnitStep
  | .ofNat n => List.replicate n .inc
  | .negSucc n => List.replicate (n + 1) .dec

theorem run_directCoefficientTrace (target : Int) :
    runCoefficientTrace 0 (directCoefficientTrace target) = target := by
  cases target with
  | ofNat n =>
      simp [directCoefficientTrace, runCoefficientTrace_replicate_inc]
  | negSucc n =>
      rw [directCoefficientTrace, runCoefficientTrace_replicate_dec]
      omega

/-- A direct trace crosses exactly the cuts separating zero from its target. -/
theorem mem_directCoefficientTraceCuts_iff (target k : Int) :
    k ∈ coefficientTraceCuts 0 (directCoefficientTrace target) ↔
      (0 ≤ k ∧ k < target) ∨ (target ≤ k ∧ k < 0) := by
  cases target with
  | ofNat n =>
      rw [directCoefficientTrace, mem_coefficientTraceCuts_replicate_inc]
      simp only [Int.ofNat_eq_natCast]
      omega
  | negSucc n =>
      rw [directCoefficientTrace, mem_coefficientTraceCuts_replicate_dec]
      omega

/-- Every valid trace to `target` contains all cuts of the direct trace. -/
theorem directCoefficientTraceCuts_subset_of_valid
    (target : Int) (trace : List SignedUnitStep)
    (valid : runCoefficientTrace 0 trace = target) :
    coefficientTraceCuts 0 (directCoefficientTrace target) ⊆
      coefficientTraceCuts 0 trace := by
  intro k hk
  rcases (mem_directCoefficientTraceCuts_iff target k).mp hk with
    hpositive | hnegative
  · by_contra hcut
    have hbound :=
      runCoefficientTrace_le_of_cut_not_mem k 0 trace hpositive.1 hcut
    rw [valid] at hbound
    omega
  · by_contra hcut
    have hbound :=
      runCoefficientTrace_ge_of_cut_not_mem k 0 trace (by omega) hcut
    rw [valid] at hbound
    omega

/-- A formation supplies one valid trace for every member of a finite target
set.  Its trace function is total only to avoid dependent lookup plumbing;
validity and cost inspect members of `targets` exclusively. -/
structure FiniteTargetFormation (targets : Finset Int) where
  trace : Int → List SignedUnitStep
  valid : ∀ target ∈ targets, runCoefficientTrace 0 (trace target) = target

namespace FiniteTargetFormation

/-- Reusable work is the union of the integer cuts used by all target traces. -/
def cuts {targets : Finset Int} (formation : FiniteTargetFormation targets) :
    Finset Int :=
  targets.biUnion fun target => coefficientTraceCuts 0 (formation.trace target)

def cost {targets : Finset Int} (formation : FiniteTargetFormation targets) : Nat :=
  formation.cuts.card

/-- The canonical formation chooses the monotone trace to each target. -/
def direct (targets : Finset Int) : FiniteTargetFormation targets where
  trace := directCoefficientTrace
  valid := fun target _ => run_directCoefficientTrace target

/-- Direct formation is cutwise, hence costwise, below every valid formation. -/
theorem direct_cuts_subset {targets : Finset Int}
    (formation : FiniteTargetFormation targets) :
    (direct targets).cuts ⊆ formation.cuts := by
  intro k hk
  simp only [cuts, direct, Finset.mem_biUnion] at hk ⊢
  rcases hk with ⟨target, htarget, hk⟩
  exact ⟨target, htarget,
    directCoefficientTraceCuts_subset_of_valid target
      (formation.trace target) (formation.valid target htarget) hk⟩

theorem direct_cost_le {targets : Finset Int}
    (formation : FiniteTargetFormation targets) :
    (direct targets).cost ≤ formation.cost :=
  Finset.card_le_card (direct_cuts_subset formation)

/-- Adjoin the origin before taking the convex hull of the targets. -/
def hull (targets : Finset Int) : Finset Int :=
  insert 0 targets

theorem hull_nonempty (targets : Finset Int) : (hull targets).Nonempty :=
  ⟨0, by simp [hull]⟩

def lower (targets : Finset Int) : Int :=
  (hull targets).min' (hull_nonempty targets)

def upper (targets : Finset Int) : Int :=
  (hull targets).max' (hull_nonempty targets)

theorem lower_mem_hull (targets : Finset Int) :
    lower targets ∈ hull targets :=
  Finset.min'_mem _ _

theorem upper_mem_hull (targets : Finset Int) :
    upper targets ∈ hull targets :=
  Finset.max'_mem _ _

theorem lower_le_of_mem_hull {targets : Finset Int} {z : Int}
    (hz : z ∈ hull targets) : lower targets ≤ z :=
  Finset.min'_le _ _ hz

theorem le_upper_of_mem_hull {targets : Finset Int} {z : Int}
    (hz : z ∈ hull targets) : z ≤ upper targets :=
  Finset.le_max' _ _ hz

/-- The direct shared cut set is precisely the convex-hull interval. -/
theorem direct_cuts_eq_Ico (targets : Finset Int) :
    (direct targets).cuts = Finset.Ico (lower targets) (upper targets) := by
  ext k
  simp only [cuts, direct, Finset.mem_biUnion, Finset.mem_Ico]
  constructor
  · rintro ⟨target, htarget, hk⟩
    have htargetHull : target ∈ hull targets := by
      simp [hull, htarget]
    have hzeroHull : 0 ∈ hull targets := by
      simp [hull]
    have hlowerTarget := lower_le_of_mem_hull htargetHull
    have hlowerZero := lower_le_of_mem_hull hzeroHull
    have htargetUpper := le_upper_of_mem_hull htargetHull
    have hzeroUpper := le_upper_of_mem_hull hzeroHull
    rcases (mem_directCoefficientTraceCuts_iff target k).mp hk with
      hpositive | hnegative <;> omega
  · rintro ⟨hlower, hupper⟩
    by_cases hnegative : k < 0
    · have hlowerNe : lower targets ≠ 0 := by omega
      have hlowerTarget : lower targets ∈ targets := by
        have hmem := lower_mem_hull targets
        simp only [hull, Finset.mem_insert] at hmem
        rcases hmem with hzero | htarget
        · exact (hlowerNe hzero).elim
        · exact htarget
      refine ⟨lower targets, hlowerTarget, ?_⟩
      exact (mem_directCoefficientTraceCuts_iff (lower targets) k).mpr
        (Or.inr ⟨hlower, hnegative⟩)
    · have hzero : 0 ≤ k := le_of_not_gt hnegative
      have hupperNe : upper targets ≠ 0 := by omega
      have hupperTarget : upper targets ∈ targets := by
        have hmem := upper_mem_hull targets
        simp only [hull, Finset.mem_insert] at hmem
        rcases hmem with hzeroEq | htarget
        · exact (hupperNe hzeroEq).elim
        · exact htarget
      refine ⟨upper targets, hupperTarget, ?_⟩
      exact (mem_directCoefficientTraceCuts_iff (upper targets) k).mpr
        (Or.inl ⟨hzero, hupper⟩)

/-- Exact optimum: interval width, attained by direct monotone traces. -/
theorem direct_cost_eq_intervalWidth (targets : Finset Int) :
    (direct targets).cost = (upper targets - lower targets).toNat := by
  rw [cost, direct_cuts_eq_Ico]
  exact Int.card_Ico (lower targets) (upper targets)

theorem intervalWidth_le_cost {targets : Finset Int}
    (formation : FiniteTargetFormation targets) :
    (upper targets - lower targets).toNat ≤ formation.cost := by
  rw [← direct_cost_eq_intervalWidth]
  exact direct_cost_le formation

/-- Full finite-target optimality in the signed-unit cut grammar. -/
theorem direct_is_minimal (targets : Finset Int) :
    (direct targets).cost = (upper targets - lower targets).toNat ∧
      ∀ formation : FiniteTargetFormation targets,
        (upper targets - lower targets).toNat ≤ formation.cost :=
  ⟨direct_cost_eq_intervalWidth targets, intervalWidth_le_cost⟩

/-- The previous kuṭṭaka target pair is recovered with interval width three. -/
theorem kuttaka_target_interval_cost :
    (direct ({2, -1} : Finset Int)).cost = 3 := by
  decide

end FiniteTargetFormation

end Pairfield
