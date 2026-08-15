/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

One duplicate-free reverse traversal for all product-state separator queries.
A synthetic source seeds pairs whose present Moore responses already differ;
one reverse predecessor move then records an original action leading from a
new pair to a previously solved pair.
-/
import Pairfield.NativeReverseSeparatorPolicy

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeReversePairTraversal

open NativeCompleteWitnesses
open NativeReverseSeparatorPolicy

variable [DecidableEq X]

/-- Labels of the reverse product automaton.  `seed pair` enters a terminal
response-separated pair from the synthetic source.  `predecessor pair action`
moves from a solved current pair to `pair` when the original synchronous
transition takes `pair` back to the current pair. -/
inductive ReverseMove (A : Type u) (X : Type v) where
  | seed (pair : X × X)
  | predecessor (pair : X × X) (action : A)
deriving Repr, DecidableEq

/-- Insertion sort of a multiset by `≤`.  Extensionally this is
`Multiset.sort (· ≤ ·)` (`msortLE_eq_sort` below), but it is built from
`List.insertionSort`, which is *structurally* recursive, where `Multiset.sort`
is `List.mergeSort`, which is well-founded recursive and therefore opaque to
the kernel: `decide` (and `decide +kernel`) get stuck on any goal mentioning
`Finset.sort`.  See `notes/NATIVE_DECIDE_AUDIT.md` §4a. -/
def msortLE [LinearOrder X] (s : Multiset X) : List X :=
  Quot.liftOn s (fun l => List.insertionSort (· ≤ ·) l) fun _ _ h =>
    List.Perm.eq_of_pairwise'
      (List.pairwise_insertionSort _ _) (List.pairwise_insertionSort _ _)
      ((List.perm_insertionSort _ _).trans (h.trans (List.perm_insertionSort _ _).symm))

theorem msortLE_eq_sort [LinearOrder X] (s : Multiset X) :
    msortLE s = s.sort (· ≤ ·) :=
  Quot.inductionOn s fun l =>
    (List.mergeSort_eq_insertionSort (r := (· ≤ · : X → X → Prop)) l).symm

/-- The states of `X` in increasing order, kernel-reducibly. -/
def sortedUniv [LinearOrder X] [Fintype X] : List X :=
  msortLE (Finset.univ : Finset X).val

/-- `sortedUniv` denotes exactly what `Finset.sort` denotes. -/
theorem sortedUniv_eq_sort [LinearOrder X] [Fintype X] :
    sortedUniv (X := X) = (Finset.univ : Finset X).sort (· ≤ ·) :=
  msortLE_eq_sort _

/-- A deterministic enumeration of every product state. -/
def pairList [LinearOrder X] [Fintype X] : List (X × X) :=
  let states := sortedUniv (X := X)
  states.flatMap fun left => states.map fun right => (left, right)

/-- The definition `pairList` replaced: the `Finset.sort`-based enumeration.
`pairList_eq_sortEnumeration` shows nothing changed but reducibility. -/
theorem pairList_eq_sortEnumeration [LinearOrder X] [Fintype X] :
    pairList (X := X) =
      (let states := (Finset.univ : Finset X).sort (· ≤ ·)
       states.flatMap fun left => states.map fun right => (left, right)) := by
  simp [pairList, sortedUniv_eq_sort]

@[simp]
theorem length_sortedUniv [LinearOrder X] [Fintype X] :
    (sortedUniv (X := X)).length = Fintype.card X := by
  simp [sortedUniv_eq_sort]

@[simp]
theorem mem_sortedUniv [LinearOrder X] [Fintype X] (state : X) :
    state ∈ sortedUniv (X := X) := by
  simp [sortedUniv_eq_sort]

@[simp]
theorem mem_pairList [LinearOrder X] [Fintype X] (pair : X × X) :
    pair ∈ pairList (X := X) := by
  rcases pair with ⟨left, right⟩
  simp [pairList]

/-- The finite reverse alphabet induced by an explicit complete original
alphabet.  No ordering is chosen noncomputably. -/
def reverseAlphabet [LinearOrder X] [Fintype X]
    (alphabet : List A) : List (ReverseMove A X) :=
  (pairList (X := X)).map ReverseMove.seed ++
    (pairList (X := X)).flatMap fun pair =>
      alphabet.map (ReverseMove.predecessor pair)

theorem reverseAlphabet_complete [LinearOrder X] [Fintype X]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    ∀ move : ReverseMove A X, move ∈ reverseAlphabet (X := X) alphabet := by
  intro move
  cases move with
  | seed pair =>
      simp [reverseAlphabet]
  | predecessor pair action =>
      simp [reverseAlphabet, complete action]

/-- A pair is a reverse source exactly when its present Moore responses
already differ. -/
def TerminalPair (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (pair : X × X) : Prop :=
  behavior M.step (acceptsBool M) pair.1 [] ≠
    behavior M.step (acceptsBool M) pair.2 []

instance terminalPairDecidable (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (pair : X × X) : Decidable (TerminalPair M pair) := by
  unfold TerminalPair
  infer_instance

/-- Deterministic reverse transition.  Invalid labels leave the current state
unchanged, so one finite alphabet can be expanded uniformly at every row. -/
def reverseStep (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    Option (X × X) → ReverseMove A X → Option (X × X)
  | none, ReverseMove.seed pair =>
      if TerminalPair M pair then some pair else none
  | some current, ReverseMove.predecessor pair action =>
      if pairStep M pair action = current then some pair else some current
  | state, _ => state

/-- The single-start DFA on which the generic visited traversal runs.  Its
accepting set is irrelevant; reachability carries the construction. -/
def reverseDFA (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    DFA (ReverseMove A X) (Option (X × X)) where
  step := reverseStep M
  start := none
  accept := ∅

/-- Reverse a forward separator into a path from the synthetic source. -/
def reverseCertificate (M : DFA A X) (pair : X × X) :
    List A → List (ReverseMove A X)
  | [] => [ReverseMove.seed pair]
  | action :: rest =>
      reverseCertificate M (pairStep M pair action) rest ++
        [ReverseMove.predecessor pair action]

/-- Exact forward/reverse adapter.  Every separating suffix becomes a path
from the synthetic source to its declared starting product state. -/
theorem reverseCertificate_reaches (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (pair : X × X) (word : List A)
    (hseparates :
      behavior M.step (acceptsBool M) pair.1 word ≠
        behavior M.step (acceptsBool M) pair.2 word) :
    (reverseDFA M).eval (reverseCertificate M pair word) = some pair := by
  induction word generalizing pair with
  | nil =>
      simp [reverseCertificate, reverseDFA, reverseStep, TerminalPair,
        hseparates]
  | cons action rest ih =>
      have htail :
          behavior M.step (acceptsBool M)
              (pairStep M pair action).1 rest ≠
            behavior M.step (acceptsBool M)
              (pairStep M pair action).2 rest := by
        simpa [behavior, run, pairStep] using hseparates
      have hreach := ih (pairStep M pair action) htail
      rw [reverseCertificate, DFA.eval, DFA.evalFrom_of_append]
      change (reverseDFA M).evalFrom
          ((reverseDFA M).eval
            (reverseCertificate M (pairStep M pair action) rest))
          [ReverseMove.predecessor pair action] = some pair
      rw [hreach]
      simp [reverseDFA, reverseStep, pairStep]

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- One shared duplicate-free reverse traversal for every root-pair query. -/
def reverseTraversal (alphabet : List A) :
    ReachQueue (ReverseMove A X) (Option (X × X)) :=
  visitedReachQueue (reverseDFA M) (reverseAlphabet (X := X) alphabet)

/-- Every reverse state, hence every product state, enters the queue at most
once. -/
theorem reverseTraversal_states_nodup (alphabet : List A) :
    (reverseTraversal M alphabet).states.Nodup := by
  simpa [reverseTraversal, visitedReachQueue] using
    (runReachQueue_states_nodup (reverseDFA M)
      (reverseAlphabet (X := X) alphabet)
      (Fintype.card (Option (X × X))))

/-- The shared traversal pays for at most the product space plus its one
synthetic source. -/
theorem reverseTraversal_expansion_bound (alphabet : List A) :
    (reverseTraversal M alphabet).closed.length ≤
      Fintype.card X * Fintype.card X + 1 := by
  simpa [reverseTraversal, Fintype.card_prod] using
    (visitedReachQueue_expansion_bound (reverseDFA M)
      (reverseAlphabet (X := X) alphabet))

theorem reverseTraversal_frontier_eq_nil
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    (reverseTraversal M alphabet).frontier = [] := by
  exact visitedReachQueue_frontier_eq_nil (reverseDFA M)
    (reverseAlphabet (X := X) alphabet)
    (reverseAlphabet_complete (X := X) alphabet complete)

/-- Completeness of the shared search on a reduced chart.  Every unequal pair
has one retained reverse node, and the node's word is a replayable path from
the source to that pair. -/
theorem exists_closed_reverse_node_of_ne
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (pair : X × X)
    (hne : pair.1 ≠ pair.2) :
    ∃ node ∈ (reverseTraversal M alphabet).closed,
      node.Valid (reverseDFA M) ∧ node.state = some pair := by
  obtain ⟨word, _, hseparates⟩ :=
    exists_completeWord_separator M alphabet complete reduced hne
  have hreach := reverseCertificate_reaches M pair word hseparates
  let reverseM := reverseDFA M
  let moves := reverseAlphabet (X := X) alphabet
  have hmoves : ∀ move : ReverseMove A X, move ∈ moves := by
    simpa [moves] using reverseAlphabet_complete (X := X) alphabet complete
  cases hlookup : visitedReachNode? reverseM moves (some pair) with
  | none =>
      have hunreachable :=
        (visitedReachNode?_eq_none_iff reverseM moves hmoves (some pair)).1
          hlookup
      exact False.elim (hunreachable (reverseCertificate M pair word)
        (by simpa [reverseM] using hreach))
  | some node =>
      have hmem : node ∈ (visitedReachQueue reverseM moves).nodes :=
        List.mem_of_find?_eq_some hlookup
      have hsound :=
        visitedReachNode?_sound reverseM moves hmoves (some pair) hlookup
      have hfrontier : (visitedReachQueue reverseM moves).frontier = [] :=
        visitedReachQueue_frontier_eq_nil reverseM moves hmoves
      have hclosed : node ∈ (visitedReachQueue reverseM moves).closed := by
        simpa [ReachQueue.nodes, hfrontier] using hmem
      exact ⟨node, by simpa [reverseTraversal, reverseM, moves] using hclosed,
        by simpa [reverseM] using hsound.1, hsound.2.1⟩

namespace Control

open BehavioralBFSWitness
open VisitedPairHorizonWitness

/-- Native execution control: the shared reverse traversal for the planted
three-state reduced automaton expands seven reverse states, below the generic
`3^2 + 1` ceiling. -/
theorem shared_reverse_traversal_expands_seven :
    (reverseTraversal automaton alphabet).closed.length = 7 := by
  decide

end Control

end NativeReversePairTraversal

end Pairfield
