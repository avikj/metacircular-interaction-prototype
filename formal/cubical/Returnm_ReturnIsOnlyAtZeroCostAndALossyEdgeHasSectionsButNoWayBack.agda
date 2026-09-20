{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î ‡‡‡®‡‡Ø-‡µ‡‡Ø‡Ø‡‡® ‡‡µ ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‡
--
-- (return only at zero cost.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE WORD THIS CORPUS IS NAMED AFTER, AS A NO-GO.  ‡‡‡‡‡∞ ‡ß‡ says return
-- is only at zero cost, and README movement 6 reads that as chronology
-- protection: you cannot come back with an unpaid debt.  This is the
-- minimal term.
--
-- The asymmetry is sharper than "a lossy map is not invertible", and it
-- is the whole content.  `Bool ‚í Unit` HAS a right inverse: leave the
-- codomain, pick a preimage, come back, and you are exactly where you
-- started ‚î `‡‡‡∞‡‡ø‡µ‡‡®‡Æ‡` below, and `Varanam_‚¶agda` ¬ß‡© exhibits two such
-- choices.  What it does NOT have is a left inverse: leave the DOMAIN and
-- there is no way back to the point you left.
--
--   ¬ out and back, in the codomain : always available, at any loss
--   ¬ out and back, in the DOMAIN   : available exactly at zero loss
--
-- So a debt does not stop you moving and does not stop you returning to
-- a description.  It stops you returning to the THING.  ¬ß‡© is that, and
-- ¬ß‡ is its converse: at zero defect the way back exists and is the
-- equivalence's own inverse.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Punaragamanam_ReturnIsOnlyAtZeroCostAndALossyEdgeHasSectionsButNoWayBack where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEq ; retEq ; secEq)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ the lossy edge.
------------------------------------------------------------------------

‡§≤‡•ã‡§™‡§É : Bool ‚Üí Unit
‡§≤‡•ã‡§™‡§É _ = tt

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡ø‡∞‡‡ó‡Æ‡®-‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î out and back IN THE CODOMAIN is free, at any
--     loss.  Pick any preimage; you return to where you started.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É : Unit ‚Üí Bool
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É _ = true

‡§¨‡§π‡§ø‡§É-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : (u : Unit) ‚Üí ‡§≤‡•ã‡§™‡§É (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É u) ‚â° u
‡§¨‡§π‡§ø‡§É-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç _ = refl

------------------------------------------------------------------------
-- ‡© ¬ ‡‡®‡‡‡-‡‡‡®‡∞‡æ‡ó‡Æ‡®‡ ‡®‡æ‡‡‡‡ø ‚î AND OUT AND BACK IN THE DOMAIN IS NOT
--     AVAILABLE.  No map back returns every point to itself, and the
--     obstruction is exactly the bit that was destroyed.
--
-- This is the no-go: a debt does not stop you moving and does not stop
-- you returning to a DESCRIPTION.  It stops you returning to the THING.
------------------------------------------------------------------------

‡§Ö‡§®‡•ç‡§§‡§É-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø : ¬¨ (Œ£[ r ‚àà (Unit ‚Üí Bool) ] ((b : Bool) ‚Üí r (‡§≤‡•ã‡§™‡§É b) ‚â° b))
‡§Ö‡§®‡•ç‡§§‡§É-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø (r , ret) = false‚â¢true (sym (ret false) ‚àô ret true)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡®‡‡Ø-‡µ‡‡Ø‡Ø‡ ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î and at zero defect the way back exists,
--     both ways, and it is the edge's own inverse.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (e : A ‚âÉ B) where

  ‡§Ö‡§®‡•ç‡§§‡§É-‡§Ü‡§ó‡§Æ‡§®‡§Æ‡•ç : (a : A) ‚Üí invEq e (e .fst a) ‚â° a
  ‡§Ö‡§®‡•ç‡§§‡§É-‡§Ü‡§ó‡§Æ‡§®‡§Æ‡•ç = retEq e

  ‡§¨‡§π‡§ø‡§É-‡§Ü‡§ó‡§Æ‡§®‡§Æ‡•ç : (b : B) ‚Üí e .fst (invEq e b) ‚â° b
  ‡§¨‡§π‡§ø‡§É-‡§Ü‡§ó‡§Æ‡§®‡§Æ‡•ç = secEq e
