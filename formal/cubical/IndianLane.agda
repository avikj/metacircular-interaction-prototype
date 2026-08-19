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

-- The machine's own material read back: the curriculum its refusals
-- demand, descent by distinction, and return.
import MachineCurriculum
import BhedaAvatarana
import Punaragamana
