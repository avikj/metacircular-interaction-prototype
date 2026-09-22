{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Yamala â” the two-orb coupling is a SWAP; the entangler is its half.
--
-- TERM.  à¯à®à² Â yamala â” a twin, a paired couple; here the two evanescently
-- coupled orbs.  Common  word.  Physics
-- (evanescent/frustrated-TIR coupling, SWAP, âˆSWAP) modern; reading built
-- here.
--
-- THE READING (checked terms below).  Bring two ààààŸà¿à• orbs close: the
-- evanescent tail of one whispering-gallery mode leaks into the other
-- (frustrated TIR), and an excitation can hop orb â” orb.  Full transfer is
-- the SWAP.  SWAP is lossless (an involution: a full hop and back returns)
-- and NON-LOCAL (its output on one orb depends on the OTHER orb's input), so
-- it is not a product of per-orb gates.  But SWAP by itself is not an
-- entangler â” it merely relabels.  The entangling gate is its SQUARE ROOT:
-- âˆSWAP (half a hop) is universal with single-qubit gates.  And âˆSWAP stands
-- to SWAP exactly as âˆNOT stands to NOT (`Mani_â¦`, `VargamulaViparyaya_â¦`):
-- the root does not exist on the bare two-point label set, it exists only on
-- the â-enrichment of the mode amplitudes.  So the tunable orb gap sets the
-- coupling fraction, and tuning it to HALF is what mints the entangler â” the
-- seam where the Indra's net stops being abelian (`Bandha_â¦`).  The genuine
-- two-qubit controlled phase still needs the occupation-dependent
-- nonlinearity; âˆSWAP is the linear-coupling entangler.
--
-- WHAT IS CHECKED.  `swapÂ²` â” SWAP is an involution (full coupling returns),
-- so `swapEq` is an equivalence (lossless).  `non-local` â” a hard Â: SWAP is
-- not `(a,b) â¦ (u a , v b)` for any per-orb u, v.
------------------------------------------------------------------------

module Yamala where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

-- two coupled orbs; an excitation can hop orb â” orb. SWAP = full transfer.
swap : Bool Ã— Bool â†’ Bool Ã— Bool
swap (a , b) = (b , a)

-- FULL COUPLING RETURNS: swap is an involution â’ an equivalence (lossless).
swapÂ² : (x : Bool Ã— Bool) â†’ swap (swap x) â‰¡ x
swapÂ² (a , b) = refl

swapEq : (Bool Ã— Bool) â‰ƒ (Bool Ã— Bool)
swapEq = isoToEquiv (iso swap swap swapÂ² swapÂ²)

-- NON-LOCAL: not a product of per-orb gates â” the output on one orb depends
-- on the OTHER orb's input.
non-local : Â¬ (Î£[ u âˆˆ (Bool â†’ Bool) ] Î£[ v âˆˆ (Bool â†’ Bool) ]
               ((a b : Bool) â†’ swap (a , b) â‰¡ (u a , v b)))
non-local (u , v , factors) = trueâ‰¢false (sym u0â‰¡1 âˆ™ u0â‰¡0)
  where u0â‰¡0 : u false â‰¡ false      -- swap(false,false) = (u false , _) = (false,_)
        u0â‰¡0 = sym (cong fst (factors false false))
        u0â‰¡1 : u false â‰¡ true        -- swap(false,true)  = (u false , _) = (true ,_)
        u0â‰¡1 = sym (cong fst (factors false true))
