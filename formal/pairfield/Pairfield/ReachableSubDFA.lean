/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable start-reachable carrier for a supplied finite DFA.  Mathlib's
`DFA.evalFrom_split` supplies the loop deletion theorem; a complete finite
alphabet turns its finite horizon into native state data.
-/
import Pairfield.ChartQuotient

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- All control words whose length is strictly below `bound`. -/
def wordsShorterThan (alphabet : List A) (bound : Nat) : List (List A) :=
  (List.range bound).flatMap (wordsOfLength alphabet)

@[simp] theorem mem_wordsShorterThan [DecidableEq A]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (word : List A) (bound : Nat) :
    word ∈ wordsShorterThan alphabet bound ↔ word.length < bound := by
  simp only [wordsShorterThan, List.mem_flatMap, List.mem_range]
  constructor
  · rintro ⟨n, hn, hword⟩
    exact (mem_wordsOfLength alphabet complete word n).mp hword ▸ hn
  · intro hword
    exact ⟨word.length, hword,
      (mem_wordsOfLength alphabet complete word word.length).mpr rfl⟩

/-- Every reachable state of a finite DFA has a loop-free reaching word.
The strict cardinal bound is the single-state analogue of the pair horizon
used by `ChartStateBFS`. -/
theorem exists_short_eval_eq [Fintype X] (M : DFA A X) (word : List A) :
    ∃ short : List A,
      short.length < Fintype.card X ∧ M.eval short = M.eval word := by
  have shorten : ∀ n : Nat, ∀ candidate : List A,
      candidate.length = n →
        ∃ short : List A,
          short.length < Fintype.card X ∧ M.eval short = M.eval candidate := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro candidate hlength
        by_cases hshort : candidate.length < Fintype.card X
        · exact ⟨candidate, hshort, rfl⟩
        · have hlong : Fintype.card X ≤ candidate.length :=
            Nat.le_of_not_gt hshort
          obtain ⟨q, a, b, c, hsplit, _, hb, ha, _, hc⟩ :=
            M.evalFrom_split (s := M.start) hlong rfl
          have hdelete : M.eval (a ++ c) = M.eval candidate := by
            rw [DFA.eval, DFA.evalFrom_of_append, ha, hc]
          have hsmaller : (a ++ c).length < n := by
            have hbpos : 0 < b.length := List.length_pos_iff.mpr hb
            rw [hsplit] at hlength
            simp only [List.length_append] at hlength ⊢
            omega
          obtain ⟨short, hbound, heval⟩ :=
            ih (a ++ c).length hsmaller (a ++ c) rfl
          exact ⟨short, hbound, heval.trans hdelete⟩
  exact shorten word.length word rfl

/-- The executable finite list of start-reachable rows. -/
def reachableRows [Fintype X] (M : DFA A X) (alphabet : List A) : List X :=
  (wordsShorterThan alphabet (Fintype.card X)).map M.eval

theorem mem_reachableRows_iff
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (state : X) :
    state ∈ reachableRows M alphabet ↔
      ∃ word : List A, M.eval word = state := by
  constructor
  · intro hstate
    simp only [reachableRows, List.mem_map] at hstate
    obtain ⟨word, hword, rfl⟩ := hstate
    exact ⟨word, rfl⟩
  · rintro ⟨word, rfl⟩
    obtain ⟨short, hshort, heval⟩ := exists_short_eval_eq M word
    simp only [reachableRows, List.mem_map]
    exact ⟨short,
      (mem_wordsShorterThan alphabet complete short _).mpr hshort, heval⟩

/-- Rows reached from the declared start, represented as an executable
subtype whose membership decision reduces to the bounded native list above. -/
def StartReachable [Fintype X] (M : DFA A X) (alphabet : List A) : Type v :=
  { state : X // state ∈ reachableRows M alphabet }

instance startReachableFintype [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A) : Fintype (StartReachable M alphabet) :=
  Subtype.fintype _

/-- The start-reachable sub-DFA.  Closure is certified by appending one action
and then shortening the resulting reaching word through `evalFrom_split`. -/
def startReachableDFA [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) :
    DFA A (StartReachable M alphabet) where
  step state action := ⟨M.step state.1 action, by
    apply (mem_reachableRows_iff M alphabet complete _).2
    obtain ⟨word, hword⟩ :=
      (mem_reachableRows_iff M alphabet complete state.1).1 state.2
    refine ⟨word ++ [action], ?_⟩
    rw [DFA.eval, DFA.evalFrom_of_append]
    change M.evalFrom (M.eval word) [action] = M.step state.1 action
    rw [hword]
    rfl⟩
  start := ⟨M.start, by
    apply (mem_reachableRows_iff M alphabet complete _).2
    exact ⟨[], rfl⟩⟩
  accept := { state | state.1 ∈ M.accept }

instance startReachableDFA_accept_decidable
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    DecidablePred (fun state : StartReachable M alphabet =>
      state ∈ (startReachableDFA M alphabet complete).accept) :=
  fun state => show Decidable (state.1 ∈ M.accept) from inferInstance

@[simp] theorem startReachableDFA_evalFrom_val
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet)
    (state : StartReachable M alphabet) (word : List A) :
    ((startReachableDFA M alphabet complete).evalFrom state word).1 =
      M.evalFrom state.1 word := by
  induction word generalizing state with
  | nil => rfl
  | cons action word ih =>
      exact ih ((startReachableDFA M alphabet complete).step state action)

@[simp] theorem startReachableDFA_eval_val
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (word : List A) :
    ((startReachableDFA M alphabet complete).eval word).1 = M.eval word := by
  exact startReachableDFA_evalFrom_val M alphabet complete
    (startReachableDFA M alphabet complete).start word

/-- Removing unreachable rows preserves the recognized language exactly. -/
theorem startReachableDFA_accepts_eq
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) :
    (startReachableDFA M alphabet complete).accepts = M.accepts := by
  ext word
  rw [DFA.mem_accepts, DFA.mem_accepts]
  change ((startReachableDFA M alphabet complete).eval word).1 ∈ M.accept ↔
    M.eval word ∈ M.accept
  rw [startReachableDFA_eval_val]

/-- Every state of the extracted carrier is reached by the same word that
certifies membership in its bounded native row list. -/
theorem startReachableDFA_allStatesReachable
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) :
    ∀ state : StartReachable M alphabet,
      ∃ word : List A,
        (startReachableDFA M alphabet complete).eval word = state := by
  intro state
  obtain ⟨word, hword⟩ :=
    (mem_reachableRows_iff M alphabet complete state.1).1 state.2
  refine ⟨word, Subtype.ext ?_⟩
  rw [startReachableDFA_eval_val]
  exact hword

/-- Delete unreachable rows and then merge equal futures.  The carrier is
fully native: both the reachability filter and the future setoid are decided
by finite searches justified by the two Mathlib loop-deletion adapters. -/
def reachableReducedDFA
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    DFA A (Quotient (dfaFutureSetoid
      (startReachableDFA M alphabet complete))) :=
  behavioralQuotientDFA (startReachableDFA M alphabet complete)

instance reachableReducedDFA_accept_decidable
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    DecidablePred (fun meaning : Quotient (dfaFutureSetoid
        (startReachableDFA M alphabet complete)) =>
      meaning ∈ (reachableReducedDFA M alphabet complete).accept) := by
  unfold reachableReducedDFA
  infer_instance

@[instance_reducible] def reachableReducedFintype
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    Fintype (Quotient (dfaFutureSetoid
      (startReachableDFA M alphabet complete))) :=
  behavioralQuotientFintype
    (startReachableDFA M alphabet complete) alphabet complete

theorem reachableReducedDFA_accepts_eq
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    (reachableReducedDFA M alphabet complete).accepts = M.accepts := by
  rw [reachableReducedDFA, behavioralQuotientDFA_accepts_eq,
    startReachableDFA_accepts_eq]

theorem reachableReducedDFA_allStatesReachable
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    ∀ meaning : Quotient (dfaFutureSetoid
        (startReachableDFA M alphabet complete)),
      ∃ word : List A,
        (reachableReducedDFA M alphabet complete).eval word = meaning := by
  apply behavioralQuotientDFA_allStatesReachable
    (startReachableDFA M alphabet complete)
  exact startReachableDFA_allStatesReachable M alphabet complete

theorem reachableReducedDFA_isReduced
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    ∀ {left right : Quotient (dfaFutureSetoid
        (startReachableDFA M alphabet complete))},
      FutureEq (reachableReducedDFA M alphabet complete).step
        (acceptsBool (reachableReducedDFA M alphabet complete)) left right →
      left = right :=
  behavioralQuotientDFA_isReduced_acceptsBool
    (startReachableDFA M alphabet complete)

namespace ReachableSubDFAWitness

open ChartQuotientWitness

example : Fintype.card (StartReachable automaton alphabet) = 3 := by
  decide

example :
    (startReachableDFA automaton alphabet alphabet_complete).accepts =
      automaton.accepts :=
  startReachableDFA_accepts_eq automaton alphabet alphabet_complete

local instance : Fintype (Quotient (dfaFutureSetoid
    (startReachableDFA automaton alphabet alphabet_complete))) :=
  reachableReducedFintype automaton alphabet alphabet_complete

example : Fintype.card (Quotient (dfaFutureSetoid
    (startReachableDFA automaton alphabet alphabet_complete))) = 3 := by
  decide

example :
    (reachableReducedDFA automaton alphabet alphabet_complete).accepts =
      automaton.accepts :=
  reachableReducedDFA_accepts_eq automaton alphabet alphabet_complete

end ReachableSubDFAWitness

end Pairfield
