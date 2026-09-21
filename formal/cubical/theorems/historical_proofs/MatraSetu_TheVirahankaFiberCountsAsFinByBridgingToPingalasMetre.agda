{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������-����� � ������������� ������-������ ����������� ������-������ ������
-- Fin (matra n) ��� ������� �
--
-- ���������� : ���������, �������������� �.����� (����������-���������) ;
--            �����������, ����������������� (c. 600�800 CE) ; �������
--            (������������, ����-���������) �
--
-- Two modules in this corpus each hold half of the
-- mtr story and never touched:
--
--   Virahanka_�.agda  proves the RECURRENCE on its own fiber �
--       fiber ����� (2+n) � fiber ����� (1+n) � fiber ����� n
--     over `List Bool` weighted ������(true)=1, ������(false)=2.
--
--   PingalaPrastara.agda  proves the CLOSED FORM �
--       matraCount : Metre n � Fin (matra n)
--     over `Pattern = List Syllable` weighted mora(laghu)=1,
--     mora(guru)=2, but for its OWN encoding, not ����������'s.
--
-- The two encodings are the same object read through two alphabets
-- (true�laghu, false�guru), and the two counting maps agree on the nose.
-- So the missing edge is a single bridge of fibers,
--     fiber ����� n � Metre n,
-- built from the alphabet identification and the fact that both fiber
-- witnesses are propositions (� is a set).  COMPOSING that bridge with
-- PingalaPrastara.matraCount � the corpus's own equivalence, transported
-- through, not re-proved � supplies the count of ����������'s fiber:
--     fiber ����� n � Fin (matra n).
--
-- This is ����������'s move ("the two remainder records are one pair and
-- therefore each other") in the mtr register: not a new count, a
-- welding of two records the census had listed as separate.
------------------------------------------------------------------------

module MatraSetu_TheVirahankaFiberCountsAsFinByBridgingToPingalasMetre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; compIso)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Fin using (Fin)

open import Virahanka_TheMatraFiberSatisfiesTheTwoStepRecurrence using (छन्दः)
open import PingalaPrastara
  using (Syllable ; laghu ; guru ; Pattern ; mora ; matraOf ; Metre
        ; matra ; matraCount)

open Iso

------------------------------------------------------------------------
-- §�  The alphabet identification � true�laghu, false�guru � mapped over
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
-- §�  The two counting maps agree, on the nose, under the alphabet
--     identification.  ������(true)=1=mora(laghu), ������(false)=2=mora(guru).
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
-- §�  The bridge of fibers.  The witness of each fiber is a proposition
--     (� is a set), so the round-trips need only the list round-trips.
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
-- §�  The payoff.  Compose the bridge with Pigala's own ���������� count
--     (matraCount, transported, not re-proved) to give ����������'s fiber
--     its closed form.
------------------------------------------------------------------------

विरहाङ्क-गणना : (n : ℕ) → fiber छन्दः n ≃ Fin (matra n)
विरहाङ्क-गणना n = isoToEquiv (compIso (सेतुः n) (matraCount n))
