{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मात्रा-सेतुः — विरहाङ्कस्य मात्रा-तन्तुः पिङ्गलस्य मात्रा-वृत्ते सेतुना
-- Fin (matra n) इति गण्यते ।
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् ८.२४–२८ (मात्रामेरु-प्रस्तारः) ;
--            विरहाङ्कः, वृत्तजातिसमुच्चयः (c. 600–800 CE) ; हलायुधः
--            (मृतसञ्जीवनी, मेरु-व्याख्या) ।
--
-- THE GAP THIS CLOSES.  Two modules in this corpus each hold half of the
-- mātrā story and never touched:
--
--   Virahanka_….agda  proves the RECURRENCE on its own fibre —
--       fiber छन्दः (2+n) ≃ fiber छन्दः (1+n) ⊎ fiber छन्दः n
--     over `List Bool` weighted मात्रा(true)=1, मात्रा(false)=2, and
--     states in its header, in as many words, "No count and no closed
--     form is proved here."
--
--   PingalaPrastara.agda  proves the CLOSED FORM —
--       matraCount : Metre n ≃ Fin (matra n)
--     over `Pattern = List Syllable` weighted mora(laghu)=1,
--     mora(guru)=2, but for its OWN encoding, not विरहाङ्क's.
--
-- The two encodings are the same object read through two alphabets
-- (true↔laghu, false↔guru), and the two counting maps agree on the nose.
-- So the missing edge is a single bridge of fibres,
--     fiber छन्दः n ≃ Metre n,
-- built from the alphabet identification and the fact that both fibre
-- witnesses are propositions (ℕ is a set).  COMPOSING that bridge with
-- PingalaPrastara.matraCount — the corpus's own equivalence, transported
-- through, not re-proved — supplies exactly the count विरहाङ्क declined:
--     fiber छन्दः n ≃ Fin (matra n).
--
-- This is विवेकसेतु's move ("the two remainder records are one pair and
-- therefore each other") in the mātrā register: not a new count, a
-- welding of two records the census had listed as separate.
--
-- WHAT IS AND IS NOT CLAIMED.  विरहाङ्क did not write `Fin`, and the
-- closed form `matra` counted here is Piṅgala's मात्रामेरु procedure, not
-- विरहाङ्क's; the naming honours whose fibre and whose count each half is.
-- Nothing new about `matra` is proved — it is imported and its
-- equivalence transported.  What is new is the identification of the two
-- fibres, and hence the count for विरहाङ्क's encoding.
--
-- CHECKED: Agda 2.8.0 + cubical, --safe, no postulate/sorry/hole, exit 0.
------------------------------------------------------------------------

module Mula.MatraSetu_TheVirahankaFibreCountsAsFinByBridgingToPingalasMetre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; compIso)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Fin using (Fin)

open import Mula.Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence using (छन्दः)
open import Mula.PingalaPrastara
  using (Syllable ; laghu ; guru ; Pattern ; mora ; matraOf ; Metre
        ; matra ; matraCount)

open Iso

------------------------------------------------------------------------
-- §१  The alphabet identification — true↔laghu, false↔guru — mapped over
--     the two list encodings, with both round-trips.
------------------------------------------------------------------------

प्रति : Bool → Syllable
प्रति true  = laghu
प्रति false = guru

बूल : Syllable → Bool
बूल laghu = true
बूल guru  = false

वर्ण-सूची : List Bool → Pattern
वर्ण-सूची []       = []
वर्ण-सूची (x ∷ xs) = प्रति x ∷ वर्ण-सूची xs

बूल-सूची : Pattern → List Bool
बूल-सूची []       = []
बूल-सूची (s ∷ p)  = बूल s ∷ बूल-सूची p

प्रति-बूल : (s : Syllable) → प्रति (बूल s) ≡ s
प्रति-बूल laghu = refl
प्रति-बूल guru  = refl

बूल-प्रति : (x : Bool) → बूल (प्रति x) ≡ x
बूल-प्रति true  = refl
बूल-प्रति false = refl

सूची-प्रत्यावृत्तिः : (l : List Bool) → बूल-सूची (वर्ण-सूची l) ≡ l
सूची-प्रत्यावृत्तिः []       = refl
सूची-प्रत्यावृत्तिः (x ∷ xs) = cong₂ _∷_ (बूल-प्रति x) (सूची-प्रत्यावृत्तिः xs)

सूची-निवृत्तिः : (p : Pattern) → वर्ण-सूची (बूल-सूची p) ≡ p
सूची-निवृत्तिः []      = refl
सूची-निवृत्तिः (s ∷ p) = cong₂ _∷_ (प्रति-बूल s) (सूची-निवृत्तिः p)

------------------------------------------------------------------------
-- §२  The two counting maps agree, on the nose, under the alphabet
--     identification.  मात्रा(true)=1=mora(laghu), मात्रा(false)=2=mora(guru).
------------------------------------------------------------------------

मात्रा-तुल्यम् : (l : List Bool) → matraOf (वर्ण-सूची l) ≡ छन्दः l
मात्रा-तुल्यम् []           = refl
मात्रा-तुल्यम् (true  ∷ xs) = cong (1 +_) (मात्रा-तुल्यम् xs)
मात्रा-तुल्यम् (false ∷ xs) = cong (2 +_) (मात्रा-तुल्यम् xs)

छन्दस्-तुल्यम् : (p : Pattern) → छन्दः (बूल-सूची p) ≡ matraOf p
छन्दस्-तुल्यम् []          = refl
छन्दस्-तुल्यम् (laghu ∷ p) = cong (1 +_) (छन्दस्-तुल्यम् p)
छन्दस्-तुल्यम् (guru  ∷ p) = cong (2 +_) (छन्दस्-तुल्यम् p)

------------------------------------------------------------------------
-- §३  The bridge of fibres.  The witness of each fibre is a proposition
--     (ℕ is a set), so the round-trips need only the list round-trips.
------------------------------------------------------------------------

सेतुः : (n : ℕ) → Iso (fiber छन्दः n) (Metre n)
fun (सेतुः n) (l , p) = वर्ण-सूची l , (मात्रा-तुल्यम् l ∙ p)
inv (सेतुः n) (p , e) = बूल-सूची p , (छन्दस्-तुल्यम् p ∙ e)
rightInv (सेतुः n) (p , e) = Σ≡Prop (λ _ → isSetℕ _ _) (सूची-निवृत्तिः p)
leftInv  (सेतुः n) (l , p) = Σ≡Prop (λ _ → isSetℕ _ _) (सूची-प्रत्यावृत्तिः l)

-- the identification the census had listed as two records
मात्रा-सेतुः : (n : ℕ) → fiber छन्दः n ≃ Metre n
मात्रा-सेतुः n = isoToEquiv (सेतुः n)

------------------------------------------------------------------------
-- §४  The payoff.  Compose the bridge with Piṅgala's own मात्रामेरु count
--     (matraCount, transported, not re-proved) to give विरहाङ्क's fibre
--     the closed form his module declined to prove.
------------------------------------------------------------------------

विरहाङ्क-गणना : (n : ℕ) → fiber छन्दः n ≃ Fin (matra n)
विरहाङ्क-गणना n = isoToEquiv (compIso (सेतुः n) (matraCount n))
