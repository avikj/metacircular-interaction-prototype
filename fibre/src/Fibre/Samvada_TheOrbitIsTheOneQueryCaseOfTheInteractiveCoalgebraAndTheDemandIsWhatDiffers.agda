{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Punarāgamana · Saṃvāda  (संवाद, dialogue)
--
-- WHAT `Fibre.Orbit` IS AND IS NOT.  An Orbit is an unbounded future
-- computed on demand — but a future with no INPUT.  Its whole trajectory
-- is fixed at the moment it is unfolded; asking for the n-th element
-- cannot change the (n+1)-st.  That is a stream, and a stream is the
-- degenerate case of an interaction: the one where the environment has
-- exactly one thing it can say.
--
-- THE COALGEBRA.  Generalise the query type from a point to a family:
--
--   ISC w  ≃  (q : Q w) → Σ[ w' ∈ W ] Σ[ o ∈ O w q w' ] E w q w' o × ISC w'
--
--   Q  what the environment may ask at this state
--   O  what it observes when it does
--   E  the proof-relevant event datum of that transition
--   ▹  the continuation, guarded — productivity, not totality
--
-- Nothing is globally normalised.  A finite demand of length n asks n
-- questions and gets n answers; the object is never completed, and that
-- is the execution seam.
--
-- THE TWO THEOREMS, and they are a pair on purpose:
--
--   det-observe               the deterministic orbit IS the trivial-query
--                             case — observing the embedded stream returns
--                             exactly the prefix of `unfold Φ`, in Orbit's
--                             own vocabulary, so this is a generalisation
--                             and not a replacement.
--
--   det-strategy-independent  under that embedding, EVERY strategy gets
--                             the same answers.  The demand is doing no
--                             work, because there is no choice to make.
--
-- AND THE SEPARATION.  `counter` is an interaction where two strategies
-- computably disagree at the very first step.  So the generalisation is
-- proper: the extra structure is not bookkeeping around a stream.
--
-- THE OTHER SAṂVĀDA.  formal/cubical/kernel/TheKernelIsAnInteractiveSystem…
-- carries the same word for the same reason, and is a different object:
-- a term-rewriting kernel whose caller disposes of the offered futures.
-- This module is the coalgebra, in the `fibre` library, which does not
-- depend on that one.  The shared name is the shared shape, not a shared
-- theorem.
--
-- WHAT IS NOT CLAIMED.  A strategy here is a function of the state alone,
-- not of the history; O and E are families, not a protocol; and nothing
-- about authority, disclosure, or resources is expressed by the shape of
-- this record.  Those are separate obligations.
------------------------------------------------------------------------

module Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Properties
open import Cubical.Data.Sigma
open import Cubical.Data.List.Base
open import Cubical.Data.Unit
open import Cubical.Data.Bool
open import Cubical.Relation.Nullary using (¬_)

open import Fibre.Orbit

private
  variable
    ℓ : Level

-- A demand: what to ask, given where you are.
Strategy : {W : Type ℓ} → (W → Type ℓ) → Type ℓ
Strategy {W = W} Q = (w : W) → Q w

------------------------------------------------------------------------
-- The interactive coalgebra.
------------------------------------------------------------------------

record ISC {W : Type ℓ} (Q : W → Type ℓ)
           (O : (w : W) → Q w → W → Type ℓ)
           (E : (w : W) (q : Q w) (w' : W) → O w q w' → Type ℓ)
           (w : W) : Type ℓ where
  coinductive
  field
    react : (q : Q w) → Σ[ w' ∈ W ] Σ[ o ∈ O w q w' ] (E w q w' o × ISC Q O E w')

open ISC public

module _ {W : Type ℓ} {Q : W → Type ℓ}
         {O : (w : W) → Q w → W → Type ℓ}
         {E : (w : W) (q : Q w) (w' : W) → O w q w' → Type ℓ} where

  -- the visible successor under one question…
  visit : {w : W} → Strategy Q → ISC Q O E w → W
  visit {w} σ p = fst (react p (σ w))

  -- …and the continuation, which is a different process, at a different
  -- state, because a question was asked.
  continue : {w : W} (σ : Strategy Q) (p : ISC Q O E w) → ISC Q O E (visit σ p)
  continue {w} σ p = snd (snd (snd (react p (σ w))))

  -- finite demand: n questions, n answers, nothing else forced.
  observe : Strategy Q → ℕ → {w : W} → ISC Q O E w → List W
  observe σ zero    p = []
  observe σ (suc n) p = visit σ p ∷ observe σ n (continue σ p)

------------------------------------------------------------------------
-- The trivial query: one question, one answer, no information.
------------------------------------------------------------------------

module _ {W : Type ℓ} where

  Trivial : W → Type ℓ
  Trivial _ = Unit*

  TrivialO : (w : W) → Trivial w → W → Type ℓ
  TrivialO _ _ _ = Unit*

  TrivialE : (w : W) (q : Trivial w) (w' : W) → TrivialO w q w' → Type ℓ
  TrivialE _ _ _ _ = Unit*

  Det : W → Type ℓ
  Det = ISC Trivial TrivialO TrivialE

  -- an endomorphism, read as an interaction that ignores what it is asked
  det : (Φ : W → W) (w : W) → Det w
  react (det Φ w) _ = Φ w , tt* , tt* , det Φ (Φ w)

  -- the finite view of an Orbit, in Orbit's own vocabulary
  prefix : ℕ → Orbit W → List W
  prefix zero    o = []
  prefix (suc n) o = here o ∷ prefix n (next o)

  -- THEOREM.  Observing the embedded stream returns the orbit's prefix —
  -- for any strategy, since there is nothing to choose.
  det-observe : (σ : Strategy Trivial) (Φ : W → W) (n : ℕ) (w : W)
              → observe σ n (det Φ w)
              ≡ prefix n (next (unfold Φ w))
  det-observe σ Φ zero    w = refl
  det-observe σ Φ (suc n) w = cong (Φ w ∷_) (det-observe σ Φ n (Φ w))

  -- COROLLARY.  Under the embedding the demand is inert.
  det-strategy-independent : (σ τ : Strategy Trivial) (Φ : W → W) (n : ℕ) (w : W)
    → observe σ n (det Φ w)
    ≡ observe τ n (det Φ w)
  det-strategy-independent σ τ Φ n w =
    det-observe σ Φ n w ∙ sym (det-observe τ Φ n w)

------------------------------------------------------------------------
-- …and an interaction where it is not.  Two strategies, one step, two
-- different answers: the coalgebra is properly more than a stream.
------------------------------------------------------------------------

Choice : ℕ → Type₀
Choice _ = Bool

ChoiceO : (w : ℕ) → Choice w → ℕ → Type₀
ChoiceO _ _ _ = Unit

ChoiceE : (w : ℕ) (q : Choice w) (w' : ℕ) → ChoiceO w q w' → Type₀
ChoiceE _ _ _ _ = Unit

counter : (n : ℕ) → ISC Choice ChoiceO ChoiceE n
react (counter n) true  = suc n , tt , tt , counter (suc n)
react (counter n) false = 0     , tt , tt , counter 0

up down : Strategy Choice
up   _ = true
down _ = false

private
  hd : List ℕ → ℕ
  hd []      = 0
  hd (x ∷ _) = x

counter-demand-matters
  : ¬ ( observe up   1 (counter 0)
      ≡ observe down 1 (counter 0) )
counter-demand-matters p = snotz (cong hd p)
