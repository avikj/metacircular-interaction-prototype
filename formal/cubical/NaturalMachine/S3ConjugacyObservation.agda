{-# OPTIONS --cubical --safe #-}

-- A nonconstant gauge-invariant loop observation for the finite S₃ model:
-- the type of fixed vertices.  Conjugation preserves it by an explicit
-- equivalence, and univalence turns that equivalence into equality of
-- observations.  This is a finite-group calibration, not a Wilson trace.

module NaturalMachine.S3ConjugacyObservation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; retEq ; secEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (Σ≡Prop)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)
import Cubical.Data.Sum.Properties as Sum
import Cubical.Data.Prod as P

open import NaturalMachine.FiniteNonabelianHolonomy
open import NaturalMachine.RelationalHolonomyRefinement
  using (closedLoopGaugeInvariant ; endpointGauge)

Fixed : ⟨ S₃ ⟩ → Type₀
Fixed g = Σ[ x ∈ Fin3 ] g .fst x ≡ x

fixedConjugateIso : (h g : ⟨ S₃ ⟩)
  → Iso (Fixed ((h S.· g) S.· S.inv h)) (Fixed g)
Iso.fun (fixedConjugateIso h g) (x , p) = (invEquiv h) .fst x , fixed
  where
  fixed : g .fst ((invEquiv h) .fst x) ≡ (invEquiv h) .fst x
  fixed = sym (secEq h (g .fst ((invEquiv h) .fst x)))
    ∙ cong ((invEquiv h) .fst) p
Iso.inv (fixedConjugateIso h g) (y , q) = h .fst y , fixed
  where
  fixed : ((h S.· g) S.· S.inv h) .fst (h .fst y) ≡ h .fst y
  fixed = cong (h .fst) (cong (g .fst) (secEq h y) ∙ q)
Iso.rightInv (fixedConjugateIso h g) (y , q) =
  Σ≡Prop (λ _ → S.is-set _ _) (retEq h y)
Iso.leftInv (fixedConjugateIso h g) (x , p) =
  Σ≡Prop (λ _ → S.is-set _ _) (secEq h x)

fixedConjugateEquiv : (h g : ⟨ S₃ ⟩)
  → Fixed ((h S.· g) S.· S.inv h) ≃ Fixed g
fixedConjugateEquiv h g = isoToEquiv (fixedConjugateIso h g)

fixedProfile : ⟨ S₃ ⟩ → Type₀
fixedProfile = Fixed

fixedProfile-conjugation : (h g : ⟨ S₃ ⟩)
  → fixedProfile ((h S.· g) S.· S.inv h) ≡ fixedProfile g
fixedProfile-conjugation h g = ua (fixedConjugateEquiv h g)

fixedProfile-gauge : (h g : ⟨ S₃ ⟩)
  → fixedProfile (endpointGauge S₃ (P._,_ h h) g)
    ≡ fixedProfile g
fixedProfile-gauge =
  closedLoopGaugeInvariant S₃ fixedProfile fixedProfile-conjugation

-- A concrete three-cycle.
cycle₀₁₂ : ⟨ S₃ ⟩
cycle₀₁₂ = s₀₁ S.· s₁₂

-- Sum no-confusion helpers used by the finite separation proofs.
outerInject : {x y : Fin 2} → fsuc x ≡ fsuc y → x ≡ y
outerInject {x} {y} p = lower (Sum.⊎Path.encode (fsuc x) (fsuc y) p)

zeroNotSucc : {x : Fin 2} → fzero ≡ fsuc x → ⊥
zeroNotSucc {x} p = lower (Sum.⊎Path.encode fzero (fsuc x) p)

succNotZero : {x : Fin 2} → fsuc x ≡ fzero → ⊥
succNotZero {x} p = lower (Sum.⊎Path.encode (fsuc x) fzero p)

cycle-no-fixed : Fixed cycle₀₁₂ → ⊥
cycle-no-fixed (fzero , p) = succNotZero (outerInject p)
cycle-no-fixed (fsuc fzero , p) = succNotZero p
cycle-no-fixed (fsuc (fsuc fzero) , p) = zeroNotSucc (outerInject p)

swap-fixed : Fixed s₀₁
swap-fixed = fsuc (fsuc fzero) , refl

identity-fixed : Fixed S.1g
identity-fixed = fzero , refl

-- Identity, transposition and three-cycle profiles are not collapsed together.
identity-not-cycle : fixedProfile S.1g ≡ fixedProfile cycle₀₁₂ → ⊥
identity-not-cycle p = cycle-no-fixed (subst (λ X → X) p identity-fixed)

swap-not-cycle : fixedProfile s₀₁ ≡ fixedProfile cycle₀₁₂ → ⊥
swap-not-cycle p = cycle-no-fixed (subst (λ X → X) p swap-fixed)
