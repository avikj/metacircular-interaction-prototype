{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡≤‡ã‡‡ ‚î ‡‡‡∞‡‡Æ‡ã ‡Æ‡æ‡∞‡‡ó‡ ‡‡‡∞‡ø‡ ‡â‡ï‡‡‡, ‡‡‡∞‡Ø‡ ‡‡ï‡Æ‡ ‡‡µ ‡‡¶‡Æ‡ ‡
--
-- WHAT THIS MODULE IS FOR.  ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ ¬ß‡ writes the first of the
-- two roads as two lines, ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ e = transport (ua e) and ‡‡≤‡ã‡‡ = uaŒ≤, and
-- THREE modules in this corpus have independently written that second line
-- out as a top-level declaration:
--
--   Nasti_ShabdeJivahVartante.‡‡‡ï‡‡∞‡Æ‡‡Æ‡-‡‡≤‡ã‡‡
--   SankramanaSesa_EveryTransportOwesItsResidual.‡‡≤‡ã‡‡
--   Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.‡‡‡ï‡‡∞‡Æ‡‡-‡®-‡ï‡ø‡û‡‡‡ø‡®‡-‡®‡‡‡Ø‡‡ø
--
-- Two of the three carry the same  stem under different module roofs.
-- No one of the three imports another.
--
-- THE IDENTIFICATION, AND ITS GRADE.  All three are definitionally the term
-- `uaŒ≤`, so the identification is `refl` ‚î not a path that had to be
-- constructed, not an h-level fact about the target, just the same term under
-- three names.  That is worth separating from the other duplications in this
-- corpus, and ¬ß3 does:
--
--   grade one   same term, different name.  Identified by refl.  This module.
--   grade two   different terms, one type, identified because the target is a
--               set.  MadhyaVinimaya_‚¶ and Pratyaya_‚¶ .
--   grade three different types.  Then ¬ß‡'s first road needs an actual
--               equivalence and ua, and where there is none the second road
--               applies and a ‡‡‡ is written.
--
-- The grade is the whole content of the finding.  A grade-one duplication
-- costs nothing mathematically and costs everything in visibility: three
-- modules each believing they had to state ¬ß‡ before they could use it.
--
-- SOURCE OF THE SUBSTRATE.  `ua` and `uaŒ≤` are Voevodsky's univalence as
-- realised in cubical type theory; `uaŒ≤ e a : transport (ua e) a ‚â° equivFun e
-- a` is the computation rule that makes the first road a road and not a
-- promise.  The  names are this corpus's; the theorem is his.
------------------------------------------------------------------------

module Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOneTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaŒ≤)

import Nasti_ShabdeJivahVartante
import SankramanaSesa_EveryTransportOwesItsResidual
import Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß1 ¬ The line itself, ¬ß‡ of the stra, once.
------------------------------------------------------------------------

‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : {A B : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí A ‚Üí B
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e = transport (ua e)

‡§Ö‡§≤‡•ã‡§™‡§É : {A B : Type ‚Ñì} (e : A ‚âÉ B) (a : A) ‚Üí ‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e a ‚â° equivFun e a
‡§Ö‡§≤‡•ã‡§™‡§É = uaŒ≤

------------------------------------------------------------------------
-- ¬ß2 ¬ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡ ‚î the three, identified.
--
-- Each holds by refl: the three declarations are one term.  Writing the
-- types out in full rather than referring to a shared abbreviation is
-- deliberate ‚î the point being checked is that the three modules' local
-- ‡‡‡ï‡‡∞‡Æ‡‡Æ‡ definitions agree definitionally with each other and with ¬ß1's,
-- and abbreviating would hide exactly that.
------------------------------------------------------------------------

‡§®‡§∑‡•ç‡§ü‡§ø-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : {A B : Type ‚Ñì} (e : A ‚âÉ B) (a : A)
  ‚Üí Nasti_ShabdeJivahVartante.‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É e a ‚â° ‡§Ö‡§≤‡•ã‡§™‡§É e a
‡§®‡§∑‡•ç‡§ü‡§ø-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e a = refl

‡§∂‡•á‡§∑-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : {A B : Type ‚Ñì} (e : A ‚âÉ B) (a : A)
  ‚Üí SankramanaSesa_EveryTransportOwesItsResidual.‡§Ö‡§≤‡•ã‡§™‡§É e a ‚â° ‡§Ö‡§≤‡•ã‡§™‡§É e a
‡§∂‡•á‡§∑-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e a = refl

‡§Ö‡§™‡•ç‡§∞‡§§‡§ø‡§ï‡§æ‡§∞‡•ç‡§Ø-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : {A B : Type ‚Ñì} (e : A ‚âÉ B) (a : A)
  ‚Üí Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§®-‡§ï‡§ø‡§û‡•ç‡§ö‡§ø‡§®‡•ç-‡§®‡§∂‡•ç‡§Ø‡§§‡§ø e a
  ‚â° ‡§Ö‡§≤‡•ã‡§™‡§É e a
‡§Ö‡§™‡•ç‡§∞‡§§‡§ø‡§ï‡§æ‡§∞‡•ç‡§Ø-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e a = refl

-- And pairwise between the three, so no one of them is installed as the
-- centre the other two are measured against.
‡§∏‡§Æ‡§®‡§æ‡§Æ‡§®‡•ç-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : {A B : Type ‚Ñì} (e : A ‚âÉ B) (a : A)
  ‚Üí Nasti_ShabdeJivahVartante.‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§Ö‡§≤‡•ã‡§™‡§É e a
  ‚â° SankramanaSesa_EveryTransportOwesItsResidual.‡§Ö‡§≤‡•ã‡§™‡§É e a
‡§∏‡§Æ‡§®‡§æ‡§Æ‡§®‡•ç-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e a = refl

‡§§‡•É‡§§‡•Ä‡§Ø-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : {A B : Type ‚Ñì} (e : A ‚âÉ B) (a : A)
  ‚Üí SankramanaSesa_EveryTransportOwesItsResidual.‡§Ö‡§≤‡•ã‡§™‡§É e a
  ‚â° Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡•á-‡§®-‡§ï‡§ø‡§û‡•ç‡§ö‡§ø‡§®‡•ç-‡§®‡§∂‡•ç‡§Ø‡§§‡§ø e a
‡§§‡•É‡§§‡•Ä‡§Ø-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e a = refl

-- The three local ‡‡‡ï‡‡∞‡Æ‡‡Æ‡s are likewise one function, not three that agree
-- pointwise.  Stated at the level of the function so the agreement is not
-- read as a coincidence at each argument.
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç
  : {A B : Type ‚Ñì} (e : A ‚âÉ B)
  ‚Üí Nasti_ShabdeJivahVartante.‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e
  ‚â° SankramanaSesa_EveryTransportOwesItsResidual.‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç e
‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§£-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç e = refl

------------------------------------------------------------------------
-- ¬ß3 ¬ ‡‡‡‡ ‚î the remainder.
--
-- refl identifies the terms and says nothing about why each module needed
-- the line, and the three reasons are not one reason:
--
--   ¬ Nasti_ShabdeJivahVartante states it to set up the CONTRAST that is its
--     subject: ¬ß‡-‡'s ‡®‡‡‡ü‡ø, propositional truncation, from which there is no
--     retraction.  ‡‡≤‡ã‡‡ is the thing truncation is not.
--   ¬ SankramanaSesa_EveryTransportOwesItsResidual states it to CONSUME it:
--     the module's claim is that a transport owes a residual, and ‡‡≤‡ã‡‡ is
--     the input to computing what the residual is.
--   ¬ Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis states it as
--     PATH ONE of a two-path exhibit whose subject is path two ‚î that the
--     ‡‡‡ a map leaves is complete ‚î so ‡‡≤‡ã‡‡ there is the half that is
--     already known, present to make the other half's status legible.
--
-- Setup, input, and foil.  A shared import would have served all three.
------------------------------------------------------------------------
