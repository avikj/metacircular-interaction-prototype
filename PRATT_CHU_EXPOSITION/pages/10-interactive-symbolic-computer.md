# The Interactive Symbolic Computer

The preceding pages describe running computational structure, not a proposed semantics awaiting an implementation layer.

The core object is `ISC(w) = Π q : Q(w), Σ w' , Σ o , E(w,q,w',o) × ISC(w')`. A reaction returns the successor world, dependent observation, proof-relevant event/residual, and continuation in one result. If the query type is contractible, this reduces to ordinary autonomous orbit. If queries genuinely differ, continuation can differ with them. Interaction is therefore primitive rather than an outer loop around a transition function.

The lossless law determines what a visible computation must retain; univalence makes established equivalence executable transport; coinduction retains productive continuation; metacircular installation allows a transformation produced by interaction to become a subsequent operation. Together these give Lossless Interdependent Type Theory: the algorithm, mathematical object, proof structure, execution trace, and changing type structure are not maintained as independent semantic universes.

Self-presentation and intrinsic rewrite close the lifecycle. A retained derivation is not dead history: when it establishes a transformation, that transformation can be installed and re-enter execution. Productive propagation preserves the continuing object rather than exporting a patch to an external learner/compiler.

The Bend2/HVM4 convergence realizes the local interaction model. Cubical operations—paths, dependent paths, composition, coercion, homogeneous composition, Glue/univalence—are brought into an interaction-net runtime whose primitive work is local active-pair reduction with native sharing/superposition and parallelism. Runtime types and paths are therefore part of the interaction object rather than compile-time annotations erased before execution.

This is the Parallel Univalent Superposition Computer reading: correlated higher-order reduction, unfinished programs, runtime type/path structure, and shared reductions all inhabit the same execution fabric. The native cost semantics counts actual primitive interactions, allowing the exact geodesic results of [Interaction Geometry Becomes Physics](09-interaction-geometry-physics.md) to be statements about computation rather than metaphors imported from geometry.

For Pratt this closes the loop from symbolic action logic, process geometry, Chu interaction, types-as-processes, transformational mathematics, and coalgebra to an executable symbolic computer. The mathematical presentation and the technology are two coordinates on the same object.

## Canonical checked construction

ISC/orbit: [`Samvada...agda`](../../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda). Carrier/transport: [`Nucleus.agda`](../../fibre/src/Fibre/Nucleus.agda). Lifecycle: [`LIFECYCLE.rst`](../../LIFECYCLE.rst). Runtime convergence: [`collab/bend2-interactive-cubical/CONVERGENCE.md`](../../collab/bend2-interactive-cubical/CONVERGENCE.md).

## External coordinates

[interaction nets](https://en.wikipedia.org/wiki/Interaction_nets), [Bend](https://github.com/HigherOrderCO/Bend), [HVM](https://github.com/HigherOrderCO/HVM).
