# `execute/acmatch.py` — matching modulo associativity and commutativity

```
python3 runtime/demo/ac_demo.py            # ~11 min, exit 0 iff every audit passes
python3 runtime/demo/ac_demo.py --quick    # ~5 min
python3 runtime/tests/test_acmatch.py      # 78/78, 7 planted controls, 11/13 mutants dead
```

> **The ceiling attacked, in the vocabulary lane's own words** (`vocabulary/README.md` §7):
>
> ```
> B3, flat 3-ary product                     base  80  ->  book  80    lemmas fired: none
> B3, the SAME polynomial, binary grouping   base  54  ->  book  37    lemmas fired: L1
> ```
>
> `L1`'s left side is a **binary** product. B3's root is a **3-ary** product.
> The substrate has flat n-ary products and its only associativity rule splices
> nested products *upward*; nothing introduces a grouping. So the redex is
> there, the lemma is there, and the matcher cannot see one from the other.
> **B3's 80 steps are untouchable by any lemma this loop can mine, in every
> configuration including (A).**

---

## 1. The answer, first

| | B1 | B2 | **B3** | B4 *(disqualified)* |
|---|---:|---:|---:|---:|
| baseline, empty book | 29 | 24 | 80 | 41 |
| (A) fixed vocabulary, positional matcher | 12 | 14 | **80** | 28 |
| **(A) fixed vocabulary, AC matcher** | 12 | 14 | **37** | 28 |
| **(B) self-extending, AC matcher** | 12 | 14 | **37** | 28 |
| **(C) null control, AC matcher** | 12 | 14 | **37** | 28 |

**B3 moves 80 → 37, i.e. −43.** 37 is *exactly* the number the hand-grouped
term reaches with the same book: AC matching makes the flat 3-ary term behave
as if a human had inserted the grouping, and not one step better. The answer is
unchanged by address, re-verified by `poly_equal` (a complete decision on this
substrate), and every AC step is accepted both by `crystallize.derivation.
check_derivation` and, as an `Eq` edge, by `kernel/check.py`.

**And (B) still equals (A) equals (C).** The verdict is the **second** of the
three the brief registered, and it is the one `ac_demo.py` §0 registered as
expected *before the experiment was run*:

> **1. The matcher was a real ceiling.** The vocabulary lane's diagnosis was
> correct, precise, and about the matcher rather than about mathematics.
> **2. And vocabulary still does nothing.** Fixing the matcher lifted the floor
> for all three arms equally. The vocabulary negative is **not** an artifact of
> the diagnosed cause; it survives the repair intact, which strengthens it.

The reason (2) survives is the one the vocabulary lane already gave and this
work does not disturb: **conservativity bars a constructor from ever entering a
base query**, so a vocabulary can only change which lemmas get *mined*, and on
these benchmarks it changes them into lemmas that do the same work.

---

## 2. What is built

| symbol | what |
|---|---|
| `ACBudget`, `ACResult`, `ACIncomplete` | explicit bounds; `.matches` **raises** when the search was cut short, `.partial()` is the written-down way in |
| `ac_match(pattern, subject, budget, rhs=)` | all AC matches, sorted into a canonical order |
| `ACMatch` | `sigma`, the **residue**, the fresh residue variables, and the **skeleton** |
| `ac_canonical` | recursive AC normal form — a *verification* device only, never used to rewrite |
| `derive_ac_lemma` | the derived lemma and its five gates |
| `ACRun`, `ACStats`, `ac_normalize` | `derivation.normalize` with AC lemma matching, exact counters, and a status that is `fixpoint` or `ac_budget:…` |
| `ac_enabled(...)` | context manager that rebinds `normalize`/`check_derivation` across the five modules that imported them, restored in a `finally`. **Default off.** |
| `kernel_edge_for`, `kernel_check_derivation` | every AC step as an `Eq` edge `kernel/check.py` accepts |
| `ac_permutation_matches` + `ematch.ematch_ac` | the additive, default-off hook for the kernel-term e-graph (§6) |

### 2.1 The semantics, stated before the code

Two AC operators: `PROD` and `SUM` of `crystallize.derivation`. Both are
genuinely associative and commutative there — the argument *multiset* determines
the value, which `poly_equal` decides.

* **At the root of the pattern**, the pattern's arguments match a **sub-multiset**
  of the subject's arguments and the rest is the **residue**, reattached by the
  rewrite in the subject's own order.
* **At every inner AC node** the match is a **bijection**: same arity, any
  permutation, no residue. *This is semantics, not budget.* An inner residue
  would make the instantiated left side a different term from the subject —
  `(#0+#1)` matched against `a+b+c` with residue `c` claims the subject is
  `a+b`, which it is not — so an inner residue is **unsound for a rewrite**, not
  merely expensive.

---

## 3. What makes an AC rewrite checkable

An AC step is not an instance of any rule the substrate's checker knows, so it
is not recorded as one. What is recorded is a **derived lemma**: the n-ary,
permuted, residue-carrying instance of the base lemma.

```
base      L1        :  (#0+#1)*(#0+(-1*#1))       ==>  (#0*#0) + (-1*#1*#1)
derived   ac|L1|6cb9:  (#0+#1)*(#0+(-1*#1))*#2    ==>  ((#0*#0)+(-1*#1*#1))*#2
```

The derived left side matches the subject **syntactically**, so
`derivation.check_step` re-derives the step with the matcher it already has.
**The AC search is not in the trusted path at all** — it is a *proposal*
mechanism, and everything it proposes is re-derived by the existing checker.

Five gates, all-or-nothing, a refusal raises:

| gate | demand |
|---|---|
| **G1** | the derived left side is an AC head of at least the base's arity |
| **G2** | every residue variable is fresh and occurs **exactly once** in the left side |
| **G3** | `ac_canonical(lhs')` equals `ac_canonical(base.lhs extended by the residue variables)` — the derived left side is an AC **rearrangement** of the base pattern, not an arbitrary term that happens to be true |
| **G4** | `poly_equal(lhs', rhs')` — the substrate's own **complete** decision procedure, applied to the derived lemma as a statement about its variables |
| **G5** | every residue variable of the left side occurs in the right side |

**G3 is the gate that makes it AC rather than "any true rule".** G4 alone would
admit `(#0+#1)*(#0+(-1*#1))*#2 ==> anything equal to it`; G3 demands that the
left side be the base pattern with the residue slots filled, in some order.

### 3.1 The kernel route

`kernel_edge_for` builds an `Eq` edge through `generate.multiway.AxiomVault`,
which is the only door into `CheckContext.axioms` in this lane and which applies
its own two gates first — **A1** re-run the schema (`derivation.match` +
`subst`), **A2** `poly_equal(redex, contractum)` — before `check.check_edge`
runs. On B3's derivation: 1 edge, 0 refused, 1 axiom declared. A bogus AC
contractum with the residue deleted gets **no edge and no axiom**, and the same
route accepts the real step immediately afterwards, so the refusal is the check
firing and not the route failing.

### 3.2 The one thing the AC context rebinds, stated plainly

`ac_enabled` rebinds two names in the modules that imported them:
`normalize` (to `ac_normalize`) and `check_derivation` (to a wrapper that hands
the **unmodified** checker the caller's lemma book *plus* the AC-derived lemmas
this run built). Nothing about the checking is weakened — a derived lemma whose
left side does not match the recorded redex is refused by `check_step` exactly
as any other lemma is. The control
`x_derived_lemma_is_not_accepted_without_the_registry` shows the checker
**refusing** an AC step when the registry is withheld, so the registry is a
lemma book, not a rubber stamp.

This is a rebinding, not a supported extension point, exactly as
`vocabulary/README.md` §4 says of `generate.loop.constructions` — one layer
down, and restored in a `finally` including on an exception
(`t_ac_enabled_restores`).

---

## 4. What it costs

### 4.1 The bound, and the four prunings

An injective assignment of `p` pattern arguments to `n` subject arguments:
`n!/(n-p)!` of them, at most `n**p`, and `n!` when `p = n` — each multiplied by
the substitutions the *inner* AC nodes yield. **Exponential in the arity of the
AC node**, on top of e-matching's existing exponential in pattern size.

1. **arity bail** — `p > n` fails before any search;
2. **head-key sub-multiset prefilter** — every non-variable pattern argument
   demands a subject argument with the same `(kind, val, arity)`; a necessary
   condition, so it removes only assignments that could not have succeeded;
3. **constants first** — ground pattern arguments are assigned first;
4. **repeated variables next, free variables last**.

Measured (`ac_demo.py` §1), difference-of-squares pattern against an n-ary
product, `ACResult.top` = root candidate pairs examined:

| n | `n!/(n-2)!` | root pairs | all pairs incl. inner | matches |
|---:|---:|---:|---:|---:|
| 2 | 2 | 6 | 29 | 1 |
| 4 | 12 | 28 | 87 | 1 |
| 6 | 30 | 66 | 161 | 1 |
| 8 | 56 | 120 | 251 | 1 |

Exactly `n(2n-1)` — quadratic in `n` for `p = 2`, factorial in general. **The
prunings change the constant, not the class.** A subject with no sum arguments
costs exactly **1** work unit (the prefilter bails); a subject whose arguments
all pass the prefilter but none match pays the full search and finds nothing.

### 4.2 Same task, with and without

Round-11 (A) book, all four benchmarks:

| task | positional steps / work | AC steps / work | steps bought |
|---|---:|---:|---:|
| B1 | 12 / 1 760 | 12 / 2 997 | 0 |
| B2 | 14 / 2 868 | 14 / 4 980 | 0 |
| **B3** | **80 / 45 363** | **37 / 19 115** | **+43** |
| B4 | 28 / 6 742 | 28 / 11 317 | 0 |
| all | 56 733 | **38 409** | |

On B1, B2 and B4 the AC matcher fires nothing and the extra work is **pure
overhead** (+70%, +74%, +68%). On B3 it fires once and the shorter derivation
*saves* work as well as steps, because a lemma firing early removes a whole
distributive expansion.

### 4.3 The crossover, twice

**(a) Workload composition, not size.** AC costs ~2 600 work units on a task
where nothing fires and saves ~26 000 on one where something does, so the AC
matcher is a net win on a workload **iff at least 1 task in ~11 has a buried
redex**. On this four-benchmark workload the ratio is 1 in 4 and AC is a net
win (56 733 → 38 409 total work).

This is the same shape as `vocabulary/README.md` §5's crossover and the
**opposite sign**: there the benefit column was identically zero so any cost
crossed immediately, and reporting a crossover number would have been reporting
a number from a curve that does not exist. Here the benefit is real, so there is
an actual trade, and it is located.

**(b) Book size — the one that will bite first.** AC matching **cannot use
`LemmaIndex`**. The net's probes are positional, and a positional filter is
unsound modulo AC: it drops lemmas whose redex sits at a permuted position, and
`x_a_positional_index_would_be_unsound_under_ac` exhibits one. So AC gives up
`SCALE.md` §3's constant-cost lemma lookup and goes back to a linear scan. Same
B1, same answer, same 12 kernel steps in every row:

| book size | positional + index, work | AC (linear scan), work |
|---:|---:|---:|
| 4 | ~1 760 | ~3 000 |
| 104 | ~1 760 | ~50 000 |
| 404 | ~1 760 | ~190 000 |

The index column is flat; the AC column is linear in the book. **That is the
wall AC matching walks into first, and nothing here moves it.** The fix is a
discrimination net keyed on the AC argument **multiset** rather than on
positions. It is a different index and it is not built.

### 4.4 Where the wall-clock actually goes — and why the obvious reading is wrong

Three arms × 12 rounds: **positional ~15 s, AC ~580 s.** That ratio is *not*
the matcher's bill. Profiled over six rounds:

| component | share |
|---|---:|
| `ac_normalize` and everything under it | **~1.2%** (1.47 s of 126 s) |
| `rewrite.install_theorem` (G3 scans every axiom of the book, per install) | ~63% |
| `term.recompute_addr` (tree-recursive, `STATUS.md` failure mode #4) | most of the rest |

**AC matching does not make those slower; it makes the loop *prove more*, and
the already-quadratic theorem-installation path is what pays.** Reporting the
ratio as "AC matching is 40× slower" would be reporting the wrong component,
and this document declines to.

### 4.5 Fixpoint, or budget?

`ACRun.status()` is `fixpoint` iff **no** AC search anywhere in the run hit a
bound. All three arms report `fixpoint` with `exhaustions=0` at the default
budget, so **no fixpoint became a budget exhaustion** — there is no regression
to report on that axis. Starve the budget deliberately (`max_assignments=3`) and
the same run reports `ac_budget:dsq at … (max_assignments)`, and
`ac_normalize` takes **no AC step at all** rather than rewriting from a partial
match set. `execute.saturate`'s own statuses are untouched: AC matching is wired
into the ring substrate's lemma search only.

---

## 5. What this does **not** cover

1. **Extension variables.** A pattern variable never absorbs several arguments.
   Full AC matching admits `mul ?a ?b` against `mul x y z` with `?b := mul y z`;
   that is not implemented. It multiplies §4.1's table by the number of set
   partitions of the argument multiset.
2. **Inner residues.** Deliberate and stated in §2.1: an inner residue is
   unsound for a rewrite, not merely expensive.
3. **AC1 / unit laws.** `mul ?a ?b` will not match `x` by taking `?b := 1`.
4. **Matching modulo the ring's own evaluation.** This is the *next ceiling* and
   §7 states it.
5. **Anything but `PROD` and `SUM`.** `AC_KINDS` is a constant, not a
   declaration mechanism. There is no way for a caller to declare a new head
   associative and commutative and have `derive_ac_lemma`'s G4 apply — G4 is
   `poly_equal`, which is a decision procedure for *this* theory.
6. **Residue-carrying matches in the kernel e-graph.** §6.
7. **Retraction.** Derived lemmas accumulate in `ACRun.lemmas` and `_DERIVED`
   for the run's lifetime and are never collected — the same defect as
   `AxiomVault`'s monotonic growth (`generate/README.md` §7.6),
   `crystallize`'s `_INTERN`, and `vocabulary`'s instance-axiom table.

---

## 6. The `ematch.py` hook

`execute/ematch.py` gained exactly two additive things and nothing above them
changed: a module constant `AC_HEADS: Tuple[str, ...] = ()` and a function
`ematch_ac(...)`. **With no AC heads named, `ematch_ac` *is* `ematch`** — same
matches, same order, same visit count — so every number published against that
module reproduces unchanged, and the existing 59-test suite is green untouched.

The kernel IR has no flat n-ary product (`mul a b` is `App(App(mul,a),b)`), so
an AC head there is a curried binary constant and "the arguments" means the
leaves of a maximal spine of it. **Only the residue-free (permutation) case is
exposed through this hook**: `EMatch` has nowhere to put a residue, and a
residue with no home is exactly the AC rewriting bug this module exists to
avoid. Demonstrated in `test_acmatch.py`: pattern `(?v*?u)*a` against an
e-graph containing `(a*b)*c` — **0 matches positionally, 2 modulo AC of `mul`.**

---

## 7. Where the next ceiling sits

B3 lands on 37, exactly the hand-grouped number. That is the ceiling this
repair could reach and not one step further.

The next one is *exhibited* by `ac_demo.py` §7 rather than argued: the first
twelve steps of B3's AC derivation are printed. Step 0 is the AC firing, and it
produces **another difference of squares** — `(x⁴ + -1*(2y)*(2y)) * (x⁴ + 4y²)`
— on which the lemma does **not** fire. Steps 5 and 6 are why: `fold_prod`
contracts `-1*2*y*2*y` to `-4*y*y`, and after that there is no `-1 * #1 * #1`
product node for the pattern to match. The engine falls through to `distrib` at
step 11 and expands by brute force for the remaining 26 steps.

> **The substrate's lemmas are matched modulo AC but not modulo the ring's own
> evaluation.** A pattern that mentions a coefficient matches only terms whose
> coefficients have not yet been folded, and `fold_prod`, `fold_sum` and
> `collect` fold them at the first opportunity. Every mined lemma in this book
> carries a literal coefficient, so **every one of them is one `fold` step away
> from being unmatchable.**

**What would break it**, stated so the next lane does not have to guess:
normalise the coefficient of each monomial *during the match* instead of
demanding it syntactically — AC1 matching (units) and then matching modulo a
decidable equational theory. That is strictly harder than what is built here.
It is not implemented and nothing here pretends otherwise.

So the ceiling has moved one level again, and it is still a ceiling:

```
generate/   the construction schema is finite and human-written
vocabulary/ the proposal mechanism cannot leave the schema's shape space
            ...and the matcher cannot see a binary redex in an n-ary product
THIS LANE   FIXED.  B3: 80 -> 37.  The vocabulary negative survives it.
            the matcher cannot see a redex whose coefficients have been folded
```

---

## 8. Testing

`runtime/tests/test_acmatch.py`: **78/78**, 7 planted controls, every one
invoked. The four the brief named are all present and all fire:

| control | what it plants |
|---|---|
| `x_bogus_ac_match_is_refused_by_the_kernel` | the real redex with the residue deleted from the contractum — no edge, no axiom, a recorded refusal; the same route then accepts the real step |
| `x_binding_inconsistent_across_a_repeated_variable` | `?a * ?a` against `x * y`; and a hand-built match claiming an inconsistent binding whose derived left side then refuses the subject |
| `x_budget_exhaustion_reported_as_a_fixpoint` | a search cut short: `.matches` and `len()` raise, `.partial()` is the way in, the run is **not** a fixpoint, and — with a budget loose enough that the partial set is **non-empty** — `ac_normalize` takes no AC step from it |
| `x_residue_dropped_during_reassembly` | three ways: a right side that is not the base's value (G4), a skeleton that is not an AC rearrangement (G3), and the positive assertion that the accepted rewrite *does* contain the untouched argument |

Plus `x_a_positional_index_would_be_unsound_under_ac` (exhibits a lemma the
discrimination net drops and AC matching fires on),
`x_ac_does_not_change_an_answer` (three tasks, answer by address, derivation
never longer), and `x_derived_lemma_is_not_accepted_without_the_registry`.

Correctness is also held against a **brute-force reference matcher**
(`_brute_force_ac`, unoptimised `itertools.permutations`) on four subjects, so
the prunings are checked against an implementation that has none.

### 8.1 Mutation testing

A green suite that has not been mutation-tested is an untested suite. Thirteen
defects injected; **11 dead**, 2 survivors *proved equivalent* and recorded
rather than counted as kills (the precedent is `curriculum/`'s 15/16):

| mutant | verdict |
|---|---|
| prefilter always true | dead — the work counter is asserted, so the cost claim is tested and not just the result |
| injectivity dropped (a subject argument used twice) | dead |
| repeated-variable consistency dropped | dead (18 checks) |
| G3 / G4 gate removed | dead (one each) |
| residue dropped from the derived right side | dead (11 checks) |
| incomplete enumeration returns a subset instead of raising | dead |
| matches not sorted into a canonical order | dead |
| a partial match set used for a rewrite anyway | dead |
| residue order reversed during reassembly | dead |
| exhaustion never recorded on the run | dead |
| **inner AC allowed to leave a residue** | **survived, equivalent**: `_sub_match` rejects unequal arities *before* calling `_assign`, so the guard inside `_assign` is unreachable. Defence in depth. |
| **G5 removed** | **survived, equivalent**: a right side that drops a residue variable is a *different polynomial*, so G4 — a complete decision procedure — refuses it first. G5 is a cheaper structural statement of the same thing. |

---

## 9. Determinism and exactness

CPU-only, pure Python 3 stdlib, exact integers. No float is constructed, no
clock is read, no RNG is consulted (asserted by a test that greps the source).
No network. Matches are sorted into a canonical order before anything reads
them, so the search order — including the constants-first heuristic — is
provably a cost decision and not a semantic one. Output byte-identical across
`PYTHONHASHSEED` 0 / 12345 / 999, asserted by a subprocess test over the counter
snapshot, the result address, the derived-lemma registry, the stats line and the
status.

---

## 10. Contract changes

| # | symbol / claim | was | is | why |
|---|---|---|---|---|
| **C1** | `ematch.py` | `ematch`, `ematch_rule` | plus `AC_HEADS = ()` and `ematch_ac(...)` | Additive. `ematch_ac` with no AC heads **is** `ematch`; nothing above the new block changed; the 59-test suite is green untouched. |
| **C2** | `crystallize.derivation.normalize` | the only normaliser | unchanged — **plus** `acmatch.ac_normalize`, reachable only inside `acmatch.ac_enabled()`, which is never entered by anything in the runtime on its own | Every number published against the ring substrate reproduces unchanged. `ac_demo.py` §4 recomputes the three published positional arms *in the same process* rather than quoting them, and gets 12 / 14 / 80 / 28 — the vocabulary lane's row exactly. |
| **C3** | "`vocabulary/README.md` §1: B3 is 80 in every configuration" | a claim about this loop's reach | a claim about this loop's reach **under the positional matcher**. Under AC matching B3 is **37** in all three configurations. | The vocabulary lane's §7 diagnosis is confirmed, not overturned: it named the cause exactly and the fix lands exactly where it predicted. **No number in `vocabulary_demo.py` changes** — that demo does not enter the AC context. |
| **C4** | "`vocabulary/README.md` §1: (B) does not beat (A)" | measured on the positional substrate | **re-measured on the AC substrate and unchanged.** (B) beats (A): NO. (C) beats (A): NO. (B) equals (C): YES. | This is the retest's actual finding, and it is a negative that got *stronger*. |

**One published number is restated, loudly**, in the style §7 of
`execute/README.md` uses: the vocabulary lane's `B3 → 80` remains correct for
the substrate it was measured on and is *not* a fact about the mathematics. The
same polynomial, the same book, the same kernel, with the matcher able to see a
sub-multiset, is **37**. Anything quoting "B3 is untouchable at 80" should
quote it as "untouchable at 80 *by a positional matcher*".
