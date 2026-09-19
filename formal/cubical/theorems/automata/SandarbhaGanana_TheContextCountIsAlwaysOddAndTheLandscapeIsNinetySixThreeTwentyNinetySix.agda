{-# OPTIONS --cubical --safe --no-import-sorts #-}

--
-- â  DEMOTED TO VERIFICATION (2026-08-23, same day, owner correction:
-- the protocol is DERIVE FIRST â” "write the proof. Do not run the
-- experiment").  Every number below is forced a priori in three lines:
-- each observable lies in exactly two contexts âŸ the six parity
-- functionals sum to zero (the only dependency) âŸ the violation map
-- is affine with image the even-weight code Eâ shifted by the sign
-- vector and kernel 2â´ âŸ stratum(j) = 16ÂC(6,j) over j of the sign
-- vectorÂparity, and the 5/6 bound is the odd cosetÂleader weight 1.
-- General law: landscape = |kernel| Â coset weight enumerator;
-- contextuality degree = coset leader weight.  The refl-pins below are
-- what a verification is: downstream of the proof, never in its place.
-- (Journal: cf-residue checkpoint 33.)
------------------------------------------------------------------------
-- àà¨àà¦à°àà-à—àà¨à¾ â” counting by context.  A real question asked of the
-- machine (the asker did not know the answer): over all 512 classical
-- assignments to the Peresâ“Mermin square, how many satisfy exactly k of
-- the six contexts?  The machine's answer, each line a 512-sweep
-- performed by the typechecker (the PMNoSection stance â” a proof that
-- runs):
--
--     k : 0    1    2    3    4    5    6
--         0   96    0  320    0   96    0
--
-- TWO FACTS FALL OUT, the first new to this corpus:
--
-- 1. A PARITY SELECTION RULE: even satisfaction-counts are FORBIDDEN.
--    Every hidden-variable attempt satisfies exactly 1, 3, or 5
--    contexts.  Reason (stated, provable from the cocycle, pinned here
--    by computation): each observable occurs in exactly two contexts,
--    so the product of all six context-parities is forced to +1, while
--    the required signs multiply to âˆ’1 â” the violated-count is always
--    odd.  The HÂ obstruction is visible in the classical landscape as
--    a superselection rule on satisfaction parity.
--
-- 2. THE NEAR-MISS STRATUM HAS SIZE 96: the classical bound 5/6 is
--    attained by exactly 96 of 512 assignments (18.75%), mirrored by
--    the 96 maximally-frustrated ones at k = 1; the bulk, 320, sits at
--    k = 3.  The landscape is symmetric about 3 â” satisfaction and
--    frustration are exchanged by the obstruction.
--
------------------------------------------------------------------------

module SandarbhaGanana_TheContextCountIsAlwaysOddAndTheLandscapeIsNinetySixThreeTwentyNinetySix where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Vec using (Vec ; [] ; _âˆ·_)
open import PMNoSection using (even3 ; odd3)

private
  b2n : Bool â†’ â„•
  b2n true = 1 ; b2n false = 0
  eqâ„• : â„• â†’ â„• â†’ Bool
  eqâ„• zero zero = true
  eqâ„• (suc m) (suc n) = eqâ„• m n
  eqâ„• _ _ = false

nSat : Vec Bool 9 â†’ â„•
nSat (a âˆ· b âˆ· c âˆ· d âˆ· e âˆ· f âˆ· g âˆ· h âˆ· i âˆ· []) =
  b2n (even3 a b c) + (b2n (even3 d e f) + (b2n (even3 g h i)
  + (b2n (even3 a d g) + (b2n (even3 b e h) + b2n (odd3 c f i)))))

countVec : (n : â„•) â†’ (Vec Bool n â†’ â„•) â†’ â„•
countVec zero    f = f []
countVec (suc n) f = countVec n (Î» v â†’ f (true âˆ· v)) + countVec n (Î» v â†’ f (false âˆ· v))

census : â„• â†’ â„•
census k = countVec 9 (Î» v â†’ if eqâ„• (nSat v) k then 1 else 0)

-- the landscape, pinned: seven 512-sweeps by the evaluator.
census0 : census 0 â‰¡ 0
census0 = refl
census1 : census 1 â‰¡ 96
census1 = refl
census2 : census 2 â‰¡ 0
census2 = refl
census3 : census 3 â‰¡ 320
census3 = refl
census4 : census 4 â‰¡ 0
census4 = refl
census5 : census 5 â‰¡ 96
census5 = refl
census6 : census 6 â‰¡ 0
census6 = refl
