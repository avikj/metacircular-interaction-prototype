# Path harvest: mine the route, not only the destination

A result is not fully metabolized when its advertised theorem is proved or
refuted.  The proof route may also contain a more general lemma, an unused
hypothesis, a dual statement, an algorithm, a counterexample family, a new
certificate, or a bridge to an older claim.

This is a standing retrospective pass.  It generates new seeds; it never
promotes their truth status.

## Trigger

Run a harvest when any of the following occurs:

- a claim reaches `formalizing`, `proving`, `breaking`, or a terminal state;
- an exact experiment closes or decisively fails;
- a hostile audit changes a theorem's boundary;
- a prior-art result reclassifies novelty;
- two claims acquire a new shared object or proof ingredient.

The harvester should be a fresh lineage when practical.  It receives the
claim, proof/audit artifacts, and route history, but is instructed to search
for value not already named in the claim.

## Ten harvest moves

1. **Generalize:** what is the strongest theorem actually proved by the same
   argument?
2. **Delete assumptions:** which hypotheses were never used, or can be traded
   for a weaker invariant?
3. **Dualize:** what do reversal, adjunction, Fourier/Mellin transform,
   complement, reciprocity, or local/global exchange produce?
4. **Classify equality and failure:** what are the extremizers, sharpness
   witnesses, or minimal counterexamples?
5. **Extract the route lemma:** which intermediate fact is reusable outside
   the motivating problem?
6. **Compile:** which repeated reasoning can become an exact traditional
   program, certificate checker, SAT instance, or formal lemma?
7. **Transport:** which existing claim becomes shorter or stronger when this
   object is substituted into it?
8. **Quantify information:** what channel/fiber/side-information or stability
   theorem is latent in the proof?
9. **Invert the no-go:** what is the minimal new observable or hypothesis that
   evades the obstruction?
10. **Diff prior art:** does the proof expose a clean corollary not stated in
    the source, or does the source kill an apparent novelty claim?

## Output contract

One JSON manifest lives at `collab/discovery/harvest/R####.json`.  Every seed
must name an exact candidate statement, its evidence, its cheapest test, and a
kill condition.  A zero-seed harvest is allowed only after recording which
moves were attempted and why no additional value survived.

A harvest seed has no authority.  A valuable one becomes a fresh claim ID;
the original claim is not silently enlarged or repaired.

`python3 code/path_harvest.py pending` reports mature claims with no current
harvest.  `python3 code/path_harvest.py validate` checks existing manifests
against the current statement hashes.  This small program is a trigger and
staleness detector, not a mathematical verifier.

## Stopping rule

One focused pass is mandatory; endless association is not.  Stop when every
move has either produced a concrete testable seed or a recorded null result.
Reopen only after a new theorem, audit, computation, or external source changes
the route graph.
