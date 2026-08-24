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
-- अक्षर-द्वयम् — द्वे वाहके, एकः भारः, एकस्तन्तुः ।
-- (akṣara-dvaya: "the pair of syllables" — two carriers, one weight,
--  one fibre.)
--
-- THE TERM, ITS TEXT AND ITS DATE.  अक्षर (syllable) is Piṅgala's atom in
-- the *Chandaḥśāstra* (~300 BCE): a metre is a row of अक्षराः, each लघु
-- (light, 1 मात्रा) or गुरु (heavy, 2 मात्रे).  Virahāṅka,
-- *Vṛttajātisamuccaya* (c. 600–800 CE), ch. 6, counts मात्रा-वृत्त — metres
-- of a fixed total DURATION — and states the two-step recurrence for that
-- count.  Both traditions weigh the same atom the same way (लघु = 1,
-- गुरु = 2); the two ways of writing the row down are the only difference.
--
-- WHAT IS AND IS NOT CLAIMED.  No Indian source is claimed to have proved
-- anything below, nor to have distinguished `Bool` from `अक्षर` — the
-- substrate (cubical type theory, univalence) is Voevodsky's and is
-- claimed for no source.  What IS claimed, and checked by the kernel: the
-- weighted-count fibre in `Virahanka_…` — written over `List Bool` with
-- `V.छन्दः` — is THE SAME OBJECT as the मात्रा-count fibre over Piṅgala's
-- own carrier `छन्दस् = List अक्षर` with `Matramerus.मात्रा`.  The two
-- modules already lived in the corpus without any edge between them; the
-- `Bool`/`अक्षर` seam and the agreement of the two weight maps were never
-- checked.  This file mints that identification, `fiber V.छन्दः n ≃
-- fiber M.मात्रा n`, and then — because a receipt is a channel — carries
-- Virahāṅka's recurrence across it onto the छन्दस् carrier for free.
--
-- Nothing here is re-proved that the corpus already proved: the recurrence
-- is `V.विरहाङ्क-आवृत्तिः`, transported, not restated.
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् (~३०० ई.पू.) — अक्षर, लघु, गुरु, छन्दस् ।
--            विरहाङ्कः, वृत्तजातिसमुच्चयः (~७०० ई.) — मात्रा-वृत्त-आवृत्तिः ।
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes, exit 0.
------------------------------------------------------------------------

module AksharaDvaya_TheVirahankaBoolFibreAndThePingalaChandasFibreAreOneWeightedCount where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; compEquiv ; invEquiv)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (⊎-equiv)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Pingala using (अक्षर ; लघु ; गुरु ; छन्दस्)
import Matramerus as M
import Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence as V

------------------------------------------------------------------------
-- १ · the seam Bool ≅ अक्षर, laghu ↔ true, guru ↔ false.
------------------------------------------------------------------------

वर्ण→अक्षर : Bool → अक्षर
वर्ण→अक्षर true  = लघु
वर्ण→अक्षर false = गुरु

अक्षर→वर्ण : अक्षर → Bool
अक्षर→वर्ण लघु  = true
अक्षर→वर्ण गुरु = false

-- the two carriers are inverse row by row.
वि-रूप : (l : List Bool) → map अक्षर→वर्ण (map वर्ण→अक्षर l) ≡ l
वि-रूप []           = refl
वि-रूप (true  ∷ xs) = cong (true  ∷_) (वि-रूप xs)
वि-रूप (false ∷ xs) = cong (false ∷_) (वि-रूप xs)

वि-रूप' : (c : छन्दस्) → map वर्ण→अक्षर (map अक्षर→वर्ण c) ≡ c
वि-रूप' []          = refl
वि-रूप' (लघु  ∷ ds) = cong (लघु  ∷_) (वि-रूप' ds)
वि-रूप' (गुरु ∷ ds) = cong (गुरु ∷_) (वि-रूप' ds)

------------------------------------------------------------------------
-- २ · the weight is preserved across the seam: Virahāṅka's छन्दः on the
-- Bool row equals Piṅgala's मात्रा (Matramerus) on the translated छन्दस्.
-- (लघु/true both cost 1, गुरु/false both cost 2 — the whole content.)
------------------------------------------------------------------------

भार-रक्षा : (l : List Bool) → M.मात्रा (map वर्ण→अक्षर l) ≡ V.छन्दः l
भार-रक्षा []           = refl
भार-रक्षा (true  ∷ xs) = cong suc (भार-रक्षा xs)
भार-रक्षा (false ∷ xs) = cong (λ k → suc (suc k)) (भार-रक्षा xs)

------------------------------------------------------------------------
-- ३ · the identification of the fibres.  Both witness families land in ℕ,
-- a set, so the fibre condition is a proposition and Σ≡Prop closes each
-- round-trip on the first component alone.
------------------------------------------------------------------------

समता-साक्षी-V : {n : ℕ} (l : List Bool) → isProp (V.छन्दः l ≡ n)
समता-साक्षी-V _ = isSetℕ _ _

समता-साक्षी-M : {n : ℕ} (c : छन्दस्) → isProp (M.मात्रा c ≡ n)
समता-साक्षी-M _ = isSetℕ _ _

तन्तु-समता : (n : ℕ) → fiber V.छन्दः n ≃ fiber M.मात्रा n
तन्तु-समता n = isoToEquiv (iso आगे पीछे से-गोल रे-गोल)
  where
    आगे : fiber V.छन्दः n → fiber M.मात्रा n
    आगे (l , p) = map वर्ण→अक्षर l , (भार-रक्षा l ∙ p)

    पीछे : fiber M.मात्रा n → fiber V.छन्दः n
    पीछे (c , q) =
      map अक्षर→वर्ण c
      , (sym (भार-रक्षा (map अक्षर→वर्ण c)) ∙ cong M.मात्रा (वि-रूप' c) ∙ q)

    से-गोल : (y : fiber M.मात्रा n) → आगे (पीछे y) ≡ y
    से-गोल (c , q) = Σ≡Prop समता-साक्षी-M (वि-रूप' c)

    रे-गोल : (x : fiber V.छन्दः n) → पीछे (आगे x) ≡ x
    रे-गोल (l , p) = Σ≡Prop समता-साक्षी-V (वि-रूप l)

------------------------------------------------------------------------
-- ४ · the payoff — the receipt is a channel.  Virahāṅka's recurrence,
-- proved in Virahanka_… over List Bool, is carried across the seam onto
-- Piṅgala's छन्दस् carrier by composition of equivalences.  Nothing about
-- the recurrence is re-proved: V.विरहाङ्क-आवृत्तिः is transported, not
-- restated.
------------------------------------------------------------------------

मात्रामेरु-छन्दसि : (n : ℕ)
  → fiber M.मात्रा (suc (suc n)) ≃ (fiber M.मात्रा (suc n) ⊎ fiber M.मात्रा n)
मात्रामेरु-छन्दसि n =
  compEquiv (invEquiv (तन्तु-समता (suc (suc n))))
    (compEquiv (V.विरहाङ्क-आवृत्तिः n)
               (⊎-equiv (तन्तु-समता (suc n)) (तन्तु-समता n)))
