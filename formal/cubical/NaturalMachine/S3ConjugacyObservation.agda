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
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc ; isSetFin)
import Cubical.Data.Sum.Properties as Sum
import Cubical.Data.Prod as P

open import NaturalMachine.FiniteNonabelianHolonomy
open import NaturalMachine.RelationalHolonomyRefinement
  using (closedLoopGaugeInvariant ; endpointGauge)

Fixed : ⟨ S₃ ⟩ → Type₀
Fixed g = Σ[ x ∈ Fin3 ] g .fst x ≡ x

mulApply : (a b : ⟨ S₃ ⟩) (x : Fin3)
  → (a S.· b) .fst x ≡ b .fst (a .fst x)
mulApply a b x = refl

conjApply : (h g : ⟨ S₃ ⟩) (x : Fin3)
  → ((h S.· g) S.· S.inv h) .fst x
    ≡ (S.inv h) .fst (g .fst (h .fst x))
conjApply h g x =
  mulApply (h S.· g) (S.inv h) x
  ∙ cong ((S.inv h) .fst) (mulApply h g x)

fixedConjugateIso : (h g : ⟨ S₃ ⟩)
  → Iso (Fixed ((h S.· g) S.· S.inv h)) (Fixed g)
Iso.fun (fixedConjugateIso h g) (x , p) = h .fst x , fixed
  where
  cancel : (z : Fin3) → h .fst ((S.inv h) .fst z) ≡ z
  cancel z = cong (λ e → e .fst z) (S.·InvL h)

  fixed : g .fst (h .fst x) ≡ h .fst x
  fixed = sym (cancel (g .fst (h .fst x))) ∙ cong (h .fst) p
Iso.inv (fixedConjugateIso h g) (y , q) = (S.inv h) .fst y , fixed
  where
  cancel : (z : Fin3) → h .fst ((S.inv h) .fst z) ≡ z
  cancel z = cong (λ e → e .fst z) (S.·InvL h)

  fixed : ((h S.· g) S.· S.inv h) .fst ((S.inv h) .fst y)
    ≡ (S.inv h) .fst y
  fixed = conjApply h g ((S.inv h) .fst y)
    ∙ cong ((S.inv h) .fst) (cong (g .fst) (cancel y) ∙ q)
Iso.rightInv (fixedConjugateIso h g) (y , q) =
  Σ≡Prop (λ _ → isSetFin _ _)
    (cong (λ e → e .fst y) (S.·InvL h))
Iso.leftInv (fixedConjugateIso h g) (x , p) =
  Σ≡Prop (λ _ → isSetFin _ _)
    (cong (λ e → e .fst x) (S.·InvR h))

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
outerInject3 : {x y : Fin 2} → fsuc x ≡ fsuc y → x ≡ y
outerInject3 {x = x} {y = y} p =
  lower (Sum.⊎Path.encode (fsuc x) (fsuc y) p)

zeroNotSucc3 : {x : Fin 2} → fzero ≡ fsuc x → ⊥
zeroNotSucc3 {x = x} p = lower (Sum.⊎Path.encode fzero (fsuc x) p)

succNotZero3 : {x : Fin 2} → fsuc x ≡ fzero → ⊥
succNotZero3 {x = x} p = lower (Sum.⊎Path.encode (fsuc x) fzero p)

zeroNotSucc2 : {x : Fin 1} → fzero ≡ fsuc x → ⊥
zeroNotSucc2 {x = x} p = lower (Sum.⊎Path.encode fzero (fsuc x) p)

cycle-no-fixed : Fixed cycle₀₁₂ → ⊥
cycle-no-fixed (fzero , p) = succNotZero3 p
cycle-no-fixed (fsuc fzero , p) = zeroNotSucc3 p
cycle-no-fixed (fsuc (fsuc fzero) , p) = zeroNotSucc2 (outerInject3 p)

swap-fixed : Fixed s₀₁
swap-fixed = fsuc (fsuc fzero) , refl

identity-fixed : Fixed S.1g
identity-fixed = fzero , refl

-- Identity, transposition and three-cycle profiles are not collapsed together.
identity-not-cycle : fixedProfile S.1g ≡ fixedProfile cycle₀₁₂ → ⊥
identity-not-cycle p = cycle-no-fixed (subst (λ X → X) p identity-fixed)

swap-not-cycle : fixedProfile s₀₁ ≡ fixedProfile cycle₀₁₂ → ⊥
swap-not-cycle p = cycle-no-fixed (subst (λ X → X) p swap-fixed)
