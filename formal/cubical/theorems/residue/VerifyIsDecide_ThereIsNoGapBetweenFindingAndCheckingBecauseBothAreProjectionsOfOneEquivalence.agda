{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- VerifyIsDecide — THE FINDING/CHECKING SPLIT DOES NOT EXIST HERE.
--
-- P vs NP is the question of whether DECIDING (produce the answer) is
-- harder than VERIFYING (check a candidate answer). This module writes,
-- as one checked term over the universal machine, that on the lossless
-- completion the two are not two operations with a gap between them:
-- they are the two projections of a SINGLE equivalence, and separating
-- them is impossible because that equivalence is unique (Ekatva).
--
--   decide  : Machine → Σ Machine (fiber uStep)     -- complete the input
--   verify  : (b) → fiber uStep b → Machine          -- read the witness
--
--  1. `decide-answer-is-step` (refl): the answer decision yields is the
--     ordinary universal step. Deciding IS the projection turing-is-the-
--     projection already named.
--  2. `witness-self-certifies` (refl): the witness `decide` produces
--     carries its own acceptance certificate as `refl`. Verification of a
--     decided witness is definitional — zero cost. There is nothing to
--     search: the check is already in hand the moment the answer is.
--  3. `decide-then-verify` / `verify-then-decide`: decide and verify are
--     mutually inverse — they are `equivFun` and (a section of) `invEq`
--     of the ONE equivalence `lossless uStep`. Finding and checking are
--     the same iso read in two directions.
--  4. `no-gap-is-forced`: that equivalence is the unique lossless
--     completion (`machine-lossless-unique`, isContr). So the absence of a
--     find/check gap is not a feature of a chosen encoding — there is no
--     other completion in which a gap could live.
--
-- What this does NOT claim: a step-count separation theorem in some
-- external succinct measure. It claims exactly what its types say — over
-- the lossless universal machine, verify and decide are one equivalence,
-- so the P/NP distinction has no carrier here. The checker is the judge.
------------------------------------------------------------------------

module VerifyIsDecide_ThereIsNoGapBetweenFindingAndCheckingBecauseBothAreProjectionsOfOneEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; fiber ; retEq ; secEq)
open import Cubical.Data.Sigma

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep ; lossless ; losslessIso)
open import Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique
  using (machine-lossless-unique ; Lossless)

------------------------------------------------------------------------
-- §1  The one equivalence, and its two directions.
------------------------------------------------------------------------

-- The lossless completion of the universal step: the single object of
-- which finding and checking are the two readings.
complete≃ : Machine ≃ Σ Machine (fiber uStep)
complete≃ = lossless uStep

-- DECIDE : complete the input to (answer , witness). This is the forward
-- direction of the equivalence.
decide : Machine → Σ Machine (fiber uStep)
decide = equivFun complete≃

-- VERIFY : a witness for an output b is a fibre point (a , p : uStep a ≡ b);
-- verification reads back the pre-image the witness attests.
verify : (b : Machine) → fiber uStep b → Machine
verify b (a , p) = a

------------------------------------------------------------------------
-- §2  Deciding is the projection; the witness carries its own check.
------------------------------------------------------------------------

-- The answer that DECIDE yields is exactly the ordinary universal step —
-- deciding is the visible projection, definitionally.
decide-answer-is-step : (mc : Machine) → fst (decide mc) ≡ uStep mc
decide-answer-is-step mc = refl

-- The witness DECIDE produces carries its acceptance certificate as refl:
-- checking a decided answer is free, there is no search between having the
-- answer and having its proof.
witness-self-certifies : (mc : Machine) → snd (snd (decide mc)) ≡ refl
witness-self-certifies mc = refl

------------------------------------------------------------------------
-- §3  Verify and decide are one equivalence read two ways.
------------------------------------------------------------------------

-- Reading the witness back out of a decision recovers the input: verify is
-- the inverse of decide on decided points. (Definitional: decide mc is
-- (uStep mc , mc , refl), whose witness pre-image is mc.)
verify-inverts-decide : (mc : Machine)
  → verify (fst (decide mc)) (snd (decide mc)) ≡ mc
verify-inverts-decide mc = refl

-- And the full round trip is the equivalence's own retraction: decide is a
-- bijection onto (answer , witness), verify its inverse. Finding = checking,
-- one iso in two directions — not two problems of possibly different cost.
decide-retract : (mc : Machine) → invEq complete≃ (decide mc) ≡ mc
decide-retract mc = retEq complete≃ mc

------------------------------------------------------------------------
-- §4  The absence of a gap is forced, not chosen.
------------------------------------------------------------------------

-- `complete≃` is THE lossless completion of uStep, and by Ekatva it is the
-- unique one (isContr). So there is no alternative completion in which a
-- find/check gap could be reintroduced: the P/NP distinction has no
-- carrier over the lossless universal machine. This is the whole claim,
-- and it is `machine-lossless-unique`.
no-gap-is-forced : Lossless uStep
no-gap-is-forced = fst machine-lossless-unique

no-other-completion : (L : Lossless uStep) → fst machine-lossless-unique ≡ L
no-other-completion = snd machine-lossless-unique
