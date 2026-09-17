{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- àµàààà-àà¿à¨àà¦àà â” the one sentence `Bahupratyanayana_â¦` left unproved.
--
-- That module says, exactly: "NOT PROVED HERE: that SÂ has no two
-- distinct points (that is connectedness, in the library, and is not
-- invoked)."  It is invoked here.  `isConnectedSÂ : (s : SÂ) â’ âˆ base â‰¡ s âˆâ`
-- gives, for any two points, a mere path between them; a proof that
-- they are distinct would refute that mere path.  So:
--
--   no-two-points : Â (Î[ x âˆˆ SÂ ] Î[ y âˆˆ SÂ ] (Â x â‰¡ y))
--
-- and, stated positively, any two points of SÂ are not-not equal.  This
-- is the point-level statement the earlier module's Â§à needed: on SÂ the
-- point-level distinctness is absent, so the obstruction it exhibits
-- there is carried by the loop and by nothing else.  Nothing about Ïâ,
-- higher levels, or the retraction is touched.
------------------------------------------------------------------------
module VrttaBindu_TheCircleHasNoTwoDistinctPointsBecauseItIsConnectedSoTheObstructionToUndoingIsNeverTwoPointsThere where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Î£-syntax ; _,_)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.HITs.S1 using (SÂ¹ ; base)
open import Cubical.HITs.S1.Properties using (isConnectedSÂ¹)
open import Cubical.HITs.PropositionalTruncation as PT using (âˆ¥_âˆ¥â‚)

-- any two points are not-not equal
Â¬Â¬path : (x y : SÂ¹) â†’ Â¬ Â¬ (x â‰¡ y)
Â¬Â¬path x y Â¬p =
  PT.rec (Î» ()) (Î» bx â†’ PT.rec (Î» ()) (Î» by â†’ Â¬p (sym bx âˆ™ by)) (isConnectedSÂ¹ y)) (isConnectedSÂ¹ x)

-- so there is no pair of distinct points
no-two-points : Â¬ (Î£[ x âˆˆ SÂ¹ ] Î£[ y âˆˆ SÂ¹ ] (Â¬ x â‰¡ y))
no-two-points (x , y , Â¬p) = Â¬Â¬path x y Â¬p
