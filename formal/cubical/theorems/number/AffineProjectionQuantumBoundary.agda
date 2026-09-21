{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AffineProjectionQuantumBoundary
--
-- The exact finite process boundary behind
--
--     6x + 10y = 14 mod 30.
--
-- Arithmetic elimination identifies six admitted x residues and ten y lifts
-- above each one.  Once that proved solution chart is encoded as
-- `Fin 6 × Fin 10`, projection to the actual x coordinate needs and attains a
-- `Fin 10` certificate.  Overwriting every solution by the single symbolic
-- statement `x = 4 mod 5` is a different, constant map: its certificate must
-- retain the whole sixty-state solution chart.
--
-- This module does not re-prove the gcd arithmetic.  It checks the quantum /
-- process transport from the exact solution chart supplied by
-- ARITHMETIC_LIFE_BINARY_PROJECTION through CertificateFibration.
------------------------------------------------------------------------

module AffineProjectionQuantumBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Foundations.Isomorphism
  using (Iso ; invIso ; isoToEquiv)
open import Cubical.Data.Fin using (Fin ; fzero ; isSetFin)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd ; Σ≡Prop ; ΣPathP)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Functions.Embedding
  using (isEmbedding ; _↪_ ; Equiv→Embedding ; compEmbedding)

import CertificateFibration as Cert
import FiniteInformation as FI

------------------------------------------------------------------------
-- 1. The exact solution chart delivered by arithmetic elimination
------------------------------------------------------------------------

ProjectedX : Type₀
ProjectedX = Fin 6

EliminatedKernel : Type₀
EliminatedKernel = Fin 10

Solutions : Type₀
Solutions = ProjectedX × EliminatedKernel

isSetSolutions : isSet Solutions
isSetSolutions = isSet× isSetFin isSetFin

------------------------------------------------------------------------
-- 2. Pointwise variable elimination costs exactly the gcd fibre
------------------------------------------------------------------------

projectX : Solutions → ProjectedX
projectX = fst

kernelCoordinate : Solutions → EliminatedKernel
kernelCoordinate = snd

projectFiberIso : (x : ProjectedX)
  → Iso (fiber projectX x) EliminatedKernel
Iso.fun      (projectFiberIso x) ((x' , k) , _) = k
Iso.inv      (projectFiberIso x) k              = (x , k) , refl
Iso.rightInv (projectFiberIso x) _              = refl
Iso.leftInv  (projectFiberIso x) ((x' , k) , p) =
  Σ≡Prop (λ _ → isSetFin _ _) (ΣPathP (sym p , refl))

-- Any exact coherent certificate for pointwise elimination contains Fin 10.
projection-environment-lower : {Environment : Type₀}
  (certificate : Solutions → Environment)
  → isEmbedding (Cert.recorded projectX certificate)
  → EliminatedKernel ↪ Environment
projection-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert projectX certificate embedding fzero)
    (Equiv→Embedding (isoToEquiv (invIso (projectFiberIso fzero))))

-- The reconstructed y-coset coordinate attains the lower bound.
kernel-coordinate-completes : FI.Completes projectX kernelCoordinate
kernel-coordinate-completes (_ , _) (_ , _) equality = equality

projection-environment-attains :
  isEmbedding (Cert.recorded projectX kernelCoordinate)
projection-environment-attains =
  Cert.Completes→isEmbedding projectX kernelCoordinate
    isSetFin isSetFin kernel-coordinate-completes

------------------------------------------------------------------------
-- 3. A symbolic solution description is a different quotient
------------------------------------------------------------------------

-- Every basis solution satisfies the same symbolic output `x = 4 mod 5`.
-- We use Unit because the bytes of that one description are irrelevant: the
-- map has one output value.
symbolicSummary : Solutions → Unit
symbolicSummary _ = tt

summaryFiberIso : Iso (fiber symbolicSummary tt) Solutions
Iso.fun      summaryFiberIso (solution , _) = solution
Iso.inv      summaryFiberIso solution       = solution , refl
Iso.rightInv summaryFiberIso _              = refl
Iso.leftInv  summaryFiberIso (solution , _) =
  Σ≡Prop (λ _ → isSetUnit _ _) refl

-- Any exact coherent overwrite to the one symbolic coset contains the whole
-- sixty-state solution chart, not merely the ten-state eliminated kernel.
summary-environment-lower : {Environment : Type₀}
  (certificate : Solutions → Environment)
  → isEmbedding (Cert.recorded symbolicSummary certificate)
  → Solutions ↪ Environment
summary-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert symbolicSummary certificate embedding tt)
    (Equiv→Embedding (isoToEquiv (invIso summaryFiberIso)))

summaryCertificate : Solutions → Solutions
summaryCertificate solution = solution

summary-completes : FI.Completes symbolicSummary summaryCertificate
summary-completes _ _ equality = cong snd equality

summary-environment-attains :
  isEmbedding (Cert.recorded symbolicSummary summaryCertificate)
summary-environment-attains =
  Cert.Completes→isEmbedding symbolicSummary summaryCertificate
    isSetUnit isSetSolutions summary-completes
