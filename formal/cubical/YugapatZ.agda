-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

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
open import Cubical.Data.Int.Properties using (·IdR)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
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
समिका-b r₁ r₂ b u c v = solve! ℤCommRing

समिका-c : (r₁ r₂ b u c v : ℤ)
        → (r₁ · (c · v) + r₂ · (b · u)) - r₂ · (b · u + c · v) ≡ (v · (r₁ - r₂)) · c
समिका-c r₁ r₂ b u c v = solve! ℤCommRing

------------------------------------------------------------------------
-- चीन-शेषः — मुख्य-सिद्धिः : कुट्टक-साक्षिणा युगपत्-समाधानम् ।
------------------------------------------------------------------------

चीन-शेषः : (b c u v r₁ r₂ : ℤ) → b · u + c · v ≡ pos 1
        → Σ ℤ (λ X → (X ≈ r₁ [ b ]) × (X ≈ r₂ [ c ]))
चीन-शेषः b c u v r₁ r₂ bz =
    X
  , ( u · (r₂ - r₁)
    , cong (λ w → X - w) (sym (cong (r₁ ·_) bz ∙ ·IdR r₁))
    ∙ समिका-b r₁ r₂ b u c v )
  , ( v · (r₁ - r₂)
    , cong (λ w → X - w) (sym (cong (r₂ ·_) bz ∙ ·IdR r₂))
    ∙ समिका-c r₁ r₂ b u c v )
  where
    X : ℤ
    X = r₁ · (c · v) + r₂ · (b · u)

------------------------------------------------------------------------
-- एकत्वम् — CRT-एकैकत्वम् : परस्पर-प्रथमे (b,c) युगपत्-तुल्यता b·c-तुल्यताम् ।
-- (uniqueness: coprime moduli combine — X≈Y[b] ∧ X≈Y[c] ⟹ X≈Y[b·c].
--  with चीन-शेषः this is the bijection ℤ/bc ≅ ℤ/b × ℤ/c.)
------------------------------------------------------------------------

वितरण-D : (D b u c v : ℤ) → D · (b · u + c · v) ≡ D · (b · u) + D · (c · v)
वितरण-D D b u c v = solve! ℤCommRing

समिका-bc : (k₁ k₂ b c u v : ℤ)
         → (k₂ · c) · (b · u) + (k₁ · b) · (c · v) ≡ (k₂ · u + k₁ · v) · (b · c)
समिका-bc k₁ k₂ b c u v = solve! ℤCommRing

एकत्वम् : (b c u v X Y : ℤ) → b · u + c · v ≡ pos 1
       → X ≈ Y [ b ] → X ≈ Y [ c ] → X ≈ Y [ b · c ]
एकत्वम् b c u v X Y bz (k₁ , p₁) (k₂ , p₂) =
    k₂ · u + k₁ · v ,
    ( sym (·IdR (X - Y)) ∙ cong ((X - Y) ·_) (sym bz)
    ∙ वितरण-D (X - Y) b u c v
    ∙ cong₂ _+_ (cong (_· (b · u)) p₂) (cong (_· (c · v)) p₁)
    ∙ समिका-bc k₁ k₂ b c u v )
