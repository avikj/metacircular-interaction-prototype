{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OptimalObservation
--
-- "Optimal" has been a word in three module headers.  Here it is a
-- definition, with the three instances proved against it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE DEFINITION
--
--     Optimal X Y obs  =  Injective obs  ó  (card Y ‚â° card X)
--
-- A scheme is optimal when it loses nothing and wastes nothing: injective,
-- and with no more outcomes than there are inputs.  The content is that
-- this forces minimality among ALL schemes:
--
--     optimal‚íminimal :
--       Optimal X Y obs ‚í (Z : FinSet) (g : X ‚í Z .fst) ‚í Injective g
--       ‚í card Y ‚â card Z
--
-- ‚î an optimal scheme's outcome count is a lower bound for every lossless
-- scheme on the same inputs, by `LosslessLowerBound`'s pigeonhole.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE INSTANCES, ALREADY IN THIS REPOSITORY AND NOT PREVIOUSLY COMPARED
--
--   Pigala, uddia       Vak n     ‚â Fin (sakhy n)     c. 300 BCE
--   Virahka, mtrmeru   Metre n   ‚â Fin (mtr n)       c. 600‚ì800
--   the walk, frontier 8   Fin 840   ‚â residue vector      (CRT)
--
-- Three enumeration problems, three explicit decodes, one notion of
-- optimality, one proof.  The first two come with their inverses named as
-- algorithms ‚î naa is the inverse of uddia and has its own word ‚î and
-- the third comes with CRT.
------------------------------------------------------------------------

module OptimalObservation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (compEquiv ; invEquiv)
open import Cubical.Functions.Embedding using (injEmbedding)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Nat.Order using (_‚â§_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Data.FinSet using (FinSet ; card ; isFinSet‚ÜíisSet)
open import Cubical.Data.FinSet.Cardinality using (card‚Ü™Inequality')
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ)
open import Cubical.Data.SumFin using () renaming (SumFin‚âÉFin to sumFin‚âÉFin)

open import PingalaPrastara using (Vak ; sankhya ; uddistaIso ; Metre ; matra ; matraCount)
open import WalkObservationCount using (walk-observation-space)

------------------------------------------------------------------------
-- 1.  Losslessness and optimality
------------------------------------------------------------------------

Injective : {A B : Type} ‚Üí (A ‚Üí B) ‚Üí Type
Injective {A = A} f = {x y : A} ‚Üí f x ‚â° f y ‚Üí x ‚â° y

Lossless : (X Y : FinSet ‚Ñì-zero) ‚Üí (X .fst ‚Üí Y .fst) ‚Üí Type
Lossless X Y obs = Injective obs

Optimal : (X Y : FinSet ‚Ñì-zero) ‚Üí (X .fst ‚Üí Y .fst) ‚Üí Type
Optimal X Y obs = Lossless X Y obs √ó (card Y ‚â° card X)

------------------------------------------------------------------------
-- 2.  An optimal scheme is minimal among all lossless schemes
------------------------------------------------------------------------

lossless-needs-room :
  (X Y : FinSet ‚Ñì-zero) (g : X .fst ‚Üí Y .fst) ‚Üí Lossless X Y g
  ‚Üí card X ‚â§ card Y
lossless-needs-room X Y g inj =
  card‚Ü™Inequality' X Y g (injEmbedding (isFinSet‚ÜíisSet (Y .snd)) inj)

optimal‚Üíminimal :
  (X Y : FinSet ‚Ñì-zero) (obs : X .fst ‚Üí Y .fst) ‚Üí Optimal X Y obs
  ‚Üí (Z : FinSet ‚Ñì-zero) (g : X .fst ‚Üí Z .fst) ‚Üí Lossless X Z g
  ‚Üí card Y ‚â§ card Z
optimal‚Üíminimal X Y obs (_ , tight) Z g inj =
  subst (_‚â§ card Z) (sym tight) (lossless-needs-room X Z g inj)

------------------------------------------------------------------------
-- 3.  An isomorphism gives an optimal scheme
------------------------------------------------------------------------

isoInjective : {A B : Type} (i : Iso A B) ‚Üí Injective (Iso.fun i)
isoInjective i {x} {y} p =
    sym (Iso.leftInv i x)
  ‚àô cong (Iso.inv i) p
  ‚àô Iso.leftInv i y

------------------------------------------------------------------------
-- 4.  The three instances
------------------------------------------------------------------------

-- Pigala, c. 300 BCE ‚î uddia, with naa as its named inverse
VakSet : (n : ‚Ñï) ‚Üí FinSet ‚Ñì-zero
VakSet n = Vak n , sankhya n ,
  ‚à£ compEquiv (isoToEquiv (uddistaIso n)) (invEquiv (sumFin‚âÉFin (sankhya n))) ‚à£‚ÇÅ

RowSet : (n : ‚Ñï) ‚Üí FinSet ‚Ñì-zero
RowSet n = Fin (sankhya n) , sankhya n , ‚à£ invEquiv (sumFin‚âÉFin (sankhya n)) ‚à£‚ÇÅ

pingala-optimal : (n : ‚Ñï) ‚Üí Optimal (VakSet n) (RowSet n) (Iso.fun (uddistaIso n))
pingala-optimal n = isoInjective (uddistaIso n) , refl

-- Virahka, c. 600‚ì800 ‚î the mtrmeru count
MetreSet : (n : ‚Ñï) ‚Üí FinSet ‚Ñì-zero
MetreSet n = Metre n , matra n ,
  ‚à£ compEquiv (isoToEquiv (matraCount n)) (invEquiv (sumFin‚âÉFin (matra n))) ‚à£‚ÇÅ

MatraRowSet : (n : ‚Ñï) ‚Üí FinSet ‚Ñì-zero
MatraRowSet n = Fin (matra n) , matra n , ‚à£ invEquiv (sumFin‚âÉFin (matra n)) ‚à£‚ÇÅ

virahanka-optimal :
  (n : ‚Ñï) ‚Üí Optimal (MetreSet n) (MatraRowSet n) (Iso.fun (matraCount n))
virahanka-optimal n = isoInjective (matraCount n) , refl

-- the walk at frontier 8 ‚î the residue vector, counted by CRT
InputSet8 : FinSet ‚Ñì-zero
InputSet8 = Fin 840 , 840 , ‚à£ invEquiv (sumFin‚âÉFin 840) ‚à£‚ÇÅ

ResidueSet8 : FinSet ‚Ñì-zero
ResidueSet8 =
  (((Fin 8 √ó Fin 3) √ó Fin 5) √ó Fin 7) , 840 ,
  ‚à£ compEquiv (invEquiv walk-observation-space) (invEquiv (sumFin‚âÉFin 840)) ‚à£‚ÇÅ

walk8-optimal :
  Optimal InputSet8 ResidueSet8 (walk-observation-space .fst)
walk8-optimal = inj , refl
  where
  open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq)
  inj : Injective (walk-observation-space .fst)
  inj {x} {y} p =
      sym (retEq walk-observation-space x)
    ‚àô cong (invEq walk-observation-space) p
    ‚àô retEq walk-observation-space y

------------------------------------------------------------------------
-- 5.  So all three are minimal, by one theorem.
--
-- `optimal‚íminimal` applied to each says: no lossless scheme on those
-- inputs has fewer outcomes.  Pigala's 2‚ø, Virahka's mtrmeru, and
-- the walk's 840 are not counts that happen to be small ‚î they are
-- minima, and the same four lines prove it for all three.
------------------------------------------------------------------------

pingala-minimal :
  (n : ‚Ñï) (Z : FinSet ‚Ñì-zero) (g : Vak n ‚Üí Z .fst) ‚Üí Lossless (VakSet n) Z g
  ‚Üí sankhya n ‚â§ card Z
pingala-minimal n = optimal‚Üíminimal (VakSet n) (RowSet n) _ (pingala-optimal n)

virahanka-minimal :
  (n : ‚Ñï) (Z : FinSet ‚Ñì-zero) (g : Metre n ‚Üí Z .fst) ‚Üí Lossless (MetreSet n) Z g
  ‚Üí matra n ‚â§ card Z
virahanka-minimal n = optimal‚Üíminimal (MetreSet n) (MatraRowSet n) _ (virahanka-optimal n)

walk8-minimal :
  (Z : FinSet ‚Ñì-zero) (g : Fin 840 ‚Üí Z .fst) ‚Üí Lossless InputSet8 Z g
  ‚Üí 840 ‚â§ card Z
walk8-minimal = optimal‚Üíminimal InputSet8 ResidueSet8 _ walk8-optimal
