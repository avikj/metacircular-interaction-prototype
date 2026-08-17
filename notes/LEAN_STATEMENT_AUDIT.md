# Do the Lean statements say what the prose says? Five mismatches, one false

**Author.** claude (Hoare lineage), 2026-08-15.

**What this is.** The sweep `notes/LEAN_LANE_AUDIT.md` §6 declined: that audit
established which modules *build*, and said plainly that a green build "says
they are well-typed, **not** that their theorem statements match the prose that
cites them." This note does that comparison for the cited modules. It reads
terms and prose; it runs nothing. `LEAN_LANE_AUDIT` is the authority for build
status, and I did not re-run `lake build` — two siblings are editing the lane
right now (`lakefile.toml` globs; `native_decide` conversion), and a build
verdict taken mid-edit would be a lie about a moving tree.

## 0. Verdict

| question | answer |
|---|---|
| `.lean` files under `formal/pairfield/` | **132**, verified independently (`find … -not -path '*/.lake/*'`). Matches `LEAN_LANE_AUDIT`; the earlier "~108" was wrong. |
| modules named anywhere in `notes/` or `papers/` | 113 of 131 — but most only in an index row. **~25** are cited by a prose sentence that asserts content. |
| statement-vs-prose mismatches found | **5** |
| of those, prose claims something *false* | **1** (`papers/pairfield_monograph.md` §1.2, Lemma 1.3) |
| prose right, Lean weaker than advertised | **0 found.** The serious direction is clean in what I checked. |
| dominant defect shape | **hypothesis deletion in a summary line** — 4 of 5 |
| repaired in place, by addition, this session | 5 of 5 |

The single structural finding: **every mismatch is in a summarising line, none
in a note whose subject is the theorem.** `LEAN_STATUS.md` and
`WALK_SENSOR_THEOREM.md` carry explicit faithfulness sections and are exact.
The errors are in port maps, monograph abstracts, and cross-reference rows —
prose written *about* a theorem by someone not currently proving it. That is
where to look next, not in the primary notes.

---

## 1. The mismatches

### M1 — `Lorentz.lean` / monograph. **The prose statement is false.**

> **PROSE** (`papers/pairfield_monograph.md`:19)
> "the group of integral isometries of $S^2-D^2$ is $\{\pm I\}$ (Lemma 1.3 —
> no 'arithmetic Lorentz group')"

> **LEAN** (`formal/pairfield/Pairfield/Lorentz.lean`:24)
> ```lean
> theorem so11_int_eq_pm_one (M : Matrix (Fin 2) (Fin 2) ℤ)
>     (hJ : Mᵀ * J * M = J) (hdet : M.det = 1) : M = 1 ∨ M = -1
> ```

`det M = 1` is present in Lean and absent from the prose. The full integral
isometry group $O(1,1)(\mathbb Z)$ has **order four** —
$\{\pm I,\ \pm\operatorname{diag}(1,-1)\}$; check
$\operatorname{diag}(1,-1)^{\mathsf T}J\operatorname{diag}(1,-1)=J$, $\det=-1$.
It is $SO(1,1)(\mathbb Z)$ that is $\{\pm I\}$.

`notes/REPORT.md`:55, the source, says it correctly ("preserving the form … **and
orientation**"), as does `notes/LEAN_STATUS.md` and `notes/VV.md`. The monograph
dropped the clause when compressing. **Repaired**: footnote added at
`papers/pairfield_monograph.md`:19, dated and attributed. The deflationary
conclusion survives untouched — an order-four group of sign flips is no more a
boost dynamics than an order-two one — which is exactly why nobody caught it.

Same defect, milder, at `notes/ATIYAH.md`:52 ("the integral Lorentz group of
S²−D² is **trivial**"): orientation dropped, and "trivial" is loose for a group
of order two. Repaired by an in-place comment; the corollary ATIYAH draws is
unaffected.

### M2 — `ReversalRigidity.lean` / port map. Three hypotheses deleted.

> **PROSE** (`notes/LEAN_TO_CUBICAL_PORT_MAP.md`:77)
> "Theorem A′ core: irreducible monic `F` with `F(0)=1` is homometrically rigid
> (`G·rev G = F·rev F ⟹ G = F ∨ G = rev F`)"

> **LEAN** (`formal/pairfield/Pairfield/ReversalRigidity.lean`:64)
> ```lean
> theorem reversal_rigidity (F G : ℤ[X]) (hFirr : Irreducible F)
>     (hFm : F.Monic) (hGm : G.Monic) (hG0 : G.coeff 0 = 1)
>     (hdeg : G.natDegree = F.natDegree)
>     (h : G * G.reverse = F * F.reverse) : G = F ∨ G = F.reverse
> ```

The prose hypothesises only `F`. All three hypotheses on `G` are missing, and
`hGm` alone is load-bearing: take `G = -F`. Then `rev G = -rev F`, so
`G · rev G = F · rev F`, and `G ∉ {F, rev F}`. **The prose implication as
displayed is false.** This matters more than a normal typo because the row's
job is to tell a porter what to state in Agda.

`notes/LEAN_STATUS.md` §"Faithfulness notes" already records the hypotheses and
their justification correctly, so the term and the primary ledger agree; this
row was the outlier. **Repaired** by a quoted block after the table.

### M3 — `VisitedPairHorizon` / `ObservableVisitedPairAdapter`. Alphabet completeness suppressed.

> **PROSE** (`notes/OBSERVABLE_HORIZON.md` §5)
> $\operatorname{visitedPairWitness?}(x,y)=\texttt{none} \iff x\equiv_\infty y$
> and
> $\operatorname{ClosesAt}(n) \iff \forall x\equiv_n y,\ \operatorname{visitedPairWitness?}(x,y)=\texttt{none}$

> **LEAN** (`VisitedPairHorizon.lean`:129, `ObservableVisitedPairAdapter.lean`:24)
> ```lean
> visitedPairWitness?_eq_none_iff (M : DFA A X) (alphabet : List A)
>   (complete : ∀ action : A, action ∈ alphabet) (left right : X) : …
> observableClosesAt_iff_visitedPairWitness_none … (complete : …) (fuel : Nat) : …
> ```

The displayed operator is binary in the prose and ternary in Lean, and the
hypothesis `complete` is nowhere in §5 — which never introduces an alphabet at
all. It is not decorative: an incomplete `alphabet` never expands the missing
action, so `none` would certify a future equivalence that does not hold. Same
hypothesis on `visitedStatePairQueue_frontier_eq_nil` and
`exists_visited_pair_separator`, both asserted in the same paragraph.

The one clause of that paragraph that *is* hypothesis-free is `R(x,y) ≤ |X|²`
(`reachableStatePairCount_le_card_sq` needs no `complete`). **Repaired** by a
quoted correction inserted in §5.

### M4 — `GENERAL_SMITH_PRODUCER` §2. Right theorem, wrong file.

> **PROSE** (`notes/GENERAL_SMITH_PRODUCER.md`:45–52) — under the heading
> "`formal/pairfield/Pairfield/GeneralSmith2x2.lean`. Total, executable,
> proved.", a five-line `lean` block ending
> `theorem smith_d₁_eq_content (A : IntMat2) : (smith A).d₁ = (A.content : Int)`

> **LEAN** — that theorem is `formal/pairfield/Pairfield/SmithContent.lean`:164.
> `GeneralSmith2x2.lean` ends at `smith_det` (:545). The other four displayed
> lines are in `GeneralSmith2x2.lean` as shown.

No statement is overstated — §6′ and §7 of the same note attribute it to
`SmithContent.lean` correctly. Only the file is wrong, and only in §2.
**Repaired** in place.

### M5 — a naming hazard, not an error: two `FiniteInformation`s.

`notes/OBSERVABLE_HORIZON.md`:183 says "the **choice-free** descent theorem
already checked in `FiniteInformation`". The Agda
`NaturalMachine/FiniteInformation.agda` is choice-free; the Lean
`Pairfield/FiniteInformation.lean` is **not** — it invokes `Classical.choose`
three times (`factorsThrough_iff_fiberConstant`, `targetFiber_injects_side`),
which `LEAN_TO_CUBICAL_PORT_MAP.md`:54 states outright and makes the whole point
of the proposed port. Context (`RealizedWindow`, truncated image,
`isPropFactorsThrough`) fixes the reference as the Agda module, so the sentence
is true as intended. Left unedited — the fix is a judgement about a naming
convention across two lanes and belongs to the lane owner. Flagged because a
reader who resolves the bare name to the Lean file gets a false statement about
that file's axioms.

---

## 2. Checked and clean

Read term-first, then prose; no mismatch found.

| module | prose | verdict |
|---|---|---|
| `SumRigidity` (`convSq_inj_nat`, `sumMarginal_inj`, `convSq_inj_nonneg_ordered`) | `REPORT.md` §2 Thm A(1); `LEAN_STATUS.md` row A(i); `AGDA_COVERAGE_LEDGER` A1 | exact, incl. the 2026-08-15 ledger addition promoting `convSq_inj_nonneg` to the ordered-ring form — I re-read the term, the addition is accurate |
| `ObservableHorizon` §§1–4 | `OBSERVABLE_HORIZON.md` §§1–4 | exact. The fixed-instance danger is handled explicitly: `least_horizon_is_one` is stated over the named three-state control, and the prose says "the existing three-state control", not "in general" |
| `finiteDFA_observableClosesAt_card_sq` | "the depth-\|X\|² observable always closes" | exact, and the docstring pre-empts the obvious overread ("not a sharp queue-execution cost") |
| `LinearAdaptiveGap` (`adaptive_depth_isLeast`, `exact_linear_gap`) | `SEED30_LOWER_BOUND_AUDIT.md` rows 12–13 | **exact, including the quantifier.** `IsLeast {fuel \| IdentifiesAtDepth …} (n-1)` for all `n ≥ 2`, both directions, no `native_decide`. Row 12's strong claim ("a quantifier a finite exhaustion cannot give") is earned |
| `MyhillNerodeAdapter` | `MATHLIB_MYHILL_NERODE_ADAPTER.md` | exact; the biconditionals claimed are biconditionals in the term (`futureEq_iff_stateLanguage_eq`, `accepts_isRegular_iff_reachableBehavioralStates_finite`) |
| `LeastNonDivisor`, `FrontierOptimality` | `WALK_SENSOR_THEOREM.md` §1, §7 | exact; §7 is a model scope-limit section (names Theorem D as note-only) |
| `InvariantCorrectiveClosure` | "checks all of these statements over an arbitrary semiring and module" | exact — the file's variables are `[Semiring R] [AddCommMonoid M] [Module R M]`, and the header itself disclaims the theorems it does *not* prove |
| `SieveRestriction` | `LENS_CIRCUIT_COMPOSITION_CORRECTION.md` §"Checked witness" | exact, and it volunteers its own orphan status ("a focused green claim, not an aggregate-green claim") |
| `GoldbachBoundary`, `GoldbachDecision`, `GoldbachCrossover`, `RestrictedGoldbachEdge` | no prose overreach found | the terms are reductions and say so (`strongGoldbach_of_check_of_contamination_tail`); `papers/crossover.md` cites none of them and is emphatic that its theorems are about the local model |
| `HolonomyDescent` | `HOLONOMY_DESCENT.md`:31 | **prior correction verified by reading, not by trusting the message.** The false "checks" is struck through and a dated correction stands beneath it. Applied. |

---

## 3. Scope limits

- **I ran nothing.** No `lake build`, no `#print axioms`. Every verdict above is
  a reading of source against source. Build status is `LEAN_LANE_AUDIT`'s, as of
  its writing, and two siblings are mid-edit.
- **Not exhaustive.** ~25 modules carry a content-bearing prose sentence; I
  compared those. The remaining ~106 are either uncited, cited only in an index
  row, or cited by name without a statement — where a mismatch misleads nobody
  because nothing was claimed.
- **One count in `LEAN_LANE_AUDIT` no longer reproduces**, and it is not an
  error in that audit: it reports `native_decide` in 39 files; today the string
  occurs in **8**. A sibling is converting those sites right now. Anyone reading
  the 143/39/72 figures should date them to 2026-08-15 early.
- The 4 broken modules and the notes naming them are `LEAN_LANE_AUDIT` §2c's
  scope and I did not redo them, except to verify the `HOLONOMY_DESCENT` repair
  landed.
- M1's arithmetic ($O(1,1)(\mathbb Z)$ has order four) is a two-line hand check
  reproduced above, not a machine verdict.
