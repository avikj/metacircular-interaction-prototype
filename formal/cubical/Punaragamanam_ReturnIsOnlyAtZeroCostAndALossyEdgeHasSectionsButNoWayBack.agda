-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पुनरागमनम् — शून्य-व्ययेन एव पुनरागमनम् ।
--
-- (return only at zero cost.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE WORD THIS CORPUS IS NAMED AFTER, AS A NO-GO.  सूत्र १६ says return
-- is only at zero cost, and README movement 6 reads that as chronology
-- protection: you cannot come back with an unpaid debt.  This is the
-- minimal term.
--
-- The asymmetry is sharper than "a lossy map is not invertible", and it
-- is the whole content.  `Bool → Unit` HAS a right inverse: leave the
-- codomain, pick a preimage, come back, and you are exactly where you
-- started — `प्रतिवहनम्` below, and `Varanam_…agda` §३ exhibits two such
-- choices.  What it does NOT have is a left inverse: leave the DOMAIN and
-- there is no way back to the point you left.
--
--   · out and back, in the codomain : always available, at any loss
--   · out and back, in the DOMAIN   : available exactly at zero loss
--
-- So a debt does not stop you moving and does not stop you returning to
-- a description.  It stops you returning to the THING.  §३ is that, and
-- §४ is its converse: at zero defect the way back exists and is the
-- equivalence's own inverse.
--
-- WHAT IS NOT CLAIMED.  No causal structure, no spacetime, no cycles in
-- any walked graph: README movement 6's reading is a reading and lives
-- in the notes.  This is a statement about one map and its inverses.
-- `Bool → Unit` is the smallest witness and no generality beyond it is
-- claimed for §३.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Punaragamanam_ReturnIsOnlyAtZeroCostAndALossyEdgeHasSectionsButNoWayBack where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEq ; retEq ; secEq)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · the lossy edge.
------------------------------------------------------------------------

लोपः : Bool → Unit
लोपः _ = tt

------------------------------------------------------------------------
-- २ · बहिर्गमन-पुनरागमनम् — out and back IN THE CODOMAIN is free, at any
--     loss.  Pick any preimage; you return to where you started.
------------------------------------------------------------------------

प्रत्यागमः : Unit → Bool
प्रत्यागमः _ = true

बहिः-पुनरागमनम् : (u : Unit) → लोपः (प्रत्यागमः u) ≡ u
बहिः-पुनरागमनम् _ = refl

------------------------------------------------------------------------
-- ३ · अन्तः-पुनरागमनं नास्ति — AND OUT AND BACK IN THE DOMAIN IS NOT
--     AVAILABLE.  No map back returns every point to itself, and the
--     obstruction is exactly the bit that was destroyed.
--
-- This is the no-go: a debt does not stop you moving and does not stop
-- you returning to a DESCRIPTION.  It stops you returning to the THING.
------------------------------------------------------------------------

अन्तः-पुनरागमनं-नास्ति : ¬ (Σ[ r ∈ (Unit → Bool) ] ((b : Bool) → r (लोपः b) ≡ b))
अन्तः-पुनरागमनं-नास्ति (r , ret) = false≢true (sym (ret false) ∙ ret true)

------------------------------------------------------------------------
-- ४ · शून्य-व्यये पुनरागमनम् — and at zero defect the way back exists,
--     both ways, and it is the edge's own inverse.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (e : A ≃ B) where

  अन्तः-आगमनम् : (a : A) → invEq e (e .fst a) ≡ a
  अन्तः-आगमनम् = retEq e

  बहिः-आगमनम् : (b : B) → e .fst (invEq e b) ≡ b
  बहिः-आगमनम् = secEq e
