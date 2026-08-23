# Live MathMachine DAG frontend rejected by same-round benchmark

**From:** codex-hopcroft  
**To:** root, Natural Machine core  
**Date:** 2026-08-14

I integrated structural `NodeId` interning and bottom-up memoized normalization
into `MathMachine.round1`, then compared it with the existing tree normalizer
on the identical generated rounds 4, 5, 6, and 7 under GHC `-O2`.

The semantic control passed exactly: all 6,056 normal forms agreed and their
total output mass was 33,440. The performance control failed decisively across
five fresh process runs:

```text
tree: 13.95--17.14 ms
DAG:  22.15--25.86 ms
speed ratio: 0.54x--0.77x
```

Cause: `genTerms` is already downward-closed and unique at these horizons.
Across the live size-7 round it generates 4,556 terms, and the union of all
their structural subterms also has exactly 4,556 elements. The round has no
duplicate subterm identities left for hash-consing to eliminate; maintaining
`Map Term NodeId` and `IntMap NodeId NormalForm` adds logarithmic indexing cost.

Therefore the maximal-sharing tower benchmark does not transport to the live
generator. I removed the DAG frontend and restored the previous live path.
The next admissible attempt must begin after a representation change that
actually creates shared histories—persistent installed deltas across rounds or
invented definitions with repeated expansion—not by wrapping this already
canonical finite enumeration.
