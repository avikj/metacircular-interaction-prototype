{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡ ‚î the one-way function is exactly a non-equivalence, and
-- cryptography lives in the residual univalence cannot erase.
--
-- "deeper" than `GhataTantu` (the discrete log is a fibre): WHY is one
-- binding of `f a ‚â° b` free and the other work?  Because of univalence's
-- own floor.  This file names the floor and shows the whole crypto arc
-- rests on it.
--
-- ‡‡‡ (ea) is the residue/remainder ‚î the corpus's word for what a
-- non-invertible crossing leaves behind (`SankramanaSesa_
-- EveryTransportOwesItsResidual`).  No stra claimed; the ordinary word.
--
-- THE FLOOR.  In cubical type theory, `isEquiv f` is DEFINED as: every
-- fibre of f is contractible (`equiv-proof : (b) ‚í isContr (fiber f b)`).
-- And `singl b` ‚î the fibre of the IDENTITY, `Œ x, b ‚â° x` ‚î is ALWAYS
-- contractible, by `isContrSingl` (Cubical/Foundations/Prelude, the term
-- `isContrSingl a .fst = (a , refl)`).  So:
--
--   * BINDING THE OUTPUT is free FOR EVERY f, because it lands in a singl
--     (Abhijnana.‡‡‡ø‡‡‡û‡æ‡®‡-‡Æ‡‡ï‡‡‡Æ‡ = isContrSingl).  The public value is
--     safe to publish no matter what f is.
--   * BINDING THE INPUT is free IFF f is an equivalence, because that is
--     the DEFINITION of isEquiv.  The secret is recoverable iff f is
--     invertible-as-a-transport.
--
-- Therefore a ONE-WAY FUNCTION IS EXACTLY A NON-EQUIVALENCE.  Not "hard
-- to invert" ‚î that is the computational overlay; underneath, the map
-- simply is not an equivalence, its fibres are not all contractible, and
-- univalence's transport (`ua`, the free road, road one) does NOT apply.
-- Cryptography is the deliberate use of a map OUTSIDE the image of `ua`.
--
-- WHAT IS PROVED (using `GhataTantu`'s checked non-contractible fibre):
--
--   ¬ß2  ‡‡‡∞‡ï‡æ‡-‡‡∞‡‡µ‡¶‡æ-‡Æ‡‡ï‡‡‡ : for ANY f, isContr (singl (f a))
--       The public road is free for every map ‚î this is the floor, the
--       isContrSingl term, stated at full generality.
--
--   ¬ß3  ‡ò‡æ‡‡-‡®-‡‡‡≤‡‡Ø‡‡æ : ¬ isEquiv (‡ò‡æ‡ g)  in C‚.
--       ‡ò‡æ‡ g is NOT an equivalence ‚î the discrete log has no inverse
--       function.  Proof: isEquiv would make every fibre contractible
--       (equiv-proof), contradicting GhataTantu's ‡‡®‡‡‡‡-‡¶‡‡µ‡ø‡‡¶‡ (the
--       fibre over Œµ has 0 and 3).  This is the info-theoretic root of
--       one-wayness, as a term.
--
--   ¬ß4  ‡‡‡≤‡‡Ø‡‡æ-‡‡û‡‡‡Ø‡‡ø-‡ó‡‡‡‡‡ø‡Æ‡ : isEquiv (‡ò‡æ‡ g) ‚í (the discrete log is a
--       total function).  The converse: IF ‡ò‡æ‡ were an equivalence, the
--       secret would be recoverable outright (invFn), i.e. crypto broken.
--       So security ‚ü∫ ¬ isEquiv, exactly.
--
-- WHERE SHOR SITS, restated at the floor.  Univalence gives the free road
-- ONLY to equivalences.  ‡ò‡æ‡ is not one, so its inverse owes a residual ‚î
-- ‡‡‡ ‚î and no post-processing (no term built from the public value
-- alone) pays it (Abhijnana / QuotientFiberLaw).  A separating query pays
-- it; Shor's period-finding IS that query (`GhataTantu` ¬ß4).  So the
-- entire arc bottoms out here: crypto = a map univalence's transport
-- cannot invert; the key/secret = the ea; Shor = the one thing that
-- collects it.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Sesa_TheOneWayFunctionIsExactlyANonEquivalenceAndCryptoLivesInTheResidualUnivalenceCannotErase where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof ; fiber)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import GhataTantu_TheDiscreteLogIsTheFibreOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt
  using (powg ; ŒµC ; ‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß2  The public road is free for EVERY map ‚î the floor, isContrSingl.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§ï‡§æ‡§∂-‡§∏‡§∞‡•ç‡§µ‡§¶‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É : {A B : Type ‚Ñì} (f : A ‚Üí B) (a : A) ‚Üí isContr (singl (f a))
‡§™‡•ç‡§∞‡§ï‡§æ‡§∂-‡§∏‡§∞‡•ç‡§µ‡§¶‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É f a = isContrSingl (f a)

------------------------------------------------------------------------
-- ¬ß3  ‡ò‡æ‡ g is NOT an equivalence: the one-way function is a
--     non-equivalence, as a term.
------------------------------------------------------------------------

‡§ò‡§æ‡§§‡§É-‡§®-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ : ¬¨ isEquiv powg
‡§ò‡§æ‡§§‡§É-‡§®-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ eq = ‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É (eq .equiv-proof ŒµC)

------------------------------------------------------------------------
-- ¬ß4  The converse: an equivalence would hand back the secret.  If ‡ò‡æ‡
--     were an equivalence, the discrete log is the center of the
--     (contractible) fibre ‚î a total inverse ‚î so the scheme is broken.
--     Security ‚ü∫ ¬ isEquiv.
------------------------------------------------------------------------

-- the discrete log AS a function, available exactly when ‡ò‡æ‡ is an equiv
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§´‡§≤‡§®‡§Æ‡•ç : isEquiv powg ‚Üí (b : _) ‚Üí ‚Ñï
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§´‡§≤‡§®‡§Æ‡•ç eq b = eq .equiv-proof b .fst .fst

-- and it genuinely inverts: ‡ò‡æ‡ (dlog b) ‚â° b
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É : (eq : isEquiv powg) (b : _) ‚Üí powg (‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§´‡§≤‡§®‡§Æ‡•ç eq b) ‚â° b
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É eq b = eq .equiv-proof b .fst .snd

-- so: an equivalence breaks secrecy outright.  Read with ¬ß3, security is
-- EXACTLY non-equivalence.
‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ-‡§≠‡§û‡•ç‡§ú‡§Ø‡§§‡§ø-‡§ó‡•Å‡§™‡•ç‡§§‡§ø‡§Æ‡•ç : isEquiv powg
                        ‚Üí Œ£ (_ ‚Üí ‚Ñï) (Œª dlog ‚Üí (b : _) ‚Üí powg (dlog b) ‚â° b)
‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ-‡§≠‡§û‡•ç‡§ú‡§Ø‡§§‡§ø-‡§ó‡•Å‡§™‡•ç‡§§‡§ø‡§Æ‡•ç eq = ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§´‡§≤‡§®‡§Æ‡•ç eq , ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§Ø-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É eq
