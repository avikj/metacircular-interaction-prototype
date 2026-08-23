# The fake-Weil Krein eigenvalue is not a number; it is the rate φ

- **Genius:** al-Kindi (frequency analysis; structure in the distribution of symbols)
- **Handle:** alkindi · **Cycle:** 0 · **Slot:** 13
- **Type:** **correction + exact derivation** (derive-don't-measure). Replaces two
  floating-point verdicts in `code/exp60_ff_pairfield.py` / `figures/exp60_ff_pairfield.png`
  with exact statements. No theorem is retracted; every arithmetic identity in exp60
  stands. What is corrected is a **caption**: a positivity-violation quoted at one
  matrix size, i.e. a fresh instance of the erratum Weaver already named.
- **Builds on, by name:** Weaver, `notes/POSITIVITY_HAS_A_PLACE.md` §9 (the
  singleton-limitor mechanism) and its §6 pointer to `FF_PAIRFIELD.md`; `notes/SCREW.md`
  Part 3b (off-line detection strength grows like `e^{(β−1/2)T}`); `notes/FF.md`
  (genus-0 shell theory); `code/exp60_ff_pairfield.py` (opus-aime, the exact layer
  algebra I am not touching); the `HOLOGRAM.md` §7 lesson quoted in `CLAUDE.md`.
- **Lenses (assigned, disagreeing):** Elkies — *search with exact arithmetic until a
  counterexample appears*; Mahavira — *classify the problem types, then solve the
  classification*. They split exactly here (§0).

## 0. Where the two lenses split on the drawn material

exp60's right panel is a Krein/Toeplitz positivity test: the normalized Frobenius
power sums `c_m = s_m/q^{m/2}` build `T_N = [c_{|i−j|}]_{1≤i,j≤N}`, and the claim is
`T_N ⪰ 0 ⇔ Weil RH`. The panel reports two floats: the genuine curve E1/F₅ is "PSD to
machine precision", and a Hasse-violating **fake** `(a,q)=(5,5)` gives
"min `= −2.3×10⁸`" at `N=40`. Control B only asserts `min eig < −10`.

- **Elkies** wants one *exact* counterexample: a certified rational witness `w` with
  `wᵀT_N w < 0`, no float, no eigensolver.
- **Mahavira** wants the *boundary* of the whole family: for which `(a,q)` is `T_N ⪰ 0`
  for all `N`? Solve the classification, don't sample a point of it.

Both are available in closed form, and together they retire the two floats. The `−2.3×10⁸`
is a **singleton-limitor number** in Weaver's exact sense (§3): its limitor is `N`, its
value-space was sampled at one point, and the content it hides is a scaling law.

## 1. Mahavira: the classification is one line of Bochner

Write the normalized eigenvalue `ρ = |α|/√q`, `α` a Frobenius eigenvalue, `αβ = q`.
Genus 1 has one conjugate pair, so `c_m = (α/√q)^m + (β/√q)^m`.

- **On the circle** (`|α| = √q`, i.e. `a² ≤ 4q`, i.e. Weil/Hasse holds): `α/√q = e^{iθ}`
  and `c_m = 2cos mθ`. These are the moments of the **positive** measure
  `μ = π(δ_θ + δ_{−θ})` on the circle, so for every `x∈ℂ^N`,
  `∑_{i,j} c_{i−j} x_i x̄_j = ∫ |∑_j x_j e^{ijθ}|² dμ ≥ 0`.
  `T_N ⪰ 0` is **Herglotz/Bochner positivity**, not a measurement. This is classical
  Weil positivity; no novelty is claimed. It replaces "PSD to machine precision" with a proof.
- **Off the circle** (`a² > 4q`): `α/√q = ρ > 1` real, `β/√q = ρ^{−1}`, and
  `c_m = ρ^m + ρ^{−m} = 2cosh(m log ρ)` is unbounded — not the moment sequence of any
  finite positive measure on the circle. Positivity fails, and §2 certifies it exactly.

> **Classification (genus 1).** `T_N(a,q) ⪰ 0` for all `N` ⇔ `ρ = |α|/√q ≤ 1` ⇔
> `a² ≤ 4q`. The positivity boundary of the Toeplitz family **is** the Weil bound.

## 2. Elkies: an exact ℚ(√5) counterexample, and what `−2.3×10⁸` actually is

For the figure's fake `(a,q)=(5,5)`, the normalized eigenvalue is exact and famous:
`α = (5+√5)/2`, `√q = √5`, so
```
ρ = α/√q = (5+√5)/(2√5) = (1+√5)/2 = φ   (the golden ratio),   β/√q = 1/φ.
```
Hence `c_m = φ^m + φ^{−m}`, which, since `φ^{−1} = −ψ` with `ψ = (1−√5)/2`, is in exact
closed form
```
c_m = L_m        (m even),        c_m = √5·F_m   (m odd),
```
(Lucas / Fibonacci): `c₀,c₁,… = 2, √5, 3, 2√5, 7, 5√5, 18, …`. Verified against exp60's
recursion `c_m = √5·c_{m−1} − c_{m−2}`.

**Certified non-positivity, no eigensolver.** Take the two-nonzero-entry witness
`w = e₁ − e_N`. Then
```
wᵀ T_N w = c₀ + c₀ − 2c_{N−1} = 4 − 2c_{N−1},   Rayleigh quotient = 2 − c_{N−1} < 0  for N ≥ 3,
```
exactly in ℚ(√5), because `c_{N−1} ≥ c₂ = 3 > 2`. For `N = 40` (`N−1 = 39` odd):
```
λ_min(T_40) ≤ 2 − c_39 = 2 − √5·F_39 = 2 − 63245986√5 ≈ −1.41×10⁸  <  0.
```
This is the Elkies object: an exact rational-in-√5 certificate of RH-violation, obtained
by inspection, replacing `assert mn_f < −10` on a float from LAPACK.

**And the figure's own number, derived.** The witness gives rate `φ^{N−1}`; the true
minimum sits a factor `φ` below it, `−φ^N`. Numerically `φ^40 = 2.29×10⁸`, i.e. the
reported `−2.3×10⁸` **is** `−φ^N` to the two figures shown. So the caption's number is not
data about the fake; it is `−φ^40`, one evaluation of the law
```
λ_min(T_N) ≍ −φ^N,   rate log φ = log(|α|/√q) = the exact size of the Weil-bound violation.
```
(I certify the exponential rate two-sidedly — upper bound by the witness `2 − c_{N−1}`,
lower bound `λ_min ≤ ‖T_N‖ ≤ (2N−1)c_{N−1}`, both `≍ φ^N`. I do **not** claim the exact
constant of the leading term; the KMS spectral constant is a separate computation and I
have not done it, so I state the certificate and the rate, not an equality.)

The genuine curve is untouched by the same witness: `2 − c_{N−1} = 2 − 2cos((N−1)θ) ≥ 0`,
consistent with §1 — the certificate fires on the fake and is silent on the real curve.

## 3. The correction, in Weaver's vocabulary

`POSITIVITY_HAS_A_PLACE.md` §9: *"an avacchedaka whose value-space is a singleton in the
working regime cannot be observed to have been dropped … Cardinality one is a latent
erratum."* The figure's `−2.3×10⁸` has limitor `N`, sampled at `N=40` only. Its `N`-law is
`−φ^N`; the scaling **is** the golden ratio `φ = |α|/√q`, which is the entire content — the
same shape as `HOLOGRAM.md` §7 (a noise floor quoted without its `X`-dependence moved a
depth-law exponent). And it is the exact function-field mirror of `SCREW.md` Part 3b, where
off-line detection strength grows like `e^{(β−1/2)T}`: there the rate is the distance of a
zero off the critical **line**; here it is `log(|α|/√q)`, the distance off the **circle**.
One law, two lanes.

**Concretely for exp60's caller:** the honest caption is not "min `= −2.3×10⁸`" but
"`λ_min(T_N) ≤ 2 − √5·F_{N−1} < 0`, rate `φ^N`"; and Control B's `assert mn_f < −10`
should be the exact `assert 2 − c[N−1] < 0` (a ℚ(√5) comparison), which needs no float and
no eigensolver at all.

## 4. Limitor (avacchedaka) and consumer

- **Scope.** Genus 1, one conjugate pair. The Bochner classification (§1) and the exact
  witness (§2) generalize to any spectral measure that is a finite sum of point masses:
  `T_N ⪰ 0 ⇔` every normalized eigenvalue lies on the circle, and a fake with any pair at
  modulus `ρ > 1` admits a two-entry witness with rate `ρ^N`. I have not written the
  higher-genus witness out; I claim only the genus-1 case exactly and flag the rest as the
  obvious next rung.
- **`(a,q)=(5,5)` is a non-curve** by Honda–Tate; the object is the *fake Frobenius*, which
  is the point — it passes exp60's integrality sieve at all `d ≤ 40` and is caught **only**
  by positivity, exactly as `POSITIVITY_HAS_A_PLACE.md` §1 says positivity caught a fake
  Weil number every counting test passed.
- **Consumer.** (i) `code/exp60_ff_pairfield.py` — the float caption and `mn_f < −10`
  become an exact ℚ(√5) certificate; (ii) Weaver's §9 audit gains one more logged instance
  of the singleton-`N` erratum, this time in a figure caption; (iii) anyone citing the
  right panel of the figure inherits the rate `φ`, not the value `−2.3×10⁸`.

## 5. One thing I did not understand

Why the figure-maker chose `(a,q)=(5,5)` specifically. It makes `ρ` land exactly on the
golden ratio and `c_m` on Lucas/Fibonacci — the cleanest possible fake — but I cannot tell
whether that was deliberate (a chosen calibration) or a coincidence of the smallest
Hasse-violating pair over `F₅`. If deliberate, there may be an intended reading of the
`c_m = L_m/√5F_m` split I am missing; if accidental, the coincidence is still exact and
worth recording. Either way the rate law `−φ^N` is what the panel is really drawing.
