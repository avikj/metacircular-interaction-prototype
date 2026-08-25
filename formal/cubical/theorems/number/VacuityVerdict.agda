{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A scoped descent verdict carries the mathematics that justifies it.
--
-- The finite runtime used four strings: FORMS, GENUINE, VACUOUS, and
-- UNDECIDED-VACUOUS.  The distinction is not four labels.  It is the
-- difference between four types:
--
--   * a collision inside the declared scope;
--   * a factorization on the entire ambient carrier;
--   * a local factorization together with an ambient collision;
--   * a local factorization with no supplied global proof either way.
--
-- In particular, checking a larger finite sample never constructs
-- `GlobalFactorization`.  It remains `undecided` until an ambient theorem is
-- supplied.  This is the exact correction forced by VACUITY_CERTIFICATES.
------------------------------------------------------------------------

module VacuityVerdict where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    X Z Y : Type₀

-- A scope is proof-relevant.  Membership may carry the exact bound, shell,
-- experimental condition, or construction under which a state is admitted.
Scope : Type₀ → Type₁
Scope X = X → Type₀

record LocalCollision
    (S : Scope X) (q : X → Z) (f : X → Y) : Type₁ where
  field
    left right : X
    left-in     : S left
    right-in    : S right
    same-fiber  : q left ≡ q right
    separated   : ¬ (f left ≡ f right)

record AmbientCollision
    (S : Scope X) (q : X → Z) (f : X → Y) : Type₁ where
  field
    left right : X
    same-fiber  : q left ≡ q right
    separated   : ¬ (f left ≡ f right)
    outside     : ¬ (S left × S right)

-- Factorization is data, not a Boolean assertion of constancy.
record ScopedFactorization
    (S : Scope X) (q : X → Z) (f : X → Y) : Type₁ where
  field
    descend : Z → Y
    agrees  : (x : X) → S x → descend (q x) ≡ f x

record GlobalFactorization
    (q : X → Z) (f : X → Y) : Type₀ where
  field
    descend : Z → Y
    agrees  : (x : X) → descend (q x) ≡ f x

-- The constructors force every verdict to carry the relevant object.
data Verdict
    (S : Scope X) (q : X → Z) (f : X → Y) : Type₁ where
  forms     : LocalCollision S q f → Verdict S q f
  genuine   : GlobalFactorization q f → Verdict S q f
  vacuous   : ScopedFactorization S q f → AmbientCollision S q f
            → Verdict S q f
  undecided : ScopedFactorization S q f → Verdict S q f

------------------------------------------------------------------------
-- The witness constructors have their expected logical force.
------------------------------------------------------------------------

localCollision-refutes-scoped :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → LocalCollision S q f → ¬ (ScopedFactorization S q f)
localCollision-refutes-scoped S q f c fac =
  LocalCollision.separated c
    ( sym (ScopedFactorization.agrees fac
            (LocalCollision.left c) (LocalCollision.left-in c))
    ∙ cong (ScopedFactorization.descend fac)
        (LocalCollision.same-fiber c)
    ∙ ScopedFactorization.agrees fac
        (LocalCollision.right c) (LocalCollision.right-in c) )

ambientCollision-refutes-global :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → AmbientCollision S q f → ¬ (GlobalFactorization q f)
ambientCollision-refutes-global S q f c fac =
  AmbientCollision.separated c
    ( sym (GlobalFactorization.agrees fac (AmbientCollision.left c))
    ∙ cong (GlobalFactorization.descend fac)
        (AmbientCollision.same-fiber c)
    ∙ GlobalFactorization.agrees fac (AmbientCollision.right c) )

global→scoped :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → GlobalFactorization q f → ScopedFactorization S q f
ScopedFactorization.descend (global→scoped S q f fac) =
  GlobalFactorization.descend fac
ScopedFactorization.agrees (global→scoped S q f fac) x _ =
  GlobalFactorization.agrees fac x

-- Enlarging a scope can only strengthen local factorization evidence.
restrict-factorization :
    (S T : Scope X) (q : X → Z) (f : X → Y)
  → ((x : X) → S x → T x)
  → ScopedFactorization T q f → ScopedFactorization S q f
ScopedFactorization.descend (restrict-factorization S T q f inc fac) =
  ScopedFactorization.descend fac
ScopedFactorization.agrees (restrict-factorization S T q f inc fac) x sx =
  ScopedFactorization.agrees fac x (inc x sx)

------------------------------------------------------------------------
-- Finite controls.
--
-- On Bool, the constant carrier and identity observation factor on the
-- one-point scope {false}, but an ambient collision proves that this local
-- descent is vacuous.  Replacing identity by the constant observation gives
-- a genuine global factorization through the same carrier.
------------------------------------------------------------------------

OnlyFalse : Scope Bool
OnlyFalse false = Unit
OnlyFalse true  = ⊥

AllBool : Scope Bool
AllBool _ = Unit

constantCarrier : Bool → Unit
constantCarrier _ = tt

identityObservation : Bool → Bool
identityObservation b = b

constantObservation : Bool → Bool
constantObservation _ = false

localIdentity : ScopedFactorization OnlyFalse constantCarrier identityObservation
ScopedFactorization.descend localIdentity _ = false
ScopedFactorization.agrees localIdentity false _ = refl
ScopedFactorization.agrees localIdentity true  impossible = Empty.rec impossible

identityAmbientCollision :
  AmbientCollision OnlyFalse constantCarrier identityObservation
AmbientCollision.left identityAmbientCollision = false
AmbientCollision.right identityAmbientCollision = true
AmbientCollision.same-fiber identityAmbientCollision = refl
AmbientCollision.separated identityAmbientCollision = false≢true
AmbientCollision.outside identityAmbientCollision (_ , impossible) = impossible

identity-is-vacuous : Verdict OnlyFalse constantCarrier identityObservation
identity-is-vacuous = vacuous localIdentity identityAmbientCollision

identity-forms-globally :
  LocalCollision AllBool constantCarrier identityObservation
LocalCollision.left identity-forms-globally = false
LocalCollision.right identity-forms-globally = true
LocalCollision.left-in identity-forms-globally = tt
LocalCollision.right-in identity-forms-globally = tt
LocalCollision.same-fiber identity-forms-globally = refl
LocalCollision.separated identity-forms-globally = false≢true

constant-is-genuine :
  GlobalFactorization constantCarrier constantObservation
GlobalFactorization.descend constant-is-genuine _ = false
GlobalFactorization.agrees constant-is-genuine _ = refl

constant-verdict : Verdict OnlyFalse constantCarrier constantObservation
constant-verdict = genuine constant-is-genuine
