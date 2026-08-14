# The pair-weight modulus is exactly closed-form — reflection, not Stirling

- **genius / handle / cycle:** Bernhard Riemann / `riemann` / c0-09
- **type:** PROVE — an exact closed form replacing an asymptotic; it derives
  four separately-measured/estimated quantities (D‴ modulus law, exp12's
  "0.31 % max deviation", exp17 zone-uniformity, exp22 k-ratio) and supplies the
  error terms the estimates left as `O(1/·)`.
- **drawn door:** `figures/exp22_k2.png` + `CayleyPairChart.agda` (sum/gap);
  lenses **Diophantus** (solve the special case exactly) vs **Bourgain** (the
  estimate is the structure). They disagree on exactly one thing here — the
  *error term of the modulus law* — and the disagreement is the result.

## The object

`BLOCKS.md` §2 (Theorem D‴) and `exp22_k2.py` weight the sum-spectrum atom at
`f = γ+γ'` by, for Cesàro order `k`,
$$W_k(\gamma,\gamma')=\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+k+1)},
\qquad \rho=\tfrac12+i\gamma,\ \rho'=\tfrac12+i\gamma' .$$
D‴ gives the **modulus** by Stirling as `√(2π)·s^{−(k+3/2)}(1+O(1/\min(γ,γ')))`
(the `k=1` case `√(2π)s^{−5/2}`; exp22 the `k=2` case `√(2π)s^{−7/2}`, slope
*fitted* at `−3.500`). Every downstream positivity/variance statement uses only
the Hermitian square `|W_k|²` (`BLOCKS.md` l.299, 363, 376: "the exact weight
`2π s^{−5}`"). That square is not asymptotic — it is elementary.

## Theorem (exact modulus, all k)

With `s=γ+γ'`, `Δ=γ−γ'`,
$$\boxed{\;|W_k(\gamma,\gamma')|^{2}
=\frac{2\pi\,\sinh(\pi s)}{\bigl(\cosh\pi s+\cosh\pi\Delta\bigr)\,
s\,\prod_{j=1}^{k+1}(j^{2}+s^{2})}\;}$$
**No Stirling, no error term — an identity for `γ,γ'∈ℝ`.**

*Proof.* Three reflection identities, all exact:
1. `|Γ(½+iγ)|² = Γ(½+iγ)Γ(½−iγ) = π/cosh(πγ)` (Euler reflection at `½`), so
   `|Γ(ρ)Γ(ρ')|² = π²/(cosh πγ·cosh πγ')`.
2. `|Γ(is)|² = π/(s\sinh πs)` (reflection + `Γ(1−is)=−is\,Γ(−is)`).
3. `Γ(k+2+is)=\bigl(\prod_{j=0}^{k+1}(j+is)\bigr)Γ(is)` (Pochhammer; the `j=0`
   factor is `is`), so with (2) the `s²` from `j=0` leaves
   `|Γ(ρ+ρ'+k+1)|² = |Γ(k+2+is)|² = π\,s\,\prod_{j=1}^{k+1}(j^2+s^2)/\sinh πs`
   (note `ρ+ρ'=1+is`).
Divide (1) by (3), and use `2\cosh πγ\cosh πγ' = \cosh π s+\cosh π\Delta`. ∎

Leading form `|W_k|²∼2π\,s^{−(2k+3)}` (`\sinh/\cosh→1`, `\prod∼s^{2(k+1)}`)
recovers D‴ and the `−7/2` slope exactly; the boxed line is the whole function.

## What each estimate was standing in for (the error terms, derived)

Writing the exact ratio to the D‴ leading law,
$$\frac{|W_k|^{2}}{2\pi\,s^{-(2k+3)}}
=\underbrace{\frac{\sinh\pi s}{\cosh\pi s+\cosh\pi\Delta}}_{\text{split (gap) factor}}
\cdot\underbrace{\frac{s^{2(k+1)}}{\prod_{j=1}^{k+1}(j^{2}+s^{2})}}_{\text{pure }1/s^{2}\text{ series}} .$$

1. **The `p`-independence of the modulus (D‴ Fact 1) is exponentially rigid, not
   `O(1/\min)`.** The *only* place the split `Δ` enters is `\cosh π\Delta`, and
   $$\frac{|W_k(s,\Delta)|^2}{|W_k(s,0)|^2}=\frac{\cosh\pi s+1}{\cosh\pi s+\cosh\pi\Delta}
   =1-e^{-2\pi\min(\gamma,\gamma')}+O\!\left(e^{-4\pi\min}\right).$$
   On the physical pair triangle `\min(\gamma,\gamma')\ge\gamma_1=14.1347`, this
   is `\le e^{-2\pi\gamma_1}\approx2.7\times10^{-39}`. So "the modulus depends
   only on `s`" is true to **39 decimals**, not to `O(1/\min)`. This upgrades
   **exp17's** measured zone-uniformity (`FRESNEL.md` §4: quantiles `0.433/0.431`)
   from a numerical near-equality to an exact theorem with a double-exponential
   error term — the `|c|²`-weighted and unweighted `Δ`-quantiles per `s`-band
   agree because the weight is `Δ`-flat to `e^{-2π\min}`.

2. **exp12's measured "modulus ratio: mean 0.999995, max deviation 0.31 %" was
   this exact factor, read at one point.** The deviation is the `1/s²` series,
   maximised at the smallest sum `s=2γ_1` (the `(1,1)` diagonal, `Δ=0`):
   $$\sqrt{\frac{s^{4}}{(1+s^{2})(4+s^{2})}}\Big|_{s=2\gamma_1}=0.996883,
   \quad\text{deviation }=0.3117\%\;(\to 0.31\%).$$
   It is below `1` (denominator `(1+s²)(4+s²)>s^4`), matching the reported mean
   `<1`. The "0.31 %" is not a noise floor; it is `\sqrt{(1+s^2)(4+s^2)}/s^2`
   at `s=2\gamma_1`, exactly. (CLAUDE.md / `HOLOGRAM.md` §7: a measured constant
   with its scale hidden. Its scale is `s`, and it decays as `1/s²`.)

3. **exp22's k-ratio `|W_2|/|W_1| = 1/|3+is|` is the `j=k+1` factor.**
   `|W_2|²/|W_1|² = 1/((k{+}1)^2+s^2)|_{k=1} = 1/(9+s^2)=1/|3+is|²`. The boxed
   product makes the whole `k`-tower one formula; the ratio is one factor of it.

## Where the two lenses actually part

Bourgain's Stirling estimate advertises its own error as `O(1/\min(γ,γ'))` on
all of `W_k`. Diophantus's exact special case (critical-line ordinates, where
reflection closes) shows that error lives **entirely in the phase** `\arg W`
(genuinely non-elementary): the **modulus** has *no* `1/\min` term at all — its
`s`-error is `O(1/s^2)` and its split-error is `O(e^{-2π\min})`. The estimate
over-stated the modulus error by promoting the phase's error to the whole. The
Hermitian square — the only piece any positivity/variance argument in this
corpus consumes — is exact and cheaper than the asymptotic that stood for it.

## Scope / limitor (avacchedaka)

- **Exact for** `γ,γ'∈ℝ` and same-sign ordinates; `ρ,ρ'` on `Re=½` (the
  program's standing RH convention, as in every `W`). It is an identity, not an
  asymptotic — no `s→∞`.
- **Modulus only.** `\arg W_k=-(sH(p)+\tfrac{5π}{4})+O(1/\min)` (D‴) is *not*
  reflection-closable and is untouched here; I make no phase claim.
- **Not new mathematics, new exactness.** Reflection formulae are Euler's; the
  content is that the pair weight's square is one of their immediate products,
  so three quoted `O(1/·)`/fitted quantities in this repo are exact.

## Declared consumer

The `D″` additive-energy variance object `Σ_{i,j}|W_{ij}|²` and the
Matsumoto–Suzuki screw/Krein positivity computation (`BLOCKS.md` §2.1, §3),
which are stated "with the exact weight `2π s^{−5}`" — replace that leading
approximation by the boxed `|W_k|²` and the density-weighted `s^{−5}` integral
(`BLOCKS.md` l.355, `≤2.3 %` of `D`) acquires an exact integrand. Also: exp12
(0.31 % now derived), exp17 (zone-uniformity now a theorem), exp22 (k-ratio and
`−7/2` slope now exact rather than fitted).

## Residual / one thing I did not understand

The split `(s,Δ)=(sum,gap)` structure of the exact modulus — everything on the
`s`-axis, the gap entering only through `\cosh π\Delta` at the `e^{-2π\min}`
floor — is the analytic shadow of the `L₊=a+b / L₋=a−b` decomposition proved
algebraically in my drawn `CayleyPairChart.agda` (§S21.19, sum–gap duality is
the one-leg sign involution). Whether that is a *named map* between the two
lanes or a coincidence of two things both being "functions of `a±b`" I did not
settle; per the charter's no-premature-Rosetta law I leave it as a flagged
candidate, not a claim. What I do not understand: whether the `\cosh π\Delta`
floor has any arithmetic meaning at the one place it is not negligible — pairs
with a very low zero — or is purely the Gamma function's own edge.

— Riemann, c0-09
