# Pratt Plate V2

Canonical working artifact is also stored in the ChatGPT Library at `/Research/Pratt/PRATT_PLATE_V2.md`.

This repository copy records the current mathematical spine and source anchors. Full revision follows the lossless-interaction theorem ledger.

## Kernel

\[
\pi:\sum_{T:\mathcal U}T\to\mathcal U
\]

\[
\operatorname{Lossless}(f):=\sum_{T:B\to\mathcal U}\sum_{\eta:A\simeq\sum_{b:B}T(b)}(\pi_1\circ\eta\sim f),
\qquad
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f))}.
\]

\[
\operatorname{Lossless}(f)\simeq\prod_{b:B}\sum_{X:\mathcal U}(X\simeq\operatorname{fib}_f(b)).
\]

Hence

\[
T(b)\simeq\operatorname{fib}_f(b),
\qquad
\operatorname{LawfulStep}(A)\simeq(A\to A).
\]

For Chu evaluation \(e:A\times X\to K\),

\[
\boxed{\operatorname{Lossless}(e)\simeq1},
\qquad
A\times X\simeq\sum_{k:K}\operatorname{fib}_e(k).
\]

## Classifier

\[
\boxed{\pi:\sum_{T:\mathcal U}T\to\mathcal U}
\]

classifies every dependent family; finite towers flatten to one family over the original base.

## Productive interaction

\[
\boxed{\mathsf{ISC}(w)=\prod_{q:Q(w)}\sum_{w':W}\sum_{o:O(w,q,w')}E(w,q,w',o)\times\mathsf{ISC}(w')}.
\]

\[
Q(w)\simeq1\Longrightarrow\mathsf{ISC}|_Q\simeq\operatorname{Orbit}.
\]

\[
\operatorname{Ans}_{m+n}(w)\simeq\sum_{a:\operatorname{Ans}_m(w)}\operatorname{Ans}_n(\operatorname{end}_m(w,a)).
\]

## Pratt coordinates

\[
\mathrm{String}\subset\mathrm{Pomset},
\qquad
\text{true }n\text{-concurrency}=n\text{-dimensional transition},
\qquad
\text{nondeterminism}=\text{monoidal homotopy}.
\]

\[
r:A\times X\to K,
\qquad
\text{precedence}=r\backslash r,
\qquad
\text{transition}=r/r.
\]

\[
(A,r,X)^\perp=(X,r^\top,A).
\]

Action Logic, Rational Mechanics, Gates Accept Concurrent Behavior, Types as Processes, the Stone gamut, transformational mathematics, dialectic lambda calculus, final-coalgebra continuum, and communes/Yoneda are treated as exact structural coordinates/restrictions, not analogies.

## Time / information

\[
x\equiv_{n+1}y\Rightarrow\sigma x\equiv_n\sigma y,
\qquad
x\equiv_{n+|w|}y\Rightarrow w(x)\equiv_nw(y).
\]

\[
\boxed{\text{depth}=\text{time},\qquad|w|=\text{causal radius}}.
\]

\[
\rho^4=1,
\qquad
Q:R\to\mathbb Z/4,
\qquad
Z_{\rm cell}=\langle\rho\rangle\simeq\mathbb Z/4.
\]

## Observation / residual / phase

\[
\delta(x)=q(\operatorname{step}x)-P(qx),
\]

\[
\chi(\delta x)=\chi(q(\operatorname{step}x))\chi(P(qx)),
\qquad
\chi(a)=\chi(b)\iff\chi(a-b)=1.
\]

The checked hostile case has injective \(\delta(x)=2x\) while every sign character sends the entire residual to the identity phase.

## Exact interaction geodesic

\[
\ell(\gamma)\ge n,
\qquad
\exists\gamma_n\;\ell(\gamma_n)=n,
\]

hence

\[
\boxed{d_{\rm interaction}(\text{cell }n,\text{head})=n}.
\]

## Metacircular closure / runtime

\[
\mathcal M\xrightarrow{\rm interact}\delta\xrightarrow{\rm install}\mathcal M'\xrightarrow{\rm interact}\cdots
\]

and the cubical operations

\[
I,\operatorname{Path},\operatorname{PathP},\operatorname{comp},\operatorname{coe},\operatorname{hcomp},\operatorname{Glue},\operatorname{ua}
\]

are carried into the Bend/HVM local interaction calculus with native sharing/superposition and parallel reduction.

\[
\boxed{\text{constructive mathematical interaction}\longleftrightarrow\text{runtime interaction}}.
\]

## Primary repository anchors

- `fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`
- `fibre/src/Fibre/Universal_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`
- `formal/cubical/theorems/residue/Uniqueness_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`
- `formal/cubical/theorems/residue/VerifyIsDecide_ThereIsNoGapBetweenFindingAndCheckingBecauseBothAreProjectionsOfOneEquivalence.agda`
- `formal/cubical/theorems/residue/ActionResidualPhase.agda`
- `research/PNP_GEODESIC_REDUCTION_20260916.md`
- `collab/bend2-cubical/CONVERGENCE.md`
