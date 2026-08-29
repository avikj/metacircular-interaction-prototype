{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेणी-चतुष्टय — four strands.
--
-- THE QUESTION VeniTraya handed forward: presentation-completeness.
-- The braid group B₄ is presented by three generators subject to
-- exactly three relations — two adjacent braid relations and one
-- distant commutation.  On four twisted-swap crossings over
-- interdependent-pair strands, ALL THREE HOLD BY REFL:
--
--   §1  σ₁σ₂σ₁ = σ₂σ₁σ₂         (adjacent, low)      — refl
--   §2  σ₂σ₃σ₂ = σ₃σ₂σ₃         (adjacent, high)     — refl
--   §3  σ₁σ₃  = σ₃σ₁            (distant commutation) — refl
--
-- So the entire defining presentation of B₄ is verified on the
-- representation with no path algebra at all, while the action
-- remains genuinely braided (non-commuting adjacent generators and
-- the order-eight crossing, inherited from the two- and three-strand
-- files).  Distant crossings commute because they touch disjoint
-- strands; adjacent ones braid because they share one; and the
-- entire difference between commuting and braiding is whether the
-- crossings MEET — interdependence, again, as the source of all
-- coherence.
--
-- SYĀT — THE CLAIM, EXACTLY.  The relations of B₄ are verified; that
-- no further relations hold (faithfulness of the induced finite
-- quotient) is the next construction, as is the general Bₙ scheme.
------------------------------------------------------------------------

module VeniCatustaya_AllRelationsOfTheFourStrandBraidGroupHoldByReflSoThePresentationIsCompleteAtFour where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)

Catuṣka : Type₀
Catuṣka = Sūtra × (Sūtra × (Sūtra × Sūtra))

σ₁ σ₂ σ₃ : Catuṣka → Catuṣka
σ₁ (w , (x , (y , z))) = caturaṃśa x , (w , (y , z))
σ₂ (w , (x , (y , z))) = w , (caturaṃśa y , (x , z))
σ₃ (w , (x , (y , z))) = w , (x , (caturaṃśa z , y))

-- §1 · The low adjacent braid relation.
veṇī-nimna : (t : Catuṣka) → σ₁ (σ₂ (σ₁ t)) ≡ σ₂ (σ₁ (σ₂ t))
veṇī-nimna t = refl

-- §2 · The high adjacent braid relation.
veṇī-ucca : (t : Catuṣka) → σ₂ (σ₃ (σ₂ t)) ≡ σ₃ (σ₂ (σ₃ t))
veṇī-ucca t = refl

-- §3 · The distant commutation.
dūra-vinimaya : (t : Catuṣka) → σ₁ (σ₃ t) ≡ σ₃ (σ₁ t)
dūra-vinimaya t = refl
