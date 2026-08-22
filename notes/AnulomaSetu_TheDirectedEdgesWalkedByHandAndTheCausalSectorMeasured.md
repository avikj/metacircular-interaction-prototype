# अनुलोमसेतु — the directed edges, walked by hand, and the causal sector measured

**What this is.** The OPEN (`DEMONSTRATE`) item of
`notes/Yogyanupalabdhi_TheCausalOrderIsVacuousTheChargeIsInTheLoopsAndTheNetCannotBeConnected.md`
§५.१, discharged by hand-reading rather than by a second extractor. That
note's sizing line said 15 files under `formal/cubical/` mention `Retract`
or `isSurjection` and called the lane "small enough to walk by hand"; the
same grep today matches **31** files (the corpus grew), which is still
walkable, and it was walked. Every edge below was verified by reading the
actual type signature in the file, and the signature is quoted. No
extractor was written; no file was modified; nothing was committed.

**Anuloma** — "with the grain", the natural direction of a thing. These are
the edges that have one.

---

## ० · The three questions of §५.१, answered first

- **(i) Is reachability antisymmetric — are there directed cycles?**
  There are **five directed cycles, all of length 1** (self-loops at the
  closed-form grain), and **every one of them is a lossless map wearing a
  lossy-form signature** — the exact mis-classification the question
  predicted. §३ exhibits them. There is **no cycle of length ≥ 2**: no two
  distinct closed types reach each other. So reachability restricted to
  distinct nodes is antisymmetric, and the five loops are not
  counterexamples to losslessness — they are invertible maps (four
  identities and one involution) that the `isEmbedding`-form conclusion is
  simply too weak to distinguish from proper embeddings.
- **(ii) Sources and sinks.** Sources: `Bool ⊎ Unit`, `Fin 3 ⊎ Unit`,
  `Fin 6 × Fin 10`. Sinks: `Unit`, `Unit × Bool`, `Bool × Fin 3`,
  `(Bool × Bool) × Unit`, `Unit × (Fin 3 ⊎ Unit)`,
  `Unit × (Fin 6 × Fin 10)`; and two loop-only nodes. §४.
- **(iii) Gluing defects.** **Not computed, and not computable from this
  walk.** §५.१ already says it: (iii) needs the maps, not the signatures.
  Signatures cannot give `dim(im B ∩ ker A)`. Stated again in §६ so nobody
  reads this note as having measured it.

**Headline measurement, which is MINE as an interpretation and FACT as a
count:** of the **17** directed-form edges, only **5** have underlying maps
that are genuinely non-invertible (2 surjections onto `Unit`, 1 set-quotient,
2 proper embeddings). The other **12** are equivalences stated in a
directional form. The directed sector exists, it is small, and most of it
is the transport sector in directional clothing. The longest genuinely
lossy chain has length 2 (`State →[quotient] Bool →[surjection] Unit`),
sitting inside a directed chain of length 3 from `Bool ⊎ Unit`.

---

## १ · Orientation convention, stated once

Every edge points in the direction of the map whose signature is quoted.

- `isSurjection f` with `f : A → B`, and a quotient conclusion
  `(A / R) ≃ B`: the edge is **A → B**, the lossy direction (for the
  quotient, the composite of `[_] : A → A / R` with the equivalence).
- `isEmbedding f` with `f : A → B`, and `A ↪ B`: the edge is **A → B**,
  the direction of `f` (A is preserved; the loss, when any, is that B is
  not recovered — no retraction is asserted).
- A refused retraction/surjection is a **non-edge** and is listed
  separately (§५); it is not oriented into the graph.

Node identity (MINE, following Setubandha's convention of resolving names
to type expressions): nodes are the **closed normal forms** of the named
types, with the definitional unfolding read from the file and quoted
(e.g. `Old = Bool`, `New = Fin 3 ⊎ Unit`, `SolvedState = Output ×
SmithKernel = Bool × (Bool × Bool)`). Where a file gives two names to one
closed type (`State`, `Kernel`, `Source` are all `Bool × Bool`), they are
one node; every such identification below is by a definition read in the
file, not by the tool's guess.

---

## २ · The directed edge list: 17 edges, 13 nodes

### २.१ Genuinely lossy (underlying map not invertible) — 5 edges

**D1 · quotient · `State (= Bool × Bool)` → `Bool`**
`formal/cubical/WallCertificate.agda:497`
```agda
quotient≃Bool : (State / _≈_) ≃ Bool
```
(`State = Bool × Bool` at :225–226; `x ≈ y = tot x ≡ tot y` at :233–234.
Four states, two classes: the quotient map `[_] : State → State / _≈_`
is 2-to-1. This edge's ≃ half is already in Setubandha's undirected graph;
the directed content is the quotient composite.)

**D2 · surjection · `RelativeFact base (= Bool)` → `Unit`**
`formal/cubical/NaturalMachine/RelationalProcessCore.agda:315`
```agda
  base-surjective : isSurjection forgetBaseFact
```
with `forgetBaseFact : RelativeFact base → Unit` at :295 and
`RelativeFact base = Bool` at :192. (A `where`-binding inside
`port-descent-criterion`; the module is top-level and unparametrized.)

**D3 · surjection · `Bool` → `Unit`**
`formal/cubical/NaturalMachine/EffectiveDescent.agda:422`
```agda
  surjToUnit : isSurjection toUnit
```
with `toUnit : Bool → Unit` at :419 (a `private` block; checked all the
same).

**D4 · embedding (proper, 4 into 6) · `New (= Fin 3 ⊎ Unit)` → `Bool × Fin 3`**
`formal/cubical/NaturalMachine/BatchDepthMemoryBoundary.agda:171–172`
```agda
new-environment-attains :
  isEmbedding (Cert.recorded newChart₁ newCertificate)
```
`Cert.recorded newChart₁ newCertificate : New → Bool × Three` (`recorded c
x = (f x , c x)`, CertificateFibration.agda:167–168; `New = Three ⊎ Unit`,
`Three = Fin 3` at :53–59 of the file).

**D5 · embedding (proper, 3 into 4) · `Physical (= Bool ⊎ Unit)` → `Bool × Bool`**
`formal/cubical/NaturalMachine/QuotientUnitSourceCutBoundary.agda:213–214`
```agda
physical-environment-attains :
  isEmbedding (Cert.recorded physicalObserved physicalCertificate)
```
`physicalObserved : Physical → Bool` at :162–163, `physicalCertificate :
Physical → Bool` at :192–194, `Physical = Bool ⊎ Unit` at :104–105.

### २.२ Directional signature, invertible underlying map — 12 edges

Each of these is a checked conclusion of the specified form; each
underlying map is an equivalence (verified by reading the definitions:
identity re-pairings, unit-paddings `x ↦ (tt , x)` / `x ↦ (x , tt)`,
chart-isos, and one involution). They are edges of the directed graph as
§५.१ defines it, and they are the mis-classification stock that (i) asked
about.

**D6 · embedding · `Old (= Bool)` → `Unit × Bool`**
`formal/cubical/NaturalMachine/BatchDepthMemoryBoundary.agda:131–132`
```agda
old-environment-attains :
  isEmbedding (Cert.recorded oldChart oldCertificate)
```
(map: `x ↦ (tt , x)`.)

**D7 · embedding · `New (= Fin 3 ⊎ Unit)` → `Unit × New`**
same file :206–207
```agda
coarse-environment-attains :
  isEmbedding (Cert.recorded newChart₀ coarseCertificate)
```
(map: `x ↦ (tt , x)`.)

**D8 · embedding · `Bool` → `Bool × Unit`**
`formal/cubical/NaturalMachine/QuotientUnitSourceCutBoundary.agda:152–153`
```agda
effective-unit-attains :
  isEmbedding (Cert.recorded (Iso.fun identityIso) unitCertificate)
```
(map: `b ↦ (b , tt)`.)

**D9–D11 · embedding ×3 · `Kernel (= Bool × Bool)` → `Kernel × Unit`**
`formal/cubical/NaturalMachine/GlobalSmithAtlasFlatness.agda:191–193, 197–199, 203–205`
```agda
identity-swap-unit-attains :
  isEmbedding
    (Cert.recorded (transition identityChart swapChart) unitCertificate)
```
and identically-shaped `swap-flip-unit-attains`,
`flip-identity-unit-attains` (`Kernel = Bool × Bool` at :130–131; each
`transition` is a composite of chart isos, so each map is an equivalence
onto `Kernel × Unit`). Three parallel edges.

**D12 · embedding · `Solutions (= Fin 6 × Fin 10)` → `ProjectedX × EliminatedKernel (= Fin 6 × Fin 10)` — SELF-LOOP**
`formal/cubical/NaturalMachine/AffineProjectionQuantumBoundary.agda:87–88`
```agda
projection-environment-attains :
  isEmbedding (Cert.recorded projectX kernelCoordinate)
```
(`projectX = fst`, `kernelCoordinate = snd` at :59–63; the map is
`(x , k) ↦ (x , k)` — the identity of `Fin 6 × Fin 10`.)

**D13 · embedding · `Solutions` → `Unit × Solutions`**
same file :127–128
```agda
summary-environment-attains :
  isEmbedding (Cert.recorded symbolicSummary summaryCertificate)
```
(map: `s ↦ (tt , s)`.)

**D14 · embedding · `SolvedState (= Bool × (Bool × Bool))` → `Output × SmithKernel (= Bool × (Bool × Bool))` — SELF-LOOP**
`formal/cubical/NaturalMachine/SmithKernelQuantumBoundary.agda:102–103`
```agda
xy-environment-attains :
  isEmbedding (Cert.recorded solvedOutput xyCoordinate)
```
(`solvedOutput = fst`, `xyCoordinate = snd`; the map is the identity.)

**D15 · embedding · `SolvedState` → `Output × SmithKernel` — SELF-LOOP, the non-trivial one**
same file :133–134
```agda
yx-environment-attains :
  isEmbedding (Cert.recorded solvedOutput yxCoordinate)
```
(`yxCoordinate state = swapKernel (xyCoordinate state)` at :119–120; the
map is `(o , (x , y)) ↦ (o , (y , x))` — an involution, hence an
equivalence, hence a lossless loop. This is Setubandha's charged-sector
automorphism `swapKernel` showing up in the directed extraction as a
cycle.)

**D16 · embedding · `UnitSolvedState (= Bool × Unit)` → `Output × Unit (= Bool × Unit)` — SELF-LOOP**
same file :188–189
```agda
unit-environment-attains :
  isEmbedding (Cert.recorded unitOutput unitCoordinate)
```
(identity map.)

**D17 · embedding · `Source (= Bool × Bool)` → `Bool × Bool` — SELF-LOOP**
`formal/cubical/NaturalMachine/BalanceWithoutTransitivity.agda:83–84`
```agda
environment-attains :
  isEmbedding (Cert.recorded quotient coordinate)
```
(`quotient = fst`, `coordinate = snd`, `Source = Bool × Bool` at :41–48;
identity re-pairing.)

---

## ३ · (i) Cycles: five, all length 1, all lossless

At the closed-form grain the self-loops are D12 (`Fin 6 × Fin 10`), D14 and
D15 (`Bool × (Bool × Bool)`), D16 (`Bool × Unit`), D17 (`Bool × Bool`).
Exhibit, per the brief's demand, the one that is not a bare identity:

> D15: `Cert.recorded solvedOutput yxCoordinate : SolvedState → Output ×
> SmithKernel` is `(o , (x , y)) ↦ (o , (y , x))` on `Bool × (Bool ×
> Bool)`, and `swapKernel-involutive`
> (`SmithKernelQuantumBoundary.agda:115–117`) makes it self-inverse. The
> edge is a directed cycle whose composite with itself is the identity — a
> **lossless loop carried by a lossy-form signature**, which is exactly
> what §५.१'s (i) said a directed cycle would have to be.

There is no directed cycle of length ≥ 2: the complete out-edge relation on
distinct closed types is
`Bool ⊎ Unit → Bool × Bool → {Bool, (Bool × Bool) × Unit}`,
`Bool → {Unit, Unit × Bool, Bool × Unit}`,
`Fin 3 ⊎ Unit → {Bool × Fin 3, Unit × (Fin 3 ⊎ Unit)}`,
`Fin 6 × Fin 10 → Unit × (Fin 6 × Fin 10)` — checked by inspection of the
17-row table; no target ever reaches back to a source. **Reachability
between distinct nodes is antisymmetric. FACT** (finite inspection of the
list above).

MINE: the correct reading is not "the causal order has five violations"
but "the `isEmbedding`-form is not a losslessness classifier". An
embedding that happens to be an equivalence satisfies the same signature
form as a proper one. The five loops are transport-sector edges that a
signature-level extractor — the very one §५.१ specified — cannot help but
misfile. The Yogyanupalabdhi note's warning that its 15-file grep was "a
count of text, not a count of edges" has a second half: the *form* match
is a count of shapes, not of losses.

## ४ · (ii) Sources and sinks

Ignoring the five self-loops:

- **Sources** (no in-edges): `Bool ⊎ Unit` (Physical), `Fin 3 ⊎ Unit`
  (New), `Fin 6 × Fin 10` (Solutions).
- **Sinks** (no out-edges): `Unit`, `Unit × Bool`, `Bool × Fin 3`,
  `(Bool × Bool) × Unit`, `Unit × (Fin 3 ⊎ Unit)`,
  `Unit × (Fin 6 × Fin 10)`. (`Bool × Unit` is a sink except for its
  identity loop D16; `Bool × (Bool × Bool)` carries only its two loops —
  it is source and sink at once, an isolated node with charge, in
  Yogyanupalabdhi §२'s sense.)
- **Interior** (both in and out): `Bool × Bool` and `Bool`.

The longest directed chain is length 3:
`Bool ⊎ Unit → Bool × Bool → Bool → Unit`
(D5 then D1 then D2/D3) — one proper embedding, then one genuine
2-to-1 quotient, then one genuine surjection. MINE: this chain is the
entire non-vacuous causal order of the corpus today. It is where
`CAUSAL_MEMORY_SPACETIME.md` §7's defect term could first be nonzero —
D1's quotient composed after D5's embedding is exactly the
`rank(AB) < rank(B)` shape — but see §६: asserting that it *is* nonzero
needs the maps in 7.1's linear form, which this walk does not supply.

## ५ · The refusals in this sector: directed non-edges, 5 + 1

Checked negatives whose *content* is directional (a retraction or
surjection that provably does not exist). They are the योग्य silences of
this sector and are not edges:

**R1** `formal/cubical/NaturalMachine/ReflectionAttachment.agda:78`
```agda
noBoundaryRetract : ¬ BoundaryRetract
```
with (:73–76) `BoundaryRetract = Σ[ retract ∈ (BoolAttachment → Bool) ]
((point : Bool) → retract (boundary point) ≡ point)` — no retraction of
the pushout `BoolAttachment` onto its boundary `Bool`.

**R2** `formal/cubical/SetTruncationDescentBoundary.agda:220`
```agda
noDescentS¹ : Retracts₀ S¹ → ⊥
```
with (:113–114) `Retracts₀ A = Σ[ f ∈ (∥ A ∥₂ → A) ] ((a : A) → f ∣ a ∣₂
≡ a)` — the set-truncation of `S¹` does not retract.

**R3** `formal/cubical/TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple.agda:259`
```agda
truncatedDefectIsNotWritable : ¬ Retraction (Defect f₀)
```
with (:239–240) `Retraction D = Σ[ r ∈ (∥ D ∥₁ → D) ] ((d : D) → r ∣ d ∣₁
≡ d)` and `f₀ : ⊥ → Bool` (:247) — `∥ Defect f₀ ∥₁` does not un-truncate.

**R4** `formal/cubical/NaturalMachine/EffectiveDescent.agda:399`
```agda
notSurjection-absurd : isSurjection emptyMap → ⊥
```
with `emptyMap : ⊥ → Bool` (:396–397).

**R5** `formal/cubical/Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence.agda:603–605`
```agda
प्रत्यानयनं-नास्ति-अत्र
  : ¬ (Σ[ ψ ∈ (L.सप्तभङ्गी → G.सप्तभङ्गी प्रश्नः) ]
         ((b : G.सप्तभङ्गी प्रश्नः) → ψ (अनर्पणम् b) ≡ b))
```
— the record lane at the concrete standpoint type `प्रश्नः` is not
recovered from its label lane.

**R6** (a refused *equivalence*, listed for completeness — it belongs to
Setubandha's REFUSED class, not to this graph)
`formal/cubical/ContractibleFiberSectionBoundary.agda:67–68`
```agda
insideSections≄descentS¹ :
  ¬ (InsideSections S¹ ≃ Descent.Retracts₀ S¹)
```

## ५.१ Matched the form, excluded as generic — the parametrized sector

§५.१ demands conclusions "between two *named* types". The following are
checked conclusions of the matched forms whose endpoints are
quantified-over (module parameters or implicit `{A : Type ℓ}`), i.e. the
directed analogue of Setubandha's GENERIC class. Listed so the exclusion
is auditable, with one representative signature each:

- `Arpitanarpita_….agda:310–313` — `अनर्पण-अर्पणम् : {S : Type ℓ} {P : S →
  Type ℓ'} (a : syādasti P) (n : syādnāsti P) (x : L.सप्तभङ्गी) → अनर्पणम्
  (अर्पणम् a n x) ≡ x` — the label lane is a retract of the record lane,
  generically in `(S, P)` given inhabitation `(a, n)`; and :322–323
  `अनर्पणम्-सर्वगम्` (split surjectivity of `अनर्पणम्`). MINE: at `प्रश्नः`
  (§१०'s `अ₁`, `न₁`) this instantiates to a concrete retraction edge
  `G.सप्तभङ्गी प्रश्नः → L.सप्तभङ्गी`, but the file states no such
  instantiated signature, so per the conclusions-only rule it is recorded
  here and not as edge D18.
- `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda:305–329`
  (`प्रत्यानयनम्-हि-hasRetract`, `स्तरः→प्रत्यानयनम्`, `प्रत्यानयनम्-सङ्कोचः`)
  and :278, :289 — retraction/truncation structure of `∥_∥ₕ`, generic in
  `A`.
- `SetTruncationDescentBoundary.agda:151` — `descentDatum≃isSet :
  {A : Type ℓ} → Retracts₀ A ≃ isSet A`.
- `Samkramana_….agda:304` — `नष्टिः≃निर्धर्मता : (isEquiv (∣_∣₁ {A = A}))
  ≃ (isProp A)` — generic in `A` (Yogyanupalabdhi §५.१ named this one;
  it is not between two named types and so yields no edge).
- `TritiyaMarga_….agda:242` — `noRetraction : {D : Type ℓ} (x y : D) →
  ¬ (x ≡ y) → ¬ Retraction D`.
- `NaturalMachine/EffectiveDescent.agda:275, 288` — `descentIso`,
  `descentEquiv : isSurjection q → (B → C) ≃ DescentData` (module-generic;
  `isSurjection` as hypothesis); :364, :380 likewise.
- `NaturalMachine/FiniteInformation.agda:385, 411` — `sideUsed↪C : (y : Y)
  → SideUsed y ↪ C`, `sideUsed↠targetFiber : (y : Y) → SideUsed y ↠
  TargetFiber q t y` — inside `module SideInformation` over `{X Y T C}`,
  `q t c decode replay`.
- `NaturalMachine/CertificateFibration.agda:188–206, 236–237, 254` and
  `SmithQuotientNoGo.no-finite-controller` :305–306 (`… → ℕ ↪ E`,
  conditional and generic in `E`).
- `NaturalMachine/QuotientUnitSourceCutBoundary.agda:68–73, 92–94,
  181–185`; `NaturalMachine/BatchDepthMemoryBoundary.agda:116, 150, 191`;
  `NaturalMachine/GlobalSmithAtlasFlatness.agda:72–78`;
  `NaturalMachine/ProgrammableActionFibers.agda:80–89, 91–98` — the
  `-lower` bounds, all conditional on an `isEmbedding` hypothesis and
  generic in `Environment` (and ProgrammableActionFibers is module-generic
  throughout).
- `NaturalMachine/WitnessNumberIsThePotential.agda:108, 117, 135`,
  `NaturalMachine/WitnessNumberIsInvariant.agda:144, 158` (`equiv→surj`),
  `NaturalMachine/LinearOrderFinite.agda:242`, `FinCardinality.agda:184`,
  `NaturalMachine/Descent.agda:51` — `isSurjection` as hypothesis or
  generic conclusion about an arbitrary `f`.
- `EGBPhiIdempotent.agda:66, 74–75` — `pathQuotEquiv : {X : Type ℓ} →
  isSet X → (X / _≡_) ≃ X`, `achromaticIdempotent : {A : Type ℓ} {R : A →
  A → Type ℓ'} → ((A / R) / _≡_) ≃ (A / R)` — quotient-form, generic.
- `NaturalMachine/Gamma0.agda:148–149` (`Γ₀-characterisation … ≃ ∥ Σ …
  ∥₁`, parametrized by `d P`; RHS not a named type),
  `NaturalMachine/Decategorification.agda:83` (`card≡MereEq`, generic over
  `FinSet`), `Ankapasa_….agda:125` (between path types, parametrized).
- `Swarm/S04ApohaFiniteCompletion.agda:69–71` — `horizonSepRetract`,
  module-parametrized in `(O, x, y)`.

## ५.२ NOT-CLASSIFIED

Signature forms met in the walk that I could not honestly place in any
class above, listed rather than guessed at:

- `NaturalMachine/SieveFiber.agda:551` — `hasSection : {n : ℕ} → n ∈
  domain → q (σ (q n)) ≡ q n`. A pointwise section identity of two
  concrete maps on `ℕ` restricted to a decidable domain — retraction-like
  in content, but not a `Retract A B` between two types, and I do not
  know a principled node pair to assign.
- `Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction.agda` — its
  "retraction" (`अपवादः`) is the *scholarly* act of retracting a claim, a
  record `{बलवत् : W → N ; खण्डनम् : ¬ W ; स्थितिः : N}`. A name collision
  with the topological notion; no graph content of the kind sought.
- `VivekaPramana_….agda:68` (`isSetविवेक = isSetRetract विवेक→ℕ³ ℕ³→विवेक
  (λ _ → refl)`) and `EGBDetConservation.agda:66` — concrete strict
  retractions (`विवेक ⊲ ℕ³`) that appear **inside proof terms** whose
  stated conclusions are `isSet _`. The conclusions-only rule excludes
  them; they are the clearest evidence that the corpus contains more
  directed structure in its proof terms than in its signatures.
- `AchromaticToy.agda:82–116` — `sec`/`ret` components of `Iso`
  constructions for equivalences already in Setubandha's undirected graph;
  not free-standing directed conclusions.

---

## ६ · Counts, and what was NOT done

**Text-count vs edge-count, kept apart as Yogyanupalabdhi demands:**

- Files matching the note's own sizing grep (`Retract|isSurjection`):
  **31** (the note said 15; the corpus has grown since; one of the 31 is
  `Everything.agda`, an import aggregator).
- Files matching any form token I swept (`isEmbedding` 11, `↪`/`↠`,
  `SetQuotient` 42, `∥` 39, `section` 144, quotient-`/`): overlapping
  sets; text counts only.
- **Directed edges (concrete, both endpoints named): 17** — 14
  embedding-form, 2 surjections, 1 quotient-≃. Of these, 5 genuinely
  lossy, 12 with invertible underlying maps, 5 of those self-loops.
- **Directed refusals: 5** (plus 1 refused equivalence).
- **Generic/parametrized form-matches excluded: 24 named declarations**
  across 20 files (§५.१ list).
- Nodes at the closed-form grain: **13**.

**(iii) was not attempted.** Computing a gluing defect `dim(im B ∩ ker A)`
in `CAUSAL_MEMORY_SPACETIME.md` 7.1's sense requires the linear-map
content of each edge, not its signature; a hand-walk of signatures has
exactly the same blindness here as the extractor would have had. The
D5∘D1-shaped composite of §४ is where a nonzero defect would first live,
and that is stated as a location, not as a measurement.

**Coverage boundary, exactly.** Greps ran over all of `formal/cubical/`
(893 `.agda` files). Files read in relevant part (signature plus enough
context to resolve every named type to its definition): WallCertificate,
RelationalProcessCore, EffectiveDescent, BatchDepthMemoryBoundary,
CertificateFibration, QuotientUnitSourceCutBoundary,
GlobalSmithAtlasFlatness, AffineProjectionQuantumBoundary,
SmithKernelQuantumBoundary, BalanceWithoutTransitivity,
ProgrammableActionFibers, FiniteInformation, ReflectionAttachment,
PolynomialAttachmentGrowth, SetTruncationDescentBoundary,
ContractibleFiberSectionBoundary, TritiyaMarga, Arpitanarpita,
Tantrayukti, Apratikaryatva, Samkramana (targeted), EGBPhiIdempotent,
FinCardinality (targeted), LinearOrderFinite (targeted),
WitnessNumberIsThePotential/Invariant (targeted), Descent (targeted),
Gamma0 (targeted), Decategorification (targeted), SieveFiber (targeted),
Swarm/S04, VivekaPramana (targeted), EGBDetConservation (targeted),
AchromaticToy (targeted), Vyatireka / Swarm/S06NoWrap / CarryClassNonzero
/ CarryObstruction / GroupCohomologyH2 / InflationVersusSubgroup /
Control/InflationFlattened (checked: their `↠` matches are all comments).
**Known blind spots:** (a) the English word "section" matches 144 files
and only conclusion-shaped occurrences (` : section `, `hasSection`,
`hasRetract`) were audited, not every comment-adjacent use; (b) a
conclusion of one of the five forms whose *tokens all* sit ≥ 2 lines away
from any of the swept tokens would be missed — the two-line window scan
below found nothing beyond the table, but a three-line split would evade
it; (c) `formal/pairfield/` (Lean) was out of scope by the item's own
wording ("over the same 893 files", i.e. `formal/cubical/`).

**Discipline notes.** No file was modified; nothing committed; no
extractor (Haskell or otherwise) written — per §५.१'s own sizing, the lane
was walked by hand. Interpretations are marked MINE; everything else is a
quoted signature or a finite count on the table above.

## ७ · Every number's command (PRASAVA)

All run 2026-08-22 from the repo root against the working tree.

- 31 files (the note's sizing grep, re-run):
  `grep -rl -E 'Retract|isSurjection' formal/cubical/ --include='*.agda' | wc -l`
- 11 files mention `isEmbedding`:
  `grep -rl 'isEmbedding' formal/cubical/ --include='*.agda' | wc -l`
- 42 / 39 / 144 files mention `SetQuotient` / `∥` / `section`:
  `for pat in 'isEmbedding' 'SetQuotient' '∥' 'retract' 'section' '_/_' 'isInjective' 'hasSection'; do echo "== $pat"; grep -rl -F "$pat" formal/cubical/ --include='*.agda' | wc -l; done`
- surjection conclusions walked from:
  `grep -rn 'isSurjection' formal/cubical/ --include='*.agda'`
- embedding conclusions walked from:
  `grep -rn 'isEmbedding' formal/cubical/ --include='*.agda'` and
  `grep -rn '↪' formal/cubical/ --include='*.agda' | grep ' : '` and
  `grep -rn '↠' formal/cubical/ --include='*.agda'`
- retract conclusions walked from:
  `grep -rn 'Retract' formal/cubical/ --include='*.agda'` and
  `grep -rn ' : section \|→ section \| : retract \|→ retract ' formal/cubical/ --include='*.agda'` and
  `grep -rn 'hasSection\|hasRetract' formal/cubical/ --include='*.agda'`
- quotient-≃ conclusions walked from:
  `grep -rn '≃' formal/cubical/ --include='*.agda' | grep -E 'SetQuotient|/ₛ| / '`
- truncation-≃ conclusions walked from:
  `grep -rn 'Trunc\|∥' formal/cubical/ --include='*.agda' | grep '≃'`
- split-signature check (found nothing new; WallCertificate:497 re-found):
  `find formal/cubical -name '*.agda' -exec awk 'prev ~ /≃/ && $0 ~ /∥|SetQuotient| \/ / && $0 !~ /^ *--/ && prev !~ /^ *--/ {print FILENAME": "FNR-1"-"FNR}; {prev=$0}' {} +`
  and the mirror-image window (`prev` holding the quotient/truncation
  token, current line holding `≃`).
- 17 edges, 5 lossy, 5 loops, 13 nodes, 5+1 refusals, 24 generic
  declarations: finite counts of the tables in §२, §५, §५.१ of this note,
  each row of which carries its own file:line.

---

*तत् सत्। The causal sector exists, is 17 edges over 13 nodes, is
antisymmetric off five invertible loops, and its only genuinely lossy
spine is `Bool ⊎ Unit → Bool × Bool → Bool → Unit`. The maps, not the
signatures, are what (iii) still owes.*
