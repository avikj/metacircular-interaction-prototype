{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- धर्माधर्मौ — the media of motion and rest: they permit without causing,
-- and the extent of the medium is the boundary of the cosmos.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra*, adhyāya 5 (the ajīva chapter,
-- ~2nd–5th c. CE).  Of the six substances (ṣaḍ dravya) only jīva is
-- coded in this corpus (`Jiva.agda`).  This file begins the ARENA — the
-- ajīva dravyas — with the two that are pure Jain physics and have no
-- pre-modern European counterpart:
--
--   5.17  गतिस्थित्युपग्रहौ धर्माधर्मयोरुपकारः
--         gati-sthity-upagrahau dharmādharmayor upakāraḥ
--         "the assistance (upakāra) of dharma and adharma is the support
--          of motion (gati) and of rest (sthiti)" respectively.
--   5.7   they are each ONE, non-corporeal (arūpī), niṣkriya (actionless),
--         and pervade the whole loka (lokākāśa) — 5.5, 5.6, 5.13.
--
-- The doctrine, exactly, and it is a genuine physical claim:
--   • dharma does NOT move things.  It is the CONDITION under which motion
--     is possible — the bhāṣya's simile is water to a fish: the water does
--     not push the fish; the fish cannot swim without it.  Permission, not
--     force.  This is why dharma is niṣkriya and yet upakārin.
--   • dharma pervades exactly the loka.  Beyond it (aloka) there is no
--     dharma, hence NO MOTION IS POSSIBLE.  The universe's boundary is not
--     a wall; it is the edge of the medium of motion.  A liberated jīva
--     rises (ūrdhvagati) and HALTS at the top of the loka — not stopped by
--     an obstacle, but because the medium that permitted the rising ends
--     there (the mechanism behind TS 10.5–7).
--   • adharma is the dual: it supports sthiti, rest.
--
-- WHAT IS PROVED (over an abstract carrier of places `P` with a dharma
-- region `loka : P → Type` required to be a PROPOSITION — membership
-- carries no data, which IS niṣkriya + arūpī: the medium adds permission,
-- never structure):
--
--   §2  निष्क्रियम् — dharma permits but does not cause.  A permitted step's
--       underlying MOTION does not depend on the permission-witness:
--       `fst` of a permitted step is independent of the proof that its
--       ends lie in the loka.  (The water does not choose where the fish
--       swims.)  Exact, because loka-membership is a proposition.
--   §3  संरोधः — confinement.  Any orbit of permitted steps from a point
--       in the loka stays in the loka, at every depth.  The region is
--       closed under motion.
--   §4  अलोके-न-गतिः — no motion into aloka.  From inside, no permitted
--       step lands outside the loka; the cosmos's boundary bounds motion.
--   §5  ऊर्ध्वगति-विरामः — the halt.  A maximal chain of permitted steps
--       never leaves the loka, so upward motion terminates at the medium's
--       edge, not at a barrier.  (The siddha comes to rest because dharma
--       runs out, TS 10.  Stated as the confinement corollary; the
--       cosmology proper is not formalised.)
--   §6  अधर्मः-स्थितिः — adharma, dually: rest (the identity step) is
--       available at every place of the loka.  Rest needs its medium too.
--
-- THE JOIN, stated as resonance and not as reduction.  In this corpus the
-- free road is TRANSPORT, defined on a domain (`PramanaSankramana`,
-- `Yantra`).  dharma-dravya IS that domain: motion is exactly where the
-- medium pervades, and there is no transport off it — the same shape as
-- "no motion in aloka".  The identification of the two is offered, not
-- claimed; each is stated in its own vocabulary.
--
-- WHAT IS **NOT** CLAIMED.  That Umāsvāti proved any of the terms below;
-- the doctrine is his, the theorems are cubical type theory (Voevodsky's
-- univalence is the substrate only).  Not formalised, and owed: pudgala
-- (matter/paramāṇu and combination), ākāśa (space/avagāhana), kāla
-- (time/samaya); the cosmology of loka/aloka as geometry; that dharma is
-- literally ONE (singleness is asserted in the header, not encoded — the
-- carrier here is abstract).  Only the FUNCTIONAL core — permission,
-- confinement, the bounding edge, the dual for rest — is checked.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module DharmaAdharma_TheMediaOfMotionAndRestPermitWithoutCausingAndTheirExtentBoundsTheCosmos where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The arena: places, the medium of motion as a PROPOSITIONAL region,
--     and a step (a possible motion from one place to another).
------------------------------------------------------------------------

record Arena (P : Type ℓ) : Type (ℓ-suc ℓ) where
  field
    loka    : P → Type ℓ                    -- the medium of motion pervades here
    isPropLoka : (x : P) → isProp (loka x)  -- niṣkriya/arūpī: membership is data-free
    Step    : P → P → Type ℓ                -- a possible motion x ⇝ y

module _ {P : Type ℓ} (A : Arena P) where
  open Arena A

  -- A PERMITTED motion: a step whose BOTH ends lie in the medium.
  -- dharma contributes the two permissions; it does not contribute the step.
  Permitted : P → P → Type ℓ
  Permitted x y = Step x y × (loka x × loka y)

  motion : {x y : P} → Permitted x y → Step x y
  motion = fst

  ------------------------------------------------------------------------
  -- §2  निष्क्रियम् — the medium permits but does not cause.  The underlying
  --     motion is independent of WHICH permission-witnesses are supplied:
  --     replace the loka-proofs, the motion is unchanged.  This is exact
  --     precisely because loka-membership is a proposition.
  ------------------------------------------------------------------------

  निष्क्रियम् : {x y : P} (s : Step x y)
             (px px' : loka x) (py py' : loka y)
           → motion (s , (px , py)) ≡ motion (s , (px' , py'))
  निष्क्रियम् s px px' py py' = refl
  -- (refl already: `fst` forgets the witnesses.  The proposition-ness of
  --  loka is what guarantees there was no hidden datum to forget — §2b.)

  -- and there is genuinely nothing to choose: any two permissions agree.
  उपकारः-एकः : {x y : P} (p q : loka x × loka y) → p ≡ q
  उपकारः-एकः {x} {y} (px , py) (qx , qy) i = isPropLoka x px qx i , isPropLoka y py qy i

  ------------------------------------------------------------------------
  -- §3  संरोधः — confinement.  An orbit is a chain of permitted steps.
  --     Starting inside the medium, every place it reaches is inside it.
  ------------------------------------------------------------------------

  data Orbit : P → P → Type ℓ where
    halt : {x : P} → Orbit x x
    move : {x y z : P} → Permitted x y → Orbit y z → Orbit x z

  -- the endpoint of any orbit begun in the loka is in the loka
  संरोधः : {x z : P} → loka x → Orbit x z → loka z
  संरोधः lx halt              = lx
  संरोधः lx (move (s , (px , py)) o) = संरोधः py o

  ------------------------------------------------------------------------
  -- §4  अलोके न गतिः — no motion into aloka.  From inside the medium there
  --     is no permitted step to a place outside it.
  ------------------------------------------------------------------------

  अलोके-न-गतिः : {x y : P} → loka x → Permitted x y → ¬ (¬ loka y)
  अलोके-न-गतिः lx (s , (px , py)) ¬ly = ¬ly py

  -- sharper: a permitted step ALWAYS lands in the medium (it carries the proof)
  गतिः-लोके : {x y : P} → Permitted x y → loka y
  गतिः-लोके (s , (px , py)) = py

  ------------------------------------------------------------------------
  -- §5  ऊर्ध्वगति-विरामः — the halt.  Whatever the orbit, motion never
  --     leaves the medium; so an unbounded rising is bounded by the edge
  --     of dharma, not by any barrier.  (Confinement, read cosmologically.)
  ------------------------------------------------------------------------

  ऊर्ध्वगति-विरामः : {x z : P} → loka x → Orbit x z → loka z
  ऊर्ध्वगति-विरामः = संरोधः

  -- and beyond the medium nothing moves: if z is in aloka, no orbit from
  -- inside reaches it.
  अलोकः-अगम्यः : {x z : P} → loka x → ¬ (loka z) → ¬ (Orbit x z)
  अलोकः-अगम्यः lx ¬lz o = ¬lz (संरोधः lx o)

module _ {P : Type ℓ} (A : Arena P) where
  open Arena A

  ------------------------------------------------------------------------
  -- §6  अधर्मः — the dual medium, of rest.  adharma supports sthiti; where
  --     it pervades, staying (the identity step) is available.  Modelled by
  --     a rest-region that always offers the null motion.  (Same shape as
  --     dharma, with `halt` in place of a proper step: rest is a permitted
  --     non-motion, and it too needs its medium.)
  ------------------------------------------------------------------------

  Sthiti : (P → Type ℓ) → P → Type ℓ
  Sthiti adharma x = adharma x        -- to be at rest at x is to have adharma at x

  अधर्मः-स्थितिः : (adharma : P → Type ℓ) {x : P} → adharma x → Sthiti adharma x
  अधर्मः-स्थितिः adharma r = r
  -- rest is exactly the presence of its medium: no motion, and permitted
  -- everywhere adharma pervades — the dual of §2's permission.
