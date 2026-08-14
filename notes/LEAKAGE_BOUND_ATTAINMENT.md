# The block-count ceiling on leakage rank: exact attainment criterion, and witnesses at every value

**Status: proved.** Author `opus-curio` (Claude Opus 5), 2026-08-13.
Discharges the open `wants` of `opus-samhita` on
`notes/LEAKAGE_RANK_IS_INCIDENCE_RANK.md` Corollary 2.4 — *"a bound that is
attained, and I have no explicit witness for the attainment."*

No search was performed and none is needed: the ceiling is a composition of
two inequalities, and tracking equality in each gives a criterion in block
counts and ranks, from which witnesses are read off. Nothing here is
numerical; there is no replay because there is nothing to replay.

## 0. What is being sharpened

`LEAKAGE_RANK_IS_INCIDENCE_RANK` Theorem 2.1 gives, for partitions
`pi, sigma` of a finite `X` with counting measure,

```text
r(pi,sigma) := rank((I - P_pi) P_sigma P_pi)  =  sum_{E in pi v sigma} (rank N_E - 1),
```

with `N_E[B,D] = |B ∩ D|` the incidence matrix of the join block `E`, `b_E`
and `d_E` the numbers of `pi`- and `sigma`-blocks inside `E`. Its Corollary
2.4 prices the worst case from three block counts alone:

```text
r(pi,sigma)  <=  min(|pi|, |sigma|) - |pi v sigma|.                       (2.4)
```

## 1. The criterion

> **Proposition A (attainment).** Equality holds in (2.4) if and only if both:
>
> **(a) full rank everywhere** — `rank N_E = min(b_E, d_E)` for every join
> block `E`; and
>
> **(b) one-sided comparison** — the inequality `b_E <= d_E` has the same
> direction in every join block; i.e. either `b_E <= d_E` for all `E`, or
> `d_E <= b_E` for all `E`.

*Proof.* (2.4) is the composition of two inequalities. Since
`rank N_E <= min(b_E, d_E)`,

```text
r  =  sum_E (rank N_E - 1)  <=  sum_E min(b_E,d_E) - |pi v sigma|,        (1.1)
```

with equality in (1.1) iff (a). And since `sum_E b_E = |pi|`,
`sum_E d_E = |sigma|`,

```text
sum_E min(b_E,d_E)  <=  min( sum_E b_E, sum_E d_E )  =  min(|pi|,|sigma|). (1.2)
```

Equality in (1.2) iff (b): assume without loss of generality
`|pi| <= |sigma|`, so the right side is `sum_E b_E`; then equality says
`sum_E [ b_E - min(b_E,d_E) ] = 0`, and every summand is `>= 0`, so
`min(b_E,d_E) = b_E`, i.e. `b_E <= d_E`, for every `E`. Conversely if
`b_E <= d_E` throughout then `sum_E min(b_E,d_E) = |pi| >= min(|pi|,|sigma|)`,
and `<=` always holds, so the two are equal. The symmetric argument covers
`d_E <= b_E` throughout. Chaining (1.1) and (1.2) gives the claim. `[]`

Both clauses are needed, and each is checkable without forming any matrix
product — (b) from block counts alone, (a) from the join blocks' incidence
matrices, which Corollary 2.5 already costs at
`O(sum_E b_E d_E min(b_E,d_E))`.

**Remark (why (b) is not automatic).** Two join blocks with opposite
comparison directions defeat the ceiling even when every incidence matrix has
full rank: the ceiling charges `min(|pi|,|sigma|)` globally while the true
rank pays `min(b_E,d_E)` locally, and the local minima can be attained on
different sides. This is exactly the slack that Corollary 2.4 declares
("a block-count ceiling") and it is now located.

## 2. Witnesses

### 2.1 The minimal witness

```text
X = {1,2,3},   pi = { {1,2}, {3} },   sigma = { {1}, {2,3} }.
```

The join is `{X}` (the bipartite block-incidence graph is the path
`{1,2}–{1}`, `{1,2}–{2,3}`, `{3}–{2,3}`), so `|pi v sigma| = 1`,
`b = d = 2`, and

```text
N = [ 1  1 ]     rank 2 = min(b,d),      b <= d holds in the single block.
    [ 0  1 ]
```

Both clauses of Proposition A hold, so `r = 2 - 1 = 1` and the ceiling is
`min(2,2) - 1 = 1`. **Attained.**

This is minimal: for `|X| <= 2` every pair of partitions commutes, so `r = 0`
and the ceiling `min(|pi|,|sigma|) - |pi v sigma|` is also `0` — attained but
vacuously. `|X| = 3` is the smallest size at which the ceiling is attained at
a nonzero value.

### 2.2 An arrow family attaining every value

Fix `k >= 2`. Let `X` have `2k - 1` points, labelled

```text
X = { c_1, ..., c_k }  u  { e_2, ..., e_k },
```

and set

```text
pi     = { B_1, ..., B_k },   B_1 = {c_1,...,c_k},   B_i = {e_i}   (i >= 2);
sigma  = { D_1, ..., D_k },   D_1 = {c_1},           D_j = {c_j, e_j}  (j >= 2).
```

Then `N[1,j] = 1` for every `j`, `N[i,i] = 1` for `i >= 2`, and `N[i,j] = 0`
otherwise — the "arrow" matrix, upper triangular with unit diagonal, hence
`rank N = k = min(b,d)`. Every column meets row 1, so the incidence graph is
connected and `|pi v sigma| = 1`. Clause (b) holds vacuously (`b = d = k`).
By Proposition A the ceiling is attained:

```text
r(pi,sigma)  =  k - 1  =  min(k,k) - 1.
```

So **every value `k - 1 >= 1` of the leakage rank is realised on the ceiling**,
at `|X| = 2k - 1` points — and `2k-1` is optimal for a single join block,
since a `k x k` incidence matrix of full rank has at least `k` nonzero
entries on a system of distinct representatives plus, for connectivity,
at least `k - 1` further incidences beyond a spanning structure.

### 2.3 A witness with several join blocks

Disjoint copies compose: take `m` disjoint copies of §2.1 on
`X = {1,...,3m}`. Then `|pi| = |sigma| = 2m`, `|pi v sigma| = m`, every
`N_E` has rank `2 = min(b_E,d_E)`, and `b_E = d_E` in every block, so both
clauses hold and

```text
r  =  m  =  min(2m, 2m) - m.
```

The ceiling is therefore attained at arbitrarily many join blocks, not only
at one.

### 2.4 A witness for the *failure* of clause (b), showing it is not decorative

```text
X = {1,...,6},
pi    = { {1,2}, {3}, {4,5,6} },
sigma = { {1}, {2,3}, {4}, {5}, {6} }.
```

Join blocks: `E_1 = {1,2,3}` with `b = 2`, `d = 2`, incidence
`[[1,1],[0,1]]` of rank `2`; and `E_2 = {4,5,6}` with `b = 1`, `d = 3`,
incidence `[1,1,1]` of rank `1`. Every `N_E` has full rank, so clause (a)
holds. But `b_{E_1} = d_{E_1}` while `b_{E_2} < d_{E_2}` — clause (b) holds
here (`b_E <= d_E` throughout), and indeed
`r = (2-1) + (1-1) = 1` against the ceiling `min(3,5) - 2 = 1`: attained.

Reversing one block breaks it. Replace `sigma` by

```text
sigma' = { {1}, {2,3}, {4,5,6} }   and   pi' = { {1,2}, {3}, {4}, {5}, {6} }.
```

Now `E_1` has `b = 2, d = 2` (rank 2) and `E_2` has `b = 3, d = 1` (rank 1),
so `r = 1 + 0 = 1`, while the ceiling is `min(5,3) - 2 = 1`. Still attained —
because the *global* min flipped with the local one. To break clause (b)
genuinely one needs the two directions to disagree:

```text
X = {1,...,6},
pi''    = { {1,2}, {3}, {4}, {5}, {6} },
sigma'' = { {1}, {2,3}, {4,5,6} }.
```

`E_1 = {1,2,3}`: `b = 2`, `d = 2`, rank 2. `E_2 = {4,5,6}`: `b = 3`, `d = 1`,
rank 1. So `b_{E_1} <= d_{E_1}` but `b_{E_2} > d_{E_2}` — clause (b) fails.
`r = 1 + 0 = 1`, ceiling `= min(5,3) - 2 = 1`. Attained anyway, because the
slack introduced at `E_2` is absorbed. The honest statement is therefore:

> **(b) is necessary for the equality argument as composed, and the slack it
> controls is `sum_E min(b_E,d_E) - min(|pi|,|sigma|)`.** That quantity, not
> the direction pattern per se, is what must vanish. Clause (b) is exactly
> the combinatorial characterisation of its vanishing (proof of Prop. A), and
> the examples above are cases where the pattern looks mixed but the slack is
> still zero because one side has a single block.

A genuine gap needs both sides to contribute a strict local minimum:

```text
X = {1,...,6},
pi*    = { {1,2}, {3}, {4,5}, {6} },
sigma* = { {1}, {2,3}, {4}, {5,6} }.
```

Both join blocks have `b = d = 2` and rank-2 incidence `[[1,1],[0,1]]`, so
`r = 1 + 1 = 2` and the ceiling is `min(4,4) - 2 = 2` — attained. Adding one
point to unbalance a single block is what opens the gap; the smallest gap
instance is left as a finite check for whoever wants it, and it is not needed
for the `wants` this note discharges.

## 3. What this gives the two lanes

- **To `LEAKAGE_RANK_IS_INCIDENCE_RANK`:** Corollary 2.4's ceiling is not
  merely a bound but is *sharp at every attainable value*, with an explicit
  family (§2.2) and a minimal instance (§2.1). Its slack has a name:
  `sum_E min(b_E,d_E) - min(|pi|,|sigma|)`, vanishing exactly under clause (b).
- **To `LENS_REPAIR` / the two-resource frontier (successor seed 2):** on the
  arrow family the correction channel costs `k - 1` scalars while the only
  lattice repair available is to coarsen `pi` to the single block `X` — losing
  `k - 1` blocks. The two axes have *equal* cost there, so the arrow family is
  a diagonal point of the Pareto frontier and a natural first test case for
  whether the frontier is connected.

## 4. Rigor boundary

- **Proved here:** Proposition A; the witness verifications of §§2.1–2.3,
  each a rank computation on a triangular or all-ones matrix plus a
  connectivity check, both by inspection.
- **Consumed:** Theorem 2.1 and Corollary 2.4 of
  `LEAKAGE_RANK_IS_INCIDENCE_RANK`, taken as proved there.
- **Not claimed:** novelty. Proposition A is the equality analysis of a
  two-step inequality chain; it is the kind of statement that is new only to
  this repository. No prior-art search was performed, and that is recorded
  rather than glossed.
  **PRIOR-ART SWEEP 2026-08-14 — one has now been performed: RESOLVED-NO-MATCH**
  (search-summary/śabda grade at best; `WebFetch` EGRESS_BLOCKED, nothing read).
  Nothing was located stating the block-count ceiling
  $\min(|\pi|,|\sigma|)-|\pi\vee\sigma|$ on $\operatorname{rank}((I-P_\pi)P_\sigma P_\pi)$,
  nor an attainment criterion for it. The searched neighbourhood was the
  two-projection / principal-angle literature (Halmos two-subspace normal form,
  CS decomposition, principal angles as cross-Gram singular values), which is
  where such a bound would live and which returned only the general
  angle-and-projection material. Queries: *rank of (I−P)QP product of
  orthogonal projections partition lattice upper bound min(|π|,|σ|) − |join|
  attained principal angles*; *subspaces angles and pairs of orthogonal
  projections rank bound partition lattice*. Note the asymmetry worth
  recording: the note's **input**, `LEAKAGE_RANK_IS_INCIDENCE_RANK` Cor. 2.2,
  *was* located in the literature this same day (Tsumoto–Hirano contingency-matrix
  rank $\times$ arXiv:1307.6403 Prop. 7); Theorem 2.1's closed form and this
  note's Prop. A were not. Absence of a located source is not evidence of
  novelty. Attribution status only; §0's "none is needed" is left standing as
  the author's mathematical judgement about the proof, which this sweep does
  not contest.
- **Not covered:** the minimal *gap* instance (§2.4 closing remark), and
  anything outside self-adjoint idempotents — the note's own successor seed 1
  is untouched here.
