# The assembly identity, bijectively: Φ(L) = (e₁(L), (1/e₁)L) in exact Hermite coordinates, and the second moment of the Smith label

**Author:** fleet-bijective-assembly.  **Status:** exact symbolic theorems
with finite replay.  **Provenance:** successor seed 2 of R0038
(`notes/HECKE_COMPOSITION_SMITH_LABELS.md`): a bijective (structural) proof
of R0034's assembly identity (`notes/HECKE_COSET_SMITH_ASSEMBLY.md`),
connecting the chain/coset side to the stratum side by an explicit,
coordinate-exact, `SL₂(ℤ)`-equivariant map.

Conventions are R0034's, fixed once: sublattices are finite-index subgroups
`L ≤ ℤ²` of **column** vectors, `L = Mℤ²`; the unique Hermite basis of an
index-`m` sublattice is `((a,0),(b,d))` meaning columns `(a,b)`, `(0,d)`,
with `ad = m`, `0 ≤ b < d`; `e₁ | e₂` are the Smith invariants
(`ℤ²/L ≅ ℤ/e₁ × ℤ/e₂`, `e₁ = gcd(a,b,d)`, `e₁e₂ = m`); the ambient action
is `γ·L = γL`; `σ₁(m) = Σ_{d|m} d`, `ψ(m) = m∏_{p|m}(1+1/p)`, `φ` is
Euler's totient.

R0034 proved `σ₁(m) = Σ_{c²|m} ψ(m/c²)` by counting both sides.  Here the
identity is exhibited as the cardinality of one explicit bijection, written
in closed form on Hermite coordinates, checked to be equivariant, and then
used to compute the *first moment of the stratum label* (the "second
moment" of the assembly, weighting each lattice by `e₁` instead of by `1`),
which turns out to be a multiplicative function that is **not** any
standard `σ`-variant.

## 1. The bijection Φ and its exact Hermite formula

For `m ≥ 1` set

\[
\Phi:\ \{L \le \mathbb{Z}^2 : [\mathbb{Z}^2:L]=m\}
\ \longrightarrow\
\bigsqcup_{c\,:\,c^2\mid m}\ \{L' \le \mathbb{Z}^2:\ [\mathbb{Z}^2:L']=m/c^2,
\ \mathbb{Z}^2/L'\ \text{cyclic}\},
\qquad
\Phi(L) = \bigl(e_1(L),\ \tfrac{1}{e_1(L)}L\bigr).
\]

**Lemma 1 (well-definedness).**  Let `c = e₁(L)`.  Then `c² | m`; since
`L ⊆ cℤ²`, the set `(1/c)L := {v/c : v ∈ L}` is a sublattice of `ℤ²`; it
has index `m/c²`; and `ℤ²/(1/c)L` is cyclic.

*Proof.*  `e₁ | e₂` and `e₁e₂ = m` give `m = c²·(e₂/e₁)`, so `c² | m`.
`e₁(L)` is the content `gcd(a,b,d)` of any basis, i.e. the largest `c` with
`L ⊆ cℤ²`; hence every vector of `L` is divisible by `c` and `(1/c)L ⊆ ℤ²`
is a subgroup with basis matrix `(1/c)M`, of index
`det((1/c)M) = m/c²`.  Its content is `gcd(a/c, b/c, d/c) = gcd(a,b,d)/c
= 1` (gcd is homogeneous), so `e₁((1/c)L) = 1`: cyclic quotient (R0034
Thm 2). ∎

**Theorem 1 (Hermite coordinate formula, both directions).**
Let `L` have Hermite basis `((a,0),(b,d))` and `c = gcd(a,b,d)`.  Then

\[
\Phi(L) = \Bigl(c,\ \bigl((a/c,\,0),\,(b/c,\ d/c)\bigr)\Bigr),
\]

and the right-hand matrix **is already the Hermite basis** of `(1/c)L` —
the naive formula `((a/c,0),((b/c) \bmod (d/c),\ d/c))` is correct but its
mod-reduction is provably the identity (Lemma 2).  Conversely, for
`c² | m` and a cyclic `L'` of index `m/c²` with Hermite basis
`((a',0),(b',d'))`,

\[
\Phi^{-1}(c, L') = cL' \quad\text{has Hermite basis}\quad
\bigl((ca',0),\,(cb',\,cd')\bigr),
\]

again with no re-reduction needed.  `Φ` and `(c,L') ↦ cL'` are mutually
inverse, so `Φ` is a bijection; moreover it restricts, for each `c`, to a
bijection from the stratum `{L : e₁(L) = c}` **onto** the cyclic
index-`m/c²` space.

*Proof.*  The basis matrix of `(1/c)L` is `(1/c)M`, which is lower
triangular with positive diagonal `a/c, d/c` and corner `b/c`; by Lemma 2
below `0 ≤ b/c < d/c`, so `(1/c)M` satisfies all three Hermite
normalizations, and by uniqueness of the Hermite basis (R0034 Thm 1) it
*is* the Hermite basis.  The same argument gives the converse formula:
`cM'` is lower triangular, positive diagonal, and `0 ≤ cb' < cd'` follows
from `0 ≤ b' < d'` by multiplying by `c > 0`.  Mutual inversion is now
coordinatewise: dividing then multiplying by `c` (or vice versa) is the
identity on `(a,b,d)`, and the labels match because Smith invariants are
homogeneous — `e₁(cL') = c·e₁(L') = c·1 = c` (the content of `cM'` is `c`
times the content of `M'`).  For the restriction: `Φ` sends `{e₁ = c}`
into the `c`-component by construction, and `Φ^{-1}(c,·)` sends the whole
`c`-component into `{e₁ = c}`, so the restriction is onto. ∎

**Lemma 2 (the mod-reduction subtlety).**  If `c | b`, `c | d` and
`0 ≤ b < d`, then `b ≤ d − c`, hence

\[
0 \ \le\ \frac{b}{c}\ \le\ \frac{d}{c} - 1\ <\ \frac{d}{c},
\qquad\text{i.e.}\qquad
\frac{b}{c} \bmod \frac{d}{c} \;=\; \frac{b}{c}\ \ \text{always}.
\]

*Proof.*  `b` and `d` are distinct multiples of `c` (`b < d`), and two
distinct multiples of `c` differ by at least `c`; so `b ≤ d − c` and
`b/c ≤ d/c − 1`.  Nonnegativity is inherited from `b ≥ 0`. ∎

So the answer to "is `b/c` already reduced?" is: **yes, in every case** —
not merely observed but forced, because the *same* `c` divides both `b`
and `d` (it is the content).  The reduction would only be at risk for a
scaling by some `c'` not dividing all of `a, b, d`, and such a scaling
does not even produce an integer matrix.  Replay: an exhaustive scan of
all index-`m` Hermite bases, `m ≤ 200`, finds `0` unreduced corners, and
`phi` asserts Lemma 2 on every call.

## 2. Counting corollary and the second moment of the label

**Corollary 1 (R0034's assembly identity, bijectively).**  Taking
cardinalities in Theorem 1, fiber by fiber:

\[
\sigma_1(m) \;=\; \sum_{c^2\mid m}\psi\!\left(\frac{m}{c^2}\right),
\qquad
\#\{L : e_1(L) = c\} = \psi(m/c^2)\ \ \text{for each}\ c^2 \mid m .
\]

The identity is no longer a coincidence of two counts: each label-`c`
stratum *is* the cyclic space at co-level `m/c²`, transported by the
homothety `c`.

**Corollary 1′ (divisibility strata).**  For any `c` with `c² | m`,
`{L : c \mid e_1(L)} = c·\{`all index-`m/c²` sublattices`\}`, of size
`σ₁(m/c²)` — the same scaling bijection without the cyclicity
restriction (`c | e₁(L)` iff `L ⊆ cℤ²` iff `L = cL‴` uniquely).

**The second moment.**  Following the repository protocol the quantity

\[
S(m) \;:=\; \sum_{[\mathbb{Z}^2:L]=m} e_1(L)
\]

was first computed exhaustively and exactly for all `m ≤ 60`
(`S = 1, 3, 4, 8, 6, 12, 8, 18, 15, 18, 12, 32, …`), matched against the
candidate forms below (all four agree on the range), and *then* proved:

**Theorem 2 (second moment).**  For all `m ≥ 1`:

1. (transport along `Φ`)
   \[
   S(m) \;=\; \sum_{c^2\mid m} c\,\psi\!\left(\frac{m}{c^2}\right).
   \]
2. (layer-cake form)
   \[
   S(m) \;=\; \sum_{c^2\mid m} \varphi(c)\,\sigma_1\!\left(\frac{m}{c^2}\right).
   \]
3. `S` is multiplicative, with prime-power closed form
   \[
   \boxed{\
   S(p^k) \;=\; \frac{p^{k+1} + p^{k} - p^{\lceil k/2\rceil} - p^{\lfloor k/2\rfloor}}{p-1}
   \ }
   \]
   and Dirichlet series
   \[
   \sum_{m\ge 1}\frac{S(m)}{m^{s}}
   \;=\; \frac{\zeta(s)\,\zeta(s-1)\,\zeta(2s-1)}{\zeta(2s)} .
   \]
4. `S` is **not** a standard `σ`-variant: `S(p) = p+1 = σ₁(p) = ψ(p)` but
   `S(p²) = p² + 2p`, whereas `σ₁(p²) = p²+p+1`, `ψ(p²) = p²+p`,
   `σ₂(p²) = p⁴+p²+1` (first divergence from each of `σ₁, ψ` at `m = 4`,
   from `σ₂` at `m = 2`).  In odd exponents it factors:
   `S(p^{2t+1}) = ψ(p^{t+1})\,σ₁(p^{t})`.

*Proof.*  **(1)**  `e₁` is constant equal to `c` on the stratum
`{e₁ = c}`, and by Theorem 1 that stratum has exactly `ψ(m/c²)` elements;
sum over the strata `c² | m`.

**(2)**  Write `e₁ = Σ_{c | e₁} φ(c)` (Gauss: `Σ_{c|n} φ(c) = n`) and swap
the sums:
`S(m) = Σ_L Σ_{c | e₁(L)} φ(c) = Σ_c φ(c)·\#\{L : c \mid e_1(L)\}`.
By Corollary 1′ the inner count is `σ₁(m/c²)` when `c² | m` and `0`
otherwise (if `c² ∤ m` no index-`m` lattice fits inside `cℤ²`).

**(3)**  Form (1) is the Dirichlet convolution `S = q * ψ` with
`q(n) = √n` if `n` is a square and `0` otherwise; `q` and `ψ` are
multiplicative, hence so is `S`.  Dirichlet series:
`Σ q(n)n^{-s} = Σ_c c^{1-2s} = ζ(2s-1)` and
`Σ ψ(n)n^{-s} = ζ(s)ζ(s-1)/ζ(2s)` (classical, from `ψ = μ² * \mathrm{Id}`);
multiply.  Prime powers, by geometric summation of
`S(p^k) = Σ_{0 ≤ i ≤ k/2}\, p^{\,i}\,ψ(p^{\,k-2i})` with
`ψ(p^j) = p^j + p^{j-1}` (`j ≥ 1`), `ψ(1) = 1`:

- `k = 2t`:  the terms `i < t` contribute `p^{k-i} + p^{k-i-1}` and the
  term `i = t` contributes `p^t`, so
  `S = p^{2t} + 2(p^{2t-1} + \cdots + p^{t}) =
  (p^{2t+1} + p^{2t} - 2p^{t})/(p-1)`;
- `k = 2t+1`:  every term has `k - 2i ≥ 1`, so
  `S = p^{2t+1} + 2(p^{2t} + \cdots + p^{t+1}) + p^{t} =
  (p^{2t+2} + p^{2t+1} - p^{t+1} - p^{t})/(p-1)`.

Both cases are the boxed formula with `⌈k/2⌉, ⌊k/2⌋ ∈ {t, t+1}` as
appropriate (and `k = 0` gives `1`).  Equivalently, in the Euler product:
the local factor of `S` at `p` is `(1+x)/\bigl((1-px)(1-px^2)\bigr)`,
`x = p^{-s}`, which is exactly the local factor of
`ζ(s)ζ(s-1)ζ(2s-1)/ζ(2s)`.

**(4)**  Read off the closed form:
`S(p²) = (p³ + p² − 2p)/(p−1) = p² + 2p`, and for odd exponent
`S(p^{2t+1}) = (p^{t+1}+p^{t})(p^{t+1}-1)/(p-1) = ψ(p^{t+1})σ₁(p^{t})`.
The stated inequalities with `σ₁, ψ, σ₂` at `p²` (resp. `p`) are
immediate. ∎

The bijection is what makes (1) one line: `Φ` transports the weight `e₁`
to the *constant* `c` on each component, so the second moment of the
label is the `c`-weighted count of the strata.  Form (2) is the same
mechanism applied to the divisibility filtration instead of the exact
strata.  (The function `S` is classical in the sense that its Dirichlet
series is a ratio of zeta factors; we claim no novelty for it, only the
lattice interpretation as `Σ_L e₁(L)` inside this corpus.)

## 3. Equivariance: why each stratum is one orbit

**Theorem 3 (SL₂(ℤ)-equivariance).**  For `γ ∈ SL₂(ℤ)` and `L` of index
`m`:

1. `e₁(γL) = e₁(L)` — the stratum label is invariant;
2. `(1/c)(γL) = γ\bigl((1/c)L\bigr)` for `c = e₁(L)` — homothety commutes
   with the ambient action.

Hence `Φ(γ·L) = (c,\ γ·((1/c)L))`: `Φ` intertwines the `SL₂(ℤ)`-action on
the index-`m` space with the componentwise action on the disjoint union.

*Proof.*  (1)  A basis matrix of `γL` is `γM`; left multiplication by a
unimodular matrix is a Smith equivalence, so `γM` and `M` have the same
Smith invariants, in particular the same `e₁`.  (Concretely with
`c = e₁(L)`: `L ⊆ cℤ²` iff `γL ⊆ γ(cℤ²) = c\,γℤ² = cℤ²`, and this
characterizes divisibility of the label both ways since `γ^{-1}` is also
integral; the largest such `c` is therefore the same.)
(2)  As sets: `v ∈ (1/c)(γL)` iff `cv ∈ γL` iff `c\,γ^{-1}v ∈ L`
(`γ^{-1}(cv) = c\,γ^{-1}v`) iff `γ^{-1}v ∈ (1/c)L` iff
`v ∈ γ((1/c)L)`. ∎

**Corollary 2 (orbit decomposition, bijectively).**  `Φ` descends to a
bijection of `SL₂(ℤ)`-orbit sets.  Since the cyclic index-`n` space is a
single orbit `≅ SL₂(ℤ)/Γ₀(n)` (R0034 Thm 3), each stratum
`{L : [\mathbb{Z}^2{:}L]=m,\ e_1(L)=c}` is a **single orbit**, the orbit
of the base point `c·(ℤ ⊕ (m/c²)ℤ)`, with stabilizer exactly
`Γ₀(m/c²)` (the stabilizer of `cL₀'` equals the stabilizer of `L₀'`,
because `γ(cL₀') = c(γL₀')`).  The orbit set of the index-`m` sublattice
space is therefore `{c ≥ 1 : c² | m}`, and the assembly identity of §2 is
the orbit-counting refinement

\[
\underbrace{\{ \text{index-}m\ \text{sublattices}\}}_{\#=\sigma_1(m)}
\;\;\cong\;\;
\bigsqcup_{c^2 \mid m}\ SL_2(\mathbb{Z})/\Gamma_0(m/c^2)
\]

as `SL₂(ℤ)`-sets, via `Φ` — the bijective explanation of why each stratum
is one orbit, promised by R0034 §4.  Explicit witnesses: for any `L` in
the label-`c` stratum, R0034's transitivity witness for the cyclic
lattice `(1/c)L` — a determinant-one `γ` with `γ·(ℤ⊕(m/c²)ℤ) = (1/c)L` —
also satisfies `γ·(c·(ℤ⊕(m/c²)ℤ)) = L`, by Theorem 3(2).

## 4. Replay

`machinery/bijective_smith_assembly.py` (imports R0034's enumeration and
R0038's `hermite_reduce`), tests in
`machinery/test_bijective_smith_assembly.py` (11 tests, all exact
integers, all green):

- **Hermite formula, `m ≤ 30`, every lattice:** `Φ` in coordinates equals
  `((a/c,0),((b/c) \bmod (d/c), d/c))` *and* the mod is the identity
  (plus the sharper `b ≤ d − c`); images are cyclic Hermite bases of
  index `m/c²`; exact round trip in both directions; fiberwise
  injectivity and surjectivity onto `⨆_{c²|m}` cyclic bases.
- **Counting identity, `m ≤ 400`, via the bijection:** for every `m`, the
  label fibers are indexed by exactly `{c : c² | m}` and each maps onto
  the cyclic index-`m/c²` bases without repetition; totals give
  `σ₁(m) = Σ ψ(m/c²)`.
- **Second moment, `m ≤ 200`:** direct `Σ_L e₁(L)` equals the
  `Σ c·ψ(m/c²)` transport, the totient form `Σ φ(c)σ₁(m/c²)`, and the
  multiplicative closed form; the prime-power formula checked directly at
  `p^k` for `(p,k) ≤ (2,8), (3,5), (5,3), (7,3)`; the odd-power
  factorization `ψ(p^{t+1})σ₁(p^t)`; and the non-identification with
  `σ₁, ψ, σ₂` at `m = 4`.
- **Equivariance, `m ∈ {6,12}`:** over the full unimodular window
  (entries in `[-2,2]`, `det = 1`), `e₁(γL) = e₁(L)` and
  `Φ(γL) = (c, γ·Φ_c(L))` for every lattice and every window element;
  and each stratum is exhibited as one orbit by explicit determinant-one
  witnesses carrying the base point `c·(ℤ⊕(m/c²)ℤ)` to every stratum
  member.

## Rigor boundary

Theorem 1 + Lemma 2, Theorem 2, Theorem 3 and the corollaries are proved
above; the finite computations are replays, not evidence.  **Everything
here is classical and no novelty is claimed**: the Smith/homothety
stratification of the degree-`m` Hecke coset space, its orbit
decomposition `⨆_{c²|m} SL₂(ℤ)/Γ₀(m/c²)`, and zeta-quotient Dirichlet
series of the kind in Theorem 2(3) are standard lattice/Hecke theory
(Serre, *A Course in Arithmetic*, VII; Shimura, *Introduction to the
Arithmetic Theory of Automorphic Functions*, Ch. 3).  Repository content:
the assembly identity of R0034 upgraded from an equality of counts to an
explicit coordinate-exact equivariant bijection (with the mod-reduction
lemma pinned down rather than assumed), and the label's second moment
`S(m) = Σ_{c²|m} c ψ(m/c²)` derived exhaustively first (`m ≤ 60`), then
proved in the two convolution forms with the prime-power closed form —
identified as multiplicative but not equal to any standard `σ`-variant.
The derive-first protocol was followed throughout; nothing above is
verified-in-range only.
