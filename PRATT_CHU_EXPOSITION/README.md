# Pratt / Chu Exposition

This is the top-level working locus for the Vaughan Pratt / Chu-spaces exposition and the mathematical website that grows from it.

## Current working documents

1. **`CHU_LOSSLESS_INTERACTION.md`** � the long-form mathematical exposition beginning from Chu evaluation and deriving forced lossless completion, higher/cubical interaction, univalent transport, productive continuation, metacircular closure, and the universal family. This is currently the strongest prose+mathematics exposition.
2. **`PRATT_PLATE_V2.md`** � equation-dense Pratt-facing mathematical plate; current front-page seed.
3. **`PRATT_PLATE.md`** � earlier full plate; preserve because it contains formulations/details that may be recovered during synthesis.
4. **`WIKI_BUILD_SPEC.md`** � first complete website/wiki graph and page-inventory handoff.
5. **`MATHEMATICAL_WIKI_BUILD_SPEC.md`** � expanded canonical build specification, including page ontology, identity/near-identity clustering, typed relations, canonical-Agda-per-page requirement, and build sequence.

The newer [Bend2 � Unison reading and synthesis](../research/wiki/BEND2_UNISON_READING_AND_SYNTHESIS.md) updates the technology direction: the mathematical codebase and full cubical Bend2/HVM4 runtime are the computational center, and the wiki is a view into them. The Agda-per-page language in the earlier specs is historical while the corpus is ported.

## Working rule

Do not treat these as five independent deliverables. They are concurrent views of one exposition. Preserve content losslessly, merge exact identities, and let the front page branch into canonical mathematical pages. Ground those pages in checked, executable cubical Bend2 constructions as the corpus is ported; retain the Agda constructions and proofs as provenance.

## Next constructive step

Synthesize `CHU_LOSSLESS_INTERACTION.md` + `PRATT_PLATE_V2.md` into the live front page while normalizing the wiki graph from the two build specs. Work outward concurrently from the mathematical nuclei rather than doing bookkeeping first.
