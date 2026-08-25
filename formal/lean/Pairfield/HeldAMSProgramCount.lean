import Mathlib

/-!
# Finite held-memory AM/AMS program count

This file checks the exact finite counting kernel of Theorems I and J in
`notes/MEMORY_NOT_SUBTRACTION.md`.  At step `i`, a syntax program chooses an
operation and an unordered pair with repetition from the `free + i` currently
available slots.  The dependent product of these choices has the advertised
cardinality, and no endpoint evaluator can have a larger finite image.

The third AMS operation is symmetric absolute difference, so unordered
operands are appropriate.  No evaluator, positivity invariant, or arithmetic
chain is constructed here.
-/

namespace Pairfield.HeldAMSProgramCount

open scoped BigOperators

/-- Addition and multiplication operation labels, presented by an explicit
two-element finite type so the cardinal factor is definitionally stable. -/
abbrev AMOperation := Fin 2

namespace AMOperation

def add : AMOperation := 0
def mul : AMOperation := 1

end AMOperation

/-- Addition, multiplication, and symmetric absolute-difference labels,
presented by an explicit three-element finite type. -/
abbrev AMSOperation := Fin 3

namespace AMSOperation

def add : AMSOperation := 0
def mul : AMSOperation := 1
def absSub : AMSOperation := 2

end AMSOperation

/-- One syntax choice from `slots` currently available values. `Sym2` counts
unordered operand pairs with repetition, including a value paired with itself. -/
abbrev StepChoice (Operation : Type*) (slots : ℕ) :=
  Operation × Sym2 (Fin slots)

/-- A length-`steps` syntax program from `free` held slots. At zero-based step
`i`, exactly `free + i` slots are available. -/
abbrev Program (Operation : Type*) (free steps : ℕ) :=
  (i : Fin steps) → StepChoice Operation (free + i.1)

theorem card_stepChoice (Operation : Type*) [Fintype Operation] (slots : ℕ) :
    Fintype.card (StepChoice Operation slots) =
      Fintype.card Operation * Nat.choose (slots + 1) 2 := by
  simp [StepChoice, Sym2.card]

/-- Exact dependent product count. No arithmetic semantics is used. -/
theorem card_program (Operation : Type*) [Fintype Operation]
    (free steps : ℕ) :
    Fintype.card (Program Operation free steps) =
      ∏ i : Fin steps,
        (Fintype.card Operation * Nat.choose (free + i.1 + 1) 2) := by
  simp [Program, StepChoice, Sym2.card]

abbrev AMProgram (free steps : ℕ) := Program AMOperation free steps
abbrev AMSProgram (free steps : ℕ) := Program AMSOperation free steps

/-- Addition-multiplication syntax contributes two operation choices at every
step. -/
theorem card_amProgram (free steps : ℕ) :
    Fintype.card (AMProgram free steps) =
      ∏ i : Fin steps, (2 * Nat.choose (free + i.1 + 1) 2) := by
  simpa [AMProgram] using card_program AMOperation free steps

/-- Adding symmetric absolute difference changes the operation factor from
two to three and leaves the unordered-pair carrier unchanged. -/
theorem card_amsProgram (free steps : ℕ) :
    Fintype.card (AMSProgram free steps) =
      ∏ i : Fin steps, (3 * Nat.choose (free + i.1 + 1) 2) := by
  simpa [AMSProgram] using card_program AMSOperation free steps

/-! ## Endpoint-image bound -/

/-- The finite set of endpoints produced by any supplied evaluator. -/
def endpointImage {Operation Target : Type*} [Fintype Operation]
    [DecidableEq Target] {free steps : ℕ}
    (evaluate : Program Operation free steps → Target) : Finset Target :=
  Finset.univ.image evaluate

/-- Collisions can only decrease the number of realized endpoints. -/
theorem card_endpointImage_le {Operation Target : Type*} [Fintype Operation]
    [DecidableEq Target] {free steps : ℕ}
    (evaluate : Program Operation free steps → Target) :
    (endpointImage evaluate).card ≤
      Fintype.card (Program Operation free steps) := by
  simpa [endpointImage] using
    (Finset.card_image_le (s := (Finset.univ :
      Finset (Program Operation free steps))) (f := evaluate))

/-- If the chosen semantics reaches every one of `modulus` target labels, the
syntax-product cardinality must be at least `modulus`. -/
theorem le_card_program_of_surjective {Operation : Type*}
    [Fintype Operation] {free steps modulus : ℕ}
    (evaluate : Program Operation free steps → Fin modulus)
    (surjective : Function.Surjective evaluate) :
    modulus ≤ ∏ i : Fin steps,
      (Fintype.card Operation * Nat.choose (free + i.1 + 1) 2) := by
  rw [← card_program Operation free steps]
  simpa using Fintype.card_le_of_surjective evaluate surjective

theorem le_card_amProgram_of_surjective {free steps modulus : ℕ}
    (evaluate : AMProgram free steps → Fin modulus)
    (surjective : Function.Surjective evaluate) :
    modulus ≤ ∏ i : Fin steps,
      (2 * Nat.choose (free + i.1 + 1) 2) := by
  simpa using le_card_program_of_surjective evaluate surjective

theorem le_card_amsProgram_of_surjective {free steps modulus : ℕ}
    (evaluate : AMSProgram free steps → Fin modulus)
    (surjective : Function.Surjective evaluate) :
    modulus ≤ ∏ i : Fin steps,
      (3 * Nat.choose (free + i.1 + 1) 2) := by
  simpa using le_card_program_of_surjective evaluate surjective

/-! ## Exact finite controls -/

/-- There is exactly one empty syntax program, independently of the number of
held slots or operation labels. -/
theorem card_zeroStep_program (Operation : Type*) [Fintype Operation]
    (free : ℕ) :
    Fintype.card (Program Operation free 0) = 1 := by
  simp [Program]

/-- From one held value, two AM steps admit `2·1 · 2·3 = 12` syntax programs. -/
theorem oneHeld_twoStep_am_card :
    Fintype.card (AMProgram 1 2) = 12 := by
  native_decide

/-- From one held value, two AMS steps admit `3·1 · 3·3 = 27` syntax
programs. -/
theorem oneHeld_twoStep_ams_card :
    Fintype.card (AMSProgram 1 2) = 27 := by
  native_decide

/-! ## Held-value blindness of the counting envelope -/

/-- Attach a concrete table of held values to the syntax count. Only its index
type, hence its cardinality, enters the counting envelope. -/
abbrev ProgramForHeld (Operation : Type*) {Index : Type*} [Fintype Index]
    (_held : Index → ℕ) (steps : ℕ) :=
  Program Operation (Fintype.card Index) steps

/-- Two held tables on the same finite index type have definitionally equal
program counts, regardless of their entries. -/
theorem card_programForHeld_valueBlind (Operation : Type*)
    [Fintype Operation] {Index : Type*} [Fintype Index]
    (left right : Index → ℕ) (steps : ℕ) :
    Fintype.card (ProgramForHeld Operation left steps) =
      Fintype.card (ProgramForHeld Operation right steps) := rfl

def heldOne (_ : Fin 1) : ℕ := 1
def heldMillion (_ : Fin 1) : ℕ := 1000000

/-- Concrete killer: the singleton tables `{1}` and `{1000000}` give the same
27-program AMS envelope at two steps. This does not say their realized endpoint
images agree. -/
theorem singletonHeld_values_do_not_change_syntax_count :
    Fintype.card (ProgramForHeld AMSOperation heldOne 2) = 27 ∧
    Fintype.card (ProgramForHeld AMSOperation heldMillion 2) = 27 ∧
    Fintype.card (ProgramForHeld AMSOperation heldOne 2) =
      Fintype.card (ProgramForHeld AMSOperation heldMillion 2) := by
  native_decide

end Pairfield.HeldAMSProgramCount
