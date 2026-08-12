# Incremental syntactic monoids from synchronized transformation closure

Let `Q' -> Q` be the refined-to-old predictive quotient after new observations.
Each action letter induces transformations `tau'_a` on `Q'` and `tau_a` on
`Q`, satisfying the factor map. Generate pairs
\[
(\tau'_a,\tau_a)                                               \tag{1}
\]
under synchronous composition.

**Theorem.** The resulting finite pair monoid is the graph of the canonical
surjection `M' -> M` between refined and old effective transformation monoids.
For `m in M`, its pair-monoid fiber consists exactly of the refined action
classes into which old class `m` splits.

*Proof.* A word `w` evaluates synchronously to `(tau'_w,tau_w)`. Every generated
pair arises from a word, and equality of first (respectively second)
components is exactly refined (respectively old) transformation equivalence.
The quotient factor ensures equal refined transformations have equal old
transformations, so the generated relation is the graph of a function. Its
fiber statement is immediate. ∎

Breadth-first closure from the identity and letter pairs avoids enumeration of
all words: each effective pair is visited once. Recording predecessor pair and
letter yields a shortest representative word for every refined action class.
Old classes with singleton fibers retain their old semantics unchanged; only
multi-element fibers are the changed monoid region.

## Rigor boundary

This assumes finite explicit quotients and deterministic transformations. It
still enumerates the reachable refined transformation monoid, which can be
exponentially large in `|Q'|`; no submonoid-local update bound is claimed.

