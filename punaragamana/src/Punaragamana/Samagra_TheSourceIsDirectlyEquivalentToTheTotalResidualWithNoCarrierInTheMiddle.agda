-- ‡ ‡‡‡‡Æ‡ ‡  One machine, one law: which side of `f a ‚â° b` is bound is everything.
-- Output bound: singl (f a), contractible ‚î the datum rides free.  Input bound:
-- fiber f b ‚î the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect ‚î there is no third path (ahis).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhag, and the sources are the origin
-- (Umsvti, Samantabhadra, Akalaka ‚î restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Punargamana ¬ ‡‡Æ‡ó‡‡∞
--
-- ‡‡Æ‡ó‡‡∞ (samagra), "whole, total, entire" ‚î used here for the total
-- space Œ[ b ‚àà B ] ‡‡‡ f b, the residual gathered back up over every
-- target point at once.   common-noun usage, not cited from a
-- mathematical text; the mathematics is HoTT 4.8 (total space of a
-- fibration ‚â the type it fibrates), specifically the total-space
-- characterization of `Œ-contractSnd`/`fiberEquiv` already in this
-- corpus's substrate (`Cubical.Foundations.Equiv`).
--
------------------------------------------------------------------------
-- WHY THIS MODULE EXISTS.
--
-- `Sesa` proves the graph Œìf has two projections: ‡Æ‡‡≤-‡‡‡∞‡ï‡‡‡‡ (to A,
-- always an equivalence) and ‡≤‡ï‡‡‡‡Ø-‡‡‡∞‡ï‡‡‡‡ (to B, an equivalence iff f
-- is).  It gets from `Carrier f ‚â Œ[ b ] ‡‡‡ f b` (`‡ó‡‡∞‡æ‡`) and
-- `Carrier f ‚â A` (`‡Æ‡‡≤-‡‡‡∞‡ï‡‡‡‡-‡‡Æ‡‡æ`) SEPARATELY.  Nowhere in that
-- module, or anywhere else searched in `punaragamana/src` or
-- `formal/cubical` (grepped for `Œ[ b`  ` ‡‡‡` composed against `A ‚â`,
-- 2026-08-24: no hit), is the two COMPOSED into the one statement that
-- actually names the total-space theorem without routing through
-- `Carrier` as scaffolding:
--
--     A  ‚â  Œ[ b ‚àà B ] ‡‡‡ f b
--
-- i.e. a point of A just IS a target point together with a witness that
-- some source point over it is exactly this one ‚î and the composite
-- equivalence's forward map is definitionally `Œª a ‚í f a , (a , refl)`,
-- checked by `refl` below, not merely provable.  This is the sharper
-- reading of the design law's two clauses AT ONE SITE: "every genuinely
-- independent distinction must survive" (an `a : A` determines its own
-- residual-witness pair) and "determined structure may remain
-- syntactically present with its determining path" (the `b` and the
-- `refl`-shaped witness are exactly that determined structure), stated as
-- ONE equivalence rather than as two theorems a reader has to compose by
-- hand.
--
-- `Carrier` therefore is not a third object standing between A and
-- Œ[ b ] ‡‡‡ f b ‚î it is a REDUNDANT waypoint on a path that closes
-- directly.  `‡‡ã‡Æ-‡‡ø‡¶‡‡ß‡ø` below proves exactly that: the round-trip
-- through Carrier and the direct one agree, definitionally, at every
-- point.
------------------------------------------------------------------------

module Punaragamana.Samagra_TheSourceIsDirectlyEquivalentToTheTotalResidualWithNoCarrierInTheMiddle where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma

open import Punaragamana.Carrier
open import Punaragamana.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

private
  variable
    ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ------------------------------------------------------------------------
  -- The direct isomorphism.  No detour through Carrier at the term
  -- level ‚î this is `descend`/`ascend` re-derived at the target-pairing
  -- shape directly, and both round-trips are `refl` (Œ-eta), exactly as
  -- for `Carrier-Iso` itself.
  ------------------------------------------------------------------------

  ‡§∏‡§Æ‡§ó‡•ç‡§∞-Iso : Iso A (Œ£[ b ‚àà B ] ‡§∂‡•á‡§∑ f b)
  Iso.fun      ‡§∏‡§Æ‡§ó‡•ç‡§∞-Iso a       = f a , (a , refl)
  Iso.inv      ‡§∏‡§Æ‡§ó‡•ç‡§∞-Iso (b , (a , p)) = a
  Iso.rightInv ‡§∏‡§Æ‡§ó‡•ç‡§∞-Iso (b , (a , p)) i = p i , (a , Œª j ‚Üí p (i ‚àß j))
  Iso.leftInv  ‡§∏‡§Æ‡§ó‡•ç‡§∞-Iso a       = refl

  ‡§∏‡§Æ‡§ó‡•ç‡§∞-‡§∏‡§Æ‡§§‡§æ : A ‚âÉ (Œ£[ b ‚àà B ] ‡§∂‡•á‡§∑ f b)
  ‡§∏‡§Æ‡§ó‡•ç‡§∞-‡§∏‡§Æ‡§§‡§æ = isoToEquiv ‡§∏‡§Æ‡§ó‡•ç‡§∞-Iso

  ------------------------------------------------------------------------
  -- ‡‡ã‡Æ-‡‡ø‡¶‡‡ß‡ø (homa-siddhi, "accomplishment of the offering [into the
  -- fire]" ‚î used here, uncited, for "what routing through the
  -- intermediate object yields, checked against going there directly").
  --
  -- `descend f a` is the canonical Carrier-valued reading of `a` (¬ß in
  -- `Carrier`, un-pattern-matched by design so it stays computational).
  -- Pushing it through `‡ó‡‡∞‡æ‡` ‚î `Sesa`'s graph equivalence, built by
  -- composing `Carrier-as-Œ` with the source/target swap `‡‡‡µ‡‡` ‚î lands
  -- on EXACTLY `equivFun ‡‡Æ‡ó‡‡∞-‡‡Æ‡‡æ a`, by `refl`: both sides unfold to
  -- the literal pair `f a , (a , refl)`.  So the direct route and the
  -- route through `Carrier` are not merely equal as equivalences of
  -- types (which composition already gives up to a propositional path);
  -- they are the same TERM on this representative, with no path needed
  -- to identify them.  `Carrier` supplies nothing here that `descend`
  -- did not already carry.
  ------------------------------------------------------------------------

  ‡§π‡•ã‡§Æ-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø : (a : A) ‚Üí
    equivFun (‡§ó‡•ç‡§∞‡§æ‡§π f) (descend f a) ‚â° equivFun ‡§∏‡§Æ‡§ó‡•ç‡§∞-‡§∏‡§Æ‡§§‡§æ a
  ‡§π‡•ã‡§Æ-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø a = refl
