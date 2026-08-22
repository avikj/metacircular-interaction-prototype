# Lean → Cubical port map

Inventory of the Lean corpus (`formal/pairfield/`, the only `*.lean` in the
repository) against the Cubical substrate (`formal/cubical/NaturalMachine/`),
with a ranked queue of what deserves porting.  Binding context: the
collaboration has settled that the machine/substrate lives in Cubical Agda
(univalence native, `--safe`, pinned toolchain per `formal/cubical/BUILD.md`:
Agda 2.6.3 + cubical **v0.5**).  The Lean development predates that decision.

**Totals: 18 Lean files, 1862 lines.  Split: 7 × (a) already present /
subsumed, 3 × (b) portable with profit, 8 × (c) no port value (scaffolding or
content whose home stays Lean).**

The top-ranked (b) item has been ported: `formal/cubical/NaturalMachine/PortQueue.agda`
**typechecks green** under the pinned toolchain (`--safe`, no holes, no
postulates; every statement proved).

---

## 1. File-by-file inventory

### (a) Already present in `formal/cubical/NaturalMachine` — 7 files

All seven are the 2×2 integer Smith pipeline.  The Cubical side does not
contain a line-by-line translation; it contains something strictly stronger:
`Cubical.Algebra.IntegerMatrix.Smith` (in cubical v0.5) provides `smith : (M :
Mat m n) → Smith M` — a **total, proof-carrying producer for arbitrary m×n
integer matrices**, whose output bundles the normal matrix, both invertible
transformations, the replay path, and Smith normality.
`NaturalMachine/SmithCapability.agda` exposes exactly this
(`normalizeSmith`, `replaySmith`, `leftTransform-invertible`,
`normalMatrix-isSmith`, `withSmith`).

| Lean file | Main content | Cubical counterpart |
|---|---|---|
| `SmithCertificate.lean` | `IntMat2`, `SmithCertificate2.Valid`, decidable checker `check` with `check_sound`/`check_complete`; forged-certificate controls | The checker architecture (untrusted producer + trusted Boolean gate) is mooted: the Cubical producer *returns the proofs* (`Smith M` record).  Gate = `withSmith` in `SmithCapability.agda`. |
| `SmithPresentation.lean` | Compositional presentation arrows `SmithPresentation A B`, `comp` (replay + unimodularity compose), `toCertificate` | Subsumed: partial-reducer composition existed to assemble a total producer stratum by stratum; Cubical has the total producer natively.  (Composition itself is transitivity of the `Sim` relation in the library's Smith development.) |
| `ComputableSmith2x2.lean` | `reduceDiagonal`: closed-form join `diag(gp,gq) → diag(g,gpq)` from a Bézout witness; `fromNatGcdOne` | Special case of `smith`.  |
| `ComputableSmith2x2Adapter.lean` | Field-for-field translation of the above into the checker surface | Adapter layer with no Cubical analogue needed (producer/consumer joint is `withSmith`). |
| `DirectSmith2x2.lean` | `compileUnitDet`/`compileNegUnitDet` (det ±1 ⇒ Smith = I via adjugate), certified linear solver `solve`/`solve_spec`/`solve_unique` | Unimodular stratum of `smith`.  The adjugate solver is Lean-side convenience, not structure. |
| `RankOneSmith2x2.lean` | Outer-product witness `A = (g,k)ᵀ(p,q)`, two Bézout equations ⇒ `SmithPresentation A diag(h,0)`; signed control | Rank-one stratum of `smith`. |
| `CapabilityGraph.lean` | Typed edge index; **open edge** `ArbitrarySmithPresentation : (A : IntMat2) → Σ d₁ d₂, SmithPresentation A (diag d₁ d₂) × …` | `NaturalMachine/CapabilityGraph.agda`.  Notably: the Lean file's deliberately *uninhabited* open joint **is inhabited on the Cubical side** — `smith` closes the arbitrary-input edge that the whole Lean 2×2 stratification was working toward.  (Its DFA edges fall under (c), see `MyhillNerodeAdapter.lean`.) |

Conclusion for (a): nothing to port; the Lean Smith corpus is a partial,
2×2-stratified reconstruction of a theorem the Cubical library already holds
in full generality.  Retire it or keep it as historical Lean-side record.

### (b) Portable with profit — 3 files (ranked in §2)

| Lean file | Main content | Why the Cubical port is *shorter* |
|---|---|---|
| `FutureBehavior.lean` (167 ln) | `run`, `behavior`, `FutureEq` (equality under all finite experiments), equivalence + congruence (`futureEq_step`), `futureSetoid`, `Quotient` machinery: `quotientStep/Observe/Run/Lift/Behavior`, `_mk` computation lemmas, `quotientBehavior_injective`, `futureEq_of_finer`, `futureEq_pair_iff` | Native set quotients eat the entire `Setoid`+`Quotient.lift` layer: `X / FutureEq` takes the raw relation, `SQ.rec` *is* the lift API, every `_mk` lemma becomes `refl`, `futureEq_iff_behavior_eq` becomes the definitional `funExt`/`funExt⁻` round trip, and effectivity upgrades from `Quotient.exact` to an `Iso ([x] ≡ [y]) (FutureEq x y)` usable for transport.  **Ported: `PortQueue.agda`, checked.** |
| `HolonomyDescent.lean` (129 ln) | Orbit quotients: `orbitSetoid`, `factors_through_orbit_iff`, `orbit_factor_unique`; coinvariants: `differenceSubgroup := closure {g•x − x}`, `A ⧸ differenceSubgroup`, `addHom_factors_through_coinvariants_iff`, `coinvariant_factor_unique` | The HIT quotient `A / R` **generates the closure for free**: Lean's `AddSubgroup.closure` + `closure_le` + `ker` + `QuotientAddGroup.lift/ext` machinery (the entire second half of the file) is replaced by quotienting by the *raw, non-equivalence* relation `a ~ b ↔ Σ g x, a ≡ b + (g•x − x)`; translation-invariance of that relation makes `+` descend by `SQ.rec2` directly.  Precedent in-library: `Cubical.Algebra.Group.Abelianization` is exactly this pattern. |
| `FiniteInformation.lean` (130 ln) | `FactorsThrough q t` (via `Set.range` + `Classical.choose`), `factorsThrough_iff_fiberConstant`, `Completes`, `completes_iff_separatesFibers`, `targetFiber_injects_side` (zero-error side-information lower bound), `factorsThrough_postprocess`, `completes_mono` | The Lean file invokes `Classical.choice` three times.  In Cubical the image is `Cubical.Functions.Image` (`Image f = Σ y ∥ fiber f y ∥₁`) and the descent direction is `rec→Set` (weakly-constant elimination out of `∥_∥₁`, `Cubical.HITs.PropositionalTruncation`): the theorem becomes **constructive**, choice-free, and shorter.  One lemma (`targetFiber_injects_side`) is irreducibly choice-shaped as stated and must be re-formulated (surjection out of `C` instead of injection into `C`, see §3.3). |

### (c) No port value — 8 files

Two sub-buckets; the distinction matters for honesty.

**(c1) Pure scaffolding (2):**

| Lean file | Content |
|---|---|
| `Pairfield.lean` | Import root (13 ln). |
| `Automata.lean` | Import root (3 ln). |

**(c2) Real content whose home stays Lean (6).**  These are genuine theorems,
but they use zero quotients/equivalences — porting them would fight the
substrate (cubical v0.5 has no `Polynomial` divisibility/irreducibility
theory, no UFD, no `omega`/`linarith`, no `NoZeroDivisors` class) and gain no
univalent content.  They stay as machine-checked Lean results, cited from
notes as such.

| Lean file | Main theorem | Why not port |
|---|---|---|
| `SumRigidity.lean` | Theorem A(i): `convSq_inj_nat` (a·a = b·b ⟹ a = b in `Polynomial ℕ`), `sumMarginal_inj` (Goldbach sum-marginal determines the sequence), `convSq_inj_nonneg` | Needs `ℤ[X]` integral-domain embedding + `mul_self_eq_mul_self_iff`; cubical v0.5 polynomial algebra has nothing comparable.  Port ≫ original. |
| `ReversalRigidity.lean` | Theorem A′ core: irreducible monic `F` with `F(0)=1` is homometrically rigid (`G·rev G = F·rev F ⟹ G = F ∨ G = rev F`) **— hypotheses on `G` omitted here; see correction below** | UFD/primality of `ℤ[X]`, `natDegree` calculus — absent from cubical v0.5. |
| `Lorentz.lean` | Lemma 1.3: `SO(1,1)(ℤ) = {±I}` (`so11_int_eq_pm_one`) | Pell-factorization + `omega`; pure integer matrix arithmetic, no structural content for the machine. |
| `CharacterAnchor.lean` | `characterAnchor_factorization`: same sum & product in a domain ⟹ pairs agree up to exchange | One `ring`+`NoZeroDivisors` step; no domain theory in cubical v0.5. |
| `MyhillNerodeAdapter.lean` | `FutureEq ↔ residual-language equality` for Mathlib `DFA`; `leftQuotient` squares; `BehavioralState`, `selectNext` | Its entire value is the bridge **to Mathlib's** `DFA`/`Language.leftQuotient`; cubical has no automata/language library to bridge to.  The library-free core (behavioral quotient + lift) is precisely what `PortQueue.agda` now holds. |
| `BehavioralBFS.lean` | Kernel-checked BFS for shortest distinguishing word: `wordsOfLength`, `shortestDistinguishingUpTo` + `_sound`/`_none_iff`/`_minimal`, executable witness | Decidability-driven executable search; no quotient content.  Cubical v0.5 `Data.List` lacks the `find?` lemma layer, so the port is strictly longer for zero structural gain.  Its spec vocabulary (bounded `FutureEq`) is expressible against `PortQueue.FutureEq` if ever needed. |

> **Correction by addition, 2026-08-15 (claude, Hoare lineage;
> `notes/LEAN_STATEMENT_AUDIT.md`).** The `ReversalRigidity.lean` row above
> states the implication with hypotheses only on `F`. The checked term carries
> three more, all on `G`, and they are load-bearing:
>
> ```lean
> theorem reversal_rigidity (F G : ℤ[X]) (hFirr : Irreducible F)
>     (hFm : F.Monic) (hGm : G.Monic) (hG0 : G.coeff 0 = 1)
>     (hdeg : G.natDegree = F.natDegree)
>     (h : G * G.reverse = F * F.reverse) : G = F ∨ G = F.reverse
> ```
>
> Drop `hGm` and `G = -F` is a counterexample (`rev(-F) = -rev F`, so
> `G·rev G = F·rev F`, yet `G ∉ {F, rev F}`). `hG0`/`hdeg` are what a
> translated 0-1 set supplies; `notes/LEAN_STATUS.md`'s faithfulness note
> already records this correctly, so this row was the outlier, not the term.
> A porter reading only this row would port a false statement.

---

## 2. Ranking of the (b) items — (content value) / (port effort)

1. **`FutureBehavior.lean`** — value: the semantic core of the observed-action
   program (it is the theorem justifying the behavioral quotient computed by
   `machinery/natural_crystal.py`, and both `MyhillNerodeAdapter` and
   `BehavioralBFS` lean on it); effort: **low** — every proof is one
   combinator.  Ratio: highest.  **Done: `PortQueue.agda` (§4).**
2. **`HolonomyDescent.lean`** — value: high (the descent/path-erasure law used
   by the holonomy notes; the coinvariants half is the additive template for
   charge/audit arguments, cf. `ProjectionChargeAudit.agda`'s obstruction
   idiom); effort: medium (must define the G-action structure locally — v0.5
   has no group-action module — and build `+` on the quotient via `SQ.rec2`).
3. **`FiniteInformation.lean`** — value: medium (distribution-free
   observer/side-information kernel; used by prose, not by other formal
   files); effort: low-to-medium (three lemmas are one-liners; the image
   factorization needs `rec→Set` plumbing; one lemma needs honest
   restatement).  The *profit* is qualitative — the port deletes
   `Classical.choice` — but the content is consumed less often than 1 and 2.

---

## 3. Concrete Cubical statements-to-prove (cubical v0.5 vocabulary)

### 3.1 `FutureBehavior` — DONE, see `formal/cubical/NaturalMachine/PortQueue.agda`

Full signature list in §4.

### 3.2 `HolonomyDescent` → `NaturalMachine/OrbitDescent.agda` (proposed)

Imports: `Cubical.HITs.SetQuotients as SQ`, `Cubical.Algebra.Group.Base`,
`Cubical.Algebra.AbGroup.Base`, `Cubical.Relation.Binary.Base`,
`Cubical.HITs.PropositionalTruncation`.

```agda
module OrbitDescent {ℓg ℓx} (G : Group ℓg) {X : Type ℓx}
  (_·_   : ⟨ G ⟩ → X → X)
  (·-1g  : (x : X) → (GroupStr.1g (snd G)) · x ≡ x)
  (·-∙   : (g h : ⟨ G ⟩) (x : X) → (GroupStr._·_ (snd G) g h) · x ≡ g · (h · x))
  where

  OrbitRel : X → X → Type (ℓ-max ℓg ℓx)
  OrbitRel x y = Σ[ g ∈ ⟨ G ⟩ ] (g · x ≡ y)

  OrbitSet : Type (ℓ-max ℓg ℓx)
  OrbitSet = X / OrbitRel                    -- raw relation: no setoid proof needed

  orbitMk : X → OrbitSet
  orbitMk-· : (g : ⟨ G ⟩) (x : X) → orbitMk (g · x) ≡ orbitMk x

  -- Lean: factors_through_orbit_iff (both directions) + orbit_factor_unique,
  -- fused: descent data is an equivalence of types, uniqueness included.
  descend : {Y : Type ℓy} (isSetY : isSet Y) (task : X → Y)
          → ((g : ⟨ G ⟩) (x : X) → task (g · x) ≡ task x)
          → OrbitSet → Y                      -- SQ.rec; β-rule is refl
  descend-unique : … → isContr (Σ[ d ∈ (OrbitSet → Y) ] ((x : X) → d (orbitMk x) ≡ task x))

  -- effectivity (needs the equivalence-relation proof, mere-witness form):
  orbitPath≃∥Rel∥ : (x y : X) → Iso (orbitMk x ≡ orbitMk y) ∥ OrbitRel x y ∥₁
    -- SQ.isEquivRel→TruncIso; the group laws enter only here
```

Coinvariants half, for `A : AbGroup ℓa` with action by additive maps
(`·-hom : (g : ⟨G⟩)(x y : ⟨A⟩) → g ·A (x + y) ≡ (g ·A x) + (g ·A y)`):

```agda
  DiffRel : ⟨ A ⟩ → ⟨ A ⟩ → Type _
  DiffRel a b = Σ[ g ∈ ⟨ G ⟩ ] Σ[ x ∈ ⟨ A ⟩ ] (a ≡ b + ((g ·A x) - x))

  Coinv : Type _
  Coinv = ⟨ A ⟩ / DiffRel                    -- HIT generates the subgroup closure

  _+Q_ : Coinv → Coinv → Coinv               -- SQ.rec2; DiffRel is translation-
                                             -- invariant, so no closure lemma
  -Q_  : Coinv → Coinv
  coinvAbGroup : AbGroup _                   -- laws by SQ.elimProp2/3 from A's laws

  coinvMk-· : (g : ⟨ G ⟩) (x : ⟨ A ⟩) → coinvMk (g ·A x) ≡ coinvMk x

  -- Lean: addHom_factors_through_coinvariants_iff + coinvariant_factor_unique
  descendHom : (task : AbGroupHom A B)
             → ((g : ⟨ G ⟩) (x : ⟨ A ⟩) → task .fst (g ·A x) ≡ task .fst x)
             → AbGroupHom coinvAbGroup B
  descendHom-unique : …                      -- SQ.elimProp
```

Port-shorter argument, explicitly: the Lean file spends its entire
`Coinvariants` section (≈60 lines) constructing `differenceSubgroup` as an
`AddSubgroup.closure`, proving `closure_le` into `task.ker`, and invoking
`QuotientAddGroup.lift`/`addMonoidHom_ext`.  In Cubical none of that
apparatus exists or is needed: `eq/` on the raw generator relation *is* the
closure, and the two universal-property proofs are `SQ.rec`/`SQ.elimProp`
applications.

### 3.3 `FiniteInformation` → `NaturalMachine/ObserverDescent.agda` (proposed)

Imports: `Cubical.Functions.Image`, `Cubical.HITs.PropositionalTruncation as PT`
(`rec→Set`, `2-Constant`), `Cubical.Functions.Embedding`, `Cubical.Functions.Surjection`.

```agda
module ObserverDescent {ℓx ℓy ℓt} {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt} where

  -- Lean's FactorsThrough, with Set.range replaced by the univalent Image
  FactorsThrough : (q : X → Y) (t : X → T) → Type _
  FactorsThrough q t = Σ[ decode ∈ (Image q → T) ]
                         ((x : X) → decode (restrictToImage q x) ≡ t x)

  FiberConstant : (q : X → Y) (t : X → T) → Type _
  FiberConstant q t = (x x' : X) → q x ≡ q x' → t x ≡ t x'

  -- Lean: factorsThrough_iff_fiberConstant.  Choice-free: the ← direction
  -- eliminates ∥ fiber q y ∥₁ by PT.rec→Set with the 2-Constant witness
  -- extracted from fiber-constancy.  Needs isSet T; Lean needed Classical.choice.
  factorsThrough≃fiberConstant :
    (isSetT : isSet T) (q : X → Y) (t : X → T)
    → … -- Iso (FactorsThrough q t) (FiberConstant q t), or the two maps
        -- factorsThrough→fiberConstant / fiberConstant→factorsThrough

  -- Lean: Completes, completes_iff_separatesFibers, completes_of_injective,
  -- completes_mono — verbatim one-liners:
  Completes : (q : X → Y) (c : X → C) → Type _
  Completes q c = (x x' : X) → q x ≡ q x' → c x ≡ c x' → x ≡ x'
  completes-of-inj  : ((x x' : X) → q x ≡ q x' → x ≡ x') → Completes q c
  completes-mono    : Completes q c → Completes q (λ x → c x , d x)

  -- Lean: factorsThrough_postprocess (deterministic data processing):
  factorsThrough-postprocess :
    (q : X → Y) (r : Y → Z) (t : X → T)
    → FiberConstant (r ∘ q) t → FiberConstant q t

  -- Lean: targetFiber_injects_side.  The Lean statement builds an injection
  -- TargetFiber → C by choosing witnesses (Classical.choose); constructively
  -- restate as a surjection OUT of C, which carries the same cardinality
  -- content (|C| ≥ |t(q⁻¹ y)|) without choice:
  decode-covers-fiber :
    (q : X → Y) (t : X → T) (c : X → C)
    (decode : Y → C → T)
    (replay : (x : X) → decode (q x) (c x) ≡ t x)
    (y : Y) (v : T) → ∥ Σ[ x ∈ X ] (q x ≡ y) × (t x ≡ v) ∥₁
    → ∥ Σ[ k ∈ C ] decode y k ≡ v ∥₁       -- PT.map, two lines
```

(For finite `X`,`C` the cardinality inequality then comes from
`Cubical.Data.FinSet.Cardinality` applied to the surjection, if it is ever
needed quantitatively.)

---

## 4. The landed port: `NaturalMachine/PortQueue.agda`

**Concurrency note (2026-08-13):** while this map was being written, a sibling
session independently landed the same rank-1 port as
`NaturalMachine/FutureBehavior.agda` (commit `37e79e8`; adds a
greatest-congruence theorem) and aggregated it into the root.  Independent
convergence on the same top pick is evidence for the ranking; the two modules
overlap and should be merged in a dedup pass (`PortQueue.agda` additionally
carries the effectivity `Iso` and the `runQ`/`liftQ` ledger below).

Checked green: `agda NaturalMachine/PortQueue.agda` exits 0 under the pinned
toolchain (Agda 2.6.3, cubical v0.5), flags
`--cubical --guardedness --safe --no-import-sorts`, **no holes, no
postulates, every statement proved** — several by `refl` that in Lean were
named lemmas, which is the point.

Signature ledger (Lean name → Cubical name):

| Lean (`FutureBehavior.lean`) | `PortQueue.agda` | Note |
|---|---|---|
| `run` | `ObservedAction.run` | identical recursion |
| `behavior` | `Observe.behavior` | |
| `FutureEq` | `Observe.FutureEq` | |
| `futureEq_refl/symm/trans` + `futureSetoid` | `futureEq-refl/sym/trans`, `futureEqIsEquivRel : isEquivRel FutureEq` | no `Setoid` wrapper; record used only for effectivity |
| `futureEq_step` | `futureEq-step` | |
| `futureEq_iff_behavior_eq` | `futureEq→behaviorPath = funExt`, `behaviorPath→futureEq = funExt⁻` | definitional round trip; zero-proof |
| `futureEq_of_finer` | `futureEq-of-finer` | |
| `futureEq_pair_iff` | `futureEq-pair-split` / `futureEq-pair-join` | |
| `Quotient (futureSetoid …)` | `BehavioralQuotient.Meaning = X / FutureEq` | needs `isSet O`; `isPropFutureEq` recorded |
| `quotientLift` (+ `_mk`) | `liftQ = SQ.rec` | β-rule definitional |
| `quotientStep` (+ `_mk`) | `stepQ` (+ `stepQ-⟦⟧ = refl`) | |
| `quotientObserve` (+ `_mk`) | `observeQ` (+ `observeQ-⟦⟧ = refl`) | |
| `quotientRun`, `quotientRun_mk` | `runQ`, `runQ-⟦⟧` | |
| `quotientBehavior` | `behaviorQ` (+ `behaviorQ-⟦⟧ = refl`) | |
| `quotientBehavior_injective` | `behaviorQ-inj` | `SQ.elimProp2` + `eq/` |
| — (Lean: `Quotient.exact`, unstated) | `meaningPath→futureEq`, `meaningPathIsoFutureEq : Iso (⟦x⟧ ≡ ⟦y⟧) (FutureEq x y)` | strict gain: effectivity as an `Iso`, transportable |

Line count: Lean 167 → Agda ≈120 net of the (larger) comment header, with
five formerly-named lemmas now `refl` and the effectivity iso added.  The
port is shorter *and* stronger, which is the (b) criterion.

## 5. Standing queue entries

- `PROVE` (port rank 2): `OrbitDescent.agda` per §3.2 — orbit descent +
  coinvariants on raw HIT quotients; success test: no closure lemma anywhere
  in the file.
- `PROVE` (port rank 3): `ObserverDescent.agda` per §3.3 — choice-free
  factorization through `Image`; success test: no `∥∥`-escape other than
  `rec→Set`.
- `SEARCH` (before either): check whether cubical ≥ v0.5 gained a group-action
  or coinvariants module (v0.5 has `Group.Abelianization` as the nearest
  precedent) so the port lands on library vocabulary.
- No `DEMONSTRATE` items: nothing here needs a numerical run; every claim in
  this note is a typechecking outcome or a line count.

---

## Scope, added 2026-08-20 by claude (Nālandā fleet) — correction by addition

The header's **"Totals: 18 Lean files, 1862 lines"** was true when written and
is now the note's coverage, not the lane's size. Measured today by running it:
`formal/pairfield/Pairfield/` holds **133 modules, 23548 lines**;
`Pairfield.lean`, listed above as "Import root (13 ln)", is 165.

All 18 modules named here still exist, so nothing in the inventory below is
falsified. What is wrong is only that a map covering **18 of 133 — 13.5% of the
lane** — reads as complete. That is the shape `AHIMSA_SUTRA_VISTARA.md` §2 names:
not a false claim, a partial one presented without its partiality, which offers
nothing to contradict.

This note remains the real seam between the Lean and Cubical lanes, and the
argument for that — as against wiring a Lean kernel into the running machine —
is §4 of
`notes/NAYABHEDE_SANKSEPO_NA_VIDYATE_TheLeanLaneClosureAuditAndTheRefusalToWireIt.md`.
What is wanted next is coverage that is **computed rather than remembered**, on
the model of `scripts/check-lean-root-closure.sh`. Deliberately not written
here: which of the other 115 modules belong in the queue is a judgement about
mathematics, and a blocking guard on a judgement call is an outage wearing
enforcement's name.
