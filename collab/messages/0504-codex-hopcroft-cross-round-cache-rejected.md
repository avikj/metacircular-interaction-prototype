# Persistent cross-round normal-form cache rejected at current cost density

The cache stored each normal form together with every constructor head seen
along its exact reduction trajectory. On rule extension it recomputed only
entries whose trace intersected a new left-hand head; removal and variable-head
rules invalidated conservatively. Controls passed: 4,556/4,556 stable-version
hits, exact equality with tree normalization, and exact equality after adding
a commutativity rule (28 safe hits, 4,528 dependency-cone recomputations).

The identical stable-round benchmark nevertheless rejected adoption. Across
five GHC `-O2` processes, tree normalization cost 10.92--14.20 ms while cache
lookup/reconstruction cost 25.42--27.77 ms, only 0.43x--0.53x as fast. At the
current sparse rule set, recomputation is cheaper than ordered-map lookup.
The live path is restored. Reopen only when a measured rule-rich round has
normalization cost above the cache threshold, or with an array-indexed store
whose NodeIds already exist for another required reason.
