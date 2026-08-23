# Delta 19 gives the descent law the failure mode it did not have

**Author:** cf-tessera, absorbing the owner's Delta 19 (2026-08-13).
**Status:** one clause typed and checked (`formal/cubical/DynamicDescent.agda`,
`--safe`); the rest is a program with named targets.

## What it corrects

A visiting logician's verdict on `formal/cubical/DescentLaw.agda`, this
session: it proves `SetQuotients.rec` plus the contrapositive of its own
β-rule, and since **every equivalence relation in a topos is effective**,
"an observable either descends or splits" cannot fail. A law that cannot
fail cannot organize — and `notes/THE_LAW_FIRST.md` promotes it to an
acceptance gate.

Delta 19 §19.6 supplies the failure mode, and it is not a repair of the
statement but a correction of its **level**. Our law quotients by an
*instantaneous* observation. For a dynamics that is wrong:

    N_obs = ⋂_{n≥0} ker (P ∘ Tⁿ)

is the only safe quotient. `ker P` discards distinctions that later
become visible; `N_obs` discards exactly those invisible **forever**.
Everything between the two returns — as memory. C19.13 states it
flatly: *the maximal dynamically safe quotient is U/N_obs, not U/ker P.*

## The clause now checked

At the smallest size where the gap exists — one observed coordinate, one
hidden — with `T = (a b / c d)`:

    markovSquare a - trueTwoStep a b c  ≡  - (excursion b c)
    excursion b c = b · c

An identity, not an approximation: the naive one-step summary differs
from the true two-step dynamics by exactly the excursion out of the
observed sector and back. Hence C19.10, checked:

- `closureIff` — an exact one-step summary forces `b·c = 0`;
- `excursionObstruction` — at `b = c = 1` the defect is `1`, so **no**
  one-step operator on the observed sector reproduces two-step
  behaviour (T19.20's smallest instance);
- `pureLeakageIsFree` — leakage without return costs nothing.

That last pair is the content: *an eliminated distinction matters only
if there is both a channel into it and a channel back.* This is the
first statement in this repository where descent genuinely **fails**,
with a witness.

## What this repository should stop saying

`THE_LAW_FIRST.md` concedes its own fourth corner ("an observable never
offered neither descends nor forms") and then moralizes it — "the third
class is pollution." Delta 19 shows the fourth corner is not pollution
but *the memory kernel*: the observable that is invisible now and
returns later. A norm was inserted where a corner opened.

## Named targets, not claims

Delta 19 §19.25 lists five, and its own discipline is the right one
(S19.14, S19.31: **do not reinvent minimal realization theory or
Mori–Zwanzig**). Ranked by what this repo can actually do next:

1. **Half-line self-energy** `Σ₊(λ) = P T Q (λ − QTQ)⁻¹ Q T P` for the
   bilateral pair operator already in the library, and identify its
   coefficients with the exact Hankel term (§19.12, Program 19.23).
   This is Wiener–Hopf/Toeplitz compression in resolvent language and
   the library already has the operator.
2. **Charge first-return kernels** `F_m` on a finite truncation
   (§19.9, 19.25A) — computable now, and the honest place to test
   C19.17's comparison with the Buchstab residual *before* claiming it.
3. **The Hecke-tree Schur complement** (Program 19.25C): is the directed
   Buchstab transfer operator a Schur complement after eliminating the
   backtracking sector? A negative answer is as valuable — it would
   locate the exact nonlinearity that blocks linear embedding.

## The correction this makes to our own machine

`machine/MathMachine.hs` quotients its term space by observational
equality at 40 sampled environments — an instantaneous P. Delta 19 says
the safe quotient is by what is invisible under **all future contexts**,
which for a rewriting system means all contexts and substitutions. The
machine's `congruent` filter is a first approximation to exactly this,
and the gap is why thirteen of its thirty-five theorems were one law
wearing hats. Same defect, same shape, one level down.
