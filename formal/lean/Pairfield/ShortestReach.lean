/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Native shortest reaching witnesses for finite DFAs.  This is the
proof-relevant precursor of a predecessor forest: every reachable row receives
a globally shortest control word, while `none` is checked unreachability.
-/
import Pairfield.ExecutableMinimization

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- A word reaches the requested DFA row. -/
def Reaches [DecidableEq X] (M : DFA A X) (target : X)
    (word : List A) : Bool :=
  decide (M.eval word = target)

/-- Search one exact word-length layer for a reaching certificate. -/
def reachingAt [DecidableEq X] (alphabet : List A) (M : DFA A X)
    (target : X) (n : Nat) : Option (List A) :=
  (wordsOfLength alphabet n).find? (Reaches M target)

/-- Search length layers `0,...,fuel`, retaining the first reaching word. -/
def shortestReachingUpTo [DecidableEq X]
    (alphabet : List A) (M : DFA A X) (target : X) :
    Nat → Option (List A)
  | 0 => reachingAt alphabet M target 0
  | n + 1 =>
      match shortestReachingUpTo alphabet M target n with
      | some word => some word
      | none => reachingAt alphabet M target (n + 1)

theorem reachingAt_sound [DecidableEq A] [DecidableEq X]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (M : DFA A X) (target : X) {n : Nat} {word : List A}
    (h : reachingAt alphabet M target n = some word) :
    word.length = n ∧ M.eval word = target := by
  unfold reachingAt at h
  have hword : word ∈ wordsOfLength alphabet n :=
    List.mem_of_find?_eq_some h
  have hreaches : Reaches M target word = true := List.find?_some h
  exact ⟨(mem_wordsOfLength alphabet complete word n).mp hword,
    by simpa [Reaches] using hreaches⟩

theorem reachingAt_none_iff [DecidableEq A] [DecidableEq X]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (M : DFA A X) (target : X) (n : Nat) :
    reachingAt alphabet M target n = none ↔
      ∀ word : List A, word.length = n → M.eval word ≠ target := by
  unfold reachingAt
  rw [List.find?_eq_none]
  constructor
  · intro h word hlength
    have hfalse := h word
      ((mem_wordsOfLength alphabet complete word n).mpr hlength)
    simpa [Reaches] using hfalse
  · intro h word hmem
    have hne := h word
      ((mem_wordsOfLength alphabet complete word n).mp hmem)
    simpa [Reaches, hne]

theorem shortestReachingUpTo_sound [DecidableEq A] [DecidableEq X]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (M : DFA A X) (target : X) {fuel : Nat} {word : List A}
    (h : shortestReachingUpTo alphabet M target fuel = some word) :
    word.length ≤ fuel ∧ M.eval word = target := by
  induction fuel with
  | zero =>
      have hs := reachingAt_sound alphabet complete M target h
      exact ⟨by simpa [hs.1], hs.2⟩
  | succ n ih =>
      simp only [shortestReachingUpTo] at h
      split at h
      next prior hprior =>
        cases h
        have got := ih hprior
        exact ⟨Nat.le_trans got.1 (Nat.le_succ n), got.2⟩
      next hnone =>
        have got := reachingAt_sound alphabet complete M target h
        exact ⟨by simpa [got.1], got.2⟩

theorem shortestReachingUpTo_none_iff [DecidableEq A] [DecidableEq X]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (M : DFA A X) (target : X) (fuel : Nat) :
    shortestReachingUpTo alphabet M target fuel = none ↔
      ∀ word : List A, word.length ≤ fuel → M.eval word ≠ target := by
  induction fuel with
  | zero =>
      rw [shortestReachingUpTo, reachingAt_none_iff alphabet complete]
      constructor
      · intro h word hlength
        exact h word (Nat.eq_zero_of_le_zero hlength)
      · intro h word hlength
        exact h word (by simp [hlength])
  | succ n ih =>
      simp only [shortestReachingUpTo]
      split
      next word hsome =>
        constructor
        · intro h
          contradiction
        · intro hall
          have sound := shortestReachingUpTo_sound
            alphabet complete M target hsome
          exact False.elim
            (hall word (Nat.le_trans sound.1 (Nat.le_succ n)) sound.2)
      next hnone =>
        rw [reachingAt_none_iff alphabet complete]
        constructor
        · intro h word hlength
          rcases Nat.lt_or_eq_of_le hlength with hlt | heq
          · exact (ih.mp hnone) word (Nat.le_of_lt_succ hlt)
          · exact h word heq
        · intro hall
          intro word hlength
          exact hall word (by simpa [hlength])

theorem shortestReachingUpTo_minimal [DecidableEq A] [DecidableEq X]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (M : DFA A X) (target : X) {fuel : Nat} {word : List A}
    (h : shortestReachingUpTo alphabet M target fuel = some word) :
    ∀ candidate : List A, M.eval candidate = target →
      word.length ≤ candidate.length := by
  induction fuel with
  | zero =>
      intro candidate _
      have hs := (reachingAt_sound alphabet complete M target h).1
      simpa [hs]
  | succ n ih =>
      simp only [shortestReachingUpTo] at h
      split at h
      next prior hprior =>
        cases h
        exact ih hprior
      next hnone =>
        have hword := (reachingAt_sound alphabet complete M target h).1
        intro candidate hcandidate
        by_contra hle
        have hcandidateLength : candidate.length ≤ n := by omega
        exact ((shortestReachingUpTo_none_iff
          alphabet complete M target n).mp hnone
          candidate hcandidateLength) hcandidate

/-- Install the finite-state loop-deletion horizon. -/
def shortestReachingWord [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A) (target : X) : Option (List A) :=
  shortestReachingUpTo alphabet M target (Fintype.card X)

theorem shortestReachingWord_eq_none_iff
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X) :
    shortestReachingWord M alphabet target = none ↔
      ∀ word : List A, M.eval word ≠ target := by
  rw [shortestReachingWord,
    shortestReachingUpTo_none_iff alphabet complete]
  constructor
  · intro bounded word hword
    obtain ⟨short, hlength, heval⟩ := exists_short_eval_eq M word
    exact (bounded short (Nat.le_of_lt hlength)) (heval.trans hword)
  · intro unreachable word _
    exact unreachable word

theorem shortestReachingWord_sound
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X)
    {word : List A} (h : shortestReachingWord M alphabet target = some word) :
    M.eval word = target :=
  (shortestReachingUpTo_sound alphabet complete M target h).2

theorem shortestReachingWord_minimal
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X)
    {word : List A} (h : shortestReachingWord M alphabet target = some word) :
    ∀ candidate : List A, M.eval candidate = target →
      word.length ≤ candidate.length :=
  shortestReachingUpTo_minimal alphabet complete M target h

/-- The complete proof-history fiber of reaching words.  Selecting one active
shortest witness below never identifies or deletes the other inhabitants. -/
def ReachDerivationFiber (M : DFA A X) (target : X) :=
  { word : List A // M.eval word = target }

/-- The active shortest-witness projection is inhabited exactly when the full
derivation fiber is inhabited.  This is the checked automata instance of the
reciprocal `derivationFiber` / `activeWitnesses` separation. -/
theorem shortestReachingWord_exists_iff_derivationFiber
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X) :
    (∃ word : List A, shortestReachingWord M alphabet target = some word) ↔
      Nonempty (ReachDerivationFiber M target) := by
  constructor
  · rintro ⟨word, hword⟩
    exact ⟨⟨word,
      shortestReachingWord_sound M alphabet complete target hword⟩⟩
  · rintro ⟨⟨candidate, hcandidate⟩⟩
    cases hresult : shortestReachingWord M alphabet target with
    | none =>
        exact False.elim
          (((shortestReachingWord_eq_none_iff
            M alphabet complete target).1 hresult candidate) hcandidate)
    | some word => exact ⟨word, rfl⟩

/-- A nonempty shortest reaching word carries its own predecessor edge, and
its `dropLast` prefix is already a globally shortest word to that predecessor.
Thus shortest witnesses form a well-founded predecessor forest under word
length; no extra choice of parents is required. -/
theorem shortestReachingWord_predecessor
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X)
    {word : List A} (h : shortestReachingWord M alphabet target = some word)
    (hne : word ≠ []) :
    (let pre := word.dropLast
     let action := word.getLast hne
     M.step (M.eval pre) action = target ∧
       ∀ candidate : List A, M.eval candidate = M.eval pre →
         pre.length ≤ candidate.length) := by
  dsimp only
  have hdecompose : word.dropLast ++ [word.getLast hne] = word :=
    List.dropLast_append_getLast hne
  have htarget := shortestReachingWord_sound
    M alphabet complete target h
  have hedge : M.step (M.eval word.dropLast) (word.getLast hne) = target := by
    rw [← hdecompose] at htarget
    rw [DFA.eval, DFA.evalFrom_of_append] at htarget
    exact htarget
  refine ⟨hedge, ?_⟩
  intro candidate hcandidate
  have hcandTarget : M.eval (candidate ++ [word.getLast hne]) = target := by
    rw [DFA.eval, DFA.evalFrom_of_append]
    change M.evalFrom (M.eval candidate) [word.getLast hne] = target
    rw [hcandidate]
    exact hedge
  have hminimal := shortestReachingWord_minimal
    M alphabet complete target h (candidate ++ [word.getLast hne]) hcandTarget
  have hwordLength : word.length = word.dropLast.length + 1 := by
    rw [← hdecompose]
    simp
  simp only [List.length_append, List.length_singleton] at hminimal
  omega

/-- A proof-relevant shortest reaching witness. -/
structure ShortestReachCertificate (M : DFA A X) (target : X) where
  word : List A
  reaches : M.eval word = target
  minimal : ∀ candidate : List A, M.eval candidate = target →
    word.length ≤ candidate.length

/-- Native search packaged with kernel-checked soundness and global
minimality. -/
def shortestReachCertificate
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X) :
    Option (ShortestReachCertificate M target) :=
  match h : shortestReachingWord M alphabet target with
  | none => none
  | some word => some ⟨word,
      shortestReachingWord_sound M alphabet complete target h,
      shortestReachingWord_minimal M alphabet complete target h⟩

namespace ShortestReachWitness

open ChartQuotientWitness

example : shortestReachingWord automaton alphabet (2 : Fin 4) =
    some [false, true] := by
  decide

example : shortestReachingWord automaton alphabet (3 : Fin 4) = none := by
  decide

end ShortestReachWitness

end Pairfield
