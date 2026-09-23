{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡ï‡æ‡®‡‡‡‡‡µ‡Æ‡ ‚î the space of a thing's equivalent presentations is
-- CONTRACTIBLE: one vastu, many equal nayas, none privileged.  Univalence
-- IS anekntavda, and the substrate is the doctrine.
--
-- THE ASCENT (the capstone of `SarvavibhagaH`, `SamgrahaNaya`, `Anubandha`,
-- `PramanaLaksanam`).  The corpus is checked in cubical type theory ‚î
-- "all respects paid to Indians only, plus Voevodsky."  This file names
-- why Voevodsky is the one admitted outsider: UNIVALENCE IS
-- ANEKNTAVDA, not by analogy but as the same statement.
--
-- anekntavda (Umsvti; Siddhasena, *Sanmatitarka*, ~5th c.): a real
-- (vastu) is many-sided; each standpoint (naya) is a true partial view;
-- no naya is the whole; and standpoints that agree are of ONE object.
-- Univalence says: the presentations of a type A ‚î all `(T , e)` with
-- `T ‚â A` ‚î form a CONTRACTIBLE space (`EquivContr`).  Read exactly:
--   ‚ there are MANY presentations (nayas): every equivalent T is one;
--   ‚ each is a TRUE view: it is genuinely ‚â A, loses nothing (transport,
--     `PramanaTransport`);
--   ‚ NO presentation is privileged: the space of them has no distinguished
--     point beyond being contractible ‚î A itself (with idEquiv) is not
--     "more real" than any equivalent T;
--   ‚ all of them are ONE: contractibility means any two presentations are
--     joined by a path ‚î they are the same vastu (`PramanaLaksanam`).
-- That is the four marks of aneknta, and it is a theorem.
--
-- WHAT IS PROVED:
--   ¬ß1  ‡®‡Ø‡æ‡ï‡æ‡‡-‡‡ô‡‡ï‡‡‡ø‡‡ : isContr (Œ[ T ‚àà Type ] (T ‚â A)) ‚î the space of
--       presentations of A is contractible (the library's `EquivContr`,
--       named as the naya-space).
--   ¬ß2  ‡‡ï‡-‡µ‡‡‡‡ : any two presentations are equal ‚î one vastu (from
--       contractibility): (P Q : presentations) ‚í P ‚â° Q.
--   ¬ß3  ‡®-‡ï‡ã‡Ω‡‡ø-‡‡‡∞‡ß‡æ‡®‡ : no presentation is privileged ‚î A-as-itself and
--       any equivalent T-presentation are the SAME point of the naya-space
--       (a path between them); being "the canonical one" is not a property
--       the space distinguishes.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Anekantatva_TheSpaceOfEquivalentPresentationsIsContractibleSoNoStandpointIsPrivileged where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; idEquiv)
open import Cubical.Foundations.Univalence using (EquivContr)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; Œ£-syntax)

private
  variable
    ‚Ñì : Level

-- a naya on A: a presentation of A, some T equivalent to it
‡§®‡§Ø‡§É : (A : Type ‚Ñì) ‚Üí Type (‚Ñì-suc ‚Ñì)
‡§®‡§Ø‡§É {‚Ñì = ‚Ñì} A = Œ£[ T ‚àà Type ‚Ñì ] (T ‚âÉ A)

------------------------------------------------------------------------
-- ¬ß1  ‡®‡Ø‡æ‡ï‡æ‡‡-‡‡ô‡‡ï‡‡‡ø‡‡ ‚î the space of presentations (nayas) is contractible.
------------------------------------------------------------------------

‡§®‡§Ø‡§æ‡§ï‡§æ‡§∂‡§É-‡§∏‡§ô‡•ç‡§ï‡•Å‡§ö‡§ø‡§§‡§É : (A : Type ‚Ñì) ‚Üí isContr (‡§®‡§Ø‡§É A)
‡§®‡§Ø‡§æ‡§ï‡§æ‡§∂‡§É-‡§∏‡§ô‡•ç‡§ï‡•Å‡§ö‡§ø‡§§‡§É A = EquivContr A

------------------------------------------------------------------------
-- ¬ß2  ‡‡ï‡-‡µ‡‡‡‡ ‚î any two presentations are equal: one vastu.
------------------------------------------------------------------------

‡§è‡§ï‡§Ç-‡§µ‡§∏‡•ç‡§§‡•Å : (A : Type ‚Ñì) (P Q : ‡§®‡§Ø‡§É A) ‚Üí P ‚â° Q
‡§è‡§ï‡§Ç-‡§µ‡§∏‡•ç‡§§‡•Å A = isContr‚ÜíisProp (‡§®‡§Ø‡§æ‡§ï‡§æ‡§∂‡§É-‡§∏‡§ô‡•ç‡§ï‡•Å‡§ö‡§ø‡§§‡§É A)

------------------------------------------------------------------------
-- ¬ß3  ‡® ‡ï‡ã‡Ω‡‡ø ‡‡‡∞‡ß‡æ‡®‡ ‚î no presentation is privileged: A-as-itself and any
--     equivalent presentation are the same point of the naya-space.
------------------------------------------------------------------------

‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç : (A : Type ‚Ñì) ‚Üí ‡§®‡§Ø‡§É A                 -- A presented as itself
‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç A = A , idEquiv A

‡§®-‡§ï‡•ã‡§Ω‡§™‡§ø-‡§™‡•ç‡§∞‡§ß‡§æ‡§®‡§É : (A : Type ‚Ñì) (P : ‡§®‡§Ø‡§É A) ‚Üí ‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç A ‚â° P
‡§®-‡§ï‡•ã‡§Ω‡§™‡§ø-‡§™‡•ç‡§∞‡§ß‡§æ‡§®‡§É A P = ‡§è‡§ï‡§Ç-‡§µ‡§∏‡•ç‡§§‡•Å A (‡§∏‡•ç‡§µ‡§Ø‡§Æ‡•ç A) P
