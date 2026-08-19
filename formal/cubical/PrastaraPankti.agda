{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- संख्या-पङ्क्ति-सेतुः — पिङ्गलस्य द्वौ प्रत्ययौ एकम् एव गणयतः (छन्दःशास्त्रम्) ।
--
-- पिङ्गलः (छन्दःशास्त्रम् ८) प्रत्ययान् आह : प्रस्तारः, नष्टम्, उद्दिष्टम्, संख्या
-- (कति छन्दांसि = 2ⁿ), मेरु-प्रस्तारः (त्रिकोण-आवली) च ।  अत्र द्वौ मिलतः :
-- संख्या (PingalaPrastara.sankhya, यत्र Vak n ≃ Fin(sankhya n) साधितम्) , मेरु-
-- पङ्क्ति-योगः च (PanktiYoga.पूर्व n n = ∑ₖ C(n,k)) ।  उभौ 2ⁿ , अतः समौ :
-- sankhya n ≡ पूर्व n n — छन्दो-गणना (संख्या) मेरु-पङ्क्ति-योगः एव ।
--
-- (Piṅgala's saṅkhyā — the count of n-syllable metres, 2ⁿ, established in
-- PingalaPrastara as Vak n ≃ Fin(sankhya n) — equals the meru-prastāra row sum
-- ∑ₖ C(n,k) (PanktiYoga.पूर्व, = द्वि-घात).  The two pratyayas Piṅgala states side
-- by side, saṅkhyā and the meru, count the same 2ⁿ, and here that identity is a
-- proof: the metre-count IS the binomial row sum, not just numerically equal.)
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् ८.२४–२८ (संख्या), ८.३४–३५ (मेरु-प्रस्तारः) ;
-- हलायुधः (मेरु-व्याख्या) ।
------------------------------------------------------------------------

module PrastaraPankti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-comm)
open import PingalaPrastara using (sankhya ; meru)
open import PanktiYoga using (द्वि-घात ; पूर्व ; पङ्क्ति-योगः)
open import Dvipada using (C)

------------------------------------------------------------------------
-- संख्या-द्विघात — संख्या-प्रत्ययः पिङ्गलस्य 2ⁿ (द्वि-घात) एव (तुल्य-आवृत्ती) ।
------------------------------------------------------------------------

संख्या-द्विघात : (n : ℕ) → sankhya n ≡ द्वि-घात n
संख्या-द्विघात zero    = refl
संख्या-द्विघात (suc n) = cong₂ _+_ (संख्या-द्विघात n) (संख्या-द्विघात n)

------------------------------------------------------------------------
-- संख्या-पङ्क्तिः — संख्या-प्रत्ययः = मेरु-पङ्क्ति-योगः : sankhya n = ∑ₖ C(n,k) ।
------------------------------------------------------------------------

संख्या-पङ्क्तिः : (n : ℕ) → sankhya n ≡ पूर्व n n
संख्या-पङ्क्तिः n = संख्या-द्विघात n ∙ sym (पङ्क्ति-योगः n)

------------------------------------------------------------------------
-- मेरु-द्विपदः — पिङ्गल-हलायुधस्य मेरु-प्रत्ययः = द्विपद-सङ्ख्या C(n,k) ।
-- PingalaPrastara.meru (Chosen n k ≃ Fin(meru n k) : n-अक्षर-k-गुरु-छन्दांसि) च
-- Dvipada.C (पास्कल-आवृत्त्या) उभौ समौ — केवलं पास्कल-पदे योग-क्रम-व्यत्ययः
-- (+-comm) ।  अतः k-गुरु-छन्द-गणना यथार्थतः मेरु-सङ्ख्या C(n,k) एव ।
--
-- (Piṅgala–Halāyudha's meru pratyaya — the count of n-syllable metres with
-- exactly k guru, PingalaPrastara.meru via Chosen n k ≃ Fin(meru n k) — equals
-- the binomial C(n,k) (Dvipada, by Pascal), differing only by the order of the
-- two summands in the Pascal step.  So the guru-count fibre IS the binomial.)
------------------------------------------------------------------------

मेरु-द्विपदः : (n k : ℕ) → meru n k ≡ C n k
मेरु-द्विपदः zero    zero    = refl
मेरु-द्विपदः zero    (suc k) = refl
मेरु-द्विपदः (suc n) zero    = refl
मेरु-द्विपदः (suc n) (suc k) =
    cong₂ _+_ (मेरु-द्विपदः n (suc k)) (मेरु-द्विपदः n k)
  ∙ +-comm (C n (suc k)) (C n k)
