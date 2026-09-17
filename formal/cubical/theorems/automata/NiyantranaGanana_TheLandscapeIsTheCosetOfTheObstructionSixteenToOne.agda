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
-- (Journal: cf-sesa checkpoint 33.)
------------------------------------------------------------------------
-- à¨à¿à¯à¨àààà°à-à—àà¨à¾ â” the control censuses, and the complete law they force.
--
-- SandarbhaGanana measured the Peresâ“Mermin landscape (96/320/96 on odd
-- satisfied-counts, evens forbidden) and conjectured the parity rule
-- from the cocycle.  THE CONTROL EXPERIMENT, run through à¨à¾à¡à before
-- landing: flip the sign vector to CONSISTENT (all-even, and two-odd â”
-- both with required-sign product +1) and re-census.  The machine's
-- answers, pinned below by 512-sweeps:
--
--     consistent (both controls, identical):  k: 6   5   4   3   2   1   0
--                                                16   0 240   0 240   0  16
--     inconsistent (SandarbhaGanana):              0  96   0 320   0  96   0
--
-- THE COMPLETE LAW, visible once the controls exist: every count is
-- 16 Â C(6,v) over the allowed violation-sizes v.  Consistent:
-- 16Â(1,15,15,1) at v = 0,2,4,6.  Inconsistent: 16Â(6,20,6) at
-- v = 1,3,5.  REASON (stated; the pins are its finite verification):
-- the assignment â¦ violation-pattern map is AFFINE over ð”½â â” nine
-- unknowns, six constraints, one dependency (each observable lies in
-- exactly two contexts, so the six context-parities always multiply to
-- +1) â” hence rank 5, every fibre of size 2â´ = 16, and the image is
-- EXACTLY the coset of the 5-dimensional image subspace selected by the
-- obstruction class: the trivial coset for consistent signs, the
-- nontrivial one for the PM square.  The classical landscape IS the HÂ
-- coset, binomially profiled, 16-to-1.
--
-- So the obstruction's full classical price: the 16 global sections of
-- any consistent square redistribute, under the odd class, into 96
-- near-misses at 5/6 â” nothing is lost, everything is displaced one
-- violation.  (The same shape as StaraArpana one lane over: the
-- obstruction never destroys; it displaces by one stratum.)
--
------------------------------------------------------------------------

module NiyantranaGanana_TheLandscapeIsTheCosetOfTheObstructionSixteenToOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Vec using (Vec ; [] ; _âˆ·_)
open import PMNoSection using (even3 ; odd3)
open import SandarbhaGanana_TheContextCountIsAlwaysOddAndTheLandscapeIsNinetySixThreeTwentyNinetySix
  using (countVec)

private
  b2n : Bool â†’ â„•
  b2n true = 1 ; b2n false = 0
  eqâ„• : â„• â†’ â„• â†’ Bool
  eqâ„• zero zero = true
  eqâ„• (suc m) (suc n) = eqâ„• m n
  eqâ„• _ _ = false

-- the all-even (consistent) square, and a two-odd (still consistent) one.
nSatE nSat2 : Vec Bool 9 â†’ â„•
nSatE (a âˆ· b âˆ· c âˆ· d âˆ· e âˆ· f âˆ· g âˆ· h âˆ· i âˆ· []) =
  b2n (even3 a b c) + (b2n (even3 d e f) + (b2n (even3 g h i)
  + (b2n (even3 a d g) + (b2n (even3 b e h) + b2n (even3 c f i)))))
nSat2 (a âˆ· b âˆ· c âˆ· d âˆ· e âˆ· f âˆ· g âˆ· h âˆ· i âˆ· []) =
  b2n (even3 a b c) + (b2n (even3 d e f) + (b2n (odd3 g h i)
  + (b2n (even3 a d g) + (b2n (even3 b e h) + b2n (odd3 c f i)))))

censusE census2 : â„• â†’ â„•
censusE k = countVec 9 (Î» v â†’ if eqâ„• (nSatE v) k then 1 else 0)
census2 k = countVec 9 (Î» v â†’ if eqâ„• (nSat2 v) k then 1 else 0)

-- the consistent landscape: 16Â(1,15,15,1) on even counts, odds zero.
cE6 : censusE 6 â‰¡ 16
cE6 = refl
cE5 : censusE 5 â‰¡ 0
cE5 = refl
cE4 : censusE 4 â‰¡ 240
cE4 = refl
cE3 : censusE 3 â‰¡ 0
cE3 = refl
cE2 : censusE 2 â‰¡ 240
cE2 = refl
cE1 : censusE 1 â‰¡ 0
cE1 = refl
cE0 : censusE 0 â‰¡ 16
cE0 = refl

-- the two-odd consistent square: the SAME landscape â” the law depends
-- only on the obstruction class, not on the representative sign vector.
c26 : census2 6 â‰¡ 16
c26 = refl
c24 : census2 4 â‰¡ 240
c24 = refl
c22 : census2 2 â‰¡ 240
c22 = refl
c20 : census2 0 â‰¡ 16
c20 = refl
c25 : census2 5 â‰¡ 0
c25 = refl
