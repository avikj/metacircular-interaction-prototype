-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मेरु-सममितिः — हलायुधस्य निरीक्षणम् : मेरुः सम-पार्श्वः, C(n,k) = C(n,n−k) ।
--
-- हलायुधः मेरु-प्रस्तारं सम-पार्श्वम् (symmetric) इति दर्शयति ।  छन्दो-अर्थः :
-- n-अक्षरं छन्दः यत्र k गुरवः ↔ तस्य विपर्ययः यत्र k लघवः (गुरु-लघु-दुलम्) ;
-- अतः C(n,k) = C(n,n−k) ।  अत्र ऋण-वर्जनार्थं n = j+k इति लिख्य : C(j+k, k) =
-- C(j+k, j) — पार्श्वयोग-आवृत्त्या द्वि-आगमनेन (न भाज्य-क्रमेण) ।
--
-- (Halāyudha's observation that the meru-prastāra is symmetric: C(n,k) =
-- C(n,n−k).  Prosodic meaning: an n-syllable metre with k gurus corresponds to
-- its guru↔laghu reversal with k laghus — the complement — so the counts are
-- equal.  Stated subtraction-free as C(j+k, k) = C(j+k, j), by double induction
-- on Pascal's recurrence, no factorials.  Uses Dvipada's C and शून्य-वाम.)
--
-- स्रोतांसि : हलायुधः, मृतसञ्जीवनी (मेरु-प्रस्तारः, पिङ्गल-भाष्यम्) ।
------------------------------------------------------------------------

module MeruSammiti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-suc ; +-zero ; +-comm)
open import Dvipada using (C ; शून्य-वाम)

------------------------------------------------------------------------
-- पूर्ण — C(n,n) = 1 (कर्ण-अन्तः) ।
------------------------------------------------------------------------

पूर्ण : (n : ℕ) → C n n ≡ 1
पूर्ण zero    = refl
पूर्ण (suc m) = cong₂ _+_ (पूर्ण m) (शून्य-वाम m 0)

------------------------------------------------------------------------
-- सममितिः — मुख्य-सिद्धिः : C(j+k, k) = C(j+k, j) ।
------------------------------------------------------------------------

सममितिः : (j k : ℕ) → C (j + k) k ≡ C (j + k) j
सममितिः zero    k       = पूर्ण k
सममितिः (suc j) zero    = sym (cong (λ z → C z (suc j)) (+-zero (suc j)) ∙ पूर्ण (suc j))
सममितिः (suc j) (suc k) =
    cong₂ _+_
      ( cong (λ z → C z k) (+-suc j k)
      ∙ सममितिः (suc j) k
      ∙ cong (λ z → C z (suc j)) (sym (+-suc j k)) )
      ( सममितिः j (suc k) )
  ∙ +-comm (C (j + suc k) (suc j)) (C (j + suc k) j)

------------------------------------------------------------------------
-- उदाहरणानि — C(5,2) = C(5,3) = 10 ; C(6,2) = C(6,4) = 15 (refl-सिद्धानि) ।
------------------------------------------------------------------------

उदाहरणम्-५ : C 5 2 ≡ C 5 3
उदाहरणम्-५ = refl

उदाहरणम्-६ : C 6 2 ≡ C 6 4
उदाहरणम्-६ = refl
