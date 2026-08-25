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
open import Cubical.Data.List using (length)
open import Mula.PingalaPrastara using (sankhya ; meru ; matra)
open import PanktiYoga using (द्वि-घात ; पूर्व ; पङ्क्ति-योगः)
open import Dvipada using (C)
open import Matramerus using (सर्व ; मात्रामेरु)
open import MeruKarna using (मेरु-कर्ण ; समता-कर्णः)

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
-- Dvipada.C (पार्श्वयोग-आवृत्त्या) उभौ समौ — केवलं पार्श्वयोग-पदे योग-क्रम-व्यत्ययः
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

------------------------------------------------------------------------
-- मात्रा-सर्वः — पिङ्गलस्य मात्रा-प्रत्ययः = विरहाङ्कस्य सर्ग-गणना (फिबोनाची) ।
-- PingalaPrastara.matra (Metre n ≃ Fin(matra n) : n-मात्रा-छन्दांसि) च
-- Matramerus.सर्व (length : विरहाङ्क-जननम्) उभौ तुल्य-द्वि-पद-आवृत्ती (M₀=M₁=१) ,
-- अतः matra n ≡ length(सर्व n) (द्वि-पद-आगमनेन) ।  एवं त्रयः प्रत्ययाः मूलिताः :
-- संख्या=2ⁿ, मेरु=C(n,k), मात्रा=सर्ग-गणना — पिङ्गलस्य त्रि-गणना कोश-सिद्धा ।
--
-- (Piṅgala's mātrā pratyaya — the count of n-mātrā metres, Metre n ≃ Fin(matra n)
-- — equals Virahāṅka's enumeration length(सर्व n): both the Fibonacci recurrence
-- with M₀=M₁=1, so matra n ≡ length(सर्व n) by two-step induction from मात्रामेरु.
-- With saṅkhyā=2ⁿ and meru=C(n,k), all three of Piṅgala's counting pratyayas are
-- now grounded in the corpus's explicit enumerations.)
------------------------------------------------------------------------

मात्रा-सर्वः : (n : ℕ) → matra n ≡ length (सर्व n)
मात्रा-सर्वः zero          = refl
मात्रा-सर्वः (suc zero)    = refl
मात्रा-सर्वः (suc (suc n)) =
    cong₂ _+_ (मात्रा-सर्वः (suc n)) (मात्रा-सर्वः n)
  ∙ sym (मात्रामेरु n)

------------------------------------------------------------------------
-- मात्रा-कर्णः — पिङ्गलस्य मात्रा-गणना = हलायुधस्य तिर्यक्-कर्णः (∑ₖ C(n−k,k)) ।
-- हलायुधः द्वे अकरोत् : छन्दांसि अगणयत् (matra), मेरोः तिर्यक्-रेखासु मात्रा-
-- सङ्ख्याः अपश्यत् (मेरु-कर्ण = ∑ₖ C(n−k,k)) ।  ते एके : matra n ≡ मेरु-कर्ण n ,
-- यत्र matra कोश-गणना (Metre n ≃ Fin(matra n)) , मेरु-कर्ण द्विपद-तिर्यक्-योगः ।
--
-- (Halāyudha did two things: counted the metres (matra) and read the mātrā-
-- counts off the shallow diagonals of the meru (मेरु-कर्ण = ∑ₖ C(n−k,k)).  They
-- are one — matra n ≡ मेरु-कर्ण n — the type-theoretic metre cardinality equal to
-- the binomial diagonal sum, through the enumeration length(सर्व n).)
------------------------------------------------------------------------

मात्रा-कर्णः : (n : ℕ) → matra n ≡ मेरु-कर्ण n
मात्रा-कर्णः n = मात्रा-सर्वः n ∙ sym (समता-कर्णः n)
