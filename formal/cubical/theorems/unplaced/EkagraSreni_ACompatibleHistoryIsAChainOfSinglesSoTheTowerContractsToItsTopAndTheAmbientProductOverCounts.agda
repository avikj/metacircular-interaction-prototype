{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकाग्र-श्रेणी — the tower with one head.
--
-- A COMPATIBLE HISTORY IS A CHAIN OF SINGLETONS, SO THE TOWER IS ITS
-- TOP, AND THE AMBIENT PRODUCT OF READINGS COUNTS SOMETHING ELSE.
--
-- Given stages `O : ℕ → Type` and reductions `r n : O (suc n) → O n`,
-- there are two different objects that get called "the histories":
--
--   the AMBIENT PRODUCT   — one reading chosen at each stage, with no
--                           equations imposed between them;
--   the COMPATIBLE TOWER  — readings that agree under reduction.
--
-- They are not the same size, and the gap is exactly the equations.
-- This module proves the compatible side is equivalent to its top
-- stage alone:
--
--     (Σ[ t ∈ O n ] Chain n t)  ≃  O n .
--
-- THE REASON IS THE FIBRE LAW, and that is the point of writing it this
-- way.  One rung of the tower is
--
--     Chain (suc n) t = Σ[ p ∈ singl (r n t) ] Chain n (fst p) ,
--
-- and `singl (r n t)` — the fibre of the IDENTITY at `r n t` — is
-- contractible with NO hypothesis on anything (`isContrSingl`).  So each
-- rung contributes nothing once the rung above it is fixed: a compatible
-- past is not extra data, it is determined.  Binding the output is free;
-- that is the whole of §1, iterated `n` times.
--
--   §1  every chain is contractible, at every stage and every top
--   §2  hence the tower of compatible histories is its top stage
--
-- CONSEQUENCE FOR COUNTING, stated as the reason a product is the wrong
-- ambient object: the compatible histories over a top stage `O n` are
-- in bijection with `O n` itself — not with the product of the stages
-- below it.  A cardinality computed from the product is counting
-- arbitrary reading records, before the compatibility equations are
-- imposed; the equations are precisely what `isContrSingl` then
-- collapses.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–3 for any family of stages and any
-- reductions between them: no group structure, no finiteness, no
-- decidability, and no arithmetic.  NOT claimed: any cardinality —
-- there are no numbers in this file, and the counting consequence
-- above is what the equivalence gives ONCE the stages are finite and
-- their sizes are supplied from elsewhere; nor anything about infinite
-- towers or their limits, which is a different object from every
-- finite truncation of one.
------------------------------------------------------------------------

module EkagraSreni_ACompatibleHistoryIsAChainOfSinglesSoTheTowerContractsToItsTopAndTheAmbientProductOverCounts where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.HLevels using (isOfHLevelΣ)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; Σ-contractSnd)
open import Cubical.Data.Unit using (Unit* ; isContrUnit*)

private
  variable
    ℓ : Level

module _ (O : ℕ → Type ℓ) (r : (n : ℕ) → O (suc n) → O n) where

  ------------------------------------------------------------------
  -- ० · A compatible past below a given top.  Each rung records the
  --     stage below and the equation tying it to the stage above.
  ------------------------------------------------------------------

  Chain : (n : ℕ) → O n → Type ℓ
  Chain zero    _ = Unit*
  Chain (suc n) t = Σ[ p ∈ singl (r n t) ] Chain n (fst p)

  ------------------------------------------------------------------
  -- १ · EVERY COMPATIBLE PAST IS CONTRACTIBLE: there is exactly one,
  --     for each top, and it carries no information of its own.  The
  --     base of each rung is `singl`, contractible with no hypothesis;
  --     the fibre is the chain below, contractible by induction.
  ------------------------------------------------------------------

  Chain-isContr : (n : ℕ) (t : O n) → isContr (Chain n t)
  Chain-isContr zero    _ = isContrUnit*
  Chain-isContr (suc n) t =
    isOfHLevelΣ 0 (isContrSingl (r n t)) (λ p → Chain-isContr n (fst p))

  ------------------------------------------------------------------
  -- २ · SO THE TOWER OF COMPATIBLE HISTORIES IS ITS TOP STAGE.
  ------------------------------------------------------------------

  Tower : ℕ → Type ℓ
  Tower n = Σ[ t ∈ O n ] Chain n t

  tower-is-its-top : (n : ℕ) → Tower n ≃ O n
  tower-is-its-top n = Σ-contractSnd (Chain-isContr n)
