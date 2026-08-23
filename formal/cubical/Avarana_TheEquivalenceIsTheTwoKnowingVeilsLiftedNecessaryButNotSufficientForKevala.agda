{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- आवरण — the equivalence is exactly the two KNOWING-veils lifted, and
-- that is NECESSARY but NOT SUFFICIENT for kevala.
--
-- WHAT THIS REPAIRS.  Jiva_…agda mapped TWO fibre-defects of a cognition
-- f : धारणा → विषयः to karma and then wrote "निर्जरा/मोक्षः = shed both =
-- isEquiv = kevalajñāna."  KarmaPrakrti_…agda (Tattvārthasūtra 8.5, 10.1)
-- shows kevala is the destruction of the FOUR ghātī, not two — so that line
-- typed a resemblance as an arrow it had not earned.  A correction removes
-- exactly what the counterexample reached: isEquiv is the two ĀVARAṆA
-- (veils on cognition) lifted, which is two of the four ghātī.
--
-- THE EARNED MAP.  The two āvaraṇa karmas are veils on KNOWING and are
-- fibre-properties of the cognition map:
--   ज्ञानावरण  (knowledge-obscuring)  destroyed  =  अन्यूनता f   (surjective:
--        no object is un-known — no empty fibre, no रिक्त)
--   दर्शनावरण  (perception-obscuring)  destroyed  =  अहानि f     (injective:
--        no two are seen as one — every fibre a prop, no विकलादेश, the
--        durnaya/saṅkṣepa destroyed)
-- and `isEquiv f` is exactly the conjunction (§2, both directions, the
-- backward one is literally Kevalajnana.केवलम्).  So isEquiv = samyag-jñāna
-- + samyag-darśana OF THE COGNITION: the map is a perfect mirror.
--
-- WHY NOT SUFFICIENT.  kevala needs also मोहनीय (deluding) and अन्तराय
-- (obstructive) gone — the karmas of WILL and CONDUCT (samyak-cāritra),
-- which are NOT properties of the cognition map.  §4 exhibits a state whose
-- two āvaraṇa are lifted (from isEquiv) while मोहनीय is not, and proves it
-- is not kevala.  §3 proves the converse: kevala ⟹ isEquiv (necessary).
-- Avik's own frame: "Right seeing, right knowing, right conduct and
-- nonviolence are one problem" — isEquiv gives the first two; the third is
-- beyond the map.
--
-- WHAT IS AND IS NOT CLAIMED OF SOURCES.  The eight prakṛtis, the ghātī
-- split, and the kevala/mokṣa thresholds are Umāsvāti's (Tattvārthasūtra
-- 8.5, 10.1–10.2), carried through KarmaPrakrti_…agda; isEquiv/fiber are
-- Voevodsky's univalence.  NO claim that Umāsvāti wrote type theory; the
-- earned claim is only that the two ĀVARAṆA — veils on cognition — are the
-- surjectivity and injectivity of the cognition map, and that the remaining
-- two ghātī are not fibre-properties of it, so isEquiv is strictly between
-- "unveiled cognition" and kevala.
--
-- CHECKED: Agda 2.8.0 / cubical-0.9, --cubical --safe, no postulates, no
-- holes, no native_decide.  Verified 2026-08-23.
------------------------------------------------------------------------

module Avarana_TheEquivalenceIsTheTwoKnowingVeilsLiftedNecessaryButNotSufficientForKevala where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof ; fiber)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

import Kevalajnana_ThePureMindLosesNothingAndMissesNothingWhichIsTheEquivalence as K
import KarmaPrakrti_TheEightBindingsSplitFourObscuringFourNonAndDestroyingTheObscuringIsOmniscience as KP

private
  variable
    A B : Type

------------------------------------------------------------------------
-- १ · the two ĀVARAṆA, as fibre-properties of a cognition.
------------------------------------------------------------------------

-- knowledge-veil destroyed: nothing un-known (surjective)
ज्ञानावरण-क्षीण : (f : A → B) → Type
ज्ञानावरण-क्षीण f = K.अन्यूनता f

-- perception-veil destroyed: nothing seen as another (injective / prop fibres)
दर्शनावरण-क्षीण : (f : A → B) → Type
दर्शनावरण-क्षीण f = K.अहानि f

------------------------------------------------------------------------
-- २ · isEquiv IS exactly the two veils lifted — both directions.
------------------------------------------------------------------------

-- forward: an equivalence has both veils lifted
समानता→द्वि-आवरण-क्षीण :
  {f : A → B} → isEquiv f → ज्ञानावरण-क्षीण f × दर्शनावरण-क्षीण f
समानता→द्वि-आवरण-क्षीण {f = f} e =
  (λ b → fst (h b)) , (λ b → isContr→isProp (h b))
  where h : (b : _) → isContr (fiber f b)
        h = K.समानता→सर्वसकलम् e

-- backward: both veils lifted give an equivalence (this is Kevalajnana.केवलम्)
द्वि-आवरण-क्षीण→समानता :
  {f : A → B} → ज्ञानावरण-क्षीण f → दर्शनावरण-क्षीण f → isEquiv f
द्वि-आवरण-क्षीण→समानता nl ng = K.केवलम् ng nl

------------------------------------------------------------------------
-- ३ · a cognition induces a karma-state, and kevala on it ⟹ isEquiv
--     (isEquiv is NECESSARY for kevala).
--
-- The two āvaraṇा are read off f; the other two ghātī (मोहनीय, अन्तराय)
-- and the aghātī are carried as independent inputs — because they are NOT
-- properties of the cognition map.
------------------------------------------------------------------------

अवस्थाOf : (f : A → B) (moha antaraya rest : Type) → KP.प्रकृति → Type
अवस्थाOf f moha antaraya rest KP.ज्ञानावरण = ज्ञानावरण-क्षीण f
अवस्थाOf f moha antaraya rest KP.दर्शनावरण = दर्शनावरण-क्षीण f
अवस्थाOf f moha antaraya rest KP.मोहनीय   = moha
अवस्थाOf f moha antaraya rest KP.अन्तराय  = antaraya
अवस्थाOf f moha antaraya rest _           = rest

केवलम्→समानता :
  {f : A → B} {moha antaraya rest : Type}
  → KP.केवलम् (अवस्थाOf f moha antaraya rest) → isEquiv f
केवलम्→समानता {f = f} k =
  द्वि-आवरण-क्षीण→समानता
    (k KP.ज्ञानावरण tt)     -- घातिन् ज्ञानावरण = Unit, so क्षीण ज्ञानावरण = अन्यूनता f
    (k KP.दर्शनावरण tt)     -- likewise दर्शनावरण
------------------------------------------------------------------------
-- ४ · but isEquiv does NOT give kevala: with मोहनीय unremoved the state
--     is not kevala, though both āvaraṇा are lifted (isEquiv NOT SUFFICIENT).
------------------------------------------------------------------------

समानता-न-केवलम् :
  {f : A → B} {antaraya rest : Type}
  → isEquiv f
  → ¬ KP.केवलम् (अवस्थाOf f ⊥ antaraya rest)
समानता-न-केवलम् _ k = k KP.मोहनीय tt   -- kevala ⟹ क्षीण मोहनीय = ⊥, absurd

-- and the two āvaraṇा really are lifted in that same state — so the
-- failure is exactly at conduct (मोहनीय), not at knowing:
समानता→आवरणे-क्षीणे :
  {f : A → B} {antaraya rest : Type}
  → isEquiv f
  → ज्ञानावरण-क्षीण f × दर्शनावरण-क्षीण f
समानता→आवरणे-क्षीणे = समानता→द्वि-आवरण-क्षीण
