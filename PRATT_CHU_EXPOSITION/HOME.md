# Lossless Interdependent Interaction

**The complete construction.** Every other page here is a coordinate, restriction, projection, truncation, carrier, historical presentation, theorem extraction, or executable realization of this object.

\[
\boxed{\pi:\sum_{T:\mathcal U}T\to\mathcal U}
\qquad
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f))}
\qquad
\boxed{\mathsf{ISC}(w)=\prod_{q:Q(w)}\sum_{w',o}E(w,q,w',o)\times\mathsf{ISC}(w')}
\]

A dependent universe classifies the structure. Every visible map has one complete conservative presentation, forced to retain its fibres. Cubical composition gives retained identity constructive higher geometry. Univalence makes equivalence executable. Coinduction retains continuation. Derived transformations re-enter interaction. Locality induces causal geometry and exact interaction cost. Noncommuting interaction retains order as braid; symmetry and characters expose phase and conserved global information. The same interaction has an interaction-net runtime.

These are not ingredients assembled into a theory. They are views of one object.

---

## Universal family

\[
\boxed{\pi:\sum_{T:\mathcal U}T\to\mathcal U}
\]

classifies dependent families. For \(P:A\to\mathcal U\), its total space is the pullback of \(\pi\) along \(P\), and

\[
\boxed{\left(\sum_{E:\mathcal U}(E\to A)\right)\simeq(A\to\mathcal U).}
\]

Finite dependent towers flatten to one family over the original base. Chu evaluations, observations, proofs, transitions, continuations, transformations and runtime types can therefore inhabit one classified universe.

**Checked:** [`Visvarupa`](../fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda).

## Forced lossless completion

For \(f:A\to B\),

\[
\operatorname{fib}_f(b):=\sum_{a:A}(f(a)=b),
\qquad
\boxed{A\simeq\sum_{b:B}\operatorname{fib}_f(b)}.
\]

Define

\[
\operatorname{Lossless}(f):=
\sum_{T:B\to\mathcal U}\sum_{e:A\simeq\sum_bT(b)}(\pi_1e\sim f).
\]

Then

\[
\boxed{\operatorname{isContr}(\operatorname{Lossless}(f))},
\qquad
\boxed{T(b)\simeq\operatorname{fib}_f(b)},
\qquad
\boxed{\operatorname{LawfulStep}(A)\simeq(A\to A).}
\]

The residual is not selected metadata: it is the dependent source distinction forced by the visible map.

→ [The Fibre Law](pages/02-fibre-law.md)  
**Checked:** [`Trace`](../fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda), [`Ekatva`](../formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda).

## Observation and descent

For \(q:X\to Y\),

\[
x\sim_qx'\iff qx=qx',
\qquad
\boxed{\text{visible}=qx,\quad\text{retained}=\operatorname{fib}_q(qx).}
\]

For set-valued target \(h\), under the stated hypotheses,

\[
\boxed{h=\bar h\circ q\iff qx=qx'\Rightarrow hx=hx'.}
\]

Observation, quotient, measurement, abstraction and sufficient representation are instances of the same law.

## Composition

\[
\boxed{\operatorname{fib}_{g\circ f}(c)\simeq\sum_{(b,p):\operatorname{fib}_g(c)}\operatorname{fib}_f(b).}
\]

Residuals compose dependently through the actual intermediate point. The same identity becomes compositional provenance, prefix/suffix decomposition and endpoint-conditioned interaction.

## Cubical identity and univalence

Retained equality is not truncated. [Cubical type theory](https://ncatlab.org/nlab/show/cubical+type+theory) gives it computational cells:

\[
I,\ \operatorname{Path},\ \operatorname{PathP},\ \operatorname{comp},\ \operatorname{fill},\ \operatorname{hcomp},\ \operatorname{coe}.
\]

Univalence gives

\[
\boxed{(A\simeq B)\simeq(A=_{\mathcal U}B)},
\qquad
\operatorname{coe}_{\operatorname{ua}(e)}=e.
\]

For \(\Phi'=e\Phi e^{-1}\),

\[
\boxed{\operatorname{map}(e,\operatorname{unfold}(\Phi,a))=\operatorname{unfold}(\Phi',ea).}
\]

The whole future transports. Equivalence, representation change, symmetry reduction and executable transformation are one path structure.

→ [Types Are Processes — Transformations Are Executable](pages/07-types-processes-transformations.md)  
**Checked:** [`Nucleus`](../fibre/src/Fibre/Nucleus.agda).

## Productive interaction

\[
\boxed{\mathsf{ISC}(w)=\prod_{q:Q(w)}\sum_{w':W}\sum_{o:O(w,q,w')}E(w,q,w',o)\times\mathsf{ISC}(w').}
\]

\[
\operatorname{react}(w,q)=(w',o,e,\kappa)
\]

returns successor, observation, event/residual and continuation together. Autonomous evolution is the one-query restriction,

\[
Q(w)\simeq1\Rightarrow\mathsf{ISC}|_Q\simeq\operatorname{Orbit},
\]

and finite interaction composes exactly:

\[
\boxed{\operatorname{Ans}_{m+n}(w)\simeq\sum_{a:\operatorname{Ans}_m(w)}\operatorname{Ans}_n(\operatorname{end}_m(w,a)).}
\]

→ [The Interactive Symbolic Computer](pages/10-interactive-symbolic-computer.md)  
**Checked:** [`Samvada`](../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda).

## Coinduction and completion

With \(x\equiv_ny\) denoting agreement through depth \(n\), compatible finite approximants determine a unique corecursive limit:

\[
x_0\equiv_0x_1,\ x_1\equiv_1x_2,\ldots
\Rightarrow
\exists!x_\infty\ \forall n,\ x_\infty\equiv_nx_n.
\]

Finite observation and infinite behavior are joined by one prefix structure; productive definition, observational topology and continuity modulus live on the same carrier.

→ [Coinduction, Continuum, and Causal Completion](pages/08-coinduction-continuum-causal-completion.md)

## Metacircular closure

\[
\mathcal M\xrightarrow{\rm interact}\delta\xrightarrow{\rm install}\mathcal M'\xrightarrow{\rm interact}\cdots
\]

\[
\boxed{\text{derived transformation}=\text{available future transformation}.}
\]

Proof, program, datum, type, path, transformation, execution and provenance are roles of mathematical objects in one continuing universe. `IntrinsicRewrite`, self-presentation, `ProductiveIndraNet` and the lifecycle construction realize retained transformation and re-entry.

## Chu: visible interaction shadow

A [Chu space](https://ncatlab.org/nlab/show/Chu+space) has \(e:A\times X\to K\). Forced completion gives

\[
\boxed{A\times X\simeq\sum_{k:K}\operatorname{fib}_e(k).}
\]

Chu retains the visible coordinate \(k\); complete conservative interaction retains its forced fibre. Universe-valued interaction

\[
R:A\times X\to\mathcal U
\]

removes the fixed scalar codomain while preserving the two-pole geometry. Chu duality, transforms, residuation, state/event, time/information, Chu over \(2,3,4\), universal mathematics and transformational mathematics become coordinates on this restriction.

→ [Chu Spaces Completed](pages/03-chu-spaces-completed.md) · [full Chu exposition](CHU_LOSSLESS_INTERACTION.md)

## Action and logic: finite/truncated interaction

Pratt's PDL relation \(R_\alpha:S\times S\to\operatorname{Prop}\) lifts to \(R_\alpha(s,t):\mathcal U\), with

\[
R_{\alpha;\beta}(s,u)=\sum_tR_\alpha(s,t)\times R_\beta(t,u),
\]

\[
[\alpha]P(s)=\prod_t(R_\alpha(s,t)\to P(t)),
\qquad
\langle\alpha\rangle P(s)=\sum_tR_\alpha(s,t)\times P(t).
\]

Fischer–Ladner/Hintikka observation is one finite decision-sufficient coordinate governed by descent; tableau realizability is a finite shadow of productive inhabitance; near-optimal reasoning about action is a classical instance of optimal interaction.

→ [Action, Logic, and Optimal Inference](pages/05-action-logic-optimal-inference.md)

## Concurrency, braid, retained order

Pratt's pomsets, schedule/automaton duality, solid automata and monoidal homotopy expose concurrent dimension geometrically. Complete interaction retains order exactly where order carries information:

\[
\sigma_i\sigma_{i+1}\sigma_i=\sigma_{i+1}\sigma_i\sigma_{i+1},
\qquad
\sigma_i\sigma_{i+1}\not\equiv\sigma_{i+1}\sigma_i
\]

when adjacent interactions genuinely do not commute. Braid is retained order modulo structure-preserving deformation.

→ [Concurrency Is Geometry](pages/04-concurrency-is-geometry.md)

## Causality and interaction geodesics

\[
x\equiv_{n+1}y\Rightarrow\sigma x\equiv_n\sigma y,
\qquad
x\equiv_{n+|w|}y\Rightarrow w(x)\equiv_nw(y).
\]

Hence

\[
\boxed{\text{depth}=\text{time},\qquad |w|=\text{causal radius}.}
\]

Moving cell \(n\) to the head requires at least \(n\) crossings and an \(n\)-crossing path exists:

\[
\boxed{d_{\rm interaction}(\text{cell }n,\text{head})=n.}
\]

Computational irreducibility is geodesicity when native evolution attains the lower bound forced by dependency geometry. Semantic equivalence does not imply zero execution work.

## Phase, symmetry, global information

\[
\rho^4=1,
\qquad
Q:R\to\mathbb Z/4,
\qquad
\boxed{Z_{\rm cell}=\langle\rho\rangle\simeq\mathbb Z/4.}
\]

Global charge is not bounded-locally readable:

\[
\forall n\;\exists x,y:\ x\equiv_ny\land Qx\neq Qy.
\]

For action residual

\[
\delta(x)=q(\operatorname{step}x)-P(qx),
\]

a character gives relative phase

\[
\boxed{\chi(\delta x)=\chi(q(\operatorname{step}x))\chi(P(qx))},
\qquad
\chi(a)=\chi(b)\iff\chi(a-b)=1.
\]

The checked hostile case has injective \(\delta(x)=2x\) while every sign character sends the residual to identity phase: a faithful distinction can be invisible under a quotient observation.

→ [State / Event — Time / Information](pages/06-state-event-time-information.md)  
**Checked:** [`ActionResidualPhase.agda`](../formal/cubical/theorems/residue/ActionResidualPhase.agda).

## Physical carrier

The photonic construction exposes

\[
S^3\simeq SU(2)\to SO(3)\curvearrowright S^2,
\]

with quarter-turn generators

\[
\rho_x^2=\rho_z^2=-1,
\qquad
\rho_x\rho_z=-\rho_z\rho_x,
\qquad
\langle\rho_x,\rho_z\rangle\simeq Q_8.
\]

A checked two-body transformation is globally lossless

\[
U:A\otimes B\simeq A\otimes B
\]

while not factorizing as \(U_A\otimes U_B\). Unitary transport, noncommuting order, global correlation, braid, phase, charge and local/global information are carried by one interaction geometry.

→ [Interaction Geometry Becomes Physics](pages/09-interaction-geometry-physics.md)

## Finding and checking

For the universal machine step,

\[
M\simeq\sum_{b:M}\operatorname{fib}_{uStep}(b).
\]

The two directions give `decide` and `verify`, with

\[
\operatorname{verify}(\operatorname{decide}m)=m
\]

and the produced equality certificate supplied by reflexivity. Together with contractibility of the lossless completion, finding and checking are projections of one equivalence *inside the lossless universal-machine object*. This statement is distinct from an external succinct-encoding complexity-class claim.

**Checked:** [`VerifyIsDecide`](../formal/cubical/theorems/residue/VerifyIsDecide_ThereIsNoGapBetweenFindingAndCheckingBecauseBothAreProjectionsOfOneEquivalence.agda).

## Runtime

The cubical operations

\[
I,\operatorname{Path},\operatorname{PathP},\operatorname{comp},\operatorname{coe},\operatorname{hcomp},\operatorname{Glue},\operatorname{ua}
\]

meet local interaction-net operations, sharing and superposition in the Bend/HVM convergence work:

\[
\boxed{\text{constructive mathematical interaction}\longleftrightarrow\text{runtime interaction}.}
\]

The intended machine is therefore not an interpreter for the mathematics above. Its primitive reduction structure is the execution surface on which the same interaction object runs.

→ [The Interactive Symbolic Computer](pages/10-interactive-symbolic-computer.md)  
**Runtime anchor:** [`collab/bend2-cubical/CONVERGENCE.md`](../collab/bend2-cubical/CONVERGENCE.md).

---

# One object, many shadows

\[
\boxed{
\begin{array}{rcl}
\text{visible projection}&\rightsquigarrow&\text{observation / Chu / quotient},\\
\text{forced fibre}&\rightsquigarrow&\text{lossless interaction},\\
\text{untruncated identity}&\rightsquigarrow&\text{cubical higher