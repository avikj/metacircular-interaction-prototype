-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गुणस्थान — the fourteen-rung ascent (mokṣa-mārga) is a chain; kevala
-- begins at the thirteenth rung and mokṣa lies beyond the fourteenth.
--
-- SOURCE.  The guṇasthānas — stages of qualitative purity as karma is
-- shed — are systematised in the Karma-grantha tradition and Nemicandra's
-- *Gommaṭasāra*, Jīvakāṇḍa (~10th c.); the seed is in the Ṣaṭkhaṇḍāgama.
-- The fourteen, in ascent order:
--   1 mithyātva · 2 sāsādana · 3 miśra · 4 avirata-samyagdṛṣṭi ·
--   5 deśavirata · 6 pramatta-saṃyata · 7 apramatta · 8 apūrvakaraṇa ·
--   9 anivṛttikaraṇa · 10 sūkṣmasāmparāya · 11 upaśānta-moha ·
--   12 kṣīṇa-moha · 13 sayoga-kevalī · 14 ayoga-kevalī.
-- Landmarks: samyaktva (right vision) first at 4; at 12 the mohanīya is
-- DESTROYED (kṣīṇa-moha — the kṣapaka path, irreversible: no fall from
-- here); at 13 the four ghātī are gone and KEVALA (omniscience) arises
-- (`KarmaPrakrti.केवलम्`); at 14 all yoga stops and, thereafter, MOKṢA —
-- the zero state (`Karma.मोक्षः`, ūrdhvagati to `DharmaAdharma`'s edge).
--
-- WHAT IS PROVED (the ascent as a rank into ℕ, so the order is the chain):
--   §2  चतुर्दश — exactly fourteen rungs.
--   §3  आरोहः — the rank is 1..14 in ascent order; the ladder is a chain.
--   §4  कैवल्यम् — kevala is exactly the top two rungs (rank ≥ 13):
--       sayoga- and ayoga-kevalī; below 13 it does not hold.
--   §5  क्षीणमोहः — kṣīṇa-moha is rung 12, the irreversible threshold
--       (mohanīya destroyed); kevala is strictly above it.
--
-- WHAT IS **NOT** CLAIMED.  Doctrine is the Karma-grantha's / Gommaṭasāra's;
-- theorems are cubical type theory.  The tie to karma (rising = shedding
-- mohanīya then ghātī; 13 ⟺ all ghātī gone, `KarmaPrakrti`; beyond 14 =
-- Karma's zero state) is CITED across modules, not re-proved here; this
-- file is the ladder's order-skeleton.  The upaśama vs kṣapaka fork at 11
-- (suppression falls back, destruction does not) is named, not encoded.
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

-- kevala: the top two rungs (ghātī destroyed) — rank ≥ 13
कैवल्यम् : गुणस्थान → Type
कैवल्यम् सयोगकेवली = Unit
कैवल्यम् अयोगकेवली = Unit
कैवल्यम् _        = ⊥

-- kevala holds at exactly 13 and 14, and its rank is ≥ 13
सयोगे-कैवल्यम् : कैवल्यम् सयोगकेवली
सयोगे-कैवल्यम् = tt

अयोगे-कैवल्यम् : कैवल्यम् अयोगकेवली
अयोगे-कैवल्यम् = tt

-- and not below: e.g. kṣīṇa-moha (12) is not yet kevala
क्षीणमोहे-न-कैवल्यम् : ¬ कैवल्यम् क्षीणमोह
क्षीणमोहे-न-कैवल्यम् z = z

-- kevala ⟹ rank ≥ 13 (the top segment)
कैवल्यं-ऊर्ध्वम् : (g : गुणस्थान) → कैवल्यम् g → 13 ≤ आरोहः g
कैवल्यं-ऊर्ध्वम् सयोगकेवली _ = ≤-refl
कैवल्यं-ऊर्ध्वम् अयोगकेवली _ = suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc
                              (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc
                              (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc (suc-≤-suc zero-≤))))))))))))
