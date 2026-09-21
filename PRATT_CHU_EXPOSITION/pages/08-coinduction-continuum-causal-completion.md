# Coinduction, Continuum, and Causal Completion

Pratt and Pavlovi's final-coalgebra program treats coinduction as foundational for analysis in deliberate duality with induction for arithmetic. Continuum, Baire space, and Cantor space are approached through final coalgebra; constructiveness and continuity become central questions about how infinite behavior is specified and observed.

The project's coinductive carrier gives this program an interaction-native metric. An orbit unfolds as a head together with another orbit. Finite observation induces prefix agreement `≡ₙ`. A Cauchy chain whose successive stages agree to increasing depth has a corecursively constructed limit, and agreement at every finite depth forces equality/bisimulation. Productive definition and intrinsic completion therefore meet on the same carrier.

Interaction generalizes orbit. The ISC does not have one predetermined successor; it quantifies over the query available at the current world and returns successor, observation, event evidence, and continuation together. When the query type is contractible, ISC restricts back to deterministic orbit. Autonomous dynamics is therefore a restriction of interactive dynamics, not a separate semantic category.

Finite observations split exactly into prefix plus continuation at the actual reached world. This gives a dependent decomposition of long interaction histories rather than an external theorem about memoization. Endpoint-conditioned histories are instances of composite fibres from [the Fibre Law](02-fibre-law.md).

Continuity is also internalized through the causal modulus. One local crossing consumes one unit of lookahead; a word of length `m` consumes at most `m`. The same law simultaneously controls continuity in the prefix topology, causal propagation in time, and information demand. This is the bridge to [State/Event — Time/Information](06-state-event-time-information.md).

Thus final coalgebra, observational topology, productive computation, and causal modulus are not separate layers. The coinductive object comes with its own finite observations and its own exact continuity geometry.

## Canonical checked construction

[`Nucleus.agda`](../../fibre/src/Fibre/Nucleus.agda) for carrier/orbit/transport; [`Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda`](../../fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda) for ISC versus orbit; causal/geodesic theorem ledger in [`PNP_GEODESIC_REDUCTION_20260916.md`](../../research/PNP_GEODESIC_REDUCTION_20260916.md).

## External coordinates

[Vaughan Pratt & Dusko Pavlovi, continuum as final coalgebra](https://scholar.google.com/scholar?q=Pratt+Pavlovic+continuum+final+coalgebra), [coalgebra](https://ncatlab.org/nlab/show/coalgebra), [Baire space](https://en.wikipedia.org/wiki/Baire_space_(set_theory)).
