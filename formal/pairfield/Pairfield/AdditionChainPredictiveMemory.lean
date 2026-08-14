import Mathlib

/-!
# Predictive memory of two persistent addition chains

Two replayable addition histories reach the same endpoint `6` but retain
different formed values.  Availability probes at `3` and `4` separate them.
This file checks the histories, identifies every direct separator with their
formed-set symmetric difference, and proves the exact two-history coding
lower bound.

The result is relative to persistent formed sets and the declared availability
profile.  It is not an optimal-addition-chain theorem or a physical memory
model.
-/

namespace Pairfield.AdditionChainPredictiveMemory

/-- A replayable addition history starts at one and appends a fresh sum of two
previously formed values.  Freshness records persistent set growth; no
optimality or global increasing-order theorem is built into this grammar. -/
inductive LegalChain : List ℕ → Prop
  | unit : LegalChain [1]
  | extend {trace : List ℕ} (legal : LegalChain trace)
      (left right : ℕ) (left_mem : left ∈ trace) (right_mem : right ∈ trace)
      (fresh : left + right ∉ trace) :
      LegalChain (trace ++ [left + right])

def chainA : List ℕ := [1, 2, 3, 6]
def chainB : List ℕ := [1, 2, 4, 6]

private theorem chainTwo_legal : LegalChain [1, 2] := by
  simpa using LegalChain.extend LegalChain.unit 1 1 (by simp) (by simp) (by simp)

private theorem chainAThree_legal : LegalChain [1, 2, 3] := by
  simpa using LegalChain.extend chainTwo_legal 1 2 (by simp) (by simp) (by simp)

private theorem chainBFour_legal : LegalChain [1, 2, 4] := by
  simpa using LegalChain.extend chainTwo_legal 2 2 (by simp) (by simp) (by simp)

theorem chainA_legal : LegalChain chainA := by
  simpa [chainA] using
    LegalChain.extend chainAThree_legal 3 3 (by simp) (by simp) (by simp)

theorem chainB_legal : LegalChain chainB := by
  simpa [chainB] using
    LegalChain.extend chainBFour_legal 2 4 (by simp) (by simp) (by simp)

def endpoint (trace : List ℕ) : Option ℕ := trace.getLast?

theorem chainA_endpoint : endpoint chainA = some 6 := rfl
theorem chainB_endpoint : endpoint chainB = some 6 := rfl
theorem same_endpoint : endpoint chainA = endpoint chainB := rfl

/-! ## Availability and the complete separator set -/

def formed (trace : List ℕ) : Finset ℕ := trace.toFinset

def available (trace : List ℕ) (value : ℕ) : Bool :=
  decide (value ∈ formed trace)

/-- Direct availability differs at exactly the symmetric difference of the
two formed sets.  Every such probe has the same one-observation depth. -/
theorem mem_symmDiff_iff_available_ne (left right : List ℕ) (value : ℕ) :
    value ∈ symmDiff (formed left) (formed right) ↔
      available left value ≠ available right value := by
  simp [available, formed, Finset.mem_symmDiff]
  tauto

theorem chains_symmDiff :
    symmDiff (formed chainA) (formed chainB) = ({3, 4} : Finset ℕ) := by
  native_decide

theorem three_separates : available chainA 3 = true ∧ available chainB 3 = false := by
  native_decide

theorem four_separates : available chainA 4 = false ∧ available chainB 4 = true := by
  native_decide

/-! ## The declared two-probe predictive profile -/

abbrev Profile := Bool × Bool

def profile (trace : List ℕ) : Profile :=
  (available trace 3, available trace 4)

/-- `false` names chain A and `true` names chain B. -/
def history : Bool → List ℕ
  | false => chainA
  | true => chainB

def historyProfile (which : Bool) : Profile := profile (history which)

theorem history_endpoint (which : Bool) : endpoint (history which) = some 6 := by
  cases which <;> rfl

theorem historyProfile_false : historyProfile false = (true, false) := by
  native_decide

theorem historyProfile_true : historyProfile true = (false, true) := by
  native_decide

theorem historyProfile_injective : Function.Injective historyProfile := by
  intro left right equal
  cases left <;> cases right <;>
    simp_all [historyProfile_false, historyProfile_true]

/-- Endpoint-only state cannot decode the declared availability profile. -/
theorem no_endpoint_decoder :
    ¬ ∃ decode : Option ℕ → Profile,
      ∀ which, decode (endpoint (history which)) = historyProfile which := by
  rintro ⟨decode, replay⟩
  apply Bool.false_ne_true
  apply historyProfile_injective
  calc
    historyProfile false = decode (endpoint (history false)) := (replay false).symm
    _ = decode (endpoint (history true)) := by
      rw [history_endpoint false, history_endpoint true]
    _ = historyProfile true := replay true

/-! ## Exact coding lower bound and attainment -/

/-- Any code from which the profile can be decoded must distinguish the two
histories.  No finiteness assumption on the code type is needed here. -/
theorem encode_injective_of_profile_decoder
    {Code : Type*} (encode : Bool → Code) (decode : Code → Profile)
    (replay : ∀ which, decode (encode which) = historyProfile which) :
    Function.Injective encode := by
  intro left right sameCode
  apply historyProfile_injective
  calc
    historyProfile left = decode (encode left) := (replay left).symm
    _ = decode (encode right) := congrArg decode sameCode
    _ = historyProfile right := replay right

/-- For a finite code alphabet, exact profile recovery requires at least two
code values. -/
theorem two_le_card_of_profile_decoder
    {Code : Type*} [Fintype Code]
    (encode : Bool → Code) (decode : Code → Profile)
    (replay : ∀ which, decode (encode which) = historyProfile which) :
    2 ≤ Fintype.card Code := by
  simpa using Fintype.card_le_of_injective encode
    (encode_injective_of_profile_decoder encode decode replay)

/-- One classical bit attains the lower bound by retaining the history label.
The decoder returns exactly the declared availability profile. -/
def bitEncode : Bool → Bool := id
def bitDecode : Bool → Profile := historyProfile

theorem bit_replay (which : Bool) :
    bitDecode (bitEncode which) = historyProfile which := rfl

theorem bitEncode_injective : Function.Injective bitEncode := by
  intro left right equal
  simpa [bitEncode] using equal

theorem bitCode_card : Fintype.card Bool = 2 := by decide

/-! ## Persistence boundary -/

/-- Deliberate garbage collection retains only the common endpoint. -/
def collectedHistory (_ : Bool) : List ℕ := [6]

theorem collected_profile_constant (left right : Bool) :
    profile (collectedHistory left) = profile (collectedHistory right) := rfl

theorem collected_profile_not_injective :
    ¬ Function.Injective (fun which ↦ profile (collectedHistory which)) := by
  intro injective
  exact Bool.false_ne_true (injective rfl)

end Pairfield.AdditionChainPredictiveMemory
