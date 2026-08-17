# Verification of `PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT.md`

**Author:** Claude, 2026-08-16.
**Object under audit:** `notes/PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT.md`
(landed cf-indra, 2026-08-16), which claims a **direct-application no-go**.
**Certificate:** `formal/cubical/KloostermanExponents.agda`
(`--cubical --safe`, exit 0, no postulates, no holes, no `TERMINATING`,
zero warnings under `--warning=error`).

---

## 0. Verdict

> **CONFIRMED-WITH-CORRECTION.**

Every exponent identity and every exponent inequality in the audit is **exactly
right**. I re-derived all of §3, §4, §5, §9 and the boxed displays
(0.2)–(0.9) by hand, independently, before reading the note's arithmetic a
second time, and then landed the whole thing as `refl`-checked terms. All five
substitutions (3.3)–(3.7), the exponent vector (0.4), the phase diagram (0.5),
the bottleneck ρ < 1/5 (0.6), the frontier (0.7), the endpoint vector (0.8),
and the §5 balanced comparison (5.1) survive verbatim. The unreplayable Python
report's eight checks are all replayed as kernel facts (§4 below).

Four corrections/additions, none of which weakens the no-go — three of them
**strengthen** it:

| # | Item | Kind |
|---|---|---|
| C1 | The no-go is **stronger** than stated: E₃ is the *maximum* of the five exponents on the whole admissible range, so the split is strictly worse than the unsplit balanced bound for **every** ρ > 0, not merely for ρ ≥ 1/5. | strengthening |
| C2 | At the endpoint ρ = 1/2 the loss is exactly D^{3/40} (E₃ dominates E₁ = 1/16). §0.8 lists both positives without ranking them. | sharpening |
| C3 | The quarter-scale endpoint ρ = 1/2 sits **on** the boundary of Wright's hypothesis, where `M ≪ N²` degenerates to `M ≍ N²`. The note writes `R ≪ D^{1/2}` in (3.2) but `R ≤ D^{1/2}` in (1.3), (0.7), (6.1), §7. Under a strict reading, (0.8) evaluates the bound at a point the hypothesis may not cover. | correction |
| C4 | (0.5)'s `min{1/3, 1/2, (1+φ)/5, (1+3φ)/2}` has two redundant entries: for φ ≥ 0 both `1/2` and `(1+3φ)/2` are ≥ 1/2 > 1/3, so the min is `min{1/3, (1+φ)/5}`. The crossover at which E₁ replaces E₃ as bottleneck is exactly **φ = 2/3**, which the note never records. | tidying + addition |

Two items are **śabda-grade** (inherited testimony, unverifiable here) and one
is a **derivation gap**; see §5 and §6.

---

## 1. Method

`WebFetch` is egress-blocked in this container. Neither Bettin–Chandee
(arXiv:1502.00769) nor Wright (arXiv:2604.25177v2) was read. **Everything below
is conditional on the note's display (2.2) being a correct quotation of
Wright's Theorem 2.1.** That conditionality is stated in the Agda header too,
and it is the single largest risk in the note.

Given (2.2), the audit's content is pure exact algebra on rational exponents.
So the verification is:

1. Re-derive each of (3.3)–(3.7) by hand from (2.2) and (3.1), without looking
   at the note's right-hand sides.
2. Re-derive the exponent forms (0.4) and each inequality `Eᵢ < 0`.
3. Encode the whole thing in Agda with **exact rationals as integer
   numerator/denominator pairs over ℕ**, denominators cleared, and certify by
   `refl` / explicit `ℕ`-order witnesses.
4. Replay every number the withheld Python script printed.

The encoding: every exponent occurring anywhere in the audit is a rational with
denominator dividing **40** (the bracket uses 8, 20, 4, 10 and the prefactor
uses 4). So a monomial `D^x R^y F^z` is the integer triple `(40x, 40y, 40z)`,
each integer stored as a pair `up ⊖ dn` of naturals. There is no division, no
subtraction on ℕ, no floating point. Every claim reduces to `_+_`, `_·_`, `_≡_`
and `_<_` on ℕ and is decided by the kernel.

**Non-vacuity was checked.** Two negative controls were run against the module:
`value 2 (evalAt 2 1 0 S₃) 1 0 40` (i.e. "E₃ = 1/40 at ρ = 1/2" instead of the
true 3/40) is rejected with `400 != 240`, and `isNeg (evalAt 2 1 0 S₁)` (i.e.
"E₁ < 0 at ρ = 1/2") is rejected with `16 != 10`. The predicates therefore have
content.

---

## 2. §3 re-derived by hand

Wright's bracket (2.2) has prefactor `R^{1/4}(1+|θ|F/(MN))^{1/4}` against the
trivial scale `‖α‖‖β‖‖ν‖(FMN)^{1/2}` — which is itself correct: Cauchy–Schwarz
in each variable gives `Σ_{m∼M}|α_m| ≤ M^{1/2}‖α‖`, and likewise for β, ν.
Under (3.1) `M = D`, `N = D/R` one has `MN = D²/R`, so
`|θ|F/(MN) = |θ|FR/D²`, and the prefactor is O(1) exactly under (4.2). **(4.2)
is correct.**

With that, term by term (my derivation, then the note's claim):

| Wright term | my reduction | ×R^{1/4} | note |
|---|---|---|---|
| `N^{-1/8}` | `D^{-1/8}R^{1/8}` | `D^{-1/8}R^{3/8}` | (3.3) ✓ |
| `R^{1/8}N^{1/8}M^{-1/4}` | `D^{1/8-1/4} = D^{-1/8}` | `D^{-1/8}R^{1/4}` | (3.4) ✓ |
| `M^{1/10}R^{-3/20}F^{-1/20}N^{-3/20}` | `D^{1/10-3/20}F^{-1/20} = D^{-1/20}F^{-1/20}` | `D^{-1/20}F^{-1/20}R^{1/4}` | (3.5) ✓ |
| `N^{3/20}F^{-3/20}M^{-1/5}` | `D^{3/20-1/5}R^{-3/20}F^{-3/20}` | `D^{-1/20}F^{-3/20}R^{1/10}` | (3.6) ✓ |
| `N^{3/8}M^{-1/2}` | `D^{-1/8}R^{-3/8}` | `D^{-1/8}R^{-1/8}` | (3.7) ✓ |

All five agree. Display **(0.3) is correct**.

The Agda version does not transcribe these. Each Wright term `Tᵢ` is *defined*
by a vector and *certified* against its defining expression with denominators
cleared — e.g. `T₁ = N^{-1/8}` is landed as the integer identity `8·T₁ = −N`
(`def-T₁`), which pins `T₁` uniquely since multiplication by a nonzero rational
is injective. Each claimed right-hand side `Cᵢ` is likewise certified against
*its* defining monomial (`def-C₁`…`def-C₅`). Only then is
`Sᵢ := R^{1/4}·Tᵢ ≡ᵐ Cᵢ` asserted (`audit-3-3`…`audit-3-7`). So the chain is
checked end to end, not copied.

**Structural hypothesis (3.2).** `M ≪ N²` ⟺ `D ≪ D²/R²` ⟺ `R ≪ D^{1/2}`.
Correct. In cleared form: with ρ = r/q, `exp(N²) − exp(M) = 1 − 2ρ`, numerator
`q − 2r`; the hypothesis is `2r < q` (`wright-hypothesis-iff`), and the gap is
derived from the monomials rather than asserted (`hypGapM`, `hypGap-bridge`).
**(0.2) is correct** — with correction **C3**, below.

---

## 3. §4 re-derived by hand

With `R = D^ρ`, `F = D^φ`, the D-exponents are read straight off the certified
vectors `Sᵢ` (the vector *is* the coefficient list, so (0.4) needs no separate
proof — it is what §2 above already certified):

```
S₁ = (−5, 15,  0)/40  ⇒  E₁ = −1/8  + 3ρ/8
S₂ = (−5, 10,  0)/40  ⇒  E₂ = −1/8  + ρ/4
S₃ = (−2, 10, −2)/40  ⇒  E₃ = −1/20 + ρ/4  − φ/20
S₄ = (−2,  4, −6)/40  ⇒  E₄ = −1/20 + ρ/10 − 3φ/20
S₅ = (−5, −5,  0)/40  ⇒  E₅ = −1/8  − ρ/8
```

which is **(0.4) verbatim**. The sign conditions:

- `E₁ < 0 ⟺ ρ < 1/3` ✓ (4.3)
- `E₂ < 0 ⟺ ρ < 1/2` ✓ (4.4)
- `E₃ < 0 ⟺ ρ < (1+φ)/5` ✓ (4.5)
- `E₄ < 0 ⟺ ρ < (1+3φ)/2` ✓ (4.6)
- `E₅ < 0` for all ρ ≥ 0 ✓ (indeed for all ρ > −1)

So **(0.5) is exact**, subject to correction **C4**: for φ ≥ 0 both `1/2` and
`(1+3φ)/2` are ≥ 1/2 > 1/3 and can never attain the minimum. The honest form is
`ρ < min{1/3, (1+φ)/5}`, and since `(1+φ)/5 ≤ 1/3 ⟺ φ ≤ 2/3`:

> **ρ\*(φ) = (1+φ)/5 for 0 ≤ φ ≤ 2/3, and 1/3 for φ ≥ 2/3.**

The crossover **φ = 2/3** — where E₁ and E₃ vanish simultaneously — is not in
the note. It is certified: `crossover-E₁`, `crossover-E₃`.

At φ = 0 the bottleneck is `ρ < 1/5`, i.e. `R < D^{1/5-ε} = X^{1/10-ε}`.
**(0.6) is correct.** At ρ = 1/5 exactly, E₃ = 0 (`fifth-E₃-is-zero`,
`threshold-sharp`).

At ρ = 1/2, φ = 0 the exponent vector is `(1/16, 0, 3/40, 0, −3/16)`.
**(0.8) is correct** (`endpoint-E₁`…`endpoint-E₅`, `endpoint-signs`): two
strictly positive, two exactly zero, one strictly negative, as the note says.

### C1 — the no-go is stronger than the note claims

The note treats E₃ as "the unique bottleneck" at φ = 0 but does not say where
E₃ sits relative to the others across the range. It sits **on top**, everywhere:

```
E₃ − E₁ = ( 3 − 5ρ)/40 ≥ 0   for ρ ≤ 3/5, hence on all of ρ ≤ 1/2
E₃ − E₂ =   3/40      > 0    always
E₃ − E₄ =  6ρ/40      ≥ 0    always
E₃ − E₅ = (3 + 15ρ)/40 > 0   always
```

so `max_i Eᵢ = E₃ = −1/20 + ρ/4` on the entire admissible range `0 ≤ ρ ≤ 1/2`
at φ = 0 (`E₃-is-max`, proved for all `q, r` with `2r ≤ q`). Three consequences:

1. **The saving is exactly `D^{1/20 − ρ/4}`**, and it is a saving iff ρ < 1/5.
   The frontier (0.7) is not merely "where one term stops helping"; it is where
   the *whole substituted bound* crosses trivial. (`direct-saving`,
   `frontier-no-go`, `threshold-sharp` give the full trichotomy.)
2. **C2:** at the endpoint the loss is exactly `D^{3/40}`, since
   3/40 > 1/16 = 2.5/40. The note's (0.8) prose ("two terms are worse than
   trivial") does not rank them.
3. **§5's audit rule (5.2) is failed on the whole range, not just above 1/5.**
   The unsplit balanced bound has exponent −1/20 (= E₃ at ρ = 0). Since
   E₃ = −1/20 + ρ/4 is the max, the split is *strictly worse than unsplit for
   every ρ > 0*. The note says only that termwise use "does not pass that test
   on the full quarter-scale range". Certified: `split-strictly-worse`.

This makes the no-go cleaner and harder, which is the right direction for a
no-go.

### C3 — the endpoint is on the hypothesis boundary

At ρ = 1/2 exactly, `M = D` and `N² = D²/R² = D`, so `M ≍ N²`, not `M ≪ N²`
(`endpoint-is-tight`: the cleared gap `q − 2r` is *zero*). Meanwhile (1.3)
supplies `min(p,b) ≤ √(B₀D)`, i.e. `R ≤ B₀^{1/2}D^{1/2}`, giving `M ≤ B₀N²`.

So:

- if Wright's `M ≪ N²` means `M = O(N²)` (the usual Vinogradov reading), the
  substitution is admissible on the closed range and the note is right as
  written — but the implied constant B₀ enters the final bound and the note
  never tracks it;
- if it means `M ≤ N²` on the nose, or `M = o(N²)`, then the exact endpoint
  R ≍ D^{1/2} is **outside** the theorem and display (0.8) evaluates the bound
  at an inadmissible point.

The note itself is inconsistent about this: (3.2) says `R ≪ D^{1/2}`, while
(1.3), (0.7), (6.1) and §7 all say `R ≤ D^{1/2}`. This does not touch the
no-go — the no-go only needs the *open* range ρ ∈ (1/5, 1/2), where the
hypothesis is strict — but (0.8) and the phrase "lands **exactly** inside the
theorem's structural hypothesis" (STATUS, §0.2) should be qualified. **Which
reading is correct cannot be settled from the note; see §5.**

---

## 4. §5 and the eight withheld Python checks, replayed

**§5 (5.1) is not an independent inheritance.** The note attributes
`D^{-1/20+ε} + D^{-1/8+ε}` to Bettin–Chandee. But it is also exactly what (2.2)
gives at `R = 1`, `M = N = D`, `F = D^0` (the hypothesis `M ≪ N²` holds there):
the bracket becomes `D^{-1/8} + D^{-1/8} + D^{-1/20} + D^{-1/20} + D^{-1/8}`
and `R^{1/4} = 1`. So (5.1) is a **corollary of the already-assumed (2.2)** and
carries no extra śabda burden. Certified as the ρ = 0 specialisation
(`balanced-E₁`…`balanced-E₅`), max −1/20, dominant term `D^{-1/20}` ✓.

Every check in
`data/egb_circulation_0002/PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT_REPORT_2026-08-16.json`
is now a kernel fact:

| JSON check | replayed by | result |
|---|---|---|
| `STRUCTURAL-COMPATIBILITY` | `hypGapM-value`, `hypGap-bridge`, `wright-hypothesis-iff`, `endpoint-is-tight`, `quarter-scale-admissible` | PASS |
| `EXPONENT-SUBSTITUTION` (ρ=7/31, φ=2/19) | `sample-E₁`…`sample-E₅` | PASS |
| `BOUNDED-FREQUENCY-THRESHOLD` | `threshold-sharp`, `E₃-neg`, `frontier-no-go` | PASS |
| `QUARTER-SCALE-ENDPOINT` | `endpoint-E₁`…`endpoint-E₅`, `endpoint-signs` | PASS |
| `THRESHOLD-SHARPNESS-FOR-DIRECT-BOUND` | `fifth-E₁`…`fifth-E₅` | PASS |
| `UNSPLIT-BALANCED-COMPARISON` | `balanced-E₁`…`balanced-E₅` | PASS |
| `FREQUENCY-PHASE-DIAGRAM` | `phase-φ0-E₁`, `phase-φ5-E₃`, `phase-φ5-E₁`, `phase-φ1-E₁`, `phase-φ1-E₃`, plus `crossover-E₁/E₃` | PASS |
| `X-SCALE-FRONTIER` | `X-lower`, `X-upper` | PASS |

The `EXPONENT-SUBSTITUTION` sample is the interesting one, because it is the
only place the script exercised a generic rational point. Over the common
denominator q = 589 = 19·31 (so r = 133, f = 62), the certified values are
exactly the script's `(−5/124, −17/248, 7/5890, −509/11780, −19/124)`. The
Python numbers were right.

**The audit's arithmetic is now replayable in-repo without Python.** That
closes the discipline-1 gap the landing note declared.

---

## 5. ŚABDA — what cannot be verified from the note alone

These are marked as inherited testimony. **Nothing in this file or in
`KloostermanExponents.agda` verifies them, and `WebFetch` is egress-blocked, so
no source paper was read.**

**S1. Display (2.2) as a quotation of Wright's Theorem 2.1.** Unverifiable
here. Everything in the audit and everything in the Agda module is conditional
on it. Specifically unchecked: the five bracket terms and their exponents; the
prefactor `R^{1/4}(1+|θ|F/(MN))^{1/4}`; whether `‖·‖` is the ℓ² norm (assumed —
the trivial-scale claim `‖α‖‖β‖‖ν‖(FMN)^{1/2}` only holds for ℓ²); the
`M^ε` versus `(FMN)^ε` loss; and the coprimality `(m, nR) = 1`.

**S2. The precise form of the hypothesis `M ≪ N²`, and "polynomial size control
on R".** This is what correction **C3** turns on. The note gives no quantitative
content to "polynomial size control on R" at all, so it is impossible to tell
from the note whether the range `R ≤ D^{1/2}` respects it. If that condition is
of the form `R ≤ D^{δ}` for some fixed small δ, the *entire* audit range could
be outside the theorem and the no-go would be vacuous rather than false. **This
is the highest-priority `SEARCH` item arising here.**

**S3. The Bettin–Chandee attribution of (5.1).** Downgraded in importance by §4
above: (5.1) follows from (2.2) at R = 1, so it needs no independent source.
The attribution may still be wrong; it no longer matters for the verdict.

**S4. arXiv:2604.25177v2.** The identifier is internally plausible (April 2026)
but was not resolved. Note that the corpus's own record of Wright's paper —
including the phrase "partially fixed moduli and unbalanced convolutions" — is
carried only by this note.

**S5. Absent dependencies.** Both notes listed under "Depends on" are **not in
`notes/`**: `PRIME_PAIR_SMOOTHED_BOUNDARY_HERMITIAN_DELTA_2026-08-11.md` and
`PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_THEOREMS_2026-08-16.md` (the nearest
present file is `PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_V2.md`, a different
document). The landing note already flags GTER Deltas 37/38 and the dynamic
sieve phase theorems as absent; the dependency list is worse than it says.

---

## 6. A derivation gap, distinct from the śabda items

Not testimony, not arithmetic: **the note does not derive its own display
(0.1).**

§1's block is `Σ_{(n,q)=1} v_D(n) e(−a n̄ / q)`. There the short factor produced
by (1.3) divides the **summation variable** n = pb; the modulus is q, whose
scale is never fixed. But (2.1)/(0.1) require the short factor R to divide the
**modulus** `nR`, with `M = D` the scale of the *inverted* variable and
`NR = D` the scale of the modulus. The note bridges these with one sentence —
"In either branch, a short internal factor can be exposed on the denominator
side of the Kloosterman fraction" (§1, after (1.4)) — which is doing an
unstated reciprocity flip (`ā/c ≡ −c̄/a + 1/(ac)`) and an unstated identification
of the modulus scale with D.

Consequences:

- The exponent audit is **conditional on (0.1)**, exactly as it is conditional
  on (2.2). If (0.1) is not the correct dictionary, the no-go is *vacuous*
  rather than *wrong* — it would be a no-go about a block that does not arise.
- The claim in §0 that (0.2) is "a genuine compatibility theorem" is therefore
  a compatibility theorem *between two displays inside this note*, not yet
  between the prime–Möbius decomposition and Wright's theorem.
- Recommended tag: `PROVE` — write out the reciprocity step and the modulus
  scale, one paragraph, and (0.1) becomes derived rather than asserted. Per
  CLAUDE.md this is well under the length of the experiment it replaces.

A smaller instance: (4.2) reads `|θ|FR ≪ D²` "i.e. φ + ρ < 2", which silently
assumes `|θ| = D^{o(1)}`. Harmless on the operative range (φ = 0, ρ ≤ 1/2 gives
1/2 < 2 with room), but it should be said.

---

## 7. What the no-go actually says, after verification

Restating §9 with the corrections folded in, at φ = 0, ρ = log R / log D:

```
                                    max_i E_i  =  E₃  =  −1/20 + ρ/4      (all 0 ≤ ρ ≤ 1/2)

  2r < q          (ρ < 1/2)     ⟺   Wright's hypothesis M ≪ N² is strict
  2r = q          (ρ = 1/2)     ⟹   M ≍ N²: hypothesis boundary            [C3]
  5r < q          (ρ < 1/5)     ⟺   all five exponents < 0; saving D^{1/20 − ρ/4}
  5r = q          (ρ = 1/5)     ⟺   E₃ = 0 exactly; ties trivial
  q < 5r      (1/5 < ρ ≤ 1/2)   ⟹   E₃ > 0: strictly worse than trivial
       r > 0          (ρ > 0)   ⟹   strictly worse than the UNSPLIT balanced bound   [C1]
```

In the prime-pair scale D = X^{1/2}: the frontier is
`X^{1/10} ≲ R ≲ X^{1/4}`, as the note says. The correct headline is slightly
harsher than the note's: the fixed-R substitution is **never** an improvement
over not splitting at all, and above X^{1/10} it is not even an improvement
over the trivial bound. §6's conclusion (6.2) — that a useful theorem must see
the moving factor as a *variable* — is therefore better supported by the
arithmetic than the note claims.

The §7 target and the §6 list of five discarded structures are unaffected and
were not audited (they are program statements, not claims).

---

## 8. Certificate inventory

`formal/cubical/KloostermanExponents.agda`, 588 lines, `--cubical --safe`.
Checked with the project's `natural-machine` library flags
(`--cubical --guardedness --safe --no-import-sorts`), as every module in
`formal/cubical/` is. Exit 0, and exit 0 again under `--warning=error`. No
`postulate`, no holes, no `TERMINATING`/`NON_TERMINATING`, no `trustMe`.
Nothing in it is `native_decide`-shaped: the whole module is kernel `refl` and
explicit `Σ`-witnesses for `_<_` on ℕ.

Structure:

- §1–3: signed integers as ℕ-pairs; sign transfer along `≐`/`≼`; cancellation
  of a positive scalar (the only nontrivial ℕ lemma, `·k-<-cancel`).
- §4–5: monomials over (D, R, F) with exponents cleared by 40; Wright's five
  bracket terms, each certified against its defining relation; the five
  relative factors; **`audit-3-3` … `audit-3-7` = displays (3.3)–(3.7)**.
- §6–7: evaluation at ρ = r/q, φ = f/q; **`wright-hypothesis-iff`,
  `endpoint-is-tight` = display (0.2) and correction C3**.
- §8: **`E₃-is-max`** (correction C1), **`direct-saving`** (display (0.6)),
  **`frontier-no-go`** (display (0.7)), **`threshold-sharp`** (§4's sharpness),
  **`split-strictly-worse`** (correction C1.3).
- §9–10: 31 numeric certificates replaying all eight JSON checks.

---

## FILES

- `notes/KLOOSTERMAN_AUDIT_VERIFICATION.md` — this file (new).
- `formal/cubical/KloostermanExponents.agda` — the certificate (new, checks
  clean).

Nothing else was touched. `notes/PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT.md`
was **not** edited; corrections C1–C4 are recorded here for its owner.

## STATUS

- Verdict: **CONFIRMED-WITH-CORRECTION**. The no-go holds, and holds more
  strongly than stated (C1, C2). The corrections are C3 (endpoint sits on the
  hypothesis boundary; the note is internally inconsistent between `≪` and `≤`)
  and C4 ((0.5) carries two redundant minima; the φ = 2/3 crossover is
  missing).
- The audit's arithmetic is now replayable in-repo as checked terms. The
  discipline-1 gap declared in the landing note ("unreplayable in-repo",
  "graded MEASURED, not proved") is closed **for the arithmetic**. It is
  *not* closed for S1/S2/S6 below, which were never Python's to certify.
- Suggested queue items: `SEARCH` Wright arXiv:2604.25177v2 Thm 2.1 (S1, S2 —
  the exact hypothesis wording decides C3 and could make the whole audit
  vacuous); `PROVE` the (0.1) dictionary from §1 (§6 above).

## RISKS

1. **S2 is load-bearing and unresolved.** "Polynomial size control on R" is
   given no content in the note. If Wright's theorem restricts R to `D^{δ}` for
   small fixed δ, the entire audited range `R ≤ D^{1/2}` lies outside it and
   the no-go is vacuous. Verifying the arithmetic does not touch this. Do not
   quote (0.2) as "the factorization lands exactly inside the hypothesis"
   without resolving it.
2. **Everything is conditional on (2.2).** A single wrong exponent in the
   quoted bracket changes the frontier. The Agda module certifies the
   consequences of (2.2), not (2.2).
3. **The (0.1) dictionary is asserted, not derived** (§6). Independent of the
   above, and independently able to make the no-go vacuous.
4. **`KloostermanExponents.agda` is an orphan.** It is not imported by
   `formal/cubical/Everything.agda` (nor by `NaturalMachine.agda`), so no
   aggregate build covers it — which is precisely the hole `BUILD.md` warns
   about. I did not edit `Everything.agda` because it is not my file in this
   shared checkout and is a high-conflict append target. **One-line follow-up
   for its owner:** add `import KloostermanExponents` to
   `formal/cubical/Everything.agda`. Until then the green above is a
   point-in-time check, re-runnable with
   `cd formal/cubical && agda --cubical --safe KloostermanExponents.agda`.
5. **No Python was run, and none is needed.** The two negative controls used to
   test non-vacuity were written in Agda and left in the scratchpad, not in the
   repo. `MATH_ALLOW_PYTHON` was not used.
6. The corrections C1–C4 are recorded here only. If the audit note is
   circulated onward before its owner folds them in, the C3 inconsistency
   (`≪` vs `≤` at the endpoint) will travel with it.
