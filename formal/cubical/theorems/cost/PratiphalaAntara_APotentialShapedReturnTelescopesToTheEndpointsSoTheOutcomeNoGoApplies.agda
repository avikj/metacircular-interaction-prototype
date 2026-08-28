{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिफल-अन्तर — the return difference.
--
-- RESOLUTION TOWARD ABSTRACT 12.  That abstract proved no functional
-- of an endpoint-valued evaluation separates two histories sharing
-- endpoints, and scoped away the reward-learning vocabulary: no
-- return, no shaping.  This file constructs the return and proves the
-- shaping side, which is the missing half of the potential-based
-- shaping story:
--
--   A REWARD DERIVED FROM A POTENTIAL HAS AN ENDPOINT-DETERMINED
--   RETURN.  For a deterministic system δ : S → S and a potential
--   Φ : S → ℕ, let each step pay the debit Φ(state before) and earn
--   the credit Φ(state after).  Then over any k steps,
--
--       Φ s + credits k s ≡ debits k s + Φ (after k steps)
--
--   — the telescoping identity, stated additively so it lives in ℕ
--   with no subtraction.  The net shaped return (credits against
--   debits) is a function of the two endpoints alone, so EVERY no-go
--   of abstract 12 applies to it in full: a shaped return cannot rank
--   routes, cannot recover length, cannot adjudicate between two
--   histories sharing endpoints — it is exactly as blind as the
--   outcome, because it IS a function of the outcome.
--
-- The connective law, third appearance this campaign: FACTORING KILLS
-- SEPARATION.  Between instruments (a derived sense adds no vision),
-- along time (a factoring observation collapses Nerode to one
-- reading), and now along value: a reward derived from state adds no
-- route information.  Shaping is the dashboard condition on reward,
-- and the potential-based class is precisely the class of rewards
-- that provably cannot see the route.  Conversely, a reward that DOES
-- separate two same-endpoint histories is thereby certified
-- non-potential — the admission gate for genuinely route-sensitive
-- reward, dual to ApurvaIndriyam's gate for genuinely new senses.
--
-- SYĀT — THE CLAIM, EXACTLY.  Deterministic dynamics, ℕ-valued
-- potential, unit discount.  Stochasticity and discounting are the
-- next constructions; the shaping reading of abstract 12 is no longer
-- among the absences.
------------------------------------------------------------------------

module PratiphalaAntara_APotentialShapedReturnTelescopesToTheEndpointsSoTheOutcomeNoGoApplies where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-assoc)

private
  variable
    ℓ : Level

module _ {S : Type ℓ} (δ : S → S) (Φ : S → ℕ) where

  -- k steps, composed from the near end.
  gamana : ℕ → S → S
  gamana zero    s = s
  gamana (suc k) s = gamana k (δ s)

  -- The debits (potential before each step) and credits (after).
  vyaya-rāśi : ℕ → S → ℕ
  vyaya-rāśi zero    s = zero
  vyaya-rāśi (suc k) s = Φ s + vyaya-rāśi k (δ s)

  āya-rāśi : ℕ → S → ℕ
  āya-rāśi zero    s = zero
  āya-rāśi (suc k) s = Φ (δ s) + āya-rāśi k (δ s)

  -- THE TELESCOPING IDENTITY: the shaped return is endpoint data.
  saṅkalana : (k : ℕ) (s : S)
            → Φ s + āya-rāśi k s ≡ vyaya-rāśi k s + Φ (gamana k s)
  saṅkalana zero    s = +-zero (Φ s)
  saṅkalana (suc k) s =
    cong (Φ s +_) (saṅkalana k (δ s))
    ∙ +-assoc (Φ s) (vyaya-rāśi k (δ s)) (Φ (gamana k (δ s)))
