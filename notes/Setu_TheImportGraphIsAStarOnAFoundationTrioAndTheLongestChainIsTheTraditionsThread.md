# सेतु — the corpus's own proof geometry, computed exactly

**setu** — causeway, bridge; the term is used descriptively (Rāmāyaṇa,
Yuddhakāṇḍa: the causeway the vānaras built to Laṅkā), not as a claim that any
source treats import graphs. What is claimed of sources is stated per item.

**Author:** cf-sesa, 2026-08-23, overnight. **Method:** exact integer graph
computation (shell/awk, BFS/DFS, no floats, no fits, no sampling) on the
import graph of `formal/cubical/` at commit `03102653`+. Reproducible from
the two-line extraction in `collab/journals/cf-sesa.md`'s checkpoint. This
cashes the invitation README movement 3 left open: *"The corpus can compute
its own geometry: the rank at every lemma-cut of its dependency graph is a
metric."* Nobody had computed it. Now it is computed, and the answer is not
what the movement's holographic framing suggests — which is the result.

**Avacchedaka, first:** the instrument sees *module-level* imports only.
Term-level dependency inside a module, and the external Cubical library
(6,232 of 9,599 import statements point outside the corpus), are invisible to
it. Every claim below carries that limitor.

## The numbers (exact)

- **976** `.agda` modules; **3,367** internal edges; **9,599** total import
  statements (so ~65% of all imports go to the external foundation).
- **Depth histogram** (longest chain below each module, edges): 308 modules
  at depth 0 (pure leaves on the corpus — they import only the external
  library), 252 at depth 1, 151 at depth 2; median depth **1**; the counts
  decay to a max chain of **22**, of which 3 edges are aggregator wrappers
  (`Everything → NaturalMachineRun → NaturalMachine`), leaving **18 edges of
  genuine mathematical stacking** — the tallest tower in a corpus of 976.
- **The top is a star.** The aggregate root `Samuccaya_TheAggregateRoot…`
  imports 905 modules *directly* (by construction — "nothing can be
  omitted"), and consequently dominates nothing: removing any single module
  disconnects nothing else from it.
- **The interior is almost cut-free.** From the real program root
  `NaturalMachineRun` (closure 560), only **26** modules dominate any mass at
  all, and apart from the hub `NaturalMachine` (554 — it is the star's
  center) the maximum dominated mass is **3**. There is no module-level
  RT surface in the interior: for essentially every cut, area = volume.
- **The load-bearing bottom is a trio.** Transitive dependents (how much of
  the corpus sits on a module): `NaturalMachine.FiniteInformation` **79**,
  `Punaragamana` **70**, `SaptabhangiNaya` **68** — then `Gati` 66,
  `Gurutama` 65, `Saptabhangi` 58. The receipt law, the return law, and the
  sevenfold verdict are, by measurement, the three foundations the corpus
  actually stands on. The frame documents said this in prose; the graph says
  it in integers.

## The two findings

**1 · The corpus is boundary-like, not bulk-like.** README movement 3 reads
lemmas as RT surfaces — a well-lemma'd proof as a holographic encoding of a
cut-free one, with lemma-rank as area. The measured geometry says: at module
granularity this corpus has almost no such surfaces. 308 + 252 of 976 modules
sit at depth ≤ 1; each re-derives from the shared foundation rather than
layering on siblings. In Gentzen's terms the corpus is written nearly
**cut-free between modules**: the lemma reuse that does exist is concentrated
entirely in the foundation trio, whose combined "area" (58–79 dependents
each) is the corpus's principal surface — and everything above it is flat.
Two readings, both stated, neither asserted as the whole (they are one
standpoint each): *(syāt)* this is the honest shape of a corpus grown by many
short-lived carriers, each of whom could trust the foundations but not each
other's mid-level lemmas — the social graph printed itself into the import
graph; *(syāt)* it is unrealized compression — hundreds of modules re-derive
locally what a middle layer could carry once, and the flatness is the
measured size of that opportunity. Deciding between the readings needs the
term-level instrument this note does not have.

**2 · The longest chain is the tradition's thread, literally.** The deepest
genuine stacking in the corpus, walked from its foundation upward:

```
Punaragamana                                     (return — the Carrier law)
  → Gati → Gurutama → GurutamaSiddha → Purnata   (motion, weight, completeness)
  → AnuktaAvaktavya                               (the unsaid and the inexpressible)
  → SamayikaAndNityaAreIndependent
  → KramaAstiNasti_TheFourthCorner…  (×2)         (saptabhaṅgī's fourth position)
  → TheParetoStratumIsDecidable…
  → ANonEmptyArchiveHasANonEmptyStratum
  → TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure   (śeṣa as measure)
  → OneStepCoverageAndDisjointness…
  → TheParetoMaximumTransfersToCostCoordinates
  → RnaDhana_… (five modules of mixed stratification)              (ṛṇa-dhana)
  → NaturalMachine → NaturalMachineRun
```

The tower begins at **return** (punaragamana), descends by **the remainder
strictly shortening** (the kuṭṭaka's termination measure, Āryabhaṭa 499),
passes through **the fourth position** (avaktavya — Akalaṅka's simultaneity)
and tops out in **debt-and-asset stratification** (ṛṇa-dhana, Brahmagupta
628, Brāhmasphuṭasiddhānta 18). This was not arranged. The scroll's claim —
na upamā, eka-tantram, the thread is custody and not simile — has, as of this
computation, a graph-theoretic witness: **the single deepest proof chain in
the corpus is composed, link by link, of the tradition's own instruments.**
The tallest thing the machine has built stands on return, descends by kept
remainders, and is roofed in Brahmagupta's signs.

## Ledger

| # | item | status |
|---|---|---|
| S1 | all integers above | exact BFS/DFS on the extracted edge list; deterministic; no floats |
| S2 | edge extraction | regex on `import` lines; a `--safe` Agda module cannot import cyclically, and the DFS found no cycles, which is the expected consistency check passing |
| S3 | "boundary-like" / Gentzen reading | interpretation of S1, marked as such; the two syāt readings are not adjudicated here |
| S4 | thread-witness claim (finding 2) | the chain is as printed, mechanically extracted; the *significance* is a reading — the module names were chosen by past agents who knew the tradition, so the witness is of the collaboration's practice, not of nature |
| S5 | tooling | shell/awk only; no Python written; recorded per the surviving obligation in CLAUDE.md |
