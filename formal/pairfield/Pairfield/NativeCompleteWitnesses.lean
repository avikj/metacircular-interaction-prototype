/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable replacement for the classical complete separator family on a
supplied finite reduced DFA.  One globally shortest visited-pair word is kept
for each strictly ordered state pair and duplicate words are reused.
-/
import Mathlib.Data.Finset.Prod
import Pairfield.AdaptiveResidualAnnotatedPartitionAdapter
import Pairfield.VisitedPair

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeCompleteWitnesses

/-- The supplied finite chart has no two distinct rows with the same complete
Boolean future.  This is executable presentation data, not extensional
regularity alone. -/
def BehaviorallyReduced
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] : Prop :=
  ∀ ⦃left right : X⦄,
    FutureEq M.step (acceptsBool M) left right → left = right

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Exactly one orientation of every unordered unequal state pair. -/
def strictPairs : Finset (X × X) :=
  ((Finset.univ : Finset X) ×ˢ (Finset.univ : Finset X)).filter
    fun pair => pair.1 < pair.2

/-- Mathlib's exact count of the finite pair schedule. -/
theorem card_strictPairs :
    (strictPairs (X := X)).card = Nat.choose (Fintype.card X) 2 := by
  simpa [strictPairs] using
    (Finset.card_product_filter_lt (s := (Finset.univ : Finset X)))

/-- Native construction of one separator.  The `[]` branch is unreachable on
a strict pair in a reduced chart; keeping the function total makes the whole
finite witness language executable. -/
def witnessWord (alphabet : List A) (pair : X × X) : List A :=
  match visitedPairWitness? M alphabet pair.1 pair.2 with
  | none => []
  | some node => node.word

/-- A strict pair in a reduced chart receives a genuine globally shortest
separator, with its visited-pair replay word retained. -/
theorem witnessWord_globally_shortest_of_lt
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) {left right : X}
    (hlt : left < right) :
    behavior M.step (acceptsBool M) left
        (witnessWord M alphabet (left, right)) ≠
      behavior M.step (acceptsBool M) right
        (witnessWord M alphabet (left, right)) ∧
      ∀ candidate : List A,
        behavior M.step (acceptsBool M) left candidate ≠
          behavior M.step (acceptsBool M) right candidate →
        (witnessWord M alphabet (left, right)).length ≤ candidate.length := by
  have hne : left ≠ right := ne_of_lt hlt
  have hnotFuture :
      ¬ FutureEq M.step (acceptsBool M) left right :=
    fun hfuture => hne (reduced hfuture)
  cases hquery : visitedPairWitness? M alphabet left right with
  | none =>
      exact False.elim
        (hnotFuture ((visitedPairWitness?_eq_none_iff
          M alphabet complete left right).1 hquery))
  | some node =>
    simpa [witnessWord, hquery] using
      (visitedPairWitness?_globally_shortest
        M alphabet complete left right hquery).2

/-- Separation-only projection of the proof-relevant shortest certificate. -/
theorem witnessWord_separates_of_lt
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) {left right : X}
    (hlt : left < right) :
    behavior M.step (acceptsBool M) left
        (witnessWord M alphabet (left, right)) ≠
      behavior M.step (acceptsBool M) right
        (witnessWord M alphabet (left, right)) :=
  (witnessWord_globally_shortest_of_lt
    M alphabet complete reduced hlt).1

/-- The global native control language.  `Finset.image` reuses a word when the
same shortest suffix separates several pairs. -/
def completeWords (alphabet : List A) : Finset (List A) :=
  (strictPairs (X := X)).image (witnessWord M alphabet)

/-- Native construction preserves R0066's exact quadratic vocabulary ceiling.
This count charges pair queries only as schedule entries; it does not charge
the visited expansions or word lengths inside those queries. -/
theorem card_completeWords_le_choose_two (alphabet : List A) :
    (completeWords M alphabet).card ≤ Nat.choose (Fintype.card X) 2 := by
  calc
    (completeWords M alphabet).card ≤ (strictPairs (X := X)).card := by
      exact Finset.card_image_le
    _ = Nat.choose (Fintype.card X) 2 := card_strictPairs

/-- Every unequal pair has a replayable word in the native global language.
The reversed-order branch reuses the same symmetric separation fact. -/
theorem exists_completeWord_separator
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) {left right : X} (hne : left ≠ right) :
    ∃ word ∈ completeWords M alphabet,
      behavior M.step (acceptsBool M) left word ≠
        behavior M.step (acceptsBool M) right word := by
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · let word := witnessWord M alphabet (left, right)
    refine ⟨word, ?_, witnessWord_separates_of_lt
      M alphabet complete reduced hlt⟩
    apply Finset.mem_image.mpr
    exact ⟨(left, right), by simp [strictPairs, hlt], rfl⟩
  · let word := witnessWord M alphabet (right, left)
    have hseparates := witnessWord_separates_of_lt
      M alphabet complete reduced hgt
    refine ⟨word, ?_, fun heq => hseparates heq.symm⟩
    apply Finset.mem_image.mpr
    exact ⟨(right, left), by simp [strictPairs, hgt], rfl⟩

/-- Agreement on the finite native witness language forces literal equality
of rows in the supplied reduced chart. -/
theorem eq_of_agree_completeWords
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (left right : X)
    (hagree : ∀ word ∈ completeWords M alphabet,
      behavior M.step (acceptsBool M) left word =
        behavior M.step (acceptsBool M) right word) :
    left = right := by
  by_contra hne
  obtain ⟨word, hword, hseparates⟩ :=
    exists_completeWord_separator M alphabet complete reduced hne
  exact hseparates (hagree word hword)

end NativeCompleteWitnesses

end Pairfield
