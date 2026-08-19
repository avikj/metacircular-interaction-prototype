{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- युगपत्-शेषः — कुट्टकस्य ग्रह-युति (चीन-शेष-प्रमेयस्य प्रक्षेप-दिक्) ।
--
-- आर्यभटस्य कुट्टक-प्रयोजनम् : द्वौ ग्रहौ भिन्न-आवर्तनौ (b, c) समं शेषं कदा
-- प्राप्नुतः ।  अत्र सम-शेष-सम्बन्धस्य (Samasesha) एका दिक् — प्रक्षेपः : यत्
-- (b·c)-मानेन तुल्यम्, तत् b-मानेन c-मानेन च तुल्यम् (युति-मानस्य सुसंगतिः) ।
-- ऋण-रहितं, स्वयंसिद्ध-रीत्या ।  उदाहरणम् : X ≈ 2 [3], X ≈ 3 [5] → X = 8 ।
--
-- (The kuṭṭaka's conjunction problem: two bodies of periods b, c sharing a
-- remainder.  This is the PROJECTION direction of CRT — a value congruent mod
-- b·c is congruent mod b and mod c (the CRT map is well-defined) — clean and
-- subtraction-free on Samasesha's congruence.  Plus a concrete conjunction.)
--
-- अवशिष्टा दिक् (existence): दत्तयोः शेषयोः r₁, r₂ योग्यं X-रचनं (r₂ − r₁-
-- व्यवकलनम्) चिह्नित-गणितम् (ℤ) अपेक्षते — ℕ-मध्ये ऋण-रहितं दुष्करम् ; ℤ-विकासाय
-- स्थापितम् ।  (The existence direction needs r₂−r₁, i.e. signed arithmetic;
-- hard subtraction-free in ℕ.  Now PROVED over ℤ in YugapatZ.agda — the
-- recorded obstruction is retired the way it was scoped: signed arithmetic.)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः ३२–३३ (कुट्टकः, ग्रह-युति) ।
------------------------------------------------------------------------

module Yugapat where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (·-assoc ; ·-comm)
open import Cubical.Data.Sigma using (_,_)
open import Samasesha using (_≈_[_])

------------------------------------------------------------------------
-- प्रक्षेप-c — (b·c)-तुल्यं ⟹ c-तुल्यम् : p·(b·c) = (p·b)·c ।
------------------------------------------------------------------------

प्रक्षेप-c : {b c X Y : ℕ} → X ≈ Y [ b · c ] → X ≈ Y [ c ]
प्रक्षेप-c {b} {c} {X} {Y} (p , q , eq) =
    p · b , q · b ,
    ( cong (X +_) (sym (·-assoc p b c))
    ∙ eq
    ∙ cong (Y +_) (·-assoc q b c) )

------------------------------------------------------------------------
-- प्रक्षेप-b — (b·c)-तुल्यं ⟹ b-तुल्यम् : p·(b·c) = (p·c)·b ।
------------------------------------------------------------------------

प्रक्षेप-b : {b c X Y : ℕ} → X ≈ Y [ b · c ] → X ≈ Y [ b ]
प्रक्षेप-b {b} {c} {X} {Y} (p , q , eq) =
    p · c , q · c ,
    ( cong (X +_) (sym (पुनर्-क्रमः p))
    ∙ eq
    ∙ cong (Y +_) (पुनर्-क्रमः q) )
  where
    पुनर्-क्रमः : (t : ℕ) → t · (b · c) ≡ (t · c) · b
    पुनर्-क्रमः t = cong (t ·_) (·-comm b c) ∙ ·-assoc t c b

------------------------------------------------------------------------
-- उदाहरणम् — ग्रह-युतिः : X = 8 सन्तोषयति X ≈ 2 [3] च X ≈ 3 [5] च ।
--   8 = 2 + 2·3  (शेषः 2, आवर्तनम् 3) ;  8 = 3 + 1·5  (शेषः 3, आवर्तनम् 5) ।
------------------------------------------------------------------------

युति-३ : 8 ≈ 2 [ 3 ]
युति-३ = 0 , 2 , refl        -- 8 + 0·3 ≡ 2 + 2·3

युति-५ : 8 ≈ 3 [ 5 ]
युति-५ = 0 , 1 , refl        -- 8 + 0·5 ≡ 3 + 1·5

-- प्रक्षेप-दृष्टान्तः : यत् 15 (=3·5)-तुल्यम्, तत् 3-तुल्यं 5-तुल्यं च ।
प्रक्षेप-दृष्टान्तः : 8 ≈ 23 [ 5 ]
प्रक्षेप-दृष्टान्तः = प्रक्षेप-c {3} {5} (1 , 0 , refl)   -- 8 ≈ 23 [15] → [5]  (8+1·15 ≡ 23)
