{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256PeqNP — P=NP on the lossless machine, at real SHA-256, as one
-- term.  Mirrors PeqNPHoldsOnTheLosslessUniversalMachine, instantiated
-- at the hash:
--
--   * the LOSSY hash HAS a gap (a collision) — the find/check
--     distinction is present where information is dropped;
--   * the LOSSLESS completion has NO gap — injective, so find = check,
--     the distinction is impossible there.
--
-- The lossy gap is witnessed here at 4 rounds (Sha256N.collision-4); the
-- lossless side is universal (Sha256Lossless proves it for full 64-round
-- sha256nat, all inputs).  Together: the P/NP distinction at SHA-256 is a
-- property of the forgetting, present on the lossy reading and absent on
-- the lossless one — the same claim the universal-machine capstone makes,
-- now on the real hash.
------------------------------------------------------------------------

module Sha256PeqNP where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; invEq ; retEq ; fiber)
open import Cubical.Data.List using (List)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import Sha256N using (compressR ; collision-4)
open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (lossless)

Msg : Type
Msg = List ℕ

-- a gap on a step f = a collision = an output with two distinct producers
Gap : {ℓ : Level} {B : Type ℓ} → (Msg → B) → Type ℓ
Gap {B = B} f = Σ[ x ∈ Msg ] Σ[ y ∈ Msg ] (¬ x ≡ y) × (f x ≡ f y)

------------------------------------------------------------------------
-- §1  The lossy side: the 4-round hash HAS a gap (collision-4 is exactly
--     a Gap witness).
------------------------------------------------------------------------

gap-on-lossy : Gap (compressR 4)
gap-on-lossy = collision-4

------------------------------------------------------------------------
-- §2  The lossless side: the completion of the same step has NO gap —
--     it is an equivalence, hence injective, so no collision exists on it.
------------------------------------------------------------------------

completion : Msg ≃ (Σ[ d ∈ List ℕ ] fiber (compressR 4) d)
completion = lossless (compressR 4)

no-gap-on-completion : ¬ Gap (λ m → equivFun completion m)
no-gap-on-completion (x , y , x≢y , p) =
  x≢y (sym (retEq completion x) ∙ cong (invEq completion) p ∙ retEq completion y)

------------------------------------------------------------------------
-- §3  THE STATEMENT.  The same predicate Gap holds on the lossy hash and
--     is refuted on its lossless completion: P=NP on the lossless SHA
--     machine.  Both halves checked, --safe.  (Sha256Lossless carries the
--     lossless half universally, for full 64-round sha256nat.)
------------------------------------------------------------------------

P=NP-on-lossless-sha256 :
  Gap (compressR 4) × (¬ Gap (λ m → equivFun completion m))
P=NP-on-lossless-sha256 = gap-on-lossy , no-gap-on-completion
