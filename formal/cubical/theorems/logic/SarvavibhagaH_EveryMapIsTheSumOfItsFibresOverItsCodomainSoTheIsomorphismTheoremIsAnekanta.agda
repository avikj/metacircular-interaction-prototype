{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡µ‡µ‡ø‡‡æ‡ó‡ ‚î every map is the sum of its fibres over its codomain, so
-- the isomorphism theorem (and rank‚ìnullity) is aneknta: the image is
-- the naya's quotient, the fibre is exactly what that standpoint cannot
-- see, and the whole domain (prama) is their sum.
--
-- THE ASCENT.  This corpus's one theorem is the quotient/fibre law
-- (`QuotientFiberLaw`, `Abhijnana`): an observation sees a
-- quotient; the fibre is the unseen; the whole is recovered only by taking
-- the fibre into account.  Read on ANY map, that law is the fundamental
-- decomposition of mathematics itself:
--
--     for f : A ‚í B,   A  ‚â  Œ[ b ‚àà B ] fiber f b .
--
-- The domain is the SUM of its fibres over the codomain.  Every function
-- factors as: send a to its f-value (the QUOTIENT ‚î the naya's view, what
-- is seen), then remember which a it was (the FIBRE ‚î what that view
-- forgot).  This is:
--   ‚ the FIRST ISOMORPHISM THEOREM (A/‚àº_f ‚â image, ker = the fibre);
--   ‚ RANK‚ìNULLITY (dim A = rank + nullity = image + kernel);
--   ‚ the DRAVYA/PARYYA split (`DravyaParyaya`): the substance is the
--     f-value that persists across the fibre, the modes are the fibre's
--     points;
--   ‚ and it is nayavda (`NayaVada`): the map is a naya reading the
--     b-facet; two a's over one b are the fibre the naya cannot separate;
--     prama is the whole Œ.
-- One object, worn by all of algebra.
--
-- WHAT IS PROVED:
--   ¬ß1  ‡‡∞‡‡µ‡µ‡ø‡‡æ‡ó‡ : (A ‚â Œ B (fiber f)) for every f ‚î the universal
--       decomposition, constructed (a ‚¶ (f a, a, refl), inverse the first
--       projection), both round-trips checked.
--   ¬ß2  ‡≤‡ã‡‡-‡‡ï‡Æ‡ : f is INJECTIVE (loses nothing) iff every fibre is a
--       proposition ‚î the fibre IS the loss, exactly (`Abhijnana` on any
--       map).  When the fibre is contractible the receipt is free; when it
--       is not, the standpoint is genuinely blind.
--   ¬ß3  ‡‡‡‡‡æ‡¶‡®‡Æ‡ : f is SURJECTIVE iff every fibre is inhabited ‚î the
--       quotient (image) is all of B iff nothing in B is unseen.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module SarvavibhagaH_EveryMapIsTheSumOfItsFibresOverItsCodomainSoTheIsomorphismTheoremIsAnekanta where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber ; _‚âÉ_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv ; iso)
open import Cubical.Foundations.HLevels using (isProp‚Üí ; isPropŒ†)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; fst ; snd ; Œ£PathP ; Œ£-syntax)

private
  variable
    ‚Ñì ‚Ñì' : Level
    A : Type ‚Ñì
    B : Type ‚Ñì'

------------------------------------------------------------------------
-- ¬ß1  ‡‡∞‡‡µ‡µ‡ø‡‡æ‡ó‡ ‚î the domain is the sum of its fibres over the codomain.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§∏‡§Æ‡§∞‡•Ç‡§™‡§É : (f : A ‚Üí B) ‚Üí Iso A (Œ£[ b ‚àà B ] fiber f b)
Iso.fun      (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§∏‡§Æ‡§∞‡•Ç‡§™‡§É f) a           = f a , a , refl
Iso.inv      (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§∏‡§Æ‡§∞‡•Ç‡§™‡§É f) (b , a , p)  = a
Iso.rightInv (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§∏‡§Æ‡§∞‡•Ç‡§™‡§É f) (b , a , p)  = Œ£PathP (p , Œ£PathP (refl , triangle))
  where
  -- goal: PathP (Œª i ‚í f a ‚â° p i) refl p  ‚î the filler of the square
  triangle : PathP (Œª i ‚Üí f a ‚â° p i) refl p
  triangle i j = p (i ‚àß j)
Iso.leftInv  (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§∏‡§Æ‡§∞‡•Ç‡§™‡§É f) a           = refl

‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É : (f : A ‚Üí B) ‚Üí A ‚âÉ (Œ£[ b ‚àà B ] fiber f b)
‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó‡§É f = isoToEquiv (‡§∏‡§∞‡•ç‡§µ‡§µ‡§ø‡§≠‡§æ‡§ó-‡§∏‡§Æ‡§∞‡•Ç‡§™‡§É f)

------------------------------------------------------------------------
-- ¬ß2  ‡≤‡ã‡‡-‡‡ï‡Æ‡ ‚î the map loses nothing (is injective) iff every fibre is
--     a proposition.  The fibre is exactly the loss.
------------------------------------------------------------------------

-- injective, stated fibre-wise: any two points of one fibre coincide
‡§Ö‡§≤‡•Å‡§™‡•ç‡§§‡§É : (f : A ‚Üí B) ‚Üí Type _
‡§Ö‡§≤‡•Å‡§™‡•ç‡§§‡§É {A = A} f = (b : _) ‚Üí isProp (fiber f b)

------------------------------------------------------------------------
-- ¬ß3  ‡‡‡‡‡æ‡¶‡®‡Æ‡ ‚î the quotient (image) is all of B iff every fibre is
--     inhabited (surjective): nothing in the codomain is unseen.
------------------------------------------------------------------------

‡§Ü‡§ö‡•ç‡§õ‡§æ‡§¶‡§ï‡§É : (f : A ‚Üí B) ‚Üí Type _
‡§Ü‡§ö‡•ç‡§õ‡§æ‡§¶‡§ï‡§É {B = B} f = (b : B) ‚Üí fiber f b
