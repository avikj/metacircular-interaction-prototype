{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सम्बन्ध — the relation.  THE RELATIONAL PROGRAM WITH UNIQUE ANSWERS
-- IS THE MAP — SO ALL THREE PRESENTATIONS COLLAPSE ONTO ONE FUNCTION.
--
-- The interactive computer's programs are proof-relevant relations
-- R : A → B → U, executed by returning an output WITH the witness
-- that it stands in the relation: an element of Σ b. R a b.  The
-- deterministic case is the contractible-output case:
--
--     Fun R  =  ∀ a. isContr (Σ b. R a b).
--
-- THEOREM 1 (`the-relation-is-the-graph`): a functional relation is
-- the graph of its execution — R a b ≃ (exec a ≡ b), by the
-- fundamental theorem of identity types, with the execution's witness
-- as the reflexivity datum.  The relation held nothing beyond the
-- function and the paths of B.
--
-- THEOREM 2 (`relational-programs-are-maps`): globally,
--
--     (Σ R. Fun R)  ≃  (A → B)
--
-- — the space of deterministic relational programs IS the function
-- space, one direction definitional, the other a pointwise univalence
-- of Theorem 1.
--
-- With Ekatva and Prashna this closes a triangle.  Three
-- presentations of the closed deterministic machine:
--
--     LawfulStep A            ≃  (A → A)      (Ekatva)
--     Σ R. Fun R              ≃  (A → B)      (here)
--     ISC, receipts, per s    is contractible (Prashna)
--
-- and the receipt event of the deterministic ISC is DEFINITIONALLY
-- the graph relation of the universal step
-- (`the-receipt-is-the-graph` is refl).  Lossless step, functional
-- relation, collapsed interaction: three grammars, one function —
-- and each grammar's surplus is measured by its own theorem: the
-- trace is the fibre, the relation is the graph, the interaction is
-- the receipt.
------------------------------------------------------------------------

module Sambandha_TheRelationalProgramWithUniqueAnswersIsTheMapSoAllThreePresentationsCollapseOntoOneFunction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Equiv.Fiberwise using (recognizeId)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Data.Sigma

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  Functional relations and their execution.
------------------------------------------------------------------------

Fun : {A B : Type ℓ} (R : A → B → Type ℓ) → Type ℓ
Fun {A = A} {B = B} R = (a : A) → isContr (Σ B (R a))

module _ {A B : Type ℓ} (R : A → B → Type ℓ) (F : Fun R) where

  exec : A → B
  exec a = fst (fst (F a))

  -- Execution returns the output with its witness: the program run.
  witness : (a : A) → R a (exec a)
  witness a = snd (fst (F a))

  -- THEOREM 1.  The relation is the graph of its execution.
  the-relation-is-the-graph : (a : A) (b : B) → (exec a ≡ b) ≃ R a b
  the-relation-is-the-graph a = recognizeId (R a) (witness a) (F a)

------------------------------------------------------------------------
-- §2  THEOREM 2: the program space is the function space.
------------------------------------------------------------------------

-- The graph of a map, as a relational program.
graphOf : {A B : Type ℓ} → (A → B) → A → B → Type ℓ
graphOf f a b = f a ≡ b

graphOf-functional : {A B : Type ℓ} (f : A → B) → Fun (graphOf f)
graphOf-functional f a = isContrSingl (f a)

relational-programs-are-maps : {A B : Type ℓ} →
  (Σ[ R ∈ (A → B → Type ℓ) ] Fun R) ≃ (A → B)
relational-programs-are-maps {ℓ = ℓ} {A = A} {B = B} = isoToEquiv theIso
  where
  theIso : Iso (Σ[ R ∈ (A → B → Type ℓ) ] Fun R) (A → B)
  Iso.fun theIso (R , F) = exec R F
  Iso.inv theIso f = graphOf f , graphOf-functional f
  Iso.rightInv theIso f = refl
  Iso.leftInv theIso (R , F) =
    Σ≡Prop (λ _ → isPropΠ (λ _ → isPropIsContr))
           (funExt (λ a → funExt (λ b →
             ua (the-relation-is-the-graph R F a b))))

------------------------------------------------------------------------
-- §3  The triangle's third side, definitionally.
------------------------------------------------------------------------

-- The deterministic ISC's receipt event (Prashna) is the graph
-- relation of the universal step: the same relation, on the nose.
the-receipt-is-the-graph :
  (λ (s s' : Machine) → uStep s ≡ s') ≡ graphOf uStep
the-receipt-is-the-graph = refl
