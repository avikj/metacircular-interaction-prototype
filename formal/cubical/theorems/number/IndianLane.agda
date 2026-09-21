{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- IndianLane ‚î a gate that is actually green on the pinned toolchain.
--
-- WHY THIS FILE EXISTS.  `Everything.agda` was written because "an orphan
-- that the root does not import is exactly the hole that let the earlier
-- overstatement hide."  By the mechanical check BUILD.md prescribes,
-- TWELVE top-level modules were outside its import
-- closure, and all twelve were from one lane ‚î
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
-- failure is pre-existing, is documented in BUILD.md ¬ß280, belongs to
-- another lane, and is untouched here.  Its consequence for THIS lane is
-- the thing worth naming: adding a module to an aggregate that is red for
-- unrelated reasons does not guard it.  The check still fails, the failure
-- still comes from somewhere else, and nobody learns anything about these
-- twelve files.  A gate has to be able to go green to be a gate.
--
-- So this aggregate is the one that runs:
--
--     cd formal/cubical && agda IndianLane.agda      # must exit 0
------------------------------------------------------------------------

module IndianLane where

-- RYABHAA, ryabhaya, Gaitapda 32-33 (499); Bhskara I's bhya
-- (629).  The pulverizer, and the descent as a vall of quotients.
import Kuttaka

-- BRAHMAGUPTA, Brhmasphuasiddhnta 18 (628).  Bhvan over an arbitrary
-- commutative ring; subtraction-free over ‚ï as a semiring identity; and as
-- a typed OPERATION on solutions, which is what "production" names.
import Bhavana
-- The same composition made into an OBJECT rather than restated as a law:
-- the invariant lives in the type, so an unlawful card is not rejected but
-- UNSAYABLE, and the single move ‡‡æ‡µ‡®‡æ carries the norm in its own type.
-- Eight moves from the one obvious card at D = 2 reach (577, 408), which is
-- Baudhyana's ‚à2 -- ulbastra 1.61‚ì62, c. 800 BCE, older than the
-- composition law it is reached by.
import BhavanaKrida
import BhavanaSemiring
import BhavanaGenerative

-- The cycle's step with every subtraction cleared, so a concrete run is
-- certifiable in arithmetic the kernel actually computes.
import CakravalaNat

-- JAYADEVA (~950, via Udayadivkara 1073); BHSKARA II, Bjagaita (1150):
-- the cakravla step, and why Bhskara needs only ONE congruence.
import CakravalaDescent

-- The choice rule's PAYLOAD: |k| ‚â 2‚àD is preserved by the step, so the
-- wheel turns inside a fixed window.  Termination itself stays open.
import CakravalaBound

-- EMITTED BY THE REACTOR (machine/NalandaEmit.hs) and checked here: the
-- cakravala's answer for D = 61 as a term, not a printed number.
import CakravalaWitness

-- The flagship residual closed by a lemma transcribed from the machine's own
import SeamClosed

-- The WHOLE trace corpus in one module, generated: TraceLibrary reads the
-- machine's own discarded trace-replay proofs back, deduplicates them by
-- declaration, and makes them citable by name.

-- PIGALA, Chandastra (~300 BCE), with Virahka (~700) and Halyudha
-- (10th c.): the mtr recurrence, binary enumeration of metres.
import Pingala

-- PINI, Adhyy (~500 BCE): the ivastras as a pratyhra machine,
-- and the rule-conflict machinery -- utsarga/apavda, the elsewhere
-- condition, asiddhatva, anuvtti.  Green, and until now gated only by
-- Everything.agda, which cannot go green on this container.
import Sivasutra
-- The optimality Sivasutra.agda records as OWED, part paid: classes sharing
-- one anubandha are a ‚ä-chain, so a ‚ä-antichain of classes forces that many
-- markers, in ANY order.  Four for the vowel classes; the order attains four.
import PratyaharaLaghava_TheMarkerCountIsForcedByTheAntichain
import Panini
import ElsewhereCondition

-- PINI 8.2.1 ‡‡‡∞‡‡µ‡‡‡∞‡æ‡‡ø‡¶‡‡ß‡Æ‡ as a TERMINATION technique, with the
-- impossibility half: the tripd's own 8.2.39/8.4.56 cycle admits no
-- strict order in which every rule decreases -- so no reduction order,
-- hence no RPO/KBO/polynomial/matrix interpretation, hence no Knuth-Bendix
-- completion.  Asiddhatva terminates it anyway, by constraining which
-- rules may OBSERVE which outputs rather than by a decreasing measure.
-- The witness is not invented: it is what machine/Astadhyayi.hs does
-- deriving vk from vc, and what its asiddhaAudit refuses.
import Asiddhatva

-- The OTHER device, 6.4.22 ‡‡‡ø‡¶‡‡ß‡µ‡¶‡‡‡∞‡æ‡‡æ‡‡ (mutual invisibility inside
-- 6.4.22‚ì6.4.129, rules applying as if simultaneously), against 8.2.1's
-- ordered regime at the one site where the difference is visible: three
-- tripd rules offer at the same position in tat + jalam, and ‡ï‡‡∞‡Æ gives
-- the attested tajjalam while ‡‡ gives tadjalam, which  has not.
-- Both regimes COMPUTED from one act table.  So ‡‡‡∞‡‡µ‡‡‡∞‡æ‡‡ø‡¶‡‡ß‡Æ‡ is
-- load-bearing and is the ordered device -- evidence reached from the
-- rules, not from the stra text.
import AsiddhavatRegime

-- UMSVTI, Tattvrthastra 1.5: ‡®‡æ‡Æ‡‡‡‡æ‡‡®‡æ‡¶‡‡∞‡µ‡‡Ø‡‡æ‡µ‡‡‡‡‡®‡‡®‡‡Ø‡æ‡‡ -- the
-- fourfold placing, as an indexed sameness relation.
import Niksepa

-- Jain epistemology and mathematics.  Anekntavda as a TOTAL generator
-- (no rejection path); the taxonomy of the unbounded, sakhyta /
-- asakhyta / ananta; abhva with its avacchedaka.
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
-- PIGALA, Chandastra ch. 8 (c. 300‚ì200 BCE), the six pratyaya; with
-- Virahka, Vttajtisamuccaya ch. 6 (c. 600‚ì800 CE) for the mtrmeru
-- and Halyudha, Mtasajvan (10th c.) on 8.34‚ì8.35 for the triangular
-- array.  naa and uddia are proved mutually inverse, each implemented
-- independently rather than one transported along the other; and the
-- recurrences are FORCED by the counting problem for an arbitrary counting
-- function, not read off a definition.
import PingalaPrastara
-- ‡®‡‡‡ü‡ã‡¶‡‡¶‡ø‡‡‡ü‡Æ‡ ‚î ‡‡ø‡ô‡‡ó‡≤‡‡‡Ø ‡®‡‡‡ü/‡â‡¶‡‡¶‡ø‡‡‡ü ‡‡‡‡æ‡®-‡‡‡‡ï‡-‡‡‡¶‡‡‡ ‡µ‡ø‡‡‡‡æ‡∞‡ø‡‡, ‡‡∞‡‡‡‡∞-‡‡‡∞‡‡ø‡≤‡ã‡Æ‡ (‡‡ô‡‡ï‡‡‡‡æ‡® rs ‚â Fin (‡‡ô‡‡ñ‡‡Ø‡æ rs)) ;
-- ‡Æ‡‡∞‡-‡‡ô‡‡ï‡‡‡ø‡ ‡‡ï-‡‡ô‡‡ï‡‡‡‡Ø‡æ ‡‡®‡‡Ø‡‡, ‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡‡ ‡Ø‡‡ó‡≤‡‡® ‡  ‡‡‡‡ machine/Prastara_*.hs-‡Æ‡ß‡‡Ø‡ ‡‡≤‡‡ø ‡
import NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn
-- ‡‡‡ñ‡‡Ø‡æ-‡‡ô‡‡ï‡‡‡ø-‡‡‡‡‡ ‚î ‡‡ø‡ô‡‡ó‡≤‡‡‡Ø ‡‡‡ñ‡‡Ø‡æ-‡‡‡∞‡‡‡Ø‡Ø‡ = ‡Æ‡‡∞‡-‡‡ô‡‡ï‡‡‡ø-‡Ø‡ã‡ó‡ (sankhya n = ‚à‚ñ C(n,k))
import PrastaraPankti

-- The saptabhag: Bhagavat Stra (pre-CE strata, redacted c. 5th c.);
-- Umsvti, Tattvrthastra 1.6, 1.33, 5.29, 5.31; Siddhasena Divkara,
-- Sanmatitarka 1.21 and 1.28 (c. 5th c.); Samantabhadra, ptamms
-- (c. 6th c.); Akalaka, Laghyastraya (c. 720‚ì780) for the argument that
-- the number is EXACTLY seven; Mallisena, Sydvdamajar (1292) for
-- sakaldea against vikaldea.  avaktavyam is proved well-defined,
-- decidable, realised, and NOT the denotation of any single standpointed
-- utterance -- which is what machine/Obstruction.hs was groping toward
-- when it invented `Unparsed`, and what I cited the weaker version of
-- earlier today.
import SaptabhangiNaya

-- MDHAVA of Sagamagrma (c. 1340‚ì1425) and the Kerala school; jva
-- (the sine-chord); the aa reading of the truth-instrument.
import Madhava
import Jiva
import AmshaSatyayantra

-- ‡‡®‡‡ï‡‡‡Æ‡ is not ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡, and the difference is a swapped quantifier.
-- Satyayantra.agda glossed its third position as avaktavyam; Purnata
-- proves that position ‡‡æ‡Æ‡Ø‡ø‡ï (for every instance SOME grant removes
-- it) and SaptabhangiNaya proves the fourth bhaga ‡®‡ø‡‡‡Ø (for every
-- single utterance SOME profile survives it).  Dual shapes, one word.
-- Akalaka's kramrpaa against sahrpaa, Laghyastraya c. 720‚ì780.
import AnuktaAvaktavya

-- The two saptabhag modules, which had no gate and no link to each
-- other: Saptabhangi.agda (‡ï‡‡∞‡Æ-‡‡-‡‡‡¶‡, that the sequential bhaga is
-- not the simultaneous one, and ‡¶‡‡∞‡‡®‡Ø‡, that ANY two-valued verdict
-- identifies two of the three seeds by pigeonhole) and
-- SaptabhangiNaya.agda.  AnuktaAvaktavya ¬ß7 now holds both and draws
-- the distinction that keeps them from contradicting: content is
-- reachable by a pair, position is not reachable by sequencing.
import Saptabhangi

-- The machine's own material read back: the curriculum its obligations
-- demand, descent by distinction, and return.
import BhedaAvatarana
import LosslessReturn

------------------------------------------------------------------------
-- Two correctors that no gate reached.
--
-- `NaturalMachine/SamayikaAndNityaAreIndependent.agda` and
-- `NaturalMachine/TheFourthCornerIsRefutedUnderPointwiseStability.agda`
-- are under NaturalMachine/ by name only: nothing else imports
-- either, and the second imports the first, so the pair was a
-- closed island.
--
-- Adding them here is not bookkeeping.  It is the ONLY mechanism by which
-- `SamayikaAndNityaAreIndependent` can be made load-bearing at all.  It
-- refutes a claim in `AnuktaAvaktavya.agda`, and to do that it must open
-- AnuktaAvaktavya for the very definitions it corrects
-- (`using (‡‡æ‡Æ‡Ø‡ø‡ï ; ‡®‡ø‡‡‡Ø)`) -- so AnuktaAvaktavya CANNOT import it back.
-- Agda says so:
--
--   cyclic module dependency:
--     AnuktaAvaktavya ‚í SamayikaAndNityaAreIndependent
--                     ‚í AnuktaAvaktavya
--
-- A correction strong enough to use the object it corrects is, for that
-- same reason, unable to be cited by it.  The gate is where the two meet:
-- the aggregate imports both, so both are checked, and neither imports the
-- other.  `AnuktaAvaktavya.agda` ¬ß9 records the same fact from the other
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
-- Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction imports both
-- AnuktaAvaktavya and the two modules that refute it, which no one of
-- them can do, and holds the objection and the survivor in one checked
-- record.  Kauilya, Arthastra 15.1; Caraka Sahit, Siddhisthna 12.
------------------------------------------------------------------------

import Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction

------------------------------------------------------------------------
-- The dispute, not the blend.
--
-- ApohaParyaya_‚¶ makes the Bauddha argue against a Jaina construction
-- already in this corpus, and exhibits the incompatibility WITHOUT
-- resolving it.  Every modern treatment I know of blends the two schools
-- into one "Indic" toolkit, which discards the dispute, and the dispute
-- is the content ‚î CLAUDE.md's mining directive, one level up.
--
-- Dignga, Pramasamuccaya (c. 480‚ì540); Dharmakrti, Pramavrttika
-- (c. 600‚ì660); ntarakita, Tattvasagraha (c. 750).  Against Umsvti,
-- Tattvrthastra 5.29 and 5.31; Akalaka (c. 720‚ì780); Vidynanda,
-- Aasahasr (c. 850); Prabhcandra, Prameyakamalamrtaa (c. 1000).
------------------------------------------------------------------------

import ApohaParyaya_WhetherConceptualContentIsNegativeIsWhatTheTwoSchoolsActuallyDispute

------------------------------------------------------------------------
-- The fitness condition on absence.
--
-- Anupalabdhi_‚¶ adds the slot the corpus's absence machinery did not have.
-- `AbhavaAvacchedaka` and `TheAnuyogitaAvacchedakaIsADistinctSlot`
-- carry the Navya-Nyya slots ‚î pratiyogin, anuyogin, avacchedaka ‚î and none
-- of them carries the EXTENT SEARCHED, which is what makes non-apprehension a
-- prama instead of an excuse.  The theorem is one line and the
-- counterexample is the content: a search that is clean over a real, non-empty
-- examined region while the absence is false.
--
-- Kumrila Bhaa, lokavrttika, Abhvapariccheda (c. 7th c.), for
-- anupalabdhi as a separate prama; Prabhkara refuses it as separate and
-- folds it into perception; both impose yogynupalabdhi, and it is the
-- condition and not the count of pramas that this file formalises.  Nothing
-- in it is Jaina, and it says so: syd-nsti with its fourfold ground is a
-- different construction and the exchange between the two schools is exhibited
-- rather than settled, in the Haskell lane.
------------------------------------------------------------------------

import Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge
