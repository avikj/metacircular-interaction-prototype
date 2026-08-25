{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.RadiusNoGo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Fin using (Fin ; toℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

record ProperFactor (n : ℕ) : Type₀ where
  constructor proper-factor
  field
    divisor : ℕ
    cofactor : ℕ
    divisor-proper : 1 < divisor
    cofactor-proper : 1 < cofactor
    factorization : divisor · cofactor ≡ n

record PrimePairTheory : Type₁ where
  field
    Prime : ℕ → Type₀
    PP : ℕ → ℕ → Type₀
    pp-left : {m n : ℕ} → PP m n → Prime m
    pp-right : {m n : ℕ} → PP m n → Prime n
    proper-factor-not-prime : {n : ℕ} → ProperFactor n → ¬ Prime n

data FailedLeg (m n : ℕ) : Type₀ where
  failed-left : ProperFactor m → FailedLeg m n
  failed-right : ProperFactor n → FailedLeg m n

failed-leg-refutes-PP :
  (theory : PrimePairTheory) {m n : ℕ} →
  FailedLeg m n → ¬ PrimePairTheory.PP theory m n
failed-leg-refutes-PP theory (failed-left factor) pair =
  PrimePairTheory.proper-factor-not-prime theory factor
    (PrimePairTheory.pp-left theory pair)
failed-leg-refutes-PP theory (failed-right factor) pair =
  PrimePairTheory.proper-factor-not-prime theory factor
    (PrimePairTheory.pp-right theory pair)

selected-center : {L : ℕ} → ℕ → Fin L → ℕ
selected-center N i = N + suc (toℕ i)

selected-left : {R L : ℕ} → ℕ → Fin L → Fin (suc R) → ℕ
selected-left N i r = selected-center N i ∸ toℕ r

selected-right : {R L : ℕ} → ℕ → Fin L → Fin (suc R) → ℕ
selected-right N i r = selected-center N i + toℕ r

record DesertCertificate (R L : ℕ) : Type₀ where
  constructor desert-certificate
  field
    N : ℕ
    factor-witness :
      (i : Fin L) (r : Fin (suc R)) →
      FailedLeg (selected-left N i r) (selected-right N i r)

AllSelectedPPFail :
  (theory : PrimePairTheory) {R L : ℕ} →
  DesertCertificate R L → Type₀
AllSelectedPPFail theory {R} {L} certificate =
  (i : Fin L) (r : Fin (suc R)) →
  ¬ PrimePairTheory.PP theory
      (selected-left (DesertCertificate.N certificate) i r)
      (selected-right (DesertCertificate.N certificate) i r)

desert-certificate-no-go :
  (theory : PrimePairTheory) {R L : ℕ} →
  (certificate : DesertCertificate R L) →
  AllSelectedPPFail theory certificate
desert-certificate-no-go theory certificate i r =
  failed-leg-refutes-PP theory
    (DesertCertificate.factor-witness certificate i r)

record VerifiedDesert
  (theory : PrimePairTheory) (R L : ℕ) : Type₀ where
  constructor verified-desert
  field
    certificate : DesertCertificate R L
    selected-PP-fail : AllSelectedPPFail theory certificate

DesertCRTGenerationObligation : (R L : ℕ) → Type₀
DesertCRTGenerationObligation R L = DesertCertificate R L

verify-desert-generation :
  (theory : PrimePairTheory) (R L : ℕ) →
  DesertCRTGenerationObligation R L → VerifiedDesert theory R L
verify-desert-generation theory R L certificate =
  verified-desert certificate (desert-certificate-no-go theory certificate)

record CenteredRecipe : Type₀ where
  constructor centered-recipe
  field
    left : ℕ → ℕ
    right : ℕ → ℕ
    centered : (w : ℕ) → left w + right w ≡ w + w

left-leg : CenteredRecipe → ℕ → ℕ
left-leg = CenteredRecipe.left

right-leg : CenteredRecipe → ℕ → ℕ
right-leg = CenteredRecipe.right

RecipeMenu : ℕ → Type₀
RecipeMenu K = Fin K → CenteredRecipe

record CongruenceKill (n : ℕ) : Type₀ where
  constructor congruence-kill
  field
    modulus : ℕ
    quotient : ℕ
    modulus-proper : 1 < modulus
    quotient-proper : 1 < quotient
    zero-congruence : modulus · quotient ≡ n

congruence-kill→proper-factor :
  {n : ℕ} → CongruenceKill n → ProperFactor n
congruence-kill→proper-factor kill = proper-factor
  (CongruenceKill.modulus kill)
  (CongruenceKill.quotient kill)
  (CongruenceKill.modulus-proper kill)
  (CongruenceKill.quotient-proper kill)
  (CongruenceKill.zero-congruence kill)

data CongruenceKilledLeg (m n : ℕ) : Type₀ where
  killed-left : CongruenceKill m → CongruenceKilledLeg m n
  killed-right : CongruenceKill n → CongruenceKilledLeg m n

congruence-killed→failed-leg :
  {m n : ℕ} → CongruenceKilledLeg m n → FailedLeg m n
congruence-killed→failed-leg (killed-left kill) =
  failed-left (congruence-kill→proper-factor kill)
congruence-killed→failed-leg (killed-right kill) =
  failed-right (congruence-kill→proper-factor kill)

record CongruenceKillingCertificate
  {K : ℕ} (menu : RecipeMenu K) : Type₀ where
  constructor congruence-killing-certificate
  field
    N : ℕ
    kills : (i : Fin K) →
      CongruenceKilledLeg
        (left-leg (menu i) N)
        (right-leg (menu i) N)

every-recipe-has-failed-leg :
  {K : ℕ} {menu : RecipeMenu K} →
  (certificate : CongruenceKillingCertificate menu) →
  (i : Fin K) →
  FailedLeg
    (left-leg (menu i) (CongruenceKillingCertificate.N certificate))
    (right-leg (menu i) (CongruenceKillingCertificate.N certificate))
every-recipe-has-failed-leg certificate i =
  congruence-killed→failed-leg
    (CongruenceKillingCertificate.kills certificate i)

EveryRecipePPFails :
  (theory : PrimePairTheory) {K : ℕ} {menu : RecipeMenu K} →
  CongruenceKillingCertificate menu → Type₀
EveryRecipePPFails theory {K} {menu} certificate =
  (i : Fin K) →
  ¬ PrimePairTheory.PP theory
      (left-leg (menu i) (CongruenceKillingCertificate.N certificate))
      (right-leg (menu i) (CongruenceKillingCertificate.N certificate))

recipe-certificate-no-go :
  (theory : PrimePairTheory) {K : ℕ} {menu : RecipeMenu K} →
  (certificate : CongruenceKillingCertificate menu) →
  EveryRecipePPFails theory certificate
recipe-certificate-no-go theory certificate i =
  failed-leg-refutes-PP theory
    (every-recipe-has-failed-leg certificate i)

record VerifiedRecipeMenu
  (theory : PrimePairTheory) {K : ℕ} (menu : RecipeMenu K) : Type₀ where
  constructor verified-recipe-menu
  field
    certificate : CongruenceKillingCertificate menu
    every-recipe-fails : EveryRecipePPFails theory certificate

record CoefficientCRTGenerationObligation
  {K : ℕ} (menu : RecipeMenu K) : Type₀ where
  constructor coefficient-CRT-generation-obligation
  field
    generated-certificate : CongruenceKillingCertificate menu

verify-recipe-generation :
  (theory : PrimePairTheory) {K : ℕ} (menu : RecipeMenu K) →
  CoefficientCRTGenerationObligation menu → VerifiedRecipeMenu theory menu
verify-recipe-generation theory menu obligation =
  verified-recipe-menu certificate
    (recipe-certificate-no-go theory certificate)
  where
  certificate =
    CoefficientCRTGenerationObligation.generated-certificate obligation

record CRTGenerationObligation
  (R L : ℕ) {K : ℕ} (menu : RecipeMenu K) : Type₀ where
  constructor crt-generation-obligation
  field
    desert : DesertCRTGenerationObligation R L
    coefficients-and-CRT : CoefficientCRTGenerationObligation menu

record VerifiedRadiusAndRecipeNoGo
  (theory : PrimePairTheory)
  (R L : ℕ) {K : ℕ} (menu : RecipeMenu K) : Type₀ where
  constructor verified-radius-and-recipe-no-go
  field
    desert : VerifiedDesert theory R L
    recipes : VerifiedRecipeMenu theory menu

verify-CRT-generation :
  (theory : PrimePairTheory)
  (R L : ℕ) {K : ℕ} (menu : RecipeMenu K) →
  CRTGenerationObligation R L menu →
  VerifiedRadiusAndRecipeNoGo theory R L menu
verify-CRT-generation theory R L menu obligation =
  verified-radius-and-recipe-no-go
    (verify-desert-generation theory R L
      (CRTGenerationObligation.desert obligation))
    (verify-recipe-generation theory menu
      (CRTGenerationObligation.coefficients-and-CRT obligation))
