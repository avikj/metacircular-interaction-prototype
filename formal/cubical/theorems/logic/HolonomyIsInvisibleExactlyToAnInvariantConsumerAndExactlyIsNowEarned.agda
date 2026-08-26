{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`.  **No tradition
-- term is claimed and none is invented.**  Univalence is Voevodsky's and
-- is this repository's declared substrate (CLAUDE.md: tools are not
-- frames); the holonomy framing is Δ 28 §36–38's, i.e. this corpus's own.
-- Naming this file with a Sanskrit label would assert a provenance
-- nobody checked, which is the mirror of the scrubbing the naming rule
-- corrects.
--
-- One connection is RECORDED AND NOT DEVELOPED, deliberately.  §5 of the
-- module below has the shape Jaina nayavāda describes — one object, two
-- standpoints, both verdicts correct, neither cancelling the other.  The
-- Jaina-logic line in this corpus is resting, and pulling it back for a
-- resemblance would be exactly the mining CLAUDE.md prohibits: taking the
-- convertible fragment of a darśana and discarding the dispute.  So this
-- is a note that the connection exists, not a claim that it holds.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT FINDING, WHICH IS THIS MODULE'S REASON FOR EXISTING.
--
-- `HolonomyIsInvisibleExactlyToAnInvariantSemantics` says EXACTLY in
-- its own name.  It proves ONE direction:
--
--   invariantSemanticsIsUnmoved :
--     ((z : Z) → sem (equivFun h z) ≡ sem z)
--     → (z : Z) → sem (transport (ua h) z) ≡ sem z
--
-- The converse is nowhere in the file, and its §"WHAT IS NOT CLAIMED"
-- — which does list architecture space, flatness, boundary semantics,
-- loop composition and the fundamental group — does not list it.
-- **So the word doing the most work in that module was in its title and
-- was unearned.**  Found by the audit move that produced ae3c3d00:
-- read a §"WHAT IS NOT CLAIMED" for what it FAILED to list.
--
-- **AND THE CONVERSE COSTS NOTHING.**  `uaβ h z : transport (ua h) z ≡
-- equivFun h z` is a PATH, so it may be walked in either orientation;
-- the backward direction is the forward one with `sym`.  Same for §3's
-- statement about the raw interface.
--
-- ────────────────────────────────────────────────────────────────────
-- **AND THAT IS THE CONTRAST WORTH RECORDING, against 53a06cc9.**  One
-- cycle earlier the same audit found a missing converse in
-- `FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt`
-- and the finding there was an ASYMMETRY: one direction a congruence,
-- the other a search paying `Enumerated K` + `Discrete O`.  Here there
-- is NO asymmetry, and the reason is structural rather than lucky —
-- there the two directions were related by an IMPLICATION assumed
-- (`FullyAbstract`), here by a PATH given (`uaβ`).  A path has an
-- inverse; an implication does not.  **So "is the converse free?" has
-- an answer readable off the shape of what connects the two sides, and
-- it is worth asking before assuming either verdict.**
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Invariant / Invisible   the two conditions, named
--   invariant→invisible     the old direction, REUSED not restated —
--                           it is `invariantSemanticsIsUnmoved`
--   invisible→invariant     the missing direction
--   invisibleExactlyWhenInvariant
--                           the biconditional, so the title's "exactly"
--                           is now a theorem
--   invisibleIsInvariantAsTypes
--                           with `isSet B`, an EQUIVALENCE of the two
--                           conditions, not merely a two-way implication
--   movedImpliesNotFixed    the same repair for §3: the raw interface
--                           being moved by the transport implies `h`
--                           does not fix the point.  The old module has
--                           only the other direction.
--
-- WHAT IS NOT CLAIMED.  Everything the older module disclaims still
-- stands: ARCHITECTURE SPACE IS NOT MODELLED, flatness is unused, no
-- loop composition, no fundamental group, and no claim that Δ 28's
-- "boundary semantics" IS invariant — that is a hypothesis here and a
-- modelling question there.  `isSet B` is a real hypothesis for the
-- equivalence and is not free; without it the two conditions are
-- logically equivalent and nothing more is claimed of them.  Nothing
-- here says which consumers a real system has.
--
-- NO NOVELTY.  `ua`, `uaβ`, `propBiimpl→Equiv` are library.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; propBiimpl→Equiv)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyIsInvisibleExactlyToAnInvariantSemantics
  using (Holonomy ; invariantSemanticsIsUnmoved)

------------------------------------------------------------------------
-- 1.  The two conditions
------------------------------------------------------------------------

module _ {Z B : Type} (h : Holonomy Z) (sem : Z → B) where

  Invariant : Type
  Invariant = (z : Z) → sem (equivFun h z) ≡ sem z

  Invisible : Type
  Invisible = (z : Z) → sem (transport (ua h) z) ≡ sem z

  ----------------------------------------------------------------------
  -- 2.  Both directions, the first one reused rather than restated
  ----------------------------------------------------------------------

  invariant→invisible : Invariant → Invisible
  invariant→invisible = invariantSemanticsIsUnmoved h sem

  invisible→invariant : Invisible → Invariant
  invisible→invariant inv z = cong sem (sym (uaβ h z)) ∙ inv z

  invisibleExactlyWhenInvariant :
    (Invariant → Invisible) × (Invisible → Invariant)
  invisibleExactlyWhenInvariant = invariant→invisible , invisible→invariant

  ----------------------------------------------------------------------
  -- 3.  And with a set of observations, an equivalence of the conditions
  ----------------------------------------------------------------------

  invisibleIsInvariantAsTypes : isSet B → Invariant ≃ Invisible
  invisibleIsInvariantAsTypes sB =
    propBiimpl→Equiv
      (isPropΠ (λ z → sB (sem (equivFun h z)) (sem z)))
      (isPropΠ (λ z → sB (sem (transport (ua h) z)) (sem z)))
      invariant→invisible
      invisible→invariant

------------------------------------------------------------------------
-- 4.  The same repair for the raw interface
------------------------------------------------------------------------

movedImpliesNotFixed :
  {Z : Type} (h : Holonomy Z) (z : Z)
  → ¬ (transport (ua h) z ≡ z) → ¬ (equivFun h z ≡ z)
movedImpliesNotFixed h z moved e = moved (uaβ h z ∙ e)
