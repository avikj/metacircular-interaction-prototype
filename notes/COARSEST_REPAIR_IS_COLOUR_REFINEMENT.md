# The coarsest repair, in closed form — and it was a solved problem

**Status.** `LENS_REPAIR.md` §5 seeds 1 and 2 are both answered. The
exponential enumeration in `machinery/lens_repair.py` is replaced by a
one-pass formula. Certificate: `machine/RepairFixpoint.hs`, exact
rationals, 813,297 ordered pairs through *n* = 7.

**Read this section before the mathematics.**

## 0. Priority: none is claimed

This note contains no new mathematics. The problem it answers was open *in
this corpus* and is not open in the literature; the corpus had been working
inside a solved problem without recognising it. Stated precisely:

| ingredient | where it already is |
|---|---|
| `ρ ⊥ σ` ⟺ `P_ρP_σ = P_σP_ρ` ⟺ `V_ρ` is `P_σ`-invariant | Godsil–Royle, *Algebraic Graph Theory*, GTM 207, Ch. 9 — textbook |
| commuting partitions = **orthogonal partitions** | Tjur, *Int. Stat. Rev.* 52 (1984) 33–81; Bailey, *Des. Codes Cryptogr.* 8 (1996) 45–77; Nelder (1965) |
| so `ρ ⊥ σ` ⟺ `ρ` is an **equitable partition of the matrix `P_σ`** | immediate from the above |
| coarsest equitable refinement of a given partition, `O(m log n)` | Paige–Tarjan (1987); Baier–Engelen–Majster-Cederbaum (2000); Derisavi–Hermanns–Sanders (2003); Grohe–Kersting–Mladenov–Selman (2014) |
| the same object as Markov **lumpability** | Buchholz (1994); Valmari–Franceschinis (2010) |
| §1's join-closure ⇒ unique coarsest, *same proof* | Stewart, *Math. Proc. Camb. Phil. Soc.* 143 (2007) 165–183 |
| the relation `≈` below | **Benzécri's *distributional equivalence*, 1966 / *L'Analyse des Données*, Dunod 1973** |
| the degenerate case `σ = {X}` (every partition is a repair) | Stewart (2007): every partition is balanced on `Kₙ` |

`LENS_REPAIR` §5 seed 1 asked "NP-hard, or a partition-refinement fixpoint
from the other direction?" The second guess was right, and the fixpoint in
question has been in print since 1987 under the name **colour refinement**.

The one sentence I could not find in print is the assembly: *for `A = P_σ`,
colour refinement terminates in one round, with a closed form.* That is a
gap of the kind that exists because nobody bothered, not because it was
hard — the proof is four lines. It is a remark. **Do not build on it as a
result.**

**Unresolved, and it should stay on the queue.** `SEARCH` — Bailey,
*Orthogonal partitions in designed experiments* (1996) §§2–4, and Bailey,
*Association Schemes* (CUP 2004) Ch. 10. That is the one place a version of
§2 below would most plausibly already sit as an unnumbered observation, and
neither sweep could open it: this environment's egress policy refuses
`CONNECT` to arxiv.org, link.springer.com, and every publisher host tried
(gateway 403, `connect_rejected`). Both sweeps ran on search-result
summaries alone and opened **zero** primary sources. Until someone with
library access reads those two chapters, the honest status of §2 is
*probably folklore, possibly in Bailey.*

---

## 1. The object

`X` finite, uniform counting measure. `P_ρ` = orthogonal projection onto
`ρ`-measurable functions. A **repair** for `(π, σ)` is a `ρ` that refines
`π` and commutes with `σ`; `LENS_REPAIR` proves the repair set has a unique
coarsest element and that no monotone path of single fusions reaches it.

Two facts turn this into linear algebra, and both are already in the
corpus — §1's Lemma uses the second one and stops there:

- `ρ` refines `π` ⟺ `V_ρ ⊇ V_π`, where `V_ρ = span{1_B : B ∈ ρ}`;
- `ρ` commutes with `σ` ⟺ `V_ρ` is `P_σ`-invariant.

So the coarsest repair is **the smallest `P_σ`-invariant partition subspace
containing `V_π`**. That is the whole reformulation, and it was one step
past a lemma the corpus had already proved.

## 2. The closed form

Write `q(x)` for the `σ`-block of `x`, and `d_A(E) = |A ∩ E| / |E|` for the
density of a `π`-block `A` in a `σ`-block `E`. Define

> `E ≈ E'` ⟺ `d_A(E) = d_A(E')` for every `A ∈ π`

— i.e. `E` and `E'` have the same `π`-profile. **This is Benzécri's
distributional equivalence and should be cited by that name.**

**Theorem.** `ρ* = π ∧ q⁻¹(≈)`.

*Two points stay together exactly when they share a `π`-block and their
`σ`-blocks are distributionally equivalent over `π`.*

*Proof.* One refinement step from `π` splits by the values of `1_A` and
`P_σ1_A`, giving exactly `π ∧ q⁻¹(≈)`; call it `ρ₁`. Its blocks are
`B = A ∩ q⁻¹(c)` for `A ∈ π` and `c` an `≈`-class. Then `P_σ1_B` vanishes
off `q⁻¹(c)` (as `B ⊆ q⁻¹(c)`), and for `E ∈ c` it takes the value
`d_A(E)`, which is constant across `c` by definition of `≈`. Hence
`P_σ1_B = d_{A,c}·1_{q⁻¹(c)}`, and `q⁻¹(c) = ⋃_{A' ∈ π}(A' ∩ q⁻¹(c))` is a
union of `ρ₁`-blocks. So `V_{ρ₁}` is already `P_σ`-invariant: `ρ₁` is a
repair. Conversely any repair `ρ` has `V_ρ ⊇ V_π`, hence `V_ρ ⊇ P_σV_π` by
invariance, hence `V_ρ ⊇ V_{ρ₁}` since `V_{ρ₁}` is the least *partition*
subspace containing both. So every repair refines `ρ₁`. ∎

**Why one round, and why this is special to projections.** `P_σ` maps into
`V_σ`, so everything a first pass adds is already `σ`-measurable and a
second pass can find nothing new. For a general stochastic `A`, `A1_B` is
confined to no fixed subspace and colour refinement genuinely iterates —
Kiefer–McKay (ICALP 2020) show the trivial `n−1` bound is tight. Cost:
`O(n log n)`, one pass, against the previous exhaustive enumeration.

## 3. Seed 2, which asked for a criterion and had a count

> *"Characterize when the meet is minimal. `410/1900` is a count, not a
> criterion. Which `(π, σ)` have `π ∧ σ` as their coarsest repair?"*

**Corollary.** `ρ* = π ∧ σ` ⟺ distinct `σ`-blocks have distinct `π`-density
profiles — i.e. **no two `σ`-blocks are distributionally equivalent over
`π`**.

*Proof.* If `E ≈ E'` with `E ≠ E'`, any `π`-block meeting `E` has positive
density there, hence positive density at `E'`, hence meets `E'` too; so the
two fuse in `ρ*` and `ρ*` is strictly coarser than the meet. Conversely if
`≈` is discrete then `q⁻¹(≈) = σ` and `ρ* = π ∧ σ`. ∎

Note the "if" half of the *nonemptiness* claim is trivial and was already
in `LENS_REPAIR` §0: anything refining `σ` commutes with `σ`. The content
here is only about when the meet is *coarsest*.

## 4. What is certified, and how

`machine/RepairFixpoint.hs`. Exact `Ratio Integer` throughout; no floating
point, nothing fitted, nothing sampled. Each check is a proposition about a
finite range that is true or produces a witness.

- **CERT 1** — the grid criterion `|B∩E|·|C| = |B|·|E|` (what
  `LENS_ORDER_COMMUTATION` works with) agrees with `P_σ`-invariance on all
  **813,297** ordered pairs, `n ≤ 7`. Run first, because CERT 2 would be
  circular without it.
- **CERT 2** — the fixpoint equals the join of *every* repair found by
  brute force, 44,168 pairs, `n ≤ 6`.
- **CERT 3** — the closed form of §2 equals the fixpoint, 813,297 pairs,
  `n ≤ 7`.
- **CERT 4** — §3's criterion, 0 mismatches; and it reproduces
  `LENS_REPAIR` §2's independently computed numbers exactly: at `n = 5`,
  **1900** noncommuting ordered pairs, of which **410** have `ρ*` strictly
  coarser than the meet. That the two implementations agree on 410 is the
  cross-check that the frozen Python and this Haskell mean the same thing
  by "commutes".
- **SCAN** — max rounds to fixpoint is 1 for every pair through `n = 7`,
  as §2 proves.

## 5. What this says about the corpus

The sweep of 2026-08-14 called this "the most delegable item here — a
self-contained combinatorics problem needing no corpus context." That was
right, and it is also why it was a rediscovery: *self-contained* means
*someone else has probably done it.* The corpus's own §6.2 observation
holds — the recurring shape is an unexecuted merge — but this instance adds
a sharper one:

**An open question with no corpus context is a literature-search task
before it is a research task.** `CLAUDE.md` already says prior art gets
searched before the experiment; the failure mode here was subtler, because
nothing was *measured*. A theorem was proved and exhaustively certified,
correctly, and the whole exercise was still a rediscovery. Proof discipline
does not protect against duplicating the world — only searching does.

The practical yield is real and survives the priority verdict: an
exponential routine becomes a formula, and two named seeds close.
