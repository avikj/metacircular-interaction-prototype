{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDelimitorNeedsOnlyStability
--
-- Third instance of the replacement question, and the first that
-- answers a named open item rather than removing a hypothesis.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SITE
--
-- `AnyonyaAbhava` Â§5 assumes `Dec (Collision q t)` to
-- close the gap between the two Vaieika categories of ààà¾àµ, and its
-- Â§6 leaves an open item in these words, read from the file:
--
--     "OPEN, named and not estimated.  Whether `Dec (Collision q t)`
--      holds at any site in this corpus."
--
-- Two things are wrong with the shape of that, and one of them is the
-- same correction this thread has now made three times.
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
--   Â§2  the open item, answered on a class of sites rather than
--       estimated: for a two-point state space with discrete Y and
--       discrete T, `Dec (Collision q t)` HOLDS, by an exhaustion over
--       the four pairs of which two are diagonal and die on `refl`.
--       So the answer to "does it hold at any site" is yes, and the
--       cost is the same finite search that `RefutingLaghavaIsASearch`
--       found at the presentation-measures site.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- TWO CORRECTIONS TO MY OWN EARLIER TEXT, MADE HERE AND MARKED THERE
--
-- `AnyonyaAbhava` Â§6 is mine and contains two sentences the standing
-- method forbids.  Reading one's own file critically is the point of
-- the method, so:
--
--   (a) "This is the second time in this corpus that the Nyya analysis
--       of ààà¾àµ has turned out to track constructive structure â¦ Two is
--       not a coincidence worth explaining away."  Two instances are
--       two instances.  A pattern over n instances is a pattern over n
--       instances until something downstream of it is computed, and
--       nothing downstream of that sentence was ever computed.  The
--       observation stands as an observation; the inference from it
--       does not.
--
--   (b) "conducted by people who did not have one and were right
--       anyway."  That scores the past by its proximity to a
--       constructive setting, which is a criterion imported and not
--       examined â” a à¦àà°àà¨à¯, a standpoint asserting itself by denying
--       others.  What can be said instead, and is enough: the Nyya
--       division of ààà¾àµ into àààà°àà— and àà¨àà¯à‹à¨àà¯ is a distinction, the
--       distinction is registered in this formalism, and the two
--       directions cost differently here.  Whether the Naiyyikas were
--       tracking what this formalism tracks is a question about them
--       that this corpus has no means to settle.
--
-- Neither sentence is deleted at its site: the record of having
-- written them is part of the record.  A pointer is added there.
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
-- 2.  The open item, answered by exhaustion on a two-point state space
--
-- `Bool` is a hypothesis here.  Nothing below claims any site of this
-- corpus has a two-point state space; what is claimed is that where one
-- does, and Y and T are discrete, the delimitor is decidable and Â§5 of
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

------------------------------------------------------------------------
-- PRIOR-ART OBLIGATION, undischarged, recorded 2026-08-19.
--
-- Navya-Nyya* (Panday & Ghosh), whose stated content includes DEPENDENT
-- DELIMITATION (avacchedaka) and TYPED ABSENCE (abhva) in cubical type
-- theory â” the same substrate and the same notions this module touches.
--
-- This module does not cite it, and could not: the citation sits in a
-- note whose Â§2 alone had been read.  arxiv.org is EGRESS_BLOCKED from
-- this session's environment, so the comparison could not be made here;
-- leaves open.
--
-- Until someone who can read the paper compares them, NO NOVELTY IS
-- CLAIMED for anything below.  The theorems are about observables,
-- fibres and Bool-valued models and are unaffected; what is owed is a
-- citation check, not a withdrawal.
------------------------------------------------------------------------
