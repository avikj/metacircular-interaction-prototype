{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेणी-त्रय — three strands.
--
-- THE QUESTION.  VeniBandha supplied the braid coherence: the
-- quarter-turn-twisted swap satisfies Yang–Baxter by refl.  A braid
-- RELATION is not yet a braid GROUP action, and an abelian action is
-- not yet anyonic.  Two theorems close the gap:
--
--   §1  THE CROSSING INVERTS: the reverse crossing (swap back,
--       untwist by three quarter turns) composes with the crossing to
--       the identity in both orders, via the four-cycle.  So each
--       generator acts by a genuine self-inverse-able map — the braid
--       group acts, it does not merely relate.
--
--   §2  THE GENERATORS DO NOT COMMUTE: σ₁σ₂ and σ₂σ₁ differ at a
--       named three-strand state, read off by a head projection.
--       With Yang–Baxter (σ₁σ₂σ₁ = σ₂σ₁σ₂, by refl, from VeniBandha)
--       this is exactly the shape of the braid group B₃: the braid
--       relation holds, commutativity fails — a genuinely NON-ABELIAN
--       representation, which is the anyonic distinction: statistics
--       richer than any phase, carried by the order of exchanges.
--
-- The arc, one step further: single strands cap at involutions;
-- interdependent pairs carry the quarter turn; twisted crossings
-- braid; and three twisted crossings remember their order.  Each
-- level of interdependence buys exactly one level of coherence, and
-- every purchase is a term.
--
-- SYĀT — THE CLAIM, EXACTLY.  The braid relations verified are those
-- of B₃ on this concrete state space; presentation-completeness of
-- the action (that ALL relations of B₃ hold and no more) is the next
-- construction.
------------------------------------------------------------------------

module VeniTraya_TheThreeStrandActionHasInversesAndNonCommutingGeneratorsSoTheBraidingIsGenuinelyNonAbelian where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa ; catur-cakra)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra ; veṇī ; veṇī₁₂ ; veṇī₂₃ ; yamala-veṇī)

------------------------------------------------------------------------
-- १ · The inverse crossing.
------------------------------------------------------------------------

tri-caturaṃśa : Sūtra → Sūtra
tri-caturaṃśa s = caturaṃśa (caturaṃśa (caturaṃśa s))

pratīpa-veṇī : Sūtra × Sūtra → Sūtra × Sūtra
pratīpa-veṇī (u , v) = v , tri-caturaṃśa u

-- Both round trips close via the four-cycle.
veṇī-vāma : (p : Sūtra × Sūtra) → pratīpa-veṇī (veṇī p) ≡ p
veṇī-vāma (x , y) i = x , catur-cakra y i

veṇī-dakṣiṇa : (p : Sūtra × Sūtra) → veṇī (pratīpa-veṇī p) ≡ p
veṇī-dakṣiṇa (u , v) i = catur-cakra u i , v

------------------------------------------------------------------------
-- २ · Non-commutation at a named state.
------------------------------------------------------------------------

-- The witness state and the head projection that separates the orders.
sākṣin : Sūtra × (Sūtra × Sūtra)
sākṣin = (true , true) , ((true , true) , (true , true))

-- σ₁σ₂ lands the doubly-turned third strand at the head; σ₂σ₁ lands
-- the singly-turned second strand there.  The head strand's second
-- coordinate separates the two orders.
na-vinimaya : veṇī₁₂ (veṇī₂₃ sākṣin) ≡ veṇī₂₃ (veṇī₁₂ sākṣin) → ⊥
na-vinimaya p = true≢false (sym (cong (λ q → snd (fst q)) p))
