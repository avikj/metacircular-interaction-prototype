# Śeṣa adjudication — the flat interior, examined module by module

**śeṣa** — remainder; used here because the question is what remains of each
reading after the modules themselves are read. The term is descriptive; no
source is claimed to treat import graphs.

**Author:** research subagent for avik@getcrowdsurf.com, 2026-08-23, working
tree (not committed). **Adjudicates:** the open fork in
`notes/Setu_TheImportGraphIsAStarOnAFoundationTrioAndTheLongestChainIsTheTraditionsThread.md`
finding 1 and the request in
`collab/messages/0914-cf-sesa-the-corpus-proof-geometry-measured-and-the-import-edge-overstates-the-receipt.md`
("one concrete extractable lemma family, named, would decide a syāt").
**Method:** exact recomputation of the depth-0 set; deterministic 30-module
sample; exhaustive top-level-definition extraction over all 308 depth-0
files; definition-by-definition comparison by direct read. Shell/awk/grep
only; no Python; no floats.

**Avacchedaka (limitors), first.** (1) Definition extraction matches
top-level signatures at column 0; definitions inside `where`/`module` blocks
are missed, so every duplication count below is a **lower bound**. (2) The
duplicate families were found by *name* frequency and then verified by
reading; a family re-derived under names I did not guess is invisible, again
a lower bound. (3) The prose-citation scan counts backtick-quoted corpus
module names in comments only. (4) Line numbers are valid for the working
tree of 2026-08-23.

## The recomputation

A depth-0 module = a `.agda` file under `formal/cubical/` none of whose
`import` lines targets a module whose dotted name corresponds to a `.agda`
file in `formal/cubical/`. Recomputed independently of Setu's edge list:
**308 of 976** — exact agreement with Setu. The 308 depth-0 files total
**68,257 lines**. Top-level definitions extracted across all 308: **4,050**.

## The duplicated lemma families (the compression reading's witnesses)

These are verified by direct read, not by name matching alone. Verbatim
means the defining equations are identical up to variable names.

### Family A — Boolean equality on ℕ with soundness. **9 modules.**

`eqℕ : ℕ → ℕ → Bool` with the four clauses
`zero zero = true / zero (suc _) = false / (suc _) zero = false /
(suc m) (suc n) = eqℕ m n`, **verbatim**, in seven files, plus the same
function named `eqb` in two more:

| module | definition | companions re-proved locally |
|---|---|---|
| `NaturalMachine/Obstruction.agda` | :162 | `eqℕ-refl` :168, `eqℕ→≡` :172 |
| `CyclicAliasing.agda` | :153 | `eqℕ-refl` :159, `eqℕ-neq` :163 |
| `EGBResidueGlue.agda` | :90 | `eqℕ-refl` :96, `eqℕ-sound` :100 |
| `NaturalMachine/EndogenousHorizon.agda` | :78 | — |
| `NaturalMachine/Alopa_TheEngineNeverTouchesTheMeaning.agda` | :107 | `eqℕ-sound` :113 |
| `NaturalMachine/LineWorldTransport.agda` | :126 | — |
| `EGBFalsifierAsymmetry.agda` | :116 | — |
| `NaturalMachine/TransmissionRefutations.agda` (as `eqb`) | :98 | — |
| `HomometricPair.agda` (as `eqb`) | :107 | — |

The soundness lemma `eqℕ m n ≡ true → m ≡ n` is proved independently three
times under three names (`eqℕ→≡`, `eqℕ-sound` ×2); `eqℕ-refl` three times.
A shared module would export: `eqℕ`, `eqℕ-refl`, `eqℕ-sound`, `eqℕ-neq`
(soundness + completeness + reflexivity — no file currently has all four).
The external library's `discreteℕ` gives `Dec`, not `Bool`; the corpus's
engine-style modules demonstrably want the `Bool` form, nine times.

### Family B — Boolean equality on Bool. **10 modules.**

The same function under three names and three syntactic presentations
(4-clause table; `if x then y else not y`; `true c = c / false c = not c`):
`eqBool` at `NaturalMachine/Pratyahara.agda`:204,
`NaturalMachine/SieveFiber.agda`:248, `HeadDepthTwo.agda`:81,
`HeadDepthMerge.agda`:73; `eqb` at
`NaturalMachine/GterTwoCoordinate.agda`:190,
`NaturalMachine/MatchingPenniesSeparator.agda`:236; `eqB` at
`NaturalMachine/Anuvrtti.agda`:118,
`Krama_NoRecitationOrderSeatsTheCycleSoRepetitionLiftsAnObstructionAndNotACost.agda`:147,
`Dvihpatha_TheAntichainBoundIsAttainedOnlyIfASoundMayBeListedTwice.agda`:143,
`Swarm/S04Apoha.agda`:73.

### Family C — `All` / `Any` / `_∈_` over lists. **12 modules corpus-wide, 7 at depth 0.**

`All P [] = Unit; All P (x ∷ xs) = P x × All P xs` and
`x ∈ [] = ⊥; x ∈ (y ∷ ys) = (x ≡ y) ⊎ (x ∈ ys)`, re-derived at:
depth 0 — `NaturalMachine/RateOneIsExactlyTheUniversalClaim.agda`:61,
`NaturalMachine/TheSecondUpadhiConditionDoesAllTheWork.agda`:151,
`NaturalMachine/AscendingFirstIsTheWorstUnlessTheArchiveIsConstant.agda`:86
(with `Any` :90), `NaturalMachine/WalkCapacity.agda`:41 and :45,
`NaturalMachine/SieveFiber.agda`:212, `ElsewhereCondition.agda`:122
(level-polymorphic), `Swarm/S13OptionSpread.agda`:136; interior —
`NaturalMachine/KramaAstiNasti_AnEnumerableRemedySetKillsTheFourthCorner.agda`:114,
`NaturalMachine/TheParetoStratumIsDecidableAndTheFilterIsExact.agda`:131,
`NaturalMachine/ChargeIsStrictRefinement.agda`:191,
`NaturalMachine/SelfImprovement.agda`:112,
`NaturalMachine/ResidualPath.agda`:76.

The interior five matter for the adjudication: those modules **do** import
corpus siblings for their main content and *still* re-derive `All`/`_∈_`
locally. Helper-sharing was not avoided because importing was avoided; it
was never practiced at all, at any depth.

### Family D — counting a Boolean predicate over a list. **6 modules.**

`NaturalMachine/RateOneIsExactlyTheUniversalClaim.agda`:65 (`count`, with
`countIsAtMostLength` :74), `Window5Walsh.agda`:178 (`countB`),
`FactoryVICore.agda`:220 (`countSurv`), `HomometricPair.agda`:113
(occurrence count via its own `eqb`), `HeadDepthTwo.agda`:197 and
`HeadDepthMerge.agda`:190 (`countList`, verbatim identical pair).

### Family E — the HeadDepth modular-arithmetic toolkit. **11 names duplicated verbatim between 2 modules.**

`HeadDepthTwo.agda` (241 lines) and `HeadDepthMerge.agda` (226 lines) share
**eleven** top-level definitions: `_%%_`, `_//_`, `_≤?_`, `allList`,
`countList`, `eqBool`, `mrChain`, `powMod`, `power`, `range`, `vCap` — an
entire mod/div/boolean-order/power/valuation prelude, copied. The
duplication is self-describing: `HeadDepthMerge.agda`'s own header reads
*"THE MERGE THE CORPUS ASKED FOR THREE TIMES"* — a module whose stated
purpose is unification, and which shares its toolkit with its sibling by
re-typing it rather than by an import edge. (`Gamma0Index.agda`:53 defines
`_%_` and `_//_` a third time, independently.)

### Family F — componentwise (Pareto) order with transitivity. **3 modules.**

`_≼_ : List ℕ → List ℕ → Type` by `(x ≤ y) × (xs ≼ ys)` with `≼-trans`,
verbatim twice:
`NaturalMachine/AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision.agda`:90
(:100) and `Swarm/S13OptionSpread.agda`:78 (:97); the pair specialisation at
`NaturalMachine/ParetoCost.agda`:53.

### Family G — mod-2 double recursion ("parity"). **4 modules.**

The recursion `f zero = a; f (suc zero) = b; f (suc (suc n)) = f n` with
four codomains: `Bool` (`NaturalMachine/ChargeGrading.agda`:134), `ℤ` signs
(`NaturalMachine/TransmissionRefutations.agda`:176), `Syllable`
(`PingalaPrastara.agda`:259), and a proof-relevant sum
(`NaturalMachine/PiPartialOnEveryPrime.agda`:135). Same recursor,
re-instantiated; one polymorphic `parityRec : A → A → ℕ → A` with its
step lemmas would carry all four.

### Family H — the miniature rewrite engine (`Term`/`eval`/`Rule`). **~5 modules, structural not verbatim.**

A local expression datatype with evaluator and sound rewrite rules is built
from scratch in `NaturalMachine/Alopa_TheEngineNeverTouchesTheMeaning.agda`
(`Term` :80, `eval` :87, `Rule` :95, `step`/`normalize` and soundness
:142–184), `NaturalMachine/PolynomialRewrite.agda`,
`NaturalMachine/ConservativePrimitiveExtension.agda`,
`NaturalMachine/RewriteCertificate.agda`, `NaturalMachine/Laghava.agda`.
These are the largest per-instance duplications (50–150 lines each) but are
design-level repetitions, not copy-level: each varies the carrier.

### The middle layer that already exists and is imported by nothing

`MachineLibrary.agda` (306 lines, depth 0 itself) exports exactly the
engine-recursion arithmetic — `addZero`, `addSuc`, `+-assoc`, `zeroAdd`,
`sucAdd`, `addComm`, `mulZero`, `mulSuc`, `zeroMul`, `sucMul`, `mulComm`,
`L01`–`L17`. Its importers in the entire corpus: `Everything.agda` and the
`Samuccaya` aggregate root — i.e. **nobody**. Meanwhile `SeamClosed.agda`
(:59, :94) and `TraceCorpus.agda` (:15, :27, plus `addAssoc` :21–25)
re-prove `addZero`/`mulZero` from scratch, and neither file mentions
`MachineLibrary`. This is the decisive small witness: the shared module was
built, documented, aggregated — and never once used as a dependency.

## The counter-measurement (what bounds the compression reading)

Summing the verified families at their measured sizes: A ≈ 135 lines,
B ≈ 50, C ≈ 90, D ≈ 30, E ≈ 200, F ≈ 75, G ≈ 20, the `addZero` pair ≈ 40 —
**≈ 640 lines of verbatim-grade duplication**, plus ≈ 400 structurally
repeated lines in family H. Against 68,257 depth-0 lines that is
**≈ 1–1.5 % of the flat stratum** (a lower bound, per the limitors, but the
name-frequency table was scanned to the floor: no larger family is hiding
under a name that occurs ≥ 3 times).

And the sampled headers show why the bound is tight. Of the 30-module
deterministic sample, **11 of 30 define their own `data`/`record` carrier**
(`Krama…`, `Swarm/S02ModeAdjoint`, `ExclusionScope`, `Narayana`,
`Swarm/S05AsiddhaNewton`, `Swarm/S01PaniniAshby`,
`NaturalMachine/BGRadiusProjectionUnsafe`, `NaturalMachine/Laghava`,
`NaturalMachine/Alopa…`, `NaturalMachine/PrimePairDecompositionCurvature`,
`ThresholdGenerationN5Boundary`), and every one of the 30 has a bespoke main
theorem (the sextic eliminant spine, Nārāyaṇa's cow sequence, the N5
threshold boundary, the mode-adjoint classification, …). A sibling's
mid-level lemma is a lemma *about the sibling's local carrier*; it cannot be
imported without first sharing the carrier. The flatness is mostly the shape
of self-contained bespoke developments, not of hundreds of missed imports.

## The social reading's own positive witness

Across all 308 depth-0 modules: **82 cite a corpus sibling by name in their
comments while importing nothing from the corpus** (backtick-quoted module
names matched against the module list; lower bound; full listing preserved
in the scan, examples: `Vilopa_…` cites `DesaSanghata_…`;
`NaturalMachine/Alopa_…` cites `Calana_TheRunAndTheInvariantForAllN` and
then rebuilds `eqℕ` and a `Term` engine locally;
`NaturalMachine/MigrationNeedsALawAndTheLawIsNotFree.agda` cites
`ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem`;
`NaturalMachine/BezoutIsGCD.agda` cites `CoprimePowers`;
`ThresholdGenerationN5Boundary.agda` is a named companion to
`ThresholdGenerationDichotomy`). So the refined social finding is sharper
than "each carrier trusted only the foundations": **the carriers knew each
other's work — a quarter of the flat stratum cites it in prose — and
re-derived anyway.** Knowledge flowed through comments and notes; the import
edge was simply not the channel the collaboration used for it.

## Verdict, graded

- **syād asti (compression):** the reading is TRUE as stated — repeated
  lemma families exist, are nameable, and are named above: eight families,
  three of them with 9–12 independent re-derivations. A single shared
  prelude module (~300 lines: Families A–G plus re-exports into
  `MachineLibrary`) would delete ≈ 640–1,000 lines and convert ≈ 35–40
  modules from depth 0 to depth 1. The cf-sesa request — one concrete
  extractable family — is answered three times over.
- **syād asti (social):** the reading is TRUE and carries the larger share
  of the flatness. 82/308 prose-citations-without-import; a merge module
  that copies its sibling's eleven-definition toolkit instead of importing
  it; a purpose-built shared library with zero real importers; and interior
  modules that import siblings for content yet still re-derive `All` — the
  practice of helper-sharing was absent at every depth, independent of
  whether importing happened.
- **syād asti-nāsti (both, in succession):** the two readings partition the
  308 by volume: ≈ 1–1.5 % of the flat stratum's lines are unrealized
  compression (real, extractable, bounded); the remaining ≈ 98–99 % is
  bespoke self-contained work whose flatness no shared middle layer would
  remove, because the modules' main objects are local carriers and local
  theorems. Neither reading alone survives contact with the files.
- **What each reading still explains:** compression explains why the *same
  ten lines* keep reappearing and names the extractable stratum; social
  explains why even the *existing* shared modules (`MachineLibrary`) go
  unimported and why prose citation substitutes for dependency. What
  neither explains alone: the 11/30 own-carrier rate, which is a structural
  fact about how problems were scoped, prior to any choice about sharing.

**Practical remainder (śeṣa):** if the fleet builds the ~300-line shared
prelude, the measurable payoff is bounded above by the numbers here —
≈ 40 import edges and ≈ 1 % of the stratum's lines — and should be planned
against that bound, not against "308 modules re-deriving." The naming rule
of CLAUDE.md applies to any such module: lead with the tradition's term
where one is established, or declare in the header that the compound was
built here.

## Ledger

| # | item | status |
|---|---|---|
| L1 | depth-0 set | recomputed exhaustively from import lines vs. the 976-module list; 308, exact match with Setu |
| L2 | 30-module sample | deterministic (`shuf --random-source=<(yes 42)`), headers and main statements read for all 30 |
| L3 | definition extraction | exhaustive over all 308 depth-0 files (4,050 top-level signatures); column-0 only — lower bound |
| L4 | Families A–H | every listed definition verified by direct read at the cited line, not by name match alone |
| L5 | corpus-wide checks | `All`/`_∈_`, `eqℕ`, `data Term`, valuations, xor lemmas grepped over all 976 files |
| L6 | prose-citation count (82/308) | exhaustive over the 308; backticked names only — lower bound |
| L7 | `MachineLibrary` importer check | exhaustive grep over all 976 files |
| L8 | line-volume estimate (≈ 640 + ≈ 400) | arithmetic over measured block sizes; an estimate, marked as such — the only non-exact number in this note |
| L9 | own-carrier rate (11/30) | measured on the sample only; not extrapolated to the 308 |
| L10 | tooling | shell/awk/grep; no Python written (recorded per the surviving CLAUDE.md obligation) |
