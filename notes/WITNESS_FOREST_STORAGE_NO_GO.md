# Shortest-parent choice cannot change witness-forest storage

Let `V` be the newly split pair set and `Z subset V` the immediate-disagreement
seeds. A one-pointer shortest certificate assigns exactly one outgoing pointer
to every vertex in `V\Z` and one observation label to every seed.

**Proposition.** Every such certificate has exactly `|V|` stored nodes,
`|V|-|Z|` action pointers, and `|Z|` terminal labels. Choosing different
shortest parents cannot change these counts.

*Proof.* The certificate representation has one pre-existing pair node per
element of `V`; by definition each nonseed stores one pointer and each seed one
label. Parent targets affect edges, not cardinalities. ∎

Thus “choose parents to maximize suffix sharing and minimize DAG size” is a
false optimization for this representation: suffix sharing is already total
because pair nodes are canonical and never duplicated.

Parent choice does affect a different exact object: **withdrawal robustness**.
A chosen path commits each pair to one terminal observation label. Different
shortest parents may route it to different labels, changing how many chosen
proofs fail when one observation is removed. Minimizing worst-case or weighted
invalidation is a legitimate optimization, but it is not storage minimization.

## Rigor boundary

This no-go applies to canonical pair-node, one-pointer certificates. Compressed
symbolic representations that merge several pair nodes may have a genuine
storage tradeoff.
