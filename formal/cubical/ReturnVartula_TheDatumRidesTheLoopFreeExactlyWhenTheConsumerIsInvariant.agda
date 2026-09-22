{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡®‡∞‡æ‡ó‡Æ‡®-‡µ‡∞‡‡‡‡≤‡Æ‡ ‚î ‡µ‡‡®‡ ‡µ‡∞‡‡‡‡≤‡ ‡Æ‡‡ï‡‡‡ ‡‡¶‡æ ‡‡µ ‡Ø‡¶‡æ ‡‡ã‡ï‡‡‡æ ‡‡µ‡ø‡ï‡æ‡∞‡ ‡
--
-- (the carried datum rides the loop free exactly when the consumer is
--  invariant.)
--
-- WHAT THIS IS.  `NaturalMachine.HolonomyIsInvisibleExactlyToAnInvariant-
-- Semantics` proves `invariantSemanticsIsUnmoved` and
-- `nonTrivialHolonomyMovesTheRawInterface`, and reads them as one theorem
-- at two consumers.  It is right, and the object it is about already has a
-- name in this corpus: ‡‡‡®‡∞‡æ‡ó‡Æ‡®, the coming-back.  Holonomy is the FAILURE
-- of the coming-back to be trivial, and this module says so as terms.
--
--   ‡‡‡®‡∞‡æ‡ó‡Æ‡®   the return exists: the datum is determined, rides free,
--             nothing is lost.  `punaragamana/` states it for a map.
--   holonomy   go around and return changed.  Stated for a loop.
--
-- Same object, opposite sign.
--
-- WHY IT IS SHORT, AND WHY THAT IS THE POINT.  ¬ß‡ of ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡:
-- ‡‡‡ï‡‡∞‡Æ‡‡ ‡‡‡∞‡‡®‡æ ‡µ‡‡‡ø, ‡‡‡ï‡‡∞‡Æ‡‡ ‡® ‡ï‡ø‡û‡‡‡ø‡®‡ ‡®‡‡‡Ø‡‡ø.  A transport that costs
-- nothing is a geodesic; if joining two things takes work, the joint is
-- wrong.  Every declaration below is `refl`, one library lemma, or one
-- application of a theorem that already existed.  Nothing is constructed.
--
-- THE STATEMENT.  For a consumer `sem : Z ‚í B`, `Carrier sem` carries
-- `sem z` beside `z` at zero degrees of freedom (the fibre `singl (sem z)`
-- is contractible).  A holonomy `h : Z ‚â Z` acts on the base, hence on the
-- Carrier.  ¬ß3: the carried datum after one turn is `sem (h z)`, by `refl`.
-- ¬ß4: therefore the datum is unmoved for every point exactly when `sem` is
-- invariant ‚î the biconditional, both directions `refl`-cheap.  ¬ß5: the
-- identity consumer is the case where the datum IS the interface, so it is
-- unmoved only if `h` is trivial, and `Bool`/`not` exhibits one that is not.
--
-- WHY A BICONDITIONAL IS AVAILABLE HERE AND NOT ON THE OTHER ROAD.  An
-- obstruction (¬ß‡'s ‡¶‡ã‡‡≤‡‡ñ, road two) is a factorisation failing, and a
-- factorisation does not invert ‚î `DosaLekha_‚¶` records that the univalent
-- holonomy statements are exactly what would NOT instantiate it without an
-- added `isSet`.  That refusal is the boundary between the two roads, and
-- it falls on this side: holonomy is joined to its consumer by a PATH,
-- and a path inverts.  **Holonomy is road one, not road two.**
------------------------------------------------------------------------

module PunaragamanaVartula_TheDatumRidesTheLoopFreeExactlyWhenTheConsumerIsInvariant where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaŒ≤)
open import Cubical.Data.Bool using (Bool ; true ; false ; notEquiv)
open import Cubical.Relation.Nullary using (¬¨_)

import NaturalMachine.HolonomyIsInvisibleExactlyToAnInvariantSemantics as H

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡æ‡‡ï‡ ‚î the law, five lines, as in punaragamana/.
------------------------------------------------------------------------

record Carrier {A B : Type ‚Ñì} (f : A ‚Üí B) : Type ‚Ñì where
  constructor carry
  field
    base    : A
    carried : B
    witness : f base ‚â° carried

open Carrier public

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ‡§Ö‡§µ‡§§‡§∞‡§£ : A ‚Üí Carrier f
  ‡§Ö‡§µ‡§§‡§∞‡§£ a = carry a (f a) refl

  ‡§â‡§§‡•ç‡§•‡§æ‡§® : Carrier f ‚Üí A
  ‡§â‡§§‡•ç‡§•‡§æ‡§® = base

  -- contractible fibre ‚í equivalence ‚í path.  The whole proof.
  ‡§Ö‡§µ‡§§‡§∞‡§£-‡§â‡§§‡•ç‡§•‡§æ‡§® : (c : Carrier f) ‚Üí ‡§Ö‡§µ‡§§‡§∞‡§£ (‡§â‡§§‡•ç‡§•‡§æ‡§® c) ‚â° c
  ‡§Ö‡§µ‡§§‡§∞‡§£-‡§â‡§§‡•ç‡§•‡§æ‡§® (carry a b w) i = carry a (q i .fst) (q i .snd)
    where
      q : Path (singl (f a)) (f a , refl) (b , w)
      q = isContrSingl (f a) .snd (b , w)

  Carrier‚âÉ : A ‚âÉ Carrier f
  Carrier‚âÉ = isoToEquiv (iso ‡§Ö‡§µ‡§§‡§∞‡§£ ‡§â‡§§‡•ç‡§•‡§æ‡§® ‡§Ö‡§µ‡§§‡§∞‡§£-‡§â‡§§‡•ç‡§•‡§æ‡§® (Œª _ ‚Üí refl))

  Carrier‚â° : A ‚â° Carrier f
  Carrier‚â° = ua Carrier‚âÉ

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡∞‡‡‡‡≤‡Æ‡ ‚î a holonomy acts on the base, hence on the carrier.
--
-- `H.Holonomy Z = Z ‚â Z`, that module's own definition.  Œ¶ is the loop
-- read as a map; the lift is the conjugation ‡‡µ‡‡∞‡ ‚àò Œ¶ ‚àò ‡â‡‡‡‡æ‡®, which is
-- the shape `punaragamana/`'s Œ¶-carrier already has.
------------------------------------------------------------------------

module _ {B Z : Type‚ÇÄ} (sem : Z ‚Üí B) (h : H.Holonomy Z) where

  Œ¶ : Z ‚Üí Z
  Œ¶ = equivFun h

  Œ¶-‡§µ‡§æ‡§π‡§ï‡•á : Carrier sem ‚Üí Carrier sem
  Œ¶-‡§µ‡§æ‡§π‡§ï‡•á c = ‡§Ö‡§µ‡§§‡§∞‡§£ sem (Œ¶ (‡§â‡§§‡•ç‡§•‡§æ‡§® sem c))

  -- the square closes definitionally, for an opaque variable
  ‡§µ‡§∞‡•ç‡§ó‡§É : (z : Z) ‚Üí Œ¶-‡§µ‡§æ‡§π‡§ï‡•á (‡§Ö‡§µ‡§§‡§∞‡§£ sem z) ‚â° ‡§Ö‡§µ‡§§‡§∞‡§£ sem (Œ¶ z)
  ‡§µ‡§∞‡•ç‡§ó‡§É _ = refl

  ----------------------------------------------------------------------
  -- ‡© ¬ ‡Ø‡‡ ‡µ‡‡‡ø ‚î what the datum becomes after one turn.  By refl.
  ----------------------------------------------------------------------

  ‡§µ‡§π‡§®‡§Æ‡•ç-‡§™‡§¶‡•á : (z : Z) ‚Üí carried (Œ¶-‡§µ‡§æ‡§π‡§ï‡•á (‡§Ö‡§µ‡§§‡§∞‡§£ sem z)) ‚â° sem (Œ¶ z)
  ‡§µ‡§π‡§®‡§Æ‡•ç-‡§™‡§¶‡•á _ = refl

  ----------------------------------------------------------------------
  -- ‡ ¬ ‡‡¶‡æ ‡‡µ ‚î THE BICONDITIONAL.
  --
  -- The carried datum is unmoved at every point exactly when the consumer
  -- is invariant under the holonomy.  Both directions are the identity on
  -- the underlying family: ¬ß3 already made the two sides the same term, so
  -- there is nothing between them.
  --
  -- This is `H.invariantSemanticsIsUnmoved` read as a statement about what
  -- rides free, and it is a BICONDITIONAL because a path inverts.
  ----------------------------------------------------------------------

  ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä : Type _
  ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä = (z : Z) ‚Üí sem (Œ¶ z) ‚â° sem z

  ‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç : Type _
  ‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç = (z : Z) ‚Üí carried (Œ¶-‡§µ‡§æ‡§π‡§ï‡•á (‡§Ö‡§µ‡§§‡§∞‡§£ sem z)) ‚â° carried (‡§Ö‡§µ‡§§‡§∞‡§£ sem z)

  ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä‚Üí‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç : ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä ‚Üí ‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç
  ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä‚Üí‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç inv = inv

  ‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç‚Üí‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä : ‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç ‚Üí ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä
  ‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç‚Üí‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡•Ä free = free

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡ï‡‡∞‡Æ‡‡ ‚î and the same along the univalent transport.
--
-- `H.invariantSemanticsIsUnmoved` is stated for `transport (ua h)`, where
-- nothing reduces on a neutral variable ‚î the datum has to be brought back
-- by `uaŒ≤`.  Quoted, not restated: the point is that ¬ß‡'s biconditional and
-- that theorem are one fact at two presentations of the same loop.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§Ö‡§™‡§ø : {B Z : Type‚ÇÄ} (sem : Z ‚Üí B) (h : H.Holonomy Z)
             ‚Üí ((z : Z) ‚Üí sem (equivFun h z) ‚â° sem z)
             ‚Üí (z : Z) ‚Üí sem (transport (ua h) z) ‚â° sem z
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§Ö‡§™‡§ø sem h = H.invariantSemanticsIsUnmoved h sem

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡µ‡Ø‡‡‡ã‡ï‡‡‡æ ‚î the identity consumer, and a loop that moves it.
--
-- When the carried datum IS the interface, invariance of the consumer is
-- invariance of the holonomy, so the datum rides free only for a trivial
-- loop.  `H.theCacheIsMoved` exhibits one that is not: `not` on `Bool`.
-- That is why caches, provenance and optimizer state are the consumers
-- that see ‚î they are keyed by the raw interface.
------------------------------------------------------------------------

‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç : {Z : Type‚ÇÄ} ‚Üí Z ‚Üí Z
‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç z = z

‡§µ‡§æ‡§π‡§ï‡§É-‡§ö‡§≤‡§ø‡§§‡§É : ¬¨ (carried (Œ¶-‡§µ‡§æ‡§π‡§ï‡•á ‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç notEquiv (‡§Ö‡§µ‡§§‡§∞‡§£ ‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç true)) ‚â° true)
‡§µ‡§æ‡§π‡§ï‡§É-‡§ö‡§≤‡§ø‡§§‡§É = H.notIsGenuineHolonomy

‡§ï‡•ã‡§∂‡§É-‡§ö‡§≤‡§ø‡§§‡§É : ¬¨ (transport (ua notEquiv) true ‚â° true)
‡§ï‡•ã‡§∂‡§É-‡§ö‡§≤‡§ø‡§§‡§É = H.theCacheIsMoved
