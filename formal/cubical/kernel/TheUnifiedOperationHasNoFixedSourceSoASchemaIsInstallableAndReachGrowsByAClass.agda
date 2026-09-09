{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheUnifiedOperationHasNoFixedSourceSoASchemaIsInstallableAndReachGrowsByAClass
--
-- WHAT WAS OPEN, and it was one record.
--
-- `Siddhasadhana_` proves `install-chain-plateau`: extending the library
-- with a derivation from a context it can already reach leaves reach
-- invariant, after any number of steps.  Its own frontier section states
-- what escapes and why the escape was unavailable:
--
--     "What escapes the plateau on the kernel side is SchematicOperation --
--      no-native-operation-does-this shows one schema fires where no
--      NativeOperation can -- but a schema is not a NativeOperation and
--      cannot be installed, so the escape is not yet a step of any chain.
--      Adesa_ supplies the certificate a schema would need; THE RECORD
--      CHANGE DOES NOT EXIST."
--
-- This file is that record change.  Nothing here is a new mathematical
-- idea; every component was already checked.  What was missing was the
-- type that lets them compose.
--
-- WHY THE OLD RECORD COULD NOT GENERALISE, exactly.  `NativeOperation`
-- carries FIXED fields `source target : Tm` and
--
--     control-sound : {t : Tm} → Control t → t ≡ source
--
-- so `eka-adhikarana` follows in one line for ANY control whatsoever:
-- two loci s, t give `s ≡ source ≡ t`.  The restriction is not a property
-- of `install`'s default control.  It is forced by the presence of a fixed
-- `source`, and no choice of `Control` can evade it.
--
-- THE CHANGE.  Drop `source`, `target` and `control-sound`.  Keep the
-- obligation they existed to discharge, stated where it is actually used:
--
--     Control : Tm → Type₀
--     apply   : (t : Tm) → Control t → Tm
--     certify : (t : Tm) (c : Control t) → Derivation t (apply t c)
--
-- `certify` is exactly what `apply-checked` computed for the old record --
-- a derivation from the firing site to the emitted term -- now a field
-- rather than a derived value.  THE SOUNDNESS SURFACE DOES NOT GROW: it was
-- already the case that every firing had to arrive carrying a derivation
-- about that firing, and it still is.  What is dropped is only the demand
-- that all firings share one source.
--
-- WHAT IS PROVED
--   §2  ground   -- `install` recovered.  The old NativeOperation is the
--                   instance with Control t = (t ≡ lhs); nothing is lost.
--   §3  schema   -- installable, with a REAL DERIVATION at every instance,
--                   by `Adesa_.subDeriv`.  This is the step that did not
--                   exist: previously a schema carried only a `meaning`
--                   (an eval-equality) and so could not be an operation of
--                   a calculus whose operations carry derivations.
--   §4  sound    -- soundness is free for every Operation, ground or
--                   schematic, by `derivation-sound ∘ certify`.  No new
--                   proof obligation appears anywhere.
--   §5  two-loci -- one schema fires at two provably distinct terms.
--   §6  ground-has-one-locus -- and no ground operation does, by the old
--                   one-line argument, which still applies to `ground`
--                   because `ground` reintroduces a fixed source locally.
--
-- SYAT -- THE CLAIM, EXACTLY.  §§2-6 are checked.  What they establish is
-- that the escape named by `Siddhasadhana_` is now a step an operation can
-- take: a schema is installable, carries a certificate, and reaches a class.
-- NOT CLAIMED: the anti-plateau theorem itself.  `install-chain-plateau` is
-- stated for `InstallChain`, whose step is `install`; restating it over
-- `Operation` and proving that a schematic step STRICTLY grows reach is the
-- next obligation and is not discharged here.  §5 supplies the separation
-- that theorem would consume, and nothing more.
------------------------------------------------------------------------

module TheUnifiedOperationHasNoFixedSourceSoASchemaIsInstallableAndReachGrowsByAClass where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; _×_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import RewriteCertificate
  using (Tm ; var ; zero ; suc ; add ; Derivation ; subVar
        ; Env ; eval ; derivation-sound)
open import Kernel.Adesa_SubstitutionIsAdmissibleOnDerivationsSoASchemaCanCarryACertificateAndNotOnlyAMeaning
  using (subDeriv)

------------------------------------------------------------------------
-- §1  THE UNIFIED RECORD.  No fixed source; the certificate is the field.
------------------------------------------------------------------------

record Operation : Type₁ where
  field
    Control : Tm → Type₀
    apply   : (t : Tm) → Control t → Tm
    certify : (t : Tm) (c : Control t) → Derivation t (apply t c)

open Operation

------------------------------------------------------------------------
-- §2  GROUND.  `install` recovered: the old record, with nothing lost.
------------------------------------------------------------------------

ground : {lhs rhs : Tm} → Derivation lhs rhs → Operation
Control (ground {lhs} d) t   = t ≡ lhs
apply   (ground {rhs = rhs} d) _ _ = rhs
certify (ground {lhs} {rhs} d) t c =
  subst (λ q → Derivation q rhs) (sym c) d

------------------------------------------------------------------------
-- §3  SCHEMA.  Installable, and certified at EVERY instance.
--
-- The control carries the substitution witness; `apply` consumes it; and
-- `certify` is `subDeriv` transported to the firing site.  A schema is now
-- an operation of the same calculus, not a second kind of object.
------------------------------------------------------------------------

schema : {lhs rhs : Tm} → Derivation lhs rhs → Operation
Control (schema {lhs} d) t = Σ[ u ∈ Tm ] (t ≡ subVar u lhs)
apply   (schema {rhs = rhs} d) _ (u , _) = subVar u rhs
certify (schema {lhs} {rhs} d) t (u , p) =
  subst (λ q → Derivation q (subVar u rhs)) (sym p) (subDeriv u d)

------------------------------------------------------------------------
-- §4  SOUNDNESS IS FREE, for every Operation whatsoever.
--
-- No case split on ground/schema, no new obligation: the certificate IS a
-- derivation, and derivations preserve meaning at every environment.
------------------------------------------------------------------------

sound : (op : Operation) (t : Tm) (c : Control op t) (ρ : Env)
      → eval t ρ ≡ eval (apply op t c) ρ
sound op t c ρ = derivation-sound (certify op t c) ρ

------------------------------------------------------------------------
-- §5  ONE SCHEMA, TWO LOCI.
------------------------------------------------------------------------

plusOne : Derivation (add var (suc zero)) (suc var)
plusOne = RC.then-step (RC.add-suc var zero)
            (RC.then-step (RC.suc-step (RC.add-zero var)) (RC.done (suc var)))
  where import RewriteCertificate as RC

ctx0 ctx1 : Tm
ctx0 = add zero (suc zero)
ctx1 = add (suc zero) (suc zero)

ctx0-fires : Control (schema plusOne) ctx0
ctx0-fires = zero , refl

ctx1-fires : Control (schema plusOne) ctx1
ctx1-fires = suc zero , refl

leftIsZero : Tm → Bool
leftIsZero (add zero _) = true
leftIsZero _            = false

ctx0≢ctx1 : ¬ (ctx0 ≡ ctx1)
ctx0≢ctx1 p = true≢false (cong leftIsZero p)

two-loci : Σ[ s ∈ Tm ] Σ[ t ∈ Tm ]
             ((Control (schema plusOne) s) × (Control (schema plusOne) t) × (¬ (s ≡ t)))
two-loci = ctx0 , ctx1 , ctx0-fires , ctx1-fires , ctx0≢ctx1

------------------------------------------------------------------------
-- §6  AND NO GROUND OPERATION DOES.
--
-- The old one-line argument, which survives for `ground` precisely because
-- `ground` puts the fixed source back.  This is the separation: the two
-- constructors of ONE record differ in reach, and the difference is exactly
-- whether the control carries a witness `apply` consumes.
------------------------------------------------------------------------

ground-has-one-locus :
  {lhs rhs : Tm} (d : Derivation lhs rhs) (s t : Tm)
  → Control (ground d) s → Control (ground d) t → s ≡ t
ground-has-one-locus d s t cs ct = cs ∙ sym ct

no-ground-operation-does-this :
  {lhs rhs : Tm} (d : Derivation lhs rhs)
  → Control (ground d) ctx0 → Control (ground d) ctx1 → ⊥
no-ground-operation-does-this d c0 c1 =
  ctx0≢ctx1 (ground-has-one-locus d ctx0 ctx1 c0 c1)
