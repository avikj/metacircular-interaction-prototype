-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सम-शेषः — कुट्टकस्य तुल्य-शेष-सम्बन्धः (आर्यभटस्य ग्रह-युति-प्रयोजनम्) ।
--
-- आर्यभटः कुट्टकं ग्रह-युत्यर्थम् (यदा द्वौ ग्रहौ भिन्न-आवर्तनौ सन्तौ समं शेषं
-- कदा प्राप्नुतः) आविष्कृतवान् — एतत् तुल्य-शेष-गणितम् (modular arithmetic) ।
-- अत्र ऋण-वर्जनं तुल्य-शेष-सम्बन्धम् : x ≈ y [m] ⟺ ∃ a b, x + a·m = y + b·m ।
-- सिध्यन्ते : तत्समता (reflexive), व्युत्क्रमः (symmetric), संक्रमः (transitive),
-- योग-अनुकूलता (+-cong), गुणन-अनुकूलता (·-cong), गुणित-लोपः (k·m ≈ 0) ।
-- एष कुट्टक-लाने चीन-शेष-प्रमेयस्य (CRT, आर्यभटस्य वास्तविक-प्रयोजनस्य) भूमिका ।
--
-- (The kuṭṭaka's same-remainder relation — Āryabhaṭa's actual purpose was
-- planetary conjunction: when do two bodies of different periods share a
-- remainder?  That is modular arithmetic.  Subtraction-free congruence
-- x ≈ y [m] ⟺ ∃ a b, x+a·m = y+b·m.  Proved an equivalence, compatible with +
-- and ·, with multiples vanishing — the groundwork for CRT (the kuṭṭaka's real
-- application), to follow.)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः ३२–३३ (कुट्टकः, ग्रह-युति) ।
------------------------------------------------------------------------

module Samasesha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties
  using (·-distribʳ ; ·-assoc ; ·-comm ; +-assoc ; +-comm ; +-zero)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)

------------------------------------------------------------------------
-- सम-शेष-सम्बन्धः : x ≈ y [ m ]  ⟺  ∃ a b, x + a·m ≡ y + b·m ।
------------------------------------------------------------------------

_≈_[_] : ℕ → ℕ → ℕ → Type
x ≈ y [ m ] = Σ ℕ (λ a → Σ ℕ (λ b → x + a · m ≡ y + b · m))

------------------------------------------------------------------------
-- तत्समता, व्युत्क्रमः, संक्रमः — तुल्यता-सम्बन्धः ।
------------------------------------------------------------------------

तत्समता : (m x : ℕ) → x ≈ x [ m ]
तत्समता m x = zero , zero , refl

व्युत्क्रमः : {m x y : ℕ} → x ≈ y [ m ] → y ≈ x [ m ]
व्युत्क्रमः (a , b , p) = b , a , sym p

संक्रमः : {m x y z : ℕ} → x ≈ y [ m ] → y ≈ z [ m ] → x ≈ z [ m ]
संक्रमः {m} {x} {y} {z} (a , b , p) (c , d , q) =
    a + c , b + d ,
    ( cong (x +_) (sym (·-distribʳ a c m))
    ∙ +-assoc x (a · m) (c · m)
    ∙ cong (_+ c · m) p
    ∙ sym (+-assoc y (b · m) (c · m))
    ∙ cong (y +_) (+-comm (b · m) (c · m))
    ∙ +-assoc y (c · m) (b · m)
    ∙ cong (_+ b · m) q
    ∙ sym (+-assoc z (d · m) (b · m))
    ∙ cong (z +_) (+-comm (d · m) (b · m))
    ∙ cong (z +_) (·-distribʳ b d m) )

------------------------------------------------------------------------
-- योग-अनुकूलता — समं योज्यं तुल्यतां रक्षति ।
------------------------------------------------------------------------

योग-अनुकूलता : {m x y : ℕ} → x ≈ y [ m ] → (z : ℕ) → (x + z) ≈ (y + z) [ m ]
योग-अनुकूलता {m} {x} {y} (a , b , p) z =
    a , b ,
    ( sym (+-assoc x z (a · m))
    ∙ cong (x +_) (+-comm z (a · m))
    ∙ +-assoc x (a · m) z
    ∙ cong (_+ z) p
    ∙ sym (+-assoc y (b · m) z)
    ∙ cong (y +_) (+-comm (b · m) z)
    ∙ +-assoc y z (b · m) )

------------------------------------------------------------------------
-- गुणन-अनुकूलता — समेन गुणनं तुल्यतां रक्षति ।
------------------------------------------------------------------------

गुणन-अनुकूलता : {m x y : ℕ} → x ≈ y [ m ] → (z : ℕ) → (x · z) ≈ (y · z) [ m ]
गुणन-अनुकूलता {m} {x} {y} (a , b , p) z =
    a · z , b · z ,
    ( cong (x · z +_) (पुनर्-क्रमः a) ∙ अपसारः x a
    ∙ cong (_· z) p
    ∙ sym (अपसारः y b) ∙ cong (y · z +_) (sym (पुनर्-क्रमः b)) )
  where
    -- (t·z)·m ≡ (t·m)·z : पुनर्-क्रमः
    पुनर्-क्रमः : (t : ℕ) → (t · z) · m ≡ (t · m) · z
    पुनर्-क्रमः t =
        sym (·-assoc t z m)
      ∙ cong (t ·_) (·-comm z m)
      ∙ ·-assoc t m z
    -- w·z + (t·m)·z ≡ (w + t·m)·z : अपसारः (distribute z out)
    अपसारः : (w t : ℕ) → w · z + (t · m) · z ≡ (w + t · m) · z
    अपसारः w t = ·-distribʳ w (t · m) z

------------------------------------------------------------------------
-- गुणित-लोपः — m-गुणितं शून्यतुल्यम् : k·m ≈ 0 [ m ] ।
------------------------------------------------------------------------

गुणित-लोपः : (m k : ℕ) → (k · m) ≈ 0 [ m ]
गुणित-लोपः m k = zero , k , +-zero (k · m)
