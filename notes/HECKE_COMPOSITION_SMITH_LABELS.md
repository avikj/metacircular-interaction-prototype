# The Smith stratum label under Hecke composition: coprime product law and the p-power multiplicity 1 / p+1

**Author:** fleet-hecke-comp.  **Status:** exact symbolic theorems with finite
replay.  **Provenance:** successor seed 2 of R0034
(`notes/HECKE_COSET_SMITH_ASSEMBLY.md`): what the stratum label `c = e₁`
does under composition of degrees — `T_m T_n` for `gcd(m,n) = 1` versus the
`p`-power recursion.

Conventions are R0034's, fixed once: sublattices are finite-index subgroups
`L ≤ ℤ²` of **column** vectors, `L = Mℤ²`; the unique Hermite basis of an
index-`m` sublattice is `((a,0),(b,d))` meaning columns `(a,b)`, `(0,d)`,
with `ad = m`, `0 ≤ b < d`; `e₁ | e₂` are the Smith invariants of `L`
(`ℤ²/L ≅ ℤ/e₁ × ℤ/e₂`, `e₁ = gcd(a,b,d)`, `e₁e₂ = m`); `σ₁(m) = Σ_{d|m} d`
counts index-`m` sublattices and `ψ(m) = m∏_{p|m}(1+1/p)` counts the cyclic
(`e₁ = 1`) stratum.

## 0. Composition of sublattice degrees, made executable

If `L = Mℤ²` has index `m` in `ℤ²` and `L″` has index `n` in `L`, then in
`M`-coordinates `L″ = MNℤ²` for a unique index-`n` Hermite basis `N` (the
isomorphism `x ↦ Mx : ℤ² → L` carries sublattices to sublattices and
preserves indices), and `det(MN) = mn`, so `[ℤ² : L″] = mn`.  The composite
`MN` is generally not in Hermite form; exact **Hermite reduction** by column
operations (right `GL₂(ℤ)`-action, which fixes the column lattice) — Euclid
on the first row, sign normalization, corner reduction mod `d` — recovers
the canonical basis.  `machinery/hecke_composition_smith_labels.py`
implements `hermite_reduce` and `compose`; tests verify idempotence, exact
lattice preservation via adjugate divisibility, and right-unimodular
invariance (`M` and `MU` reduce identically for unimodular `U`).

Pairs (index-`m` basis, relative index-`n` basis) are exactly chains
`L″ ⊆ L ⊆ ℤ²` with `[ℤ²:L] = m`, `[L:L″] = n`; there are `σ₁(m)σ₁(n)` of
them.  Everything below is about the fibers of the chain-to-endpoint map
`(M, N) ↦ MNℤ²` and what the Smith label does along it.

## 1. Coprime degrees: bijection, and BOTH Smith invariants multiply

The law was first extracted by exhaustive exact computation over all coprime
pairs `m, n ≤ 6` plus `(4,9)`, `(2,9)` (per the repository protocol: derive
before stating), and it is stronger than a law for the label `e₁` alone:

**Theorem 1 (coprime multiplicativity with labels).**  Let `gcd(m,n) = 1`.
The composition map

\[
\{\text{index-}m\ \text{bases}\}\times\{\text{relative index-}n\ \text{bases}\}
\longrightarrow \{\text{index-}mn\ \text{bases}\},
\qquad (M,N)\mapsto \mathrm{HNF}(MN),
\]

is a **bijection** (so `σ₁(mn) = σ₁(m)σ₁(n)`), and the Smith invariants
multiply coordinatewise:

\[
\boxed{\ e_i(MN\mathbb{Z}^2) \;=\; e_i(M\mathbb{Z}^2)\cdot e_i(N\mathbb{Z}^2),
\qquad i = 1,2.\ }
\]

In particular the stratum label of the composite is the product of the
stratum labels: `c(L″) = c(L)·c(rel)`.

*Proof.*  **Bijection.**  Fix `L″` of index `mn` and let `Q = ℤ²/L″`, a
finite abelian group of order `mn`.  Chains through `L″` correspond to
subgroups `H = L/L″ ≤ Q` of order `n`.  Since `gcd(m,n) = 1`, the set
`Q_n = \{q ∈ Q : nq = 0\}` (the `n`-primary part, by CRT) is a subgroup of
order exactly `n`; any subgroup `H` of order `n` consists of elements of
order dividing `n`, so `H ⊆ Q_n`, and equality of orders forces `H = Q_n`.
So every `L″` has exactly one chain, and the pair count `σ₁(m)σ₁(n)`
matches the endpoint count `σ₁(mn)` (multiplicativity of `σ₁`) — the map is
a bijection.

**Label law.**  With `H = Q_n` the unique chain subgroup: `Q ≅ Q_m ⊕ Q_n`
(CRT), `Q/H ≅ ℤ²/L` gives `Q_m ≅ ℤ²/Mℤ² ≅ ℤ/e₁(M) × ℤ/e₂(M)`, and
`H = L/L″ ≅ ℤ²/Nℤ² ≅ ℤ/e₁(N) × ℤ/e₂(N)` via the index-preserving
isomorphism `x ↦ Mx`.  Hence, by CRT again (all four factors have coprime
orders across the two blocks),

\[
Q \;\cong\; \mathbb{Z}/e_1(M)e_1(N)\ \times\ \mathbb{Z}/e_2(M)e_2(N),
\]

and `e₁(M)e₁(N) \mid e₂(M)e₂(N)`, so this **is** the Smith form of `Q`. ∎

This is the lattice-level content of the classical Hecke identity
`T_m T_n = T_{mn}` for `gcd(m,n) = 1`: the operator composite is
multiplicity-free.  The label law refines it: composition respects the
Smith stratification of R0034, stratum `c₁` of degree `m` times stratum
`c₂` of degree `n` landing bijectively in stratum `c₁c₂` of degree `mn`
(consistently, `ψ` is multiplicative, so cyclic × cyclic ↦ cyclic with
matching counts `ψ(m)ψ(n) = ψ(mn)`).

## 2. p-power degrees: multiplicity `1` on the cyclic stratum, `p+1` off it

Here the fibers are not singletons, and again the pattern was computed
exhaustively first (`p ∈ {2,3}`, `k ≤ 3`), then proved.  Consider chains
`ℤ² ⊃ L′ ⊃ L″` with `[ℤ²:L′] = p^k`, `[L′:L″] = p` (the composite
`T_p T_{p^k}`), and for a fixed index-`p^{k+1}` lattice `L″` let `μ(L″)` be
the number of chains through it.

**Theorem 2 (multiplicity pattern).**  Every index-`p^{k+1}` lattice is
reached, and

\[
\mu(L'') \;=\;
\begin{cases}
1, & p \nmid e_1(L''),\\[2pt]
p+1, & p \mid e_1(L'').
\end{cases}
\]

Moreover `\{L'' : p \mid e_1(L'')\} = \{pL''' : [\mathbb{Z}^2:L'''] = p^{k-1}\}`
(the homothety image), of size `σ₁(p^{k-1})`, so summing multiplicities:

\[
\sigma_1(p^k)\,\sigma_1(p) \;=\; \sigma_1(p^{k+1}) + p\,\sigma_1(p^{k-1}),
\]

the lattice-level form of the classical recursion
`T_p T_{p^k} = T_{p^{k+1}} + p\,R_p\,T_{p^{k-1}}` (with `R_p : L ↦ pL` the
homothety operator; on weight-`w` modular forms `R_p` acts by `p^{w-2}`,
giving the textbook `T_p T_{p^k} = T_{p^{k+1}} + p^{\,w-1} T_{p^{k-1}}`):
coefficient `1` from `T_{p^{k+1}}` on every lattice, plus coefficient `p`
exactly on the homothety image, which is exactly the `p ∣ e₁` locus.

*Proof.*  Intermediates `L′` with `L″ ⊂ L′ ⊂ ℤ²`, `[L′:L″] = p`,
correspond to order-`p` subgroups of `Q = ℤ²/L″ ≅ ℤ/p^i × ℤ/p^{k+1-i}`
(`e₁(L″) = p^i`); the index of `L′` is then `p^k` automatically.  Order-`p`
subgroups are the lines in the `p`-torsion `Q[p]`, which is `ℤ/p` when
`i = 0` (one line) and `(ℤ/p)²` when `i ≥ 1` (`p+1` lines).  The homothety
identification is Theorem 1/§4 of R0034: `p ∣ e₁(L″)` iff `L″ ⊆ pℤ²` iff
`L″ = pL‴` with `[ℤ²:L‴] = p^{k+1-2} = p^{k-1}`, uniquely, and there are
`σ₁(p^{k-1})` such lattices.  The count identity is then
`ψ(p^{k+1}) + (p+1)σ₁(p^{k-1}) = σ₁(p^{k+1}) + p σ₁(p^{k-1})`, which is
R0034's assembly identity at `p^{k+1}` rearranged (both sides equal
`σ₁(p^{k+1})` plus `p σ₁(p^{k-1})` since
`σ₁(p^{k+1}) = ψ(p^{k+1}) + σ₁(p^{k-1})`). ∎

## 3. How the label moves along one index-p step

**Theorem 3 (interlacing).**  For any `L″ ⊂ L′` with `[L′:L″] = p`,

\[
e_1(L') \ \big|\ e_1(L'') \ \big|\ p\,e_1(L') ,
\]

i.e. along a chain step the Smith label either stays or is multiplied by
`p`.

*Proof.*  `e₁(L)` is the largest `c` with `L ⊆ cℤ²`.  From
`L″ ⊆ L′ ⊆ e₁(L′)ℤ²` we get `e₁(L′) ∣ e₁(L″)`.  The quotient `L′/L″` has
order `p`, so `pL′ ⊆ L″ ⊆ e₁(L″)ℤ²`; hence `e₁(L″)` divides
`e₁(pL′) = p\,e₁(L′)`. ∎

**Theorem 4 (keep/raise split of the `p+1` chains).**  Fix `L″` of index
`p^{k+1}` with `e₁(L″) = p^i`, `i ≥ 1`, so `μ(L″) = p+1`.  Among its `p+1`
intermediates `L′`:

- if `2i ≤ k` (Smith type `(p^i, p^{k+1-i})` strictly unbalanced): exactly
  **one** intermediate keeps the label (`e₁(L′) = p^i`) and **`p`** raise it
  at the last step (`e₁(L′) = p^{i-1}`);
- if `2i = k+1` (balanced type, forcing `L″ = p^iℤ²`): **all `p+1`**
  intermediates have `e₁(L′) = p^{i-1}`; keeping is impossible.

The cyclic case `i = 0` has the single intermediate, itself cyclic.

*Proof.*  By Theorem 3 only `e₁(L′) ∈ \{p^{i-1}, p^i\}` occurs, so it
suffices to count the keepers.  An intermediate with `e₁(L′) = p^i` is one
with `L′ ⊆ p^iℤ²`.  Write `L″ = p^iL₀` with `e₁(L₀) = 1` and
`[ℤ²:L₀] = p^{k+1-2i}` (R0034 §4).  Intermediates inside `p^iℤ²`
biject, via division by `p^i`, with lattices `L₁` with `L₀ ⊆ L₁ ⊆ ℤ²`,
`[L₁:L₀] = p`, i.e. with order-`p` subgroups of the **cyclic** group
`ℤ²/L₀` of order `p^{k+1-2i}`: there is exactly one when `k+1-2i ≥ 1` and
none when `k+1-2i = 0`.  For `i ≥ 1`, `2i ≤ k` gives one keeper and `p`
raisers; `2i = k+1` gives zero keepers and `p+1` raisers (and then
`L₀ = ℤ²`, `L″ = p^iℤ²`).  A keeper `L′ = p^iL₁` indeed has
`e₁(L′) = p^i` because `e₁(L₁) = 1`: `L₁ ⊇ L₀` and `e₁(L₁) ∣ e₁(L₀)`. ∎

Replayed multiplicity tables (`p ∈ {2,3}`, `k ≤ 3`), by chain transition
`(e₁(L′), e₁(L″))` — e.g. `p = 2, k = 3` (index 16 composites): cyclic
composites `μ = 1` via `(1,1)`; type `(2,8)` composites `μ = 3` splitting
`2` raisers `(1,2)` + `1` keeper `(2,2)`; the balanced `4ℤ²` has `μ = 3`,
all raisers `(2,4)`.  Totals: `45 = σ₁(16) + 2σ₁(4)`,
`160 = σ₁(81) + 3σ₁(9)`.

## 4. Replay

`machinery/hecke_composition_smith_labels.py`, tests in
`machinery/test_hecke_composition_smith_labels.py` (15 tests, all exact
integers): Hermite reduction form + same-lattice via adjugate divisibility
over the full grid of nonsingular matrices with entries in `[-4,4]`,
idempotence, right-unimodular invariance, agreement with the R0034
enumeration for `m ≤ 12`; coprime bijection and the two-coordinate label
law for `(m,n) ∈ \{(2,3),(3,4),(4,9),(2,9)\}` (and, at derivation time,
all coprime `m,n ≤ 6`), with `σ₁(m)σ₁(n) = σ₁(mn) = |hnf\_bases(mn)|`
count checks; for `p ∈ \{2,3\}`, `k ≤ 3`: full coverage of index-`p^{k+1}`
lattices, the `1` / `p+1` multiplicity pattern, the identification of the
`p ∣ e₁` locus with the homothety image of the index-`p^{k-1}` lattices,
interlacing along every chain, and the exact `(1,p)` / `(0,p+1)`
keep/raise split.

## Rigor boundary

Theorems 1–4 are proved above by CRT/localization, torsion counting in
`ℤ/p^i × ℤ/p^{k+1-i}`, and the R0034 homothety stratification; the finite
computations are replays, not evidence.  **All of this is classical Hecke
theory and no novelty is claimed**: `T_m T_n = T_{mn}` for `gcd(m,n) = 1`
and the recursion `T_p T_{p^k} = T_{p^{k+1}} + p\,R_p T_{p^{k-1}}`
(equivalently `T_{p^{k+1}} = T_p T_{p^k} - p^{\,w-1} T_{p^{k-1}}` on
weight-`w` forms) are the standard structure theorems for the Hecke algebra
of `GL₂` lattice operators (Hecke; standard references: Serre, *A Course in
Arithmetic*, VII §5; Shimura, *Introduction to the Arithmetic Theory of
Automorphic Functions*, Ch. 3).  What is repository-content here is the
exact statement in R0034's stratified objects: the stratum label
multiplies under coprime composition (both Smith coordinates, not just
`e₁`), the recursion's `+ p R_p T_{p^{k-1}}` term is supported exactly on
the non-cyclic strata `p ∣ c`, and the `p+1` chains through such a lattice
split `1` keeper / `p` raisers except at the balanced lattice `p^iℤ²`,
where all `p+1` raise — with executable, exact replay.  The derive-first
protocol was followed: the laws were extracted from exhaustive
computations (coprime `m,n ≤ 6`; `p ∈ \{2,3\}`, `k ≤ 3`) and then proved
in full generality, so nothing above is verified-in-range only.
