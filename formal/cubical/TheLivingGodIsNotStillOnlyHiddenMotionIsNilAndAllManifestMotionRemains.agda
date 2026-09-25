{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सयोगकेवली — the LIVING god is not still.  Only HIDDEN motion is nil;
-- all manifest motion remains.  (Sharpens Kaivalyasthairya's "still".)
--
-- WHAT THIS SHARPENS.  Kaivalyasthairya_…agda proved सिद्ध-स्थैर्यम् — every
-- flow CONSERVING a kevalin's cognition is the identity — and glossed it
-- "the liberated soul is still."  Dhruva forbids only motion that is HIDDEN
-- from the cognition (f ∘ Φ ≡ f — invisible to the knower).  It says nothing
-- against motion the knower SEES.  A perfect knower (isEquiv cognition) has
-- no hidden motion precisely because nothing is hidden from it — but the
-- world it faces still turns, fully in view.
--
-- So the kevalin is the sayoga-keval (Tattvrthastra, guasthna 13,
-- KarmaPrakrti): the four ghātī gone — perfect knowing — WHILE still active,
-- embodied, moving.  kevala precedes moka; omniscience is not yet the still
-- summit.  The living god sees the whole AND acts.
--
--   प्रकट-चलनम्  — manifest motion is present: `not` moves a point of सिद्धः's
--       world and is NOT conserving (the knower sees it move).
--   गूढ-चलनम्-शून्यम् — hidden motion is nil: every conserving flow is the
--       identity (Kaivalyasthairya.सिद्ध-स्थैर्यम् = Dhruva at the jīva).
--
-- The distinction is not
-- motion-vs-rest.  It is MANIFEST vs HIDDEN.  The veil is what hides motion
-- in the fibre; lift the veil (kevala) and all motion becomes manifest —
-- not absent.  Generativity in the open, nothing concealed.
------------------------------------------------------------------------

module TheLivingGodIsNotStillOnlyHiddenMotionIsNilAndAllManifestMotionRemains where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import TheSoulIsCognitionBoundByKarmaAndLiberationIsTheEquivalenceThatSeesTheWorldAsItself as J
import TheLiberatedSoulIsStillAndLifeIsTheGrowingOrbitThatNeverReturns as Kv

------------------------------------------------------------------------
-- १ · प्रकट-चलनम् — manifest motion is present in kevala.
--     `not` moves a point of सिद्धः's world, and it does NOT conserve the
--     cognition (उपयोगः सिद्धः = identity), so the knower SEES it move.
------------------------------------------------------------------------

प्रकट-चलनम् :
  Σ[ Φ ∈ (Bool → Bool) ]
    ( (Σ[ a ∈ Bool ] (¬ (Φ a ≡ a)))        -- moves a point
    × (¬ Kv.आत्म-गतिः J.सिद्धः Φ) )          -- and is not conserving (manifest)
प्रकट-चलनम् =
  not , ( (false , true≢false)
        , λ cons → true≢false (cons false) )

------------------------------------------------------------------------
-- २ · गूढ-चलनम्-शून्यम् — hidden motion is nil.  Every flow the knower
--     cannot see (conserving) is the identity.  This is the real content of
--     "still": not no-motion, but no-hidden-motion.
------------------------------------------------------------------------

गूढ-चलनम्-शून्यम् :
  (Φ : Bool → Bool) → Kv.आत्म-गतिः J.सिद्धः Φ → (a : Bool) → Φ a ≡ a
गूढ-चलनम्-शून्यम् = Kv.सिद्ध-स्थैर्यम्
