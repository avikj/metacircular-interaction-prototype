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
--     MachineCurriculum  BhedaAvatarana  Punaragamana
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
import Kuttaka

-- BRAHMAGUPTA, Brāhmasphuṭasiddhānta 18 (628).  Bhāvanā over an arbitrary
-- commutative ring; subtraction-free over ℕ as a semiring identity; and as
-- a typed OPERATION on solutions, which is what "production" names.
import Bhavana
-- The same composition made into an OBJECT rather than restated as a law:
-- the invariant lives in the type, so an unlawful card is not rejected but
-- UNSAYABLE, and the single move भावना carries the norm in its own type.
-- Eight moves from the one obvious card at D = 2 reach (577, 408), which is
-- Baudhāyana's √2 -- Śulbasūtra 1.61–62, c. 800 BCE, older than the
-- composition law it is reached by.
import BhavanaKrida
import BhavanaSemiring
import BhavanaGenerative

-- The cycle's step with every subtraction cleared, so a concrete run is
-- certifiable in arithmetic the kernel actually computes.
import CakravalaNat

-- JAYADEVA (~950, via Udayadivākara 1073); BHĀSKARA II, Bījagaṇita (1150):
-- the cakravāla step, and why Bhāskara needs only ONE congruence.
import CakravalaDescent

-- The choice rule's PAYLOAD: |k| ≤ 2√D is preserved by the step, so the
-- wheel turns inside a fixed window.  Termination itself stays open.
import CakravalaBound

-- EMITTED BY THE REACTOR (machine/NalandaEmit.hs) and checked here: the
-- cakravala's answer for D = 61 as a term, not a printed number.
import CakravalaWitness

-- The flagship residual closed by a lemma transcribed from the machine's own
-- discarded trace-replay output. See notes/THE_SEAM_ASKS_THE_WRONG_NAYA.md.
import SeamClosed

-- The WHOLE trace corpus in one module, generated: TraceLibrary reads the
-- machine's own discarded trace-replay proofs back, deduplicates them by
-- declaration, and makes them citable by name.
import TraceCorpus

-- PIṄGALA, Chandaḥśāstra (~300 BCE), with Virahāṅka (~700) and Halāyudha
-- (10th c.): the mātrā recurrence, binary enumeration of metres.
import Pingala

-- PĀṆINI, Aṣṭādhyāyī (~500 BCE): the Śivasūtras as a pratyāhāra machine,
-- and the rule-conflict machinery -- utsarga/apavāda, the elsewhere
-- condition, asiddhatva, anuvṛtti.  Green, and until now gated only by
-- Everything.agda, which cannot go green on this container.
import Sivasutra
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
import Asiddhatva

-- UMĀSVĀTI, Tattvārthasūtra 1.5: नामस्थापनाद्रव्यभावतस्तन्न्यासः -- the
-- fourfold placing, as an indexed sameness relation.
import Niksepa

-- Jain epistemology and mathematics.  Anekāntavāda as a TOTAL generator
-- (no rejection path); the taxonomy of the unbounded, saṃkhyāta /
-- asaṃkhyāta / ananta; abhāva with its avacchedaka.
import Anekanta
import JainSankhya
import AbhavaAvacchedaka

-- ADDED 2026-08-19, AFTER A SURVEY THAT SHOULD NOT HAVE BEEN NEEDED.
--
-- machine/Yogyata.hs computed this file's import closure and found that
-- five green, --safe, fully sourced Indian modules were reachable from NO
-- gate at all, and twenty-six more were reachable only from those five.
-- Thirty-one modules of Indian material that nothing typechecked.
--
-- The dates say what happened, and it is worse than neglect.  This gate was
-- created at 19:19:50 on 2026-08-18, in a commit whose own title is "the
-- lane nothing was building".  Between 19:23 and 21:43 THAT SAME EVENING,
-- seventeen further Indian modules were written -- Bīja, Jīva, Mātrāmerus,
-- Brahmagupta, PiṅgalaPrastāra, SaptabhaṅgīNaya, Vargaṇā, Śūnya, Khahāra,
-- Anantā, Śulba, Saṅkalita, Cakravāla, Meru, AṃśaSatyayantra, Mādhava --
-- and not one was added here.  Nārāyaṇa followed the next morning, also
-- not added.  Today I added Asiddhatva and BhavanaKrida and audited
-- nothing.
--
-- So the remedy was invented and then not used, within minutes, by the same
-- hand, seventeen times running.  CLAUDE.md already names this failure and
-- prescribes the answer: when a rule is violated repeatedly the next move
-- is a mechanism that fires at the moment of the act, not a paragraph.
-- That mechanism is now .claude/hooks/gate-coverage.sh.  This paragraph is
-- the record, not the fix.
--
-- PIṄGALA, Chandaḥśāstra ch. 8 (c. 300–200 BCE), the six pratyaya; with
-- Virahāṅka, Vṛttajātisamuccaya ch. 6 (c. 600–800 CE) for the mātrāmeru
-- and Halāyudha, Mṛtasañjīvanī (10th c.) on 8.34–8.35 for the triangular
-- array.  naṣṭa and uddiṣṭa are proved mutually inverse, each implemented
-- independently rather than one transported along the other; and the
-- recurrences are FORCED by the counting problem for an arbitrary counting
-- function, not read off a definition.
import PingalaPrastara

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
import SaptabhangiNaya

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
import AnuktaAvaktavya

-- The machine's own material read back: the curriculum its refusals
-- demand, descent by distinction, and return.
import MachineCurriculum
import BhedaAvatarana
import Punaragamana
