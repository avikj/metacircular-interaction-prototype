-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- श्रेढी-फलम् — आर्यभटस्य समान्तर-श्रेढी-योगः (आर्यभटीयम्, गणितपादः १९, ४९९ ई.) ।
--
-- आर्यभटः (गणितपादः १९) समान्तर-श्रेढ्याः (मुख a, चयः d, पदानि n) योगम् आह :
-- मध्यधनं × पदसङ्ख्या = योगः , अर्थात् S = n·(2a + (n−1)d)/2 ।  विभाग-वर्जनार्थम् :
-- २·S = n·(2a) + n·(n−1)·d ।  एषा सर्व-समान्तर-श्रेढ्याः सामान्या ; ∑k (Sankalita)
-- अस्याः a=1,d=1 विशेषः ।
--
-- (Āryabhaṭa's arithmetic-progression sum, 2.19: for first term a, common
-- difference d, n terms, S = n(2a+(n−1)d)/2 — the mean times the count.  Given
-- integrally as 2S = n·(2a) + n(n−1)d.  This is the GENERAL arithmetic series,
-- of which ∑k in Sankalita.agda is the a=1, d=1 case.  Proved by induction; the
-- quadratic in n uses द्वि-योगः: 2n + n(n−1) ≡ n(n+1).)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः १९ (मध्यधन-श्रेढीफल-सूत्रम्) ।
------------------------------------------------------------------------

module Shredhi where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Nat.Properties
  using (·-distribˡ ; ·-distribʳ ; ·-assoc ; ·-comm ; ·-suc ; +-assoc ; +-zero)

------------------------------------------------------------------------
-- सहायकौ ।
------------------------------------------------------------------------

द्वि· : (x : ℕ) → 2 · x ≡ x + x
द्वि· x = cong (x +_) (+-zero x)

-- द्वि-योगः : 2n + n(n−1) = n(n+1) ।
द्वि-योगः : (n : ℕ) → 2 · n + n · (n ∸ 1) ≡ n · suc n
द्वि-योगः zero    = refl
द्वि-योगः (suc m) =
    cong (_+ suc m · m) (द्वि· (suc m))
  ∙ sym (+-assoc (suc m) (suc m) (suc m · m))
  ∙ cong (suc m +_) (sym (·-suc (suc m) m))
  ∙ sym (·-suc (suc m) (suc m))

------------------------------------------------------------------------
-- श्रेढी — समान्तर-श्रेढ्याः योगः : a + (a+d) + (a+2d) + … (n पदानि) ।
------------------------------------------------------------------------

श्रेढी : ℕ → ℕ → ℕ → ℕ
श्रेढी a d zero    = zero
श्रेढी a d (suc n) = a + श्रेढी (a + d) d n

------------------------------------------------------------------------
-- श्रेढी-फलम् — मुख्य-सिद्धिः : २·S = n·(2a) + n·(n−1)·d ।
------------------------------------------------------------------------

श्रेढी-फलम् : (a d n : ℕ)
          → 2 · श्रेढी a d n ≡ n · (2 · a) + (n · (n ∸ 1)) · d
श्रेढी-फलम् a d zero    = refl
श्रेढी-फलम् a d (suc n) =
    sym (·-distribˡ 2 a (श्रेढी (a + d) d n))
  ∙ cong (2 · a +_) (श्रेढी-फलम् (a + d) d n)
  ∙ cong (λ z → 2 · a + (z + (n · (n ∸ 1)) · d)) expand
  ∙ regroup
  ∙ cong₂ _+_ refl secondGroup
  where
    P Q R : ℕ
    P = n · (2 · a)
    Q = n · (2 · d)
    R = (n · (n ∸ 1)) · d
    expand : n · (2 · (a + d)) ≡ P + Q
    expand = cong (n ·_) (sym (·-distribˡ 2 a d))
           ∙ sym (·-distribˡ n (2 · a) (2 · d))
    regroup : 2 · a + ((P + Q) + R) ≡ (2 · a + P) + (Q + R)
    regroup = cong (2 · a +_) (sym (+-assoc P Q R))
            ∙ +-assoc (2 · a) P (Q + R)
    secondGroup : Q + R ≡ (suc n · n) · d
    secondGroup =
        cong (_+ R) (·-assoc n 2 d)
      ∙ ·-distribʳ (n · 2) (n · (n ∸ 1)) d
      ∙ cong (_· d) (cong (_+ n · (n ∸ 1)) (·-comm n 2)
                    ∙ द्वि-योगः n
                    ∙ ·-comm n (suc n))

------------------------------------------------------------------------
-- उदाहरणम् — 2,5,8,11,14 (a=2,d=3,n=5) : योगः = 40 ; 2·40 = 80 = 5·4 + 5·4·3 ।
--   (∑1..4 = 10 as the a=1,d=1 case : 2·श्रेढी 1 1 4 = 20 = 4·2 + 4·3·1.)
------------------------------------------------------------------------

उदाहरणम्-श्रेढी : श्रेढी 2 3 5 ≡ 40
उदाहरणम्-श्रेढी = refl

उदाहरणम्-∑ : श्रेढी 1 1 4 ≡ 10          -- ∑1..4, the a=1 d=1 special case
उदाहरणम्-∑ = refl

------------------------------------------------------------------------
-- अन्त — समान्तर-श्रेढ्याः अन्तिम-पदम् (n पदेषु) : a + (n−1)·d ।
------------------------------------------------------------------------

अन्त : ℕ → ℕ → ℕ → ℕ
अन्त a d n = a + (n ∸ 1) · d

------------------------------------------------------------------------
-- मध्यधनम् — आर्यभटस्य मध्यधन-रूपम् : 2·S = n·(आदि + अन्त) = पद-सङ्ख्या × (मुख+अन्तिम) ।
-- (गणितपादः १९ यत् "मध्यधनं पदसङ्ख्या-गुणितं" इति आह, तत् एतत् — श्रेढी-फलस्य
--  विस्तृत-रूपात् (n·2a + n(n−1)d) मध्य-रूपम् वाम-वितरणेन ।)
--
-- (Āryabhaṭa's madhyadhana form: 2S = n·(first + last), the sum as number-of-
-- terms times the mean, which 2.19 states directly.  Derived from the expanded
-- श्रेढी-फलम् by left-distribution and 2a = a + a.)
------------------------------------------------------------------------

मध्यधनम् : (a d n : ℕ) → 2 · श्रेढी a d n ≡ n · (a + अन्त a d n)
मध्यधनम् a d n =
    श्रेढी-फलम् a d n
  ∙ cong (n · (2 · a) +_) (sym (·-assoc n (n ∸ 1) d))
  ∙ ·-distribˡ n (2 · a) ((n ∸ 1) · d)
  ∙ cong (n ·_) (cong (_+ (n ∸ 1) · d) (द्वि· a)
                  ∙ sym (+-assoc a a ((n ∸ 1) · d)))

-- उदाहरणम् — 2,5,8,11,14 : 2·40 = 80 = 5·(2+14) = 5·16 (refl-सिद्धम्) ।
मध्य-५ : 2 · श्रेढी 2 3 5 ≡ 5 · (2 + 14)
मध्य-५ = refl

------------------------------------------------------------------------
-- सम-श्रेढी — शून्य-चय-श्रेढी (d=0) : n समान-पदानां योगः = n·a ।  आर्यभटस्य
-- श्रेढीफलं गुणनम् अपि व्याप्नोति — गुणनं समान-श्रेढ्याः योगः एव (पुनरावृत्त-योगः) ।
-- (Āryabhaṭa's series with zero common difference: n equal terms sum to n·a, so
--  the śreḍhī subsumes multiplication — n·a is the sum of the constant series.)
------------------------------------------------------------------------

सम-श्रेढी : (a n : ℕ) → श्रेढी a 0 n ≡ n · a
सम-श्रेढी a zero    = refl
सम-श्रेढी a (suc n) =
    cong (λ z → a + श्रेढी z 0 n) (+-zero a)
  ∙ cong (a +_) (सम-श्रेढी a n)

-- उदाहरणम् — श्रेढी 7 0 4 = 28 = 4·7 (refl-सिद्धम्) ।
सम-४ : श्रेढी 7 0 4 ≡ 28
सम-४ = refl
