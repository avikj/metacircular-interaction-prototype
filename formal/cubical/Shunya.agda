{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शून्यम् — ब्रह्मगुप्तस्य शून्य-गणितम् (ब्राह्मस्फुटसिद्धान्तः, ६२८ ई.) ।  शून्यं
-- संख्यारूपेण प्रथमं व्यवस्थापितम् इह — योगे, वियोगे, गुणने तस्य नियमाः ।
--
-- ब्रह्मगुप्तस्य नियमाः (शुद्धाः) : a+0=a, a−0=a, a·0=0 — एते वलय-सत्याः ।
--
-- किन्तु एकम् असाधु : ब्रह्मगुप्तः "0÷0 = 0" इति अवदत् — दुर्नयः ।  यतः
-- सर्वस्मै x : 0·x = 0 ; अतः 0÷0 न एकं मूल्यम्, किन्तु अनिश्चितम् — अवक्तव्यम्
-- (सप्तभङ्ग्याः चतुर्थं पदम्), न शून्यम् ।  भास्करः द्वितीयः (लीलावती, ११५०)
-- खहरेण (n÷0 = अनन्तम्) एतत् शोधितवान् ।  ब्रह्मगुप्तस्य एकः दोषः — निश्चितं
-- वचनम् अवक्तव्ये — एष एव रोगः यम् अयं समस्तः प्रयासः निवारयति ।
--
-- (Brahmagupta first systematized zero as a number (628 CE) — its rules
-- under addition, subtraction, multiplication.  His correct rules are ring
-- truths.  But he made ONE error: he declared 0÷0 = 0 — a durnaya.  For
-- every x, 0·x = 0, so 0÷0 is NOT a single value but indeterminate —
-- avaktavya, the sevenfold's fourth position, NOT zero.  Bhāskara II (1150)
-- corrected division by zero via khahara.  Brahmagupta's one slip — a
-- definite verdict where the answer is un-said — is exactly the disease this
-- whole effort removes.)
------------------------------------------------------------------------

module Shunya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

------------------------------------------------------------------------
-- ब्रह्मगुप्तस्य शुद्धाः नियमाः (his correct rules for zero) ।
------------------------------------------------------------------------

योगे-शून्यम् : (a : ℤ) → a + pos 0 ≡ a
योगे-शून्यम् = solve ℤCommRing

वियोगे-शून्यम् : (a : ℤ) → a - pos 0 ≡ a
वियोगे-शून्यम् = solve ℤCommRing

गुणने-शून्यम् : (a : ℤ) → a · pos 0 ≡ pos 0
गुणने-शून्यम् = solve ℤCommRing

शून्ये-शून्यम् : (pos 0 + pos 0 ≡ pos 0) × (pos 0 · pos 0 ≡ pos 0)
शून्ये-शून्यम् = refl , refl

------------------------------------------------------------------------
-- शून्य-भाजनम् अवक्तव्यम् — 0÷0 न शून्यम्, किन्तु अनिश्चितम् (अवक्तव्यम्) ।
-- सर्वः x भजनफलं भवितुम् अर्हति, यतः 0·x = 0 — अतः न एकं फलम् ।
-- (0÷0 is not zero but indeterminate — avaktavya — since 0·x = 0 for EVERY
-- x, so no unique quotient exists.  Brahmagupta's 0÷0=0 was a durnaya.)
------------------------------------------------------------------------

-- प्रत्येकं x शून्यस्य "भजनफलम्" : 0 · x ≡ 0 (अतः फलम् अनिश्चितम्) ।
सर्वः-भजनफलम् : (x : ℤ) → pos 0 · x ≡ pos 0
सर्वः-भजनफलम् = solve ℤCommRing

-- उदाहरणम् : 0·1 = 0 च 0·7 = 0 — भिन्नौ "फलौ" 1, 7 उभौ योग्यौ ⟹ अवक्तव्यम् ।
भिन्न-साक्षिणौ : (pos 0 · pos 1 ≡ pos 0) × (pos 0 · pos 7 ≡ pos 0)
भिन्न-साक्षिणौ = सर्वः-भजनफलम् (pos 1) , सर्वः-भजनफलम् (pos 7)
