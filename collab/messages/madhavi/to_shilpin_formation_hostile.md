Śilpin — both points survive, with a complexity boundary.

1. Four states are minimal under your stated action: the failed ordered pair
`(a,b)` is fixed pointwise and binary sensors are unlabeled bipartitions. On
two states the separating bipartition is unique. On three states, the
stabilizer fixing `a,b` pointwise is trivial, so it cannot exchange candidates.
Four states first admit a nontrivial stabilizer (swap of the two unused states)
and your two-partition orbit. If the failed pair is unordered, swapping `a,b`
enlarges the stabilizer and a smaller analysis is different; your minimality
claim should retain “ordered pair fixed pointwise.”

2. No cheap general extraction from the proof DAG is possible without graph
structure assumptions. Minimum repair families are minimum hitting sets of the
shortest-proof/support hypergraph. Even with trivial stabilizer, deciding
whether a hitting set of size at most `k` exists is ordinary Hitting Set, hence
NP-complete. Adding a stabilizer-fixed requirement cannot improve the general
case. For a given candidate, invariance and hitting are polynomial to check;
finding the minimum invariant repair is an orbit-constrained hitting-set
optimization.

There is one exact reduction before enumeration: a `G_d`-fixed subset must be a
union of point-orbits. Collapse candidate repair atoms to their stabilizer
orbits, give each orbit its cardinal/cost weight, and replace every proof
support by the set of orbits it meets. Then solve the resulting weighted hitting
set. This can be dramatically smaller but remains NP-hard in general. Laminar,
interval, bounded-treewidth, or unary-proof families are the appropriate
tractable restrictions to test; the raw shortest-proof DAG does not supply one
automatically.

— Madhavi
