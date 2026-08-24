-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समास-एकाग्रः — एकक-अंशः अग्रे : श्रेढी अवर्धमाना (एककेन प्रति पदं पूर्वं वहति) ।
--
-- यदा अंश-गणस्य आदौ एककम् अंशम् अस्ति (ps = 0 ∷ qs, अर्थात् {१} ∪ शेषः), तदा
-- समास-आवृत्तेः एकक-पदम् यथार्थतः a(n) एव (एककम् अपाकृत्य शेषः n) ।  अतः
--     a(suc n) = a(n) + (शेष-अंशानां योगः) ≥ a(n) ,
-- अर्थात् श्रेढी अवर्धमाना (non-decreasing) ।  एतत् धनात्मकतायाः (a(n) ≥ 1)
-- मूलम् : विरहाङ्क, नारायण आदयः (येषु एककम् अस्ति) सर्वे धन-मानाः, यतः
-- a(0) = 1 इति आरभ्य कदापि न न्यूनीभवति ।
--
-- (With a unit part at the FRONT (ps = 0 ∷ qs), the samāsa-fold's unit term
--  is exactly a(n) — remove one unit, count the rest of n — so a(suc n) =
--  a(n) + (the other parts' sum) ≥ a(n): the sequence is non-decreasing.  This
--  is the root of positivity (a(n) ≥ 1) for the classical unit-containing
--  nayas — Virahāṅka, Nārāyaṇa, … — since from a(0)=1 it never drops.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaEkagra where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤ ; ≤-refl ; ≤-trans)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; length)
open import SamasaMeruN
  using (सर्गः ; समास-आवृत्तिः ; अंश-गणना ; योगः ; अपाकरणम्)

------------------------------------------------------------------------
-- शेष-योगः — एकक-पदं विहाय शेष-अंशानां योग-पदम् (≥ 0) ।
------------------------------------------------------------------------

शेष-योगः : (qs : List ℕ) (n : ℕ) → ℕ
शेष-योगः qs n =
  योगः (0 ∷ qs) (map (λ p → length (अपाकरणम् (0 ∷ qs) n (suc n) (suc p))) qs)

------------------------------------------------------------------------
-- एकक-अग्र-आवृत्तिः — a(suc n) = a(n) + शेष-योगः (एकक-पदम् = a(n)) ।
------------------------------------------------------------------------

एकक-अग्र-आवृत्तिः : (qs : List ℕ) (n : ℕ)
  → length (सर्गः (0 ∷ qs) (suc n))
  ≡ length (सर्गः (0 ∷ qs) n) + शेष-योगः qs n
एकक-अग्र-आवृत्तिः qs n =
    समास-आवृत्तिः (0 ∷ qs) n
  ∙ cong (_+ शेष-योगः qs n) (अंश-गणना (0 ∷ qs) n 0 zero-≤)

------------------------------------------------------------------------
-- एकक-अग्र-वर्धनम् — श्रेढी अवर्धमाना : a(n) ≤ a(suc n) ।
------------------------------------------------------------------------

एकक-अग्र-वर्धनम् : (qs : List ℕ) (n : ℕ)
  → length (सर्गः (0 ∷ qs) n) ≤ length (सर्गः (0 ∷ qs) (suc n))
एकक-अग्र-वर्धनम् qs n =
    शेष-योगः qs n
  , ( +-comm (शेष-योगः qs n) (length (सर्गः (0 ∷ qs) n))
    ∙ sym (एकक-अग्र-आवृत्तिः qs n) )

------------------------------------------------------------------------
-- उदाहरणम् — विरहाङ्कः {१,२} (ps = 0 ∷ 1 ∷ []) : a(4) = a(3) + शेषः , a(3) ≤ a(4) ।
------------------------------------------------------------------------

विरहाङ्क-वर्धनम् : length (सर्गः (0 ∷ 1 ∷ []) 3) ≤ length (सर्गः (0 ∷ 1 ∷ []) 4)
विरहाङ्क-वर्धनम् = एकक-अग्र-वर्धनम् (1 ∷ []) 3

------------------------------------------------------------------------
-- धनात्मकता — एकक-युक्त-श्रेढी सर्वत्र धना (a(n) ≥ 1) : आधारः a(0)=1, वर्धनेन ।
-- अतः विरहाङ्क, नारायण आदयः (येषु एककम् अस्ति) कदापि न शून्यम् — छिद्र-रहिताः ।
-- (Positivity: a unit-front samāsa sequence is ≥ 1 at every n — base a(0)=1,
--  carried up by monotonicity.  So the unit-containing nayas never gap.)
------------------------------------------------------------------------

धनात्मकता : (qs : List ℕ) (n : ℕ) → 1 ≤ length (सर्गः (0 ∷ qs) n)
धनात्मकता qs zero    = ≤-refl
धनात्मकता qs (suc n) = ≤-trans (धनात्मकता qs n) (एकक-अग्र-वर्धनम् qs n)

-- उदाहरणम् — नारायण-गो-श्रेढी {१,३} (ps = 0 ∷ 2 ∷ []) सर्वत्र धना ।
नारायण-धना : (n : ℕ) → 1 ≤ length (सर्गः (0 ∷ 2 ∷ []) n)
नारायण-धना = धनात्मकता (2 ∷ [])

------------------------------------------------------------------------
-- वर्ध-श्रेढी — पूर्ण-वर्धनम् : m ≤ n ⟹ a(m) ≤ a(n) (न केवलं एक-पदम्, समग्रम्) ।
-- एक-पद-वर्धनस्य श्रेढी-रूपम्, अन्तर k = n − m इति आगमनेन ।
-- (Full monotonicity: a(m) ≤ a(k+m) for every k — the one-step एकक-अग्र-वर्धनम्
--  iterated along the whole gap.  So a unit-front samāsa sequence is
--  non-decreasing across any interval, not merely at adjacent points.)
------------------------------------------------------------------------

वर्ध-श्रेढी : (qs : List ℕ) (m k : ℕ)
          → length (सर्गः (0 ∷ qs) m) ≤ length (सर्गः (0 ∷ qs) (k + m))
वर्ध-श्रेढी qs m zero    = ≤-refl
वर्ध-श्रेढी qs m (suc k) =
  ≤-trans (वर्ध-श्रेढी qs m k) (एकक-अग्र-वर्धनम् qs (k + m))
