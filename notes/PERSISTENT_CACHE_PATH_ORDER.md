# Persistent path installation forgets order but not marginal history

`CACHE_OPTION_VALUE_NO_GO` proves that equal past scalar totals can conceal
incomparable future cache profiles.  A different scalar question has the
opposite answer.  In the fixed unique-parent trace tree, with persistent
storage and no eviction, the **total** cost of acquiring a fixed finite family
of targets is independent of their order even though the individual marginal
costs need not be.

## Exact setting

Let `T` be a rooted tree and write `P_t` for the non-root vertices on the
unique root-to-`t` path.  A lawful cache `K` is ancestor-closed.  The declared
transition resumes at the deepest cached point of `P_t`, executes the suffix,
and persistently retains every result; call it `Φ_t(K)`.

**Path-union lemma.** For every lawful `K`,

`Phi_t(K) = K union P_t`.

Indeed, ancestor closure makes `K ∩ P_t` an initial segment.  The resume rule
installs exactly its complementary suffix, while vertices already in `K`
remain.  Conversely, unions of root paths are ancestor-closed, so the law is
preserved by every transition from the root cache.

This condition matters.  If an arbitrary cache contains a late path vertex
but omits its ancestor, the resume rule can skip the hole and need not equal
union with the whole path.  Such a cache is outside the fixed-policy reachable
state space used here.

## The order theorem

For targets `s,t`, the path-union lemma gives

`Phi_t(Phi_s(K)) = K union P_s union P_t
                  = Phi_s(Phi_t(K))`.

Therefore every adjacent swap preserves the endpoint, and induction over a
permutation gives:

**Theorem 1 (endpoint order-independence).** If two finite request lists are
permutations of one another, their final persistent caches are equal.

Let one-step cost count newly installed vertices:

`c(K,t) = |P_t \ K|`, so `|K| + c(K,t) = |Phi_t(K)|`.

The identities telescope along any request list `t_1,...,t_r`:

`|K| + sum_i c(K_(i-1),t_i) = |K_r|`.

Combining this with Theorem 1 and cancelling `|K|` proves:

**Theorem 2 (total acquisition order-independence).** The total number of
newly installed trace vertices depends only on `K` and the union of the
requested paths, not on request order or repetition.

`formal/cubical/CachePathOrder.agda` checks the shared algebraic core.  It
specializes the already checked `foldlPermInvariant` theorem from
`ObligatioOrderTrilemma` to Boolean path union, proves idempotence, and proves
the telescoping and cost-order theorems for every natural-valued potential
model satisfying the displayed one-step law.  It also constructs the concrete
finite-inventory instance by counting old and newly installed Boolean
memberships and checks the cardinal-growth law coordinate by coordinate.  For
a duplicate-free inventory this is finite-cache cardinality with
`c(K,t)=|P_t\K|`.

## What remains order-sensitive

For the binary traces

`P_3 = {2,3}` and `P_5 = {2,4,5}`,

starting at `{1}` gives marginal vectors `(2,2)` in the order `(3,5)` and
`(3,1)` in the order `(5,3)`.  Both total four and end at
`{1,2,3,4,5}`.  Thus the theorem does **not** repair the scalar-summary no-go:
a system answering the next request still needs labeled cache incidence, not
only total cost.

The original witness makes the distinction even sharper.  From
`K_5={1,2,4,5}`, requests `(3,4)` cost `(1,0)`; from
`K_6={1,2,3,6}`, they cost `(0,1)`.  Both batches total one, while their
first-request prices disagree.  Batch cost is an endpoint potential; option
value is a labeled future profile.

## Encounter and boundary

The common object is not generic “order”: it is a **commuting idempotent
join action carrying an exact potential cocycle**.  The medieval-obligatio
formalization supplies the permutation theorem for commuting updates; the
cache model supplies union and cardinal growth.  The encounter changes both
readings: history can survive in marginal coordinates while disappearing
from the endpoint, and a commuting update is insufficient for order-free
behavior once a prefix-reading selector chooses which update occurs.

The following hypotheses are load-bearing:

- a fixed unique path for every target;
- ancestor-closed reachable caches;
- persistent storage with no eviction;
- unit cost per newly installed path vertex;
- a fixed request multiset, rather than weighted completion latency.

Alternative proof paths, cache-dependent witness selection, garbage
collection, capacity constraints, or prefix-reading response rules can break
commutation or the potential law.  No theorem about those regimes is claimed.

The commuting-fold lemma is prior local work, and union/cardinality
telescoping is standard.  The contribution is the exact bridge and the
separation between marginal history and batch total in this cache model; no
external novelty is claimed.
