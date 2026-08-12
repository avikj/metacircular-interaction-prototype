# Natural crystal: the compact mathematical artifact

Let a finite observed dynamical system be

\[
\mathcal M=(X,A,\delta,o),
\]

where `X` is a state set, `A` a set of interventions/tools,
`delta:X times A -> X` their action, and `o:X -> Y` the accessible
observation. Extend `delta` to words `w in A*`.

Define contextual equivalence

\[
x\equiv y
\quad\Longleftrightarrow\quad
o(\delta(x,w))=o(\delta(y,w))\quad\text{for every }w\in A^*. \tag{1}
\]

Then `equiv` is the greatest action-compatible equivalence contained in the
kernel of `o`. The quotient

\[
\operatorname{Cry}(\mathcal M)=X/{\equiv}             \tag{2}
\]

is the unique minimal deterministic observed machine with the same behavior,
up to isomorphism. Its quotient classes are compositional tools; their full
preimages are retained as dependent-origin fibers.

`machinery/natural_crystal.py` computes (2) by finite partition refinement.
It does not assume that a proposed twelvefold experiential system exists in
fundamental physics. The exact realizability question is whether a physical
observed dynamical system `P` admits a surjective machine morphism

\[
P\twoheadrightarrow N_{12}                            \tag{3}
\]

to an empirically specified twelve-link intervention system. Such a morphism
must preserve observations and intervention dynamics. Merely labeling twelve
physical variables does not establish (3).

The artifact therefore converts the philosophical claim into three finite
obligations: specify the interventions, specify observable distinctions, and
exhibit or refute the morphism. Crystallization is behavioral minimization;
dependent origination is the retained fiber and transition provenance;
compositionality is action by intervention words.

## Static lens kernel

The complementary finite object is a Chu-style observation context

\[
(P,r,L),\qquad r:P\times L\to K,                    \tag{4}
\]

where `P` are points, `L` are lenses/probes, and `K` is the value type. The
biextensional collapse identifies equal rows and equal columns while retaining
their origin fibers. A separating lens family is a subset `S of L` for which

\[
p\longmapsto(r(p,s))_{s\in S}                       \tag{5}
\]

is injective on the collapsed points. Its least size is the exact number of
faces required for reconstruction. Transposition exchanges points and lenses.

`machinery/observation_crystal.py` computes the collapse, exact minimum
separating point/probe families, unresolved pairs, transpose dual, and Boolean
double-prime closure. The static and temporal kernels are distinct:

\[
\text{Chu context: simultaneous refraction},\qquad
\text{coalgebra: unfolding under intervention}.     \tag{6}
\]

Their future joint is a dynamic observation context whose probes may themselves
be composable interventions. Yoneda/density is the categorical correctness
target: a probe family is dense when its nerve is fully faithful. Sheaf descent
is the later gluing target. Tannaka reconstruction is reserved for the special
case where a genuine rigid tensor category and faithful fiber functor exist.

## Generated/initial kernel

Following Voevodsky's terminal program, the third axis begins with a dependent
system of inference rules `S` and its least closed sentence world

\[
\operatorname{Cl}_S(\varnothing).                   \tag{7}
\]

If the associated structured term model is initial, every realization receives
a unique interpretation from it. General initiality is conjectural at the level
of general dependent type theories. `machinery/initial_crystal.py` implements
only finite rule closure, proof-relevant origins, and replay of declared
interpretations. It deliberately does not manufacture initiality by definition.

The three finite axes are therefore generation, observation, and behavior. A
true natural crystal must prove their compatibility; placing them beside each
other is only an atlas.

## Compatibility joint

`COMPOSITIONAL_CRYSTAL_THEOREM.md` supplies the finite joint. For a finite
algebra, close an observation under every one-hole polynomial context. Equality
of all contextual observations is the greatest operation-congruence contained
in the raw observation kernel. Its quotient therefore retains all generated
operations and has the usual universal factorization property. This is the
finite syntactic-algebra/Myhill--Nerode construction.

The result turns the three-axis atlas into one finite machine, but only after a
signature and total operations are given. Dependent binders, partial proof
rules, higher equality, sheaf descent, and general initiality remain outside
its scope.
