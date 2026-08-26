{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- QuotientUnitSourceCutBoundary
--
-- A reversible action on a predictive quotient and a reversible physical
-- implementation are different typed statements.  If q : X -> Q forgets
-- physical states and u : Q ≅ Q is the effective unit, then the physical-
-- source observed map u ∘ q has exactly the fibers of q, relabelled by u.
-- Its coherent side-memory therefore does not disappear.  Unit environment
-- is attained only after Q itself becomes the input source.
--
-- The concrete control is Apoha's minimal three-state reversal: a
-- nonidentity idempotent reset becomes identity after merging states 0 and 1
-- while retaining state 2.  The quotient identity needs Unit from quotient
-- input, but the physical-source observed map has a Bool fiber and Bool is
-- both necessary and sufficient as an exact certificate alphabet.
------------------------------------------------------------------------

module QuotientUnitSourceCutBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism
  using (Iso ; invIso ; isoToEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; true≢false ; isSetBool)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (isSet⊎)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Functions.Embedding
  using (isEmbedding ; _↪_ ; Equiv→Embedding ; compEmbedding)
open import Cubical.Relation.Nullary using (¬_)

import CertificateFibration as Cert
import FiniteInformation as FI

private
  variable
    ℓx ℓq ℓe : Level
    X : Type ℓx
    Q : Type ℓq

------------------------------------------------------------------------
-- 1. A quotient unit only relabels the physical-source fibers
------------------------------------------------------------------------

observed : (X → Q) → Iso Q Q → X → Q
observed q u x = Iso.fun u (q x)

postIsoFiber :
  (q : X → Q) (u : Iso Q Q) (isSetQ : isSet Q) (y : Q)
  → Iso (fiber (observed q u) y) (fiber q (Iso.inv u y))
Iso.fun (postIsoFiber q u isSetQ y) (x , p) =
  x , sym (Iso.leftInv u (q x)) ∙ cong (Iso.inv u) p
Iso.inv (postIsoFiber q u isSetQ y) (x , p) =
  x , cong (Iso.fun u) p ∙ Iso.rightInv u y
Iso.rightInv (postIsoFiber q u isSetQ y) _ =
  Σ≡Prop (λ _ → isSetQ _ _) refl
Iso.leftInv (postIsoFiber q u isSetQ y) _ =
  Σ≡Prop (λ _ → isSetQ _ _) refl

-- Every exact physical-source certificate contains the corresponding
-- original q-fiber.  Postcomposition by the unit cannot lower this bound.
physical-fiber-lower :
  {Environment : Type ℓe}
  (q : X → Q) (u : Iso Q Q) (isSetQ : isSet Q)
  (certificate : X → Environment)
  → isEmbedding (Cert.recorded (observed q u) certificate)
  → (y : Q) → fiber q (Iso.inv u y) ↪ Environment
physical-fiber-lower q u isSetQ certificate embedding y =
  compEmbedding
    (Cert.fiber↪cert (observed q u) certificate embedding y)
    (Equiv→Embedding
      (isoToEquiv (invIso (postIsoFiber q u isSetQ y))))

-- Once the quotient Q is itself the source, the same unit is an injective
-- basis permutation and a singleton certificate attains the exact boundary.
unitCertificate : {A : Type ℓq} → A → Unit
unitCertificate _ = tt

quotient-unit-completes :
  (u : Iso Q Q) → FI.Completes (Iso.fun u) unitCertificate
quotient-unit-completes u left right equality =
  sym (Iso.leftInv u left)
  ∙ cong (Iso.inv u) (cong fst equality)
  ∙ Iso.leftInv u right

quotient-unit-attains :
  (u : Iso Q Q) (isSetQ : isSet Q)
  → isEmbedding (Cert.recorded (Iso.fun u) unitCertificate)
quotient-unit-attains u isSetQ =
  Cert.Completes→isEmbedding (Iso.fun u) unitCertificate
    isSetQ isSetUnit (quotient-unit-completes u)

------------------------------------------------------------------------
-- 2. Apoha's minimal three-state reversal
------------------------------------------------------------------------

-- `inl false`, `inr tt`, `inl true` represent states 0, 1, 2.
Physical : Type₀
Physical = Bool ⊎ Unit

isSetPhysical : isSet Physical
isSetPhysical = isSet⊎ isSetBool isSetUnit

-- Forget 0 versus 1, but retain their distinction from 2.
quotient : Physical → Bool
quotient (inl bit) = bit
quotient (inr tt)  = false

-- Reset 1 to 0 while fixing 0 and 2.
physicalAction : Physical → Physical
physicalAction (inl bit) = inl bit
physicalAction (inr tt)  = inl false

physical-idempotent : (x : Physical)
  → physicalAction (physicalAction x) ≡ physicalAction x
physical-idempotent (inl _) = refl
physical-idempotent (inr tt) = refl

hiddenTag : Physical → Bool
hiddenTag (inl _)  = false
hiddenTag (inr tt) = true

physical-nonidentity : ¬ (physicalAction (inr tt) ≡ inr tt)
physical-nonidentity equality =
  false≢true (cong hiddenTag equality)

physical-not-injective :
  ¬ ((left right : Physical)
      → physicalAction left ≡ physicalAction right → left ≡ right)
physical-not-injective injective =
  false≢true
    (cong hiddenTag (injective (inl false) (inr tt) refl))

-- The induced quotient action is exactly identity.
action-descends-to-identity : (x : Physical)
  → quotient (physicalAction x) ≡ quotient x
action-descends-to-identity (inl _) = refl
action-descends-to-identity (inr tt) = refl

identityIso : Iso Bool Bool
Iso.fun      identityIso bit = bit
Iso.inv      identityIso bit = bit
Iso.rightInv identityIso _ = refl
Iso.leftInv  identityIso _ = refl

effective-unit-attains :
  isEmbedding (Cert.recorded (Iso.fun identityIso) unitCertificate)
effective-unit-attains = quotient-unit-attains identityIso isSetBool

------------------------------------------------------------------------
-- 3. The physical source still pays exactly Bool
------------------------------------------------------------------------

-- This is the observable process from the original source.  It is q after
-- the reset, extensionally equal to q by `action-descends-to-identity`.
physicalObserved : Physical → Bool
physicalObserved x = quotient (physicalAction x)

falsePhysicalFiberIso : Iso (fiber physicalObserved false) Bool
Iso.fun falsePhysicalFiberIso (inl false , _) = false
Iso.fun falsePhysicalFiberIso (inl true  , p) =
  Empty.rec (true≢false p)
Iso.fun falsePhysicalFiberIso (inr tt , _) = true
Iso.inv falsePhysicalFiberIso false = inl false , refl
Iso.inv falsePhysicalFiberIso true  = inr tt , refl
Iso.rightInv falsePhysicalFiberIso false = refl
Iso.rightInv falsePhysicalFiberIso true  = refl
Iso.leftInv falsePhysicalFiberIso (inl false , _) =
  Σ≡Prop (λ _ → isSetBool _ _) refl
Iso.leftInv falsePhysicalFiberIso (inl true , p) =
  Empty.rec (true≢false p)
Iso.leftInv falsePhysicalFiberIso (inr tt , _) =
  Σ≡Prop (λ _ → isSetBool _ _) refl

-- Every exact environment for physical-source observation contains Bool.
physical-environment-lower : {Environment : Type ℓe}
  (certificate : Physical → Environment)
  → isEmbedding (Cert.recorded physicalObserved certificate)
  → Bool ↪ Environment
physical-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert physicalObserved certificate embedding false)
    (Equiv→Embedding (isoToEquiv (invIso falsePhysicalFiberIso)))

-- One bit records precisely which member of the merged fiber was present.
physicalCertificate : Physical → Bool
physicalCertificate (inl _)  = false
physicalCertificate (inr tt) = true

physical-completes : FI.Completes physicalObserved physicalCertificate
physical-completes (inl false) (inl false) _ = refl
physical-completes (inl false) (inl true) equality =
  Empty.rec (false≢true (cong fst equality))
physical-completes (inl false) (inr tt) equality =
  Empty.rec (false≢true (cong snd equality))
physical-completes (inl true) (inl false) equality =
  Empty.rec (true≢false (cong fst equality))
physical-completes (inl true) (inl true) _ = refl
physical-completes (inl true) (inr tt) equality =
  Empty.rec (true≢false (cong fst equality))
physical-completes (inr tt) (inl false) equality =
  Empty.rec (true≢false (cong snd equality))
physical-completes (inr tt) (inl true) equality =
  Empty.rec (false≢true (cong fst equality))
physical-completes (inr tt) (inr tt) _ = refl

physical-environment-attains :
  isEmbedding (Cert.recorded physicalObserved physicalCertificate)
physical-environment-attains =
  Cert.Completes→isEmbedding physicalObserved physicalCertificate
    isSetBool isSetBool physical-completes

-- Decisive source-cut separation:
--   quotient source: Unit certificate;
--   physical source: Bool embeds in every certificate, and Bool attains.
-- The action became a unit only after the source type changed.
