/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Exact shortest future witnesses between arbitrary rows of a supplied finite
behavioral chart.  Unlike the canonical Nerode presentation, this layer is
executable and uses no chosen residual representatives.
-/
import Pairfield.ReachableChart

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The synchronous monitor for two arbitrary DFA states. -/
def statePairDFA (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : X) : DFA A (X × X) where
  step pair action := (M.step pair.1 action, M.step pair.2 action)
  start := (left, right)
  accept := { pair | acceptsBool M pair.1 ≠ acceptsBool M pair.2 }

private theorem statePairDFA_evalFrom
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : X) (pair : X × X) (word : List A) :
    (statePairDFA M left right).evalFrom pair word =
      (M.evalFrom pair.1 word, M.evalFrom pair.2 word) := by
  induction word generalizing pair with
  | nil => rfl
  | cons action word ih =>
      exact ih (M.step pair.1 action, M.step pair.2 action)

theorem mem_statePairDFA_accepts_iff
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : X) (word : List A) :
    word ∈ (statePairDFA M left right).accepts ↔
      behavior M.step (acceptsBool M) left word ≠
      behavior M.step (acceptsBool M) right word := by
  rw [DFA.mem_accepts, DFA.eval, statePairDFA_evalFrom]
  change (decide (M.evalFrom left word ∈ M.accept) ≠
      decide (M.evalFrom right word ∈ M.accept)) ↔ _
  simp only [behavior, acceptsBool, run_eq_evalFrom]

/-- Loop deletion in the pair monitor gives a safe finite horizon for two
arbitrary rows, not only states reached by prefixes from the declared start. -/
theorem exists_state_separator_lt_card_sq
    [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : X) {word : List A}
    (hword : behavior M.step (acceptsBool M) left word ≠
      behavior M.step (acceptsBool M) right word) :
    ∃ short : List A,
      short.length < Fintype.card X * Fintype.card X ∧
        behavior M.step (acceptsBool M) left short ≠
          behavior M.step (acceptsBool M) right short := by
  let P := statePairDFA M left right
  have haccept : word ∈ P.accepts :=
    (mem_statePairDFA_accepts_iff M left right word).2 hword
  have shorten : ∀ n : Nat, ∀ candidate : List A,
      candidate.length = n → candidate ∈ P.accepts →
        ∃ short : List A,
          short.length < Fintype.card (X × X) ∧ short ∈ P.accepts := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro candidate hlength hcand
        by_cases hshort : candidate.length < Fintype.card (X × X)
        · exact ⟨candidate, hshort, hcand⟩
        · have hlong : Fintype.card (X × X) ≤ candidate.length :=
            Nat.le_of_not_gt hshort
          obtain ⟨q, a, b, c, hsplit, _, hb, ha, _, hc⟩ :=
            P.evalFrom_split (s := P.start) hlong rfl
          have hdelete : P.eval (a ++ c) = P.eval candidate := by
            rw [DFA.eval, DFA.evalFrom_of_append, ha, hc]
          have hsmaller : (a ++ c).length < n := by
            have hbpos : 0 < b.length := List.length_pos_iff.mpr hb
            rw [hsplit] at hlength
            simp only [List.length_append] at hlength ⊢
            omega
          apply ih (a ++ c).length hsmaller (a ++ c) rfl
          rw [DFA.mem_accepts, hdelete]
          exact hcand
  obtain ⟨short, hlength, hshort⟩ :=
    shorten word.length word rfl haccept
  refine ⟨short, ?_, ?_⟩
  · simpa [Fintype.card_prod] using hlength
  · exact (mem_statePairDFA_accepts_iff M left right short).1 hshort

/-- Exhaustive length-layered search with the sufficient state-pair horizon
installed. -/
def shortestStateWitness [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : Option (List A) :=
  shortestDistinguishingUpTo alphabet M.step (acceptsBool M) left right
    (Fintype.card X * Fintype.card X)

theorem shortestStateWitness_eq_none_iff
    [DecidableEq A] [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    shortestStateWitness M alphabet left right = none ↔
      FutureEq M.step (acceptsBool M) left right := by
  rw [shortestStateWitness,
    shortestDistinguishingUpTo_none_iff alphabet complete]
  constructor
  · intro bounded word
    by_contra hword
    obtain ⟨short, hlength, hshort⟩ :=
      exists_state_separator_lt_card_sq M left right hword
    exact hshort (bounded short (Nat.le_of_lt hlength))
  · intro future word _
    exact future word

theorem shortestStateWitness_sound
    [DecidableEq A] [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {word : List A}
    (h : shortestStateWitness M alphabet left right = some word) :
    behavior M.step (acceptsBool M) left word ≠
      behavior M.step (acceptsBool M) right word :=
  (shortestDistinguishingUpTo_sound alphabet complete M.step
    (acceptsBool M) left right h).2

theorem shortestStateWitness_minimal
    [DecidableEq A] [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {word : List A}
    (h : shortestStateWitness M alphabet left right = some word) :
    ∀ candidate : List A,
      behavior M.step (acceptsBool M) left candidate ≠
        behavior M.step (acceptsBool M) right candidate →
      word.length ≤ candidate.length :=
  shortestDistinguishingUpTo_minimal alphabet complete M.step
    (acceptsBool M) left right h

/-- Proof-producing exact future-equivalence decision for arbitrary finite
DFA states. -/
def stateFutureEqDecidable
    [DecidableEq A] [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    Decidable (FutureEq M.step (acceptsBool M) left right) :=
  if h : shortestStateWitness M alphabet left right = none then
    isTrue ((shortestStateWitness_eq_none_iff
      M alphabet complete left right).1 h)
  else
    isFalse fun heq => h ((shortestStateWitness_eq_none_iff
      M alphabet complete left right).2 heq)

namespace FiniteBehavioralPresentation

variable {M : DFA A X} (C : FiniteBehavioralPresentation M)

/-- The exact arbitrary-row comparison consumed by constructive chart
reduction.  No reachability proof or Mathlib residual representative enters. -/
def chartStateFutureEqDecidable
    [DecidableEq A] [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : C.State) :
    Decidable (FutureEq C.toDFA.step (acceptsBool C.toDFA) left right) :=
  stateFutureEqDecidable C.toDFA alphabet complete left right

end FiniteBehavioralPresentation

namespace ChartStateBFSWitness

open ReachableChartWitness

def left : chart.State := by
  change Fin 3
  exact 0

def right : chart.State := by
  change Fin 3
  exact 1

example :
    shortestStateWitness chart.toDFA alphabet left right = some [true] := by
  decide

example :
    FutureEq chart.toDFA.step (acceptsBool chart.toDFA) left left := by
  exact futureEq_refl _ _ _

end ChartStateBFSWitness

end Pairfield
