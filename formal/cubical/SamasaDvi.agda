-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समास-द्विः — एक-अंश-गणः {२} (एककम् अंशं विना) : काल-द्वि-आवृत्तिः a(n+2)=a(n) ।
--
-- समास-एकः {१} ध्रुव-श्रेढीम् (१,१,१,…) अदर्शयत् ; अत्र प्रति-पक्षः — एकः अंशः
-- किन्तु मानेन २ (ps = 1 ∷ [], अर्थात् {२}) ।  n केवलं द्वि-गुणैः अंशैः रच्यते
-- यदि n युग्मम् ; अन्यथा न किमपि ।  अतः श्रेढी : १,०,१,०,१,० … (युग्म-सूचकः) ।
-- सामान्य-समास-आवृत्तिः (अंश-गणनया) एतत् अपि वहति :
--     length (सर्गः {२} (n+2)) ≡ length (सर्गः {२} n) ।
-- न योग-रूपा (एक-अंशत्वात्), अपि तु शुद्ध-आवर्तनम् — छिद्र-आवृत्तेः (द्वि-अंश)
-- एक-अंश-रूपम् ।  एवम् एककम् अंशं विना अपि भावना सम्यक् चलति ।
--
-- (The single non-unit part {2}: where समास-एकः {1} gave the constant line
--  1,1,1,…, this is its counterpart — one part, of size 2 (ps = [1]).  An n is
--  built from twos exactly when it is even, else not at all, so the sequence is
--  1,0,1,0,1,0,… (the even-indicator).  The same general समास-आवृत्तिः, via
--  अंश-गणना, yields it: length(सर्गः {2} (n+2)) ≡ length(सर्गः {2} n) — not a
--  sum (only one part) but pure period-2 recurrence, the single-part case of
--  छिद्र-आवृत्तिः.  The bhāvanā runs correctly even without any unit part.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaDvi where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Data.Nat.Order using (suc-≤-suc ; zero-≤)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import SamasaMeruN using (सर्गः ; समास-आवृत्तिः ; अंश-गणना)

------------------------------------------------------------------------
-- द्वि-अंश-आवृत्तिः — {२}-श्रेढेः शुद्ध-आवर्तनम् : a(n+2) = a(n) ।
------------------------------------------------------------------------

द्वि-अंश-आवृत्तिः : (n : ℕ)
  → length (सर्गः (1 ∷ []) (suc (suc n)))
  ≡ length (सर्गः (1 ∷ []) n)
द्वि-अंश-आवृत्तिः n =
    समास-आवृत्तिः (1 ∷ []) (suc n)
  ∙ cong (_+ 0) (अंश-गणना (1 ∷ []) (suc n) 1 (suc-≤-suc zero-≤))
  ∙ +-zero (length (सर्गः (1 ∷ []) n))

------------------------------------------------------------------------
-- उदाहरणे — युग्म-सूचकः : १,०,१,०,१,० … (refl-सिद्धानि) ।
------------------------------------------------------------------------

द्वि-० : length (सर्गः (1 ∷ []) 0) ≡ 1     -- युग्मम् : एकः समासः ([])
द्वि-० = refl

द्वि-१ : length (सर्गः (1 ∷ []) 1) ≡ 0     -- अयुग्मम् : न किमपि
द्वि-१ = refl

द्वि-४ : length (सर्गः (1 ∷ []) 4) ≡ 1     -- युग्मम् : २+२
द्वि-४ = refl

द्वि-५ : length (सर्गः (1 ∷ []) 5) ≡ 0     -- अयुग्मम्
द्वि-५ = refl
