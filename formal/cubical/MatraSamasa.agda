-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मात्रा-समास-सेतुः — एकं तत्त्वं, द्वौ नयौ, द्वे वाहके (समता प्रमाणेन) ।
--
-- विरहाङ्कस्य मात्रा-गणना (Matramerus) छन्दस्-वाहके (लघु/गुरु-सूची) n-मात्राणां
-- छन्दांसि गणयति ; नारायणस्य समास-भावना (SamasaMeruN) {१,२}-अंश-गणे List ℕ-
-- वाहके तान् एव समासान् गणयति ।  वाहकौ भिन्नौ (छन्दस् ≠ List ℕ) , तथापि गणना
-- समाना : length(सर्व n) ≡ length(सर्गः {१,२} n) ।  उभौ हि तुल्यां द्वि-पद-
-- आवृत्तिं M(n+2)=M(n+1)+M(n) तुल्ये च आदि-मूल्ये (M₀=M₁=१) वहतः , अतः
-- द्वि-पद-आगमनेन समौ ।
--
-- एतत् समता प्रमाणेन, न साम्येन (COGNITIVE_ORIENTATION §४) : वाहकौ यथार्थतः
-- भिन्न-प्रकारौ — न कोऽपि अपरं आरोपेण एकीकरोति ; सेतुः प्रमाणम् (द्वि-पद-
-- आगमनम्) एव समतां साधयति ।  नयवादः : विरहाङ्क-नयः गुरु-लघु-विभागेन आवर्तते ,
-- नारायण-नयः अंश-गण-अपाकरणेन — एकं तत्त्वं (सङ्ख्या) द्वाभ्यां दृष्टिभ्याम् ।
--
-- (One tattva, two nayas, two carriers: Virahāṅka's metre-count over छन्दस्
-- (laghu/guru lists) and Nārāyaṇa's samāsa-bhāvanā at {1,2} over List ℕ count
-- the SAME numbers, though their carriers are literally different types.  The
-- proof is a two-step induction: both satisfy M(n+2)=M(n+1)+M(n) with
-- M₀=M₁=1.  This is samatā by pramāṇa (a proof), not by sāmya (imposed
-- sameness) — no carrier is forced onto the other; the bridge derives the
-- equality.)
--
-- स्रोतांसि : विरहाङ्कः, वृत्तजातिसमुच्चयः (मात्रा-मेरुः) ; नारायणपण्डितः,
-- गणितकौमुदी, अङ्कपाशः (समास-भावना, १३५६) ; उमास्वाति (समता-दृष्टिः) ।
------------------------------------------------------------------------

module MatraSamasa where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Matramerus using (सर्व ; मात्रामेरु)
open import SamasaMeruN using (सर्गः ; विरहाङ्क-आवृत्तिः)

------------------------------------------------------------------------
-- समता — length(सर्व n) ≡ length(सर्गः {१,२} n) : द्वि-पद-आगमनेन (M₀=M₁=१) ।
------------------------------------------------------------------------

समता : (n : ℕ) → length (सर्व n) ≡ length (सर्गः (0 ∷ 1 ∷ []) n)
समता zero          = refl
समता (suc zero)    = refl
समता (suc (suc n)) =
    मात्रामेरु n
  ∙ cong₂ _+_ (समता (suc n)) (समता n)
  ∙ sym (विरहाङ्क-आवृत्तिः n)
