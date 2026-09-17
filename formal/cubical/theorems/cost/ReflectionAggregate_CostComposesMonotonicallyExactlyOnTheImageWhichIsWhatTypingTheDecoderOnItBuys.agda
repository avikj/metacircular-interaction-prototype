{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡-‡‡ô‡‡ò‡æ‡‡ ‚î cost composes monotonically EXACTLY on the image, and
-- that is what typing the decoder on the Image buys.  Two facts the corpus
-- already holds, in different files, that are one fact.
--
-- FACT A (`README` ¬ßC4).  `FactorsThrough` has two definitions under one
-- name.  `FiniteInformation` types its decoder on the IMAGE ‚î "the empty
-- fibre unroutable by type, the router's guard is sound THERE" ‚î while
-- `QuotientFiberLaw` types it on the full codomain, and gating against the
-- wrong one makes the ‡∞‡ø‡ï‡‡‡Æ‡ rows transportable.  Recorded as a naming
-- defect.
--
-- FACT B (`DesaSanghata_‚¶NotAGradedMonoid`, `Vilopa_‚¶FailureOfChoice`, both
-- this corpus, today).  Cost does not compose: an empty inner fibre deletes
-- a point of the outer fibre, ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ collapses to ‡‡ï‡≤‡æ‡¶‡‡, monotonicity
-- fails ‚î and the annihilation happens exactly when no section
-- `(w : ‡‡‡ g z) ‚í ‡‡‡ f (fst w)` exists.
--
-- THEY ARE THE SAME FACT.  The section whose absence ‡ïills composition IS
-- the statement that the outer fibre lies inside the image of `f`.  So:
--
--   * on the full codomain there is no graded monoid (Fact B), and
--   * on the image there is (¬ß‡© below), because the section is free,
--
-- and C4's "two definitions" is not a naming slip to be tidied ‚î it is the
-- boundary between a cost model that composes and one that does not.  The
-- Image-typed decoder is sound for exactly the reason cost is monotone
-- there, and no other.
--
-- WHAT ¬ß‡© IS.  Not a new inequality: the hypothesis named, and shown to be
-- the image condition.  `‡‡‡‡‡‡¶-‡‡ô‡‡ò‡æ‡‡` says a crowded outer stage stays
-- crowded through composition whenever every outer point is hit by `f`.
-- That is the router's guard, and it is the whole of it ‚î there is nothing
-- else to check.
--
-- ¬ß‡ is the price of the repair, and it is not nothing: the image condition
-- is a Œ†, so it is not decidable here and cannot be tested pointwise, which
-- is `Vilopa` ¬ß‡ arriving from the other side.  A router does not VERIFY the
-- guard; it CARRIES a section, or it has no route.  That is why the receipt
-- economy's unit is a term and not a check.
--
-- No source claimed for the mathematics; it is elementary.  ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡ is
-- ordinary  for image/reflection; the compound is built here,
-- 2026-08-22.
------------------------------------------------------------------------

module PratibimbaSanghata_CostComposesMonotonicallyExactlyOnTheImageWhichIsWhatTypingTheDecoderOnItBuys where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open Iso
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

‡§∂‡•á‡§∑ : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí B ‚Üí Type ‚Ñì
‡§∂‡•á‡§∑ {A = A} f b = Œ£[ a ‚àà A ] (f a ‚â° b)

------------------------------------------------------------------------
-- ‡ß ¬ The composition law (SankramanaSesa's ‡‡‡-‡‡ô‡‡ò‡æ‡‡; term cited, not
-- claimed), restated locally so this module stands alone under the kernel.
------------------------------------------------------------------------

module _ {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C) where

  private
    fwd : ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z ‚Üí Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)
    fwd (a , p) = ((f a , p) , (a , refl))

    bwd : (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)) ‚Üí ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z
    bwd ((b , q) , (a , p)) = (a , cong g p ‚àô q)

    bwd-fwd : (x : ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z) ‚Üí bwd (fwd x) ‚â° x
    bwd-fwd (a , p) i = (a , sym (lUnit p) i)

    fwd-bwd : (w : Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w)) ‚Üí fwd (bwd w) ‚â° w
    fwd-bwd ((b , q) , (a , p)) = lem a b p q
      where
      lem : (a : A) (b : B) (p : f a ‚â° b) (q : g b ‚â° z)
          ‚Üí fwd (bwd ((b , q) , (a , p))) ‚â° ((b , q) , (a , p))
      lem a b p q =
        J (Œª b' p' ‚Üí (q' : g b' ‚â° z)
              ‚Üí fwd (bwd ((b' , q') , (a , p'))) ‚â° ((b' , q') , (a , p')))
          (Œª q' i ‚Üí ((f a , lUnit q' (~ i)) , (a , refl)))
          p q

  ‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : ‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z ‚âÉ (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w))
  ‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É = isoToEquiv (iso fwd bwd fwd-bwd bwd-fwd)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡∞‡‡ø‡‡ø‡Æ‡‡‡ ‚î THE IMAGE CONDITION, named.  "Every point of the outer
-- fibre over z is hit by f."  This is precisely the section whose absence
-- Vilopa proves the annihilation requires, and precisely what typing a
-- decoder on the Image asserts.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C) ‚Üí Type ‚Ñì
‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á f g z = (w : ‡§∂‡•á‡§∑ g z) ‚Üí ‡§∂‡•á‡§∑ f (fst w)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡‡‡¶-‡‡ô‡‡ò‡æ‡‡ ‚î ON THE IMAGE, COST IS MONOTONE.
--
-- A crowded outer stage stays crowded through composition.  No annihilation,
-- no hiding of upstream loss: the graded monoid that fails on the codomain
-- exists here.  The proof is one retraction ‚î the section splits `fst`.
------------------------------------------------------------------------

‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) (z : C)
              ‚Üí ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡•á f g z
              ‚Üí ¬¨ (isContr (‡§∂‡•á‡§∑ g z))
              ‚Üí ¬¨ (isContr (‡§∂‡•á‡§∑ (Œª a ‚Üí g (f a)) z))
‡§Ö‡§ö‡•ç‡§õ‡•á‡§¶-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É f g z s nb c = nb ‡§¨‡§π‡§ø‡§É-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É
  where
    Œ£c : isContr (Œ£[ w ‚àà ‡§∂‡•á‡§∑ g z ] ‡§∂‡•á‡§∑ f (fst w))
    Œ£c = isOfHLevelRespectEquiv 0 (‡§∂‡•á‡§∑-‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É f g z) c
      where open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
    ‡§¨‡§π‡§ø‡§É-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : isContr (‡§∂‡•á‡§∑ g z)
    fst ‡§¨‡§π‡§ø‡§É-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É   = fst (fst Œ£c)
    snd ‡§¨‡§π‡§ø‡§É-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É w = cong fst (snd Œ£c (w , s w))

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡ ‚î the price of the repair, which is the same price one level
-- down.
--
-- `‡‡‡∞‡‡ø‡‡ø‡Æ‡‡‡` is a Œ†.  It is not decidable here and cannot be tested
-- pointwise; `Vilopa` ¬ß‡ says the same thing from the other side, that the
-- obstruction yields only the non-existence of a section and never a witness
-- point.  So a router does NOT verify this guard.  It CARRIES a section, or
-- it has no route ‚î which is exactly why the unit of proof-of-transport is a
-- term and not a check, and why `FactorsThrough` must be TYPED on the image
-- rather than gated against it.  C4's "two definitions under one name" is
-- therefore not a tidy-up: keeping both is keeping the boundary between a
-- composable cost model and an incomposable one, and the names should say
-- which side each is on.
--
-- Not proved here: that the image-restricted composites form a category with
-- the monoid structure assembled.  ¬ß‡© is the key step (no annihilation), not
-- the assembly.
------------------------------------------------------------------------
