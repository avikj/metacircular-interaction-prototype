# Predictor formation by finite-window obstruction

**Status.** Author-proved and checked in Cubical Agda (`--safe`, no holes or
postulates).  Finite observation-window refinement and Moore/Nerode
equivalence are standard; no novelty is claimed.  The local contribution is
the exact junction between the R0044 action residual, predictor existence,
collision obstruction, minimal repair, and an executable arithmetic clock in
which the repair changes the next available operation.

Checked source:
[`formal/cubical/NaturalMachine/PredictorFormation.agda`](../formal/cubical/NaturalMachine/PredictorFormation.agda).

## 1. The question left by the residual compiler

Let

\[
q:X\to O,\qquad s:X\to X
\]

be the current observation and one already installed state action.  R0044
forms, relative to a declared predictor, a residual coordinate reversibly
equivalent to the one-step behavior carrier

\[
W_1(x)=(q(x),q(sx)).
\]

The remaining question is not how to choose another residual origin.  It is
whether the formed carrier itself carries an exact action update:

\[
P(W_1(x))=W_1(sx)\quad\text{for every }x.
\]

Write

\[
q_2(x)=q(s^2x).
\]

Since the first coordinate of `W_1(sx)` is already the second coordinate of
`W_1(x)`, only `q_2` remains unknown.

## 2. Exact theorem: predictor if and only if third-reading descent

In the repository's descent language, `f` descends through `r` when there is a
decoder `d` with `d(r(x))=f(x)` on every realized reading.

**Theorem 2.1 (finite-window predictor criterion).** The following data
determine each other:

1. a predictor `P : O×O -> O×O` satisfying
   \(P(W_1(x))=W_1(sx)\);
2. a decoder `d : O×O -> O` satisfying \(d(W_1(x))=q_2(x)\).

The checked conversions are

\[
d\longmapsto P(y_0,y_1)=(y_1,d(y_0,y_1))
\]

and

\[
P\longmapsto d=\operatorname{pr}_2\circ P.
\]

No choice, finiteness, surjectivity, or extension theorem is used.  Both maps
need agree only on the realized image of `W_1`.

**Corollary 2.2 (collision no-go).** If there are states `x,x'` with

\[
W_1(x)=W_1(x'),\qquad q_2(x)\ne q_2(x'),
\]

then no predictor on the two-reading carrier exists.

This is the same exact tear returned by
`InstalledRootedQuotient.agda`: a same-fiber pair separated by the proposed
update refutes descent.  Here the target is specifically the next window, so
the tear identifies its missing coordinate rather than merely reopening to an
unspecified larger state.

**Theorem 2.3 (all finite horizons).** For every `n≥0`, let

\[
W_n(x)=(q(x),q(sx),\ldots,q(s^n x)).
\]

An exact update `P_n(W_n(x))=W_n(sx)` exists if and only if the one unread
response `q(s^(n+1)x)` descends through `W_n`.  The checked proof defines a
structural shift on the left-associated window code, uses the descent decoder
to append its final coordinate, and recovers the converse by projecting the
last coordinate of every predicted window.

Consequently, a same-`W_n`, different-next-reading collision refutes closure
at horizon `n` and forces the strict minimal refinement `W_(n+1)`.

**Theorem 2.4 (persistence).** If `W_n` predicts itself, then `W_(n+1)`
predicts itself.  The old predictor is applied once to obtain the shifted
prefix and twice to obtain the new final reading.  Thus the set of closing
horizons is upward closed: the first one, when it exists, is an actual
stabilization frontier rather than an accidental equality.

Finally, a supplied decoder `W_n(x) -> x` compiles closure directly as
`W_n ∘ s ∘ decode`.  The supplied decoder is essential executable data;
abstract injectivity alone is not silently converted into a program.

## 3. The minimal repair

Adjoin the obstructing reading:

\[
W_2(x)=(W_1(x),q_2(x))=(q(x),q(sx),q(s^2x)).
\]

The product universal property checked in `ActionRefinement.agda` gives:

- `W_2` retains `W_1` and makes `q_2` descend;
- every carrier determining both `W_1` and `q_2` determines `W_2`;
- a witnessed collision makes the refinement strict.

Thus the unread response is simultaneously obstruction and minimal repair.
Universally, `W_2` already predicts the advanced two-window:

\[
(q(x),q(sx),q(s^2x))\longmapsto(q(sx),q(s^2x)).
\]

It need not predict all of itself: that may require `q(s^3x)`.  This is the
finite-stabilization boundary, retained rather than hidden.

## 4. Closure survives lossless coordinate change

Suppose carriers `a:X->A` and `b:X->B` determine each other on their realized
images.  If `N_A` predicts `a(sx)` from `a(x)`, then

\[
N_B=\operatorname{read}_B\circ N_A\circ\operatorname{read}_A
\]

predicts `b(sx)` from `b(x)`.  `closure-under-mutual-refinement` checks the
three replay paths explicitly.

Therefore the predictor criterion is not an artifact of replacing R0044's
residual by behavior coordinates: their checked mutual refinement transports
closure and no-go knowledge both ways.

This statement is deliberately **not** true for lossy postcomposition.  The
new residual-phase return (`ActionResidualPhase.agda`, message 0510) proves
that a sign character can annihilate the classically injective residual `2x`.
A character quotient may therefore destroy exactly the distinctions needed by
a predictor.  Before transporting this formation event into phase, one must
audit the realized residual image against the character kernel.

## 5. Executable arithmetic event: successor modulo four

Take the cyclic group chart \(X=\mathbb Z/4\mathbb Z\), let

\[
s(x)=x+1\pmod 4,
\qquad
q(x)=\begin{cases}1,&x=0,\\0,&x\ne0.\end{cases}
\]

The exact readings are:

| state `x` | `q(x)` | `q(sx)` | `q(s²x)` |
|---:|---:|---:|---:|
| 0 | 1 | 0 | 0 |
| 1 | 0 | 0 | 0 |
| 2 | 0 | 0 | 1 |
| 3 | 0 | 1 | 0 |

States 1 and 2 have the same two-reading word `(0,0)` but different third
readings.  Corollary 2.2 refutes every map

\[
P:\{0,1\}^2\to\{0,1\}^2
\]

purporting to update the current carrier.

All four three-reading words are distinct.  The checked decoder is

\[
100\mapsto0,\quad000\mapsto1,\quad001\mapsto2,\quad010\mapsto3,
\]

with harmless defaults on the other four ambient bit strings.  Agda checks
`decode(W_2(x))=x` separately for all four states.  It then compiles the exact
predictor

\[
P_2=W_2\circ s\circ\operatorname{decode}.
\]

This is an executable formation event in the requested sense.  Relative to
the already formed two-reading carrier, one further action/observation forms
the third bit.  Before it, the next update is impossible; after it, the state
and every later window update are executable from the carrier alone.

## 6. Proof replay

From `formal/cubical/`:

```sh
agda -i . NaturalMachine/PredictorFormation.agda
agda -i . NaturalMachine.agda
```

Both commands exit zero.  The root replay emits only inherited Cubical Agda
warnings about indexed matches in older modules.

## 7. Scope and changed frontier

The result now proves the universal criterion and forced minimal refinement at
every finite horizon, upward persistence after the first closure, one exact
no-go, and one finite stabilization event.  It does not prove that an
arbitrary infinite-state action reaches a closing horizon.
`FutureBehavior.agda` already supplies the complete all-word quotient;
invoking it immediately would erase the operational question of whether a
finite newly formed language ever becomes closed.

The remaining exact problem is therefore constructive rather than structural:

> Given an explicit finite action/observation presentation, compute the least
> closing horizon and return a same-window/different-next-reading collision at
> every earlier horizon.  State precisely which enumeration and decidable
> equality data make this executable; do not infer a program from abstract
> finite existence.

The new automata returns sharpen the last clause.  A finite reachable reduced
chart can make the least distinguishing horizon executable; abstract
regularity or an extensional future quotient alone does not provide that
finite presentation.
