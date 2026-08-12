# `runtime/SCALE.md` — what the runtime does when the inputs stop being small

> *"Measured on toy tasks only."* — the standing objection to every number in
> `STATUS.md`.

This file is the repair-and-scale lane's answer to it. It contains **only
measurements**, each one reproducible by a named command, each one an exact
integer from a counter unless it is explicitly labelled wall clock. Where a
prediction made by another lane is tested, the prediction is quoted verbatim
first and the verdict is stated whether or not it flatters the prediction.

Three things are measured here:

1. **§1–§3 The lemma book.** `crystallize/README.md` §6 predicted that at a few
   hundred lemmas the search cost would overtake the step savings. It is right
   that the crossover exists, and **wrong by an order of magnitude about where**
   — it is at **22 lemmas**, not a few hundred. §3 implements the fix that lane
   named (a discrimination net) and re-measures: the crossover moves to 477,
   and **disappears entirely** when the net is built once per book instead of
   once per query.
2. **§4 E-matching.** The compiled automaton against the memoised recursive
   matcher, on the L3 demo and on an AC-saturated graph 20× larger. Verdict:
   **mixed and kept anyway** — 3.1× fewer total lookups, 50% fewer e-match
   visits in the demo's saturation loop, 2.7×–4.7× faster on search-dominated
   patterns, but **3–10% slower on two match-heavy patterns**, which are left in
   the table. Its raw `visits` counter is *higher* on the AC graph, because the
   two engines count different things; §4.4 says so in full rather than burying
   it.
3. **§5 The homotopy-class enumerator**, on the 533-record graph the defect was
   filed against, and **§5.1** the same defect in `propagate/invalidate.py`,
   found by the repair lane, filed, and now fixed by the same code.
4. **§6 The materialisation cliff**: what Pareto extraction over the class DAG
   finds that extraction over stored terms cannot, and which published number
   that moves.

Nothing here is an asymptotic claim. Every row is a measurement at a stated
size, and the largest size measured is stated in each section.

---

## 1. The prediction under test

`runtime/crystallize/README.md` §6, item 1, in full:

> **Lemma matching is a linear scan over positions × book.** Every
> normalisation iteration tries every lemma at every position: `O(|book| ·
> |term|)` match attempts *per step*. The null-control row already shows the
> symptom — +665 work units for one irrelevant lemma. At a few hundred lemmas
> the search cost overtakes the step savings and the headline number becomes a
> lie told with a true counter. Fix: index lemma LHSs by a discrimination net
> or top-symbol/flat-term index so only plausible lemmas are tried. This is the
> first thing that must change.

### Method

`runtime/demo/scale_lemmas.py`. The problem is the crystallize demo's
independent problem P4 — `(x²+3y)(x²−3y) + 9y²` — whose seed-criterion number
is **29 steps → 12 steps** with one mined lemma installed.

The book is grown with mechanically generated lemmas from four families:

| family | statement | why it is here |
|---|---|---|
| `dsq c` | `(#0 + c)·(#0 − c) ⟶ #0² − c²` | the same *shape* as the mined lemma, so the matcher does realistic work before failing |
| `factor c` | `(#0 + #1)·c ⟶ c·#0 + c·#1` | a different root shape |
| `distrib c` | `#0·(#1 + c) ⟶ c·#0 + #0·#1` | a pattern variable at the root's first argument |
| `square c` | `(#0 + c)² ⟶ c² + 2c·#0 + #0²` | repeated variable, deeper right side |

for `c = 11, 12, 13, …`. Three properties matter and all three are enforced, not
assumed:

* **Every generated lemma is genuinely valid, and is checked.** Each is
  installed through `Book.install`, i.e. through the same **seven gates** as a
  mined lemma — including G3 (proof rebuilt from scratch over fresh ground
  indeterminates), G6 (every rebuilt step re-validated against its schema) and
  G7 (an independent exact-grid decision of the polynomial identity). The
  script fails if any lemma is rejected. At `N = 3000` none was.
* **No generated lemma can fire on P4.** Every one carries an integer literal
  `≥ 11`; P4's derivation only ever contains `−1, 3, 9, −9`. This is checked,
  not argued: the *null book* column below (N generated lemmas, no mined lemma)
  must stay at 29 steps at every size, and the script fails if it moves.
* **The answer never changes.** At every size the derivation's result address is
  asserted equal to the baseline's, and `poly_equal` re-decides it independently.

```
python3 runtime/demo/scale_lemmas.py --index \
        --sizes=1,10,22,23,50,100,300,477,1000,3000
```

---

## 2. The curve, and the crossover

Baseline: P4 with an **empty book** — `steps = 29`, `work = 5431`.
`work` counts rule/lemma match attempts; `steps` counts rewrite steps that
entered the derivation DAG. The seed criterion of `CRYSTAL.md` §0 is about
`steps` and only `steps`.

| N (book size) | steps | search work | vs baseline work | null steps | null work | install work | wall ms |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | **12** | 1,567 | −3,864 | 29 | 6,096 | 2,889 | 0 |
| 10 | **12** | 3,223 | −2,208 | 29 | 12,081 | 12,307 | 1 |
| **22** | **12** | **5,431** | **±0** | 29 | 20,061 | 24,040 | 1 |
| 23 | **12** | 5,615 | +184 | 29 | 20,726 | 24,455 | 1 |
| 50 | **12** | 10,583 | +5,152 | 29 | 38,681 | 51,417 | 2 |
| 100 | **12** | 19,783 | +14,352 | 29 | 71,931 | 99,150 | 4 |
| 300 | **12** | 56,583 | +51,152 | 29 | 204,931 | 294,700 | 11 |
| 477 | **12** | 89,151 | +83,720 | 29 | 322,636 | 468,298 | 16 |
| 1000 | **12** | 185,383 | +179,952 | 29 | 670,431 | 979,125 | 35 |
| 3000 | **12** | 553,383 | +547,952 | 29 | 2,000,431 | 2,934,625 | 135 |

The curve is exactly linear: `work(N) = 1567 + 184·(N−1)` for the useful book
and `6096 + 665·(N−1)` for the null book. The 184 and the 665 are the
per-lemma scan costs at 12 and at 29 steps respectively — the same constant the
crystallize lane already saw once, as "+665 work units for one irrelevant
lemma", now shown to be the slope of a line.

### The crossover

> **Break-even is at N = 22 and the book is a net loss from N = 23.**

At `N = 22` the total search work with the lemma book is **5,431** — the empty
book's number, to the unit. From 23 lemmas on, the book costs more search than
solving P4 with no book at all, while the headline step count sits unmoved at
12. That is precisely the failure the crystallize lane described:

> the headline number becomes a lie told with a true counter

and it arrives **at 22 lemmas, not at "a few hundred"** — the prediction was
right in kind and about 15× optimistic in degree. Reported that way round
deliberately: the lane called this "the first thing that must change" before
anyone had measured it, and it was.

### What the crossover is not

It is not a claim that the step reduction decays. It does not: **12 steps at
N = 1 and 12 steps at N = 3000.** The lemma keeps firing, the derivation is
unchanged, the answer is re-verified at every size. What decays is the *total
cost* of getting there, and only because of how lemmas are looked up.

---

## 3. The discrimination net, and the same curve again

The fix the crystallize lane named is implemented in
`runtime/crystallize/derivation.py` as `LemmaIndex`.

**What it is.** `match` is one-way and purely structural: at a non-variable
pattern node it demands the same `(kind, val, arity)` as the subject. So for a
fixed set of probe positions — root, `(0)`, `(1)`, `(2)`, `(0,0)`, `(0,1)`,
`(1,0)`, `(1,1)` — a lemma whose left side carries a concrete key at a probe
**cannot** match a subject carrying a different key (or nothing) there. The net
stores, per probe, a dict from key to an integer bitmask of lemmas, plus a
wildcard mask for the lemmas that are unconstrained there; a lookup is eight
dict hits and eight integer ANDs, and the surviving bits are read out in
installation order.

**What it may not do.** It is a filter, never a truncation: the candidate list
is a superset of the matches, so the derivation is identical *step for step*.
That is asserted three ways in `runtime/tests/test_crystallize.py`:
`test_discrimination_net_returns_the_same_derivation_as_the_scan` (same result,
same rule sequence, same step count, strictly less work),
`test_discrimination_net_candidates_are_a_superset_of_the_matches` (the planted
control — every lemma the net *drops* is re-matched by brute force at every
node of every test term and must fail), and
`test_discrimination_net_index_can_be_built_once_and_reused`.

**Cost is charged, not hidden.** Every probe lookup and every lemma insertion
bumps the same `work` counter as the scan it replaces.

| N | steps | scan work | net work (built per query) | ratio | net work (index amortised) | ratio | index build |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 12 | 1,567 | 1,607 | 1.0× | 1,599 | 1.0× | 8 |
| 10 | 12 | 3,223 | 1,703 | 1.9× | 1,623 | 2.0× | 80 |
| 22 | 12 | 5,431 | 1,799 | 3.0× | 1,623 | 3.3× | 176 |
| 50 | 12 | 10,583 | 2,023 | 5.2× | 1,623 | 6.5× | 400 |
| 100 | 12 | 19,783 | 2,423 | 8.2× | 1,623 | 12.2× | 800 |
| 300 | 12 | 56,583 | 4,023 | 14.1× | 1,623 | 34.9× | 2,400 |
| 477 | 12 | 89,151 | 5,439 | 16.4× | **1,623** | 54.9× | 3,816 |
| 1000 | 12 | 185,383 | 9,623 | 19.3× | **1,623** | 114.2× | 8,000 |
| 3000 | 12 | 553,383 | 25,623 | 21.6× | **1,623** | 341.0× | 24,000 |

Two different questions, two different answers:

* **Index built inside every query.** Work is `1,599 + 8·N`: the residual
  linear term is the *construction* of the net, not the search. Crossover moves
  from **22 to 477** — a 21.7× improvement, and the failure mode still exists.
* **Index built once per book and reused.** Query work is **constant at 1,623
  from N = 10 to N = 3000** — a 3000-lemma book costs a query no more than a
  10-lemma one. **There is no crossover at any size measured.** Against the
  empty-book baseline of 5,431 the query is 3.3× *cheaper*, at every size.

The amortised column is the honest one for a runtime that installs lemmas once
and solves many problems, which is the entire premise of §3.1. The per-query
column is the honest one for a runtime that rebuilds its book constantly.

### Why the net is off by default

`normalize(..., use_index=False)` is the default, so every counter already
published by the crystallize lane (`crystallize/README.md`, `STATUS.md`, the
demo's `work` column) stays reproducible to the unit. Flipping the default is a
one-word change in `normalize`; it belongs to the lane that owns the published
numbers, together with a re-issue of those numbers. This file does not edit
another lane's README to match a change made in this one.

### What it implies about the seed criterion at scale

Stated as `CRYSTAL.md` §0 states it — *does mathematics entering the runtime
make an independent problem solve in strictly fewer kernel steps, with a null
control that does not?* — the criterion **survives at every size measured, up to
a 3000-lemma book**:

| | N = 1 | N = 3000 |
|---|---|---|
| P4 with the mined lemma | **12 steps** | **12 steps** |
| P4 with a null book of the same size | 29 steps | 29 steps |
| answer identical & independently re-verified | yes | yes |

The criterion is durable because it is a statement about *steps*, and steps are
exactly the quantity that does not degrade. But the honest counterweight is that
**a criterion about steps stops being an operational claim once search cost
dominates** — and with the linear scan that happens at 22 lemmas, which is a
small book. With the net amortised, cost stops growing with the book at all, and
the step claim and the cost claim point the same way again. That is the real
result of this section: *the seed criterion did not need saving; the runtime
around it did.*

---

## 4. E-matching: a compiled automaton vs the memoised recursive matcher

`execute/README.md` records that e-matching is exponential in pattern size and
that two optimisations (binding to e-classes, memoising the subsearch) took the
demo from 53M visits to 37k and "only postpone the wall". This section replaces
the recursive search with a compiled automaton (Simplify / egg style) and
measures.

### 4.1 What was built

`runtime/execute/ematch.py`, `compile_pattern` → `Program`. Each pattern is
compiled **once** (and cached) into a flat instruction sequence over registers
holding e-classes:

```
("app",   src, sort, bucket_key, r_fn, r_arg)   branch: app nodes of a class
("lam",   src, sort, dom_addr,   r_body)        branch: lam nodes of a class
("const", src, sort, symbol)                    filter: class contains the atom
("var",   src, sort, index)                     filter: class contains the atom
("vbind", src, sort)                            filter: class sort agrees
("vcmp",  src, other)                           filter: same class
```

Compilation is in pattern preorder, so the automaton explores in the same order
as the recursive matcher and returns **the same matches in the same sequence**.
Three things change:

1. Pattern walk, bucket keys and register layout are computed once per
   (pattern, variable set) instead of once per query.
2. The search is an index-and-candidate loop over an array with a register file
   written in place — no generator frames, no per-binding dict copy, no
   `tuple(sorted(csigma.items()))` memo key built at every node.
3. **Candidates are e-node *signatures*, not e-nodes.** A bind step can only
   expose the *classes* of a node's children, so two nodes of one class with the
   same child classes are one candidate. In a curried IR that collapse is large:
   the partial application `mul a` has one node per term equal to `a`, all with
   identical child classes, so a class of *n* members contributes **one**
   candidate. This removes structurally the blow-up the memo table was
   introduced to survive.

The two engines are both kept. `ematch(..., engine="automaton"|"recursive")`
selects; `DEFAULT_ENGINE = "automaton"`.
`test_ematch_automaton_agrees_with_the_recursive_matcher` is a differential test
over eight patterns × two graph sizes asserting **equal match keys in equal
order** — not equal counts, and not equal sets.

### 4.2 The L3 demo (`runtime/demo/geodesic_demo.py`)

E-graph: 309 nodes, 17 classes, 517 records; saturation reaches the same
fixpoint under both engines (257 applications, 32 unions, 225 chords).

| measurement | recursive | automaton | change |
|---|---:|---:|---|
| **saturation e-match visits** (277 calls) | 33,630 | **16,962** | **−50%** |
| saturation wall clock | 153 ms | 134 ms | −12% |
| `mul(mul(mul(?p,?p),?p),?p)` — 44 matches | 721 visits / 2.2 ms | 808 visits / **1.8 ms** | −18% time |
| `mul(mul(?a,?b),mul(?b,?a))` — 99 matches | 1,152 / 4.5 ms | 847 / **2.3 ms** | −49% time |
| `mul(mul(?a,?b),mul(?c,?a))` — 229 matches | 1,200 / 7.5 ms | 911 / **3.9 ms** | −48% time |
| `mul(mul(?a,?b),mul(?c,?u))` — 739 matches | 1,200 / 14.1 ms | 959 / **10.3 ms** | −27% time |
| 5-deep spine, repeated variable — 10 matches | 818 / 2.0 ms | 1,023 / **1.7 ms** | −15% time |

Match counts are identical in every row (44, 99, 229, 739, 10).

The two saturation rows are printed by `geodesic_demo.py` itself
(`ematch_visits=` in its section 2/6 lines); the five per-pattern rows come from
a scratch harness that ran each engine in its **own process** against its own
build of the same graph. §4.3's table is the more controlled measurement — one
process, one graph object — and where the two disagree in sign on a per-pattern
wall clock, §4.3 is the one to believe.

### 4.3 The harder case: an AC-saturated e-graph

The demo's graph is small and its classes are narrow. The stress case is an
e-graph saturated under **associativity + commutativity** of a product of *k*
atoms, which merges structurally different nodes into one class, so a class
carries many distinct child-class signatures and a multi-variable pattern really
does branch at every level. Script: `runtime/demo/ematch_bench.py`, which builds
the graph **once** and queries that same object with both engines, so the two
columns are not two builds. It fails if the engines disagree on any pattern.

**k = 6: 6,549 nodes, 126 classes, widest class 1,896 members.** `vis` is that
engine's own `visits` counter, `hits` the lookups it serves from a cache and
charges nothing for (memo hits / entry-signature hits) — see §4.4.

| pattern | matches | rec vis | rec hits | rec ms | aut vis | aut hits | aut ms | |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| `mul(mul(?a,?b),?c)` | 36,554 | 14,623 | 49,649 | 721.8 | 20,346 | 4,983 | 746.6 | **−3%** |
| `mul(mul(?a,?b),mul(?c,?u))` | 47,524 | 31,357 | 61,877 | 1,123.1 | 35,046 | 4,983 | 1,015.3 | 1.1× |
| `mul(mul(mul(?a,?b),?c),?u)` | 104,856 | 18,926 | 130,912 | 2,343.6 | 37,566 | 4,983 | 2,576.5 | **−10%** |
| `mul(mul(?a,?b),mul(?b,?a))` | 0 | 27,997 | 58,619 | 115.8 | 28,326 | 4,983 | **43.1** | **2.7×** |
| `mul(mul(mul(?a,?b),?c),mul(?a,?b))` | 0 | 29,246 | 134,212 | 271.5 | 41,766 | 4,983 | **57.5** | **4.7×** |
| `mul(mul(mul(?a,?b),mul(?c,?u)),mul(?v,?w))` | 17,568 | 29,186 | 152,674 | 751.1 | 47,046 | 4,983 | 564.9 | 1.3× |
| **total** | | 151,335 | 587,943 | 5,326.7 | 210,096 | 29,898 | 5,003.7 | 1.06× |
| **total lookups** | | **739,278** | | | **239,994** | | | **3.1×** |

Match counts are identical in every row, and so is the order.

**Two rows go the wrong way and are left in the table.** On the two
match-heavy patterns (36,554 and 104,856 matches) the automaton is 3% and 10%
*slower*. Those queries are dominated not by search but by *materialising* the
answer — `_expand`, the `EMatch` objects, the dedup dict — which both engines do
identically; what is left of the search there favours the recursive matcher's
memo, which is shared across the whole call, while the automaton's entry cache
is keyed per entry signature and so reuses less. Reproduced twice with the same
sign (Q1 721.8/739.5 vs 746.6/760.3; Q3 2,343.6/2,483.3 vs 2,576.5/2,569.9),
so it is not noise.

**The rows that go the right way are the search-dominated ones**, exactly as the
theory predicts: the two patterns with **late compares and no matches** are
2.7× and 4.7× faster — that is the search the recursive matcher must walk and
abandon, and that the automaton's signature collapse never enters.

At **k = 5** (1,175 nodes, widest class 427) the same script gives totals
256.1 → 190.5 ms (1.35×) and 61,926 → 33,852 total lookups (1.8×), with five of
six patterns faster and `Q2` reproducibly ~15% slower.

### 4.4 The honest part: `visits` is not a cost model

The automaton's `visits` counter is *higher* on the AC graph while its total
work is 3.1× lower. Both are true and they are not in tension, because the two
engines count different events:

* the recursive matcher charges a visit per `_match_class` / `_match_node`
  entry, and charges **nothing** for a memo hit — of which there were 587,943 at
  k = 6, each a dict lookup with a `tuple(sorted(...))` key built to find it;
* the automaton charges a visit per candidate signature considered, and charges
  **nothing** for an entry-signature cache hit — of which there were 29,898.

Counting every lookup either engine performs, the automaton does **3.1× less**
at k = 6 and 1.8× less at k = 5. Counting raw `visits` it looks worse on the AC
graph and better in the demo's saturation loop. The conclusion is not that one
counter is dishonest; it is that **`max_visits` is a budget, not a metric**, and
cross-engine comparisons of it are meaningless. Where a genuine cross-engine
number is wanted it is "total lookups" or wall clock, and both are reported.

One consequence must be stated because it is a contract change: a caller who
pinned a specific `max_visits` against the recursive engine may see
`exhausted=True` sooner under the automaton on AC-like graphs. The budget still
does exactly what it promises — report rather than truncate — but the number now
means "candidate signatures considered", not "recursive calls made".

### 4.5 Verdict

**The automaton is kept**, and the recursive matcher is kept alongside it
(`engine="recursive"`), on these grounds:

* identical answers — the differential test asserts equal match keys **in equal
  order** over eight patterns × two graph sizes, plus binder patterns, and
  `ematch_bench.py` re-asserts it on every run;
* **3.1× fewer total lookups** at k = 6, 1.8× at k = 5, **50% fewer e-match
  visits** in the L3 demo's saturation loop (33,630 → 16,962);
* 2.7×–4.7× faster on the search-dominated patterns, which are the ones that
  will grow;
* one compile per pattern instead of one per query — saturation calls `ematch`
  277 times in the demo and now compiles 48 programs, not 277 pattern walks.

Against: it is **3–10% slower on match-materialisation-dominated queries**, its
raw `visits` are higher on AC graphs, and — the claim it emphatically does not
support — **it is not an asymptotic improvement**. E-matching is still
exponential in pattern size, the automaton still enumerates the same search
tree, and the wall it postpones is the same wall. It removes the constant
factors and the memo's bookkeeping; it does not remove the bound.

---

## 5. The homotopy-class enumerator on the graph it was filed against

Defect 1 in `STATUS.md` was filed by the L3 lane against a **533-record**
e-graph — the one `geodesic_demo.py` builds after installing the `pow4` theorem
— where the geodesic to `sqr(sqr(sqr #3))` is 15 kernel steps.

Same graph, same bounds (`max_depth=32`, `max_paths=4096`), before and after the
fix (`git archive HEAD` of the pre-fix tree vs the working tree):

| | before | after |
|---|---:|---:|
| classes found (in the same 4,096-path budget) | 104 | **523** |
| **smallest class found** | 64 axioms | **11 axioms** |
| largest class found | 186 axioms | 102 axioms |
| nodes explored | 252,202 | **26,346** |
| wall clock | 327 ms | 243 ms |
| `complete` | False (`max_paths`) | False (`max_paths`) |

The enumerator now spends its path budget on the *short* proofs: a class of 11
axiom atoms instead of 64, found with a tenth of the exploration, and five times
as many classes inside the same budget. (Class size counts axiom atoms and the
geodesic counts kernel steps, so 11 and 15 are different units of the same
shortness; neither is a metric — see `STATUS.md` defect 3 and L3's
`RouteFinder`.)

On a synthetic worst case — a 301-record chain carrying the low record ids with
a 15-axiom route hidden behind it — the before-behaviour is total: **0 classes,
33 nodes explored, the search dead on the first deep branch**. After: the
15-axiom class, 374 nodes explored. That case is now the regression test
`A7` in `runtime/tests/test_propagate.py`.

Honesty is unchanged in both columns: every run above pruned branches or hit a
path bound, and every one of them reports `complete=False` and refuses to be
iterated or measured without `.partial()`.

### 5.1 The same defect in L4, and the shared abstraction

`STATUS.md`'s "still open" list, written by the lane that fixed §5, said:

> `propagate/invalidate.py`'s derivation-tree walk still aborts globally on
> `max_depth` exactly as `egraph.py` used to, and wants the same repair.

It did, and it now has it. The discipline was factored into
**`runtime/kernel/bounded.py`** — `resolve_bounds`, `bounds_tuple`,
`SearchLedger`, `ClassBuckets`, `deepen` — and both enumerators call it. What is
shared is the *bookkeeping* both got wrong: a bound prunes a branch and the
search backtracks; rounds deepen shortest-first; a branch is cut only when
`depth + admissible_lower_bound` provably overruns the round; and whichever
bound bound is named in the reason. What is not shared is the search itself,
because the two spaces are different in kind — `egraph` enumerates simple
**paths** in an undirected graph (OR-choices only, admissible bound = the
breadth-first distance to the target), `invalidate` enumerates derivation
**trees** (an AND-OR search: OR over a fact's derivations, AND over a
derivation's premises, admissible bound = the minimum justification height).

The L4 test case: a library where `THEOREM` has two derivations — `d.a_deep`
through a 60-link chain standing on the fact to be retracted (deeper than the
default `max_depth=32`, and first in sorted derivation order, so the search
meets it first), and `d.b_short` from two independent primitives. The surviving
justification is behind the over-deep branch.

| same graph, same bounds (`max_depth=32`) | before | after |
|---|---:|---:|
| classes found | **0** | **1** |
| smallest class | — | **2 facts** |
| nodes explored | 33 | 96 |
| `complete` | False (`max_depth`) | False (`max_depth`, 1 branch pruned) |
| `survival(THEOREM, R0)` | **UNDECIDED** | **SURVIVES** |

The verdict row is the one that matters: `recompute.apply` refuses to act on a
plan containing an `UNDECIDED` survival, so before the fix a consequence with a
perfectly good independent proof could not be certified as surviving. Nodes
explored went *up*, because the search now explores instead of dying on the
first deep branch.

**No published number moved.** `runtime/demo/propagate_demo.py` is
byte-identical before and after — 344 L4 steps for the `P00` retraction against
1 for the null control, `class.expand=119`, `index.reverse=251`. The demo's
library has uniform justification height, so `deepen` runs exactly one round and
the admissible bound prunes nothing. `runtime/demo/geodesic_demo.py` §1–§12 is
byte-identical too, which is how the `egraph` half of the refactor was checked:
the shared module reproduces the old behaviour exactly, it does not re-implement
it approximately.

Regression tests: `B10`, `B11`, and the control `x_l4_depth_pruned_not_complete`
in `runtime/tests/test_propagate.py`.

---

## 6. The materialisation cliff: extraction over the class DAG

`execute/README.md` §10 item 2:

> **`Budget.max_exhaustive_vars = 1` is a route-materialisation cliff.** Rules
> with two or more variables bind canonically, so their right-hand sides are
> built at one representative per class. No equality is lost, but the frontier
> only ever contains terms someone materialised — so a *better route to a term
> nobody built* is invisible. … The real fix is extraction that selects from
> classes rather than from stored terms (bottom-up Pareto extraction over the
> class DAG).

Built as `execute.extract_class_frontier`. Method and termination argument:
`execute/README.md` §5.1. Measurement, on `runtime/demo/geodesic_demo.py`'s
task (evaluate `3^8`), same graphs, same cost vector, same checker:

| | stored terms | class DAG |
|---|---:|---:|
| nondominated routes, **before** the theorem | 11 | **16** |
| nondominated routes, **after** | 9 | **14** |
| frontier routes to a term **never built**, before / after | 0 by construction | **4 / 3** |
| candidate destinations, before / after | 99 / 102 | 103 / 105 |
| routes the checker rejected | 0 | **0** |
| class fixpoint, before / after | — | converged, 4 rounds / 3 rounds (10,627 / 7,865 assemblies) |
| `frontier_diff` before→after | appeared 2, vanished 4, shortened 4 | appeared 6, vanished 8, shortened 5 |

The four before-theorem frontier points no stored-term extraction can see:

| assembled term | steps | size | width | verify |
|---|---:|---:|---:|---:|
| `mul (mul (mul (mul #3 #3) (mul #3 #3)) #9) (mul #3 #3)` | 8 | 11 | 6 | 41 |
| `mul (mul (mul (mul #3 #3) (mul #3 #3)) (mul #3 #3)) (mul #3 #3)` | 11 | 10 | 2 | 57 |
| `mul (mul (mul #3 #3) (mul #3 #3)) #81` | 12 | 9 | 9 | 59 |
| `mul (sqr #9) #81` | 16 | 7 | 11 | 79 |

Row 2 is the cleanest demonstration. At `width = 2` the stored-term frontier
offers `size 8` only at **15** steps, and nothing between `size 12` and
`size 8`. The assembled `size 10` term at **11** steps is dominated by nothing
and dominates nothing — a new corner of the frontier, reachable only through a
term the e-graph never materialised.

Controls, all in the demo: 208 class-DAG destinations across both runs evaluated
by the demo's independent exact-integer evaluator → **one value, 6561**; 0 routes
rejected; the null theorem leaves the class-DAG frontier **bit-identical**; and
`test_class_dag_extraction_does_not_mutate_the_egraph` asserts the e-graph's
terms, records and classes are unchanged by extraction.

### 6.1 The published number this moves

| shortest route to `sqr (sqr (sqr #3))` | before | after | change |
|---|---:|---:|---:|
| through the **retained merge records** (`RouteFinder`) | 24 | 15 | **−9** |
| extracted over the **class DAG** | **20** | 15 | **−5** |

Both are checked proofs. The class-DAG extractor finds a 20-step proof *before*
the theorem that `RouteFinder`'s shortest path through the justification graph
does not, because a congruence proof assembled from freely chosen sub-geodesics
need not correspond to any single retained congruence record. So **24 is a
minimum over record-graph routes, not over checkable proofs**, and the
theorem's honest effect on that target is −5.

The direction of every claim is unchanged — the theorem still strictly shortens
the target, no route gets longer, the frontier still moves, the null control
still changes nothing. What is no longer defensible is the magnitude −9 as a
statement about proofs. `STATUS.md` and `execute/README.md` §7 both quote it and
both now carry the correction next to it.

### 6.2 What §6 does not establish

* **The fixpoint is bounded, not convergent.** With a *vector* cost the usual
  "costs only decrease, integers are well founded" argument fails, and a cyclic
  class graph can grow a class's Pareto set without bound (going round a cycle
  strictly increases `size` but may decrease `width` or `steps`, so the new
  option is not dominated). Termination is by `max_rounds` / `max_options` /
  `max_terms`, each reported when it binds. The demo's class graph is acyclic
  and converges; **nothing here measures a cyclic one.**
* **The per-class Pareto filter is silent in `verify`.** Three of the four cost
  components are exactly compositional and are filtered on; `verify` is the
  checker's counter delta on a *complete* route and is measured only at the end.
  An option dominated on `(steps, size, width)` but cheaper in `verify` is
  dropped. On this task `verify` is near-collinear with `steps`, which is why
  that is tolerable here and why it is stated rather than implied.
* **Saturation is unchanged.** `max_exhaustive_vars` is still 1 and rules still
  fire at canonical representatives, so an *equality* that would only be found
  by e-matching against an unbuilt term is still not found. What was removed is
  the cliff in **extraction**, not in search.
* **One task, one IR.** 16 → 11 and 14 → 9 are this task's numbers. The
  combination count is `|options|^arity` per node per round, which is why
  `max_terms` exists.

---

## 7. Reproducing every number in this file

```bash
# §2, §3  the lemma-book curve, the crossover, and the net
python3 runtime/demo/scale_lemmas.py --index \
        --sizes=1,10,22,23,50,100,300,477,1000,3000

# §4.3   both e-match engines against one AC-saturated graph (k=6 is ~90 s)
python3 runtime/demo/ematch_bench.py 5
python3 runtime/demo/ematch_bench.py 6

# §4.2   the demo's saturation loop under the automaton (the default engine);
#        set ematch.DEFAULT_ENGINE = "recursive" for the other column
python3 runtime/demo/geodesic_demo.py

# §5     the 533-record graph and its 15-step geodesic (demo section 7)
python3 runtime/demo/geodesic_demo.py

# §5.1  the L4 backtracking repair
python3 runtime/tests/test_propagate.py        # B10, B11, x_l4_depth_pruned_not_complete

# §6     the class-DAG frontier, before and after (demo section 13)
python3 runtime/demo/geodesic_demo.py

# the eight suites, all of which must pass unchanged
for t in kernel execute propagate crystallize distinguish render physics curriculum; do
    python3 runtime/tests/test_$t.py; done
```

The only number above that needs a scratch harness is §5's *before* column,
which requires the pre-fix tree (`git archive` of the commit before the repair)
and a 40-line script calling `explanation_classes` on the demo's after-theorem
graph. Everything else is produced by the two committed scripts. Counters should
reproduce exactly; wall clock should not.

## 8. What this file does *not* establish

* **No asymptotics.** Every row is a measurement at a stated size. The largest
  sizes measured are: 3,000 lemmas (§2–3), a 6,549-node / 1,896-wide e-graph
  (§4.3), a 533-record justification graph (§5), a 64-fact dependency graph with
  a 60-link chain (§5.1), a 17-class / 309-node e-graph (§6). Beyond those, nothing here
  says anything.
* **§2's crossover is P4's crossover.** The 22 is a property of one problem with
  one mined lemma at 12 steps and a 29-step baseline. The *slope* (184 work per
  lemma per query at 12 steps) generalises to any problem of that step count and
  term size; the intercept does not.
* **The generated lemmas are uniform.** Four families with a varying literal.
  A book of genuinely heterogeneous mined lemmas would index better (more
  distinct probe keys) and scan the same. So §3's net numbers are, if anything,
  a **lower** bound on what the net buys.
* **No claim about the mining or the gates at scale.** The install column shows
  what checking 3,000 lemmas costs (2.9M work units) and nothing more; the
  miner was run on three derivations, as in the demo.
* **Wall clock is not exact, and per-query wall clock is not even stable in
  sign.** Two of §4.2's per-pattern rows reverse sign when the same comparison
  is made in one process against one graph object (§4.3). Totals and counters
  are stable; individual millisecond figures are indicative. No claim in this
  file rests on wall clock alone, and the two rows where the automaton loses are
  in the table rather than in a footnote.
* **§4 measures one IR.** Curried application is what makes the automaton's
  signature collapse large; a first-order IR with n-ary application would see
  less of it, and the crystallize substrate (§2–3, flat n-ary sums and products)
  is exactly such an IR.
