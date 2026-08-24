-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कुट्टक-चीन-शेषः — आर्यभटस्य पूर्ण-रीतिः : कुट्टकात् ग्रह-युतिः ।
--
-- आर्यभटस्य कुट्टकः (Bija) परस्पर-प्रथमयोः a, b रेखिक-साक्षिं जनयति
-- (a·x = b·y ± 1) ।  स एव साक्षी चीन-शेषस्य (YugapatZ.चीन-शेषः) आवश्यको
-- वल्ल्याः-संयोगः ।  अत्र सेतुः : ℕ-कुट्टक-साक्षिं ℤ-वल्ल्याः-साक्षिम्
-- (pos a · U + pos b · V = 1) परिणमयति ; ततः युगपत्-समाधानम् ।  एवं
-- कुट्टक-चीन-शेषौ एक-प्रवाहेण मिलतः — आर्यभटस्य ग्रह-युति-गणनं यथावत् ।
--
-- (Āryabhaṭa's full method: from the pulverizer to the conjunction.  The
-- kuṭṭaka (Bija) yields a linear witness a·x = b·y ± 1 for coprime a, b — which
-- is exactly the Bézout combination चीन-शेषः needs.  This bridge lifts the
-- ℕ kuṭṭaka witness to the ℤ Bézout (pos a · U + pos b · V = 1) and feeds the
-- CRT solver, so the pulverizer and the conjunction join in one pipeline —
-- Āryabhaṭa's astronomical computation as it actually ran.)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः ३२–३३ (कुट्टकः, ग्रह-युति) ।
------------------------------------------------------------------------

module KuttakaCRT where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ) renaming (_·_ to _·ℕ_ ; _+_ to _+ℕ_)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_ ; -_)
open import Cubical.Data.Int.Properties using (pos+ ; pos·pos ; -DistR· ; plusMinus ; +Comm)
open import Cubical.Data.Sigma using (Σ ; _,_ ; _×_)
open import Bija using (बीजसिद्धि ; वामसिद्धि ; दक्षिणसिद्धि)
open import YugapatZ using (_≈_[_] ; चीन-शेषः)

------------------------------------------------------------------------
-- अन्त्यम् — (B + 1) − B ≡ 1 (सामान्य ℤ-सहायः) ।
------------------------------------------------------------------------

अन्त्यम् : (B : ℤ) → (B + pos 1) - B ≡ pos 1
अन्त्यम् B = cong (_- B) (+Comm B (pos 1)) ∙ plusMinus B (pos 1)

------------------------------------------------------------------------
-- सेतुः — ℕ-कुट्टक-साक्षिं ℤ-वल्ल्याः-साक्षिम् परिणमयति ।
------------------------------------------------------------------------

सेतुः : {a b : ℕ} → बीजसिद्धि a b 1
      → Σ ℤ (λ U → Σ ℤ (λ V → pos a · U + pos b · V ≡ pos 1))
सेतुः {a} {b} (वामसिद्धि x y pf) =
    pos x , - (pos y) ,
    ( cong (pos a · pos x +_) (sym (-DistR· (pos b) (pos y)))
    ∙ cong (_- (pos b · pos y)) पद
    ∙ अन्त्यम् (pos b · pos y) )
  where
    पद : pos a · pos x ≡ pos b · pos y + pos 1
    पद = sym (pos·pos a x) ∙ cong pos pf
       ∙ pos+ (b ·ℕ y) 1 ∙ cong (_+ pos 1) (pos·pos b y)
सेतुः {a} {b} (दक्षिणसिद्धि x y pf) =
    - (pos x) , pos y ,
    ( cong (_+ pos b · pos y) (sym (-DistR· (pos a) (pos x)))
    ∙ cong (- (pos a · pos x) +_) पद'
    ∙ +Comm (- (pos a · pos x)) (pos a · pos x + pos 1)
    ∙ अन्त्यम् (pos a · pos x) )
  where
    पद' : pos b · pos y ≡ pos a · pos x + pos 1
    पद' = sym (pos·pos b y) ∙ cong pos pf
        ∙ pos+ (a ·ℕ x) 1 ∙ cong (_+ pos 1) (pos·pos a x)

------------------------------------------------------------------------
-- कुट्टक-चीन — मुख्य-सिद्धिः : कुट्टक-साक्षिणा युगपत्-समाधानम् ।
------------------------------------------------------------------------

कुट्टक-चीन : {a b : ℕ} → बीजसिद्धि a b 1 → (r₁ r₂ : ℤ)
          → Σ ℤ (λ X → (X ≈ r₁ [ pos a ]) × (X ≈ r₂ [ pos b ]))
कुट्टक-चीन {a} {b} बी r₁ r₂ =
    let (U , V , bz) = सेतुः बी
    in चीन-शेषः (pos a) (pos b) U V r₁ r₂ bz
