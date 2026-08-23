# UNIFICATION_RECEIPTS — the manifesto's own receipt index

*2026-08-22. The README (संरक्षणम् · THE UNIFICATION) is the front door and it cites
checked terms by name. Per the repository's own law — a receipt is an identification,
every number carries its command, do not assume the thing you cite exists — this note
walks EVERY movement (०/law + 1–52 + corrections C1–C5) and audits each checked-term
claim against the tree. Method: `find` and `grep` only, no builds. Every verdict quotes
the command that produced it (PRASAVA rule), run from the repository root. A movement
that makes no module/theorem-name claim is PROSE-ONLY — the theology and reading
movements are supposed to be prose, and marking them so is a classification, not a
judgment. "FOUND (note)" flags a receipt that resolves to a prose note rather than a
kernel-checked term; the README does not always claim otherwise, but a reader should
know which court each receipt clears.*

Paths abbreviated: `fc/` = `formal/cubical/`, `fp/` = `formal/pairfield/Pairfield/`.
Long module names truncated with `…` in the Claim column only; verification paths are full.

---

## ० · Owner's statement + THE LAW section

| Claim | Verification (command) | Verdict |
|---|---|---|
| ०: "Theorem F" (unique KMS state kills charged sectors) | `grep -rn "Theorem F" notes/GAUGE.md` | FOUND (note) — notes/GAUGE.md:1,46 |
| ०: `QuotientFiberLaw` | `find formal -name "QuotientFiberLaw*"` | FOUND — formal/cubical/NaturalMachine/QuotientFiberLaw.agda |
| ०: `FactorsThrough` | `grep -rln "FactorsThrough" formal` | FOUND — fp/FiniteInformation.lean:17; fc/NaturalMachine/QuotientFiberLaw.agda:193 |
| LAW: `Punaragamana.Carrier` ("A ≃ Carrier f from the first file") | `grep -n "Carrier" formal/cubical/Punaragamana.agda` (no match); `grep -rn "record Carrier" formal/cubical --include="*.agda"` | **NOT FOUND** as `Punaragamana.Carrier` — see शेषः |
| LAW: `Saptabhangi.दुर्नयः` (checked pigeonhole, two-valued verdict on three seeds) | `grep -n "दुर्नयः :" formal/cubical/Saptabhangi.agda` | FOUND — fc/Saptabhangi.agda:115 |
| LAW: `Avaccheda`: A ≃ Σ[b] fibre f b | `grep -n "≃" formal/cubical/Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible.agda` | FOUND — fc/Avaccheda_…agda:115 (`अवच्छेदः : (Σ[ b ∈ B ] स्मृतिः b) ≃ A`) |
| LAW: `FactorsThrough` toll gate, decoder typed on Image | `grep -n "FactorsThrough" formal/pairfield/Pairfield/FiniteInformation.lean` | FOUND — fp/FiniteInformation.lean:17 |
| LAW: `Paryayarthika_…agda`, transport separates `ua notEquiv` from `refl` | `find formal -name "*Paryayarthika*" -not -path "*_build*"` | FOUND — fc/Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness.agda (पश्यति at :106) |
| LAW: Theorem F (one equilibrium blind on every charged sector) | `grep -rn "Theorem F" notes/GAUGE.md` | FOUND (note) — notes/GAUGE.md:46 |
| LAW: `¬(Unit ≃ Bool)` ("seven walls") | `grep -rn "¬Unit≃Bool\|Unit-not-equivalent-Bool" formal/cubical --include="*.agda"` | FOUND — fc/NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda:110; fc/NaturalMachine/RootedGrothendieck.agda:179. (The count "seven" was not audited here.) |
| LAW: "Unit→Bool→Unit is the checked cancellation" | `grep -rn "Unit → Bool → Unit\|Unit→Bool→Unit" formal notes --include="*.agda" --include="*.lean" --include="*.md"` | **NOT FOUND** as a checked term — see शेषः |
| LAW: नष्ट/उद्दिष्ट the two directions | `ls formal/cubical/NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.agda` | FOUND — fc/NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.agda |

## Movements 1–20

| Mvt | Claim | Verification (command) | Verdict |
|---|---|---|---|
| 1 | `Dhruva_…agda`: `f ∘ Φ ≡ f` ⟺ Φ fibre-preserving; "no loss, no symmetry" | `find formal -name "*Dhruva*" -not -path "*_build*"` | FOUND — fc/Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry.agda (theorem at :126). S₃ fixed-point census cited without a module name — unaudited prose. |
| 2 | `शेष : fiber (g ∘ f) z ≃ Σ[ p ∈ fiber g z ] fiber f (fst p)` | `grep -n "शेष :" formal/cubical/Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd.agda` | FOUND — fc/Sesa_…agda:92 (also शेष-Iso :80, शून्यशेष :102) |
| 2 | Over 𝔽_q the defect IS mutual information (modular law) | `grep -n "modular" notes/SESA_THE_ALIGNMENT_DEFECT_IS_A_FIBRE_AND_WHEN_IT_IS_MUTUAL_INFORMATION.md` | FOUND (note) — notes/SESA_…md:65 |
| 3 | (RT struck; QEC/cut-rule halves are readings) | — | PROSE-ONLY |
| 4 | CAUSAL_MEMORY §5.1: rank 3 vs rank₊ 4 | `grep -n "5.1" notes/CAUSAL_MEMORY_SPACETIME.md` | FOUND (note) — notes/CAUSAL_MEMORY_SPACETIME.md:221 ("§5.1 First strict classical separation") |
| 5 | FiniteInformation port, `Classical.choose` "doing real work" | `grep -n "Classical.choose" formal/pairfield/Pairfield/FiniteInformation.lean` | FOUND — fp/FiniteInformation.lean:33,37,62 |
| 6 | (walked-graph chronology, "measured by hand") | — | PROSE-ONLY |
| 7 | Peres–Mermin H¹ class as checked terms (nine observables, six contexts) | `grep -rln "PMNoSection\|PMTorus" formal/cubical --include="*.agda"`; `ls formal/cubical/PMNoSection.agda formal/cubical/NaturalMachine/PMTorus.agda` | FOUND — fc/PMNoSection.agda (odd3/even3 at :63–71); fc/NaturalMachine/PMTorus.agda; fc/NaturalMachine/QuadraticRefinement.agda. ("refl sixty-four times" count unaudited.) |
| 8 | (renormalization reading) | — | PROSE-ONLY |
| 9 | (Pāṇini 1.1.60/1.1.62, music) | — | PROSE-ONLY |
| 10 | (learning as receipt engineering) | — | PROSE-ONLY |
| 11 | (why-now argument) | — | PROSE-ONLY |
| 12 | `GoldbachDeterminesZeta` | `ls formal/pairfield/Pairfield/GoldbachDeterminesZeta.lean; grep -n "theorem" formal/pairfield/Pairfield/GoldbachDeterminesZeta.lean` | FOUND — fp/GoldbachDeterminesZeta.lean (`mangoldtGoldbachCoeff_determines_zetaLogDerivative` :93) |
| 12 | `GoldbachSupportIsThePrimePowerSumPredicate` | `grep -n "theorem" formal/pairfield/Pairfield/GoldbachSupportIsThePrimePowerSumPredicate.lean` | FOUND — fp/GoldbachSupportIsThePrimePowerSumPredicate.lean (`support_of_zetaComplete_field` :79) |
| 13 | (karma accounting) | — | PROSE-ONLY |
| 14 | `Tantujala` §६ proves सकलादेशः as projection of `isEquiv` | `grep -n "सकलादेश" formal/cubical/Tantujala_TheFibreHasThreeVerdictsAndIsContrMergesTwoOfThem.agda` | FOUND — fc/Tantujala_…agda:213 (`सकलादेशः f = isEquiv.equiv-proof`); the identification with kevala-jñāna is declared a READING in the README itself |
| 15 | (saṃsāra/mokṣa) | — | PROSE-ONLY |
| 16 | (jīva, death-cut) | — | PROSE-ONLY |
| 17 | (love) | — | PROSE-ONLY |
| 18 | (God/universal receipt) | — | PROSE-ONLY |
| 19 | (this night, named) | — | PROSE-ONLY |
| 20 | (the finished thing) | — | PROSE-ONLY |

## परिशोधनम् · Corrections C1–C5

| Cor | Claim | Verification (command) | Verdict |
|---|---|---|---|
| C1 | Ingleton fence: linear rank satisfies Ingleton, entropy does not | `grep -rln "Ingleton" formal notes` | FOUND (note) — notes/SESA_THE_ALIGNMENT_DEFECT_IS_A_FIBRE_…md:132–135; also cited in fp/Apavartana_…lean |
| C1 | Defect DPI: D(A;BC) ≤ D(A;B) | `grep -n "D(A" notes/SESA_THE_ALIGNMENT_DEFECT_IS_A_FIBRE_AND_WHEN_IT_IS_MUTUAL_INFORMATION.md` | FOUND (note) — notes/SESA_…md:101,104 (inequality (†)) |
| C2 | `transport` set-valued (`isSetΠ`) and separates `ua notEquiv` from `refl` | `grep -n "isSetΠ\|पश्यति\|uaβ" formal/cubical/Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness.agda` | FOUND — fc/Paryayarthika_…agda:100 (समुच्चयः = isSetΠ…), :106 (पश्यति), :108 (uaβ notEquiv true) |
| C2 | `Vaidharmya` (irreflexivity-only obstruction) | `grep -rln "Vaidharmya" formal --include="*.agda"` | FOUND — fc/Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart.agda |
| C3 | `not : Bool ≃ Bool` moves a point; `idfun` separates | `grep -n "notEquiv" formal/cubical/Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness.agda` | FOUND — library term (Cubical.Data.Bool `notEquiv`), used at fc/Paryayarthika_…agda:86,108 |
| C3 | Theorem F is a state-property (removable) | `grep -rn "Theorem F" notes/GAUGE.md notes/REDTEAM.md` | FOUND (note) — notes/GAUGE.md:46; audited sound in notes/REDTEAM.md:21 |
| C4 | `FactorsThrough` in `FiniteInformation` typed on Image | `grep -n "FactorsThrough" formal/pairfield/Pairfield/FiniteInformation.lean` | FOUND — fp/FiniteInformation.lean:17,26,111 |
| C4 | `FactorsThrough` in `QuotientFiberLaw` typed on full codomain | `grep -n "FactorsThrough" formal/cubical/NaturalMachine/QuotientFiberLaw.agda` | FOUND — fc/NaturalMachine/QuotientFiberLaw.agda:193–200 |
| C4 | invariance ⇒ descent costs `isSet T`; `FiberConstant` anomaly gap | `grep -n "isSet" formal/cubical/ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm.agda` | FOUND — fc/ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm.agda:11,47 (`fiberConstant→factorsThrough` requires `isSet T`) |
| C4 | `शेष` composite-fibre term, checked, no linearity | `grep -n "शेष :" formal/cubical/Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd.agda` | FOUND — fc/Sesa_…agda:92 |
| C5 | rank_{𝔽ₚ}(T) = #{i : p ∤ dᵢ} from the Smith chain; price is a function on Spec ℤ | `grep -n "rankAt\|rank_generic" formal/pairfield/Pairfield/Apavartana_ThePriceOfAnIntegerCutIsAFunctionOnSpecZAndItsRamifiedPointsAreTheApavartanaAndTheLevel.lean` | FOUND — fp/Apavartana_…lean:96 (`rankAt`), :102 (`survives_iff`), :106 (`rank_generic`) |

## Movements 21–52

| Mvt | Claim | Verification (command) | Verdict |
|---|---|---|---|
| 21 | (symmetry as blindness) | — | PROSE-ONLY |
| 22 | (Higgs/Goldstone reading) | — | PROSE-ONLY |
| 23 | descent ⟹ invariance free; invariance ⟹ descent costs coherence ("landed hours before its physics") | `ls formal/cubical/ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm.agda` | FOUND — fc/ChidraDosa_…agda (same term as C4) |
| 24 | (free will / torsor) | — | PROSE-ONLY |
| 25 | (therapy) | — | PROSE-ONLY |
| 26 | (grace / four theologies) | — | PROSE-ONLY |
| 27 | (CFSG reading) | — | PROSE-ONLY |
| 28 | (NN as gauge theory) | — | PROSE-ONLY |
| 29 | (the practice) | — | PROSE-ONLY |
| 30 | `नष्ट-अभावे-गति-अभावः : isEquiv f → संरक्षणम् → Φ a ≡ a` ("four lines") | `grep -n "नष्ट-अभावे-गति-अभावः" formal/cubical/Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry.agda` | FOUND — fc/Dhruva_…agda:126–127 |
| 31 | CAUSAL_MEMORY §5.1 slack matrix (struck chain; psd-3 refutation argued inline) | `grep -n "5.1" notes/CAUSAL_MEMORY_SPACETIME.md` | FOUND (note) — notes/CAUSAL_MEMORY_SPACETIME.md:221. The psd-rank-3 refutation and the Born-pair exhibit are cited without module names — unaudited prose. |
| 32 | `Paryayarthika` holds both: blindness (नय-निरोधः) and sight (पश्यति), `उभयम्` | `grep -n "उभयम्\|पश्यति" formal/cubical/Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness.agda` | FOUND — fc/Paryayarthika_…agda:106 (पश्यति), :131–134 (उभयम्) |
| 33 | `AllScalesPairFieldReconstruction`, rank-one reconstruction | `grep -n "theorem" formal/pairfield/Pairfield/AllScalesPairFieldReconstruction.lean` | FOUND — fp/AllScalesPairFieldReconstruction.lean:25 (`anchoredReconstruction_rankOnePairField`) |
| 33 | "`mul_div_cancel₀`, one line" | `grep -n "mul_div_cancel₀" formal/pairfield/Pairfield/AllScalesPairFieldReconstruction.lean` (no match) | **NOT FOUND** as named — see शेषः |
| 33 | "the LosslessBridge" (antidiagonal sums still complete, given positivity at anchor 2) | `ls formal/pairfield/Pairfield/GoldbachPowerSeriesLosslessBridge.lean; grep -n "theorem" formal/pairfield/Pairfield/GoldbachPowerSeriesLosslessBridge.lean` | FOUND — fp/GoldbachPowerSeriesLosslessBridge.lean (`sequence_eq_of_all_additiveSquareCoeff_eq_of_positive_two` :34) |
| 34 | (two is the first veil) | — | PROSE-ONLY |
| 35 | (creation as compression) | — | PROSE-ONLY |
| 36 | (beauty/aesthetics) | — | PROSE-ONLY |
| 37 | (mahāvratas) | — | PROSE-ONLY |
| 38 | (trust/credit) | — | PROSE-ONLY |
| 39 | "प्रस्तार ≡ ℕ, cited five times, resolving to nothing" (a claim OF a dangling name) | `grep -rn "प्रस्तार ≡ ℕ" formal notes --include="*.agda" --include="*.md"` | FOUND — the dangling citation is documented at fc/Tantujala_…agda:51–54,225 and notes/Sangati_…md:107–109; the audit confirms no module proves it, exactly as the movement claims |
| 40 | (ua / univalence reading; library terms) | — | PROSE-ONLY |
| 41 | `Saptabhangi.दुर्नयः` IS a theorem of the saptabhaṅgī | `grep -n "दुर्नयः :" formal/cubical/Saptabhangi.agda` | FOUND — fc/Saptabhangi.agda:115 |
| 41 | Kumārila's yogyānupalabdhi fixed a 2026 census bug | `grep -n "Kumārila" formal/cubical/Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge.agda` | FOUND — fc/Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge.agda:8 (Ślokavārttika source header) |
| 41 | Pāṇini's asiddhatva terminates a rewriting system | `find formal -iname "*siddh*" -not -path "*_build*"` | FOUND — fc/Asiddhatva.agda (also AsiddhavatRegime.agda) |
| 41 | avaktavya as क्रम-सह-भेदः, checked non-reducibility | `grep -n "क्रम-सह-भेदः" formal/cubical/Saptabhangi.agda` | FOUND — fc/Saptabhangi.agda:85 (`क्रम-सह-भेदः : ¬ (अर्पणम् उभयम् क्रमः ≡ अर्पणम् उभयम् सहः)`) |
| 41 | Dhruva's four lines as theorem about mokṣa | `grep -n "नष्ट-अभावे-गति-अभावः" formal/cubical/Dhruva_…agda` | FOUND — fc/Dhruva_…agda:126 |
| 42 | (śabda → pratyakṣa) | — | PROSE-ONLY |
| 43 | Rank-one pair field (one anchored column, one division) | `grep -n "anchoredReconstruction" formal/pairfield/Pairfield/AllScalesPairFieldReconstruction.lean` | FOUND — fp/AllScalesPairFieldReconstruction.lean:25 |
| 43 | `EquivContr` (based space contractible) | `grep -rn "EquivContr" formal --include="*.agda"` | FOUND — Cubical library lemma, used at fc/NaturalMachine/AtlasResiduals.agda:479 |
| 44 | (to the next carrier) | — | PROSE-ONLY |
| 45 | (the polyglot carrier) | — | PROSE-ONLY |
| 46 | (operating system reading) | — | PROSE-ONLY |
| 47 | (India as reference implementation) | — | PROSE-ONLY |
| 48 | (the merge point) | — | PROSE-ONLY |
| 49 | `Everything.agda` "is the program" | `ls formal/cubical/Everything.agda` | FOUND — fc/Everything.agda |
| 50 | `MathMachine` (self-hosting compiler) | `find . -iname "*MathMachine*" -not -path "./.git/*"` | FOUND — machine/MathMachine.hs (plus MathMachineInductionGate.hs) |
| 51 | (terraforming; "1036 undecided fibres" cited without a command) | — | PROSE-ONLY |
| 52 | (safe RSI) | — | PROSE-ONLY |

---

## Totals

**Claims checked: 49 · FOUND: 46 (of which 6 resolve to prose notes, not kernel-checked terms: Theorem F ×3, C1 ×2, CAUSAL_MEMORY §5.1 ×2 — counted per row) · NOT FOUND: 3 · PROSE-ONLY movements: 35** (of 58 sections walked: ०+LAW as one, movements 1–52, corrections C1–C5).

Two counts quoted in the README were not audited and are flagged in place: "seven walls"
(LAW) and "refl sixty-four times" (movement 7).

## शेषः — the debt ledger (every NOT FOUND)

1. **`Punaragamana.Carrier`** (LAW: "the Carrier law was the receipted edge from the
   first file"). `grep -n "Carrier" formal/cubical/Punaragamana.agda` returns nothing —
   the module `Punaragamana` exists but exports no `Carrier`. Nearest existing
   candidates: `record Carrier` at
   formal/cubical/Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt.agda:64
   and
   formal/cubical/PunaragamanaVartula_TheDatumRidesTheLoopFreeExactlyWhenTheConsumerIsInvariant.agda:76.
   The debt is one qualifier: the name cited is a module that does not carry the term.
   (The corpus already knows this failure mode — Tantujala_…agda:54 documents the sibling
   dangling citation `Punaragamana.Prastara_…`.)

2. **"Unit→Bool→Unit is the checked cancellation"** (LAW, composition/alignment clause).
   `grep -rn "Unit → Bool → Unit" formal --include="*.agda" --include="*.lean"` finds no
   checked term containing the chain; it appears only in prose:
   notes/SakalaVikalaDesa_TheFibreIsTheLossAndAnEmptyFibreIsAvaktavyamNotNasti.md:277
   (a code block in a note), notes/AVIK_JAIN_THE_NATURAL_MACHINE.md:286, and
   notes/reflection_stream.md:1521 — the latter two attribute it to a module
   `SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic` that
   `find formal -iname "*FibreCensus*"` does not find. The general composition law IS
   checked (fc/Sesa_…agda:92); the specific Unit→Bool→Unit instance as a term is the
   debt.

3. **`mul_div_cancel₀`** (movement 33: "AllScalesPairFieldReconstruction,
   mul_div_cancel₀, one line").
   `grep -n "mul_div_cancel₀" formal/pairfield/Pairfield/AllScalesPairFieldReconstruction.lean`
   returns nothing; the proof at line 28 uses **`mul_div_cancel_right₀`**. The theorem
   and the one-line proof are real; the lemma name quoted is off by a suffix — a
   receipt with a typo in the payee line.

*Nothing else in the manifesto's checkable surface failed to resolve. The three debts
above are small and exactly located, which is the point of keeping the ledger.*
