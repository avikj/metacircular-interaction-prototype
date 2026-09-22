# Mathematical Wiki — Canonical Build Specification

**Architecture:** The [Bend2  Unison handoff](BEND2_UNISON_READING_AND_SYNTHESIS.md) records the computational direction. The target is a mathematical codebase centered on checked cubical Bend2 constructions executed on the full HVM4 runtime, with content addressing, normal-form sharing, witnessed relations, and Unison-like codebase behavior. Agda remains source/provenance where the corpus is being ported; the site is a hypertext view of the live computational system.

## Goal
Build a public mathematical wiki around this repository. `research/pratt/PRATT_PLATE_V2.md` is the initial front page. The site is a typed mathematical graph, not ordinary documentation or a topic tree. Pages correspond to mathematical objects, constructions, theorem-complexes, restrictions, carriers, or executable realizations; links encode mathematical relations.

## Rules
- Standard background normally routes to Wikipedia/nLab/SEP/textbooks.
- Internal pages exist for project-specific constructions, exact identities, equivalences, restrictions, completions, theorem complexes, carriers, counterexamples, executable realizations, and significant historical correspondences.
- Names are not pages: preserve vocabulary as aliases; merge genuine mathematical identities.
- Every canonical mathematical page eventually has one canonical Agda construction/file covering the entirety of that page's mathematical content.
- New equivalences may merge existing nodes; this is desired.

## Typed edges
`identical-to`, `near-identical-to`, `equivalent-to`, `univalent-to`, `dual-to`, `restriction-of`, `truncation-of`, `projection-of`, `quotient-of`, `pullback-of`, `classified-by`, `specialization-of`, `generalizes`, `refines`, `composes-with`, `transports-to`, `implemented-by`, `realized-by`, `implies`, `corollary-of`, `prerequisite-of`, `counterexample-to`, `historically-anticipated-by`, `historical-presentation-of`, `computational-realization-of`, `physical-realization-of`, `observational-shadow-of`, `finite-shadow-of`, `set-level-shadow-of`, `propositional-shadow-of`, `carrier-for`.

## Current nuclei
Universal classifier; Forced lossless completion; Composite residual; Observation/descent; Cubical composition; Univalent transport; Coinductive completion; Dependent interaction/ISC; Metacircular installation; Locality/causal modulus; Interaction geodesic; Braid/noncommutation; Phase/character quotient; Z/4 global invariant/symmetry; Interaction-net realization; Nonfactorization/interdependence.

## Build sequence
0. Preserve plan in this specification.
1. Normalize page graph: canonical IDs, aliases, anchors, identity/near-identity clusters.
2. Identify typed relations among every surviving canonical page.
3. Assign/create one canonical Agda construction per mathematical page.
4. Concurrently install/refine Pratt front page and site/graph infrastructure.
5. Heavy concurrent page construction by nuclei, carriers, and historical programs.
6. Integrate canonical Agda and Bend/HVM executable/source views; mechanically surface checked/derived/conjectural status.
7. Finish search, graph navigation, equation rendering, aliases/redirects, external references, responsive UI, CI, build and deployment; then web agents can maintain/expand under this ontology.

## Worker rule
Workers never duplicate prerequisite exposition: hyperlink canonical prerequisite pages. If workers discover identical mathematics, merge canonical nodes and preserve vocabulary as aliases. Prioritize dynamically by graph centrality and reader paths. Front page, schema, Pratt branch, core nuclei, runtime, physics, arithmetic, language/HCI can proceed concurrently.

## Success criterion
The wiki behaves like the mathematics: many apparent topics collapse onto a small number of exact constructions; equivalences merge presentations without deleting vocabulary; restrictions expose historical theories; carriers expose physics/arithmetic/language/etc.; every mathematical claim bottoms out in a canonical checked construction.
