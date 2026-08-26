/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact finite ambiguity consumed by one safe Boolean split in a
residual-labelled adaptive distinguishing tree.
-/
import Pairfield.AdaptiveResidualPartition

namespace Pairfield

universe u v

namespace FiniteLiveCell

variable {Candidate : Type u} {Next : Type v}
variable [DecidableEq Candidate] [DecidableEq Next]

/-- The candidates in one live cell that return the declared response. -/
def responseFiber (cell : Finset Candidate) (response : Candidate → Bool)
    (answer : Bool) : Finset Candidate :=
  cell.filter fun candidate => response candidate = answer

/-- The distinct advanced residual representatives in one response branch. -/
def advancedBranch (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next) (answer : Bool) : Finset Next :=
  (responseFiber cell response answer).image advance

/-- Finite form of the live-cell safety law: within one response fiber, the
advance map is injective, so no two still-indistinguishable candidates merge. -/
def SafeAdvance (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next) : Prop :=
  ∀ ⦃left right : Candidate⦄,
    left ∈ cell → right ∈ cell →
    response left = response right →
    advance left = advance right → left = right

/-- The square cardinality is the ordered ambiguity potential, including the
diagonal.  It is chosen because its Boolean splitting law has no subtraction. -/
def squarePotential (cell : Finset Candidate) : Nat :=
  cell.card * cell.card

theorem safeAdvance_injOn_responseFiber
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next) (answer : Bool)
    (hsafe : SafeAdvance cell response advance) :
    Set.InjOn advance (responseFiber cell response answer) := by
  intro left hleft right hright hadvance
  have hleftData := Finset.mem_filter.mp hleft
  have hrightData := Finset.mem_filter.mp hright
  have hleftCell := hleftData.1
  have hrightCell := hrightData.1
  have hleftResponse := hleftData.2
  have hrightResponse := hrightData.2
  exact hsafe hleftCell hrightCell
    (hleftResponse.trans hrightResponse.symm) hadvance

/-- Safety preserves the exact number of candidates inside each branch. -/
theorem card_advancedBranch
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next) (answer : Bool)
    (hsafe : SafeAdvance cell response advance) :
    (advancedBranch cell response advance answer).card =
      (responseFiber cell response answer).card := by
  exact Finset.card_image_of_injOn
    (safeAdvance_injOn_responseFiber cell response advance answer hsafe)

/-- The two Boolean response fibers partition the live cell exactly. -/
theorem card_responseFibers
    (cell : Finset Candidate) (response : Candidate → Bool) :
    cell.card =
      (responseFiber cell response false).card +
        (responseFiber cell response true).card := by
  simpa [responseFiber] using
    (Finset.card_filter_add_card_filter_not
      (s := cell) (p := fun candidate => response candidate = false)).symm

/-- Exact safe-split law.  The cross term is precisely the ambiguity removed
by learning which Boolean response occurred. -/
theorem squarePotential_split
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next)
    (hsafe : SafeAdvance cell response advance) :
    squarePotential cell =
      squarePotential (advancedBranch cell response advance false) +
        squarePotential (advancedBranch cell response advance true) +
          2 * (advancedBranch cell response advance false).card *
            (advancedBranch cell response advance true).card := by
  have hfalse := card_advancedBranch cell response advance false hsafe
  have htrue := card_advancedBranch cell response advance true hsafe
  have hpartition := card_responseFibers cell response
  simp only [squarePotential]
  rw [hfalse, htrue, hpartition]
  ring

/-- A safe action strictly decreases total branch ambiguity exactly when it
actually realizes both responses.  Safety alone is not progress. -/
theorem branchPotential_lt_iff_both_nonempty
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next)
    (hsafe : SafeAdvance cell response advance) :
    squarePotential (advancedBranch cell response advance false) +
          squarePotential (advancedBranch cell response advance true) <
        squarePotential cell ↔
      (advancedBranch cell response advance false).Nonempty ∧
        (advancedBranch cell response advance true).Nonempty := by
  let falseBranch := advancedBranch cell response advance false
  let trueBranch := advancedBranch cell response advance true
  have hsplit := squarePotential_split cell response advance hsafe
  change squarePotential falseBranch + squarePotential trueBranch <
      squarePotential cell ↔ falseBranch.Nonempty ∧ trueBranch.Nonempty
  change squarePotential cell = squarePotential falseBranch +
      squarePotential trueBranch + 2 * falseBranch.card * trueBranch.card at hsplit
  constructor
  · intro hlt
    constructor
    · by_contra hempty
      rw [Finset.not_nonempty_iff_eq_empty.mp hempty] at hsplit hlt
      simp [squarePotential] at hsplit hlt
      rw [hsplit] at hlt
      exact Nat.lt_irrefl _ hlt
    · by_contra hempty
      rw [Finset.not_nonempty_iff_eq_empty.mp hempty] at hsplit hlt
      simp [squarePotential] at hsplit hlt
      rw [hsplit] at hlt
      exact Nat.lt_irrefl _ hlt
  · rintro ⟨hfalse, htrue⟩
    have hfalseCard : 0 < falseBranch.card := Finset.card_pos.mpr hfalse
    have htrueCard : 0 < trueBranch.card := Finset.card_pos.mpr htrue
    have hcross : 0 < 2 * falseBranch.card * trueBranch.card :=
      Nat.mul_pos (Nat.mul_pos (by decide) hfalseCard) htrueCard
    omega

/-- Equality is the exact no-progress boundary: one of the two advanced
response branches is empty. -/
theorem branchPotential_eq_iff_empty_branch
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next)
    (hsafe : SafeAdvance cell response advance) :
    squarePotential (advancedBranch cell response advance false) +
          squarePotential (advancedBranch cell response advance true) =
        squarePotential cell ↔
      advancedBranch cell response advance false = ∅ ∨
        advancedBranch cell response advance true = ∅ := by
  let falseBranch := advancedBranch cell response advance false
  let trueBranch := advancedBranch cell response advance true
  have hsplit := squarePotential_split cell response advance hsafe
  change squarePotential falseBranch + squarePotential trueBranch =
      squarePotential cell ↔ falseBranch = ∅ ∨ trueBranch = ∅
  change squarePotential cell = squarePotential falseBranch +
      squarePotential trueBranch + 2 * falseBranch.card * trueBranch.card at hsplit
  constructor
  · intro heq
    have hcross : 2 * falseBranch.card * trueBranch.card = 0 := by
      omega
    rcases Nat.mul_eq_zero.mp hcross with hfalseProduct | htrue
    · rcases Nat.mul_eq_zero.mp hfalseProduct with htwo | hfalse
      · omega
      · exact Or.inl (Finset.card_eq_zero.mp hfalse)
    · exact Or.inr (Finset.card_eq_zero.mp htrue)
  · intro hempty
    rcases hempty with hfalse | htrue
    · rw [hfalse] at hsplit ⊢
      simpa [squarePotential] using hsplit.symm
    · rw [htrue] at hsplit ⊢
      simpa [squarePotential] using hsplit.symm

namespace Control

/-- The identity action with a constant response is safe. -/
theorem constantFalse_safe :
    SafeAdvance ({false, true} : Finset Bool) (fun _ => false) id := by
  intro left right _hleft _hright _hresponse hadvance
  exact hadvance

/-- Planted equality case: the safe action consumes no ambiguity because it
does not split the two candidates. -/
theorem constantFalse_no_progress :
    squarePotential
        (advancedBranch ({false, true} : Finset Bool) (fun _ => false) id false) +
      squarePotential
        (advancedBranch ({false, true} : Finset Bool) (fun _ => false) id true) =
      squarePotential ({false, true} : Finset Bool) := by
  decide

/-- A genuine Boolean split fires the strict branch-potential control. -/
theorem identityResponse_strict_progress :
    squarePotential
        (advancedBranch ({false, true} : Finset Bool) id id false) +
      squarePotential
        (advancedBranch ({false, true} : Finset Bool) id id true) <
      squarePotential ({false, true} : Finset Bool) := by
  decide

end Control

end FiniteLiveCell

namespace ResidualCell

variable {A : Type u} {X : Type v}

/-- Choosing one prefix representative per live residual transports the
recursive certificate's local safety law to the finite ambiguity theorem. -/
theorem safeAction_to_finiteSafeAdvance
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Set (List A)) (representatives : Finset (List A)) (action : A)
    (hrepresentatives : ∀ pre ∈ representatives, cell pre)
    (hinjective : Set.InjOn (BranchResidual M) representatives)
    (hsafe : ResidualCell.SafeAction M cell action) :
    FiniteLiveCell.SafeAdvance representatives
      (fun pre => acceptsBool M (M.eval (pre ++ [action])))
      (fun pre => BranchResidual M (pre ++ [action])) := by
  intro left right hleft hright _hresponse hadvanced
  apply hinjective hleft hright
  exact hsafe
    (hrepresentatives left hleft)
    (hrepresentatives right hright)
    hadvanced

/-- The advanced residual representatives in one Boolean branch.  Classical
equality is used only to package the finite image; the cardinal theorem below
does not decide equality of arbitrary languages at runtime. -/
noncomputable def advancedResidualBranch
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (representatives : Finset (List A)) (action : A) (answer : Bool) :
    Finset (Language A) := by
  classical
  exact FiniteLiveCell.advancedBranch representatives
    (fun pre => acceptsBool M (M.eval (pre ++ [action])))
    (fun pre => BranchResidual M (pre ++ [action]))
    answer

/-- Actual residual-cell specialization: for one representative of every
live residual, a certified safe action obeys the exact square-potential split
law on its two advanced left-quotient branches. -/
theorem safeAction_squarePotential_split
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Set (List A)) (representatives : Finset (List A)) (action : A)
    (hrepresentatives : ∀ pre ∈ representatives, cell pre)
    (hinjective : Set.InjOn (BranchResidual M) representatives)
    (hsafe : ResidualCell.SafeAction M cell action) :
    FiniteLiveCell.squarePotential representatives =
      FiniteLiveCell.squarePotential
          (advancedResidualBranch M representatives action false) +
        FiniteLiveCell.squarePotential
          (advancedResidualBranch M representatives action true) +
        2 *
          (advancedResidualBranch M representatives action false).card *
          (advancedResidualBranch M representatives action true).card := by
  classical
  simpa [advancedResidualBranch] using
    (FiniteLiveCell.squarePotential_split
    representatives
    (fun pre => acceptsBool M (M.eval (pre ++ [action])))
    (fun pre => BranchResidual M (pre ++ [action]))
    (safeAction_to_finiteSafeAdvance M cell representatives action
      hrepresentatives hinjective hsafe))

end ResidualCell

end Pairfield
