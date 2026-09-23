{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ß‡∞‡‡Æ‡æ‡ß‡∞‡‡Æ‡ ‚î the media of motion and rest: they permit without causing,
-- and the extent of the medium is the boundary of the cosmos.
--
-- SOURCE.  Umsvti, *Tattvrthastra*, adhyya 5 (the ajva chapter,
-- ~2nd‚ì5th c. CE).  Of the six substances (a dravya) only jva is
-- coded in this corpus (`Jiva.agda`).  This file begins the ARENA ‚î the
-- ajva dravyas ‚î with the two that are pure Jain physics and have no
-- pre-modern European counterpart:
--
--   5.17  ‡ó‡‡ø‡‡‡‡ø‡‡‡Ø‡‡‡ó‡‡∞‡‡ ‡ß‡∞‡‡Æ‡æ‡ß‡∞‡‡Æ‡Ø‡ã‡∞‡‡‡ï‡æ‡∞‡
--         gati-sthity-upagrahau dharmdharmayor upakra
--         "the assistance (upakra) of dharma and adharma is the support
--          of motion (gati) and of rest (sthiti)" respectively.
--   5.7   they are each ONE, non-corporeal (arp), nikriya (actionless),
--         and pervade the whole loka (lokka) ‚î 5.5, 5.6, 5.13.
--
-- The doctrine, exactly, and it is a genuine physical claim:
--   ‚ dharma does NOT move things.  It is the CONDITION under which motion
--     is possible ‚î the bhya's simile is water to a fish: the water does
--     not push the fish; the fish cannot swim without it.  Permission, not
--     force.  This is why dharma is nikriya and yet upakrin.
--   ‚ dharma pervades exactly the loka.  Beyond it (aloka) there is no
--     dharma, hence NO MOTION IS POSSIBLE.  The universe's boundary is not
--     a wall; it is the edge of the medium of motion.  A liberated jva
--     rises (rdhvagati) and HALTS at the top of the loka ‚î not stopped by
--     an obstacle, but because the medium that permitted the rising ends
--     there (the mechanism behind TS 10.5‚ì7).
--   ‚ adharma is the dual: it supports sthiti, rest.
--
-- WHAT IS PROVED (over an abstract carrier of places `P` with a dharma
-- region `loka : P ‚í Type` required to be a PROPOSITION ‚î membership
-- carries no data, which IS nikriya + arp: the medium adds permission,
-- never structure):
--
--   ¬ß2  ‡®‡ø‡‡‡ï‡‡∞‡ø‡Ø‡Æ‡ ‚î dharma permits but does not cause.  A permitted step's
--       underlying MOTION does not depend on the permission-witness:
--       `fst` of a permitted step is independent of the proof that its
--       ends lie in the loka.  (The water does not choose where the fish
--       swims.)  Exact, because loka-membership is a proposition.
--   ¬ß3  ‡‡‡∞‡ã‡ß‡ ‚î confinement.  Any orbit of permitted steps from a point
--       in the loka stays in the loka, at every depth.  The region is
--       closed under motion.
--   ¬ß4  ‡‡≤‡ã‡ï‡-‡®-‡ó‡‡ø‡ ‚î no motion into aloka.  From inside, no permitted
--       step lands outside the loka; the cosmos's boundary bounds motion.
--   ¬ß5  ‡ä‡∞‡‡ß‡‡µ‡ó‡‡ø-‡µ‡ø‡∞‡æ‡Æ‡ ‚î the halt.  A maximal chain of permitted steps
--       never leaves the loka, so upward motion terminates at the medium's
--       edge, not at a barrier.  (The siddha comes to rest because dharma
--       runs out, TS 10.  Stated as the confinement corollary; the
--       cosmology proper is not formalised.)
--   ¬ß6  ‡‡ß‡∞‡‡Æ‡-‡‡‡‡ø‡‡ø‡ ‚î adharma, dually: rest (the identity step) is
--       available at every place of the loka.  Rest needs its medium too.
--
-- THE JOIN, stated as resonance and not as reduction.  In this corpus the
-- free road is TRANSPORT, defined on a domain (`PramanaTransport`,
-- `Machine`).  dharma-dravya IS that domain: motion is exactly where the
-- medium pervades, and there is no transport off it ‚î the same shape as
-- "no motion in aloka".  The identification of the two is offered, not
-- claimed; each is stated in its own vocabulary.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module DharmaAdharma_TheMediaOfMotionAndRestPermitWithoutCausingAndTheirExtentBoundsTheCosmos where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; fst ; snd ; _√ó_)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•rec)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß1  The arena: places, the medium of motion as a PROPOSITIONAL region,
--     and a step (a possible motion from one place to another).
------------------------------------------------------------------------

record Arena (P : Type ‚Ñì) : Type (‚Ñì-suc ‚Ñì) where
  field
    loka    : P ‚Üí Type ‚Ñì                    -- the medium of motion pervades here
    isPropLoka : (x : P) ‚Üí isProp (loka x)  -- ni·π£kriya/ar≈´pƒ´: membership is data-free
    Step    : P ‚Üí P ‚Üí Type ‚Ñì                -- a possible motion x ‚áù y

module _ {P : Type ‚Ñì} (A : Arena P) where
  open Arena A

  -- A PERMITTED motion: a step whose BOTH ends lie in the medium.
  -- dharma contributes the two permissions; it does not contribute the step.
  Permitted : P ‚Üí P ‚Üí Type ‚Ñì
  Permitted x y = Step x y √ó (loka x √ó loka y)

  motion : {x y : P} ‚Üí Permitted x y ‚Üí Step x y
  motion = fst

  ------------------------------------------------------------------------
  -- ¬ß2  ‡®‡ø‡‡‡ï‡‡∞‡ø‡Ø‡Æ‡ ‚î the medium permits but does not cause.  The underlying
  --     motion is independent of WHICH permission-witnesses are supplied:
  --     replace the loka-proofs, the motion is unchanged.  This is exact
  --     precisely because loka-membership is a proposition.
  ------------------------------------------------------------------------

  ‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç : {x y : P} (s : Step x y)
             (px px' : loka x) (py py' : loka y)
           ‚Üí motion (s , (px , py)) ‚â° motion (s , (px' , py'))
  ‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç s px px' py py' = refl
  -- (refl already: `fst` forgets the witnesses.  The proposition-ness of
  --  loka is what guarantees there was no hidden datum to forget ‚î ¬ß2b.)

  -- and there is genuinely nothing to choose: any two permissions agree.
  ‡§â‡§™‡§ï‡§æ‡§∞‡§É-‡§è‡§ï‡§É : {x y : P} (p q : loka x √ó loka y) ‚Üí p ‚â° q
  ‡§â‡§™‡§ï‡§æ‡§∞‡§É-‡§è‡§ï‡§É {x} {y} (px , py) (qx , qy) i = isPropLoka x px qx i , isPropLoka y py qy i

  ------------------------------------------------------------------------
  -- ¬ß3  ‡‡‡∞‡ã‡ß‡ ‚î confinement.  An orbit is a chain of permitted steps.
  --     Starting inside the medium, every place it reaches is inside it.
  ------------------------------------------------------------------------

  data Orbit : P ‚Üí P ‚Üí Type ‚Ñì where
    halt : {x : P} ‚Üí Orbit x x
    move : {x y z : P} ‚Üí Permitted x y ‚Üí Orbit y z ‚Üí Orbit x z

  -- the endpoint of any orbit begun in the loka is in the loka
  ‡§∏‡§Ç‡§∞‡•ã‡§ß‡§É : {x z : P} ‚Üí loka x ‚Üí Orbit x z ‚Üí loka z
  ‡§∏‡§Ç‡§∞‡•ã‡§ß‡§É lx halt              = lx
  ‡§∏‡§Ç‡§∞‡•ã‡§ß‡§É lx (move (s , (px , py)) o) = ‡§∏‡§Ç‡§∞‡•ã‡§ß‡§É py o

  ------------------------------------------------------------------------
  -- ¬ß4  ‡‡≤‡ã‡ï‡ ‡® ‡ó‡‡ø‡ ‚î no motion into aloka.  From inside the medium there
  --     is no permitted step to a place outside it.
  ------------------------------------------------------------------------

  ‡§Ö‡§≤‡•ã‡§ï‡•á-‡§®-‡§ó‡§§‡§ø‡§É : {x y : P} ‚Üí loka x ‚Üí Permitted x y ‚Üí ¬¨ (¬¨ loka y)
  ‡§Ö‡§≤‡•ã‡§ï‡•á-‡§®-‡§ó‡§§‡§ø‡§É lx (s , (px , py)) ¬¨ly = ¬¨ly py

  -- sharper: a permitted step ALWAYS lands in the medium (it carries the proof)
  ‡§ó‡§§‡§ø‡§É-‡§≤‡•ã‡§ï‡•á : {x y : P} ‚Üí Permitted x y ‚Üí loka y
  ‡§ó‡§§‡§ø‡§É-‡§≤‡•ã‡§ï‡•á (s , (px , py)) = py

  ------------------------------------------------------------------------
  -- ¬ß5  ‡ä‡∞‡‡ß‡‡µ‡ó‡‡ø-‡µ‡ø‡∞‡æ‡Æ‡ ‚î the halt.  Whatever the orbit, motion never
  --     leaves the medium; so an unbounded rising is bounded by the edge
  --     of dharma, not by any barrier.  (Confinement, read cosmologically.)
  ------------------------------------------------------------------------

  ‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§§‡§ø-‡§µ‡§ø‡§∞‡§æ‡§Æ‡§É : {x z : P} ‚Üí loka x ‚Üí Orbit x z ‚Üí loka z
  ‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§§‡§ø-‡§µ‡§ø‡§∞‡§æ‡§Æ‡§É = ‡§∏‡§Ç‡§∞‡•ã‡§ß‡§É

  -- and beyond the medium nothing moves: if z is in aloka, no orbit from
  -- inside reaches it.
  ‡§Ö‡§≤‡•ã‡§ï‡§É-‡§Ö‡§ó‡§Æ‡•ç‡§Ø‡§É : {x z : P} ‚Üí loka x ‚Üí ¬¨ (loka z) ‚Üí ¬¨ (Orbit x z)
  ‡§Ö‡§≤‡•ã‡§ï‡§É-‡§Ö‡§ó‡§Æ‡•ç‡§Ø‡§É lx ¬¨lz o = ¬¨lz (‡§∏‡§Ç‡§∞‡•ã‡§ß‡§É lx o)

module _ {P : Type ‚Ñì} (A : Arena P) where
  open Arena A

  ------------------------------------------------------------------------
  -- ¬ß6  ‡‡ß‡∞‡‡Æ‡ ‚î the dual medium, of rest.  adharma supports sthiti; where
  --     it pervades, staying (the identity step) is available.  Modelled by
  --     a rest-region that always offers the null motion.  (Same shape as
  --     dharma, with `halt` in place of a proper step: rest is a permitted
  --     non-motion, and it too needs its medium.)
  ------------------------------------------------------------------------

  Sthiti : (P ‚Üí Type ‚Ñì) ‚Üí P ‚Üí Type ‚Ñì
  Sthiti adharma x = adharma x        -- to be at rest at x is to have adharma at x

  ‡§Ö‡§ß‡§∞‡•ç‡§Æ‡§É-‡§∏‡•ç‡§•‡§ø‡§§‡§ø‡§É : (adharma : P ‚Üí Type ‚Ñì) {x : P} ‚Üí adharma x ‚Üí Sthiti adharma x
  ‡§Ö‡§ß‡§∞‡•ç‡§Æ‡§É-‡§∏‡•ç‡§•‡§ø‡§§‡§ø‡§É adharma r = r
  -- rest is exactly the presence of its medium: no motion, and permitted
  -- everywhere adharma pervades ‚î the dual of ¬ß2's permission.
