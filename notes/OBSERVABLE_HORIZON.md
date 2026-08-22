# Finite observable horizons

**Status.** Checked in Lean by
`formal/pairfield/Pairfield/ObservableHorizon.lean`, with its semantic kernel
compiled independently into Cubical Agda by
`formal/cubical/NaturalMachine/ObservableHorizon.agda`.  The construction is
standard finite automata mathematics placed at the observable-formation
boundary of R0044/R0045; no novelty is claimed.

## 1. The bounded observable

Let `X` be a state type, `A` an action alphabet, `s : X → A → X` a
transition, and `q : X → O` an observation.  For `n : ℕ`, define

\[
x\equiv_n y
\quad\Longleftrightarrow\quad
q(s_wx)=q(s_wy)\quad
\text{for every word }w\text{ with }|w|\le n.
\]

This is equality under the complete finite response carrier through depth
`n`.  Say that this carrier *closes* when its kernel admits every installed
one-step action:

\[
x\equiv_n y \Longrightarrow s_a x\equiv_n s_a y
\qquad(a\in A).
\]

This definition does not assume an enumeration, a chosen quotient
representative, or a predictor table.

## 2. Stabilization theorem

**Theorem 2.1 (finite observable formation).**  The depth-`n` carrier closes
if and only if

\[
x\equiv_n y \Longrightarrow
q(s_wx)=q(s_wy)\quad\text{for every finite word }w.
\]

In other words, a finite response kernel is action-stable exactly when it has
already stabilized to complete future equivalence.

**Proof.**  If the kernel closes, induct on the arbitrary word.  The empty
word is included in the bounded carrier.  For `aw`, closure transports
`x≡_n y` to `s_a x≡_n s_a y`, and the induction hypothesis handles `w`.
Conversely, complete future equivalence is a congruence for every action;
restrict it again to words of length at most `n`.  Lean checks both maps as
`observableClosesAt_iff_bounded_implies_future`. ∎

**Corollary 2.2 (collision obstruction).**  If `x≡_n y` but any later word
separates the two states, the depth-`n` carrier cannot close.  Thus the later
response is not merely evidence of failure: it is a missing experimental
coordinate forced by the admitted action language.

## 3. Finite-state bound and retained obstruction

For a Boolean DFA on a finite state type `X`, the synchronous pair monitor
has `|X|²` states.  The already checked loop-deletion theorem supplies, from
any separating word, a separating word of length strictly below `|X|²`.
Theorem 2.1 therefore gives

\[
\boxed{\text{the depth-}|X|^2\text{ observable always closes}.}
\]

This is `finiteDFA_observableClosesAt_card_sq`.  It is a semantic bound, not
an assertion that an implementation must enumerate every word or every pair.

If `shortestStateWitness` returns `w`, its checked global minimality implies
that the two states agree through every depth `n<|w|`; its checked soundness
supplies the separating response at `w`.  Hence the same retained word
certifies failure of *every* smaller horizon.  Lean checks this as
`shortestStateWitness_obstructs_before`.

## 4. Executable formation event

The existing three-state control has Boolean actions and observation
`q(x)=[x=2]`.  States `0` and `1` agree now, but action `true` sends only state
`1` to the observed state `2`.  Therefore depth zero is not closed.

The present response together with the response to `true` distinguishes all
three states.  Depth-one equality is consequently literal state equality, so
it is future-equivalent and closed.  Lean checks

\[
\neg\operatorname{ClosesAt}(0)
\quad\text{and}\quad
\operatorname{ClosesAt}(1).
\]

This is a formation event in the requested causal sense: admitting one
action-response coordinate changes a non-transferable observation into an
exact predictive state carrier.  No hidden state oracle is granted; the
injectivity proof is a finite case term over the response window.

## 5. Visited-pair compilation

The concurrent visited-reach work separately checks the implementation facts
that were excluded from Theorem 2.1: unique visited representatives, global
minimality, an empty frontier after the state-cardinality horizon, stability,
and at most one expansion per state.  The checked continuation
`Pairfield.VisitedPairHorizon` now applies that traversal to the synchronous
pair monitor.

For declared states `x,y`, it retains the exact reachable-pair queue and
defines its implementation-level carrier

\[
R(x,y)=\#\{\text{pair nodes actually expanded from }(x,y)\}.
\]

Lean proves `R(x,y)≤|X|²`, emptiness of the terminal pair frontier, replay
validity of every returned node, and completeness: every semantic separator
has a retained separating node whose replay word still has length below
`|X|²`.  Searching those retained nodes gives an exact executable decision:

\[
\operatorname{visitedPairWitness?}(x,y)=\texttt{none}
\iff x\equiv_\infty y.
\]

The independent `Pairfield.VisitedPair` continuation proves that queue order
is breadth-first, so the selected separator is globally shortest, not merely
shortest among words reaching its terminal pair.  It also retains the full
subtype of all distinguishing derivations.  Finally,
`Pairfield.ObservableVisitedPairAdapter` joins the semantic and executable
statements without loss:

\[
\operatorname{ClosesAt}(n)
\iff
\forall x\equiv_n y,
\operatorname{visitedPairWitness?}(x,y)=\texttt{none}.
\]

> **Correction by addition, 2026-08-15 (claude, Hoare lineage;
> `notes/LEAN_STATEMENT_AUDIT.md`).**  The two displayed biconditionals of §5
> write `visitedPairWitness?(x,y)` as a function of two states.  In Lean it
> takes a third explicit argument, `alphabet : List A`, and both equivalences
> carry the hypothesis `complete : ∀ action : A, action ∈ alphabet`:
>
> ```lean
> visitedPairWitness?_eq_none_iff (M : DFA A X) (alphabet : List A)
>   (complete : ∀ action : A, action ∈ alphabet) (left right : X) :
>   visitedPairWitness? M alphabet left right = none ↔
>     FutureEq M.step (acceptsBool M) left right
> observableClosesAt_iff_visitedPairWitness_none … (complete : …) (fuel : Nat) : …
> ```
>
> Same hypothesis on `visitedStatePairQueue_frontier_eq_nil` and
> `exists_visited_pair_separator`.  It is not decorative: an incomplete
> `alphabet` never expands the missing action, so `none` would certify future
> equivalence that does not hold.  The one clause of the paragraph above that
> is genuinely hypothesis-free is `R(x,y) ≤ |X|²`
> (`reachableStatePairCount_le_card_sq` needs no `complete`).  §4's and §1–§3's
> statements are unaffected; they were checked against their terms and match.

The three-state control makes the distinction visible.  Its ambient pair
space has size nine, but the pair monitor from `(0,1)` expands exactly two
pairs and returns `[true]`.  The monitor from `(0,0)` returns `none`.  The
formation event therefore consumes the reachable derivation fibre, not an
ambient square census.

The next residual is global rather than pairwise: construct the least closing
horizon of the whole finite presentation by aggregating these retained pair
witnesses without discarding which pair each word separates.

## 6. Cubical semantic adapter and its exact boundary

The Cubical module defines the same bounded kernel as `BoundedFutureEq` and
compiles action closure directly into the existing
`FutureBehavior.isBehavioralCongruence` record.  Its two fields are not new
proof obligations: bounded equality at the empty word gives observation
equality, and `ObservableClosesAt` is literally preservation by one action.
The already-checked greatest-congruence theorem then supplies complete future
equality.  Conversely, any proof that bounded equality implies complete future
equality makes the bounded kernel action-stable.  Thus Cubical checks both

\[
  \operatorname{ClosesAt}(n)
  \iff (\equiv_n\text{ is a behavioral congruence})
  \iff (\equiv_n\Rightarrow\equiv_\infty).
\]

The adapter deliberately stops there.  It does **not** translate the Lean
visited-pair queue, its expansion count, or its shortest retained witness;
those are executable finite-state evidence rather than part of the semantic
theorem.

The continuation now constructs exactly the action that closure licenses.
`ResponseWindow` packages a word together with its depth certificate, and
equality of its response functions is proved equivalent to bounded future
equality.  For a closing horizon,

\[
  \operatorname{Carrier}_n
  = \operatorname{Image}(X\to\operatorname{ResponseWindow}_n)
\]

inherits every installed action.  `RealizedWindow.actionFactors` uses the
choice-free descent theorem already checked in `FiniteInformation`: closure
makes the advanced response constant on each response fiber, so elimination
of the truncated image witness into the set-valued carrier constructs
`imageStep`.  Its replay law is exact on every state:

\[
  \operatorname{imageStep}([x],a)=[s_a x].
\]

This repairs the useful part of the boundary without weakening it.  Kernel
closure still does **not** by itself inhabit
`PredictorFormation.PredictorAt`, which asks for a total update function on
the entire ambient observation codomain.  The image action is total only on
realized response classes.  Extending it to every unrealized observation
requires extra extension or chosen-section data.  Silently identifying these
two interfaces remains an unsound translation.

### 6.1 Realized image versus complete future quotient

Pointwise equality of the bounded and complete kernels is not, by itself, a
type identification.  The Cubical continuation therefore constructs both
maps from the native universal properties and proves their inverse laws:

\[
 \operatorname{Image}(X\to\operatorname{ResponseWindow}_n)
 \;\mathop{\simeq}\;
 X/\!\equiv_\infty.
\]

The direction from the complete future quotient to the realized image is
unconditional: complete future equality restricts to every bounded window,
so the state-to-image map descends through `FutureQuotient.factor`.  The
reverse direction is exactly where closure is consumed.  Equal bounded
windows first become complete future-equivalent by Theorem 2.1, hence define
the same quotient point; choice-free image descent then gives `toMeaning`.

`RealizedWindow.realizedMeaningIso` packages these maps as an explicit
Cubical `Iso`, and `realizedMeaningEquiv` exposes the corresponding
equivalence.  Neither kernel equality nor a connected-component label is
treated as object identity.  The inverse laws follow from uniqueness of the
two factorizations: `FutureQuotient.factor-unique` on the quotient side and
`FiniteInformation.isPropFactorsThrough` on the image side.

The adapter also preserves the installed dynamics, not merely the carrier:

\[
 \operatorname{toMeaning}(\operatorname{imageStep}(c,a))
 =
 \operatorname{quotStep}(\operatorname{toMeaning}(c),a).
\]

This commuting law is again obtained by uniqueness of descent from states.
The empty-word coordinate also defines `imageObserve`, and the same uniqueness
argument proves

\[
 \operatorname{imageObserve}(c)
 =
 \operatorname{quotObserve}(\operatorname{toMeaning}(c)).
\]

Induction on words then gives `toMeaning-run` and
`toMeaning-behavior`: arbitrary finite execution and its observation commute
with the equivalence.  Thus the exact positive result is a machine equivalence
on realized response classes, not only an equivalence of underlying types.
The negative boundary from the preceding paragraph remains: no map from the
whole ambient response-function type to itself has been constructed.

## 7. Exact least global horizon

The checked module `Pairfield.GlobalObservableHorizon` assigns an ordered pair
`(x,y)` the length of its globally shortest visited separator, or zero if the
visited query returns `none`.  It then takes the finite supremum

\[
H(M)=\max_{(x,y)\in X^2} h(x,y).
\]

The zero convention handles both boundary cases correctly.  A pair separated
by the empty word has delay zero because it never belongs to bounded equality,
while a future-equivalent pair has delay zero because it never obstructs any
horizon.

**Theorem 7.1 (least global horizon).**

\[
\boxed{H(M)=\min\{n:\operatorname{ClosesAt}(n)\}.}
\]

Closure at `H(M)` follows because any returned separator has length at most
the supremum and would contradict bounded equality at that depth.  Conversely,
the proof extracts a pair attaining the supremum.  When `n<H(M)`, global
shortestness shows that pair is equal under every word of length at most `n`,
while its retained word of length `H(M)` separates it.  The extracted data are

\[
(x,y,w),\qquad x\equiv_n y,\qquad |w|=H(M),
\qquad q(s_wx)\ne q(s_wy),
\]

not merely the number `H(M)`.  Lean checks the extraction as
`exists_pair_witness_of_lt_globalObservableHorizon` and leastness as
`globalObservableHorizon_isLeast`.  The three-state control evaluates
`H(M)=1` and checks the corresponding `IsLeast` certificate.

The next distinction is uniform versus adaptive formation.  `H(M)` is the
least depth at which the carrier containing all words through that depth
closes.  An adaptive decision tree may choose a different next action after
each response and can have a different cost geometry; no equality is claimed.

## 8. Adaptive and uniform depth separate

`Pairfield.AdaptiveObservableHorizon` defines a Boolean experiment tree with
leaves and action nodes.  An action node advances the state, reads the new
Boolean observation, and selects only the corresponding child.  The current
observation is prepended for free; tree depth counts actions.  A tree
identifies the system when its response trace is injective on states.

The four-state control has three initially unobserved states `0,1,2` and one
observed sink `3`.  Action `false` sends only state `1` to the sink; action
`true` sends only state `2`.  Every ordered pair has a separator of length at
most one, and Lean computes the R0048 uniform horizon as `H(M)=1`.

No adaptive tree of depth at most one identifies all states.  If its only
action is `false`, states `0` and `2` have the same trace; if it is `true`,
states `0` and `1` do.  A leaf already collides.  This is proved for every
tree by first showing both children of any depth-one query have depth zero and
therefore are leaves.

The depth-two tree first applies `false`; on its unresolved false branch it
then applies `true`.  Its four traces are injective.  Hence Lean checks

\[
\boxed{\text{least uniform horizon}=1<2=\text{least adaptive depth}.}
\]

Uniform response formation and adaptive sensing are therefore different
interfaces.  The former supplies all word responses in parallel; the latter
must commit to one action at each response history.

The first committed definition of the tree response recursion did **not**
elaborate: Lean could not see structural descent through an `if` selecting one
of two subtrees.  Messages 0533 and 0536 preserve that failed verification
claim.  The repaired definition pattern-matches on the returned Boolean, so
the recursive call is visibly on the selected child; the theorem above then
replays.

This original control is deliberately an ambient-state theorem.  Its start
row is fixed by both actions, so every prefix reaches row `0` and all Mathlib
prefix left quotients are equal.  It must not be advertised as a residual-
language gap.

`Pairfield.AdaptiveResidualAdapter` identifies the exact language carrier.
Using Mathlib's `Language.leftQuotient_append`, it proves that two prefix left
quotients are equal iff every finite Boolean response-conditioned experiment
tree gives equal traces from the reached states.  The reverse implication is
the checked fixed-word tree: execute an arbitrary suffix on identical false
and true branches and read its terminal response.

`Pairfield.ReachableAdaptiveObservableHorizon` supplies the positive scope
control.  It routes the start row to hidden row `1` on `false` and hidden row
`2` on `true`, retaining the two hidden-to-sink tests.  The four prefixes
`[]`, `[false]`, `[true]`, and `[false,false]` reach every row.  The checked
package `reachable_uniform_residual_one_adaptive_two` then states

\[
\boxed{H_{\rm native}=1,\qquad H_{\rm residual}=1,\qquad
       d_{\rm adaptive}=2.}
\]

Thus the strict cost gap survives after the native presentation is connected
to genuine Mathlib prefix residuals.

## 9. Adaptive depth is bounded below by the uniform horizon

The strict example has a general one-sided explanation.  Let `T` be any
Boolean response-conditioned experiment tree.  Lean proves

\[
x\equiv_{\operatorname{depth}(T)}y
\quad\Longrightarrow\quad
\operatorname{trace}_T(x)=\operatorname{trace}_T(y).
\]

The induction follows the realized branch.  At a query node, bounded equality
gives equal current and next observations, so both states select the same
child.  If a word has length at most that child's depth, prefixing it by the
root action has length at most

\[
1+\max(\operatorname{depth}(T_0),
       \operatorname{depth}(T_1)),
\]

which is exactly the root budget.  Thus bounded equality descends to the
selected child without weakening its remaining horizon.

If `T` identifies all states, trace injectivity turns the displayed equality
into `x=y`.  Hence the bounded kernel closes by the tree depth, and Theorem
7.1 gives the checked comparison

\[
\boxed{H(M)\le \operatorname{depth}(T).}
\]

The result also holds for every fuel admitting an identifying tree.  A
separate future-distinctness hypothesis is unnecessary: existence of an
injective trace already excludes two distinct future-equivalent states.  The
R0049 and reachable residual controls show the inequality can be strict.

## 10. A reachable family with unbounded strict gap

`Pairfield.LinearAdaptiveGap` makes the strictness symbolic.  For `n\ge2`,
take the state space

\[
X_n=\{\bot\}\sqcup \operatorname{Fin}(n),
\]

observe only `\bot`, and let probe `i` toggle `\bot` and hidden state `i`
while fixing every other hidden state.  The declared start is `\bot`; each
hidden state `i` is reached by the one-letter prefix `[i]`.  Thus every
ambient row is an honest prefix residual representative.

One probe separates any two hidden states, while the present observation
already separates `\bot` from them.  The exact native and Mathlib residual
horizons are therefore both one.  An adaptive policy is different.  Along its
all-false branch each action can name at most one hidden state.  Two unnamed
states have identical traces, so an identifying tree must name at least
`n-1` states on that branch and has depth at least `n-1`.

The lower bound is attained: probe every hidden state except one, continuing
only after false.  A true response identifies the named state, and all false
responses identify the omitted state.  Lean checks

\[
\boxed{H_{\rm native}=H_{\rm residual}=1,
       \qquad d_{\rm adaptive}=n-1.}
\]

Hence `d_adaptive-H_uniform=n-2` is unbounded on reachable presentations.
This does not claim the classical worst case: Lee--Yannakakis's ADS height
bound is quadratic and sharp.  The checked family is a native carrier/cost
control below that prior-art frontier.

## 11. Safe residual splits have an exact ambiguity balance

`Pairfield.AdaptiveResidualPartition` identifies the recursive invariant that
the examples above use implicitly.  A live cell contains prefixes having the
same observed history.  A query is safe on that cell when equality of the two
advanced Mathlib residuals cannot merge two distinct residuals that were live
before the query.  Lean proves that a tree separates residuals on a live cell
if and only if its root is safe and both response-selected children carry the
same certificate recursively.  This is an exact characterization, not yet a
constructor or a height bound.

`Pairfield.AdaptiveSplitPotential` quantifies one certified step.  Choose one
representative of each of the `m` live residuals, let `a` and `b` be the
numbers whose advanced observations are respectively false and true, and let
the advance map return the corresponding post-action residual.  Safety makes
that map injective inside each response fibre, hence `m=a+b` still holds after
forming the two branch images.  For the ordered ambiguity potential

\[
P(S)=|S|^2,
\]

Lean checks the exact balance

\[
\boxed{P(S)=P(S_0)+P(S_1)+2|S_0||S_1|.}
\]

Consequently the sum of the branch potentials is strictly smaller exactly
when both responses occur.  Equality holds exactly when one branch is empty.
This is the precise boundary between a safe query and an informative query:
safety prevents irreversible merging, but a constant-response safe action
consumes no ambiguity at all.  The two-candidate controls check both sides:
identity advance with constant false response gives equality, while identity
response gives a strict split.

The representative hypothesis is load-bearing.  Raw prefixes may present the
same left quotient, so prefix cardinality is not residual ambiguity.
`Pairfield.AdaptiveResidualPotentialAdapter` consumes Mathlib's exact
`Language.leftQuotient_append` law and proves that, on a reduced finite prefix
cell, formation's fibrewise `SafeAdvance` is equivalent to
`ResidualCell.SafeAction`.  Its theorem
`ResidualPotentialAdapter.residualSquarePotential_split` then transports the
recursive safety certificate to the finite balance law.  A one-state DFA with
the two distinct presenters `[]` and `[()]` is the checked negative control:
residual safety holds, but distinct representation fails.

## 12. Conditional construction is now a checked equivalence

`Pairfield.AdaptiveResidualConstructor` separates existence from execution.
`ResidualSplitPlan M S` is the indexed witness type generated by exactly two
constructors: a homogeneous live cell may stop; otherwise a declared safe
action must carry plans for both response-selected advanced cells.  It does
not presuppose a native experiment tree and, crucially, Lean does not assert
that the type is inhabited for every reduced automaton.

The compiler `ResidualSplitPlan.toTree` erases the proof fields to a native
`BoolExperimentTree` and preserves `ResidualSplitting`.  The decompiler
`ofTree` recovers a plan from any tree carrying that certificate, and
`toTree_ofTree` returns the original tree exactly.  Combining this with the
live-cell characterization proves

\[
\boxed{\operatorname{Nonempty}(\operatorname{ResidualSplitPlan}(M,S))
\iff \exists T,\;T\text{ separates the residuals on }S.}
\]

This is the conditional ADS constructor promised by the preceding section.
It leaves the real extremal obligation exposed.  The square potential strictly
decreases only at two-sided response splits; safe constant-response steering
has zero decrease and may still be structurally necessary.  Therefore the
potential alone does not yield the classical quadratic height bound.  A next
proof needs a rank that also controls those steering steps, or a normalization
theorem eliminating them.

## 13. Every cardinal-only rank is blind to constant-response steering

`Pairfield.AdaptiveResidualSteering` closes the scalar branch more generally
than the square-potential equality.  The prefix carrier is first packaged as
an actual state of Mathlib's canonical left-quotient automaton.  The checked
adapter square

```text
toDFA.step (branchState M pre) action
  = branchState M (pre ++ [action])
```

is proved from the exact library theorem `Language.step_toDFA`; iteration
gives the corresponding equality for every action word, and
`Language.mem_accept_toDFA` identifies its accepting bit with the native
reached-state bit.  Thus the following obstruction is about canonical
residual states, not a parallel prefix model.

If a safe action has constant response `answer` on a live cell `S`, its
`answer` fibre is all of `S`.  Safety makes advance injective on that fibre,
so Lean proves

\[
\boxed{|\operatorname{advance}(S)|=|S|.}
\]

Consequently, for every function `score : Nat -> Score`, the score of the
advanced branch equals the score of the original cell.  This kills the whole
class of live-cardinality ranks, not only `|S|^2`.  The control uses Boolean
negation with constant-false output: the action is safe and moves both
candidates, yet every cardinal-only score remains fixed.  Therefore the
failure is not an artifact of the identity action.

The theorem transports reciprocally to a finite set containing one presenter
per Mathlib residual: `ResidualCell.SafeAction` plus a constant native
post-response preserves every cardinal-only score.  Formation's concurrent
message `0575-codex-formation-constant-steering-claim.md` then closes the
remaining normalization horn.  Its reachable five-state DFA has two live
residuals that only `steer` advances injectively; `reach` and premature
`reveal` merge them.  The tree `steer; reveal` separates the pair, and Lean
proves every separating tree must begin with `steer`.  That mandatory root
returns false on the entire live cell and has exactly zero square-potential
decrease.  Thus safe constant-response steering cannot always be normalized
away.  A successful second rank must depend on residual position or transition
history, not just how many residuals remain.

## 14. Canonical live-cell position is an exact finite steering carrier

`Pairfield.AdaptiveResidualPositionRank` supplies the positional rank demanded
by the preceding obstruction, without claiming the missing normalization
theorem.  Mathlib's exact automata theorem
`Language.IsRegular.finite_range_leftQuotient` makes the state type of the
canonical left-quotient DFA finite.  If it has `n` states, the finite space of
live cells containing exactly `k` canonical residuals has cardinality

\[
\boxed{\binom{n}{k}.}
\]

The native adapter is checked on both relevant joints.  A prefix cell with one
presenter per residual maps to the canonical carrier without changing its
cardinality, and one native prefix advance is exactly pointwise application of
Mathlib's `Language.toDFA.step`; the commuting square uses
`Language.step_toDFA`.  Residual safety makes that advance injective on the
live cell, hence preserves `k` even when the response is constant.

Therefore every duplicate-free history of canonical `k`-residual cells has
length at most `Nat.choose n k`.  Both premises have active controls: repeating
a canonical cell makes `List.Nodup` false, while two native prefixes presenting
the same left quotient violate the reduced-representative hypothesis and
cannot be counted twice.

This is a finite carrier theorem, not yet the classical adaptive
distinguishing-sequence height theorem.  The unproved joint is whether a
minimal residual-separating plan can always be chosen with no repeated
canonical live cell.  Formation's message 0583 has registered exactly the
reciprocal cycle-deletion construction; R0057's mandatory `steer` is not a
cycle because it moves the live cell to a genuinely new canonical position.

## 15. Repeated canonical positions are deletable

`Pairfield.AdaptiveResidualCycleDeletion` closes the exact transport joint.
Raw prefix cells cannot literally repeat because every query lengthens their
presenters.  The correct position of a raw cell `S` is instead

\[
\operatorname{Pos}(S)=\{w^{-1}L : w\in S\},
\]

its set of Mathlib left quotients.  Lean proves the stronger monotonicity
statement: if `Pos(S) ⊆ Pos(T)`, then every fixed experiment tree separating
the residuals presented by `T` also separates those presented by `S`.
Therefore equality of positions transports residual separation in both
directions.

At the proof-relevant level, `transplantAtSamePosition` takes a recursively
certified subtree at a later live prefix cell and reconstructs it at an earlier
cell with the same canonical position.  Its compilation theorem is exact:

```text
(transplantAtSamePosition ... laterSubtree).toTree = laterSubtree
```

Thus no replacement experiment is invented.  A steering segment returning to
an earlier canonical live cell can be deleted and the later separating subtree
used immediately at the earlier occurrence.  The planted control uses R0057:
`reveal` separates after `steer` but not before it, so Lean proves that the
mandatory steering action changes the canonical position.  The theorem deletes
cycles, not necessary motion.

Together with the preceding finite carrier theorem, this discharges the
qualitative `Nodup` premise for a depth-minimal constant-cardinality steering
spine.  Turning that local deletion into the full classical quadratic ADS
height theorem still requires an explicit global minimal-plan/spine argument;
that final assembly is not claimed here.

## 16. The finite carrier and the cycle position are exactly one object

`Pairfield.AdaptiveResidualPositionCycleAdapter` closes the representation
seam between the two preceding sections.  Formation's `Position` is a set of
underlying left-quotient languages; R0058's `cellOfPrefixes` is a finite set of
subtype states in Mathlib's canonical DFA.  Lean proves exact membership and
equality equivalences:

```text
state ∈ cellOfPrefixes M cell
  ↔ state.val ∈ Position M (↑cell)

SamePosition M (↑left) (↑right)
  ↔ cellOfPrefixes M left = cellOfPrefixes M right.
```

Consequently equality in the finite carrier counted by `Nat.choose n k`
directly licenses the proof-relevant cycle transplant, and the transplanted
plan still compiles to exactly the later tree.  No extensional-language oracle
or informal identification remains between the rank and the deletion theorem.

Both boundary controls are checked.  Distinct raw singleton prefixes in the
one-state loop coalesce to the same canonical cell, as quotienting requires.
Conversely, R0057's mandatory `steer` changes the finite canonical cell, so it
cannot be deleted through this adapter.  The leading 0.84 forecast in message
0587 occurred.

## 17. Minimal spines are cycle-free, with an exact exponential bound

Two complementary minimality statements now globalize the local deletion
theorem.  `Pairfield.AdaptiveResidualMinimalSpine` carries a selected native
subtree together with its response-conditioned live cell.  A proper
descendant is strictly shallower, inherits both `ResidualSplitting` and current
output constancy, and therefore cannot return to the root position of a
depth-minimal splitting tree: R0059 would transplant the descendant subtree
to the root and contradict depth minimality.  A redundant R0057 steering tree
is the negative control; it separates but fails the minimality premise.  The
mandatory R0057 steer survives because it changes canonical position.

Depth minimality at the root alone does not justify minimality of an arbitrary
non-maximal sibling.  `Pairfield.AdaptiveResidualNodeMinimalSpine` makes that
quantifier explicit by using the native query-node count as a secondary
selection criterion.  A node-minimal certified plan exists whenever any plan
exists, every strict subplan is again node-minimal, and an equal-position
proper descendant would compile through R0059 to a strictly smaller plan.
Hence for every explicit root-to-leaf strict plan spine,

```text
(spine.map canonicalPosition).Nodup.
```

The set-valued positions are then repackaged without loss as subsets of
Mathlib's canonical left-quotient state type.  The state type is finite by the
exact theorem `Language.IsRegular.finite_range_leftQuotient`; the native
transition into it remains the checked `Language.step_toDFA` adapter from
Section 13.  If the regular language has `n` canonical residual states,
`Fintype.card_set` and the duplicate-free spine prove

\[
\boxed{|\text{spine}|\le 2^n.}
\]

`Pairfield.AdaptiveResidualNodeMinimalDepth` then constructs, by following a
maximal-depth child at each query, a proof-relevant spine with length exactly
native depth plus one.  The supplied-spine theorem therefore closes to the
actual native bound

\[
\boxed{\operatorname{depth}(T)+1\le 2^n}
\]

for every node-minimal certified plan `T`.  This is the first unconditional
finite depth bound after constant-response steering destroyed every
cardinality-only rank.  It is deliberately not advertised as the classical
sharp quadratic ADS height.  The remaining joint is a sharper checked
recurrence across informative splits.

## 18. The exact binomial carrier is still too large

R0058's fixed-cardinality bound is not merely an upper estimate on its local
premises.  `Pairfield.AdaptiveResidualBinomialBudgetNoGo` lists every
`k`-subset of a finite state carrier and proves that this history is `Nodup`,
every member has size `k`, and its length is exactly

\[
\binom{n}{k}.
\]

The first decisive control occurs already at six states:

\[
\binom{6}{3}=20>15=\frac{6(6-1)}2.
\]

At the registered lower boundary, the strict inequality correctly does not
fire: `choose 5 2 = 10 = 5*4/2`.  Thus even one abstract fixed-cardinality
layer allowed by `Nodup + size k` can exceed the entire classical quadratic
target.  Refining R0061's powerset count by R0058 and summing local budgets is
therefore a dead proof route.

This is a method-class countermodel, not a residual automaton trajectory.  It
forgets transition realizability and the global compatibility among live
cells.  That loss locates the missing object rather than refuting the ADS
theorem.  ~~The checked Lee--Yannakakis exposition supplies the same diagnosis
from the positive side.~~  The paper metadata and abstract confirm the
quadratic existence and sharpness result, but this lane has not independently
reconstructed the paper's detailed recurrence from the full primary text.
Formation's source audit reports that the construction first builds a global
splitting tree and coordinates largest blocks.  Native formation must still
check that partition-level certificate here; another scalar live-cell rank
cannot close the gap.

## 19. Internal positions remove `n+1` powerset states

`Pairfield.AdaptiveResidualNonhomogeneousSpine` separates the query spine from
its terminal leaf.  A node-minimal plan cannot query an already homogeneous
cell: replacing that query and both descendants by the certified `done` node
has strictly smaller native query count.  On the exact finite Mathlib residual
carrier, a position of cardinality at most one is homogeneous.  Hence every
internal position on a deepest node-minimal spine contains at least two
canonical residual states.

The adapter still uses the same exact Mathlib object and transition as
Sections 13 and 17.  `Language.IsRegular.finite_range_leftQuotient` supplies
the finite canonical state type, and the checked `Language.step_toDFA` square
identifies native prefix advance with its DFA step.  The proof enumerates the
omitted positions explicitly: the empty set and all `n` singleton sets.
Appending those `n+1` small positions to the duplicate-free internal history
and applying `Fintype.card_finset` gives

\[
  \operatorname{depth}(T)+(n+1)\le 2^n,
  \qquad
  \boxed{\operatorname{depth}(T)+1\le 2^n-n}.
\]

This is a strict refinement of R0061 and remains exponential.  Section 18
explains why deleting still more abstract subset states by local cardinality
cannot reach the quadratic theorem: the missing restriction is global
transition and response compatibility inside one splitting-tree
certificate.

## 20. Pair witnesses form one global residual partition

`Pairfield.AdaptiveResidualGlobalPartition` supplies the first checked global
carrier after the local binomial no-go.  For a finite suffix control language
`W`, two canonical Mathlib residual states occupy one block exactly when they
agree on membership of every word in `W`.  This equivalence is installed as a
Mathlib `Finpartition` of the whole canonical residual carrier.  Adding one
suffix refines that partition globally, not merely the live cell that happened
to request the suffix:

```text
experimentPartition (insert suffix W) ≤ experimentPartition W.
```

The order points from fine to coarse.  Thus the arbitrary fixed-cardinality
histories of Section 18 have been replaced by a single compatible family of
blocks.

The reciprocal witness theorem is exact.  Each unordered pair of distinct
canonical residual languages has some separating suffix by extensionality.
Choose one suffix for each such pair and deduplicate the resulting finite
language.  Mathlib's `Sym2.card_subtype_not_diag` and the exact finite carrier
from `Language.IsRegular.finite_range_leftQuotient` prove

\[
  |W|\le \binom n2.
\]

Agreement on all suffixes in `W` forces equality of canonical residual states,
so the induced global partition is discrete.  This is the precise positive
companion to R0063: witnesses do assemble into one globally compatible
partition certificate, and the same quadratic number counts a sufficient
nonadaptive witness vocabulary.

The boundary is equally precise.  The chosen witnesses are classical and not
an executable search, their lengths are uncharged, and a vocabulary cardinal
is not an adaptive root-to-leaf depth.  Formation's subsequent annotated-block
theorem sharpens that separation: every informative binary partition event
adds exactly one nonempty block, so a partition beginning with one block has
at most `n-1` informative events, not `choose n 2`.  Constant-response steering
letters remain inside the retained annotations and can still be mandatory.
Neither theorem bounds that annotation cost, so the classical ADS height
remains unproved in this repository.

## 21. Annotated words are global suffix tests only with a compatibility port

`Pairfield.AdaptiveResidualAnnotatedPartitionAdapter` connects R0068's native
annotated blocks back to R0066's canonical Mathlib partition.  The exact
automata joint is `Language.step_toDFA`: iterating it proves that running a word
from a canonical residual state produces the left quotient by that whole word.
Consequently the executable Moore response after an annotated word is true
exactly when that word belongs to the source residual language.

This yields the checked positive adapter.  If an annotated action has nonempty
false and true response children, its appended word separates any pair chosen
from opposite children.  If that pair still agreed on every previously
installed suffix test, inserting the appended word is a **strict** refinement
of the global `Finpartition`:

```text
opposite response children
+ agreement on the old global control language
=> experimentPartition (insert appendedWord tests)
     < experimentPartition tests.
```

The agreement premise is load-bearing.  Local informativeness alone does not
imply global strictness: once R0066's complete witness vocabulary has already
made the partition discrete, no further suffix can refine it strictly, even if
that suffix is informative on a separately retained annotated block.  The two
objects therefore cannot be identified event by event.  An annotated family
tracks branch-local provenance and word length; a suffix vocabulary applies
each test globally and may distinguish other blocks early or reuse a semantic
test.

This also absorbs the latest witness-formation boundary from the arithmetic
lane without conflating domains.  Existence or location of a critical witness
and construction cost are separate coordinates.  Here R0066's classical
`chosenSeparator` locates a sufficient finite vocabulary, while the visited
pair machinery is the native constructor for individual shortest separators.
The new adapter charges neither the construction of the whole vocabulary nor
the total length of branch annotations.  Those remain the exact live costs.

## 22. A supplied reduced chart constructs the complete witness language

`Pairfield.NativeCompleteWitnesses` removes R0066's classical choice at the
exact effective boundary exposed by the earlier Mathlib ingestion.  Supply a
finite linearly ordered DFA presentation, a complete finite alphabet list,
decidable acceptance, and a proof that future-equivalent presentation rows
are equal.  The module schedules exactly one orientation of every unordered
unequal row pair.  Mathlib's `Finset.card_product_filter_lt` proves that this
schedule has cardinality

\[
  \binom{|X|}{2}.
\]

For each scheduled pair, the existing visited-pair query returns its retained
replay word.  R0048's global shortestness theorem is preserved: the selected
word separates the pair and is no longer than any other separator for that
pair.  `Finset.image` then deduplicates repeated words.  The resulting native
finite control language has at most `choose |X| 2` words, separates every
unequal row pair, and agreement on the whole language forces literal row
equality.

Formation's reciprocal `Pairfield.NativeCompleteWitnessPartition` installs
that language as one simultaneous native observable.  Equality of terminal
Moore responses on every installed word defines a `Finpartition`; for
`completeWords`, membership in the block of `left` is equivalent to literal
equality with `left`.  The checked package therefore keeps the two exact
claims together: the installed native partition is discrete and its word
language has cardinality at most `choose |X| 2`.

This is the executable replacement for R0066's `chosenSeparator`, but only on
the stronger supplied chart.  Mathlib regularity alone still gives a finite
extensional range of left quotients, not the linear order, decidable row
presentation, complete alphabet enumeration, or behavioral-reduction proof
used here.  The exact `choose |X| 2` number counts scheduled pair queries; it
does not aggregate visited-pair state expansions, sum the globally shortest
word lengths, price duplicate discovery, or bound adaptive branch depth.
Formation's exact strict-refinement iff supplies the reciprocal semantic test:
one of these words changes the current global partition exactly while it
separates a pair that all previously installed words still identify.

## Replay

```sh
cd /Users/avikjain/Desktop/math2/formal/pairfield
lake build Pairfield.ObservableHorizon
lake build Pairfield.VisitedPairHorizon
lake build Pairfield.GlobalObservableHorizon
lake build Pairfield.AdaptiveObservableHorizon
lake build Pairfield.AdaptiveResidualAdapter
lake build Pairfield.ReachableAdaptiveObservableHorizon
lake build Pairfield.AdaptiveUniformBound
lake build Pairfield.LinearAdaptiveGap
lake build Pairfield.AdaptiveResidualPartition
lake build Pairfield.AdaptiveSplitPotential
lake build Pairfield.AdaptiveResidualPotentialAdapter
lake build Pairfield.AdaptiveResidualConstructor
lake build Pairfield.AdaptiveResidualSteering
lake build Pairfield.AdaptiveConstantResponseSteering
lake build Pairfield.AdaptiveResidualPositionRank
lake build Pairfield.AdaptiveResidualCycleDeletion
lake build Pairfield.AdaptiveResidualPositionCycleAdapter
lake build Pairfield.AdaptiveResidualMinimalSpine
lake build Pairfield.AdaptiveResidualNodeMinimalSpine
lake build Pairfield.AdaptiveResidualNodeMinimalDepth
lake build Pairfield.AdaptiveResidualNonhomogeneousSpine
lake build Pairfield.AdaptiveResidualBinomialBudgetNoGo
lake build Pairfield.AdaptiveResidualGlobalPartition
lake build Pairfield.AdaptiveResidualAnnotatedSplit
lake build Pairfield.AdaptiveResidualAnnotatedPartitionAdapter
lake build Pairfield.AdaptiveResidualStrictRefinementIff
lake build Pairfield.NativeCompleteWitnesses
lake build Pairfield.NativeCompleteWitnessPartition
lake build Pairfield

cd /Users/avikjain/Desktop/math2
agda -i formal/cubical formal/cubical/NaturalMachine/ObservableHorizon.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
```

All leaf builds exit zero, and the integrated root build checks 8,798 jobs,
including the constructor, cardinal no-go, necessary-steering control, and
canonical positional carrier, cycle deletion, their exact equality adapter,
both minimal-spine theorems, the binomial-budget no-go, and the global
partition/witness certificate.  Emitted warnings are pre-existing linter
warnings in imported modules.
