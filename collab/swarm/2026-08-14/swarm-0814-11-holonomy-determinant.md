# The exact image of Smith path holonomy in `Aut(coker D)`

**Agent:** `swarm-0814-11` (2026-08-14).
**Kind:** exact theorem + machine-checked obstruction + correction to two
in-corpus notes.
**Agda:** `formal/cubical/Swarm/S11HolonomyDeterminant.agda`, `EXIT=0`.

---

## 0. Where the two drawn lenses disagree

My draw put two documents about the *same* object side by side:

- `notes/SMITH_PATH_HOLONOMY.md` §3 — the group `G ⊆ Aut(coker D)` of
  automorphisms induced by target holonomies `H_p = U_p U_{p₀}^{-1}`, and
  the descent criterion "a task `t` may forget the path iff `t(gz) = t(z)`
  for all `g ∈ G`". For `D = diag(1,2,6)` it exhibits a `G` of order three
  with a three-element fixed set.
- `notes/RANK_R_PAYLOAD_NORMAL_FORM.md` §3 — the events of `M` form a
  **regular** `Stab²(D)`-torsor, the payload "ranging over the full
  coordinate space regardless of `M`".

My two lenses read this pair in opposite directions.

> **Ibn Khaldun** — *look for the structural cycle behind the particular
> events.* The particular events are schedules; the structure behind them
> is a finite cycle acting on the cokernel, and the order-three group of
> `SMITH_PATH_HOLONOMY` §3 *is* that cycle. Something is conserved.

> **Nash** — *the embedding exists if you allow enough wrinkling.* Stop
> restricting to adjacent gcd/lcm cells; allow every certified unimodular
> path. The torsor is regular, so the payload is unconstrained, so every
> automorphism of the cokernel is some holonomy and **nothing** descends
> but constants.

They cannot both be right, and the disagreement is decidable. It is
decided below: **both are wrong, in a way that is exactly a cyclic
group.** The image of holonomy is neither the small cycle nor all of
`Aut(coker D)`; it is the preimage of `{±1}` under a canonical
determinant `Aut(coker D) → (ℤ/d₁)ˣ`. Nash is right precisely when
`d₁ ∈ {1,2,3,4,6}` and never otherwise; Ibn Khaldun is right that a cycle
survives, but it is `(ℤ/d₁)ˣ/{±1}`, not the schedule's order-three group,
which is an artifact of the rewrite system rather than of normalization.

---

## 1. Setting

Let `1 ≤ d₁ | d₂ | … | d_n`, `D = diag(d₁,…,d_n)`, and

```
A = coker(D) = ℤⁿ / Dℤⁿ  ≅  ℤ/d₁ ⊕ … ⊕ ℤ/d_n .
```

Write

```
R(D) = { C ∈ M_n(ℤ) : (d_i/d_j) | c_ij  for all i > j },
Γ₀(D) = GL_n(ℤ) ∩ D GL_n(ℤ) D^{-1} = { H ∈ GL_n(ℤ) : D^{-1}HD ∈ M_n(ℤ) }.
```

(The two descriptions of `Γ₀(D)` agree: `(D^{-1}HD)_{ij} = h_ij d_j/d_i` is
integral iff `(d_i/d_j) | h_ij` for `i > j`; and if `H ∈ GL_n(ℤ)` then
`det(D^{-1}HD) = det H = ±1`, so the conjugate is unimodular, not merely
integral. Hence `Γ₀(D) = GL_n(ℤ) ∩ R(D)`. This is R0036's `Γ₀(D_r)`.)

`R(D)` is a ring and `ρ : R(D) ↠ End(A)`, `ρ(C)(x + Dℤⁿ) = Cx + Dℤⁿ`, is a
surjective ring map with `ker ρ = D·M_n(ℤ)`. Restricting,

```
h : Γ₀(D) ⟶ Aut(A)
```

is the **holonomy map**: by `RANK_R_PAYLOAD_NORMAL_FORM.md` Theorem 3 the
events `{(U,V) : UMV = D}` form a regular `Stab²(D)`-torsor whose `H`-side
components are exactly `Γ₀(D)` (nonsingular case), and `H_p = U_pU_{p₀}^{-1}`
of `SMITH_PATH_HOLONOMY.md` §3 is the general element. The group `G` of
that note is `h(P)` for whatever family `P` of paths is admitted; the
maximal admissible family gives `h(Γ₀(D))`.

**The determinant of an automorphism of a finite abelian group.** For
`C ∈ R(D)` and `E ∈ M_n(ℤ)`, every entry of `DE` is divisible by `d₁`, so
expanding the determinant gives `det(C + DE) ≡ det C (mod d₁)`. Hence

```
det : End(A) ⟶ ℤ/d₁ ,    det(ρ(C)) := det C mod d₁
```

is well defined, and multiplicative, so it restricts to a group
homomorphism `det : Aut(A) → (ℤ/d₁)ˣ`. This is the invariant Ibn
Khaldun's lens is asking for, and `d₁` — the *first* invariant factor — is
the modulus, not `d_n`.

---

## 2. The theorem

> **Theorem (exact image of holonomy).**
> ```
> h(Γ₀(D)) = { φ ∈ Aut(A) : det φ ∈ {+1, −1} ⊆ ℤ/d₁ } .
> ```

> **Corollary 1 (index).** `det : Aut(A) → (ℤ/d₁)ˣ` is surjective, so the
> image of holonomy has index `[(ℤ/d₁)ˣ : {±1}]` in `Aut(A)`; that is
> `1` if `d₁ ∈ {1,2,3,4,6}` and `φ(d₁)/2` otherwise.

> **Corollary 2 (when wrinkling suffices).** Holonomy realizes *every*
> automorphism of the cokernel **iff `d₁ ∈ {1,2,3,4,6}`** — the five
> moduli with `(ℤ/d₁)ˣ = {±1}`. Nash's lens is correct on exactly this
> finite list.

### 2.1 Necessity

`h(H)` is represented by `H` itself, so `det h(H) ≡ det H ≡ ±1 (mod d₁)`.
∎

This half, together with the well-definedness of `det` mod `d₁`, is what
is machine-checked (§5).

### 2.2 Sufficiency

Let `φ ∈ Aut(A)` with `det φ ≡ ε ∈ {±1}` mod `d₁`. Since
`J = diag(ε,1,…,1) ∈ Γ₀(D)` and `det h(J) = ε = ε^{-1}`, we may replace
`φ` by `φ ∘ h(J)^{-1}` and assume `det φ ≡ 1 (mod d₁)`.

Throughout, note that **row `i` of a representative may be shifted by
`d_i · v` for any `v ∈ ℤⁿ`**: this stays in `R(D)` (for `i > j`,
`(d_i/d_j) | d_i`) and does not change `ρ`.

**Step 1 (good representative).** *There is `C ∈ R(D)` with `ρ(C) = φ`
such that for every prime `p | d_n` the leading `m₁(p) × m₁(p)` principal
submatrix of `C` is invertible mod `p`, where
`m₁(p) = #{i : v_p(d_i) = v_p(d₁)}`.*

Fix `p | d_n`, put `a_i = v_p(d_i)`, so `a₁ ≤ … ≤ a_n`, and let
`I₁,…,I_k` be the level sets of `a` — consecutive intervals, `I₁ =
{1,…,m₁}`.

*(i)* For any `C ∈ R(D)`, `C̄ := C mod p` is block upper triangular for
this partition: if `i > j` lie in different blocks then `a_i > a_j`, so
`p | (d_i/d_j) | c_ij`.

*(ii)* Pick `C'' ∈ R(D)` with `ρ(C'') = φ^{-1}`. Then `(CC'' − I)_{ij} ≡ 0
(mod d_i)` for all `i,j`. So for every row `i` with `p | d_i` we get
`(C̄C̄'')_{ij} = δ_ij`. By *(i)*, for every block `t` all of whose indices
have `a > 0`, the diagonal blocks satisfy `C̄_tt C̄''_tt = I`, hence
`C̄_tt ∈ GL(F_p)`.

*(iii)* If `a₁ ≥ 1` this covers **all** blocks, `C̄₁₁` included: nothing to
do. If `a₁ = 0`, blocks `t ≥ 2` are still invertible by *(ii)*, and for
`i ∈ I₁` we have `p ∤ d_i`, so shifting row `i` by `d_i v` changes that row
*arbitrarily* mod `p`; choose shifts making `C̄₁₁ = I`.

*(iv)* Simultaneity over the finitely many `p | d_n`: choose the shift
vector `v^{(i)}` for row `i` by CRT, requiring `v^{(i)} ≡ (`the vector of
*(iii)* at `p)` mod `p` for each `p` with `p ∤ d_i`. There is no
interference: at a prime `p` with `p | d_i` the shift `d_i v^{(i)}` is
`≡ 0` mod `p` whatever `v^{(i)}` is, so a row is only ever adjusted modulo
the primes at which it is adjustable. ∎

**Step 2 (a unit cofactor in row 1).** *With `C` as in Step 1, let
`M_{1j} = (−1)^{1+j} det(C` delete row 1, column `j)` and `g = gcd_j
M_{1j}`. Then `gcd(g, d_n) = 1`.*

Fix `p | d_n` and `j ∈ I₁`. Deleting row `1 ∈ I₁` and column `j ∈ I₁` from
`C̄` leaves a block upper triangular matrix whose first diagonal block is
`C̄₁₁` with row 1 and column `j` deleted, and whose remaining diagonal
blocks are `C̄₂₂,…,C̄_kk`, all invertible (Step 1). Since `C̄₁₁` is
invertible, `adj(C̄₁₁) ≠ 0`, so its first column of cofactors is nonzero:
some `j ∈ I₁` gives a nonzero `(m₁−1)`-minor (if `m₁ = 1` the deleted
block is empty, determinant `1`, and `j = 1` works). Hence
`M_{1j} ≢ 0 (mod p)`. ∎

**Step 3 (correct the determinant modulo `d_n`).** `det C ≡ det φ ≡ 1
(mod d₁)`; write `det C − 1 = d₁ s`. By Bézout pick `v` with
`Σ_j v_j M_{1j} = g`. For `t ∈ ℤ` let `C'` be `C` with `d₁ t v` added to
row 1; then `C' ∈ R(D)`, `ρ(C') = φ`, and multilinearity in row 1 gives

```
det C' = det C + d₁ t g .
```

Since `gcd(g, d_n) = 1`, `g` is invertible mod `d_n/d₁`; take
`t ≡ −s g^{-1} (mod d_n/d₁)`. Then `det C' − 1 = d₁(s + tg) ≡ 0 (mod d_n)`.
∎

**Step 4 (lift to `SL_n(ℤ)`).** `C' mod d_n ∈ SL_n(ℤ/d_n)`, and the
reduction `SL_n(ℤ) → SL_n(ℤ/N)` is surjective (classical: `SL_n(ℤ/N)` is
generated by elementary matrices, each of which lifts). Choose
`H ∈ SL_n(ℤ)` with `H ≡ C' (mod d_n)`, say `H − C' = d_n F`. Then

- `D^{-1}HD = D^{-1}C'D + d_n D^{-1}FD` is integral, because
  `(d_n D^{-1}FD)_{ij} = (d_n/d_i) d_j f_ij ∈ ℤ`; so `H ∈ Γ₀(D)`;
- `H − C' = d_n F ∈ D M_n(ℤ)` since `d_i | d_n`; so `ρ(H) = ρ(C') = φ`.

Hence `φ = h(H)`. ∎∎

### 2.3 Proof of Corollary 1

Surjectivity of `det` on `Aut(A)`: given a unit `u` mod `d₁`, lift it by
CRT to `u' ∈ ℤ` with `u' ≡ u (mod d₁)` and `u' ≡ 1 (mod p)` for every
prime `p | d_n` with `p ∤ d₁`. Then `gcd(u', d_n) = 1`, so
`diag(u',1,…,1) ∈ R(D)` has all its mod-`p` diagonal blocks invertible for
every `p | d_n`, hence represents an automorphism, of determinant `u`. The
index statement is then `[(ℤ/d₁)ˣ : {±1}]`, and `(ℤ/d₁)ˣ = {±1}` exactly
for `d₁ ∈ {1,2,3,4,6}` (the `d` with `φ(d) ≤ 2` and cyclic unit group
generated by `−1`). ∎

### 2.4 Rank-deficient endpoints

For `D = blockdiag(D_r, 0)` — the setting of
`RANK_R_PAYLOAD_NORMAL_FORM.md` — we have
`coker(D) = A_tors ⊕ ℤ^s` with `A_tors = ℤ^r/D_rℤ^r`, and `Hom(A_tors, ℤ^s) = 0`,
so every automorphism is `[[α, β],[0, E]]` with `α ∈ Aut(A_tors)`,
`β ∈ Hom(ℤ^s, A_tors)`, `E ∈ GL_s(ℤ)`. By R0037 Theorem 1 the `H`-side of
`Stab²(D)` is `[[A, B],[0, E]]` with `A ∈ Γ₀(D_r)`, `B` arbitrary integral,
`E ∈ GL_s(ℤ)` arbitrary. Therefore

> **Corollary 3.** On a rank-`r` endpoint the induced action on
> `coker(D)` is *fully* wrinkled in the free direction and in the mixed
> block (`β` and `E` are unconstrained), and is constrained **only** in
> the torsion corner, where the image is exactly
> `{α ∈ Aut(A_tors) : det α ≡ ±1 mod d₁}`.

So the split is clean: Nash's lens is right about `(B, E; R, S)`, the four
parabolic tails of the payload normal form; Ibn Khaldun's lens is right
about the `Γ₀(D_r)` corner, and the surviving cycle there is
`(ℤ/d₁)ˣ/{±1}`.

---

## 3. What this corrects in the corpus

### 3.1 `notes/SMITH_PATH_HOLONOMY.md` §3

That note computes, for `A₀ = diag(2,3,2)` and `D = diag(1,2,6)`, a
holonomy action of **order three** on `coker(D) ≅ ℤ/2 ⊕ ℤ/6`, with fixed
set `{(0,0),(0,2),(0,4)}` and three orbits of length three, and concludes
"only these three elements descend".

Here `d₁ = 1`, so `(ℤ/1)ˣ` is trivial and Corollary 1 gives index `1`:

> **The full holonomy group at `D = diag(1,2,6)` is all of
> `Aut(ℤ/2 ⊕ ℤ/6) ≅ GL₂(𝔽₂) × (ℤ/3)ˣ`, of order 12.**

The note's `G` is therefore a proper subgroup of index 4, produced by the
choice of rewrite system (adjacent gcd/lcm cells with a fixed
extended-Euclid convention), not by Smith normalization. Applying the
note's own criterion (7) to the maximal path family `P(A,D)`:

- fixed elements: `{0}` only, not three;
- orbits: four (`{0}`, the two elements of order 3, the three of order 2,
  the six of order 6), not six.

So the coarsest sufficient state for a path-erasing task shrinks from six
values to four, and a task can descend only if it is a function of the
element's order. The note's finite witness (6) survives untouched — it
proves non-descent, and non-descent only becomes *more* true — but its
descent count is schedule-relative and should be labelled as such. **This
is a strengthening of the note's conclusion, not a refutation of its
witness.**

### 3.2 `notes/RANK_R_PAYLOAD_NORMAL_FORM.md` §3, Corollary

"the payload ranging over the full coordinate space regardless of `M`" is
correct *as a statement about the payload*, and it is exactly what invites
the Nash reading. Corollary 3 above says what it does **not** imply: the
map `payload ↦ induced automorphism of coker(D)` is not surjective, and
the defect is the cyclic group `(ℤ/d₁)ˣ/{±1}`. A regular torsor upstairs
can have a non-surjective induced action downstairs; the lens that missed
this is the one that reads a torsor and stops.

---

## 4. Contradictions with conspicuous documents (reported, not fixed)

1. **`notes/RANK_R_PAYLOAD_NORMAL_FORM.md` "Not treated / open":** *"The
   Agda formalization of the payload type remains blocked on a local Agda
   toolchain, as recorded in R0035/R0037; it is the next formal step."*
   This is stale. Agda 2.6.3 is at `/usr/bin/agda`, the cubical library is
   configured, and `formal/cubical/Gamma0Partner.agda`,
   `Gamma0Converse.agda`, `Gamma0Freeness.agda`, `Gamma0Transitivity.agda`,
   `TransporterMembership.agda`, `SmithTorsorBridge.agda` already formalize
   the `n = 2` payload/torsor clauses. The blocker line should be deleted.
2. **`notes/SMITH_PATH_HOLONOMY.md` §5 "Replay"** instructs
   `python3 machinery/smith_path_holonomy.py`. Under `CLAUDE.md` (Python
   banned, enforced by `.claude/hooks/no-python.sh`, `.githooks/`, and CI)
   that replay instruction is not executable by any agent that respects the
   repo's own gate. Notes whose only replay is a Python invocation are
   claims without a checker, by the repository's current standard.
3. **`figures/exp42_esprit.png`** ("Blind parametric extraction of the zeta
   sum-spectrum from Möbius–Goldbach data") is precisely the artifact
   `CLAUDE.md` forbids: eyeballed agreement between red estimate lines and
   green true `γ_i + γ_j` lines, with no error term, no `X`-dependence, and
   several estimates with no corresponding true line at all. It is
   retained in the tree with no visible note stating which theorem the
   agreement stands in for.
4. **`collab/discovery/claims/R0010-…md`** carries an "Independent audit"
   block that contradicts its own registered "Exact statement" (`F1`
   overreaches; `𝔸ⁿ_ℤ` refutes the relative-dimension-zero claim) while the
   statement and its hash are deliberately preserved. This is intentional
   provenance, correctly flagged in-file — noted here only because a reader
   arriving via the claim index sees the overreaching statement first.

---

## 5. What is machine-checked

`formal/cubical/Swarm/S11HolonomyDeterminant.agda`, `--cubical --safe`,
no postulates, no holes, checked with

```
$ cd formal/cubical && agda -i . Swarm/S11HolonomyDeterminant.agda
Checking Swarm.S11HolonomyDeterminant (…/Swarm/S11HolonomyDeterminant.agda).
EXIT=0
```

Following the repo's `Gamma0*` convention `D = diag(d₁, q·d₁)`, `Γ₀(q) =`
matrices with lower-left entry `q·k`:

| name | statement |
|---|---|
| `detShift` | `det(C + D·E) = det C + d₁·K` with `K` **exhibited** — the well-definedness of `det` on `End(coker D)` mod `d₁`, as a polynomial identity over any commutative ring |
| `detClass` | if a holonomy `H = (a,b,q·k,e)` is congruent mod `D` to a representative `C`, then `det H = det C + d₁·t` with `t` exhibited: §2.1 necessity |
| `sqLem`, `squareObstruction` | `ε = δ + d₁·t` and `ε² = 1` force `d₁ | δ² − 1`, with the quotient exhibited |
| `no5≤3`, `¬5∣3` | `5 ∤ 3` in ℕ, hence in ℤ |
| `noSurjectivity` | **for every `q`**: no `H` with `det H = ε`, `ε² = 1` is congruent to `diag(2,1)` modulo `D = diag(5, 5q)` |

At `q = 1` the class of `diag(2,1)` is a genuine automorphism of
`coker(D) = (ℤ/5)²` (inverse `diag(3,1)`), of determinant `2 ∉ {±1}` mod
`5`. So `noSurjectivity` is a certificate that `h : Γ₀(D) → Aut(coker D)`
is **not** surjective — the Nash reading is refuted by a checked term, not
by an appeal to §2.

`2` is the smallest possible witness: `d₁ = 5` is the least modulus with
`(ℤ/d₁)ˣ ≠ {±1}`. Note also that the constraint is strictly finer than
"`det φ` is a square root of 1": at `d₁ = 8`, `3² ≡ 1 (mod 8)` yet
`3 ∉ {1,7}`, so `diag(3,1)` on `(ℤ/8)²` is also excluded (from `ε = 3+8t`
and `ε² = 1` one gets `8(6t + 8t²) = −8`, so `2 | −1`).

**Not machine-checked:** §2.2 sufficiency (Steps 1–4) and Corollary 1, which
are prose proofs above. They rest on two classical inputs used, not
reproved: surjectivity of `SL_n(ℤ) → SL_n(ℤ/N)`, and the Smith normal form.

---

## 6. Prior art and novelty

**No novelty is claimed for the theorem.** The image of `GL_n(ℤ)` in the
automorphism group of a finite abelian group, and the determinant
`Aut(A) → (ℤ/d₁)ˣ`, are classical; the `n = 1` case is "the units of ℤ are
`±1`" and the `D = d·I` case is the familiar failure of
`GL_n(ℤ) → GL_n(ℤ/d)` to be surjective. What is new *here* is only the
identification: that this classical constraint is exactly the holonomy
obstruction of the repository's Smith event torsor, that its modulus is the
**first** invariant factor (so it is invisible in every example with
`d₁ = 1`, which is every worked example in the corpus), and the resulting
correction to the descent count in `SMITH_PATH_HOLONOMY.md`.

In-corpus search performed **before** the write-up:
`grep -ril "Aut(coker\|holonomy image\|det ≡ ±1\|determinant mod d" notes/
collab/ formal/` returns only `collab/encounters/codex-smith-path-holonomy.json`
(the encounter record for the note itself) — no prior statement of the
image. `notes/HOLONOMY_DESCENT.md` contains no occurrence of `Aut`,
`coker`, `image`, or `surject`.

---

## 7. Honesty ledger

- No floating-point quantity was computed, measured, or fitted in this
  work. No experiment was run. The only computation is `agda`, which is
  certified symbolic computation and therefore proof (`CLAUDE.md`).
- §2.1, and the finite non-surjectivity witness, are checked terms.
- §2.2, §2.3, §2.4 and §3 are prose proofs, complete but hand-checked, and
  should be read as such. The weakest joint is Step 1(iv): the CRT
  simultaneity argument is correct but terse; a formalization would want
  it in full.
- Corollary 2's list `{1,2,3,4,6}` is the classical list of `d` with
  `(ℤ/d)ˣ = {±1}`; it is quoted, not derived here.
- The order-12 count for `Aut(ℤ/2 ⊕ ℤ/6)` uses
  `ℤ/2 ⊕ ℤ/6 ≅ (ℤ/2)² ⊕ ℤ/3`, `|GL₂(𝔽₂)| = 6`, `|(ℤ/3)ˣ| = 2`.
- I did not edit `notes/SMITH_PATH_HOLONOMY.md` or
  `notes/RANK_R_PAYLOAD_NORMAL_FORM.md`; §3 and §4 are reports for their
  owners.

## 8. Draw

Eleven files, read in full before planning: `figures/exp42_esprit.png`,
`notes/CONTEXTUAL_QUANTUM_DIMENSION.md`, `notes/SMITH_PATH_HOLONOMY.md`,
`collab/discovery/claims/R0010-chowla-ff-missing-structure.md`,
`data/exp1b_out.txt`, `data/odlyzko_zeros_100k.txt`,
`machinery/test_subset_sum_carrier.py`,
`notes/RANK_R_PAYLOAD_NORMAL_FORM.md`,
`collab/messages/0275-codex-formation-ancestor-closed-retention-result.md`,
`collab/discovery/events/R0019/20260812T003933Z-blind-breaker.json`,
`runtime/curriculum/order.py`. Frontier field: statistical mechanics of
computation. Ancient field: Brahmagupta's composition law on binary
quadratic forms — its trace here is §1's insistence that the composition
law (`Γ₀(D)`, `det`) be stated before any instance is solved. Lenses: Ibn
Khaldun and Nash, as in §0.
