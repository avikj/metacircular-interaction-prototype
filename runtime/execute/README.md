> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/execute` — L3 execution, the geodesic engine

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

> Every accepted equality may become a rewrite; … the runtime chooses among
> implementations by declared task and a **cost vector**, keeping nondominated
> routes rather than collapsing to one scalar fitness. — `CRYSTAL.md` §2 L3

**Status: BUILT.** `python3 runtime/tests/test_execute.py` → **59/59**, and the
suite kills every one of 13 injected defects. `python3
runtime/demo/geodesic_demo.py` → exit 0, ~6 s, byte-identical under
`PYTHONHASHSEED` 0/12345/999.

Two things named in §10 as "what breaks first" have since been **built**, and
this file has been brought current for both: the **e-matching automaton** (§3.4,
§10 item 1) and **Pareto extraction over the class DAG** (§5.1, §10 item 2).
What changed in the contract is recorded in §12, not applied silently.

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

### 3.4 Two engines, and which one runs

The description above is the **recursive** matcher. It is no longer the default.
`ematch.DEFAULT_ENGINE = "automaton"`: a pattern is compiled **once** (and
cached) by `compile_pattern` into a flat instruction sequence over registers
holding e-classes — `app`/`lam` branch, `const`/`var`/`vbind`/`vcmp` filter —
walked in pattern preorder so the automaton returns **the same matches in the
same order** as the recursive matcher. Both engines are kept and selectable:
`ematch(..., engine="automaton"|"recursive")`.

The one structural change: **candidates are e-node *signatures*, not e-nodes.**
A bind step can only expose the *classes* of a node's children, so two nodes of
one class with the same child classes are one candidate. In a curried IR that
collapse is large, and it removes structurally the blow-up the memo table
existed to survive.

Measured (`SCALE.md` §4, full tables and caveats there):

| | recursive | automaton |
|---|---:|---:|
| demo saturation e-match visits (277 calls) | 33,630 | **16,962** |
| AC-saturated k=6 graph (6,549 nodes), total lookups | 739,278 | **239,994** |
| search-dominated patterns (late compares, no matches) | — | **2.7×–4.7× faster** |
| two match-materialisation-dominated patterns | — | **3–10% slower** |

The two slower rows are in the table, not in a footnote. Three honest caveats:
`max_visits` is a **budget, not a metric** and its unit differs between the
engines (§4.4 of `SCALE.md`), so a caller who pinned a `max_visits` against the
recursive engine may see `exhausted=True` sooner under the automaton on AC-like
graphs; the differential test
`test_ematch_automaton_agrees_with_the_recursive_matcher` asserts equal match
keys **in equal order** over eight patterns × two graph sizes; and this is **not
an asymptotic improvement** — e-matching is still exponential in pattern size.

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

### 5.1 Extraction over the **class DAG** — `extract_class_frontier`

`extract_routes` costs the terms that are *members of the e-class*: the terms
someone materialised. §10 item 2 named why that is a cliff — with
`max_exhaustive_vars = 1` a multi-variable rule fires at one representative per
class, so most combinations of realisations are never built, and **a better
route to an unbuilt term is invisible**. `extract_class_frontier` is the fix
that item named.

**What it does.** An e-node is a head plus a tuple of child *classes*, so a term
is recovered by choosing, for every class, one realisation — and the chosen
combination need never have been built. The classical scalar version is a
fixpoint (a class's best cost = min over its nodes of the node's cost combined
with its children's best costs); here the cost is a *vector*, so a class carries
a **Pareto set** of `ClassOption`s instead of a single best.

A `ClassOption` is a term, the e-node it was assembled from (its *anchor*), the
sub-proofs of its replaced children, and three **exactly compositional** costs:
`steps` (kernel steps in the proof), `size`, `width`. `verify` is deliberately
absent from the per-class filter — it is the checker's own counter delta from
verifying a *complete* route, and there is no complete route until an option is
attached to the task. It is measured, exactly, once, on the finished routes.
**So the per-class Pareto is exact in three components and silent in the
fourth**, which is a stated approximation, not an oversight: an option dominated
on `(steps, size, width)` but cheaper in `verify` can be dropped. On this task
`verify` is near-collinear with `steps` (§10 item 7), which is why the
approximation is tolerable here and why it is written down rather than implied.

**Re-anchoring.** An option's proof is `class root = term`, but the class root
is not usually where the consumer starts. `ClassOption.path_from(src)` rebuilds
the same realisation from any address in the class; since the root is one
possible `src`, re-anchoring can only shorten the route.

**Termination, stated rather than assumed.** The scalar fixpoint terminates
because costs only decrease and the integers are well founded. *That argument
does not survive the move to a vector*, and the class graph can be cyclic (a
class may contain a node one of whose child classes is the class itself, once
e.g. `x = x*1` is proved). Going once round such a cycle produces a term that
properly contains an option of the same class, so its `size` strictly increases
— but it may strictly *decrease* `width` or `steps`, so it is not dominated, and
the Pareto set of a class in a cyclic class graph is **not guaranteed finite**.
Termination here is therefore *by construction*: at most `max_rounds` rounds
(round *k* can only produce terms of assembly depth *k*), at most `max_options`
options per class, at most `max_terms` assemblies in total. Where the class
graph is acyclic the fixpoint genuinely converges and **the round at which no
class's option set changes is detected** — the result then reports
`complete=True` and no bound bound. Where a bound does bind, `ClassSolution.reason`
names which, and it is propagated into `ExtractionResult.partial_targets` /
`.reasons` through the same channel `homotopy` mode uses. On the demo's graph it
converges in **4 rounds before the theorem and 3 after**.

**Nothing is trusted.** Every assembled route goes to `check_path` before it is
costed, exactly as `extract_routes` does; one that fails is counted in
`rejected` and never returned. The extractor never adds a node, a record or a
merge to the e-graph (`test_class_dag_extraction_does_not_mutate_the_egraph`),
so the graph the geodesic engine measures is untouched — which does mean an
assembled target is **not** an e-graph member and `g.equal` cannot be asked
about it. The checker can, and is.

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
| before | fixpoint | 4 | 257 | 32 | 225 | 309 | 17 | 517 | 16 962 |
| after `pow4` | fixpoint | 4 | 265 | 32 | 233 | 317 | 17 | 533 | 19 260 |
| null control | fixpoint | 4 | 257 | 32 | 225 | 309 | 17 | 517 | 16 962 |

The e-match visit column is the **automaton's** counter, which is what the demo
now prints (§3.4). Under `engine="recursive"` the same three rows are 33 630 /
37 082 / 34 484 — the same fixpoint, the same 257/265/257 applications, the same
frontier, a different amount of work to get there. The two counters are not the
same unit and must not be compared across engines (`SCALE.md` §4.4).

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
| e-match work it cost anyway | **+0 visits** under the automaton, **+854** under the recursive matcher |

A true, checked, irrelevant theorem costs search work and buys nothing. The gap
between that row and the table above it is the entire claim: the runtime is not
caching, it is applying mathematics that happens to apply.

The e-match row moved when the automaton became the default (§3.4) and is worth
stating rather than quietly re-issuing: the automaton's candidate-signature
collapse makes the irrelevant `plus`/`dbl` theorem cost **nothing measurable**
on this graph, where the recursive matcher paid 854 visits to fail. That
*weakens* the "it costs work and buys nothing" half of the null control on this
particular counter — the theorem is still applied 0 times and the frontier is
still bit-identical, which is the half the claim rests on, but the cost side of
it is now engine-dependent and is reported as such.

### The frontier again, extracted over the **class DAG** (demo §13)

Same two graphs, same cost vector, same checker; the only change is that
candidate routes are assembled from e-classes instead of read off stored terms.

| | stored terms (`extract_routes`) | class DAG (`extract_class_frontier`) |
|---|---:|---:|
| nondominated routes, **before** | 11 | **16** |
| nondominated routes, **after** | 9 | **14** |
| frontier routes to a term the e-graph **never built**, before | 0 by construction | **4** |
| …after | 0 by construction | **3** |
| candidate destinations considered, before / after | 99 / 102 | 103 / 105 |
| routes rejected by the checker | 0 | **0** |
| class fixpoint | — | converged in 4 rounds (10,627 assemblies) / 3 rounds (7,865) |
| curvature (`frontier_diff`) | appeared 2, vanished 4, shortened 4 | appeared 6, vanished 8, shortened 5 |

**Before** the theorem, the four frontier points that no stored-term extraction
can see:

| assembled term | steps | size | width | verify |
|---|---:|---:|---:|---:|
| `mul (mul (mul (mul #3 #3) (mul #3 #3)) #9) (mul #3 #3)` | 8 | 11 | 6 | 41 |
| `mul (mul (mul (mul #3 #3) (mul #3 #3)) (mul #3 #3)) (mul #3 #3)` | 11 | 10 | 2 | 57 |
| `mul (mul (mul #3 #3) (mul #3 #3)) #81` | 12 | 9 | 9 | 59 |
| `mul (sqr #9) #81` | 16 | 7 | 11 | 79 |

The second row is the clearest one: at `width = 2` the stored-term frontier
offers `size 8` only at **15** steps and nothing between `size 12` and `size 8`.
The assembled `size 10 / 11 steps` point beats both on one axis and neither
dominates the other — a genuinely new corner of the frontier, reachable by a
term nobody ever built.

Every one of the 208 class-DAG destinations across both runs was evaluated by
the demo's independent exact-integer evaluator: **one value, 6561**. The null
control leaves the class-DAG frontier **bit-identical** to the before-run, as it
does the stored-term one.

#### The number this moves, said loudly

| route to `sqr (sqr (sqr #3))` | before | after | change |
|---|---:|---:|---:|
| shortest route through the **retained merge records** (`RouteFinder`, §7 above) | 24 | 15 | **−9** |
| shortest route extracted over the **class DAG** | **20** | 15 | **−5** |

Both columns are checked proofs. The class-DAG extractor finds a **20-step**
proof *before* the theorem that `RouteFinder`'s shortest path through the
justification graph does not: 24 is a minimum over **record-graph routes**, not
over checkable proofs, because a congruence proof assembled from freely chosen
sub-geodesics need not correspond to any single retained congruence record.

So the honest effect of `pow4` on this target is **−5**, and the **−9** in §7
above (and in `STATUS.md`, which quotes it as "24→15 steps on one target") is
partly an artifact of how thoroughly the *before* run was extracted. **The
direction of the claim is unchanged**: the theorem still strictly shortens this
target, no route got longer, the frontier still moves, and the null control
still changes nothing. What is no longer defensible is the *magnitude* −9 as a
statement about proofs rather than about record-graph routes. §7's table is left
as it stands because it is a correct statement about `RouteFinder`, which is
what produced it; this row is the correction.

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

`python3 runtime/tests/test_execute.py` — **59/59**, every capability paired
with a planted control. The four the brief names:

| control | test |
|---|---|
| a rewrite whose justification the checker rejects | `test_planted_false_rule_is_never_applied`, `test_forged_rule_contributes_nothing_to_the_egraph` |
| an e-match that must **not** match modulo an unmerged equality | `test_ematch_does_not_match_across_an_unmerged_equality` |
| an extraction claiming a dominated route is Pareto-optimal | `test_dominated_route_is_refused_by_the_frontier` |
| a saturation that must report budget exhaustion | `test_saturation_reports_budget_exhaustion_not_a_fixpoint` |

plus, for the two things built since (§3.4, §5.1): the automaton and the
recursive matcher returning **equal match keys in equal order** over eight
patterns × two graph sizes and over binder patterns; the automaton honouring the
same budget discipline; a pattern compiled once and reused; an unknown engine
name refused; a class-DAG frontier point that lands on a term the e-graph
**never built** and still checks; the class-DAG frontier matching or beating
every stored-term frontier point; the class fixpoint converging *and saying so*;
the class fixpoint under each of `max_rounds`, `max_options` and `max_terms`
refusing to call itself converged (the planted falsehood being "we found some,
so we are done"); an unknown bound refused rather than ignored; assembled routes
being re-checked against a different book and **failing**, because "our own
fixpoint assembled it" is not a reason to believe it; class-DAG extraction being
deterministic; and class-DAG extraction leaving the e-graph's terms, records and
classes untouched.

Plus: `Conjecture` edges refused as rules; `Eq` edges with unchecked proofs
refused; theorems that justify themselves refused; schematic parameters that
collide with an axiom refused; forged theorem expansions that do not check;
open bindings refused; bare-variable patterns refused; sorts respected across
classes; chords droppable without losing equalities; geodesics never longer than
the forest route; `max_targets` refusing rather than truncating; determinism of
e-matching, saturation and the demo; and a grep asserting no float appears
anywhere in the package.

**Mutation-tested — but note what is and is not covered.** A green suite that
has not been mutation-tested is an untested suite. Thirteen deliberate defects
were injected into copies of the package — dropping the checker call from `apply_rule`; letting a bound
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

1. ~~**E-matching is exponential in pattern size and this bound is doing real
   work.** … The fix is the standard one and is not cheap: compile patterns to
   an e-matching automaton (a discrimination net over the e-graph), and index
   nodes by `(spine head, arity, child classes)` so candidate generation is a
   join rather than a scan.~~ **The automaton is BUILT** (§3.4,
   `execute/ematch.py`, `DEFAULT_ENGINE = "automaton"`, the recursive matcher
   retained and selectable). Measured: demo saturation 33,630 → **16,962**
   visits, 3.1× fewer total lookups on an AC-saturated 6,549-node graph,
   2.7×–4.7× faster on search-dominated patterns, **3–10% slower on two
   match-heavy patterns**. **The bound itself is untouched**: e-matching is
   still exponential in pattern size, the automaton enumerates the same search
   tree, and a pattern with several variables over wide classes will still hit
   `max_visits` and still make saturation report `budget:ematch`. What was
   removed is constant factors, not the exponential — so this item is downgraded,
   not deleted. Full numbers and the two adverse rows: `SCALE.md` §4.
2. ~~**`Budget.max_exhaustive_vars = 1` is a route-materialisation cliff.**
   … The real fix is extraction that selects from classes rather than from
   stored terms (bottom-up Pareto extraction over the class DAG), at which point
   materialisation stops mattering.~~ **BUILT** — §5.1,
   `extract_class_frontier`. On the demo's before-graph the frontier goes
   **11 → 16** nondominated routes, **4 of them to terms the e-graph never
   built**; after the theorem **9 → 14** with 3 unbuilt. `max_exhaustive_vars`
   is still 1 and the e-graph still materialises one representative per class:
   what changed is that extraction no longer *depends* on that, so the cliff no
   longer shows up in the frontier. Two things this does **not** fix: the
   *saturation* search still only ever fires rules at canonical representatives,
   so an equality that would only be discovered by e-matching against an unbuilt
   term is still not discovered; and the per-class Pareto filter is exact in
   `(steps, size, width)` and silent in `verify` (§5.1).
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
7. **The class-DAG fixpoint is bounded, not convergent, on cyclic class
   graphs.** §5.1's termination argument is by construction. On an e-graph
   carrying a unit law (`x = x*1`) the class graph has a cycle and the Pareto
   set of a class is not guaranteed finite, so `max_rounds`/`max_options` will
   bind and the result will honestly say `complete=False`. Nothing measured here
   exercises that case — the demo's class graph is acyclic and converges — so
   the bounds' behaviour under a genuinely cyclic class graph is *untested at
   scale*, which is a gap, not a guarantee. The combination count is also
   `|options|^arity` per node per round, and `max_terms` exists because that is
   the number that will bite.
8. **`verify` is nearly collinear with `steps` on flat proof paths.** The axis
   earns its place only on congruence-heavy routes. On a task whose proofs are
   all root-level rewrites it is close to `4·steps`, and a four-component vector
   with two near-parallel components is a three-component vector wearing a hat.

---

## 11. Files

| file | contents |
|---|---|
| `rewrite.py` | `Rule`; `rule_from_axiom` / `rule_from_edge` / `install_theorem` (G1–G3); positions, `match`, `apply_rule`, `rewrite_all`; proof-path arithmetic — `count_steps`, `reverse_path`, `substitute_path`, `expand_path` |
| `ematch.py` | `EMatchBudget`, `EMatch`, `EMatchResult`; class member/index caches; the two-phase memoised recursive matcher **and** the compiled automaton (`compile_pattern`, `Program`, `DEFAULT_ENGINE`); `ematch`, `ematch_rule` |
| `saturate.py` | `Budget`, `Application`, `SaturationResult`, `saturate` |
| `extract.py` | `CostVector`, `dominates`, `pareto`, `is_nondominated`; `RouteFinder` (the geodesic); `Route`, `measure_route`, `extract_routes`; **`ClassOption`, `ClassSolution`, `ClassExtractor`, `extract_class_frontier`, `DEFAULT_DAG_BOUNDS`** (§5.1); `Scalarization`, `ScalarChoice`, `scalarize`; `FrontierDiff`, `frontier_diff` |
| `../demo/geodesic_demo.py` | the measured demonstration, §1–§14; exits 0 iff every claim above holds. §13 is the class-DAG frontier, §14 the verdict |
| `../demo/ematch_bench.py` | both e-match engines against one AC-saturated graph — `SCALE.md` §4.3 |
| `../tests/test_execute.py` | 59 tests, every planted-false control |

---

## 12. Contract changes

This section exists because other lanes code against this file, and a silently
edited document is indistinguishable from a document that was always right.
Each entry says what the contract *was*, what it *is*, and why it moved.

| # | when | symbol / claim | was | is | why |
|---|---|---|---|---|---|
| C1 | scale lane | `ematch(g, pattern, variables, budget=…)` | one engine: the memoised recursive matcher | `ematch(…, engine=None)` selecting `"automaton"` (the default) or `"recursive"`; patterns compiled once by `compile_pattern` and cached | §10 item 1 named the automaton as the thing that must be built. Matches are **identical in content and order** under both engines (differential test), so no caller's answer changes. |
| C2 | scale lane | `EMatchBudget.max_visits` | "recursive calls made" | "candidate signatures considered" under the automaton | The two engines count different events, so a caller who pinned a `max_visits` against the recursive engine may see `exhausted=True` sooner on AC-like graphs. `max_visits` is a **budget, not a metric**, and cross-engine comparisons of it are meaningless (`SCALE.md` §4.4). |
| C3 | repair lane | extraction | `extract_routes` only, over the members of an e-class — i.e. over the terms that were materialised | `extract_class_frontier` additionally, over the **class DAG**: a Pareto fixpoint whose realisations need never have been built | §10 item 2's named fix. `extract_routes` is **unchanged** and still the demo's published extractor, so every §7 counter reproduces to the unit. The new function is additive. |
| C4 | repair lane | "the geodesic to `sqr(sqr(sqr #3))` is 24 before the theorem" (§7) | presented as the route length | a minimum over **record-graph routes**; the minimum over checkable proofs found by the class-DAG extractor is **20** | Extraction weakness, not mathematics. The theorem's honest effect on that target is **−5**, not −9. §7's table is correct about `RouteFinder` and is left as it stands; §7's class-DAG subsection is the correction, and `STATUS.md` quotes the −9. |
| C5 | repair lane | the null control's e-match cost | "+854 visits" | **+0** under the automaton, +854 under the recursive matcher | The default engine changed (C1). The half of the null control that carries the claim — 0 applications, bit-identical frontier — is unchanged; the cost half is now engine-dependent and is reported as such. |

One thing deliberately did **not** change and should not be changed without an
entry here: `extract_routes` remains the default extractor and the source of
every number in §7's main tables, so a lane that quoted them can still reproduce
them exactly.
