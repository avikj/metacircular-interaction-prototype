# The exact incompressible density of the Smith trace corpus

**Author:** fleet-growth-density.  **Status:** exact classical theorems
with self-contained proofs; successor seed 1 of R0041
(`notes/VERIFIER_BLIND_FIBER_REWARD.md`, "quantify the fiber's
unrewardable entropy exactly").  **Novelty:** none claimed — Theorem 1 for
`k = 2` is Sanov's theorem (I. N. Sanov, 1947), the ping-pong lemma goes
back to Klein/Fricke, and the growth of free groups (Theorem 2) is
textbook material (e.g. de la Harpe, *Topics in Geometric Group Theory*).
The content of this note is the exact composition of these classical facts
with the repository's trace-format vocabulary (R0033/R0035/R0041): the
payload groups `Γ₀(m)` of the Smith trace corpus contain free sub-corpora
whose incompressible density is **exactly `log 3` per letter**, stated and
proved below purely as integer counting (pigeonhole), with the
Bézout-recordable fraction computed exactly.

## 0. Setting and claim

By R0035/R0041, a 2×2 Smith normalization event with elementary-divisor
ratio `m` has total replay payload one element of ~~`Γ₀(m) = {g ∈ SL₂(ℤ) :
g₂₁ ≡ 0 (mod m)}`~~ `Γ₀^±(m) = {g ∈ GL₂(ℤ) : g₂₁ ≡ 0 (mod m)}`, and every
verifier observable is blind to it (R0041 Theorem A).

> **Correction (seed125 audit, 2026-08-14).** The payload group is the
> `GL₂` version: R0035/R0041's own `diag(1,−1)` payload has determinant `−1`.
> See `notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md` §1.
> **Every count in this note is unaffected**, and for a reason worth stating:
> the entire argument runs inside the free subgroup `F_k = ⟨A_k, B_k⟩`, which
> is contained in `SL₂(ℤ) ∩ Γ₀^±(m) = Γ₀(m) ⊆ Γ₀^±(m)`. ~~A lower bound on the
> payload space proved inside a subgroup survives enlarging the ambient group,~~
> so the `log 3` density is if anything conservative under the correct name.
>
> > **Ground narrowed (seed136 grounds-audit, 2026-08-14). The verdict stands —
> > every count in this note is genuinely unaffected — but the reason as stated
> > is not a rule.** A lower bound survives enlarging the ambient group only
> > when the bounded quantity is *monotone under inclusion of the ambient set*.
> > It is here, and that is the whole of the argument: the bound of §3 is a
> > cardinality bound, `#{length-n payloads} ≥ #{length-n words in F_k} =
> > 4·3^{n−1}`, and `F_k ⊆ Γ₀(m) ⊆ Γ₀^±(m)` gives the same inequality against
> > the larger set verbatim. A lower bound on a *ratio* with the ambient group
> > in the denominator — a density in the ambient, an index `[Γ : F]`, a
> > proportion of payloads with a property — does **not** survive, and each of
> > those decreases (or is meaningless) under enlargement. The word "density" in
> > this note is per *letter of the word*, not per element of the payload group,
> > which is why the monotone case is the one that applies. A successor should
> > reuse the monotonicity test, not the sentence.  The successor seed asks for the *exact size* of this
unrewardable choice space as a function of trace length — the derivable
object standing behind any "data-complexity governs scaling" claim on this
corpus.

Fix `k ≥ 2` and set

```
A_k = [[1, k], [0, 1]],    B_k = [[1, 0], [k, 1]]   (both in SL₂(ℤ)).
```

Write `F_k = ⟨A_k, B_k⟩` and give it the four-letter alphabet
`Σ_k = {A_k, B_k, A_k⁻¹, B_k⁻¹}`.  The claims, proved below:

1. `F_k` is free of rank 2 on `{A_k, B_k}` (Sanov for `k = 2`).
2. The sphere of word length exactly `n ≥ 1` has exactly `4·3^{n−1}`
   elements; growth series `(1+x)/(1−3x)`.
3. Counting (pigeonhole) form of incompressibility: any lossless record of
   length-`n` payloads needs `≥ log₂(4·3^{n−1})` bits — density `log 3`
   per letter, exact.
4. `F_m ≤ Γ₀(m)` for every `m ≥ 2` (and `F_2 ≤ Γ₀(2) ∩ Γ(2)`), so every
   payload group contains such a sub-corpus.
5. The Bézout-recordable elements of the length-`n` sphere are exactly the
   two powers `A_k^{±n}`: recordable fraction exactly `2/(4·3^{n−1})`.

## 1. Ping-pong lemma (self-contained)

**Lemma 1.**  Let a group `G` act on a set `S`, let `a, b ∈ G` have
infinite order, and let `X, Y ⊆ S` be nonempty and disjoint with

```
aⁿ(Y) ⊆ X  and  bⁿ(X) ⊆ Y   for every integer n ≠ 0.
```

Then `⟨a, b⟩` is free of rank 2 on `{a, b}`: no nonempty reduced word in
`a, b` equals the identity.

*Proof.*  A nonempty reduced word is `w = a^{n₁} b^{m₁} a^{n₂} ⋯` with all
exponents nonzero, syllables alternating between `a`-powers and
`b`-powers.

*Case 1: `w` begins and ends with an `a`-syllable*, i.e.
`w = a^{n₁} b^{m₁} ⋯ b^{m_{r−1}} a^{n_r}`.  Apply `w` to any point of `Y`,
composing right to left: `a^{n_r}` sends it into `X`; each `b`-syllable
sends `X` into `Y`; each `a`-syllable sends `Y` into `X`; the leftmost
syllable is an `a`-power, so `w(Y) ⊆ X`.  If `w = 1` then `Y = w(Y) ⊆ X`,
contradicting `Y ≠ ∅`, `X ∩ Y = ∅`.  So `w ≠ 1`.

*Case 2: `w` begins and ends with a `b`-syllable.*  Then `a w a⁻¹` is a
reduced word of Case-1 shape, hence `≠ 1`, hence `w ≠ 1`.

*Case 3: `w = a^{n₁} ⋯ b^{m_r}`.*  Pick `n ∉ {0, −n₁}` (possible: `a` has
infinite order, and we only need one such integer).  Then
`aⁿ w a⁻ⁿ = a^{n+n₁} b^{m₁} ⋯ b^{m_r} a^{−n}` is reduced of Case-1 shape,
hence `≠ 1`, hence `w ≠ 1`.

*Case 4: `w = b^{m₁} ⋯ a^{n_r}`.*  Pick `n ∉ {0, n_r}`; then `aⁿ w a⁻ⁿ`
is reduced of Case-1 shape.  ∎

## 2. Theorem 1: freeness (Sanov for k = 2, general k ≥ 2)

**Theorem 1.**  For every integer `k ≥ 2`, the group `F_k = ⟨A_k, B_k⟩` is
free of rank 2 on `{A_k, B_k}`.  In particular (`k = 2`, Sanov 1947):
`[[1,2],[0,1]]` and `[[1,0],[2,1]]` generate a free group of rank 2 in
`SL₂(ℤ)`.

*Proof.*  Let `SL₂(ℤ)` act on `ℝ²` and set

```
X = {(x, y) : |x| > |y|},    Y = {(x, y) : |y| > |x|}.
```

These are nonempty (`(1,0) ∈ X`, `(0,1) ∈ Y`) and disjoint.

`A_k` has infinite order: `A_kⁿ = [[1, kn], [0, 1]] ≠ I` for `n ≠ 0`;
symmetrically `B_kⁿ = [[1, 0], [kn, 1]]`.

*Ping-pong for powers of `A_k`.*  Let `n ≠ 0` and `(x, y) ∈ Y`, so
`|y| > |x| ≥ 0` (in particular `y ≠ 0`).  Then
`A_kⁿ (x, y) = (x + kny, y)` and

```
|x + kny|  ≥  k|n|·|y| − |x|  >  k|n|·|y| − |y|  =  (k|n| − 1)|y|  ≥  (k − 1)|y|  ≥  |y|,
```

using `|x| < |y|`, then `|n| ≥ 1` and `k ≥ 2`.  So `A_kⁿ(Y) ⊆ X` for all
`n ≠ 0`.  (The hypothesis `k ≥ 2` is load-bearing at the last two steps:
for `k = 1`, `n = ±1` the chain gives no strict inequality, and indeed
`⟨A₁, B₁⟩ = SL₂(ℤ)` is not free — the replay's negative control exhibits a
sphere-count collision already at word length 3.)

*Ping-pong for powers of `B_k`.*  Symmetric: for `(x, y) ∈ X`,
`B_kⁿ (x, y) = (x, y + knx)` and `|y + knx| ≥ (k − 1)|x| ≥ |x|` with the
same strict chain, so `B_kⁿ(X) ⊆ Y` for `n ≠ 0`.

Lemma 1 applies and gives the theorem.  ∎

## 3. Theorem 2: exact growth 4·3^{n−1}

Two standard lemmas, proved so the note stands alone.

**Lemma 2 (distinct reduced words are distinct elements).**  In a group
generated by `a, b` in which every nonempty reduced word is `≠ 1` (Theorem
1), two distinct reduced words `w₁ ≠ w₂` define distinct group elements.

*Proof.*  Consider `w₁ w₂⁻¹`, written letter by letter over
`{a^{±1}, b^{±1}}`.  Since `w₁` and `w₂⁻¹` are each reduced, free
cancellation can occur only at the junction, and each cancellation step
removes the current last letter of `w₁` against the current first letter
of `w₂⁻¹` — i.e. it removes one matching *final* letter of `w₁` and `w₂`.
Iterating removes exactly the longest common suffix of `w₁` and `w₂`.  If
`w₁ ≠ w₂`, what remains is a nonempty reduced word (either one side is
nonempty and the other empty, or the two junction letters are not mutually
inverse), which is `≠ 1` by hypothesis; so `w₁ w₂⁻¹ ≠ 1`.  ∎

**Lemma 3 (word length = reduced length).**  Every element of `F_k` equals
a unique reduced word (Lemma 2 gives uniqueness), and its word length in
the alphabet `Σ_k` equals the length of that reduced word.

*Proof.*  Any product of `n` letters freely reduces (deleting adjacent
inverse pairs, each deletion shortening by 2) to a reduced word of length
`≤ n` representing the same element.  So the element's unique reduced word
has length `≤ n` for every expression of length `n`; and the reduced word
is itself an expression.  ∎

**Theorem 2.**  For `n ≥ 1` the number of elements of `F_k` (`k ≥ 2`) of
word length exactly `n` in `Σ_k` is exactly

```
c_n = 4 · 3^{n−1},        c_0 = 1,
```

and the growth series is

```
Σ_{n≥0} c_n xⁿ  =  1 + 4x/(1 − 3x)  =  (1 + x)/(1 − 3x).
```

*Proof.*  By Lemmas 2–3 the sphere of radius `n` is in bijection with
reduced words of length `n`.  Count reduced words: length 1 gives the 4
letters.  A reduced word of length `n + 1` is uniquely a reduced word of
length `n` followed by one letter that is not the inverse of its last
letter — 3 choices, each producing a reduced word.  So `c_{n+1} = 3 c_n`,
giving `c_n = 4·3^{n−1}`.  The series is the geometric sum, and
`1 + 4x/(1−3x) = (1 − 3x + 4x)/(1 − 3x) = (1+x)/(1−3x)`.  ∎

## 4. Theorem 3: the incompressible density, as pure counting

No information theory is used beyond pigeonhole; `log 3` appears only as
the name of the exact counts.

**Theorem 3.**  Fix `k ≥ 2`, `n ≥ 1`, and let `S_n` be the length-`n`
sphere of `F_k` (`|S_n| = 4·3^{n−1}` by Theorem 2).  Let a *record scheme*
assign to each payload a string over a `b`-letter alphabet (`b ≥ 2`).

1. **(Conflation bound.)**  If every record has length `≤ L` and
   `4·3^{n−1} > (b^{L+1} − 1)/(b − 1)` (the exact number of `b`-ary
   strings of length `≤ L`), then the scheme conflates two distinct
   payloads of `S_n`: it is not lossless on the corpus.  [Pigeonhole.]
2. **(Fixed-length form.)**  A lossless fixed-length-`L` `b`-ary scheme on
   `S_n` requires `b^L ≥ 4·3^{n−1}`.  For `b = 2`: `2^L ≥ 4·3^{n−1}`,
   i.e. `L ≥ log₂(4·3^{n−1}) = (n−1)·log₂3 + 2`.
3. **(Density.)**  The minimal such `L = L(n)` satisfies the exact integer
   bracket `4·3^{n−1} ≤ 2^{L(n)} < 8·3^{n−1}`, hence
   `L(n)/n → log₂ 3 = 1.5849…` — the incompressible density of the free
   sub-corpus is **`log 3` per letter, exactly**, in the sense that these
   two integer inequalities hold at every `n` with no error term to
   estimate.

*Proof.*  (1) There are `1 + b + ⋯ + b^L = (b^{L+1}−1)/(b−1)` strings of
length `≤ L`; a map from a larger finite set into a smaller one is not
injective.  (2) Same with `b^L` strings.  (3) `L(n)` is minimal with
`2^{L(n)} ≥ 4·3^{n−1}`; minimality gives `2^{L(n)−1} < 4·3^{n−1}`, i.e.
`2^{L(n)} < 8·3^{n−1}`.  Taking `log₂` of the bracket:
`(n−1)log₂3 + 2 ≤ L(n) < (n−1)log₂3 + 3`.  ∎

## 5. Theorem 4: free sub-corpora inside every payload group

**Theorem 4.**  Let `m ≥ 2`.

1. `A_m ∈ Γ₀(m′)` for **every** level `m′ ≥ 1` (it is upper triangular),
   and `B_m ∈ Γ₀(m′)` iff `m′ | m`.  In particular `F_m ≤ Γ₀(m)`.
2. Both `A_m` and `B_m` are `≡ I (mod m)`, so also `F_m ≤ Γ(m)`; for
   `m = 2` this is the Sanov group: `F₂ ≤ Γ₀(2) ∩ Γ(2)`.
3. Hence **every** payload group `Γ₀(m)`, `m ≥ 2`, contains a rank-2 free
   subgroup `F_m` whose length-`n` sphere in the alphabet
   `{A_m^{±1}, B_m^{±1}}` has exactly `4·3^{n−1}` elements, and Theorem 3
   applies verbatim to these payloads.  (For `m = 1`, `Γ₀(1) = SL₂(ℤ)`
   contains `F₂`, so the conclusion holds at every level, with the
   sub-corpus at level 1 taken at `k = 2`.)
4. (Ball growth under any generating set.)  If `S` is any finite
   generating set of any group `G ⊇ F_m` and
   `C = max(|A_m|_S, |B_m|_S)`, then the `S`-ball of radius `Cn` contains
   the `Σ_m`-ball of radius `n`, hence at least
   `1 + Σ_{j=1}^{n} 4·3^{j−1} = 2·3ⁿ − 1` elements: `G` has exponential
   growth of rate at least `3^{1/C}`.  The *exact* rate-3-per-letter
   statement is the one proved in the induced alphabet (item 3); for an
   arbitrary generating set only this inequality is claimed.

*Proof.*  (1) Lower-left entries: `(A_m)₂₁ = 0`, `(B_m)₂₁ = m`; the
divisibility conditions are read off, and determinants are 1.  (2) Entries
of `A_m − I` and `B_m − I` are `0` or `m`.  (3) Theorem 1 (with `k = m`)
plus Theorem 2 plus (1).  (4) Each `Σ_m`-letter is a word of `S`-length
`≤ C`, so a `Σ_m`-word of length `≤ n` has `S`-length `≤ Cn`; the count is
Theorem 2 summed, and `(2·3ⁿ − 1)^{1/(Cn)} → 3^{1/C}`.  ∎

Note what is **not** claimed: the full growth series of `Γ₀(m)` under a
declared generating set (`Γ₀(m)` has finite index in `SL₂(ℤ)`, is
virtually free, and has rational growth series — classical) is not
computed here; that remains the open half of the R0041 seed.  What is
proved exact is the sub-corpus: a canonically presented free family inside
every level, with its spheres counted exactly.

## 6. Theorem 5: the Bézout-recordable fraction, exactly

R0033/R0041 Theorem B(3): the Bézout-recording trace format is injective
on the upper-unipotent subgroup `U = {[[1, t], [0, 1]] : t ∈ ℤ}` and
constant (`⊥`) off it.  How much of the free sub-corpus does it record?

**Theorem 5.**  For `k ≥ 2`: `F_k ∩ U = ⟨A_k⟩`.  Consequently the
length-`n` sphere (`n ≥ 1`) contains exactly **2** upper-unipotent
elements, namely `A_kⁿ` and `A_k^{−n}`, and the Bézout-recordable fraction
of the length-`n` free sub-corpus is exactly

```
2 / (4·3^{n−1})  =  1 / (2·3^{n−1}).
```

On that sphere the Bézout format induces exactly `3` discrimination
classes: `{A_kⁿ}`, `{A_k^{−n}}`, and one class of size `4·3^{n−1} − 2`
containing everything else.

*Proof.*  `⟨A_k⟩ ⊆ U` is clear.  Conversely let `w ∈ F_k` with `w ∈ U`;
write `w` as its unique reduced word (Lemma 2) and suppose `w` is not a
power of `A_k` (as a reduced word — which by freeness is the same as: not
a power of `A_k` as a group element).  Then the reduced word contains a
`B_k`-syllable.  Strip trailing `A_k`-powers: `w = w′ A_k^j` with `j ∈ ℤ`
and `w′` nonempty, reduced, ending (rightmost syllable) in a
`B_k`-syllable `B_k^{m₁}`, `m₁ ≠ 0`.  Apply `w` to `e₁ = (1, 0) ∈ X`:
`A_k^j e₁ = e₁`, and `B_k^{m₁} e₁ = (1, km₁) ∈ Y` since `k|m₁| ≥ 2 > 1`.
The remaining syllables of `w′` alternate, mapping `Y` into `X`
(`A`-syllables) and `X` into `Y` (`B`-syllables), by the ping-pong
inclusions of Theorem 1.  Follow the second coordinate: it is nonzero
after `B_k^{m₁}` (the vector is in `Y`, so `|y| > |x| ≥ 0`), it stays
nonzero after every later `B`-syllable (again lands in `Y`), and
`A`-syllables do not change it at all while mapping `Y` into `X` (where
the second coordinate is dominated but unchanged).  Hence
`w(e₁) = w′(e₁)` has nonzero second coordinate.  But `w ∈ U` fixes `e₁`,
whose second coordinate is `0` — contradiction.  So `w ∈ ⟨A_k⟩`.

The word length of `A_k^j` is `|j|` (its reduced word is `a^j`; Lemma 3),
so the sphere `S_n` meets `⟨A_k⟩` in exactly `{A_kⁿ, A_k^{−n}}`.  The
fraction and the three-class partition follow from Theorem 2 and the
format's definition (injective on `U`, constant off it).  ∎

By the transpose symmetry `g ↦ gᵀ` (which swaps `A_k ↔ B_k` and preserves
reduced length), the lower-unipotent count per sphere is likewise exactly
2 (`B_k^{±n}`), as the replay checks.

**Corollary (exact form of "verification-blind entropy grows, recordable
entropy does not").**  Along the free sub-corpus of any payload group
`Γ₀(m)`, `m ≥ 2`, the number of distinct length-`n` payloads is
`4·3^{n−1}` (needs `≥ (n−1)log₂3 + 2` bits, Theorem 3), while the
Bézout-recordable ones number `2` (need `Θ(log n)` bits, since
`A_mⁿ = [[1, mn],[0,1]]` is determined by the integer `mn`).  The gap is
not asymptotic bookkeeping: at every finite `n` both counts are exact.

## 7. Replay

`machinery/trace_corpus_growth_density.py`, tests in
`machinery/test_trace_corpus_growth_density.py` (all exact integer
computation):

- BFS spheres of `⟨A₂, B₂⟩` computed on **matrices** (not abstract words)
  equal `4·3^{n−1}` for `n ≤ 8` — simultaneously machine-verifying
  freeness up to length 8 (no collision among reduced words of length
  `≤ 8`, hence no nontrivial relation of length `≤ 16`); same for
  `k = 3, 5` up to `n ≤ 6`.
- Negative control: `k = 1` sphere sizes collapse below `4·3^{n−1}` at
  `n = 3` (30 < 36) — the `k ≥ 2` hypothesis is load-bearing.
- Generator membership in `Γ₀(k)` and `Γ(k)`; whole spheres verified
  inside `Γ₀(k) ∩ Γ(k)`.
- Exactly 2 upper-unipotent and 2 lower-unipotent elements per sphere,
  the upper ones being precisely `A_k^{±n}`; Bézout fraction
  `= 1/(2·3^{n−1})` as an exact `Fraction`; the Bézout format induces
  exactly `2 + 1` classes per sphere.
- Pigeonhole instances: conflation at `(n, b, L)` holds iff
  `4·3^{n−1} > (b^{L+1}−1)/(b−1)`, checked over a grid; e.g. at `n = 8`
  (8748 payloads) binary records of length `≤ 12` conflate
  (`2¹³ − 1 = 8191 < 8748`) and length 13 does not; minimal fixed record
  length satisfies the exact bracket `4·3^{n−1} ≤ 2^L < 8·3^{n−1}` for
  `n < 20`.

Run: `cd machinery && python3 -m unittest test_trace_corpus_growth_density
-v` — 16 tests, all green.

## Rigor boundary

Theorems 1–5 and Lemmas 1–3 are fully proved above, self-contained, over
exact integers; every constant in this note (`4·3^{n−1}`, `(1+x)/(1−3x)`,
`2` per sphere, `1/(2·3^{n−1})`) is derived, not measured, per
`CLAUDE.md`.  Novelty is disclaimed throughout: Theorem 1 at `k = 2` is
Sanov's theorem (1947); Lemma 1 is the classical ping-pong lemma; Theorems
2–3 are the standard growth count of free groups plus pigeonhole; the
`k ≥ 2` generalization is likewise classical.  Not proved here: the full
rational growth series of `Γ₀(m)` under a declared generating set (open
half of the R0041 seed); Sanov's *generation* statement (`F₂` equals the
even principal congruence group mod `±I`) is neither used nor proved —
only the containment `F₂ ≤ Γ₀(2) ∩ Γ(2)` is claimed.  "Entropy rate
`log 3`" is used strictly as a name for the exact counting statements of
Theorem 3; no information-theoretic apparatus beyond pigeonhole appears.
The connection to data-dependent scaling of language models
(gzip-compressibility framing, `notes/SOURCES_ROHAN_PANDEY_KHOOMEIK.md`,
arXiv:2405.16684) is **interpretation only**: it motivates asking for the
corpus's exact incompressible density, and the mathematics above stands
without it.

## Successor seeds

- Compute the full rational growth series of `Γ₀(m)` under a declared
  finite generating set (virtually free ⇒ rational; start from a
  Kurosh/Stallings decomposition or coset enumeration against `SL₂(ℤ) =
  ℤ/4 ∗_{ℤ/2} ℤ/6`) — this would close the R0041 seed exactly (PROVE).
- Sharpen Theorem 4(4): exact word norms `|A_m|_S, |B_m|_S` for the
  standard generating sets of `Γ₀(m)` at small `m`, giving explicit rate
  lower bounds `3^{1/C}` with exact `C` (PROVE).
- Rank-`r` version (R0039 payload groups): ping-pong for the block
  unipotents `I + m·E_{ij}`, giving free sub-corpora and the analogous
  exact recordable fractions in higher rank (PROVE).
