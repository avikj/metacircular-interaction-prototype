{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned
--
-- ON THE NAME.  Univalence is Voevodsky's and
-- is this repository's declared substrate;
-- the holonomy framing is Δ 28 §36–38's, i.e. this corpus's own.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONVERSE.
--
-- `HolonomyIsInvisibleExactlyToAnInvariantSemantics`
-- proves ONE direction:
--
--   invariantSemanticsIsUnmoved :
--     ((z : Z) → sem (equivFun h z) ≡ sem z)
--     → (z : Z) → sem (transport (ua h) z) ≡ sem z
--
-- THE CONVERSE COSTS NOTHING.  `uaβ h z : transport (ua h) z ≡
-- equivFun h z` is a PATH, so it may be walked in either orientation;
-- the backward direction is the forward one with `sym`.  Same for §3's
-- statement about the raw interface.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONTRAST.  The converse in
-- `FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt`
-- is an ASYMMETRY: one direction a congruence,
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
--   invisible→invariant     the converse direction
--   invisibleExactlyWhenInvariant
--                           the biconditional, so the title's "exactly"
--                           is a theorem
--   invisibleIsInvariantAsTypes
--                           with `isSet B`, an EQUIVALENCE of the two
--                           conditions, not merely a two-way implication
--   movedImpliesNotFixed    the same converse for §3: the raw interface
--                           being moved by the transport implies `h`
--                           does not fix the point.
--
-- `ua`, `uaβ`, `propBiimpl→Equiv` are library.
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
-- 4.  The same converse for the raw interface
------------------------------------------------------------------------

movedImpliesNotFixed :
  {Z : Type} (h : Holonomy Z) (z : Z)
  → ¬ (transport (ua h) z ≡ z) → ¬ (equivFun h z ≡ z)
movedImpliesNotFixed h z moved e = moved (uaβ h z ∙ e)
