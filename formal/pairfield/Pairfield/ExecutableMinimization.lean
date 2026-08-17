/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Global cardinal minimality for the executable reachable/reduced DFA.  The
proof compares the native quotient to Mathlib's canonical residual carrier;
the canonical carrier remains a proof device and does not enter execution.
-/
import Pairfield.ReachableSubDFA
import Pairfield.NerodeChartAdapter

namespace Pairfield

universe u v w

variable {A : Type u} {X : Type v} {Y : Type w}

/-- A finite DFA recognizes a regular language, with no choice of residual
representatives required. -/
theorem finiteDFA_accepts_isRegular [Fintype X] (M : DFA A X) :
    M.accepts.IsRegular := by
  apply Language.isRegular_iff.mpr
  exact ⟨X, inferInstance, M, rfl⟩

/-- A state of the executable reachable/reduced DFA determines a residual of
the original language.  Reachability is used only to prove that its state
language lies in the residual range; no representative is chosen. -/
def reachableReducedStateToResidual
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (meaning : Quotient (dfaFutureSetoid
      (startReachableDFA M alphabet complete))) :
    Set.range M.accepts.leftQuotient := by
  let R := reachableReducedDFA M alphabet complete
  refine ⟨stateLanguage R meaning, ?_⟩
  obtain ⟨word, hword⟩ :=
    reachableReducedDFA_allStatesReachable M alphabet complete meaning
  refine ⟨word, ?_⟩
  calc
    M.accepts.leftQuotient word = R.accepts.leftQuotient word := by
      rw [reachableReducedDFA_accepts_eq]
    _ = stateLanguage R (R.eval word) :=
      leftQuotient_eq_stateLanguage_eval R word
    _ = stateLanguage R meaning := by rw [hword]

/-- Reducedness makes the executable state-to-residual map injective. -/
theorem reachableReducedStateToResidual_injective
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    Function.Injective
      (reachableReducedStateToResidual M alphabet complete) := by
  intro left right heq
  apply reachableReducedDFA_isReduced M alphabet complete
  let R := reachableReducedDFA M alphabet complete
  have hlanguage : stateLanguage R left = stateLanguage R right :=
    congrArg Subtype.val heq
  have hfuture : FutureEq R.step (fun state => state ∈ R.accept) left right :=
    (futureEq_iff_stateLanguage_eq R left right).2 hlanguage
  intro word
  change decide (run R.step left word ∈ R.accept) =
    decide (run R.step right word ∈ R.accept)
  have hiff : run R.step left word ∈ R.accept ↔
      run R.step right word ∈ R.accept := iff_of_eq (hfuture word)
  by_cases hleft : run R.step left word ∈ R.accept
  · have hright := hiff.mp hleft
    simp [hleft, hright]
  · have hright : ¬ (run R.step right word ∈ R.accept) :=
      fun h => hleft (hiff.mpr h)
    simp [hleft, hright]

/-- The executable quotient has no more states than Mathlib's canonical
residual chart. -/
theorem reachableReducedDFA_card_le_nerode
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    @Fintype.card (Quotient (dfaFutureSetoid
        (startReachableDFA M alphabet complete)))
        (reachableReducedFintype M alphabet complete) ≤
      @Fintype.card
        (nerodePresentation M (finiteDFA_accepts_isRegular M)).State
        (nerodePresentation M
          (finiteDFA_accepts_isRegular M)).fintypeState := by
  classical
  letI : Fintype (Quotient (dfaFutureSetoid
      (startReachableDFA M alphabet complete))) :=
    reachableReducedFintype M alphabet complete
  letI : Fintype (Set.range M.accepts.leftQuotient) :=
    (nerodePresentation M (finiteDFA_accepts_isRegular M)).fintypeState
  exact Fintype.card_le_of_injective
    (reachableReducedStateToResidual M alphabet complete)
    (reachableReducedStateToResidual_injective M alphabet complete)

/-- Global executable minimization: the reachable/reduced native DFA has no
more states than any finite DFA recognizing the same language, even if the
competitor contains unreachable rows or behavioral duplicates. -/
theorem reachableReducedDFA_card_le
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (N : DFA A Y) [Fintype Y] (accepts_eq : N.accepts = M.accepts) :
    @Fintype.card (Quotient (dfaFutureSetoid
        (startReachableDFA M alphabet complete)))
        (reachableReducedFintype M alphabet complete) ≤ Fintype.card Y := by
  exact le_trans (reachableReducedDFA_card_le_nerode M alphabet complete)
    (nerodePresentation_card_le M (finiteDFA_accepts_isRegular M)
      N accepts_eq)

namespace ExecutableMinimizationWitness

open ChartQuotientWitness

local instance : Fintype (Quotient (dfaFutureSetoid
    (startReachableDFA automaton alphabet alphabet_complete))) :=
  reachableReducedFintype automaton alphabet alphabet_complete

example : Fintype.card (Quotient (dfaFutureSetoid
    (startReachableDFA automaton alphabet alphabet_complete))) ≤
    Fintype.card (Fin 4) :=
  reachableReducedDFA_card_le automaton alphabet alphabet_complete automaton rfl

end ExecutableMinimizationWitness

end Pairfield
