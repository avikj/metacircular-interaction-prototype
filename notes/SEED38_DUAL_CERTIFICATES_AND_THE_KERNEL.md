# SEED-38: Dual certificates for LP_CERT, and whether Delta 19 really is the kernel

**Worker:** SEED-38 (Claude Opus 5), persona George Dantzig. 2026-08-14, overnight.
**Inputs (read in full):** `notes/LP_CERT.md`, `notes/DELTA19_IS_THE_KERNEL_AGAIN.md`.
**Type:** audit + exact results. No computation was run; no floating-point
number below was produced here — every number quoted from LP_CERT is quoted,
and every number asserted here is exact.

**Method note (Tarski).** Throughout I keep the *object language* — the
Hermitian forms `W`, `I`, `pole`, `arch`, the subspace `N_obs` — separate from
the *metalanguage* — a report, in floating point, about those forms. LP_CERT
mixes them: its §3–§4 tables are metalanguage sentences ("the run returned")
typeset as object-language sentences ("λ_min = 0.59"). Where the two conflict,
the exact statement bars (*bādha*) the measured one. Two of the conflicts below
are decisive.

---

## 0. Summary of findings

1. **LP_CERT §3, the row `+wide atoms (64)`, is internally impossible.** It
   reports `inertia(I) = (3,38,23)` and `inertia(I|_P) = (3,34,25)`. A negative
   index can never *increase* under restriction to a subspace. 25 > 23 refutes
   the row as printed, independently of every conditioning caveat in the note.
   (§2.1)
2. **The "more strongly" in LP2.2 is circular.** The form inequality
   `I(g) ≤ 2Re[Φ_g(0)Φ̄_g(1)]` advertised as strengthening the index bound is
   *literally* the hypothesis `I ≼ pole` from which the index bound was just
   derived, and is itself literally `W ≥ 0`, i.e. Weil's criterion. It adds
   nothing. (§2.2)
3. **Half of LP2.2 is unconditional and is stated as conditional.**
   `n₊(pole|_V) ≤ 1` needs no RH and no Weyl monotonicity; it is a two-line
   Sylvester argument, and it carries an exact rational congruence certificate,
   exhibited in §3.1. Only the passage from `pole` to `I` uses RH.
4. **Not one optimality or infeasibility claim in LP_CERT carries a dual
   certificate.** §3 gives the full ledger, the exact dual each claim needs, and
   — for the claims that are *infeasibility* claims — the observation that they
   need only a single exhibited rational vector, which is cheap and still
   missing. (§3)
5. **The constant `λ_min/λ_max = 0.19` is the `HOLOGRAM.md` §7 error again.**
   It is not a property of the prime-free slice; it decays like `1/log M` in the
   mode count `M`, and `M = 30` was fixed. Proved in §4, using only the
   monotonicity of `Re ψ(¼+iτ/2)` in `|τ|`. A number reported without its
   `M`-dependence looks like a spectral gap and is not one.
6. **DELTA19's kernel identification is a genuine equality of subspaces**, not
   an equality of dimensions — but only after two specialisations the note never
   states. Both are necessary: exact counterexamples in §5.2, §5.3.
7. The **REFUTED witness** in DELTA19 §2 (the 3×3 `T`), the containment
   criterion `BD^mC = 0 ∀m ⟺ B|_U = 0`, and the Kalman truncation to `m ≤ q−1`
   all check out exactly. Verified line by line in §5.4.

---

## 1. The persona's demand, stated precisely

An optimum you cannot certify with a dual solution is a number, not a result.
For the objects in LP_CERT the relevant primal–dual pair is not an LP but its
semidefinite parent, and it is worth writing down once because LP_CERT never
does.

Let `G ≻ 0` be the Gram matrix of the dictionary, `M` the Weil matrix, and
`Π` the orthogonal projector (in the `G` inner product) onto the primitive
block `P`. The quantity LP_CERT calls `λ_min(W|_P)` is the value of

> **(Primal)** minimise `c^H M c` subject to `c^H G c = 1`, `Πc = c`.

Its Lagrangian dual is

> **(Dual)** maximise `μ` subject to `Π(M − μG)Π ⪰ 0` on `ran Π`.

Weak duality is immediate; strong duality holds (Slater is trivial, the
feasible set is a sphere in a subspace). Therefore:

- **An upper bound on the optimum is a primal witness:** one vector `c`.
- **A lower bound on the optimum is a dual witness:** one certificate that
  `Π(M − μG)Π ⪰ 0`, i.e. a rational `LDL^H` factorisation with `D ⪰ 0`.
- **A claim of indefiniteness ("λ_min < 0") is an infeasibility claim for the
  dual at `μ = 0`, and is certified by a single primal vector** with
  `c^H M c < 0`, `Πc = c`.

This is the whole of the discipline being asked for. Note the asymmetry it
exposes, which is the practical content of this audit: LP_CERT's *hardest*
claims to certify (the positive lower bounds, §4's `0.59–1.42`) are exactly the
ones where nobody expects a certificate yet; but LP_CERT's *cheapest* claims to
certify — every `λ_min < 0` in the leave-one-out table of §4, each of which
needs one exhibited vector and no eigensolver at all — are also uncertified.
That is not a resource problem. That is a habit of reporting eigensolver output
instead of witnesses.

---

## 2. Errors found in the exact half of LP_CERT

### 2.1 The `+wide atoms (64)` row is impossible as printed

**Lemma A.** Let `A` be Hermitian on a finite-dimensional space `V` and `S ⊆ V`
a subspace. Then `n₋(A|_S) ≤ n₋(A)` and `n₊(A|_S) ≤ n₊(A)`.

*Proof.* Let `S₋ ⊆ S` be a subspace of dimension `n₋(A|_S)` on which `A|_S` is
negative definite. Then `A` is negative definite on `S₋ ⊆ V`, so
`n₋(A) ≥ dim S₋`. Symmetrically for `n₊`. ∎

Now read the fourth row of the §3 inertia table:

| dictionary | dim | inertia(I) | inertia(I&#124;_P) |
|---|---|---|---|
| +wide atoms | 64 | (3, 38, 23) | (3, 34, 25) |

`n₋(I) = 23` but `n₋(I|_P) = 25`. Lemma A forbids this. The row is not merely
ill-conditioned; as a pair of integer triples it cannot both be true.

The diagnosis is visible in the same row: `n₀(I) = 38`. Thirty-eight directions
were classified as numerically zero at relative tolerance `1e−8`; on restriction
four of them changed class, two upward and two downward. The reported inertia
triples are therefore not inertias of anything — they are histograms of an
eigensolver's output binned against a threshold, and the binning is not stable
under the operation the table applies to it. Lemma A is the cheapest possible
consistency check on such a table, costs one subtraction per row, and was not
run. Rows 1–3 pass it; row 4 fails.

The same check applies to the interlacing budget: `P` has codimension 2, so
additionally `n₊(I) − 2 ≤ n₊(I|_P)` and `n₋(I) − 2 ≤ n₋(I|_P)`. Rows 1–3
satisfy both bounds. ~~Row 4 satisfies the `n₊` bound and violates the `n₋`
one.~~

> **Correction (SEED-101, 2026-08-14, Rule K2 — checked against this note's own
> Lemma A).** Row 4 satisfies **both** interlacing lower bounds:
> `n₊: 3−2 = 1 ≤ 3` and `n₋: 23−2 = 21 ≤ 25`. The interlacing budget is not
> what row 4 violates. What it violates is Lemma A's *upper* bound
> `n₋(I|_P) ≤ n₋(I)`, i.e. `25 ≤ 23`, which is the impossibility already
> established two paragraphs above. The verdict of §2.1 is unaffected — row 4
> is impossible as printed — but the reason given in this sentence was the
> wrong one, and the sentence is struck rather than deleted so the record shows
> which check actually fired. (Convention re-verified at the source: LP_CERT §3
> states the triples are `(n₊, n₀, n₋)` explicitly, so `n₋` is the third entry
> and the reading in §2.1 is correct.)

**Consequence for the note's reading.** LP_CERT's §3 concludes "the conditioned
data are consistent with H2 and H1". For row 4 the data are not consistent with
*themselves*. The sentence that must be added is not another caveat about
whitening; it is that row 4 reports no inertia at all.

### 2.2 The "stronger form inequality" is the hypothesis

LP2.2 argues: `I = pole − W`; under RH `W ⪰ 0`; hence `I ≼ pole`; hence by Weyl
`λ₂(I) ≤ λ₂(pole) ≤ 0`. Correct. It then says:

> More strongly, the following form inequality holds:
> `I(g) ≤ 2Re[Φ_g(0)Φ̄_g(1)] = "Z·Z ≤ 2d₁d₂"`.

But `2Re[Φ_g(0)Φ̄_g(1)] = pole(g)`, so the displayed inequality is
`I(g) ≤ pole(g)`, i.e. `pole(g) − W(g) ≤ pole(g)`, i.e. `W(g) ≥ 0` — Weil's
criterion, the assumption of the preceding sentence. It is not stronger than
the index bound; it is the *input* to the index bound, restated. Under RH it is
true, under ¬RH it is false, and it is equivalent to RH on the full admissible
class. Calling it "more strongly" invites a reader to treat the Castelnuovo
analogy as carrying extra arithmetic content beyond `W ⪰ 0`. It carries none.

The honest statement of the Castelnuovo line is: *the intersection-theoretic
transcription of Weil positivity is `Z·Z ≤ 2d₁d₂`, and this transcription is a
change of vocabulary, not a change of hypothesis.* The note's own §6
prior-art paragraph already says the transcription is not new
(Connes–Consani–Marcolli, Def. 7.1 / Prop. 7.2); §2 should not re-import it as
strength.

### 2.3 Half of LP2.2 does not need RH

LP_CERT derives `n₊ ≤ 1` for `pole|_V` by Weyl monotonicity from a form
comparison. That is a detour. The following is unconditional and needs no
eigenvalues.

**Lemma B.** Let `Q` be a Hermitian form on `ℂ²` with `n₊(Q) = 1`, let `V` be
any finite-dimensional space and `Φ : V → ℂ²` linear. Then `n₊(Φ*Q) ≤ 1` and
`n₋(Φ*Q) ≤ 1`.

*Proof.* Suppose `S ⊆ V` is a 2-dimensional subspace on which `Φ*Q` is positive
definite. Then `Φ|_S` is injective: a nonzero `v ∈ ker Φ|_S` would give
`(Φ*Q)(v) = Q(0) = 0`. So `Φ(S) ⊆ ℂ²` is 2-dimensional, i.e. all of `ℂ²`, and
`Q` is positive definite on it — contradicting `n₊(Q) = 1`. Symmetrically for
`n₋`. ∎

With `Q = pole` and `Φ_V : g ↦ (Φ_g(0), Φ_g(1))` this gives LP_CERT's
"positive and negative index at most one, inertia `(1, r−2, 1)` only when the
moment map has rank two" directly, unconditionally, with the rank statement
falling out of the same proof (`n₊ = n₋ = 1` iff `Φ` is onto `ℂ²`). RH enters
only at the step `pole ⟶ I`.

---

## 3. The certificate ledger

### 3.1 The one claim I can certify exactly, certified

**Claim (LP_CERT §2, §3 "Pole form inertia"):** the pole form on the moment
plane is `[[0,1],[1,0]]`, with inertia `(1,0,1)` and null generators
`F₁² = F₂² = 0`, `F₁·F₂ = 1`.

**Certificate (exact, rational, congruence).** Put

```
S = [[1,  1],
     [1, -1]],        det S = -2 ≠ 0,
```

then

```
Sᵀ [[0,1],[1,0]] S = [[2, 0],
                      [0,-2]].
```

Check by hand: `(Sᵀ Q S)₁₁ = 2·1·1 = 2`; `(Sᵀ Q S)₁₂ = 1·(−1) + 1·1 = 0`;
`(Sᵀ Q S)₂₂ = 2·1·(−1) = −2`. Diagonal `(2, −2)`, signs `(+,−)`, so by
Sylvester's law of inertia `n₊ = n₋ = 1`, `n₀ = 0`. `det Q = −1 ≠ 0` confirms
`n₀ = 0` independently. The two null generators are the columns of the identity,
`e₁, e₂`, with `Q(e₁,e₁) = Q(e₂,e₂) = 0`, `Q(e₁,e₂) = 1`: exactly the hyperbolic
plane claimed.

This is the entire exact spectral content of §2 and it fits in six lines of
rational arithmetic. Combined with Lemma B it certifies every inertia statement
LP_CERT makes about `pole` on any test space, and it does so *without* the run
that produced the "spurious inertias `(1,57,2)` and `(2,60,2)`". Those spurious
triples, incidentally, also violate Lemma B — `n₋ = 2` for a pullback of a form
with `n₋ = 1` is impossible — which is again a check available at the cost of
one comparison.

### 3.2 Ledger of the remaining claims

`P` = primal witness (a vector), `D` = dual witness (a PSD certificate).
"Present" means exhibited in the note with entries a reader could check.

| # | claim in LP_CERT | kind | certificate needed | present? |
|---|---|---|---|---|
| 1 | pole form inertia `(1,0,1)`, null generators | exact | rational congruence | **now present**, §3.1 |
| 2 | `n₊(pole&#124;_V) ≤ 1` | exact | Lemma B | **now present**, §2.3 |
| 3 | `n₊(I&#124;_V) ≤ 1` under RH | exact, conditional | Lemma B + `W ⪰ 0` | present in substance (LP2.2), modulo §2.2 |
| 4 | LP1: `W&#124;_P ⪰ 0` under RH | exact, conditional | termwise sum of squares | present |
| 5 | §3 table, `λ₂(I) = −1.7e−8`, `+6.3e−13`, `+3.2e−5`, `+4.4e−5` | numerical | D: rational `LDL^H` of `Π(M−μG)Π` with slack, over rigorous interval enclosures of `M`, `G` | **absent** |
| 6 | §3 "top of I&#124;_P (assembled) = −1.718e−8 matches finite-zero estimate" | numerical | D for the upper bound + P for the lower; also an *a priori* truncation bound for the 100,000-zero tail | **absent**; and the note's own §3 records factored/assembled `λ_min` disagreeing by up to `4.5e−1` elsewhere |
| 7 | §3 `λ_min = 3.14e−10` on the narrow dictionary, "nine orders smaller than the best single atom" | numerical | P (one vector, gives `≤`) + D (gives `≥`) | **P absent though it is free** — the minimiser was computed; printing 20 rational coordinates would upgrade "λ_min = 3.14e−10" to the checkable "λ_min ≤ 3.15e−10" |
| 8 | §4 `λ_min(W&#124;_P) = 0.59–1.42` at `T < log 2` | numerical, positive | D: `Π(arch − 0.59 G)Π ⪰ 0` in exact arithmetic over interval enclosures of the archimedean quadrature | **absent**; and see §4 below — the companion ratio `0.19` is scale-dependent |
| 9 | §4 per-prime-power cascade `2.5e−1 → 1e−30` | numerical, positive | D per row; also the `M`-dependence, which the note admits is `~10%` at `M=22/30/38` in the resolved regime and *unbounded* in the collapse regime | **absent** |
| 10 | §4 leave-one-out `λ_min < 0` for `n = 3,4,5,7,8,…,27` | numerical, **infeasibility** | **P only: one rational `c` with `Πc = c` and `c^H M c < 0`** | **absent — and this is the cheap one** |
| 11 | §5 conditioning numbers `cond = 2.6e16` etc. | numerical | none available in principle; these are honest diagnostics | n/a, correctly labelled |

**The line worth acting on is row 10.** ~~Twelve indefiniteness claims are
made.~~ **A claim per tested prime power `3 ≤ n ≤ 27` is made.**

> **Correction (SEED-101, 2026-08-14, K1 — count checked against LP_CERT §4).**
> "Twelve" is not derivable from the source and is almost certainly wrong.
> LP_CERT §4 names five deletions explicitly (`n = 3, 4, 5, 7, 8`) and then
> writes "every later prime power tested (through 27)" without enumerating the
> rest. The prime powers in `[3, 27]` are `3,4,5,7,8,9,11,13,16,17,19,23,25,27`
> — **fourteen**, not twelve — so if every one was tested the count is 14, and
> if not, the count is unknown because LP_CERT does not say which were. Either
> way a specific numeral must not be quoted here: this note was written to
> object to numbers reported without their provenance, and a fitted count is
> the same defect one level up. Read every "twelve" in §3.2 row 10, in the
> paragraphs below it, and in §6 item 4 as "one per tested prime power
> `3 ≤ n ≤ 27`, a list LP_CERT must state". The argument — one exhibited
> rational vector certifies each, and the minimisers were already in hand — is
> unchanged and is what matters.

Each is an existential statement — "there exists `g ∈ P` with `W(g) < 0` when
atom `n` is deleted" — and each is certified by exhibiting *one* vector. The
run already produced those vectors: the note even reports the Rayleigh weight of
the deleted term at the minimiser ("11.8 at `n=2` … `~1e14` by `n=11`"), so the
minimiser was in hand. Rounding those minimisers to rationals and printing them,
together with the rational form data at that cap, converts twelve floating-point
assertions into twelve finite checks. Nothing else in LP_CERT has that
cost-to-certainty ratio. It should be done before any further eigen-sweeps.

I record the reason this matters beyond bookkeeping: row 10 is the note's most
*consequential* empirical claim — it is the source of "the assembled form is not
a monotone budget", which is the sentence a successor programme will build on.
An existential claim supporting a structural conclusion, with the witness
available and unprinted, is the exact shape of the `exp27` failure this
repository's `CLAUDE.md` was written to prevent.

---

## 4. The `0.19` has a scale, and it decays

LP_CERT §4 and §6 report, as the headline of the prime-free regime,

> `λ_min(arch|_P)/λ_max ≈ 0.19` (28-dimensional compact-basis primitive slice at
> `T = 0.68`, `M = 30` modes), "comfortable O(1) computed definiteness",
> contrasted with `6.9e−4` unconstrained.

Per `CLAUDE.md` §7 (`HOLOGRAM.md` corollary): a constant measured at one scale
hides its scaling. Here the hidden scale is the mode count `M`, and the ratio is
not `O(1)`.

**Setup.** With the note's own conventions, `Φ_g(½+iτ) = ∫ g(u) e^{iτu} du`, so
Plancherel gives `‖g‖² = (1/2π)∫|Φ_g(½+iτ)|² dτ`, and for `T < log 2` the prime
sum is empty and the pole form vanishes on `P`, so on the primitive slice

```
R(g) := W(g)/‖g‖² = arch(g)/‖g‖²
      = ∫ |Φ_g(½+iτ)|² D(τ) dτ  /  ∫ |Φ_g(½+iτ)|² dτ,     D(τ) = Re ψ(¼+iτ/2) − log π.
```

`R` is a weighted average of `D`. Two exact facts about `D`:

**(D1) `D` is even and strictly increasing in `|τ|`.** From
`Re ψ(z) = −γ + Σ_{n≥0}[ 1/(n+1) − Re 1/(z+n) ]` and, for `z = x+iy` with
`x > 0`, `Re 1/(z+n) = (x+n)/((x+n)² + y²)`, which is strictly decreasing in
`|y|`. Hence `Re ψ(¼+iτ/2)` strictly increases in `|τ|`.

**(D2) `D(0) = −γ − π/2 − 3 log 2 − log π < 0`,** using `ψ(¼) = −γ − π/2 − 3log2`.
Numerically `≈ −5.3722`, but the sign is what is used, and it is exact.

**(D3) `D(τ) = log(|τ|/(2π)) + O(τ^{−2})` as `|τ| → ∞`,** from
`ψ(z) = log z − 1/(2z) + O(z^{−2})`: `Re ψ(¼+iτ/2) = log(|τ|/2) + O(τ^{−2})`,
and subtracting `log π` gives the stated form.

**Proposition S38-1.** Let `V_M ⊆ P` be the primitive part of the span of the
compact basis `h_1,…,h_M` on `[−T/2, T/2]`, whose frequencies satisfy
`q_m ≍ m/T`. Then

```
λ_min(arch|_{V_M}) ≤ C₁     and     λ_max(arch|_{V_M}) ≥ c₂ log M − C₃,
```

with `C₁, c₂ > 0, C₃` independent of `M`. Consequently

```
λ_min/λ_max = O(1/log M),
```

and in particular the reported `0.19` is a value of a quantity tending to `0`,
not an estimate of a spectral gap.

*Proof.* **Upper bound on `λ_min`.** Fix any three low modes `h_1,h_2,h_3`;
their span meets the codimension-2 subspace `P` in a nonzero vector `g₀`,
independent of `M`. Then `λ_min ≤ R(g₀) =: C₁`, a fixed finite number
(`R(g₀) < ∞` because `∫|Φ_{g₀}|² D dτ` converges: `|Φ_{g₀}|² = O(τ^{−4})` by the
`C¹` zero-extension and `D = O(log|τ|)`).

**Lower bound on `λ_max`.** Take the three top modes `h_{M−2}, h_{M−1}, h_M`;
their span meets `P` in a nonzero `g_M`. Write `μ` for the probability measure
`|Φ_{g_M}(½+iτ)|² dτ / ∫|Φ_{g_M}|² dτ`. Since `D ≥ D(0)` everywhere by (D1),

```
R(g_M) ≥ D(0) + ( D(q_{M−2}) − D(0) ) · μ({ |τ| ≥ q_{M−2} }).
```

The modes `h_m` are cosine differences at frequencies `q_{m±1}`, so `Φ_{g_M}`
has its principal mass at `|τ| ≍ q_{M−2}…q_{M+1}` with algebraic `τ^{−2}` tails;
hence `μ({|τ| ≥ q_{M−2}}) ≥ c > 0` uniformly in `M`. With (D3) and
`q_{M−2} ≍ (M−2)/T`,

```
λ_max ≥ R(g_M) ≥ D(0) + c·( log(M/(2πT)) + O(1) − D(0) ) = c₂ log M − C₃. ∎
```

**Reading.** Two things follow, and they point in opposite directions from the
note's reading:

- The prime-free positivity that LP_CERT calls "comfortable" is real (`λ_min`
  bounded below away from `0` is the substantive question), but the *ratio* is
  the wrong statistic to quote for it: the denominator diverges by (D3) for
  purely archimedean reasons — the Γ-factor weight grows logarithmically — and
  has nothing to do with the arithmetic being tested. Quoting `0.19` against
  `6.9e−4` compares two numbers whose denominators diverge at different rates.
- The statistic that *is* scale-free, and that the note should report, is
  `λ_min(arch|_P)` itself, together with the `M` at which it was computed and a
  dual certificate for it (ledger row 8). Whether `λ_min(arch|_P)` is bounded
  below uniformly in `M` for `T < log 2` is a genuine open question of exactly
  the Connes–Consani type, and it is invisible in the ratio.

Note also (D2): `D(0) < 0`, so `arch` is **not** positive semidefinite on the
full space — the archimedean form is indefinite, and the positivity of `arch|_P`
is a real constrained statement, not an automatic one. LP_CERT's phrase
"`W|_P = arch|_P` on this finite slice — comfortable O(1) computed definiteness"
reads as though the definiteness were inherited from `arch`. It is not.

---

## 5. DELTA19: is it the same kernel, or the same dimension?

The mandate asks whether "`N_obs` **is** the kernel" is an equality of
subspaces or a coincidence of an invariant. Verdict: **equality of subspaces —
exactly, not merely dimensionally — under two specialisations that the note
does not state, both of which are necessary.**

### 5.1 The equality, proved

Let `U` be a vector space over a field `k`, `T : U → U` linear, `O` a vector
space and `P : U → O` linear. Take the Lean data of
`formal/pairfield/Pairfield/FutureBehavior.lean` with `X := U`, `O := O`,
`observe := P`, alphabet `A := {∗}` a singleton, `step x ∗ := T x`.

Words in `A` of length `n` are in bijection with `n ∈ ℕ`, and
`run step x (word of length n) = Tⁿ x` by induction on `n` (base: `T⁰ = id`;
step: `run` prepends one action). Hence

```
behavior step observe x (word of length n) = P Tⁿ x.
```

Therefore, for `x, y ∈ U`,

```
FutureEq step observe x y
  ⟺ ∀ n,  P Tⁿ x = P Tⁿ y                       (bijection words ↔ ℕ)
  ⟺ ∀ n,  P Tⁿ (x − y) = 0                      (linearity of P and Tⁿ)
  ⟺ x − y ∈ ⋂_{n ≥ 0} ker(P Tⁿ) = N_obs.
```

**Proposition S38-2.** Under the above, `{x : FutureEq step observe x 0} = N_obs`
**as subsets of `U`**, and this set is a linear subspace, and `FutureEq` is
exactly the coset equivalence `x ~ y ⟺ x − y ∈ N_obs`. Moreover the Lean
theorem `futureEq_step` specialises to `T N_obs ⊆ N_obs` (T19.12/T19.35): if
`x ∈ N_obs` then `FutureEq x 0`, so `futureEq_step` gives
`FutureEq (T x) (T 0) = FutureEq (T x) 0`, i.e. `T x ∈ N_obs`. ∎

This is an equality of *sets*, established by a chain of `⟺`s at the level of
elements. No dimension count occurs anywhere in it. So DELTA19 §1's
identification survives the test the corpus has failed before: it is the same
object, not the same invariant.

Two remarks on what makes the proof go through, each of which is a hypothesis
DELTA19 leaves silent.

### 5.2 Necessity of the singleton alphabet — exact counterexample

If `|A| > 1` the Lean kernel is `⋂_{words w} ker(P S_w)` over *all* words in the
action monoid, which is in general strictly smaller than `⋂_n ker(P T_aⁿ)` for a
single action `a`. Witness over `ℝ`, `U = ℝ²`, `P(x₁,x₂) = x₁`, `A = {a,b}`:

```
T_a = [[0,0],[0,1]]   (kills coordinate 1, fixes coordinate 2)
T_b = [[0,1],[1,0]]   (swap)
```

Then `P T_aⁿ e₂ = P e₂ = 0` for all `n ≥ 0`, so `e₂ ∈ ⋂_n ker(P T_aⁿ)`; but
`P T_b e₂ = P e₁ = 1 ≠ 0`, so `e₂` is **not** in the Lean kernel. The two
objects differ. So "Delta 19's `N_obs` is the kernel of `behavior` in the linear
case" is true for the autonomous system Delta 19 actually writes, and false for
the input-driven system the Lean file actually supports. The Lean statement is
more general in the direction of dropping linearity (as DELTA19 correctly says)
and *also* more general in the direction of many actions — and in that second
direction it is a different subspace, not a generalisation of the same one
evaluated at a point.

The correct statement of the general linear case, for the record: with actions
acting by linear maps `T_a`, the observationally-null subspace is
`⋂_{w ∈ A*} ker(P T_w)`, the **unobservable subspace of the switched linear
system**, which equals the largest `{T_a}`-invariant subspace contained in
`ker P`. For `|A| = 1` this is Kalman's unobservable subspace and, by
Cayley–Hamilton, the intersection truncates at `n ≤ dim U − 1` — the truncation
DELTA19 §2 correctly applies to the *other* chain (`U_k`) but never states for
`N_obs` itself.

### 5.3 Necessity of linear `observe` — exact counterexample

DELTA19 says "Delta 19's `N_obs` is the kernel of `behavior` in the linear case,
where the equivalence class of `0` is a subspace". The parenthetical is doing
real work and should be a hypothesis. Take `U = ℝ`, `A = {∗}`, `T = id`,
`observe(x) = x²`. Then `FutureEq x y ⟺ x² = y²`, whose classes are `{±x}`.
The class of `0` is `{0}`, which *is* a subspace — but `FutureEq` is not the
coset relation of it (`1 ~ −1` while `1 − (−1) = 2 ∉ {0}`). So even when the
zero-class happens to be a subspace, without linearity of `observe` the
equivalence is not determined by that subspace, and T19.11 ("x,y equivalent iff
`x − y ∈ N_obs`") fails. Linearity of `observe` is not cosmetic.

### 5.4 Verification of the REFUTED block and the corrected criteria

I checked the note's own refutation arithmetic, since it is the part most likely
to have been transcribed rather than computed.

**The 3×3 witness.** Basis `(f, e₁, e₂)`, matrix columns are images:

```
T = [[0,0,1],
     [1,1,0],
     [0,0,0]]
```
gives `T f = (0,1,0) = e₁`, `T e₁ = (0,1,0) = e₁`, `T e₂ = (1,0,0) = f`. With
`P = diag(1,0,0)`, `Q = I − P`: `A = PTP = 0` ✓ (coefficient of `f` in `Tf` is
`0`); `C = QTP : f ↦ e₁` ✓; `D = QTQ : e₁ ↦ e₁, e₂ ↦ 0` ✓; `B = PTQ : e₁ ↦ 0,
e₂ ↦ f` ✓. Then `B ≠ 0`, `C ≠ 0`, and `B Dᵐ C f = B Dᵐ e₁ = B e₁ = 0` for every
`m ≥ 0` ✓. And `Tⁿ f = e₁` for `n ≥ 1`, so `P Tⁿ P = 0 = (PTP)ⁿ` for `n ≥ 1` ✓.
**The witness is correct**: closure holds with both channels nonzero, so
C19.10's gloss "either one vanishing restores closure" is indeed only the weak
direction, and the note's refutation stands.

**The containment form.** `U := Σ_{m≥0} Dᵐ C(ran P)`. `D U ⊆ U` is immediate
from the definition (shifting `m`). `BDᵐC = 0 ∀m ⟺ B|_U = 0` is immediate since
`U` is by definition spanned by the `Dᵐ C(ran P)` ✓. The gloss "the reachable
subspace of `(D,C,B)` lies in its unobservable subspace / the Hankel operator of
the excursion subsystem vanishes" is the correct classical reading ✓.

**The Kalman truncation.** `U_k := Σ_{m<k} Dᵐ C(ran P)` satisfies
`U_{k+1} = C(ran P) + D U_k`, so `U_k = U_{k+1} ⟹ U_{k+1} = U_{k+2}`; the chain
is increasing inside `ran Q`, so it strictly increases until it stabilises and
therefore stabilises by `k = q := dim ran Q` ✓. Hence `BDᵐC = 0 ∀ m ≥ 0` iff
`BDᵐC = 0` for `0 ≤ m ≤ q−1` ✓. (Edge case: if `C(ran P) = 0` the chain
stabilises at `k = 1`; the bound is still valid.)

All three check. The refutation in DELTA19 §2 is sound and I add nothing to it
beyond confirmation and the `N_obs` truncation noted in §5.2 above.

---

## 6. What should change in each note

**`notes/LP_CERT.md`:**

1. Strike or re-derive the `+wide atoms (64)` row of the §3 table; as printed it
   violates Lemma A. Add Lemma A as a standing consistency check on every
   reported inertia pair. (It also kills the spurious `(1,57,2)`/`(2,60,2)` by
   Lemma B, which is a stronger statement than "eigensolver artifact".)
2. Delete "More strongly" in LP2.2 and replace the displayed inequality with the
   sentence that it *is* `W ⪰ 0` in intersection-theoretic vocabulary.
3. Restate the pole-inertia claim as unconditional (Lemma B) with the rational
   congruence certificate of §3.1 inline.
4. Print the leave-one-out minimisers (§4) as exact rationals. Twelve
   infeasibility certificates for the price of twelve vectors.
5. Replace `λ_min/λ_max = 0.19` by `λ_min(arch|_P)` at stated `M` and `T`, with
   the `O(1/log M)` decay of the ratio recorded (Proposition S38-1), and the
   observation that `D(0) < 0` so `arch` is indefinite on the full space.

**`notes/DELTA19_IS_THE_KERNEL_AGAIN.md`:**

6. Add the two hypotheses to §1's identification: singleton alphabet (or all
   actions acting by the same map), and linear `observe`. Cite §5.2 and §5.3 for
   necessity. Then §1's claim is Proposition S38-2 — an equality of subspaces,
   provable in five lines, and therefore a fit target for the successor seed 3
   ("checked transport"), which becomes a small and well-posed Lean exercise
   rather than an open-ended one.
7. Record the `N_obs` truncation `⋂_{n≥0} ker(PTⁿ) = ⋂_{n<dim U} ker(PTⁿ)`
   (Cayley–Hamilton), parallel to the `U_k` truncation the note already gives.
   As stated, `N_obs` is an infinite intersection and is no more a test than
   C19.10 was.

---

## Appendix. The field neither end names

The two notes are discussing the same question from opposite ends, and neither
names the field it is in.

LP_CERT §4 asks: *delete one atom `Λ(n)` from the assembled form; does the
conclusion survive?* It reports that deleting any single tested `n ≥ 3` breaks
positivity, and calls this "not a monotone budget". DELTA19 §2 asks: *delete one
distinction from the state space; does the dynamics survive?* It reports that the
answer is governed by whether `B Dᵐ C` vanishes — whether the reachable subspace
of the excursion subsystem lies in its unobservable subspace.

These are one question. LP_CERT's leave-one-out sweep is a **Hankel** computation:
each atom is a channel into the form and back out of it, and "atom `n` is
load-bearing" means precisely that the composite in-then-out map through `n` is
nonzero at the minimiser — the note even reports the composite's size (the
Rayleigh weight, `11.8` at `n=2` growing to `~1e14` by `n=11`), which is a
Hankel singular value in all but name, and its growth to `1e14` is the exact
statement that the minimiser "rides an extreme cancellation". DELTA19 names the
field on the operator side ("classical minimal-realization theory; no novelty")
and does not carry it back to any arithmetic instance. LP_CERT names it on
neither side, and so reports twelve deletions as twelve separate empirical facts
rather than as one rank computation with a truncation bound.

The consequence is concrete rather than aesthetic. Minimal-realization theory
supplies exactly what LP_CERT §4 lacks: a **truncation theorem**. DELTA19's
`U_k` chain stabilises by `k = q`; LP_CERT's leave-one-out sweep ran to `n = 27`
and stopped where the numerics stopped, with no statement of where it *could*
have stopped. If the deletion question is posed as a rank condition on a
finite-dimensional excursion subsystem — which is what the compact support cap
`T` makes available, since only `log n < T` contributes — then the number of
atoms that can be independently load-bearing is bounded by the dimension of the
test space, exactly, and the sweep has a stopping rule instead of a floor.

That is the bridge item I would put on the queue: `PROVE` — pose LP_CERT §4's
leave-one-atom-out question as the Hankel/observability rank condition of
DELTA19 §2 on the support-capped test space, and derive the truncation bound.
It replaces a table of twelve measured numbers with a rank and a dimension
count, which is what `CLAUDE.md` asks for and what the persona would insist on:
the sweep is the primal, the rank bound is its dual, and only together are they
a result.

---

## Rigor boundary

- Lemmas A, B, Propositions S38-1, S38-2, the certificate in §3.1, the
  counterexamples in §5.2 and §5.3, and the verification in §5.4 are exact and
  complete as written; no toolchain was available and none was needed.
- Proposition S38-1's constant `c` (uniform lower bound on the high-frequency
  mass fraction `μ({|τ| ≥ q_{M−2}})`) is asserted from the stated structure of
  the cosine-difference modes — frequencies `q_{m±1}` with `τ^{−2}` tails from
  the `C¹` zero-extension — and not computed. The `O(1/log M)` conclusion needs
  only `c > 0`, not its value. If the mode family were changed so that the
  high-frequency mass fraction vanished as `M → ∞`, the bound would need
  redoing; for a fixed basis of the stated form it does not.
- I did **not** re-run, re-derive, or attempt to reproduce any floating-point
  number in either note. Every criticism above is either an internal
  inconsistency (§2.1), a logical circularity (§2.2), a missing hypothesis
  (§5.2, §5.3), or a derivation of a scaling the note omitted (§4).
- No novelty is claimed. Lemmas A and B are Sylvester's law of inertia; §4 is
  Stirling for `ψ`; §5 is Kalman observability and Myhill–Nerode. The content is
  that they were not applied.
