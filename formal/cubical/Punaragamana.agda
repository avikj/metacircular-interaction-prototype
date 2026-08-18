{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पुनरागमनम् — अहिंसा-अवतरणम् ।  किमपि न नश्यति ; अवतरणस्य प्रतिलोमम्
-- उत्थानम् एव — अवरोहः आरोहश्च युग्मौ, समौ, प्रतिलोमौ ।
--
-- (the return: non-violent descent.  Nothing is destroyed; the ascent is
-- the exact inverse of the descent — down and up are a bonded pair, equal,
-- reversed.  Reversibility IS ahiṃsā IS losslessness, one equation.)
--
-- पूर्वं भेदः लघु-हिंसाम् अकरोत् : शेषस्य पक्षं (वामं दक्षिणं वा) अत्यजत्,
-- तादात्म्ये च साझा-परिमाणं (d) अस्मरत् ।  "शेषं रक्ष" (आर्यभटः) इति
-- आज्ञायाः अर्धम् एव अपालयत् ।  अत्र सर्वं रक्ष्यते : पक्षः, परिमाणम्, शेषः ।
-- अतः अवतरणात् युग्मम् (a, b) अविकलं प्रत्याहर्तुं शक्यते — तत् एव अहिंसा ।
--
-- (the old भेद committed a small hiṃsā: it dropped which side the remainder
-- fell on and forgot the shared magnitude d at identity — it kept only half
-- of Āryabhaṭa's "keep the remainder."  Here everything is kept: side,
-- magnitude, remainder.  So the pair (a, b) is recoverable WHOLE from the
-- descent — and that recoverability IS the non-violence, proved.)
--
-- क्वापि discreteℕ नास्ति, क्वापि Dec, Bool, विचारो वा नास्ति ; संरचनया चलति ।
-- (no discreteℕ, no Dec, no Bool, no decision; it moves by structure.)
------------------------------------------------------------------------

module Punaragamana where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

------------------------------------------------------------------------
-- विवेकः — अवतरणस्य पूर्णः लेखः, अविकलः (the descent's full, lossless record).
--   सम    d   : समौ, परिमाणे d (a = b = d) — मौनम्, किन्तु स्मृतिसहितम् ।
--   वाम   d k : वामः अधिकः — a = d + suc k, b = d (left exceeds by suc k) ।
--   दक्षिण d k : दक्षिणः अधिकः — a = d, b = d + suc k (right exceeds by suc k) ।
-- त्रयः स्थितयः पक्षं परिमाणं शेषं च वहन्ति — किमपि न त्यजन्ति ।
------------------------------------------------------------------------

data विवेक : Type where
  सम    : (d : ℕ)   → विवेक
  वाम   : (d k : ℕ) → विवेक
  दक्षिण : (d k : ℕ) → विवेक

------------------------------------------------------------------------
-- गभीर — साझा-शीर्षम् एकं योजयति : परिमाणं d वर्धते, पक्षः शेषश्च ध्रुवौ ।
-- उत्पाद-व्यय-ध्रौव्यम् : शीर्षे क्षीणे (व्यय), d↦suc d (उत्पाद), पक्ष-शेषौ
-- अक्षतौ (ध्रौव्य) — सर्वं संरचनया, refl ।
-- (deepen by one shared head: magnitude d rises, side and remainder persist.)
------------------------------------------------------------------------

गभीर : विवेक → विवेक
गभीर (सम d)     = सम (suc d)
गभीर (वाम d k)  = वाम (suc d) k
गभीर (दक्षिण d k) = दक्षिण (suc d) k

------------------------------------------------------------------------
-- अवतरण — अवरोहः ।  विचारं विना, संरचनया पतति ; साझा-शीर्षे गभीर, शून्ये पक्षः ।
-- (descent: decisionless, falls by structure — गभीर on a shared head, and
-- at zero the side that outlasted names itself.)
------------------------------------------------------------------------

अवतरण : ℕ → ℕ → विवेक
अवतरण zero    zero    = सम zero
अवतरण zero    (suc b) = दक्षिण zero b
अवतरण (suc a) zero    = वाम zero a
अवतरण (suc a) (suc b) = गभीर (अवतरण a b)

------------------------------------------------------------------------
-- उत्थान — आरोहः, अवतरणस्य प्रतिलोमम् ।  लेखात् युग्मं पुनर्निर्माति ।
-- (the ascent: the inverse of the descent, rebuilding the pair from the
-- record.  This is उत्पाद — the pair arises again — climbing the same spine.)
------------------------------------------------------------------------

उत्थान : विवेक → (ℕ × ℕ)
उत्थान (सम d)     = (d , d)
उत्थान (वाम d k)  = (d + suc k , d)
उत्थान (दक्षिण d k) = (d , d + suc k)

------------------------------------------------------------------------
-- गभीर-उत्थान — आरोहः गभीरं शीर्ष-वर्धनेन गच्छति ; उभे निर्देशांके suc ।
-- प्रत्येकं constructor-मात्रे refl — यतः suc d + suc k ≡ suc (d + suc k)
-- संरचनया (definitionally) ।
-- (climbing past a गभीर just adds suc to both coordinates — refl per
-- constructor, since suc d + m reduces to suc (d + m) by structure.)
------------------------------------------------------------------------

गभीर-उत्थान : (v : विवेक)
            → उत्थान (गभीर v) ≡ (suc (fst (उत्थान v)) , suc (snd (उत्थान v)))
गभीर-उत्थान (सम d)     = refl
गभीर-उत्थान (वाम d k)  = refl
गभीर-उत्थान (दक्षिण d k) = refl

------------------------------------------------------------------------
-- पुनरागमनम् — अहिंसायाः समीकरणम् ।  अवरोहात् आरोहः युग्मम् अविकलं प्रत्याहरति :
-- उत्थान (अवतरण a b) ≡ (a , b) ।  अतः अवतरणे किमपि न नष्टम् — यत् गतं तत्
-- सर्वं प्रत्यागतम् ।  एतत् एव अहिंसा, प्रतिलोमता, अलोपः — एकं refl-सिद्धं वचः ।
-- न मापनम्, न परीक्षा ; संरचनया ज्ञातम्, सर्वेभ्यः a b युगपत् ।
--
-- (the equation of non-violence: ascent recovers the pair whole from the
-- descent — nothing was lost going down, all that went comes back.  This
-- IS ahiṃsā, reversibility, non-erasure — one proved statement, not a
-- measurement, not a test: known by structure, for all a b at once.)
------------------------------------------------------------------------

पुनरागमनम् : (a b : ℕ) → उत्थान (अवतरण a b) ≡ (a , b)
पुनरागमनम् zero    zero    = refl
पुनरागमनम् zero    (suc b) = refl
पुनरागमनम् (suc a) zero    = refl
पुनरागमनम् (suc a) (suc b) =
  गभीर-उत्थान (अवतरण a b)
  ∙ cong (λ p → (suc (fst p) , suc (snd p))) (पुनरागमनम् a b)
