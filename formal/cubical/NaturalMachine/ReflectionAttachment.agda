{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.ReflectionAttachment where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Bool using
  (Bool ; false ; true ; not ; false≢true)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.Pushout.Base

open import NaturalMachine.FiniteIndraWeave using (TotalView)
open import NaturalMachine.ProductiveIndraNet using (Net ; observe)

record Reflection (A : Type₀) : Type₀ where
  field
    reflect : A → A
    involutive : (x : A) → reflect (reflect x) ≡ x

open Reflection

ReflectionFiber : {A : Type₀} → Reflection A → A → Type₀
ReflectionFiber reflection x = reflect reflection x ≡ x

ReflectionTotal : {A : Type₀} → Reflection A → Type₀
ReflectionTotal {A} reflection = Σ A (ReflectionFiber reflection)

ReflectionSection : {A : Type₀} → Reflection A → Type₀
ReflectionSection {A} reflection = (x : A) → ReflectionFiber reflection x

section→total : {A : Type₀} (reflection : Reflection A)
  → ReflectionSection reflection → (x : A) → ReflectionTotal reflection
section→total reflection section x = x , section x

boolReflection : Reflection Bool
reflect boolReflection = not
involutive boolReflection false = refl
involutive boolReflection true = refl

noBoolReflectionTotal : ¬ ReflectionTotal boolReflection
noBoolReflectionTotal (false , fixed) = false≢true (sym fixed)
noBoolReflectionTotal (true , fixed) = false≢true fixed

noBoolReflectionSection : ¬ ReflectionSection boolReflection
noBoolReflectionSection section =
  noBoolReflectionTotal (section→total boolReflection section false)

------------------------------------------------------------------------
-- Attaching one apex along all of Bool identifies the reflected boundary.
-- A retraction would transport that identification back to false ≡ true.
------------------------------------------------------------------------

identityBoundary : Bool → Bool
identityBoundary point = point

collapseBoundary : Bool → Unit
collapseBoundary _ = tt

BoolAttachment : Type₀
BoolAttachment = Pushout identityBoundary collapseBoundary

boundary : Bool → BoolAttachment
boundary = inl

apex : BoolAttachment
apex = inr tt

boundary-collapses : boundary false ≡ boundary true
boundary-collapses = push false ∙ sym (push true)

BoundaryRetract : Type₀
BoundaryRetract =
  Σ[ retract ∈ (BoolAttachment → Bool) ]
    ((point : Bool) → retract (boundary point) ≡ point)

noBoundaryRetract : ¬ BoundaryRetract
noBoundaryRetract (retract , section) =
  false≢true
    (sym (section false)
      ∙ cong retract boundary-collapses
      ∙ section true)

------------------------------------------------------------------------
-- The absent filler is an executable productive branch.  Every second
-- finite observation exposes the tear; the intervening layer retains the
-- reflected boundary rather than collapsing it prematurely.
------------------------------------------------------------------------

data AttachmentJewel : Type₀ where
  reflected : Bool → AttachmentJewel
  missing-filler : AttachmentJewel

mutual
  missingNet : ¬ BoundaryRetract → Net Bool AttachmentJewel
  Net.view (missingNet obstruction) _ _ = missing-filler
  Net.next (missingNet obstruction) = reflectedNet obstruction

  reflectedNet : ¬ BoundaryRetract → Net Bool AttachmentJewel
  Net.view (reflectedNet obstruction) root _ = reflected root
  Net.next (reflectedNet obstruction) = missingNet obstruction

attachmentNet : Net Bool AttachmentJewel
attachmentNet = missingNet noBoundaryRetract

attachment-four : observe 4 attachmentNet ≡
  (λ _ _ → missing-filler) ∷
  (λ root _ → reflected root) ∷
  (λ _ _ → missing-filler) ∷
  (λ root _ → reflected root) ∷ []
attachment-four = refl

first-missing : Net.view attachmentNet false true ≡ missing-filler
first-missing = refl

next-retains-reflection :
  Net.view (Net.next attachmentNet) true false ≡ reflected true
next-retains-reflection = refl
