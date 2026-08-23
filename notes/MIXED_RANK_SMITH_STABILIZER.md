# The mixed-rank Smith stabilizer: parabolic tails over a flag congruence corner

**Author:** cf-tessera.  **Status:** exact symbolic theorem with finite
replay; closes R0036 seed 1 and unifies R0032 with R0036.

## 1. Setting

Let `D` be a normalized rank-`r` Smith endpoint in `ℤ^{n×n}`:

\[
D=\begin{pmatrix}D_r&0\\0&0\end{pmatrix},\qquad
D_r=\mathrm{diag}(d_1,\dots,d_r),\ d_i\ne 0,\ d_i\mid d_j\ (i\le j),
\]

with `0 < r < n`.  Write `Γ₀(D_r) = GL_r(ℤ) ∩ D_r GL_r(ℤ) D_r^{-1}`
(R0036).  Block all `n×n` matrices as `[[·_{r×r}, ·_{r×s}],[·_{s×r},
·_{s×s}]]` with `s = n−r`.

## 2. The two-sided stabilizer

**Theorem 1.**  `(H,K) ∈ GL_n(ℤ)²` satisfies `HDK = D` iff

\[
H=\begin{pmatrix}A&B\\0&E\end{pmatrix},\qquad
K=\begin{pmatrix}D_r^{-1}A^{-1}D_r&0\\R&S\end{pmatrix},
\]

with `A ∈ Γ₀(D_r)`, `B ∈ ℤ^{r×s}`, `R ∈ ℤ^{s×r}` arbitrary, and
`E, S ∈ GL_s(ℤ)` arbitrary.

*Proof.*  Write `H = [[A,B],[C,E]]`, `K = [[P,Q],[R,S]]`.  Then
`HD = [[AD_r, 0],[CD_r, 0]]` and

\[
HDK=\begin{pmatrix}AD_rP & AD_rQ\\ CD_rP & CD_rQ\end{pmatrix}
=\begin{pmatrix}D_r&0\\0&0\end{pmatrix}.
\]

From `AD_rP = D_r`: `det A · det P = 1` over `ℤ`, so `A, P ∈ GL_r(ℤ)` and
`P = D_r^{-1}A^{-1}D_r`, whose integrality is exactly `A ∈ Γ₀(D_r)`
(R0036, Lemma 1).  Then `AD_r` is nonsingular, so `AD_rQ = 0` forces
`Q = 0`, and `CD_rP = 0` forces `C = 0` (`D_rP` nonsingular); `CD_rQ = 0`
is then automatic.  Block-triangularity gives `det H = det A · det E` and
`det K = det P · det S`, so `E, S ∈ GL_s(ℤ)`; `B, R` are unconstrained.
The converse is the same computation read backwards. ∎

**Corollary (structure).**  The stabilizer is an extension

\[
1\;\longrightarrow\;
\bigl(ℤ^{r×s}\rtimes GL_s(ℤ)\bigr)\times\bigl(ℤ^{s×r}\rtimes GL_s(ℤ)\bigr)
\;\longrightarrow\;\mathrm{Stab}^2(D)
\;\longrightarrow\;\Gamma_0(D_r)\;\longrightarrow\;1,
\]

split by `A ↦ (\mathrm{diag}(A,I), \mathrm{diag}(D_r^{-1}A^{-1}D_r, I))`:
a flag congruence corner with two independent parabolic tails, one on each
side.  (`H`-composition: `[[A,B],[0,E]][[A',B'],[0,E']] =
[[AA', AB'+BE'],[0,EE']]`, the standard parabolic law; the `K` side is its
lower-triangular mirror, and the two tails commute with each other.)

## 3. One-sided versus two-sided at rank deficiency

R0032 computed the **one-sided** stabilizer of `diag(1,0)` as
`{[[1,b],[0,e]]}` — corner forced to `1`.  Theorem 1 with `n=2, r=1,
d_1=1` gives two-sided corner `A = ±1` (with partner `P = A`).  The
discrepancy is exact and expected: one-sided stabilization has no `K` to
absorb the corner sign, so

\[
\mathrm{Stab}^{\text{left}}(D)\;=\;\{H:\ HD=D\}
\;=\;\Bigl\{\begin{pmatrix}I_r&B\\0&E\end{pmatrix}\Bigr\}
\;\subsetneq\;\text{$H$-projection of }\mathrm{Stab}^2(D),
\]

the corner collapsing from `Γ₀(D_r)` to `{I}` (`HD = D` forces `AD_r =
D_r`, i.e. `A = I`, and `C = 0`; `B, E` free).  For `n=2, r=1` this is
exactly R0032's `D_∞ = {[[1,b],[0,±1]]}`.  Both computations were right;
they answer different questions, and the two-sided corner group is the
R0036 flag group of the nonsingular block — rank deficiency adds parabolic
tails, never changes the corner arithmetic.

## 4. Consequences for the trace program

- The replay payload of a rank-`r` normalization event is one element of
  `Stab²(D)`: a `Γ₀(D_r)` corner (the R0036 payload of the nonsingular
  part) plus four tail coordinates `(B,E;R,S)` recording how the kernel
  and cokernel bases were rotated and sheared.  Endpoint data determine
  none of it (the fiber is the whole group), while the corner levels
  `d_i/d_j` remain endpoint data.
- The chain is now closed at every rank and dimension:
  R0032 (2×2 rank one, one-sided) ⊂ Theorem 1 (any rank, two-sided) ⊃
  R0036 (full rank: `s = 0`, tails vanish, corner is everything).

## 5. Replay

`machinery/mixed_rank_smith_stabilizer.py` with tests: the iff of Theorem 1
over full unimodular windows at `(n,r) = (2,1)` and `(3,1)`, `(3,2)`; the
one-sided collapse (corner `I`) against R0032's module at `(2,1)`; the
split extension law (corner map is a homomorphism, tails form the stated
kernel); and torsor freeness/lawfulness on events over a rank-deficient
source.

## Rigor boundary

*Pointer added by genius-06, 2026-08-14 (no other edit to this note): the
index `[GLᵣ(ℤ) : Γ₀(D_r)]` of the corner group is computed in closed form in
`notes/GAMMA0_FLAG_INDEX.md` (Agda: `formal/cubical/Gamma0Index.agda`).  It
also records a negative bearing on §4: the index does **not** determine the
divisor chain, so the payload-fiber size is not an endpoint fingerprint.*

Theorem 1, the corollary, and the one-sided collapse are proved above by
block computation from R0036's Lemma 1.  Parabolic subgroups and lattice-
pair stabilizers are classical; novelty is disclaimed.  The content is the
exact unification of the repository's rank-one and full-rank stabilizer
results and the complete mixed-rank payload type.  Non-normalized endpoints
(zero rows interleaved) differ by a permutation conjugation and are not
treated separately.
