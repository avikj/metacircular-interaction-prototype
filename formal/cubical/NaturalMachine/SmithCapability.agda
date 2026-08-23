{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SmithCapability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient
open import Cubical.Algebra.IntegerMatrix.Smith

private
  variable
    m n : ℕ
    ℓ : Level

open Coefficient ℤCommRing
open Sim
open SimRel
open Smith

-- The native Cubical construction already is the proof-carrying executable
-- package sought by the repository.  Its output contains the normal matrix,
-- invertible left/right transformations, their replay equation, and a proof
-- of Smith normality.  Nothing needs to be reconstructed in Python.
normalizeSmith : (M : Mat m n) → Smith M
normalizeSmith = smith

normalMatrix : (M : Mat m n) → Mat m n
normalMatrix M = normalizeSmith M .sim .result

leftTransform : (M : Mat m n) → Mat m m
leftTransform M = normalizeSmith M .sim .simrel .transMatL

rightTransform : (M : Mat m n) → Mat n n
rightTransform M = normalizeSmith M .sim .simrel .transMatR

-- Replay is not a test: it is a path returned by the normalizer itself.
replaySmith : (M : Mat m n)
            → normalMatrix M
             ≡ leftTransform M ⋆ M ⋆ rightTransform M
replaySmith M = normalizeSmith M .sim .simrel .transEq

leftTransform-invertible : (M : Mat m n) → isInv (leftTransform M)
leftTransform-invertible M =
  normalizeSmith M .sim .simrel .isInvTransL

rightTransform-invertible : (M : Mat m n) → isInv (rightTransform M)
rightTransform-invertible M =
  normalizeSmith M .sim .simrel .isInvTransR

normalMatrix-isSmith : (M : Mat m n) → isSmithNormal (normalMatrix M)
normalMatrix-isSmith M = normalizeSmith M .isnormal

-- Native consumer joint.  A downstream capability receives the actual normal
-- matrix together with the invertible presentation change and its normality
-- proof; no external certificate decoder or untyped tuple intervenes.
withSmith : {A : Type ℓ} (M : Mat m n)
          → ((N : Mat m n) → SimRel M N → isSmithNormal N → A)
          → A
withSmith M consume =
  consume (normalMatrix M)
          (normalizeSmith M .sim .simrel)
          (normalMatrix-isSmith M)
