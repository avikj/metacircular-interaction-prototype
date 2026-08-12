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
   the automaton wins on wall clock everywhere measured (1.1×–5.0×) and on
   e-match work in the demo's saturation loop (33,630 → 16,962 visits), but its
   raw `visits` counter is *higher* on the AC graph — because the two engines
   count different things. That is stated in full in §4.4 rather than buried.
3. **§5 The homotopy-class enumerator**, on the 533-record graph the defect was
   filed against.

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

### 4.3 The harder case: an AC-saturated e-graph

The demo's graph is small and its classes are narrow. The stress case is an
e-graph saturated under **associativity + commutativity** of a product of *k*
atoms, which merges structurally different nodes into one class, so a class
carries many distinct child-class signatures and a multi-variable pattern really
does branch at every level. Script: the AC benchmark described in §6.

**k = 6 atoms: 6,549 nodes, 126 classes, widest class 1,896 members.**

| pattern | matches | recursive visits / ms | automaton visits / ms | speed-up |
|---|---:|---:|---:|---:|
| `mul(mul(?a,?b),?c)` | 36,554 | 14,623 / 725.0 | 20,346 / 644.5 | 1.1× |
| `mul(mul(?a,?b),mul(?c,?u))` | 47,524 | 31,357 / 1,140.4 | 35,046 / 848.6 | 1.3× |
| `mul(mul(mul(?a,?b),?c),?u)` | 104,856 | 18,926 / 2,429.3 | 37,566 / 1,934.9 | 1.3× |
| `mul(mul(?a,?b),mul(?b,?a))` | 0 | 27,997 / 118.2 | 28,326 / **44.5** | **2.7×** |
| `mul(mul(mul(?a,?b),?c),mul(?a,?b))` | 0 | 29,246 / 291.6 | 41,766 / **55.7** | **5.2×** |
| `mul(mul(mul(?a,?b),mul(?c,?u)),mul(?v,?w))` | 17,568 | 29,186 / 780.4 | 47,046 / 411.2 | 1.9× |
| whole-run totals | — | 237,608 visits + 722,316 memo hits = **959,924 lookups** | 317,026 visits + 54,150 entry hits = **371,176 lookups** | **2.6× less work** |

The same six patterns at **k = 5** (1,175 nodes, widest class 427) give the same
shape: 59.1→40.7, 46.5→35.2, 97.4→79.4, 15.8→**6.7**, 19.2→**7.2**,
14.4→**7.9** ms, with identical match counts throughout.

Match counts are identical in every row. The largest wins are exactly where the
theory says they should be: patterns with **late compares and no matches**
(rows 4 and 5) — the search that the recursive matcher must walk and abandon,
and that the automaton's signature collapse never enters.

### 4.4 The honest part: `visits` is not a cost model

On the AC graph the automaton's `visits` counter is *higher* while its wall
clock is lower, in one case by 5×. Both statements are true and they are not in
tension, because the two engines count different events:

* the recursive matcher charges a visit per `_match_class` / `_match_node`
  entry, and charges **nothing** for a memo hit — of which there were 722,316,
  each one a dict lookup with a `tuple(sorted(...))` key built to find it;
* the automaton charges a visit per candidate signature considered, and charges
  **nothing** for an entry-signature cache hit — of which there were 54,150.

Counting every lookup either engine performs (last row of §4.3) the automaton
does **2.6× less** work. Counting only each engine's own `visits`, the recursive
matcher looks better on this graph and worse on the demo. The conclusion is not
that one counter is dishonest; it is that **`max_visits` is a budget, not a
metric**, and cross-engine comparisons of it are meaningless. Where a genuine
cross-engine number is wanted it is either "total lookups" or wall clock, and
both are reported above.

One consequence must be stated because it is a contract change: a caller who
pinned a specific `max_visits` against the recursive engine may see
`exhausted=True` sooner under the automaton on AC-like graphs. The budget still
does exactly what it promises — reports rather than truncates — but the number
means "candidate signatures considered", not "recursive calls made".

### 4.5 Verdict

**The automaton is kept**, on these grounds and no others: identical answers
(differential test, equal order), lower wall clock in **all 17** measured
pattern queries (5 on the demo graph, 6 at k = 5, 6 at k = 6), 2.6× fewer total
lookups on the hardest graph, 50% fewer e-match visits in the demo's saturation
loop, and one compile per pattern instead of one per query. Saturation wall
clock moved 153→134 ms (demo) and 981→941 ms (k = 5); at k = 6 it was
14,311→14,334 ms, a tie inside the noise, because that loop is dominated by
kernel checking and merging rather than by matching.
The claim it does *not* support: it is not an asymptotic improvement. E-matching
is still exponential in pattern size, the automaton still enumerates the same
search tree, and the wall it postpones is the same wall.

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

---

## 6. Reproducing every number in this file

```bash
# §2, §3  the lemma-book curve, the crossover, and the net
python3 runtime/demo/scale_lemmas.py --index \
        --sizes=1,10,22,23,50,100,300,477,1000,3000

# §4.2   the L3 demo under both engines (DEFAULT_ENGINE is monkeypatched)
python3 runtime/demo/geodesic_demo.py          # automaton (the default)

# §5     the enumerator, before/after, on the 533-record graph
python3 runtime/demo/geodesic_demo.py          # section 7 prints the geodesic

# all six suites
for t in kernel execute propagate crystallize distinguish render; do
    python3 runtime/tests/test_$t.py; done
```

The §4.3 AC benchmark and the §5 before-column need a scratch harness (an
AC-saturated e-graph at k = 5, 6 and a checkout of the pre-fix tree
respectively); both are ~60-line scripts built from the public APIs
(`saturate`, `ematch`, `EGraph.explanation_classes`) and neither is committed,
because a benchmark that is not run by CI decays. The numbers above are what
those runs printed; anyone re-deriving them should expect the counters to match
exactly and the wall clock not to.

## 7. What this file does *not* establish

* **No asymptotics.** Every row is a measurement at a stated size. The largest
  sizes measured are: 3,000 lemmas (§2–3), a 6,549-node / 1,896-wide e-graph
  (§4.3), a 533-record justification graph (§5). Beyond those, nothing here
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
* **Wall clock is not exact.** It is reported to show that the counter
  reductions are not bought with hidden constants, and no claim in this file
  rests on it alone.
