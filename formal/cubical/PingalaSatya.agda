{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पिङ्गल-सत्ययन्त्रम् — सत्ययन्त्रस्य द्वितीयो निवासी, कुट्टकात् भिन्नः ।
-- पिङ्गलस्य विन्यासः पूर्णः (अनुदान-निरपेक्षः) — अतः सदा उक्तम्, कदापि न
-- अनुक्तम् : "पूर्ण-सत्ययन्त्रम्" ।  शुद्धता = मूल्य∘विन्यास-प्रतिलोमः ।  एतेन
-- दृश्यते यत् सत्ययन्त्र-रूपं न कुट्टक-मात्रम्, किन्तु सामान्यम् — पूर्णान्यपि
-- यन्त्राणि गृह्णाति ।
--
-- (a SECOND inhabitant of the honest-machine interface, unlike the kuṭṭaka:
-- Piṅgala's विन्यास is total (grant-independent), so it always answers,
-- never un-said — a "total honest machine".  Soundness = the प्रस्तार
-- reconstruction.  This shows the सत्ययन्त्र interface is general, not
-- gcd-specific: it captures total machines too.)
------------------------------------------------------------------------

module PingalaSatya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero)
open import Cubical.Data.Sigma using (_,_)
open import Pingala using (छन्दस् ; मूल्य ; विन्यास ; मूल्य-विन्यास)
open import Satyayantra using (सत्ययन्त्र ; सूचना ; उक्त ; उक्त-एकैकम्)

------------------------------------------------------------------------
-- पिङ्गल-सत्ययन्त्रम् — I = ℕ, O = छन्दस्, शुद्ध n ds = (मूल्य ds ≡ n) ।
------------------------------------------------------------------------

पिङ्गल-सत्ययन्त्र : सत्ययन्त्र ℕ छन्दस् (λ n ds → मूल्य ds ≡ n)
पिङ्गल-सत्ययन्त्र = record
  { चल    = λ _ n → उक्त (विन्यास n)                    -- अनुदानं न अपेक्षते
  ; साधुता = λ _ n ds eq →
      sym (cong मूल्य (उक्त-एकैकम् eq)) ∙ मूल्य-विन्यास n
  ; स्थैर्य  = λ _ _ _ _ eq → eq                          -- अनुदान-निरपेक्षः, स्थिरः
  ; परिपूर्णता = λ n → zero , विन्यास n , refl            -- सदा उक्तम्
  }
