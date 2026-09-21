{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- वृत्त-बिन्दुः — the one sentence `Bahupratyanayana_…` left unproved.
--
-- That module says, exactly: "NOT PROVED HERE: that S¹ has no two
-- distinct points (that is connectedness, in the library, and is not
-- invoked)."  It is invoked here.  `isConnectedS¹ : (s : S¹) → ∥ base ≡ s ∥₁`
-- gives, for any two points, a mere path between them; a proof that
-- they are distinct would refute that mere path.  So:
--
--   no-two-points : ¬ (Σ[ x ∈ S¹ ] Σ[ y ∈ S¹ ] (¬ x ≡ y))
--
-- and, stated positively, any two points of S¹ are not-not equal.  This
-- is the point-level statement the earlier module's §५ needed: on S¹ the
-- point-level distinctness is absent, so the obstruction it exhibits
-- there is carried by the loop and by nothing else.  Nothing about π₁,
-- higher levels, or the retraction is touched.
------------------------------------------------------------------------
module VrttaBindu_TheCircleHasNoTwoDistinctPointsBecauseItIsConnectedSoTheObstructionToUndoingIsNeverTwoPointsThere where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base)
open import Cubical.HITs.S1.Properties using (isConnectedS¹)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁)

-- any two points are not-not equal
¬¬path : (x y : S¹) → ¬ ¬ (x ≡ y)
¬¬path x y ¬p =
  PT.rec (λ ()) (λ bx → PT.rec (λ ()) (λ by → ¬p (sym bx ∙ by)) (isConnectedS¹ y)) (isConnectedS¹ x)

-- so there is no pair of distinct points
no-two-points : ¬ (Σ[ x ∈ S¹ ] Σ[ y ∈ S¹ ] (¬ x ≡ y))
no-two-points (x , y , ¬p) = ¬¬path x y ¬p
