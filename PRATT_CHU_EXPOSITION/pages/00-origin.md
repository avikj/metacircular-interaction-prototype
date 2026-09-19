# Lossless Interdependent Interaction

> **The complete construction.** Everything else in this exposition is a restriction, projection, truncation, carrier, coordinate system, historical presentation, or executable realization of the object developed here.

A constructive mathematical universe is not a collection of inert values equipped with an external evaluator. Its objects carry their own spaces of identification; maps expose observations of them; the information collapsed by an observation is determined by that observation; equivalences are executable paths; compatible higher boundaries compose; interactions continue coinductively; transformations produced by interaction can re-enter as subsequent transformations; and the same local interaction admits a runtime realization.

The compact form is

\[
\boxed{
\pi:\sum_{T:\mathcal U}T\longrightarrow\mathcal U
}
\qquad
\boxed{
\operatorname{isContr}(\operatorname{Lossless}(f))
}
\qquad
\boxed{
\mathsf{ISC}(w)=
\prod_{q:Q(w)}
\sum_{w':W}\sum_{o:O(w,q,w')}
E(w,q,w',o)\times\mathsf{ISC}(w')
}.
\]

The first classifies dependent mathematical structure. The second says that the complete conservative presentation of any visible map is forced. The third makes interaction productive: observation, evidence, successor, and continuation are returned together. Cubical composition, univalence, coinduction, reflection, braid, symmetry, phase, causal locality, geodesic cost, and interaction-net execution are not separate semantic layers attached afterward; they are structures and consequences exposed by this same object.

---

## 1. The universal interaction universe

Let \(\mathcal U\) be a [univalent universe](https://ncatlab.org/nlab/show/univalent+universe). Its universal family is

\[
\boxed{
\pi:\sum_{T:\mathcal U}T\to\mathcal U,
\qquad
\pi(T,t)=T.
}
\]

Every dependent family

\[
P:A\to\mathcal U
\]

is obtained by pulling back \(\pi\) along its classifying map \(P\):

\[
\begin{array}{ccc}
\displaystyle\sum_{a:A}P(a)&\longrightarrow&\displaystyle\sum_{T:\mathcal U}T\\[1mm]
\downarrow&&\downarrow\pi\\
A&\xrightarrow{P}&\mathcal U.
\end{array}
\]

At equal universe level the classifier is expressed by

\[
\boxed{
\left(\sum_{E:\mathcal U}(E\to A)\right)
\simeq
(A\to\mathcal U).
}
\]

Finite towers of dependent families flatten to one family over the original base. Repeatedly exposing more dependent structure therefore does not require a hierarchy of foreign semantic mechanisms: it remains one dependent object classified by the same universe.

This is the first sense in which the construction is universal. A [Chu space](03-chu-spaces-completed.md), a transition relation, a proof family, an observation family, a bundle, a continuation family, a space of transformations, and a runtime type are not required to inhabit distinct ontologies. They can all be presented as dependent mathematical structure inside the same classifier.

**Checked construction:** [`Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`](../../fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda).

---

## 2. Every visible map has one complete conservative presentation

Take any map

\[
f:A\to B.
\]

Its homotopy fibre at \(b:B\) is

\[
\operatorname{fib}_f(b)
:=
\sum_{a:A}(f(a)=b).
\]

There is a canonical equivalence over \(B\):

\[
\boxed{
A\simeq\sum_{b:B}\operatorname{fib}_f(b)
}
\]

with

\[
a\longmapsto(f(a),(a,\operatorname{refl})).
\]

The visible result is still exactly \(f(a)\). What has changed is that the complete source distinction lying over that result has not been discarded.

But the stronger theorem is the important one. Define a conservative completion of \(f\) by

\[
\operatorname{Lossless}(f)
:=
\sum_{T:B\to\mathcal U}
\sum_{e:A\simeq\sum_{b:B}T(b)}
(\pi_1\circ e\sim f).
\]

Then

\[
\boxed{
\operatorname{isContr}(\operatorname{Lossless}(f)).
}
\]

Equivalently, any conservative factorization over the same visible map forces

\[
\boxed{
T(b)\simeq\operatorname{fib}_f(b).
}
\]

The residual is not an annotation selected by a machine designer. Once the visible map and conservation requirement are fixed, the retained family is determined up to equivalence, and the type of complete conservative presentations is itself contractible.

At machine level this yields the compact equivalence

\[
\boxed{
\operatorname{LawfulStep}(A)\simeq(A\to A).
}
\]

The lawful lossless machine is the map together with structure that is uniquely forced by the map.

This is the mathematical core of [The Fibre Law](02-fibre-law.md), [lossless Chu evaluation](03-chu-spaces-completed.md), retained provenance, reversible presentation, exact observation, and the later finding/checking result.

**Checked constructions:** [`Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`](../../fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda), [`Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`](../../formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda).

---

## 3. Observation is quotient; the fibre is what the quotient identified

An observation

\[
q:X\to Y
\]

induces indistinguishability

\[
x\sim_qx'\quad:\Longleftrightarrow\quad q(x)=q(x').
\]

The fibre \(\operatorname{fib}_q(y)\) is exactly the dependent family of sources identified at visible value \(y\). Thus observation and residual are not independent notions:

\[
\boxed{
\text{visible coordinate}=q(x),
\qquad
\text{forced retained coordinate}=\operatorname{fib}_q(qx).
}
\]

For a target observation \(h:X\to Z\) with the relevant set-level hypotheses, the exact descent criterion is

\[
\boxed{
h=\bar h\circ q
\iff
q(x)=q(x')\Rightarrow h(x)=h(x').
}
\]

So the question âdoes this representation retain enough information?â is not heuristic. A target computation descends precisely when it is constant on the distinctions collapsed by the observation.

This is the common mechanism beneath quotient semantics, measurement, sufficient observation, abstraction, the Fischerâ“Ladner/Hintikka coordinate used in [Pratt's dynamic-logic work](05-action-logic-optimal-inference.md), and the local/global information split in [state/event â” time/information](06-state-event-time-information.md).

---

## 4. Residuals compose

For

\[
A\xrightarrow{f}B\xrightarrow{g}C,
\]

the residual of the composite decomposes through the actual intermediate value:

\[
\boxed{
\operatorname{fib}_{g\circ f}(c)
\simeq
\sum_{(b,p):\operatorname{fib}_g(c)}
\operatorname{fib}_f(b).
}
\]

Lossless interaction therefore composes dependently. The retained information of a composite is not a flat log of two independent steps; the second residual indexes the first at the intermediate point actually reached.

The same law reappears as finite prefix/suffix decomposition of interaction, endpoint-conditioned histories, compositional provenance, and the relation between heterogeneous interaction and the residuation vocabulary of Pratt's [Rational Mechanics](03-chu-spaces-completed.md).

---

## 5. Identity is higher-dimensional and computational

The residual family contains equality witnesses

\[
p:f(a)=b.
\]

No truncation is imposed by the construction. Whenever those types possess higher identity, it remains present:

\[
p=q,\qquad \alpha=\beta,\qquad\ldots
\]

[Cubical type theory](https://ncatlab.org/nlab/show/cubical+type+theory) gives this identity structure explicit computational geometry. There is an interval \(I\); paths and dependent paths are maps over \(I\); higher paths are cubes; compatible partial boundaries admit composition and filling; dependent structure transports along paths:

\[
I,
\quad
\operatorname{Path},
\quad
\operatorname{PathP},
\quad
\operatorname{comp},
\quad
\operatorname{fill},
\quad
\operatorname{hcomp},
\quad
\operatorname{coe}.
\]

This is the constructive cell language in which [higher-dimensional concurrent interaction](04-concurrency-is-geometry.md), proofs of equivalence, geometric deformation, and runtime transport can inhabit one mathematics.

The point is not that every identity path is automatically a concurrent execution. Rather, execution cells and identity/coherence cells can be represented and related inside one cubical language, so an identification between them is itself mathematics rather than an analogy between two external models.

---

## 6. Equivalence is executable identity

For types \(A,B:\mathcal U\), univalence gives

\[
\boxed{
(A\simeq B)\simeq(A=_{\mathcal U}B).
}
\]

Given

\[
e:A\simeq B,
\]

we obtain

\[
\operatorname{ua}(e):A=_{\mathcal U}B
\]

and computational transport

\[
\operatorname{coe}_{\operatorname{ua}(e)}=e.
\]

An equivalence is therefore not merely a proposition saying that two presentations encode the same mathematics. It is a path along which every dependent construction can move.

For dynamics \(\Phi:A\to A\) and an equivalence \(e:A\simeq A'\), define

\[
\Phi'=e\Phi e^{-1}.
\]

The coinductive dynamics commute with this change of coordinates:

\[
\boxed{
\operatorname{map}(e,\operatorname{unfold}(\Phi,a))
=
\operatorname{unfold}(\Phi',ea).
}
\]

The whole future transports. This is [dynamic reflection](07-types-processes-transformations.md): equivalence, representation change, proof reuse, symmetry reduction, and executable transformation are different readings of the same path structure.

**Checked construction:** [`Nucleus.agda`](../../fibre/src/Fibre/Nucleus.agda).

---

## 7. Interaction is productive

A terminating evaluator has the shape

\[
(w,q)\mapsto o.
\]

The complete interaction returns the successor, visible observation, proof-relevant event, and continuation together. The interactive symbolic computer is

\[
\boxed{
\mathsf{ISC}(w)
=
\prod_{q:Q(w)}
\sum_{w':W}
\sum_{o:O(w,q,w')}
E(w,q,w',o)\times\mathsf{ISC}(w').
}
\]

One interaction is therefore

\[
\operatorname{react}(w,q)=(w',o,e,\kappa).
\]

The continuation \(\kappa\) has the same interactive form again. The future is not an external scheduler attached to a static semantics; it is part of the mathematical result.

The deterministic orbit is exactly the one-query restriction:

\[
Q(w)\simeq1
\Longrightarrow
\mathsf{ISC}|_Q\simeq\operatorname{Orbit}.
\]

Finite observations compose by

\[
\boxed{
\operatorname{Ans}_{m+n}(w)
\simeq
\sum_{a:\operatorname{Ans}_m(w)}
\operatorname{Ans}_n(\operatorname{end}_m(w,a)).
}
\]

A length-\(m+n\) interaction is exactly a length-\(m\) realized prefix together with the dependent length-\(n\) continuation at the endpoint actually reached.

This is the central object of [The Interactive Symbolic Computer](10-interactive-symbolic-computer.md) and the productive completion of the finite interaction shadows appearing in Chu evaluation, dynamic logic, automata, proof search, and ordinary program execution.

**Checked construction:** [`Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda`](../../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda).

---

## 8. Coinduction is intrinsic completion

Let

\[
x\equiv_n y
\]

mean agreement through observational depth \(n\). A compatible chain

\[
x_0\equiv_0x_1,
\quad
x_1\equiv_1x_2,
\quad\ldots
\]

has a unique corecursively constructed limit \(x_\infty\) satisfying

\[
\forall n,\qquad x_\infty\equiv_nx_n.
\]

Thus productive continuation carries its own completion principle. Finite observation and infinite behavior are not separate semantic worlds: finite prefixes determine the topology/metric through which the coinductive carrier is completed.

This meets Pratt and Pavlovi's [final-coalgebraic continuum](08-coinduction-continuum-causal-completion.md) directly: induction/arithmetic and coinduction/analysis become neighboring restrictions of one constructive interaction universe, while locality supplies explicit continuity moduli for the transformations acting on the carrier.

---

## 9. Interdependence is retained rather than factorized away

A complete interaction need not decompose into independent local transformations. A checked two-body transformation may be globally lossless

\[
U:A\otimes B\simeq A\otimes B
\]

while admitting no local factorization

\[
U\neq U_A\otimes U_B
\]

for all candidate local factors of the required form.

This is the computational content of interdependence: the complete object carries correlations that are not reconstructible from independently transformed components. Sharing, superposition, entangling interaction, dependent continuation, and global invariants are all places where the structure of the whole cannot be replaced by a product of separately evolved parts.

See [Interaction Geometry Becomes Physics](09-interaction-geometry-physics.md).

---

## 10. Order becomes geometry

Pratt's concurrency program supplies a historically exact coordinate. A string is a linearly ordered multiset; a [pomset](https://en.wikipedia.org/wiki/Pomset) relaxes total order. Schedule/automaton duality exposes two presentations of concurrent behavior. True \(n\)-fold concurrency occupies an \(n\)-dimensional transition rather than an interleaving skeleton. Monoidal homotopy makes nondeterministic process geometry explicit.

The complete interaction retains order only where order carries information. Independent/commuting order can collapse; noncommuting order cannot.

The resulting local geometry naturally admits braid relations

\[
\sigma_i\sigma_{i+1}\sigma_i
=
\sigma_{i+1}\sigma_i\sigma_{i+1}
\]

without imposing

\[
\sigma_i\sigma_{i+1}
=
\sigma_{i+1}\sigma_i.
\]

Braid is retained order modulo exactly the deformations that preserve interaction. It therefore links higher-dimensional concurrency, path geometry, information-bearing order, transport