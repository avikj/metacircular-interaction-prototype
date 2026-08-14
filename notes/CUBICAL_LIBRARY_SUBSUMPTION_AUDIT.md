# Cubical library subsumption audit: what we built that was already there

**Task:** a reading task, not a mathematics task. For each significant
construction hand-rolled in `formal/cubical/NaturalMachine/`, determine whether
cubical v0.5 (pinned, `~/agda-libs/cubical`, see `formal/cubical/BUILD.md`)
already contains it.

**Method.** Read `Cubical/Categories/**` (88 modules), `Cubical/Displayed/**`
(13), `Cubical/Structures/**` (25), `Cubical/Codata/**` (20),
`Cubical/Data/W/`, `Cubical/Induction/`, `Cubical/Relation/`,
`Cubical/Algebra/{Group,Matrix,IntegerMatrix,Monoid,Ring}/`, then compared
against the named modules. No code was written or changed. **No module was
rewritten in this task; the map is the deliverable.**

**The measurement that prompted it, re-verified here.** Our corpus opens 60
distinct `Cubical.*` modules out of 859 installed, distributed as:

| namespace | `open import` sites in our corpus |
|---|---|
| `Cubical.Data` | 257 |
| `Cubical.Foundations` | 133 |
| `Cubical.Algebra` | 46 |
| `Cubical.Relation` | 25 |
| `Cubical.HITs` | 13 |
| `Cubical.Tactics` | 11 |
| `Cubical.Functions` | 6 |
| **`Cubical.Categories`** | **0** (of 88 modules) |
| **`Cubical.Displayed`** | **0** (of 13) |
| **`Cubical.Structures`** | **0** (of 25) |
| **`Cubical.Codata`** | **0** (of 20) |
| **`Cubical.Induction`** | **0** |
| **`Cubical.Reflection`** | **0** |

---

## Headline

**10 SUBSUMED, 6 OVERLAPS, 4 GENUINELY OURS** across the twenty constructs
audited below. (Row #8 was downgraded from GENUINELY OURS to OVERLAPS mid-audit
when I found `Cubical.Codata.M`'s `unfold-η`; the correction is recorded in
place below rather than smoothed over.)

**The single most embarrassing duplication.** `PayloadMorphism.MinCarrier` and
its uniqueness theorem `min-unique` are, character for character, the library's
`Cubical.Data.Nat.Order.Recursive.Minimal.Least` and `Least-unique` — including
the proof, which in both places is a three-way trichotomy split with
`Empty.rec` in the `lt` and `gt` branches:

```agda
-- ours, PayloadMorphism.agda §B
MinCarrier r m = FactorsAt r m × ((m' : ℕ) → m' < m → ¬ FactorsAt r m')
min-unique r m m' (fm , nm) (fm' , nm') = decide (m ≟ m')
  where decide (lt p) = Empty.rec (nm' m p fm)
        decide (eq p) = p
        decide (gt p) = Empty.rec (nm m' p fm')

-- library, Cubical/Data/Nat/Order/Recursive.agda, module Minimal
Least P m = P m × (∀ n → n < m → ¬ P n)
Least-unique m n (Pm , ¬P<m) (Pn , ¬P<n) with m ≟ n
... | lt m<n = Empty.rec (¬P<n m m<n Pm)
... | eq m≡n = m≡n
... | gt n<m = Empty.rec (¬P<m n n<m Pn)
```

The module imports `Cubical.Data.Nat.Order` fifteen lines above the
duplication and never looked in the sibling `Order/Recursive`. The library also
ships `isPropLeast`, `isPropΣLeast`, `search` (decidable minimisation) and
`→Least`, none of which we have — so the duplication cost us the *stronger*
statements as well as the lines.

---

## The table

Verdicts: **SUBSUMED** = the library has it; our module should become a thin
instantiation. **OVERLAPS** = the library has a more general form; the column
says what ours adds, if anything. **GENUINELY OURS** = no library counterpart.

| # | Our construct | Verdict | Library module + construct | What our version adds |
|---|---|---|---|---|
| 1 | `PayloadMorphism.MinCarrier`, `min-unique` | **SUBSUMED** | `Cubical.Data.Nat.Order.Recursive` → `Minimal.Least`, `Least-unique` | Nothing. Library also has `isPropLeast`, `isPropΣLeast`, `search`, `→Least`. |
| 2 | `PayloadMorphism.MorphismClass` "as a category with structure" | **OVERLAPS** | `Cubical.Categories.Category.Base` → `Category`; `Constructions.Elements` → `∫ F`; `Constructions.Slice` → `SliceCat` | Nothing structural. `MorphismClass` has **no composition and no identity** — it is *less* structured than `Category`, not more. `Factors r c` is a fibre of `app`; that pattern is `∫ F`/`SliceCat`. Our extra content is the two laws (`app-null`, `rank0-trivial`), which are pointedness of `El`, not category structure. |
| 3 | `PayloadMorphism` §A: `sumℤ`, `sumℕ`, `dot`, `sumℤ-const0`, `sumℤ-dim0/1`, `sumℕ-mono`, `sum0→each0` | **SUBSUMED** | `Cubical.Algebra.Ring.BigOps` → `∑`, `∑Ext`, `∑0r`, `∑Split`, `∑Last`; `Cubical.Algebra.Monoid.BigOp` → `bigOp` over `FinVec`; `Cubical.Algebra.Matrix` → `FinMatrix`, `Mat`, `_⋆_` | Nothing. Both use `Cubical.Data.FinData.Fin`/`FinVec`, so the index conventions already agree. `dot` is a row of `_⋆_`. |
| 4 | `StabilizerTorsor.Action` (record: `_▸_`, `▸-1g`, `▸-·`) | **OVERLAPS** | `Cubical.Algebra.SymmetricGroup` → `Symmetric-Group X isSetX`; `Cubical.Algebra.Group.Morphisms` → `GroupHom`, `IsGroupHom` | Nothing. A set action **is** `GroupHom G (Symmetric-Group X isSetX)`. `IsGroupHom` has *one* field (`pres·`); `pres1` and `presinv` are derived in `Cubical.Algebra.Group.MorphismProperties`. Our record therefore carries one redundant law. The header's claim "cubical v0.5 has no group-action record" is **true and beside the point** — the library's encoding is a group hom into the symmetric group. |
| 5 | `StabilizerTorsor` transporter groupoid: `T x y`, `idT`, `_∙T_`, `invT`, `∙T-IdL/IdR/Assoc/InvL/InvR`, `transporterPath` | **SUBSUMED** | `Cubical.Categories.Constructions.Elements` → `∫ F`, whose homs are literally `Σ[ f ∈ C [ c , c' ] ] x' ≡ (F ⟪ f ⟫) x` | Only glue: the library has no delooping `BG : Group ℓ → Category _ _`, ~15 lines. Once it exists, `∫ (action functor)` supplies all five groupoid laws and `isSetHom`; `transporterPath` is already just `Σ≡Prop`. |
| 6 | `StabilizerTorsor.isTorsorT`, `isTorsorTL`, `invariantPoint→contrStab`, `uniqueCertificate→contrStab` | **GENUINELY OURS** | — (no `Torsor` module anywhere in v0.5; searched) | The freeness/transitivity packaging and the R0027 no-go. Real content, no counterpart. |
| 7 | `FutureBehavior` §5–§5d: quotient, descent, effectivity, universal property | **SUBSUMED** (already correctly library-backed) | `Cubical.HITs.SetQuotients` → `rec`, `elimProp`, `eq/`, `squash/`, `effective`, `isEquivRel→effectiveIso`; `Cubical.Relation.Binary.Base` → `isEquivRel`, `isPropValued` | Nothing to change. This module is the corpus's example of doing it right. |
| 8 | `FutureBehavior` §4/§5e: `isBehavioralCongruence`, `futureEq-isCongruence` (greatest congruence), `Terminal.mediate`/`mediate-unique` | **OVERLAPS** (downgraded — see correction below) | `Cubical.Codata.M` → `M`, `unfold`, `unfold-η` (the final-coalgebra universal property for indexed containers, `--safe --guardedness`); `Cubical.Categories.Limits.Terminal` → `isTerminal` | Our machine is an `O × (−)^A`-coalgebra and its future quotient is the minimal realization. `Cubical.Codata.M` **does** prove finality — I first claimed otherwise and was wrong (see the correction below). v0.5 still has **no coalgebra category** (`Instances.FunctorAlgebras` has no dual). What ours adds over `unfold`/`unfold-η`: nothing structural; see `notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md`. |
| 9 | `AtlasResiduals` §1: `Alg`, `AlgHom`, `isPropCommutes`, `idAlgHom`, `compAlgHom` | **SUBSUMED** | `Cubical.Categories.Instances.FunctorAlgebras` → `Algebra`, `AlgebraHom`, `RepAlgebraHom`, `AlgebraHom≡`, `idAlgebraHom`, `seqAlgebraHom`, `AlgebrasCategory`, `ForgetAlgebra` | Nothing. `compAlgHom` = `seqAlgebraHom`; `isPropCommutes` is the content of `AlgebraHom≡`; and the library gets the whole *category* (unit and associativity laws, `isSetHom`) plus the forgetful functor, which we do not have. |
| 10 | `AtlasResiduals` §3: `isInitial`, `ℕ-algebra-endo-is-id`, `initial→isEquiv`, `isContrAlgIso` | **SUBSUMED** | `Cubical.Categories.Limits.Initial` → `isInitial`, `initialArrow`, `initialArrowUnique`, `initialEndoIsId`, `initialToIso`, `isPropIsInitial`, `isPropInitial`; `Cubical.Categories.Category.Base` → `isPropIsIso` | Nothing. `isInitial` is definitionally ours (`∀ y → isContr (C [ x , y ])`); `ℕ-algebra-endo-is-id` is `initialEndoIsId`; `initial→isEquiv` is `initialToIso`; `isContrAlgIso` is `initialToIso` + `isPropIsIso` + contractibility of the hom. `isPropInitial` (uniqueness of the initial object in a *univalent* category) is strictly stronger than anything we proved. |
| 11 | `AtlasResiduals.ℕ-isInitial` (ℕ **is** the initial 1+X-algebra, universe-polymorphic target) | **GENUINELY OURS** | — | The library gives the *category* of F-algebras but exhibits **no initial algebra**. `Cubical.Data.W.Indexed` gives `IW` with `wExt`, `isoRepIW`, the full `IWPath` characterisation and `isOfHLevelSuc-IW` — the *type* and its path structure, never the recursor's uniqueness. So the existence half is ours; only the packaging (#9, #10) is duplicated. |
| 12 | `AtlasResiduals.BS n = Σ[ X ] ∥ X ≃ Fin n ∥₁` | **SUBSUMED** | `Cubical.Structures.TypeEqvTo` → `TypeEqvTo ℓ X = TypeWithStr ℓ (λ Y → ∥ Y ≃ X ∥₁)`; also `Cubical.Data.FinSet.Base` → `isFinSet A = Σ[ n ] ∥ A ≃ Fin n ∥₁`, `isPropIsFinSet` | Nothing. `BS n ≡ TypeEqvTo ℓ-zero (Fin n)` on the nose. `TypeEqvTo` additionally comes with the SIP (`PointedEqvToSIP`) via `Structures.Axioms`. |
| 13 | `AtlasResiduals` §4–§5: `forgetTrunc`, `basedPath≃`, `isContrOrdTotal`, `linOrd-torsor` | **SUBSUMED** (already correctly library-backed) | `Cubical.Foundations.Univalence` → `EquivContr : ∃![ T ] (T ≃ A)`, `univalence`; `Cubical.Foundations.Equiv` → `equivComp` | Nothing to change; already one library term. |
| 14 | `Obstruction.Tm` (`var`/`node`), `plug`, `Over`, `unfold`, `Over-mono`, `plug-Over` | **SUBSUMED** | `Cubical.Data.List` → `List`, `_++_`, `++-assoc`; `Cubical.Data.List.Dependent` → `ListP` | Nothing. `Tm ≅ List Shape` exactly (`var = []`, `node c t = c ∷ t`), `plug = _++_`, and `Over V` is `ListP (λ c → memb c V ≡ true)`. `plug-Over` is `ListP` append. We re-derived a list and its append lemmas under new names. |
| 15 | `Obstruction.memb`, `eqℕ`, `memb-here`, `memb-mono` | **OVERLAPS** | `Cubical.Relation.Nullary` → `Dec`, `Discrete`; `Cubical.Data.Nat.Properties` → `discreteℕ`; `Cubical.Data.Nat.Order.Recursive` → `_≤?_` | Nothing beyond a `Dec → Bool` wrapper. v0.5 genuinely has **no list membership** (`Cubical/Data/List/` is Base, Properties, FinData, Dependent), so `memb` itself is a legitimate ~4-line hand-roll; only `eqℕ` is redundant. |
| 16 | `Obstruction`/`GenerativeLoop`: `Obstruction`, `propose`, `plateau`, `anti-plateau`, `deficit`, `deficit-split`, `generative-step` | **GENUINELY OURS** | — | The obstruction-indexed proposer and its progress theory. `Cubical.Reflection` is only `Base`/`RecordEquiv`/`StrictEquiv` — nothing about term syntax or structural induction over a user datatype. No counterpart. |
| 17 | `GenerativeLoop.loop`, `generative-loop` (fuelled iteration) | **OVERLAPS** | `Cubical.Induction.WellFounded` → `Acc`, `WellFounded`, `WFI.induction`, `isPropAcc`; `Cubical.Data.Nat.Order.Recursive` → `WellFounded.wf-<`, `wf-elim`, `wf-rec` | Only the fuel parameter. `deficit` strictly decreases, so `wf-elim` on `<` gives unconditional termination without threading fuel; ours reaches the same theorem by a weaker route. |
| 18 | `HolonomyDescent.Orbit` (`_▸_` + laws as module parameters), `OrbitRel`, `orbitRelIsEquivRel` | **OVERLAPS** | Same as #4 (`Symmetric-Group` + `GroupHom`); quotient half already uses `SetQuotients` and `isEquivRel→TruncIso` correctly | Nothing new. This is the **second** independent hand-rolled group action in the corpus (the third if `Coinvariants`' `_▸_` is counted). Three encodings of one concept, none of them the library's. |
| 19 | `HolonomyDescent.Coinvariants` (`DiffRel` raw-generator HIT quotient, `descendHom-contr`, `CoinvAbGroup`) | **GENUINELY OURS** | `Cubical.Algebra.Group.QuotientGroup` quotients by a *normal subgroup*; `Cubical.Algebra.Group.Subgroup` has no closure-of-a-generating-set | The insight that the HIT quotient by the raw generator relation generates the subgroup closure for free. Genuinely shorter than the library route, and the library has no direct counterpart. |
| 20 | `Transport`/`TransportInstance` SIP and structure transport | **SUBSUMED** (already correctly library-backed) | `Cubical.Algebra.Monoid.Base` → `MonoidPath = ∫ 𝒮ᴰ-Monoid .UARel.ua` | Nothing to change, **and the audit question is answered NO**: `Cubical.Structures.*` is *not* the better home. `MonoidPath` is already built on `Cubical.Displayed` (`UARel`/`DUARel`/`∫`), so the corpus already consumes `Cubical.Displayed` transitively. `Cubical.Structures.*` is the older `StrEquiv`/`UnivalentStr` layer that `Cubical.Displayed` supersedes for record-shaped structures. |

---

## Corrections to the premises of the task

Two framings in the task are wrong, and the map is worse if they stand.

**`Cubical.Displayed.*` is not displayed categories.** It is `UARel`/`DUARel` —
univalent and displayed-univalent *reflexive-graph relations*, the automation
layer under the SIP (`Displayed/Auto.agda`, `Displayed/Record.agda` generate
these by reflection). There are **no displayed categories in v0.5 at all**:
`Cubical/Categories/` has no `Displayed` subdirectory. So the answer to "does
`Cubical.Displayed` give the structure-over-a-base pattern `PayloadMorphism` is
groping toward" is **no** — that pattern would be `Elements`/`Slice`/
`FullSubcategory`. `Cubical.Displayed` *is* the right home for the
`HolonomyDescent`/`TransportInstance` SIP work, and we are already using it
transitively.

**`Cubical.Codata` *does* give final coalgebras — I got this wrong on the first
pass and am correcting it in place rather than quietly.** My first search covered
`Codata/M/AsLimit/**` only: there, `Coalg/Base` defines `Coalg₀` and cones and
`M/*` builds the M-type as a limit, and finality is indeed absent. But
`Cubical/Codata/M.agda` itself — `{-# OPTIONS --safe --guardedness #-}` — defines
indexed containers `IxCont` and the coinductive `M`, and proves the universal
property outright:

```agda
unfold   : ∀ {A} (α : ∀ x → A x → F A x) → ∀ x → A x → M C x
unfold-η : ∀ {A} (α) (h) → (h a coalgebra morphism) → ∀ x a → h x a ≡ unfold α x a
```

Existence and uniqueness of the anamorphism, i.e. finality. The Moore functor
`O × (−)^A` is expressible as an `IxCont` over `Unit*`. So row #8 is **OVERLAPS,
not GENUINELY OURS**, and the corpus's central construction has a standard
source. A concurrent note, `notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md` (in the tree
untracked as this was written, not authored by me), reaches the same conclusion
from the mathematics side and argues in its §4.1 that `Cubical.Codata.M`'s form
is nonetheless unusable for us in practice — I have not verified that half, and
it does not change the subsumption verdict, only the recommended remedy.

What survives: there is still **no `FunctorCoalgebras`** to dualise
`FunctorAlgebras`, so the *categorical* phrasing has no home. And our
`Terminal.mediate-unique` proves uniqueness of the mediating *function*, whereas
`Cubical.Categories.Limits.Terminal.isTerminal` is `∀ y → isContr (C [ y , x ])`
— uniqueness of the whole morphism including its commutation data. Ours is the
weaker statement, said longhand.

## Where we already did it right

Worth recording so the ranking below is not read as a blanket indictment.
`SmithCapability.agda` (64 lines) is a thin instantiation of
`Cubical.Algebra.IntegerMatrix.Smith` — it imports `smith` and re-exports the
normal form, transformations, replay path and normality proof under corpus
names, and proves nothing itself. That is exactly the shape the rewrites below
should produce. `FutureBehavior` §5 and `Transport` §8 are likewise correct
consumers of `SetQuotients` and `MonoidPath`.

---

## Ranked import plan

Two orderings of the same eight rewrites. **Easiest-first** ranks by risk;
**hardest-first** is its reverse. The column that decides priority is
*lines deleted per unit of risk*, and by that measure the order is
**R3, R1, R2, R4, R5, R6, R7, R8**.

### Easiest first (ascending risk)

| rank | rewrite | import | ~lines deleted | risk | note |
|---|---|---|---|---|---|
| R1 | `PayloadMorphism.MinCarrier`/`min-unique` → `Least`/`Least-unique` | `Cubical.Data.Nat.Order.Recursive` | 12 | **very low** | One real cost: `Order.Recursive._<_` is the recursive `≤`, not `Order._<_`'s Σ-form, and v0.5 ships **no** translation lemma between them (`Data/Fin/Base` imports it renamed and lives with both). Either switch §B's order or write a 6-line transfer. Net deletion is small; the value is the name and the free `isPropLeast`/`search`/`→Least`. |
| R2 | `PayloadMorphism` §A sums → `∑`/`bigOp`/`Mat` | `Cubical.Algebra.Ring.BigOps`, `Cubical.Algebra.Monoid.BigOp`, `Cubical.Algebra.Matrix` | ~60 | **low** | Index conventions already agree (both `Cubical.Data.FinData.FinVec`). `sumℤ` is `∑` over `ℤCommRing`; `sumℕ` is `bigOp` over the additive ℕ monoid; `dot` is a row of `Mat._⋆_`. |
| R3 | `AtlasResiduals` §1+§3 → F-algebra category | `Cubical.Categories.Instances.FunctorAlgebras`, `Cubical.Categories.Limits.Initial` | ~90 | **low** | **Best ratio in the corpus.** Mechanical re-instantiation. Needs one thing the library lacks: the `Maybe` endofunctor on `SET` (~10 lines: `F-ob`, `F-hom`, `F-id`, `F-seq`). One genuine loss to weigh: our `ℕ-isInitial` is universe-polymorphic in the target, and `isInitial` inside a single `Category ℓ ℓ'` is not — keep the polymorphic statement as a corollary. `isUnivalentSET` exists, so `isPropInitial` is reachable. |
| R4 | `StabilizerTorsor.Action` (and `HolonomyDescent`'s two copies) → group hom into the symmetric group | `Cubical.Algebra.SymmetricGroup`, `Cubical.Algebra.Group.Morphisms` | ~25 across three sites | **low-medium** | Deduplicates three encodings of one concept. `▸-1g` stops being a hypothesis (derived from `pres·`). Touches three modules, so coordinate. |
| R5 | `AtlasResiduals.BS` → `TypeEqvTo` | `Cubical.Structures.TypeEqvTo` | 3 | **low-medium** | Trivial deletion, but `BS` is referenced from `Decategorification`; check that module's `FinSet` story at the same time (`Cubical.Data.FinSet.Cardinality` is also 0-imported and looks relevant to `ℕ≃π₀FinSet`/`card≡MereEq` — **not audited here**). |
| R6 | `Obstruction.Tm` → `List Shape` | `Cubical.Data.List`, `Cubical.Data.List.Dependent` | ~40 | **medium** | Pervasive: `Tm` threads through `Obstruction` (586 lines) and `GenerativeLoop` (645). Every `plug` lemma becomes a `++` lemma. Do it only together with R7. |
| R7 | `GenerativeLoop` fuel → well-founded recursion on `deficit` | `Cubical.Induction.WellFounded`, `Cubical.Data.Nat.Order.Recursive` | ~30, and strengthens the theorem | **medium** | Rewrites the termination argument, not just its packaging. `generative-loop` stops needing a fuel bound. |
| R8 | `StabilizerTorsor` transporter groupoid → `∫ F` | `Cubical.Categories.Constructions.Elements` + a new `BG : Group ℓ → Category _ _` | ~70 | **medium-high** | Needs the delooping the library omits (~15 lines) and a universe negotiation: `∫` wants `F : Functor C (SET ℓS)` while our `Torsor` is polymorphic in two independent levels `ℓ ℓ'`. Highest deletion in the action lane, highest friction. |

*Not on the list, deliberately:* rewriting `FutureBehavior` over
`Cubical.Codata.M`. Finality is there (`unfold`, `unfold-η`), so the *content*
is subsumed — but the remedy is contested. `notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md`
argues that the M-type presentation is unusable for our Moore functor and
recommends ~25 lines naming the final coalgebra *inside our own module* instead.
That is a mathematics call, not a subsumption call, and it belongs to whoever
owns that note. Separately, building a `FunctorCoalgebras` category to phrase
terminality as `isTerminal` would **add** roughly 120 lines to delete about 25,
with no library dual to lean on; it buys the stronger `isContr` statement and a
citable name, and is worth doing only if the coalgebra category is wanted for
its own sake. Recorded here so nobody re-derives either conclusion.

### Hardest first (descending risk)

R8, R7, R6, R5, R4, R3, R2, R1 — and if the goal is to *stop the bleeding*
rather than to delete lines, invert again: R1 and R4 are the two that prevent
the same mistake recurring, because they attach library names (`Least`,
`Symmetric-Group`) to concepts the corpus keeps re-inventing under local names.

---

## Honesty ledger

- Verdicts are from reading source, not from typechecking. No rewrite was
  attempted, so every "~lines deleted" is an estimate from the current source,
  not a measured diff.
- Only the constructs named in the task were audited. The other ~35 modules in
  `formal/cubical/NaturalMachine/` were not. Three that visibly deserve the
  same treatment and did not get it: `Decategorification` vs
  `Cubical.Data.FinSet.Cardinality`; `PMTorus` (921 lines) vs
  `Cubical.HITs.Torus`/`Cubical.Homotopy.*`; `LinearOrderFinite` (299 lines,
  and the standing obligation `LinOrd′ X ≃ (X ≃ Fin n)` recorded in
  `AtlasResiduals`' header) vs `Cubical.Relation.Binary.Poset` and
  `Cubical.Data.Fin.LehmerCode`.
- "SUBSUMED" is a claim about mathematical content, not about compile-time.
  Importing `Cubical.Categories.*` pulls a large dependency cone into a corpus
  that currently checks against `Cubical.Data`/`Foundations` only; whoever
  lands R3 should report the change in `NaturalMachine.agda`'s check time.
- I made one outright factual error during this audit — claiming
  `Cubical.Codata` has no finality theorem, on the strength of a grep that
  covered `Codata/M/AsLimit/**` and not `Codata/M.agda`. It is corrected above
  and the tally was revised down. Treat the remaining "no library counterpart"
  verdicts with the corresponding discount: each is a claim that *I did not
  find one*, over 859 modules read at varying depth.
- Prior art beyond this library (nLab, the Agda standard library's
  `Relation.Binary`, `Data.Container` for coalgebras, agda-categories'
  `F-Coalgebra`, Rutten's universal coalgebra) was **not** searched here.
  `StabilizerTorsor`'s torsor theorem and `HolonomyDescent`'s coinvariants are
  GENUINELY OURS *relative to cubical v0.5*, which is a much weaker claim than
  novelty — and the FutureBehavior correction shows how weak. A `SEARCH` item,
  not a result. The protocol's "prior art gets searched **before** the
  experiment" applies to formalisation targets too.
