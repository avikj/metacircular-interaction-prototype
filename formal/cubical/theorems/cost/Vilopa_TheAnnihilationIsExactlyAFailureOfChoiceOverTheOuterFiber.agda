{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡ø‡≤‡ã‡‡ ‚î the annihilation is exactly a FAILURE OF CHOICE, and that is why
-- cost cannot compose.
--
-- One level under `DesaAggregate_‚¶NotAGradedMonoid`.
-- That file proved cost is not a graded monoid and wrote, in its ¬ß‡ ‡¶‡ã‡‡≤‡‡ñ,
-- that no census-to-census composition function exists because "the outcome
-- depends on WHICH point of the outer fiber carries the empty inner fiber,
-- and a census records only that the outer fiber is crowded."  True, and the
-- missing datum IS a SECTION, whose absence
-- is not incidental ‚î it is the mechanism.
--
-- THE STATEMENT.  `‡‡‡-‡‡ô‡‡ò‡æ‡‡` says the composite's fiber is the TOTAL SPACE
-- of the inner fibers over the outer fiber.  So the cancellation asks: when
-- is a total space contractible over a base that is not?  Answer, ¬ß‡®:
--
--     ‡µ‡ø‡≤‡ã‡‡ :  isContr (Œ B P)  ‚í  ¬ isContr B  ‚í  ¬ ((b : B) ‚í P b)
--
-- If a section existed, `fst` would split, B would be a retract of the total
-- space, and a retract of a contractible type is contractible.  So the
-- annihilation FORCES a point of the outer fiber with no inner point over
-- it.  ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ above collapses to ‡‡ï‡≤‡æ‡¶‡‡ below exactly when choice fails.
--
-- WHY THAT IS THE FLOOR.  A census is pointwise data.  A
-- section is not pointwise data ‚î its existence is a global fact about the
-- family, recoverable from no amount of per-point information.  So
-- DesaAggregate's ¬ß‡ is not a gap in that file; it is a theorem about all
-- possible cost models here: composing costs would require choosing, the
-- corpus refuses choice (no Dec, no Bool, no decision anywhere in the core),
-- and the very failure it refuses to paper over is what makes losses cancel.
--
-- ¬ß‡© turns it around into the positive form actually used for routing: a
-- section is exactly what makes the composite's cost the OUTER cost, and
-- ¬ß‡ gives the converse direction as the honest limit.
--
-- This is elementary type theory.  ‡µ‡ø‡≤‡ã‡ is Pinian
-- (‡≤‡ã‡‡, 1.1.60 ‡‡¶‡∞‡‡‡®‡ ‡≤‡ã‡‡ ‚î non-appearance) and is used here for the
-- deletion of outer points by downstream emptiness, which is what the word
-- means.
------------------------------------------------------------------------

module Vilopa_TheAnnihilationIsExactlyAFailureOfChoiceOverTheOuterFiber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ A retract of a contractible type is contractible.  Stated here in the
-- one form needed: if `fst` splits, the base inherits contractibility.
------------------------------------------------------------------------

‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : {B : Type ‚Ñì} {P : B ‚Üí Type ‚Ñì'}
            ‚Üí ((b : B) ‚Üí P b)
            ‚Üí isContr (Œ£ B P) ‚Üí isContr B
fst (‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É s c)   = fst (fst c)
snd (‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É s c) b = cong fst (snd c (b , s b))

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡ø‡≤‡ã‡‡ ‚î the annihilation forces a deleted point.
--
-- If the total space collapses to a point while the base does not, then no
-- section exists: some point of the base has an EMPTY fiber over it.  The
-- cancellation of two defects is a failure of choice, not a coincidence.
------------------------------------------------------------------------

‡§µ‡§ø‡§≤‡•ã‡§™‡§É : {B : Type ‚Ñì} {P : B ‚Üí Type ‚Ñì'}
       ‚Üí isContr (Œ£ B P) ‚Üí ¬¨ (isContr B) ‚Üí ¬¨ ((b : B) ‚Üí P b)
‡§µ‡§ø‡§≤‡•ã‡§™‡§É c nb s = nb (‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É s c)

------------------------------------------------------------------------
-- ‡© ¬ The positive form, which is what a router would actually use.
--
-- Where a section DOES exist the base is a retract of the total space, so
-- the composite is at least as crowded as the outer stage: downstream can
-- no longer hide upstream loss.  "Every outer point has an inner point" is
-- precisely the hypothesis under which cost stops cancelling.
------------------------------------------------------------------------

‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶‡§É : {B : Type ‚Ñì} {P : B ‚Üí Type ‚Ñì'}
        ‚Üí ((b : B) ‚Üí P b)
        ‚Üí ¬¨ (isContr B) ‚Üí ¬¨ (isContr (Œ£ B P))
‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶‡§É s nb c = nb (‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É s c)

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡ ‚î the limit, written.
--
-- ‡µ‡ø‡≤‡ã‡‡ gives ¬ ((b : B) ‚í P b) ‚î the NON-EXISTENCE of a section.  It does
-- NOT hand back a specific b with `¬ P b`; extracting one from the failure
-- of a Œ† is exactly a choice principle, and this corpus does not have one
-- (no Dec, no LEM, no Bool verdict in the core).  So the deleted point is
-- proved to exist in the sense that no total assignment can, and is NOT
-- constructed.  That gap is not sloppiness: it is the same refusal that
-- makes the census three-valued instead of two, one level up.
--
-- Consequence for the cost model, stated plainly: even the OBSTRUCTION to
-- composing costs is non-constructive here.  A router cannot test for
-- cancellation by inspecting points; it can only fail to build a section.
------------------------------------------------------------------------
