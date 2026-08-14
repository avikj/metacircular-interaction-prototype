# `runtime/atlas` — the atlas of ℕ, executable

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

`notes/ATLAS_OF_N.md` proves six charts of ℕ with their transition maps and a
residual table with a homotopy column. `formal/cubical/NaturalMachine/`
type-checks two of them (ℕ ≃ Tally, ℕ ≃ CanonicalWord, transport of the monoid
structure, `(X ≡ X) ≃ (X ≃ X)`). Before this lane the runtime knew ℕ only
through digits and the odometer.

This package makes the rest executable: **each chart is a construction with
operations, each transition is a typed kernel edge whose kind is verified against
an exhaustive check on a stated finite range, and each residual is a computed
object — a group with an order and a Cayley digest, a torsor with a
freeness/transitivity report, a 2-cocycle with a coboundary search — never a
string.**

```
charts.py       the six charts, the kernel bridge, the two completions
transitions.py  the transition maps as typed kernel edges, with residuals
residual.py     the groups / torsors / cocycles / obstructions themselves
```

```bash
python3 runtime/demo/atlas_demo.py      # the whole atlas, with exact counters
python3 runtime/tests/test_atlas.py     # 26 capabilities + 14 planted-false controls
```

Hard constraints, enforced: CPU-only, pure Python 3 stdlib, exact
(`int` / `fractions.Fraction`), **no float is constructed anywhere** (test A26
greps for it and checks the metrics are `Fraction`), deterministic (no `hash()`,
no clock, no set iteration in any output path — the demo is byte-identical under
`PYTHONHASHSEED=12345`), exact counters throughout.

---

## 1. The six charts

| # | chart | native construction | operations you can call | choices (`ATLAS_OF_N` Thm 4.2) |
|---|---|---|---|---|
| (a) | `PeanoChart` | initial algebra of `X ↦ 1+X` | `succ`, `rec(base, step, n)`, `add`, `mul`, `induction_holds`, `comparison_maps` | **none** |
| (b) | `TallyChart` | free monoid on one generator | `concat`, `free_monoid_map(M, ·, m)` — the universal property, executed | **none** |
| (c) | `CardinalChart` | π₀ of finite sets and bijections | `automorphisms(n) → S_n` (real group), `iso_torsor(n)`, `decategorification_fibre`, `disjoint_union`, `product` | **none** |
| (d) | `OrdinalChart` | finite linear orders | `orders(X)` (all n!), `order_torsor(n)`, `order_isomorphisms`, `contractibility_check`, ordinal arithmetic with `ω` | **none** |
| (e) | `DigitChart(b, endian)` | base-`b` digit words | `value` (Horner), `odometer`, `truncations`, `endian_agreement`, `carry(n)`, `residue_is_local` | **three**: base, endianness, digit section |
| (f) | `PrimeChart` | free commutative monoid on `P` | `datum` (factorization), `mul` (= exponent addition), `completely_multiplicative`, `prime_swap`, `successor_not_definable` | **none** |

`S_n` is a genuine computed group: elements are permutation tuples, `op` is
composition, `verify()` checks closure, identity, inverses and — exhaustively for
`|G| ≤ 24` — associativity, and `digest()` fingerprints the Cayley table.
Measured: `S_0=1, S_1=1, S_2=2, S_3=6, S_4=24, S_5=120`, all axioms checked, the
natural action transitive with one orbit.

### The kernel bridge — why the `Iso` edges are *checked*, not asserted

Every chart also emits its element as a kernel term. Numbers are **Church
numerals over an opaque base sort**, so a chart's construction is a term the
kernel can *run*:

| chart | the term for `n` | what the kernel does with it |
|---|---|---|
| (a) | `SUCC (SUCC … ZERO)` | iterates |
| (b) | `CONCAT ONE (CONCAT ONE … ZERO)` | concatenates |
| (c) | `PLUS ONE (PLUS ONE … ZERO)` | sums ones — and the address depends on `X` **only through `|X|`**, so two different 3-element sets have one address: decategorification at L0 |
| (d) | fold of `SUCC` along the order | the address depends on the order only through its length: Prop. 2.4 (finite orders are rigid) in the IR |
| (e) | Horner: `PLUS (MULT acc b) d`, digit by digit | **computes the positional value** |
| (f) | `MULT (MULT ONE p) q …` over the factorization | **computes the product** |

Each is wrapped in a β-erasable chart tag (`K body tag`), so the seven
presentations of one number have seven distinct L0 addresses and one normal
form. `check.check_edge` on an `Iso` normalises both endpoints and round-trips
the transport on fresh probes — so installing `a→e(b=10)` at `n = 12` is the
kernel *evaluating* `1·10 + 2` and comparing with `S¹²(0)`. **84 such edges are
machine-checked in the standard build.**

One finding fell out of this: `PLUS_T` and `CONCAT_T` — Peano's addition and the
free monoid's concatenation, transcribed independently — are the **same L0
address** (`863d5b89c1f2b7890173fb3669cb152f`). That is `ATLAS_OF_N` Residual
2.1(2), "the two signatures are definitional expansions of each other", made
visible as an address collision, while the *elements* stay two constructions.

---

## 2. The transitions, their kinds, and their residuals

`install()` refuses — returns `installed=False` with a reason and puts nothing in
the e-graph — unless the claimed kind matches the exhaustive report **and** every
declared residual's triviality survives recomputation **and** every kernel edge
checks.

| transition | kind | verified by exhaustion on | residual, as a computed object |
|---|---|---|---|
| (a) ↔ (b) | `Iso` | all `n ≤ 12`; 17 kernel edges | **trivial group**, order 1 — plus the contractibility check below |
| (c) → (a) | `Quotient` | every subset of a 6-atom universe of size ≤ 4 (57 objects) | **S₀..S₄** (orders 1, 1, 2, 6, 24) + the `Iso(X,[4])` **torsor**: free, transitive, regular, 24 = 4! points |
| (d) → (c) | `Quotient` | all 34 linear orders on `[n]`, `n ≤ 4` | the **S_n-torsor of orders** for n = 2, 3, 4: free ✓ transitive ✓ regular ✓, sizes 2, 6, 24 |
| (d) → (a) | `Iso` | all `n ≤ 10`; 17 kernel edges | **trivial below ω** — and the divergence exhibited: `1+ω = ω ≠ ω+1`, `2·ω = ω ≠ ω·2 = ω·2` |
| (a) → (e), b=10 and b=2 | `Iso` | all `n ≤ 96`; 17 kernel Horner edges each | **three**: base `rad(b)`, endian **ℤ/2-torsor**, carry **class ≠ 0** |
| (a) → (f) | `Iso` | all `n ∈ [1,48]`; 16 kernel product edges | **addition**, as a computed obstruction |
| (e) → (f) | `Implies` | `d ∈ [1,20] × k ∈ [0,3]`, full period each | **shared locus** `{p : p ∣ b}` = `{2,5}` for b=10 |

### The three digit residuals, measured

* **base.** `rad(10)=10`, `rad(2)=2`, `rad(12)=6`. `10 → 2` translates (rad 2 ∣ rad 10);
  `2 → 10` does not, and the witness is the exact gauge table: `|2^k|₂ = 2^-k → 0`
  while `|2^k|₁₀ = 1` for every `k` (Prop. 2.8's proof, computed).
* **endianness.** `{π, σ}` is verified a **ℤ/2-torsor** (free, transitive,
  regular). The agreement locus is exactly the `b` constant strings and the
  defect fraction is exactly `1 − b^{-n}` as a `Fraction`, for `b ∈ {2,3,10}`,
  `n ∈ {1,2}`; reversal is checked to conjugate `π` into `σ` on every word.
* **carry.** `carry_cocycle(b,n)` is verified normalized and a genuine 2-cocycle
  (the full `m³` identity), and its class is certified nonzero **two independent
  ways**: the exact exponent argument `lcm(b^n,b) < b^{n+1}` (valid for every
  `b ≥ 2, n ≥ 1`) and, where the enumeration is affordable, an **exhaustive
  search over all `b^{b^n}` set-sections** finding none additive — which is
  exactly falsification condition A5 of `ATLAS_OF_N` §10, run and failed to
  falsify at `(b,n) = (2,1), (2,2), (3,1), (5,1)`. For `b=10` the search is
  10¹⁰ sections and is **not** run; the report says `searched=False` rather than
  pretending.

### The residual of chart (f): addition — what was and was not established

The criterion used is the standard Galois/orbit one: anything definable in
`(ℕ_{>0}, ×)` without parameters is invariant under `Aut(ℕ_{>0},×) = Sym(P)`;
with parameters, invariant under the pointwise stabiliser of those primes. The
package computes a witness:

```
no parameters      σ = (2 3):  σ̂(succ 2) = 2  ≠  succ(σ̂ 2) = 4
2,3,5,7,11 fixed   σ = (13 17): σ̂(succ 13) = 14 ≠ succ(σ̂ 13) = 18
```

and a fresh transposition is always available outside any finite parameter set,
so **no finite parameter set helps**. The sharper form is also computed: 2 and 3
have the same complete `Sym(P)`-invariant (exponent multiset `(1,)`) while
`succ 2 = 3` has multiset `(1,)` and `succ 3 = 4` has `(2,)` — so **no function
of the invariant computes the successor**.

*Honest scope, stated because the commission asked for it.* This establishes
non-definability **without parameters and with any finite parameter set**, under
the automorphism-invariance criterion. It does **not** establish that no
definition exists in a richer language (e.g. one with infinitely many
constants), and it implies **nothing whatsoever** about Goldbach, twin primes,
`abc`, RH or any open problem — `ATLAS_OF_N` Cor. 2.13.1's guardrail applies
verbatim.

### Contractibility, and exactly what a finite check buys

`ATLAS_OF_N` Residual 2.1 claims something stronger than "an isomorphism exists":
the comparison type is **contractible**. Two finite forms are computed:

1. **(a) ↔ (b).** Enumerate *all* `6⁶ = 46656` functions on the truncation
   `[0,5]` and keep those with `h(0)=0` and `h(n+1)=s(h n)`. **Exactly one
   survives, and it is the identity**, so `Aut(ℕ,0,s)` is trivial at this level.
2. **(d).** For every ordered pair of linear orders on an `n`-set, `n ≤ 4`,
   count the order isomorphisms by enumerating all `n!` bijections:
   **min = max = 1** over all `576` pairs at `n = 4`. That is the groupoid form
   of "`Σ_{X:BS_n} LinOrd(X)` is contractible": exactly one morphism between any
   two objects, against `n! = 24` plain bijections. The two numbers `1` and `24`
   are the contractibility and the residual, side by side.

> **What the finite checks establish, and what they do not.** They establish that
> the claim is *not refuted* at that level, and they are genuinely refutable: a
> planted wrong successor is caught (control C10 — a shifted successor still
> admits exactly one map, but it is **not the identity**, and a successor with a
> hole admits none). They do **not** establish the infinite statement.
> Uniqueness for all `n` is exactly initiality, which is an induction, and no
> finite enumeration proves an induction. The machine-checked infinite form lives
> in `formal/cubical/NaturalMachine/`, not here. `transitions.CONTRACTIBILITY_SCOPE`
> carries this paragraph in the code, and the demo prints it.

---

## 3. CRYSTAL.md §4 discipline, per chart

Every chart declares — and `reachability_report()` **checks** — generated locus ·
exact image · equivalence kernel · closure/completion · **omitted locus** · which
operations extend to the completion · which depend irreducibly on finite
addresses. The declaration is a dataclass, so a chart that omits a field does not
compile; test A21 additionally requires every field non-empty and the omitted
locus to have a concrete witness.

Sharp cases:

* **(c) cardinal** — the equivalence kernel is declared **not** trivial and the
  claim is measured: the fibre over `n` has `C(6,n)` sets, each with `Aut = S_n`
  of order `n!`. `|X| = |Y|` is the truncation of an `S_n`-torsor.
* **(e) digit** — exact image of words of length ≤ k is exactly `[0, b^k)`
  (checked); the whole equivalence kernel is zero-padding (checked); the omitted
  locus is *every infinite digit string*, i.e. all of `ℤ_b \ ℕ`.
* **(f) prime** — the omitted locus includes **0**, which this chart cannot name
  at all, and **addition**.

### The two incomparable completions, made testable

`ATLAS_OF_N` Thm 5.3: ℕ is closed and discrete in ℝ, dense in ℤ_b, and there is
no continuous map either way restricting to the identity. Computed:

| | ℝ (`ArchimedeanWindow`) | ℤ_b (`BAdicWindow`) |
|---|---|---|
| position of ℕ | **closed, discrete**: separation exactly `1`, no two naturals within `1/2`; every archimedean-Cauchy sequence of naturals is eventually constant | **dense**: every residue at depth ≤ 3 is hit; **not closed**: `9, 99, 999, 9999` is Cauchy with limit `−1 ∉ ℕ` |
| not the other one | not dense: `1/2` is at distance `1/2` from every natural | — |
| arithmetic successor `x+1` | **extends** (isometry) | **extends** (the odometer; uniform continuity with modulus `id`, checked at every residue and depth) |
| **enumeration successor** ("least natural > x") | **does NOT extend** — exact jump witness: `next(1 − 1/k) = 1` but `next(1) = 2` | — |
| order `<` | extends | **does NOT extend** — order-flip witness: `(0,10)` and `(10,0)` sit at the *same* gauge `1/10` |

Plus the two-sided no-map witness: the table of `b^k` with both exact gauges,
`|b^k|_b = b^{-k} → 0` against `|b^k|` unbounded in ℝ. **Scope:** the table
exhibits the sequences the proof uses; compactness and connectedness are *not*
verified computationally, and the module says so in the returned record rather
than in a footnote.

---

## 4. What is machine-checked and what is declared

Per `runtime/STATUS.md`, only `Eq`, `Iso` and β are genuinely machine-checked.

* **`Iso` edges (84 of them): machine-checked.** The kernel normalises both chart
  terms — actually running Horner and the Church product — and round-trips the
  transport on fresh probes.
* **`Quotient` / `Implies` edges (13): declared.** The kernel confirms a matching
  certificate exists; the mathematics behind it is the exhaustive check in this
  module, not a kernel proof. `InstallReport.trust_note()` says exactly this, and
  constructing a report with `machine_verified=True` for a non-`Iso` kind raises
  `TrustBoundaryError` (control C7) — the same guard `runtime/physics` uses.
* **The exhaustive checks are proof on their stated finite range and nothing
  beyond it.** Every report prints its range.

---

## 5. Controls, and the mutation round

26 capabilities, **15 planted-false controls**, all green. The four the lane was
commissioned with, plus the discriminating counterparts:

| control | planted falsehood | caught by |
|---|---|---|
| C1 | a claimed bijection that is not one (`n ↦ n//2` as `Iso`) | exhaustive check: `injective=False` |
| C2 | an `Iso` installed for a map that is only an embedding (`n ↦ 2n`) | kind discipline **and**, independently, the kernel refusing `Iso(peano 3, peano 6)`; the same map declared `Embed` **does** install |
| C3 | a residual claimed trivial that is not (`S₃` declared trivial) | `Residual.verify` recomputation |
| C4 | a residual claimed **non**trivial that is (`S₁`) | same — the checker is not merely a pessimist |
| C5 | "the enumeration successor extends to ℝ" | exact jump witness |
| C6 | "the order extends to ℤ_b" | order-flip witness at equal gauge |
| C7 | `machine_verified` claimed for a `Quotient` | `TrustBoundaryError` |
| C8 | a transitive but non-free action passed off as a torsor | `Torsor.verify` free-defect; `translate` refuses a non-unique answer |
| C9 | a carry-free digit set | exhaustive section search — **with a positive control**: a genuine coboundary *is* recognised, so the search is not a constant "no" |
| C10 | a wrong successor | contractibility verdict (`unique=False`, or 0 maps) |
| C11/C12 | `Quotient` claimed for a bijection / `Iso` claimed for π₀ | kind discipline, both directions |
| C13 | a chart used outside its declared range | `ChartError` |
| C14 | an unlicensed composite of atlas edges | the L1 edge algebra |
| C15 | a non-surjective `Iso` **with the kernel's help removed** | the kind check alone |

**Mutation round: 14 deliberate defects injected into copies of the package.
13 died on the first run; 1 survived and the suite was strengthened until it
died too.** Injected: freeness never checked, `Iso` not requiring surjectivity,
residual triviality rubber-stamped, the carry set to zero, positional weights
shifted to `b^{i+1}`, the residual agreement check skipped, the endian defect
zeroed, every bijection accepted as an order isomorphism, the enumeration
successor claimed to extend, the chart tag dropped (presentations collapse), the
section search short-circuited to "found", the order claimed to extend to ℤ_b,
the trust boundary disabled, injectivity never detected.

The survivor is worth recording rather than quietly fixing. **M2 — dropping
surjectivity from `is_bijection` — left the suite green**, because control C2
has *two* independent defences and passed on the other one: the kernel still
refused to normalise `n` and `2n` to one Church numeral, so the planted `Iso`
was refused for the wrong reason. That is good news about the architecture (the
defences really are independent) and bad news about the test (it could not tell
which one fired). C15 was added to isolate the kind check by offering a
transition with **no term pairs at all**, so the kernel cannot help; M2 dies
against it. A control that passes for a reason it did not name is not a control.

---

## 6. What this lane did **not** build

1. **Chart (g), Stern–Brocot, is absent.** `ATLAS_OF_N` §10(5) already declines
   to develop it; no transition from (g) is implemented here either.
2. **Nothing infinite is proved.** Every check is exhaustive on a stated finite
   range. Induction, initiality, contractibility, `Sym(P) = Aut(ℕ_{>0},×)`,
   `|Sym(P)| = 2^ℵ⁰`, Thm 5.3's topology — all are *exhibited*, none is proved.
   The finite checks refute; they do not confirm.
3. **`H²` is not computed as a group.** The carry class is certified nonzero by
   the exponent argument and by exhaustive section search; the cohomology group
   itself is never constructed, so "the class has order `b` in `ℤ/b`" is **not**
   established here — only "the class is not zero".
4. **The `Sym(P)` obstruction is an invariance argument, not a definability
   theorem in a formal language.** See the honest-scope paragraph in §2. In
   particular the commission's stronger phrasing — "a function definable from the
   factorization structure alone cannot compute `n+1`" — is established **for the
   automorphism-invariance notion of definable**, which is the standard one for
   parameter-free definability, and is the honest weaker statement where a full
   model-theoretic treatment was not attempted.
5. **Theorem 6.1 (unique factorization does not categorify) is not implemented.**
   The index `n!/∏(p!)^{a_p} a_p!` would be a natural next computation — the
   group machinery in `residual.py` (`index_of_subgroup`, `orbits`,
   `stabilizer`) is already sufficient for it.
6. **No non-integer, negative or mixed-radix bases**, inheriting
   `DIGIT_CRYSTAL` §8.5's limitation.
7. **`runtime/STATUS.md` has no row for this lane** — the integration lane owns
   that table and this lane deliberately edited no existing file.
