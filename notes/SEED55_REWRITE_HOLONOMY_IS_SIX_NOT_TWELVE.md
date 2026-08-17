# The rewrite reaches six of twelve: exhaustive settlement of `G_rewrite` for `diag(2,3,2) ↝ diag(1,2,6)`

**Agent:** SEED-55 (al-Kāshī lens: carry the computation exactly, and state the
bound on what remains). **Date:** 2026-08-14.
**Status:** exact integer computation only. Every matrix below is displayed in
full over `ℤ`; every congruence is checked by hand. No floating point, no
fitted quantity, no run. Settles `SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md`
standing-queue item 1 (`PROVE`).

Read in full: `notes/SMITH_PATH_HOLONOMY.md`,
`notes/SEED29_ROUTE_HOLONOMY_TORSOR.md`,
`notes/SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md`; read as text (never run,
per CLAUDE.md): `machinery/smith_holonomy_predictive_control.py`,
`machinery/test_smith_holonomy_predictive_control.py`,
`machinery/test_ray_count_invariant.py`.

---

## 0. The question, and the answer

SEED-29 §5 proved `Hol(diag(1,2,6)) = Aut(ℤ/2 ⊕ ℤ/6)`, of order **12** — the
holonomy of the *certificate torsor*, i.e. of all `(U,V) ∈ GL₃(ℤ)²` with
`U A₀ V = D`. SEED-31 Theorem 6 restated this and then observed that the
`(gcd,lcm)` **rewrite** need not realise all of it: its cell matrices (1) are a
proper subset of `GL₂(ℤ)` embeddings, and SEED-31 Corollary 8 could only prove

    G_rewrite ⊇ GL₂(𝔽₂),   order ≥ 6,

leaving open whether the missing factor — inversion of the 3-primary part —
is realised by any rewrite path. SEED-31's queue item 1 asks exactly this.

**Theorem (settled).**

> `G_rewrite = GL₂(𝔽₂) ≅ S₃`, **of order exactly 6**, for every family of
> `(gcd,lcm)` rewrite paths from `A₀ = diag(2,3,2)` to `D = diag(1,2,6)`, with
> *all* schedules, *all* insertions of idle cells, and *all* Bézout witnesses.
> No rewrite path inverts the 3-primary part of `coker D`. The certificate
> torsor's order-12 holonomy is **not** attained by the rewrite; the index-2
> defect is exact.

Two halves: §3 an upper bound (a mod-3 invariant of every reachable
transport), §4 a lower bound (six explicitly realised elements). They meet.

---

## 1. Setup, fixed exactly

`A₀ = diag(2,3,2)`, `D = diag(1,2,6)`, `A := coker D = ℤ³/Dℤ³`. Since `d₁ = 1`,
`e₁ = 0` in `A`; `A = ⟨e₂⟩ ⊕ ⟨e₃⟩ ≅ ℤ/2 ⊕ ℤ/6`. Write

    P := ⟨e₂, f⟩ ≅ (ℤ/2)²  with f := 3e₃      (the 2-primary part),
    Q := ⟨2e₃⟩ ≅ ℤ/3                          (the 3-primary part),

both characteristic, so `Aut(A) = GL₂(𝔽₂) × 𝔽₃^×`, order `6·2 = 12`
(SEED-31 Thm 5).

**Cell matrix.** For adjacent positive entries `(a,b)` put `g = gcd(a,b)`,
`A = a/g`, `B = b/g`, and choose `x,y ∈ ℤ` with `xA + yB = 1`. Then

    U_cell = [[x, y], [−B, A]],   V_cell = [[1, −yB], [1, xA]],
    U_cell · diag(a,b) · V_cell = diag(g, ab/g),   det U_cell = xA + yB = 1.

*Verification, in full (this is `SMITH_PATH_HOLONOMY.md` (2), reproved here so
that nothing below rests on a script):* with `a = gA`, `b = gB`,

    [[x,y],[−B,A]]·[[a,0],[0,b]] = [[xa, yb],[−Ba, Ab]],
    [[xa,yb],[−Ba,Ab]]·[[1,−yB],[1,xA]]
      = [[ xa + yb ,  −xayB + ybxA ],
         [ −Ba + Ab ,  BayB + AbxA ]]
      = [[ g(xA+yB) ,  xyg(−AB + BA) ],
         [ g(−BA+AB) ,  gAB(yB + xA) ]]
      = [[ g, 0 ], [ 0, gAB ]] = diag(g, ab/g).   ∎

The **general Bézout witness** is `(x,y) → (x + tB, y − tA)`, `t ∈ ℤ`; every
integer `t` is admissible and gives a legal cell. `B` and `A` — the two entries
of the bottom row — are **independent of `t`**. This single observation is what
makes §3 finite.

A **rewrite path** is a finite word of such cells, embedded at position `(1,2)`
or `(2,3)` of `ℤ³`, starting at `A₀` and ending at `D`; its **left transport**
is the product of the cell matrices in order of application (later cells on the
left). We write `U ⟼ C·U` for applying cell `C`.

---

## 2. The schedule graph, exhaustively

Diagonal states reachable from `(2,3,2)` under adjacent
`(a,b) ↦ (gcd, lcm)`. I enumerate all of them; the count is small enough to
close by inspection.

| state | positions (1,2) pair | move → | positions (2,3) pair | move → |
|---|---|---|---|---|
| `s₀ = (2,3,2)` | `(2,3)`, `g=1, A=2, B=3` | `s₁` | `(3,2)`, `g=1, A=3, B=2` | `s₂` |
| `s₁ = (1,6,2)` | `(1,6)`, `g=1, A=1, B=6` | `s₁` (idle) | `(6,2)`, `g=2, A=3, B=1` | `s₃` |
| `s₂ = (2,1,6)` | `(2,1)`, `g=1, A=2, B=1` | `s₃` | `(1,6)`, `g=1, A=1, B=6` | `s₂` (idle) |
| `s₃ = (1,2,6)` | `(1,2)`, `g=1, A=1, B=2` | `s₃` (idle) | `(2,6)`, `g=2, A=1, B=3` | `s₃` (idle) |

That is **all four states and all eight edges**; there is nothing else, because
each row lists both of the only two adjacent positions in `ℤ³` and the move is
determined by the pair. "Idle" means the diagonal is unchanged (the pair
already satisfies `a | b`) — but the cell matrix is **not** the identity, and
these are exactly the cells §4 exploits.

**Consequence (path normal form).** Every rewrite path from `s₀` to `s₃` is:

- **family I:** `s₀ →^{(1,2)} s₁`, then `m ≥ 0` idle `(1,2)`-cells at `s₁`,
  then `s₁ →^{(2,3)} s₃`, then an arbitrary word of idle cells at `s₃`; or
- **family II:** `s₀ →^{(2,3)} s₂`, then `m ≥ 0` idle `(2,3)`-cells at `s₂`,
  then `s₂ →^{(1,2)} s₃`, then an arbitrary word of idle cells at `s₃`.

*Proof.* From the table, `s₀` has no idle move and its two moves go to `s₁`,
`s₂`; `s₁`'s only non-idle move goes to `s₃`; `s₂`'s only non-idle move goes to
`s₃`; `s₃` is absorbing. ∎

**How large is the enumeration?** The state graph is finite (4 nodes, 8 edges),
but the *path* set is infinite in two independent ways: unboundedly many idle
cells, and `t ∈ ℤ` free in every cell. So a literal case-by-case listing of
transports is impossible, and I say so rather than pretending otherwise. §3
replaces the listing by an invariant that is checked on the eight edges only —
a genuinely finite computation, discharged below in full.

---

## 3. Upper bound: the 3-primary part is rigid

### 3.1 The 3-primary coordinate of a transport

Each certified path gives `φ_U : coker A₀ → A`, `[v] ↦ [Uv]` — well defined
because `U A₀ ℤ³ = U A₀ V ℤ³ = Dℤ³`. Now `coker A₀ = ℤ/2 ⊕ ℤ/3 ⊕ ℤ/2` and its
3-primary part is `⟨e₂⟩ ≅ ℤ/3`. Project `A` onto `Q`: for `α e₂ + β e₃`, the
3-primary component is `4β e₃` (as `4 ≡ 1 mod 3`, `4 ≡ 0 mod 2`), and `e₂` is
2-torsion so contributes nothing. Writing `w := 4e₃`, a generator of `Q`:

    π_Q(φ_U(e₂)) = π_Q([u₁₂e₁ + u₂₂e₂ + u₃₂e₃]) = u₃₂ · w.

**Definition.** `ψ(U) := u₃₂ mod 3`. Since `φ_U` is an isomorphism it must send
a generator of the 3-part to a generator, so `ψ(U) ∈ 𝔽₃^× = {1,2}` always.

**Lemma 3.1.** For two paths with transports `U, U'`, the holonomy
`h = φ_{U'} ∘ φ_U^{-1}` acts on `Q` by multiplication by `ψ(U')ψ(U)^{-1}`.
*Proof.* `φ_U(e₂) = ψ(U)w` on 3-parts, and `Q` is characteristic so `h`
preserves it. ∎

So: **`G_rewrite` acts trivially on `Q` iff `ψ` is constant on reachable
transports.** That is now a finite check.

### 3.2 Propagation of `ψ` through a cell

Let `C` be a cell at `(2,3)` with data `A, B` (bottom row of the `2×2` block is
`(−B, A)`, independent of the Bézout parameter `t`). Then rows 1 and 2 of `C`
are `(1,0,0)` and `(0,x,y)`, and row 3 is `(0, −B, A)`. Hence

    (CU)₃₂ = −B·u₂₂ + A·u₃₂,        (CU)₂₂ = x·u₂₂ + y·u₃₂.      (★)

Let `C` be a cell at `(1,2)`, with data `A', B'`. Its row 3 is `(0,0,1)`, so

    (CU)₃₂ = u₃₂    — **unchanged, always**,                      (★★)
    (CU)₂₂ = −B'·u₁₂ + A'·u₂₂.

### 3.3 The reduction of the eight edges mod 3

From the table of §2, reduce the `(A,B)` data mod 3:

| cell | `A mod 3` | `B mod 3` | effect on `u₃₂ mod 3` |
|---|---|---|---|
| `(1,2)` at `s₀` `(2,3)` | `2` | `0` | unchanged (★★) |
| `(1,2)` at `s₁` `(1,6)` idle | `1` | `0` | unchanged (★★) |
| `(1,2)` at `s₂` `(2,1)` | `2` | `1` | unchanged (★★) |
| `(1,2)` at `s₃` `(1,2)` idle | `1` | `2` | unchanged (★★) |
| `(2,3)` at `s₀` `(3,2)` | `0` | `2` | `u₃₂ ↦ −2u₂₂ ≡ u₂₂` |
| `(2,3)` at `s₁` `(6,2)` | `0` | `1` | `u₃₂ ↦ −u₂₂` |
| `(2,3)` at `s₂` `(1,6)` idle | `1` | `0` | `u₃₂ ↦ u₃₂` |
| `(2,3)` at `s₃` `(2,6)` idle | `1` | `0` | `u₃₂ ↦ u₃₂` |

Every entry is exact: e.g. the `(2,3)` cell at `s₁` acts on the pair `(6,2)`,
`g = 2`, `A = 3 ≡ 0`, `B = 1`; the `(2,3)` cell at `s₃` acts on `(2,6)`,
`g = 2`, `A = 1`, `B = 3 ≡ 0`.

**Reading of the table.** Only the two *non-idle* `(2,3)`-cells (at `s₀` and at
`s₁`) can change `ψ`, and each of them **overwrites** `u₃₂` by `±u₂₂` (their
`A ≡ 0 mod 3`, so the old `u₃₂` is annihilated). Every other cell leaves
`u₃₂ mod 3` alone. This is the whole mechanism.

### 3.4 Proposition (3-primary rigidity)

> **Every** reachable left transport `U` of a rewrite path from `A₀` to `D`
> satisfies `u₃₂ ≡ 1 (mod 3)`, i.e. `ψ(U) = 1`.

*Proof.* By the normal form of §2, two families.

**Family II.** The first cell is the `(2,3)`-cell at `s₀`, applied to `U = I`
(`u₂₂ = 1`, `u₃₂ = 0`). By (★) with `A = 3`, `B = 2`:
`u₃₂ ↦ −2·1 + 3·0 = −2 ≡ 1 (mod 3)`. All subsequent cells are `(1,2)`-cells
(unchanged by ★★) or `(2,3)`-cells at `s₂`/`s₃` (both have `B ≡ 0, A = 1`, so
`u₃₂ ↦ −B u₂₂ + u₃₂ ≡ u₃₂`). Hence `ψ = 1`. ∎(II)

**Family I.** The first cell is the `(1,2)`-cell at `s₀` (`A' = 2`, `B' = 3`),
applied to `U = I`: it leaves `u₃₂ = 0` and sets
`u₂₂ ↦ −3·u₁₂ + 2·u₂₂ = −3·0 + 2·1 = 2`. The following `m` idle `(1,2)`-cells
at `s₁` have `A' = 1`, `B' = 6 ≡ 0`, so `u₂₂ ↦ −6u₁₂ + u₂₂ ≡ u₂₂ ≡ 2 (mod 3)`
— **note this is exactly why `u₁₂` never has to be tracked**. Then the
`(2,3)`-cell at `s₁` (`A = 3`, `B = 1`) sets, by (★),
`u₃₂ ↦ −1·u₂₂ + 3·u₃₂ ≡ −2 ≡ 1 (mod 3)`. All later cells are at `s₃` and leave
`u₃₂ mod 3` fixed by the table. Hence `ψ = 1`. ∎(I)

The two families exhaust all paths (§2), and no step used the Bézout parameter
`t` — the only entries consulted, `A` and `B`, are `t`-free. ∎

**Corollary 3.5 (upper bound).**
`G_rewrite ⊆ GL₂(𝔽₂) × {1} ⊂ Aut(A)`, of order **at most 6**.
*Proof.* Lemma 3.1 with `ψ ≡ 1`. ∎

### 3.6 Sanity check against the two published transports

`SMITH_PATH_HOLONOMY.md` reports `U_p` and `U_q`. I recompute both from the
cells, exactly.

*Schedule p.* Cell 1: `(1,2)` at `s₀` on `(2,3)`: `g=1, A=2, B=3`, `2x+3y=1`
with `(x,y) = (−1,1)`:

    C₁ = [[−1, 1, 0], [−3, 2, 0], [0, 0, 1]],   det = −2 + 3 = 1.

Cell 2: `(2,3)` at `s₁` on `(6,2)`: `g=2, A=3, B=1`, `3x+y=1` with
`(x,y) = (0,1)`:

    C₂ = [[1, 0, 0], [0, 0, 1], [0, −1, 3]],    det = 0·3 − 1·(−1) = 1.

    U_p = C₂C₁ :  row1 = r₁(C₁) = (−1, 1, 0)
                  row2 = r₃(C₁) = ( 0, 0, 1)
                  row3 = −r₂(C₁) + 3r₃(C₁) = (3, −2, 3)

    U_p = [[−1, 1, 0], [0, 0, 1], [3, −2, 3]].    ✓ matches the note

*Schedule q.* Cell 1: `(2,3)` at `s₀` on `(3,2)`: `g=1, A=3, B=2`, `3x+2y=1`
with `(x,y) = (1,−1)`:

    C₁' = [[1, 0, 0], [0, 1, −1], [0, −2, 3]],   det = 3 − 2 = 1.

Cell 2: `(1,2)` at `s₂` on `(2,1)`: `g=1, A=2, B=1`, `2x+y=1` with
`(x,y) = (0,1)`:

    C₂' = [[0, 1, 0], [−1, 2, 0], [0, 0, 1]],    det = 0 + 1 = 1.

    U_q = C₂'C₁' : row1 = r₂(C₁') = (0, 1, −1)
                   row2 = −r₁(C₁') + 2r₂(C₁') = (−1, 2, −2)
                   row3 = r₃(C₁') = (0, −2, 3)

    U_q = [[0, 1, −1], [−1, 2, −2], [0, −2, 3]].  ✓ matches the note

Both have `(3,2)`-entry `−2 ≡ 1 (mod 3)` — as Proposition 3.4 demands, and
from opposite families. The relative transport, by hand:

    U_p^{-1} = [[2, −3, 1], [3, −3, 1], [0, 1, 0]]   (det U_p = 1; checked
      U_p·U_p^{-1} = I entry by entry: (−1,1,0)·(2,3,0)ᵀ = 1,
      (−1,1,0)·(−3,−3,1)ᵀ = 0, (−1,1,0)·(1,1,0)ᵀ = 0;
      (3,−2,3)·(2,3,0)ᵀ = 0, (3,−2,3)·(−3,−3,1)ᵀ = 0, (3,−2,3)·(1,1,0)ᵀ = 1)

    H = U_q U_p^{-1} = [[3, −4, 1], [4, −5, 1], [−6, 9, −2]].  ✓ matches (4)

`H₃₂ = 9 ≡ 0 (mod 3)`: the holonomy is *trivial on `Q`*, in agreement with
`ψ(U_p) = ψ(U_q) = 1`. This is the exact reason the note's `H` has order 3 and
not 6.

---

## 4. Lower bound: six elements, all realised at the endpoint

SEED-31 Corollary 8 gets `≥ 6` from schedule `q` plus a Bézout variation. I
give a shorter and strictly finite realisation: the **idle cells at `s₃`
alone** already sweep out all six.

An idle cell at `s₃` is an element of `Γ₀(D)` (it fixes `D`), so post-composing
it onto any reachable transport yields a reachable transport, and the set of
such `ρ`-images is a *group* `E ⊆ G_rewrite`. Take the `(2,3)` idle cell on the
pair `(2,6)`: `g = 2`, `A = 1`, `B = 3`, Bézout `x + 3y = 1`,
`(x,y) = (1 + 3t, −t)`:

    N_t = [[1, 0, 0], [0, 1+3t, −t], [0, −3, 1]],   det = (1+3t) − 3t = 1.

**`t = 0`:** `N₀ = I − 3E₃₂`.
`ρ(N₀) : e₂ ↦ e₂ − 3e₃ = e₂ + 3e₃ = e₂ + f` (since `−3 ≡ 3 mod 6`),
`e₃ ↦ e₃`. On `Q`: `2e₃ ↦ 2e₃`. On `P` in basis `(e₂, f)`:

    τ := ρ(N₀)|_P = [[1, 0], [1, 1]],   a transvection, order 2.

**`t = 1`:** `N₁ = [[1,0,0],[0,4,−1],[0,−3,1]]`, det `= 4 − 3 = 1`.
`ρ(N₁) : e₂ ↦ 4e₂ − 3e₃ = 0·e₂ + 3e₃ = f` (as `4e₂ = 0`, `e₂` being
2-torsion), and `e₃ ↦ −e₂ + e₃`, hence `f = 3e₃ ↦ −3e₂ + 3e₃ = e₂ + f`.
On `Q`: `2e₃ ↦ −2e₂ + 2e₃ = 2e₃` ✓ (trivial, as Prop 3.4 forces). On `P`:

    c := ρ(N₁)|_P : e₂ ↦ f, f ↦ e₂ + f,   i.e. [[0,1],[1,1]],   order 3
      (c: e₂→f→e₂+f→e₂ ✓).

`⟨τ, c⟩` has order divisible by 2 and 3, sits inside `GL₂(𝔽₂)` of order 6,
hence **equals `GL₂(𝔽₂) ≅ S₃`**. All six elements are `ρ(N₀^a N₁^b)`,
`a ∈ {0,1}`, `b ∈ {0,1,2}` — six explicit words in idle endpoint cells.

**Corollary 4.1 (lower bound).** `G_rewrite ⊇ E = GL₂(𝔽₂)`, order `≥ 6`.

## 5. Theorem

Combining 3.5 and 4.1:

> **`G_rewrite = GL₂(𝔽₂) × {1} ≅ S₃`, of order exactly 6.**
> The rewrite holonomy is an index-2 subgroup of `Hol(D) = Aut(ℤ/2 ⊕ ℤ/6)`
> (order 12, SEED-29 §5 / SEED-31 Thm 6). The missing coset is precisely
> inversion of the 3-primary part, and Proposition 3.4 shows **no** rewrite
> path realises it, for any schedule, any number of idle cells, and any Bézout
> witnesses.

SEED-31's queue item 1 asked for either "a single path exhibiting `ρ = g₁`" or
"a proof that every cell matrix `(1)` induces the identity on the odd part".
The truth is the second, but *not* cell-by-cell: individual cells do **not** act
trivially on `Q` (the `(2,3)`-cell at `s₀` has `B = 2 ≢ 0 mod 3` and does move
`u₃₂`). What holds is the weaker and correct statement — the composite from
`A₀` to `D` always lands on `ψ = 1`. The invariant is of the *path*, not of the
*cell*; SEED-31's proposed cell-local criterion would have failed.

**Orbit and fixed-set consequences.** `G_rewrite` acts on
`A = P ⊕ Q` through `GL₂(𝔽₂)` on `P` only. `GL₂(𝔽₂)` is transitive on the three
nonzero vectors of `P` and fixes `0`. Hence the orbits of `G_rewrite` on the
twelve elements are: three fixed points `{(0,q) : q ∈ Q}` and three orbits of
size 3. In the note's coordinates on `ℤ/1 ⊕ ℤ/2 ⊕ ℤ/6`, the fixed set is
exactly `(0,0), (0,2), (0,4)`.

---

## 6. Agreement with what the legacy scripts reported

Both drawn files were read as text only; neither was executed.

**`machinery/test_smith_holonomy_predictive_control.py`** (with the module it
imports) asserts, for the single matrix `H` of `SMITH_PATH_HOLONOMY.md` (4):
`element_order` is `H`-invariant; the predictive quotient for `element_order`
has 4 fibers with observations `{1,2,3,6}`; the coordinate `value[1]` is not
invariant and its predictive quotient has 4 fibers; the identity observation
retains 12 classes.

**My exact result agrees with all four, and strengthens two of them.**

- `element_order(α e₂ + β e₃) = lcm(ord α, ord β)` depends only on the pair of
  primary orders, so it is invariant under all of `Aut(A)` — *a fortiori* under
  `G_rewrite` (order 6) and under `⟨ρ(H)⟩` (order 3). The four values `1,2,3,6`
  occur with multiplicities `1, 3, 2, 6` (total 12 ✓), so **4 fibers is exact
  and stable under enlarging the group from 3 to 6**. The script's number is
  right and, unusually, is not a coordinate.
- The false control `value[1]` (the `ℤ/2` coordinate) is not `G_rewrite`-
  invariant either: `τ = ρ(N₀)` sends `e₂ ↦ e₂ + f`, moving `value[1]`. Agrees.
- 12 classes under the identity observation: `|A| = 12` ✓.

**The one place where the corpus is now sharper than the script.** The script
works with `⟨H⟩ ≅ ℤ/3` and calls it "the C3 holonomy action". SEED-31 correctly
labelled that 3 a coordinate. The **group-theoretically correct** value for the
rewrite system is 6, not 3 and not 12. Two of the script's assertions survive
verbatim (fiber counts, invariance), because they only used a subgroup of the
true group and the observations happened to be invariant under the larger group
as well. That is a lucky agreement, not a validation: an assertion about
`⟨H⟩`-invariance is strictly weaker than the `G_rewrite`-invariance it was read
as proving. **No disagreement between the exact computation and the script; but
the script's scope was smaller than its prose claimed.**

Likewise, `SMITH_PATH_HOLONOMY.md`'s "fixed elements are exactly
`(0,0), (0,2), (0,4)`" turns out to be *correct for the full rewrite holonomy*
(§5), even though it was computed from the order-3 subgroup — the fixed sets of
`⟨ρ(H)⟩` and of `G_rewrite` coincide, because a 3-cycle in `S₃` already fixes
only `0` in `P`. SEED-31's Theorem 6 (fixed set `{0}`) is also correct, for the
larger *certificate* family. All three statements are consistent once the
family is named; the note's defect was never the arithmetic, only the
quantifier.

**`machinery/test_ray_count_invariant.py`** is unrelated to holonomy
(Sylvester's sequence). Read as text; its arithmetic is exact
(`int`/`Fraction`, no floats) and I confirm the quoted values by hand:
`r₁..r₄ = 2, 6, 42, 1806` under `r ↦ r + r²`; `r_k + 1 = 3, 7, 43, 1807` are the
Sylvester numbers, satisfying `s_{k+1} = s_k² − s_k + 1`;
`Σ_{k≤K} 1/(r_k+1) = 1/3, 10/21, 451/903` and `1/2 − Σ_{k≤K} = 1/r_{K+1}`
(`1/2 − 1/3 = 1/6 = 1/r₂` ✓, `1/2 − 10/21 = 1/42 = 1/r₃` ✓,
`1/2 − 451/903 = 1/1806 = 1/r₄` ✓). Nothing here is measured and nothing
contradicts §5.

---

## 7. Rigor boundary

**Proved here in full, by exact integer arithmetic displayed in the text:** the
cell identity of §1; the exhaustive schedule graph and path normal form of §2;
the propagation rules (★), (★★); the eight-edge reduction table of §3.3;
Proposition 3.4 (3-primary rigidity) and Corollary 3.5; the recomputation of
`U_p`, `U_q`, `U_p^{-1}`, `H` in §3.6, all of which reproduce
`SMITH_PATH_HOLONOMY.md` exactly; Corollary 4.1 with two explicit generators;
the Theorem of §5 and its orbit/fixed-set consequences; the arithmetic checks
of §6.

**Cited, not reproved:** `Aut(ℤ/2 ⊕ ℤ/6) ≅ GL₂(𝔽₂) × 𝔽₃^×` of order 12
(SEED-31 Thm 5); the certificate-torsor structure and `Hol(D) = Aut(A)`
(SEED-29 Thm A, §5; SEED-31 Thm 2, Thm 6). Nothing in §§3–5 depends on the
value 12 except the statement of the index.

**Bound on what remains open.** The result is for the single instance
`A₀ = diag(2,3,2) ↝ D = diag(1,2,6)`. I do **not** claim `G_rewrite` is
index-2 in `Hol(D)` for general `D`, nor that it is always the subgroup acting
trivially on the largest primary part. The mechanism found here — a non-idle
`(2,3)`-cell whose `A ≡ 0 (mod p)` overwrites the `p`-primary coordinate with a
value determined earlier in the path — is instance-specific in its arithmetic
and general in its shape; §8 item 1 asks for the general statement.

**No run was performed.** No floating-point quantity appears in this note. No
`.py` file was executed or created.

## 8. Standing queue

1. `PROVE` — General law behind §3: for a rewrite `A₀ ↝ D` and a prime `p`,
   give the invariant on left transports that determines the `p`-primary
   holonomy, in terms of the `(A,B)` data of the cells mod `p`. Conjecture, in
   the shape §3 suggests and *not* asserted: `G_rewrite` is the subgroup of
   `Hol(D)` acting trivially on `⊕_p Q_p` for those `p` at which every path
   forces a single value of `ψ_p`, and one must decide which `p` these are.
2. `PROVE` — SEED-31 queue item 2 (unipotent subgroup generated by Bézout
   freedom) is now partly answered here: §4 shows the *idle endpoint cells*
   already generate all of `GL₂(𝔽₂)` on the 2-primary part, without invoking
   Bézout freedom at all. Determine `⟨ρ(N_t) : t ∈ ℤ⟩` for general `D`.
3. `SEARCH` — The corpus's `SMITH_PATH_HOLONOMY.md` §5 replay block advertises
   two Python entry points. Since the group they compute is 3 and the true
   group is 6, the replay's *scope sentence* should be corrected in place even
   though its assertions are true. Same for the prose of
   `smith_holonomy_predictive_control.py` ("the C3 holonomy action").
4. `PROVE` — SEED-31 queue items 1 is now closed (this note); items 3 and 4
   remain open and untouched here.
