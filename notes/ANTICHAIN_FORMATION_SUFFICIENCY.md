# Non-chain formation sufficiency is controlled by a witness frontier

**Status.** Exact finite order-theoretic theorem. This answers
`FORMATION_SUFFICIENCY.md` §6.1. It generalizes that note's chain criterion;
it does not alter its arithmetic applications.

## 1. Setup

Let `P` be a finite poset of charts on a set `X`. Write `p ≤ q` when `q`
refines `p`, so

```text
chart_q(y) = chart_q(x)  =>  chart_p(y) = chart_p(x).
```

Fix a task `T : X -> Y`, a point `x ∈ S ⊆ X`, and assume some chart is
sufficient at `x` on `X`. For `A ⊆ X` containing `x`, define

```text
U_A(x) = { p ∈ P : for every y ∈ A,
                   chart_p(y) = chart_p(x) => T(y) = T(x) }.
```

`U_A(x)` is an upper set. Restriction can only add sufficient charts:
`U_X(x) ⊆ U_S(x)`. Let

```text
M_X(x) = Min(U_X(x))
```

be the antichain of ambient-minimal sufficient charts, and put

```text
F_X(x) = Max(P  ↑M_X(x)).
```

This is the **ambient failure frontier**: the maximal charts which do not
refine any ambient-minimal sufficient chart.

## 2. Frontier theorem

**Theorem.** The following are equivalent.

1. The formation-relative and ambient minimal antichains agree:
   `Min(U_S(x)) = M_X(x)`.
2. Every chart outside `↑M_X(x)` remains insufficient on `S`.
3. Every frontier chart `p ∈ F_X(x)` has a witness `y ∈ S` with

   ```text
   chart_p(y) = chart_p(x)  and  T(y) != T(x).                 (W_p)
   ```

When these conditions hold, the stronger equality `U_S(x) = U_X(x)` holds.

**Proof.** Since `P` is finite and `U_X(x)` is a nonempty upper set,

```text
U_X(x) = ↑M_X(x).                                             (1)
```

The same statement holds for `U_S(x)`. Hence equality of their minimal
antichains is equivalent to equality of the upper sets. Because restriction
already gives `U_X(x) ⊆ U_S(x)`, equality holds exactly when no
`p ∉ ↑M_X(x)` enters `U_S(x)`. Unfolding the definition of insufficiency is
exactly the existence of `(W_p)`. This proves `1 <=> 2` and the witness form
of `2`.

It remains to reduce all of the lower complement to its maximal frontier.
The complement `P \ ↑M_X(x)` is a lower set. Every one of its elements lies
below a maximal element `f ∈ F_X(x)`. A witness for `f` is also a witness for
every `p ≤ f`, because equality in the finer chart `f` implies equality in
the coarser chart `p`. Thus frontier witnesses imply witnesses throughout the
complement; the converse is immediate. Therefore `2 <=> 3`. ∎

## 3. Why “one witness per ambient minimum” is false

Take the diamond `0 < a,b < 1`. Suppose the ambient sufficient upper set is
`{b,1}`, so `M_X={b}`. On the formed set, let `a` also become sufficient.
The ambient minimum `b` has not lost minimality, but the new minimal antichain
is `{a,b}`. Checking only charts below `b` sees no defect. The failure frontier
is `{a}`, and its missing witness detects exactly the new incomparable branch.

Conversely, if the ambient sufficient upper set is `{a,b,1}`, then
`M_X={a,b}` and the failure frontier is `{0}`. One witness at `0` preserves
both incomparable minima. Witnesses therefore belong to maximal *failure
charts*, not intrinsically one-to-one to minimal successful charts.

These two diamonds are designed annihilation controls for the two tempting
false rules: “test only below each old minimum” and “allocate one distinct
witness to each old minimum.”

## 4. Chain reduction and consequence

For a finite chain with unique ambient minimum `k`, the failure frontier is
the immediate predecessor of `k` (when it exists). Condition `(W_p)` is then
exactly `FORMATION_SUFFICIENCY.md` condition `(W)`. The earlier theorem is not
merely analogous; it is the one-frontier-point specialization.

For a general finite lens lattice, non-chain minimality is therefore not an
interaction among an unspecified family of witnesses. It is a finite coverage
problem indexed by the antichain `F_X(x)`. One formed point may cover several
frontier charts, while some frontier charts may need different points. The
theorem identifies the exact obligations but makes no claim that the minimum
number of points realizing them is `|F_X(x)|`.

## 5. Rigor and provenance boundary

- Proved here: the three-way equivalence, frontier reduction, stronger upper-set
  equality, chain specialization, and the two diamond controls.
- Assumptions: a finite poset of charts, refinement-monotone chart equality,
  and at least one ambient-sufficient chart at the fixed point.
- Not claimed: a theorem for infinite chart posets without compactness or
  well-foundedness; an algorithm for constructing missing formed points; a
  probability law for witness availability; or independence among frontier
  obligations.
- Prior art: the proof is elementary finite-poset theory plus the definition of
  task sufficiency. No literature search has been performed, and no novelty
  claim is made. The contribution is the exact answer to the repository's
  stated non-chain formation question.
  **PRIOR-ART SWEEP 2026-08-14 — searched; RESOLVED-FOUND for the order theory,
  RESOLVED-NO-MATCH for the packaging** (search-summary/śabda grade; `WebFetch`
  EGRESS_BLOCKED, no source text read). The frontier reduction and the
  stronger upper-set equality are instances of the classical finite-poset
  bijection $S\mapsto\,\uparrow\!S$ between antichains and up-closed subsets
  (equivalently $S\mapsto\,\downarrow\!S$ for down-sets), with the antichain
  recovered as the minimal elements — standard order theory, e.g. P. J.
  Cameron's Combinatorics Study Group poset notes, and used as the working
  representation in C. A. Gunter and T.-H. Ngair, *Sets as Anti-Chains*. So
  the row's own reading is right and can be stated flatly: **the order theory
  here is known mathematics**; what is this note's is the identification of
  chart-refinement sufficiency with it. Nothing was located on task/chart
  sufficiency in that form. Query: *antichain of minimal elements upper set
  finite poset bijection sufficiency frontier obligations equivalence theorem*.
  Absence of a located source is not evidence of novelty. Attribution status
  only; the three-way equivalence and both diamond controls are untouched.

