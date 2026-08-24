-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अक्षर-द्विगुणः — पिङ्गलस्य वर्ण-प्रस्तारस्य द्विगुणनम्, वस्तु-स्तरे (न केवलं गणने) ।
--
-- पिङ्गलस्य संख्या-प्रत्ययः : n-अक्षर-छन्दांसि 2ⁿ (sankhya (suc n) = sankhya n +
-- sankhya n) — किन्तु एषा आवृत्तिः केवलं गणना ।  किमर्थं द्विगुणम् ?  यतः प्रति
-- (suc n)-अक्षर-छन्दः द्वयोः एकम् : आदौ लघुः, ततः n-अक्षर-छन्दः ; अथवा आदौ गुरुः,
-- ततः n-अक्षर-छन्दः ।  एतत् वस्तु-स्तरीयं तुल्यता-रूपम् :
--     Vak (suc n) ≃ Vak n ⊎ Vak n
-- (आदि-अक्षरेण विभागः) — इदम् एव संख्या-द्विगुणस्य मूल-हेतुः, न पृथक् गणना ।
-- मात्रा-वृत्ते matrameruIso (Metre) अस्ति ; अत्र वर्ण-वृत्ते (Vak) तत् साधितम् ।
--
-- (Piṅgala's saṅkhyā pratyaya says n-syllable metres number 2ⁿ, encoded as
--  sankhya(suc n) = sankhya n + sankhya n — but that recurrence only COUNTS.
--  Why does it double?  Because every (n+1)-syllable metre is exactly one of
--  two things: a laghu followed by an n-metre, or a guru followed by one —
--  a type equivalence Vak (suc n) ≃ Vak n ⊎ Vak n, split by the first
--  syllable.  This is the OBJECT-level root of the doubling, from which the
--  count follows, not a separate arithmetic fact.  The mātrā-vṛtta already had
--  matrameruIso for Metre; this supplies the varṇa-vṛtta (Vak) analogue.)
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् ८ (प्रस्तारः, संख्या) ; हलायुधः (मेरु-व्याख्या) ।
------------------------------------------------------------------------

module AksaraDviguna where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; injSuc ; znots)
open import Cubical.Data.Nat.Properties using (isSetℕ)
open import Cubical.Data.List using (_∷_ ; [])
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; Σ≡Prop)
open import Cubical.Data.Empty using (rec)
open import PingalaPrastara using (Syllable ; laghu ; guru ; Pattern ; varna ; Vak)

------------------------------------------------------------------------
-- अग्रे — आदि-अक्षरेण विभागः : लघुः → वामम् (inl), गुरुः → दक्षिणम् (inr) ।
-- रिक्तः असम्भवः (varna [] = 0 ≢ suc n) ।
------------------------------------------------------------------------

अग्रे : (n : ℕ) → Vak (suc n) → Vak n ⊎ Vak n
अग्रे n ([]         , e) = rec (znots e)
अग्रे n (laghu ∷ p  , e) = inl (p , injSuc e)
अग्रे n (guru  ∷ p  , e) = inr (p , injSuc e)

------------------------------------------------------------------------
-- पश्चात् — आदि-अक्षर-प्रक्षेपः : वामे लघुः, दक्षिणे गुरुः पुरतः योज्यते ।
------------------------------------------------------------------------

पश्चात् : (n : ℕ) → Vak n ⊎ Vak n → Vak (suc n)
पश्चात् n (inl (p , e)) = (laghu ∷ p , cong suc e)
पश्चात् n (inr (p , e)) = (guru  ∷ p , cong suc e)

------------------------------------------------------------------------
-- परिवृत्ती — उभे प्रतिलोमे ; अक्षर-अंशः refl, मान-अंशः प्रमाण-रूपेण (isSetℕ) ।
------------------------------------------------------------------------

पश्चात्-अग्रे : (n : ℕ) (x : Vak (suc n)) → पश्चात् n (अग्रे n x) ≡ x
पश्चात्-अग्रे n ([]        , e) = rec (znots e)
पश्चात्-अग्रे n (laghu ∷ p , e) = Σ≡Prop (λ _ → isSetℕ _ _) refl
पश्चात्-अग्रे n (guru  ∷ p , e) = Σ≡Prop (λ _ → isSetℕ _ _) refl

अग्रे-पश्चात् : (n : ℕ) (y : Vak n ⊎ Vak n) → अग्रे n (पश्चात् n y) ≡ y
अग्रे-पश्चात् n (inl (p , e)) = cong inl (Σ≡Prop (λ _ → isSetℕ _ _) refl)
अग्रे-पश्चात् n (inr (p , e)) = cong inr (Σ≡Prop (λ _ → isSetℕ _ _) refl)

------------------------------------------------------------------------
-- द्विगुण-वाक् — मुख्य-फलम् : Vak (suc n) ≃ Vak n ⊎ Vak n (संख्या-द्विगुणस्य मूलम्) ।
------------------------------------------------------------------------

द्विगुण-Iso : (n : ℕ) → Iso (Vak (suc n)) (Vak n ⊎ Vak n)
द्विगुण-Iso n = iso (अग्रे n) (पश्चात् n) (अग्रे-पश्चात् n) (पश्चात्-अग्रे n)

द्विगुण-वाक् : (n : ℕ) → Vak (suc n) ≃ (Vak n ⊎ Vak n)
द्विगुण-वाक् n = isoToEquiv (द्विगुण-Iso n)
