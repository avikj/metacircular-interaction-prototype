{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समास-द्वि-अंशः — यथेच्छ-द्वि-अंश-गणः {L,M} : सामान्य-आवृत्तिः a(n)=a(n−L)+a(n−M) ।
--
-- एक-अंश-गणः (SamasaEkAmsa) शुद्ध-आवर्तनम् अददात् ; द्वि-अंश-गणः {L,M} (ps =
-- j ∷ k ∷ [], अंश-मानौ L=suc j, M=suc k) शास्त्रीय-द्वि-पद-आवृत्तिं जनयति :
-- यदा उभौ अंशौ योग्यौ (j ≤ N, k ≤ N), तदा
--     length (सर्गः {L,M} (suc N)) ≡ length (सर्गः {L,M} (N−j)) + length (सर्गः {L,M} (N−k)) ।
-- एषा एका आवृत्तिः त्रीणि पूर्व-सिद्धानि नयानि एकत्र वहति :
--   विरहाङ्कः {१,२} (j=0,k=1) : a(n)=a(n−1)+a(n−2) — फिबोनाची ।
--   नारायणः  {१,३} (j=0,k=2) : a(n)=a(n−1)+a(n−3) — गो-श्रेढी ।
--   छिद्रः    {२,३} (j=1,k=2) : a(n)=a(n−2)+a(n−3) — एकक-रहितः ।
-- अत्र त्रयः अस्याः एकस्याः सामान्य-आवृत्तेः रूपे (अनुबन्ध-रूपेण साधिताः) ।
--
-- (The general two-part {L,M} law: where SamasaEkAmsa gave pure recurrence,
--  a part-set of two sizes L=j+1, M=k+1 yields the classical binary recurrence
--  length(सर्गः {L,M} (suc N)) ≡ length(सर्गः {L,M} (N−j)) + length(सर्गः {L,M} (N−k))
--  whenever both parts fit (j≤N, k≤N).  One recurrence subsuming the three
--  previously per-instance nayas — Virahāṅka {1,2} (Fibonacci), Nārāyaṇa {1,3}
--  (cows), and the unit-free छिद्र {2,3} — each derived here as a corollary.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaDviAmsa where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤ ; suc-≤-suc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import SamasaMeruN using (सर्गः ; समास-आवृत्तिः ; अंश-गणना)

------------------------------------------------------------------------
-- द्वि-अंश-आवृत्तिः — सामान्य-द्वि-पद-आवृत्तिः (उभयोः अंशयोः योग्यत्वे) ।
------------------------------------------------------------------------

द्वि-अंश-आवृत्तिः : (j k N : ℕ) → j ≤ N → k ≤ N
  → length (सर्गः (j ∷ k ∷ []) (suc N))
  ≡ length (सर्गः (j ∷ k ∷ []) (N ∸ j)) + length (सर्गः (j ∷ k ∷ []) (N ∸ k))
द्वि-अंश-आवृत्तिः j k N j≤N k≤N =
    समास-आवृत्तिः (j ∷ k ∷ []) N
  ∙ cong₂ _+_ (अंश-गणना (j ∷ k ∷ []) N j j≤N)
              ( cong (_+ 0) (अंश-गणना (j ∷ k ∷ []) N k k≤N)
              ∙ +-zero (length (सर्गः (j ∷ k ∷ []) (N ∸ k))) )

------------------------------------------------------------------------
-- अनुबन्धाः — त्रीणि नयानि, सामान्य-आवृत्तेः रूपे (अंश-अपकर्षाः definitional) ।
------------------------------------------------------------------------

-- विरहाङ्कः {१,२} : a(n+2) = a(n+1) + a(n) (फिबोनाची) ।
विरहाङ्क-रूपम् : (n : ℕ)
  → length (सर्गः (0 ∷ 1 ∷ []) (suc (suc n)))
  ≡ length (सर्गः (0 ∷ 1 ∷ []) (suc n)) + length (सर्गः (0 ∷ 1 ∷ []) n)
विरहाङ्क-रूपम् n = द्वि-अंश-आवृत्तिः 0 1 (suc n) zero-≤ (suc-≤-suc zero-≤)

-- नारायणः {१,३} : a(n+3) = a(n+2) + a(n) (गो-श्रेढी) ।
नारायण-रूपम् : (n : ℕ)
  → length (सर्गः (0 ∷ 2 ∷ []) (suc (suc (suc n))))
  ≡ length (सर्गः (0 ∷ 2 ∷ []) (suc (suc n))) + length (सर्गः (0 ∷ 2 ∷ []) n)
नारायण-रूपम् n = द्वि-अंश-आवृत्तिः 0 2 (suc (suc n)) zero-≤ (suc-≤-suc (suc-≤-suc zero-≤))

-- छिद्रः {२,३} : a(n+3) = a(n+1) + a(n) (एकक-रहितः) ।
छिद्र-रूपम् : (n : ℕ)
  → length (सर्गः (1 ∷ 2 ∷ []) (suc (suc (suc n))))
  ≡ length (सर्गः (1 ∷ 2 ∷ []) (suc n)) + length (सर्गः (1 ∷ 2 ∷ []) n)
छिद्र-रूपम् n = द्वि-अंश-आवृत्तिः 1 2 (suc (suc n)) (suc-≤-suc zero-≤) (suc-≤-suc (suc-≤-suc zero-≤))
