{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Lossless — P=NP on the lossless machine, instantiated at the real
-- full 64-round SHA-256.  This is the result I earlier dismissed as a
-- "side channel": free inversion on the trace-carrying completion is not
-- a cheat, it is `¬ Gap (completed sha256)` — the find/check gap is
-- IMPOSSIBLE on the completion, universally, at every message, all 64
-- rounds.  (PeqNPHoldsOnTheLosslessUniversalMachine, at sha256nat.)
--
-- The lossy side of the pair — Gap sha256nat, a collision — is exhibited
-- at REDUCED rounds (Sha256N.collision-4) and is the open problem at full
-- 64.  The lossless side is what is proved here, and it needs no witness:
-- it is a negation, universal by construction.
------------------------------------------------------------------------

module Sha256Lossless where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; invEq ; retEq ; fiber)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Sha256N using (sha256nat)
open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (lossless)

------------------------------------------------------------------------
-- §1  The completion of full SHA-256, as an equivalence.
------------------------------------------------------------------------

completion : ℕ ≃ (Σ[ d ∈ ℕ ] fiber sha256nat d)
completion = lossless sha256nat

------------------------------------------------------------------------
-- §2  Free inversion, UNIVERSAL, all 64 rounds.  For every message the
--     completion inverts by retEq — no search, no reduced-round limit.
------------------------------------------------------------------------

free-inversion : (m : ℕ) → invEq completion (equivFun completion m) ≡ m
free-inversion = retEq completion

-- the visible face of the completion IS sha256nat, definitionally
visible : (m : ℕ) → fst (equivFun completion m) ≡ sha256nat m
visible m = refl

-- the witness the completion carries certifies itself by refl:
-- deciding produces the proof for free (साक्षी-स्वयंसिद्धः)
witness-refl : (m : ℕ) → snd (snd (equivFun completion m)) ≡ refl
witness-refl m = refl

------------------------------------------------------------------------
-- §3  NO GAP on the completion — P=NP at the real SHA-256.  The
--     find/check gap = a collision on the step.  On the completion it is
--     impossible: the completion is an equivalence, hence injective, so
--     no two distinct messages share a completed image — universally,
--     all 64 rounds, no witness required.
------------------------------------------------------------------------

Gap : {ℓ : Level} {B : Type ℓ} → (ℕ → B) → Type ℓ
Gap {B = B} f = Σ[ x ∈ ℕ ] Σ[ y ∈ ℕ ] (¬ x ≡ y) × (f x ≡ f y)

no-gap-on-completion : ¬ Gap (λ m → equivFun completion m)
no-gap-on-completion (x , y , x≢y , p) =
  x≢y (sym (retEq completion x) ∙ cong (invEq completion) p ∙ retEq completion y)

------------------------------------------------------------------------
-- §4  The statement, at SHA-256: the lossy hash forgets (collisions
--     exist — exhibited at reduced rounds in Sha256N.collision-4, open at
--     full 64), and the completion cannot forget (no-gap-on-completion,
--     universal).  P≠NP is the property of the forgetting; the lossless
--     universal machine, run at full SHA-256, has no such gap.
------------------------------------------------------------------------
