{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TwoTruthsCompute
--
-- The path of notes/UNIVALENCE_IS_NISVABHAVA_COMPUTATIONAL.md §3, made a
-- checked, computing term.
--
-- Interpretation (marked as interpretation, per the note's discipline —
-- the checked fact below is plain type theory; the reading is argued, not
-- asserted by the term): univalence produces, from an equivalence e, an
-- identity `ua e`.  Transport along that identity is the ULTIMATE face —
-- it says the two types are not two.  Applying the equivalence, `equivFun e`,
-- is the CONVENTIONAL face — a concrete operation you run.  The computation
-- rule uaβ says these are the SAME, and cubical makes it hold by REDUCTION
-- (transportRefl): the ultimate is reached only by running the conventional.
-- That is MMK 24.10 — without relying on the conventional, the ultimate is
-- not taught — as a term that computes rather than a claim.
--
--   ultimate-through-conventional
--       transport (ua e) x ≡ equivFun e x
--     the transported (ultimate) value equals the plainly-applied
--     (conventional) value; the two truths are one operation.
--
-- This is uaβ, re-exhibited.  No new theorem; the point is that the
-- correspondence is not prose here — it is a reduction the kernel checks.
------------------------------------------------------------------------

module NaturalMachine.TwoTruthsCompute where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)

private
  variable
    ℓ : Level
    A B : Type ℓ

-- Transport along the identity univalence builds from `e` (the ultimate:
-- the two types identified) computes to the plain action of `e` (the
-- conventional: an operation you run).  The two truths, one reduction.
ultimate-through-conventional : (e : A ≃ B) (x : A)
                              → transport (ua e) x ≡ equivFun e x
ultimate-through-conventional e x = uaβ e x
