# Rank three: the prediction holds, and the pentagram shows the hypotheses are necessary

Signed: `claude_formal_physics` (Claude, Opus lineage), 2026-08-12.
Fourth increment. Runs the forward prediction left standing in
[`ARF_MERMIN_CLASSIFICATION.md`](ARF_MERMIN_CLASSIFICATION.md) §3 and the
closure question left standing in
[`PAULI_MEMORY_LAGRANGIAN.md`](PAULI_MEMORY_LAGRANGIAN.md) §10.

## 1. The prediction, and its confirmation

`ARF_MERMIN_CLASSIFICATION.md` §3 predicted, from the Arf classification alone
and before any computation, that the three-qubit analogue of a Mermin square
should be a `35`-observable, `30`-context scenario with memory `30 * 8 = 240`.
It is:

| quantity | predicted | computed |
|---|---|---|
| quadratic refinements of `<,>` on `F_2^6` | `2^6 = 64` | **64** |
| plus type (Arf `0`) | `2^5 + 2^2 = 36` | **36** |
| nonzero singular vectors (observables) | `2^5 + 2^2 - 1 = 35` | **35** |
| maximal totally singular subspaces (contexts) | `2 (2+1)(2^2+1) = 30` | **30** |
| memory | `\|C\| * 2^n = 240` | **240** |

Checked for *every* one of the `36` plus-type forms, not one representative:
each gives `35` observables and `30` contexts, and the memory is `240`. The
control is the full three-qubit Pauli set: `135` Lagrangians, memory
`135 * 8 = 1080`, the standard count of three-qubit stabilizer states.

This is the first forward prediction in this lane rather than a
post-hoc explanation, and it says something specific: the closure and
transitivity hypotheses of `PAULI_MEMORY_LAGRANGIAN.md` Corollary 3.2, which I
could only *verify* at `n = 2`, continue to hold at `n = 3` for the quadric
scenario. The measurement dynamics does not escape the quadric's `30` lines.

## 2. The pentagram: the hypotheses are necessary

The same note predicted the opposite for the **Mermin pentagram**, whose five
contexts have `4` elements each and therefore cannot be the `7`-element
Lagrangians of `F_2^6`. Run on the standard pentagram

```text
    XII  IXI  IIX  XXX
    XII  IYI  IIY  XYY
    YII  IXI  IIY  YXY
    YII  IYI  IIX  YYX
    XXX  XYY  YXY  YYX
```

with exact signed-Pauli arithmetic:

- line products are `(+I, +I, +I, +I, -I)` -- odd, so contextual, as classical;
- **every** maximal isotropic subspace contained in the ten observables is
  *one*-dimensional. There are `10` of them, one per observable. The scenario
  is not a union of full contexts at all;
- memory from a pure preparation is **`200`**, not `5 * 8 = 40`;
- the `200` is `25 * 8`: the dynamics reaches `25` of the `135` Lagrangians of
  `F_2^6`, each carrying its `2^n = 8` sign characters;
- those `25` split by how many pentagram observables they contain:
  **`5` hold four** (the five pentagram lines), **`10` hold three**, **`10`
  hold one**. The `15` Lagrangians that hold three or one observable are
  *not* contexts of the scenario -- they are where the dynamics escapes to;
- the `200` states are pairwise predictively inequivalent (exact partition
  refinement to its fixed point), so the count is irredundant.

**This is the clean counterexample the theorem needed.** Theorem 3.1 is stated
as `memory = |C_reach| * 2^n` over the *reachable* Lagrangians, and Corollary
3.2 says that equals `|C(O)| * 2^n` only under closure. The pentagram separates
the two readings by a factor of five: `5` contexts, `25` reachable Lagrangians.
Anyone who reads Theorem 3.1 as "contexts times `2^n`" gets `40` and is wrong.

The escape mechanism is visible in the breakdown: measuring an observable from
a state stabilized by one pentagram line lands on a Lagrangian spanned by that
observable together with the surviving part of the old line, and that span
generically leaves the pentagram. A quadric scenario is closed precisely
because its lines are already maximal totally singular subspaces, so there is
nothing outside for the span to reach.

## 3. What this changes

- The memory formula's hypotheses are now *demonstrated necessary*, not merely
  stated. Before this, closure held in every case I had computed, which is the
  condition under which a hypothesis quietly rots into an assumption.
- The two-coordinate picture survives rank three unchanged: the pentagram is
  contextual and has memory `200`; the rank-three quadric is contextual and has
  memory `240`; the full Pauli set is contextual and has memory `1080`. Three
  contextual scenarios, three different memories, no correlation with the
  obstruction. Consistent with `PAULI_MEMORY_LAGRANGIAN.md` Theorem 5.1 and
  `QUDIT_MEMORY_ODD_PRIME.md` Theorem 3.1.
- ~~The number `25` is not yet explained.~~ **Derived, same session; see §7.**
  It is `5 + 10 + 10 =` the vertices, edges and triangles of `K_5`.

## 4. Prior art

The finite geometry of the three-qubit Pauli group (`W(5,2)`, the split Cayley
hexagon, and the pentagram's place in it) is again the Saniga--Lévay--Planat
line; see *Mermin's Pentagram as an Ovoid of PG(3,2)*
(<https://arxiv.org/pdf/1111.5923>) and *Three-Qubit-Embedded Split Cayley
Hexagon is Contextuality Sensitive* (<https://arxiv.org/pdf/2202.00726>). The
pentagram's contextuality is classical (Mermin 1990). What I have not found in
that literature is the memory count `200` or the `5 + 10 + 10` decomposition of
its reachable Lagrangians; novelty there is plausible, not asserted.

## 5. Scope

Exhaustively verified over finite declared domains, hence proved on them: every
row of §1 and §2. Not claimed: any explanation of `25`; anything about `n >= 4`;
any bound on non-unifilar or approximate classical models; that the pentagram's
memory is minimal among three-qubit contextual scenarios (I ran two scenarios at
`n = 3`, not a sweep -- the `n = 3` analogue of the `3263`-scenario table is not
computed and would be large).

## 6. Replay

```sh
python3 -m machinery.rank_three_scenarios
python3 -m unittest machinery.test_rank_three_scenarios -v
```

## 7. The `25`, derived

Added after §1--§6, closing the residue they left open.

**The pentagram's incidence structure is the complete graph `K_5`.** Its five
contexts are the vertices and its ten observables are the edges: each
observable lies on exactly two contexts, each pair of contexts meets in exactly
one observable, and each context holds four observables -- the four edges at a
vertex. (This `(10_2, 5_4)` configuration is elementary and classical; the
`K_5` reading is standard in the Saniga--Lévay--Planat treatment of the
pentagram. The reading is not what is new here.)

**Theorem 7.1 (the labelling).** The `25` reachable Lagrangians are in
canonical bijection with the cliques of size `1, 2, 3` in `K_5`, i.e. with the
nonempty subsets `S` of the five contexts with `|S| <= 3`:

| `\|S\|` | Lagrangians | how many pentagram observables it holds |
|---|---|---|
| 1 | the 5 context Lagrangians | 4 (the edges at that vertex) |
| 2 | 10 edge Lagrangians | 1 (that edge) |
| 3 | 10 triangle Lagrangians | 3 (the triangle's edges) |

Hence

    25 = 5 + 10 + 10 = C(5,1) + C(5,2) + C(5,3),      memory = 25 * 2^3 = 200.

The label is read off the overlap: a Lagrangian holding four observables lies
in a unique context (its vertex); one holding three holds exactly the three
edges of a triangle (verified: all `10` triangles occur, each once); one
holding a single observable is labelled by that edge (verified: all `10` edges
occur, each once). No reachable Lagrangian holds two or zero.

**Theorem 7.2 (the automaton).** Measuring the observable with edge `e` from
the state labelled `S`:

1. **comparable** -- `e ⊆ S` when `|S| >= 2`, or `S ⊆ e` when `|S| = 1` -- the
   observable already lies in the Lagrangian, the outcome is deterministic and
   `S` is unchanged;
2. else if `|S ∪ e| <= 3`, the label **grows**: `S ↦ S ∪ e`;
3. else the label **collapses**: for `|S| = 2` to `e ∪ (V ∖ (S ∪ e))`, the
   triangle on `e` plus the one remaining vertex; for `|S| = 3` to `S ∩ e`,
   the single shared vertex, or to `e` itself when the edge misses the triangle.

Verified on the **entire** transition relation: `3520` transitions, every one
matching the closed formula, and the determinism criterion in (1) holding
exactly (measurement is deterministic *iff* the labels are comparable).

**What the label means for the closure question.** The label size is exactly
the diagnostic of Corollary 3.2. For the Mermin square the contexts *are*
maximal Lagrangians, rule (2) never fires, every label has size one, and the
reachable set is the six contexts -- closure. For the pentagram the contexts
are not maximal, rule (2) fires, and the labels grow to size three. So

    closure  <=>  the label never leaves size one,

which is a statement one can check without computing the orbit at all. That is
the general form of what §2 exhibited as a counterexample.

**Scope.** Theorems 7.1 and 7.2 are exhaustive verifications over a finite
declared domain, hence proved on it. I have *not* derived rule (3) from the
symplectic geometry -- I computed which collapse occurs and checked the formula
everywhere. The bound `|S| <= 3` is likewise verified, not derived; the naive
dimension count permits `|S| = 4` (the six edges of a `4`-clique span three
dimensions) and something finer excludes it, which I have not identified.

Replay:

```sh
python3 -m machinery.pentagram_labels
python3 -m unittest machinery.test_pentagram_labels -v
```
