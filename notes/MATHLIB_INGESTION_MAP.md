# Mathlib ingestion map: what the largest formalized library already has, against this corpus

**Task type.** Reading/ingestion. No new mathematics is produced here, no
experiment was run, no file outside this one was written. Every declaration
name below was obtained by grepping the mathlib source, not from memory.

**Provenance.** `~/agda-libs/mathlib4`, blobless shallow clone,
`HEAD = 9058eaf3aa64912a91b80832a3c1c7e632094997` (2026-08-14),
toolchain `leanprover/lean4:v4.34.0-rc1`. Our Lean lane
(`formal/pairfield/lakefile.toml`) pins mathlib **`v4.33.0`**, toolchain
`leanprover/lean4:v4.33.0`, manifest rev `db584cd6…`. The `v4.33.0` tag was
fetched into the same clone and **every module recommended in §10 below was
verified present at `v4.33.0`**, so none of the recommendations require a
toolchain bump. Where a name is only known at HEAD it is marked.

**Companion documents.** `notes/CUBICAL_LIBRARY_SUBSUMPTION_AUDIT.md` does the
same job for the cubical Agda lane against `~/agda-libs/cubical`;
`notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md` does it for one module against the
coalgebra literature. This file is the mathlib half and does not repeat them.

---

## 1. Scale

| quantity | mathlib @ HEAD (2026-08-14) | mathlib @ v4.33.0 (what we build against) | our Lean lane | our Agda lane |
|---|---|---|---|---|
| `.lean` / `.agda` modules | **8 324** | 8 311 | 22 | 59 |
| lines (library source) | 2 293 684 | — | 2 917 | ~14 k |
| ratio to our Lean lane | **≈ 786 ×** by line count | | 1 | |

Top-level areas by module count:

| area | modules | | area | modules |
|---|---:|---|---|---:|
| `Algebra` | 1349 | | `AlgebraicTopology` | 161 |
| `CategoryTheory` | 1098 | | `Geometry` | 145 |
| `Analysis` | 795 | | `AlgebraicGeometry` | 140 |
| `RingTheory` | 719 | | `Probability` | 137 |
| `Topology` | 680 | | `FieldTheory` | 84 |
| `Data` | 650 | | `Logic` | 57 |
| `LinearAlgebra` | **372** | | `SetTheory` | 56 |
| `Tactic` | 360 | | `RepresentationTheory` | 43 |
| `Order` | 315 | | **`Computability`** | **35** |
| `MeasureTheory` | 314 | | `ModelTheory` | 34 |
| **`NumberTheory`** | **242** | | `Dynamics` | 34 |
| `Combinatorics` | 199 | | `Condensed` | 34 |
| **`GroupTheory`** | **167** | | `Control` | 25 |

The five areas adjacent to us are bolded: `Computability` (35),
`LinearAlgebra` (372), `NumberTheory` (242), `GroupTheory` (167),
`CategoryTheory` (1098). Note the shape of the adjacency: the two areas where
our corpus has the most material — automata and integer-matrix normal forms —
sit in the two *smallest* relevant mathlib namespaces. That is the single most
useful structural fact in this document, and §9 draws the consequence.

**How much of mathlib the Lean lane currently uses.** Twenty-two modules; the
complete set of non-`Tactic` mathlib imports across all of them is:

```
Mathlib.Computability.MyhillNerode      Mathlib.Data.Int.GCD
Mathlib.Data.Set.Image                  Mathlib.Data.Int.Basic
Mathlib.LinearAlgebra.Vandermonde       Mathlib.Algebra.EuclideanDomain.Int
Mathlib.GroupTheory.QuotientGroup.Basic Mathlib.Algebra.Module.Submodule.Invariant
Mathlib.Algebra.GroupWithZero.Action.Basic
```

Nine modules out of 8 311, plus four files that `import Mathlib` wholesale
(`Lorentz`, `SumRigidity`, `ReversalRigidity`, `CapabilityGraph`). Nothing in
`Mathlib/LinearAlgebra/FreeModule/`, nothing in `Mathlib/Algebra/Module/PID`,
nothing in `Mathlib/GroupTheory/GroupAction/`, nothing in
`Mathlib/NumberTheory/` at all.

---

## 2. The substrate barrier, stated once

mathlib is Lean 4, classical, choice-based. `#print axioms` on our own Lean
targets already returns `[propext, Classical.choice, Quot.sound]`
(`notes/LEAN_STATUS.md`), so **the Lean lane pays no additional price for any
mathlib import**: it is already inside mathlib's axiom envelope. The barrier
is entirely on the Agda side.

Three grades are used in every table below:

- **(a) usable today** — importable into `formal/pairfield/` at the pinned
  `v4.33.0` with no porting work. The only cost is compile time.
- **(b) transcribable at stated cost** — the statement is constructively
  meaningful and could be re-proved in `--cubical --safe`, but mathlib's proof
  cannot be copied: it uses `Classical.choice` (all `noncomputable def`s
  produced by `choose`), decidable equality on arbitrary types, `Set.Finite`
  via `Nonempty (Fintype _)`, or quotient types with `Quot.sound` where cubical
  wants a HIT. Cost is stated per row.
- **(c) unusable** — depends on classical analysis, measure theory, topology on
  ℝ/ℂ, or is a `Prop`-level existence statement whose content is exactly the
  choice we cannot make. Not portable to cubical at any reasonable cost;
  usable only in the Lean lane.

A fourth category is worth naming because it recurs: mathlib's Smith normal
form, its structure theorem for f.g. modules over a PID, and its
Myhill–Nerode automaton are all **existence statements**. They tell you a
diagonal basis / a decomposition / a minimal DFA *exists*. Our corpus's
distinguishing asset in every one of these places is **an executable producer
with a checkable certificate**. mathlib does not have that anywhere in the
Smith thread. This is not a small difference and it is the reason §9 does not
conclude "delete the Lean Smith lane".

---

## 3. Myhill–Nerode / automata / regular languages

### 3.1 What mathlib states and proves

`Mathlib/Computability/` — 35 modules. The relevant four:

**`Mathlib/Computability/Language.lean`**
- `Language α := Set (List α)`; `instSemiring : Semiring (Language α)` (`+` = union, `*` = concatenation, `1` = `{[]}`, `0` = `∅`); `instance : KleeneAlgebra (Language α)` with `l∗`.
- `Language.map : (α → β) → Language α →+* Language β`, `Language.reverse`, `Language.self_eq_mul_add_iff` (Arden's lemma, in the form `[] ∉ m → (l = m * l + n ↔ l = m∗ * n)`).

**`Mathlib/Computability/DFA.lean`**
- `structure DFA (α σ) := (step : σ → α → σ) (start : σ) (accept : Set σ)`.
- `DFA.evalFrom (s : σ) : List α → σ`, `DFA.eval`, `evalFrom_of_append`, `eval_append_singleton`.
- `DFA.acceptsFrom (s : σ) : Language α := {x | M.evalFrom s x ∈ M.accept}`; `DFA.accepts := M.acceptsFrom M.start`.
- `DFA.pumping_lemma [Fintype σ]`, `DFA.evalFrom_split`, `DFA.evalFrom_of_pow`.
- `DFA.comap`, `DFA.reindex`, `DFA.union`, `DFA.inter`, `instance : Compl (DFA α σ)` with `accepts_compl`, `accepts_union`, `accepts_inter`.
- `Language.IsRegular L := ∃ σ, _ : Fintype σ, ∃ M : DFA α σ, M.accepts = L`; `isRegular_iff`, `IsRegular_compl`, `IsRegular.add`, `IsRegular.inf`.

**`Mathlib/Computability/MyhillNerode.lean`** (105 lines, the whole file)
- `Language.leftQuotient (x : List α) : Language α := {y | x ++ y ∈ L}`; `leftQuotient_nil`, `leftQuotient_append`, `mem_leftQuotient`.
- `Language.leftQuotient_accepts_apply (M : DFA α σ) (x) : M.accepts.leftQuotient x = M.acceptsFrom (M.eval x)`; `leftQuotient_accepts : leftQuotient M.accepts = M.acceptsFrom ∘ M.eval`.
- `Language.IsRegular.finite_range_leftQuotient : L.IsRegular → (Set.range L.leftQuotient).Finite`.
- `Language.toDFA : DFA α (Set.range L.leftQuotient)` — the **Nerode automaton**, states = residual languages, `step s a = s.leftQuotient [a]`, `start = L`, `accept = {s | [] ∈ s}`; with `mem_accept_toDFA`, `step_toDFA`, `start_toDFA`, `accepts_toDFA : L.toDFA.accepts = L`.
- `Language.IsRegular.of_finite_range_leftQuotient`, and the theorem the file exists for: `Language.isRegular_iff_finite_range_leftQuotient : L.IsRegular ↔ (Set.range L.leftQuotient).Finite`.

**`Mathlib/Computability/NFA.lean` / `EpsilonNFA.lean` / `RegularExpressions.lean`**
- `NFA.toDFA` (subset construction) + `NFA.toDFA_correct`; `DFA.toNFA` + `toNFA_correct`; `εNFA.toNFA` + `toNFA_correct`; `NFA.reverse` and `Language.IsRegular.reverse` / `isRegular_reverse_iff`.
- `RegularExpression`, `matches'`, `deriv` (Brzozowski), `rmatch`, `rmatch_iff_matches'`, `DecidablePred (· ∈ P.matches')`.

### 3.2 Against our objects

| our object | mathlib module + declaration | verdict | usable today? |
|---|---|---|---|
| `Pairfield.run : (X → A → X) → X → List A → X` | `DFA.evalFrom` (`Computability/DFA.lean:74`) | **SUBSUMES** — our own `MyhillNerodeAdapter.run_eq_evalFrom` proves them equal. `run` is a redundant definition kept alive only by `FutureBehavior`. | (a) |
| `Pairfield.stateLanguage M x` | `DFA.acceptsFrom` (`DFA.lean:118`) | **SUBSUMES** — our definition is literally `M.acceptsFrom x`; it is an alias, not a construction. | (a) |
| `Pairfield.FutureEq step observe` at `O = Prop`/`Bool` | kernel of `DFA.acceptsFrom`; the equivalence is `MyhillNerodeAdapter.futureEq_iff_stateLanguage_eq` | **SUBSUMES** (already bridged by us) | (a) |
| `Pairfield.FutureEq` at **arbitrary observation type `O`** | *nothing* — mathlib's automata are Boolean-acceptance only; there is no Moore machine, no `σ → O` output map anywhere in `Computability/` | **UNCOVERED** | — |
| `futureEq_of_finer`, `futureEq_pair_iff` (refinement / joint observation lattice) | *nothing* | **UNCOVERED** (they are only meaningful for general `O`) | — |
| `Pairfield.futureSetoid` + `quotientStep` + `quotientObserve` (state-side behavioural quotient) | `Language.toDFA` is the *language-side* Nerode automaton; mathlib never quotients a given DFA's state set | **BRIDGED ON THE REACHABLE CARRIER** — `behavioralLanguage_image_reachable` identifies its residual-language image exactly with `Set.range M.accepts.leftQuotient`; unreachable ambient meanings deliberately remain outside the theorem. | (a) |
| `quotientBehavior_injective` (distinct meanings ⇒ distinct futures) | *nothing* in mathlib; the local adapter theorem is `behavioralLanguage_injective` | **BRIDGED LOCALLY** for Boolean DFA observation; mathlib still does not state automaton minimality | (a) |
| `Pairfield.BehavioralBFS` (executable shortest distinguishing word) | *nothing* — no minimization algorithm, no Hopcroft/Moore partition refinement, no distinguishing-word search in mathlib | **UNCOVERED BY MATHLIB, NOW CONNECTED** — `ResidualBFS` transports its bounded shortest certificates to prefix left quotients. | (a), local |
| Agda `NaturalMachine/FutureBehavior.agda` (445 lines) | same as the three rows above, plus `PFunctor.M` / `QPF.Cofix` for the coalgebraic framing (§6) | **SUBSUMED in content** for `O = Bool`; the general-`O` and cubical-effectivity parts are ours | (b), high cost |

### 3.3 What `MyhillNerodeAdapter.lean` now bridges, and what remains

Original bridge: `stateLanguage`, `run_eq_evalFrom`,
`futureEq_iff_stateLanguage_eq`, `leftQuotient_eq_stateLanguage_eval`,
`stateLanguage_step`, `leftQuotient_eq_iff_futureEq_eval`, `BehavioralState`,
`selectNext` / `selectNext_mk`, `quotient_action_residual`. In mathlib terms it
bridges to exactly three declarations: `DFA.acceptsFrom`, `DFA.evalFrom`, and
`Language.leftQuotient_accepts_apply`.

The 2026-08-14 ingestion adds `behavioralLanguage`, proves it injective,
identifies its image on `reachableBehavioralStates` exactly with the range of
left quotients, and transports
`Language.isRegular_iff_finite_range_leftQuotient` to

```lean
M.accepts.IsRegular ↔ (reachableBehavioralStates M).Finite.
```

The concurrent `ResidualBFS` return then connects shortest witnesses to prefix
residuals and, under an explicit ambient `[Fintype X]`, uses the synchronous
pair monitor plus `DFA.evalFrom_split` to install the safe horizon `|X|^2`.
The later `ReachableChart` return supplies the missing effective datum as
`FiniteBehavioralPresentation M`.  `NerodeChartAdapter` now turns Mathlib's
`Language.toDFA` into the canonical instance: its states are exactly the left
quotients, its chosen concrete representatives preserve state language, and
Lean proves the chart reachable, reduced, and language-preserving.  The
construction from regularity is explicitly `noncomputable`; it does not
extract executable rows from `Set.Finite`.

The reciprocal audit now also proves
`M.accepts.IsRegular ↔ Nonempty (FiniteBehavioralPresentation M)` and the
global Myhill--Nerode cardinal lower bound: the canonical residual state type
injects into the state type of every finite DFA recognizing the same language.
The later `ReachableSubDFA`, `ChartQuotient`, and `ExecutableMinimization`
returns close constructive reduction of supplied executable chart data:
unreachable rows are removed, equal futures are quotiented, the recognized
language is preserved, and the result is globally cardinal-minimal.

The next cost layer is `VisitedReach`. Its checked global `Nodup` invariant
meets Mathlib's `List.Nodup.length_le_card` in
`VisitedReachCardinality`, giving the exact native budget

```lean
(runReachQueue M alphabet round).states.length ≤ Fintype.card X.
```

The reciprocal return then closes the missing layer invariant.  Mathlib
`DFA.evalFrom_split` supplies loop deletion, every frontier word at round `n`
has length exactly `n`, every retained word is globally shortest, and a
frontier node at round `|X|` would therefore contradict its shorter loop-free
representative.  Hence the frontier at `|X|` is empty and the queue is a fixed
point.  The bound remains a bound on retained discoveries and completed
expansions, not on raw candidate edges generated before freshness filtering.

`VisitedPairHorizon` specializes that result to the live synchronous product
monitor.  Mathlib `Fintype.card_prod` identifies its ambient horizon with
`|X|²`, while the native `reachableStatePairCount` records the often smaller
number of pairs actually expanded.  `VisitedPair` proves the first retained
separator globally shortest and preserves the full distinguishing derivation
fibre.  Finally `ObservableVisitedPairAdapter` checks the exact semantic seam

```lean
ObservableClosesAt M.step (acceptsBool M) fuel ↔
  ∀ left right,
    BoundedFutureEq M.step (acceptsBool M) fuel left right →
      visitedPairWitness? M alphabet left right = none.
```

Thus bounded observable formation and the executable stable pair queue are
now literally the same proposition.  The safe global horizon is `|X|²`; its
sharp least value still requires aggregating the pair-labelled shortest
witnesses over the whole finite presentation.

The reciprocal `VisitedResidual` module continues the transport to Mathlib's
native residual languages.  Its visited query returns `none` exactly when the
two `Language.leftQuotient`s agree.  Every returned word is a globally shortest
separating suffix, its minimum length agrees with the exhaustive Mathlib query,
and `ResidualSeparatorFiber` preserves the full family of separators.

**Still unbridged:**

1. **Bridged 2026-08-14:** `Language.toDFA` and `accepts_toDFA` — `NerodeChartAdapter` packages the canonical residual automaton as a native `FiniteBehavioralPresentation`, proves all states reachable and behaviorally reduced, and preserves all DFA operations used here. The bridge is classical/noncomputable, not an executable enumeration extracted from regularity. Mathlib itself still does not state DFA minimality.
2. `DFA.pumping_lemma` — never invoked.
3. `DFA.union` / `inter` / `Compl` / `IsRegular.add` / `IsRegular.inf` / `IsRegular_compl` — the Boolean algebra of behaviours. `futureEq_pair_iff` is the observation-side shadow of `DFA.inter`; the connection is unmade.
4. `Language.leftQuotient_append` — our `stateLanguage_step` is only the one-letter case; the word case is free from mathlib.
5. `NFA.toDFA` / `isRegular_reverse_iff` — nothing in our corpus is nondeterministic, but `ReversalRigidity` and `CROSS_REVERSAL_CHARGE` are about reversal, and `Language.reverse` + `isRegular_reverse_iff` exist.
6. `KleeneAlgebra (Language α)` — the semiring structure on behaviours. Unused.

**Genuine gap, stated plainly:** mathlib has no **Kleene theorem**. `RegularExpression.matches'` is never connected to `Language.IsRegular`; there is no `IsRegular_iff_exists_regularExpression`. It also has no DFA **minimality** theorem and no **bisimulation** for automata (it has bisimulation only for M-types, §6). If the corpus wants any of those three it must prove them.

---

## 4. Smith normal form / integer matrices / modules over a PID

### 4.1 What mathlib has

**`Mathlib/LinearAlgebra/FreeModule/PID.lean`** (`R` a PID, `M` free f.g.)
- `structure Module.Basis.SmithNormalForm (N : Submodule R M) (ι) (n : ℕ)` with fields `bM : Basis ι R M`, `bN : Basis (Fin n) R N`, `f : Fin n ↪ ι`, `a : Fin n → R`, and `snf : ∀ i, (bN i : M) = a i • bM (f i)`.
- `Submodule.exists_smith_normal_form_of_le`, `Submodule.smithNormalFormOfLE`, **`Submodule.smithNormalForm (b : Basis ι R M) (N : Submodule R M) : Σ n, Basis.SmithNormalForm N ι n`**, `Submodule.smithNormalFormOfRankEq`, `Submodule.exists_smith_normal_form_of_rank_eq`, `Submodule.smithNormalFormTopBasis` / `…BotBasis` / `…Coeffs`.
- `Submodule.basisOfPid`, `Submodule.basisOfPidOfLE` (a submodule of a f.g. free module over a PID is free).
- `Module.Basis.SmithNormalForm.repr_eq_zero_of_notMem_range`, `repr_apply_embedding_eq_repr_smul`, `coord_apply_embedding_eq_smul_coord`, `toMatrix_restrict_eq_toMatrix`.

**`Mathlib/Algebra/Module/PID.lean`**
- `Module.equiv_free_prod_directSum` — **structure theorem for f.g. modules over a PID**: `∃ n ι _ p (_ : ∀ i, Irreducible (p i)) e, Nonempty (M ≃ₗ[R] (Fin n →₀ R) × ⨁ i, R ⧸ R ∙ p i ^ e i)`.
- `Module.equiv_directSum_of_isTorsion`, `Module.exists_ker_toSpanSingleton_eq_annihilator`.

**`Mathlib/GroupTheory/FiniteAbelian/Basic.lean`**
- `AddCommGroup.equiv_free_prod_directSum_zmod` (f.g. abelian groups), `AddCommGroup.equiv_directSum_zmod_of_finite`, `equiv_directSum_zmod_of_finite'`, `CommGroup.equiv_prod_multiplicative_zmod_of_finite`, `CommGroup.equiv_free_prod_prod_multiplicative_zmod`.

**`Mathlib/LinearAlgebra/FreeModule/Int.lean`** and **`…/Finite/CardQuotient.lean`**
- `Module.Basis.SmithNormalForm.toAddSubgroup_index_eq_pow_mul_prod`, `…toAddSubgroup_index_eq_ite`, `…toAddSubgroup_index_ne_zero_iff`, `Submodule.submodule_toAddSubgroup_index_ne_zero_iff`, `AddSubgroup.subgroup_index_ne_zero_iff`.
- `Submodule.natAbs_det_equiv`, `Submodule.natAbs_det_basis_change`, `AddSubgroup.index_eq_natAbs_det`, `AddSubgroup.relIndex_eq_natAbs_det` — index of a sublattice = |det| of the change of basis.

**Related**: `Mathlib/LinearAlgebra/FreeModule/Norm.lean` (`associated_norm_prod_smith`, `Ideal.smithCoeffs`), `Mathlib/RingTheory/Bezout.lean` (`IsBezout`), `Mathlib/RingTheory/PrincipalIdealDomain.lean`, `Mathlib/LinearAlgebra/Matrix/Transvection.lean` (`Matrix.transvection`, `TransvectionStruct`, `isUnit_prod_comp_inverse`, `det_toMatrix_prod` — elementary matrices, used for diagonalization **over a field**), `Mathlib/LinearAlgebra/Matrix/Echelon/{Basic,Pivot,Decomposition}.lean` (`Matrix.IsRowEchelon`, `IsReducedRowEchelon`, `IsPivotedBy`, `Matrix.Echelon.Decomposition`).

### 4.2 What mathlib does **not** have (grep-verified)

- **No matrix-form Smith normal form.** There is no declaration anywhere in mathlib of the shape `∃ U ∈ GL m ℤ, ∃ V ∈ GL n ℤ, U * A * V = diagonal d ∧ ∀ i, d i ∣ d (i+1)`. Every occurrence of "Smith" in the source is either `Basis.SmithNormalForm`, `Ideal.smithCoeffs`, or an author surname. mathlib's SNF is a statement about **bases of a submodule**, never about a matrix.
- **No computable Smith.** `Submodule.smithNormalForm` is `noncomputable`, produced by `choose` from `exists_smith_normal_form_of_le`, whose proof is an induction on rank using `Submodule.basis_of_pid_aux`. It cannot be `#eval`'d.
- **No uniqueness of invariant factors.** `grep -i 'invariantFactor\|invariant factor'` over all 8 324 modules returns nothing. mathlib proves the `a : Fin n → R` exist; it never proves they are determined up to units.
- **No Hermite normal form.** `grep -i 'hermite normal'` returns nothing.
- **No content/gcd-of-entries of a matrix.** `Polynomial.content` exists; there is no `Matrix.content`.
- **No certificate/checker layer** of any kind for linear algebra.

### 4.3 Against our objects

| our object | mathlib | verdict | usable today? |
|---|---|---|---|
| the *existence* content of the whole 2×2 thread: "every `A : IntMat2` has a Smith presentation with the four normal-form side conditions" (`R0027`–`R0046`, `arbitrarySmithPresentation'`) | `Submodule.smithNormalForm` at `R = ℤ`, `ι = Fin 2`, `M = Fin 2 → ℤ`, `N = range of A` | **SUBSUMES**, and at arbitrary size over an arbitrary PID. The existence half of ~1 400 lines of our Lean is a specialization of one mathlib `def`. | (a) |
| `Pairfield.smith : (A : IntMat2) → SmithResult A` — total, executable, WF-terminating producer (`GeneralSmith2x2.lean`, 565 lines) | *nothing computable* | **ADVANCES BEYOND** — mathlib has no executable SNF at any size. This is the Lean lane's strongest genuinely-non-duplicated asset. | — |
| `SmithCertificate2` + `Valid` + `check_sound` / `check_complete` (decidable independent checker) | *nothing* | **ADVANCES BEYOND** — mathlib has no proof-carrying-certificate idiom in linear algebra. | — |
| `SmithPresentation` + `comp` + `comp_replay` (composable exact presentation arrows) | `Matrix.TransvectionStruct` composes elementary matrices with `isUnit_prod_comp_inverse` / `reverse_inv_prod_mul_prod`; the *idea* is present, the typed-arrow packaging is not | **OVERLAP** — the unimodularity bookkeeping (`unimodular_mul`, `det_mul`, `IntMat2.inv`, `inv_mul`, `mul_inv`) is `Matrix.det_mul` + `Matrix.adjugate` + `Matrix.isUnit_iff_isUnit_det` re-proved by hand for 2×2. | (a) for the bookkeeping |
| `IntMat2.content`, `content_mul_left/right`, `smith_d₁_eq_content` | *nothing* | **UNCOVERED** — plainly absent from mathlib. (It is textbook: `d₁ = gcd` of the 1×1 minors. Absent nonetheless.) | — |
| `smith_d₂_mul_content`, `smith_det` | *nothing directly*; the determinant statement is `Submodule.natAbs_det_equiv` in disguise | **UNCOVERED as stated**; **SUBSUMED in content** by `AddSubgroup.index_eq_natAbs_det` for the index reading | (a) for the index reading |
| `source_of_replay`, `SmithCertificate2.source_injective` (`CertificateSource.lean`) | `Matrix.isUnit_iff_isUnit_det`, `Matrix.nonsing_inv` — inverting a unimodular integer matrix is `Matrix.adjugate` over ℤ | **SUBSUMES** the mechanism (a unimodular matrix over ℤ has an integral inverse); the *conclusion* (no irreducible quotient trace) is ours | (a) |
| `NaturalMachine/SmithCapability.agda` wrapping `Cubical.Algebra.IntegerMatrix.Smith.smith` (arbitrary `m × n`, constructive, computable, with L/R transforms and replay equation) | *strictly stronger than mathlib's* — mathlib cannot compute; cubical can | **ADVANCES BEYOND mathlib** | n/a (Agda) |
| index / order of `ℤ²/AZ²` computations anywhere in the Smith notes | `AddSubgroup.index_eq_natAbs_det`, `Submodule.natAbs_det_basis_change`, `Basis.SmithNormalForm.toAddSubgroup_index_eq_pow_mul_prod` | **SUBSUMES** | (a) |
| any classification of the finite abelian group `ℤ²/AZ²` by invariant factors | `AddCommGroup.equiv_directSum_zmod_of_finite'` | **SUBSUMES** | (a) |

**The blunt version.** Of the Smith thread, mathlib subsumes the *mathematics*
(existence, structure theorem, index formulas, at arbitrary size over arbitrary
PIDs) and covers none of the *engineering* (executable producer, decidable
certificate, composable presentation arrows, source recovery). The corpus has
consistently written the mathematics and called it the result; the engineering
was the result.

---

## 5. Number theory (the analytic lane)

**Situation first:** the analytic lane (`E2`, `E2b`, `MERTENS_FLOOR`,
`DRIFT_EXPONENT`, `ENERGY`, `ENERGY_CONSTANT_EXACT`, `APPENDIX_D`) is **entirely
unformalized**. `find . -name '*.lean' -not -path './formal/pairfield/*'`
returns nothing; `formal/pairfield/` contains zero `Mathlib.NumberTheory`
imports. So every row below is a statement about what the lane *could* import,
not about a duplication that exists.

| our object / need | mathlib module + declaration | verdict | usable today? |
|---|---|---|---|
| von Mangoldt Λ | `Mathlib/NumberTheory/ArithmeticFunction/VonMangoldt.lean`: `ArithmeticFunction.vonMangoldt` (notation `Λ`), `vonMangoldt_apply`, `vonMangoldt_apply_prime`, `vonMangoldt_sum : ∑ i ∈ n.divisors, Λ i = Real.log n`, `vonMangoldt_mul_zeta : Λ * ζ = log`, `moebius_mul_log_eq_vonMangoldt`, `sum_moebius_mul_log_eq`, `vonMangoldt_le_log` | **SUBSUMES** the elementary identities `E2_PROOF` §1.0 uses to set up `Λ♯`/`Λ♭` | (a) |
| Dirichlet convolution, μ, ζ, Möbius inversion | `Mathlib/NumberTheory/ArithmeticFunction/Defs.lean`: `ArithmeticFunction R`, `Mul` = Dirichlet convolution, `CommRing`, `IsMultiplicative`. `…/Moebius.lean`: `moebius` (`μ`), `moebius_mul_coe_zeta`, `coe_zeta_mul_moebius`, `zetaUnit`, `sum_eq_iff_sum_smul_moebius_eq`, `sum_eq_iff_sum_mul_moebius_eq`, `isMultiplicative_moebius`. `…/Misc.lean`: `ArithmeticFunction.id`, `pow`, `sigma`, `cardFactors` (Ω), `cardDistinctFactors` (ω) | **SUBSUMES** every convolution manipulation in `MERTENS_FLOOR` §1 and `E2_PROOF` §1 | (a) |
| totient φ, `φ = μ * Id` | `Mathlib/Data/Nat/Totient.lean`: `Nat.totient`, `sum_totient : n.divisors.sum φ = n`, `totient_mul`, `totient_prime_pow`, `totient_eq_prod_factorization`, `ZMod.card_units_eq_totient` | **SUBSUMES** | (a) |
| Bézout / extended Euclid (`KuttakaValli.agda`, `ARITHMETIC_LIFE_BEZOUT_INVERSE`) | `Mathlib/Data/Int/GCD.lean`: `Nat.xgcd`, `Nat.gcdA`, `Nat.gcdB`, `Nat.gcd_eq_gcd_ab`, `Int.gcd_eq_gcd_ab`; `Mathlib/Algebra/EuclideanDomain/Basic.lean`: `EuclideanDomain.gcd_eq_gcd_ab`; `Mathlib/RingTheory/Bezout.lean`: `IsBezout` | **SUBSUMES** the arithmetic; the vallī-as-syntax / `replayHom` / `detReplay` monoid-morphism framing in `KuttakaValli.agda` is **UNCOVERED** | (a) for the arithmetic |
| Chebyshev ψ, θ | `Mathlib/NumberTheory/Chebyshev.lean`: `Nat.psi` (`ψ`), `Nat.theta` (`θ`), `psi_eq_sum_Icc`, `theta_eq_sum_primesLE_log`, `theta_le_log4_mul_x`, `psi_mono`, `theta_eq_log_primorial`, `Nat.lcmUpto`. Plus `Mathlib/NumberTheory/PrimeCounting.lean`: `Nat.primeCounting` (`π`), `primesBelow`, `primesLE` | **SUBSUMES** the elementary Chebyshev bounds; **does NOT cover** ψ(x) ~ x | (a) |
| Riemann zeta, its zeros | `Mathlib/NumberTheory/LSeries/RiemannZeta.lean`: `riemannZeta`, functional equation via `…/AbstractFuncEq.lean` + `HurwitzZeta*`; `…/Nonvanishing.lean` (ζ(1+it) ≠ 0); `…/ZetaZeros.lean`: `riemannZetaZeros`, `isClosed_riemannZetaZeros`, `isDiscrete_riemannZetaZeros`, `IsCompact.inter_riemannZetaZeros_finite` | **SUBSUMES** the "zeros are discrete, finitely many in a box" hygiene `ENERGY.md` assumes | (a) |
| Γ reflection formula (E2b uses exact reflection moduli) | `Mathlib/Analysis/SpecialFunctions/Gamma/Beta.lean`: `Complex.Gamma_mul_Gamma_one_sub : Γ z * Γ (1-z) = π / sin (π z)`, `Real.Gamma_mul_Gamma_one_sub`, `Gamma_mul_Gamma_add_half` | **SUBSUMES** | (a) |
| Abel/partial summation (`DRIFT_EXPONENT`, `MERTENS_FLOOR` tail work) | `Mathlib/NumberTheory/AbelSummation.lean`: `sum_mul_eq_sub_sub_integral_mul`, `sum_mul_eq_sub_integral_mul₀`, `tendsto_sum_mul_atTop_nhds_one_sub_integral`, `summable_mul_of_bigO_atTop` | **SUBSUMES** | (a) |
| sieve upper bounds | `Mathlib/NumberTheory/SelbergSieve.lean`: `BoundingSieve`, `SelbergSieve`, Λ² sieve diagonalisation | **SUBSUMES** the sieve scaffolding | (a) |
| **Mertens' theorems** (1st, 2nd, 3rd) and the **Mertens function** `M(x) = ∑_{n≤x} μ(n)` — the object `MERTENS_FLOOR.md` derives `c(Q) = c₀ + ½M(Q)` about | **ABSENT.** `grep -i mertens` over all 8 324 modules returns only `Mathlib/RingTheory/Polynomial/ContentIdeal.lean:38`, a TODO for the unrelated **Dedekind–Mertens lemma**. mathlib has `Nat.Primes.not_summable_one_div` (`SumPrimeReciprocals.lean`) — divergence of ∑1/p — and nothing else in this direction | **UNCOVERED** | — |
| **Prime Number Theorem** | **ABSENT.** Named only as a downstream goal in `LSeries/Nonvanishing.lean:25`; lives in the external `PrimeNumberTheoremAnd` project (Kontorovich et al.), from which `Chebyshev.lean` was partially upstreamed | **UNCOVERED** | — |
| **Explicit formula** (truncated von Mangoldt), **Perron's formula**, **Riemann–von Mangoldt N(T)** — all three load-bearing in `E2b_PROOF` | **ABSENT.** `grep -i 'explicit formula\|perron\|riemann.?von.?mangoldt'` finds nothing in `NumberTheory/` | **UNCOVERED** | — |
| **Ramanujan sums** `c_q(n)` — the definition `Λ♯_Q = ∑_{q≤Q} (μ(q)/φ(q)) c_q` in `E2_PROOF` §1.0 | **ABSENT.** `grep -i ramanujan` finds only Ramanujan–Serre derivatives of modular forms and Chudnovsky–Ramanujan π formulas | **UNCOVERED** | — |
| **singular series / Hardy–Littlewood constants** | **ABSENT.** `grep -i 'singular series\|hardy.?littlewood'` returns nothing | **UNCOVERED** | — |
| additive-energy machinery (`ENERGY.md`, TTY `N*(σ,T)`) | **ABSENT** | **UNCOVERED** | — |

**Summary for this subject.** mathlib subsumes the entire *elementary*
arithmetic-function layer the analytic lane rests on, and none of the *analytic*
layer above it. The dividing line is exactly the explicit formula: everything
below it is a one-line import, everything above it does not exist in any
formalized library. That is a real finding and it is worth saying in one
sentence: **if the analytic lane is ever formalized, the first four sections
are free and the fifth is a research project.**

---

## 6. Category theory: initial algebras, final coalgebras, fibered categories, torsors

| our object | mathlib module + declaration | verdict | usable today? |
|---|---|---|---|
| "`FutureBehavior` is coalgebra for the Moore functor `F Z = O × Z^A`" (`notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md`) | `Mathlib/CategoryTheory/Endofunctor/Algebra.lean`: `Endofunctor.Algebra F`, **`Endofunctor.Coalgebra F`**, their categories, `Coalgebra.isoMk`, `forget`, `functorOfNatTrans`, `equivOfNatIso`, and **Lambek**: `Endofunctor.Algebra.Initial.str_isIso` / `Endofunctor.Coalgebra.Terminal.str_isIso` | **SUBSUMES** the abstract framing — mathlib has `Coalgebra` for a general endofunctor and Lambek's lemma in both directions | (a) |
| the *existence* of a final coalgebra for our Moore functor | `Mathlib/Data/PFunctor/Univariate/M.lean`: `PFunctor.M`, `M.corec`, `M.bisim`, `M.eq_of_bisim`, `M.IsBisimulation`; `Mathlib/Data/QPF/Univariate/Basic.lean`: `QPF.Cofix`, `Cofix.bisim`, `Cofix.bisim_rel`, `Cofix.bisim'`, `QPF.Fix` (initial algebra) | **SUBSUMES** — and note mathlib **does** have coinduction-by-bisimulation here, just not for `DFA` | (a) |
| — *warning* — | `Mathlib/RingTheory/Coalgebra/*` and `Mathlib/CategoryTheory/Monoidal/Comon_.lean` are **linear-algebraic coalgebras** (comultiplication on a module). They are not `F`-coalgebras and are not what our corpus means. Do not import them by name-match. | — | — |
| displayed / fibered categories (`Cubical.Displayed` unused per the cubical audit) | `Mathlib/CategoryTheory/FiberedCategory/{Fibered,Fiber,Cartesian,HasFibers,Grothendieck}.lean`; `Mathlib/CategoryTheory/Grothendieck.lean`; `Mathlib/CategoryTheory/Elements.lean`; `Mathlib/CategoryTheory/Bicategory/Grothendieck.lean` | **SUBSUMES** the general theory; our corpus has no fibered construction to compare against, so this is potential, not duplication | (a) |
| group objects / actions in a category | `Mathlib/CategoryTheory/Action/{Basic,Concrete,Limits,Monoidal}.lean`: `Action V G`, `ActionCategory`, `Action.ofMulAction` | **UNCOVERED-by-us** (we have no such construct) | (a) |
| torsors / principal homogeneous spaces | `Mathlib/Algebra/Torsor/Defs.lean`: `class Torsor G P` and `class AddTorsor G P` (free + transitive, with `/ₛ` and `-ᵥ`), `Group.instTorsor`, `sdiv_smul`, `smul_sdiv`, `smul_right_cancel`; `Mathlib/Algebra/Torsor/Basic.lean`; topological versions in `Mathlib/Topology/Algebra/Group/Torsor.lean` | **SUBSUMES** the definitional content of `StabilizerTorsor.agda`'s torsor clause — see §7 | (a) |
| a *categorical* torsor / principal bundle (torsor over a site, `BG`) | **ABSENT** at the level our `TwoSided` module would need | **UNCOVERED** | — |

---

## 7. Group actions, orbits, stabilizers, quotients

This is where the largest single duplication in the corpus lives.

**mathlib.** `Mathlib/GroupTheory/GroupAction/` — 30+ modules, plus
`Mathlib/Algebra/Group/Action/`:

- `MulAction`, `AddAction`, `SMul`; `MulAction.orbit G a`, `MulAction.stabilizer G a : Subgroup G`, `MulAction.fixedPoints`.
- **`MulAction.orbitRel : Setoid α`** (`GroupTheory/GroupAction/Defs.lean:282`), `orbitRel.Quotient G α`, `orbitRel.Quotient.orbit`, `orbitRel.Quotient.quotient_smul_eq`, `orbitRel_subgroup_le`.
- **`MulAction.orbitEquivQuotientStabilizer (b : X) : orbit G b ≃ G ⧸ stabilizer G b`** (`GroupAction/Quotient.lean:174`) — orbit–stabilizer.
- `MulAction.selfEquivSigmaOrbits`, `selfEquivSigmaOrbitsQuotientStabilizer` — the class formula.
- **`MulAction.stabilizerEquivStabilizer (hg : b = g • a) : stabilizer G a ≃* stabilizer G b`** (`GroupAction/Basic.lean:262`), with `stabilizerEquivStabilizer_apply`, `…_trans`, `…_symm`, `…_inv`, `…_one`, and `stabilizerEquivStabilizerOfOrbitRel`.
- `stabilizer_smul_eq_stabilizer_map_conj`, `IsCancelSMul.stabilizer_eq_bot`, `isCancelSMul_iff_stabilizer_eq_bot` (**free action ⟺ all stabilizers trivial**).
- `MulAction.IsPretransitive`, `orbit_eq_univ`, `pretransitive_iff_subsingleton_quotient`; `MulAction.Blocks`, `Primitive`, `MultipleTransitivity`, `Jordan`, `Iwasawa`, `ConjAct`, `FixingSubgroup`, `SubMulAction.OfStabilizer`.

| our object | mathlib | verdict | usable today? |
|---|---|---|---|
| `Pairfield.HolonomyDescent.orbitSetoid : Setoid X := ⟨fun x y => ∃ g : G, g • x = y, …⟩` (`HolonomyDescent.lean:14`) — hand-rolled, on top of an existing `[MulAction G X]` instance | **`MulAction.orbitRel`** — the same setoid, defined at `GroupTheory/GroupAction/Defs.lean:282`, in a file the lane already transitively imports via `Mathlib.Algebra.GroupWithZero.Action.Basic` | **SUBSUMES — verbatim.** This is the clearest single duplication found in this audit: a `Setoid` re-declared where mathlib's is already in scope, discarding `orbitRel.Quotient`, orbit–stabilizer, and the class formula that come attached to it. | (a) |
| `NaturalMachine/StabilizerTorsor.agda` `record Action` ("cubical v0.5 ships no `GroupAction`") | `MulAction` (Lean-side only; the cubical gap the comment reports is real, this row is about the mathematics not the substrate) | **SUBSUMES in Lean, not in Agda** | (b), the record itself is trivial to port; its *theory* is not |
| `Torsor.T x y = Σ[ g ∈ G ] (g ▸ x ≡ y)` — the transporter | mathlib has **no named transporter** (`grep -i transporter` ⇒ nothing). The set is `{g | g • x = y}`; mathlib works with it only through `orbitEquivQuotientStabilizer` and `stabilizerEquivStabilizer` | **UNCOVERED as a named object**; its two theorems are not | — |
| `isTorsorT` / `isTorsorTL` — the transporter is a `Stab x`- and `Stab y`-torsor; any two transporters differ by a unique stabilizer element | `MulAction.stabilizerEquivStabilizer` (the induced iso of endpoint stabilizers) + `MulAction.orbitEquivQuotientStabilizer` (the transporter set is a coset of `stabilizer G x`) | **SUBSUMES in content** — freeness+transitivity of `Stab x` on `{g | g•x = y}` is precisely "cosets of a subgroup are a torsor for it", which is `Group.instTorsor` + `QuotientGroup` in mathlib | (a) |
| `invariantPoint→contrStab` (R0027 no-go: endpoint-invariant data ⇒ trivial stabilizer) and `uniqueCertificate→contrStab` / `contrStab→uniqueCertificate` | closest is `isCancelSMul_iff_stabilizer_eq_bot`; the equivalence "unique transporter ⟺ trivial stabilizer" as such is **not** a named mathlib lemma | **UNCOVERED as stated** (though it is one line from `orbitEquivQuotientStabilizer` and `Subgroup.card_eq_one`) | — |
| `TwoSided` — two commuting one-sided actions `(L, R)` on a matrix set, certificates as transporters to a normal form `D` | mathlib has commuting actions (`SMulCommClass`) and `Matrix` `GL` actions (`Mathlib/LinearAlgebra/Matrix/Action.lean`), but not this packaging | **UNCOVERED as packaged**; each ingredient exists | (a) for the ingredients |
| `Gamma0Freeness.agda`, `Gamma0Transitivity.agda`, `Gamma0Partner.agda`, `Gamma0Converse.agda`, `M2Unimodular.agda` (adjugate identities, Binet at n=2, ε²=1 ⇒ ε≠0) | `Mathlib/LinearAlgebra/Matrix/Adjugate.lean` (`Matrix.adjugate`, `mul_adjugate : A * adjugate A = A.det • 1`), `Matrix.det_mul` (Binet, all n), `Matrix.SpecialLinearGroup`, `SL(2,ℤ)`, and `Mathlib/NumberTheory/ModularForms/CongruenceSubgroups.lean` (`Gamma`, **`Gamma0`**, `Gamma1`, `Gamma0_mem`, `IsCongruenceSubgroup`, `instFiniteIndexGamma0`) | **SUBSUMES** all five modules' matrix toolkit, and mathlib's `Gamma0` is the same group | (a) |
| `SymmetryCardinality.agda` (\|Aut(Fin n)\| = n!) | `Mathlib/Data/Finite/Perm.lean`: `Nat.card_perm : Nat.card (Equiv.Perm α) = (Nat.card α)!` (and `Fintype.card_perms_of_finset` in `Mathlib/Data/Fintype/Perm.lean`) | **SUBSUMES** | (a) |
| `InvariantCorrectiveClosure.lean` (least `a`-invariant submodule containing `U`) | already imports `Mathlib/Algebra/Module/Submodule/Invariant.lean` — `Module.End.invtSubmodule` is a `Sublattice (Submodule R M)`, so the least invariant submodule containing `U` is `sInf` in that lattice | **PARTIALLY SUBSUMES** — the lattice structure is imported but the `sInf` characterisation is re-derived. mathlib has no Krylov-subspace theory (`grep -i krylov` ⇒ nothing) | (a) |

---

## 8. p-adics, ℤ_p, profinite completion, inverse limits

| our object | mathlib module + declaration | verdict | usable today? |
|---|---|---|---|
| `DigitTowerLimit.InvLim X step = Σ[ x ∈ ∀ n, X n ] (∀ n, step n (x (suc n)) ≡ x n)` | mathlib expresses inverse limits as `CategoryTheory.limit` of a functor from `ℕᵒᵖ`, or concretely as `PadicInt.lift`. The coherent-sequence form appears as e.g. `Mathlib/CategoryTheory/CofilteredSystem.lean` and `Mathlib/Topology/Category/TopCat/Limits/Konig.lean` | **SUBSUMES in content**, different presentation | (c) — mathlib's is categorical/topological |
| the base-`b` odometer / digit tower with carries (`Digits.agda`, `Endian.agda`, `CountedDigits.agda`, `DIGIT_CRYSTAL.md`, `ADELIC*.md`) | `Mathlib/NumberTheory/Padics/PadicIntegers.lean` (`ℤ_[p]`), `…/RingHoms.lean`: **`PadicInt.toZModPow (n) : ℤ_[p] →+* ZMod (p^n)`**, `ker_toZModPow`, `zmod_cast_comp_toZModPow`, `PadicInt.lift` (universal property = ℤ_p *is* the inverse limit of `ZMod (p^n)`), `nthHom`, `limNthHom`, `denseRange_natCast`, `PadicInt.zmodRepr` (the digit!), `Mathlib/NumberTheory/Padics/MahlerBasis.lean` | **SUBSUMES** — `zmodRepr` is exactly the leading digit and `toZModPow` exactly the truncation-to-`n`-digits map, with the tower coherence proved | (a) for prime base; mathlib has no general-base odometer |
| `DigitTowerFinLimit`: `MSDLimit A ≃ (ℕ → A)` | the same statement for `ℤ_[p]` is `PadicInt.lift`/`limNthHom`; for a general profinite set it is `Profinite.asLimit` | **SUBSUMES in content** | (c) |
| adic ladder / completion generally | `Mathlib/RingTheory/AdicCompletion/{Basic,Algebra,Completeness,Functoriality,Topology,Noetherian}.lean`: `AdicCompletion I M`, `IsAdicComplete`, `IsHausdorff`, `IsPrecomplete`, `IsAdicComplete.lift`, `of_bijective_iff` | **SUBSUMES**, far beyond | (c) |
| profinite structure / finite quotients | `Mathlib/Topology/Category/Profinite/`: `Profinite`, **`Profinite.asLimit`** (every profinite set is the limit of its finite discrete quotients), `Profinite.CofilteredLimit`, `LightProfinite`, `Profinite.Nobeling`; `Mathlib/Topology/Algebra/Category/ProfiniteGrp/{Basic,Limits,Completion}.lean` | **SUBSUMES**, far beyond | (c) |
| general-base (non-prime, mixed-radix) odometer as a dynamical system | `grep -i odometer` over mathlib ⇒ **nothing**. `Mathlib/Dynamics/` has `SymbolicDynamics`, `Minimal`, `TopologicalEntropy`, `PeriodicPts`, but no odometer | **UNCOVERED** | — |

---

## 9. Tally, and the things genuinely absent

**Per-subject verdict** (a subject counts as SUBSUMED when mathlib covers the
mathematical content of the majority of our objects in it):

| subject | verdict | note |
|---|---|---|
| Myhill–Nerode / automata | **SUBSUMED** for `O = Bool`; **UNCOVERED** for general observation `O`, for minimality, and for the BFS | mixed, leaning subsumed |
| Smith / PID modules | **SUBSUMED** (existence, structure, index) | the executable/certificate layer is ours |
| Number theory, elementary layer | **SUBSUMED** | |
| Number theory, analytic layer | **UNCOVERED** | explicit formula and everything above it |
| Category theory (initial algebra / final coalgebra / fibered) | **SUBSUMED** | we had almost nothing here to duplicate |
| Group actions / orbits / stabilizers / torsors | **SUBSUMED** | |
| p-adics / inverse limits / profinite | **SUBSUMED** | general-base odometer excepted |

**4 subjects SUBSUMED outright, 1 UNCOVERED outright, 2 mixed.**

**Genuinely absent from mathlib** — brief, because absence is information, not a
programme:

1. Matrix-form Smith normal form (`∃ U V unimodular, U A V = diag d`) at any size.
2. Any computable/executable normal-form producer in linear algebra.
3. Uniqueness of invariant factors.
4. Hermite normal form; content (gcd of entries) of an integer matrix.
5. Kleene's theorem (regex ↔ regular language).
6. DFA minimality; automaton bisimulation; any minimization algorithm.
7. Moore machines / automata with non-Boolean output.
8. Mertens' theorems and the Mertens function; the Prime Number Theorem; the explicit formula; Perron's formula; Riemann–von Mangoldt `N(T)`; Ramanujan sums `c_q(n)`; singular series.
9. Odometers as such (general base).

**The single largest duplication found.** `Pairfield.HolonomyDescent.orbitSetoid`
is `MulAction.orbitRel`, re-declared in a file whose imports already put
`MulAction.orbitRel` in scope — and by re-declaring it the module forfeits
`orbitRel.Quotient`, `orbitEquivQuotientStabilizer`, and
`selfEquivSigmaOrbitsQuotientStabilizer`. Runner-up, and larger in line count
though not in avoidability: the ~1 400 Lean lines of the 2×2 Smith thread whose
*existence* content is `Submodule.smithNormalForm` specialised to `Fin 2`
(the producer and certificate are not, and should not be deleted).

---

## 10. Top ten for the Lean lane this week, ranked

Ranked by expected value. Each is marked **[easy]** (a single `import` plus
under ~20 lines) or **[hard]** (a real bridging effort), and every module was
verified present at the pinned `v4.33.0`.

1. **[easy] `Mathlib.GroupTheory.GroupAction.Basic` + `…GroupAction.Quotient` into `HolonomyDescent.lean`.** Delete `orbitSetoid`; use `MulAction.orbitRel`. Immediately inherits `orbitRel.Quotient`, `orbitEquivQuotientStabilizer`, `stabilizerEquivStabilizer`, `selfEquivSigmaOrbitsQuotientStabilizer`. Highest ratio of gain to effort in the whole list.

2. **[landed twice 2026-08-14] `Mathlib.Computability.MyhillNerode` into the native reachable chart.** `MyhillNerodeAdapter` first proved regularity iff finiteness of *reachable* behavioral meanings; `NerodeChartAdapter` now packages Mathlib's `Language.toDFA` as the canonical `FiniteBehavioralPresentation`, with representative-language preservation, reachable/reduced proofs, and recognized-language equality. `ResidualBFS` decides equality from a supplied finite chart. Exact residual: the canonical construction from regularity uses classical choice and is noncomputable, so it does not replace explicit chart data.

3. **[easy] `Mathlib.LinearAlgebra.FreeModule.Int` + `Mathlib.LinearAlgebra.FreeModule.Finite.CardQuotient` into the Smith thread.** `AddSubgroup.index_eq_natAbs_det` and `Basis.SmithNormalForm.toAddSubgroup_index_eq_pow_mul_prod` give the cokernel order of `A : IntMat2` for free, which several Smith notes compute by hand.

4. **[easy] `Mathlib.Algebra.Torsor.Defs` as the target of a `StabilizerTorsor` Lean shadow.** `Torsor G P` / `AddTorsor G P` is the definition R0027 hand-rolls in Agda. A 30-line Lean module instantiating `Torsor (stabilizer G x) {g | g • x = y}` would make the torsor claim a mathlib instance rather than a bespoke record.

5. **[easy] `Mathlib.LinearAlgebra.Matrix.Adjugate` + `Mathlib.LinearAlgebra.Matrix.NonsingularInverse` into `SmithContent.lean` / `CertificateSource.lean`.** `IntMat2.inv`, `inv_mul`, `mul_inv`, `det_mul`, `unimodular_mul` are `Matrix.adjugate`, `Matrix.mul_adjugate`, `Matrix.det_mul`, `Matrix.isUnit_iff_isUnit_det` at `n = 2`. Keep `IntMat2` for `#eval`; derive the algebra.

6. **[easy] `Mathlib.NumberTheory.ModularForms.CongruenceSubgroups` as the Lean home for the Γ₀ thread.** `Gamma0 N : Subgroup SL(2,ℤ)` with `Gamma0_mem`, `Gamma1_in_Gamma0`, `instFiniteIndexGamma0`. The Agda `Gamma0*` modules are re-proving the group; the Lean lane can adopt it.

7. **[hard] `Mathlib.LinearAlgebra.FreeModule.PID` — bridge `Pairfield.smith` to `Submodule.smithNormalForm`.** State and prove that our executable producer's output realizes a `Module.Basis.SmithNormalForm` for the submodule spanned by `A`'s columns. This converts our lane from "a 2×2 story" into "a computable witness for a mathlib existence theorem", which is the only framing under which the 565-line producer is not duplicated work. This is the single most valuable hard item.

8. **[hard] `Mathlib.CategoryTheory.Endofunctor.Algebra` — a Lean statement that `DFA α σ` is a `Coalgebra` of `F Z = Prop × (α → Z)`, with `Language.toDFA` terminal in the relevant subcategory.** `notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md` establishes the mathematics; nothing in either lane states it formally. mathlib supplies `Coalgebra`, `Terminal.str_isIso` (Lambek), and `PFunctor.M.bisim` to do it with.

9. **[hard] `Mathlib.Algebra.Module.PID` / `Mathlib.GroupTheory.FiniteAbelian.Basic` — classify the cokernels the Smith thread produces.** `AddCommGroup.equiv_directSum_zmod_of_finite'` turns every `ℤ²/AZ²` in the corpus into an explicit `⨁ ZMod (n i)`. Hard only because it requires deciding which corpus statements are about the cokernel and which about the presentation.

10. **[hard] `Mathlib.NumberTheory.ArithmeticFunction.{Defs,Moebius,VonMangoldt}` + `Mathlib.Data.Nat.Totient` + `Mathlib.NumberTheory.AbelSummation` — open a Lean file for the elementary half of `MERTENS_FLOOR.md`.** The identity `Λ♯_Q(n) = ∑_{d∣n, d≤Q} A_d` and `φ = μ * Id` are pure `ArithmeticFunction` algebra and are formalizable today. The `M(Q)` and `c₀ = −(log 2π + ¼)` parts are not — mathlib has no Mertens function. Hard because it means deciding where the formalizable/unformalizable line falls, which is itself the useful output.

**Not recommended.** Do not bump the pin to reach HEAD: everything above is at
`v4.33.0`. Do not import `Mathlib` wholesale in new files (`Lorentz`,
`SumRigidity`, `ReversalRigidity`, `CapabilityGraph` already do, and
`ArbitrarySmithClosure.lean`'s header records that this is why
`CapabilityGraph` is kept out of the default build target).
