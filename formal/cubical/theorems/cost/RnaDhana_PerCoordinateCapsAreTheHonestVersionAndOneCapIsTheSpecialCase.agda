{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
--
-- à‹àà§à¨ Â a-dhana â” Brahmagupta, *Brhmasphuasiddhnta* (628): one
-- magnitude read as *dhana* (asset) or *a* (debt).  A benefit
-- coordinate and a cost coordinate are that same magnitude under the
-- two readings, and this line is about what it costs to turn one into
-- the other.  The sign rules are his; the cap, the adjunction, and the
-- per-coordinate refinement below are not, and no claim is made that
-- they are.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `RnaDhana_TheCostFlipIsFaithfulBelowTheCap` closed the restricted
-- converse and ended with:
--
--   "The cap is still a single number shared by all cost coordinates;
--    per-coordinate caps are not modelled, though the one-sided
--    hypothesis suggests they would be the honest version."
--
-- They are modelled here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Caps ds            a cap PER COST COORDINATE, as a recursive family
--                      over the direction list â” benefit coordinates
--                      carry no cap at all, which the single-number
--                      version could not express
--   flipWithCaps       the flip against those caps
--   BoundedC           each cost entry is below ITS OWN cap
--   flipCapsIsSound    mixed dominance still implies product dominance
--                      of the flipped vectors â” the bound plays no part
--   flipCapsReflect    and below the caps the converse holds, with the
--                      bound needed only on the DOMINATING vector, as
--                      before
--   flipCapsFaithful   so the two orders agree there
--   constCaps          the constant cap assignment
--   oneCapIsTheSpecialCase
--                      `flipWithCaps ds (constCaps cap ds) v â‰¡
--                       flipWith cap ds v`, pointwise on the nose â” so
--                      the earlier theorem is this one at a constant
--                      family and nothing was lost by proving it first
--
-- **WHY THIS IS THE HONEST VERSION, IN ONE SENTENCE.**  A single cap
-- forces one number above every cost in every coordinate, so a
-- dollar-cost coordinate and a wall-time coordinate must share a
-- ceiling and are silently made commensurable; per-coordinate caps
-- require only that each coordinate be capped in its own units, which
-- is what a modelling obligation about incomparable objectives should
-- say.  The benefit coordinates carrying NO cap is the same point from
-- the other side: the single-number version had to pretend they were
-- capped too.
--
-- NO NOVELTY.  Nothing here is more than the earlier module coordinate
-- by coordinate; the only content is that the generalisation costs
-- nothing and strictly weakens the hypothesis.
------------------------------------------------------------------------

module RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; _âˆ¸_)
open import Cubical.Data.Nat.Order using (_â‰¤_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)

open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec ; Dom ; flipWith ; âˆ¸-antitone)
open import RnaDhana_TheCostFlipIsFaithfulBelowTheCap
  using (capReflects)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_â‰¼_)

------------------------------------------------------------------------
-- 1.  One cap per cost coordinate, none per benefit coordinate
------------------------------------------------------------------------

Caps : List Bool â†’ Type
Caps []           = Unit
Caps (true  âˆ· ds) = Caps ds
Caps (false âˆ· ds) = â„• Ã— Caps ds

flipWithCaps : (ds : List Bool) â†’ Caps ds â†’ Vec ds â†’ List â„•
flipWithCaps []           _        _        = []
flipWithCaps (true  âˆ· ds) cs       (x , xs) = x âˆ· flipWithCaps ds cs xs
flipWithCaps (false âˆ· ds) (c , cs) (x , xs) = (c âˆ¸ x) âˆ· flipWithCaps ds cs xs

BoundedC : (ds : List Bool) â†’ Caps ds â†’ Vec ds â†’ Type
BoundedC []           _        _        = Unit
BoundedC (true  âˆ· ds) cs       (x , xs) = BoundedC ds cs xs
BoundedC (false âˆ· ds) (c , cs) (x , xs) = (x â‰¤ c) Ã— BoundedC ds cs xs

------------------------------------------------------------------------
-- 2.  Sound without any bound, faithful below the caps
------------------------------------------------------------------------

flipCapsIsSound :
  (ds : List Bool) (cs : Caps ds) (v w : Vec ds)
  â†’ Dom ds v w â†’ flipWithCaps ds cs v â‰¼ flipWithCaps ds cs w
flipCapsIsSound []           _        _        _        _           = tt
flipCapsIsSound (true  âˆ· ds) cs       (x , xs) (y , ys) (le , rest) =
  le , flipCapsIsSound ds cs xs ys rest
flipCapsIsSound (false âˆ· ds) (c , cs) (x , xs) (y , ys) (ge , rest) =
  âˆ¸-antitone c y x ge , flipCapsIsSound ds cs xs ys rest

flipCapsReflect :
  (ds : List Bool) (cs : Caps ds) (v w : Vec ds)
  â†’ BoundedC ds cs w
  â†’ flipWithCaps ds cs v â‰¼ flipWithCaps ds cs w â†’ Dom ds v w
flipCapsReflect []           _        _        _        _         _          = tt
flipCapsReflect (true  âˆ· ds) cs       (x , xs) (y , ys) b         (le , r)   =
  le , flipCapsReflect ds cs xs ys b r
flipCapsReflect (false âˆ· ds) (c , cs) (x , xs) (y , ys) (yb , b)  (le , r)   =
  capReflects c x y yb le , flipCapsReflect ds cs xs ys b r

flipCapsFaithful :
  (ds : List Bool) (cs : Caps ds) (v w : Vec ds)
  â†’ BoundedC ds cs w
  â†’ (Dom ds v w â†’ flipWithCaps ds cs v â‰¼ flipWithCaps ds cs w)
  Ã— (flipWithCaps ds cs v â‰¼ flipWithCaps ds cs w â†’ Dom ds v w)
flipCapsFaithful ds cs v w b =
  flipCapsIsSound ds cs v w , flipCapsReflect ds cs v w b

------------------------------------------------------------------------
-- 3.  The single cap is the constant assignment
------------------------------------------------------------------------

constCaps : â„• â†’ (ds : List Bool) â†’ Caps ds
constCaps cap []           = tt
constCaps cap (true  âˆ· ds) = constCaps cap ds
constCaps cap (false âˆ· ds) = cap , constCaps cap ds

oneCapIsTheSpecialCase :
  (cap : â„•) (ds : List Bool) (v : Vec ds)
  â†’ flipWithCaps ds (constCaps cap ds) v â‰¡ flipWith cap ds v
oneCapIsTheSpecialCase cap []           _        = refl
oneCapIsTheSpecialCase cap (true  âˆ· ds) (x , xs) =
  cong (x âˆ·_) (oneCapIsTheSpecialCase cap ds xs)
oneCapIsTheSpecialCase cap (false âˆ· ds) (x , xs) =
  cong ((cap âˆ¸ x) âˆ·_) (oneCapIsTheSpecialCase cap ds xs)
