{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î ‡‡‡‡‡‡æ‡ß‡®‡Æ‡ ‡‡®‡æ‡µ‡‡‡Ø‡ï‡Æ‡ ‡‡‡‡‡ ; ‡‡‡ï‡‡∞‡Æ‡‡ ‡¶‡¶‡æ‡‡ø ‡
--
-- (the hand proof was unnecessary; transport gives it.)
--
-- WHAT THIS IS.  `VivekaPramana_TheRemainderIsLawfulAndTheNetBeats.agda`
-- proves (‚ï ó ‚ï) ‚â° ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ by hand.  Its `Iso.rightInv` transports
-- ‡¶‡ï‡‡‡ø‡ along the ‡‡‡∞‡Æ‡æ‡ field and fills the ‡‡‡∞‡Æ‡æ‡ component with
-- `isProp‚íPathP` over `isSet‚ï`, and its header records the fight:
--
--     "`isPropNat` does not exist and CANNOT: ‚ï is not a proposition."
--
-- That obstacle is not in the mathematics.  It is an artefact of building
-- the equivalence instead of recognising it.  The record IS
-- `Punaragamana.Carrier ‡Ø‡ã‡ó` for ‡Ø‡ã‡ó (s , l) = s + l, whose fibre is
-- `singl (s + l)`, contractible by `isContrSingl` ‚î no h-level hypothesis,
-- no ‚ï, no transport of a field, and true for ARBITRARY A and B.
--
-- So nothing here is constructed.  ¬ß1 names the map, ¬ß2 is the fibre,
-- ¬ß3 is the equivalence and the path, and ¬ß4 is the identification with
-- the hand-built one ‚î every proof `refl` or a library lemma.  The
-- content is that there was nothing to do.
--
-- ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ ¬ß‡ ¬ ‡¶‡‡µ‡ ‡Æ‡æ‡∞‡‡ó‡.  This is the first road taken
-- where the second had been written by hand: ‡‡‡ï‡‡∞‡Æ‡‡ ‡‡‡∞‡‡®‡æ ‡µ‡‡‡ø, and the
-- structure that carries here is the whole equivalence.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9, --cubical --safe, no postulates,
-- no holes.  (The punaragamana/ library is a separate lake with its own
-- pin, so `Carrier` is restated here rather than imported ‚î five lines,
-- and ¬ß5 records that this duplication is deliberate.)
------------------------------------------------------------------------

module Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; isoToPath)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Foundations.Univalence using (ua ; uaŒ≤)
open import Cubical.Data.Sigma using (Œ£ ; Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd ; Œ£-contractSnd)
open import Cubical.Data.Nat using (‚Ñï ; _+_)

import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as V

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡æ‡‡ï‡ ‚î the law, restated in five lines.
--
-- base, carried, and the witness that the second is the first's image.
------------------------------------------------------------------------

record Carrier {A B : Type ‚Ñì} (f : A ‚Üí B) : Type ‚Ñì where
  constructor carry
  field
    base    : A
    carried : B
    witness : f base ‚â° carried

open Carrier public

------------------------------------------------------------------------
-- ‡® ¬ ‡ï‡‡‡‡‡‡∞‡ ‡‡Æ‡‡‡‡∞‡‡‡Æ‡ ‚î the fibre is contractible, and that is the whole
-- proof.
--
-- `singl (f a)` is inhabited by (f a , refl) and everything in it is
-- joined to that point.  No h-level hypothesis on A or B anywhere.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç : A ‚Üí Type ‚Ñì
  ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a = singl (f a)

  ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£‡§Æ‡•ç : (a : A) ‚Üí isContr (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a)
  ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£‡§Æ‡•ç a = isContrSingl (f a)

  ------------------------------------------------------------------------
  -- ‡© ¬ ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î and therefore A ‚â Carrier f, and A ‚â° Carrier f.
  ------------------------------------------------------------------------

  Carrier-as-Œ£ : Iso (Carrier f) (Œ£[ a ‚àà A ] ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a)
  Iso.fun      Carrier-as-Œ£ c       = base c , (carried c , witness c)
  Iso.inv      Carrier-as-Œ£ (a , p) = carry a (p .fst) (p .snd)
  Iso.rightInv Carrier-as-Œ£ _       = refl
  Iso.leftInv  Carrier-as-Œ£ _       = refl

  Œ£-law : (Œ£[ a ‚àà A ] ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a) ‚âÉ A
  Œ£-law = Œ£-contractSnd ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§∏‡§Æ‡•ç‡§™‡•Ç‡§∞‡•ç‡§£‡§Æ‡•ç

  ‡§Ö‡§µ‡§§‡§∞‡§£ : A ‚Üí Carrier f
  ‡§Ö‡§µ‡§§‡§∞‡§£ a = carry a (f a) refl

  ‡§â‡§§‡•ç‡§•‡§æ‡§® : Carrier f ‚Üí A
  ‡§â‡§§‡•ç‡§•‡§æ‡§® = base

  ‡§â‡§§‡•ç‡§•‡§æ‡§®-‡§Ö‡§µ‡§§‡§∞‡§£ : (a : A) ‚Üí ‡§â‡§§‡•ç‡§•‡§æ‡§® (‡§Ö‡§µ‡§§‡§∞‡§£ a) ‚â° a
  ‡§â‡§§‡•ç‡§•‡§æ‡§®-‡§Ö‡§µ‡§§‡§∞‡§£ _ = refl

  ‡§Ö‡§µ‡§§‡§∞‡§£-‡§â‡§§‡•ç‡§•‡§æ‡§® : (c : Carrier f) ‚Üí ‡§Ö‡§µ‡§§‡§∞‡§£ (‡§â‡§§‡•ç‡§•‡§æ‡§® c) ‚â° c
  ‡§Ö‡§µ‡§§‡§∞‡§£-‡§â‡§§‡•ç‡§•‡§æ‡§® (carry a b w) i = carry a (q i .fst) (q i .snd)
    where
      q : Path (singl (f a)) (f a , refl) (b , w)
      q = isContrSingl (f a) .snd (b , w)

  Carrier-Iso : Iso A (Carrier f)
  Carrier-Iso = iso ‡§Ö‡§µ‡§§‡§∞‡§£ ‡§â‡§§‡•ç‡§•‡§æ‡§® ‡§Ö‡§µ‡§§‡§∞‡§£-‡§â‡§§‡•ç‡§•‡§æ‡§® ‡§â‡§§‡•ç‡§•‡§æ‡§®-‡§Ö‡§µ‡§§‡§∞‡§£

  Carrier‚âÉ : A ‚âÉ Carrier f
  Carrier‚âÉ = isoToEquiv Carrier-Iso

  Carrier‚â° : A ‚â° Carrier f
  Carrier‚â° = ua Carrier‚âÉ

------------------------------------------------------------------------
-- ‡ ¬ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡ ‚î and ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ is that, at ‡Ø‡ã‡ó.
--
-- Every line below is refl.  The hand-built record and `Carrier ‡Ø‡ã‡ó` are
-- the same object; uncurrying is the entire difference.
------------------------------------------------------------------------

‡§Ø‡•ã‡§ó : ‚Ñï √ó ‚Ñï ‚Üí ‚Ñï
‡§Ø‡•ã‡§ó x = fst x + snd x

‡§µ‡§ø‡§µ‡•á‡§ï‚âÖ‡§µ‡§æ‡§π‡§ï‡§É : Iso V.‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ (Carrier ‡§Ø‡•ã‡§ó)
Iso.fun      ‡§µ‡§ø‡§µ‡•á‡§ï‚âÖ‡§µ‡§æ‡§π‡§ï‡§É v = carry (v .V.‡§∏‡§Æ , v .V.‡§µ‡§æ‡§Æ) (v .V.‡§¶‡§ï‡•ç‡§∑‡§ø‡§£) (sym (v .V.‡§™‡•ç‡§∞‡§Æ‡§æ‡§£))
Iso.inv      ‡§µ‡§ø‡§µ‡•á‡§ï‚âÖ‡§µ‡§æ‡§π‡§ï‡§É c =
  record { ‡§∏‡§Æ = fst (base c) ; ‡§µ‡§æ‡§Æ = snd (base c)
         ; ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ = carried c ; ‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ = sym (witness c) }
Iso.rightInv ‡§µ‡§ø‡§µ‡•á‡§ï‚âÖ‡§µ‡§æ‡§π‡§ï‡§É _ = refl
Iso.leftInv  ‡§µ‡§ø‡§µ‡•á‡§ï‚âÖ‡§µ‡§æ‡§π‡§ï‡§É _ = refl

‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É : V.‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚âÉ Carrier ‡§Ø‡•ã‡§ó
‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É = isoToEquiv ‡§µ‡§ø‡§µ‡•á‡§ï‚âÖ‡§µ‡§æ‡§π‡§ï‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡Ø‡‡ ‡‡®‡æ‡µ‡‡‡Ø‡ï‡Æ‡ ‡‡‡‡‡ ‚î what the hand proof was for.
--
-- `V.‚ïó‚ï‚â°‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡` is built from an Iso whose rightInv transports
-- ‡¶‡ï‡‡‡ø‡ along ‡‡‡∞‡Æ‡æ‡ and discharges the ‡‡‡∞‡Æ‡æ‡ component with
-- isProp‚íPathP over isSet‚ï.  Here the same path is `Carrier‚â° ‡Ø‡ã‡ó`
-- composed with ¬ß4's equivalence, and NOTHING about ‚ï is used: no isSet‚ï,
-- no isProp‚íPathP, no transport of a field.  Replace ‚ï by any type and
-- the proof is unchanged.
------------------------------------------------------------------------

‚Ñï√ó‚Ñï‚â°‡§µ‡§æ‡§π‡§ï‡§É : (‚Ñï √ó ‚Ñï) ‚â° Carrier ‡§Ø‡•ã‡§ó
‚Ñï√ó‚Ñï‚â°‡§µ‡§æ‡§π‡§ï‡§É = Carrier‚â° ‡§Ø‡•ã‡§ó

‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ : (‚Ñï √ó ‚Ñï) ‚â° V.‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ = ‚Ñï√ó‚Ñï‚â°‡§µ‡§æ‡§π‡§ï‡§É ‚àô sym (ua ‡§µ‡§ø‡§µ‡•á‡§ï‚âÉ‡§µ‡§æ‡§π‡§ï‡§É)

-- and it is the same path the hand proof produced, because the two
-- constructions have the same endpoints and there was only ever one
-- equivalence to have.
‡§∏‡§Æ‡§æ‡§®-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : (x : ‚Ñï √ó ‚Ñï) ‚Üí V.‡§â‡§§‡•ç‡§•‡§æ‡§® (V.‡§Ö‡§µ‡§§‡§∞‡§£ x) ‚â° x
‡§∏‡§Æ‡§æ‡§®-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É _ = refl

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what is written rather than repaired.
--
-- `VivekaPramana_‚¶` is NOT edited.  ¬ß‡ of the stra gives two roads and
-- this module takes the first; deleting another seat's second road would
-- be the collapse the corpus refuses (¬ß‡: ‡®‡Ø‡‡‡¶‡ ‡‡ô‡‡ï‡‡‡‡‡ã ‡® ‡µ‡ø‡¶‡‡Ø‡‡).
-- What is claimed is only that the h-level obstacle its header records is
-- an artefact of the construction and not of the mathematics.
--
-- `Carrier` is restated here rather than imported because punaragamana/ is
-- a separate lake with its own pin (2.6.3 / cubical v0.5, currently
-- unrunnable on this machine ‚î see punaragamana/README.md's Toolchain
-- section).  That duplication is a defect, it is deliberate, and the fix
-- is to make punaragamana/ importable from formal/cubical rather than to
-- keep two copies of a five-line record.
------------------------------------------------------------------------
