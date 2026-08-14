/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A native visited-state traversal for finite DFAs.  Unlike the earlier
word-layer specification, a row enters the frontier at most once and carries
the reaching word that discovered it.
-/
import Pairfield.ShortestReach

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- One discovered row together with its replayable reaching word. -/
structure ReachNode (A : Type u) (X : Type v) where
  state : X
  word : List A
deriving Repr

/-- The invariant carried by every node admitted to the traversal. -/
def ReachNode.Valid (M : DFA A X) (node : ReachNode A X) : Prop :=
  M.eval node.word = node.state

/-- Extend one proof-relevant node by one typed action. -/
def ReachNode.child (M : DFA A X) (node : ReachNode A X) (action : A) :
    ReachNode A X :=
  ⟨M.step node.state action, node.word ++ [action]⟩

theorem ReachNode.child_valid (M : DFA A X) {node : ReachNode A X}
    (hnode : node.Valid M) (action : A) : (node.child M action).Valid M := by
  rw [ReachNode.Valid, ReachNode.child, DFA.eval, DFA.evalFrom_of_append]
  change M.evalFrom (M.eval node.word) [action] = M.step node.state action
  rw [hnode]
  rfl

/-- Keep the first candidate for every state not already in `seen`.  The seen
list grows during the fold, so duplicates in the candidate layer are removed
as well. -/
def freshNodes [DecidableEq X] (seen : List X) :
    List (ReachNode A X) → List (ReachNode A X)
  | [] => []
  | node :: rest =>
      if node.state ∈ seen then freshNodes seen rest
      else node :: freshNodes (node.state :: seen) rest

theorem mem_freshNodes_imp_mem [DecidableEq X]
    {seen : List X} {candidates : List (ReachNode A X)} {node : ReachNode A X}
    (hnode : node ∈ freshNodes seen candidates) : node ∈ candidates := by
  induction candidates generalizing seen with
  | nil => simp [freshNodes] at hnode
  | cons head tail ih =>
      by_cases hseen : head.state ∈ seen
      · simp [freshNodes, hseen] at hnode
        exact List.mem_cons_of_mem head (ih hnode)
      · simp only [freshNodes, hseen, ↓reduceIte, List.mem_cons] at hnode
        rcases hnode with rfl | hnode
        · exact List.mem_cons_self
        · exact List.mem_cons_of_mem head (ih hnode)

theorem freshNodes_state_not_mem_seen [DecidableEq X]
    (seen : List X) (candidates : List (ReachNode A X)) :
    ∀ node ∈ freshNodes seen candidates, node.state ∉ seen := by
  induction candidates generalizing seen with
  | nil => simp [freshNodes]
  | cons head tail ih =>
      by_cases hseen : head.state ∈ seen
      · simpa [freshNodes, hseen] using ih seen
      · intro node hnode
        simp only [freshNodes, hseen, ↓reduceIte, List.mem_cons] at hnode
        rcases hnode with rfl | hnode
        · exact hseen
        · have hnot := ih (head.state :: seen) node hnode
          exact fun hmem => hnot (List.mem_cons_of_mem head.state hmem)

theorem freshNodes_states_nodup [DecidableEq X]
    (seen : List X) (candidates : List (ReachNode A X)) :
    ((freshNodes seen candidates).map ReachNode.state).Nodup := by
  induction candidates generalizing seen with
  | nil => simp [freshNodes]
  | cons head tail ih =>
      by_cases hseen : head.state ∈ seen
      · simpa [freshNodes, hseen] using ih seen
      · simp only [freshNodes, hseen, ↓reduceIte, List.map_cons,
          List.nodup_cons]
        constructor
        · intro hmem
          simp only [List.mem_map] at hmem
          obtain ⟨node, hnode, heq⟩ := hmem
          have hnot := freshNodes_state_not_mem_seen
            (head.state :: seen) tail node hnode
          exact hnot (by simpa [heq])
        · exact ih (head.state :: seen)

/-- Closed nodes have already been expanded; frontier nodes are the unique
unexpanded discoveries at the current distance. -/
structure ReachQueue (A : Type u) (X : Type v) where
  closed : List (ReachNode A X)
  frontier : List (ReachNode A X)
deriving Repr

def ReachQueue.nodes (queue : ReachQueue A X) : List (ReachNode A X) :=
  queue.closed ++ queue.frontier

def ReachQueue.states (queue : ReachQueue A X) : List X :=
  queue.nodes.map ReachNode.state

def expandFrontier (M : DFA A X) (alphabet : List A)
    (frontier : List (ReachNode A X)) : List (ReachNode A X) :=
  frontier.flatMap fun node => alphabet.map (node.child M)

def initialReachQueue (M : DFA A X) : ReachQueue A X :=
  ⟨[], [⟨M.start, []⟩]⟩

/-- One genuine visited-state step: every current frontier row is expanded,
then moved permanently to `closed`; only first visits enter the next frontier.
-/
def advanceReachQueue [DecidableEq X] (M : DFA A X) (alphabet : List A)
    (queue : ReachQueue A X) : ReachQueue A X :=
  let next := freshNodes queue.states
    (expandFrontier M alphabet queue.frontier)
  ⟨queue.closed ++ queue.frontier, next⟩

def runReachQueue [DecidableEq X] (M : DFA A X) (alphabet : List A) :
    Nat → ReachQueue A X
  | 0 => initialReachQueue M
  | n + 1 => advanceReachQueue M alphabet (runReachQueue M alphabet n)

theorem mem_expandFrontier_valid (M : DFA A X) (alphabet : List A)
    (frontier : List (ReachNode A X))
    (hvalid : ∀ node ∈ frontier, node.Valid M) :
    ∀ child ∈ expandFrontier M alphabet frontier, child.Valid M := by
  intro child hchild
  simp only [expandFrontier, List.mem_flatMap, List.mem_map] at hchild
  obtain ⟨node, hnode, action, _, rfl⟩ := hchild
  exact ReachNode.child_valid M (hvalid node hnode) action

theorem advanceReachQueue_valid [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    (hvalid : ∀ node ∈ queue.nodes, node.Valid M) :
    ∀ node ∈ (advanceReachQueue M alphabet queue).nodes, node.Valid M := by
  intro node hnode
  simp only [advanceReachQueue, ReachQueue.nodes, List.mem_append] at hnode
  rcases hnode with hclosed | hfresh
  · apply hvalid node
    change node ∈ queue.closed ++ queue.frontier
    exact hclosed
  · have hcandidates := mem_freshNodes_imp_mem hfresh
    apply mem_expandFrontier_valid M alphabet queue.frontier
    · intro old hold
      exact hvalid old (by
        simp only [ReachQueue.nodes, List.mem_append]
        exact Or.inr hold)
    · exact hcandidates

theorem runReachQueue_valid [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    ∀ node ∈ (runReachQueue M alphabet round).nodes, node.Valid M := by
  induction round with
  | zero =>
      intro node hnode
      simp [runReachQueue, initialReachQueue, ReachQueue.nodes] at hnode
      rcases hnode with rfl
      rfl
  | succ n ih =>
      exact advanceReachQueue_valid M alphabet
        (runReachQueue M alphabet n) ih

namespace VisitedReachWitness

open ChartQuotientWitness

example : (runReachQueue automaton alphabet 3).states = [0, 1, 2] := by
  native_decide

example : (runReachQueue automaton alphabet 3).nodes.map ReachNode.word =
    [[], [false], [false, true]] := by
  native_decide

example : ∀ node ∈ (runReachQueue automaton alphabet 3).nodes,
    node.Valid automaton :=
  runReachQueue_valid automaton alphabet 3

end VisitedReachWitness

end Pairfield
