> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/curriculum` — the education layer

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

Makes one theorem executable.

> **`notes/ATLAS_OF_N.md` Theorem 4.2(3).** *Positional notation is a chart of
> $\pi_0$ requiring three choices — a finite quotient (the base), a
> trivialization of a $\mathbb{Z}/2$-torsor (the endianness), and a $2$-cocycle
> representative whose class is never zero (the carry) — on top of a
> generator/successor which it does not supply and which charts (a)–(d) do.
> Symmetry and generation require zero choices, because they live one level up,
> before truncation.*

The package builds the dependency graph of that atlas's concepts, with **every
edge carrying the theorem that forces it, quoted verbatim and checked against
the file it cites**; counts the parameters each concept requires; derives an
order from those counts; and compares that order against a hand-encoded model of
the conventional school sequence, reporting exactly how many dependency edges
each order violates and how much *choice debt* each incurs.

CPU-only. Pure Python 3 standard library. Exact integer and `Fraction`
arithmetic — **no float in any semantic path**, enforced by an AST walk over
this package's own sources in the test suite. No ML, no network, no randomness.
Deterministic: the demo and all three artifacts are byte-identical across
processes and across `PYTHONHASHSEED` values, checked in the suite.

```
runtime/curriculum/depgraph.py     concepts, justified edges, verbatim quote checking
runtime/curriculum/order.py        the choice metric, both orderings, the claim guard
runtime/curriculum/render.py       SVG + HTML artifacts, built on runtime/render
runtime/demo/curriculum_demo.py    the artifacts and the measured report
runtime/tests/test_curriculum.py   55 tests: 29 capabilities, 26 planted-false controls
```

Run:

```
python3 runtime/demo/curriculum_demo.py    # ~3 s; writes runtime/demo/out_curriculum/
python3 runtime/tests/test_curriculum.py   # 55 tests, ~40 s
```

**Independence.** Imports the standard library, `runtime/render` (for exact
colour and the SVG writer) and itself. Nothing from `runtime/kernel`,
`crystallize`, `distinguish`, `execute` or `propagate`. Asserted on the parsed
import graph in the suite. Artifacts go to `runtime/demo/out_curriculum/`
rather than `runtime/demo/out/`, because the latter belongs to `runtime/render`'s
demo and that lane's suite asserts its exact contents.

---

## 0. The result, before anything else

| | derived | conventional |
|---|---:|---:|
| **positional notation lands at** | step **13 of 13** | step 6 of 13 |
| **group action (symmetry) lands at** | step **3 of 13** | step 13 of 13 |
| dependency edges violated | **0** / 23 | **11** / 23 |
| unjustified choice debt | **0** | **7** |
| first choice introduced at | step 10 | step 4 |
| choice-free concepts taught behind a choice | 0 | 6 |

**The derived order supports the direction.** Group action at step 3, positional
notation at step 13 — dead last. And it was not tuned to: the ordering is a sort
on two computed integers, the first of which is Theorem 4.2's parameter count.

Two results that were *not* asked for and fell out of the graph anyway:

* **Unique factorization lands at step 7, before place value.** Chart (f) is
  proved from chart (a) and needs no parameter (Theorem 2.12: *"Every step is an
  instance of induction, i.e. of chart (a)"*). "Primes before place value" was
  nobody's direction; the graph produced it.
* **The carry is not last.** It lands at step 12, ahead of positional notation
  itself, because the numeral is what the three parameters assemble — chart (e)
  is the *value* of `Dig(b, ε, s)`, not one of its inputs.

The derived order in full:

```
 1 quotient / truncation                     0 choices, depth 0
 2 successor / generation                    0 choices, depth 0
 3 symmetry / group action                   0 choices, depth 0
 4 iteration / free monoid on one generator   0 choices, depth 1
 5 orbit of a group action                    0 choices, depth 1
 6 cardinality / finite sets                  0 choices, depth 2
 7 factorization / free commutative monoid    0 choices, depth 2
 8 free monoid on an alphabet                 0 choices, depth 2
 9 order / ordinals below omega               0 choices, depth 3
10 finite quotient (mod b)  — THE BASE        1 choice,  depth 1
11 torsor / endianness      — THE ORIENTATION 2 choices, depth 2
12 cocycle / carry          — THE CLASS       3 choices, depth 3
13 positional notation (place value)          3 choices, depth 4
```

---

## 1. An edge is a claim, so it ships with its theorem

`Edge` carries a `Justification`: a **source**, a **locator**, and a **verbatim
quote**. `DependencyGraph.add_edge` refuses an edge without one — that is the
planted-false control the brief asks for, and the suite plants it four ways (no
justification at all, a bare string in its place, an empty quote, a missing
locator).

Refusal at construction is the weak half. The strong half is `verify_quotes`,
which reads each cited file and checks that the quote **actually occurs in it**
after whitespace normalisation. A fabricated citation is therefore a detectable
defect rather than a matter of good faith, and the suite plants two: a plausible
invented "Theorem 4.2(4)" about a fourth choice, and a real quote with one word
altered (`least infinite ordinal` → `least infinite cardinal`). Both are caught.

**39 citations are checked and 39 are verbatim.** Citations are also restricted
to `ALLOWED_SOURCES` (`ATLAS_OF_N.md`, `DIGIT_CRYSTAL.md`, `CROSS_LENS.md`), so
the graph cannot quietly acquire a dependency on prose nobody in this repo
audited.

The 13 concepts and 23 edges, with the theorem behind each edge:

| edge | forced by |
|---|---|
| successor → iteration | Residual 2.1(2), *definitional expansions of each other* — **orientation conventional**, see §5 |
| iteration → free monoid | `DIGIT_CRYSTAL` Lemma 0.1: concatenation is graded by length, `Φ(u)∘Φ(v) = [b^{m+k}, …]` |
| symmetry → orbit | Thm 2.5 proof: *"$S_n$ acts on linear orders by transport; transitively … and freely"* |
| symmetry → cardinality | §1(c): $\mathbb{F} = \operatorname{core}(\mathbf{FinSet})$, *finite sets and bijections* |
| quotient → cardinality | §0: *"A set, obtained by $\pi_0$ … This is $\mathbb{N}$"* |
| orbit → cardinality | Thm 2.2 proof: *"the objects of $\mathbb{F}$ fall into connected components indexed by $\mathbb{N}$"* |
| cardinality → order | Thm 2.5: the fibre of $U$ is *"a torsor under $\operatorname{Aut}(X) = S_n$, of cardinality $n!$"* |
| symmetry → order | Thm 2.5: chart (d) *"reaches $\mathbb{N}$ from (c) by rigidifying"* |
| orbit → order | Thm 3.2 proof: a linear order *"is the same datum as an equivalence $X ≃ \mathrm{Fin}\,n$"* |
| quotient → finite quotient | Thm 4.2(2)(i): *"equivalently a finite quotient $\mathbb{N} ↠ \mathbb{Z}/b$"* |
| successor → finite quotient | Thm 4.2(2): *"The alphabet $\{0,…,b-1\}$ is an initial segment produced by iterating the successor"* |
| finite quotient → torsor | Prop 2.10: the torsor is of *"truncation systems on the family $(\mathbb{Z}/b^n)_n$"* — no base, no torsor |
| orbit → torsor | Prop 2.10(1): the $\mathbb{Z}/2$-action *"is free and transitive"* |
| finite quotient → cocycle | Prop 2.11: *"its class in $H^2(\mathbb{Z}/b^n;\mathbb{Z}/b) …$ is nonzero"* |
| torsor → cocycle | `DIGIT_CRYSTAL` after Lemma 4.1: only the $\pi$-sheet *"carries $+$, hence the odometer, hence the carry cocycle"* |
| successor → positional | Thm 4.2(2): *"the evaluation $\sum c_i b^i$ uses $+$ and $\times$, … defined by primitive recursion"* |
| free monoid → positional | §1(e): the native operation is *"concatenation … the free affine monoid $M_b$"* |
| orbit → positional | §1(e): *"with positional evaluation being the orbit of $0$"* |
| base, torsor, cocycle → positional | Thm 4.2(3), the headline, quoted in full |
| successor → factorization | Thm 2.12: *"Every step is an instance of induction, i.e. of chart (a)"* |
| iteration → factorization | §1(f): $e((a_p)) = \prod_p p^{a_p}$ |

---

## 2. The choice metric, and why it is checked against the theorem

`Concept.own_choices` is the number of parameters a concept *introduces*, in
`ATLAS_OF_N.md` Definition 4.1's sense (a presentation is choice-free when its
parameter class is a point). `DependencyGraph.choices_required` sums that over
the transitive prerequisite closure. Positional notation therefore inherits
three parameters and introduces none — which is exactly what Theorem 4.2's
"on top of" means.

**Both directions must be justified.** A concept claiming to be choice-free
needs a `freedom_justification`; a concept introducing a choice needs a
`choice_justification` *and* a `nonredundancy` citation, because Theorem 4.2's
force comes from each parameter being nonredundant by a **separate mechanism**:

| parameter | nonredundant because | cited |
|---|---|---|
| base $b$ | $\operatorname{rad}(b)$ is a chart invariant; distinct radicals give charts with no continuous intertranslation | Cor 2.8.1 |
| endianness | only one sheet admits a group-valued limit; the chart symmetry group drops $(\mathbb{Z}/2)^2 → \mathbb{Z}/2$ with kernel the endian generator | Thm 4.2(2)(ii), `DIGIT_CRYSTAL` Lemma 4.1, Cor 4.5 |
| carry | $[c_n] \ne 0$ for **every** section, so no digit set makes the chart carry-free | Prop 2.11, Cor 2.11.1 |

`order.verify_against_atlas` runs **16 independent checks** of the graph's
arithmetic against the theorem, transcribed as data in `ATLAS_CHOICE_TABLE`:
every entry of the table matches; the multiset of choices in the whole graph is
exactly the three parameters Theorem 4.2(2) names and no others; positional
notation inherits all three and owns none; and every choice-carrying concept
cites a nonredundancy proof. The suite plants two disagreements — a graph in
which carrying is free (positional gets 2 choices) and one in which positional
owns a parameter of its own (total still 3, but the wrong shape) — and both are
caught.

---

## 3. The order is derived, and its zero is a theorem

Sort key: `(choices_required, depth, cid)`. The third component is **an
alphabetical tie-break with no mathematical content whatsoever**.

`prove_topological` shows the tie-break can never invert a dependency, edge by
edge:

> For an edge $u \to v$: $\mathrm{ancestors}(u) \cup \{u\} \subseteq
> \mathrm{ancestors}(v)$, so $\mathrm{choices}(u) \le \mathrm{choices}(v)$; and
> depth is longest-path, so $\mathrm{depth}(u) < \mathrm{depth}(v)$. The key is
> non-decreasing along every edge and *strictly* increasing whenever the first
> component ties. The third component is therefore never consulted on an edge.

Verified 23/23. This matters because **"the derived order violates 0 edges" is
otherwise a worthless number** — an order built to satisfy a metric satisfying
that metric proves nothing. The content is the *other* column, where an ordering
nobody built for it scores 11 and 7.

**The derived order is not a total order.** It is a chain of 8 antichains, and
`unordered_pairs` republishes every place the tie-break decided anything:

```
choices=0 depth=0 : quotient, successor, symmetry
choices=0 depth=1 : iteration, orbit
choices=0 depth=2 : cardinality, factorization, free_monoid
choices=0 depth=3 : order
choices=1 depth=1 : finite_quotient
choices=2 depth=2 : torsor_endianness
choices=3 depth=3 : cocycle_carry
choices=3 depth=4 : positional
```

5 of the 12 adjacencies are alphabetical only. The mathematics does not order
`quotient` against `successor` against `symmetry`; it orders *levels*.

---

## 4. The comparison, and what the two numbers mean

**Violation** — an edge whose prerequisite is taught after the concept that
depends on it. **Choice debt** —

$$\mathrm{debt}(O) \;=\; \sum_{c \,:\, \mathrm{own}(c) > 0} \mathrm{own}(c)\cdot
\big|\{u \in \mathrm{ancestors}(c) \;:\; \mathrm{pos}(u) > \mathrm{pos}(c)\}\big|$$

— every parameter charged once for each piece of structure that forces it to be
a parameter but which the reader has not met yet. That is the exact reading of
"choices introduced before the structure that motivates them".

The conventional order's 11 violations, each with its citation, are printed by
the demo. Its debt of 7 itemises as:

```
finite_quotient    1 choice x 1 unmet prerequisite  [quotient]                   = 1
torsor_endianness  1 choice x 3 unmet prerequisites [orbit, quotient, symmetry]  = 3
cocycle_carry      1 choice x 3 unmet prerequisites [orbit, quotient, symmetry]  = 3
```

Read plainly: the conventional sequence asks a reader to pick a base before
meeting a quotient, to pick an endianness before meeting a torsor or a group
action, and to carry before meeting either. That is the shape of the finding —
not "the conventional order is wrong", which is not a statement this program can
make, but "the conventional order introduces its three parameters an average of
2⅓ prerequisites early, and here is which ones."

**The conventional sequence is a hand-written model** in `order.py`
(`CONVENTIONAL_SEQUENCE`). No curriculum document was read or cited. Every
number above is a function of that encoding, and the tuple is the place to argue
with it.

---

## 5. What the graph is honest about

**One edge is oriented by convention, not by force.** `successor → iteration`.
`ATLAS_OF_N.md` §2.1 proves the comparison type between charts (a) and (b) is
*contractible* — each is definable from the other — so the arrow's direction is
a presentation decision. `Edge.symmetric` records it, `report()` counts it, and
the artifact says so. Modelling it as an edge in either direction changes
nothing downstream (both endpoints carry 0 choices), which is why it is
tolerable; hiding it would not have been.

**Depth is a modelling choice.** Longest-path. Shortest-path or edge-count would
give a different second key. The *first* key — the choice count — is the one the
theorem supplies, and it alone already separates positional notation from
everything choice-free.

**The graph covers the atlas's charts and nothing else.** Arithmetic algorithms,
fractions, measurement, negative numbers, geometry: absent. This is not a
curriculum; it is the prerequisite skeleton of one corner of one. Chart (g)
(Stern–Brocot) is not modelled, per the atlas's own §10 item 5, and chart (e) is
modelled only for integer $b \ge 2$, per its item 6.

---

## 6. The picture in which the three choices are separable

`runtime/demo/out_curriculum/choice_cube.svg`.

The language is the **eight subsets of $\{b, \varepsilon, s\}$**. Three layers
of `runtime/render`'s `ChromaticChannel` claim **disjoint single opponent
components**:

```
base b       ->  Co      (the finite quotient)
endianness   ->  Cg      (the torsor trivialization)
carry        ->  Y       (the cocycle representative)
```

so moving down the picture changes lightness only, moving across the major
division changes red/blue only, and moving inside a pair changes green only.
Each parameter owns one axis of the colour and nothing else owns it.

`certify_separability` proves this on **two independent legs**, because either
alone would be weak:

* **Structural.** The three layers claim disjoint singleton component sets
  covering all three, so two choices can never compete for one component. A
  wrong wiring is *representable* — and therefore catchable, which is the same
  reflex `runtime/render` applies to layer precedence. Three planted miswirings
  are in the suite: two choices sharing `Co`; one layer painting all three
  components; and a layer that paints nothing, collapsing 8 states to 4 colours.
* **Measured.** All 8 states × 3 flips = **24 flips, every one checked**. The
  claimed component moves by **at least 60**; every other component moves by
  **at most 14/25**, against a derived quantisation bound of **1**. Nothing is
  clamped. A gap of 14/25 to 60 is not a judgement call.

The channel is then put through `runtime/render`'s own certificates unchanged:
`validate_channel` ok, injective over 28 pairs, 8 states → 8 codes,
`certify_precedence` ok, and all three "is this parameter fixed?" tasks
preserved with 0 violations.

**What the picture is not.** The three axes are separable **in the chart**, not
orthogonal as mathematics. The endian torsor is a torsor of truncation systems
on $(\mathbb{Z}/b^n)_n$, so it is not even definable before the base is fixed
(Prop 2.10) — the graph records that as a real edge, and the picture's
independence is a property of the colour coding, not of the objects. Nor is
"carry = 0" a carry-free numeral: no digit section makes the class vanish
(Cor 2.11.1), and 0 there means *the parameter has not been chosen yet*. Both
misreadings are printed inside the SVG itself.

The second picture, `curriculum_orders.svg`, draws both orders with identical
geometry and identical palette, so any difference between the panels is the
ordering and nothing else; violated edges are red. `out_of_bounds` re-parses the
writer's own output and asserts every drawn coordinate is inside the canvas — a
picture that leaves its viewBox lies silently in every viewer.

`curriculum.html` is the traversal: 13 steps, each with what it depends on, the
theorem forcing it quoted verbatim, what it costs in parameters, and the honesty
section carried *inside* the document rather than only in the console. It is
plain hand-written HTML because `runtime/render` implements SVG only and no HTML
writer; the two SVGs are produced by `runtime/render`'s writer and inlined.

---

## 7. Honesty — mandatory, and not a disclaimer

### What is established

A **dependency order**. That positional notation is definable from generation,
symmetry and three parameters; that those parameters are each nonredundant by a
separate mechanism (radical invariance, the torsor's failure to trivialize
structure, nonvanishing $H^2$); and that generation and symmetry require none.
This is a fact about definitions, provable from the cited theorems, and it does
not depend on anybody's opinion.

### What is not established, and cannot be by this program

Anything about learners. No trial was run. No outcome was measured. No
population was sampled. No retention, transfer, error rate or time-to-mastery
was observed. **There is no learner in the domain of this computation at all** —
the vertices are mathematical constructions and the edges are theorems.

`order.certify_curriculum_claim` enforces this the way `runtime/render`'s
`certify_claim` enforces its own bound. There, a channel declaring
`INFORMATION_GAIN` is rejected because a channel is a function of state. Here, a
curriculum declaring `LEARNING_OUTCOME` is rejected because the object does not
contain the thing being claimed about. Both rejections are structural, both are
run live in the demo, and — because a verifier that rejects everything is
worthless — the `DEPENDENCY_ORDER` claim is accepted in the same breath. The
machinery discriminates.

`ATLAS_OF_N.md` Corollary 4.3 draws this line first, and this package quotes it
rather than paraphrasing so that weakening it would be a visible edit to a
quotation:

> **This corollary is a claim about dependency order and nothing else.** It is
> *not* an empirical claim about how humans learn, in what order they should be
> taught, what is pedagogically effective, or what any curriculum ought to do.

### The strongest counter-argument, stated fairly

**Logical downstream is not psychological downstream.** Positional notation is a
compressed, manipulable, externally supported representation. A child can move
ten counters into a bundle and watch a carry happen long before possessing any
notion of a cocycle, and that concrete manipulation may be exactly what makes
the abstraction learnable at all. On that view a dependency-ordered curriculum
inverts the scaffolding — it teaches the general case to learners who hold no
instance of it — and the logical priority of groups is simply irrelevant to a
mind that does not learn by definitional expansion. A weaker but still real
version: even granting that the derived order is better *eventually*, the
conventional order buys immediate arithmetic fluency, which has enormous
instrumental value, and a curriculum optimises under a time budget that this
graph knows nothing about.

The literature that bears on this — concreteness fading, worked-example and
expertise-reversal effects, the long record of discovery-learning results — is
real, was **not consulted here**, and is deliberately not summarised, because
summarising unread literature is worse than declining to.

### What would settle it, and why this system cannot produce it

A randomised trial with pre-registered outcomes: matched cohorts, comparably
prepared teachers, assessment on **transfer to genuinely novel tasks** rather
than on the notation itself (which the conventional sequence trivially wins and
the derived sequence trivially loses), long-delayed retention rather than
end-of-unit performance, and replication across ages, since the answer may well
differ by age. Ideally with the two sequences crossed against instructional
style, since "group theory first" taught badly and "place value first" taught
well is not a test of the ordering.

**This system cannot produce any of it.** It has no learner, no instrument and
no data. Adding more mathematics to it would not bring it one step closer — the
missing ingredient is not a theorem.

### Everything else that was not established

1. The conventional sequence is an **encoding**, not a measurement of any real
   curriculum. 11 violations and debt 7 are properties of that encoding.
2. 5 of 12 adjacencies in the derived order rest on an alphabetical tie-break.
3. 1 of 23 edges is oriented by convention (§5).
4. Depth is longest-path, a modelling choice (§5).
5. No claim that these thirteen concepts are the *right* decomposition — only
   that they are the ones the atlas's charts name.
6. The graph inherits every limitation of `ATLAS_OF_N.md` §10, including that
   nothing in it is machine-checked in a proof assistant. This package checks
   that the *quotations are real*; it does not check that the theorems are true.

---

## 8. Adversarial testing

**55 tests: 29 capabilities, 26 planted-false controls.** Every capability is
paired with a falsehood that must be caught.

| control | what is planted | what must catch it |
|---|---|---|
| `control_edge_without_justification` | an edge with `justification=None` | `add_edge`, at construction |
| `control_justification_must_be_a_justification` | a bare string as the justification | `add_edge`'s type check |
| `control_empty_quote` / `control_missing_locator` | a `Justification` with nothing in it | `Justification.__post_init__` |
| `control_unvetted_source` | a citation to a file nobody audited | `ALLOWED_SOURCES` |
| `control_fabricated_quote` | a plausible invented "Theorem 4.2(4)" about a fourth choice | `verify_quotes`, against the file |
| `control_altered_quote` | a real quote with one word changed | `verify_quotes` |
| `control_cycle_is_detected` | a 3-cycle in the graph | `cycles()`; `derive_order` then refuses to produce an order |
| `control_self_loop` / `control_duplicate_edge` / `control_unknown_concept` | malformed edges | `add_edge` |
| `control_ordering_violates_a_valid_dependency` | positional notation moved to step 1 | `violations`, naming all 6 broken edges and their prerequisites |
| `control_ordering_must_cover_the_graph` | an ordering missing a concept | refused rather than scored |
| `control_choice_count_disagreeing_with_atlas` | a graph in which carrying is free, so positional needs 2 | `verify_against_atlas` |
| `control_positional_owning_a_choice` | total still 3, but positional owns one | `verify_against_atlas` |
| `control_unjustified_freedom` / `control_choice_without_nonredundancy` / `control_choice_count_mismatch` | choice bookkeeping without its proof | `Concept.__post_init__` |
| **`control_learning_outcome_claim_is_rejected`** | **a claim of empirical learning benefit** | **`certify_curriculum_claim`** |
| `control_unknown_claim_kind` | `"proven-to-work-in-classrooms"` | refused, not silently accepted |
| `control_information_gain_claim_is_rejected` | the choice cube claiming information gain | `runtime/render`'s `certify_claim` |
| `control_choices_sharing_a_component` | base and endianness both driving `Co` | `certify_separability`, structural leg |
| `control_one_layer_paints_everything` | one layer claiming all three components | `certify_separability`, measured leg |
| `control_colliding_choice_cube` | 8 states painted in 4 colours | `certify_separability`, injectivity |
| `control_float_scanner_works` | a float literal and a true division | the AST scanner itself, so a green scan means something |
| `control_off_canvas_is_caught` | a rect spilling off the viewBox | `out_of_bounds` |

**Mutation-tested.** Sixteen deliberate defects were injected into copies of the
package: `cycles()` never finding a cycle; `verify_quotes` never checking;
`choices_required` forgetting the transitive closure; `Concept` no longer
requiring a nonredundancy proof; depth taking shortest instead of longest path;
`derive_order` ignoring the choice count and sorting on depth alone;
`violations` never firing; `choice_debt` counting prerequisites on the wrong
side; the learning-outcome claim accepted; `verify_against_atlas` no longer
comparing; `certify_separability` losing its disjointness leg; the same losing
its cross-talk measurement; `out_of_bounds` always passing; and three variants of
gutting `add_edge`'s justification guard.

**15 of 16 die.** The one survivor is *provably an equivalent mutant*: deleting
`add_edge`'s explicit `justification is None` branch changes no behaviour,
because the `isinstance(..., Justification)` check on the next line rejects
`None` too. The sharper mutations — deleting the type check, and deleting the
whole guard — both die. The redundant branch is kept for legibility and is
recorded here rather than quietly counted as a kill.

---

## 9. What breaks first at scale

In the order it bites.

1. **`verify_quotes` normalises each cited file on every call.** Fine at three
   notes; at a hundred sources it is the dominant cost, and the fix is a digest
   cache keyed on file mtime — which is exactly `CRYSTAL.md` L0 content
   addressing, and is not wired up.
2. **Quote matching is substring containment after whitespace normalisation.**
   It cannot detect a quote lifted from the right file but the *wrong theorem* —
   the locator is not verified, only the text. A locator index over the notes'
   heading structure would fix it and does not exist.
3. **`choices_required` is `O(V·E)` through repeated `ancestors` walks**, cached
   per concept but invalidated wholesale on any edit. Irrelevant at 13 concepts,
   quadratic at 10³.
4. **`cycles()` is recursive DFS** and will hit Python's recursion limit on a
   graph a few thousand deep. `depth` is likewise recursive.
5. **The order picture allocates one lane per overlapping edge span.** 23 edges
   need 17 lanes; the gutter grows roughly linearly in edge count and the
   picture stops being readable somewhere around 60 edges. A layered DAG drawing
   with real routing is the escape, and would give up the property that every
   coordinate is an integer the code computed.
6. **The conventional order is one hand-written tuple.** The comparison would be
   far stronger against a family of real curricula; encoding one is a data
   problem, not a mathematics problem, and this lane did not do it.
