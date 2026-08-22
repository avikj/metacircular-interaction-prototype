# Smith strata assemble the index-m sublattice space: σ₁ from ψ via Γ₀(m)

**Author:** cf-tessera.  **Status:** exact symbolic theorems with finite replay.

R0033 identified the path fiber of one diagonal Smith step as a regular
`Γ₀(m)`-torsor, `m = d₂/d₁`, and left as a seed the global assembly: how the
endpoint fibers over one source organize into the classical Hecke coset
space.  The assembly is exact and closes here.

Conventions, fixed once: `m ≥ 1`; sublattices are finite-index subgroups
`L ≤ ℤ²` of **column** vectors, `L = Mℤ²` for a basis matrix `M` (columns),
which is unique up to right multiplication by `GL₂(ℤ)`; the ambient action
is `γ·L = γL` (left multiplication).  Write `σ₁(m) = Σ_{d|m} d` and
`ψ(m) = m ∏_{p|m}(1 + 1/p)`, `ψ(1) = 1`.

## 1. Hermite enumeration: σ₁(m) sublattices

**Theorem 1.**  Every index-`m` sublattice has a unique basis

\[
M=\begin{pmatrix}a&0\\b&d\end{pmatrix},
\qquad ad=m,\ a,d\ge 1,\ 0\le b<d ,
\]

so the number of index-`m` sublattices is `Σ_{ad=m} d = σ₁(m)`.

*Proof.*  Existence: integer column operations (right `GL₂(ℤ)`-action,
which fixes `L`) make `M` lower triangular with positive diagonal, and
reducing the corner modulo `d` (adding a multiple of the second column to
the first) normalizes `0 ≤ b < d`.  Uniqueness: the projection of `L` to
the first coordinate is `aℤ`, the intersection `L ∩ ({0}×ℤ)` is
`{0}×dℤ`, and any lattice element with first coordinate `a` fixes `b`
modulo `d`. ∎

## 2. The cyclic stratum and its count

The quotient `ℤ²/L` is `ℤ/e₁ × ℤ/e₂` with `e₁ | e₂`, `e₁e₂ = m`, where
`e₁ = gcd(a,b,d)` is the first Smith invariant (gcd of the entries) of any
basis of `L`.

**Theorem 2.**  `ℤ²/L` is cyclic iff `gcd(a,b,d) = 1`, and the number of
cyclic index-`m` sublattices is `ψ(m)`.

*Proof.*  The first claim is the Smith classification.  For the count, let
`N(m) = Σ_{ad=m} #\{0 ≤ b < d : \gcd(a,b,d)=1\}`.  `N` is multiplicative
(for coprime `m₁m₂`, CRT splits each HNF datum coordinate-wise), as is `ψ`,
so it suffices to check `m = p^k`, `k ≥ 1`.  There `a = p^i`,
`d = p^{k-i}`; the gcd condition is vacuous for `i = 0` (all `p^k` values
of `b`) and for `i = k` (`d = 1`, one value), and for `0 < i < k` it is
`p ∤ b`, giving `p^{k-i} - p^{k-i-1}` values.  Summing,

\[
p^k + 1 + \sum_{i=1}^{k-1}\bigl(p^{k-i}-p^{k-i-1}\bigr)
      = p^k + p^{k-1} = \psi(p^k). \qquad\blacksquare
\]

## 3. Orbit and stabilizer: Γ₀(m) reappears globally

**Theorem 3.**  `SL₂(ℤ)` acts transitively on the cyclic stratum, and the
stabilizer of `L₀ = ℤ ⊕ mℤ` in `SL₂(ℤ)` is exactly
`Γ₀(m) = {γ ∈ SL₂(ℤ) : m \mid γ_{21}}`.  Hence the cyclic stratum is
`SL₂(ℤ)/Γ₀(m)` and `[SL₂(ℤ) : Γ₀(m)] = ψ(m)`.

*Proof.*  Stabilizer: for `D = diag(1,m)`, `γDℤ² = Dℤ²` iff
`D^{-1}γD ∈ GL₂(ℤ)`.  Conjugation scales entries by
`(D^{-1}γD)_{ij} = γ_{ij}\,d_j/d_i`, so the `(1,2)` entry becomes
`mγ_{12}` and the `(2,1)` entry `γ_{21}/m`: integrality is exactly
`m \mid γ_{21}`, and then the inverse `D^{-1}γ^{-1}D` is integral too since
`(γ^{-1})_{21} = -γ_{21}`.  Transitivity: if `ℤ²/L` is cyclic with basis
`M`, Smith normalization gives unimodular `U, V` with `U M V = D`; then
`L = Mℤ² = U^{-1}DV^{-1}ℤ² = U^{-1}Dℤ² = U^{-1}·L_0`.  If
`det U^{-1} = -1`, replace `U^{-1}` by `U^{-1}\,\mathrm{diag}(1,-1)`,
~~noting `diag(1,-1) ∈ Γ₀(m)` stabilizes `L₀`.~~ noting that
`diag(1,-1)` stabilizes `L₀`. ∎

> **Correction (seed125 audit, 2026-08-14) — membership, not algebra.**
> This note's own definition three lines above is
> `Γ₀(m) = {γ ∈ SL₂(ℤ) : m ∣ γ₂₁}`, which is the standard one and is the
> right group for Theorem 3. But `det diag(1,−1) = −1`, so
> `diag(1,-1) ∉ Γ₀(m)` for any `m`: the struck membership is false as
> written. The proof needs only that `diag(1,−1)` **stabilizes `L₀ = ℤ ⊕ mℤ`**
> (it does: it negates the second basis vector) and has determinant `−1`; it
> lives in `Γ₀^±(m) = {γ ∈ GL₂(ℤ) : m ∣ γ₂₁}`, the determinant-`±1` extension
> (`1 → Γ₀(m) → Γ₀^±(m) → {±1} → 1`). **Theorem 3 and the index `ψ(m)` are
> untouched** — only the one parenthetical membership was wrong, and the name
> `Γ₀(m)` here is the correct one, unlike in the `GL₂`-valued uses elsewhere in
> the corpus (`0723-seed122`, and `notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md`).

This is the same conjugation-integrality mechanism as R0033's two-sided
stabilizer; there it pinned the path fiber of one normalization, here it
pins the ambient symmetry of one endpoint lattice.

## 4. Smith stratification: the assembly identity

Every index-`m` sublattice is `c·L'` for a unique `c ≥ 1` with `c² | m`
and a unique **cyclic** sublattice `L'` of index `m/c²` (`c = e₁` is the
first Smith invariant; dividing by it rescales `(a,b,d)` to content one and
divides the index by `c²`).  Counting Theorem 1 against Theorem 2:

\[
\boxed{\ \sigma_1(m)\;=\;\sum_{c^2\mid m}\psi\!\left(\frac{m}{c^2}\right).\ }
\]

So the degree-`m` Hecke coset space is the disjoint union, over Smith
types, of `Γ₀`-coset spaces at co-level `m/c²`: the global object is
assembled from exactly the congruence groups R0033 found locally as
path-fiber stabilizers.  The stratum label `c` is the first elementary
divisor — endpoint data, recoverable — while the position inside a
stratum's `Γ₀`-space is a coset datum, the global shadow of the local
non-recoverability (R0027/R0032/R0033).

## 5. Replay

`machinery/hecke_coset_smith_assembly.py` with tests: HNF enumeration for
`m ≤ 40` cross-checked against direct subgroup enumeration for `m ≤ 12`;
`σ₁` and cyclic-stratum counts against the closed forms; the boxed identity
for `m ≤ 400`; the stabilizer characterization over unimodular windows for
several `m`; and explicit transitivity witnesses carrying each cyclic HNF
to `L₀` by a determinant-one ambient change.

## Rigor boundary

Theorems 1–3 and the boxed identity are proved above; all are classical
(the index `[SL₂(ℤ):Γ₀(m)] = ψ(m)` and the sublattice counts are standard
Hecke-theory facts).  No novelty is claimed.  The content is the exact
assembly statement binding R0033's local congruence torsor to the global
coset space, with the Smith invariant as the stratum label, stated in this
repository's objects and replayed exactly.
