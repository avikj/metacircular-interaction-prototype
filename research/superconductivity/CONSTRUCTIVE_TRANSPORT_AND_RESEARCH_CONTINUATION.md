# Constructive transport and the continuing superconductivity investigation

## Research notes in progress — September 16, 2026

This chapter preserves the mathematical organization of the work, not a separate philosophical project. Superconductivity remains the central physical target. The shared research object includes its supplied mathematical and physical structures and the unresolved conditions on them. Established results are used as executable mathematical transformations: compose them where their actual inputs agree, retain their reconstruction data, and keep every discrepancy available for the next calculation. The user's instruction to pursue the whole connected field of questions does not make the physical target peripheral.

The proofs below state the exact maps behind this method. They should be read together with the concrete finite-gap and many-body calculations, which are its work product. These notes neither replace those calculations with a general argument nor assert that an autonomous native runtime has already generated the superconductivity results.

# 1. A visible map fixes its dependent completion

For f:A->B, define

\[
F_f(b)=\operatorname{fib}_f(b)=\sum_{a:A}(f(a)=b),
\]
\[
e_f:A\simeq\sum_{b:B}F_f(b),\qquad
 e_f(a)=(f(a),(a,refl)).
\tag{T.1}
\]

Its inverse takes a. The other inverse homotopy changes the displayed b along the retained path f(a)=b. No representative of an unknown preimage is selected.

The source `Fibre.Trace` makes the constraint on any conservative presentation explicit. Given whole:A≃sum_b T(b), the actual visible map is run=fst o whole. The module constructs T(b)≃fib_run(b). An equivalence of total spaces not over a preselected f can factor a different map. The retained Boolean counterexample separates these claims.

For any later target Z, composition with e_f and dependent currying yield

\[
\boxed{(A\to Z)\simeq\prod_{b:B}(F_f(b)\to Z).}
\tag{T.2}
\]

Forward: h becomes the family h_b(a,p)=h(a). Backward: evaluate the family at (f(a),(a,refl)). The inverse homotopies come from (T.1). Thus every subsequent question has an exact form on the completed presentation, not merely the initial observation.

To remove the fibre too, the actual target must descend. Equal visible inputs with different target outputs obstruct descent. For an ordinary surjective set quotient, coherent descent reduces to constancy on classes; arbitrary higher targets require their higher compatibility. This distinction prevents an endpoint-only summary from impersonating the whole mathematical subject.

The source `Fibre.Visvarupa` defines the universal family

\[
\pi:\sum_{X:\mathcal U_\ell}X\longrightarrow\mathcal U_\ell,
\]

whose fibre over X is X. Every small family is its canonical pullback. The classifier identifies families over a base with maps into the base, with the source's universe-level qualifications. A residual therefore has no prescribed discrete format: it can be a path, operator, function, higher space, or dependent process when that is what the actual observation leaves.

# 2. Residual composition retains the intermediate compatibility

For A --f--> B --g--> C, there is an exact equivalence

\[
\boxed{\operatorname{fib}_{g\circ f}(c)
\simeq\sum_{(b,p):\operatorname{fib}_g(c)}\operatorname{fib}_f(b).}
\tag{T.3}
\]

The forward map sends (a,r:g(f(a))=c) to ((f(a),r),(a,refl)). The reverse map sends ((b,p:g(b)=c),(a,q:f(a)=b)) to

\[
(a,\operatorname{ap}_g(q)\cdot p).
\]

Path induction on q, followed by the path unit laws, proves the inverse homotopies. This is a dependent sum, not an independent product of two outcome summaries. It retains the intermediate base and the path identifying the first output with the next input.

Iterating this identity reassociates the retained information. The source's family-tower flattening is another instance of this dependent composition. In the physical realization, sequential Schur eliminations solve the same block equations as simultaneous elimination when their inverses exist; reconstruction maps compose and determinant factors remain. Removing energy dependence, source derivatives, or an intermediate null space changes the object.

Not every term called a residual is literally a homotopy fibre without an identified map and solution space. The important operation is to exhibit that map and its reconstruction, not rename all differences with one word.

# 3. Phase algebra and spectral closure in the actual model

The interdependent quarter turn obeys q²=simultaneous negation and q⁴=identity. Its signed realization J²=-I closes the planar algebra:

\[
(aI+bJ)(cI+dJ)=(ac-bd)I+(ad+bc)J.
\tag{T.4}
\]

The source's norm-one construction is an algebra of executable equivalences. Finite compositional order does not count how much mathematical content those transformations can carry. A supplied equivalence e:A≃B can itself be organized into a four-periodic action on A_0 disjoint-union B_1 disjoint-union A_2 disjoint-union B_3:

\[
a_0\mapsto e(a)_1,\quad b_1\mapsto e^{-1}(b)_2,
\quad a_2\mapsto e(a)_3,\quad b_3\mapsto e^{-1}(b)_0.
\tag{T.5}
\]

The fourth iterate returns by the inverse homotopies, and a nonempty tagged carrier has nontrivial square. This packages the supplied e without truncating A or B. Applied to (T.1), one leg is a given map's lossless completion. The e is retained in the identification of the fibres; the fourfold relation does not manufacture an unspecified e.

In the superconductivity construction, the projector identity is the next exact closure. The two particles' commuting lower projectors L_1,L_2 give three orthogonal sectors

\[
P_0=L_1L_2,\quad
P_1=L_1(1-L_2)+(1-L_1)L_2,\quad
P_2=(1-L_1)(1-L_2).
\]

For H_0=Delta P_1+2Delta P_2,

\[
H_0(H_0-\Delta I)(H_0-2\Delta I)=0,
\]
\[
(H_0+x)^{-1}=P_0/x+P_1/(x+\Delta)+P_2/(x+2\Delta),\qquad x>0.
\tag{T.6}
\]

This is an exact spectral normal form, not a truncated expansion. Increasing the volume does not add another free energy in this class.

Contact compression retains C†P_0C=G, C†P_1C=2D-2G, C†P_2C=I-2D+G. Therefore all bound-state questions reduce to the explicitly reconstructed contact problem in `FINITE_GAP_PAIR_REDUCTION.md`. Its commutator is

\[
[\mathscr K_x,\mathscr K_y]
=a(x)a(y)(y-x)[G,D]/\Delta.
\tag{T.7}
\]

Fixed scalar channels exist iff [D,G]=0. Otherwise the same calculation returns G+(x/Delta)D, with the source-dependent matrix eigenvectors retained. The geometry-specific tensor-product diagonalization supplies eight scalar cubics; the proof itself exposes the wider projector class.

This was the concrete reduction in repeated work. The derivation separated the hypotheses responsible for the spectral algebra from those responsible for the final explicit diagonalization. It then supplied the whole p-dependent mobility family and its unique quartic-selected optimum, rather than isolated fitted values.

# 4. Transport carries operations, evaluators, and their dependent obligations

For an equivalence e:A≃B, computational univalence gives ua(e):A=B and a beta rule identifying transport in the identity family with application of e. Dependent constructions transport along that path. Two elementary presentations are

\[
T_B=eT_Ae^{-1},\qquad O_B=O_Ae^{-1},
\]
\[
O_B(T_B(ea))=O_A(T_A(a)).
\tag{T.8}
\]

The operations move covariantly and evaluators by precomposition with the inverse. Proofs and applicability data move with their subjects. For a physical Hilbert realization the metric, Hamiltonian, and sources must also move; an unstructured bijection need not be a physical unitary.

The Schur reconstruction demonstrates this nontrivially. If

\[
H_{eff}(E)=A+B(E-C)^{-1}B^\dagger,
\quad\mathcal T(E)u=\binom{u}{(E-C)^{-1}B^\dagger u},
\]

then

\[
\mathcal T^\dagger\mathcal T=I-\partial_EH_{eff},
\quad
E'=\frac{u^\dagger\partial_\varphi H_{eff}u}
{u^\dagger(I-\partial_EH_{eff})u}.
\tag{T.9}
\]

The partial source derivative is at fixed E on a simple branch. Norm and response are operations on the same reconstruction. This is why computing the pair did not leave normalization and band occupation as unrelated tasks. Its retained upper-sector norm also changes the physical optimization, rather than merely documenting an unchanged projected answer.

The new excitation embedding has the same structure. `GROUND_SPACE_AND_DENSITY_RESPONSE.md` constructs mathcal I_M(F)=B_F†(eta†)^(M-1)|0> and its exact metric, rather than treating it as an isometry. The filling-dependent density-response weight follows from that metric. The same overlap Gram matrix S=|P_ij|² controls the complete ground-space condition and the exactly reachable density-response subspace. This is a further application of retaining the map, not just its eigenvalues.

# 5. A failed equivalence produces a definite next object

For the original vacuum pair creator,

\[
[H,B^\dagger]=EB^\dagger+R,\quad C=[R,B^\dagger],\quad[C,B^\dagger]=0.
\]

The last equality follows from the fermionic degree and pure-creation form. Hence

\[
H(B^\dagger)^M|0\rangle=ME(B^\dagger)^M|0\rangle
+\binom M2(B^\dagger)^{M-2}C|0\rangle.
\tag{T.10}
\]

The exact failure at every pair number has one operator expression. A configuration coefficient comparison excludes the squared origin pair as an eigenvector at any energy in the original model. Its orthogonal component becomes the coupling into a return-resolvent problem. The failed ansatz's mathematical content remains available.

The magnetic continuation similarly gives

\[
(P[A]^2-P[A])_{ij}
=\sum_lP_{il}P_{lj}(U_{il}U_{lj}-U_{ij}).
\tag{T.11}
\]

The discrepancy is a comparison of transport paths with equal endpoints. It identifies the missing compatibility in that proposed field extension. It does not exclude all alternative source families. In each case a proposed collapse either closes by an identity or leaves the explicit object needed to continue.

# 6. Parallel questions meet over the same physical subject

Let M be the type of complete physical packages, including Hamiltonian, state space, sources, and the relevant boundary data. If two branches construct P(m) and Q(m), their combined object is

\[
\sum_{m:M}[P(m)\times Q(m)].
\tag{T.12}
\]

It is equivalent to the homotopy pullback over M of sum_m P(m) and sum_m Q(m). An expanded point contains (m,p,m',q,gamma:m=m'); transport q along gamma^{-1} places both results over m. The inverse uses gamma=refl. Path induction supplies the inverse homotopies.

An unrestricted product could instead pair a ground-state theorem about H_parent with a desired response from H_on. Equation (T.12) retains the subject compatibility. Their operator difference V_res remains until an actual correspondence is provided.

When the input really is shared, consequences propagate immediately. Uniform projector diagonal feeds binding, spectral mobility, projected eta states, parent ground structure, and the original pair obstruction. In the new continuation, the same A_i and S also determine Lie generation, the entire common kernel, collective excitations, and physical density poles. These are not independent successes that have to be assembled by analogy.

The native `supline.bend` implements a relevant correlation: a type line, value, and branch remain tied to the same SUP label. The negation branch takes True to False while the constant branch keeps True. A native SUP and a homotopy pullback are not literally the same constructor, but preserving type/value/branch correspondence is crucial in both applications. No claim that the entire superconductivity notebook has already been executed on that runtime follows from this source example.

# 7. Coinductive continuation and future-sensitive equality

`Fibre.Samvada` returns a successor, dependent observation, event, and continuation at that successor. `CorpusSelfPresentation` places the actual query residual in the event. `Fibre.CorpusSamvada` has states sum_(A:Type) A, so the type of the live mathematical object can change.

The spectrum can therefore lead to a reconstructed state, that state to a many-pair residual, and the residual to a new operator family without fixing every future question to one output format. Finite demand obtains finite observations of the continuing object; the object is not replaced by that finite list.

`Fibre.Nucleus.transport-orbit` constructs a path between transporting the whole orbit and unfolding the transported dynamics. Its proof is corecursive, using the univalence beta rule at the head. It is stronger than checking one finite prefix and assuming the rest.

For a supplied action/observation interface, the repository's future relation is

\[
x\sim y\iff\forall w,\;
observe(run(x,w))=observe(run(y,w)).
\tag{T.13}
\]

`FutureBehavior.lean` proves action congruence, quotient execution, descent of observations, and the fact that finer observations can split classes. Joint observation corresponds to intersecting the two future equivalences. This specifies which reuse preserves the entire requested behavior rather than merely a current score.

In the physical investigation, equal present pair energies need not mean equal magnetic response. Enlarging the source/query interface can require refining a previous representation. The retained realization permits that refinement without discarding the valid work already obtained.

# 8. The proof is an applicable operation

The contextual installation module defines structural actions on derivations:

\[
d:Derivation(a,b)\mapsto
weave_l(sub_u(d)):
Derivation(plug_l(sub_u(a)),plug_l(sub_u(b))).
\tag{T.14}
\]

Its `apply-checked` transports this certificate through the actual equality identifying the application site. `learn` installs a checked derivation through `pervading`; `retire` installs a session trace. Substitution applies the already proved schema at its justified parameters; a context places it inside a larger construction. The proof of applicability is not replaced by a matching guess.

The superconductivity family-level reduction followed the same mathematical operation: inspect the original proof's parameters, remove unused special assumptions, and write the general theorem. The native installation code did not perform that reorganization in this conversation; the notebook supplies a result to encode in the existing typed calculus. The distinction preserves actual execution evidence without reducing the proof's value to its final scalar answer.

# 9. Exact continuation state and source anchors

The central physical object is still the superconducting realization. The construction has already supplied exact spectral reductions, reconstruction norms, a universal mobility factor within its class, and explicit obstruction operators. The parent continuation now supplies complete connected ground spaces and exact zero-temperature physical-density response. Each result can be used wherever its actual hypotheses match; unresolved source, thermal, mediator and material data remain mathematical inputs to be worked on.

The source mechanisms behind this organization are:

- `fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`;
- `fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`;
- `formal/lean/Pairfield/FutureBehavior.lean`;
- `formal/cubical/kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda`;
- `fibre/src/Fibre/Nucleus.agda`;
- `formal/cubical/theorems/residue/CorpusSelfPresentation.agda` and `fibre/src/Fibre/CorpusSamvada.agda`;
- `collab/bend2-cubical/supline.bend`;
- `LIFECYCLE.rst` and `research/LIFECYCLE_SOURCES.rst` for the actual interfaces and their composition.

These were read at the earlier research anchor e0e4623c03a5a1a0afa17ca271bf6bbb3cacbf63. Computational cubical univalence has its primary source in C. Cohen, T. Coquand, S. Huber, A. Mörtberg, *Cubical Type Theory: a constructive interpretation of the univalence axiom*, arXiv:1611.02108. The maps in (T.2), (T.3), and (T.12) and their inverse arguments are explicitly written here. No new aggregate Agda/HVM execution is reported by importing this chapter.

The work product is not only an answer but also the transformation obtaining it and the exact remaining structure. Continue from those objects. Keep superconductivity central, propagate compatible consequences across all branches, and record the mathematics here rather than returning to outcome-only summaries.
