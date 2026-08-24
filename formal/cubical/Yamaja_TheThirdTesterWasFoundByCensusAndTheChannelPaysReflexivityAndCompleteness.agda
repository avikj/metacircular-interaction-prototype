-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- यमजौ — तृतीयः परीक्षकः गणनया लब्धः ; सेतुना पुनरावृत्तिः पूर्णता च दीयेते ।
--
-- (twins: a third tester, found by census, and the channel pays it
--  reflexivity and completeness.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, AND IT IS SOMEONE ELSE'S METHOD APPLIED TO A PAIR THEY
-- COULD NOT FIND.
--
-- `Bhedanirnaya_TwoTestersForSamenessOnNumberAndTheTransportThatMoves
-- TheoremsBetweenThem.agda` identified `EGBResidueGlue.eqℕ` with
-- `NaturalMachine.Obstruction.eqℕ` — two modules that had each written
-- the same four clauses, whose theorems PRINT alike and are NOT the same
-- type, since the two `eqℕ` do not reduce to a common form at variable
-- arguments.  Its sentence is the reason to do this at all:
--
--     "A duplication that has been identified is not merely tidier — it is
--      a CHANNEL, and theorems flow both ways along it."
--
-- And its §६ says what it could not do: "the pattern generalises and is
-- not generalised… a question for the audit tool, which currently reports
-- only same-PRINTED-type groups and would miss a pair whose definitions
-- agree under different names."
--
-- That audit now exists — `machine/Pratyaksa_…hs --twins`, which erases
-- each declaration's own module prefix from its KERNEL-ELABORATED type and
-- groups — and the first thing it returned was a THIRD `eqℕ`:
--
--     NaturalMachine.Alopa_TheEngineNeverTouchesTheMeaning.eqℕ-sound
--     NaturalMachine.Obstruction.eqℕ→≡
--
-- neither of which Bhedanirnaya mentions.  This is that pair, opened.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE CHANNEL PAYS, and the ledger was lopsided exactly as
-- Bhedanirnaya predicted — each module proved the half its own question
-- required and no more:
--
--   Alopa       holds  eqℕ-sound.                   And nothing else.
--   Obstruction holds  eqℕ-refl, eqℕ→≡, ≢→eqℕ-false.
--
-- Alopa's engine tests names for equality while rewriting; it never needed
-- to trust a NEGATIVE answer, so it never proved completeness.  §३ and §४
-- hand it both missing theorems by transport, with no new induction and no
-- edit to either module.
--
-- THE ONLY WORK IS §१, four lines, and everything after it is transport.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT DONE, said so silence is not read as denial.
--
--   · The triangle is not closed here.  Bhedanirnaya identifies
--     EGBResidueGlue with Obstruction and this identifies Alopa with
--     Obstruction, so Alopa ≡ EGBResidueGlue follows by composing the two
--     paths — and is NOT stated below, because EGBResidueGlue is not
--     imported here and importing it to state a corollary that costs one
--     `∙` is not worth the dependency.  Named as available, not claimed.
--   · NONE of the three should exist.  `Cubical.Relation.Nullary.Discrete`
--     and `Cubical.Data.Nat.Properties.discreteℕ` give decidable equality
--     on ℕ with both halves, in the library, checked — which Bhedanirnaya
--     §६ already says of two copies and now says of three.  This module
--     identifies copies with each other and identifies NONE of them with
--     the library's, so the corpus still carries a fourth statement of the
--     fact that it did not write and cannot see.
--   · No claim that the twins report is a proof of anything.  A hit is a
--     CANDIDATE: two statements normalising alike does not mean two
--     definitions agree, and §१ is exactly the work the report cannot do.
--     Here they did agree.  Elsewhere a hit may be a genuine near-miss.
--
-- TERM.  यमज — twin-born; the ordinary Sanskrit word, used for the
-- relation the census reports and NOT taken from any technical source.
-- No text is claimed for anything below, and the mathematics — path,
-- transport, `ua` — is cubical type theory, Voevodsky's, this
-- repository's one admitted non-Indian substrate.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Yamaja_TheThirdTesterWasFoundByCensusAndTheChannelPaysReflexivityAndCompleteness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.Alopa_TheEngineNeverTouchesTheMeaning as A
import NaturalMachine.Obstruction as O

------------------------------------------------------------------------
-- १ · समता — the two testers agree, pointwise.  Induction on both
--     arguments, four lines, and it is the only work in this file.
------------------------------------------------------------------------

समता : (m n : ℕ) → A.eqℕ m n ≡ O.eqℕ m n
समता zero    zero    = refl
समता zero    (suc _) = refl
समता (suc _) zero    = refl
समता (suc m) (suc n) = समता m n

------------------------------------------------------------------------
-- २ · एकीभावः — pointwise agreement made a path between the functions,
--     written as a direct cubical abstraction so the path's i-th slice IS
--     §१'s i-th slice and there is no step where anything could go
--     missing.
------------------------------------------------------------------------

एकीभावः : A.eqℕ ≡ O.eqℕ
एकीभावः i m n = समता m n i

------------------------------------------------------------------------
-- ३ · पूर्णता — COMPLETENESS, carried BACKWARDS to Alopa.
--
--     Obstruction proved it because its question needed a trustworthy
--     NEGATIVE answer — it tests membership in a list of seen states.
--     Alopa's engine never needed that and never proved it.  It has it
--     now, and no induction was repeated.
------------------------------------------------------------------------

संक्रान्त-पूर्णता : (m n : ℕ) → ¬ (m ≡ n) → A.eqℕ m n ≡ false
संक्रान्त-पूर्णता =
  transport (λ i → (m n : ℕ) → ¬ (m ≡ n) → एकीभावः (~ i) m n ≡ false)
            O.≢→eqℕ-false

------------------------------------------------------------------------
-- ४ · पुनरावृत्तिः — and reflexivity, the same way.
------------------------------------------------------------------------

संक्रान्त-पुनरावृत्तिः : (n : ℕ) → A.eqℕ n n ≡ true
संक्रान्त-पुनरावृत्तिः =
  transport (λ i → (n : ℕ) → एकीभावः (~ i) n n ≡ true) O.eqℕ-refl

------------------------------------------------------------------------
-- ५ · The tester Alopa now has, both answers trustworthy, in one place.
--     Soundness is its own; completeness came across §३.
------------------------------------------------------------------------

open import Cubical.Data.Sigma using (_×_ ; _,_)

पूर्ण-निर्णयः
  : (m n : ℕ)
  → (A.eqℕ m n ≡ true → m ≡ n)
  × (¬ (m ≡ n) → A.eqℕ m n ≡ false)
पूर्ण-निर्णयः m n = A.eqℕ-sound m n , संक्रान्त-पूर्णता m n

------------------------------------------------------------------------
-- ६ · संक्रमण-तादात्म्यम् — and the carry lands ON THE NOSE.
--
--     The transported soundness IS Alopa's own proof.  ℕ is a set and the
--     target is a path in ℕ, so the whole Π-type is a proposition: the
--     theorem transports uniquely precisely because there was never room
--     for two answers.  Bhedanirnaya §४'s point, at this pair.
------------------------------------------------------------------------

open import Cubical.Data.Nat.Properties using (isSetℕ)

संक्रान्त-सौष्ठवम् : (m n : ℕ) → A.eqℕ m n ≡ true → m ≡ n
संक्रान्त-सौष्ठवम् =
  transport (λ i → (m n : ℕ) → एकीभावः (~ i) m n ≡ true → m ≡ n) O.eqℕ→≡

संक्रमण-तादात्म्यम् : संक्रान्त-सौष्ठवम् ≡ A.eqℕ-sound
संक्रमण-तादात्म्यम् =
  funExt λ m → funExt λ n → funExt λ _ → isSetℕ m n _ _
