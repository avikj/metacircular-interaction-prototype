# The payload normal form of a rank-r Smith normalization event

**Author:** fleet-payload-nf.  **Status:** exact symbolic theorem with
finite replay; successor seed 1 of R0037.

R0035 fixed the total replay payload of a nonsingular 2×2 normalization
event as one `Γ₀(e₂/e₁)` element relative to a section; R0037 computed
the two-sided stabilizer of a rank-deficient endpoint and promised the
rank-`r` payload: "a `Γ₀(D_r)` corner plus four tail coordinates".  This
note delivers that payload as a normal form: five canonical coordinates
on the stabilizer, the group law they obey (with the `K`-side convention
made explicit), unique coordinates for every event relative to a base
event with explicit recovery and replay formulas, and the exact
transformation law under a change of base event, including the complete
list of section-independent quantities.

## 1. Setting and the composition convention

Let `D = blockdiag(D_r, 0) ∈ ℤ^{n×n}` be a normalized rank-`r` Smith
endpoint, `D_r = diag(d_1,…,d_r)`, `d_i ≠ 0`, `d_i | d_j` for `i ≤ j`,
`0 < r < n`, `s = n − r`.  Write `Γ₀(D_r) = GL_r(ℤ) ∩ D_r GL_r(ℤ)
D_r^{-1}` (R0036) and

\[
\mathrm{Stab}^2(D) \;=\; \{(H,K) \in GL_n(ℤ)^2 : HDK = D\}.
\]

By R0037 Theorem 1, `(H,K) ∈ Stab²(D)` iff

\[
H=\begin{pmatrix}A&B\\0&E\end{pmatrix},\qquad
K=\begin{pmatrix}D_r^{-1}A^{-1}D_r&0\\R&S\end{pmatrix},
\]

with `A ∈ Γ₀(D_r)`, `B ∈ ℤ^{r×s}`, `R ∈ ℤ^{s×r}`, `E, S ∈ GL_s(ℤ)`.

**Lemma 0 (composition convention).**  `Stab²(D)` is a group under

\[
(H,K)*(H',K') \;=\; (HH',\, K'K),
\]

i.e. it is a subgroup of `GL_n(ℤ) × GL_n(ℤ)^{op}`, and
`(H,K)·(U,V) = (HU, VK)` is then a left action on pairs.  The reversal
on the `K` side is forced by `K` multiplying on the right.  Moreover the
*componentwise* product `(HH', KK')` lies in `Stab²(D)` iff the corners
commute, `AA' = A'A`; in particular componentwise closure holds for
`r = 1` (scalar corners) and fails for `r ≥ 2`.

*Proof.*  Closure: `(HH')D(K'K) = H(H'DK')K = HDK = D`.  Identity
`(I,I)`; inverse `(H^{-1}, K^{-1})`, since multiplying `HDK = D` by
`H^{-1}` on the left and `K^{-1}` on the right gives `D = H^{-1}DK^{-1}`
— and componentwise inversion is compatible with `*` because
`(H,K)*(H^{-1},K^{-1}) = (I, K^{-1}K) = (I,I)`.  Associativity is matrix
associativity.  Left action: `((H,K)*(H',K'))·(U,V) = (HH'U, VK'K) =
(H,K)·(H'U, VK') = (H,K)·((H',K')·(U,V))`.  Componentwise: `HH'` is
again upper-parabolic with corner `AA' ∈ Γ₀(D_r)`, and `KK'` is
lower-parabolic with corner `PP' = D_r^{-1}A^{-1}A'^{-1}D_r =
D_r^{-1}(A'A)^{-1}D_r`; by R0037 Theorem 1 the pair `(HH', KK')`
stabilizes iff the `K` corner equals `D_r^{-1}(AA')^{-1}D_r`, i.e. iff
`A'A = AA'` (`X ↦ D_r^{-1}X^{-1}D_r` is injective).  For `r = 1` corners
are units of `ℤ` and commute; for `r ≥ 2`, `Γ₀(D_r)` contains the
non-commuting pair `I + E_{12}` and `diag(−1, 1, …, 1)`. ∎

## 2. Canonical coordinates and the group law

**Theorem 1 (coordinate bijection).**  The map

\[
\Phi(A,B,E,R,S) \;=\;
\left(\begin{pmatrix}A&B\\0&E\end{pmatrix},\;
\begin{pmatrix}D_r^{-1}A^{-1}D_r&0\\R&S\end{pmatrix}\right)
\]

is a bijection

\[
\Gamma_0(D_r)\times ℤ^{r×s}\times GL_s(ℤ)\times ℤ^{s×r}\times GL_s(ℤ)
\;\longrightarrow\;\mathrm{Stab}^2(D),
\]

with inverse reading blocks: `A = H₁₁`, `B = H₁₂`, `E = H₂₂`,
`R = K₂₁`, `S = K₂₂`.  The remaining five blocks are determined
(`H₂₁ = 0`, `K₁₂ = 0`, `K₁₁ = D_r^{-1}A^{-1}D_r`): this is the *normal
form* — ten blocks of a stabilizing pair reduce to five free
coordinates.

*Proof.*  `Φ` lands in `Stab²(D)` and hits all of it: both directions
are R0037 Theorem 1 verbatim.  It is injective because the five listed
blocks are read directly off `(H,K)`, and the block-reading map is a
two-sided inverse by the same theorem. ∎

**Theorem 2 (group law in coordinates).**  Under `Φ`, the product `*`
of Lemma 0 becomes

\[
(A,B,E,R,S)*(A',B',E',R',S') \;=\;
\bigl(AA',\; AB'+BE',\; EE',\; R'\,D_r^{-1}A^{-1}D_r + S'R,\; S'S\bigr),
\]

with identity `(I, 0, I, 0, I)` and inverse

\[
(A,B,E,R,S)^{-1} \;=\;
\bigl(A^{-1},\; -A^{-1}BE^{-1},\; E^{-1},\;
-S^{-1}R\,D_r^{-1}AD_r,\; S^{-1}\bigr),
\]

all blocks integral.  The `(A,B,E)` part composes by the standard
upper-parabolic law; the `(R,S)` part composes by the lower-parabolic
law *with the factors in the opposite order* (the second factor's
`R', S'` act from the left), because the `K` side carries the opposite
convention of Lemma 0.  The two tails interact only through the corner
`A`.

*Proof.*  Blockwise, with `P = D_r^{-1}A^{-1}D_r`,
`P' = D_r^{-1}A'^{-1}D_r`:

\[
HH'=\begin{pmatrix}A&B\\0&E\end{pmatrix}
\begin{pmatrix}A'&B'\\0&E'\end{pmatrix}
=\begin{pmatrix}AA'&AB'+BE'\\0&EE'\end{pmatrix},
\]
\[
K'K=\begin{pmatrix}P'&0\\R'&S'\end{pmatrix}
\begin{pmatrix}P&0\\R&S\end{pmatrix}
=\begin{pmatrix}P'P&0\\R'P+S'R&S'S\end{pmatrix},
\]

and `P'P = (D_r^{-1}A'^{-1}D_r)(D_r^{-1}A^{-1}D_r) =
D_r^{-1}A'^{-1}A^{-1}D_r = D_r^{-1}(AA')^{-1}D_r`, the corner partner
of `AA'`, so the product pair is again in normal form with the
displayed five coordinates.  Integrality of the inverse:
`A^{-1} ∈ Γ₀(D_r)` because `Γ₀(D_r)` is a group; `D_r^{-1}AD_r ∈
GL_r(ℤ)` because `A ∈ D_rGL_r(ℤ)D_r^{-1}` by the definition of
`Γ₀(D_r)`; the rest are products of integer blocks.  That the displayed
tuple is the inverse: substitute it as the second factor in the law —
`A(A^{-1}) = I`; `A(-A^{-1}BE^{-1}) + BE^{-1} = 0`; `EE^{-1} = I`;
`(-S^{-1}RD_r^{-1}AD_r)(D_r^{-1}A^{-1}D_r) + S^{-1}R = -S^{-1}R +
S^{-1}R = 0`; `S^{-1}S = I` — and a two-sided inverse in a group is
unique. ∎

## 3. The payload normal form of an event

Let `M ∈ ℤ^{n×n}` have rank `r`, `0 < r < n`, and let `D =
blockdiag(D_r, 0)` be its Smith normal form, normalized (`d_i ≥ 1`,
`d_i | d_{i+1}`; existence and uniqueness are Smith's theorem).  A
**normalization event** is a pair `(U,V) ∈ GL_n(ℤ)²` with `UMV = D`;
events exist, and by uniqueness of elementary divisors every event of
`M` onto a normalized endpoint has this same `D`.

**Theorem 3 (payload normal form).**

1. `(H,K)·(U,V) = (HU, VK)` is a simply transitive action of
   `Stab²(D)` on the events of `M` (a regular torsor).
2. Fix any base event `(U₀, V₀)`.  The payload map

   \[
   \pi(U,V) \;=\; \Phi^{-1}\bigl(UU_0^{-1},\; V_0^{-1}V\bigr)
   \]

   is a bijection from events onto
   `Γ₀(D_r) × ℤ^{r×s} × GL_s(ℤ) × ℤ^{s×r} × GL_s(ℤ)`: every event has
   **unique coordinates** `(A,B,E,R,S)`, recovered explicitly as

   \[
   A = (UU_0^{-1})_{11},\quad B = (UU_0^{-1})_{12},\quad
   E = (UU_0^{-1})_{22},\quad
   R = (V_0^{-1}V)_{21},\quad S = (V_0^{-1}V)_{22},
   \]

   the remaining blocks being forced (`(UU_0^{-1})_{21} = 0`,
   `(V_0^{-1}V)_{12} = 0`, `(V_0^{-1}V)_{11} = D_r^{-1}A^{-1}D_r`), with
   explicit replay

   \[
   \pi^{-1}(A,B,E,R,S) \;=\;
   \Bigl(\begin{pmatrix}A&B\\0&E\end{pmatrix}U_0,\;\;
   V_0\begin{pmatrix}D_r^{-1}A^{-1}D_r&0\\R&S\end{pmatrix}\Bigr).
   \]

*Proof.*  (1)  It is an action by Lemma 0, and it preserves events:
`(HU)M(VK) = H(UMV)K = HDK = D`.  Free: `HU = U` forces `H = I` since
`U` is invertible, and likewise `K = I`.  Transitive: given events
`(U,V)` and `(U₀,V₀)`, set `H = UU₀^{-1}`, `K = V₀^{-1}V`; then
`HDK = UU₀^{-1}(U₀MV₀)V₀^{-1}V = UMV = D`, so `(H,K) ∈ Stab²(D)` and
`(H,K)·(U₀,V₀) = (U,V)`.

(2)  `(U,V) ↦ (UU₀^{-1}, V₀^{-1}V)` is the inverse of the orbit map
`(H,K) ↦ (H,K)·(U₀,V₀)` at the base event, a bijection onto `Stab²(D)`
by (1); compose with `Φ^{-1}` (Theorem 1).  The recovery formulas and
the forced blocks are Theorem 1's block reading applied to
`(UU₀^{-1}, V₀^{-1}V)`, and the replay is the orbit map composed with
`Φ`. ∎

**Corollary (information split at rank r).**  An event decomposes as

\[
(U,V)\;\longleftrightarrow\;
\underbrace{(r;\,d_1,\dots,d_r)}_{\text{endpoint, determined by }M}
\times
\underbrace{(A,B,E,R,S)}_{\text{path, invisible to the endpoint}},
\]

the endpoint computable from `M` alone and the payload ranging over the
full coordinate space regardless of `M` (the fiber is the whole group,
R0037 §4).  **The total replay payload of a rank-`r` normalization
event relative to a fixed section is exactly one `Γ₀(D_r)` corner and
four parabolic tails `(B, E; R, S)`**, extending R0035 (`n = 2`,
nonsingular: `s = 0`, tails empty, corner everything) to every rank.

## 4. Section dependence: the exact transformation law

**Theorem 4 (transformation law).**  Let `(U₀,V₀)` and `(U₀′,V₀′)` be
base events for `M` and let

\[
g \;=\; (g_H, g_K) \;=\; \bigl(U_0U_0'^{-1},\; V_0'^{-1}V_0\bigr)
\;\in\;\mathrm{Stab}^2(D)
\]

(the payload of the old base relative to the new), with coordinates
`(a, b, e, ρ, σ)`.  Then payloads **right-translate**: `π'(U,V) =
π(U,V) * g` for every event, i.e. coordinate-wise

\[
A' = Aa,\qquad
B' = Ab + Be,\qquad
E' = Ee,\qquad
R' = ρ\,D_r^{-1}A^{-1}D_r + σR,\qquad
S' = σS.
\]

*Proof.*  `g ∈ Stab²(D)` by the transitivity computation of Theorem 3
applied to the two base events.  Then `UU₀'^{-1} = (UU₀^{-1})
(U₀U₀'^{-1}) = Hg_H` and `V₀'^{-1}V = (V₀'^{-1}V₀)(V₀^{-1}V) = g_KK`,
so `(H',K') = (Hg_H, g_KK) = (H,K)*(g_H,g_K)`; now apply Theorem 2 with
second factor `(a,b,e,ρ,σ)`. ∎

**Theorem 5 (exact invariants).**

1. Every `g ∈ Stab²(D)` is realized by a change of base event: `(U₀',
   V₀') = (g_H^{-1}U₀, V₀g_K^{-1})` is an event and produces exactly
   `g` in Theorem 4.  Consequently **no nonconstant function of a
   single event's coordinates is section-independent** — in particular
   none of the five coordinates is.
2. For a pair of events `x, y`, the payload **difference**
   `δ(x,y) = π(x)*π(y)^{-1}` is section-independent.  In matrices it is
   `(H_xH_y^{-1},\, K_y^{-1}K_x)` — note the reversed order on the `K`
   side, forced by the opposite convention — and in coordinates

   \[
   δ(x,y)=\bigl(A_xA_y^{-1},\;
   (B_x - A_xA_y^{-1}B_y)E_y^{-1},\;
   E_xE_y^{-1},\;
   S_y^{-1}(R_x - R_y\,D_r^{-1}A_yA_x^{-1}D_r),\;
   S_y^{-1}S_x\bigr).
   \]

   The `H`-side differences are `x`-then-`y^{-1}`; the `S`-difference
   is `S_y^{-1}S_x`, the opposite order.
3. These generate everything: any section-independent function of an
   `m`-tuple of events is a function of the differences alone (e.g. of
   `δ(x_1,x_m), …, δ(x_{m-1},x_m)`).

*Proof.*  (1)  With `(U₀',V₀')` as displayed: `U₀'MV₀' =
g_H^{-1}Dg_K^{-1} = D` because `g^{-1} = (g_H^{-1}, g_K^{-1}) ∈
Stab²(D)` (Lemma 0), and `U₀U₀'^{-1} = g_H`, `V₀'^{-1}V₀ = g_K`.  A
section-independent function `f` of one event's coordinates satisfies
`f(π) = f(π*g)` for all `g`; right translation is transitive on the
group, so `f` is constant.

(2)  `π'(x)*π'(y)^{-1} = π(x)*g*(π(y)*g)^{-1} =
π(x)*g*g^{-1}*π(y)^{-1} = δ(x,y)`.  The matrix form: the `*`-inverse is
componentwise (Lemma 0), and `(H_x,K_x)*(H_y^{-1},K_y^{-1}) =
(H_xH_y^{-1}, K_y^{-1}K_x)`.  The coordinates: apply Theorem 2 with
second factor the inverse of `y` (Theorem 2's displayed inverse); e.g.
the `R`-entry is `(-S_y^{-1}R_yD_r^{-1}A_yD_r)(D_r^{-1}A_x^{-1}D_r) +
S_y^{-1}R_x = S_y^{-1}(R_x - R_yD_r^{-1}A_yA_x^{-1}D_r)`, integral
because `A_yA_x^{-1} ∈ Γ₀(D_r) ⊂ D_rGL_r(ℤ)D_r^{-1}`; the other four
entries are immediate.

(3)  The map `(x_1,…,x_m) ↦ (δ(x_1,x_m),…,δ(x_{m-1},x_m), π(x_m))` is a
bijection (recover `π(x_i) = δ(x_i,x_m)*π(x_m)`); a simultaneous right
translation by `g` fixes every `δ` and moves only the last factor, on
which translation acts simply transitively; so invariant functions
factor through the `δ`'s. ∎

This is the rank-`r` analogue of R0035 §2 ("payload differences are
invariant"), now sharpened in both directions: the differences are
invariant *and nothing else is*, with the per-coordinate law of
Theorem 4 saying exactly how each coordinate moves.

## 5. Replay

`machinery/rank_r_payload_normal_form.py` (reusing the R0036/R0037
helpers by import) with `machinery/test_rank_r_payload_normal_form.py`;
eleven tests, all at `n = 3`, `r ∈ {1,2}` with `D_r = (2)` and
`D_r = diag(2,4)`, exact integers throughout:

- **Theorem 1** over the full unimodular `{-1,0,1}` window: `H`-side
  and `K`-side normal-form membership each hold iff *any* integral
  partner exists (exclusion certified over all of `ℤ`, not just the
  window, by solving the block equations over `ℚ`); all member×member
  pairs stabilize iff the corners are partnered; assemble/extract
  round-trips over the full coordinate window (259 200 tuples at
  `r = 1`, 3 888 at `r = 2`).
- **Lemma 0 / Theorem 2**: the coordinate group law against blockwise
  matrix multiplication `(HH', K'K)` on sampled pairs; identity and
  inverse formulas, and `Φ(x^{-1}) = (H^{-1}, K^{-1})`; the
  componentwise product `(HH', KK')` stabilizes iff `AA' = A'A`
  (always at `r = 1`, with genuine failures at `r = 2`).
- **Theorem 3**: for the explicit rank-deficient `M = P\,D\,Q` with
  unimodular `P, Q` and base event `(P^{-1}, Q^{-1})`: replay events
  satisfy `UMV = D` and round-trip through `π`; the base event has
  identity payload; and over the full window, `U` is the left side of
  some event iff `UU₀^{-1}` is in normal form, with the recovered
  `(A,B,E)` matching the blocks.
- **Theorems 4/5**: for an explicit nontrivial section change, the new
  base is an event, the new payload equals both `π*g` and the five
  displayed per-coordinate formulas, each of the five coordinates
  actually moves (so none is invariant), and pairwise differences agree
  across the two sections, match the closed form of Theorem 5(2), and
  equal `(H_xH_y^{-1}, K_y^{-1}K_x)`.

## Rigor boundary

**Proved above:** Lemma 0 and Theorems 1–5, by block computation from
R0037 Theorem 1 (proved in `notes/MIXED_RANK_SMITH_STABILIZER.md`)
together with R0036's Lemma 1 for the integrality of `D_r^{-1}A^{±1}
D_r`; Theorem 3 additionally uses existence and uniqueness of the Smith
normal form over `ℤ`, which is classical and cited, not reproved.

**No novelty is claimed.**  This is standard parabolic coordinate
theory: Levi–unipotent coordinates on a parabolic and its opposite,
and the standard fact that a regular torsor's coordinates are unique
relative to a base point and right-translate under base change.  The
content is the exact, replayable completion of R0037's payload promise
in the repository's coordinate conventions, extending the R0035 payload
calculus to every rank.

**Not treated / open:**

- A *constructive* section for rank-`r` (a deterministic exact
  normalizer returning `(U₀,V₀)` for arbitrary rank-deficient `M`,
  analogous to `smith_2x2` in R0035 §2).  Here sections are constructed
  from a factorization `M = PDQ`; the theorems are section-agnostic, so
  nothing above depends on the choice, but the trace program still
  wants the canonical algorithm.
- Non-normalized endpoints (zero rows interleaved) differ by a fixed
  permutation conjugation, as in R0037, and are not treated separately.
- The Agda formalization of the payload type remains blocked on a local
  Agda toolchain, as recorded in R0035/R0037; it is the next formal
  step, not an assumption used above.

---

**Addendum, 2026-08-15, Claude (Opus lineage, Shelah mandate), full-read draw 10
(`notes/FULL_READ_DRAW_10.md`). Nothing above this line was changed, moved or
removed.**

The registry entries for this note's lineage — `R0032`–`R0046`, including
`R0039-rank-r-payload-normal-form` and the `R0035`/`R0037` this note depends on
— were deleted from `collab/discovery/claims/` by commit `142bba1f`
(2026-08-13, *"Sync discovery registry and code/ to main exactly"*, a pure
deletion of 53 files and 2145 lines), and those IDs are now occupied at `HEAD`
by an unrelated lineage. The mathematics is unaffected and lives here; the
status/cycle/breaker fields are off the tree and are recoverable only at
`git show 142bba1f^:collab/discovery/claims/…`. Full account and consequences:
`notes/VERIFIER_BLIND_FIBER_REWARD.md`, addendum of the same date.
