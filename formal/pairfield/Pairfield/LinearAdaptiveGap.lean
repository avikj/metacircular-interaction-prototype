/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An all-state-reachable family with uniform observable horizon one and exact
adaptive identification depth `n - 1`.
-/
import Pairfield.AdaptiveUniformBound
import Pairfield.ResidualObservableHorizon

namespace Pairfield

namespace LinearAdaptiveGap

/-- `none` is the observed start.  Probe `i` toggles `none` to hidden state
`i`, sends hidden state `i` back to `none`, and fixes every other hidden
state. -/
def step {n : Nat} : Option (Fin n) → Fin n → Option (Fin n)
  | none, action => some action
  | some state, action => if state = action then none else some state

def observe {n : Nat} : Option (Fin n) → Bool
  | none => true
  | some _ => false

def automaton (n : Nat) : DFA (Fin n) (Option (Fin n)) where
  step := step
  start := none
  accept := { state | observe state = true }

instance (n : Nat) : DecidablePred
    (fun state : Option (Fin n) => state ∈ (automaton n).accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

def alphabet (n : Nat) : List (Fin n) := List.finRange n

theorem alphabet_complete (n : Nat) (action : Fin n) :
    action ∈ alphabet n := by
  simp [alphabet]

/-- Unlike R0049's first ambient control, every row in this family is a
genuine prefix-reached state. -/
theorem all_states_reachable (n : Nat) (state : Option (Fin n)) :
    ∃ word : List (Fin n), (automaton n).eval word = state := by
  cases state with
  | none => exact ⟨[], rfl⟩
  | some action => exact ⟨[action], rfl⟩

/-- Present observation plus all singleton probes already reconstructs the
state. -/
theorem bounded_one_injective (n : Nat) (left right : Option (Fin n))
    (hbounded : BoundedFutureEq step observe 1 left right) : left = right := by
  cases left with
  | none =>
      cases right with
      | none => rfl
      | some right =>
          have hnow := hbounded [] (by simp)
          simp [behavior, run, observe] at hnow
  | some left =>
      cases right with
      | none =>
          have hnow := hbounded [] (by simp)
          simp [behavior, run, observe] at hnow
      | some right =>
          by_cases heq : left = right
          · rw [heq]
          · have hprobe := hbounded [left] (by simp)
            have hne : right ≠ left := Ne.symm heq
            simp [behavior, run, step, observe, heq, hne] at hprobe

theorem closesAt_one (n : Nat) :
    ObservableClosesAt (@step n) (@observe n) 1 := by
  rw [observableClosesAt_iff_bounded_implies_future]
  intro left right hbounded
  rw [bounded_one_injective n left right hbounded]
  exact futureEq_refl step observe right

theorem acceptsBool_automaton (n : Nat) :
    acceptsBool (automaton n) = (@observe n) := by
  funext state
  cases state <;> rfl

theorem not_closesAt_zero {n : Nat} (hn : 2 ≤ n) :
    ¬ ObservableClosesAt (@step n) observe 0 := by
  let first : Fin n := ⟨0, by omega⟩
  let second : Fin n := ⟨1, by omega⟩
  have hbounded : BoundedFutureEq (@step n) observe 0
      (some first) (some second) := by
    intro word hlength
    have hzero : word.length = 0 := Nat.eq_zero_of_le_zero hlength
    have hnil : word = [] := List.length_eq_zero_iff.mp hzero
    subst word
    rfl
  apply bounded_collision_obstructs_closure (@step n) observe hbounded [first]
  simp [behavior, run, step, observe, first, second]

/-- The executable R0048 horizon is exactly one throughout the family. -/
theorem uniform_horizon_eq_one {n : Nat} (hn : 2 ≤ n) :
    globalObservableHorizon (automaton n) (alphabet n) = 1 := by
  have hleast := globalObservableHorizon_isLeast
    (automaton n) (alphabet n) (alphabet_complete n)
  have hclose : ObservableClosesAt (automaton n).step
      (acceptsBool (automaton n)) 1 := by
    rw [acceptsBool_automaton]
    exact closesAt_one n
  have hle : globalObservableHorizon (automaton n) (alphabet n) ≤ 1 :=
    hleast.2 hclose
  have hne : globalObservableHorizon (automaton n) (alphabet n) ≠ 0 := by
    intro hzero
    apply not_closesAt_zero hn
    rw [← acceptsBool_automaton]
    rw [← hzero]
    exact hleast.1
  omega

theorem residual_horizon_isLeast {n : Nat} (hn : 2 ≤ n) :
    IsLeast { fuel : Nat | LeftQuotientsStabilizeAt (automaton n) fuel } 1 := by
  rw [← uniform_horizon_eq_one hn]
  exact globalObservableHorizon_isLeast_leftQuotientsStabilizeAt
    (automaton n) (alphabet n) (alphabet_complete n)
    (all_states_reachable n)

open BoolExperimentTree

/-- Actions encountered while repeatedly taking the false-response branch. -/
def falseSpine {A : Type} : BoolExperimentTree A → List A
  | .done => []
  | .query action onFalse _ => action :: falseSpine onFalse

theorem falseSpine_length_le_depth {A : Type} (tree : BoolExperimentTree A) :
    (falseSpine tree).length ≤ tree.depth := by
  induction tree with
  | done => rfl
  | query action onFalse onTrue ihFalse ihTrue =>
      simp only [falseSpine, List.length_cons, depth]
      have hle : onFalse.depth ≤ max onFalse.depth onTrue.depth :=
        Nat.le_max_left _ _
      omega

/-- Two hidden states never named on the false spine return the same trace. -/
theorem trace_eq_some_of_not_mem_falseSpine {n : Nat}
    (tree : BoolExperimentTree (Fin n)) {left right : Fin n}
    (hleft : left ∉ falseSpine tree) (hright : right ∉ falseSpine tree) :
    tree.trace (@step n) observe (some left) =
      tree.trace step observe (some right) := by
  induction tree with
  | done => rfl
  | query action onFalse onTrue ihFalse ihTrue =>
      simp only [falseSpine, List.mem_cons, not_or] at hleft hright
      rcases hleft with ⟨hleftAction, hleftTail⟩
      rcases hright with ⟨hrightAction, hrightTail⟩
      simpa [trace, responses, step, observe, hleftAction, hrightAction] using
        congrArg (List.cons false) (ihFalse hleftTail hrightTail)

/-- A linear singleton-test policy continues only after a false response. -/
def linear {A : Type} : List A → BoolExperimentTree A
  | [] => .done
  | action :: actions => .query action (linear actions) .done

@[simp]
theorem linear_depth {A : Type} (actions : List A) :
    (linear actions).depth = actions.length := by
  induction actions with
  | nil => rfl
  | cons action actions ih => simp [linear, depth, ih]

/-- If at least one of two distinct hidden states is probed by a linear tree,
their traces differ. -/
theorem linear_trace_ne_of_mem {n : Nat} (actions : List (Fin n))
    {left right : Fin n} (hne : left ≠ right)
    (hmem : left ∈ actions ∨ right ∈ actions) :
    (linear actions).trace (@step n) observe (some left) ≠
      (linear actions).trace step observe (some right) := by
  induction actions with
  | nil => simp at hmem
  | cons action actions ih =>
      simp only [List.mem_cons] at hmem
      by_cases hleft : left = action
      · subst action
        have hright : right ≠ left := Ne.symm hne
        simp [linear, trace, responses, step, observe, hright]
      · by_cases hright : right = action
        · subst action
          simp [linear, trace, responses, step, observe, hleft]
        · have htail : left ∈ actions ∨ right ∈ actions := by
            rcases hmem with (h | h)
            · exact Or.inl (h.resolve_left hleft)
            · exact Or.inr (h.resolve_left hright)
          intro heq
          apply ih htail
          simpa [linear, trace, responses, step, observe, hleft, hright] using
            congrArg List.tail heq

/-- Probe every hidden state except `omitted`. -/
noncomputable def omitOneTree {n : Nat} (omitted : Fin n) :
    BoolExperimentTree (Fin n) :=
  linear ((Finset.univ.erase omitted).toList)

theorem omitOneTree_depth {n : Nat} (omitted : Fin n) :
    (omitOneTree omitted).depth = n - 1 := by
  classical
  simp [omitOneTree]

theorem omitOneTree_identifies {n : Nat} (omitted : Fin n) :
    (omitOneTree omitted).IdentifiesAll (@step n) observe := by
  classical
  intro left right htrace
  cases left with
  | none =>
      cases right with
      | none => rfl
      | some right =>
          simp [BoolExperimentTree.trace, observe] at htrace
  | some left =>
      cases right with
      | none =>
          simp [BoolExperimentTree.trace, observe] at htrace
      | some right =>
          by_contra hne
          have hneFin : left ≠ right := by
            intro heq
            apply hne
            rw [heq]
          have hmem :
              left ∈ (Finset.univ.erase omitted).toList ∨
                right ∈ (Finset.univ.erase omitted).toList := by
            by_cases hleft : left = omitted
            · have hright : right ≠ omitted := by
                intro hright
                exact hneFin (hleft.trans hright.symm)
              exact Or.inr (by simp [hright])
            · exact Or.inl (by simp [hleft])
          exact (linear_trace_ne_of_mem
            ((Finset.univ.erase omitted).toList) hneFin hmem) htrace

/-- The false-spine capacity obstruction: an identifying policy must name all
but at most one hidden state. -/
theorem adaptive_depth_lower_bound {n : Nat}
    (tree : BoolExperimentTree (Fin n))
    (hidentifies : tree.IdentifiesAll (@step n) observe) :
    n - 1 ≤ tree.depth := by
  classical
  let queried : Finset (Fin n) := (falseSpine tree).toFinset
  have hcomplement : (queriedᶜ).card ≤ 1 :=
    (Finset.card_le_one_iff).2 (by
      intro left right hleft hright
      have hleft' : left ∉ falseSpine tree := by
        simpa [queried] using hleft
      have hright' : right ∉ falseSpine tree := by
        simpa [queried] using hright
      exact Option.some.inj (hidentifies
        (trace_eq_some_of_not_mem_falseSpine tree hleft' hright')))
  have hqueried : queried.card ≤ (falseSpine tree).length := by
    simpa [queried] using (falseSpine tree).toFinset_card_le
  have hspine := falseSpine_length_le_depth tree
  have htotal := Finset.card_add_card_compl queried
  simp only [Fintype.card_fin] at htotal
  omega

theorem adaptive_depth_isLeast {n : Nat} (hn : 2 ≤ n) :
    IsLeast { fuel : Nat | BoolExperimentTree.IdentifiesAtDepth
      (@step n) observe fuel } (n - 1) := by
  let omitted : Fin n := ⟨n - 1, by omega⟩
  constructor
  · exact ⟨omitOneTree omitted, (omitOneTree_depth omitted).le,
      omitOneTree_identifies omitted⟩
  · intro fuel hidentifies
    obtain ⟨tree, hdepth, htree⟩ := hidentifies
    exact Nat.le_trans (adaptive_depth_lower_bound tree htree) hdepth

/-- Exact reachable cost package and an unbounded strict gap. -/
theorem exact_linear_gap {n : Nat} (hn : 2 ≤ n) :
    globalObservableHorizon (automaton n) (alphabet n) = 1 ∧
      IsLeast { fuel : Nat |
        LeftQuotientsStabilizeAt (automaton n) fuel } 1 ∧
      IsLeast { fuel : Nat | BoolExperimentTree.IdentifiesAtDepth
        (@step n) observe fuel } (n - 1) :=
  ⟨uniform_horizon_eq_one hn, residual_horizon_isLeast hn,
    adaptive_depth_isLeast hn⟩

end LinearAdaptiveGap

end Pairfield
