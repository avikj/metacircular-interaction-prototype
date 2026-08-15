/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A proof-relevant inventory of genuine reverse product edges.  Unlike the flat
reverse alphabet, a native edge records its unique source and target.  Mathlib's
alphabet-comap theorem checks that decoding an edge trace preserves DFA
evaluation exactly.
-/
import Pairfield.NativeReversePairTraversal

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeReverseEdgeInventory

open NativeReverseSeparatorPolicy
open NativeReversePairTraversal

variable [DecidableEq X]

/-- A proof-bearing seed edge exists only for a genuinely response-separated
pair.  The proof is erased by native evaluation but prevents false seeds from
entering the executable inventory. -/
structure TerminalSeed (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] where
  pair : X × X
  terminal : TerminalPair M pair

/-- Genuine reverse edges.  A predecessor edge is determined by one original
product state and one original action; its source is computed, not searched. -/
inductive ReverseEdge (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] where
  | seed (data : TerminalSeed M)
  | predecessor (pair : X × X) (action : A)

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Decode the proof-relevant native edge into the earlier flat reverse move. -/
def ReverseEdge.toMove : ReverseEdge M → ReverseMove A X
  | .seed data => .seed data.pair
  | .predecessor pair action => .predecessor pair action

/-- The unique reverse state at which this edge is enabled. -/
def ReverseEdge.source : ReverseEdge M → Option (X × X)
  | .seed _ => none
  | .predecessor pair action => some (pairStep M pair action)

/-- The unique state reached by this genuine edge. -/
def ReverseEdge.target : ReverseEdge M → Option (X × X)
  | .seed data => some data.pair
  | .predecessor pair _ => some pair

/-- Every proof-relevant edge performs its advertised source-to-target move in
the existing reverse DFA. -/
theorem reverseStep_toMove_source (edge : ReverseEdge M) :
    reverseStep M edge.source edge.toMove = edge.target := by
  cases edge with
  | seed data =>
      simp [ReverseEdge.source, ReverseEdge.target, ReverseEdge.toMove,
        reverseStep, data.terminal]
  | predecessor pair action =>
      simp [ReverseEdge.source, ReverseEdge.target, ReverseEdge.toMove,
        reverseStep]

/-- The native edge automaton is the alphabet pullback of the existing reverse
DFA along the checked decoder. -/
def edgeDFA : DFA (ReverseEdge M) (Option (X × X)) :=
  (reverseDFA M).comap (ReverseEdge.toMove M)

/-- Exact Mathlib adapter: evaluation of any native edge trace is evaluation
of the decoded reverse-move trace.  This is `DFA.evalFrom_comap` specialized to
the repository's proof-relevant edge carrier. -/
theorem edgeDFA_evalFrom (state : Option (X × X))
    (edges : List (ReverseEdge M)) :
    (edgeDFA M).evalFrom state edges =
      (reverseDFA M).evalFrom state
        (edges.map (ReverseEdge.toMove M)) := by
  simpa [edgeDFA] using
    (DFA.evalFrom_comap (reverseDFA M) (ReverseEdge.toMove M) state edges)

theorem edgeDFA_step_source (edge : ReverseEdge M) :
    (edgeDFA M).step edge.source edge = edge.target := by
  change reverseStep M edge.source edge.toMove = edge.target
  exact reverseStep_toMove_source M edge

variable [LinearOrder X] [Fintype X]

/-- Construct a seed only when the decidable Moore response test proves that
the pair is terminal. -/
def terminalEdge? (pair : X × X) : Option (ReverseEdge M) :=
  if h : TerminalPair M pair then
    some (.seed ⟨pair, h⟩)
  else
    none

/-- Every genuine terminal seed, with false seeds removed before traversal. -/
def terminalEdges : List (ReverseEdge M) :=
  (pairList (X := X)).filterMap (terminalEdge? M)

/-- Exactly one genuine predecessor edge for each product-state/action pair. -/
def predecessorEdges (alphabet : List A) : List (ReverseEdge M) :=
  (pairList (X := X)).flatMap fun pair =>
    alphabet.map (ReverseEdge.predecessor pair)

/-- The once-constructed raw edge inventory from which a source index can be
materialized. -/
def edgeInventory (alphabet : List A) : List (ReverseEdge M) :=
  terminalEdges M ++ predecessorEdges M alphabet

theorem pairList_length :
    (pairList (X := X)).length = Fintype.card X * Fintype.card X := by
  simp [pairList]

private theorem filterMap_length_le {Y Z : Type*} (f : Y → Option Z) :
    ∀ xs : List Y, (xs.filterMap f).length ≤ xs.length
  | [] => by simp
  | x :: xs => by
      cases h : f x with
      | none =>
          simp only [List.filterMap, h, List.length_cons]
          exact Nat.le_succ_of_le (filterMap_length_le f xs)
      | some value =>
          simp only [List.filterMap, h, List.length_cons]
          exact Nat.succ_le_succ (filterMap_length_le f xs)

theorem terminalEdges_length_le :
    (terminalEdges M).length ≤ Fintype.card X * Fintype.card X := by
  exact (filterMap_length_le (terminalEdge? M) (pairList (X := X))).trans_eq
    (pairList_length (X := X))

theorem predecessorEdges_length (alphabet : List A) :
    (predecessorEdges M alphabet).length =
      Fintype.card X * Fintype.card X * alphabet.length := by
  simp [predecessorEdges, pairList_length (X := X)]

/-- Honest inventory bound.  This counts stored genuine edges, not association
list lookup, index construction, or queue transition attempts. -/
theorem edgeInventory_length_le (alphabet : List A) :
    (edgeInventory M alphabet).length ≤
      Fintype.card X * Fintype.card X * (alphabet.length + 1) := by
  rw [edgeInventory, List.length_append, predecessorEdges_length]
  calc
    (terminalEdges M).length +
        Fintype.card X * Fintype.card X * alphabet.length ≤
      Fintype.card X * Fintype.card X +
        Fintype.card X * Fintype.card X * alphabet.length :=
          Nat.add_le_add_right (terminalEdges_length_le M) _
    _ = Fintype.card X * Fintype.card X * (alphabet.length + 1) := by
      simp [Nat.mul_add, Nat.add_comm, Nat.mul_assoc]

namespace Control

open BehavioralBFSWitness
open VisitedPairHorizonWitness

/-- The three-state native control has four genuine terminal seeds and
eighteen predecessor edges, versus twenty-seven flat reverse labels. -/
theorem inventory_has_twenty_two_edges :
    (edgeInventory automaton alphabet).length = 22 := by
  decide

theorem inventory_respects_generic_bound :
    (edgeInventory automaton alphabet).length ≤
      Fintype.card (Fin 3) * Fintype.card (Fin 3) *
        (alphabet.length + 1) := by
  decide

/-- Native evaluation encounters the same product state before and after
decoding a proof-relevant predecessor edge. -/
theorem native_predecessor_adapter_control :
    (edgeDFA automaton).evalFrom (some (0, 2))
        [ReverseEdge.predecessor (0, 1) false] =
      (reverseDFA automaton).evalFrom (some (0, 2))
        [ReverseMove.predecessor (0, 1) false] := by
  decide

end Control

end NativeReverseEdgeInventory

end Pairfield
