# Pratt / Chu Exposition

Top-level working locus for the Vaughan Pratt / Chu-spaces exposition and the mathematical website growing from it.

## Front-page sources

- [`CHU_LOSSLESS_INTERACTION.md`](CHU_LOSSLESS_INTERACTION.md) — long mathematical exposition.
- [`PRATT_PLATE_V2.md`](PRATT_PLATE_V2.md) — compressed equation-dense front-page spine.

## First ten canonical pages

1. [Lossless Interdependent Interaction](pages/01-lossless-interdependent-interaction.md)
2. [The Fibre Law — Losslessness Is Forced](pages/02-fibre-law.md)
3. [Chu Spaces Completed](pages/03-chu-spaces-completed.md)
4. [Concurrency Is Geometry](pages/04-concurrency-is-geometry.md)
5. [Action, Logic, and Optimal Inference](pages/05-action-logic-optimal-inference.md)
6. [State / Event — Time / Information](pages/06-state-event-time-information.md)
7. [Types Are Processes — Transformations Are Executable](pages/07-types-processes-transformations.md)
8. [Coinduction, Continuum, and Causal Completion](pages/08-coinduction-continuum-causal-completion.md)
9. [Interaction Geometry Becomes Physics](pages/09-interaction-geometry-physics.md)
10. [The Interactive Symbolic Computer](pages/10-interactive-symbolic-computer.md)

These are deliberately the same pages we would keep if the exposition were permanently limited to ten. Each is a major mathematical object/theorem-complex rather than a documentation category. Internal links already form the first graph; external links route standard background outward rather than duplicating it.

## Canonical construction rule

Every mathematical page ultimately gets one canonical Agda construction covering the entirety of that page's mathematical claims. This first pass links each page to the strongest existing checked source(s). Where the mathematics currently spans several modules, a later consolidation pass will add a single canonical re-export/construction rather than inventing unchecked glue.

## Working rule

Preserve content losslessly, merge only exact identities, keep alternate mature vocabularies as aliases, and let the exposition branch outward from these ten pages. New pages should exist because there is project-specific mathematics to state—not because a standard concept deserves another encyclopedia entry.
