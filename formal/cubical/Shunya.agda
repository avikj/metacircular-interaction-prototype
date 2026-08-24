-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

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

-- [CORRECTED 2026-08-19.  The identification of 0÷0 with अवक्तव्यम्,
--  the saptabhaṅgī's fourth position, does not hold — and it fails by
--  SaptabhangiNaya.agda's own criterion, in this same directory, not
--  by an outside standard.  §5 there defines avaktavyam as the case
--  where NO SINGLE UTTERANCE denotes the content, proved exhaustively
--  over the six atoms of its language.  0÷0's situation IS denotable
--  in one utterance: every x whatsoever satisfies 0·x = 0, which is
--  one complete statement saying exactly what is wrong.
--
--  The two defects are opposite.  avaktavyam: the content is
--  determinate and the medium cannot say it in one go — an
--  EXPRESSIBILITY failure.  0÷0: the content is perfectly expressible
--  and the solution set is not a singleton — a UNIQUENESS failure.
--
--  Everything else in this module stands.  Brahmagupta's 0÷0 = 0
--  (Brāhmasphuṭasiddhānta, 628) is a durnaya; Bhāskara II's khahara
--  (Līlāvatī, 1150) is a genuinely different non-finite result from
--  it; and a boolean "undefined" collapsing them is the disease.
--  Only the name of the second thing is wrong.  See
--  AnuktaAvaktavya.agda §6, where 0÷0's defect is checked.
--
--  Three modules here now call three different structures
--  avaktavyam — Satyayantra, Khahara, Shunya.  Using one third
--  position as a catch-all for "not a clean single answer" is the
--  boolean collapse this corpus exists to fight, one level up.]
module Shunya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- ब्रह्मगुप्तस्य शुद्धाः नियमाः (his correct rules for zero) ।
------------------------------------------------------------------------

योगे-शून्यम् : (a : ℤ) → a + pos 0 ≡ a
योगे-शून्यम् a = solve! ℤCommRing

वियोगे-शून्यम् : (a : ℤ) → a - pos 0 ≡ a
वियोगे-शून्यम् a = solve! ℤCommRing

गुणने-शून्यम् : (a : ℤ) → a · pos 0 ≡ pos 0
गुणने-शून्यम् a = solve! ℤCommRing

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
सर्वः-भजनफलम् x = solve! ℤCommRing

-- उदाहरणम् : 0·1 = 0 च 0·7 = 0 — भिन्नौ "फलौ" 1, 7 उभौ योग्यौ ⟹ अवक्तव्यम् ।
भिन्न-साक्षिणौ : (pos 0 · pos 1 ≡ pos 0) × (pos 0 · pos 7 ≡ pos 0)
भिन्न-साक्षिणौ = सर्वः-भजनफलम् (pos 1) , सर्वः-भजनफलम् (pos 7)

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module or its
-- CORRECTED block.
--
-- That block separates two defects — expressibility (avaktavyam) versus
-- uniqueness (0÷0) — and names the risk: one third position used as a
-- catch-all for "not a clean single answer" is the boolean collapse this
-- corpus exists to fight, one level up.
--
-- The independence is now checked, over four realised corners, in
-- `NaturalMachine.NonUniquenessAndInexpressibilityAreIndependent`
-- (--safe, no postulates, no holes):
--
--   nonUnique ∧ expressible     all,  constants
--   unique    ∧ inexpressible   self, constants
--   nonUnique ∧ inexpressible   all,  onlyFalse
--   unique    ∧ expressible     self, onlyId
--
-- so neither defect implies the other and neither implies the other's
-- negation — they are not two readings of one thing at any strength.
-- The types also show WHY: non-uniqueness is a property of the content
-- alone, inexpressibility of the content AND the medium.
--
-- The third structure, Satyayantra's अनुक्तम्, is deliberately NOT
-- brought onto that carrier: it is temporal, and d909db0d already says
-- the two third-positions' remedies live in different types.  No verdict
-- is offered there on which module should keep the word अवक्तव्यम्, nor
-- on the saptabhaṅgī, nor on Brahmagupta's or Bhāskara II's texts.
------------------------------------------------------------------------
