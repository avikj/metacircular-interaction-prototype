{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BehavioralApartness
--
-- Prime-Pair Atlas Delta 20, T20.4: behavioural apartness, machine-checked.
-- Companion prose: notes/DISTINCTION_CARRIES_WITNESSES.md.
--
-- The repository's kernel (formal/lean/Pairfield/FutureBehavior.lean)
-- formalises SAMENESS: FutureEq x y = ∀ w, behavior x w = behavior y w.
-- It contains no notion of distinction beyond the negation of that.
--
-- But README.md describes the machine as keeping, "for every distinction
-- ... the shortest experiment that reveals it".  That object -- the
-- separating experiment, as data rather than as a refutation -- is what
-- Delta 20 calls behavioural apartness, and it is absent from the kernel.
--
-- This module supplies it, and proves the asymmetry that makes it worth
-- having separately:
--
--   * FutureEq is a PROPOSITION (isPropFutureEq): sameness carries no data;
--   * Apart is NOT a proposition (ApartNotProp): distinction carries data.
--
-- So they are not De Morgan duals with the same status.  One is a
-- truth value; the other is a space of experiments.
------------------------------------------------------------------------

module BehavioralApartness where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1.  The observation system, exactly as the Lean kernel declares it
------------------------------------------------------------------------

module System {St : Type ℓ} {Act : Type ℓ'} {Obs : Type ℓ''}
              (step : St → Act → St) (obs : St → Obs) where

  -- `run`, matching Pairfield.run: apply a word left to right.
  run : St → List Act → St
  run x []       = x
  run x (a ∷ w)  = run (step x a) w

  -- `behavior`, matching Pairfield.behavior.
  behavior : St → List Act → Obs
  behavior x w = obs (run x w)

  -- `FutureEq`, matching Pairfield.FutureEq.
  FutureEq : St → St → Type (ℓ-max ℓ' ℓ'')
  FutureEq x y = (w : List Act) → behavior x w ≡ behavior y w

  -- Delta 20 T20.4.  Apartness is a Σ: its inhabitant IS the experiment.
  Apart : St → St → Type (ℓ-max ℓ' ℓ'')
  Apart x y = Σ[ w ∈ List Act ] (¬ (behavior x w ≡ behavior y w))

  ----------------------------------------------------------------------
  -- 2.  The two relate as expected in one direction only
  ----------------------------------------------------------------------

  -- Apartness refutes sameness.  Constructive, no hypotheses.
  apart→¬futureEq : {x y : St} → Apart x y → ¬ FutureEq x y
  apart→¬futureEq (w , sep) fe = sep (fe w)

  -- The converse is NOT provable here, and that is the point: from
  -- ¬ FutureEq one cannot extract a word without a search principle.
  -- Delta 20's "the witness is not merely that x and y differ; it is a
  -- CONTEXT that distinguishes them" is exactly this gap.

  ----------------------------------------------------------------------
  -- 3.  Both are congruences, in opposite directions
  ----------------------------------------------------------------------

  -- Sameness descends along actions.  This is Pairfield.futureEq_step.
  futureEq-step : {x y : St} → FutureEq x y → (a : Act)
                → FutureEq (step x a) (step y a)
  futureEq-step fe a w = fe (a ∷ w)

  -- Distinction ASCENDS: an experiment separating the successors,
  -- prefixed by the action, separates the predecessors.  The witness is
  -- transported explicitly -- this is the computational content the
  -- proposition-valued kernel cannot express.
  apart-step : {x y : St} (a : Act)
             → Apart (step x a) (step y a) → Apart x y
  apart-step a (w , sep) = (a ∷ w) , sep

  -- And conversely a nonempty witness peels.
  apart-peel : {x y : St} {a : Act} {w : List Act}
             → (¬ (behavior x (a ∷ w) ≡ behavior y (a ∷ w)))
             → Apart (step x a) (step y a)
  apart-peel {w = w} sep = w , sep

------------------------------------------------------------------------
-- 4.  The asymmetry: sameness is a proposition, distinction is not
------------------------------------------------------------------------

module _ {St : Type ℓ} {Act : Type ℓ'} {Obs : Type ℓ''}
         (step : St → Act → St) (obs : St → Obs) (isSetObs : isSet Obs) where

  open System step obs

  -- Sameness carries no data: any two proofs are equal.
  isPropFutureEq : (x y : St) → isProp (FutureEq x y)
  isPropFutureEq x y =
    isPropΠ (λ w → isSetObs (behavior x w) (behavior y w))

------------------------------------------------------------------------
-- 5.  Control: Apart is genuinely not a proposition
--
-- The minimal witnessing system.  Two states, one action, the identity
-- dynamics, the state itself as observation.  Every word separates
-- `false` from `true`, so the apartness type has many inhabitants with
-- distinct first components.
------------------------------------------------------------------------

module Minimal where

  stepM : Bool → Unit → Bool
  stepM b _ = b

  obsM : Bool → Bool
  obsM b = b

  open System stepM obsM

  -- Every state is fixed, so behaviour is the state itself.
  behavior-const : (b : Bool) (w : List Unit) → behavior b w ≡ b
  behavior-const b []      = refl
  behavior-const b (_ ∷ w) = behavior-const b w

  sep-any : (w : List Unit) → ¬ (behavior false w ≡ behavior true w)
  sep-any w p =
    false≢true (sym (behavior-const false w) ∙ p ∙ behavior-const true w)

  -- Two separating experiments of different length.
  w₀ w₁ : List Unit
  w₀ = []
  w₁ = tt ∷ []

  witness₀ witness₁ : Apart false true
  witness₀ = w₀ , sep-any w₀
  witness₁ = w₁ , sep-any w₁

  -- They are distinct, because their first components are.
  []≢tt∷[] : ¬ (w₀ ≡ w₁)
  []≢tt∷[] p = subst D p tt
    where
    D : List Unit → Type
    D []      = Unit
    D (_ ∷ _) = ⊥

  witness₀≢witness₁ : ¬ (witness₀ ≡ witness₁)
  witness₀≢witness₁ p = []≢tt∷[] (cong fst p)

  -- Hence apartness is not a proposition, while FutureEq always is.
  ApartNotProp : ¬ (isProp (Apart false true))
  ApartNotProp h = witness₀≢witness₁ (h witness₀ witness₁)

  -- The contrast, in one place: for this very system, sameness IS a
  -- proposition (Bool is a set) while distinction is not.
  FutureEqIsProp : (x y : Bool) → isProp (FutureEq x y)
  FutureEqIsProp = isPropFutureEq stepM obsM isSetBool

  -- Sanity: the two states really are apart, so §5 is not vacuous.
  falseApartTrue : Apart false true
  falseApartTrue = witness₀

------------------------------------------------------------------------
-- HEADER CORRECTION, appended 2026-08-15, Claude (Hilbert lineage,
-- header/term audit pass 2, notes/HEADER_CLAIM_AUDIT_2.md §3.1).
-- Nothing above was altered or deleted; this block only qualifies a
-- header sentence.
--
-- The header states the asymmetry as two unqualified sentences:
--
--     * FutureEq is a PROPOSITION (isPropFutureEq): sameness carries
--       no data;
--     * Apart is NOT a proposition (ApartNotProp): distinction carries
--       data.
--
-- The first is general and the terms carry it: `isPropFutureEq` is
-- proved in §4 for EVERY (step, obs) with `isSet Obs`.
--
-- The second is NOT general, and cannot be: `ApartNotProp` lives in
-- `module Minimal` and has type `¬ (isProp (Apart false true))` — one
-- system (two states, one action, identity dynamics, state-as-
-- observation) at one pair of states.  Read as a statement about every
-- system it is false, not merely unproved: whenever `FutureEq x y`
-- holds, `Apart x y` is empty and hence IS a proposition, and the
-- module supplies no hypothesis excluding that case.
--
-- The body is already correct where it is local: §5 is titled
-- "Control", says "The minimal witnessing system", and closes with
-- `falseApartTrue` labelled "so §5 is not vacuous".  Only the header
-- generalises.  The accurate reading of the pair is:
--
--     sameness is ALWAYS a proposition; distinction is NOT always one,
--     and `Minimal` is the witness that it can fail to be.
--
-- That is still the asymmetry the module is for — one side is a
-- theorem about all systems, the other is a counterexample — and it is
-- what the terms prove.  No mathematical judgement is made here about
-- whether a general hypothesis (e.g. two words of different length
-- both separating) should be added; that is the author's call.
------------------------------------------------------------------------
