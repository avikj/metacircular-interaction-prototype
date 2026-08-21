> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/crystallize` — derivation crystallization (CRYSTAL.md §3.1)

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

> A mathematical fact enters the runtime; an *independent* problem thereafter
> solves in strictly fewer kernel steps; the reduction is measured by exact
> counters, is reproducible, and the post-reduction answer is still
> kernel-checked. — CRYSTAL.md §0

**Status: the seed criterion is met.** P4 costs **29** kernel steps without
the mined lemma and **12** with it; an unrelated, equally-well-checked lemma
leaves it at **29**. Reproduce with

```
python3 runtime/demo/crystallize_demo.py     # exit 0 iff the criterion holds
python3 runtime/tests/test_crystallize.py    # 30/30
python3 runtime/demo/scale_lemmas.py --index --sizes=1,10,22,23,50,100,300,477,1000,3000
```

Pure Python 3 stdlib. CPU only. Exact integers throughout — no floating point
anywhere, including in the ranking heuristics. No ML, no network, no
randomness. Output is byte-identical across `PYTHONHASHSEED` values (verified
for 0, 12345, 999), because addresses are SHA-256 of an explicit encoding and
nothing observable iterates a `set`.

This package is **self-contained**. It imports nothing from `runtime/kernel`
or `runtime/distinguish` and defines its own minimal derivation types, so the
measurement stands on its own; wiring it to the kernel's term and edge types
is a separate integration job.

---

## 1. The domain, and why this one

**Normalisation of expressions in the free commutative ring `Z[x₁,x₂,…]`**,
with flat n-ary sum and product nodes:

```
t ::= Int(n) | Var(s) | Sum([t,…]) | Prod([t,…])           a - b  ≡  a + (-1)*b
```

Four properties made it the right choice, and each of them was load-bearing:

1. **Exactly decidable with integers.** Equality of two terms is equality of
   two polynomials over `Z`, which an integer grid evaluation *decides*
   (§4). No floats, no tolerance, no probabilistic identity testing — so the
   independent check is a proof, not evidence.
2. **Genuinely expensive the slow way.** Expanding a product of sums is
   quadratic, and reaching canonical order by adjacent transpositions is
   quadratic again. `(x+y)(x−y)` costs 16 primitive steps. There is real work
   to crystallize; a domain where everything is cheap cannot demonstrate
   anything.
3. **It hosts a repeated pattern whose LGG needs a consistent variable map.**
   Difference of squares is the honest test case for Plotkin/Reynolds
   anti-unification: the abstracted subterm occurs at *two* positions on the
   left and *two* on the right. Generalise `(x+y)(x−y)` and `(u+v)(u−v)` with
   a consistent map and you get `(#0+#1)(#0−#1) = #0² − #1²`, a theorem.
   Generalise them without one and you get `(#0+#1)(#2−#3) = #0² − #1²`,
   which is false. The mined *shape* is identical in both cases; only the
   variable map separates the theorem from the falsehood. That is exactly the
   failure a runtime must be able to reject, so the domain supplies its own
   adversary.
4. **A valid-but-irrelevant sibling lemma exists.** Perfect squares,
   `(#0+#1)² = #0² + 2·#0·#1 + #1²`, are mined by the same code from the same
   kind of training problems, pass the same seven gates, and are simply not
   applicable to P4. That is the null control, and it is a real theorem rather
   than a strawman.

Rejected alternatives: a finitely-presented monoid (the repeated pattern —
pushing a generator past a run of another — is *arithmetic* in the run length,
and first-order anti-unification over unary numerals cannot see it, so the
demo would have needed a rigged encoding); Boolean simplification (too cheap
per step to make the counters interesting).

Every rewrite rule is a single commutative-ring axiom instance:

| rule | axiom |
|---|---|
| `distrib` | `a*(b+c) = a*b + a*c` |
| `collect` | `c₁*m + c₂*m = (c₁+c₂)*m` |
| `sort_prod`, `sort_sum` | commutativity (one adjacent transposition) |
| `flat_prod`, `flat_sum` | associativity |
| `fold_prod`, `fold_sum` | evaluation in `Z` |
| `unit_prod`, `unit_sum`, `zero_prod` | `1*a=a`, `0+a=a`, `0*a=0` |
| `single_*`, `empty_*` | unary/nullary flattening |

Strategy: innermost-leftmost redex, fixed rule priority, lemmas tried over the
whole term before any primitive fires. Termination is by a lexicographic
measure (size · sums-under-products · inversions · summand count) and is
*enforced* at runtime by a cycle guard on whole-term addresses plus a hard
step cap — both raise `Divergence` rather than return a wrong answer, so a
badly installed lemma cannot loop silently.

---

## 2. Mining, and its honest cost

A **segment** of a derivation is a contiguous run of steps `[i..j]` whose
rewrite positions all lie under one common position `p`. Nothing outside `p`
is touched, so the segment *is* a derivation of the subterm at `p`:

```
u = before_i|p   ——steps i..j——>   v = after_j|p
```

Its **shape key** is the sequence of `(rule name, position relative to p)`
pairs — the sub-DAG's rules, order, and geometry. Equal keys mean the same
sub-DAG applied to different data, so mining is a hash join, not subgraph
isomorphism.

**The bound.** Enumerating all sub-DAGs is exponential (`2^L` subsets, and
connectivity does not save it). Exact-but-exponential is unacceptable, so:

> **Bounding heuristic: contiguity plus a window.** Only contiguous runs of at
> most `window` steps are considered (default 24).

**Cost.** At most `L·window` segments per derivation; the common-position and
key computations are `O(window)` each; total **`O(D·L·window²)`** for `D`
derivations plus `O(#segments)` hashing. In the demo: `D=3`, `L≤19`,
`window=24` → **791** counted operations. Polynomial for any input.

**What it gives up, stated plainly.** Sub-DAGs whose steps are interleaved
with unrelated steps are invisible, and so are repetitions longer than
`window`. Those are real losses. They are cheap here only because an
innermost-leftmost strategy keeps related work contiguous — that is a property
of *this strategy*, not a theorem about the miner. The demo prints the mining
cost so the price is visible.

**Support is counted in derivations, never in occurrences.** A pattern
repeating ten times inside one problem has support 1 and is not mined:
CRYSTAL.md says "across *different* derivations", and self-repetition is a
loop, not a lemma. There is a test for this.

---

## 3. Anti-unification

`Generalizer` implements first-order LGG with the one thing that matters: a
map from *tuples of disagreeing subterms* to variables, consistent across the
entire generalisation — including across the lemma's left and right sides,
which is what lets the RHS be expressed in the LHS's parameters at all.
Identical subterms are never abstracted. Linear, `O(k·m)`, no backtracking.

`recover(g, i, gen)` reconstructs instance `i` from the generalisation via its
witness substitution; the installer refuses any candidate where a
reconstruction misses. That is a necessary condition, not a sufficient one —
`test_pattern_not_actually_shared_produces_a_lemma_that_fails_the_check`
plants a forgery that satisfies it and is still destroyed downstream.

---

## 4. The checking discipline

A mined candidate is a *proposal*. It becomes a lemma only by passing seven
gates, all-or-nothing, no confidence score:

| gate | what it demands |
|---|---|
| **G1** well-formed | RHS variables ⊆ LHS variables; sides differ; LHS not a bare variable |
| **G2** LGG soundness | every mined instance recovered by its witness substitution |
| **G3** proof rebuilt | instantiate the parameters with fresh ground indeterminates and **re-derive the generalised statement from scratch** with the primitives |
| **G4** proof fidelity | the rebuilt rule sequence equals the mined sub-DAG's rule sequence |
| **G5** endpoint | the rebuilt normal form is exactly the generalised RHS (address equality) |
| **G6** kernel check | every rebuilt step re-validated against its rule schema — the checker re-runs the rule, it does not trust the recorded contractum |
| **G7** independent semantics | `poly_equal` decides the identity by exact evaluation on an integer grid |

G3–G6 are syntactic replay; **G7 is denotational and structurally unrelated**,
so the two can disagree and a candidate passing one but not the other is
rejected and worth investigating.

G7 is a *decision procedure*, not a spot check: a polynomial over `Z` of degree
≤ `dᵢ` in `xᵢ` that vanishes on a grid of `(d₁+1)×…×(d_k+1)` integer points is
identically zero (induction on `k`; over an integral domain a univariate
polynomial of degree ≤ `d` with `d+1` roots is zero). The bounds come from the
term structure.

**Why a fresh-indeterminate rebuild covers all instantiations.** The
generalised statement is an identity in `Z[#0,#1,…]`, which is initial among
commutative `Z`-algebras; an identity there maps to an identity under every
substitution of ring elements. So the installed rewrite is sound at arbitrary
*compound* arguments — and the demo fires it on arguments (`x*x`, `3*y`) that
no mined instance exhibited.

G4 is deliberately strict, and rejects statements that are *true* but proved
by other steps. A lemma is a crystallisation of the mined derivation or it is
not that lemma. `test_true_but_differently_proved_lemma_fails_fidelity` pins
this down as a design decision rather than an accident.

**Installing a lemma may not change any answer.** The rewrite is derivable
from the primitives (that is what G3–G6 establish), so it changes the route
and never the normal form. Asserted over a 14-term battery under three
different books.

---

## 5. The measurement

Training: the *same* shape in three different surroundings with three
different variable pairs.

```
P1 = (x+y)(x−y)          P2 = 7 + (u+v)(u−v)          P3 = (a+b)(a−b) + a
```

Mining finds one 16-step sub-DAG at positions `[]`, `[1]`, `[0]` with support
3 and anti-unifies it to

```
(#0 + #1)*(#0 + (-1*#1))   ==>   (-1*#1*#1) + (#0*#0)
```

Independent problem, **not used in mining and mechanically checked not to be
an instance of any Pᵢ**:

```
P4 = (x*x + 3*y)*(x*x − 3*y) + 9*y*y          answer  x*x*x*x
```

Null control, mined by the same code from `Q1=(x+y)²`, `Q2=5+(u+v)²`,
`Q3=(a+b)²+a`, passing all seven gates:

```
(#0 + #1)*(#0 + #1)   ==>   (2*#0*#1) + (#0*#0) + (#1*#1)
```

### Kernel steps

| problem | before | after | with null lemma | answers agree | independently verified |
|---|---:|---:|---:|:--:|:--:|
| P1 \* | 16 | 1 | 16 | yes | yes |
| P2 \* | 17 | 2 | 17 | yes | yes |
| P3 \* | 19 | 4 | 19 | yes | yes |
| **P4** | **29** | **12** | **29** | **yes** | **yes** |

\* used in mining, so their reduction proves nothing. **P4 is the experiment.**

### Search work (rule/lemma match attempts)

Reported separately so a step reduction bought with unbounded search cannot
hide behind the headline number.

| problem | before | after | with null lemma |
|---|---:|---:|---:|
| P1 | 2769 | 137 | 3013 |
| P2 | 3166 | 306 | 3453 |
| P3 | 3196 | 593 | 3501 |
| P4 | 5431 | 1567 | 6096 |

The null lemma raises search work by 12% while leaving the step count exactly
unchanged — which is what an irrelevant fact should do, and is the clearest
single number in the table: the runtime is not caching, it is applying
mathematics that happens to apply.

### Verdict

- P4: **12 < 29**, a 17-step reduction to 41% of baseline. **Strict.**
- Null control: **29**, unchanged. **Passes.**
- Answer identical in all three runs (`x*x*x*x`), and independently decided by
  exact grid evaluation, not by the rewriter that produced it.
- Every step of the post-reduction derivation — including the lemma step —
  re-validated against its schema by the checker (`checks == steps`).

**Seed criterion: MET.**

---

## 6. What would break first at scale

Ordered by how soon it bites.

1. ~~**Lemma matching is a linear scan over positions × book.** Every
   normalisation iteration tries every lemma at every position: `O(|book| ·
   |term|)` match attempts *per step*. The null-control row already shows the
   symptom — +665 work units for one irrelevant lemma. At a few hundred
   lemmas the search cost overtakes the step savings and the headline number
   becomes a lie told with a true counter. Fix: index lemma LHSs by a
   discrimination net or top-symbol/flat-term index so only plausible lemmas
   are tried. This is the first thing that must change.~~ **MEASURED, AND
   FIXED — see §6.1.** The crossover is real and this section was wrong about
   *where*: it is at **22 lemmas**, not a few hundred. The discrimination net
   this item named is built (`derivation.LemmaIndex`) and moves it to 477 per
   query, or removes it entirely when the index is built once per book.
2. **The window/contiguity heuristic is strategy-dependent.** It works because
   innermost-leftmost keeps related work adjacent. Any strategy that
   interleaves — parallel rewriting, e-graph saturation, a scheduler — makes
   the shape key miss the pattern entirely, and the miner will report support
   1 for a pattern that is genuinely everywhere. Fix: mine over the
   dependency DAG (steps connected by term addresses) instead of over the
   linear trace, and pay a real subgraph-matching cost with a real bound.
3. **Shape keys are exact-match, so the miner is brittle.** One extra
   `sort_sum` from a different variable name ordering and two occurrences of
   the same mathematics land in different buckets. Support undercounts, and it
   undercounts *silently*. Fix: key on a canonical form of the sub-DAG modulo
   commuting independent steps.
4. **G7's grid is exponential in the variable count.** `∏(dᵢ+1)` points, with
   a cap at 300 000. Any lemma over more than a handful of variables, or with
   high degree, becomes uncheckable by this route and falls back to G3–G6
   alone — losing the independent witness exactly where it is most wanted.
   Fix: modular/interpolation-based identity testing with an exact
   Schwartz–Zippel bound over a large enough prime field, keeping the check
   exact and complete rather than probabilistic.
5. **Candidate blowup.** 3 derivations of ≤19 steps produced 104 candidates.
   The count grows like `D·L·window`, and every one of them costs a full G3–G7
   verification if installed naively. Fix: verify only the Pareto frontier
   (steps saved × support), and cache verdicts by `(lhs, rhs)` address pair.
6. **Interned terms are never collected.** `_INTERN` grows monotonically for
   process lifetime. Fine for a demo, fatal for a long-running runtime. Fix:
   weak-value interning, or generation-scoped tables.
7. **No lemma composition or subsumption.** Two mined lemmas where one is an
   instance of the other both get installed and both get tried forever. There
   is no retraction path either, so a lemma installed from a later-retracted
   axiom cannot be withdrawn — CRYSTAL.md §L4's dependency cone is exactly the
   missing machinery.

### 6.1 Item 1, measured and built (this is no longer a prediction)

`runtime/SCALE.md` §2–3 tests the paragraph above against a book grown to 3,000
mechanically generated, individually seven-gate-checked lemmas, none of which
can fire on P4. Verdict: **right in kind, ~15× optimistic in degree.**

| | predicted here | measured |
|---|---|---|
| where the scan's cost overtakes the step saving | "a few hundred" | **22 lemmas**; net loss from 23 |
| does the step count decay with book size? | not claimed | **no** — 12 steps at N=1 and at N=3000; null book 29 at every size |
| the named fix (a discrimination net) | "the first thing that must change" | **built**: `LemmaIndex` in `derivation.py` |

`LemmaIndex` stores, per probe position (root, `(0)`, `(1)`, `(2)`, `(0,0)`,
`(0,1)`, `(1,0)`, `(1,1)`), a dict from `(kind, val, arity)` key to an integer
bitmask of lemmas, plus a wildcard mask for the lemmas unconstrained there. A
lookup is eight dict hits and eight integer ANDs, and the survivors are read out
in installation order. It is a **filter, never a truncation**: the candidate
list is a superset of the matches, so the derivation is identical step for step,
which the suite asserts three ways —
`test_discrimination_net_returns_the_same_derivation_as_the_scan`,
`test_discrimination_net_candidates_are_a_superset_of_the_matches` (the planted
control: every lemma the net drops is re-matched by brute force at every node of
every test term and must fail), and
`test_discrimination_net_index_can_be_built_once_and_reused`. Every probe
lookup and every insertion bumps the same `work` counter as the scan it
replaces, so the cost is charged, not hidden.

| N | steps | scan work | net, built per query | net, index amortised |
|---:|---:|---:|---:|---:|
| 22 | 12 | 5,431 | 1,799 | 1,623 |
| 477 | 12 | 89,151 | 5,439 | **1,623** |
| 3000 | 12 | 553,383 | 25,623 | **1,623** |

Per-query construction moves the crossover 22 → **477**; an index built once per
book removes it — query work is **constant at 1,623 from N=10 to N=3000**, which
is 3.3× *cheaper* than the empty-book baseline of 5,431, at every size.

**It is off by default.** `normalize(..., use_index=False)` is the default, so
every counter in §5 above reproduces to the unit. Flipping the default is a
one-word change in `normalize` and belongs with a re-issue of the §5 tables; the
scale lane deliberately did not make that change inside this lane's README.
Full method, the generated-lemma families, and the validity/irrelevance
enforcement are in `SCALE.md` §1–3.

Items 2–7 below are unchanged and remain unfixed.

---

## 7. Contract changes

This section exists because other lanes code against this file, and a silently
edited document is indistinguishable from a document that was always right.
Each entry says what was claimed, what is true now, and why it moved.

| # | when | symbol / claim | was | is | why |
|---|---|---|---|---|---|
| C1 | scale lane | `derivation.normalize` | `normalize(start, lemmas=(), ...)` — a linear scan over positions × book, with no alternative | `normalize(start, lemmas=(), ..., use_index=False, index=None)`; `LemmaIndex` is a discrimination net over lemma left sides, selectable per call and reusable across calls | §6 item 1 named the scan as "the first thing that must change" and it was measured to bite at 22 lemmas. The default is unchanged so every published counter still reproduces; the new keywords are additive and a caller written against the old signature is unaffected. |
| C2 | scale lane | §6 item 1's estimate | "at a few hundred lemmas the search cost overtakes the step savings" | **22 lemmas**, with the curve, the slope (184 work per lemma per query at 12 steps) and the null-book slope (665) in `SCALE.md` §2 | The estimate was a prediction, not a measurement, and this README presented it as the operative number. It was right that a crossover exists and wrong by ~15× about where. |
| C3 | repair lane | test count | 27/27 | **30/30** | Three tests were added with `LemmaIndex` (same derivation, superset-of-matches control, index reuse). No test was removed or weakened. |

Two things deliberately did **not** change, and should not be changed without an
entry here: the seven gates are still all-or-nothing with no confidence score,
and `use_index` still defaults to `False` so §5's numbers stay reproducible.

---

## 8. Files

| file | contents |
|---|---|
| `derivation.py` | hash-consed ring terms and addresses; positions; `Counter` (steps / work / checks); `Step`, `Derivation`; the rule set; matching and substitution; `normalize` (with `use_index` / `index`); **`LemmaIndex`**, the discrimination net over lemma left sides; the checker (`check_step`, `check_derivation`); the exact semantic decision `poly_equal` |
| `antiunify.py` | `Generalizer` (Plotkin/Reynolds LGG with the consistent variable map), `antiunify`, `antiunify_tuples`, `recover`, `variable_positions` |
| `mine.py` | `Segment`, shape keys, the windowed miner, `Candidate`, `reconstruction_ok` |
| `install.py` | the seven gates (`verify`), `Verdict`, `Book`, `solve` |
| `../demo/crystallize_demo.py` | the measured demonstration; exits 0 iff the seed criterion holds |
| `../demo/scale_lemmas.py` | the book-size curve, the crossover, and the net — `SCALE.md` §2–3 |
|  `../tests/test_crystallize.py` | 30 tests, including every planted-false control |
