{-# OPTIONS --cubical --safe #-}

-- The algebra-homomorphism part of the compositional-context quotient's
-- universal property.  CompositionalContextAdapter already descends the
-- binary operation, while FutureBehavior supplies factorization of bare set
-- maps.  This leaf proves that the factor of a context-constant magma map is
-- again a magma map, and that it is the unique factor on quotient generators.

module CompositionalMagmaFactorization where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; not ; false≢true ; isSetBool)
open import Cubical.Data.List using ([])
open import Cubical.HITs.SetQuotients as SQ using ([_])
open import Cubical.Relation.Nullary using (¬_)

import CompositionalContextAdapter as CCA

private
  variable
    ℓx ℓo ℓy : Level
    X : Type ℓx
    O : Type ℓo
    Y : Type ℓy

PreservesMagma : (X → X → X) → (Y → Y → Y) → (X → Y) → Type _
PreservesMagma source target map =
  (x y : _) → map (source x y) ≡ target (map x) (map y)

ContextConstant : (operation : X → X → X) (observe : X → O)
                → (X → Y) → Type _
ContextConstant operation observe map =
  {x y : _} → CCA.ContextEq operation observe x y → map x ≡ map y

------------------------------------------------------------------------
-- A context-constant magma map factors as a magma map
------------------------------------------------------------------------

module Factorization
    (operation : X → X → X)
    (setO : isSet O)
    (observe : X → O)
    (targetOperation : Y → Y → Y)
    (setY : isSet Y)
    (map : X → Y)
    (constant : ContextConstant operation observe map)
    (preserves : PreservesMagma operation targetOperation map)
    where

  module CQ = CCA.ContextQuotient operation setO observe

  -- The existing set-quotient factor, now named at the magma interface.
  magmaFactor : CQ.Meaning → Y
  magmaFactor = CQ.Q.factor setY map constant

  magmaFactor-β : (x : X) → magmaFactor [ x ] ≡ map x
  magmaFactor-β = CQ.Q.factor-[] setY map constant

  -- The new joint: the bare factor preserves the descended operation.
  magmaFactor-preserves : (left right : CQ.Meaning)
    → magmaFactor (CQ._opQ_ left right)
      ≡ targetOperation (magmaFactor left) (magmaFactor right)
  magmaFactor-preserves =
    SQ.elimProp2 (λ _ _ → setY _ _) preserves

  -- Agreement on the quotient generators determines the factor everywhere.
  -- This is stronger than uniqueness merely among magma-preserving maps.
  magmaFactor-unique : (other : CQ.Meaning → Y)
    → ((x : X) → other [ x ] ≡ map x)
    → other ≡ magmaFactor
  magmaFactor-unique other agrees =
    funExt (CQ.Q.factor-unique setY map constant other agrees)

------------------------------------------------------------------------
-- Killer control: bare factorization does not manufacture a magma law
------------------------------------------------------------------------

xor : Bool → Bool → Bool
xor false right = right
xor true  false = true
xor true  true  = false

identity : Bool → Bool
identity value = value

module BoolQuotient = CCA.ContextQuotient xor isSetBool identity

-- The empty context makes ContextEq imply equality for identity observation,
-- so `not` is constant on the contextual fibers and has a bare factor.
not-context-constant : ContextConstant xor identity not
not-context-constant related = cong not (related [])

bareNotFactor : BoolQuotient.Meaning → Bool
bareNotFactor =
  BoolQuotient.Q.factor isSetBool not not-context-constant

bareNotFactor-β : (value : Bool) → bareNotFactor [ value ] ≡ not value
bareNotFactor-β =
  BoolQuotient.Q.factor-[] isSetBool not not-context-constant

-- At false,false, preservation would say
--   not (false xor false) = not false xor not false,
-- i.e. true = false.
bare-factor-need-not-preserve-magma :
  ¬ ((left right : BoolQuotient.Meaning)
    → bareNotFactor (BoolQuotient._opQ_ left right)
      ≡ xor (bareNotFactor left) (bareNotFactor right))
bare-factor-need-not-preserve-magma preserves =
  false≢true (sym (preserves [ false ] [ false ]))
