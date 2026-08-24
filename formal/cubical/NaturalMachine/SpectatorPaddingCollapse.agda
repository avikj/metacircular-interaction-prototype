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

-- A two-arity algebraic seam from TOKEN_PHILOSOPHY: commutative parallel
-- composition at binary arity makes unary order disappear after padding.
-- This is deliberately not a construction of a free commutative monoidal
-- category or of a trace-monoid normal form.

module NaturalMachine.SpectatorPaddingCollapse where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true ; not ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓu ℓb : Level

record TwoLevelCollective (ℓu ℓb : Level) :
    Type (ℓ-suc (ℓ-max ℓu ℓb)) where
  field
    Unary  : Type ℓu
    Binary : Type ℓb

    idU     : Unary
    _thenU_ : Unary → Unary → Unary
    _thenB_ : Binary → Binary → Binary
    _tensor_ : Unary → Unary → Binary

    unary-id-left  : (u : Unary) → idU thenU u ≡ u
    unary-id-right : (u : Unary) → u thenU idU ≡ u

    interchange : (u v x y : Unary)
      → (u thenU v) tensor (x thenU y)
      ≡ (u tensor x) thenB (v tensor y)

    tensor-commutative : (u v : Unary) → u tensor v ≡ v tensor u

module _ (S : TwoLevelCollective ℓu ℓb) where
  open TwoLevelCollective S

  -- Add one idle unary component and read the result at binary arity.
  padding : Unary → Binary
  padding u = u tensor idU

  -- Interchange moves the second unary step onto the idle component.  The
  -- only commutation used is at binary arity.
  padding-composite-is-parallel : (u v : Unary)
    → padding (u thenU v) ≡ u tensor v
  padding-composite-is-parallel u v =
      cong ((u thenU v) tensor_) (sym (unary-id-left idU))
    ∙ interchange u v idU idU
    ∙ cong ((u tensor idU) thenB_) (tensor-commutative v idU)
    ∙ sym (interchange u idU idU v)
    ∙ cong₂ _tensor_ (unary-id-right u) (unary-id-left v)

  -- Padding therefore forgets the order of two unary steps.
  padding-commutes : (u v : Unary)
    → padding (u thenU v) ≡ padding (v thenU u)
  padding-commutes u v =
      padding-composite-is-parallel u v
    ∙ tensor-commutative u v
    ∙ sym (padding-composite-is-parallel v u)

  -- The repeated-step causal-collapse equation is the diagonal instance.
  padding-repeated-collapses : (u : Unary)
    → padding (u thenU u) ≡ u tensor u
  padding-repeated-collapses u = padding-composite-is-parallel u u

------------------------------------------------------------------------
-- Killer control: padding equality cannot be cancelled in this interface.
------------------------------------------------------------------------

firstThen : (Bool → Bool) → (Bool → Bool) → Bool → Bool
firstThen f g x = g (f x)

identity : Bool → Bool
identity x = x

erase : Bool → Bool
erase _ = false

toggle : Bool → Bool
toggle = not

-- Binary observations are completely collective in this finite control.
boolUnitCollective : TwoLevelCollective ℓ-zero ℓ-zero
boolUnitCollective = record
  { Unary = Bool → Bool
  ; Binary = Unit
  ; idU = identity
  ; _thenU_ = firstThen
  ; _thenB_ = λ _ _ → tt
  ; _tensor_ = λ _ _ → tt
  ; unary-id-left = λ f → funExt λ _ → refl
  ; unary-id-right = λ f → funExt λ _ → refl
  ; interchange = λ _ _ _ _ → refl
  ; tensor-commutative = λ _ _ → refl
  }

leftExecution : Bool → Bool
leftExecution = firstThen toggle erase

rightExecution : Bool → Bool
rightExecution = firstThen erase toggle

-- Unary order is still visible before padding: false is sent to false on the
-- left and to true on the right.
unary-order-distinct : ¬ leftExecution ≡ rightExecution
unary-order-distinct equal =
  false≢true (cong (λ f → f false) equal)

-- Yet the generic theorem identifies the two executions after one idle
-- component is added.
padding-order-collision :
    padding boolUnitCollective leftExecution
    ≡ padding boolUnitCollective rightExecution
padding-order-collision =
  padding-commutes boolUnitCollective toggle erase

-- There is no cancellation theorem for padding under the declared laws.
padding-not-injective :
    ¬ ((f g : Bool → Bool)
      → padding boolUnitCollective f ≡ padding boolUnitCollective g
      → f ≡ g)
padding-not-injective injective =
  unary-order-distinct
    (injective leftExecution rightExecution padding-order-collision)
