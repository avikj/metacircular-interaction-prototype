# Shortest executable witnesses for Mathlib prefix residuals

## Exact square

Let `M : DFA A X`, and let `u,v : List A` be input prefixes.  Mathlib's
`Language.leftQuotient_accepts_apply` identifies

\[
M.\operatorname{accepts}.\operatorname{leftQuotient}(u)
=M.\operatorname{acceptsFrom}(M.\operatorname{eval}(u)).       \tag{1}
\]

`Pairfield.MyhillNerodeAdapter` already transports (1) to equality under every
future word.  `Pairfield.ResidualBFS` now composes that theorem with the native
length-layered search in `Pairfield.BehavioralBFS`:

```text
prefix u --M.eval--> reached state --BehavioralBFS--> shortest suffix w
   |                                      |
   v                                      v
left quotient u -----------------> membership differs at w
```

The executable

```text
shortestLeftQuotientWitnessUpTo M alphabet u v fuel
```

returns either `some w` or `none`.  Lean proves:

1. `some w` implies `w.length <= fuel` and membership in the two Mathlib left
   quotients differs;
2. `none` is equivalent to membership agreement for every suffix of length at
   most `fuel`;
3. every returned word has minimum length among **all** residual-language
   separators, not only those below the requested fuel;
4. prefixes reaching the same state return `none` at every fuel;
5. replacing one complete alphabet enumeration by another cannot change the
   `none` verdict or the minimum returned length.

For finite `X`, the adapter now also constructs the synchronous product
monitor `residualPairDFA M u v` on `X × X`.  Its accepting states are exactly
the pairs whose acceptance observations disagree.  Mathlib's
`DFA.evalFrom_split` deletes a nonempty loop from every accepting run of length
at least `|X × X|`.  Strong induction therefore proves

\[
L_u\ne L_v\quad\Longrightarrow\quad
\text{some separating suffix has length }<|X|^2.                 \tag{2}
\]

Consequently Lean checks that search with fuel `Fintype.card X ^ 2` returns
`none` if and only if the two Mathlib left quotients are extensionally equal.
This is a finite executable decision procedure, not merely an existence
statement about a finite set of quotients.

The no-fuel interface `shortestLeftQuotientWitness` installs that horizon.  It
retains a globally shortest separating suffix in the `some` branch, while
`reachableLeftQuotientEqDecidable` turns the `none` branch into proof-producing
`Decidable` evidence of extensional language equality.  The latter decision is
derived from execution and (2), not from an assumed equality oracle on sets.

## Reciprocal boundary with reachable regularity

Concurrently, `MyhillNerodeAdapter` gained the checked theorem
`accepts_isRegular_iff_reachableBehavioralStates_finite`: Mathlib regularity is
equivalent to `Set.Finite` of the **reachable behavioral quotient**, even if
the ambient state type is infinite.

The first reading of this return was too strong.  `Set.Finite` is extensional
`Prop`; by itself it does not expose an executable enumeration, decidable
equality, or representative transition table.  But Mathlib regularity does
classically imply existence of a finite chart.  `Pairfield.NerodeChartAdapter`
chooses a prefix for every residual and builds

```lean
nerodePresentation M regular : FiniteBehavioralPresentation M
```

whose state type is exactly `Set.range M.accepts.leftQuotient`.  Lean proves
that its start and transitions simulate the concrete DFA up to `FutureEq`,
that every chart state is reachable, and that equality under all futures
forces literal equality of chart states.  Consequently

```lean
M.accepts.IsRegular ↔
  Nonempty (FiniteBehavioralPresentation M)
```

at the appropriate universe.  This kills the claim that a finite chart is
logically stronger than regularity.  The correct residual is operational:
the forward construction uses `Classical.choose`, whereas a supplied
`FiniteBehavioralPresentation` is data that native search can execute.

`Pairfield.ReachableChart` supplies exactly this data boundary.  Its start and
one-step behavioral simulation laws already imply coverage of every reached
meaning; coverage is not an additional axiom.  The chart's finite native DFA
recognizes exactly `M.accepts`, and the pair-search theorems transport to it
with `|Chart.State|²` in place of the ambient `|X|²`.  An internal control has
ambient state type `Nat` but chart state type `Fin 3`; native reduction returns
the shortest separator `[true]` without assuming `[Fintype Nat]`.

The reciprocal construction also closes the extensional minimality half.
For any finite DFA `N` accepting the same language, send a residual state to
the state reached in `N` by its chosen witnessing prefix.  Distinct residuals
cannot land at the same state, because equal reached states have equal left
quotients.  Lean therefore proves

```lean
Fintype.card (nerodePresentation M regular).State ≤ Fintype.card N.State
```

even when `N` contains unreachable or behaviorally duplicate states.  This is
the usual Myhill--Nerode cardinal lower bound, now connected to the executable
chart while retaining the noncomputable/executable distinction.

## Arbitrary chart rows become decidable

The hostile review of the minimality map passed and returned a stronger
forecast: no additional **chart axiom** appears necessary for constructive
reduction.  This changed the next operation from prefix residuals to arbitrary
rows.  `Pairfield.ChartStateBFS` builds `statePairDFA M left right` directly on
`X × X`; it never asks that either row be reached from `M.start` and never
chooses a Mathlib residual representative.

Mathlib's `DFA.evalFrom_split` again deletes loops in an accepting pair run.
The adapter installs the safe `|X|²` horizon and proves

```lean
shortestStateWitness M alphabet left right = none ↔
  FutureEq M.step (acceptsBool M) left right
```

for every pair of finite DFA states.  The `some` branch is a genuine shortest
future separator, while `stateFutureEqDecidable` turns the `none` branch into
proof-producing exact equality.  A `FiniteBehavioralPresentation` therefore
already supplies every row comparison needed by a reducer once the external
finite control enumeration and acceptance decision are given.  Reachability
remains relevant only to removing garbage rows, not to deciding whether two
rows should merge.

The fifth theorem corrects an initially tempting reading of the executable
interface.  A complete list does not choose the control language: it enumerates
and orders the actions already present in the type `A`.  Control authority
lives in the action type or typed intervention interface.  List order can only
choose between equally short certificates.  This is the checked contact with
`CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md`.

## Native quotient and removal of unreachable rows

`Pairfield.ChartQuotient` now consumes the arbitrary-row decision directly.
Its state type is Mathlib's ordinary quotient

```lean
Quotient (dfaFutureSetoid M)
```

and its transition is the checked `quotientStep`.  The key interface lemma
`acceptsBool_behavioralQuotientDFA` identifies the quotient DFA's native
acceptance bit pointwise with the observation descended through the quotient.
From that equality Lean proves recognized-language preservation and
reducedness in the ordinary executable `acceptsBool` interface.  Mathlib's
`Quotient.fintype` becomes executable because
`ChartStateBFS.stateFutureEqDecidable` supplies the setoid decision.  The
four-row control has only three complete futures, and `native_decide` computes
the quotient cardinality as `3`.

The reciprocal audit first rejected five elaboration defects in this adapter:
an invalid quotient binder, an incorrect equivalence interface, an unstated
acceptance decision, a bad definitional-equality shortcut, and a downstream
native-control failure.  After those repairs, the independent Mathlib lineage
accepted the quotient and requested the pointwise acceptance lemma above.
That request changed the final interface: reducedness is no longer stated only
for a private descended observation.

The accepted quotient deliberately retains behaviorally unique garbage.
`Pairfield.ReachableSubDFA` closes that boundary constructively.  A second use
of Mathlib's `DFA.evalFrom_split` proves that every start-reachable state has a
reaching word of length strictly less than `Fintype.card X`.  Thus the bounded
native list `reachableRows M alphabet` is equivalent to unbounded start
reachability.  Its subtype is closed under every typed action, all of its
states carry reaching words, and its DFA accepts exactly the original
language.  Composing this carrier with the accepted future quotient gives
`reachableReducedDFA`: a finite executable DFA with the same language in
which every state is start-reachable and no two states have the same complete
accepted future.  On the four-row control, the reachable carrier and the
composed reducer both have cardinality `3` by `native_decide`.

`Pairfield.ExecutableMinimization` closes the cardinal statement rather than
leaving minimality as a structural gloss.  Each native reduced state maps to
its `stateLanguage`; all-state reachability proves this language lies in
Mathlib's residual range, and reducedness makes the map injective.  The checked
inequality

```lean
reachableReducedDFA_card_le M alphabet complete N accepts_eq
```

then composes this injection with `nerodePresentation_card_le`.  Hence the
native reachable/reduced quotient has no more states than **any** finite DFA
accepting the same language, including competitors with garbage and duplicate
rows.  The noncomputable canonical Nerode chart participates only as a proof
bridge; it is not invoked by the reducer.

## Shortest reaching witnesses retain their derivation fibres

`Pairfield.ShortestReach` applies the same finite-state loop deletion theorem
to a single target row.  Its native search

```lean
shortestReachingWord M alphabet target
```

uses the safe horizon `Fintype.card X`.  Lean proves that `none` is equivalent
to genuine unreachability by **every** word, while `some word` reaches the
target and has globally minimum length among all reaching words.  The
load-bearing Mathlib theorem is again `DFA.evalFrom_split`: deleting a
nonempty repeated-state loop turns any reaching run into one shorter than the
finite state cardinality.

The shortest word also contains a checked predecessor pointer.  If it is
nonempty, `shortestReachingWord_predecessor` proves that `word.dropLast`
reaches a predecessor whose final typed action reaches the target, and that
the prefix is itself globally shortest to that predecessor.  Word length
strictly decreases along these pointers.  Thus the certificates form a
well-founded predecessor forest as proof data, without silently changing the
action type or choosing a new control language.

The reciprocal Hopcroft result made one interface distinction mandatory.
Selecting an operational witness must not identify all the mathematical
derivations that reach the same state.  The adapter therefore exposes

```lean
ReachDerivationFiber M target := {word // M.eval word = target}
```

and proves that the active shortest-witness projection is inhabited exactly
when this full fibre is inhabited.  All other fibre members remain ordinary
Lean data; alphabet list order only breaks ties among equal-length active
witnesses.  This is the automata instance of Hopcroft's independent
`derivationFiber` / `activeWitnesses` separation, now checked on the Mathlib
DFA interface.

## Visited-state execution closes the word-enumeration gap

The Mathlib return in msg 0519 transported
`List.Nodup.length_le_card` to the new queue and asked for the three missing
clauses: completeness at round `|X|`, an empty frontier there, and agreement
with the earlier shortest-word specification.  `Pairfield.VisitedReach` now
checks all three.

The native queue stores `ReachNode`s, each containing a state and the word that
first discovered it.  A round expands only the current frontier, moves it
permanently to `closed`, and filters candidate successors against every state
already retained.  Lean proves the mutually supporting invariants:

1. every retained word evaluates to its stored state;
2. retained states are duplicate-free, so a row enters the expandable
   frontier at most once;
3. closed rows have every typed action represented in the visited set;
4. every word of length `n` has its endpoint visited by round `n`;
5. every retained word is globally shortest to its state;
6. `visitedReachNode? = none` exactly when the target is unreachable;
7. at round `Fintype.card X` the frontier is empty and another round is a
   fixed point;
8. completed state expansions are bounded by `Fintype.card X`.

Clause 7 is where Mathlib's `DFA.evalFrom_split` returns decisively.  A node
remaining at the cardinal frontier would carry a shortest word of length
`|X|`, while loop deletion supplies another reaching word of length `< |X|`,
a contradiction.  The companion
`Pairfield.VisitedReachCardinality` uses Mathlib's
`List.Nodup.length_le_card` for the finite discovery budget.  Finally,
`visitedReachNode?_length_eq_shortestReachingWord` proves that the queue and
the previous exhaustive word-layer specification return the same minimum
length, while allowing different equal-length tie choices.

The four-state native control visits exactly states `[0,1,2]`, retains words
`[[],[false],[false,true]]`, returns `[false,true]` for target `2`, returns
`none` for unreachable target `3`, and leaves the full derivation fibre from
the preceding section untouched.

The continuation is now closed at pair level as well.  The independently
landed `Pairfield.VisitedPairHorizon` instantiates the same queue on
`statePairDFA`, measures the number of pairs actually reached, proves the
saturated frontier empty, and makes `visitedPairWitness? = none` equivalent to
complete future equality.  `Pairfield.VisitedPair` adds the missing optimality
and proof-relevance layer:

- queue insertion order is proved nondecreasing in replay-word length;
- the first separating pair node is globally shortest among **all** suffixes,
  not just retained nodes;
- completed pair expansions are bounded by the actual reachable-pair count,
  itself at most `|X|²`, and the saturated queue is a fixed point;
- visited and exhaustive pair searches have exactly the same minimum length;
- `DistinguishingDerivationFiber` retains every separating suffix, while the
  active query selects one shortest inhabitant without identifying the rest.

Thus the old quadratic theorem remains the safe semantic horizon, but native
execution no longer enumerates all words below that horizon.  It expands each
reachable synchronous pair at most once.

`Pairfield.VisitedResidual` completes the transition back to Mathlib's native
language vocabulary.  For prefixes `left` and `right`, it runs precisely the
same pair query from `(M.eval left, M.eval right)` and proves:

- `none` iff `M.accepts.leftQuotient left =
  M.accepts.leftQuotient right`;
- a returned node is a genuine left-quotient membership separator and is
  globally shortest among every such separator;
- its minimum length agrees with the older exhaustive
  `shortestLeftQuotientWitness`;
- `ResidualSeparatorFiber` preserves all separating suffixes.

The adapter uses the existing checked pointwise identification between
Mathlib left-quotient membership and Boolean future observation.  No search is
duplicated and no extensional language equality is assumed as an oracle.

## Falsifier and replay

The internal three-state DFA has prefixes `[]` and `[false]` separated first by
the suffix `[true]`; Lean reduces the executable result to `some [true]` and
certifies residual-membership disagreement.  The control prefixes `[]` and
`[true]` reach the same state, and Lean proves the search returns `none`.

```sh
cd formal/pairfield
lake build Pairfield.NerodeChartAdapter Pairfield.ReachableChart \
  Pairfield.ChartStateBFS Pairfield.ChartQuotient \
  Pairfield.ReachableSubDFA Pairfield.ExecutableMinimization \
  Pairfield.ShortestReach Pairfield.VisitedReachCardinality \
  Pairfield.VisitedPair Pairfield.VisitedResidual
```

The newest focused target passes (`3025` jobs).  Its state controls return
`[false, true]` for reachable state `2` and `none` for unreachable state `3`
in the four-state quotient witness; its pair controls return `[true]` for the
separable chart rows and `none` for an equal-row control; the residual control
returns `[true]` for prefixes `[]` and `[false]`, and `none` for prefixes
reaching the same row.  `Pairfield.lean`
imports the adapter and both reducers.  A root
`lake build Pairfield` reaches the adapter but remains red in the unrelated
pre-existing `Pairfield.Lowenheim` and `Pairfield.DirectSmith2x2` targets; no
aggregate-green claim is made.

## Rigor boundary

All statements and controls are Lean-checked.  The result concerns left
quotients of prefixes reachable from `M.start`.  At arbitrary fuel, `none`
still means only bounded equality; at the proved quadratic horizon it means
full residual equality.  The canonical quotient DFA and its global cardinal
minimality are now proved, but the canonical construction is noncomputable.
The executable chart must still be supplied as data.  Given that data, the
native path now removes unreachable rows and emits the future quotient.  Start
reachability uses a checked visited-state traversal with at most `|X|` completed
row expansions; the new pair query uses a checked visited-pair traversal with
at most the number of actually reachable synchronous pairs, hence at most
`|X|²`, completed expansions.  The older quotient constructor still consumes
its exhaustive specification because changing that dependency would require a
module refactor; equality and minimum-length agreement are proved, so this is
an implementation-routing boundary rather than a semantic gap.  Candidate
edge generation is not separately costed.  The quotient carrier is executable
Lean data rather than a serialized external transition table.  The linear and
quadratic horizons are safe rather than sharp.

No novelty claim is made: left quotients, Myhill--Nerode equivalence, and
breadth-first shortest witnesses are standard.  The contribution is a checked
adapter making Mathlib's extensional theorem executable inside this formal
corpus while preserving its scope.

## Exact global horizon and reciprocal residual transport

`Pairfield.GlobalObservableHorizon` aggregates the pair queue without erasing
its sources.  For each ordered state pair it records zero for future equality,
otherwise the length of the globally shortest retained separator, and takes
the finite supremum.  Lean proves that number is the least fuel at which the
whole bounded observable kernel closes.  Every smaller fuel returns an
attaining ordered pair and the original replay node, which is still
bounded-equal through that fuel and separates at the global depth.

The independent adapter `Pairfield.ResidualObservableHorizon` uses Mathlib's
exact `Language.leftQuotient_accepts_apply` transition to prove, fuel by fuel:

- bounded equality of two prefix left quotients is bounded future equality of
  their reached native states;
- residual stabilization is executable by `visitedLeftQuotientWitness?` and
  introduces no second search;
- if every native state has a reaching prefix, the native global horizon is
  exactly the least Mathlib left-quotient stabilization depth;
- every earlier native obstruction transports to two reaching prefixes and
  the same pair-labelled globally shortest residual separator.

Reachability is load-bearing, not interface decoration.  The checked hostile
control has start state `0` fixed by every action, while two unreachable rows
first separate after one action.  Its whole-state horizon is `1`, but its
accepted language has one reachable residual and stabilizes at depth `0`.
Thus a language-level horizon cannot see arbitrary unreachable chart rows.

The focused residual target passes `3028` jobs.  The first root replay reached
and accepted the adapter but was red in the unrelated clean tracked
`Pairfield.BoundedPrimePair` proof, where `simp` already closed a goal before
a following `ring`.  That redundant tactic was subsequently removed upstream.
The current root is again red, now in the explicitly in-flight
`AdaptiveObservableHorizon` successor whose structural recursion has not yet
been accepted; no root-green claim is made for this checkpoint.
