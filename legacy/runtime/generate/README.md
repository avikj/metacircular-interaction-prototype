# `runtime/generate` — the missing arrow, and the loop it closes

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

> ```
> GENERATE     construct reachable states from constructors
> DISTINGUISH  find collisions where the current view loses required behavior
> PROVE        certify transformations, equivalences, obstructions
> CRYSTALLIZE  abstract repeated derivations into executable lemmas
> COMPRESS     minimize representation relative to declared tasks
> ROUTE        select nondominated implementations by cost vector
> REALIZE      compile to symbolic / executable / perceptual surfaces
> REFLECT      feed execution residuals back as new distinctions
> ```
> — `CRYSTAL.md` §7

Every layer built before this one is **reactive**: hand it mathematics and it
improves. `crystallize/` mines derivations *it is given*. `distinguish/`
refines a view against tasks *it is declared*. `execute/` shortens routes for
goals *someone sets*. Nothing produced mathematics, so §7's cycle — which
begins at GENERATE and ends at REFLECT feeding back into GENERATE — had never
run.

This package runs it. **There is no model anywhere in the cycle.** That is the
thesis being tested, not a restriction being tolerated: CPU-only, pure Python 3
stdlib, exact integers, no float constructed anywhere (asserted by a test), no
randomness, no network, byte-identical across `PYTHONHASHSEED` 0 / 12345 / 999
(asserted by a subprocess test).

```
python3 runtime/demo/organism_demo.py            # ~35 s, exit 0 iff audits pass
python3 runtime/demo/organism_demo.py --quick    # ~15 s
python3 runtime/tests/test_generate.py           # 37/37, 8 planted controls
```

---

## 1. The result, first

Two held-out benchmarks, both fixed **before round 1**, neither ever a seed, a
generated state, a mining input, a compression input or a routing input —
machine-checked four ways by `leakage_report`, with three planted leaks that
the check must catch.

| | baseline | full loop, 12 rounds | null loop (CRYSTALLIZE removed) |
|---|---:|---|---|
| **B1** `(x²+3y)(x²−3y) + 9y²` | **29** steps | 12,12,12,12,12,12,12,12,12,12,12,12 | 29 × 12 |
| **B2** `(x²+2y)² − 4y²` | **24** steps | 24,**14**,14,14,14,14,14,14,14,14,14,14 | 24 × 12 |

Both answers unchanged and re-decided independently by exact grid evaluation
(`poly_equal`), and every benchmark derivation kernel-checked in the round that
reports it.

**The loop is learning, not merely generating.** The null trajectory is the
control that decides it: same generation (1,680 states), same distinction, same
proving (407 conjectures), same compression, routing and reflection — only the
arrow that turns repeated derivations into lemmas removed — and the benchmark
does not move by one step.

**And the honest shape of it is a two-step staircase, not a curve.** B1 drops in
round 0, B2 in round 1, and then eleven and ten further rounds respectively
generate ~1,400 more states, discharge ~330 more conjectures and install more
lemmas that buy either benchmark *exactly nothing*. Each benchmark improves
once. §7 below says why, and it is not a property of crystallization.

**There is a real regression, and it is in the table rather than a footnote.**
At round 0 the book helps B1 and is useless to B2 — so B2's *search work* goes
`5025 → 5874` (+849) while its step count sits unmoved at 24. A checked, valid,
irrelevant lemma costs search and buys nothing. That is `SCALE.md`'s finding
appearing inside a live loop, on a problem the loop has never seen, and it is
pinned by `test_an_irrelevant_book_costs_search_and_buys_nothing`.

### The search cost fights back exactly where SCALE.md said

`SCALE.md` §2 measured the linear lemma scan at **+184 work units per lemma per
query** and a crossover at 22 lemmas. Running the same loop twice, differing
only in whether the discrimination net is used:

| round | book | B1 steps (net / scan) | B1 work, net | B1 work, scan | Δ |
|---:|---:|---|---:|---:|---:|
| 0 | 2 | 12 / 12 | 1625 | 1751 | +126 |
| 1 | 4 | 12 / 12 | 1625 | 2119 | +494 |
| 2 | 6 | 12 / 12 | 1625 | 2487 | +862 |
| 3 | 8 | 12 / 12 | 1625 | 2855 | +1230 |
| … | | | | | |
| 11 | 6 | 12 / 12 | 1654 | 2487 | +833 |

Step counts identical in every row. The scan column climbs at 184 work per
lemma — the slope `SCALE.md` measured on a synthetic book, reproduced by a loop
building its *own* book. With the net amortised across the round, query work is
flat. The crossover does not bite here **because the fix was used**, not because
it was avoided.

---

## 2. `multiway.py` — Wolfram, repaired

A raw multiway system rewrites, keeps every history, and cannot tell a
theorem-preserving step from a corruption: "A became B" carries no guarantee.
Everything else here follows from repairing that one thing.

**States** are terms of the crystallize substrate (free commutative ring
`Z[x₁,…]`, flat n-ary sums and products). **Every rule at every position** is
applied — not the normaliser's single innermost-leftmost successor — and **all
histories are retained**: a state reached two ways keeps both edges.

**Every edge is a typed kernel edge**, `kernel.edges.Edge(kind="Eq", …)`,
carrying a proof path that `kernel.check.check_edge` validates. Ring terms are
encoded into the kernel's curried STLC —

```
I(n)         -> Const("z:n"  : R)
V(s)         -> Const("v:s"  : R)
Sum(a₁..a_k) -> sum_k  a₁ … a_k      sum_k  : R -> … -> R
Prod(a₁..a_k)-> prod_k a₁ … a_k      prod_k : R -> … -> R
```

— a rewrite at ring position `p` becomes an `Axiom` step at the redex, lifted to
the root by genuine `check.Step(kind="congruence")` nodes, one per level, with
the untouched sibling carrying the empty path. Encoding injectivity is asserted
over every generated state (`test_encoding_is_injective_…`); without it a
collision could launder a corrupt step into a true one.

### The admission chain

`CheckContext.axioms` is the kernel's trust assumption **T3** — its only
unproved input. `AxiomVault` is the *sole* writer to it in this lane, and it
declares nothing until two independent exact gates pass:

| gate | demand | structurally |
|---|---|---|
| **A1** schema re-run | the named ring rule, re-run on the redex, returns the recorded contractum, address for address | syntactic |
| **A2** independent semantics | `poly_equal(redex, contractum)` — exact evaluation on an integer grid whose size is a *complete* degree bound, so a decision, not a spot check | denotational |

Only then does the axiom exist; only then can a lifted path cite it. Three
refusal paths, all exercised by the demo and by planted controls:

```
corrupt contractum                  REFUSED [A1]  ((x+y)(x-y)) -/-> ((x*x))
TRUE but mis-attributed contractum  REFUSED [A1]  ((x*x) + (-1*y*y))
forged edge, undeclared axiom       REFUSED [K]   "undeclared axiom"
accepted graph after all three      1 edge, 1 axiom
```

The second one is the interesting refusal. `(x+y)(x−y) = x² − y²` is a *true
theorem*; A2 passes it happily. It is still refused, because A1 asks what the
**named rule** does, not what happens to be true. A system that accepted it
would be a system in which the provenance of an edge is decorative.

`MultiwayGraph.audit()` re-checks every retained edge under a **fresh**
`CheckContext` (not the one that admitted them) and asserts every edge is `Eq`.
`Conjecture` edges are never constructed in this module at all.

### Causal structure

Two composable edges are **causally dependent** when their positions are nested
and **concurrent** when they are disjoint; a concurrent branch pair whose two
orders reconverge is a **closed diamond**, the local form of causal invariance.
A representative round: `causal 186, concurrent 74 | disjoint branch pairs 86,
diamonds closed 34/86 | branching states 49, max out-degree 8`.

Measured, reported, and — see §7 — **not yet used for anything**.

---

## 3. `propose.py` — collisions become conjectures, and then three fates

`CRYSTAL.md` §3.2 says a collision is not a failure but a *specification*. Read
generatively: a collision between two distinct constructions specifies a
candidate theorem.

**The channel.** A probe is an integer point plus a modulus; `mod = m` reads the
value through `Z → Z/m`. Both are exact. The default channel is deliberately
**coarse** (§3.2 step 2: "start from the coarsest observation") — two diagonal
points read mod 3 and mod 4. A channel that already separates everything
proposes nothing, and a loop that never proposes a falsehood has nothing to
refute and nothing to learn from.

**Cross-construction priority, and why it is not a thumb on the scale.** Two
states of one construction's rewrite orbit are *already joined by an accepted
path* in the multiway graph, so a conjecture between them is one the runtime can
discharge by construction. Under a budget, an enumeration that fails to prefer
cross-construction pairs spends itself entirely on conjectures that cannot fail.
`collisions(..., sources=…)` puts cross-source pairs first inside each bucket;
`test_collisions_are_a_permutation_under_source_priority` asserts the *set* is
unchanged and only the order moves. (Both the breadth-first-across-buckets
enumeration and the source priority were added after observing the failure they
fix: 0 counterexamples in 6 rounds.)

**Three fates, no fourth.**

| fate | how | what it produces |
|---|---|---|
| **DISCHARGED** | route A: normalise both sides under the current book, compare addresses. route B: `execute.saturate` over a kernel e-graph whose rules are the multiway graph's accepted `Eq` edges, installed by `execute.rule_from_edge` | a real `Eq` edge whose path the kernel checks; for route B the e-graph's `explain` is expanded back to primitives by `execute.expand_path` and **re-checked in a context where no theorem is declared** |
| **REFUTED** | an exact integer point from the audit grid at which the two sides differ | a counterexample — and its dependency cone is invalidated through `propagate.invalidate` + `propagate.recompute.apply` |
| **OPEN / EXHAUSTED** | neither, inside the budget | a residual: reported, fed back by REFLECT, and **never used** |

A refutation is *sound as a decision*: two polynomials agreeing everywhere agree
at that point, so disagreement proves they are different polynomials.
`test_every_refutation_is_semantically_false` re-decides all of them with
`poly_equal`; `test_every_accepted_discharge_is_semantically_true` does the
converse for the accepted side.

**The two graphs are two graphs.** `ProposalGraph.conjectures` holds
`Conjecture` edges and a `propagate.DependencyGraph`; `accepted_edges` holds
`Eq` only. `audit()` re-checks every accepted edge under a fresh context *and*
asserts the checker still rejects every conjecture. The control
`x_conjecture_used_as_if_discharged` attacks the boundary three ways at once —
`accept()` with a Conjecture edge, `rule_from_edge` on one, `check_edge` on one
— and all three must refuse.

### Why a conjecture can have a cone at all

A `Conjecture` composes with nothing, so it can never enter an accepted
derivation. But conjectures chain *speculatively*: from candidates `a ~ b` and
`b ~ c` this module proposes `a ~ c` and records the dependency. That closure
graph lives entirely on the proposal side, and it is what gives a counterexample
something real to invalidate:

```
retract c|56cc97c2…: cone 2/68 facts | survive 0, die 2, undecided 0
                   | 66 untouched by construction | 9 L4 steps
```

Over twelve rounds: 96 closure edges, 37 cones computed, largest 6 facts. The
planted control `x_refuted_conjecture_leaves_its_cone_standing` performs the
naive handling — mark the refuted conjecture and stop — and asserts the
speculative consequence survives, which is exactly the bug `propagate/` exists
to prevent.

---

## 4. `loop.py` — the arrows, and the one that is not wired

| arrow | implementation | built by |
|---|---|---|
| GENERATE | `multiway.generate` | this lane |
| DISTINGUISH | `propose.collisions` over the exact channel | this lane |
| PROVE | `propose.triage` = `crystallize.normalize` (route A) + `execute.saturate` / `execute.rule_from_edge` / `execute.expand_path` (route B) | `crystallize/`, `execute/` |
| CRYSTALLIZE | `crystallize.mine` + `Book.install` (all 7 gates) + `crystallize.LemmaIndex` | `crystallize/` |
| COMPRESS | never-firing lemmas dropped; probes that separate nothing dropped (§3.2's converse) | this lane |
| ROUTE | `execute.dominates` over an exact 4-component cost vector | `execute/` |
| **REALIZE** | **NOT WIRED** | — |
| REFLECT | residuals → next round's seeds; separators → next round's channel | this lane |

**REALIZE is not wired and is not faked.** `render/` builds perceptual surfaces
from a channel spec; nothing in this loop consumes one. Wiring it would produce
a picture nobody reads and an arrow in a table. `ARROWS` says `NOT WIRED`,
`test_arrows_that_are_not_wired_say_so` asserts exactly one arrow does, and the
demo prints it as `--` rather than `ok`.

Everything else runs. Two things about the running are worth stating.

**The book feeds back into generation.** Installed lemmas participate in the
next round's multiway expansion as extra rules, so a round's reachable set
depends on what earlier rounds proved. The cycle is closed at the term level,
not only at the measurement level.

**COMPRESS may not consult the benchmark, and structurally cannot.** Firing
counts come only from generated targets.
`test_compress_never_consults_the_benchmark` asserts that two runs produce
identical books, channels and Pareto frontiers regardless of what benchmark is
measured afterwards.

---

## 5. The leakage check

The cheapest way to fake this result is to make the benchmark a generation
target. `leakage_report` checks four routes, for **each** benchmark, at subterm
granularity:

| | |
|---|---|
| **L1** | the benchmark was handed to GENERATE as a seed |
| **L2** | any **subterm address** of the benchmark appears among the generated states — so generating a *piece* of it counts |
| **L3** | the benchmark was one of the derivations CRYSTALLIZE mined from |
| **L4** | the benchmark is an **instance** of a seed — the subtle one, because a seed the benchmark instantiates makes the "independent problem" an instance of a training problem. This is the condition the crystallize lane checks by hand in its demo; here it is mechanical |

L4 is not decorative: it fired during construction of this lane. An earlier
embedding `S(shape, fresh_var)` made B1 an instance of a seed, and the check
caught it; the embedding now reuses the shape's own first atom, exactly as the
crystallize demo's `P3` does. **The construction schema was changed because the
leakage check rejected it**, which is the only kind of evidence a leakage check
can offer that it is doing anything.

Three planted controls, each of which must be detected:
`x_benchmark_as_generation_target_…` (L1), `…reached_as_a_generated_state…`
(L2, subterm granularity), `x_benchmark_is_an_instance_of_a_seed` (L4).

**What the leakage check does not cover, and must not be read as covering.**
The construction schema and the benchmarks were both written by a human before
round 1, in the same sitting, by someone who knew both. Nothing *inside* the
loop has seen a benchmark — that is what is machine-checked — but the *choice*
of what families to generate is a human prior, and no test here launders it into
something else. The claim is "no human and no model in the loop", not "no human
ever".

---

## 6. Files

| file | contents |
|---|---|
| `multiway.py` | ring↔kernel bridge (`encode`, `kernel_dirs`, `lift_path`); `AxiomVault` and gates A1/A2; `MEdge`, `Refusal`, `MultiwayGraph` with `admit`/`audit`; `generate`; `causal_report` |
| `propose.py` | probes and the exact modular channel; `collisions`; `Conjecture` / `Discharge` / `ProposalGraph`; `eq_edge_from_derivations`; `discharge_by_rewriting`, `discharge_by_saturation`, `triage`; refutation and cone invalidation |
| `loop.py` | `BENCHMARKS` (fixed before round 1), the construction schema, `Config`, `RoundReport`, `Organism` with one method per arrow, `leakage_report` |
| `../demo/organism_demo.py` | the deliverable: 10 sections, exit 0 iff every audit passes |
| `../tests/test_generate.py` | 37 tests, 8 planted controls, every one invoked and asserted to fire |

---

## 7. What breaks first

Ordered by how soon it bites.

1. **The construction schema is finite and human-written, and that — not
   crystallization — is why the trajectory plateaus.** Nothing inside the loop
   invents a new constructor family. Once the four families are exhausted the
   loop re-derives what it already knows, and a benchmark needing a fifth kind
   of lemma will never get one. This is the single largest gap between what is
   built and what §7 describes: GENERATE constructs from constructors, but the
   *constructors* are given.
2. **PROVE is nearly complete on this substrate, so REFLECT's intended residual
   stream is almost empty.** Normalisation decides equality here and the audit
   grid decides inequality, so conjectures essentially never survive a round:
   `still open / budget-exhausted: 0` in every run. The residuals that do flow
   are the collisions the proposal budget truncated — a real stream, and the
   right one, but not the one CRYSTAL.md §7 has in mind. On a substrate without a
   decision procedure this arrow would carry the load, and this loop has not been
   tested there.
3. **COMPRESS is a measured heuristic, not a principle.** With grace 0 it deletes
   every lemma one round after installing it — observed (the benchmark went
   12 → 29 between rounds 0 and 1), then fixed with a grace period and a
   post-install firing measurement. With grace too large the book grows and §1's
   scan column is what happens. There is no principled setting here.
4. **The speculative closure graph is shallow.** Cones of 2–6 facts, one
   inference rule (transitivity), one level deep in practice. It is a real
   dependency structure and `propagate/` computes it exactly, but it is not the
   deep consequence tree that layer was built for.
5. **Causal structure is measured and discarded.** Closed diamonds are counted
   and nothing prunes on them. A multiway system that knew its confluent branches
   could skip half its expansion; this one does not.
6. **`AxiomVault` grows monotonically** — 1,303 declared axioms after 12 rounds,
   one per distinct rewrite instance ever admitted, never collected. Same defect
   as `crystallize`'s `_INTERN` (its README §6.6) and fatal for a long run.
7. **The multiway graph is rebuilt per round and thrown away** except for a
   bounded state pool. Nothing incremental, and `propagate/` — the layer whose
   entire purpose is not rebuilding the world — is used only on the proposal
   side.
