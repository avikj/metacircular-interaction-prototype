{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����-�������� � the second seam ford: ������-������ ≡ �.
--
-- The content is one composition.  VivekaPramana pays ╗� � ������-������;
-- SetuYugma pays (╗�) � �; the composite is free � �����, again: two
-- landed solutions meet, the third arises, all three survive.
------------------------------------------------------------------------

module SetuPramana_TheAmbiguousNameHidTheFordAndTheRemainderLawIsAlsoTheNaturals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_)

open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats
  using (विवेक-प्रमाण ; isoℕ×ℕ-विवेक-प्रमाण)
open import SetuYugma_TheSeamFordJoinsTheValliToPingalaAndVivekaIsTheNaturalNumbers
  using (युग्म≃ℕ)

विवेक-प्रमाण≃ℕ : विवेक-प्रमाण ≃ ℕ
विवेक-प्रमाण≃ℕ = compEquiv (invEquiv (isoToEquiv isoℕ×ℕ-विवेक-प्रमाण)) युग्म≃ℕ

विवेक-प्रमाण≡ℕ : विवेक-प्रमाण ≡ ℕ
विवेक-प्रमाण≡ℕ = ua विवेक-प्रमाण≃ℕ
