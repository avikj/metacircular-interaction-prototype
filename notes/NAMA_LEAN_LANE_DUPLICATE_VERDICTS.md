# नाम — verdicts on the Lean lane's eighteen duplicate groups

Census: `runghc machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs --full`,
run 2026-08-22. Lean lane at that moment: 138 `.lean` files, 1,906 top-level
declarations, 1,871 distinct content addresses, 24 addresses holding more than
one declaration, of which **18 confirmed identical text** and 6 hash collisions
that are not the same text.

A confirmed group is a verdict about **presentation**, not about mathematics —
the census says so in its own limits, and this file is the other half. For each
group: does the identical text name one object (factor it) or several (leave
it, and say what distinguishes them). Every verdict is also written at the
site, because a ledger nobody opens is not in hand at the moment of the next
write.

**नयभेदे सङ्क्षेपो न विद्यते** — where the standpoints differ there is no
abbreviation. Do not merge to tidy.

## The result

| verdict | groups | declarations |
|---|---|---|
| identified — one object, both sites kept, sameness now checked by `rfl` | 2 | 4 |
| left standing — same text, different object or different role | 16 | 41 |
| merged | 0 | 0 |

Nothing was merged. That was not the expected outcome and it is the finding:
**sixteen of eighteen groups are one text over several objects.** `lake build`:
exit 0, 8859 jobs, before and after.

## Identified, not merged (2 groups)

**`step` ×2 and `automaton` ×2** — `NativeWitnessGreedyFormation.Control` and
`NativeDemandRestrictedFormation.Control`. These two really are one 3-state
automaton, and one module imports the other, so a merge was available.

It was not taken. A control that reaches into another module for its own
subject is no longer a control, and each of these modules has to be readable
where it stands. What the duplication was costing was not space but *silence*:
the two modules run two different formation policies — greedy pruning of a
planted duplicate, demand-restricted scheduling — and both land on
`{[], [false]}`, and that comparison is only meaningful because the fixture is
one fixture. So the sameness is now checked instead of merged, in
`Pairfield/NativeDemandRestrictedFormation.lean`:

```lean
theorem step_eq_greedy_control_step :
    step = NativeWitnessGreedyFormation.Control.step := rfl
theorem automaton_eq_greedy_control :
    automaton = NativeWitnessGreedyFormation.Control.automaton := rfl
```

Both close by `rfl`. This is what the census note itself prescribes:
mathematical sameness is a checked edge, not a shared name.

## The one that was factored and then un-factored (2 groups)

**`alphabet` ×6 and `alphabet_complete` ×6** — the lane's two largest groups,
in `BehavioralBFS`, `ReachableChart`, `ResidualBFS`, `ChartQuotient`,
`AdaptiveObservableHorizon`, `ReachableAdaptiveObservableHorizon`. Six copies
of `[false, true]` and six copies of `∀ a : Bool, a ∈ [false, true]`.

This looked like the clear factoring case: a fact about `Bool` that mentions no
automaton, no state type and no module, in six modules that all reach
`BehavioralBFS` by import. It was factored — `boolAlphabet` and
`boolAlphabet_complete` stated once, the six sites reduced to `abbrev`s.

**Then re-running the census refuted it**, and the repair kept refuting it:

1. With `abbrev alphabet : List Bool := boolAlphabet` at the six sites, both
   groups were **still ×6** — twelve duplicated lines had been traded for
   twelve differently-duplicated lines. A merge that a hash cannot see is not
   a merge.
2. Deleting the six local names instead broke `ChartStateBFS`,
   `ResidualObservableHorizon`, `ReachableSubDFA`, `ExecutableMinimization` and
   others: **eighteen modules `open` those witness namespaces and use the bare
   name.**
3. `alphabet : List A` with `complete : ∀ a : A, a ∈ alphabet` is a *parameter
   pair* of the general theory, bound in roughly 117 places across the lane.
   The witness constants are that parameter filled in, not a constant the
   theory refers to. A lane-wide rename would have renamed 117 binders in
   theory that is not about `Bool` at all.
4. Decisively: **`LinearAdaptiveGap` defines its own `alphabet` and
   `alphabet_complete` over `Fin n`.** Same role, different alphabet. The six
   coincide only because `Bool` happens to have two elements — the name is a
   role, and `LinearAdaptiveGap` is the counter-instance that proves it.

Reverted. Verdict: same text, different question. Recorded at the site in
`Pairfield/BehavioralBFS.lean` so the next agent does not spend the hour again.

The general lesson is worth more than the group: **a duplicate group over a
role name is not a duplicate.** `alphabet`, `step`, `observe`, `automaton`,
`reach`, `reveal` are all role names in this lane, and role names are exactly
the vocabulary a content address cannot distinguish from constants.

## Left standing (the other 14 groups)

**`automaton` ×4** — `ResidualBFS`, `NativeDemandRestrictedFormation`,
`NativeWitnessGreedyFormation`, `AdaptiveResidualAnnotatedSplit`. The five
lines are identical and **they name four different automata**, because the
`step` each refers to differs: action-blind (`if state = 1 then 2 else state`)
in the two `Native` modules, `0 --false--> 1 --true--> 2` in `ResidualBFS`,
`true`-gated in `AdaptiveResidualAnnotatedSplit`. The census's dependency scan
is lexical; here that is the whole story. This is the group that would have
done real damage if merged.

**Seven groups shared by `AdaptiveObservableHorizon` and
`ReachableAdaptiveObservableHorizon`** — `observe`, `automaton`,
`adaptiveTree`, `adaptiveTree_depth`, `adaptiveTree_identifies`,
`adaptive_depth_isLeast`, `uniform_horizon_eq_one` (nine with the two
`alphabet` groups). The declaration *not* shared is `step`: the reachable
module's start row branches on the action, so every row is reachable and
`all_states_reachable` goes through. Different automaton, therefore seven
different theorems wearing identical words — and the identical wording is the
module's entire content, since what it asserts is that the adaptive/uniform
horizon gap survives the reachability hypothesis. Merging would delete the
comparison the module exists to make.

**`reach` ×2, `reveal` ×2, `merge`/`steer`** — `AdaptiveResidualSplitting` and
`AdaptiveConstantResponseSteering`. Action labels, `: Fin 3 := 0/1/2`. A label
is an index into an alphabet: there they drive a `DFA (Fin 3) (Fin 5)` where
`steer` separates a pair `reveal` cannot; here a `DFA (Fin 3) (Fin 3)` where
`merge` collapses one. `merge` and `steer` share a text and are not even the
same *role*. Sharing them would assert an identification of the two experiments
that nothing proves.

**`observe` ×2 (`BehavioralBFS` / `AdaptiveResidualSplitting`)** —
`decide (state = 2)` on `Fin 3`, over two different systems. An observation is
a function *of a system*; two systems share one only by accident of state
numbering.

**`chartStep` / `step` (`ReachableChart` / `ResidualBFS`)** — that one is a
DFA's transition, this one a *chart's*, existing only as the finite mirror of
`ambientStep : Nat → Bool → Nat` five lines above it. The pair is what
`chart.step_sound` is about; pointing it at another module's witness automaton
would leave the correspondence unreadable at the site that proves it.

**`overlapLeft` / `incompatibleRight` (`IncrementalCRTAdapter`, same file)** —
both `⟨2, 6⟩`, and the sharpest case in the lane. `⟨2, 6⟩` is compatible with
`⟨8, 9⟩` and incompatible with `⟨1, 4⟩`. Compatibility is a property of a
*pair*, never of a congruence state; naming one state twice under the two roles
it plays **is** the statement, and one name for both roles would make the two
controls look like one, which is precisely the inference the pair blocks.

**`steeringLanguageDecidableEq` / `languageDecidableEq`
(`AdaptiveResidualSteering` / `AdaptiveResidualPotentialAdapter`)** — both
`local instance … := Classical.decEq _`. The entire content of `local` is that
a classical decision procedure for language equality is admitted inside one
file and nowhere else. Factoring it into a shared module would promote it to a
global instance, which is the one consequence the keyword exists to prevent.

## What the census cannot see, restated from its own limits

A Lean group is a floor. The addresser takes only keyword-introduced named
declarations; the dependency scan is lexical, so `automaton ×4` above is one
text and four objects and nothing in the digest could have told them apart. The
digest bounds the **work** — eighteen groups to open — and never the truth.

The number that came out is worth writing down: **0 merges, 2 checked
identifications, 16 left standing.** A census of a lane whose modules are
mostly worked controls over small finite objects will report mostly role-name
collisions, and the correct response to almost all of them is a sentence, not
an edit.
