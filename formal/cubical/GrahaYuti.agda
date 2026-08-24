-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ग्रह-युतिः — आर्यभटस्य कुट्टक-चीन-प्रवाहस्य मूर्त-दृष्टान्तः ।
--
-- आवर्तनौ ३, ५ (परस्पर-प्रथमौ) ।  कुट्टक-साक्षी : ३·२ = ५·१ + १ (वल्ली) ।
-- अनेन साक्षिणा कुट्टक-चीन X ≈ २ [३], X ≈ ३ [५] इति युगपत्-समाधानं रचयति ,
-- यत् X = ८ (३·२+२ = ८, ५·१+३ = ८) ।  सर्वं पुलवेरकात् (कुट्टकात्) आरभ्य ,
-- refl-सिद्धम् — आर्यभटस्य ग्रह-युति-गणनं यथावत् चलति ।
--
-- (A concrete run of the kuṭṭaka→CRT pipeline: periods 3, 5, the pulverizer
-- witness 3·2 = 5·1+1, and कुट्टक-चीन constructs the simultaneous solution of
-- X ≈ 2 [3], X ≈ 3 [5] — which computes to 8, straight from the pulverizer,
-- checked by refl.  Āryabhaṭa's conjunction reckoning, running end to end.)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः ३२–३३ (कुट्टकः, ग्रह-युति) ।
------------------------------------------------------------------------

module GrahaYuti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Sigma using (fst)
open import Bija using (बीजसिद्धि ; वामसिद्धि)
open import KuttakaCRT using (कुट्टक-चीन)

------------------------------------------------------------------------
-- कुट्टक-साक्षी — ३·२ ≡ ५·१ + १ (वल्ल्याः फलम्, refl) ।
------------------------------------------------------------------------

साक्षी : बीजसिद्धि 3 5 1
साक्षी = वामसिद्धि 2 1 refl

------------------------------------------------------------------------
-- समाधानम् — कुट्टक-चीनेन रचितं युगपत्-समाधानम् (शेषौ २, ३) ।
------------------------------------------------------------------------

समाधानम् : ℤ
समाधानम् = fst (कुट्टक-चीन साक्षी (pos 2) (pos 3))

------------------------------------------------------------------------
-- मूल्यम् — समाधानम् = ८ , पुलवेरकात् आरभ्य refl-सिद्धम् ।
------------------------------------------------------------------------

मूल्यम् : समाधानम् ≡ pos 8
मूल्यम् = refl
