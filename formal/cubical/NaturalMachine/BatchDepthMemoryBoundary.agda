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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.BatchDepthMemoryBoundary
--
-- A two-point encounter can raise both the least sufficient chart depth and
-- the exact environment alphabet required by coherent overwrite.  This is
-- impossible for refinement on one fixed source.  The distinction is source
-- growth, not a failure of the fibre theorem.
--
-- The finite incidence pattern is the p = 3 witness from
-- DEPTH_MEMORY_LAW:
--
--   old world: two valuation-one points, constant chart, fibre size 2;
--   new world: three valuation-one points in residue 0 and one
--              valuation-zero point in residue 1, fibre sizes 3 and 1.
--
-- `CertificateFibration` turns those fibres into exact coherent-environment
-- requirements.  Lower bounds are embeddings of Bool and Fin 3 into every
-- valid certificate alphabet; matching certificates attain both bounds.
-- On the fixed four-point source the coarse constant chart instead requires
-- the entire four-point source, so refinement moves 4 -> 3, never upward.
------------------------------------------------------------------------

module NaturalMachine.BatchDepthMemoryBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism
  using (Iso ; invIso ; isoToEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; true≢false ; isSetBool)
open import Cubical.Data.Fin using (Fin ; fzero ; fsuc ; isSetFin)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (isSet⊎)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Functions.Embedding
  using (isEmbedding ; _↪_ ; Equiv→Embedding ; compEmbedding)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.CertificateFibration as Cert
import NaturalMachine.FiniteInformation as FI

------------------------------------------------------------------------
-- 1. The old and encountered worlds
------------------------------------------------------------------------

Old : Type₀
Old = Bool

Three : Type₀
Three = Fin 3

-- `inl` is the residue-zero fibre; `inr tt` is the exceptional residue.
New : Type₀
New = Three ⊎ Unit

oldChart : Old → Unit
oldChart _ = tt

oldValue : Old → Bool
oldValue _ = false

newChart₀ : New → Unit
newChart₀ _ = tt

newChart₁ : New → Bool
newChart₁ (inl _)  = false
newChart₁ (inr tt) = true

newValue : New → Bool
newValue = newChart₁

-- The two old points sit in the three-point refined fibre.  The remaining
-- `Fin 3` point and `inr tt` are exactly the two-point batch.
includeOld : Old → New
includeOld false = inl fzero
includeOld true  = inl (fsuc fzero)

old-value-is-restriction : (x : Old) → newValue (includeOld x) ≡ oldValue x
old-value-is-restriction false = refl
old-value-is-restriction true  = refl

------------------------------------------------------------------------
-- 2. Least sufficient depth rises from zero to one
------------------------------------------------------------------------

Sufficient : {X Y V : Type₀} → (X → Y) → (X → V) → Type₀
Sufficient {X = X} {Y = Y} {V = V} chart value =
  Σ[ decode ∈ (Y → V) ] ((x : X) → decode (chart x) ≡ value x)

old-depth-zero-sufficient : Sufficient oldChart oldValue
old-depth-zero-sufficient = ((λ _ → false) , (λ _ → refl))

new-depth-zero-insufficient : ¬ Sufficient newChart₀ newValue
new-depth-zero-insufficient (decode , replay) =
  false≢true
    (sym (replay (inl fzero)) ∙ replay (inr tt))

new-depth-one-sufficient : Sufficient newChart₁ newValue
new-depth-one-sufficient = ((λ b → b) , (λ _ → refl))

------------------------------------------------------------------------
-- 3. Exact old environment: Bool is necessary and sufficient
------------------------------------------------------------------------

oldFiberIso : Iso (fiber oldChart tt) Bool
Iso.fun      oldFiberIso (x , _)    = x
Iso.inv      oldFiberIso x          = x , refl
Iso.rightInv oldFiberIso _          = refl
Iso.leftInv  oldFiberIso (x , _) =
  Σ≡Prop (λ _ → isSetUnit _ _) refl

old-environment-lower : {Environment : Type₀}
  (certificate : Old → Environment)
  → isEmbedding (Cert.recorded oldChart certificate)
  → Bool ↪ Environment
old-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert oldChart certificate embedding tt)
    (Equiv→Embedding (isoToEquiv (invIso oldFiberIso)))

oldCertificate : Old → Bool
oldCertificate x = x

old-completes : FI.Completes oldChart oldCertificate
old-completes _ _ equality = cong snd equality

old-environment-attains :
  isEmbedding (Cert.recorded oldChart oldCertificate)
old-environment-attains =
  Cert.Completes→isEmbedding oldChart oldCertificate
    isSetUnit isSetBool old-completes

------------------------------------------------------------------------
-- 4. Exact new environment: Fin 3 is necessary and sufficient
------------------------------------------------------------------------

newFiberIso : Iso (fiber newChart₁ false) Three
Iso.fun      newFiberIso (inl e , _)  = e
Iso.fun      newFiberIso (inr tt , p) = Empty.rec (true≢false p)
Iso.inv      newFiberIso e            = inl e , refl
Iso.rightInv newFiberIso _            = refl
Iso.leftInv  newFiberIso (inl e , _) =
  Σ≡Prop (λ _ → isSetBool _ _) refl
Iso.leftInv  newFiberIso (inr tt , p)   = Empty.rec (true≢false p)

new-environment-lower : {Environment : Type₀}
  (certificate : New → Environment)
  → isEmbedding (Cert.recorded newChart₁ certificate)
  → Three ↪ Environment
new-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert newChart₁ certificate embedding false)
    (Equiv→Embedding (isoToEquiv (invIso newFiberIso)))

newCertificate : New → Three
newCertificate (inl e)  = e
newCertificate (inr tt) = fzero

new-completes : FI.Completes newChart₁ newCertificate
new-completes (inl e) (inl e') equality = cong inl (cong snd equality)
new-completes (inl e) (inr tt) equality =
  Empty.rec (false≢true (cong fst equality))
new-completes (inr tt) (inl e) equality =
  Empty.rec (true≢false (cong fst equality))
new-completes (inr tt) (inr tt) _ = refl

new-environment-attains :
  isEmbedding (Cert.recorded newChart₁ newCertificate)
new-environment-attains =
  Cert.Completes→isEmbedding newChart₁ newCertificate
    isSetBool isSetFin new-completes

------------------------------------------------------------------------
-- 5. Hostile control: refinement on the fixed new source lowers 4 -> 3
------------------------------------------------------------------------

isSetNew : isSet New
isSetNew = isSet⊎ isSetFin isSetUnit

coarseFiberIso : Iso (fiber newChart₀ tt) New
Iso.fun      coarseFiberIso (x , _)    = x
Iso.inv      coarseFiberIso x          = x , refl
Iso.rightInv coarseFiberIso _          = refl
Iso.leftInv  coarseFiberIso (x , _) =
  Σ≡Prop (λ _ → isSetUnit _ _) refl

coarse-environment-lower : {Environment : Type₀}
  (certificate : New → Environment)
  → isEmbedding (Cert.recorded newChart₀ certificate)
  → New ↪ Environment
coarse-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert newChart₀ certificate embedding tt)
    (Equiv→Embedding (isoToEquiv (invIso coarseFiberIso)))

coarseCertificate : New → New
coarseCertificate x = x

coarse-completes : FI.Completes newChart₀ coarseCertificate
coarse-completes _ _ equality = cong snd equality

coarse-environment-attains :
  isEmbedding (Cert.recorded newChart₀ coarseCertificate)
coarse-environment-attains =
  Cert.Completes→isEmbedding newChart₀ coarseCertificate
    isSetUnit isSetNew coarse-completes

-- The old-to-new transition raises 2 -> 3 because the source grows.  On the
-- same four-point source, refining the constant chart to `newChart₁` instead
-- lowers the exact requirement 4 -> 3.  Both facts are certified above by
-- matching lower embeddings and attaining certificate maps.
