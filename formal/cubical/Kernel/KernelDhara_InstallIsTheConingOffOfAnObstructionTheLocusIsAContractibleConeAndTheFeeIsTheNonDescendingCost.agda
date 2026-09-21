{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à—à°àà-à§à¾à°à¾ â” the womb-holding: install IS a coning-off.
--
-- `install` (SthapanaVarga), the act
-- by which a theorem of the kernel becomes a structure map of the
-- kernel, is the same act as CONING OFF an obstruction and thereby
-- climbing the Postnikov tower one level (garbha.dhara).  This module
-- makes the load-bearing half of that identification a checked term.
--
-- WHAT CONING-OFF IS.  To cone off a map g : X â’ Y (Cubical's
-- HITs.MappingCones.Cone) is to glue a hub to Y with one spoke to each
-- inj (g x); the defining property that makes it KILL a class is that a
-- cone is CONTRACTIBLE â” the attached cell has nothing in it, so any
-- class it bounds becomes null.  Coning off adds one contractible cell,
-- not a family.
--
-- WHAT INSTALL IS.  SthapanaVarga Â§4 (locusContr) proves the
-- applicability locus of `install d` â” Î[ t ] Control (install d) t,
-- which is Î[ t ] (t â‰¡ lhs) â” is CONTRACTIBLE with centre the source.
-- "Capability grows by one, not by a class."  That locus is a cone:
-- the based-path space is the cone point.
--
--   Â§1  THE LOCUS IS A CONE.  Î[ t ] (t â‰¡ lhs) â‰ singl lhs (reverse the
--       path), and singl is the library's contractible cone
--       (isContrSingl).  So install's locus is a contractible cone â”
--       coning-off's defining property, on the nose, as SthapanaVarga
--       found it hand-rolled.
--   Â§2  THE SPOKE.  Every point of the locus is a spoke into the coned
--       source: the control datum c : t â‰¡ lhs is exactly the path a
--       mapping-cone spoke carries.  Exhibited as a map locus â’ Cone of
--       the source point-map, landing in the hub's own singl.
--   Â§3  ONE CELL, NOT A CLASS â” restated as the contractibility of Â§1:
--       the locus is a proposition (isContrâ’isProp), so there are not
--       two distinct places to fire.  This is "grows by one."
--
-- THE FEE (garbha, cited not rebuilt).  Coning off a class at level n
-- precipitates a new class at level n+1 (VakraValayaSanketa: the
-- forgotten succession precipitates as one bit, "the first veil is its
-- fee").  In the kernel that fee is the NON-DESCENDING COST: after
-- install collapses meaning-equal routes (L of SankramanaShreni), cost
-- is exactly what does not descend â” the residual one level up.  Named
-- here by re-exporting the witness, so this module states install +
-- its fee together.
------------------------------------------------------------------------

module GarbhaDhara_InstallIsTheConingOffOfAnObstructionTheLocusIsAContractibleConeAndTheFeeIsTheNonDescendingCost where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.HLevels using ()
open import Cubical.Data.Sigma using (Î£-syntax ; _,_ ; fst ; snd)
open import Cubical.HITs.MappingCones using (Cone ; inj ; hub ; spoke)
open import Cubical.Data.Unit using (Unit ; tt)

open import RewriteCertificate using (Tm ; Derivation)
open import ControlledGrammar using (NativeOperation ; install)
open NativeOperation

------------------------------------------------------------------------
-- à§ Â The locus of install is a contractible cone.
--     Control (install d) t = (t â‰¡ lhs); the locus is Î[ t ] t â‰¡ lhs,
--     which is singl lhs read backwards â” the cone, contractible.
------------------------------------------------------------------------

Locus : {l r : Tm} â†’ Derivation l r â†’ Typeâ‚€
Locus {l} d = Î£[ t âˆˆ Tm ] Control (install d) t   -- = Î£[ t ] (t â‰¡ l)

-- the cone: singl' l = Î[ t ] t â‰¡ l, contractible with centre (l , refl).
locusIsCone : {l r : Tm} (d : Derivation l r) â†’ isContr (Locus d)
locusIsCone {l} d .fst = l , refl
locusIsCone {l} d .snd (t , p) i = p (~ i) , Î» j â†’ p (~ i âˆ¨ j)

------------------------------------------------------------------------
-- à¨ Â The spoke.  Cone off the source as a point-map g : Unit â’ Tm,
--     g _ = l.  A control datum c : t â‰¡ l is exactly a mapping-cone
--     spoke: hub â‰¡ inj (g tt) is hub â‰¡ inj l, and the locus point (t,c)
--     names the spoke at t.  We land the locus in singl (hub) of that
--     cone â” the contractible hub-based paths â” so "install's locus" and
--     "the cone's own contractible core" are one contractible type.
------------------------------------------------------------------------

module _ {l r : Tm} (d : Derivation l r) where

  g : Unit â†’ Tm
  g _ = l

  -- the mapping cone of the source point-map.
  TheCone : Typeâ‚€
  TheCone = Cone g

  -- each locus point gives a spoke-path in the cone: hub â‰¡ inj t,
  -- obtained by composing the canonical spoke (hub â‰¡ inj l) with injâˆ˜(tâ‰¡l).
  toSpoke : Locus d â†’ Î£[ y âˆˆ TheCone ] (hub â‰¡ y)
  toSpoke (t , c) = inj t , (spoke tt âˆ™ cong inj (sym c))

------------------------------------------------------------------------
-- à© Â One cell, not a class: the locus is a proposition.
------------------------------------------------------------------------

locusIsProp : {l r : Tm} (d : Derivation l r) (x y : Locus d) â†’ x â‰¡ y
locusIsProp d x y = isContrâ†’isProp (locusIsCone d) x y

------------------------------------------------------------------------
-- THE FEE â” the residual one level up, cited from the localization
-- sequence: after install collapses meaning-equal routes, cost is
-- exactly what does not descend.
------------------------------------------------------------------------

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (kernelCostDoesNotDescend)

-- install kills by a contractible cone (Â§Â§1â“3, above); the fee it leaves
-- one level up is the non-descending cost (cited, one object).
theFee = kernelCostDoesNotDescend
