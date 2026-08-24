-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पङ्क्ति-योगः — मेरु-पङ्क्तेः योगः = 2ⁿ (पिङ्गलस्य सङ्ख्या, छन्दो-मूलम्) ।
--
-- पिङ्गलस्य "सङ्ख्या" : n-अक्षर-छन्दसां कुल-सङ्ख्या = 2ⁿ ; तेषु यत्र यथार्थतः k
-- गुरवः, तत् मेरु-सङ्ख्या C(n,k) (Dvipada) ।  अतः ∑_{k=0}^{n} C(n,k) = 2ⁿ —
-- गुरु-सङ्ख्यानुसारं विभज्य पुनः-योगः ।  एतत् द्विपदस्य छन्दो-मूलम् : मेरु-सङ्ख्या
-- गुरु-गणनातः जायते, न भाज्य-क्रमात् (factorials) ।  पार्श्वयोग-आवृत्त्या एव सिद्धम् ।
--
-- (Piṅgala's saṅkhyā: the total number of n-syllable metres is 2ⁿ; those with
-- exactly k gurus number C(n,k).  So ∑_{k=0}^{n} C(n,k) = 2ⁿ — decompose by
-- guru-count and re-sum.  This is the binomial's PROSODIC root: the meru number
-- arises from counting metres by heavy-syllable count, not from the factorial.
-- Proved from the Pascal recurrence alone, with the telescope C(n+1,k) =
-- C(n,k−1)+C(n,k) doubling the row.)
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् (सङ्ख्या-प्रत्ययः) ; हलायुधः (मेरु-प्रस्तारः) ।
------------------------------------------------------------------------

module PanktiYoga where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-assoc ; +-comm ; +-zero)
open import Dvipada using (C ; शून्य-वाम)

------------------------------------------------------------------------
-- द्वि-घात — 2ⁿ (पिङ्गलस्य सङ्ख्या) ।
------------------------------------------------------------------------

द्वि-घात : ℕ → ℕ
द्वि-घात zero    = suc zero
द्वि-घात (suc n) = द्वि-घात n + द्वि-घात n

------------------------------------------------------------------------
-- पूर्व-योगः — ∑_{k=0}^{m} C(n,k) (आंशिक-पङ्क्ति-योगः) ।
------------------------------------------------------------------------

पूर्व : ℕ → ℕ → ℕ
पूर्व n zero    = C n zero
पूर्व n (suc m) = पूर्व n m + C n (suc m)

------------------------------------------------------------------------
-- शफल — चतुर्-पद-विनिमयः : (a+b)+(c+d) ≡ (a+d)+(b+c) ।
------------------------------------------------------------------------

शफल : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + d) + (b + c)
शफल a b c d =
    sym (+-assoc a b (c + d))
  ∙ cong (a +_) (+-assoc b c d ∙ +-comm (b + c) d)
  ∙ +-assoc a d (b + c)

------------------------------------------------------------------------
-- अन्तरालः — पार्श्वयोग-दूरदर्शनम् : पूर्व(n+1, m+1) = पूर्व(n, m+1) + पूर्व(n, m) ।
------------------------------------------------------------------------

अन्तरालः : (n m : ℕ) → पूर्व (suc n) (suc m) ≡ पूर्व n (suc m) + पूर्व n m
अन्तरालः n zero    = +-comm (C (suc n) zero) (C (suc n) 1)
अन्तरालः n (suc m) =
    cong (_+ C (suc n) (suc (suc m))) (अन्तरालः n m)
  ∙ शफल (पूर्व n (suc m)) (पूर्व n m) (C n (suc m)) (C n (suc (suc m)))

------------------------------------------------------------------------
-- पङ्क्ति-योगः — मुख्य-सिद्धिः : ∑_{k=0}^{n} C(n,k) = 2ⁿ ।
------------------------------------------------------------------------

पङ्क्ति-योगः : (n : ℕ) → पूर्व n n ≡ द्वि-घात n
पङ्क्ति-योगः zero    = refl
पङ्क्ति-योगः (suc n) =
    अन्तरालः n n
  ∙ cong (_+ पूर्व n n)
         (cong (पूर्व n n +_) (शून्य-वाम n 0) ∙ +-zero (पूर्व n n))
  ∙ cong₂ _+_ (पङ्क्ति-योगः n) (पङ्क्ति-योगः n)

------------------------------------------------------------------------
-- उदाहरणम् — ∑ C(4,k) = 1+4+6+4+1 = 16 = 2⁴ (refl-सिद्धम्) ।
------------------------------------------------------------------------

उदाहरणम् : पूर्व 4 4 ≡ 16
उदाहरणम् = refl
