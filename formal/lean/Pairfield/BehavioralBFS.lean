/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable, kernel-checked breadth-first search for a shortest word that
distinguishes two states of a finite observed action system.
-/
import Pairfield.MyhillNerodeAdapter
import Mathlib.Tactic

namespace Pairfield

universe u v w

variable {X : Type u} {A : Type v} {O : Type w}

/-- All words of exactly `n` letters, with the alphabet order used only to
choose among equally short witnesses. -/
def wordsOfLength (alphabet : List A) : Nat → List (List A)
  | 0 => [[]]
  | n + 1 => alphabet.flatMap fun a =>
      (wordsOfLength alphabet n).map (a :: ·)

@[simp] theorem mem_wordsOfLength [DecidableEq A]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (word : List A) (n : Nat) :
    word ∈ wordsOfLength alphabet n ↔ word.length = n := by
  induction n generalizing word with
  | zero => simp [wordsOfLength]
  | succ n ih =>
      constructor
      · intro h
        simp only [wordsOfLength, List.mem_flatMap, List.mem_map] at h
        obtain ⟨a, _, tail, htail, rfl⟩ := h
        simp [(ih tail).mp htail]
      · intro h
        cases word with
        | nil => simp at h
        | cons a tail =>
          have htailLength : tail.length = n := by simpa using h
          simp only [wordsOfLength, List.mem_flatMap, List.mem_map]
          exact ⟨a, complete a, tail, (ih tail).mpr htailLength, rfl⟩

/-- A word distinguishes `x` and `y` when their observations disagree after
running that common experiment. -/
def Distinguishes [DecidableEq O] (step : X → A → X) (observe : X → O)
    (x y : X) (word : List A) : Bool :=
  decide (behavior step observe x word ≠ behavior step observe y word)

theorem distinguishes_eq_true_iff [DecidableEq O]
    (step : X → A → X) (observe : X → O) (x y : X) (word : List A) :
    Distinguishes step observe x y word = true ↔
      behavior step observe x word ≠ behavior step observe y word := by
  simp [Distinguishes]

/-- Search one BFS layer. -/
def distinguishingAt [DecidableEq O]
    (alphabet : List A) (step : X → A → X) (observe : X → O) (x y : X) (n : Nat) :
    Option (List A) :=
  (wordsOfLength alphabet n).find? (Distinguishes step observe x y)

/-- Search layers `0,...,fuel`, retaining the first witness found. -/
def shortestDistinguishingUpTo [DecidableEq O]
    (alphabet : List A) (step : X → A → X) (observe : X → O) (x y : X) :
    Nat → Option (List A)
  | 0 => distinguishingAt alphabet step observe x y 0
  | n + 1 =>
      match shortestDistinguishingUpTo alphabet step observe x y n with
      | some word => some word
      | none => distinguishingAt alphabet step observe x y (n + 1)

theorem distinguishingAt_sound [DecidableEq A] [DecidableEq O]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (step : X → A → X) (observe : X → O) (x y : X) {n : Nat} {word : List A}
    (h : distinguishingAt alphabet step observe x y n = some word) :
    word.length = n ∧
      behavior step observe x word ≠ behavior step observe y word := by
  unfold distinguishingAt at h
  have hw : word ∈ wordsOfLength alphabet n :=
    List.mem_of_find?_eq_some h
  have hd : Distinguishes step observe x y word = true :=
    List.find?_some h
  exact ⟨(mem_wordsOfLength alphabet complete word n).mp hw,
    (distinguishes_eq_true_iff step observe x y word).mp hd⟩

theorem distinguishingAt_none_iff [DecidableEq A] [DecidableEq O]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (step : X → A → X) (observe : X → O) (x y : X) (n : Nat) :
    distinguishingAt alphabet step observe x y n = none ↔
      ∀ word : List A, word.length = n →
        behavior step observe x word = behavior step observe y word := by
  unfold distinguishingAt
  rw [List.find?_eq_none]
  constructor
  · intro h word hlen
    have hnot := h word ((mem_wordsOfLength alphabet complete word n).mpr hlen)
    simpa [Distinguishes] using hnot
  · intro h word hmem
    have heq := h word ((mem_wordsOfLength alphabet complete word n).mp hmem)
    simpa [Distinguishes, heq]

theorem shortestDistinguishingUpTo_sound
    [DecidableEq A] [DecidableEq O]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (step : X → A → X) (observe : X → O) (x y : X)
    {fuel : Nat} {word : List A}
    (h : shortestDistinguishingUpTo alphabet step observe x y fuel = some word) :
    word.length ≤ fuel ∧
      behavior step observe x word ≠ behavior step observe y word := by
  induction fuel with
  | zero =>
      exact ⟨by
        have hs := (distinguishingAt_sound alphabet complete step observe x y h).1
        simpa [hs], (distinguishingAt_sound alphabet complete step observe x y h).2⟩
  | succ n ih =>
      simp only [shortestDistinguishingUpTo] at h
      split at h
      next prior hprior =>
        cases h
        have got := ih hprior
        exact ⟨Nat.le_trans got.1 (Nat.le_succ n), got.2⟩
      next hnone =>
        have got := distinguishingAt_sound alphabet complete step observe x y h
        exact ⟨by simpa [got.1], got.2⟩

theorem shortestDistinguishingUpTo_none_iff
    [DecidableEq A] [DecidableEq O]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (step : X → A → X) (observe : X → O) (x y : X) (fuel : Nat) :
    shortestDistinguishingUpTo alphabet step observe x y fuel = none ↔
      ∀ word : List A, word.length ≤ fuel →
        behavior step observe x word = behavior step observe y word := by
  induction fuel with
  | zero =>
      rw [shortestDistinguishingUpTo,
        distinguishingAt_none_iff alphabet complete]
      constructor
      · intro h word hlen
        exact h word (Nat.eq_zero_of_le_zero hlen)
      · intro h word hlen
        exact h word (by simp [hlen])
  | succ n ih =>
      simp only [shortestDistinguishingUpTo]
      split
      next word hsome =>
        constructor
        · intro h
          contradiction
        · intro hall
          have sound := shortestDistinguishingUpTo_sound alphabet complete step observe x y hsome
          exact False.elim (sound.2 (hall word (Nat.le_trans sound.1 (Nat.le_succ n))))
      next hnone =>
        rw [distinguishingAt_none_iff alphabet complete]
        constructor
        · intro h word hlen
          rcases Nat.lt_or_eq_of_le hlen with hlt | heq
          · exact (ih.mp hnone) word (Nat.le_of_lt_succ hlt)
          · exact h word heq
        · intro hall
          intro word hlen
          exact hall word (by simpa [hlen])

/-- The first returned experiment is globally shortest among all experiments
within the searched horizon. -/
theorem shortestDistinguishingUpTo_minimal
    [DecidableEq A] [DecidableEq O]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (step : X → A → X) (observe : X → O) (x y : X)
    {fuel : Nat} {word : List A}
    (h : shortestDistinguishingUpTo alphabet step observe x y fuel = some word) :
    ∀ candidate : List A,
      behavior step observe x candidate ≠ behavior step observe y candidate →
      word.length ≤ candidate.length := by
  induction fuel with
  | zero =>
      intro candidate _
      have hs := (distinguishingAt_sound alphabet complete step observe x y h).1
      simpa [hs]
  | succ n ih =>
      simp only [shortestDistinguishingUpTo] at h
      split at h
      next prior hprior =>
        cases h
        exact ih hprior
      next hnone =>
        have hw := (distinguishingAt_sound alphabet complete step observe x y h).1
        intro candidate hdist
        by_contra hle
        have hc : candidate.length ≤ n := by
          omega
        have heq := (shortestDistinguishingUpTo_none_iff alphabet complete step observe x y n).mp hnone
          candidate hc
        exact hdist heq

/-- Finding no witness through `fuel` is precisely bounded future equality. -/
theorem shortestDistinguishingUpTo_eq_none_iff_boundedFutureEq
    [DecidableEq A] [DecidableEq O]
    (alphabet : List A) (complete : ∀ a : A, a ∈ alphabet)
    (step : X → A → X) (observe : X → O) (x y : X) (fuel : Nat) :
    shortestDistinguishingUpTo alphabet step observe x y fuel = none ↔
      ∀ word : List A, word.length ≤ fuel →
        behavior step observe x word = behavior step observe y word :=
  shortestDistinguishingUpTo_none_iff alphabet complete step observe x y fuel

namespace BehavioralBFSWitness

/-- A three-state system whose states `0` and `1` first separate after the
single action `true`. This is an internal executable control for the search. -/
def step (state : Fin 3) (action : Bool) : Fin 3 :=
  if action && state = 1 then 2 else state

/-- `AdaptiveResidualSplittingControl.observe` has this text exactly (census,
2026-08-22).  It is the same function `Fin 3 → Bool` and a different
observation: there it reads the states of a `DFA (Fin 3) (Fin 3)` whose actions
are `reach`/`merge`/`reveal`, here the states of a Boolean-actioned control.
An observation is a function *of a system*; two systems share one only by
accident of state numbering. -/
def observe (state : Fin 3) : Bool := decide (state = 2)

/-! `alphabet` and `alphabet_complete` below are this lane's **role names**, not
one shared object, and the census of 2026-08-22
(`machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs`) flags them in its two
largest groups — six copies each, in `BehavioralBFS`, `ReachableChart`,
`ResidualBFS`, `ChartQuotient`, `AdaptiveObservableHorizon` and
`ReachableAdaptiveObservableHorizon`.

They were factored out on 2026-08-22 and the factoring was reverted the same
hour, because doing it surfaced the evidence against it:

* `alphabet : List A` with `complete : ∀ a : A, a ∈ alphabet` is a *parameter
  pair* of the general theory, bound in roughly 117 places across the lane.
  The witness constants are that parameter filled in, not a constant the theory
  refers to.
* `LinearAdaptiveGap` defines its own `alphabet` and `alphabet_complete` over
  `Fin n`. Same role, different alphabet — which is the direct proof that the
  role name is not an alias for `[false, true]`. The six coincide only because
  `Bool` has two elements.
* Eighteen modules `open` these witness namespaces and use the bare names, so
  a rename does not stay local, and a lane-wide rename would have renamed 117
  binders in theory that is not about `Bool` at all.

So: same text, different question. See
-/

def alphabet : List Bool := [false, true]

theorem alphabet_complete (action : Bool) : action ∈ alphabet := by
  cases action <;> simp [alphabet]

example :
    shortestDistinguishingUpTo alphabet step observe (0 : Fin 3) 1 2 =
      some [true] := by decide

example :
    behavior step observe (0 : Fin 3) [true] ≠
      behavior step observe 1 [true] :=
  (shortestDistinguishingUpTo_sound alphabet alphabet_complete step observe
    (0 : Fin 3) 1 (fuel := 2) (word := [true]) (by decide)).2

example (candidate : List Bool)
    (h : behavior step observe (0 : Fin 3) candidate ≠
      behavior step observe 1 candidate) :
    [true].length ≤ candidate.length :=
  shortestDistinguishingUpTo_minimal alphabet alphabet_complete step observe
    (0 : Fin 3) 1 (fuel := 2) (word := [true]) (by decide) candidate h

end BehavioralBFSWitness

end Pairfield
