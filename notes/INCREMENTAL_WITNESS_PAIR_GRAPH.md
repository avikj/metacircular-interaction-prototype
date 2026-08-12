# Incremental refinement is reverse reachability in the old pair graph

Let a finite alphabet act deterministically on finite `X`. Assume the old
future-task quotient `Q_O` is known. Add finite observations `N`.

Inside each old block, form the synchronous pair graph with vertices `(x,y)`
where `x~_O y`, and edges
\[
(x,y)\xrightarrow{a}(x\cdot a,y\cdot a).                     \tag{1}
\]
Old equivalence is action-stable, so every edge remains inside one old block.
Let seeds be pairs on which some new observation already differs.

**Theorem.** An old-equivalent pair splits under `O union N` iff it can reach
a seed in the synchronous pair graph. A shortest path label `w` to a seed,
together with the differing new observation there, is a shortest new
distinguishing history.

*Proof.* Reachability by word `w` to a seed means some `n in N` satisfies
`n(xw)!=n(yw)`, exactly new distinguishability. Conversely any distinguishing
word ends at such a seed. Shortest paths give shortest words. ∎

Hence reverse BFS from seeds computes only the changed pair region. Pairs not
reached remain equivalent; connected components of the complement relation
give refined blocks (equivalently group states by equality against all reached
separations). The search space has size `sum_B |B|^2`, over old blocks `B`,
rather than `|X|^2` across unrelated blocks.

Old witnesses between distinct old blocks persist verbatim, since adding
observations never invalidates a distinguishing history. New certificates are
created only for reached within-block pairs.

## Rigor boundary

The theorem assumes a finite deterministic action and explicit old blocks.
The stated pair bound is a search-space bound, not a claim of optimal runtime;
symmetry can halve ordered pairs and specialized minimizers can do better.

