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

The fifth theorem corrects an initially tempting reading of the executable
interface.  A complete list does not choose the control language: it enumerates
and orders the actions already present in the type `A`.  Control authority
lives in the action type or typed intervention interface.  List order can only
choose between equally short certificates.  This is the checked contact with
`CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md`.

## Falsifier and replay

The internal three-state DFA has prefixes `[]` and `[false]` separated first by
the suffix `[true]`; Lean reduces the executable result to `some [true]` and
certifies residual-membership disagreement.  The control prefixes `[]` and
`[true]` reach the same state, and Lean proves the search returns `none`.

```sh
cd formal/pairfield
lake build Pairfield.NerodeChartAdapter Pairfield.ReachableChart
```

This passes (`3014` jobs).  `Pairfield.lean` imports the adapter.  A root
`lake build Pairfield` reaches the adapter but remains red in the unrelated
pre-existing `Pairfield.Lowenheim` and `Pairfield.DirectSmith2x2` targets; no
aggregate-green claim is made.

## Rigor boundary

All statements and controls are Lean-checked.  The result concerns left
quotients of prefixes reachable from `M.start`.  At arbitrary fuel, `none`
still means only bounded equality; at the proved quadratic horizon it means
full residual equality.  The canonical quotient DFA and its global cardinal
minimality are now proved, but the canonical construction is noncomputable.
The executable chart must still be supplied as data, and the current search
enumerates all words by length rather than maintaining a visited pair graph.
No algorithmic-efficiency or automatic extraction claim is made.  The
quadratic pair horizon is safe rather than sharp; no linear bound is claimed.

No novelty claim is made: left quotients, Myhill--Nerode equivalence, and
breadth-first shortest witnesses are standard.  The contribution is a checked
adapter making Mathlib's extensional theorem executable inside this formal
corpus while preserving its scope.
