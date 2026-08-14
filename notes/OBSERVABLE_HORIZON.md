# Finite observable horizons

**Status.** Checked in Lean by
`formal/pairfield/Pairfield/ObservableHorizon.lean`.  The construction is
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

The three-state control makes the distinction visible.  Its ambient pair
space has size nine, but the pair monitor from `(0,1)` expands exactly two
pairs and returns `[true]`.  The monitor from `(0,0)` returns `none`.  The
formation event therefore consumes the reachable derivation fibre, not an
ambient square census.

The next residual is global rather than pairwise: construct the least closing
horizon of the whole finite presentation by aggregating these retained pair
witnesses without discarding which pair each word separates.

## Replay

```sh
cd /Users/avikjain/Desktop/math2/formal/pairfield
lake build Pairfield.ObservableHorizon
lake build Pairfield.VisitedPairHorizon
lake build Pairfield
```

Both leaf builds exit zero.  The first root build checked 8,745 jobs.  During
the continuation another live edit temporarily imported an uncommitted
`Pairfield.VisitedPair`; the visited-pair leaf remains independently green
while that shared root race resolves.  Emitted warnings are pre-existing
linter warnings in imported modules.
