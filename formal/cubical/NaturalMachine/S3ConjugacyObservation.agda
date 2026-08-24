-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

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
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc ; isSetFin)
import Cubical.Data.Sum.Properties as Sum
import Cubical.Data.Prod as P

open import NaturalMachine.FiniteNonabelianHolonomy
open import NaturalMachine.FiniteGraphCylindricalEquivalence
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

coarseLoopProfile : CoarseNetwork S₃ → Type₀
coarseLoopProfile x = fixedProfile (P.proj₂ (P.proj₂ x))

refinedLoopProfile : RefinedNetwork S₃ → Type₀
refinedLoopProfile x = coarseLoopProfile (collapseNetwork S₃ x)

-- The loop coordinate is untouched by stem subdivision, and this remains true
-- when refinement is crossed as the actual univalent network path.
fixedProfile-refinement : (x : RefinedNetwork S₃)
  → coarseLoopProfile
      (subst (λ X → X) (networkCylindricalPath S₃) (networkClass S₃ x))
    ≡ refinedLoopProfile x
fixedProfile-refinement x =
  cong coarseLoopProfile (networkCylindricalTransport S₃ x)

-- A concrete three-cycle.
cycle₀₁₂ : ⟨ S₃ ⟩
cycle₀₁₂ = s₀₁ S.· s₁₂

-- Sum no-confusion helpers used by the finite separation proofs.
raise2 : Fin 2 → Fin 3
raise2 x = fsuc x

raise1 : Fin 1 → Fin 2
raise1 x = fsuc x

zero3 : Fin 3
zero3 = fzero

zero2 : Fin 2
zero2 = fzero

outerInject3 : {x y : Fin 2} → raise2 x ≡ raise2 y → x ≡ y
outerInject3 {x = x} {y = y} p =
  lower (Sum.⊎Path.encode (raise2 x) (raise2 y) p)

zeroNotSucc3 : {x : Fin 2} → zero3 ≡ raise2 x → ⊥
zeroNotSucc3 {x = x} p = lower (Sum.⊎Path.encode zero3 (raise2 x) p)

succNotZero3 : {x : Fin 2} → raise2 x ≡ zero3 → ⊥
succNotZero3 {x = x} p = lower (Sum.⊎Path.encode (raise2 x) zero3 p)

zeroNotSucc2 : {x : Fin 1} → zero2 ≡ raise1 x → ⊥
zeroNotSucc2 {x = x} p = lower (Sum.⊎Path.encode zero2 (raise1 x) p)

succNotZero2 : {x : Fin 1} → raise1 x ≡ zero2 → ⊥
succNotZero2 {x = x} p = lower (Sum.⊎Path.encode (raise1 x) zero2 p)

cycle-no-fixed : Fixed cycle₀₁₂ → ⊥
cycle-no-fixed (fzero , p) = succNotZero3 p
cycle-no-fixed (fsuc fzero , p) = zeroNotSucc3 p
cycle-no-fixed (fsuc (fsuc fzero) , p) = zeroNotSucc2 (outerInject3 p)

swap-fixed : Fixed s₀₁
swap-fixed = fsuc (fsuc fzero) , refl

identity-fixed : Fixed S.1g
identity-fixed = fzero , refl

identity-fixed-one : Fixed S.1g
identity-fixed-one = fsuc fzero , refl

swap-fixed-contractible : isContr (Fixed s₀₁)
fst swap-fixed-contractible = swap-fixed
snd swap-fixed-contractible (fzero , p) = Empty.rec (succNotZero3 p)
snd swap-fixed-contractible (fsuc fzero , p) = Empty.rec (zeroNotSucc3 p)
snd swap-fixed-contractible (fsuc (fsuc fzero) , p) =
  Σ≡Prop (λ _ → isSetFin _ _) refl

identity-fixed-distinct : identity-fixed ≡ identity-fixed-one → ⊥
identity-fixed-distinct p = zeroNotSucc3 (cong fst p)

-- Identity, transposition and three-cycle profiles are not collapsed together.
identity-not-cycle : fixedProfile S.1g ≡ fixedProfile cycle₀₁₂ → ⊥
identity-not-cycle p = cycle-no-fixed (subst (λ X → X) p identity-fixed)

swap-not-cycle : fixedProfile s₀₁ ≡ fixedProfile cycle₀₁₂ → ⊥
swap-not-cycle p = cycle-no-fixed (subst (λ X → X) p swap-fixed)

identity-not-swap : fixedProfile S.1g ≡ fixedProfile s₀₁ → ⊥
identity-not-swap p = identity-fixed-distinct
  ((subst (λ X → isProp X) (sym p)
    (isContr→isProp swap-fixed-contractible)) identity-fixed identity-fixed-one)
