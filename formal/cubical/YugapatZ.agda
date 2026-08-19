{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- युगपत्-शेषः (पूर्णाङ्के) — चीन-शेष-प्रमेयस्य सत्ता-दिक्, ℤ-मध्ये सिद्धा ।
--
-- Yugapat.agda ℕ-मध्ये सत्ता-दिशं चिह्नित-गणित-अपेक्षाम् (r₂ − r₁) इति अवक्तव्यम्
-- अकरोत् ।  अत्र सा दिक् ℤ-मध्ये सिद्धा : यदि b·u + c·v = 1 (परस्पर-प्रथमत्वस्य
-- कुट्टक-साक्षी), तर्हि X = r₁·(c·v) + r₂·(b·u) युगपत् X ≈ r₁ [b], X ≈ r₂ [c] ।
-- गणितं वलय-साधकेन (solve ℤCommRing) ; भाजकत्वं pos 1-रहितं, bz-प्रतिस्थापनेन ।
--
-- (The existence direction of CRT that Yugapat.agda left avaktavya for wanting
-- r₂−r₁ (signed) is here PROVED over ℤ: given a Bézout witness b·u+c·v=1 (the
-- kuṭṭaka's coprimality certificate), X = r₁·(c·v)+r₂·(b·u) simultaneously
-- solves X ≈ r₁ [b] and X ≈ r₂ [c].  The algebra is the ℤ ring solver, kept
-- free of bare `pos 1` by substituting pos 1 ↦ b·u+c·v via the witness — the
-- move around the Mādhava-lane finding that the solver mishandles `pos 1`.)
--
-- स्रोतांसि : आर्यभटः, गणितपादः ३२–३३ (कुट्टकः, ग्रह-युति) ; ब्रह्मगुप्तः (भावना/
-- परस्पर-प्रथमत्वम्) ।  ℕ-प्रक्षेप-दिक् Yugapat.agda-मध्ये ।
------------------------------------------------------------------------

module YugapatZ where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Data.Int.Properties using (·Rid)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)
open import Cubical.Data.Sigma using (Σ ; _,_ ; _×_)

------------------------------------------------------------------------
-- सम-शेष-सम्बन्धः (ℤ) : x ≈ y [ m ]  ⟺  m ∣ (x − y) ।
------------------------------------------------------------------------

_≈_[_] : ℤ → ℤ → ℤ → Type
x ≈ y [ m ] = Σ ℤ (λ k → x - y ≡ k · m)

------------------------------------------------------------------------
-- वलय-साधकेन (pos 1-रहिते) : भाजकत्व-समिके, bz-प्रतिस्थापन-योग्ये ।
------------------------------------------------------------------------

समिका-b : (r₁ r₂ b u c v : ℤ)
        → (r₁ · (c · v) + r₂ · (b · u)) - r₁ · (b · u + c · v) ≡ (u · (r₂ - r₁)) · b
समिका-b = solve ℤCommRing

समिका-c : (r₁ r₂ b u c v : ℤ)
        → (r₁ · (c · v) + r₂ · (b · u)) - r₂ · (b · u + c · v) ≡ (v · (r₁ - r₂)) · c
समिका-c = solve ℤCommRing

------------------------------------------------------------------------
-- चीन-शेषः — मुख्य-सिद्धिः : कुट्टक-साक्षिणा युगपत्-समाधानम् ।
------------------------------------------------------------------------

चीन-शेषः : (b c u v r₁ r₂ : ℤ) → b · u + c · v ≡ pos 1
        → Σ ℤ (λ X → (X ≈ r₁ [ b ]) × (X ≈ r₂ [ c ]))
चीन-शेषः b c u v r₁ r₂ bz =
    X
  , ( u · (r₂ - r₁)
    , cong (λ w → X - w) (sym (cong (r₁ ·_) bz ∙ ·Rid r₁))
    ∙ समिका-b r₁ r₂ b u c v )
  , ( v · (r₁ - r₂)
    , cong (λ w → X - w) (sym (cong (r₂ ·_) bz ∙ ·Rid r₂))
    ∙ समिका-c r₁ r₂ b u c v )
  where
    X : ℤ
    X = r₁ · (c · v) + r₂ · (b · u)
