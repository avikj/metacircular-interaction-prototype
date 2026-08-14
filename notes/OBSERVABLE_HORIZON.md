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
Thus the exact positive result is a machine equivalence on realized response
classes.  The negative boundary from the preceding paragraph remains: no map
from the whole ambient response-function type to itself has been constructed.

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
\boxed{\text{least uniform horizon}=1<2=	ext{least adaptive depth}.}
\]

Uniform response formation and adaptive sensing are therefore different
interfaces.  The former supplies all word responses in parallel; the latter
must commit to one action at each response history.

## Replay

```sh
cd /Users/avikjain/Desktop/math2/formal/pairfield
lake build Pairfield.ObservableHorizon
lake build Pairfield.VisitedPairHorizon
lake build Pairfield.GlobalObservableHorizon
lake build Pairfield.AdaptiveObservableHorizon
lake build Pairfield

cd /Users/avikjain/Desktop/math2
agda -i formal/cubical formal/cubical/NaturalMachine/ObservableHorizon.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
```

All leaf builds exit zero, and the integrated root build checks 8,754 jobs.
Emitted warnings are pre-existing linter warnings in imported modules.
