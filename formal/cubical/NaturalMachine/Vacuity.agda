{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Vacuity verdicts as types that carry their witnesses.
--
-- A *claim* is an invariant `inv` together with the relation `apart`
-- naming the pairs it is supposed to tell apart.  A *verdict* on that
-- claim is one of four things, and in this encoding each one is the
-- witness rather than a string naming it:
--
--   FORMS              the claim has an instance at all              (x)
--   GENUINE            a pair the invariant really separates
--                                              (x , y , apart , ≢)
--   VACUOUS            a COLLISION PAIR: apart, yet the invariant
--                      reports the same value  (x , y , apart , ≡)
--   UNDECIDED-VACUOUS  neither witness is available yet, together
--                      with the exact proposition whose decision
--                      produces one            (P , isProp P , resolver)
--
-- The point is structural, not disciplinary.  An emitter cannot write
-- `genuine` without exhibiting the separated pair, cannot write
-- `vacuous` without exhibiting the collision pair, and cannot park a
-- claim in `undecided-vacuous` without naming the decision that would
-- settle it — `Dec P → Verdict` is a resolver, so the obligation is
-- carried in the type and discharged by supplying the decision.
--
-- The last theorem is the seam with `NaturalMachine.Descent`: a claim
-- that is vacuous at *every* apart-pair is precisely one whose
-- invariant factors through the quotient by `apart`.  "Carries no
-- information" and "descends" are the same statement.
------------------------------------------------------------------------

module NaturalMachine.Vacuity where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Unit using (Unit*)
open import Cubical.Relation.Nullary using (Dec ; ¬_ ; yes ; no)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_])

open import NaturalMachine.Descent

private
  variable
    ℓ : Level

record Claim (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Obj   : Type ℓ
    Val   : Type ℓ
    inv   : Obj → Val
    apart : Obj → Obj → Type ℓ

open Claim public

-- A collision pair: two things the claim is supposed to separate, on
-- which the invariant agrees.  This is the object VACUITY_CERTIFICATES
-- was written to demand and could only ask for in prose.
CollisionPair : Claim ℓ → Type ℓ
CollisionPair c =
  Σ[ x ∈ Obj c ] Σ[ y ∈ Obj c ] apart c x y × (inv c x ≡ inv c y)

SeparatedPair : Claim ℓ → Type ℓ
SeparatedPair c =
  Σ[ x ∈ Obj c ] Σ[ y ∈ Obj c ] apart c x y × (¬ (inv c x ≡ inv c y))

data Verdict (c : Claim ℓ) : Type (ℓ-suc ℓ) where
  forms             : Obj c → Verdict c
  genuine           : SeparatedPair c → Verdict c
  vacuous           : CollisionPair c → Verdict c
  undecided-vacuous : (P : Type ℓ) → isProp P → (Dec P → Verdict c)
                    → Verdict c

module _ {c : Claim ℓ} where

  -- Extraction is total: a `vacuous` verdict *is* its collision pair.
  -- There is no decoding step at which a string could have been faked.
  collisionPair : (v : Verdict c) → Type ℓ
  collisionPair (vacuous _) = CollisionPair c
  collisionPair _           = Unit*

  readCollision : (v : Verdict c) → collisionPair v
  readCollision (forms _)                 = _
  readCollision (genuine _)               = _
  readCollision (vacuous p)               = p
  readCollision (undecided-vacuous _ _ _) = _

  -- Soundness: no pair admits both verdicts.  A `genuine` and a
  -- `vacuous` verdict about the same pair contradict each other, so an
  -- emitter cannot hedge by producing both.
  genuine-not-vacuous : (x y : Obj c)
                      → apart c x y
                      → (inv c x ≡ inv c y)
                      → (¬ (inv c x ≡ inv c y))
                      → ⊥
  genuine-not-vacuous _ _ _ p ¬p = ¬p p

  -- The undecided constructor is exactly the gap to a decision oracle:
  -- given one, every verdict resolves to a decided verdict, and the
  -- resolution is structural recursion, not a promise.
  Oracle : Type (ℓ-suc ℓ)
  Oracle = (P : Type ℓ) → isProp P → Dec P

  data Decided (c : Claim ℓ) : Type (ℓ-suc ℓ) where
    forms   : Obj c → Decided c
    genuine : SeparatedPair c → Decided c
    vacuous : CollisionPair c → Decided c

  resolve : Oracle → Verdict c → Decided c
  resolve o (forms x)                   = forms x
  resolve o (genuine p)                 = genuine p
  resolve o (vacuous p)                 = vacuous p
  resolve o (undecided-vacuous P pp k)  = resolve o (k (o P pp))

  -- A decided verdict always yields a witness of its own kind.
  Witness : Decided c → Type ℓ
  Witness (forms _)   = Obj c
  Witness (genuine _) = SeparatedPair c
  Witness (vacuous _) = CollisionPair c

  readWitness : (v : Decided c) → Witness v
  readWitness (forms x)   = x
  readWitness (genuine p) = p
  readWitness (vacuous p) = p

------------------------------------------------------------------------
-- Total vacuity is descent.
------------------------------------------------------------------------

-- Every apart-pair is a collision pair.
TotallyVacuous : Claim ℓ → Type ℓ
TotallyVacuous c = (x y : Obj c) → apart c x y → inv c x ≡ inv c y

module _ (c : Claim ℓ) (isSetVal : isSet (Val c)) where

  private
    Q : Type ℓ
    Q = Obj c / apart c

  -- ⇒ : a claim that collides everywhere factors through the quotient.
  --     Its invariant sees nothing the quotient has not already
  --     identified, which is what "carries no information" means.
  totallyVacuous→factors : TotallyVacuous c → Factors [_] (inv c)
  totallyVacuous→factors tv = SQ.rec isSetVal (inv c) tv , λ _ → refl

  -- ⇐ : and conversely.  So the vacuity verdict, taken over all pairs,
  --     is not a report about the invariant; it is the invariant's
  --     descent datum.
  factors→totallyVacuous : Factors [_] (inv c) → TotallyVacuous c
  factors→totallyVacuous fac x y r =
    factors→constant [_] (inv c) fac x y (SQ.eq/ x y r)
