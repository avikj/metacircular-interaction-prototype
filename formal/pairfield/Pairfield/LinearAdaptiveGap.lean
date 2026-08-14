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
    ∃ prefix : List (Fin n), (automaton n).eval prefix = state := by
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

theorem closesAt_one (n : Nat) : ObservableClosesAt step observe 1 := by
  rw [observableClosesAt_iff_bounded_implies_future]
  intro left right hbounded
  rw [bounded_one_injective n left right hbounded]
  exact futureEq_refl step observe right

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
  have hle : globalObservableHorizon (automaton n) (alphabet n) ≤ 1 :=
    hleast.2 (closesAt_one n)
  have hne : globalObservableHorizon (automaton n) (alphabet n) ≠ 0 := by
    intro hzero
    apply not_closesAt_zero hn
    rw [← hzero]
    exact hleast.1
  omega

theorem residual_horizon_isLeast {n : Nat} (hn : 2 ≤ n) :
    IsLeast { fuel : Nat | LeftQuotientsStabilizeAt (automaton n) fuel } 1 := by
  rw [← uniform_horizon_eq_one hn]
  exact globalObservableHorizon_isLeast_leftQuotientsStabilizeAt
    (automaton n) (alphabet n) (alphabet_complete n)
    (all_states_reachable n)

namespace BoolExperimentTree

/-- Actions encountered while repeatedly taking the false-response branch. -/
def falseSpine {A : Type} : BoolExperimentTree A → List A
  | .done => []
  | .query action onFalse _ => action :: falseSpine onFalse

theorem falseSpine_length_le_depth {A : Type} (tree : BoolExperimentTree A) :
    tree.falseSpine.length ≤ tree.depth := by
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
    (hleft : left ∉ tree.falseSpine) (hright : right ∉ tree.falseSpine) :
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
            · exact h.resolve_left hleft
            · exact h.resolve_left hright
          intro heq
          apply ih htail
          simpa [linear, trace, responses, step, observe, hleft, hright] using
            congrArg List.tail heq

end BoolExperimentTree

/-- Probe every hidden state except `omitted`. -/
def omitOneTree {n : Nat} (omitted : Fin n) :
    BoolExperimentTree (Fin n) :=
  BoolExperimentTree.linear ((Finset.univ.erase omitted).toList)

theorem omitOneTree_depth {n : Nat} (omitted : Fin n) :
    (omitOneTree omitted).depth = n - 1 := by
  simp [omitOneTree]

theorem omitOneTree_identifies {n : Nat} (omitted : Fin n) :
    (omitOneTree omitted).IdentifiesAll (@step n) observe := by
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
          have hmem :
              left ∈ (Finset.univ.erase omitted).toList ∨
                right ∈ (Finset.univ.erase omitted).toList := by
            by_cases hleft : left = omitted
            · have hright : right ≠ omitted := by
                intro hright
                exact hne (hleft.trans hright.symm)
              exact Or.inr (by simp [hright])
            · exact Or.inl (by simp [hleft])
          exact (BoolExperimentTree.linear_trace_ne_of_mem
            ((Finset.univ.erase omitted).toList) hne hmem) htrace

/-- The false-spine capacity obstruction: an identifying policy must name all
but at most one hidden state. -/
theorem adaptive_depth_lower_bound {n : Nat}
    (tree : BoolExperimentTree (Fin n))
    (hidentifies : tree.IdentifiesAll (@step n) observe) :
    n - 1 ≤ tree.depth := by
  classical
  let queried : Finset (Fin n) := tree.falseSpine.toFinset
  have hcomplement : (queriedᶜ).card ≤ 1 :=
    (Finset.card_le_one_iff).2 (by
      intro left right hleft hright
      have hleft' : left ∉ tree.falseSpine := by
        simpa [queried] using hleft
      have hright' : right ∉ tree.falseSpine := by
        simpa [queried] using hright
      exact Option.some.inj (hidentifies
        (tree.trace_eq_some_of_not_mem_falseSpine hleft' hright')))
  have hqueried : queried.card ≤ tree.falseSpine.length := by
    exact List.toFinset_card_le
  have hspine := tree.falseSpine_length_le_depth
  have htotal := Finset.card_add_card_compl queried
  simp only [Fintype.card_fin] at htotal
  omega

theorem adaptive_depth_isLeast {n : Nat} (hn : 2 ≤ n) :
    IsLeast { fuel : Nat | BoolExperimentTree.IdentifiesAtDepth
      (@step n) observe fuel } (n - 1) := by
  let omitted : Fin n := ⟨n - 1, by omega⟩
  constructor
  · exact ⟨omitOneTree omitted, omitOneTree_depth omitted,
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
