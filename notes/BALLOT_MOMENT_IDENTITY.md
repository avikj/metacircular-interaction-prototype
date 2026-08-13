# The ballot–moment identity: chains weighted by their Smith label, the radial law, and the exact (ir)rational bridge to S(p^k)

**Author:** fleet-ballot-moment.  **Status:** exact symbolic theorems with
finite replay; one refutation with exact minimal counterexamples.
**Provenance:** successor seed 3 of R0042
(`notes/DIVISOR_FLAG_LABEL_AUTOMATON.md`, seed 1), joined to seed 2
(`notes/BIJECTIVE_SMITH_ASSEMBLY.md`): find the exact identity connecting
the ballot path counts `C_p(i,k)` to the label moment `S(p^k)`, or refute
that one exists in a precise sense.  Both happen, and the boundary between
them is exactly the rational/algebraic divide.

Conventions are R0034/R0038/R0042's, fixed once: `p` prime; an index-`p^k`
sublattice `L ≤ ℤ²` has Smith pair `(p^i, p^{k-i})`, `0 ≤ 2i ≤ k`; `k` is
the **level**, `i = v_p(e₁)` the **label**; the label-`i` stratum has
`ψ(p^{k-2i})` members (`ψ(m) = m∏_{q|m}(1+1/q)`); a **chain** is
`ℤ² = L₀ ⊃ L₁ ⊃ ⋯ ⊃ L_k` with every step of index `p`; the number of
chains ending at a fixed lattice of label `i` is the ballot sum

\[
C_p(i,k) = \sum_{j=0}^{i} b_j(k)\,p^j,\qquad
b_j(k) := \binom{k}{j}-\binom{k}{j-1}
\]

(seed 1, Theorem 3), the total chain count is `(p+1)^k`, and the second
moment of the label (seed 2, Theorem 2) is

\[
S(p^k) \;=\; \sum_{[\mathbb{Z}^2:L]=p^k} e_1(L)
\;=\; \sum_{2i\le k} p^i\,\psi(p^{k-2i})
\;=\; \frac{p^{k+1}+p^k-p^{\lceil k/2\rceil}-p^{\lfloor k/2\rfloor}}{p-1},
\]

with local Euler factor
`Ŝ(x) := Σ_k S(p^k)x^k = (1+x)/((1-px)(1-px^2))` — **rational**.

Everything was derived by hand first (the tables in §5 are replays); the
tree combinatorics is classical — named in the rigor boundary — and no
novelty is claimed for it.

## 0. Summary of the landing

Two ensembles live on the same set of index-`p^k` lattices: the
**endpoint-uniform** ensemble (each lattice once), whose `e₁`-moment is
`S(p^k)`, and the **chain-uniform** ensemble (each lattice weighted by its
chain count `C_p(i,k)`), whose `e₁`-moment is

\[
W(k) \;:=\; \sum_{[\mathbb{Z}^2:L]=p^k} e_1(L)\,C_p(\mathrm{label}(L),k)
\;=\; \sum_{2i\le k} p^i\,\psi(p^{k-2i})\,C_p(i,k)
\;=\;(p+1)^k\,\mathbb{E}\bigl[p^{I_k}\bigr],
\]

`I_k` the label of the endpoint of a uniform random length-`k` chain.

- **The identity exists** (Theorem 2): `W` is the `p²`-weighted ballot
  transform of `S`,
  `W(k) = Σ_j b_j(k) p^{2j} S(p^{k-2j})`, with the closed form
  `W(k) = [(p^{k+1}+p^k)\binom{k}{\lfloor k/2\rfloor} -
  (p^{\lceil k/2\rceil}+p^{\lfloor k/2\rfloor})B_p(k)]/(p-1)` — the exact
  analogue of the `S(p^k)` formula with the central binomial and the full
  ballot polynomial `B_p(k) = C_p(\lfloor k/2\rfloor, k)` riding the two
  terms.  Generating-function form: `V(x) := Σ_k W(k)x^k = C(x)\,Ŝ(xC(x))`
  with `C = 1 + p²x²C²` (Catalan), i.e. the **Ihara substitution**
  `u = xC(x)`, inverted by `x = u/(1+p²u²)`:
  \[
  \boxed{\;Ŝ(u) \;=\; \frac{V\!\bigl(u/(1+p^2u^2)\bigr)}{1+p^2u^2}.\;}
  \]
  The Euler factor of the moment *is* the chain-ensemble generating
  function read in the non-backtracking variable.
- **The refutation is equally exact** (Theorem 4): `Ŝ` is rational, while
  `V` — and the per-state sum `U(x) = Σ_kΣ_i p^iC_p(i,k)x^k` — are
  algebraic of degree **exactly 2** over `ℚ(x)` (proved by Galois
  conjugation `u ↦ 1/(p²u)`, with an all-`p` witness).  So no identity of
  the form `V = Ŝ`, `U = Ŝ`, or `V/U = Ŝ∘r` with `r` rational can hold.
  Minimal counterexamples: `U` vs `Ŝ` differ first at `k=1` (`1` vs
  `p+1`); `V` vs `Ŝ` differ first at `k=2`, with gap exactly `p²`; and
  `W(k) > S(p^k)` for every `k ≥ 2`, the gap being
  `Σ_{j≥1} b_j(k)p^{2j}S(p^{k-2j})` term by term.

## 1. The chain ensemble by label, and the radial law

**Theorem 1 (radial law).**  Let `M_k(i)` be the number of length-`k`
chains whose endpoint has label `i`.  Then

\[
M_k(i) \;=\; \psi(p^{k-2i})\,C_p(i,k),
\qquad
\mathbb{P}(I_k = i) \;=\; \frac{\psi(p^{k-2i})\,C_p(i,k)}{(p+1)^k}
\;=\; \frac{\psi(p^{k-2i})\sum_{j\le i} b_j(k)p^j}{(p+1)^k},
\]

and `Σ_i M_k(i) = (p+1)^k` (so the law is an exact probability
distribution).  Under the seed-1 dictionary this is the distance
distribution of the uniform walk on the `(p+1)`-regular Bruhat–Tits tree,
`D_k = k - 2I_k` — classical (Kesten); here it falls out of the automaton.

*Proof.*  Every length-`k` chain ends at some index-`p^k` lattice and
every such lattice is an endpoint (seed 1, Corollary to Theorem 3); the
label-`i` stratum has `ψ(p^{k-2i})` members (seed 2, Theorem 1 /
R0034 §4), and each receives exactly `C_p(i,k)` chains (seed 1, Theorems
2–3, label-only dependence).  Multiply.  The total is seed 1's
`Σ_i ψ(p^{k-2i})C_p(i,k) = (p+1)^k`. ∎

Equivalently, `M_k` is computed by the forward automaton DP (seed 1,
Theorem 1): `M₀ = δ₀`, and `M_{k+1}(i)` receives `p·M_k(i)` (keep,
unbalanced), `(p+1)·M_k(i)` if `2i = k` (keep, balanced), and `M_k(i-1)`
if `2(i-1) < k` (raise).  The replay checks the DP against the product
formula and against brute-force enumeration of all `(p+1)^k` chains.

## 2. The identity: W is the ballot transform of S

**Lemma 1 (self-similarity of the stratum sums).**  For `0 ≤ j ≤ ⌊k/2⌋`:

\[
\sum_{i=j}^{\lfloor k/2\rfloor} p^{i}\,\psi(p^{k-2i}) = p^{j}\,S(p^{k-2j}),
\qquad
\sum_{i=j}^{\lfloor k/2\rfloor} \psi(p^{k-2i}) = \sigma_1(p^{k-2j}),
\qquad
\sum_{i=j}^{\lfloor k/2\rfloor} p^{i} = p^{j}\,R_{k-2j},
\]

where `R_m := 1 + p + ⋯ + p^{⌊m/2⌋}`.

*Proof.*  Reindex `i = j + i'`; the ranges match
(`i' ≤ ⌊(k-2j)/2⌋`), and the summands become
`p^{j}·p^{i'}ψ(p^{(k-2j)-2i'})`, resp. `ψ(p^{(k-2j)-2i'})`, resp.
`p^{j}p^{i'}`.  The first sum is seed 2's stratum decomposition of
`S(p^{k-2j})`; the second is R0034's assembly identity
`σ₁(m) = Σ_{c²|m}ψ(m/c²)` at `m = p^{k-2j}`; the third is geometric. ∎

**Theorem 2 (the ballot–moment identity).**  For all `k ≥ 0`:

\[
\boxed{\;W(k) \;=\; \sum_{j=0}^{\lfloor k/2\rfloor} b_j(k)\,p^{2j}\,
S(p^{k-2j})\;}
\tag{2.1}
\]

and, with `B_p(k) := C_p(⌊k/2⌋, k) = Σ_{j≤⌊k/2⌋} b_j(k)p^j` the full
ballot polynomial,

\[
W(k) \;=\; \frac{(p^{k+1}+p^{k})\binom{k}{\lfloor k/2\rfloor}
\;-\;\bigl(p^{\lceil k/2\rceil}+p^{\lfloor k/2\rfloor}\bigr)\,B_p(k)}{p-1}.
\tag{2.2}
\]

Moreover `W(0) = 1` and, for `t ≥ 0`,

\[
W(2t+1) \;=\; p^{t}(p+1)\sum_{r=0}^{t}\binom{2t+1}{r}p^{r},
\qquad
W(2t+2) \;=\; 2p\,W(2t+1),
\tag{2.3}
\]

so
`𝔼[p^{I_{2t+1}}] = p^{t}\,\bigl(\sum_{r\le t}\binom{2t+1}{r}p^{r}\bigr)
/(p+1)^{2t}`.
First values: `W = 1,\ (p+1),\ 2p(p+1),\ p(p+1)(3p+1),\
2p^2(p+1)(3p+1),\ p^2(p+1)(10p^2+5p+1),\ …`

*Proof.*  **(2.1)**  Insert the ballot closed form and swap the finite
sums:

\[
W(k) = \sum_{i} p^i\psi(p^{k-2i})\sum_{j\le i} b_j(k)p^j
= \sum_j b_j(k)\,p^j \sum_{i\ge j} p^i\psi(p^{k-2i})
= \sum_j b_j(k)\,p^{2j}\,S(p^{k-2j})
\]

by Lemma 1 (first form).

**(2.2)**  Insert seed 2's closed form of `S(p^{k-2j})` into (2.1).
Since `⌈(k-2j)/2⌉ = ⌈k/2⌉-j` and `⌊(k-2j)/2⌋ = ⌊k/2⌋-j`,

\[
(p-1)W(k) = (p^{k+1}+p^k)\sum_j b_j(k)
- \bigl(p^{\lceil k/2\rceil}+p^{\lfloor k/2\rfloor}\bigr)\sum_j b_j(k)p^{j},
\]

and the first sum telescopes to `\binom{k}{\lfloor k/2\rfloor}` (seed 1),
the second is `B_p(k)`.

**(2.3)**  Odd `k = 2t+1`: `p^{k+1}+p^k = p^k(p+1)` and
`p^{\lceil k/2\rceil}+p^{\lfloor k/2\rfloor} = p^t(p+1)`, so
`(p-1)W = (p+1)p^t\,[\,p^{t+1}\binom{k}{t} - B_p(k)\,]`.  Writing
`B_p(k) = Σ_{j\le t}\binom{k}{j}p^j - pΣ_{j\le t-1}\binom{k}{j}p^j`
(split the ballot numbers and shift), the bracket is

\[
p^{t+1}\binom{k}{t} - B_p(k)
= p\sum_{j\le t}\binom{k}{j}p^{j} - \sum_{j\le t}\binom{k}{j}p^{j}
= (p-1)\sum_{r=0}^{t}\binom{k}{r}p^{r}.
\]

Even `k = 2t+2`: `\binom{2t+2}{t+1} = 2\binom{2t+1}{t}` (Pascal),
`p^{\lceil k/2\rceil}+p^{\lfloor k/2\rfloor} = 2p^{t+1}`, and
`B_p(2t+2) = (p+1)B_p(2t+1)` (seed 1, balanced recurrence
`C_p(t{+}1,2t{+}2) = (p+1)C_p(t,2t{+}1)`); so
`(p-1)W(2t+2) = 2p\,[\,(p^{2t+2}+p^{2t+1})\binom{2t+1}{t}
- p^{t}(p+1)B_p(2t+1)\,] = 2p\,(p-1)W(2t+1)`. ∎

**Corollary (exact gap; the naive identity refuted term by term).**
`W(0) = S(1) = 1`, `W(1) = S(p) = p+1`, and for `k ≥ 2`

\[
W(k) - S(p^k) \;=\; \sum_{j\ge 1} b_j(k)\,p^{2j}\,S(p^{k-2j}) \;>\; 0,
\]

with minimal case `k = 2`: `W(2) - S(p^2) = b_1(2)p^2S(1) = p^2`
(`W(2) = 2p^2+2p` vs `S(p^2) = p^2+2p`; for `p = 2`: `12` vs `8`).
So the uniform-chain moment is **never** the endpoint moment beyond
`k = 1`; `S(p^k)` arises from the chain ensemble only under the
endpoint-uniform reweighting (weight `1/C_p(i,k)` per chain), which is
Theorem 1 read backwards.

## 3. The transfer lemma and the three generating functions

**Theorem 3 (ballot transfer lemma).**  Fix a commutative ring, a weight
`w`, and any sequence `(G_m)_{m≥0}` with `Ĝ(u) = Σ_m G_m u^m`.  Then, as
formal power series,

\[
\sum_{k\ge 0} x^k \sum_{j=0}^{\lfloor k/2\rfloor} b_j(k)\,w^{j}\,G_{k-2j}
\;=\; C_w(x)\;Ĝ\bigl(x\,C_w(x)\bigr),
\qquad C_w = 1 + w\,x^2 C_w^2
\]

(`C_w = Σ_t \mathrm{Cat}_t\,w^t x^{2t}`, the Catalan series).

*Proof.*  Let `N_k(m) := b_{(k-m)/2}(k)` for `k ≥ m`, `k ≡ m (mod 2)`,
else `0` — the number of nonnegative `±1`-paths of length `k` from `0` to
`m`.  Seed 1's Pascal identity `b_j(k) = b_j(k-1) + b_{j-1}(k-1)` gives,
for `m ≥ 1`, `N_k(m) = N_{k-1}(m-1) + N_{k-1}(m+1)`, and at the wall
`N_k(0) = N_{k-1}(1)` (the would-be term `N_{k-1}(-1)` is
`b_{k/2}(k-1) = 0` by central adjacency, exactly seed 1's balanced
collapse).  Define the column series
`B_m(x) := Σ_k N_k(m)\,w^{(k-m)/2} x^k`; the down-step count is
`(k-m)/2`, and it stays fixed along the `m-1 → m` edge and increments
along `m+1 → m`, so the recurrences become

\[
B_m = x\,B_{m-1} + w\,x\,B_{m+1}\ (m\ge 1),
\qquad B_0 = 1 + w\,x\,B_1 .
\]

This system, with `[x^0]B_m = [m=0]`, determines all coefficients by
induction on the degree.  The candidate `β_m := C_w\,(xC_w)^m` satisfies
it: for `m ≥ 1`, `xβ_{m-1} + wxβ_{m+1} = (xC_w)^m + (xC_w)^m(C_w-1)
= β_m` using `wx²C_w² = C_w - 1`, and `1 + wxβ_1 = 1 + wx²C_w² = C_w
= β_0`; also `[x^0]β_m = [m=0]`.  Hence `B_m = β_m`.  Finally
`Σ_k x^kΣ_j b_j(k)w^jG_{k-2j} = Σ_m G_m B_m(x)` (regroup the finite sums
by `m = k-2j`; summable since `B_m = O(x^m)`)
`= Σ_m G_m C_w (xC_w)^m = C_w Ĝ(xC_w)`. ∎

Write from now on `C := C_{p^2}` and `u := xC(x)`, so `C = 1 + p²u²` and
— solving `p²xu² - u + x = 0` for `x` — `x = u/(1+p²u²)`; the maps
`x ↦ xC(x)` and `u ↦ u/(1+p²u²)` are mutually inverse formal
substitutions.  (`u` is the non-backtracking/first-passage variable of
the `(p+1)`-regular tree; see the rigor boundary.)

**Theorem 3′ (the three instances).**

1. **Chain-side moment** (`w = p²`, `G_m = S(p^m)` via Theorem 2):
   \[
   V(x) := \sum_k W(k)\,x^k \;=\; C(x)\,Ŝ\bigl(xC(x)\bigr)
   \;=\; \frac{(1+p^2u^2)(1+u)}{(1-pu)(1-pu^2)}\Big|_{u = xC(x)} .
   \]
2. **Per-state sum** (`w = p²`, `G_m = R_m` via Lemma 1, third form,
   after the same swap as in Theorem 2:
   `U_k := Σ_{2i\le k} p^iC_p(i,k) = Σ_j b_j(k)p^{2j}R_{k-2j}`), with
   `R̂(u) = Σ_m R_m u^m = 1/((1-u)(1-pu^2))`:
   \[
   U(x) := \sum_k U_k\,x^k \;=\; \frac{C}{(1-xC)\,(1-p\,x^2C^2)}
   \;=\; \frac{1+p^2u^2}{(1-u)(1-pu^2)}\Big|_{u = xC(x)} .
   \]
   In particular `V\,(1-pu) = U\,(1-u^2)` in the `u`-variable.
3. **Total chains** (`w = p`, `G_m = σ_1(p^m)` via Lemma 1, second form:
   `(p+1)^k = Σ_iψ(p^{k-2i})C_p(i,k) = Σ_j b_j(k)p^{j}σ_1(p^{k-2j})`),
   with `σ̂(u) = 1/((1-u)(1-pu))` and `u_1 = xC_p(x)`, `C_p = 1+pu_1²`:
   \[
   \frac{1}{1-(p+1)x} \;=\; C_p(x)\,σ̂\bigl(xC_p(x)\bigr),
   \qquad\text{i.e.}\qquad
   1-(p+1)x = \frac{(1-u_1)(1-pu_1)}{1+pu_1^2}
   \]
   — the Bass–Ihara determinant identity for the `(p+1)`-regular tree,
   here a corollary of seed 1's total `(p+1)^k` plus the transfer lemma.

*Proof.*  Each left-hand side is Theorem 3 applied to the stated `(w,G)`;
the `u`-variable forms substitute `C = 1+p²u²` (resp. `C_p = 1+pu_1²`)
and `xC = u` into the rational functions
`Ŝ(u) = (1+u)/((1-pu)(1-pu^2))` (seed 2), `R̂`, `σ̂` (geometric sums:
`R̂(u) = Σ_i p^iu^{2i}·Σ_a u^a`, `σ̂(u) = Σ_a(pu)^a·Σ_b u^b`).  For (3),
`1-(p+1)x = 1-(p+1)u_1/(1+pu_1²) = (1-u_1)(1-pu_1)/(1+pu_1²)`.  All
substitutions are of positive-order series into rational functions with
unit constant-term denominators, hence legal formally. ∎

**Theorem 3″ (inverse substitution: the exact bridge).**  As formal power
series in `u`,

\[
Ŝ(u) \;=\; \frac{V\bigl(u/(1+p^2u^2)\bigr)}{1+p^2u^2},
\qquad\text{equivalently}\qquad
Ŝ(u) = \frac{V(x)}{C(x)}\ \text{under}\ x = \frac{u}{1+p^2u^2}.
\]

*Proof.*  Compose Theorem 3′(1) with the inverse substitution
`x = u/(1+p²u²)` (inverse because `u = xC(x)` satisfies
`p²xu²-u+x = 0`, i.e. `x(1+p²u²) = u`, and both series have linear
coefficient `1`); then `C(x)|_{x=u/(1+p²u²)} = 1+p²u²`. ∎

So the rational Euler factor of the second moment is recovered *exactly*
from the chain ensemble: pass to the non-backtracking variable and strip
the Catalan prefactor.  That is the precise sense in which the sought
identity exists.

## 4. The refutation: V and U are irrational, Ŝ is not them

**Theorem 4 (rationality split).**  Fix a prime `p ≥ 2`.

1. `Ŝ(x) = (1+x)/((1-px)(1-px^2)) ∈ ℚ(x)`.
2. `V(x) ∉ ℚ(x)` and `U(x) ∉ ℚ(x)`; both lie in the quadratic extension
   `ℚ(x)(u) = ℚ(x)\bigl(\sqrt{1-4p^2x^2}\bigr)`, so both are algebraic
   over `ℚ(x)` of degree exactly `2`.
3. Consequently `V ≠ Ŝ`, `U ≠ Ŝ`, `V ≠ U`, and there is **no** rational
   substitution `r(x) ∈ xℚ(x)` with `Ŝ(r(x)) = V(x)` or `= U(x)` (the
   left side would be rational).  The coefficientwise minimal
   counterexamples are `k = 1` for `U` (`U_1 = 1` vs `S(p) = p+1`) and
   `k = 2` for `V` (`W(2)-S(p^2) = p^2`), per §2's corollary.

*Proof.*  **(1)** is seed 2.

**(2)**  The quadratic `q(T) = p²xT² - T + x ∈ ℚ(x)[T]` has discriminant
`1-4p²x² = (1-2px)(1+2px)`, a squarefree quadratic, hence not a square in
`ℚ(x)` (squares have even-order zeros), so `q` is irreducible and
`L := ℚ(x)[T]/(q)` is a degree-2 Galois extension of `ℚ(x)`.  The series
`u = xC(x) ∈ xℚ[[x]]` is a root of `q` (Catalan equation, §3), which
embeds `L ↪ ℚ((x))`, `T ↦ u`; since `x = u/(1+p²u²)`, in fact
`L = ℚ(u)` with `u` transcendental over `ℚ`.  The nontrivial automorphism
`σ` of `L/ℚ(x)` swaps the roots of `q`; their product is
`x/(p²x) = 1/p²`, so

\[
σ(u) = \frac{1}{p^2u}.
\]

By Theorem 3′, `V = Φ_V(u)` and `U = Φ_U(u)` with

\[
Φ_V(T) = \frac{(1+p^2T^2)(1+T)}{(1-pT)(1-pT^2)},
\qquad
Φ_U(T) = \frac{1+p^2T^2}{(1-T)(1-pT^2)} \;\in ℚ(T).
\]

Suppose `V ∈ ℚ(x)`.  Then `V` is `σ`-fixed, so
`Φ_V(u) = σ(Φ_V(u)) = Φ_V(1/(p²u))` in `L = ℚ(u)`; as `u` is
transcendental, `Φ_V(T) - Φ_V(1/(p²T)) ≡ 0` in `ℚ(T)`.  Evaluate at
`T = 1/p²` (conjugate point `1/(p²T) = 1`; all four denominator factors
are nonzero there):

\[
Φ_V\!\left(\tfrac{1}{p^2}\right) = \frac{(p^2+1)^2}{(p-1)(p^3-1)},
\qquad
Φ_V(1) = \frac{2(p^2+1)}{(p-1)^2},
\]

and equality would force `(p^2+1)(p-1) = 2(p^3-1)`, whose defect is
`(p^2+1)(p-1) - 2(p^3-1) = -(p+1)^2(p-1) ≠ 0` for every `p`.
Contradiction; so `V ∉ ℚ(x)`.

For `U`, compare poles instead: as rational functions of `T`,

\[
Φ_U\!\left(\frac{1}{p^2T}\right)
= \frac{p^3T\,(p^2T^2+1)}{(p^2T-1)(p^3T^2-1)}
\]

has a **simple pole** at `T = 1/p²` (the factor `p²T-1` vanishes, the
numerator `p(p²+1)/p²·…` and the factor `p³T²-1 = (1-p)/p` do not),
while `Φ_U(T)` is **regular** there
(`(1-T)(1-pT^2)|_{T=1/p^2} = \frac{(p^2-1)(p^3-1)}{p^5} ≠ 0`, value
`p^3(p^2+1)/((p^2-1)(p^3-1))`).  So `Φ_U(T) ≠ Φ_U(1/(p²T))`, and the same
Galois argument gives `U ∉ ℚ(x)`.  Both lie in `L` (degree 2), so the
degree is exactly 2.

**(3)**  Immediate from (1), (2), the closure of `ℚ(x)` under
composition with rational `r`, and the corollary of §2 (for `V ≠ U`:
their coefficients differ at `k = 1`, `p+1` vs `1`; in `u`-coordinates
`V(1-pu) = U(1-u²)` and `(1-pu) ≠ (1-u²)`). ∎

**Remark (what the divide means).**  The singularity of `V` at
`x = 1/(2p)` is a branch point that *collides* with the image of the pole
`u = 1/p` of `Ŝ` (at `x = 1/(2p)` one has `u = xC = 1/p` exactly), which
is why `W(k)` grows like `(2p)^k k^{-1/2}` (visible in (2.3):
`W(2t+1) ≈ p^t(p+1)\binom{2t+1}{t}p^t\cdot\frac{p}{p-1}`) — a
`k^{-1/2}` prefactor no rational function can produce.  The Galois proof
above is the certified version of this remark.

## 5. First values and derive-first tables

For general `p`:
`W = 1,\ p{+}1,\ 2p(p{+}1),\ p(p{+}1)(3p{+}1),\ 2p^2(p{+}1)(3p{+}1),\
p^2(p{+}1)(10p^2{+}5p{+}1),\ 2p^3(p{+}1)(10p^2{+}5p{+}1),\ …` and
`U = 1,\ 1,\ p^2{+}p{+}1,\ 2p^2{+}p{+}1,\ 2p^4{+}3p^3{+}4p^2{+}p{+}1,\ …`.
For `p = 2`: `W = 1, 3, 12, 42, 168, 612, 2448, …`;
`U = 1, 1, 7, 11, 75, 135, 907, …`; `S(2^k) = 1, 3, 8, 18, 40, 84, …`;
`𝔼[2^{I_k}] = 1, 1, 4/3, 14/9, 56/27, 68/27, …`.  The label law at
`(p,k) = (2,4)`: `P(I=0,1,2) = (24, 42, 15)/81` — i.e.
`ψ(16)·1, 2·ψ(4)·7, 4·1·15` over `(p+1)^k`, `Σ = 1` exactly.

The identities (2.1)–(2.3), the three GF instances, and the inverse
substitution were derived by hand from seeds 1–2 (the derivations above)
and only then replayed on exact tables `p ∈ {2,3,5}`, `k ≤ 12`; the
tables confirmed every law and produced no fitted quantity.

## 6. Replay

`machinery/ballot_moment_identity.py` (imports seed 1's
`ballot`/`chain_count_closed`, seed 2's `second_moment_prime_power`, and
R0034's `psi`), tests in `machinery/test_ballot_moment_identity.py`
(22 tests, all exact integers/Fractions, all green):

- **ensemble:** `M_k(i) = ψ(p^{k-2i})C_p(i,k)` for `p ∈ {2,3,5}`,
  `k ≤ 12` (DP vs product), and against brute-force enumeration of all
  `(p+1)^k` chains for `p ∈ {2,3}`, `k ≤ 4`; closed form vs seed-1 DP
  re-pinned.
- **moment:** the five expressions of `W(k)` (automaton DP, stratum sum,
  ballot transform (2.1), closed form (2.2), half-sum (2.3)) agree for
  `p ∈ {2,3,5}`, `k ≤ 12`; the doubling `W(2t+2) = 2pW(2t+1)`; the first
  values above.
- **radial law:** the label distribution sums to `1` as exact fractions
  and is positive; `𝔼[p^{I_k}]` from the distribution equals
  `W(k)/(p+1)^k` and the odd-`k` closed form.
- **generating functions, coefficientwise to `k ≤ 12`:**
  `Ŝ` series = `S(p^k)`; `V = C\,Ŝ(xC)`; `U = C/((1-xC)(1-px²C²))`;
  the Ihara instance reproduces `(p+1)^k`; the Catalan functional
  equation; the transfer lemma on generic `(w,G)` (weights `1,2,3,4,9`,
  three unrelated sequences); and the inverse substitution
  `Ŝ(u) = V(u/(1+p²u²))/(1+p²u²)`.
- **refutation:** minimal counterexamples at `k = 1` (`U`) and `k = 2`
  (`V`, gap `p²`); the Galois witnesses as exact fractions for
  `p ∈ {2,3,5,7,11}` — `Φ_V(1/p²) ≠ Φ_V(1)` with the defect polynomial
  `-(p+1)²(p-1)`, the `Φ_U` pole/regularity split, and the `u`-variable
  relations `V(1-pu) = U(1-u²)`, `V = (1+p²u²)Ŝ(u)` at sample rational
  points.

Run: `cd machinery && python3 -m unittest test_ballot_moment_identity -v`.

## Rigor boundary

Theorems 1–4 (with Lemma 1 and Theorems 3′, 3″) are proved above by
finite sums, formal power-series algebra, and one Galois-theoretic
argument; the computations in §5–6 are replays, not evidence; nothing is
verified-in-range only.  The derive-first protocol was followed: every
closed form was derived before any table was computed.

**The tree combinatorics is classical and no novelty is claimed for it.**
Named objects: the radial (distance) distribution of the simple random
walk on the `(p+1)`-regular tree and its `k^{-1/2}`-corrected `(2p)^k`
growth are Kesten's (Kesten, *Symmetric random walks on groups*, 1959);
the column generating functions `B_m = C_w(xC_w)^m` are the standard
first-passage/Green-function combinatorics of trees (Woess, *Random Walks
on Infinite Graphs and Groups*, Ch. I); the substitution
`u = xC(x)`, `x = u/(1+p²u²)` and instance 3′(3) are the Bass–Ihara
determinant identity specialized to the `(p+1)`-regular tree (Ihara 1966;
Bass 1992; Terras, *Zeta Functions of Graphs*); the ballot numbers and
the Catalan transform are folklore lattice-path theory; chain counts are
P. Hall's flag enumerations (Butler, *Subgroup Lattices and Symmetric
Functions*).  Repository content: the identification of the
uniform-chain `e₁`-moment `W(k)` as the `p²`-weighted ballot transform of
the seed-2 moment `S(p^k)` (2.1), its two closed forms (2.2)–(2.3)
mirroring the `S(p^k)` formula, the exact rational/algebraic split
(Theorem 4) refuting every naive `C_p`-to-`S` identity with minimal
counterexamples `k=1`, `k=2` (gap `p²`), and the exact bridge
`Ŝ(u) = V(u/(1+p²u²))/(1+p²u²)` exhibiting the Euler factor of `S`
inside the chain ensemble — all bound to one executable exact replay.
