{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`.  **No tradition
-- term is claimed and none is invented.**  Univalence is Voevodsky's and
-- is this repository's declared substrate (CLAUDE.md: tools are not
-- frames); the holonomy framing is Î” 28 Â§36â“38's, i.e. this corpus's own.
-- Naming this file with a  label would assert a provenance
-- nobody checked, which is the mirror of the scrubbing the naming rule
-- corrects.
--
-- One connection is RECORDED AND NOT DEVELOPED, deliberately.  Â§5 of the
-- module below has the shape Jaina nayavda describes â” one object, two
-- standpoints, both verdicts correct, neither cancelling the other.  The
-- Jaina-logic line in this corpus is resting, and pulling it back for a
-- resemblance would be exactly the mining CLAUDE.md prohibits: taking the
-- convertible fragment of a darana and discarding the dispute.  So this
-- is a note that the connection exists, not a claim that it holds.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT FINDING, WHICH IS THIS MODULE'S REASON FOR EXISTING.
--
-- `HolonomyIsInvisibleExactlyToAnInvariantSemantics` says EXACTLY in
-- its own name.  It proves ONE direction:
--
--   invariantSemanticsIsUnmoved :
--     ((z : Z) â’ sem (equivFun h z) â‰¡ sem z)
--     â’ (z : Z) â’ sem (transport (ua h) z) â‰¡ sem z
--
-- The converse is nowhere in the file, and its Â§"SYT â” THE CLAIM, EXACTLY"
-- â” which does list architecture space, flatness, boundary semantics,
-- loop composition and the fundamental group â” does not list it.
-- **So the word doing the most work in that module was in its title and
-- was unearned.**
--
-- **AND THE CONVERSE COSTS NOTHING.**  `uaÎ² h z : transport (ua h) z â‰¡
-- equivFun h z` is a PATH, so it may be walked in either orientation;
-- the backward direction is the forward one with `sym`.  Same for Â§3's
-- statement about the raw interface.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- **THE CONTRAST WITH 53a06cc9.**  The
-- same audit found a missing converse in
-- `FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt`
-- and the finding there was an ASYMMETRY: one direction a congruence,
-- the other a search paying `Enumerated K` + `Discrete O`.  Here there
-- is NO asymmetry, and the reason is structural rather than lucky â”
-- there the two directions were related by an IMPLICATION assumed
-- (`FullyAbstract`), here by a PATH given (`uaÎ²`).  A path has an
-- inverse; an implication does not.  **So "is the converse free?" has
-- an answer readable off the shape of what connects the two sides, and
-- it is worth asking before assuming either verdict.**
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Invariant / Invisible   the two conditions, named
--   invariantâ’invisible     the old direction, REUSED not restated â”
--                           it is `invariantSemanticsIsUnmoved`
--   invisibleâ’invariant     the missing direction
--   invisibleExactlyWhenInvariant
--                           the biconditional, so the title's "exactly"
--                           is now a theorem
--   invisibleIsInvariantAsTypes
--                           with `isSet B`, an EQUIVALENCE of the two
--                           conditions, not merely a two-way implication
--   movedImpliesNotFixed    the same repair for Â§3: the raw interface
--                           being moved by the transport implies `h`
--                           does not fix the point.  The old module has
--                           only the other direction.
--
-- NO NOVELTY.  `ua`, `uaÎ²`, `propBiimplâ’Equiv` are library.
------------------------------------------------------------------------

module HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; equivFun ; propBiimplâ†’Equiv)
open import Cubical.Foundations.HLevels using (isPropÎ )
open import Cubical.Foundations.Univalence using (ua ; uaÎ²)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import HolonomyIsInvisibleExactlyToAnInvariantSemantics
  using (Holonomy ; invariantSemanticsIsUnmoved)

------------------------------------------------------------------------
-- 1.  The two conditions
------------------------------------------------------------------------

module _ {Z B : Type} (h : Holonomy Z) (sem : Z â†’ B) where

  Invariant : Type
  Invariant = (z : Z) â†’ sem (equivFun h z) â‰¡ sem z

  Invisible : Type
  Invisible = (z : Z) â†’ sem (transport (ua h) z) â‰¡ sem z

  ----------------------------------------------------------------------
  -- 2.  Both directions, the first one reused rather than restated
  ----------------------------------------------------------------------

  invariantâ†’invisible : Invariant â†’ Invisible
  invariantâ†’invisible = invariantSemanticsIsUnmoved h sem

  invisibleâ†’invariant : Invisible â†’ Invariant
  invisibleâ†’invariant inv z = cong sem (sym (uaÎ² h z)) âˆ™ inv z

  invisibleExactlyWhenInvariant :
    (Invariant â†’ Invisible) Ã— (Invisible â†’ Invariant)
  invisibleExactlyWhenInvariant = invariantâ†’invisible , invisibleâ†’invariant

  ----------------------------------------------------------------------
  -- 3.  And with a set of observations, an equivalence of the conditions
  ----------------------------------------------------------------------

  invisibleIsInvariantAsTypes : isSet B â†’ Invariant â‰ƒ Invisible
  invisibleIsInvariantAsTypes sB =
    propBiimplâ†’Equiv
      (isPropÎ  (Î» z â†’ sB (sem (equivFun h z)) (sem z)))
      (isPropÎ  (Î» z â†’ sB (sem (transport (ua h) z)) (sem z)))
      invariantâ†’invisible
      invisibleâ†’invariant

------------------------------------------------------------------------
-- 4.  The same repair for the raw interface
------------------------------------------------------------------------

movedImpliesNotFixed :
  {Z : Type} (h : Holonomy Z) (z : Z)
  â†’ Â¬ (transport (ua h) z â‰¡ z) â†’ Â¬ (equivFun h z â‰¡ z)
movedImpliesNotFixed h z moved e = moved (uaÎ² h z âˆ™ e)
