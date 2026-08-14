# Phase-predictor closure is independent of residual separation

**Status:** author-proved in safe Cubical Agda; independent audit unassigned.
No novelty is claimed.  Descent through a quotient, pullback of characters,
and the dual action of an endomorphism are standard.  The contribution here is
the exact missing executable condition at R0045's predicted-phase interface.

## 1. The operator assumption that remained open

R0045 (`ACTION_RESIDUAL_PHASE_BOUNDARY`) starts with

```text
q       : X -> A
step    : X -> X
predict : A -> A
chi     : A -> {+1,-1}
```

and proves the exact relative-phase identity

```text
chi(q(step x)) chi(predict(q x)) = chi(delta(x)).       (1)
```

For a reversible `step`, (1) is the basis action of

```text
U_step^dagger O_q U_step O_predict^dagger.
```

That theorem deliberately grants both diagonal factors.  If the implementation
retains only the current phase carrier

```text
current(x)   = chi(q(x)),
predicted(x) = chi(predict(q(x))),
```

then `O_predict` is carrier-relatively executable exactly when there is a map

```text
decode : {+1,-1} -> {+1,-1}
decode(current(x)) = predicted(x)                     (2)
```

on every realized state.  This is ordinary descent.  A same-current-phase,
different-predicted-phase pair refutes every such compiler.  The checked
generic object is `PhasePullback.PhasePredictorCompiler` in
`formal/cubical/NaturalMachine/PhasePredictorClosure.agda`.

Equation (2) is weaker than asking to reconstruct the response value and
stronger than merely asking whether `chi` separates the final residual.  The
two tests are independent.

## 2. Decisive two-sign no-go

Let the response group be

```text
A = {+1,-1} x {+1,-1}
```

with componentwise multiplication, and write a response as `(a,b)`.  Take

```text
q          = identity,
step       = identity,
predict    = swap,
chi(a,b)   = a.
```

The state action is already reversible.  The current and predicted phases are

```text
current(a,b)   = a,
predicted(a,b) = b.                                  (3)
```

Because signs are self-inverse, the response residual between the actual
identity action and the swap predictor is

```text
delta(a,b) = (a,b) (b,a)^(-1) = (ab,ab).             (4)
```

Its realized image is the diagonal `{(+,+),(-,-)}`.  The first character is
injective on that image: equality of the first residual sign forces equality
of both coordinates.  Therefore R0045's residual-kernel audit **passes**.

But (2) fails.  The two states

```text
(+,+) and (+,-)
```

have the same retained phase and different predicted phases.  Hence no
postprocessing of the first phase can synthesize the predicted factor.  The
relative residual phase `ab` is algebraically exact and separated on the
residual image, yet R0045's operator product cannot be compiled from the
declared one-character carrier alone.

This is the decisive no-go:

```text
character separates delta(X)
    does not imply
predicted character descends through current character.       (5)
```

`residual-separates-but-predictor-does-not-close` checks both sides of (5) in
one term.

## 3. Forced repair and positive control

Adjoin the pulled-back second character.  The joint carrier is `(a,b)`, and
its next predicted value is obtained by the exact update

```text
(a,b) -> (b,a).
```

The product universal property makes this the coarsest common refinement that
retains both the old and predicted phases.  The collision proves the repair is
strict; `joint-phase-predicts-swap` proves it closes.

Not every one-phase quotient fails.  The product character

```text
pi(a,b) = ab
```

is swap-invariant, so its predictor is the identity.  This is the positive
control: the obstruction is not compression itself, but failure of the
retained character family to close under predictor pullback.

For a finite character family, the standard dual formulation is that the
family's generated dual subgroup must contain its pullback by the predictor
(equivalently, the associated joint kernel must be predictor-stable).  That
general Pontryagin-dual statement is not formalized here; the checked theorem
uses descent directly and the two-sign instance supplies the exact boundary.

## 4. Changed next move

A proposed residual-phase implementation now has two independent audits:

1. **Residual sensitivity:** does the character family separate the realized
   residual image?
2. **Predictor closure:** do all predicted phase factors descend through the
   retained phase carrier?

If the first fails, the formed residual is dark.  If the second fails, the
desired phase exists as an algebraic function of the response but is not an
executable update of the declared phase state.  The organism must then do one
of three explicit things:

- retain the response value register;
- adjoin the missing pulled-back characters;
- grant and separately price `O_predict`.

R0045's square/successor Boolean route failed the first test.  The swap witness
here passes the first and fails the second.  Together they close the inference
that either audit can stand in for the other.

This also sharpens R0045's scope without retracting it.  Its operator identity
is correct under the stated executable-factor hypothesis.  What is refuted is
only an implicit promotion of that identity into a compiler from `O_q` alone.

## 5. Verification, falsifier, and prior art

Checked with Agda 2.8.0 and the installed Cubical library:

```sh
cd formal/cubical
agda -i . NaturalMachine/PhasePredictorClosure.agda
agda -i . NaturalMachine.agda
```

The standalone module is `--cubical --safe`, with no postulates or holes.  The
root aggregate also exits zero; it emits only inherited indexed-match
warnings.  The first aggregate attempt exposed a concurrently committed
duplicate local module name in `FixedCarryChart.agda`; that file's owner
renamed it before the successful replay.  No carry theorem was changed here.

The headline falsifier is the explicit collision `(+,+)/(+,-)`.  The positive
control is the swap-invariant product character, and the repair control is the
two-character swap update.  All are checked terms, not sampled cases.

Prior-art search followed the repository protocol under the standard terms
`finite abelian group character`, `annihilator`, `dual endomorphism`, and
`pullback`.  The protocol's local installed-library paths were absent on this
host; `notes/PRIOR_ART_INDEX.md` had no specific entry.  Public search returned
general Pontryagin-duality references, including the standard contravariant
duality of locally compact abelian groups.  No novelty is claimed for the
mathematics.  The exact organism-facing interface and counterexample are the
reason for retaining it.

## 6. Scope

Exact sign phases and a finite two-sign response.  The no-go concerns
**carrier-relative synthesis** of the predicted phase.  It does not say that
`O_predict` is impossible when the basis state, response value, or a separate
oracle is available; in this example a value-level swap forms it immediately.
No Hilbert-space gate count, approximation theorem, noisy distinguishability,
thermodynamic erasure, or quantum speedup is claimed.
