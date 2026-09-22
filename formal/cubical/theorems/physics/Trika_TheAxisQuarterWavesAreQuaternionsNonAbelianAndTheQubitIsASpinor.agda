{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Trika_TheAxisQuarterWavesAreQuaternionsNonAbelian
--       AndTheQubitIsASpinor
--
-- TERM.  ààà°à¿à• Â trika â” a triad; here the three axis quarter-waves i, j, k.
-- A common  word.  The physics (quaternion
-- gates, SU(2)/SO(3), spinor, Poincar© sphere) is modern; the compound and
-- the identification are built here.
--
-- THE READING (checked terms below).  Companion to `Mani_â¦`: one orb is a
-- single âˆNOT quarter-wave.  Waveplates on DIFFERENT axes are the three
-- generators i, j, k of the single-qubit gate group; together they generate
-- all of SU(2) (two non-parallel rotations suffice).  Their finite skeleton
-- is the QUATERNION GROUP Q8, and its two facts are the two facts of the
-- device's gate layer:
--   (1) NON-ABELIAN â” `ijâ‰ji`.  The order in which a photon threads the orbs
--       is physical; that order-dependence is where computational power lives
--       (cf. `VeniYangBaxtara_â¦`, the braid).  This is what makes a network of
--       orbs â” an àà¨àà¦àà°àà¾à², Indra's net â” universal rather than a single phase.
--   (2) SPINOR / DOUBLE COVER â” `full-turn-is-minus-one`, `double-turn-returns`,
--       `minus-one-is-not-one`.  A full turn about an axis is âˆ’1, not 1; a
--       second full turn returns.  SU(2) double-covers SO(3): the Poincar©
--       sphere (physical polarizations) is SO(3)=SÂ², but the qubit STATE that
--       carries the phase is the spinor above it â” SÂ³, the Hopf total space.
--       The orb remembers a single rotation as a sign.
--
-- WHAT IS CHECKED, exactly.  Q8 = Bool — B (sign — {e,i,j,k}) with the
-- quaternion product; then `iÂ² â‰¡ jÂ² â‰¡ kÂ² â‰¡ -ğŸ™` (three axis quarter-waves each
-- squaring to the NOT/Ï element), `ij â‰¡ k`, `ji â‰¡ -k`, `ijâ‰ji` (a hard Â), and
-- the spinor relations.  All by computation / `trueâ‰false`.
------------------------------------------------------------------------

module Trika_TheAxisQuarterWavesAreQuaternionsNonAbelianAndTheQubitIsASpinor where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; trueâ‰¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

data B : Type where be bi bj bk : B
Q : Type
Q = Bool Ã— B                      -- sign (true=+1, false=-1) Ã— basis

signMul : Bool â†’ Bool â†’ Bool
signMul true  s = s
signMul false s = not s

bMul : B â†’ B â†’ B
bMul be y = y
bMul x be = x
bMul bi bi = be ; bMul bj bj = be ; bMul bk bk = be
bMul bi bj = bk ; bMul bj bk = bi ; bMul bk bi = bj
bMul bj bi = bk ; bMul bk bj = bi ; bMul bi bk = bj

bSign : B â†’ B â†’ Bool
bSign be y = true
bSign x be = true
bSign bi bi = false ; bSign bj bj = false ; bSign bk bk = false
bSign bi bj = true  ; bSign bj bk = true  ; bSign bk bi = true
bSign bj bi = false ; bSign bk bj = false ; bSign bi bk = false

_Â·_ : Q â†’ Q â†’ Q
(s1 , b1) Â· (s2 , b2) = (signMul (signMul s1 s2) (bSign b1 b2) , bMul b1 b2)

ğŸ™ -ğŸ™ i j k : Q
ğŸ™  = (true  , be) ; -ğŸ™ = (false , be)
i  = (true  , bi) ; j  = (true  , bj) ; k  = (true , bk)

-- three axis quarter-waves, each squaring to the NOT/Ï element âˆ’1
iÂ² : i Â· i â‰¡ -ğŸ™
iÂ² = refl
jÂ² : j Â· j â‰¡ -ğŸ™
jÂ² = refl
kÂ² : k Â· k â‰¡ -ğŸ™
kÂ² = refl

-- non-abelian: ij = k, ji = âˆ’k
ij : i Â· j â‰¡ k
ij = refl
ji : j Â· i â‰¡ (false , bk)
ji = refl
ijâ‰¢ji : Â¬ (i Â· j â‰¡ j Â· i)
ijâ‰¢ji p = trueâ‰¢false (cong fst p)

-- spinor / double cover
full-turn-is-minus-one : i Â· i â‰¡ -ğŸ™
full-turn-is-minus-one = refl
double-turn-returns : (i Â· i) Â· (i Â· i) â‰¡ ğŸ™
double-turn-returns = refl
minus-one-is-not-one : Â¬ (-ğŸ™ â‰¡ ğŸ™)
minus-one-is-not-one p = trueâ‰¢false (cong fst (sym p))
