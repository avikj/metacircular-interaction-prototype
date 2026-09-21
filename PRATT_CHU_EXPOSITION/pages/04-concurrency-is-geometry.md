# Concurrency Is Geometry

Pratt's partial strings remove the arbitrary total-order constraint from strings: a string is a linearly ordered pomset, while a concurrent process can retain only the order actually forced between events. His later schedule/automaton duality makes the geometric consequence explicit: a one-dimensional automaton skeleton permits interleaving; true `n`-fold concurrency occupies an `n`-dimensional transition. Nondeterminism is treated through monoidal homotopy.

The project begins where that geometry becomes constructive and executable. Cubical type theory supplies an interval, products `I^n`, dependent paths, composition, filling, and transport. Independent interaction dimensions can therefore be represented as genuine higher cells rather than encoded by an enumeration of sequential schedules. Compatible boundaries can be filled; equivalences of the structured spaces can be internalized by univalence.

The important point is not that âconcurrency resembles cubes.â Pratt already established dimension as the correct home of true concurrency. The completion is that the same cell language also carries computational identity and dependent transport. The geometry is executable.

Order itself then separates into redundant and informative order. When interactions commute, their sequential ordering is presentation redundancy. When they do not commute, order is retained mathematical information. The braid relation gives the coherent noncommuting case: neighboring interactions can satisfy Yangâ“Baxter coherence without collapsing to commutativity. This connects directly to the braid carrier and phase/charge structure in [Interaction Geometry Becomes Physics](09-interaction-geometry-physics.md).

Local interaction also induces a causal geometry. One crossing consumes one unit of lookahead; a word of length `|w|` has modulus `|w|`. The same statement can be read temporally as propagation depth or informationally as required input depth. See [State/Event â” Time/Information](06-state-event-time-information.md) and [Coinduction, Continuum, and Causal Completion](08-coinduction-continuum-causal-completion.md).

At runtime the same local geometry appears in interaction-net reduction rather than being compiled into a separate global scheduler. See [The Interactive Symbolic Computer](10-interactive-symbolic-computer.md).

## Canonical checked construction

Core carrier/transport: [`Nucleus.agda`](../../fibre/src/Fibre/Nucleus.agda). Physics/geodesic theorem ledger: [`research/PNP_GEODESIC_REDUCTION_20260916.md`](../../research/PNP_GEODESIC_REDUCTION_20260916.md). Runtime convergence: [`CONVERGENCE.md`](../../collab/bend2-interactive-cubical/CONVERGENCE.md).

## External coordinates

[Vaughan Pratt, âModeling Concurrency with Geometryâ](https://dl.acm.org/doi/10.1145/99583.99625), [pomset](https://en.wikipedia.org/wiki/Pomset), [higher-dimensional automata](https://ncatlab.org/nlab/show/higher-dimensional+automaton), [cubical type theory](https://arxiv.org/abs/1611.02108).
