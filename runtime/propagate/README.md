> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/propagate` — L4, incremental consequence propagation

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

Implements CRYSTAL.md §2 **L4**:

> When a fact changes, the runtime computes the exact dependency cone: which
> constructions depend on it, which consequences survive through an independent
> proof, which caches are invalid, which routes shortened. Nothing rereads the
> library.

**This file is a contract**, in the same sense as `kernel/README.md`. Callers
code against the signatures and the guarantees below.

```
cone       (indices)    forward + reverse, the exact cone, transitive support
  ↓
invalidate (decision)   survival by homotopy class, stale vs dead, obligations
  ↓
recompute  (mutation)   apply the plan, re-execute only the invalid, routes
```

`cone` imports only `kernel.term`. `invalidate` imports `kernel.egraph`'s
**quotient machinery** — `ClassEnumeration`, `merge_multisets`, `multiset_key`,
`IncompleteEnumeration` — plus `kernel.bounded`, the bounded-search discipline
it shares with `egraph.explanation_classes` (§7 C1), and nothing else. L4 never touches the checker and
cannot make anything true.

```python
import sys; sys.path.insert(0, "<repo root>")
from runtime.propagate import (DependencyGraph, Fact, Derivation, Obligation,
                               invalidate, apply, route_table, route_delta)
```

---

## 0. The one identification that matters

**L4's survival rule and L2's explanation semantics are the same mechanism.**

`kernel/egraph.py` answers "how many genuinely different proofs are there that
`a = b`?" by quotienting justification *paths* by their axiom multiset.
`propagate/invalidate.py` answers "does this theorem survive losing that fact?"
by quotienting justification *trees* by their leaf multiset and asking whether
any class avoids the fact. Same canonical form, same guarded result type, same
refusal to answer from a partial enumeration:

> **A consequence dies only when every homotopy class of its justification
> passes through the retracted fact.**

That sentence is not a summary of the code; it is the code
(`invalidate.survival`). If the class enumeration is incomplete *and* no
surviving class was found, the verdict is `UNDECIDED`, not a guess — and
`recompute.apply` refuses to act on a plan containing one. A guess here would
be `STATUS.md` failure mode #1 wearing a new hat.

---

## 1. The homotopy semantics, stated

Two justification trees for the same consequence are **equivalent** when one can
be turned into the other by moves the kernel can perform with no mathematical
input: reassociating transitivity, commuting congruence with its arguments,
inserting or deleting a computation step, re-routing through a different
intermediate lemma. The invariant of that move set is the **multiset of
primitive facts consumed**.

| level | path/tree is | atoms are | reassociation is |
|---|---|---|---|
| L2 (`egraph`) | a simple path in the justification graph | `Axiom`, `Instantiate`, `Certificate` witnesses | congruence, symmetry, transitivity, `Beta`, `Refl` |
| L4 (`propagate`) | a derivation tree | primitive `Fact`s at the leaves | choice of intermediate derived facts |

At L2, `Refl` and `Beta` are **structural**: given two terms the kernel decides
them itself, with no choice to make, so they are as free as an associativity
move and contribute no atom. `Axiom` and `Instantiate` are the caller's
mathematical input and cannot be manufactured, so they are atoms. That is the
whole of the semantics, and it is what makes the two demo cases come out `2`
and `1`:

* **two independent axioms** merging the same pair → **2 classes**. Different
  multisets, genuinely different transports, and `CRYSTAL.md` §2 L1 requires
  both to survive.
* **the naturality square of β against congruence** — `(λx.x)a = (λx.x)b` by
  congruence, or by β then the axiom then β — → **2 raw paths, 1 class**. Both
  consume exactly one axiom; one of them is the other, reassociated.

Multiplicity is kept (a *multi*set): a proof that invokes an axiom twice is not
the same proof as one that invokes it once.

### What this notion does *not* claim

It is a quotient by *kernel-decidable* reassociation, not by provable
equivalence. Two axioms that happen to be interderivable still give two classes
— correctly: they are two hypotheses, and retracting one leaves the other. The
quotient is coarse enough to kill presentation noise and fine enough to keep
every genuinely independent reason. Those are the only two properties the L4
survival rule needs, and each has a planted-false control in the suite
(over-merging and over-splitting are both tested for).

---

## 2. API

### `cone.py`

| call | returns | notes |
|---|---|---|
| `Fact(fid, statement="", value=None)` | | `.atom()` is `("fact", fid)` |
| `Derivation(did, conclusion, premises, cost, rule="", compute=None)` | | `cost` must be an exact `int`; `compute: {fid: value} -> value` must be pure |
| `g.add_fact(f)` / `g.add_derivation(d)` | id | maintains **both** indices |
| `g.uses(fid)` | derivations consuming it | O(1) — the forward index |
| `g.produced_by(fid)` | derivations concluding it | O(1) — the reverse index |
| `g.forward_cone(fid)` | `Cone` | BFS over the forward index only |
| `g.support(fid)` | `frozenset` | transitive, memoised — decides *cache* validity |
| `g.is_live_fact(fid)` / `g.is_live_derivation(did)` | `bool` | the post-mutation fixpoint |
| `g.build()` | `int` | full evaluation, exact cost |
| `g.value(fid)` / `g.cache_entry(fid)` / `g.cache_snapshot()` | | snapshot is for **identity** comparison |
| `g.total_cost()` | `int` | price of rebuilding everything |
| `brute_force_dependents(g, fid)` | `frozenset` | **the slow oracle**; tests only |

`Cone` fields: `seed`, `facts`, `derivations`, `steps`, `total_facts`,
`total_derivations`, `.size`, `.render()`.

### `invalidate.py`

| call | returns |
|---|---|
| `justification_classes(g, fid, max_paths=, max_depth=, max_classes=)` | `ClassEnumeration` of `DerivationClass` — **iterative deepening; a depth bound prunes a branch, never the search** (§7 C1) |
| `survival(g, fid, retracted)` | `Survival` — `.status ∈ {SURVIVES, DIES, UNDECIDED}` |
| `invalidate(g, fid, obligations=())` | `Invalidation` — the whole plan, **pure** |
| `classify_obligations(g, obligations, survivals)` | `ObligationVerdict`s |

`Invalidation`: `cone`, `survives`, `dies`, `undecided`, `stale_caches`,
`dead_caches`, `dead_derivations`, `survivals`, `obligations`, `steps`.

`Survival.alive` **raises** `IncompleteEnumeration` on an `UNDECIDED` verdict:
there is no boolean answer to give, so none is given.

`DerivationClass.representative` is the class's **smallest** justification tree
(fewest derivations, ties broken by the derivation-id sequence), matching
`kernel/README.md` C3. `members` is unchanged.

### `recompute.py`

| call | returns |
|---|---|
| `apply(g, plan)` | `RecomputeReport` — performs the retraction and repairs the cache |
| `route_table(g, targets)` | `{fid: Route}` — class count and shortest class |
| `route_delta(before, after)` | `RouteDelta`s: `shortened` / `lengthened` / `vanished` / `appeared` / `narrowed` / `widened` / `unchanged` |
| `intact_cache_ids(g, plan)` | **verification only**, O(library) |
| `verify_untouched(snapshot, g, outside)` | `(ok, offenders)` — `is`, not `==` |
| `verify_no_stale_reuse(g, plan, snapshot)` | `(ok, offenders)` |

---

## 3. Guarantees

1. **Nothing rereads the library.** `forward_cone`, `invalidate` and `apply` are
   O(cone), not O(facts). The null control measures it: retracting an unused
   fact costs **1** L4 step against **344** for a load-bearing one.
2. **The cone is exact.** Not conservative, not approximate: it equals
   `brute_force_dependents`, asserted for five different seeds.
3. **Survival is complete or it is `UNDECIDED`.** Never a guess, never a subset.
4. **Locality is object identity.** Every cache entry outside the cone is the
   *same object* afterwards. Equal values prove nothing — a full rebuild also
   produces equal values, which is exactly the failure this layer exists to
   avoid. `verify_untouched` compares with `is`, and the suite plants an
   equal-but-rebuilt entry to prove the check can fail.
5. **Survival and validity are never conflated.** A theorem can survive while
   its cached value is garbage, because the value was computed along the dead
   route. `stale_caches` is exactly that set, and `verify_no_stale_reuse`
   detects a recomputation that silently kept one.
6. **Deciding does not mutate.** `invalidate` is pure; `apply` is the only
   mutation, and it takes the decision as its plan.
7. **Only primitive facts are retractable.** A derived fact is a consequence,
   not a hypothesis; retracting it is a category error and is refused.

---

## 4. The numbers (from `runtime/demo/propagate_demo.py`)

Library: **45 facts, 21 derivations**, full build **280** exact steps.

| claim | number |
|---|---|
| cone of `P00` | **7 / 45 facts (15%)**, 6 / 21 derivations, **13 index lookups**; 38 facts never looked at |
| cone exactness | exact match against a full reread |
| survival | `THEOREM_A` **SURVIVES** (1 of its 2 classes avoids `P00`); `THEOREM_B` **DIES** (its 1 class contains `P00`) |
| incrementality | recompute **42** steps vs full rebuild **226** — **81% of the rebuild avoided**, 2 derivations re-executed, 5 dropped, 38 untouched |
| null control | retract `ISOLATED`: cone **1/45**, **1** L4 step, **0** recomputation cost, all 44 other cache entries `is`-identical |
| locality | 38/38 outside-cone cache entries `is`-identical |
| routes | `THEOREM_B`, `REPORT` **vanish**; `THEOREM_A`, `COROLLARY` **narrow** 2→1 class at unchanged length 12; after a crystallised shortcut lemma both **shorten** 12→6 |
| obligations | O1 **discharged**, O2 **irrelevant**, O3 **unchanged**, O4 **sharper** (`{P00,P12}` → `{P12}`) |

The null control is the part that matters: a propagation engine that dirtied
something there would be measuring its own cache rather than the mathematics,
which `CRYSTAL.md` §0 rules out explicitly.

---

## 5. Testing

`python3 runtime/tests/test_propagate.py` — **19 capability tests and 13
planted-false controls (32 total)**; exits nonzero on any failure. The controls are the
three the design is most likely to get wrong, plus the ones that guard the
guarantees:

* a consequence *claimed* to survive whose every justification routes through
  the retracted fact (`THEOREM_B`) — the verdict must be `DIES`, and the class
  inventory is exhibited as the constructive falsification;
* a cone that omits a genuine dependent (direct dependents only) — the oracle
  must expose it, and the real cone must not be exposed;
* a "clean" recomputation that silently reuses an invalidated cache — the
  pre-retraction entry is reinstalled and must be flagged;
* an equal-but-rebuilt cache outside the cone — `==` passes, `is` must fail;
* a caller that ignores the `Incomplete` marker — `len`, iteration, `.classes`
  and `== ()` must all raise;
* two independent axioms must not collapse to one class (over-merging), and two
  reassociations must not count as two proofs (over-splitting);
* a plan built on an `UNDECIDED` survival must not be applied;
* a retracted fact must justify nothing afterwards;
* a derived fact must not be retractable;
* a bounded tree enumeration that found *some* classes must not call itself
  complete (`x_l4_depth_pruned_not_complete`), while an unbounded run on the
  same graph must still be able to.

**Mutation-tested**, per the norm the kernel set: 12 deliberate defects were
injected into copies — β counted as an axiom, axioms counted as nothing,
incomplete enumerations reported complete, congruence dropping its arguments'
axioms, the cone truncated to direct dependents, survival redefined as "has any
justification at all", stale caches reused, everything in the cone declared
intact, `route_table` trusting a partial enumeration, derived facts made
retractable, dead facts justifying themselves, and `_evaluate` keeping the old
cache object. **All 12 die.** A green suite that has not been mutation-tested is
an untested suite.

---

## 6. Not implemented (designed, not built)

* **Assertion is not symmetric with retraction.** `route_delta` reads a
  shortening correctly when a lemma is installed, but there is no
  `assert_fact` that incrementally *extends* the cache; the demo installs the
  lemma and re-queries. Incremental forward propagation of an addition is the
  obvious next piece.
* **Derivation-level retraction** is expressible in the class inventory
  (`DerivationClass.members` carries every tree's derivation ids) but has no
  API of its own; only primitive-fact retraction is exposed.
* **No cost vectors.** `Derivation.cost` is one scalar. CRYSTAL §L3 wants a
  nondominated frontier; `chosen_derivation` picks the cheapest and breaks ties
  by insertion order.
* **Obligations are declarative.** An `Obligation` is a caller-supplied record;
  nothing checks that its `owes` set is the true remaining gap.
* **No persistence.** The graph is in memory; there is no on-disk index, so
  "nothing rereads the library" is a statement about algorithmic access, not
  about I/O.

### What breaks first at scale

0. ~~**The derivation-tree walk aborts globally on `max_depth`, exactly as
   `egraph.py` used to.**~~ **FIXED** — see §7 C1. It now prunes the branch and
   backtracks, with rounds shortest-first over an admissible minimum-height
   bound.
1. **Class enumeration is exponential, and honestly so.** Six links with three
   parallel axioms each is `3⁶ = 729` genuinely distinct classes — the demo
   computes all of them. The blow-up is in the mathematics, not the algorithm:
   those really are 729 different transports. What used to break was the
   *honesty* (a silent subset); what still breaks is the *cost*. With a bound
   set, the answer is an explicit `INCOMPLETE`, and `survival` degrades to
   `UNDECIDED` rather than to a wrong verdict.
2. **`justification_classes` materialises the cartesian product** of premise
   classes before bucketing them. A fact with 8 premises each having 10 classes
   builds 10⁸ tuples before a single one is quotiented. Bucketing incrementally
   per premise (fold the quotient into the product) is the fix and is not done.
3. **`survival` is recomputed per cone member.** The cone's own facts share most
   of their sub-derivations, and nothing is memoised across members, so
   `invalidate` is O(cone × classes) where it could be O(classes).
4. **`support` is memoised but cleared wholesale** on every mutation. A library
   under continuous edit recomputes all of it.
5. **The kernel's own limits still bind**: `explanation_classes` inherits the
   e-graph's DFS recursion depth (`STATUS.md` #5) and, on a heavily shared atom,
   the retraction cone width (`STATUS.md` #3). L4's cone is exact over the
   *fact* graph; it does not repair the *term* graph's sharing problem.
6. **Iterative deepening re-explores.** Each round re-expands the trees it
   already saw and re-records only the ones of exactly that height. On a graph
   whose justification heights are uniform — the demo's, and the reason its
   counters did not move — the loop runs once and costs nothing extra. On a
   graph with a wide spread of tree heights it runs once per height and the
   work multiplies by that spread. `expand` is not memoised across rounds; it
   could be, keyed on `(fact, remaining height)`, and is not.

---

## 7. Contract changes

This section exists because other lanes code against this file, and a silently
edited document is indistinguishable from a document that was always right.

| # | when | symbol | was | is | why |
|---|---|---|---|---|---|
| C1 | repair lane | `invalidate.justification_classes` | on reaching `max_depth` the tree walk set a **global** stop flag and returned no trees at all: one justification chain deeper than the bound ended the whole enumeration. A consequence with a short, independent, *surviving* justification behind that chain therefore produced **zero** classes, `survival` degraded to `UNDECIDED`, and `recompute.apply` refuses to act on an `UNDECIDED` plan — so a theorem that plainly survived could not be said to | the depth bound **prunes that derivation branch and backtracks**; rounds go shortest-first (iterative deepening from `min_height(fid)` upward, cutting a branch only when `depth + min_height` provably overruns the round) | Filed by the repair lane against itself in `STATUS.md`: "`propagate/invalidate.py`'s derivation-tree walk still aborts globally on `max_depth` exactly as `egraph.py` used to, and wants the same repair." It is the same defect as `kernel/README.md` C2 and it now runs the same code (`kernel/bounded.py`). Measured on a 60-link chain hiding a 2-fact survivor: **0 classes / `UNDECIDED` → 1 class of size 2 / `SURVIVES`**. Honesty is unchanged: the run still reports `complete=False` with the pruned-branch count in `reason`. Pinned by `B10`, `B11` and the control `x_l4_depth_pruned_not_complete`. |
| C2 | repair lane | the `max_paths` premise-product bound | overrunning it set the same global stop flag | it **truncates that derivation and keeps its siblings**, and is reported *as a width bound*, with its own reason string, not as a depth problem | A deeper round cannot recover a product that was too wide, so reporting it as `max_depth` would have been a wrong diagnosis. `SearchLedger` tracks depth pruning and width truncation separately for exactly this reason. |
| C3 | repair lane | `DerivationClass.representative` | the tree with the lexicographically smallest derivation-id sequence | the **smallest** tree (fewest derivations), ties broken by that same sequence | Parity with `kernel/README.md` C3: the representative is what a caller reads as "the proof". `members` is unchanged. |

**No published number moved.** `runtime/demo/propagate_demo.py`'s output is
**byte-identical** before and after — including `344` L4 steps for the `P00`
retraction against `1` for the null control, `class.expand=119` and
`index.reverse=251`. The demo's library has uniform justification height, so the
deepening loop runs exactly one round and the admissible bound prunes nothing.
