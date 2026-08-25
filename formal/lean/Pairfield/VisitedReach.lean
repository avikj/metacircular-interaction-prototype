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

/-- Every candidate state is either old or represented by the retained first
fresh node for that state. -/
theorem freshNodes_covers_candidate [DecidableEq X]
    (seen : List X) (candidates : List (ReachNode A X))
    {node : ReachNode A X} (hnode : node ∈ candidates) :
    node.state ∈ seen ∨
      ∃ kept ∈ freshNodes seen candidates, kept.state = node.state := by
  induction candidates generalizing seen with
  | nil => simp at hnode
  | cons head tail ih =>
      simp only [List.mem_cons] at hnode
      rcases hnode with rfl | htail
      · by_cases hseen : node.state ∈ seen
        · exact Or.inl hseen
        · exact Or.inr ⟨node, by simp [freshNodes, hseen], rfl⟩
      · by_cases hseen : head.state ∈ seen
        · simpa [freshNodes, hseen] using ih seen htail
        · rcases ih (head.state :: seen) htail with hold | hfresh
          · simp only [List.mem_cons] at hold
            rcases hold with heq | hold
            · exact Or.inr ⟨head, by simp [freshNodes, hseen], heq.symm⟩
            · exact Or.inl hold
          · obtain ⟨kept, hkept, heq⟩ := hfresh
            exact Or.inr ⟨kept, by simp [freshNodes, hseen, hkept], heq⟩

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

/-- Every closed row has already had every listed action expanded into the
visited set. -/
def ReachQueue.ClosedExpanded (M : DFA A X) (alphabet : List A)
    (queue : ReachQueue A X) : Prop :=
  ∀ node ∈ queue.closed, ∀ action ∈ alphabet,
    M.step node.state action ∈ queue.states

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

theorem ReachQueue.state_mem_states {queue : ReachQueue A X}
    {node : ReachNode A X} (hnode : node ∈ queue.nodes) :
    node.state ∈ queue.states := by
  simp only [ReachQueue.states, List.mem_map]
  exact ⟨node, hnode, rfl⟩

theorem advanceReachQueue_nodes_mono [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    {node : ReachNode A X} (hnode : node ∈ queue.nodes) :
    node ∈ (advanceReachQueue M alphabet queue).nodes := by
  let next := freshNodes queue.states
    (expandFrontier M alphabet queue.frontier)
  change node ∈ queue.nodes ++ next
  exact List.mem_append.mpr (Or.inl hnode)

theorem advanceReachQueue_states_mono [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    {state : X} (hstate : state ∈ queue.states) :
    state ∈ (advanceReachQueue M alphabet queue).states := by
  simp only [ReachQueue.states, List.mem_map] at hstate ⊢
  obtain ⟨node, hnode, rfl⟩ := hstate
  exact ⟨node, advanceReachQueue_nodes_mono M alphabet queue hnode, rfl⟩

theorem advanceReachQueue_frontier_successor [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    {node : ReachNode A X} (hnode : node ∈ queue.frontier)
    {action : A} (haction : action ∈ alphabet) :
    M.step node.state action ∈
      (advanceReachQueue M alphabet queue).states := by
  let candidate := node.child M action
  have hcandidate : candidate ∈
      expandFrontier M alphabet queue.frontier := by
    simp only [expandFrontier, List.mem_flatMap, List.mem_map]
    exact ⟨node, hnode, action, haction, rfl⟩
  rcases freshNodes_covers_candidate queue.states
      (expandFrontier M alphabet queue.frontier) hcandidate with
    hold | hfresh
  · exact advanceReachQueue_states_mono M alphabet queue hold
  · obtain ⟨kept, hkept, heq⟩ := hfresh
    have hkeptState : kept.state ∈
        (advanceReachQueue M alphabet queue).states := by
      apply ReachQueue.state_mem_states
        (queue := advanceReachQueue M alphabet queue)
        (node := kept)
      change kept ∈ queue.nodes ++ freshNodes queue.states
        (expandFrontier M alphabet queue.frontier)
      exact List.mem_append.mpr (Or.inr hkept)
    simpa [candidate, ReachNode.child, heq] using hkeptState

theorem advanceReachQueue_closedExpanded [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    (hclosed : queue.ClosedExpanded M alphabet) :
    (advanceReachQueue M alphabet queue).ClosedExpanded M alphabet := by
  intro node hnode action haction
  change node ∈ queue.closed ++ queue.frontier at hnode
  rcases List.mem_append.mp hnode with hold | hfrontier
  · exact advanceReachQueue_states_mono M alphabet queue
      (hclosed node hold action haction)
  · exact advanceReachQueue_frontier_successor M alphabet queue
      hfrontier haction

theorem runReachQueue_closedExpanded [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    (runReachQueue M alphabet round).ClosedExpanded M alphabet := by
  induction round with
  | zero => simp [ReachQueue.ClosedExpanded, runReachQueue, initialReachQueue]
  | succ n ih =>
      exact advanceReachQueue_closedExpanded M alphabet
        (runReachQueue M alphabet n) ih

/-- After one queue round, the successor of every already visited node is
visited.  Closed nodes use the expansion invariant; frontier nodes are
expanded by this round. -/
theorem advanceReachQueue_successor [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    (hclosed : queue.ClosedExpanded M alphabet)
    {node : ReachNode A X} (hnode : node ∈ queue.nodes)
    {action : A} (haction : action ∈ alphabet) :
    M.step node.state action ∈
      (advanceReachQueue M alphabet queue).states := by
  change node ∈ queue.closed ++ queue.frontier at hnode
  rcases List.mem_append.mp hnode with hold | hfrontier
  · exact advanceReachQueue_states_mono M alphabet queue
      (hclosed node hold action haction)
  · exact advanceReachQueue_frontier_successor M alphabet queue
      hfrontier haction

theorem runReachQueue_successor [DecidableEq X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (round : Nat)
    {state : X} (hstate : state ∈ (runReachQueue M alphabet round).states)
    (action : A) :
    M.step state action ∈ (runReachQueue M alphabet (round + 1)).states := by
  simp only [ReachQueue.states, List.mem_map] at hstate
  obtain ⟨node, hnode, heq⟩ := hstate
  subst state
  exact advanceReachQueue_successor M alphabet
    (runReachQueue M alphabet round)
    (runReachQueue_closedExpanded M alphabet round) hnode (complete action)

/-- Completeness at the exact word length: every control word has deposited
its endpoint into the visited queue by the corresponding round. -/
theorem runReachQueue_covers_word [DecidableEq X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (word : List A) :
    M.eval word ∈ (runReachQueue M alphabet word.length).states := by
  induction word using List.reverseRecOn with
  | nil => simp [runReachQueue, initialReachQueue, ReachQueue.states,
      ReachQueue.nodes]
  | append_singleton pre action ih =>
      have hnext := runReachQueue_successor M alphabet complete
        pre.length ih action
      simpa [DFA.eval, DFA.evalFrom_of_append] using hnext

theorem advanceReachQueue_nodes_mono_le [DecidableEq X]
    (M : DFA A X) (alphabet : List A) {first last : Nat}
    (hle : first ≤ last) {node : ReachNode A X}
    (hnode : node ∈ (runReachQueue M alphabet first).nodes) :
    node ∈ (runReachQueue M alphabet last).nodes := by
  obtain ⟨extra, rfl⟩ := Nat.exists_eq_add_of_le hle
  induction extra with
  | zero => simpa
  | succ n ih =>
      simpa [Nat.add_assoc, runReachQueue] using
        advanceReachQueue_nodes_mono M alphabet
          (runReachQueue M alphabet (first + n))
          (ih (Nat.le_add_right first n))

theorem mem_expandFrontier_word_length (M : DFA A X) (alphabet : List A)
    (frontier : List (ReachNode A X)) (round : Nat)
    (hfrontier : ∀ node ∈ frontier, node.word.length ≤ round) :
    ∀ child ∈ expandFrontier M alphabet frontier,
      child.word.length ≤ round + 1 := by
  intro child hchild
  simp only [expandFrontier, List.mem_flatMap, List.mem_map] at hchild
  obtain ⟨node, hnode, action, _, rfl⟩ := hchild
  simp only [ReachNode.child, List.length_append, List.length_singleton]
  exact Nat.add_le_add_right (hfrontier node hnode) 1

theorem advanceReachQueue_word_length [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X) (round : Nat)
    (hlength : ∀ node ∈ queue.nodes, node.word.length ≤ round) :
    ∀ node ∈ (advanceReachQueue M alphabet queue).nodes,
      node.word.length ≤ round + 1 := by
  intro node hnode
  simp only [advanceReachQueue, ReachQueue.nodes, List.mem_append] at hnode
  rcases hnode with hold | hfresh
  · exact Nat.le_trans (hlength node (List.mem_append.mpr hold))
      (Nat.le_succ round)
  · apply mem_expandFrontier_word_length M alphabet queue.frontier round
    · intro old hfrontier
      exact hlength old (List.mem_append.mpr (Or.inr hfrontier))
    · exact mem_freshNodes_imp_mem hfresh

theorem runReachQueue_word_length [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    ∀ node ∈ (runReachQueue M alphabet round).nodes,
      node.word.length ≤ round := by
  induction round with
  | zero =>
      intro node hnode
      simp [runReachQueue, initialReachQueue, ReachQueue.nodes] at hnode
      rcases hnode with rfl
      simp
  | succ n ih =>
      simpa [runReachQueue] using
        advanceReachQueue_word_length M alphabet
          (runReachQueue M alphabet n) n ih

theorem mem_expandFrontier_word_length_eq (M : DFA A X) (alphabet : List A)
    (frontier : List (ReachNode A X)) (round : Nat)
    (hfrontier : ∀ node ∈ frontier, node.word.length = round) :
    ∀ child ∈ expandFrontier M alphabet frontier,
      child.word.length = round + 1 := by
  intro child hchild
  simp only [expandFrontier, List.mem_flatMap, List.mem_map] at hchild
  obtain ⟨node, hnode, action, _, rfl⟩ := hchild
  simp only [ReachNode.child, List.length_append, List.length_singleton]
  exact congrArg (· + 1) (hfrontier node hnode)

/-- The frontier really is a breadth layer: every word retained there has
length exactly equal to the round number. -/
theorem runReachQueue_frontier_word_length [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    ∀ node ∈ (runReachQueue M alphabet round).frontier,
      node.word.length = round := by
  induction round with
  | zero =>
      intro node hnode
      simp [runReachQueue, initialReachQueue] at hnode
      rcases hnode with rfl
      rfl
  | succ n ih =>
      intro node hnode
      change node ∈ freshNodes (runReachQueue M alphabet n).states
        (expandFrontier M alphabet
          (runReachQueue M alphabet n).frontier) at hnode
      apply mem_expandFrontier_word_length_eq M alphabet
        (runReachQueue M alphabet n).frontier n ih
      exact mem_freshNodes_imp_mem hnode

theorem ReachQueue.node_eq_of_state_eq (queue : ReachQueue A X)
    (hnodup : queue.states.Nodup) {left right : ReachNode A X}
    (hleft : left ∈ queue.nodes) (hright : right ∈ queue.nodes)
    (heq : left.state = right.state) : left = right := by
  have hnodes : queue.nodes.Nodup := List.Nodup.of_map _ hnodup
  exact (List.nodup_map_iff_inj_on hnodes).mp hnodup
    left hleft right hright heq

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
    exact List.mem_append.mpr hclosed
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

/-- Fresh filtering makes the visited-state invariant executable: no state is
ever admitted twice, so every node enters the expandable frontier at most
once. -/
theorem advanceReachQueue_states_nodup [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    (hnodup : queue.states.Nodup) :
    (advanceReachQueue M alphabet queue).states.Nodup := by
  let candidates := expandFrontier M alphabet queue.frontier
  let next := freshNodes queue.states candidates
  change ((queue.nodes ++ next).map ReachNode.state).Nodup
  rw [List.map_append, List.nodup_append']
  refine ⟨hnodup, freshNodes_states_nodup queue.states candidates, ?_⟩
  simp only [List.disjoint_left]
  intro state hseen hfresh
  simp only [List.mem_map] at hfresh
  obtain ⟨node, hnode, rfl⟩ := hfresh
  exact (freshNodes_state_not_mem_seen queue.states candidates node hnode) hseen

theorem runReachQueue_states_nodup [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    (runReachQueue M alphabet round).states.Nodup := by
  induction round with
  | zero => simp [runReachQueue, initialReachQueue, ReachQueue.states,
      ReachQueue.nodes]
  | succ n ih =>
      exact advanceReachQueue_states_nodup M alphabet
        (runReachQueue M alphabet n) ih

/-- Every retained node carries a globally shortest reaching word.  The proof
uses completeness at the candidate word's length, monotonicity of the visited
set, and uniqueness of state representatives. -/
theorem runReachQueue_node_minimal [DecidableEq X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (round : Nat)
    {node : ReachNode A X}
    (hnode : node ∈ (runReachQueue M alphabet round).nodes) :
    ∀ candidate : List A, M.eval candidate = node.state →
      node.word.length ≤ candidate.length := by
  intro candidate hcandidate
  by_contra hnot
  have hcandlt : candidate.length < node.word.length :=
    Nat.lt_of_not_ge hnot
  have hnodeRound := runReachQueue_word_length M alphabet round node hnode
  have hcandRound : candidate.length ≤ round :=
    Nat.le_trans (Nat.le_of_lt hcandlt) hnodeRound
  have hcover := runReachQueue_covers_word M alphabet complete candidate
  simp only [ReachQueue.states, List.mem_map] at hcover
  obtain ⟨prior, hprior, hpriorState⟩ := hcover
  have hpriorLater := advanceReachQueue_nodes_mono_le M alphabet
    hcandRound hprior
  have hsame : prior = node :=
    ReachQueue.node_eq_of_state_eq (runReachQueue M alphabet round)
      (runReachQueue_states_nodup M alphabet round)
      hpriorLater hnode (hpriorState.trans hcandidate)
  have hpriorLength := runReachQueue_word_length M alphabet
    candidate.length prior hprior
  have hnodeLength : node.word.length ≤ candidate.length := by
    simpa [hsame] using hpriorLength
  exact (Nat.not_lt_of_ge hnodeLength) hcandlt

/-- Run the visited traversal through the Mathlib loop-deletion horizon. -/
def visitedReachQueue [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A) : ReachQueue A X :=
  runReachQueue M alphabet (Fintype.card X)

/-- Native lookup of the unique retained node for a target row. -/
def visitedReachNode? [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A) (target : X) :
    Option (ReachNode A X) :=
  (visitedReachQueue M alphabet).nodes.find?
    (fun node => decide (node.state = target))

/-- A returned node is a replayable, globally shortest certificate. -/
theorem visitedReachNode?_sound [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X)
    {node : ReachNode A X}
    (hnode : visitedReachNode? M alphabet target = some node) :
    node.Valid M ∧ node.state = target ∧
      ∀ candidate : List A, M.eval candidate = target →
        node.word.length ≤ candidate.length := by
  have hmem : node ∈ (visitedReachQueue M alphabet).nodes :=
    List.mem_of_find?_eq_some hnode
  have hstate : node.state = target := by
    have := List.find?_some hnode
    simpa using this
  refine ⟨runReachQueue_valid M alphabet (Fintype.card X) node hmem,
    hstate, ?_⟩
  intro candidate hcandidate
  apply runReachQueue_node_minimal M alphabet complete
    (Fintype.card X) hmem candidate
  exact hcandidate.trans hstate.symm

/-- `none` is exact unreachability.  Completeness uses the same Mathlib
`DFA.evalFrom_split` consequence as `ShortestReach`: every reachable row has a
loop-free word shorter than the state cardinality. -/
theorem visitedReachNode?_eq_none_iff [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X) :
    visitedReachNode? M alphabet target = none ↔
      ∀ word : List A, M.eval word ≠ target := by
  unfold visitedReachNode?
  rw [List.find?_eq_none]
  constructor
  · intro hnone word hword
    obtain ⟨short, hlength, heval⟩ := exists_short_eval_eq M word
    have hcover := runReachQueue_covers_word M alphabet complete short
    simp only [ReachQueue.states, List.mem_map] at hcover
    obtain ⟨node, hnode, hstate⟩ := hcover
    have hnodeFinal : node ∈ (visitedReachQueue M alphabet).nodes := by
      apply advanceReachQueue_nodes_mono_le M alphabet
        (Nat.le_of_lt hlength) hnode
    have hfalse := hnone node hnodeFinal
    have htarget : node.state = target :=
      hstate.trans (heval.trans hword)
    simpa [htarget] using hfalse
  · intro hunreachable node hnode
    have hvalid := runReachQueue_valid M alphabet
      (Fintype.card X) node hnode
    have hne : node.state ≠ target := by
      intro hstate
      exact hunreachable node.word (hvalid.trans hstate)
    simp [hne]

/-- The traversal expands at most one node per finite state.  `closed` is
exactly the list of nodes expanded by completed rounds. -/
theorem visitedReachQueue_expansion_bound [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A) :
    (visitedReachQueue M alphabet).closed.length ≤ Fintype.card X := by
  have hstates : (visitedReachQueue M alphabet).states.length ≤
      Fintype.card X :=
    (runReachQueue_states_nodup M alphabet (Fintype.card X)).length_le_card
  simp only [ReachQueue.states, ReachQueue.nodes, List.length_map,
    List.length_append] at hstates
  omega

/-- The cardinal horizon is saturated: no unexpanded discovery remains. -/
theorem visitedReachQueue_frontier_eq_nil [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) :
    (visitedReachQueue M alphabet).frontier = [] := by
  apply List.eq_nil_iff_forall_not_mem.mpr
  intro node hfrontier
  have hlength := runReachQueue_frontier_word_length M alphabet
    (Fintype.card X) node hfrontier
  have hnode : node ∈ (visitedReachQueue M alphabet).nodes := by
    change node ∈ (visitedReachQueue M alphabet).closed ++
      (visitedReachQueue M alphabet).frontier
    exact List.mem_append.mpr (Or.inr hfrontier)
  have hvalid := runReachQueue_valid M alphabet
    (Fintype.card X) node hnode
  obtain ⟨short, hshort, heval⟩ := exists_short_eval_eq M node.word
  have hminimal := runReachQueue_node_minimal M alphabet complete
    (Fintype.card X) hnode short (heval.trans hvalid)
  omega

theorem advanceReachQueue_eq_self_of_frontier_eq_nil [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (queue : ReachQueue A X)
    (hfrontier : queue.frontier = []) :
    advanceReachQueue M alphabet queue = queue := by
  cases queue with
  | mk closed frontier =>
      simp only at hfrontier
      subst frontier
      simp [advanceReachQueue, ReachQueue.states, ReachQueue.nodes,
        expandFrontier, freshNodes]

theorem visitedReachQueue_stable [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) :
    advanceReachQueue M alphabet (visitedReachQueue M alphabet) =
      visitedReachQueue M alphabet :=
  advanceReachQueue_eq_self_of_frontier_eq_nil M alphabet _
    (visitedReachQueue_frontier_eq_nil M alphabet complete)

/-- The visited-state implementation and the original word-layer
specification may choose different equal-length ties, but their returned
lengths agree exactly. -/
theorem visitedReachNode?_length_eq_shortestReachingWord
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet) (target : X)
    {node : ReachNode A X} {word : List A}
    (hvisited : visitedReachNode? M alphabet target = some node)
    (hshortest : shortestReachingWord M alphabet target = some word) :
    node.word.length = word.length := by
  have hvisitedSound := visitedReachNode?_sound M alphabet complete
    target hvisited
  have hshortestSound := shortestReachingWord_sound M alphabet complete
    target hshortest
  apply Nat.le_antisymm
  · exact hvisitedSound.2.2 word hshortestSound
  · apply shortestReachingWord_minimal M alphabet complete target hshortest
    exact hvisitedSound.1.trans hvisitedSound.2.1

namespace VisitedReachWitness

open ChartQuotientWitness

example : (runReachQueue automaton alphabet 3).states = [0, 1, 2] := by
  decide

example : (runReachQueue automaton alphabet 3).nodes.map ReachNode.word =
    [[], [false], [false, true]] := by
  decide

example : (visitedReachNode? automaton alphabet (2 : Fin 4)).map
    ReachNode.word = some [false, true] := by
  decide

example : visitedReachNode? automaton alphabet (3 : Fin 4) = none := by
  decide

example : ∀ node ∈ (runReachQueue automaton alphabet 3).nodes,
    node.Valid automaton :=
  runReachQueue_valid automaton alphabet 3

example : (runReachQueue automaton alphabet 3).states.Nodup :=
  runReachQueue_states_nodup automaton alphabet 3

end VisitedReachWitness

end Pairfield
