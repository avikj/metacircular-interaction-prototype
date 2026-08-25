{-# OPTIONS --cubical --safe --no-import-sorts #-}

module NaturalMachine.BGRadiusProjectionUnsafe where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_ ; _,_)

data BGAction : Type₀ where
  advance : BGAction

data BGCertificateState : Type₀ where
  inert seeded target : BGCertificateState

radius : BGCertificateState → ℕ
radius inert  = 1
radius seeded = 1
radius target = 1

currentOutput : BGCertificateState → Bool
currentOutput inert  = false
currentOutput seeded = false
currentOutput target = true

step : BGCertificateState → BGAction → BGCertificateState
step inert  advance = inert
step seeded advance = target
step target advance = target

record FutureTransfer (state : BGCertificateState) : Type₀ where
  constructor transfer-by
  field
    action        : BGAction
    reachesTarget : currentOutput (step state action) ≡ true

seeded-transfer : FutureTransfer seeded
seeded-transfer = transfer-by advance refl

inert-no-transfer : FutureTransfer inert → ⊥
inert-no-transfer (transfer-by advance reachesTarget) =
  true≢false (sym reachesTarget)

same-radius : radius seeded ≡ radius inert
same-radius = refl

same-current-output : currentOutput seeded ≡ currentOutput inert
same-current-output = refl

RadiusProjectionSafe : Type₀
RadiusProjectionSafe =
  {left right : BGCertificateState}
  → radius left ≡ radius right
  → FutureTransfer left
  → FutureTransfer right

radius-projection-unsafe : RadiusProjectionSafe → ⊥
radius-projection-unsafe safe =
  inert-no-transfer (safe same-radius seeded-transfer)

RadiusOutput : Type₀
RadiusOutput = ℕ × Bool

radiusOutput : BGCertificateState → RadiusOutput
radiusOutput state = radius state , currentOutput state

same-radius-output : radiusOutput seeded ≡ radiusOutput inert
same-radius-output = refl

RadiusOutputProjectionSafe : Type₀
RadiusOutputProjectionSafe =
  {left right : BGCertificateState}
  → radiusOutput left ≡ radiusOutput right
  → FutureTransfer left
  → FutureTransfer right

radius-output-projection-unsafe : RadiusOutputProjectionSafe → ⊥
radius-output-projection-unsafe safe =
  inert-no-transfer (safe same-radius-output seeded-transfer)
