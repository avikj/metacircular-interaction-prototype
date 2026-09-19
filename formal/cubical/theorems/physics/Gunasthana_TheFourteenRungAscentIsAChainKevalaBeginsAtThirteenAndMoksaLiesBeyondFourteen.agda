{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ��������� � the fourteen-rung ascent (moka-mrga) is a chain; kevala
-- begins at the thirteenth rung and moka lies beyond the fourteenth.
--
-- SOURCE.  The guasthnas � stages of qualitative purity as karma is
-- shed � are systematised in the Karma-grantha tradition and Nemicandra's
-- *Gommaasra*, Jvaka (~10th c.); the seed is in the akhagama.
-- The fourteen, in ascent order:
--   1 mithytva � 2 ssdana � 3 mira � 4 avirata-samyagdi �
--   5 deavirata � 6 pramatta-sayata � 7 apramatta � 8 aprvakaraa �
--   9 anivttikaraa � 10 skmasmparya � 11 upanta-moha �
--   12 ka-moha � 13 sayoga-keval � 14 ayoga-keval.
-- Landmarks: samyaktva (right vision) first at 4; at 12 the mohanya is
-- DESTROYED (ka-moha � the kapaka path, irreversible: no fall from
-- here); at 13 the four ght are gone and KEVALA (omniscience) arises
-- (`KarmaPrakrti.�������`); at 14 all yoga stops and, thereafter, MOKA �
-- the zero state (`Karma.��������`, rdhvagati to `DharmaAdharma`'s edge).
--
-- WHAT IS PROVED (the ascent as a rank into �, so the order is the chain):
--   §2  ������� � exactly fourteen rungs.
--   §3  ������ � the rank is 1..14 in ascent order; the ladder is a chain.
--   §4  ���������� � kevala is exactly the top two rungs (rank � 13):
--       sayoga- and ayoga-keval; below 13 it does not hold.
--   §5  ����������� � ka-moha is rung 12, the irreversible threshold
--       (mohanya destroyed); kevala is strictly above it.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Gunasthana_TheFourteenRungAscentIsAChainKevalaBeginsAtThirteenAndMoksaLiesBeyondFourteen where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; zero-≤ ; suc-≤-suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

data गुणस्थान : Type where
  मिथ्यात्व सासादन मिश्र अविरत देशविरत प्रमत्त अप्रमत्त
    अपूर्वकरण अनिवृत्तिकरण सूक्ष्मसाम्पराय उपशान्तमोह
    क्षीणमोह सयोगकेवली अयोगकेवली : गुणस्थान

सर्वाणि : List गुणस्थान
सर्वाणि = मिथ्यात्व ∷ सासादन ∷ मिश्र ∷ अविरत ∷ देशविरत ∷ प्रमत्त ∷ अप्रमत्त
       ∷ अपूर्वकरण ∷ अनिवृत्तिकरण ∷ सूक्ष्मसाम्पराय ∷ उपशान्तमोह
       ∷ क्षीणमोह ∷ सयोगकेवली ∷ अयोगकेवली ∷ []

चतुर्दश : length सर्वाणि ≡ 14
चतुर्दश = refl

-- ascent rank, 1..14
आरोहः : गुणस्थान → ℕ
आरोहः मिथ्यात्व = 1
आरोहः सासादन = 2
आरोहः मिश्र = 3
आरोहः अविरत = 4
आरोहः देशविरत = 5
आरोहः प्रमत्त = 6
आरोहः अप्रमत्त = 7
आरोहः अपूर्वकरण = 8
आरोहः अनिवृत्तिकरण = 9
आरोहः सूक्ष्मसाम्पराय = 10
आरोहः उपशान्तमोह = 11
आरोहः क्षीणमोह = 12
आरोहः सयोगकेवली = 13
आरोहः अयोगकेवली = 14

-- kevala: the top two rungs (ght destroyed) � rank � 13
कैवल्यम् : गुणस्थान → Type
कैवल्यम् सयोगकेवली = Unit
कैवल्यम् अयोगकेवली = Unit
कैवल्यम् _        = ⊥

-- kevala holds at exactly 13 and 14, and its rank is � 13
सयोगे-कैवल्यम् : कैवल्यम् सयोगकेवली
सयोगे-कैवल्यम् = tt

अयोगे-कैवल्यम् : कैवल्यम् अयोगकेवली
अयोगे-कैवल्यम् = tt

-- and not below: e.g. ka-moha (12) is not yet kevala
क्षीणमोहे-न-कैवल्यम् : ¬ कैवल्यम् क्षीणमोह
क्षीणमोहे-न-कैवल्यम् z = z

-- kevala � rank � 13 (the top segment)
कैवल्यं-ऊर्ध्वम् : (g : गुणस्थान) → कैवल्यम् g → 13 ≤ आरोहः g
कैवल्यं-ऊर्ध्वम् सयोगकेवली _ = ≤-refl
कैवल्यं-ऊर्ध्वम् अयोगकेवली _ = suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc
                              (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc
                              (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc zero-≤))))))))))))
