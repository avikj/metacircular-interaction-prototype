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
-- सेतु-प्रमाणम् — the second seam ford: विवेक-प्रमाण ≡ ℕ.
--
-- WHY, measured.  In notes/tirtha/SetuSnapshot.tsv the bank
-- `⟨ambig⟩.विवेक-प्रमाण` heads a 7-bank component (the रात्रि census bases)
-- SEPARATE from the 13-bank component holding ℕ, विवेक, छन्दस् — even though
-- `VivekaPramana…ℕ×ℕ≡विवेक-प्रमाण` was already landed.  The split is partly
-- an artifact of ambiguous naming in the snapshot, and partly real: no
-- checked term joined विवेक-प्रमाण to ℕ itself.  This file supplies that
-- term, so the join no longer rests on name-resolution.  Joining 7 to 13
-- is +91 free crossings — the largest merge available on the board.
--
-- The content is one composition.  VivekaPramana pays ℕ×ℕ ≃ विवेक-प्रमाण;
-- SetuYugma pays (ℕ×ℕ) ≃ ℕ; the composite is free — भावना, again: two
-- landed solutions meet, the third arises, all three survive.
--
-- No source claimed; the compound सेतु-प्रमाण is built here, 2026-08-23.
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
