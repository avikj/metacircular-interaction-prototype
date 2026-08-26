{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PolyHaythamResponseCostNoGo
--
-- A response table is not a realization-cost model.  This is the cheapest
-- exact falsifier for the tempting inference that observational equality
-- prices the implementation which produces the observation.
--
-- Random-sample collision (2026-08-14):
--
--   * machinery/observer_channel.py audits exact response sufficiency only
--     on its declared finite state rows;
--     fabrication, calibration, sampling, and post-action return;
--   * collab/messages/0415-codex-seshat-tester-statistics-cost-result.md
--     records equal process statistics with unequal realization cost;
--   * AtomicSatisfaction checks preservation of responses,
--     not preservation of an unmentioned implementation coordinate.
--
-- The general theorem below says why.  If a response fiber contains two
-- implementations separated by a cost, no postprocessing of the response
-- can recover that cost.  The Bool instance has a constant response and an
-- identity cost, hence refutes response-to-cost descent with two points and
-- no numerical fit or legacy executable assertion.
------------------------------------------------------------------------

module PolyHaythamResponseCostNoGo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓX ℓY ℓC : Level

-- An explicit split response fiber refutes every proposed factorization of
-- the cost through the response.  No finiteness, cardinality, or metric is
-- needed; the missing implementation coordinate is the whole obstruction.
split-fiber-refutes-cost-descent :
  {X : Type ℓX} {Y : Type ℓY} {C : Type ℓC}
  (response : X → Y) (cost : X → C) {x x′ : X}
  → response x ≡ response x′
  → ¬ (cost x ≡ cost x′)
  → ¬ (Σ[ price ∈ (Y → C) ] ((z : X) → cost z ≡ price (response z)))
split-fiber-refutes-cost-descent response cost {x} {x′} same-response split
  (price , factors) =
  split (factors x ∙ cong price same-response ∙ sym (factors x′))

-- Cheapest concrete control: two implementations, one observed word.
response : Bool → Bool
response _ = false

cost : Bool → Bool
cost b = b

same-response : response false ≡ response true
same-response = refl

different-cost : ¬ (cost false ≡ cost true)
different-cost = false≢true

response-does-not-price-realization :
  ¬ (Σ[ price ∈ (Bool → Bool) ]
       ((implementation : Bool)
       → cost implementation ≡ price (response implementation)))
response-does-not-price-realization =
  split-fiber-refutes-cost-descent response cost same-response different-cost
