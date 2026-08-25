{-# OPTIONS --cubical --safe #-}

-- A finite, proof-relevant DSO obstruction.
--
-- The random batch-02 anchor was a raw SVG fragment from the carry-cocycle
-- display.  It exposes named intermediate cells (w,L,zₙ), but its bytes do
-- not certify a semantic cost or a complete transition relation.  We
-- therefore use it only as a generative prompt for the exact question below:
-- can a materialised intermediate architecture lose an endpoint witness?
--
-- This module deliberately keeps witnesses before any minimisation.  The
-- endpoint relation R contains a valid pair, while the chosen intermediate
-- relation T ; S cannot compose to it.  Thus no optimizer restricted to that
-- architecture can repair the loss.

module NaturalMachine.DSOArchitecture where

open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (Σ; _,_; _×_; fst; snd)
open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)

-- The endpoint relation contains exactly the witness relevant to this
-- finite test.  It is proof-relevant: `endpoint` is the certificate itself.
data Endpoint : Bool → Bool → Type where
  endpoint : Endpoint true true

-- The architecture materialises one waypoint type.  Its first component
-- admits only the lower waypoint, while its second component admits only the
-- upper waypoint.
data FirstLeg : Bool → Bool → Type where
  first : FirstLeg true false

data SecondLeg : Bool → Bool → Type where
  second : SecondLeg true true

Composition : Bool → Bool → Type
Composition a c = Σ Bool (λ b → FirstLeg a b × SecondLeg b c)

-- The endpoint is feasible.
endpoint-feasible : Endpoint true true
endpoint-feasible = endpoint

-- The materialised architecture is empty at that endpoint.  Both possible
-- waypoints are eliminated explicitly; no numerical search is involved.
architecture-obstructed : ¬ Composition true true
architecture-obstructed (false , witness) =
  second-leg-impossible (snd witness)
  where
  second-leg-impossible : SecondLeg false true → ⊥
  second-leg-impossible ()
architecture-obstructed (true , witness) =
  first-leg-impossible (fst witness)
  where
  first-leg-impossible : FirstLeg true true → ⊥
  first-leg-impossible ()

-- Exact decomposition loss: the endpoint relation is inhabited, but the
-- chosen factorisation has no witness.  This is the finite DSO analogue of
-- infinite architecture regret (+∞) for the missing endpoint.
decomposition-loss : Endpoint true true × (¬ Composition true true)
decomposition-loss = endpoint-feasible , architecture-obstructed
