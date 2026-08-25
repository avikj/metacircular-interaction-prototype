/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An annotated global-splitting event retains the initial states, the exact
word transporting them to their current image, and the injectivity/response
certificates needed to continue.  Informative partition events are only
linear in the number of initial states; the classical quadratic ADS cost must
therefore live in the lengths and scheduling of the retained annotations.
-/
import Pairfield.AdaptiveResidualGlobalPartition
import Pairfield.AdaptiveResidualPotentialAdapter

namespace Pairfield

universe u v

namespace AnnotatedResidualSplit

variable {A : Type u} {X : Type v}
variable [DecidableEq X]

/-- One block of initial states together with the exact word currently
installed on that block.  The word is proof-relevant: its current-state image
is injective, and all initial states in the block currently show one output. -/
structure Block (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] where
  members : Finset X
  nonempty : members.Nonempty
  word : List A
  imageInjective : Set.InjOn (fun state => M.evalFrom state word) members
  currentConstant :
    ∀ ⦃left right : X⦄,
      left ∈ members → right ∈ members →
      acceptsBool M (M.evalFrom left word) =
        acceptsBool M (M.evalFrom right word)

namespace Block

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- The current state after appending one proposed action to the retained
annotation. -/
def nextState (block : Block M) (action : A) (initial : X) : X :=
  M.evalFrom initial (block.word ++ [action])

/-- The next Moore response seen by one initial state. -/
def postResponse (block : Block M) (action : A) (initial : X) : Bool :=
  acceptsBool M (block.nextState M action initial)

/-- The initial states entering one response child.  Initial identities are
retained; only their common annotation is extended. -/
def childMembers (block : Block M) (action : A) (answer : Bool) : Finset X :=
  FiniteLiveCell.responseFiber block.members
    (block.postResponse M action) answer

/-- Validity is the exact no-merging condition on both response fibres. -/
def ValidAction (block : Block M) (action : A) : Prop :=
  FiniteLiveCell.SafeAdvance block.members
    (block.postResponse M action) (block.nextState M action)

/-- A valid nonempty response child is again an annotated block.  This is the
provenance-preserving formation event: the old initial members survive, the
word is visibly extended, and validity supplies injectivity of the new image. -/
def child (block : Block M) (action : A) (answer : Bool)
    (valid : block.ValidAction M action)
    (inhabited : (block.childMembers M action answer).Nonempty) : Block M where
  members := block.childMembers M action answer
  nonempty := inhabited
  word := block.word ++ [action]
  imageInjective := by
    change Set.InjOn (block.nextState M action)
      (block.childMembers M action answer)
    simpa [childMembers] using
      (FiniteLiveCell.safeAdvance_injOn_responseFiber block.members
        (block.postResponse M action) (block.nextState M action) answer valid)
  currentConstant := by
    intro left right hleft hright
    have hleftData := Finset.mem_filter.mp hleft
    have hrightData := Finset.mem_filter.mp hright
    exact hleftData.2.trans hrightData.2.symm

@[simp] theorem child_members (block : Block M) (action : A) (answer : Bool)
    (valid : block.ValidAction M action)
    (inhabited : (block.childMembers M action answer).Nonempty) :
    (block.child M action answer valid inhabited).members =
      block.childMembers M action answer := rfl

@[simp] theorem child_word (block : Block M) (action : A) (answer : Bool)
    (valid : block.ValidAction M action)
    (inhabited : (block.childMembers M action answer).Nonempty) :
    (block.child M action answer valid inhabited).word =
      block.word ++ [action] := rfl

/-- Ordered ambiguity of the retained initial identities in one block. -/
def squareAmbiguity (block : Block M) : Nat :=
  block.members.card * block.members.card

/-- Total ambiguity after exposing the two Boolean response children. -/
def branchSquareAmbiguity (block : Block M) (action : A) : Nat :=
  let falseChild := block.childMembers M action false
  let trueChild := block.childMembers M action true
  falseChild.card * falseChild.card + trueChild.card * trueChild.card

/-- Exact local-to-global accounting.  The identity is on the initial-state
partition, so it holds independently of validity; validity is what turns both
nonempty fibres into reusable annotated children. -/
theorem squareAmbiguity_split (block : Block M) (action : A) :
    block.squareAmbiguity M =
      block.branchSquareAmbiguity M action +
        2 * (block.childMembers M action false).card *
          (block.childMembers M action true).card := by
  have hpartition := FiniteLiveCell.card_responseFibers block.members
    (block.postResponse M action)
  simp only [squareAmbiguity, branchSquareAmbiguity, childMembers]
  rw [hpartition]
  ring

/-- An informative valid split spends at least two ordered-ambiguity units. -/
theorem branchSquareAmbiguity_add_two_le (block : Block M) (action : A)
    (falseInhabited : (block.childMembers M action false).Nonempty)
    (trueInhabited : (block.childMembers M action true).Nonempty) :
    block.branchSquareAmbiguity M action + 2 ≤
      block.squareAmbiguity M := by
  have hsplit := block.squareAmbiguity_split M action
  have hfalse : 0 < (block.childMembers M action false).card :=
    Finset.card_pos.mpr falseInhabited
  have htrue : 0 < (block.childMembers M action true).card :=
    Finset.card_pos.mpr trueInhabited
  have hcross :
      2 ≤ 2 * (block.childMembers M action false).card *
        (block.childMembers M action true).card := by
    nlinarith
  omega

/-- Square ambiguity of a finite family of annotated blocks. -/
def familySquareAmbiguity (blocks : List (Block M)) : Nat :=
  (blocks.map (squareAmbiguity M)).sum

/-- Replacing one annotated parent by its two nonempty children changes the
global family ambiguity by exactly the same cross term. -/
theorem familySquareAmbiguity_replace
    (before after : List (Block M)) (block : Block M) (action : A)
    (valid : block.ValidAction M action)
    (falseInhabited : (block.childMembers M action false).Nonempty)
    (trueInhabited : (block.childMembers M action true).Nonempty) :
    familySquareAmbiguity M (before ++ block :: after) =
      familySquareAmbiguity M
        (before ++
          block.child M action false valid falseInhabited ::
          block.child M action true valid trueInhabited :: after) +
        2 * (block.childMembers M action false).card *
          (block.childMembers M action true).card := by
  have hsplit := block.squareAmbiguity_split M action
  simp only [familySquareAmbiguity, List.map_append, List.map_cons,
    List.sum_append, List.sum_cons]
  simp only [child_members, squareAmbiguity]
  simp only [squareAmbiguity, branchSquareAmbiguity] at hsplit
  omega

/-- The same replacement has exactly one more nonempty block.  This elementary
count is the correction to the forecast that the quadratic pair budget might
be sharp as a count of informative partition events. -/
theorem family_length_replace
    (before after : List (Block M)) (block : Block M) (action : A)
    (valid : block.ValidAction M action)
    (falseInhabited : (block.childMembers M action false).Nonempty)
    (trueInhabited : (block.childMembers M action true).Nonempty) :
    (before ++
      block.child M action false valid falseInhabited ::
      block.child M action true valid trueInhabited :: after).length =
      (before ++ block :: after).length + 1 := by
  simp only [List.length_append, List.length_cons]
  omega

end Block

/-- Any genuine partition of an `n`-element carrier has at most `n` nonempty
blocks.  If informative events replace one block by two, their total number is
therefore at most `n - initialBlocks`, not the quadratic pair budget. -/
theorem informativeEvents_le_card_sub
    {carrier : Finset X} (after : Finpartition carrier)
    (initialBlocks events : Nat)
    (count : after.parts.card = initialBlocks + events) :
    events ≤ carrier.card - initialBlocks := by
  have hparts := after.card_parts_le_card
  omega

/-- Starting from the indiscrete one-block partition gives the sharp linear
event ceiling `n-1`. -/
theorem informativeEvents_from_one_le
    {carrier : Finset X} (after : Finpartition carrier)
    (events : Nat) (count : after.parts.card = 1 + events) :
    events ≤ carrier.card - 1 := by
  exact informativeEvents_le_card_sub after 1 events count

/-- Registered annihilation control: on three states, informative partition
events are at most two, strictly below the three unordered-pair witnesses.
Thus `choose n 2` cannot be sharp as an event count even though it is the exact
global witness-vocabulary ceiling returned by R0066. -/
theorem finThree_events_lt_choose_two
    (after : Finpartition (Finset.univ : Finset (Fin 3)))
    (events : Nat) (count : after.parts.card = 1 + events) :
    events < Nat.choose 3 2 := by
  have hlinear := informativeEvents_from_one_le after events count
  norm_num at hlinear ⊢
  omega

namespace Control

/-- Two hidden nonaccepting states; `false` is a constant identity action and
`true` reveals state `1` by moving it to the accepting state `2`. -/
def step (state : Fin 3) (action : Bool) : Fin 3 :=
  if action then if state = 1 then 2 else state else state

/-- The five lines below are character-for-character identical to the
`automaton` of `ResidualBFSWitness`, `NativeWitnessGreedyFormation.Control` and
`NativeDemandRestrictedFormation.Control` (census, 2026-08-22, the lane's
`automaton ×4` group) — **and they name four different automata**, because the
`step` each refers to is different in three of the four: action-blind in the
two `Native` modules, `0 --false--> 1 --true--> 2` in `ResidualBFS`, and
`true`-gated here.  A content address is a hash of the presentation and the
dependency scan is lexical, so the group is a floor on nothing: the right
verdict is to leave all four standing.  The two that *are* one automaton say so
by a checked `rfl` in `NativeDemandRestrictedFormation.Control`. -/
def automaton : DFA Bool (Fin 3) where
  step := step
  start := 0
  accept := { state | state = 2 }

instance : DecidablePred
    (fun state : Fin 3 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (state = 2))

/-- Initial block with two hidden states and the empty retained annotation. -/
def hiddenBlock : Block automaton where
  members := {0, 1}
  nonempty := by simp
  word := []
  imageInjective := by
    intro left hleft right hright heq
    simpa using heq
  currentConstant := by decide

theorem stay_valid : hiddenBlock.ValidAction automaton false := by
  intro left right hleft hright hresponse hnext
  fin_cases left <;> fin_cases right <;>
    simp_all [hiddenBlock, Block.postResponse, Block.nextState,
      automaton, step, acceptsBool]

theorem reveal_valid : hiddenBlock.ValidAction automaton true := by
  intro left right hleft hright hresponse hnext
  fin_cases left <;> fin_cases right <;>
    simp_all [hiddenBlock, Block.postResponse, Block.nextState,
      automaton, step, acceptsBool]

theorem reveal_false_nonempty :
    (hiddenBlock.childMembers automaton true false).Nonempty := by
  decide

theorem reveal_true_nonempty :
    (hiddenBlock.childMembers automaton true true).Nonempty := by
  decide

/-- Positive event: reveal turns the size-two block into two singleton
children and spends exactly two ordered-ambiguity units. -/
theorem reveal_spends_exactly_two :
    hiddenBlock.squareAmbiguity automaton =
      hiddenBlock.branchSquareAmbiguity automaton true + 2 := by
  decide

/-- Equality boundary: the valid constant-response identity action retains
all ambiguity and creates no informative partition event. -/
theorem stay_spends_zero :
    hiddenBlock.branchSquareAmbiguity automaton false =
      hiddenBlock.squareAmbiguity automaton := by
  decide

end Control

end AnnotatedResidualSplit

end Pairfield
