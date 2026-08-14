/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable adapter from Mathlib left quotients to the repository's checked
shortest behavioral-witness search.
-/
import Pairfield.BehavioralBFS

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- Acceptance as executable Boolean observation. -/
def acceptsBool (M : DFA A X) [DecidablePred (fun x : X => x ∈ M.accept)]
    (x : X) : Bool :=
  decide (x ∈ M.accept)

private theorem decide_eq_decide_iff {p q : Prop} [Decidable p] [Decidable q] :
    decide p = decide q ↔ (p ↔ q) := by
  by_cases hp : p <;> by_cases hq : q <;> simp [hp, hq]

private theorem decide_ne_decide_iff {p q : Prop} [Decidable p] [Decidable q] :
    decide p ≠ decide q ↔ ¬ (p ↔ q) := by
  rw [ne_eq, decide_eq_decide_iff]

/--
Mathlib's theorem `Language.leftQuotient_accepts_apply` identifies the left
quotient at a prefix with the residual language of its reached state.  This
lemma is its pointwise executable form for the Boolean observation used by
`BehavioralBFS`.
-/
theorem mem_leftQuotient_iff_accept_evalFrom_eval
    (M : DFA A X) (pre word : List A) :
    word ∈ M.accepts.leftQuotient pre ↔
      M.evalFrom (M.eval pre) word ∈ M.accept := by
  rw [leftQuotient_eq_stateLanguage_eval M pre]
  rfl

theorem behavior_acceptsBool_eval_eq_decide_accept
    (M : DFA A X) [DecidablePred (fun x : X => x ∈ M.accept)]
    (pre word : List A) :
    behavior M.step (acceptsBool M) (M.eval pre) word =
      decide (M.evalFrom (M.eval pre) word ∈ M.accept) := by
  simp [behavior, acceptsBool, run_eq_evalFrom]

/-- Search for a shortest word separating the left quotients at two prefixes. -/
def shortestLeftQuotientWitnessUpTo
    (M : DFA A X) [DecidablePred (fun x : X => x ∈ M.accept)]
    (alphabet : List A) (left right : List A) (fuel : Nat) : Option (List A) :=
  shortestDistinguishingUpTo alphabet M.step (acceptsBool M)
    (M.eval left) (M.eval right) fuel

/-- A returned word is a genuine Mathlib left-quotient membership separator. -/
theorem shortestLeftQuotientWitnessUpTo_sound
    [DecidableEq A] (M : DFA A X)
    [DecidablePred (fun x : X => x ∈ M.accept)]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (left right : List A) {fuel : Nat} {word : List A}
    (h : shortestLeftQuotientWitnessUpTo M alphabet left right fuel = some word) :
    word.length ≤ fuel ∧
      ¬ (word ∈ M.accepts.leftQuotient left ↔
        word ∈ M.accepts.leftQuotient right) := by
  have hs := shortestDistinguishingUpTo_sound alphabet complete M.step
    (acceptsBool M) (M.eval left) (M.eval right) h
  refine ⟨hs.1, ?_⟩
  rw [behavior_acceptsBool_eval_eq_decide_accept M left word,
    behavior_acceptsBool_eval_eq_decide_accept M right word] at hs
  have hresidual := decide_ne_decide_iff.mp hs.2
  simpa only [mem_leftQuotient_iff_accept_evalFrom_eval] using hresidual

/-- No result through `fuel` means exact bounded agreement of left quotients. -/
theorem shortestLeftQuotientWitnessUpTo_none_iff
    [DecidableEq A] (M : DFA A X)
    [DecidablePred (fun x : X => x ∈ M.accept)]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (left right : List A) (fuel : Nat) :
    shortestLeftQuotientWitnessUpTo M alphabet left right fuel = none ↔
      ∀ word : List A, word.length ≤ fuel →
        (word ∈ M.accepts.leftQuotient left ↔
          word ∈ M.accepts.leftQuotient right) := by
  rw [shortestLeftQuotientWitnessUpTo,
    shortestDistinguishingUpTo_none_iff alphabet complete]
  constructor
  · intro h word hlen
    have heq := h word hlen
    rw [behavior_acceptsBool_eval_eq_decide_accept M left word,
      behavior_acceptsBool_eval_eq_decide_accept M right word] at heq
    have hresidual := decide_eq_decide_iff.mp heq
    simpa only [mem_leftQuotient_iff_accept_evalFrom_eval] using hresidual
  · intro h word hlen
    rw [behavior_acceptsBool_eval_eq_decide_accept M left word,
      behavior_acceptsBool_eval_eq_decide_accept M right word]
    apply decide_eq_decide_iff.mpr
    simpa only [mem_leftQuotient_iff_accept_evalFrom_eval] using h word hlen

/-- The returned separator has minimum length among all residual separators. -/
theorem shortestLeftQuotientWitnessUpTo_minimal
    [DecidableEq A] (M : DFA A X)
    [DecidablePred (fun x : X => x ∈ M.accept)]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (left right : List A) {fuel : Nat} {word : List A}
    (h : shortestLeftQuotientWitnessUpTo M alphabet left right fuel = some word) :
    ∀ candidate : List A,
      ¬ (candidate ∈ M.accepts.leftQuotient left ↔
        candidate ∈ M.accepts.leftQuotient right) →
      word.length ≤ candidate.length := by
  intro candidate hcandidate
  apply shortestDistinguishingUpTo_minimal alphabet complete M.step
    (acceptsBool M) (M.eval left) (M.eval right) h candidate
  rw [behavior_acceptsBool_eval_eq_decide_accept M left candidate,
    behavior_acceptsBool_eval_eq_decide_accept M right candidate]
  apply decide_ne_decide_iff.mpr
  simpa only [mem_leftQuotient_iff_accept_evalFrom_eval] using hcandidate

/-- Equal reached states are a falsifier: no horizon can produce a separator. -/
theorem shortestLeftQuotientWitnessUpTo_eq_none_of_eval_eq
    [DecidableEq A] (M : DFA A X)
    [DecidablePred (fun x : X => x ∈ M.accept)]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (left right : List A) (fuel : Nat) (hreached : M.eval left = M.eval right) :
    shortestLeftQuotientWitnessUpTo M alphabet left right fuel = none := by
  apply (shortestLeftQuotientWitnessUpTo_none_iff M alphabet complete
    left right fuel).2
  intro word _
  rw [leftQuotient_eq_stateLanguage_eval M left,
    leftQuotient_eq_stateLanguage_eval M right, hreached]

/-- Changing a complete enumeration cannot change bounded residual equality.
The action type, not the list order, carries control authority. -/
theorem shortestLeftQuotientWitnessUpTo_none_iff_of_complete_alphabets
    [DecidableEq A] (M : DFA A X)
    [DecidablePred (fun x : X => x ∈ M.accept)]
    (first second : List A)
    (first_complete : ∀ a : A, a ∈ first)
    (second_complete : ∀ a : A, a ∈ second)
    (left right : List A) (fuel : Nat) :
    shortestLeftQuotientWitnessUpTo M first left right fuel = none ↔
      shortestLeftQuotientWitnessUpTo M second left right fuel = none := by
  rw [shortestLeftQuotientWitnessUpTo_none_iff M first first_complete,
    shortestLeftQuotientWitnessUpTo_none_iff M second second_complete]

/-- Complete enumeration order may select a different shortest word, but not
a different minimum length. -/
theorem shortestLeftQuotientWitnessUpTo_length_invariant
    [DecidableEq A] (M : DFA A X)
    [DecidablePred (fun x : X => x ∈ M.accept)]
    (first second : List A)
    (first_complete : ∀ a : A, a ∈ first)
    (second_complete : ∀ a : A, a ∈ second)
    (left right : List A) {fuel₁ fuel₂ : Nat} {word₁ word₂ : List A}
    (h₁ : shortestLeftQuotientWitnessUpTo M first left right fuel₁ = some word₁)
    (h₂ : shortestLeftQuotientWitnessUpTo M second left right fuel₂ = some word₂) :
    word₁.length = word₂.length := by
  have separates₁ :=
    (shortestLeftQuotientWitnessUpTo_sound M first first_complete left right h₁).2
  have separates₂ :=
    (shortestLeftQuotientWitnessUpTo_sound M second second_complete left right h₂).2
  apply Nat.le_antisymm
  · exact shortestLeftQuotientWitnessUpTo_minimal M first first_complete
      left right h₁ word₂ separates₂
  · exact shortestLeftQuotientWitnessUpTo_minimal M second second_complete
      left right h₂ word₁ separates₁

namespace ResidualBFSWitness

/-- A reachable three-state DFA: `false` reaches state `1`, then `true`
reaches the sole accepting state `2`. -/
def step (state : Fin 3) (action : Bool) : Fin 3 :=
  if state = 0 ∧ action = false then 1
  else if state = 1 ∧ action = true then 2
  else state

def automaton : DFA Bool (Fin 3) where
  step := step
  start := 0
  accept := { state | state = 2 }

instance : DecidablePred (fun state : Fin 3 => state ∈ automaton.accept) :=
  fun state => by
    change Decidable (state = 2)
    infer_instance

def alphabet : List Bool := [false, true]

theorem alphabet_complete (action : Bool) : action ∈ alphabet := by
  cases action <;> simp [alphabet]

/-- The shortest residual separator between prefixes `[]` and `[false]` is
the one-letter suffix `[true]`. -/
example :
    shortestLeftQuotientWitnessUpTo automaton alphabet [] [false] 2 =
      some [true] := by rfl

example :
    ¬ ([true] ∈ automaton.accepts.leftQuotient [] ↔
      [true] ∈ automaton.accepts.leftQuotient [false]) :=
  (shortestLeftQuotientWitnessUpTo_sound automaton alphabet alphabet_complete
    [] [false] (fuel := 2) (word := [true]) (by rfl)).2

/-- Known-false control for separation: `[]` and `[true]` reach the same
state, so bounded search returns no witness. -/
example :
    shortestLeftQuotientWitnessUpTo automaton alphabet [] [true] 2 = none :=
  shortestLeftQuotientWitnessUpTo_eq_none_of_eval_eq automaton alphabet
    alphabet_complete [] [true] 2 (by rfl)

end ResidualBFSWitness

end Pairfield
