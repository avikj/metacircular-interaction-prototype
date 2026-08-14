# The divisor-flag label automaton: Smith pairs along index-p chains are walks on the Bruhat–Tits tree

**Author:** fleet-flag-automaton.  **Status:** exact symbolic theorems with
finite replay.  **Provenance:** successor seed 1 of R0038
(`notes/HECKE_COMPOSITION_SMITH_LABELS.md`): track the full Smith pair
`(e₁, e₂)` of an index-`p^k` sublattice as a *state*, along chains of
index-`p` steps, and identify the exact automaton.

Conventions are R0034/R0038's, fixed once: `p` prime; sublattices are
finite-index subgroups `L ≤ ℤ²` of column vectors, `L = Mℤ²`, with unique
Hermite basis `((a,0),(b,d))` (columns `(a,b)`, `(0,d)`, `ad = index`,
`0 ≤ b < d`); `e₁ | e₂` are the Smith invariants (`e₁ = gcd(a,b,d)`,
`e₁e₂ = index`); `ψ(m) = m∏_{q|m}(1+1/q)` counts the cyclic (`e₁ = 1`)
stratum; `σ₁(m) = Σ_{d|m} d` counts all index-`m` sublattices.  For a
lattice of index `p^k` the Smith pair is `(p^i, p^{k-i})` with
`0 ≤ 2i ≤ k`; we call `k` the **level**, `i = v_p(e₁)` the **label**, and
`d := v_p(e₂) - v_p(e₁) = k - 2i ≥ 0` the **imbalance**.  A **chain** of
length `k` is `ℤ² = L₀ ⊃ L₁ ⊃ ⋯ ⊃ L_k` with every step of index `p`.

**Classical object, named up front.**  Everything here is classical local
Hecke combinatorics: the automaton below is the radial (distance-from-root)
projection of the walk on the **Bruhat–Tits tree of `GL₂(ℚ_p)`** — the
`(p+1)`-regular tree on homothety classes of lattices (Serre, *Trees*,
II §1; Bruhat–Tits) — and the path counts are the classical counts of
maximal subgroup flags in finite abelian `p`-groups of rank ≤ 2 (P. Hall;
Butler, *Subgroup Lattices and Symmetric Functions*).  No novelty is
claimed; see the rigor boundary.

## 1. The automaton: exact forward keep/raise multiplicities

States at level `k`: labels `i` with `2i ≤ k` (Smith type `(p^i, p^{k-i})`).
Every lattice `L` has exactly `p+1` sublattices of index `p` (lines in
`L/pL ≅ (ℤ/p)²`), and by R0038 Theorem 3 (interlacing) each child has label
`i` (**keep**) or `i+1` (**raise**).  R0038 Theorem 4 counted the
*backward* direction — parents of a fixed child.  The forward direction is
its time reversal, and the multiplicities transpose:

**Theorem 1 (forward transitions).**  Let `L` have index `p^k` and label
`i`.  Among its `p+1` index-`p` sublattices:

- **unbalanced source, `2i < k`:** exactly `p` children keep the label `i`
  and exactly `1` raises it to `i+1`;
- **balanced source, `2i = k`** (forcing `L = p^iℤ²`): **all `p+1`**
  children keep the label `i`; raising is impossible (a raised child would
  have `2(i+1) = k+2 > k+1`).

Equivalently, with Iverson brackets:

\[
\boxed{\ \#\text{keep}(i,k) = p + [\,2i=k\,],\qquad
\#\text{raise}(i,k) = [\,2i<k\,].\ }
\]

*Proof.*  Write `L = p^iL₀` with `e₁(L₀) = 1` and `[ℤ²:L₀] = p^{d}`,
`d = k-2i` (R0034 §4).  Multiplication by `p^i` carries index-`p`
sublattices `L₁ ⊆ L₀` bijectively to those of `L`, and
`e₁(p^iL₁) = p^i e₁(L₁)`; by interlacing `e₁(L₁) ∈ {1, p}`, and
`e₁(L₁) = p` iff `L₁ ⊆ pℤ²`.  So children of `L` that raise the label
correspond to index-`p` sublattices `L₁ ⊆ L₀` with `L₁ ⊆ pℤ²`.

If `d = 0` then `L₀ = ℤ²` and every index-`p` sublattice `L₁` has
`e₁(L₁)² ∣ p`, hence `e₁(L₁) = 1`: zero raisers, `p+1` keepers.

If `d ≥ 1`: `SL₂(ℤ)` acts transitively on the cyclic stratum (R0034
Theorem 3) and preserves indices, Smith invariants, and `pℤ²` (since
`γ·pℤ² = pℤ²`), so we may take `L₀ = ℤ ⊕ p^dℤ`.  Then
`pℤ² ∩ L₀ = pℤ ⊕ p^dℤ`, which has index `p` in `L₀`, is contained in
`pℤ²`, and has `e₁ = gcd(p, 0, p^d) = p`.  Any index-`p` sublattice
`L₁ ⊆ pℤ²` satisfies `L₁ ⊆ pℤ² ∩ L₀`, and equality of indices forces
`L₁ = pℤ² ∩ L₀`.  So exactly **one** raiser and `p` keepers. ∎

**Remark (time reversal against R0038).**  Backward, into a fixed child of
level `k+1` and label `i`: `(keep, raise)` parents number `(1,0)` for
`i = 0`, `(1,p)` for `1 ≤ i`, `2i ≤ k`, and `(0,p+1)` for `2i = k+1`
(R0038 Theorems 2+4).  Forward and backward counts are consistent by
stratum bookkeeping: the label-`i` stratum at level `k` has
`N_k(i) = ψ(p^{k-2i})` members (homothety, R0034 §4), and e.g. for keeps
with `2i < k`: `N_k(i)·p = ψ(p^{k-2i})·p = ψ(p^{k+1-2i}) = N_{k+1}(i)·1`
(using `ψ(p^{j+1}) = pψ(p^j)` for `j ≥ 1`, and for `j = 1`:
`ψ(p)·p = (p+1)p = ψ(p)·p`); for raises with `2i < k`:
`N_k(i)·1 = N_{k+1}(i+1)·p` when `2i ≤ k-2` (`ψ(p^j) = pψ(p^{j-1})`,
`j ≥ 2`) and `N_k(i)·1 = ψ(p) = p+1 = N_{k+1}(i+1)·(p+1)` when
`2i = k-1` (balanced target `p^{i+1}ℤ²`, `N = 1`); at the balanced source
`2i = k`: `N_k(i)·(p+1) = p+1 = ψ(p)·1 = N_{k+1}(i)·1`.  Every edge of the
level-transition bigraph is counted the same way from both sides.

The task-level caution is exactly this reversal: R0038's "1 keeper + `p`
raisers" is the *backward* multiplicity; the automaton's *forward*
multiplicity is `p` keepers + `1` raiser, with the balanced boundary on
the **source** (`2i = k`: no raiser leaves `p^iℤ²`) rather than on the
target (`2i = k+1`: no keeper enters `p^iℤ²`).

## 2. Path counting: the ballot closed form

Fix a lattice `L` of index `p^k` and label `i`, and let `C(L)` be the
number of chains `ℤ² = L₀ ⊃ ⋯ ⊃ L_k = L`.  Chains to `L` are exactly the
maximal flags `Q = H₀ > H₁ > ⋯ > H_k = 0` of subgroups of
`Q = ℤ²/L ≅ ℤ/p^i × ℤ/p^{k-i}` (via `H_j = L_j/L`; each step has index
`p`), so `C(L)` is a classical quantity: the number of maximal subgroup
chains of the abelian `p`-group of type `(k-i, i)`.

**Theorem 2 (DP recurrence; label-only dependence).**  `C(L)` depends only
on `(i,k)`; writing `C_p(i,k)`, with `C_p(0,0) = 1`:

- `C_p(0,k) = C_p(0,k-1)`  (so `C_p(0,k) = 1`: a cyclic quotient has a
  unique maximal flag — one subgroup of each order);
- `1 ≤ i`, `2i < k`:  `C_p(i,k) = C_p(i,k-1) + p·C_p(i-1,k-1)`;
- `2i = k`:  `C_p(i,k) = (p+1)·C_p(i-1,k-1)`.

*Proof.*  `C(L) = Σ_{L'} C(L')` over the parents `L'` (index-`p`
overlattices of `L` inside `ℤ²`, automatically of index `p^{k-1}`).  By
the backward counts (Remark above): a label-`0` child has one parent, of
label `0`; a label-`i ≥ 1` child with `2i < k` has one label-`i` parent
and `p` label-`(i-1)` parents; a balanced child (`2i = k`) has `p+1`
label-`(i-1)` parents.  Induction on `k` gives label-only dependence and
the recurrence simultaneously. ∎

**Theorem 3 (closed form).**  With `\binom{k}{r} := 0` for `r < 0`,

\[
\boxed{\ C_p(i,k)\;=\;\sum_{j=0}^{i}
\left[\binom{k}{j}-\binom{k}{j-1}\right] p^{\,j}.\ }
\]

The coefficient `b_j(k) = \binom{k}{j}-\binom{k}{j-1}` is the ballot
number: the number of `±1`-paths of length `k` from `0` to `k-2j` that
never go below `0`.

*Proof.*  Let `S(i,k)` denote the right side, defined for all `i ≥ 0`,
`k ≥ 0`.  Pascal gives, for every `j ≥ 0`,

\[
b_j(k) = \binom{k-1}{j}-\binom{k-1}{j-2} = b_j(k-1) + b_{j-1}(k-1)
\]

(with `b_{-1} := 0`), hence summing `j ≤ i`:

\[
S(i,k) = S(i,k-1) + p\,S(i-1,k-1)\qquad (i ≥ 1,\ k ≥ 1). \tag{∗}
\]

Base: `S(0,k) = b_0(k) = 1`.  Unbalanced case of Theorem 2 is (∗)
verbatim.  Balanced case `2i = k`: the top coefficient at `k-1 = 2i-1` is
central, `b_i(2i-1) = \binom{2i-1}{i} - \binom{2i-1}{i-1} = 0`, so
`S(i,k-1) = S(i-1,k-1)` and (∗) collapses to
`S(i,k) = (p+1)S(i-1,k-1)`.  Thus `S` satisfies exactly the recurrence and
base of Theorem 2, and induction on `k` gives `C_p = S`. ∎

First values (`q = p`): `C_p(0,k) = 1`; `C_p(1,k) = (k-1)p + 1`;
`C_p(2,4) = (p+1)(2p+1)`; `C_p(2,5) = 5p²+4p+1`;
`C_p(3,6) = (p+1)(5p²+4p+1)`.  There is **no product formula** in
general: `5p²+4p+1` has negative discriminant, so it is irreducible over
`ℚ`; only the balanced column factors,
`C_p(i,2i) = (p+1)C_p(i-1,2i-1)` (the last step into `p^iℤ²` arrives from
`p+1` parents).  Telescoping gives `Σ_{j=0}^{i} b_j(k) = \binom{k}{i}`,
the number of monotone label paths `0 → i`.

**Corollary (totals).**  Every lattice has exactly `p+1` index-`p`
sublattices, so the number of length-`k` chains is `(p+1)^k`; every
index-`p^k` lattice is a chain endpoint (any finite flag of `ℤ²/L`
refines to a maximal one); equivalently

\[
\sum_{2i\le k}\psi(p^{k-2i})\,C_p(i,k) \;=\;(p+1)^k ,
\]

and the chains ending on the **cyclic stratum** number
`ψ(p^k)·C_p(0,k) = ψ(p^k) = (p+1)p^{k-1}` for `k ≥ 1` — one chain per
cyclic endpoint.  (The task-sheet's guess `(p+1)p^{k-1}` is this cyclic
count, i.e. the count of geodesics = sphere size in §3; the full chain
total is `(p+1)^k`.)

## 3. The Bruhat–Tits dictionary

Let `T_p` be the graph whose vertices are homothety classes
`[L] = {p^tL : t ∈ ℤ_{≥0}}` of finite-index sublattices of `ℤ²` of
`p`-power index, with `[L] ∼ [L′]` iff some representatives satisfy
`L′ ⊂ L` with index `p`.  The relation is symmetric: `L′ ⊂ L` of index `p`
implies `pL ⊂ L′` of index `p` (the quotient `L/L′` is killed by `p`).
Each class contains a unique **primitive** (`e₁ = 1`, i.e. cyclic) member
`L^* = L/e₁(L)`, and a unique member of index `p^k` for each
`k = d + 2t`, `t ≥ 0`, where `p^d = [ℤ²:L^*]` — namely `p^tL^*`.  This is
the standard combinatorial model of the Bruhat–Tits tree of `GL₂(ℚ_p)`
(Serre, *Trees*, II §1); the root is `[ℤ²]`.

**Theorem 4 (dictionary).**  Let `dist` be the graph distance in `T_p`
from the root.

1. **Chains = walks.**  The map `(L₀,…,L_k) ↦ ([L₀],…,[L_k])` is a
   bijection from length-`k` chains to length-`k` walks in `T_p` starting
   at the root.
2. **Distance = imbalance.**  For `L` of level `k` and label `i`,
   `dist([L]) = v_p(e₂) - v_p(e₁) = k - 2i`; walks of length `k` from the
   root to `[L]` exist iff `k ≥ k-2i =: d` and `k ≡ d (mod 2)`.  Hence
   the exact dictionary
   \[
   \boxed{\ \text{label } i \;=\; \frac{k - \operatorname{dist}([L])}{2},
   \qquad \operatorname{dist}([L]) = v_p\!\left(e_2/e_1\right).\ }
   \]
3. **Radial projection.**  Under the bijection, a keep step moves the walk
   from distance `d` to `d+1` (away from the root) and a raise step to
   `d-1` (toward the root); balanced states are exactly the visits to the
   root.  The §1 automaton is the distance automaton of the tree, and
   `C_p(i,k)` is the number of length-`k` walks from the root to a fixed
   vertex at distance `k-2i`.
4. **`T_p` is a `(p+1)`-regular tree**, and the sphere of radius `k ≥ 1`
   has `(p+1)p^{k-1} = ψ(p^k)` vertices — the cyclic stratum at level
   `k`.  Chains ending on the cyclic stratum are exactly the geodesics
   (non-backtracking walks), one per sphere vertex (`C_p(0,k) = 1`).

*Proof.*  **(1)** Consecutive chain lattices give adjacent, distinct
classes (`L_{j+1} = p^tL_j` is impossible at index ratio `p`), so a chain
maps to a walk.  Conversely, along a walk each neighbor class of `[L_j]`
contains a representative that is an index-`p` sublattice of `L_j`, and it
is unique (homothetic lattices have indices differing by squares
`p^{2t}`), so a walk lifts to a unique chain.

**(2)** Walks of length `k` from the root to `[L]` correspond by (1) to
chains ending at a member of `[L]` of index `p^k`; such a member exists
iff `k = d + 2t`, `t ≥ 0`.  For `k = d` the endpoint is the primitive
member `L^*` and a chain exists (`C_p(0,d) = 1 ≥ 1`: the unique maximal
flag of the cyclic group `ℤ²/L^*`).  So the minimum walk length is
exactly `d`.

**(3)** A step raises the level by `1` and keeps or raises the label, so
`d = k - 2i` changes by `+1` (keep) or `-1` (raise); `d = 0` iff
balanced.  By (2), `d` *is* the distance, so keeps move away from the
root, raises toward it; the multiplicities are Theorem 1's.  Fixing the
endpoint class and length fixes the endpoint lattice (unique index-`p^k`
member), so walk counts to a fixed vertex are the chain counts
`C_p(i,k)`.

**(4)** Neighbors of `[L]` are the classes of the `p+1` index-`p`
sublattices of the primitive representative `L^*`, and these classes are
distinct: keep-children are distinct primitive lattices (distinct classes,
since the primitive member of a class is unique), and the raise-child (if
`d ≥ 1`) lies at distance `d-1 ≠ d+1`.  So `T_p` is `(p+1)`-regular.  By
(2)–(3), every edge joins vertices at consecutive distances, and every
vertex at distance `r ≥ 1` has *exactly one* neighbor at distance `r-1`
(Theorem 1 applied to its primitive representative: one raiser) and `p`
at `r+1`.  Hence in each ball of radius `R`, every non-root vertex has a
unique parent edge and every edge is a parent edge, so
`#edges = #vertices - 1`; the ball is connected (every `[L]` is reached
by its geodesic chain), so every ball — and therefore `T_p` — is a tree.
Sphere sizes follow by induction: `|S(1)| = p+1`,
`|S(r+1)| = p|S(r)|` (each distance-`r` vertex has `p` children at
`r+1`, each with a unique parent), giving `(p+1)p^{k-1} = ψ(p^k)`; the
distance-`k` vertices are the classes of the cyclic index-`p^k` lattices
(by (2), `d = k` iff `i = 0`), each reached by a unique length-`k` chain,
and a walk of minimal length is exactly a non-backtracking walk in a
tree. ∎

So the full Smith-pair automaton is the classical picture: **a chain of
index-`p` steps is a walk from the root on the `(p+1)`-regular tree; the
level is time, the imbalance `v_p(e₂/e₁)` is the distance from the root,
the label `i` is the number of steps toward the root so far, and the
balanced lattices `p^iℤ²` are the returns to the root.**  The closed form
of Theorem 3 is the standard ballot-sum evaluation of walk counts on the
regular tree (the generating-function form
`Σ_k C_p(i,k)z^k` with `d = k-2i` fixed is `G₀(z)(zD(z))^d`,
`D = 1 + pz²D²`, the tree's Green-function combinatorics).

## 4. Replay

`machinery/divisor_flag_label_automaton.py` (reusing
`hecke_composition_smith_labels.compose` and the R0034 enumeration), tests
in `machinery/test_divisor_flag_label_automaton.py` — all exact integers:

- forward `(keep, raise)` multiplicities of Theorem 1 against brute-force
  composition of Hermite bases, for `p ∈ {2,3}`, all lattices of level
  `k ≤ 4`, including the balanced identification `2i = k ⟺ L = p^iℤ²`;
- backward parent splits (the R0038 time reversal) for the same range;
- brute-force enumeration of all `(p+1)^k` chains (`k ≤ 4`): endpoint
  coverage of all `σ₁(p^k)` lattices, per-endpoint counts against both
  the DP of Theorem 2 and the closed form of Theorem 3;
- DP = closed form for `p ∈ {2,3,5,7}`, `k ≤ 14`, plus the special
  values and the balanced factorization;
- totals: `(p+1)^k` chains, `ψ`-weighted stratum identity, cyclic-stratum
  count `(p+1)p^{k-1}`, stratum sizes `N_k(i) = ψ(p^{k-2i})`;
- the tree: BFS ball of `T_p` to radius 5 with sphere sizes
  `(p+1)p^{r-1}`, unique parents, `(p+1)`-regularity, adjacency symmetry;
  the distance formula `dist([L]) = v_p(e₂/e₁)` for every lattice of
  level `≤ 4`; and the walk dictionary (`d_j = j - 2i_j`, steps `±1`,
  keep ↔ away / raise ↔ toward) along every enumerated chain.

## Rigor boundary

Theorems 1–4 are proved above by elementary lattice/subgroup arguments on
top of R0034 (homothety stratification, `SL₂(ℤ)`-transitivity on the
cyclic stratum) and R0038 (interlacing, backward multiplicities); the
Pascal induction for Theorem 3 is complete; the finite computations are
replays, not evidence.  The derive-first protocol was followed: the
forward multiplicities and the ballot closed form were derived by hand
from R0038's theorems (the closed form extracted from the DP's first
rows, then proved by the Pascal identity), and only then replayed.

**All of this is classical and no novelty is claimed.**  The named
classical object is the **Bruhat–Tits tree for `GL₂(ℚ_p)`** (Bruhat–Tits;
Serre, *Trees*, II §1): vertices are homothety classes of rank-2 lattices,
the tree is `(p+1)`-regular, and distance from the base vertex is the
difference of elementary-divisor valuations — Theorem 4 is that standard
dictionary specialized to R0034's stratified integral objects.  Chain
counts to a fixed endpoint are counts of maximal subgroup flags of finite
abelian `p`-groups of rank ≤ 2 — classical territory of P. Hall's
enumerations (see Butler, *Subgroup Lattices and Symmetric Functions*) —
equivalently, walk counts on the regular tree, standard in spectral graph
theory (Kesten) and Ihara-zeta combinatorics.  Repository content: the
exact forward/backward multiplicity transposition made explicit in
R0038's keep/raise coordinates, the ballot-sum closed form
`C_p(i,k) = Σ_{j≤i} (\binom{k}{j}-\binom{k}{j-1})p^j` with a two-line
Pascal proof against the automaton's DP, the observation that no product
formula exists off the balanced column (certified by an irreducible
instance), and the executable exact replay binding chains, flags, and
tree walks in one test suite.
