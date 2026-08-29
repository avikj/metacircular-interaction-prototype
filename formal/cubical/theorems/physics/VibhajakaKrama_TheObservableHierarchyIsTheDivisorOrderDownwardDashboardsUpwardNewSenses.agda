{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विभाजक-क्रम — the divisor order.
--
-- The ladder's rungs, ordered.  Between the full strand reading
-- (mod four) and the xor reading (mod two):
--
--   §1  DOWNWARD IS A DASHBOARD: the xor reading factors through the
--       full reading, by the tautological witness — a coarser rung is
--       post-processing of a finer one, and by the derived-sense
--       theorem it adds no separation.
--
--   §2  UPWARD IS IMPOSSIBLE: the full reading does not factor
--       through the xor reading — the xor conflates the constant
--       strand with its half-turn (both read false) while the full
--       reading separates them, so any reconstruction dies at that
--       named pair.
--
-- Hence the hierarchy of aliasing observables is ordered exactly as
-- their moduli divide: mod one below mod two below mod four,
-- dashboards flowing down, new senses required to climb.  Divisibility
-- of resolution IS derivability of observables — the ladder, the
-- admission gate, and the divisor lattice are one structure, and the
-- direction of information is the direction of division.
--
-- SYĀT — THE CLAIM, EXACTLY.  The two directions between the named
-- rungs; the statement over the full divisor lattice at every modulus
-- is the standing construction.
------------------------------------------------------------------------

module VibhajakaKrama_TheObservableHierarchyIsTheDivisorOrderDownwardDashboardsUpwardNewSenses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_,_ ; fst)
open import Cubical.Data.Empty using (⊥)

open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import MatraSopana_EachObservableReadsTheTwistCountModuloTheOrderOfItsOwnBlindness
  using (vyatyaya)
open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति)

------------------------------------------------------------------------
-- १ · Downward: the xor rung is a dashboard of the full reading.
------------------------------------------------------------------------

adhaḥ-praṇālī : प्रवहति (λ (x : Sūtra) → x) vyatyaya
adhaḥ-praṇālī = vyatyaya , λ x → refl

------------------------------------------------------------------------
-- २ · Upward: the full reading is no dashboard of the xor rung.
------------------------------------------------------------------------

ūrdhva-agamya : (h : Bool → Sūtra)
              → ((x : Sūtra) → x ≡ h (vyatyaya x))
              → ⊥
ūrdhva-agamya h fac =
  true≢false
    (cong fst (fac (true , true) ∙ sym (fac (false , false))))
