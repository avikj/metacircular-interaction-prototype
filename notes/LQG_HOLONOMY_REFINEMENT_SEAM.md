# LQG holonomy/refinement seam

**Status:** checked finite kinematic analogue; not full loop quantum gravity.

The executable object is
[`RelationalHolonomyRefinement.agda`](../formal/cubical/NaturalMachine/RelationalHolonomyRefinement.agda).
For an arbitrary group `G`, it compares one oriented edge labelled by `g : G`
with its subdivision into two edges `(a,b)` whose composite holonomy is `b·a`.
Gauge transformation at the inserted vertex acts by

\[
  (a,b) \longmapsto (h a, b h^{-1}).
\]

The composite is invariant.  Cubical Agda then forms the set quotient by the
generated gauge paths and proves an equivalence

\[
  (G\times G)/(\text{internal gauge}) \simeq G.
\]

Univalence turns this equivalence into a path of state spaces, and the checked
transport computation sends a refined gauge class to exactly `b·a`.  Endpoint
gauge remains covariant:

\[
  g \longmapsto t g s^{-1}.
\]

When source and target coincide this is conjugation, so every declared class
function gives a gauge-invariant closed-loop observation.

## Why this is LQG-adjacent

Holonomies are native variables in non-perturbative connection formulations;
Ashtekar and Isham construct the quantum holonomy algebra and its
representations in
[Representations of the holonomy algebras of gravity and non-Abelian gauge
theories](https://arxiv.org/abs/hep-th/9202053).  Rovelli and Smolin introduce
spin-network states as a basis for non-perturbative quantum gravity in
[Spin Networks and Quantum Gravity](https://arxiv.org/abs/gr-qc/9505006).
Ashtekar and Bianchi's
[A Short Review of Loop Quantum Gravity](https://arxiv.org/abs/2104.04394)
places this holonomy/spin-network kinematics within the larger LQG program.

Those sources motivate the seam; the Agda proof establishes only the finite
group-theoretic statement written above.

## Rigor boundary

Checked here:

- composition of two edge holonomies;
- cancellation of an internal gauge transformation;
- a higher-inductive quotient whose paths encode that gauge identification;
- equivalence and univalent identity between the quotient-refined and coarse
  state spaces;
- computation of transport along that identity;
- endpoint gauge covariance and conjugation-invariant loop observation.

Absent, and not implied:

- the gauge group `SU(2)` as a Lie group;
- Haar measure or the Ashtekar–Lewandowski Hilbert space;
- representation labels, intertwiners, or spin-network amplitudes;
- holonomy–flux commutation relations;
- area and volume operators;
- Gauss, diffeomorphism, or Hamiltonian constraints;
- spin foams, continuum limits, semiclassical recovery, or empirical quantum
  gravity predictions.

The next honest extension is a finite representation-labelled graph with
intertwiner-valued vertices and a proved refinement map.  Dynamics should enter
only after its constraint or amplitude law is itself formalized.

## First abstract spin-network extension

That first extension now exists in
[`AbstractSpinNetworkKinematics.agda`](../formal/cubical/NaturalMachine/AbstractSpinNetworkKinematics.agda).
It deliberately uses “representation” only in the minimal mathematically
earned sense of a group action on a set.  A bivalent vertex is an equivariant
map between two such actions; its equivariance equation is the local gauge
square.  The checked module supplies identity and composite intertwiners,
pointwise unit and associativity laws, insertion and contraction of an identity
vertex, preservation of every observation of the underlying map under that
canonical refinement, and agreement between composite holonomy action and
sequential edge action.

This is less than the spin networks of Rovelli–Smolin: there is no linear
carrier, tensor product, irreducible label, or multivalent invariant tensor.
The gap is now typed rather than hidden.  The next extension must introduce a
genuine monoidal representation interface before it may claim trivalent or
higher spin-network vertices.

## Holonomy--flux derivation boundary

[`HolonomyFluxDerivation.agda`](../formal/cubical/NaturalMachine/HolonomyFluxDerivation.agda)
adds the next justified interaction.  A represented group holonomy takes
values in a declared observable carrier, and a declared flux operation must
carry an explicit Leibniz witness.  Agda then proves for a subdivided edge

\[
D\rho(ba)
=
(D\rho(b))\star\rho(a)
\oplus
\rho(b)\star(D\rho(a)),
\]

as well as compatibility of flux evaluation with canonical edge insertion.
The theorem assumes neither commutativity nor unstated ring laws.

This seam is motivated by the role of holonomies and conjugate fluxes as basic
kinematic observables in Lewandowski–Okołów–Sahlmann–Thiemann,
[Uniqueness of diffeomorphism invariant states on holonomy-flux
algebras](https://arxiv.org/abs/gr-qc/0504147), and by the explicit
holonomy-flux representation program described in Okołów–Lewandowski,
[Automorphism covariant representations of the holonomy-flux
*-algebra](https://arxiv.org/abs/gr-qc/0405119).

The checked derivation is not yet either paper's holonomy-flux algebra.  A
faithful next model must supply oriented surfaces, edge/surface intersection
data, the corresponding left/right invariant action, involution and operator
domain structure, and then prove that its concrete action inhabits this
abstract Leibniz interface.

## Iterated refinement and flux coherence

[`IteratedCylindricalConsistency.agda`](../formal/cubical/NaturalMachine/IteratedCylindricalConsistency.agda)
passes the first nontrivial history test.  Three edge labels carry two internal
gauge coordinates.  Quotienting them is equivalent to one coarse holonomy;
univalence makes this a path of state spaces whose transport computes.  The
direct three-to-one universe path equals the staged three-to-two-to-one path by
`uaCompEquiv`.  The two binary contraction orders differ by exactly the group
associator.

[`FluxCylindricalCoherence.agda`](../formal/cubical/NaturalMachine/FluxCylindricalCoherence.agda)
then applies physics at that coherence test.  Flux evaluation is equal along
the direct and staged contractions.  Expanding the derivation in the two
orders produces two differently bracketed three-term expressions, and Agda
proves them equal using only representation multiplicativity, the declared
Leibniz witness, and group associativity.  At this abstraction level there is
therefore no additional flux-coherence defect to postulate.

## Parallel finite-network composition

[`ParallelNetworkComposition.agda`](../formal/cubical/NaturalMachine/ParallelNetworkComposition.agda)
adds disjoint, parallel composition to the checked seam.  It constructs the
cartesian product of two group actions and proves the serial/parallel
interchange law for intertwiners.  Subdividing both components and then
contracting is judgmentally the same map as contracting each component and
then composing them in parallel.  The same construction pairs two abstract
flux derivations and proves that the subdivision law projects to each
component.

This is the first checked move from one path toward a finite network, but its
monoidal product is deliberately only the cartesian product of abstract action
carriers.  It is not the Hilbert-space tensor product used for LQG spin-network
states.  Reaching that claim requires a declared linear/unitary representation
category, tensor products of edge representations, and invariant tensors at
multivalent vertices; none is inferred from the present interchange theorem.
