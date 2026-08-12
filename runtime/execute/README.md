# `runtime/execute` — L3 execution, the geodesic engine

> Every accepted equality may become a rewrite; … the runtime chooses among
> implementations by declared task and a **cost vector**, keeping nondominated
> routes rather than collapsing to one scalar fitness. — `CRYSTAL.md` §2 L3

**Status: BUILT.** `python3 runtime/tests/test_execute.py` → **47/47**, and the
suite kills every one of 13 injected defects. `python3
runtime/demo/geodesic_demo.py` → exit 0, ~2 s, byte-identical under
`PYTHONHASHSEED` 0/12345/999.

Pure Python 3 stdlib, CPU only, exact integers throughout — no float is
constructed anywhere in the package (there is a test that greps for it). No ML,
no network, no randomness. Every number in this file came out of a counter.

This layer is built **on** `runtime/kernel`, which it imports and never
modifies. Nothing here is trusted by the checker.

---

## 0. What "geodesic" means operationally

A **route** is a checkable proof path from the task's term to some term equal to
it. Its length is the exact number of kernel proof steps. The **geodesic** is
the shortest such route through the justifications the e-graph actually retains.
Mathematics entering the runtime is a new edge in that graph, so it changes the
metric: distances shrink, and the *set* of nondominated destinations moves.

That is the whole claim, and §7 measures it.

Two things this is emphatically not. It is not `EGraph.explain`: that returns
the *proof-forest* route, whose length depends on the order merges happened in,
so adding a theorem can make it **longer** by pure bookkeeping accident. (It did,
in an earlier draft of the demo: 28 → 36 steps for a route that had genuinely
got shorter. A measurement with that artifact in it is not a measurement.) And
it is not a minimum over all conceivable proofs — a proof the e-graph never
recorded cannot be found. `RouteFinder` states both bounds in its docstring.

---

## 1. What is built, and what is not

| CRYSTAL.md §L3 clause | status |
|---|---|
| every accepted equality may become a **rewrite** | **BUILT** — `rewrite.py` |
| pattern → substitutions **modulo proved equalities** | **BUILT** — `ematch.py` |
| run rules to a **fixpoint or a declared budget** | **BUILT** — `saturate.py` |
| choose by **cost vector**, keep **nondominated routes** | **BUILT** — `extract.py` |
| every iso a **transport** | *designed, not built* |
| every finite classification a **decision procedure** | *designed, not built* |
| every quotient a **state compression** | *designed, not built* |
| every obstruction a **search prune** | *designed, not built* |

The four unbuilt clauses need L1's directed-edge algebra (`Iso`, `Quotient`)
wired into route selection, which is L4 work: a `Quotient` edge is only usable
when the task's sufficiency certificate covers it, and there is no task-declaration
machinery here to check that against.

---

## 2. How a rule is expressed in the kernel's IR

The kernel has no pattern variables. It has something better for this purpose:
`check.Instantiate(name, subst)`, which substitutes **opaque constants** into a
declared axiom's two sides and compares recomputed addresses. So a rule is

> a declared equational axiom `name : lhs = rhs`, together with a set of `Const`
> symbols of its sides designated **schematic**.

Matching binds those symbols; application is `term.subst_consts`; the
justification is `Instantiate(name, σ)` — a witness the trusted checker already
knows how to verify. **No new trusted code, and no new witness kind.**

Three consequences.

* **Rules are bidirectional.** `Eq` is symmetric and the checker's `_sides`
  accepts a step in either order, so `apply_rule(..., "bwd", ...)` is checked by
  exactly the same witness. `Rule.directions()` reports which orientations are
  usable — a direction whose pattern side is a bare variable, or which fails to
  bind a variable the other side needs, is refused rather than fired blindly.
* **Bindings must be closed.** `subst_consts` does not shift de Bruijn indices,
  so substituting an open term underneath a binder would capture it. `match`
  refuses an open binding (`rewrite.match_open_refused`). The cost is real: a
  rewrite that would have to bind a bound variable simply does not fire. It is
  the cheapest sound rule and it is enforced, not documented and hoped for.
* **Sorts are the kernel's.** An ill-sorted instantiation raises from `App`/`Lam`
  at build time; there is no ill-sorted intermediate to leak.

### The discipline, in one sentence

> Every rewrite application emits a proof path, that path goes to
> `kernel/check.py` **before** the rewritten term is returned, and a rewrite the
> checker rejects is never applied.

There is no unchecked application path in the module. `apply_rule` returns
`None` and bumps `rewrite.rejected`. Saturation checks the step before calling
`merge`, so a bad rule contributes **zero** nodes and zero merges — it cannot
put a term into the e-graph that a later extraction could route through. Both
are planted-false tests, and the demo shows one live (§12 of the demo output):
a rule that cites `pow4` but claims `sqr(sqr(sqr ?p))` matches, builds its term,
and dies at the door with `step … does not match witness sides`.

### Theorems, and why the trusted base does not grow

`install_theorem` (and `rule_from_edge`, which checks an L1 `Eq` edge first) has
three gates, all-or-nothing:

| gate | demand |
|---|---|
| **G1** | the name is fresh — a theorem may not silently redefine an axiom |
| **G2** | `check_path` accepts the proof **under the book as it stands before the theorem exists**, so a theorem can never be its own justification |
| **G3** | every schematic symbol occurs in **no axiom of the book** |

G3 is the side condition that makes "prove it about an opaque constant, use it
at every term" sound: the proof is a derivation about constants no axiom
mentions, and substitution composes through `Instantiate`. It is machine-checked
(`test_theorem_whose_parameter_occurs_in_an_axiom_is_refused` plants a theorem
generalised over `?u`, which `sqr_def` mentions, and it is refused).

But G3 is still a meta-argument, so the layer does not rest on it. The theorem
retains its proof as `Rule.expansion`, and `expand_path` replaces every theorem
step in a route by that proof, instantiated at the arguments of the actual use.
The result cites only primitives, so it can be re-checked in a `CheckContext`
where **no theorem is declared**. The demo does exactly this for every route on
the post-theorem frontier: 9/9 accepted, in a context where `'pow4' in
ctx.axioms` is `False`.

> A theorem in this runtime is a **route compression**, not a new assumption.
> The compression is visible: the frontier's routes are 9, 14, 15, 18, 20 and 20
> steps compressed, from 12, 17, 18, 21, 29 and 23 primitive steps.

---

## 3. E-matching: patterns against e-classes

A syntactic matcher sees one term at a time. An e-matcher sees an *equivalence
class* at every position, so it fires on shapes that exist **only modulo the
equalities already proved**.

The demo turns on precisely that. The pattern `mul(mul(mul(?p,?p),?p),?p)` —
"a fourth power" — against the saturated graph for `3^8`:

| | matches |
|---|---:|
| against the task term alone, before any equality is proved | **1** |
| against the saturated e-graph | **44** |
| …of which have a stored realisation | 5 |
| …of which have **no** stored realisation | **39** |

e.g. `?p = #9`, whose instance `mul (mul (mul #9 #9) #9) #9` is not a node of the
e-graph at all. It is that match — the fourth power of a *square* — that produces
`sqr(sqr(sqr #3))` and shortens its geodesic. A syntactic matcher finds nothing
there. This is the concrete answer to "why pay for an e-graph".

### The bound, stated

E-matching is a backtracking search over (pattern node × e-class member) pairs.
For a pattern with `P` nodes over classes of at most `C` members it has up to
`C**P` leaves: **exponential in pattern size**. Three explicit bounds, all
reported through `EMatchResult.exhausted` / `.complete` / `.reason`, none silent:

| bound | default | what exceeding it means |
|---|---:|---|
| `max_visits` | 200 000 | the enumeration is **partial** |
| `max_representatives` | 64 | one class had more members than a variable may be bound to |
| `max_exhaustive_vars` | 1 | patterns with more distinct variables bind to the **canonical representative** of each class instead of to every member |

The last one is the only place this module gives something up, so it gets the
honest statement:

> Canonical-representative binding loses **no equality**. If the pattern matches
> a class with `σ'`, then `lhs[σ']` and `lhs[σ_canonical]` lie in the same class,
> so congruence makes `rhs[σ']` and `rhs[σ_canonical]` equal too — the
> class-level consequence is identical. What is lost is **materialisation**:
> some syntactic members of the class are never built as nodes, and therefore
> cannot later be *extracted* as routes. That is a loss of candidate routes, not
> of mathematics.

### Two implementation facts that are load-bearing

Both were forced by measurement, and both are pure-function optimisations that
cannot change a result — only its cost.

1. **Variables bind to classes, not to terms** (phase 1), and class bindings are
   expanded into term substitutions once, at the end (phase 2). Binding terms
   inside the search means a repeated variable rejects candidate *terms* one at
   a time instead of comparing one *class*.
2. **The subsearch is memoised** on `(pattern node address, class root,
   substitution so far)`. Curried application means `mul a b` is
   `App(App(mul,a),b)`, so the partial application `mul a` has an e-class of its
   own containing one node per term equal to `a` — and without memoisation the
   matcher re-enumerates the whole subpattern once per member of it, at every
   spine level. On the demo's post-theorem graph that is the difference between **37 082**
   e-match visits and **53 million**, measured during development.

---

## 4. Saturation: a fixpoint, or a named budget

`CRYSTAL.md`'s cardinal sin is silent subsetting. So `SaturationResult.status`
is one of

```
fixpoint              nothing changed in a full pass; the answer is total
budget:iterations     the pass limit was reached with work outstanding
budget:applications   the application limit was reached
budget:nodes          the e-graph node limit was reached
budget:ematch         e-matching itself was incomplete, so "no change" proves nothing
```

and `is_fixpoint` is true for exactly one of them. The last is worth noting:
when e-matching reported `exhausted`, a quiet pass is **not** evidence of a
fixpoint, and saturation downgrades its own verdict accordingly rather than
inheriting a claim it cannot support.

The demo starves the same run three ways and gets three different statuses, none
of them `fixpoint`.

Two design points:

* **Instance deduplication.** A rule instance is a fact; re-deriving it on a
  later pass adds a duplicate record and nothing else, so an instance is applied
  at most once. This is not chord suppression — two *different* instances that
  happen to prove the same equality are both kept.
* **Chords are kept by default** (`Budget.keep_chords`). A merge of an
  already-equal pair is retained by the kernel as a chord: a second, independent
  route. That is the automorphism-preservation requirement of `CRYSTAL.md` §2 L1
  at execution level, and it is what makes the geodesic search have anything to
  choose between. Turning it off is a scale escape hatch and a real loss: the
  justification graph becomes a forest and every pair of terms has exactly one
  route. (In the demo: 225 chords against 32 unions, 517 retained records against
  292. Dropping them leaves the same 17 classes and the same 32 unions — the
  same mathematics, one route each.)

---

## 5. Extraction: a cost **vector**, and the frontier

Four exact integer components. They are not redundant:

| component | what it is |
|---|---|
| `steps` | kernel proof steps in the route, counting congruence subproofs — exactly the number of `check_step` calls verification will make |
| `size` | nodes in the extracted term's DAG: what must be stored, and what every later match must traverse |
| `width` | exact-arithmetic width — total bit length of the integer literals in the term |
| `verify` | the checker's **own counter delta** from actually verifying this route. Not modelled; the trusted heart is run and read |

`size` and `width` trade against each other directly: `#6561` is 1 node and 13
bits; `sqr(sqr(sqr #3))` is 5 nodes and 2 bits; neither dominates. `steps` and
`verify` are strongly correlated on this task (paths are flat) and separate on
congruence-heavy routes, where a short path hides deep subproofs — that is the
axis's purpose, and on this task it is nearly along `steps`, which is worth
saying rather than implying otherwise.

`dominates(a,b)` iff `a ≤ b` componentwise and `a < b` somewhere. `pareto` keeps
everything dominated by nothing, including ties — equal cost is not domination,
and two equally cheap different transports are exactly the plurality the spec
protects.

**Collapsing to one route requires an explicit, named `Scalarization`**, and the
name is carried in the `ScalarChoice`. There is no default and no implicit
tie-break that amounts to one. Four scalarizations of the *same* nine-route
frontier give three different winners:

| scalarization | weights | winner |
|---|---|---|
| cheap-to-prove | `steps` | the 16-node presentation itself (0 steps) |
| compact-term | `4·size + width` | `#6561` |
| narrow-arithmetic | `size + 4·width` | `sqr (sqr (sqr #3))` |
| balanced | `steps + 2·size + width` | `sqr (sqr (sqr #3))` |

A runtime that had collapsed early would have discarded the other answers before
the caller said which question they were asking.

`extract_routes` refuses to truncate: `max_targets` below the class size
**raises** rather than quietly extracting from part of a class, and
`ExtractionResult.partial_targets` propagates the kernel's own
`ClassEnumeration.complete` flag in `homotopy` mode.

---

## 6. The domain, and why this one

Evaluate `3^8` presented as a left-nested product of eight 3s, under
associativity, the definition of `sqr`, and exact integer folds.

Four properties made it right, and each is load-bearing.

1. **The cost vector is genuinely multi-dimensional.** Folding to a literal is
   small and arithmetically wide; keeping the square tower is wide-in-nodes and
   arithmetically narrow. Without literals the `width` axis is dead and the
   "vector" is decoration.
2. **The theorem's leverage is not syntactic.** `pow4` applies to `3^8` at a
   binding (`?p` = the class of `3^2`) whose instantiated left side is stored
   nowhere. A domain
   where the theorem's left side is simply *there* would demonstrate rewriting,
   not e-matching.
3. **The task is not an instance of the theorem.** `pow4`'s left side does not
   match the task term; it was proved about a fourth power and used on an eighth,
   which is what `CRYSTAL.md` §0 requires of an independent problem.
4. **A real, checked, irrelevant sibling theorem exists.** `pow4_plus` over
   `plus`/`dbl` is proved by the same machinery through the same checker and is
   simply not applicable. It is a theorem, not a strawman.

The arithmetic in the axiom book is exactly true by construction: each fold is
computed in Python's exact integer arithmetic at declaration time. The kernel
*trusts* declared axioms (`check.py` T3), so this matters — an axiom book with
an arithmetic error in it would produce beautifully checked nonsense.

---

## 7. The measurement

`python3 runtime/demo/geodesic_demo.py`

### Saturation

| run | status | iters | applications | unions | chords | nodes | classes | records | e-match visits |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| before | fixpoint | 4 | 257 | 32 | 225 | 309 | 17 | 517 | 33 630 |
| after `pow4` | fixpoint | 4 | 265 | 32 | 233 | 317 | 17 | 533 | 37 082 |
| null control | fixpoint | 4 | 257 | 32 | 225 | 309 | 17 | 517 | 34 484 |

Every one of those applications was handed to `check.py` as an `Instantiate`
step before the merge. Rejections: 0 for the primitive book, and the planted-false
rule produces `applications=0, unions=0, rejected=1`.

### The Pareto frontier, before → after

**Before** — 11 nondominated routes out of 99:

| extracted term | steps | size | width | verify |
|---|---:|---:|---:|---:|
| `mul (mul (mul (mul (mul (mul (mul #3 #3) #3) #3) #3) #3) #3) #3` | 0 | 16 | 2 | 1 |
| `… (mul #3 #3)` | 1 | 14 | 2 | 5 |
| `mul (mul (mul (mul (mul #3 #3) #3) (mul #3 #3)) #9) #3` | 7 | 13 | 6 | 37 |
| `mul (mul (mul (mul #3 #3) (mul #3 #3)) #9) #9` | 9 | 11 | 6 | 45 |
| `mul (mul (mul #3 #3) (mul #3 #3)) (mul (mul #3 #3) (mul #3 #3))` | 15 | 8 | 2 | 75 |
| `mul (sqr #9) (sqr #9)` | 19 | 6 | 4 | 93 |
| `sqr (sqr #9)` | 20 | 4 | 4 | 97 |
| `sqr (sqr (mul #3 #3))` | 20 | 7 | 2 | 97 |
| `#6561` | 21 | 1 | 13 | 101 |
| `sqr #81` | 21 | 3 | 7 | 103 |
| `sqr (sqr (sqr #3))` | **24** | 5 | 2 | 117 |

**After `pow4`** — 9 nondominated routes out of 102:

| extracted term | steps | size | width | verify |
|---|---:|---:|---:|---:|
| `mul (mul (mul (mul (mul (mul (mul #3 #3) #3) #3) #3) #3) #3) #3` | 0 | 16 | 2 | 1 |
| `… (mul #3 #3)` | 1 | 14 | 2 | 5 |
| `mul (mul (mul (mul (mul #3 #3) #3) (mul #3 #3)) #9) #3` | 7 | 13 | 6 | 37 |
| `mul (mul (sqr (sqr #3)) #9) #9` | 9 | 10 | 6 | 45 |
| `mul (sqr (sqr #3)) (sqr (sqr #3))` | 14 | 7 | 2 | 69 |
| `sqr (sqr (sqr #3))` | **15** | 5 | 2 | 73 |
| `sqr (sqr #9)` | 18 | 4 | 4 | 89 |
| `#6561` | 20 | 1 | 13 | 97 |
| `sqr #81` | 20 | 3 | 7 | 99 |

### Curvature

| | |
|---|---:|
| routes that **appeared** on the frontier | 2 |
| routes that **vanished** | 4 |
| routes that **shortened** | 4 |
| routes **unchanged** | 3 |

| geodesic to | before | after | change |
|---|---:|---:|---:|
| `sqr (sqr (sqr #3))` | 24 | **15** | **−9** |
| `#6561` | 21 | 20 | −1 |
| `sqr #81` | 21 | 20 | −1 |

No geodesic got longer. The frontier both **shortened** and **changed shape**:
`mul (sqr (sqr #3)) (sqr (sqr #3))` and `mul (mul (sqr (sqr #3)) #9) #9`
appeared, and four routes that had been nondominated were beaten off the
frontier by cheaper routes to other terms. (`FrontierDiff` reports the
shape-changed-without-shortening case separately, because an edge that reorders
which routes are optimal without shortening the best one is the more interesting
outcome; on this task both happened.)

### Null control

| | |
|---|---|
| theorem | `plus (plus (plus ?q ?q) ?q) ?q = dbl (dbl ?q)`, proved in 4 kernel steps, checked |
| applications during saturation | **0** |
| frontier targets vs before | **identical** |
| frontier costs vs before | **identical** |
| e-match work it cost anyway | **+854 visits** |

A true, checked, irrelevant theorem costs search work and buys nothing. The gap
between that row and the table above it is the entire claim: the runtime is not
caching, it is applying mathematics that happens to apply.

### Correctness controls

| control | result |
|---|---|
| all 102 route destinations evaluated by an independent exact-integer evaluator | one value: **6561** |
| all destinations provably equal to the task in the e-graph | yes |
| every route re-verified by `check.check_path` | 102 checked, 0 rejected |
| every frontier route expanded to primitives and re-checked with **no theorem declared** | 9/9 accepted |
| planted-false rewrite | matches, is built, is rejected, contributes 0 merges |

---

## 8. What this layer adds to the trusted base

**Nothing.** Concretely:

* every rewrite justification is an `Instantiate` step the existing checker
  verifies; no new witness kind, no new trusted file;
* a theorem is only installed after its proof checks against the *previous*
  book, and every use expands back to primitives and re-checks without it;
* the e-graph is never asked to vouch for anything — `check_path` re-derives
  every step from the terms, exactly as `kernel/README.md` promises;
* the one genuinely new side condition (schematic generalisation, G3) is
  machine-checked and belted-and-braced by expansion.

The trust boundary is still the one `STATUS.md` states: declared axioms and
certificates. This layer widens `ctx.axioms` only through `install_theorem`,
which requires a checked derivation, and every such widening is reversible by
expansion.

---

## 9. Testing

`python3 runtime/tests/test_execute.py` — **47/47**, every capability paired
with a planted control. The four the brief names:

| control | test |
|---|---|
| a rewrite whose justification the checker rejects | `test_planted_false_rule_is_never_applied`, `test_forged_rule_contributes_nothing_to_the_egraph` |
| an e-match that must **not** match modulo an unmerged equality | `test_ematch_does_not_match_across_an_unmerged_equality` |
| an extraction claiming a dominated route is Pareto-optimal | `test_dominated_route_is_refused_by_the_frontier` |
| a saturation that must report budget exhaustion | `test_saturation_reports_budget_exhaustion_not_a_fixpoint` |

plus: `Conjecture` edges refused as rules; `Eq` edges with unchecked proofs
refused; theorems that justify themselves refused; schematic parameters that
collide with an axiom refused; forged theorem expansions that do not check;
open bindings refused; bare-variable patterns refused; sorts respected across
classes; chords droppable without losing equalities; geodesics never longer than
the forest route; `max_targets` refusing rather than truncating; determinism of
e-matching, saturation and the demo; and a grep asserting no float appears
anywhere in the package.

**Mutation-tested.** A green suite that has not been mutation-tested is an
untested suite. Thirteen deliberate defects were injected into copies of the
package — dropping the checker call from `apply_rule`; letting a bound
e-matching variable match any class; hard-wiring `is_fixpoint` to `True`;
dropping the strictness half of domination; merging without checking; degrading
the geodesic to the forest route; ignoring the visit budget; skipping the
schematic side condition; believing a theorem's offered proof; costing an
unverified path; truncating instead of refusing; silently dropping chords; and
dropping the congruence lift from a rewrite justification — and the suite kills
all thirteen.

---

## 10. What breaks first at scale

Ordered by how soon it bites.

1. **E-matching is exponential in pattern size and this bound is doing real
   work.** The memo and the head index cut the demo's e-match cost by three
   orders of magnitude, and they only postpone the problem:
   a pattern with several variables over classes of thousands of members will hit
   `max_visits`, and then saturation correctly reports `budget:ematch` and every
   claim downstream becomes "as far as we got". The fix is the standard one and
   is not cheap: compile patterns to an e-matching automaton (a discrimination
   net over the e-graph), and index nodes by `(spine head, arity, child classes)`
   so candidate generation is a join rather than a scan. **This is the one that
   matters**, because a partial e-match makes the fixpoint claim unavailable.
2. **`Budget.max_exhaustive_vars = 1` is a route-materialisation cliff.** Rules
   with two or more variables bind canonically, so their right-hand sides are
   built at one representative per class. No equality is lost, but the frontier
   only ever contains terms someone materialised — so a *better route to a term
   nobody built* is invisible. Raising the threshold multiplies node count by
   `|class|^vars`. The real fix is extraction that selects from classes rather
   than from stored terms (bottom-up Pareto extraction over the class DAG), at
   which point materialisation stops mattering.
3. **Chords make the record graph dense, and everything downstream is over that
   graph.** 32 unions produced 225 chords here — a factor of 8. `RouteFinder`'s
   Dijkstra is `O(E log V)` per target and it is run per target, so extraction is
   `O(|class| · E log V)`; the kernel's own `explanation_classes` is worse
   (exponential simple-path enumeration, and on this graph it hits `max_depth`
   before finding a short route at all, which is why `homotopy` mode is not the
   default). Fix: one multi-target Dijkstra from the task per graph, and a
   homotopy-class enumeration that searches by increasing axiom count rather than
   depth-first.
4. **`merge`'s duplicate-id scan is `O(records)`** — `kernel/STATUS.md` failure
   mode #2 — and L3 is what makes it bite, because saturation calls `merge` once
   per application. 257 applications over 517 records is already ~10⁵ comparisons
   and it is quadratic in the number of merges.
5. **Global memo caches are never evicted.** `_SIZE_CACHE`, `_MEMBERS_CACHE` and
   `_INDEX_CACHE` grow for process lifetime, keyed by addresses and class tuples
   that are themselves permanent. Correct, deterministic, and unbounded. Wants
   generation-scoped tables, like the intern table it mirrors.
6. **No retraction path.** A theorem installed from an axiom that is later
   retracted stays in `ctx.axioms` and stays a rule. `expand_path` would still
   produce a primitive proof, and that proof would then fail to check — so the
   failure is *loud*, which is the right failure mode, but the bookkeeping that
   should have withdrawn the rule is `CRYSTAL.md` §L4's dependency cone and it is
   not built.
7. **`verify` is nearly collinear with `steps` on flat proof paths.** The axis
   earns its place only on congruence-heavy routes. On a task whose proofs are
   all root-level rewrites it is close to `4·steps`, and a four-component vector
   with two near-parallel components is a three-component vector wearing a hat.

---

## 11. Files

| file | contents |
|---|---|
| `rewrite.py` | `Rule`; `rule_from_axiom` / `rule_from_edge` / `install_theorem` (G1–G3); positions, `match`, `apply_rule`, `rewrite_all`; proof-path arithmetic — `count_steps`, `reverse_path`, `substitute_path`, `expand_path` |
| `ematch.py` | `EMatchBudget`, `EMatch`, `EMatchResult`; class member/index caches; the two-phase memoised matcher; `ematch`, `ematch_rule` |
| `saturate.py` | `Budget`, `Application`, `SaturationResult`, `saturate` |
| `extract.py` | `CostVector`, `dominates`, `pareto`, `is_nondominated`; `RouteFinder` (the geodesic); `Route`, `measure_route`, `extract_routes`; `Scalarization`, `ScalarChoice`, `scalarize`; `FrontierDiff`, `frontier_diff` |
| `../demo/geodesic_demo.py` | the measured demonstration; exits 0 iff every claim above holds |
| `../tests/test_execute.py` | 47 tests, every planted-false control |
