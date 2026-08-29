{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सोपान-भेद — the rungs are separated.
--
-- The ladder said each observable reads the count modulo its alias's
-- order.  This file proves the rungs are GENUINELY separated — the
-- admission gate of ApurvaIndriyam, standing vertically:
--
--   §1  ANY OBSERVABLE WITH AN INVOLUTIVE ALIAS CONFLATES COUNTS ONE
--       AND THREE: if O aliases through a g with g² = id, then O
--       cannot tell one quarter turn from three — the odd counts
--       collapse, generically, by the ladder law and one involution.
--
--   §2  THE FULL READING SEPARATES THEM: one and three quarter turns
--       of the constant strand differ at a named coordinate.
--
--   §3  HENCE THE FULL READING ADMITS NO INVOLUTIVE ALIAS AT ALL —
--       no g with g² = id makes the identity factor, for the exact
--       reason §1 and §2 collide.  Climbing from mod-two to mod-four
--       resolution is therefore not post-processing of any mod-two
--       sense: it is a new organ, certified by the blind pair (counts
--       one and three) that every lower rung provably conflates.
--
-- The ladder and the admission gate are one structure: each rung's
-- blindness is the next rung's certificate, which is the śeṣa
-- trilaw's generativity clause climbing the divisors — resolution
-- grows only by senses no alias can synthesize.
--
-- SYĀT — THE CLAIM, EXACTLY.  The separation at the involutive rung;
-- the same separation at every divisor pair is the standing
-- construction.
------------------------------------------------------------------------

module SopanaBheda_ClimbingARungIsANewSenseNoInvolutiveAliasServesTheFullReading where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (true ; false ; true≢false)
open import Cubical.Data.Sigma using (_,_ ; fst)
open import Cubical.Data.Empty using (⊥)

open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana)
private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- १ · An involutive alias conflates counts one and three.
------------------------------------------------------------------------

module _ {A : Type ℓ} (O : Sūtra → A) (g : A → A)
         (pravāha : (x : Sūtra) → O (caturaṃśa x) ≡ g (O x))
         (nivartana : (a : A) → g (g a) ≡ a) where

  tri-eka : (x : Sūtra) → O (cakrāvartana 3 x) ≡ O (cakrāvartana 1 x)
  tri-eka x =
    pravāha (cakrāvartana 2 x)
    ∙ cong g (pravāha (cakrāvartana 1 x))
    ∙ cong (λ a → g (g a)) (pravāha x)
    ∙ nivartana (g (O x))
    ∙ sym (pravāha x)

------------------------------------------------------------------------
-- २ · The full reading separates one from three.
------------------------------------------------------------------------

eka-tri-bheda : cakrāvartana 3 (true , true) ≡ cakrāvartana 1 (true , true) → ⊥
eka-tri-bheda p = true≢false (cong fst p)

------------------------------------------------------------------------
-- ३ · Hence no involutive alias serves the identity reading.
------------------------------------------------------------------------

na-nivartana-praṇālī : (g : Sūtra → Sūtra)
                     → ((x : Sūtra) → caturaṃśa x ≡ g x)
                     → ((x : Sūtra) → g (g x) ≡ x)
                     → ⊥
na-nivartana-praṇālī g pravāha nivartana =
  eka-tri-bheda (tri-eka (λ x → x) g pravāha nivartana (true , true))
