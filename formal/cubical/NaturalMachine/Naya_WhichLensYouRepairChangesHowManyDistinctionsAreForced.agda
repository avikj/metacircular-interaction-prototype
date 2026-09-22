{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- NaturalMachine.Naya_WhichLensYouRepairChangesHowManyDistinctionsAreForced
--
-- A six-point witness: for one noncommuting lens pair (Ï , Ï) on a finite
-- uniform space, the coarsest repair of Ï against Ï and the coarsest repair
-- of Ï against Ï force DIFFERENT NUMBERS of new distinctions, and their
-- surviving common views are different partitions.
--
-- What is claimed of the sources, precisely.
--
--   * Per the repository's
--     own `notes/COARSEST_REPAIR_IS_COLOUR_REFINEMENT.md`, the operative
--     prior art is: commuting partitions = orthogonal partitions (Tjur,
--     *Int. Stat. Rev.* 52, 1984; Bailey, *Des. Codes Cryptogr.* 8, 1996;
--     Nelder 1965); the coarsest equitable refinement is colour refinement
--     (Paigeâ“Tarjan 1987); the profile relation used below is Benz©cri's
--     distributional equivalence (*L'Analyse des Donn©es*, Dunod 1973).
--
--   * `Naya` in the file name names the DIAGNOSIS, not the theorem.  In
--     Jaina epistemology a *naya* is a standpoint and a *durnaya* is a
--     standpoint that asserts itself by denying the others (Siddhasena
--     Divkara, *Sanmatitarka*; Akalaka).  The result below is that the
--     Ï-standpoint and the Ï-standpoint on one lens pair yield inequivalent
--     repairs, so calling either one "the canonical surviving view" is a
--     durnaya.
--
-- The witness (elements 0..5):
--
--     Ï  = {0,1} | {2,3} | {4,5}          3 blocks
--     Ï  = {0,2} | {1,3,4,5}              2 blocks
--
--   coarsest repair of Ï against Ï :  Ïâ = {0}|{1}|{2}|{3}|{4,5}   5 blocks
--   coarsest repair of Ï against Ï :  Ïâ = {0,2}|{1,3}|{4,5}       3 blocks
--
--   new blocks forced:  Ï-side 5âˆ’3 = 2,   Ï-side 3âˆ’2 = 1.   2 â‰  1.
--
-- All arithmetic is on â•, cross-multiplied so that no rationals appear.
-- Every theorem below is `refl` on a closed Boolean or numeral.
------------------------------------------------------------------------

module NaturalMachine.Naya_WhichLensYouRepairChangesHowManyDistinctionsAreForced where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; injSuc ; snotz)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_ ; _or_)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1. Finite Boolean apparatus over the six points 0..5
------------------------------------------------------------------------

eqâ„• : â„• â†’ â„• â†’ Bool
eqâ„• zero    zero    = true
eqâ„• zero    (suc _) = false
eqâ„• (suc _) zero    = false
eqâ„• (suc m) (suc n) = eqâ„• m n

_â‡’_ : Bool â†’ Bool â†’ Bool
b â‡’ c = not b or c

infixr 4 _â‡’_

bit : Bool â†’ â„•
bit true  = 1
bit false = 0

-- The carrier is {0,1,2,3,4,5}; every quantifier below is this unrolling.
count : (â„• â†’ Bool) â†’ â„•
count p = bit (p 0) + (bit (p 1) + (bit (p 2) + (bit (p 3) + (bit (p 4) + bit (p 5)))))

everyPt : (â„• â†’ Bool) â†’ Bool
everyPt p = p 0 and (p 1 and (p 2 and (p 3 and (p 4 and p 5))))

somePt : (â„• â†’ Bool) â†’ Bool
somePt p = p 0 or (p 1 or (p 2 or (p 3 or (p 4 or p 5))))

everyPair : (â„• â†’ â„• â†’ Bool) â†’ Bool
everyPair r = everyPt (Î» x â†’ everyPt (Î» y â†’ r x y))

------------------------------------------------------------------------
-- 2. Partitions as colourings, and the three predicates
------------------------------------------------------------------------

Colouring : Typeâ‚€
Colouring = â„• â†’ â„•

-- number of colours actually used on the carrier
nblocks : Colouring â†’ â„•
nblocks c = count (Î» k â†’ somePt (Î» x â†’ eqâ„• (c x) k))

-- |Ï-block of a|
blockSize : Colouring â†’ â„• â†’ â„•
blockSize c a = count (Î» w â†’ eqâ„• (c w) (c a))

-- |Ï-block of z  âˆ©  Ï-block of x|
meetSize : Colouring â†’ Colouring â†’ â„• â†’ â„• â†’ â„•
meetSize cr cs z x = count (Î» w â†’ eqâ„• (cr w) (cr z) and eqâ„• (cs w) (cs x))

-- Ï commutes with Ï  âŸº  V_Ï is P_Ï-invariant  âŸº  for every Ï-block B the
-- density x â¦ |B âˆ© Ï(x)| / |Ï(x)| is constant on Ï-blocks.  Cross-multiplied.
commutes : Colouring â†’ Colouring â†’ Bool
commutes cr cs = everyPair (Î» x y â†’
  eqâ„• (cr x) (cr y) â‡’
    everyPt (Î» z â†’ eqâ„• (meetSize cr cs z x Â· blockSize cs y)
                       (meetSize cr cs z y Â· blockSize cs x)))

-- Ï refines q
refines : Colouring â†’ Colouring â†’ Bool
refines cr cq = everyPair (Î» x y â†’ eqâ„• (cr x) (cr y) â‡’ eqâ„• (cq x) (cq y))

sameParts : Colouring â†’ Colouring â†’ Bool
sameParts c d = everyPair (Î» x y â†’
  (eqâ„• (c x) (c y) â‡’ eqâ„• (d x) (d y)) and (eqâ„• (d x) (d y) â‡’ eqâ„• (c x) (c y)))

------------------------------------------------------------------------
-- 3. The witness
------------------------------------------------------------------------

-- Ï = {0,1} | {2,3} | {4,5}
cPi : Colouring
cPi 0 = 0
cPi 1 = 0
cPi 2 = 1
cPi 3 = 1
cPi 4 = 2
cPi 5 = 2
cPi _ = 9

-- Ï = {0,2} | {1,3,4,5}
cSg : Colouring
cSg 0 = 0
cSg 1 = 1
cSg 2 = 0
cSg 3 = 1
cSg 4 = 1
cSg 5 = 1
cSg _ = 9

-- Ïâ = {0}|{1}|{2}|{3}|{4,5}   -- the coarsest repair of Ï against Ï
cR1 : Colouring
cR1 0 = 0
cR1 1 = 1
cR1 2 = 2
cR1 3 = 3
cR1 4 = 4
cR1 5 = 4
cR1 _ = 9

-- Ïâ = {0,2}|{1,3}|{4,5}       -- the coarsest repair of Ï against Ï
cR2 : Colouring
cR2 0 = 0
cR2 1 = 1
cR2 2 = 0
cR2 3 = 1
cR2 4 = 2
cR2 5 = 2
cR2 _ = 9

-- the two partitions strictly between Ï and Ïâ that refine Ï
cM1 : Colouring          -- {0}|{1}|{2,3}|{4,5}
cM1 0 = 0
cM1 1 = 1
cM1 2 = 2
cM1 3 = 2
cM1 4 = 3
cM1 5 = 3
cM1 _ = 9

cM2 : Colouring          -- {0,1}|{2}|{3}|{4,5}
cM2 0 = 0
cM2 1 = 0
cM2 2 = 1
cM2 3 = 2
cM2 4 = 3
cM2 5 = 3
cM2 _ = 9

-- J = {0,1,2,3}|{4,5}: the finest common coarsening of Ï and Ïâ
cJ : Colouring
cJ 0 = 0
cJ 1 = 0
cJ 2 = 0
cJ 3 = 0
cJ 4 = 1
cJ 5 = 1
cJ _ = 9

------------------------------------------------------------------------
-- 4. The pair genuinely fails to commute, and the predicate is symmetric
------------------------------------------------------------------------

pi-sigma-noncommuting : commutes cPi cSg â‰¡ false
pi-sigma-noncommuting = refl

sigma-pi-noncommuting : commutes cSg cPi â‰¡ false
sigma-pi-noncommuting = refl

------------------------------------------------------------------------
-- 5. Ïâ is the coarsest repair of Ï against Ï
------------------------------------------------------------------------

r1-refines-pi : refines cR1 cPi â‰¡ true
r1-refines-pi = refl

r1-commutes : commutes cR1 cSg â‰¡ true
r1-commutes = refl

-- The repair set has a unique coarsest element (LENS_REPAIR.md Â§1, join
-- closure), so the coarsest repair lies between Ï and Ïâ.  A partition there
-- keeps or splits each Ï-block along its Ïâ-pieces, so there are exactly four
-- (Ï, cM1, cM2, Ïâ) and the other three are all refuted as repairs.
m1-not-a-repair : commutes cM1 cSg â‰¡ false
m1-not-a-repair = refl

m2-not-a-repair : commutes cM2 cSg â‰¡ false
m2-not-a-repair = refl
-- (Ï itself is handled by `pi-sigma-noncommuting`.)

------------------------------------------------------------------------
-- 6. Ïâ is the coarsest repair of Ï against Ï
------------------------------------------------------------------------

r2-refines-sigma : refines cR2 cSg â‰¡ true
r2-refines-sigma = refl

r2-commutes : commutes cR2 cPi â‰¡ true
r2-commutes = refl
-- Only Ï lies strictly between Ï and Ïâ, and `sigma-pi-noncommuting` kills it.

------------------------------------------------------------------------
-- 7. The asymmetry
------------------------------------------------------------------------

pi-blocks : nblocks cPi â‰¡ 3
pi-blocks = refl

r1-blocks : nblocks cR1 â‰¡ 5
r1-blocks = refl

sigma-blocks : nblocks cSg â‰¡ 2
sigma-blocks = refl

r2-blocks : nblocks cR2 â‰¡ 3
r2-blocks = refl

-- new distinctions forced on each side
pi-side-forces-two : nblocks cPi + 2 â‰¡ nblocks cR1
pi-side-forces-two = refl

sigma-side-forces-one : nblocks cSg + 1 â‰¡ nblocks cR2
sigma-side-forces-one = refl

twoâ‰¢one : Â¬ (2 â‰¡ 1)
twoâ‰¢one p = snotz (injSuc p)

-- REFUTED: "each side of a lens pair must make the same number of new
-- distinctions" (the reciprocity a correspondence-shaped reading predicts).
no-reciprocity-in-forced-blocks : Â¬ (2 â‰¡ 1)
no-reciprocity-in-forced-blocks = twoâ‰¢one

-- The carriers themselves differ in size, not only in the increment.
r1-and-r2-differ : sameParts cR1 cR2 â‰¡ false
r1-and-r2-differ = refl

------------------------------------------------------------------------
-- 8. The two surviving common views are different partitions
------------------------------------------------------------------------

-- Ï-side: Ïâ refines Ï, so the finest common coarsening of Ïâ and Ï is Ï.
r1-refines-sigma : refines cR1 cSg â‰¡ true
r1-refines-sigma = refl

-- Ï-side: both Ï and Ïâ refine J, and J is their finest common coarsening
-- (0âˆ¼1 by Ï, 1âˆ¼3 by Ïâ, 3âˆ¼2 by Ï forces {0,1,2,3}; 4âˆ¼5 by both).
pi-refines-J : refines cPi cJ â‰¡ true
pi-refines-J = refl

r2-refines-J : refines cR2 cJ â‰¡ true
r2-refines-J = refl

-- and the two surviving views are not the same partition
surviving-views-differ : sameParts cSg cJ â‰¡ false
surviving-views-differ = refl
