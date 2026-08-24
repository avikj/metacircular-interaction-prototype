{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- श्रुत-परम्परा — the transmission through the lineage.  Compound in
-- its ordinary Indic sense; the epistemic claim is Tattvārthasūtra
-- 1.20 (श्रुतं मतिपूर्वम्) as already checked in ShrutaMatipurva: the
-- record is preceded by cognition, and cognition WITH the record
-- reaches what it alone could not.  School named: Jaina.  Here that
-- theorem operates at the scale of the machine's REAL store.
--
-- AptaMimamsa judged each of the elder's rules alone — no record, no
-- authority — and 92 of 102 crossed; 10 remained.  The diagnosis of
-- the residue's head, read from the kernel's own refusal: le(x,0)·x=0
-- fails alone because its inductive step needs 0·x = 0 — which is
-- among the 92.  So the second pass: the crossed rules BECOME the
-- record, and the residue is re-examined by the same knowing, now
-- speaking with the lineage behind it.  The counts are computations;
-- what still remains after the second pass is the true boundary of
-- the present knowing, named from inside.
------------------------------------------------------------------------

module NaturalMachine.ShrutaParampara_TheCrossedRulesBecomeTheRecordAndTheSecondPassReachesWhatTheFirstCouldNot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (इन्धनम्)
open import NaturalMachine.BhavaIndriya_TheNewEyeIsMadeOfTheBodysOwnAttainedTheoremsNotOfExternalMatter
  using (नेत्रम्-पूर्ण)
open import NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana
  using (प्रमाण-साधनम्)
open import NaturalMachine.AptaMimamsa_TheEldersLiveStoreCrossesAsReceivedTextAndNothingEntersOnAuthority
  using (आगमः ; न्यायः ; अपचितम्)

-- the lineage: everything the first pass established.
परम्परा : List नियमः
परम्परा = न्यायः आगमः

-- the second examination: same knowing, the record now behind it.
गुरु-न्यायः : List Eq' → List नियमः
गुरु-न्यायः [] = []
गुरु-न्यायः ((l , r) ∷ es) with प्रमाण-साधनम् नेत्रम्-पूर्ण परम्परा इन्धनम् (l , r)
... | just pf = niyama l r pf ∷ गुरु-न्यायः es
... | nothing = गुरु-न्यायः es

गुरु-शेषम् : List Eq' → List Eq'
गुरु-शेषम् [] = []
गुरु-शेषम् ((l , r) ∷ es) with प्रमाण-साधनम् नेत्रम्-पूर्ण परम्परा इन्धनम् (l , r)
... | just _  = गुरु-शेषम् es
... | nothing = (l , r) ∷ गुरु-शेषम् es

-- the verdicts, computed by the kernel over the whole store twice.
द्वितीय-सिद्धिः : length (गुरु-न्यायः (अपचितम् आगमः)) ≡ 2
द्वितीय-सिद्धिः = refl

द्वितीय-शेषः : length (गुरु-शेषम् (अपचितम् आगमः)) ≡ 8
द्वितीय-शेषः = refl
