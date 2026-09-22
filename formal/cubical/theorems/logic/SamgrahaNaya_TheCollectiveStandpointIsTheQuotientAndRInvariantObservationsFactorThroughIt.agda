{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ô‡‡ó‡‡∞‡‡®‡Ø‡ ‚î the collective standpoint IS the quotient: an R-invariant
-- observation is exactly a map out of A/R.  The universal property of
-- quotients, read as one of the seven nayas.
--
-- THE ASCENT (continuing `SarvavibhagaH`).  Among the seven nayas
-- (`NayaVada`, Tattvrthastra 1.34) the SAGRAHA-naya is the collective
-- standpoint: it grasps particulars under a universal, identifying what a
-- chosen relation makes the same.  In mathematics that operation is the
-- QUOTIENT.  And the quotient's universal property is exactly the naya's
-- character: an observation that RESPECTS the relation R (identifies
-- R-related things ‚î sees only the collected universal, blind to the
-- within-class distinction) is precisely a map out of A / R.
--
--     (A ‚í B) respecting R    ‚â    (A / R ‚í B)          [B a set]
--
-- So the sagraha-naya is not a metaphor for the quotient; it is the
-- quotient's universal property.  The fibre of the quotient map over a
-- class is the class itself ‚î exactly what the collective standpoint
-- cannot separate (the fibre law, `SarvavibhagaH`, `QuotientFiberLaw`).
--
-- WHAT IS PROVED:
--   ¬ß2  ‡‡ô‡‡ó‡‡∞‡-‡‡æ‡∞‡‡µ‡‡‡∞‡ø‡ï‡Æ‡ : (A ‚í B respecting R) ‚â (A/R ‚í B), for B a
--       set ‚î the universal property (library's `setQuotUniversal`), named
--       as the naya: an R-invariant observation IS a factoring through the
--       collective standpoint, and uniquely.
--   ¬ß3  ‡‡‡∞‡Æ‡æ‡‡Æ‡-‡‡‡‡‡æ‡¶‡Ø‡‡ø : the quotient map [_] : A ‚í A/R is surjective
--       ‚î prama (all of A) covers every collected class; no class is
--       unseen.
--   ¬ß4  ‡ï‡ï‡‡‡‡Ø‡æ-‡≤‡ã‡‡ : the collective standpoint is genuinely BLIND within
--       a class: if R a b then [ a ] ‚â° [ b ] ‚î R-related particulars are
--       identified, their difference is the fibre the naya forgets.
------------------------------------------------------------------------

module SamgrahaNaya_TheCollectiveStandpointIsTheQuotientAndRInvariantObservationsFactorThroughIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.HITs.SetQuotients using (_/_ ; [_] ; eq/ ; setQuotUniversal)
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; Œ£-syntax)

private
  variable
    ‚Ñì ‚Ñì' ‚Ñì'' : Level

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} (R : A ‚Üí A ‚Üí Type ‚Ñì'') where

  ------------------------------------------------------------------------
  -- ¬ß2  ‡‡ô‡‡ó‡‡∞‡-‡‡æ‡∞‡‡µ‡‡‡∞‡ø‡ï‡Æ‡ ‚î an R-invariant observation is exactly a map
  --     out of the collective standpoint (the quotient).
  ------------------------------------------------------------------------

  -- the R-respecting observations of A: standpoints that identify R-related
  -- particulars (see only the collected universal)
  ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π-‡§¶‡•É‡§∑‡•ç‡§ü‡§ø : Type _
  ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π-‡§¶‡•É‡§∑‡•ç‡§ü‡§ø = Œ£[ f ‚àà (A ‚Üí B) ] ((a b : A) ‚Üí R a b ‚Üí f a ‚â° f b)

  ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π-‡§∏‡§æ‡§∞‡•ç‡§µ‡§§‡•ç‡§∞‡§ø‡§ï‡§Æ‡•ç : isSet B ‚Üí (A / R ‚Üí B) ‚âÉ ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π-‡§¶‡•É‡§∑‡•ç‡§ü‡§ø
  ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π-‡§∏‡§æ‡§∞‡•ç‡§µ‡§§‡•ç‡§∞‡§ø‡§ï‡§Æ‡•ç Bset = setQuotUniversal Bset

------------------------------------------------------------------------
-- ¬ß3  ‡‡‡∞‡Æ‡æ‡‡Æ‡-‡‡‡‡‡æ‡¶‡Ø‡‡ø ‚î the quotient map covers every class.
-- ¬ß4  ‡ï‡ï‡‡‡‡Ø‡æ-‡≤‡ã‡‡ ‚î R-related particulars are identified (the blindness).
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} {R : A ‚Üí A ‚Üí Type ‚Ñì'} where

  ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π‡§É : A ‚Üí A / R                       -- the collective standpoint's map
  ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π‡§É a = [ a ]

  -- prama covers: every class is [ a ] for some a (surjectivity, as the
  -- image-inhabitation of SarvavibhagaH.‡‡‡‡‡æ‡¶‡ï‡, propositionally)
  open import Cubical.HITs.SetQuotients using (elimProp)
  open import Cubical.Foundations.HLevels using (isPropŒ†)
  open import Cubical.HITs.PropositionalTruncation using (‚à•_‚à•‚ÇÅ ; isPropPropTrunc)

  ‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç-‡§Ü‡§ö‡•ç‡§õ‡§æ‡§¶‡§Ø‡§§‡§ø : (x : A / R) ‚Üí ‚à• Œ£[ a ‚àà A ] (‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π‡§É a ‚â° x) ‚à•‚ÇÅ
  ‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç-‡§Ü‡§ö‡•ç‡§õ‡§æ‡§¶‡§Ø‡§§‡§ø = elimProp (Œª _ ‚Üí isPropPropTrunc) (Œª a ‚Üí ‚à£ a , refl ‚à£‚ÇÅ)

  -- the blindness: R a b ‚ü the collective standpoint identifies a and b
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§≤‡•ã‡§™‡§É : (a b : A) ‚Üí R a b ‚Üí ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π‡§É a ‚â° ‡§∏‡§ô‡•ç‡§ó‡•ç‡§∞‡§π‡§É b
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§≤‡•ã‡§™‡§É a b r = eq/ a b r
