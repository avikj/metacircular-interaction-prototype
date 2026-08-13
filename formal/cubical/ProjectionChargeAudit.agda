{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module ProjectionChargeAudit where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool
open import Cubical.Data.Unit
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary
open import Cubical.HITs.SetQuotients as SQ

-- The smallest positive example: local coordinate plus total charge.
State : Type
State = Bool × Bool

encode : State → Bool × Bool
encode (false , b) = false , b
encode (true  , false) = true , true
encode (true  , true)  = true , false

decode : Bool × Bool → State
decode (false , z) = false , z
decode (true  , false) = true , true
decode (true  , true)  = true , false

decodeEncode : (x : State) → decode (encode x) ≡ x
decodeEncode (false , false) = refl
decodeEncode (false , true)  = refl
decodeEncode (true  , false) = refl
decodeEncode (true  , true)  = refl

encodeDecode : (x : Bool × Bool) → encode (decode x) ≡ x
encodeDecode (false , false) = refl
encodeDecode (false , true)  = refl
encodeDecode (true  , false) = refl
encodeDecode (true  , true)  = refl

localChargeEquiv : State ≃ Bool × Bool
localChargeEquiv = isoToEquiv (iso encode decode encodeDecode decodeEncode)

-- Minimal negative descent example.  The observable relation identifies
-- everything, while charge is the original Boolean value.
R : Bool → Bool → Type
R _ _ = Unit

Local : Type
Local = Bool / R

NoChargeDescent : Type
NoChargeDescent =
  ¬ (Σ[ cbar ∈ (Local → Bool) ] ((b : Bool) → cbar [ b ] ≡ b))

noChargeDescent : NoChargeDescent
noChargeDescent (cbar , agrees) = false≢true contradiction
  where
  glued : [ false ] ≡ [ true ]
  glued = eq/ false true tt

  contradiction : false ≡ true
  contradiction = sym (agrees false) ∙ cong cbar glued ∙ agrees true
