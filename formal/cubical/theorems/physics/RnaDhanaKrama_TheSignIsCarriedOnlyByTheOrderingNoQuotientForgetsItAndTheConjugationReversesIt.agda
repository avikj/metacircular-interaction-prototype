{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à‹à-à§à¨-à•àà°à®à â” the order on signed magnitude.  Brahmagupta's a (debt)
-- and dhana (asset) ARE the two signs; the sign of an integer is the datum
-- an ORDERING carries, that no quotient forgets *to*, and that the sign
-- conjugation reverses.  This is the crystal's Order-edge fact
-- (runtime/CRYSTAL.md Â§1) and POSITIVITY_HAS_A_PLACE's "the ordering is the
-- avacchedaka (limitor)", made elementary and exact over â.
--
-- THE CONVERGENCE (owner's directive; the reading, not re-proved here).
-- One theorem in six vocabularies, each a face of "sign is preserved by no
-- averaging":
--   â positivity is a point of Sper K, chart-free only because |Sper â|=1
--                          (POSITIVITY_HAS_A_PLACE; Artinâ“Schreier 1927)
--   â Galois conjugation swaps the orderings âŸ (Iso;Order) unlicensed
--   â the runtime carries sign on exactly one of eleven edges, Order, and
--     no path through a Quotient delivers it        (runtime/CRYSTAL.md Â§1)
--   â the sieve's parity charge (âˆ’1,â¦,âˆ’1) is invisible to every averaging
--                                                              (TARGET.md)
--
-- CHECKED over â (Cubical.Data.Int):
--   Â§1  the sign conjugation neg (âˆ’_) is an involution â” the Iso edge.
--   Â§2  neg PRESERVES the quotient abs:  abs (âˆ’ n) â‰¡ abs n.  (Iso;Quotient)
--       is licensed â” an isomorphism composes with a quotient.
--   Â§3  neg REVERSES the order sign:  sign (âˆ’ n) â‰¡ flip (sign n).  So
--       (Iso;Order) is NOT the identity on sign: the conjugation swaps the
--       ordering, exactly the one edge pair the crystal refuses.
--   Â§4  sign does NOT factor through abs (the quotient that forgets sign):
--       Â Î[ s âˆˆ (â• â’ Sign) ] (âˆ n â’ s (abs n) â‰¡ sign n).
--   Â§5  the abs-fibre over a positive value is the two-point {n, âˆ’n}, split
--       by sign â” sign is exactly what the quotient forgets, and it is an
--       order datum, so only an Order edge recovers it.
--
-- FENCE.  The genuine multi-cone fork needs a field with |Sper K| > 1
-- (â(âˆ2): xÂ² âˆ’ âˆ2 yÂ² definite at one ordering, indefinite at the other),
-- which needs the real embedding and is NOT built here.  â carries the one
-- ordering, so this is the minimal faithful model of the Order edge, not
-- the fork.  Sources: Brahmagupta, Brhmasphuasiddhnta 18 (628), the
-- a/dhana sign rules; Artinâ“Schreier 1927 (formally real fields), via
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module RnaDhanaKrama_TheSignIsCarriedOnlyByTheOrderingNoQuotientForgetsItAndTheConjugationReversesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤; pos; negsuc; -_; abs)
open import Cubical.Data.Nat using (â„•; zero; suc)
open import Cubical.Data.Bool using (Bool; true; false; trueâ‰¢false)
open import Cubical.Data.Sigma using (Î£; Î£-syntax; _,_; _Ã—_)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- à‹à / ààà¨àà¯ / à§à¨ â” debt, void, asset: Brahmagupta's three signs.
data Sign : Type where
  rna   : Sign     -- á¹›á¹‡a   Â· negative
  sunya : Sign     -- Å›Å«nya Â· zero
  dhana : Sign     -- dhana Â· positive

sign : â„¤ â†’ Sign
sign (pos zero)    = sunya
sign (pos (suc _)) = dhana
sign (negsuc _)    = rna

-- viparyaya â” the reversal: a â” dhana, nya fixed.
flip : Sign â†’ Sign
flip rna   = dhana
flip sunya = sunya
flip dhana = rna

------------------------------------------------------------------------
-- Â§1 Â The Iso edge: the sign conjugation is an involution.
neg-involution : (n : â„¤) â†’ - (- n) â‰¡ n
neg-involution (pos zero)    = refl
neg-involution (pos (suc _)) = refl
neg-involution (negsuc _)    = refl

------------------------------------------------------------------------
-- Â§2 Â (Iso ; Quotient) is licensed: neg preserves abs.
neg-preserves-abs : (n : â„¤) â†’ abs (- n) â‰¡ abs n
neg-preserves-abs (pos zero)    = refl
neg-preserves-abs (pos (suc _)) = refl
neg-preserves-abs (negsuc _)    = refl

------------------------------------------------------------------------
-- Â§3 Â (Iso ; Order) is NOT the identity on sign: neg reverses it.
neg-reverses-sign : (n : â„¤) â†’ sign (- n) â‰¡ flip (sign n)
neg-reverses-sign (pos zero)    = refl
neg-reverses-sign (pos (suc _)) = refl
neg-reverses-sign (negsuc _)    = refl

------------------------------------------------------------------------
-- the two nonzero signs are distinct (a Sign is not a Bool: it is the
-- three-verdict codomain a/nya/dhana, never a two-valued collapse).
private
  tag : Sign â†’ Bool
  tag dhana = true
  tag _     = false

rnaâ‰¢dhana : Â¬ (rna â‰¡ dhana)
rnaâ‰¢dhana p = trueâ‰¢false (sym (cong tag p))

------------------------------------------------------------------------
-- Â§4 Â sign does NOT factor through abs.  No reader s of the magnitude
-- alone can reproduce the sign: the two integers Â1 share a magnitude and
-- differ in sign, so s(1) would have to be both dhana and a.
signNotThroughAbs :
  Â¬ (Î£[ s âˆˆ (â„• â†’ Sign) ] ((n : â„¤) â†’ s (abs n) â‰¡ sign n))
signNotThroughAbs (s , e) =
  rnaâ‰¢dhana (sym (e (negsuc zero)) âˆ™ e (pos (suc zero)))

------------------------------------------------------------------------
-- Â§5 Â the abs-fibre over a positive magnitude is the two-point {n, âˆ’n},
-- carrying the same quotient value and separated exactly by sign.
absFibreIsSplitBySign :
  (abs (pos (suc zero)) â‰¡ abs (negsuc zero))
  Ã— (Â¬ (sign (pos (suc zero)) â‰¡ sign (negsuc zero)))
absFibreIsSplitBySign = refl , Î» p â†’ rnaâ‰¢dhana (sym p)
