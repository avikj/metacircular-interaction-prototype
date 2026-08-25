{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- खहरः — भास्करस्य द्वितीयस्य शून्य-हर-राशिः (लीलावती, बीजगणितम्, ११५० ई.) ।
-- ब्रह्मगुप्तस्य शोधनम् : n÷0 (n≠0) न शून्यम्, किन्तु "खहरः" — अनन्त-राशिः,
-- यः ससीम-योगेन वियोगेन च अविकृतः (खहरे अस्मिन् न विकारः) ।
--
-- सूक्ष्म-भेदः (Shunya-सम्बन्धः) : n÷0 (n≠0) = खहरः (अनन्तः, निश्चितः) ;
-- किन्तु 0÷0 = अवक्तव्यम् (अनिश्चितम्, सप्तभङ्ग्याः ४र्थं पदम्), न खहरः ।
-- द्वौ भिन्नौ "अशून्य-हरौ" : एकः अनन्तः, अपरः अवक्तव्यः ।  एष एव सूक्ष्मः
-- विवेकः यम् बूलियन्-गणितं (एकं "undefined") लुम्पति ।
--
-- (Bhāskara II's khahara — the zero-divided quantity (Līlāvatī, 1150),
-- correcting Brahmagupta: n÷0 (n≠0) is not zero but khahara, an infinite
-- quantity UNCHANGED by adding or subtracting a finite amount.  And the
-- fine distinction with Shunya: n÷0 (n≠0) = khahara (determinate infinite),
-- whereas 0÷0 = avaktavya (indeterminate, the un-said) — two DIFFERENT
-- non-finite results that a boolean "undefined" collapses into one.)
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
module Khahara where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _-_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- खहर — ससीमः (finite ℤ) वा अनन्तः (khahara) ।
------------------------------------------------------------------------

data खहर : Type where
  ससीम : ℤ → खहर
  अनन्त : खहर          -- भास्करस्य खहरः

------------------------------------------------------------------------
-- ⊕ , ⊖ — योगः वियोगश्च ।  अनन्तः ससीमेन अविकृतः (Bhāskara's law) ।
------------------------------------------------------------------------

_⊕_ : खहर → खहर → खहर
ससीम a ⊕ ससीम b = ससीम (a + b)
अनन्त  ⊕ _       = अनन्त
ससीम _ ⊕ अनन्त   = अनन्त

_⊖_ : खहर → खहर → खहर
ससीम a ⊖ ससीम b = ससीम (a - b)
अनन्त  ⊖ _       = अनन्त
ससीम _ ⊖ अनन्त   = अनन्त

------------------------------------------------------------------------
-- भास्कर-नियमः — खहरे न विकारः : अनन्तः ससीम-योगेन वियोगेन च अविकृतः ।
-- (Bhāskara's law: khahara is unchanged by adding or subtracting a finite.)
------------------------------------------------------------------------

खहरे-न-विकारः-योगे : (a : ℤ) → (अनन्त ⊕ ससीम a) ≡ अनन्त
खहरे-न-विकारः-योगे a = refl

खहरे-न-विकारः-वियोगे : (a : ℤ) → (अनन्त ⊖ ससीम a) ≡ अनन्त
खहरे-न-विकारः-वियोगे a = refl

-- खहरः खहरेण सह अपि खहरः (khahara + khahara = khahara)
खहर-खहर : (अनन्त ⊕ अनन्त) ≡ अनन्त
खहर-खहर = refl

------------------------------------------------------------------------
-- भजनम् — n÷0 (n≠0) = खहरः (अनन्तः) ; तत् Shunya-अवक्तव्यात् (0÷0) भिन्नम् ।
-- अत्र हरः शून्यः इति निर्दिश्य फलं खहरम् आदिशामः — भास्करस्य दृष्टिः ।
-- (dividing a nonzero by zero yields khahara — distinct from Shunya's 0÷0,
-- which is avaktavya.  Two non-finite outcomes, kept apart, not collapsed.)
------------------------------------------------------------------------

-- शून्य-हरे (अशून्य-अंशे) फलम् खहरः, न ससीमः, न अवक्तव्यः ।
शून्य-हरः : ℤ → खहर          -- अंशः n (≠0 अभिप्रेतः) ; हरः 0 ⟹ खहरः
शून्य-हरः _ = अनन्त

-- अतः यत् किञ्चित् ससीमं तेन योजितं खहरं न ससीमं करोति (अनन्तत्वं स्थिरम्) ।
अनन्तत्व-स्थैर्यम् : (n a : ℤ) → (शून्य-हरः n ⊕ ससीम a) ≡ शून्य-हरः n
अनन्तत्व-स्थैर्यम् n a = refl

------------------------------------------------------------------------
-- खहरः न ससीमः — भास्करस्य ब्रह्मगुप्त-शोधनम्, पदी-कृतम् : n÷0 (अनन्तः) कस्मादपि
-- ससीमात् भिन्नः — विशेषतः शून्यात् न ।  ब्रह्मगुप्तः 0÷0=0 (दुर्नयः) आह ;
-- भास्करः खहरम् अनन्तं पृथक् अस्थापयत् ।  विवेचकेन (अनन्त?) सिद्धम् ।
-- (Bhāskara's correction of Brahmagupta, made a term: n÷0 (khahara) differs
--  from EVERY finite — in particular it is not zero.  Brahmagupta's 0÷0=0 is
--  a durnaya; Bhāskara set the infinite khahara apart.  Via a discriminator.)
------------------------------------------------------------------------

अनन्त? : खहर → Type
अनन्त? (ससीम _) = ⊥
अनन्त? अनन्त     = Unit

अनन्त-न-ससीमः : (a : ℤ) → ¬ (अनन्त ≡ ससीम a)
अनन्त-न-ससीमः a eq = subst अनन्त? eq tt

-- ब्रह्मगुप्त-दोषः — n÷0 ≠ 0 : खहरः शून्यः न (ब्रह्मगुप्तस्य दुर्नयस्य निरासः) ।
ब्रह्मगुप्त-दोषः : (n : ℤ) → ¬ (शून्य-हरः n ≡ ससीम (pos 0))
ब्रह्मगुप्त-दोषः n = अनन्त-न-ससीमः (pos 0)

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above, including the CORRECTED block.  Pointer only.
--
-- THIS APPEND EXISTS BECAUSE A CHECK CAUGHT ITS ABSENCE.  b397fe48 made
-- correction-propagation a standing check: a module that corrects X is
-- unreachable from X unless X names it.  Run against my own pairs, 18 of
-- 20 carried the back-reference and this file was one of the two that
-- did not.
--
-- The CORRECTED block above separates two defects and warns that using
-- one third position as a catch-all is the boolean collapse this corpus
-- fights, one level up.  Their INDEPENDENCE is checked, over four
-- realised corners, in
-- `NonUniquenessAndInexpressibilityAreIndependent`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   nonUnique ∧ expressible     all,  constants
--   unique    ∧ inexpressible   self, constants
--   nonUnique ∧ inexpressible   all,  onlyFalse
--   unique    ∧ expressible     self, onlyId
--
-- so neither defect implies the other and neither implies the other's
-- negation.  The types say why: non-uniqueness is a property of the
-- CONTENT alone, inexpressibility of the content AND the MEDIUM — which
-- is the asymmetry that makes one word for both lossy.
--
-- That module deliberately does NOT bring Satyayantra's अनुक्तम् onto
-- the same carrier: it is temporal, and d909db0d already says the two
-- third-positions' remedies live in different types.  And it offers no
-- verdict on which module should keep the word अवक्तव्यम् — that is this
-- lane's dispute, untouched.
------------------------------------------------------------------------
