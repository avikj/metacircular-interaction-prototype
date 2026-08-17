# `runtime/vocabulary` — letting the loop name things, and what that did not buy

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

> **The ceiling, in the generate lane's own words** (`generate/README.md` §7.1):
> *the construction schema is finite and human-written — nothing inside the loop
> invents a constructor family.* Both held-out benchmarks drop exactly once and
> ten further rounds of generation, proving and crystallizing buy nothing. The
> organism can discover new **theorems**; it cannot discover new **things to
> talk about.**

This package lets it discover new things to talk about, honestly — and then
measures whether that breaks the plateau.

```
python3 runtime/demo/vocabulary_demo.py          # ~100 s, exit 0 iff audits pass
python3 runtime/demo/vocabulary_demo.py --quick  # ~20 s
python3 runtime/tests/test_vocabulary.py         # 36/36, 10 planted controls
```

---

## 1. The answer, first, because it is negative

| | B1 `(x²+3y)(x²−3y)+9y²` | B2 `(x²+2y)²−4y²` | B3 `(x²+2y)(x²−2y)(x⁴+4y²)` | B4 *(disqualified, §6)* |
|---|---:|---:|---:|---:|
| baseline, empty book | 29 | 24 | 80 | 41 |
| **(A) fixed vocabulary**, round 11 | 12 | 14 | **80** | 28 |
| **(B) self-extending**, round 11, 12 constructors | 12 | 14 | **80** | 28 |
| **(C) null control**, round 11, 12 constructors | 12 | 14 | **80** | 28 |

**(A) plateaus from round 2. (B) does not break the plateau. (C) does not
either.** Neither buys one kernel step on any held-out problem, in any round.
`(B) beats (A) on any benchmark in any round: NO` is computed and printed by the
demo rather than asserted here.

And (B) is not a no-op — that is checked, because a null result from code that
did nothing is worthless:

```
constructors installed        12
seeds contributed to GENERATE 22
final book, (A)/(B)/(C)       9 / 5 / 12 lemmas
extended theorems checked     23, all unfolded and re-checked in the base
```

(B) changed which shapes GENERATE built, which changed which lemmas got mined,
which changed the book. It changed everything except the number that matters.

**Why that was the expected shape.** A definitional extension is *conservative*:
it proves no theorem of the old vocabulary that was not already provable. So a
new vocabulary can only ever change **reachability under a budget** — which is
exactly the claim that what you can name determines what you can find, isolated
from the claim that naming proves things. Section 5 measures the reachability
change. It is zero on the benchmarks and slightly negative on cost.

---

## 2. What is built

| file | what |
|---|---|
| `define.py` | a constructor is `c(#0..#k-1) := body`; defined heads live in the substrate's `kind` field; `unfold` (elimination), `fold` (the direction that makes a name useful), the defining equation as a kernel-checked `Eq` edge, and per-instance unfolding edges lifted by real congruence steps |
| `propose.py` | where constructors come from: recurring **objects** in the loop's own derivation record, and proved **quotients**. Plus the count-matched null pool, labelled as the control. Plus `vocab_leakage_report` |
| `conservativity.py` | the guard: seven admission gates, and the elimination argument *executed* on every theorem the extended loop proves |

### 2.1 A defined symbol in this substrate

`crystallize.derivation` hash-conses on `"<kind>|<child addresses>"`, and `val`
is **not** part of that encoding for a compound head. So the constructor name
goes in the `kind` (`"def:sqr"`), not in `val` — otherwise `sqr(x)` and
`cube(x)` would be the same address and one constructor's unfolding could be
applied to another's instance. `test_defined_heads_are_hash_consed_injectively`
pins it.

Two consequences fall out, both wanted:

* every primitive ring rule guards on `kind == PROD` / `kind == SUM`, so **no
  primitive rule fires on a defined node**. A defined term is inert to the base
  engine.
* `evaluate`, `degree_bounds` and `poly_equal` treat an unknown compound head
  as a *product*, so handing them a defined term produces a confident wrong
  answer. `require_base` raises instead, and every crossing back into the base
  vocabulary in this package goes through it. The control
  `x_defined_term_reaches_the_base_semantics_unguarded` demonstrates the wrong
  answer the guard prevents — it is not a hypothetical.

### 2.2 The seven admission gates

| gate | demand |
|---|---|
| **D1** | the constructor name is fresh, and unused in any existing body |
| **D2** | arity ≥ 1, and the body is a term rather than a bare parameter |
| **D3** | the defining equation's left side is the **new head applied to distinct parameters** — it constrains no old symbol |
| **D4** | the body mentions only base symbols and **strictly earlier** definitions (so unfolding terminates and eliminates) |
| **D5** | the body's parameters are exactly `#0..#k-1` — none free, none unused |
| **D6** | unfolding the definition's own left side is *run* and must reach a base term |
| **D7** | no side equations ride along with the definition |

**D3 is the conservativity gate.** `x*y := x+y` has a fresh name attached and
looks like a definition, but its left side is a term of the old language, so the
equation constrains `*` and `+` and would prove `2*3 = 2+3`. It is refused, and
a refused definition declares **no axiom at all** — the `AxiomVault` discipline
of `generate/multiway.py`, applied to vocabulary instead of to rewrites.

### 2.3 Conservativity, executed rather than cited

The standard argument is that every proof using the new symbol unfolds to one
that does not. `conservativity.unfolds` runs that argument on an actual theorem:

1. unfold both sides (counted), demanding base terms;
2. normalise both with the **base** engine and demand one address;
3. re-check every step of both derivations with `check_derivation`;
4. decide the identity again with `poly_equal` — complete on this substrate and
   structurally unrelated to (2)–(3).

All four must hold. Every theorem the extended loop proves goes through it
(23 in the default run, all `ok`), and the planted control
`x_extended_theorem_whose_unfolding_does_not_check` — `sqr(x) = x*x*x`, a
statement nothing about which is malformed — is caught only here.

`base_answers_unchanged` is the blunt statement of the same thing: normalisation
is a decision procedure on this substrate, so fixing the answer fixes the
provable set, and the answers are asserted equal by **address**.

---

## 3. Where constructors come from — and the source that is not implemented

`crystallize/` mines recurring **rewrite patterns** and turns them into lemmas.
This module mines recurring **objects**. Those are different: a lemma is a new
route between terms the loop can already write down; a constructor is a term the
loop could not write down before.

**Source 1 — recurring subterms.** Walk every subterm of every recorded term,
abstract its ordinary variables to parameters (integers stay concrete: `3y` and
`5y` are different objects), and count. A *derivation record* is one seed's
orbit in one round's multiway graph, `r3-s1`.

```
score(s) = freq(s) × spread(s) × (size(s) − 1)      ties on canonical key
```

`freq` alone rewards one runaway derivation repeating itself; `spread` — the
number of **distinct** derivation records — is the factor that demands
independence. `size − 1` so that naming an atom scores zero. `min_spread` is a
hard floor rather than a tiebreak, and
`x_constructor_from_a_single_derivation_is_proposed` plants exactly the claim it
refuses.

**Source 2 — proved quotients.** Every conjecture the loop *discharges* is a
kernel-checked `Eq` edge, so the equivalence those edges generate on generated
states is proved, not assumed. Its classes are the quotient's objects; the
canonical representative (least in the substrate's total order) names one.

**Source 3 — the null pool.** Not mathematics: the control. Same count, same
gates, same installation path, provenance deliberately irrelevant, and
*disjointness from the history is checked* rather than asserted.

**"Propose a random new symbol" is not implemented and is not an oversight.**
Every constructor comes from something the loop proved or measured.

### 3.1 Gate P1, which the leakage check forced

The first constructor configuration (B) ever proposed was

```
c1(#0,#1) := #0 + (-1*#1)
```

— **subtraction itself**. Its instances become seeds, and a bare subtraction
seed makes *every* term whose root is a subtraction an instance of a seed, so
`generate.loop.leakage_report`'s L4 and this module's V2 both fired on a
held-out problem. The response is gate **P1**: a constructor may not rename
syntax the substrate already has — its flat `Sum`/`Prod` heads and its one
abbreviation `Sub`. The generate lane changed its embedding when L4 fired at it
(`generate/README.md` §5); this is the same event one layer up.

---

## 4. How a constructor reaches the loop at all

An installed constructor becomes a **construction family**: its instances,
*unfolded to base terms*, are handed to GENERATE as seeds, and with two or more
constructors installed the arguments are themselves constructor instances. The
seed must be base — the multiway generator's rules are the ring axioms and a
defined head is inert to all of them — so what the vocabulary contributes is the
unfolding of a constructor instance: a shape the human schema does not
enumerate, arrived at by naming rather than by widening the schema by hand.

`VocabularyOrganism` reaches the schema by rebinding `generate.loop`'s
module-level `constructions` for the duration of `super().round`, restoring it in
a `finally`. `mode="fixed"` is asserted to leave the loop **bit-identical** to
the unmodified one (`test_fixed_mode_is_the_unmodified_loop_step_for_step`).

One implementation note that is a finding rather than a detail: a *composed*
instance is usually the interesting one and usually the one that busts the
generation budget's size cap. Falling back to the plain instance rather than
skipping is what keeps the vocabulary from being a silent no-op — without the
fallback, **2** seeds reached GENERATE in twelve rounds instead of **22**, and
the experiment would have measured nothing while looking as though it had.

---

## 5. The cost side, measured

```
      r | voc | (B) saved  bench dW  lane work  total  | (C) saved  bench dW
      0 |   1 |         0         0       3586   3586  |         0         0
      3 |   4 |         0       -44      13912  13868  |         0       -44
      7 |   8 |         0       248      26190  26438  |         0       250
     11 |  12 |         0        49      38825  38874  |         0       109
```

**The crossover is at the first constructor, in both (B) and (C)** — and the
reason is blunt rather than subtle: the benefit column is identically zero, so
*any* cost crosses immediately. `SCALE.md`'s 22-lemma crossover was a real
trade — lemmas bought 17 steps and search caught up at 22. Here nothing is
bought, so there is no trade to locate. Reporting "22" for constructors would be
reporting a number from a curve that does not exist.

The costs separate into three, and they are not the same size:

1. **Benchmark search work: not measurably affected.** Total over the four
   problems is 56,645 units in the final round; (B) differs from (A) by **+49**
   (+0.08%), (C) by **+109** (+0.19%), and the difference takes both signs
   across the twelve rounds. It tracks book size (9 / 5 / 12 lemmas), not
   vocabulary. Structurally it must: **a constructor never enters a base
   query**, which is conservativity's operational content and is asserted by
   `test_a_constructor_never_enters_a_base_query`.
2. **The proposal step's own work: this is the real cost.** 3,586 units in round
   0, **38,825** in round 11 — growing ~3,200 per round because mining re-walks
   the *whole* history every round. Cumulative **254,801** units over 12 rounds,
   quadratic in rounds. Same defect shape as `AxiomVault`'s monotonic growth
   (`generate/README.md` §7.6). A long run dies here, not on the query side.
3. **Generation displacement.** States are pinned at the budget cap (90) in
   every round of every configuration, so a constructor's seeds do not *add*
   reachable states — they take budget from the hand-written families. Naming is
   not free even when it is conservative.

**On provenance.** The honest reading is narrower than "(B) costs more than
(C)". Provenance changed *which* constructors were installed and therefore which
lemmas were mined; it did not change the sign of the benefit, which was zero in
both. The brief's alternative — "if (B) improves but so does (C), symbol count
rather than provenance is doing the work" — does not arise, because neither
improves.

---

## 6. Leakage, including one firing that was not planted

`vocab_leakage_report` runs `generate.loop.leakage_report`'s four routes (L1–L4)
and adds six:

| | |
|---|---|
| **V1** | a constructor was generalised from a witness that is a **subterm of the benchmark** |
| **V2** | the benchmark is an **instance** of a constructor body — the vocabulary analogue of L4 |
| **V3** | a constructor cites a record whose name marks it benchmark-derived |
| **V4** | a constructor body is literally a benchmark subterm address |
| **V5** | a constructor **claiming** loop provenance cites a derivation record the organism did not build |
| **V6** | a constructor was generalised from a witness in the benchmark's own **derivation closure** — every subterm of every term the base engine passes through while solving it |

**V5 and V6 exist because the planted control defeated V1–V4.** Poisoning the
history with the benchmark's normalisation trajectory leaves witnesses that are
subterms of *intermediate* terms, not of the benchmark, so V1 missed it. The
control was written first and the check was strengthened until it fired. It now
fires on both routes at once.

V5 exempts the null pool deliberately: a null-pool constructor *claims* no loop
provenance, so it has nothing to be lying about. V5 catches false claims, not
absent ones, and `test_V5_exempts_the_declared_control_and_only_the_declared_control`
relabels the pool as `"subterm"` and asserts V5 then fires.

**The unplanted firing: B4 is disqualified.** B4 = `((x+y)² − (x−y)²) − 4xy` was
written by a human before round 1 as a harder held-out problem. In the default
configuration **V6 fires on it**: six constructors were generalised from
witnesses lying in B4's own derivation closure. Everything in B4 is something
the loop builds from `x` and `y` anyway, so B4 is *not independent of the loop's
history*. **It is excluded from every improvement claim**, and it stays in the
tables so the exclusion is visible rather than tidied away. B1, B2 and B3 draw no
finding in any configuration, and that is asserted in the demo rather than
eyeballed.

This is the second time in this runtime that a mechanical check rejected a
*human* choice rather than a machine one. The first is `generate/README.md` §5.

---

## 7. Where the new ceiling sits

The diagnosis is one pair of measurements, reproduced by the demo:

```
B3, flat 3-ary product                     base  80  ->  book  80    lemmas fired: none
B3, the SAME polynomial, binary grouping   base  54  ->  book  37    lemmas fired: L1
```

`L1` is the mined difference-of-squares lemma, `(#0+#1)*(#0−#1) ⇒ #0² − #1²`. Its
left side is a **binary** product. B3's root is a **3-ary** product. The
substrate has flat n-ary products and its only associativity rule splices nested
products *upward*; nothing introduces a grouping. So the redex is there, the
lemma is there, and the matcher cannot see one from the other. **B3's 80 steps
are untouchable by any lemma this loop can mine, in every configuration
including (A).**

A constructor does not fix this, and the reason is exact:

* **proposal by generalisation from history is closed.** The set of shapes a
  constructor can name is closed under "already built". The four hand-written
  families build binary products; every proposal is therefore a binary product;
  every lemma mined from a constructor's seeds is therefore a binary lemma.
  Naming *re-describes* the reachable set, it does not enlarge its shape space.
* **and it may not be used on a base problem anyway.** That is conservativity,
  and it is not a technicality: the extended vocabulary is barred from the
  benchmark by the same argument that makes it safe.

So the ceiling moved from *"the construction schema is finite and human-written"*
to *"the proposal mechanism cannot leave the schema's shape space"*. It moved by
exactly one level and it is still a ceiling. That is a real result and it is the
one the brief flagged as more likely.

**What would break it**, stated so the next lane does not have to guess: a
proposer that reads the **residual of a failed match** — *why* did L1 not fire on
B3? because its redex is buried in a 3-ary product — and names the missing
grouping, rather than one that generalises the shapes that did occur. That is a
different mechanism, driven by an obstruction rather than by a frequency, and it
is the natural next thing for this lane. It is not implemented here and nothing
in this package pretends otherwise.

---

## 8. What breaks first, ordered

1. **The proposal step is O(history) per round, O(rounds²) cumulative** (§5.2).
   The fix is the same one `crystallize` needed: index the history's shapes
   incrementally instead of re-walking it. Nothing here is incremental.
2. **Constructors are never retired.** `COMPRESS` drops never-firing lemmas;
   there is no analogue for a never-instantiated constructor, so `max_definitions`
   is a cap rather than a policy. The same criticism `generate/README.md` §7.3
   makes of `COMPRESS`'s grace period applies here with less excuse.
3. **`fold` is a fixpoint loop with a hard iteration cap**, tried in installation
   order, so which constructor claims an overlapping subterm depends on install
   order. Nothing downstream trusts `fold` — whatever it produces is unfolded and
   re-checked before it counts — but a *different* fold would state different
   extended theorems.
4. **The quotient source is shallow.** It union-finds discharged conjectures and
   names class representatives. It does not use the quotient's *structure* —
   `distinguish/`'s coarsest-sufficient-quotient machinery is right there and is
   not called.
5. **The residual source named in the brief is not implemented.** `atlas/`'s
   groups, torsors and cocycle classes are not ring terms, so naming one would
   need a second substrate bridge. The quotient source is implemented instead and
   the residual source is absent rather than faked.
6. **`VocabularyOrganism` rebinds a module-level name.** It is restored in a
   `finally` and `mode="fixed"` is asserted bit-identical to the unmodified loop,
   but it is a rebinding and not a supported extension point. A `constructions`
   hook in `generate/loop.py` would be the honest fix and belongs to that lane.
7. **The instance-axiom table grows monotonically.** `unfold_edge` declares one
   axiom per distinct unfolding instance and never collects — the same defect as
   `AxiomVault` (`generate/README.md` §7.6) and `crystallize`'s `_INTERN`.

---

## 9. Determinism and exactness

CPU-only, pure Python 3 stdlib, exact integers, no float constructed anywhere
(asserted by a test that also refuses `random.` and `time.time`), no network, no
model. Output byte-identical across `PYTHONHASHSEED` 0 / 12345 / 999, asserted by
a subprocess test over the vocabulary fingerprint, the round rows, the unfolding
reports and the top candidates.

## 10. Contract notes

* **C1.** `generate.loop.Organism` is subclassed, not modified. No file outside
  `runtime/vocabulary/`, `runtime/demo/vocabulary_demo.py` and
  `runtime/tests/test_vocabulary.py` was changed; all ten pre-existing suites
  were run before and after and are unchanged.
* **C2.** `Vocabulary.install_unchecked` exists and is named that way. The
  guarded door is `conservativity.admit`. A test needs the unguarded one to plant
  a bad definition and watch the unfolding check catch it downstream.
* **C3.** `vocab_leakage_report` may look at the benchmark; the loop may not.
  That asymmetry is the whole design of a leakage check, and `derivation_closure`
  is where it is most visible — computing V6's target requires *solving* the
  benchmark, which is precisely what the loop is forbidden to do.
