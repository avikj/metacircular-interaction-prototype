{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDelimitorNeedsOnlyStability
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SITE
--
-- `AnyonyaAbhava` Â§5 assumes `Dec (Collision q t)` to
-- close the gap between the two Vaieika categories of ààà¾àµ.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  the hypothesis is stronger than the use.  `dec-collapses` is
--       used only as `Â Â A â’ A`, which is `Stable`.  So
--       `Stable (Collision q t)` closes the gap, and `Dec` is a
--       corollary by `Decâ’Stable`.  The delimitor does not need a
--       decision; it needs the double negation to collapse.
--
--   Â§2  decidability on a class of sites: for a two-point state space with discrete Y and
--       discrete T, `Dec (Collision q t)` HOLDS, by an exhaustion over
--       the four pairs of which two are diagonal and die on `refl`.
--       So the answer to "does it hold at any site" is yes, and the
--       cost is the same finite search that `RefutingLaghavaIsASearch`
--       found at the presentation-measures site.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE RESPECTS, SINCE Â§1 AND Â§2 PULL DIFFERENT WAYS
--
--   ààà¯à¾àà â” in the respect of what the proof needs, `Stable` is the
--            hypothesis and `Dec` was more than was used;
--   ààà¯à¾àà â” in the respect of what can actually be EXHIBITED at a
--            site, `Dec` is what Â§2 constructs, because a finite
--            search decides rather than merely stabilises.
--
-- These do not collapse into each other.  The weaker hypothesis is not
-- the one the concrete site supplies, and the concrete site does not
-- show the weaker hypothesis is ever available on its own.  Both are
-- proved; neither is called the better statement, there being no scale
-- here on which to say it.
--
------------------------------------------------------------------------

module TheDelimitorNeedsOnlyStability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete ; Stable)
open import Cubical.Relation.Nullary.Properties using (Decâ†’Stable)

open import FiniteInformation using (FactorsThrough)
open import AnyonyaAbhava
  using (Collision ; Anyonya ; samsargaâ†’Â¬Â¬anyonya ; anyonyaâ†’samsarga)

private
  variable
    â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  Stability closes the gap; decidability was more than was used
------------------------------------------------------------------------

samsargaâ†’anyonya-when-stable :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (dT : Discrete T) (q : X â†’ Y) (t : X â†’ T)
  â†’ Stable (Collision q t)
  â†’ Â¬ FactorsThrough q t
  â†’ Collision q t
samsargaâ†’anyonya-when-stable dT q t st noDecoder =
  st (samsargaâ†’Â¬Â¬anyonya dT q t noDecoder)

-- the decidable form, now a corollary
samsargaâ†’anyonya-when-decidableâ€² :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (dT : Discrete T) (q : X â†’ Y) (t : X â†’ T)
  â†’ Dec (Collision q t)
  â†’ Â¬ FactorsThrough q t
  â†’ Collision q t
samsargaâ†’anyonya-when-decidableâ€² dT q t dC =
  samsargaâ†’anyonya-when-stable dT q t (Decâ†’Stable dC)

categories-agree-when-stable :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (dT : Discrete T) (q : X â†’ Y) (t : X â†’ T)
  â†’ Stable (Collision q t)
  â†’ (Collision q t â†’ Â¬ FactorsThrough q t)
  Ã— (Â¬ FactorsThrough q t â†’ Collision q t)
categories-agree-when-stable dT q t st =
    (Î» c â†’ anyonyaâ†’samsarga q t {x = c .fst} {x' = c .snd .fst}
             (c .snd .snd .fst) (c .snd .snd .snd))
  , samsargaâ†’anyonya-when-stable dT q t st

------------------------------------------------------------------------
-- 2.  Decidability by exhaustion on a two-point state space
--
-- `Bool` is a hypothesis here: where a site has a two-point state space,
-- and Y and T are discrete, the delimitor is decidable and Â§5 of
-- `AnyonyaAbhava` applies.
------------------------------------------------------------------------

-- the two refutations, at top level so no `with` clause carries a
-- `where`.  Diagonal pairs die on `refl` in both.
noGroundRefutes :
  {Y : Type â„“y} {T : Type â„“t} (q : Bool â†’ Y) (t : Bool â†’ T)
  â†’ Â¬ (q true â‰¡ q false) â†’ Â¬ Collision q t
noGroundRefutes q t ny (true  , true  , _    , ne) = ne refl
noGroundRefutes q t ny (false , false , _    , ne) = ne refl
noGroundRefutes q t ny (true  , false , same , _ ) = ny same
noGroundRefutes q t ny (false , true  , same , _ ) = ny (sym same)

equalTargetRefutes :
  {Y : Type â„“y} {T : Type â„“t} (q : Bool â†’ Y) (t : Bool â†’ T)
  â†’ (t true â‰¡ t false) â†’ Â¬ Collision q t
equalTargetRefutes q t pt (true  , true  , _ , ne) = ne refl
equalTargetRefutes q t pt (false , false , _ , ne) = ne refl
equalTargetRefutes q t pt (true  , false , _ , ne) = ne pt
equalTargetRefutes q t pt (false , true  , _ , ne) = ne (sym pt)

decCollisionOnTwoPoints :
  {Y : Type â„“y} {T : Type â„“t}
  (dY : Discrete Y) (dT : Discrete T) (q : Bool â†’ Y) (t : Bool â†’ T)
  â†’ Dec (Collision q t)
decCollisionOnTwoPoints dY dT q t with dY (q true) (q false)
... | no  ny = no (noGroundRefutes q t ny)
... | yes py with dT (t true) (t false)
...   | no  nt = yes (true , false , py , nt)
...   | yes pt = no (equalTargetRefutes q t pt)

-- and therefore the two categories of ààà¾àµ agree there.
categories-agree-on-two-points :
  {Y : Type â„“y} {T : Type â„“t}
  (dY : Discrete Y) (dT : Discrete T) (q : Bool â†’ Y) (t : Bool â†’ T)
  â†’ (Collision q t â†’ Â¬ FactorsThrough q t)
  Ã— (Â¬ FactorsThrough q t â†’ Collision q t)
categories-agree-on-two-points dY dT q t =
  categories-agree-when-stable dT q t
    (Decâ†’Stable (decCollisionOnTwoPoints dY dT q t))
