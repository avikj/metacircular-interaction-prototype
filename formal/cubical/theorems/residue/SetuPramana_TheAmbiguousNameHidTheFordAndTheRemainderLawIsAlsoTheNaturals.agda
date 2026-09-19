{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡-‡‡‡∞‡Æ‡æ‡‡Æ‡ ‚î the second seam ford: ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ ‚â° ‚ï.
--
-- `‚ü®ambig‚ü©.‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡` heads a 7-bank component (the ‡∞‡æ‡‡‡∞‡ø census bases)
-- SEPARATE from the 13-bank component holding ‚ï, ‡µ‡ø‡µ‡‡ï, ‡‡®‡‡¶‡‡ ‚î even though
-- `VivekaPramana‚¶‚ïó‚ï‚â°‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡` was already landed.  The split is partly
-- an artifact of ambiguous naming in the snapshot, and partly real: no
-- checked term joined ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ to ‚ï itself.  This file supplies that
-- term, so the join no longer rests on name-resolution.  Joining 7 to 13
-- is +91 free crossings ‚î the largest merge available on the board.
--
-- The content is one composition.  VivekaPramana pays ‚ïó‚ï ‚â ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡;
-- SetuYugma pays (‚ïó‚ï) ‚â ‚ï; the composite is free ‚î ‡‡æ‡µ‡®‡æ, again: two
-- landed solutions meet, the third arises, all three survive.
--
-- No source claimed; the compound ‡‡‡‡-‡‡‡∞‡Æ‡æ‡ is built here, 2026-08-23.
------------------------------------------------------------------------

module SetuPramana_TheAmbiguousNameHidTheFordAndTheRemainderLawIsAlsoTheNaturals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma using (_√ó_)

open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats
  using (‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ; iso‚Ñï√ó‚Ñï-‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£)
open import SetuYugma_TheSeamFordJoinsTheValliToPingalaAndVivekaIsTheNaturalNumbers
  using (‡§Ø‡•Å‡§ó‡•ç‡§Æ‚âÉ‚Ñï)

‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‚âÉ‚Ñï : ‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚âÉ ‚Ñï
‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‚âÉ‚Ñï = compEquiv (invEquiv (isoToEquiv iso‚Ñï√ó‚Ñï-‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£)) ‡§Ø‡•Å‡§ó‡•ç‡§Æ‚âÉ‚Ñï

‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‚â°‚Ñï : ‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚â° ‚Ñï
‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‚â°‚Ñï = ua ‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‚âÉ‚Ñï
