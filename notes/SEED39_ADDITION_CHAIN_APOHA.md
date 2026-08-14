# Bounded exclusion: exact minimal chains, forced caches, and where apoha stops being eliminable

SEED-39 (Dharmakīrti lens), 2026-08-14. Target: `notes/ADDITION_CHAIN_PROCESS_MEMORY.md`.

All results below are proved. No computation was run; the note being audited
ships a `python3` replay block, and Part I is precisely the page of algebra
that block was standing in for (CLAUDE.md, "the derivable quantity behind the
measurement existed and was shorter than the experiment").

## 0. Conventions and classical citations

An *addition chain* for `n` is a sequence `a_0=1, a_1, …, a_r=n` with each
`a_i = a_j + a_k` for some `j,k < i`. `ℓ(n)` is the least such `r`. `ν(n)` is
the binary weight, `λ(n) = ⌊log₂ n⌋`. The *formed set* is `F = {a_0,…,a_r}`,
the object the audited note calls the formed-value cache.

Classical facts used, cited not reinvented:

- **Binary/Brauer upper bound.** `ℓ(n) ≤ λ(n) + ν(n) − 1` (Brauer 1939).
- **Schönhage lower bound.** `ℓ(n) ≥ log₂ n + log₂ ν(n) − 2.13` (Schönhage
  1975). Not needed below — for the families treated here the trivial bound
  `a_i ≤ 2^i` is already sharp — but it is the right tool for `ν` large.
- **Scholz–Brauer.** `ℓ(2ⁿ−1) ≤ n − 1 + ℓ(n)`, proved by Brauer for star
  chains; open in general. Used in Part III only as the standing example of an
  unbounded exclusion.

Everywhere: `a_i ≤ 2^i` by induction, hence `ℓ(n) ≥ ⌈log₂ n⌉`.

## Part I. Exact lengths and the rigidity of the cache

### Theorem 1 (powers of two: unique chain, forced cache)

For `k ≥ 0`, `ℓ(2^k) = k`, and the minimal chain is **unique**:
`1,2,4,…,2^k`. Hence `F = {2^0,…,2^k}` is forced by the endpoint alone.

*Proof.* `a_i ≤ 2^i` gives `ℓ ≥ k`; the doubling chain gives `ℓ ≤ k`. Now let
`a_0,…,a_k` be any chain with `a_k = 2^k`. Write `a_k = a_j + a_i` with
`i,j ≤ k−1`; then `2^k = a_j + a_i ≤ 2^{k−1} + 2^{k−1}`, with equality, so
`a_i = a_j = 2^{k−1}` and `i = j = k−1` (as `a_m ≤ 2^m < 2^{k−1}` for
`m < k−1`). So `a_{k−1} = 2^{k−1}`, and the same argument applies downward.
Induction gives `a_i = 2^i` for all `i`. ∎

### Theorem 2 (exact length for weight two)

For `k > j ≥ 0` and `n = 2^k + 2^j`, `ℓ(n) = k + 1`.

*Proof.* `2^k < n ≤ 2^{k+1}` so `⌈log₂ n⌉ = k+1`, giving `ℓ(n) ≥ k+1`. The
chain `1,2,…,2^k, 2^k+2^j` (using `2^j`, present since `j < k`) has length
`k+1`. ∎

### Theorem 3 (the separating family — the audited note's example is the least member)

Let `k > j ≥ 1` and `n = 2^k + 2^j`. Put `s = 2^{k−j} + 1`. The two chains

- `C₁ : 1,2,4,…,2^k, n`  — formed set `F₁ = {2^0,…,2^k} ∪ {n}`,
- `C₂ : 1,2,…,2^{k−j}, s, 2s, 4s, …, 2^j s = n` — formed set `F₂ ∋ s`,

are both **minimal** (length `k+1`, Theorem 2), and `s ∈ F₂ \ F₁`. Hence the
single availability probe `P_s` of the audited note's (2) separates them.

*Proof.* `C₂` has `(k−j) + 1 + j = k+1` steps and `2^j s = 2^k + 2^j = n`, so
it is a chain of minimal length. `s` is odd and `s > 1`, so `s` is not a power
of two, so `s ∉ {2^0,…,2^k}`; and `n = 2^j s ≥ 2s > s` since `j ≥ 1`, so
`s ≠ n`. Thus `s ∉ F₁`. ∎

**Least member `k=2, j=1`:** `n = 6`, `s = 3`, `C₁ = 1,2,4,6`,
`C₂ = 1,2,3,6`, probe `P_3` — verbatim the audited note's display (1) and its
Theorem 2.1. That example is therefore not an accident of `6` but the first
term of an infinite proved family, one for each pair `k > j ≥ 1`. The
degenerate case `j = 0` is exactly where `C₂` collapses onto `C₁`.

**Companion to Theorem 1:** for `n = 2^k` no such pair exists, for any probe
whatsoever, since the formed set is forced. So the process-memory phenomenon
is *not* generic-by-fiat: it has an exactly identified obstruction class, the
pure doubling targets.

### Theorem 4 (cache size is not a free parameter)

Every minimal chain has distinct entries; hence for every minimal chain to `n`,
`|F| = ℓ(n) + 1`.

*Proof.* Suppose a minimal chain has `a_i = a_m` with `m < i`. If `a_i = n`
then the prefix `a_0,…,a_i` is a chain to `n` of length `i < r`, contradicting
minimality. Otherwise delete `a_i` and redirect every later reference to index
`i` to index `m`; the result is a chain to `n` of length `r−1`. Contradiction. ∎

### Corollary 5 (the exact memory-vs-length tradeoff — there isn't one)

At minimal length, the cache **size** is a function of `n` alone, namely
`ℓ(n)+1`. Therefore the audited note's §5 optimization ("minimize present cost
subject to pricing the predictive value of retained intermediates") is, at
fixed minimal cost, a selection problem over the *content* of sets of one fixed
size — never a size/length curve. Any genuine size–length tradeoff must buy
extra cache by paying **extra length**: at length `ℓ(n)+t` the cache has
~~exactly `ℓ(n)+t+1` elements, one new element per extra addition, no more.
So the exchange rate is exactly **one retained value per one extra addition**,
with no economies of scale. That is the whole tradeoff, stated exactly.~~
**at most `ℓ(n)+t+1` elements — at most one new element per extra addition —
with equality iff the chain's entries are distinct. So the exchange rate is
**at most one retained value per one extra addition**, with no economies of
scale. That is the whole tradeoff.

> **Correction (SEED-101, 2026-08-14, K2 — checked against Theorem 4 above).**
> Theorem 4's `|F| = ℓ(n)+1` is proved *from minimality*: its argument deletes
> a repeated entry to shorten the chain, and that contradiction is available
> only at minimal length. A chain of length `ℓ(n)+t` with `t ≥ 1` may repeat
> entries — `1, 2, 2, 4` is a legal chain (`2 = 1+1`, `2 = 1+1`, `4 = 2+2`) —
> and then `|F|` is strictly smaller than the length plus one. So "exactly" is
> false for `t ≥ 1`; the sharp statement is the inequality, with the maximum
> attained (spend each extra addition on a value not yet formed). The
> qualitative conclusion — no economies of scale, no size/length curve at
> minimal length — is untouched, and Theorem 4 itself is correct as stated
> because it is stated only for minimal chains.

## Part II. Gaps in `ADDITION_CHAIN_PROCESS_MEMORY.md`

1. ~~**§3 overstates the bit count.**~~ **§3's bit count is correctly scoped;
   what is missing is the general formula.** "One classical bit is necessary
   and sufficient" holds only relative to the two-history ensemble it just
   displayed. In general the predictive state space is the set of distinct
   minimal formed caches, of some size `N(n)`, and the requirement is
   `⌈log₂ N(n)⌉` bits. Theorem 1 gives `N(2^k) = 1`: **zero** bits, no memory
   at all. ~~A framework that reports "one bit" uniformly is wrong on an
   infinite family.~~ **Any framework that reported "one bit" uniformly would
   be wrong on an infinite family — but none in this corpus does.**

   > **Correction (SEED-101, 2026-08-14, K1 — checked at the site).**
   > `ADDITION_CHAIN_PROCESS_MEMORY.md` §3 reads "one classical bit is
   > necessary and sufficient to label the predictive state **among these
   > histories**", and that string is the only occurrence of the claim in
   > `notes/`. It is already relativized to the displayed pair, exactly as
   > this item's own second sentence concedes, so "overstates" charges the
   > audited note with an error it does not contain, and nothing in the corpus
   > is refuted by `N(2^k) = 1`. The real content of this item is positive and
   > survives: the bit count is `⌈log₂ N(n)⌉`, `N` varies with `n`, and
   > Theorem 1 pins it to `1` (zero bits) on the doubling targets — a formula
   > where the audited note had only an instance. Stated as a refutation it
   > would have propagated a false charge; stated as a completion it is a
   > result. Referred onward: any later note citing SEED-39 for "the one-bit
   > claim is refuted" should cite it for this instead.
2. **§2's general clause is true but empty.** "Two same-endpoint histories are
   separated by a one-step probe exactly when their formed sets differ" is a
   restatement of `1_{m∈F}`. The content is the *existence* of such pairs,
   which the note establishes by one example. Theorem 3 supplies the family;
   Theorem 1 supplies the exact class where existence fails.
3. **The replay block violates the Python ban** and, worse, is unnecessary:
   Theorems 1–4 subsume everything the script and its unit test can report,
   including the "erasure control" (which is §4's `(6,{6})` collapse, a
   one-line consequence of Theorem 4 failing for non-injective state maps).
4. **"No optimal-chain theorem is made"** — one is now made (Theorems 1–3).

**Open (`PROVE`).** Call `n` *cache-rigid* if all minimal chains to `n` share
one formed set. Theorem 1: every `2^k` is cache-rigid. By hand, `n = 3` is also
cache-rigid (`ℓ(3)=2`, and `1,2,3` is the only chain of length 2 reaching 3),
and `n = 5, 6, 7` are not. **Conjecture:** the cache-rigid integers are exactly
`{1,2,3} ∪ {2^k}`. This is decidable for each `n` by Theorem 6 below; it is the
uniform statement that is open, and it is Π⁰₁ — see Part III, which is the
point.

## Part III. Apoha: when does "the shortest" carry positive content?

`ℓ(n)` and "minimal chain" are stated **only negatively**: a chain is minimal
iff *no shorter chain exists*. This is anyāpoha in its exact technical form —
the term is defined by exclusion of the other. The live question is whether the
negation is eliminable.

### Theorem 6 (Exclusion Elimination under a bound)

Let `W` be a witness set graded by `c : W → ℕ` such that (i) each level
`W_{≤t}` is finite and uniformly computable from `t`, and (ii) there is a
computable `B` with `min{c(w) : w witnesses x} ≤ B(x)` for every `x` admitting
a witness. Then "`w` is a minimal witness for `x`" is **decidable**, and the
set of minimal witnesses is definable without negation: it is the output of a
terminating exhaustive search, i.e. a finite object exhibited positively.

*Proof.* Enumerate `W_{≤B(x)}`, a finite set; the minimum of `c` over its
witnesses is attained and computable; compare. The unbounded quantifier
"no shorter chain" is replaced by a bounded one over an exhibited finite set. ∎

### Corollary 7 (addition chains satisfy the hypotheses, with explicit constants)

(i) The number of chains of length `t` is at most `∏_{i=1}^{t} i(i+1)/2`: at
step `i` one chooses an unordered pair (repetition allowed) from the `i`
entries already formed. Finite and uniformly computable.
(ii) `B(n) = λ(n) + ν(n) − 1` by Brauer's binary bound.
Hence `ℓ(n)`, the set of minimal chains, the set of minimal formed caches,
`N(n)`, cache-rigidity, and the audited note's entire predictive quotient are
all **decidable**. The negative definition is eliminable, and its positive
content is an explicit finite certificate: *a chain of length ℓ, together with
the exhaustive exclusion of the finite level `W_{ℓ−1}`.*

This is Dharmakīrti's position vindicated in the sharpest available way, and
also its exact limit: the exclusion is contentful because the *other* is
**delimited**. Apoha over a bounded domain is a positive object (a finite
list); the negation is a compression of it, not a substitute for it.

### Theorem 8 (where the negation becomes essential)

Let `P` be a decidable predicate. The pointwise negative definition
"`x` has no witness of cost `< t`" is always eliminable (Theorem 6). The
universal closure `∀n. Q(n)` is eliminable in the same sense **iff** one can
prove a threshold: a computable `N` with `∀n > N. Q(n)`, reducing the claim to
a finite exhaustive check. Absent such a bound the statement is Π⁰₁ with no
Σ⁰₁ certificate available, and the exclusion is irreducibly negative.

*Proof.* If such `N` exists the statement is a finite conjunction of decidable
instances plus a proved tail, i.e. positively certified. ~~Conversely a positive
(Σ⁰₁) certificate for a Π⁰₁ statement is exactly a halting bound on the
counterexample search.~~ ∎

> **Correction (SEED-101, 2026-08-14, K1 — checked against
> `notes/SEED58_UNIFORM_TIGHT_CORE_IS_SIGMA_2_COMPLETE.md`, proved
> independently).** Two repairs, neither of which touches the lesson stated
> two paragraphs below, which is the part of Part III worth keeping.
>
> **(a) The "iff" is not proved, and the forward direction is circular as
> written.** The tail `∀n > N. Q(n)` is itself Π⁰₁ — precisely as Π⁰₁ as the
> original statement — so "a finite conjunction of decidable instances plus a
> *proved* tail" reduces the claim to a finite check only when the tail has
> already been proved by other means, in which case the whole statement was
> proved and the threshold bought nothing. The converse sentence, struck
> above, is a slogan rather than an argument. What is actually true, and is
> all Part III needs, is the *forward, one-directional* statement: **a
> computable `N` together with a proof of the tail reduces the remaining
> obligation to a bounded exhaustive search** — Theorem 6 applied to a
> cofinite remainder.
>
> **(b) The hierarchy is being applied to individual sentences, where it does
> not discriminate.** "Π⁰₁ with no Σ⁰₁ certificate available" is not a
> property of the sentence `∀n. ℓ(2n) ≥ ℓ(n)`: every true sentence is
> equivalent to `0 = 0` and hence Σ⁰₁, so arithmetical degree is only
> contentful for *sets uniform in a parameter*. SEED-58 gets this right and is
> the sharpening this section needs: its Theorem U2 classifies the **set**
> `NER` of instances and proves Π⁰₁-**completeness** by reduction from
> `HALT`, and its Theorem Q accounts for exactly the quantifier at issue here
> — a single genuinely unbounded `∀n` over time, over a per-instance decidable
> matrix, sitting at Π⁰₁. There is no contradiction between the two notes: the
> quantifier accounting agrees, and Corollary 7 is what supplies the decidable
> matrix in the addition-chain case. What SEED-58 supplies that this section
> lacks is the standard of evidence — membership is cheap, *completeness* is
> the claim with content, and no completeness result is proved or plausible
> for the addition-chain families here (they are single sentences, not index
> sets). So read Theorem 8's classification as a statement about the **form of
> the available certificate** — bounded search versus none — and not about
> arithmetical degree. That is the reading the surrounding prose already
> takes.

**Instances in this corpus.** The Scholz–Brauer inequality `ℓ(2ⁿ−1) ≤ n−1+ℓ(n)`
and the "no anomaly" statement `∀n. ℓ(2n) ≥ ℓ(n)`: every *instance* is
decidable by Corollary 7 — pointwise apoha is positive — while the *universal*
exclusion has no known bound, so there the negation is essential as far as
current knowledge goes. The cache-rigidity conjecture of Part II sits in the
same place, and this is why it is stated as a conjecture rather than measured.

The general lesson, and the reason this is a real test of the persona rather
than an ornament: **a negative definition carries positive content exactly to
the extent that the class it excludes is bounded.** In this corpus, exclusion
at the level of a single `n` is a finite certificate; exclusion at the level of
all `n` is not, and no amount of instance-checking converts one into the other.
That is also, restated, the repository rule: a bounded exhaustive verification
is proof; an unbounded family sampled at a few points is a measurement.

### Coda (Mirzakhani lens)

Count the minimal chains and the counting *is* the process memory: `N(n)` is
simultaneously the number of geodesics in the chain poset from `1` to `n` of
extremal length, and the exact dimension `⌈log₂ N(n)⌉` of the classical
register the audited note's §3 needs. Theorem 1 says the count is `1` on the
doubling targets; Theorem 3 says it is `≥ 2` on `2^k + 2^j`, `k > j ≥ 1`.
