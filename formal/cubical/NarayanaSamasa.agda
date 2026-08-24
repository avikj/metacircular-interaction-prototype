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
-- नारायण-समास-सेतुः — नारायणस्य गो-सर्गः (बद्ध {१,३}-रचना) ≡ सामान्य-समास-मेरुः
-- अंश-गणे {१,३} (SamasaMeruN) : length-समता, त्रि-पद-आगमनेन ।
--
-- नारायणः "अङ्कपाशे" गो-सर्गं स्व-निर्मित-आवृत्त्या (एकः/त्रिः-सर्गेण) रचयति ;
-- सः एव सर्गः सामान्य-समास-भावनायाः अंश-गणे {१,३} (ps = 0 ∷ 2 ∷ []) उदेति ।
-- द्वौ वाहकौ — बद्धः च सामान्यः च — एकं तत्त्वम् : उभयोः length समाना, यतः
-- उभौ n-मात्रायाः {१,३}-समासान् गणयतः ।  समता प्रमाणेन, न साम्येन — यथा
-- MatraSamasa विरहाङ्के {१,२} (मात्रा-सर्ग ≡ समास-मेरु {१,२}) ; तत्र द्वि-पद-
-- आगमनम्, अत्र त्रि-पदम् (a(n+3)=a(n+2)+a(n) इति त्रि-वर्ष-ध्रौव्यात्) ।
--
-- (The bridge for Nārāyaṇa's cows: his bespoke gosarga — built by his own
--  {1,3} emanation (एकः / त्रिः steps) in Narayana.agda — has the SAME count
--  as the general samāsa-meru at part-set {1,3} (ps = [0,2]) in SamasaMeruN.
--  Two carriers, one tattva: a length equality, samatā pramāṇena — the exact
--  Nārāyaṇa analogue of MatraSamasa's Virahāṅka {1,2} bridge.  MatraSamasa
--  needed a two-term induction (Fibonacci); this needs a THREE-term one, the
--  cow-recurrence a(n+3)=a(n+2)+a(n) with the three-year maturation base.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module NarayanaSamasa where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Narayana using () renaming (सर्गः to गो-सर्गः ; नारायण-आवृत्तिः to गो-आवृत्तिः)
open import SamasaMeruN using (सर्गः ; नारायण-आवृत्तिः)

------------------------------------------------------------------------
-- समता — length(गो-सर्गः n) ≡ length(सर्गः {१,३} n) : त्रि-पद-आगमनेन ।
-- आधाराः a(0)=a(1)=a(2)=1 (त्रि-वर्ष-ध्रौव्यम्) ; पदे उभे आवृत्ती संयुज्येते ।
------------------------------------------------------------------------

समता : (n : ℕ) → length (गो-सर्गः n) ≡ length (सर्गः (0 ∷ 2 ∷ []) n)
समता zero                      = refl
समता (suc zero)                = refl
समता (suc (suc zero))          = refl
समता (suc (suc (suc n))) =
    गो-आवृत्तिः n
  ∙ cong₂ _+_ (समता (suc (suc n))) (समता n)
  ∙ sym (नारायण-आवृत्तिः n)
