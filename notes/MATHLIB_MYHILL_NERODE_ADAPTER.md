# Mathlib residual languages are predictive futures

## Exact checked bridge

For a deterministic automaton `M : DFA A X`, Mathlib's residual language at a
state is

\[
\mathcal L_x=M.\operatorname{acceptsFrom}(x).
\]

The repository behavior map records the Boolean acceptance observation after
every future word.  `Pairfield.MyhillNerodeAdapter` proves

\[
x\sim_{\mathrm{Future}}y\quad\Longleftrightarrow\quad
\mathcal L_x=\mathcal L_y.
\]

For prefixes `u,v`, Mathlib's `leftQuotient_accepts_apply` then yields

\[
u^{-1}L=v^{-1}L
\quad\Longleftrightarrow\quad
M.\operatorname{eval}(u)\sim_{\mathrm{Future}}M.\operatorname{eval}(v).
\]

This is a checked identity of objects, not an analogy between automata and
predictive quotients.

The bridge is compositional.  `stateLanguage_step` proves

\[
\mathcal L_{\delta(x,a)}=[a]^{-1}\mathcal L_x.
\]

Thus the map from concrete states to residual languages transports each
one-step action; it is not merely a terminal equality test.

## Next-action selector

The adapter exposes

```lean
def selectNext (M : DFA A X) (policy : X → A)
    (sound : ∀ ⦃x y⦄, FutureEq M.step observe x y → policy x = policy y) :
    BehavioralState M → A
```

with `selectNext_mk` reducing selection on a represented state to the original
policy.  Thus a proposed next action becomes executable on behavioral meaning
only after a proof that it is constant on complete-future classes.  A policy
that distinguishes future-equivalent states is rejected at the type boundary.

This is the smallest selector compatible with the repository's authority
discipline: the quotient licenses factorization, but it does not invent a
policy or authorize an action.

## Extensional versus finite executable content

The checked adapter now reaches Mathlib's actual Myhill--Nerode theorem.  Define

\[
\operatorname{ReachBeh}(M)
=\{[M.\operatorname{eval}(u)]_{\mathrm{Future}}:u\in A^*\}.
\]

The induced map

\[
[x]_{\mathrm{Future}}\longmapsto M.\operatorname{acceptsFrom}(x)
\]

is injective, and its image on `ReachBeh(M)` is exactly
`Set.range M.accepts.leftQuotient`.  Finiteness therefore transports in both
directions.  Combining this with Mathlib's
`Language.isRegular_iff_finite_range_leftQuotient` gives the checked theorem

\[
M.\operatorname{accepts}.\operatorname{IsRegular}
\quad\Longleftrightarrow\quad
\operatorname{ReachBeh}(M)\text{ is finite}.
\]

Reachability is not cosmetic.  A DFA may have infinitely many unreachable
states with mutually different future languages while its accepted language
is regular.  Hence the same iff for the whole ambient `BehavioralState M` is
false.

Mathlib's conclusion is `Set.Finite` of extensional sets.  It does not itself
provide decidable equality, enumeration, partition refinement, or a global
shortest-distinguishing-word horizon.

A finite executable minimizer still requires explicit finite state/action
tables and decidable observations.  The live checked return
`Pairfield.ResidualBFS` composes Mathlib left quotients with the repository's
`BehavioralBFS`: given a complete finite enumeration of the already-admitted
action type and a fuel, it returns a shortest separator, proves that `none`
means bounded residual agreement, and includes an equal-reached-state false
control.  It also proves that changing the complete enumeration preserves the
bounded-equality verdict and minimum witness length.  The list therefore does
not choose the control language; actual intervention restriction must change
the action type or interface.

A second checked return installs a sufficient horizon when the *ambient* state
type has `[Fintype X]`.  The synchronous pair monitor has `|X|^2` states;
Mathlib's `DFA.evalFrom_split` deletes a loop from an overlong separating run.
Thus search through fuel `|X|^2` returns `none` exactly when two reachable
prefix residuals are equal.  This is a total proof-producing equality decision
for an explicitly finite DFA presentation, though the bound is deliberately
non-sharp.

The two theorems still do not compose into an algorithm from regularity alone.
Regularity gives `Set.Finite` of reachable behavioral meanings; the quadratic
decision assumes an ambient `Fintype X`, which may be inflated by unreachable
and duplicate states.  The missing effective carrier was an explicitly
enumerable, transition-closed chart of reachable behavioral representatives.

## Return: the canonical chart and its exact boundary

The automata lineage returned that carrier as
`FiniteBehavioralPresentation M`.  It contains a finite chart state type,
concrete representatives, start and transition operations, and proofs that
the representatives simulate the ambient start and transitions up to complete
future equality.  Its existing theorem `accepts_eq` transports the recognized
language, while `ResidualBFS` uses the chart cardinality rather than the
ambient cardinality.

`Pairfield.NerodeChartAdapter` now identifies the strongest Mathlib object
already matching it: `Language.toDFA`.  Given
`regular : M.accepts.IsRegular`, `nerodePresentation M regular` has state type

```lean
Set.range M.accepts.leftQuotient
```

and its start and step are definitionally Mathlib's `toDFA.start` and
`toDFA.step`.  A residual state's range witness supplies a prefix; evaluating
that prefix in `M` gives a concrete representative.  Lean proves

```lean
stateLanguage M (residualRepresentative M state) = state.val
```

and from this one preservation boundary obtains start soundness, transition
soundness, equality of accepting states, and equality of recognized languages.
The canonical chart is additionally proved `AllStatesReachable` and
`IsReduced`: every residual is reached by its witnessing prefix, and equality
of all future observations forces literal equality of residual states.

This closes the *mathematical* chart identification but deliberately does not
erase the effective boundary.  `Set.Finite.fintype`, the residual prefix, and
the representative all use classical choice; `nerodePresentation` is marked
`noncomputable`.  Regularity therefore proves that the canonical finite chart
exists and is reduced, but does not emit runnable rows, decidable residual
equality, or a transition table.  A supplied `FiniteBehavioralPresentation`
remains strictly stronger operational data, and constructive reduction of such
a chart is the next live automata seam.

The immediate automata return strengthened this to the exact logical and
minimality statements. Lean now proves

```lean
M.accepts.IsRegular ↔ Nonempty (FiniteBehavioralPresentation M)
```

at the pinned state universe. Thus an explicit chart is not mathematically
stronger than regularity; it is only operationally stronger because the
forward implication is noncomputable.

For any other DFA `N` recognizing `M.accepts`, the map

```lean
state ↦ N.eval (residualPrefix M state)
```

from canonical residual states to `N.State` is injective. If two chosen
prefixes reach the same `N` state, Mathlib's
`leftQuotient_eq_stateLanguage_eval` makes their residual languages equal.
Consequently `nerodePresentation_card_le` proves that the canonical chart has
at most as many states as every finite recognizing DFA, even one containing
unreachable garbage or behavioral duplicates. Reachability, reduction, and
global cardinal minimality are therefore all checked.

## Return: executable reduction and the visited-state budget

The automata lineage has now closed the separate executable question.
`ReachableSubDFA` removes unreachable rows, `ChartQuotient` merges complete-
future duplicates, and `ExecutableMinimization` proves the resulting native
DFA globally cardinal-minimal without executing the noncomputable Nerode
presentation.

Its next live object is the proof-relevant `ReachQueue`: each retained row
carries the word that discovered it. `VisitedReach` proves these stored words
are valid and the state list is globally duplicate-free. The Mathlib adapter
`VisitedReachCardinality` applies `List.Nodup.length_le_card` to obtain

\[
\#\operatorname{states}(Q_r)\le |X|
\]

at every round `r`. This is an actual expansion budget for retained states,
but not yet a traversal-completeness theorem: the proof still needs to connect
queue rounds with word length and show that the frontier is empty and stable
by round `|X|`.

## Rigor boundary

Kernel-checked here: word-execution alignment, future equality iff residual
language equality, prefix-left-quotient transport, policy factorization to the
behavioral quotient, injectivity of residual language on behavioral meanings,
exact identification of reachable meanings with the left-quotient range, and
regularity iff finiteness of the reachable behavioral quotient.  The returned
adapter also checks the canonical residual representative, start/step/accept
preservation, recognized-language equality, reachability of every canonical
state, and absence of behavioral duplicates.

Not supplied computably by the regularity adapter: a finite quotient enumeration,
decidable residual equality, or a global minimization horizon.  `ResidualBFS`
supplies all three only from the stronger input of an explicit ambient
`Fintype X` plus decidable acceptance and a complete action enumeration; it
does not extract them from the regularity proof.  Neither theorem is a source
of policy authority.  Boolean acceptance is the declared observation;
multi-valued observations require explicit Boolean probes or a separate
generalized construction.

Replay in proof language only:

```text
cd formal/pairfield
lake build Pairfield.MyhillNerodeAdapter Pairfield.ResidualBFS Pairfield.NerodeChartAdapter
```
