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
-- आकाश — space is accommodation (avagāhana): non-exclusive, and strictly
-- exceeding the cosmos, so there is room where nothing moves.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra*, adhyāya 5 (~2nd–5th c.):
--   5.18  ākāśasyāvagāhaḥ — the function of ākāśa is avagāha, the GIVING
--         OF ROOM.
--   5.12  dharmādharmayoḥ kṛtsne — dharma and adharma pervade the whole
--         loka and only the loka; so lokākāśa is finite and alokākāśa
--         (5.9, ananta-pradeśa) is the infinite empty remainder.
--   Distinctive doctrine (the lamp-in-a-room; pratighāta-abhāva): ākāśa
--         accommodates WITHOUT EXCLUSION — many occupy one region, subtle
--         bodies interpenetrate.  ākāśa is niṣkriya, arūpī, and ONE.
--
-- WHAT IS PROVED (over an abstract ākāśa `P`, entities `E`, occupancy
-- `At : E → P → Type`, and lokākāśa `loka` — the last a proposition,
-- which IS niṣkriya + arūpī + oneness: membership carries no datum):
--
--   §2  अवगाहः-न-वारणम् — accommodation is NOT exclusion.  Two distinct
--       entities at one point make "who is here" not a proposition: a
--       pradeśa holds more than one.  Impenetrability refuted (the lamp).
--   §3  लोकः-आकाशात्-न्यूनः — the cosmos is strictly inside space.  If
--       aloka is inhabited (5.9), ākāśa has a point the loka lacks; and
--       that point is outside the medium of motion (dharma pervades only
--       the loka, 5.12), so — by `DharmaAdharma.अलोकः-अगम्यः`, cited — no
--       motion reaches it.  Space gives room even where nothing can move.
--   §4  आकाशं-निष्क्रियम् — space gives locus and adds no data (as dharma).
--
-- WHAT IS **NOT** CLAIMED.  Doctrine is Umāsvāti's; theorems are cubical
-- type theory.  The infinitude of alokākāśa is the HYPOTHESIS "aloka
-- inhabited", not built (its ananta is `JainSankhya`'s object).  The
-- no-motion consequence is `DharmaAdharma`'s theorem, cited not re-proved.
-- avagāha's geometry (which point holds which, the loka's finite pradeśa
-- total) is not modelled; only non-exclusion, the strict containment, and
-- niṣkriya are checked.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Akasha_SpaceIsAccommodationItIsNonExclusiveAndStrictlyExceedsTheCosmosSoThereIsRoomWhereNothingMoves where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  Space, entities, occupancy, lokākāśa.
------------------------------------------------------------------------

record Akasha (P : Type ℓ) : Type (ℓ-suc ℓ) where
  field
    E    : Type ℓ                          -- entities that occupy space
    At   : E → P → Type ℓ                  -- e occupies point p
    loka : P → Type ℓ                      -- lokākāśa: where the media reach
    isPropLoka : (x : P) → isProp (loka x) -- niṣkriya, arūpī, ONE (data-free)

module _ {P : Type ℓ} (A : Akasha P) where
  open Akasha A

  अवगाहः : P → Type ℓ                       -- the occupants of a point
  अवगाहः p = Σ E (λ e → At e p)

  ------------------------------------------------------------------------
  -- §2  अवगाहः-न-वारणम् — accommodation is not exclusion.
  ------------------------------------------------------------------------

  अवगाहः-न-वारणम् : (p : P) (e₀ e₁ : E)
                  → At e₀ p → At e₁ p → ¬ (e₀ ≡ e₁)
                  → ¬ (isProp (अवगाहः p))
  अवगाहः-न-वारणम् p e₀ e₁ a₀ a₁ e₀≢e₁ pr =
    e₀≢e₁ (cong fst (pr (e₀ , a₀) (e₁ , a₁)))

  ------------------------------------------------------------------------
  -- §3  लोकः-आकाशात्-न्यूनः — the cosmos is strictly inside space.
  --     The witness of the containment IS a point of aloka: ākāśa has a
  --     place the loka lacks.  (No-motion there is DharmaAdharma's, cited.)
  ------------------------------------------------------------------------

  लोकः-आकाशात्-न्यूनः : Σ P (λ p → ¬ (loka p)) → Σ P (λ p → ¬ (loka p))
  लोकः-आकाशात्-न्यूनः alokaInhabited = alokaInhabited

  -- and the point is genuinely NOT in the loka — the containment is strict
  न्यूनता-दृढा : (w : Σ P (λ p → ¬ (loka p))) → ¬ (loka (fst w))
  न्यूनता-दृढा w = snd w

  ------------------------------------------------------------------------
  -- §4  आकाशं-निष्क्रियम् — space gives locus, adds no data.
  ------------------------------------------------------------------------

  आकाशं-निष्क्रियम् : (p : P) (u v : loka p) → u ≡ v
  आकाशं-निष्क्रियम् p = isPropLoka p
