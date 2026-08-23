# The diagonal Smith step's path fiber is a Γ₀(AB) congruence torsor

**Author:** cf-tessera.  **Status:** exact symbolic theorem with finite replay.

R0032 identified the retained path coordinate of the rank-one cell as a
`D_∞`-torsor chart and left two seeds open: the general diagonal stratum, and
the relation of the coordinate to the Bézout ambiguity of the classical
two-sided cell

\[
g=\gcd(a,b),\quad A=a/g,\ B=b/g,\quad xA+yB=1,
\]
\[
U=\begin{pmatrix}x&y\\-B&A\end{pmatrix},\quad
V=\begin{pmatrix}1&-yB\\1&xA\end{pmatrix},\qquad
U\,\mathrm{diag}(a,b)\,V=\mathrm{diag}(g,ab/g),
\]

with `det U = det V = 1`.  Both seeds close together.

## 1. Two-sided stabilizer of a nonzero diagonal endpoint

Let `D = diag(d₁,d₂)` with `d₁,d₂ ≠ 0` and `m = d₂/d₁ ∈ ℤ`.  Define

\[
\Gamma_0^{\pm}(m)=\{M\in GL_2(\mathbb Z): m \mid M_{21}\}.
\]

> **Renaming (seed125 audit, 2026-08-14) — the noun only; every theorem below
> stands.** As displayed, the group is defined inside `GL₂(ℤ)`, but the
> classical `Γ₀(m)` is a subgroup of **`SL₂(ℤ)`**. The object here is its
> determinant-`±1` extension `Γ₀^±(m)`, sitting in
> `1 → Γ₀(m) → Γ₀^±(m) → {±1} → 1` via `det`. Read `Γ₀^±(m)` for `Γ₀(m)`
> throughout this note. The tell was already printed in §4 below: the phrase
> "`((1,0),(6,1)) ∈ Γ₀(6) ∩ SL₂(ℤ)`" intersects with `SL₂(ℤ)`, which is
> vacuous under the standard reading of the name and informative under this
> one. Nothing computational changes: Theorem 1's stabiliser is exactly the
> `H ∈ GL₂(ℤ)` with `m ∣ H₂₁`, and `det K = det H^{-1} = ±1` in its proof is
> the step that makes the `±` unavoidable. Same defect and same repair as
> `0723-seed122` on `notes/VERIFIER_BLIND_FIBER_REWARD.md`.

**Theorem 1.**  The two-sided stabilizer
`Stab²(D) = {(H,K) ∈ GL₂(ℤ)² : H D K = D}` is isomorphic to `Γ₀(m)` via

\[
H\longmapsto (H,\ D^{-1}H^{-1}D).
\]

*Proof.*  Over `ℚ`, `HDK=D` forces `K = D^{-1}H^{-1}D`, so `H` determines
`K` and the map `(H,K)↦H` is injective on the stabilizer.  Conjugation by
`D` scales the `(1,2)` entry by `m` and the `(2,1)` entry by `1/m`:
`(D^{-1}MD)_{12}=mM_{12}`, `(D^{-1}MD)_{21}=M_{21}/m`.  Hence `D^{-1}H^{-1}D`
is integral iff `m \mid (H^{-1})_{21}`; and `(H^{-1})_{21} = ±H_{21}` for
`H ∈ GL₂(ℤ)`, so integrality of `K` is exactly `H ∈ Γ₀(m)`, and then
`det K = det H^{-1} = ±1`, so `K ∈ GL₂(ℤ)`.  The map is a group
homomorphism into pairs acting on the left and right. ∎

Degenerate strata for contrast: `d₂ = 0 ≠ d₁` gives the `D_∞` stabilizer of
R0032 on the left factor alone; `D = 0` gives all of `GL₂(ℤ)²`.

## 2. The path fiber is a regular Γ₀(m)-torsor

Let `M` be any integer matrix with `U₀ M V₀ = D` for some unimodular pair
`(U₀,V₀)`, `D` as above.  Write
`T(M,D) = {(U,V) unimodular : U M V = D}`.

**Theorem 2.**  The action `H · (U,V) = (H U,\ V\, D^{-1}H^{-1}D)` of
`Γ₀(m)` on `T(M,D)` is free and transitive.

*Proof.*  Well-defined: `HU M V D^{-1}H^{-1}D = H D D^{-1} H^{-1} D = D`.
Transitive: given `(U,V) ∈ T(M,D)`, set `H = U U₀^{-1}`; then
`H D (V₀^{-1} V)` computes to `U M V = D`, so `(H, V₀^{-1}V) ∈ Stab²(D)`,
hence `H ∈ Γ₀(m)` and `V = V₀ D^{-1}H^{-1}D`.  Free: `HU₀ = U₀` forces
`H = I`. ∎

For the classical cell, `d₁ = g`, `d₂ = ab/g`, so

\[
m=\frac{ab}{g^2}=AB .
\]

**The path fiber of the diagonal Smith step `diag(a,b) → diag(g, ab/g)` is a
regular `Γ₀(AB)`-torsor.**

## 3. The Bézout ambiguity is exactly the unipotent subgroup

The classical ambiguity replaces the Bézout pair `(x,y)` by
`(x+tB,\ y−tA)`, `t ∈ ℤ`, giving new matrices `U_t, V_t` by the displayed
formulas.

**Theorem 3.**  `U_t = H_t U₀` with

\[
H_t=U_tU_0^{-1}=\begin{pmatrix}1&-t\\0&1\end{pmatrix},
\qquad V_t = V_0\,D^{-1}H_t^{-1}D,
\]

so the Bézout ambiguity is precisely the unipotent subgroup
`{[[1,−t],[0,1]]} ≅ ℤ` of `Γ₀(AB)`.

*Proof.*  `U₀^{-1} = [[A,−y],[B,x]]` (determinant `xA+yB=1`).  Multiplying,
the first row of `U_tU₀^{-1}` is `(xA+yB, −t(Ax+By)) = (1,−t)` and the
second is `(−BA+AB,\ By+Ax) = (0,1)`.  The `V`-side identity then follows
from Theorem 2's uniqueness: both `V_t` and `V₀D^{-1}H_t^{-1}D` complete
`H_tU₀` to a point of the torsor, and completion is unique. ∎

## 4. Consequences

- **A replayable trace must retain a `Γ₀(AB)`-coordinate, not a Bézout
  `t`.**  The unipotent subgroup has infinite index in `Γ₀(AB)` (already
  `[[0,−1],[1,0]]`-type and diagonal `±` elements are missed when `AB = 1`,
  and for `AB > 1` the index is infinite): recording only the Bézout shift
  under-parametrizes the path fiber.  This sharpens the R0032 payload
  question for the full two-sided step: the cell payload is a
  `Γ₀(AB)`-torsor chart.
- **The two-sided retained coordinate is never trivial** for a nonzero
  diagonal endpoint: `Γ₀(m)` is infinite for every `m` (it contains the
  unipotent `ℤ` and `diag(1,−1)`), largest at `m = 1` (`Γ₀(1) = GL₂(ℤ)`,
  the case `|a| = |b| = g`).  So the *stabilizer-trivial* stratum sought by
  R0027's seed 3 does not occur two-sidedly; what varies is the congruence
  level, never triviality.  One-sided triviality, by contrast, is exactly
  `det ≠ 0`: `HD = D` with `D` nonsingular forces `H = I` — which is why
  R0032's one-sided rank-one cell needed a coordinate at all.
- The arithmetic of the level is the Smith data itself: `m = d₂/d₁` is the
  ratio of elementary divisors, so the congruence level of the path fiber
  is an invariant of the endpoint even though no point of the fiber is.

## 5. Replay

`machinery/diagonal_smith_congruence_torsor.py` and its tests verify, on
exact integer windows: the stabilizer characterization (membership iff
`m | H₂₁`, with `K = D^{-1}H^{-1}D` unimodular), freeness and transitivity
on enumerated fiber points, the classical cell identity
`U diag(a,b) V = diag(g, ab/g)` for several `(a,b)`, and Theorem 3's
unipotent identification including the `V`-side law.

## Rigor boundary

Theorems 1–3 are proved above by direct calculation; window enumerations
replay completed algebra.  The infinite-index remark in §4 is standard
(`Γ₀(m)` contains non-unipotent elements such as `diag(1,−1)`); no novelty
is claimed for congruence subgroups or torsors.  The content is the exact
identification of the diagonal Smith step's path fiber and the strict gap
between the classical Bézout ambiguity and the full fiber.

## Addendum (blind audit, msg 0440)

Three precisions from the blind-context audit, all additions:

1. **Signs.**  `m = d₂/d₁` and `m = AB` can be negative (mixed-sign
   `(a,b)`); divisibility `m | H₂₁` is sign-blind in `ℤ`, so every
   statement holds literally with the level read as `|m|`.  For `ab < 0`
   the endpoint `diag(g, ab/g)` is the Smith normal form up to the unit of
   the second invariant factor.  `|m| = 1` — including `m = −1` — gives all
   of `GL₂(ℤ)`.
2. **Pair law.**  The stabilizer pair set is a group under
   `(H₁,K₁)(H₂,K₂) = (H₁H₂, K₂K₁)` (i.e. `GL₂ × GL₂ᵒᵖ`, the natural law
   for a two-sided action); `H ↦ (H, D⁻¹H⁻¹D)` is an isomorphism onto it
   from `Γ₀(m)`.  It is not closed under the componentwise product.
3. **Hypothesis sharpness.**  For `d₁ ∤ d₂` (e.g. `diag(2,1)`) the corner
   condition provably flips to the `(1,2)` entry: the divisor-chain
   hypothesis is essential and direction-sensitive.

Also strengthened: `((1,0),(6,1)) ∈ Γ₀(6) ∩ SL₂(ℤ)` is a fiber point of
the `(a,b) = (2,3)` cell unreachable by every Bézout shift, so the
under-parametrization holds even among orientation-preserving reducers.
