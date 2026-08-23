{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विलोपः — the annihilation is exactly a FAILURE OF CHOICE, and that is why
-- cost cannot compose.
--
-- One level under `DesaSanghata_…NotAGradedMonoid` (this corpus, today).
-- That file proved cost is not a graded monoid and wrote, in its §६ दोषलेख,
-- that no census-to-census composition function exists because "the outcome
-- depends on WHICH point of the outer fibre carries the empty inner fibre,
-- and a census records only that the outer fibre is crowded."  True, and it
-- leaves open what the missing datum IS.  It is a SECTION, and its absence
-- is not incidental — it is the mechanism.
--
-- THE STATEMENT.  `शेष-सङ्घातः` says the composite's fibre is the TOTAL SPACE
-- of the inner fibres over the outer fibre.  So the cancellation asks: when
-- is a total space contractible over a base that is not?  Answer, §२:
--
--     विलोपः :  isContr (Σ B P)  →  ¬ isContr B  →  ¬ ((b : B) → P b)
--
-- If a section existed, `fst` would split, B would be a retract of the total
-- space, and a retract of a contractible type is contractible.  So the
-- annihilation FORCES a point of the outer fibre with no inner point over
-- it.  विकलादेश above collapses to सकलादेश below exactly when choice fails.
--
-- WHY THAT IS THE FLOOR OF THIS LANE.  A census is pointwise data.  A
-- section is not pointwise data — its existence is a global fact about the
-- family, recoverable from no amount of per-point information.  So
-- DesaSanghata's §६ is not a gap in that file; it is a theorem about all
-- possible cost models here: composing costs would require choosing, the
-- corpus refuses choice (no Dec, no Bool, no decision anywhere in the core),
-- and the very failure it refuses to paper over is what makes losses cancel.
--
-- §३ turns it around into the positive form actually used for routing: a
-- section is exactly what makes the composite's cost the OUTER cost, and
-- §४ gives the converse direction as the honest limit.
--
-- No source is claimed; this is elementary type theory.  विलोप is Pāṇinian
-- (लोपः, 1.1.60 अदर्शनं लोपः — non-appearance) and is used here for the
-- deletion of outer points by downstream emptiness, which is what the word
-- means.  The compound is built here, 2026-08-22.
------------------------------------------------------------------------

module Vilopa_TheAnnihilationIsExactlyAFailureOfChoiceOverTheOuterFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · A retract of a contractible type is contractible.  Stated here in the
-- one form needed: if `fst` splits, the base inherits contractibility.
------------------------------------------------------------------------

छेद-सङ्कोचः : {B : Type ℓ} {P : B → Type ℓ'}
            → ((b : B) → P b)
            → isContr (Σ B P) → isContr B
fst (छेद-सङ्कोचः s c)   = fst (fst c)
snd (छेद-सङ्कोचः s c) b = cong fst (snd c (b , s b))

------------------------------------------------------------------------
-- २ · विलोपः — the annihilation forces a deleted point.
--
-- If the total space collapses to a point while the base does not, then no
-- section exists: some point of the base has an EMPTY fibre over it.  The
-- cancellation of two defects is a failure of choice, not a coincidence.
------------------------------------------------------------------------

विलोपः : {B : Type ℓ} {P : B → Type ℓ'}
       → isContr (Σ B P) → ¬ (isContr B) → ¬ ((b : B) → P b)
विलोपः c nb s = nb (छेद-सङ्कोचः s c)

------------------------------------------------------------------------
-- ३ · The positive form, which is what a router would actually use.
--
-- Where a section DOES exist the base is a retract of the total space, so
-- the composite is at least as crowded as the outer stage: downstream can
-- no longer hide upstream loss.  "Every outer point has an inner point" is
-- precisely the hypothesis under which cost stops cancelling.
------------------------------------------------------------------------

अच्छेदः : {B : Type ℓ} {P : B → Type ℓ'}
        → ((b : B) → P b)
        → ¬ (isContr B) → ¬ (isContr (Σ B P))
अच्छेदः s nb c = nb (छेद-सङ्कोचः s c)

------------------------------------------------------------------------
-- ४ · दोषलेखः — the limit, written.
--
-- विलोपः gives ¬ ((b : B) → P b) — the NON-EXISTENCE of a section.  It does
-- NOT hand back a specific b with `¬ P b`; extracting one from the failure
-- of a Π is exactly a choice principle, and this corpus does not have one
-- (no Dec, no LEM, no Bool verdict in the core).  So the deleted point is
-- proved to exist in the sense that no total assignment can, and is NOT
-- constructed.  That gap is not sloppiness: it is the same refusal that
-- makes the census three-valued instead of two, one level up.
--
-- Consequence for the cost model, stated plainly: even the OBSTRUCTION to
-- composing costs is non-constructive here.  A router cannot test for
-- cancellation by inspecting points; it can only fail to build a section.
------------------------------------------------------------------------
