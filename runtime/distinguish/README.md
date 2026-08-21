> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `runtime/distinguish` — distinction compilation

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

Implementation of **CRYSTAL.md §3.2** (distinction compilation) with the
**§4** reachability discipline attached to every claim, and a measured demo
that reports against **§0** (the seed criterion).

CPU-only. Pure Python 3 standard library. Exact integer arithmetic, no
floating point anywhere (enforced by an AST scan in the test suite). No
machine learning, no network, no randomness beyond one printed integer
recurrence. Deterministic: the demo prints a SHA-256 of its own report and the
test suite re-runs it under two different `PYTHONHASHSEED` values and demands
byte-identical output.

**Independence.** This package imports nothing from `runtime/kernel/` or
`runtime/crystallize/`, and nothing outside the standard library. The test
suite asserts this on the parsed import graph, not by grepping.

```
runtime/distinguish/observe.py    channels, tasks, the system, the collision finder
runtime/distinguish/refine.py     Moore refinement, sufficiency/coarseness proofs,
                                  the compiled representation, the compile loop
runtime/distinguish/channels.py   the invariant library and the channel searches
runtime/demo/distinguish_demo.py  the measured demonstration
runtime/tests/test_distinguish.py adversarial tests with planted-false controls
```

Run:

```
python3 runtime/demo/distinguish_demo.py     # ~13 s, exits 0 iff §0 is met
python3 runtime/tests/test_distinguish.py    # 51 tests, ~55 s
```

---

## 1. The system, and why this one

`notes/DIGIT_CRYSTAL.md` §0–§1 supplies a finite mathematical system whose
symmetries were *proved*, not assumed, which is what makes it a real source of
tasks rather than a toy.

* **States**: little-endian base-`b` digit words `w = (c_0, …, c_{n-1})`,
  `L(w) = Σ c_i b^i : W_n ≅ Z/b^n`. The demo uses `b = 6`, `n = 6`, so
  **46656 states**.
* **Actions** (the declared action monoid `⟨T, E⟩`):
  * `T` — the odometer `v ↦ v+1`, realised on the word by carry propagation;
  * `E` — digit complement `c_i ↦ b-1-c_i`, i.e. `v ↦ b^n-1-v`
    (DIGIT_CRYSTAL Prop. 1.2/1.3: this is *the* conjugation-induced digit
    symmetry, and `E T E⁻¹ = T⁻¹`).
* **Not an action**: `D` — word reversal (DIGIT_CRYSTAL §1.1). This is
  deliberate and is the whole of §4 in miniature; see §6 below.

**Why base 6.** `6 = 2·3` is not a prime power. The two declared tasks
therefore live at genuinely different primes, and no single digit-window
readout answers both. The channel search has to *find* the Chinese Remainder
decomposition rather than read it off a digit block. In base 2 or base 3 the
whole problem is 1-adic and the minimum channel set is trivially of size 1.

**Two declared task families.**

| family | tasks | coarsest sufficient quotient | minimum channel set |
|---|---|---|---|
| A | `τ[8<4] = [L(w) mod 8 < 4]`, `τ[27<14] = [L(w) mod 27 < 14]` | `Z/216`, 216 blocks | `(res_8, res_27)` |
| B | `τC[c1=0] = [second digit is 0]` | `Z/36`, 36 blocks | `(digit_0, digit_1)` |

Both are hand-computable, which is the point — the machine's answer is checked
against mathematics, not against itself:

* **A.** Knowing `[v+k mod 8 < 4]` for all `k` recovers `v mod 8`, because the
  8-periodic word `11110000` has all 8 rotations distinct; likewise the
  27-periodic word (14 ones, 13 zeros) recovers `v mod 27`. `lcm(8,27) = 216`
  and `216 | 6^6`, so reduction mod 216 commutes with both `T` and
  `E(v) = 46655 - v`. Hence exactly **216** blocks, and by CRT the minimum
  observation is the pair of local components.
* **B.** `(c_0, c_1)` is itself an odometer on `Z/36`, and the indicator of
  `c_1 = 0` has all 36 rotations distinct. Hence exactly **36** blocks: "is
  the second digit zero" needs the low *two* digits and no more — the carry
  window, which is why family B's collisions have positive depth (see §4).

---

## 2. Collisions (§3.2 step 3)

A collision is emitted as **data**, never as an exception:

```
Collision(x, y, word, task, out_x, out_y)
```

`observe(x) = observe(y)`, and applying `word` makes `task` disagree. `word`
is a *shortest* such word, obtained from the Moore level history, so the
collision is a minimal specification of the missing distinction. Every
collision the demo prints is replayed through the raw engine in the test suite
(`test_collision_witness_replays_on_the_raw_engine`), and shortestness is
verified by brute-force enumeration of all shorter words
(`test_collision_witnesses_are_shortest`).

The finder is bounded-depth on purpose. `SignatureOracle.level(d)` separates
exactly the pairs distinguishable by words of length ≤ `d`, and levels are
cached, so a compile loop that asks for deeper and deeper collisions pays for
each level once. Unbounded saturation is a real cost — for a task that reads
the word through `D` it needs thousands of levels — so the API forces the
caller to say which they want.

---

## 3. The channel library, and what "minimal" means

The library is generated by a **uniform rule**, so the search is not rigged:

* `digit_i` for every position `i` — cost 1 read each;
* `res_{p^j}` for **every prime power dividing `b^n`** up to the length bound,
  plus `res_5`, `res_7` for two primes that do *not* divide it;
* `digitsum_mod_k` (k = 2,3,5), `altsum_mod_(b+1)`;
* `is_palindrome` — the indicator of `Fix(D)` (DIGIT_CRYSTAL Thm 3.4);
* `valuation` — the `b`-adic valuation `v_b`, i.e. trailing zero digits;
* `zero_count`;
* `rev_res_m` — a residue read through the reversal, present so that a
  recompilation after a `D`-sensitive task arrives is a *search*, not a
  hand-placed answer.

Nothing in the library is any declared task's answer by construction. A
residue channel reads only the digits that can matter: `truncation_length`
returns the least `k` with `b^k ≡ 0 (mod m)`, so `res_8` and `res_27` in base
6 each read **3** digits, not 6, because `6³ = 216 = 8·27`. The *raw* task
evaluator uses the same truncated Horner, so the raw baseline gets every
arithmetic shortcut the compiled side gets and the only thing measured is
representation.

**"Minimal" is disambiguated at every call site.** Three functions, three
different claims:

| function | claim | cost |
|---|---|---|
| `minimum_cardinality_set` | **exact minimum cardinality**. Subsets enumerated by increasing size; the exhaustive failure of all smaller sizes *is* the proof. Guarded by an explicit subset budget that raises `SearchBudgetExceeded` rather than silently degrading. Ties at the minimum size broken deterministically by *(induced class count, total declared reads, names)*. | exponential in library size |
| `greedy_set` | **greedy set cover**, never called minimal without its bound: `|C| ≤ H(P)·OPT` for `P` collision pairs, `H` the harmonic number computed as an exact fraction (`harmonic_ceiling` reports the least integer ≥ `H(P)`). This is the tight bound for set cover. | linear |
| `inclusion_minimal_set` | **minimal under inclusion**: no single member is removable. Explicitly *not* claimed to be minimum cardinality. This is §3.2 step 6, and it is what deletes the null channel. | `O(|C|)` requirement tests |

Two requirement kinds, and they are different claims: `PairRequirement`
(separate the collision pairs found so far — what the loop can actually see)
and `PartitionRequirement` (refine a whole target partition — the global
claim, testable in `O(|S|)` per subset because refinement is a class-count
identity).

The demo runs the incremental search *and* the global exhaustive search and
reports that they agree. That cross-check is the expensive part of compilation
and is labelled optional in the cost table.

---

## 4. Refinement (§3.2 steps 4–5)

**Algorithm: Moore (1956), not Hopcroft.** Start from the partition induced by
the declared task outputs; repeatedly replace each state's class by
`(class, class of each successor)`, renumbering by first occurrence. The
partition only gets finer and is bounded by `|S|`, so it terminates.

*Complexity.* A round costs `O(|Σ|·|S|)` (renumbering is a dictionary pass,
not a sort). The round count is `1 + L` where `L` is the longest *shortest*
distinguishing word, `L ≤ |S|-1`; so `O(|Σ|·|S|²)` worst case. Hopcroft would
give `O(|Σ|·|S|·log|S|)` worst case. Moore is used because its intermediate
levels **are** the bounded-depth Myhill–Nerode signatures the collision finder
needs anyway, and because it is short enough to audit by eye. On the demo
system `L = 7` (family A) and `L = 13` (family B).

Two proofs are run and both are reported:

* `check_sufficient` — **complete, not a sample**. Task outputs constant on
  each block (the empty-word case) plus the congruence property (`block(x) =
  block(y) ⟹ block(a·x) = block(a·y)` for every action) give sufficiency for
  words of *every* length by induction. Failures are returned as witnesses,
  never raised.
* `check_coarsest` — merging any two remaining blocks breaks some task.
  Computed for **every** pair at once by backward BFS from the
  output-distinguished pairs (classical table-filling), which also yields the
  shortest distinguishing word per pair. On family A that is all 23220 pairs.
  The demo additionally *executes* the falsification: it merges sampled block
  pairs and re-runs `check_sufficient`, which rejects 24/24.

---

## 5. Redundant-channel removal and the null control (§3.2 step 6)

`inclusion_minimal_set` drops any channel whose removal preserves the
requirement, in a deterministic order (most declared reads first, then name).
A **null channel** — valid, but irrelevant to the declared tasks — is added by
the demo (`is_palindrome`) and the measurement shows it:

* does **not** reduce cost: it *adds* 616 steps (family A) / 596 steps
  (family B) across the 512-query batch, because it must be evaluated per
  query;
* doubles the key table (216 → 432 entries in family A) without changing the
  block count;
* is removed by step 6 in both exhibits.

A runtime whose every added fact speeds things up is measuring its cache, not
its mathematics (CRYSTAL.md §0). This is that check.

---

## 6. Reachability discipline (§4): what the quotient omits

For the installed family-A quotient:

| slot | value |
|---|---|
| generated locus | all 46656 states (`T` generates `Z/46656` from 0) |
| exact image | `Z/216` under `v ↦ v mod 216` |
| equivalence kernel | `216Z / 46656Z`, every fibre of size 216 |
| closure/completion | `Z_6` (DIGIT_CRYSTAL §0); mod-216 reduction extends |
| **omitted locus** | the high digits, i.e. the fibre coordinate |
| operations that extend | `T`, `E`, every task factoring through mod 216 |
| operations that do not | `D` = word reversal |
| may not claim | completeness for any task that sees `D` |

This is the reason `D` is not an action. DIGIT_CRYSTAL Thm 4.2/4.4 proves that
reversal does not descend to the completion and that its limit is the
*identity* — "the residual is the endian class". `CROSS_LENS` §2 files the
same object as one row of a table of six: *web = value map, residual = endian
ℤ/2*. Here that abstract statement becomes an executable one:

* a new task `τ[16<8]` — a finer 2-adic threshold — **collides** against the
  installed quotient, and recompiles to `Z/432 = Z/lcm(16,27)`: still a 108×
  compression. The distinction was missing; it was found and installed.
* a new task `τD[8<4]` — the same threshold read through `D` — **also
  collides**, but recompiles to *nothing*: the Myhill–Nerode quotient
  collapses to the identity. Verified exactly on the smaller twins of the same
  system (216→216, 1296→1296, 7776→7776 blocks); at `n = 6` the bounded run
  already exceeds 216 blocks after 8 rounds, which suffices to refute
  sufficiency.

Both are detected as collisions. Neither is answered silently and wrongly.
That asymmetry — one new task recompiles, the other proves that no compression
exists — is exactly the §4 claim that *a quotient sufficient for one task
family is not sufficient for the ambient problem, and the machine must know
the difference.*

---

## 7. Measured result (§0)

From `runtime/demo/distinguish_demo.py`, `report-sha256
4508dc081515930874fb062e3df453a096d9b8a7de2aa61b88260402326d0094`:

| quantity | exhibit A | exhibit B |
|---|---:|---:|
| raw representation size (states) | 46656 | 46656 |
| compiled representation size (blocks) | **216** | **36** |
| compression factor | 216× | 1296× |
| installed channels | `res_8,res_27` | `digit_0,digit_1` |
| independent queries (fresh states, fresh words) | 512 | 512 |
| overlap with refinement-driving states | **0** | **0** |
| steps, RAW | 91551 | 88960 |
| steps, COMPILED | **28672** | **26624** |
| steps, COMPILED + NULL CHANNEL | 29288 | 27220 |
| answers agree with raw | YES | YES |
| null control: extra steps | **+616** | **+596** |
| null channel removed by step 6 | YES | YES |
| new task `τ[16<8]`: collision detected | YES | — |
| new task `τD[8<4]`: collision detected | YES | — |
| one-time compile cost (steps) | 23779194 | 25567268 |
| — of which the optional global-minimality cross-check | 18989399 | 18989399 |
| break-even queries (required compile only) | 39002 | 54028 |

**Seed criterion: met.** A mathematical fact entered (the coarsest sufficient
quotient and its exact minimum channel set); an independent batch — fresh
states with zero overlap with the 302/79 states the collision finder ever
looked at, and fresh action words — solves in strictly fewer exact steps; the
answers are checked against the raw computation, not assumed; a null control
does not reduce the cost.

**The honest caveat, stated in the table rather than omitted.** The reduction
is per-query and the compilation is not free. At 122 steps saved per query,
the *required* compilation (collision loop, Moore, sufficiency and coarseness
proofs, install) amortises after ~39000 queries. The optional exhaustive
global-minimality cross-check is 80% of the compile cost and buys a stronger
claim, not a faster program.

---

## 8. What breaks first at scale

Measured or derived from the implementation, in the order they bite:

1. **The exact minimum-cardinality search.** `C(|library|, k)` subsets, each
   an `O(|S|)` refinement test. With 28 channels and `k = 2` that is 407
   subsets × 46656 states ≈ 1.9·10⁷ state visits — already 80% of compile
   cost. At `k = 3` it is 3276 subsets, at `k = 4` about 20475. This is set
   cover; it is NP-hard and the budget guard exists because of that. The
   escape is `greedy_set` with its stated `H(P)` bound, not a better exact
   search.
2. **Moore's round count, when the quotient is near-trivial.** Round count is
   `1 + L`. For the well-behaved families here `L` is 7 and 13. For the
   reversal task `L` grows like the state count: `b=6,n=5` needs 1189 rounds
   over 7776 states, and `n=6` would need several thousand over 46656 — which
   is why the demo caps it and reports a lower bound instead of pretending.
   Hopcroft fixes the worst case (`O(|Σ|·|S|·log|S|)`) and should be the
   replacement when this becomes the binding constraint; Moore was chosen for
   auditability and for the level history, both of which Hopcroft loses.
3. **The `O(|S|)` per-subset requirement test.** It is `set(zip(*columns))`
   over the whole state space. Beyond ~10⁶ states the channel value tables
   (one `int` per state per channel) dominate memory before time does.
4. **`check_coarsest` is `O(|Σ|·|B|²)` in the block count.** Fine at 216
   blocks (23220 pairs); at 10⁴ blocks it is 5·10⁷ pairs, and the complete
   all-pairs guarantee would have to become a sampled one — at which point the
   word "coarsest" would have to be downgraded, and should be.
5. **Nothing here is incremental.** A new task recompiles from scratch. The
   §3.2 loop as specified is incremental in the *channels*, not in the
   refinement; wiring the retained level history into a partial re-refinement
   is the obvious next piece of work and is not done.
