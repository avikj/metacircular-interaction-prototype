{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- IndianLane — a gate that is actually green on the pinned toolchain.
--
-- WHY THIS FILE EXISTS.  `Everything.agda` was written because "an orphan
-- that the root does not import is exactly the hole that let the earlier
-- overstatement hide."  Audited 2026-08-18 with the mechanical check
-- BUILD.md prescribes: TWELVE top-level modules were outside its import
-- closure, and all twelve were from one lane —
--
--     Kuttaka  Bhavana  BhavanaSemiring  BhavanaGenerative  Pingala
--     Sivasutra  Anekanta  JainSankhya  AbhavaAvacchedaka
--     MachineCurriculum  BhedaAvatarana  LosslessReturn
--
-- The newest and most emphasised work in the repository was built by
-- nothing while the older lane was guarded.  That is the sourcing skew
-- reproduced in the build graph rather than in citations, which is the
-- form of it no amount of careful prose catches.
--
-- WHY NOT JUST ADD THEM TO `Everything.agda`.  They ARE added there too.
-- But `Everything.agda` cannot go green on this container: it reaches
-- `NaturalMachine/PathIsSymmetry.agda:98`, which needs `SymGroup`, a
-- cubical v0.9 name that the pinned v0.5 spells `Symmetric-Group`.  That
-- failure is pre-existing, is documented in BUILD.md §280, belongs to
-- another lane, and is untouched here.  Its consequence for THIS lane is
-- the thing worth naming: adding a module to an aggregate that is red for
-- unrelated reasons does not guard it.  The check still fails, the failure
-- still comes from somewhere else, and nobody learns anything about these
-- twelve files.  A gate has to be able to go green to be a gate.
--
-- So this aggregate is the one that runs:
--
--     cd formal/cubical && agda IndianLane.agda      # must exit 0
--
-- Every module below was verified standalone before being listed (exit 0,
-- --safe, no postulates, no holes) — so this file changes what is GUARDED,
-- not what is true.  They were green the day they landed and nothing had
-- re-checked them since.
--
-- WHEN THE v0.9 SKEW IS RESOLVED this file becomes redundant with
-- `Everything.agda` and should be deleted rather than maintained.
------------------------------------------------------------------------

module IndianLane where

-- ĀRYABHAṬA, Āryabhaṭīya, Gaṇitapāda 32-33 (499); Bhāskara I's bhāṣya
-- (629).  The pulverizer, and the descent as a vallī of quotients.
import SourcedProofs.Kuttaka

-- BRAHMAGUPTA, Brāhmasphuṭasiddhānta 18 (628).  Bhāvanā over an arbitrary
-- commutative ring; subtraction-free over ℕ as a semiring identity; and as
-- a typed OPERATION on solutions, which is what "production" names.
import SourcedProofs.Bhavana
-- The same composition made into an OBJECT rather than restated as a law:
-- the invariant lives in the type, so an unlawful card is not rejected but
-- UNSAYABLE, and the single move भावना carries the norm in its own type.
-- Eight moves from the one obvious card at D = 2 reach (577, 408), which is
-- Baudhāyana's √2 -- Śulbasūtra 1.61–62, c. 800 BCE, older than the
-- composition law it is reached by.
import SourcedProofs.BhavanaKrida
import SourcedProofs.BhavanaSemiring
import SourcedProofs.BhavanaGenerative

-- The cycle's step with every subtraction cleared, so a concrete run is
-- certifiable in arithmetic the kernel actually computes.
import CakravalaNat

-- JAYADEVA (~950, via Udayadivākara 1073); BHĀSKARA II, Bījagaṇita (1150):
-- the cakravāla step, and why Bhāskara needs only ONE congruence.
import SourcedProofs.CakravalaDescent

-- The choice rule's PAYLOAD: |k| ≤ 2√D is preserved by the step, so the
-- wheel turns inside a fixed window.  Termination itself stays open.
import SourcedProofs.CakravalaBound

-- EMITTED BY THE REACTOR (machine/NalandaEmit.hs) and checked here: the
-- cakravala's answer for D = 61 as a term, not a printed number.
import CakravalaWitness

-- The flagship residual closed by a lemma transcribed from the machine's own
-- discarded trace-replay output. See notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md.
import SeamClosed

-- The WHOLE trace corpus in one module, generated: TraceLibrary reads the
-- machine's own discarded trace-replay proofs back, deduplicates them by
-- declaration, and makes them citable by name.

-- PIṄGALA, Chandaḥśāstra (~300 BCE), with Virahāṅka (~700) and Halāyudha
-- (10th c.): the mātrā recurrence, binary enumeration of metres.
import SourcedProofs.Pingala

-- PĀṆINI, Aṣṭādhyāyī (~500 BCE): the Śivasūtras as a pratyāhāra machine,
-- and the rule-conflict machinery -- utsarga/apavāda, the elsewhere
-- condition, asiddhatva, anuvṛtti.  Green, and until now gated only by
-- Everything.agda, which cannot go green on this container.
import Sivasutra
-- The optimality Sivasutra.agda records as OWED, part paid: classes sharing
-- one anubandha are a ⊆-chain, so a ⊆-antichain of classes forces that many
-- markers, in ANY order.  Four for the vowel classes; the order attains four.
import SourcedProofs.PratyaharaLaghava_TheMarkerCountIsForcedByTheAntichain
import Panini
import ElsewhereCondition

-- PĀṆINI 8.2.1 पूर्वत्रासिद्धम् as a TERMINATION technique, with the
-- impossibility half: the tripādī's own 8.2.39/8.4.56 cycle admits no
-- strict order in which every rule decreases -- so no reduction order,
-- hence no RPO/KBO/polynomial/matrix interpretation, hence no Knuth-Bendix
-- completion.  Asiddhatva terminates it anyway, by constraining which
-- rules may OBSERVE which outputs rather than by a decreasing measure.
-- The witness is not invented: it is what machine/Astadhyayi.hs does
-- deriving vāk from vāc, and what its asiddhaAudit refuses.
import SourcedProofs.Asiddhatva

-- The OTHER device, 6.4.22 असिद्धवदत्राभात् (mutual invisibility inside
-- 6.4.22–6.4.129, rules applying as if simultaneously), against 8.2.1's
-- ordered regime at the one site where the difference is visible: three
-- tripādī rules offer at the same position in tat + jalam, and क्रम gives
-- the attested tajjalam while सह gives tadjalam, which Sanskrit has not.
-- Both regimes COMPUTED from one act table.  So पूर्वत्रासिद्धम् is
-- load-bearing and is the ordered device -- evidence reached from the
-- rules, not from the sūtra text.
import SourcedProofs.AsiddhavatRegime

-- UMĀSVĀTI, Tattvārthasūtra 1.5: नामस्थापनाद्रव्यभावतस्तन्न्यासः -- the
-- fourfold placing, as an indexed sameness relation.
import SourcedProofs.Niksepa

-- Jain epistemology and mathematics.  Anekāntavāda as a TOTAL generator
-- (no rejection path); the taxonomy of the unbounded, saṃkhyāta /
-- asaṃkhyāta / ananta; abhāva with its avacchedaka.
import Anekanta
import JainSankhya
import AbhavaAvacchedaka

-- ADDED 2026-08-19, AFTER A SURVEY -- AND THE SURVEY'S FIRST VERDICT
-- WAS WRONG.  Recorded here because the wrong version was published in
-- this header and in three commit messages.
--
-- WHAT I CLAIMED: machine/Yogyata.hs found five green Indian modules
-- "reachable from NO gate at all" and twenty-six more reachable only
-- from those five -- thirty-one that nothing typechecked -- and I read
-- that as the Indian material being shelved while the Western lane sat
-- in the reactor.
--
-- WHAT IS TRUE.  The survey read ONE DIRECTORY LEVEL: 140 of the 602
-- Agda files under formal/cubical/.  It stated its domain honestly and
-- I read the domain line as "the corpus".  Four of the five are
-- imported from formal/cubical/NaturalMachine/, which it never opened.
--
-- Recursing, the picture INVERTS.  guarded 104, reached-only-by-a-red-
-- gate 409, shelf 117, orphan 23.  The 409 is overwhelmingly EGB*,
-- Gamma0*, FactoryVI, HeadDepth -- the Western lane -- because
-- agda and Everything.agda both die in two seconds at
-- NaturalMachine/PathIsSymmetry.agda:98 on `SymGroup`, a cubical v0.9
-- name against the pinned v0.5.  That is the FIRST of several such name
-- skews, not the only one -- fixing it moves the failure to
-- NaturalMachine/SymmetryCardinality.agda:31 on `factorial`.  So "one
-- identifier was why four hundred modules went unchecked" is also wrong,
-- and is corrected here rather than left standing.  What is established:
-- 409 modules are reached only by a gate that fails, and after yesterday's gating this
-- file is the only green Agda gate here, and the Indian modules are
-- among the few things actually being checked -- the opposite of what
-- I said.
--
-- WHAT SURVIVES.  Adding these modules here was still right: a gate
-- that cannot go green does not guard what it reaches, which is this
-- file's own founding argument, and NaturalMachine could not go green.
-- And the mechanism stands on its own evidence: this gate was created
-- at 19:19:50 on 2026-08-18 in a commit titled "the lane nothing was
-- building", and between 19:23 and 21:43 that evening seventeen more
-- Indian modules were written and none was added to it.
-- .claude/hooks/gate-coverage.sh now fires at the moment of the write.
--
-- PIṄGALA, Chandaḥśāstra ch. 8 (c. 300–200 BCE), the six pratyaya; with
-- Virahāṅka, Vṛttajātisamuccaya ch. 6 (c. 600–800 CE) for the mātrāmeru
-- and Halāyudha, Mṛtasañjīvanī (10th c.) on 8.34–8.35 for the triangular
-- array.  naṣṭa and uddiṣṭa are proved mutually inverse, each implemented
-- independently rather than one transported along the other; and the
-- recurrences are FORCED by the counting problem for an arbitrary counting
-- function, not read off a definition.
import SourcedProofs.PingalaPrastara
-- नष्टोद्दिष्टम् — पिङ्गलस्य नष्ट/उद्दिष्ट स्थान-पृथक्-छेदेषु विस्तारितौ, परस्पर-प्रतिलोमौ (अङ्कस्थान rs ≃ Fin (सङ्ख्या rs)) ;
-- मेरु-पङ्क्तिः एक-पङ्क्त्या जन्यते, मात्रामेरुः युगलेन ।  एतत् machine/Prastara_*.hs-मध्ये चलति ।
import SourcedProofs.NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn
-- संख्या-पङ्क्ति-सेतुः — पिङ्गलस्य संख्या-प्रत्ययः = मेरु-पङ्क्ति-योगः (sankhya n = ∑ₖ C(n,k))
import PrastaraPankti

-- The saptabhaṅgī: Bhagavatī Sūtra (pre-CE strata, redacted c. 5th c.);
-- Umāsvāti, Tattvārthasūtra 1.6, 1.33, 5.29, 5.31; Siddhasena Divākara,
-- Sanmatitarka 1.21 and 1.28 (c. 5th c.); Samantabhadra, Āptamīmāṃsā
-- (c. 6th c.); Akalaṅka, Laghīyastraya (c. 720–780) for the argument that
-- the number is EXACTLY seven; Mallisena, Syādvādamañjarī (1292) for
-- sakalādeśa against vikalādeśa.  avaktavyam is proved well-defined,
-- decidable, realised, and NOT the denotation of any single standpointed
-- utterance -- which is what machine/Obstruction.hs was groping toward
-- when it invented `Unparsed`, and what I cited the weaker version of
-- earlier today.
import SourcedProofs.SaptabhangiNaya

-- MĀDHAVA of Saṅgamagrāma (c. 1340–1425) and the Kerala school; jīva
-- (the sine-chord); the aṃśa reading of the truth-instrument.
import Madhava
import Jiva
import AmshaSatyayantra

-- अनुक्तम् is not अवक्तव्यम्, and the difference is a swapped quantifier.
-- Satyayantra.agda glossed its third position as avaktavyam; Purnata
-- proves that position सामयिक (for every instance SOME grant removes
-- it) and SaptabhangiNaya proves the fourth bhaṅga नित्य (for every
-- single utterance SOME profile survives it).  Dual shapes, one word.
-- Akalaṅka's kramārpaṇa against sahārpaṇa, Laghīyastraya c. 720–780.
import SourcedProofs.AnuktaAvaktavya

-- The two saptabhaṅgī modules, which had no gate and no link to each
-- other: Saptabhangi.agda (क्रम-सह-भेदः, that the sequential bhaṅga is
-- not the simultaneous one, and दुर्नयः, that ANY two-valued verdict
-- identifies two of the three seeds by pigeonhole) and
-- SourcedProofs.SaptabhangiNaya.agda.  AnuktaAvaktavya §7 now holds both and draws
-- the distinction that keeps them from contradicting: content is
-- reachable by a pair, position is not reachable by sequencing.
import Saptabhangi

-- The machine's own material read back: the curriculum its refusals
-- demand, descent by distinction, and return.
import BhedaAvatarana
import LosslessReturn

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only.
--
-- This header names the v0.5/v0.9 skew at `NaturalMachine/PathIsSymmetry.agda:98`
-- as pre-existing, another lane's, and untouched — and draws the right
-- conclusion from it, that a gate which cannot go green is not a gate.
--
-- The repair is now VERIFIED, though still not applied: v0.5 spells the
-- name `Symmetric-Group`, with the same two explicit arguments, in the
-- module that file already opens.  A renamed copy compiled OUTSIDE the
-- repository gives exit 0, and `Everything.agda`'s only reported error
-- is that one line.  Details, commands and exit codes are appended at
-- the end of `NaturalMachine/PathIsSymmetry.agda`, at its own site.
--
-- NOT established: that applying it makes `Everything.agda` green —
-- Agda stops at the first error, so downstream blockers would not have
-- shown.  So this file's reason for existing is not withdrawn by the
-- finding; if the repair is applied and the aggregate goes green, THEN
-- this file's own closing sentence applies and it should be deleted.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, third correction, and it reframes the two above.
--
-- I have been reporting "409 modules reached only by a gate that fails" as
-- if it described this CORPUS.  It describes this CONTAINER.
--
-- BUILD.md and formal/cubical/check.sh give the pin as Agda 2.8.0 with
-- agda/cubical v0.9.  This container carries Agda 2.6.3 and cubical v0.5.
-- check.sh exists to stop exactly the conclusion I drew -- its own contract
-- says "It NEVER reports green under a toolchain that is not the pin.  If it
-- has to fall back, every line of its output says so and the exit code is
-- non-zero regardless of what Agda returned."  I called `agda` directly all
-- session and never ran it.
--
-- The skew is not a series of renames to be patched.  MEASURED: 336 uses of
-- `solve!` and 36 of `solveℕ!` across formal/cubical/ -- 372 proof
-- obligations discharged by tactics whose v0.9 spellings the pinned v0.5
-- does not have.  Rewriting those solver-free is not a repair, it is a
-- rewrite of a large fraction of the corpus, and it would move the corpus
-- OFF its own declared pin to suit a container.
--
-- And the library alone does not close it: cloning cubical v0.9 and pointing
-- Agda 2.6.3 at it fails in the library's own Foundations/Structure.agda on
-- `opaque`, an Agda 2.7+ feature.  The pin is 2.8.0 for a reason.
--
-- SO: the corpus is not rotting.  The two version-agnostic repairs made
-- today (SymGroup and FinSymGroup in NaturalMachine/PathIsSymmetry.agda,
-- factorial in NaturalMachine/SymmetryCardinality.agda) are still
-- improvements -- they name the same objects under both surfaces and pick no
-- side -- but they do NOT open a path to a green NaturalMachine here, and I
-- should not have implied one.
--
-- WHAT STANDS UNCHANGED, because it does not depend on any of this: this
-- gate was created at 19:19:50 on 2026-08-18 in a commit titled "the lane
-- nothing was building", seventeen more Indian modules were written by 21:43
-- that evening with none added to it, and .claude/hooks/gate-coverage.sh now
-- fires at the moment of the write.  A gate has to be able to go green to be
-- a gate -- and on this container, this one is the only Agda gate that can.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, fourth append: two correctors that NO gate reached.
--
-- `NaturalMachine/SamayikaAndNityaAreIndependent.agda` and
-- `NaturalMachine/TheFourthCornerIsRefutedUnderPointwiseStability.agda`
-- were both written today, both are green under this container's Agda
-- 2.6.3 / cubical v0.5, and both were reachable from nothing.  They are
-- under NaturalMachine/ by name only: `agda` does not
-- import either, and the second imports the first, so the pair was a
-- closed island.
--
-- Adding them here is not bookkeeping.  It is the ONLY mechanism by which
-- `SamayikaAndNityaAreIndependent` can be made load-bearing at all.  It
-- refutes a claim in `SourcedProofs.AnuktaAvaktavya.agda`, and to do that it must open
-- AnuktaAvaktavya for the very definitions it corrects
-- (`using (सामयिक ; नित्य)`) -- so AnuktaAvaktavya CANNOT import it back.
-- Agda says so:
--
--   cyclic module dependency:
--     AnuktaAvaktavya → SamayikaAndNityaAreIndependent
--                     → AnuktaAvaktavya
--
-- A correction strong enough to use the object it corrects is, for that
-- same reason, unable to be cited by it.  The gate is where the two meet:
-- the aggregate imports both, so both are checked, and neither imports the
-- other.  `SourcedProofs.AnuktaAvaktavya.agda` §9 records the same fact from the other
-- side and keeps a pointer there, which is the strongest mechanism
-- available IN that direction.
--
-- General, and it is the reason this is written out rather than just done:
-- an aggregate is not only a list of what to check.  It is the only place
-- in a module system where mutually uncitable results can be held
-- together.  Every pair (claim, refutation-that-uses-the-claim) in this
-- corpus has this shape and will need this remedy.
------------------------------------------------------------------------

import SamayikaAndNityaAreIndependent
import KramaAstiNasti_TheFourthCornerIsRefutedUnderPointwiseStability

------------------------------------------------------------------------
-- APPENDED 2026-08-19, fifth append.
--
-- Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction imports both
-- AnuktaAvaktavya and the two modules that refute it, which no one of
-- them can do, and holds the objection and the survivor in one checked
-- record.  Kauṭilya, Arthaśāstra 15.1; Caraka Saṃhitā, Siddhisthāna 12.
------------------------------------------------------------------------

import Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction

------------------------------------------------------------------------
-- APPENDED 2026-08-20, sixth append: the dispute, not the blend.
--
-- ApohaParyaya_… makes the Bauddha argue against a Jaina construction
-- already in this corpus, and exhibits the incompatibility WITHOUT
-- resolving it.  Every modern treatment I know of blends the two schools
-- into one "Indic" toolkit, which discards the dispute, and the dispute
-- is the content — CLAUDE.md's mining directive, one level up.
--
-- Dignāga, Pramāṇasamuccaya (c. 480–540); Dharmakīrti, Pramāṇavārttika
-- (c. 600–660); Śāntarakṣita, Tattvasaṅgraha (c. 750).  Against Umāsvāti,
-- Tattvārthasūtra 5.29 and 5.31; Akalaṅka (c. 720–780); Vidyānanda,
-- Aṣṭasahasrī (c. 850); Prabhācandra, Prameyakamalamārtaṇḍa (c. 1000).
------------------------------------------------------------------------

import SourcedProofs.ApohaParyaya_WhetherConceptualContentIsNegativeIsWhatTheTwoSchoolsActuallyDispute

------------------------------------------------------------------------
-- APPENDED 2026-08-20, seventh append: the fitness condition on absence.
--
-- Anupalabdhi_… adds the slot the corpus's absence machinery did not have.
-- `AbhavaAvacchedaka` and `TheAnuyogitaAvacchedakaIsADistinctSlot`
-- carry the Navya-Nyāya slots — pratiyogin, anuyogin, avacchedaka — and none
-- of them carries the EXTENT SEARCHED, which is what makes non-apprehension a
-- pramāṇa instead of an excuse.  The theorem is one line and the
-- counterexample is the content: a search that is clean over a real, non-empty
-- examined region while the absence is false.
--
-- Kumārila Bhaṭṭa, Ślokavārttika, Abhāvapariccheda (c. 7th c.), for
-- anupalabdhi as a separate pramāṇa; Prabhākara refuses it as separate and
-- folds it into perception; both impose yogyānupalabdhi, and it is the
-- condition and not the count of pramāṇas that this file formalises.  Nothing
-- in it is Jaina, and it says so: syād-nāsti with its fourfold ground is a
-- different construction and the exchange between the two schools is exhibited
-- rather than settled, in the Haskell lane.
------------------------------------------------------------------------

import Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge
