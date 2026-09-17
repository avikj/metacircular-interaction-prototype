# Lossless Interdependent Interaction

**The complete construction.** Every other page in this exposition is a coordinate, restriction, projection, truncation, carrier, historical presentation, theorem extraction, or executable realization of the object developed here.

\[
\boxed{\pi:\sum_{T:\mathcal U}T\to\mathcal U}
\qquad
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f))}
\qquad
\boxed{\mathsf{ISC}(w)=\prod_{q:Q(w)}\sum_{w':W}\sum_{o:O(w,q,w')}E(w,q,w',o)\times\mathsf{ISC}(w')}
\]

A dependent universe classifies the mathematical structure. Every visible map has one complete conservative presentation, forced to retain its homotopy fibres. Cubical composition gives the retained identities constructive higher geometry. Univalence turns equivalence into executable identity and transport. Coinduction retains continuation. Interaction results can re-enter as subsequent transformations. Locality induces causal geometry and exact interaction cost. Noncommuting interaction retains order as braid; symmetry and characters expose phase and conserved global information. The same local calculus is realized by interaction-net reduction.

The sections below are not ingredients assembled into a theory. They are views of one object.

---

## Universal family

Let \(\mathcal U\) be a [univalent universe](https://ncatlab.org/nlab/show/univalent+universe). Its universal family is

\[
\boxed{\pi:\sum_{T:\mathcal U}T\to\mathcal U,\qquad\pi(T,t)=T.}
\]

Every family \(P:A\to\mathcal U\) is the pullback of \(\pi\) along its own classifying map:

\[
\begin{array}{ccc}
\sum_{a:A}P(a)&\longrightarrow&\sum_{T:\mathcal U}T\\
\downarrow&&\downarrow\pi\\
A&\xrightarrow{P}&\mathcal U.
\end{array}
\]

At equal universe level,

\[
\boxed{\left(\sum_{E:\mathcal U}(E\to A)\right)\simeq(A\to\mathcal U).}
\]

Finite dependent towers flatten to one family over the original base. Repeated dependence therefore remains one classified object rather than a stack of foreign semantic layers.

A [Chu evaluation](pages/03-chu-spaces-completed.md), proof family, observation family, transition family, bundle, continuation, transformation space, and runtime type may all be presented inside this same classifier.

**Checked:** [`Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`](../fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda).

---

## Forced lossless completion

For every map

\[
f:A\to B,
\]

define

\[
\operatorname{fib}_f(b):=\sum_{a:A}(f(a)=b).
\]

Then canonically, over \(B\),

\[
\boxed{A\simeq\sum_{b:B}\operatorname{fib}_f(b)}
\]

by

\[
a\mapsto(f(a),(a,\operatorname{refl})).
\]

The stronger theorem removes any apparent design choice. Define

\[
\operatorname{Lossless}(f):=
\sum_{T:B\to\mathcal U}
\sum_{e:A\simeq\sum_{b:B}T(b)}
(\pi_1\circ e\sim f).
\]

Then

\[
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f)).}
\]

Every conservative factorization over the same visible map forces

\[
\boxed{T(b)\simeq\operatorname{fib}_f(b).}
\]

The residual is therefore not metadata, history chosen to be logged, or an auxiliary inverse. It is the dependent source distinction forced by the visible map itself. At machine level:

\[
\boxed{\operatorname{LawfulStep}(A)\simeq(A\to A).}
\]

The lawful lossless machine is the map with the completion uniquely forced by that map.

→ [The Fibre Law — Losslessness Is Forced](pages/02-fibre-law.md)

**Checked:** [`Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`](../fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda), [`Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`](../formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda).

---

## Observation, quotient, descent

An observation

\[
q:X\to Y
\]

induces indistinguishability

\[
x\sim_qx'\iff q(x)=q(x').
\]

Its fibre is precisely the dependent family of sources identified at a visible result. Thus

\[
\boxed{\text{visible coordinate}=q(x),\qquad\text{forced retained coordinate}=\operatorname{fib}_q(qx).}
\]

For \(h:X\to Z\), under the relevant set-level hypotheses,

\[
\boxed{h=\bar h\circ q\iff q(x)=q(x')\Rightarrow h(x)=h(x').}
\]

An observation is sufficient exactly when the desired result respects the identifications it makes. Measurement, abstraction, quotient semantics, finite logical observation, and information loss are all instances of this one relation between a map and its fibres.

This is why the classical value of an interaction can be a faithful answer for one question while being radically incomplete as a presentation of the interaction itself.

---

## Composition

For

\[
A\xrightarrow fB\xrightarrow gC,
\]

\[
\boxed{\operatorname{fib}_{g\circ f}(c)\simeq\sum_{(b,p):\operatorname{fib}_g(c)}\operatorname{fib}_f(b).}
\]

The residual of a composite is a dependent composite: the retained first-stage structure is indexed by the actual intermediate point retained by the second stage. The same law appears as compositional provenance, finite interaction decomposition, endpoint-conditioned histories, and residual calculus.

---

## Cubical interaction

The complete residual is not truncated. Whenever its identity types contain higher structure, that structure remains present:

\[
p:f(a)=b,\qquad q:p=p',\qquad r:q=q',\qquad\ldots
\]

[Cubical type theory](https://ncatlab.org/nlab/show/cubical+type+theory) gives identity constructive cell structure:

\[
I,\quad\operatorname{Path},\quad\operatorname{PathP},\quad\operatorname{comp},\quad\operatorname{fill},\quad\operatorname{hcomp},\quad\operatorname{coe}.
\]

Compatible partial boundaries compose and fill; dependent objects transport along paths. Execution dimensions and identity/coherence dimensions can therefore inhabit one constructive higher-dimensional language, with any claimed identification between them itself expressed mathematically.

This is the point at which Pratt's higher-dimensional concurrency program meets the constructive object directly: true concurrent dimension need not be simulated by a one-dimensional interleaving history.

→ [Concurrency Is Geometry](pages/04-concurrency-is-geometry.md)

---

## Univalence: equivalence executes

\[
\boxed{(A\simeq B)\simeq(A=_{\mathcal U}B).}
\]

For \(e:A\simeq B\),

\[
\operatorname{ua}(e):A=_{\mathcal U}B,
\qquad
\operatorname{coe}_{\operatorname{ua}(e)}=e.
\]

Equivalence is not merely a theorem relating two presentations. It is a path along which every dependent construction can transport.

For dynamics \(\Phi:A\to A\), equivalence \(e:A\simeq A'\), and conjugate dynamics \(\Phi'=e\Phi e^{-1}\),

\[
\boxed{\operatorname{map}(e,\operatorname{unfold}(\Phi,a))=\operatorname{unfold}(\Phi',ea).}
\]

The whole continuation commutes with the equivalence. Representation change, symmetry reduction, theorem transport, process equivalence, and executable transformation therefore meet in one operation.

→ [Types Are Processes — Transformations Are Executable](pages/07-types-processes-transformations.md)

**Checked:** [`Nucleus.agda`](../fibre/src/Fibre/Nucleus.agda).

---

## Productive dependent interaction

The central productive object is

\[
\boxed{
\mathsf{ISC}(w)=
\prod_{q:Q(w)}
\sum_{w':W}
\sum_{o:O(w,q,w')}
E(w,q,w',o)\times\mathsf{ISC}(w').
}
\]

One interaction returns

\[
\operatorname{react}(w,q)=(w',o,e,\kappa),
\]

where successor, observation, proof-relevant event/residual, and continuation are one dependent result. The continuation is again an interaction object.

Deterministic autonomous evolution is the one-query restriction:

\[
Q(w)\simeq1\Longrightarrow\mathsf{ISC}|_Q\simeq\operatorname{Orbit}.
\]

Finite interaction composes exactly:

\[
\boxed{\operatorname{Ans}_{m+n}(w)\simeq\sum_{a:\operatorname{Ans}_m(w)}\operatorname{Ans}_n(\operatorname{end}_m(w,a)).}
\]

A long interaction is its realized prefix plus the continuation at the actual reached world. No external scheduler state is needed to explain the future; continuation is inside the result.

→ [The Interactive Symbolic Computer](pages/10-interactive-symbolic-computer.md)

**Checked:** [`Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda`](../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda).

---

## Coinduction and completion

Let \(x\equiv_ny\) mean agreement through observational depth \(n\). Compatible finite approximants determine a unique corecursive limit:

\[
x_0\equiv_0x_1,\ x_1\equiv_1x_2,\ldots
\Longrightarrow
\exists!x_\infty\;\forall n,\ x_\infty\equiv_nx_n.
\]

The productive carrier therefore carries an intrinsic completion principle. Finite observation and infinite behavior are joined by the same prefix structure rather than separated into finite computation plus an external ideal limit.

This meets Pratt–Pavlović's final-coalgebraic continuum at exactly the constructive point: productive definition, observational topology, and continuity modulus can be internal to one carrier.

→ [Coinduction, Continuum, and Causal Completion](pages/08-coinduction-continuum-causal-completion.md)

---

## Metacircular closure

The output of interaction inhabits the same mathematical universe as subsequent inputs. A derived transformation can therefore be installed as a future transformation:

\[
\mathcal M\xrightarrow{\mathrm{interact}}\delta\xrightarrow{\mathrm{install}}\mathcal M'\xrightarrow{\mathrm{interact}}\cdots
\]

\[
\boxed{\text{derived transformation}=\text{available future transformation}.}
\]

Proof, program, datum, type, path, transformation, execution, and provenance are not required to be disjoint runtime species. They are roles played by mathematical objects in the same continuing universe. A checked derivation can establish a transformation; the transformation can execute; its execution returns another retained interaction; that interaction can alter subsequent interaction.

`IntrinsicRewrite`, self-presentation/contextual installation, `ProductiveIndraNet`, and the lifecycle construction are the checked/source-level loci of this closure.

→ [The Interactive Symbolic Computer](pages/10-interactive-symbolic-computer.md)

---

## Chu is a visible interaction shadow

A [Chu space](https://ncatlab.org/nlab/show/Chu+space) begins with

\[
(A,X,e),\qquad e:A\times X\to K.
\]

Apply forced completion to its defining evaluation:

\[
\boxed{A\times X\simeq\sum_{k:K}\operatorname{fib}_e(k).}
\]

The Chu matrix retains the visible coordinate \(k\). The complete conservative interaction retains the uniquely forced fibre above \(k\). A universe-valued interaction

\[
R:A\times X\to\mathcal U
\]

removes the fixed scalar codomain while preserving the two-pole interaction geometry. Chu duality, transforms, residuation, state/event duality, time/information, Chu over \(2,3,4\), universal mathematics, and transformational mathematics become local coordinates through which the complete object can be read.

The important relation is not “our theory resembles Chu.” Chu evaluation is a restricted visible presentation of the more complete dependent interaction; illuminating that restriction imports the surrounding structure back into Chu coordinates.

→ [Chu Spaces Completed](pages/03-chu-spaces-completed.md)  
→ [From Chu Space to the Universal Lossless Interaction Object](CHU_LOSSLESS_INTERACTION.md)

---

## Action and logic are restrictions of interaction

Pratt's propositional dynamic semantics uses

\[
R_\alpha:S\times S\to\operatorname{Prop}.
\]

Retain proof relevance:

\[
R_\alpha(s,t):\mathcal U.
\]

Then

\[
R_{\alpha;\beta}(s,u)=\sum_{t:S}R_\alpha(s,t)\times R_\beta(t,u),
\]

\[
[\alpha]P(s)=\prod_t(R_\alpha(s,t)\to P(t)),
\qquad
\langle\alpha\rangle P(s)=\sum_tR_\alpha(s,t)\times P(t).
\]

The classical propositional relation is a truncation/restriction of the proof-relevant action object. Fischer–Ladner/Hintikka observation is one finite decision-sufficient coordinate, governed by the same descent theorem as every other observation. Pratt's tableau fixed point is a finite shadow of productive realizability; his near-optimal reasoning about action is a classical instance of the more general question of geodesic inference in an interaction metric.

→ [Action, Logic, and Optimal Inference](pages/05-action-logic-optimal-inference.md)

---

## Concurrency is retained dimension

A string fixes total order. A [pomset](https://en.wikipedia.org/wiki/Pomset) relaxes that order. Pratt's schedule/automaton duality and solid automata identify true \(n\)-fold concurrency with \(n\)-dimensional transition; monoidal homotopy makes nondeterministic process geometry explicit.

The complete interaction retains order exactly where order is information. Commuting independent order can collapse; noncommuting order cannot. Hence braid relations arise