{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àµààà-ààààààŸà¯ â” four strands.
--
-- THE QUESTION VeniTraya handed forward: presentation-completeness.
-- The braid group Bâ is presented by three generators subject to
-- exactly three relations â” two adjacent braid relations and one
-- distant commutation.  On four twisted-swap crossings over
-- interdependent-pair strands, ALL THREE HOLD BY REFL:
--
--   Â§1  ÏâÏâÏâ = ÏâÏâÏâ         (adjacent, low)      â” refl
--   Â§2  ÏâÏâÏâ = ÏâÏâÏâ         (adjacent, high)     â” refl
--   Â§3  ÏâÏâ  = ÏâÏâ            (distant commutation) â” refl
--
-- So the entire defining presentation of Bâ is verified on the
-- representation with no path algebra at all, while the action
-- remains genuinely braided (non-commuting adjacent generators and
-- the order-eight crossing, inherited from the two- and three-strand
-- files).  Distant crossings commute because they touch disjoint
-- strands; adjacent ones braid because they share one; and the
-- entire difference between commuting and braiding is whether the
-- crossings MEET â” interdependence, again, as the source of all
-- coherence.
--
------------------------------------------------------------------------

module VeniCatustaya_AllRelationsOfTheFourStrandBraidGroupHoldByReflSoThePresentationIsCompleteAtFour where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaá¹ƒÅ›a)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (SÅ«tra)

Catuá¹£ka : Typeâ‚€
Catuá¹£ka = SÅ«tra Ã— (SÅ«tra Ã— (SÅ«tra Ã— SÅ«tra))

Ïƒâ‚ Ïƒâ‚‚ Ïƒâ‚ƒ : Catuá¹£ka â†’ Catuá¹£ka
Ïƒâ‚ (w , (x , (y , z))) = caturaá¹ƒÅ›a x , (w , (y , z))
Ïƒâ‚‚ (w , (x , (y , z))) = w , (caturaá¹ƒÅ›a y , (x , z))
Ïƒâ‚ƒ (w , (x , (y , z))) = w , (x , (caturaá¹ƒÅ›a z , y))

-- Â§1 Â The low adjacent braid relation.
veá¹‡Ä«-nimna : (t : Catuá¹£ka) â†’ Ïƒâ‚ (Ïƒâ‚‚ (Ïƒâ‚ t)) â‰¡ Ïƒâ‚‚ (Ïƒâ‚ (Ïƒâ‚‚ t))
veá¹‡Ä«-nimna t = refl

-- Â§2 Â The high adjacent braid relation.
veá¹‡Ä«-ucca : (t : Catuá¹£ka) â†’ Ïƒâ‚‚ (Ïƒâ‚ƒ (Ïƒâ‚‚ t)) â‰¡ Ïƒâ‚ƒ (Ïƒâ‚‚ (Ïƒâ‚ƒ t))
veá¹‡Ä«-ucca t = refl

-- Â§3 Â The distant commutation.
dÅ«ra-vinimaya : (t : Catuá¹£ka) â†’ Ïƒâ‚ (Ïƒâ‚ƒ t) â‰¡ Ïƒâ‚ƒ (Ïƒâ‚ t)
dÅ«ra-vinimaya t = refl
