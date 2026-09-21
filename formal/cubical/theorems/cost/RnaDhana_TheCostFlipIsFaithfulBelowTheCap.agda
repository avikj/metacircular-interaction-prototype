{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheCostFlipIsFaithfulBelowTheCap
--
-- à‹àà§à¨ Â a-dhana â” debt and asset.  Brahmagupta,
-- *Brhmasphuasiddhnta*, 628, states the arithmetic of **dhana**
-- (asset, the quantity read as gain) and **a** (debt, the same
-- magnitude read as loss) together with nya, in the chapter that
-- also carries the kuaka.  A cost coordinate and a benefit
-- coordinate in this module are one magnitude under those two
-- readings, and the whole subject of the module is what it costs to
-- turn one reading into the other.  **No claim is made that
-- Brahmagupta proved anything below**: the debt/asset distinction is
-- his, the cap and its adjunction are not, and the theorem is
-- elementary.  The name leads with the term because the structure is
-- named there first and the English is the translation, not the other
-- way round.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `FlippingACostCoordinateIsSoundButNotFaithful` proved that mixed
-- dominance implies product dominance of the capped-and-subtracted
-- vectors and refuted the unrestricted converse.  The RESTRICTED
-- converse is proved here, and the hypothesis needed is weaker than
-- "every cost is `â‰ cap`".
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   boundedSum          `y â‰ c â’ (c âˆ y) + y â‰ c` â” the half of the
--                       monus identity the bound actually buys
--   capReflects         `y â‰ c â’ c âˆ x â‰ c âˆ y â’ y â‰ x`: below the cap
--                       the a reading reflects the dhana one
--   Bounded cap ds v    a recursive family: every COST entry of v is
--                       `â‰ cap`; benefit entries are unconstrained
--   flipReflectsBelowTheCap
--                       `Bounded cap ds w â’ flipWith cap ds v â‰¼
--                        flipWith cap ds w â’ Dom ds v w`
--   flipIsFaithfulBelowTheCap
--                       with `flipIsSound`, the two orders agree
--
-- **THE HYPOTHESIS IS ONE-SIDED, AND THAT IS THE CONTENT.**  Only the
-- costs of `w` â” the DOMINATING vector, the one claimed better â” need
-- the bound; `v`'s costs may exceed the cap arbitrarily.  The reason is
-- visible in `capReflects`: the bound is used to turn `(c âˆ y) + y`
-- back into `c`, and `y` is `w`'s entry.  So a cap has to be chosen
-- above the costs of the candidates one wants to CONCLUDE ARE BETTER,
-- not above every cost in the archive.  That is a materially weaker
-- modelling obligation.
--
-- The refutation is consistent with it: its witness has
-- `cap = 3` with `w`'s cost `7`, which fails `Bounded`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Truncated subtraction reflecting the reversed order
-- below the truncation point is elementary, and the two library facts
-- doing the work (`â‰-âˆ-+-cancel`, `â‰-k+-cancel`) are cubical's.  The
-- Galois-adjunction framing of monus is Birkhoff/Ore-era lattice
-- theory.
------------------------------------------------------------------------

module RnaDhana_TheCostFlipIsFaithfulBelowTheCap where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _âˆ¸_ ; +-zero ; +-suc)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; suc-â‰¤-suc ; pred-â‰¤-pred ; Â¬-<-zero
        ; â‰¤-âˆ¸-+-cancel ; â‰¤-k+-cancel)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (âˆ¸-adjË¡)
open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec ; Dom ; flipWith ; flipIsSound)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_â‰¼_)

------------------------------------------------------------------------
-- 1.  What the bound buys, at one coordinate
------------------------------------------------------------------------

boundedSum : (c y : â„•) â†’ y â‰¤ c â†’ (c âˆ¸ y) + y â‰¤ c
boundedSum c y h = subst (_â‰¤ c) (sym (â‰¤-âˆ¸-+-cancel h)) â‰¤-refl

capReflects : (c x y : â„•) â†’ y â‰¤ c â†’ c âˆ¸ x â‰¤ c âˆ¸ y â†’ y â‰¤ x
capReflects c x y ybound h =
  â‰¤-k+-cancel (subst (_â‰¤ (c âˆ¸ y) + x) (sym (â‰¤-âˆ¸-+-cancel ybound))
                     (âˆ¸-adjË¡ c x (c âˆ¸ y) h))

------------------------------------------------------------------------
-- 2.  Bounded on the dominating side only
------------------------------------------------------------------------

Bounded : (cap : â„•) (ds : List Bool) â†’ Vec ds â†’ Type
Bounded cap []           _        = Unit
Bounded cap (true  âˆ· ds) (x , xs) = Bounded cap ds xs
Bounded cap (false âˆ· ds) (x , xs) = (x â‰¤ cap) Ã— Bounded cap ds xs

------------------------------------------------------------------------
-- 3.  The restricted converse
------------------------------------------------------------------------

flipReflectsBelowTheCap :
  (cap : â„•) (ds : List Bool) (v w : Vec ds)
  â†’ Bounded cap ds w
  â†’ flipWith cap ds v â‰¼ flipWith cap ds w â†’ Dom ds v w
flipReflectsBelowTheCap cap []           _        _        _        _ = tt
flipReflectsBelowTheCap cap (true  âˆ· ds) (x , xs) (y , ys) b (le , r) =
  le , flipReflectsBelowTheCap cap ds xs ys b r
flipReflectsBelowTheCap cap (false âˆ· ds) (x , xs) (y , ys) (yb , b) (le , r) =
  capReflects cap x y yb le , flipReflectsBelowTheCap cap ds xs ys b r

flipIsFaithfulBelowTheCap :
  (cap : â„•) (ds : List Bool) (v w : Vec ds)
  â†’ Bounded cap ds w
  â†’ (Dom ds v w â†’ flipWith cap ds v â‰¼ flipWith cap ds w)
  Ã— (flipWith cap ds v â‰¼ flipWith cap ds w â†’ Dom ds v w)
flipIsFaithfulBelowTheCap cap ds v w b =
    flipIsSound cap ds v w
  , flipReflectsBelowTheCap cap ds v w b

------------------------------------------------------------------------
-- Here the cap is a single number shared by all cost coordinates.
-- Per-coordinate caps are in
-- `RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase`.
--
-- The generalisation costs nothing: `flipCapsIsSound`,
-- `flipCapsReflect` and `flipCapsFaithful` are this module's theorems
-- coordinate by coordinate, with `capReflects` reused unchanged.  Two
-- things it buys.  Benefit coordinates carry NO cap at all in `Caps
-- ds`, which the single number could not express; and
-- `oneCapIsTheSpecialCase` shows `flipWithCaps ds (constCaps cap ds)`
-- is `flipWith cap ds` pointwise, so nothing here is superseded â” it
-- is the constant assignment of the general statement.
--
-- The modelling point, which is why it is worth the module: a single
-- cap forces one number above every cost in every coordinate, so a
-- dollar cost and a wall time must share a ceiling and are silently
-- made commensurable.
------------------------------------------------------------------------
