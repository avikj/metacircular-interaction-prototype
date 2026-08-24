-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Does the natural machine RUN, and at what complexity?
--
-- `NaturalMachine.Transport` proves `transport-+-is-⊕`: transporting ℕ's
-- addition along `ua ℕ≃CanWord` yields *literally* the schoolbook
-- ripple-carry algorithm.  That is a proved PATH.  A path between two
-- functions says nothing about how the two TERMS reduce, so two separate
-- questions remain, and both are decided by execution rather than by proof:
--
--   (1) does the transported term compute at all?
--   (2) if so, does it compute at the native algorithm's complexity?
--
-- Answers, measured (see notes/TRANSPORT_IS_NOT_A_COMPILER.md):
--   (1) YES.  Every `refl` below forces evaluation and typechecks.
--   (2) NO.  Native is flat in the number of chained operations; the
--       transported term is quadratic, because transport across `ua e`
--       *is* `e⁻¹ ∘ f ∘ (e × e)` — a full round trip through ℕ per
--       operation, and `valueC`/`digitsC` are unary.
--
-- This file is the small reproducible witness.  The scaling runs that
-- established (2) are recorded in the note, not here, because leaving a
-- 40-second typecheck in the tree would be hostile.

module NaturalMachine.TransportCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)

open import NaturalMachine
open NaturalMachine.Base2

transported : CanWord → CanWord → CanWord
transported = transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i → ℕ≡CanWord i) _+_

-- (1) The transported term reduces.  Smallest case exercising a carry.
transported-computes : valueC (transported (digitsC 1) (digitsC 1)) ≡ 2
transported-computes = refl

-- Full carry cascade, base two: 111₂ + 1 = 1000₂.
transported-cascade : valueC (transported (digitsC 7) (digitsC 1)) ≡ 8
transported-cascade = refl

-- The native algorithm, same inputs.
native-cascade : valueC (digitsC 7 ⊕ digitsC 1) ≡ 8
native-cascade = refl

-- The two agree ON THE NOSE, not merely along `transport-+-is-⊕`.
-- This is strictly stronger than the proved path and separately falsifiable.
agree-definitionally : transported (digitsC 7) (digitsC 1) ≡ digitsC 7 ⊕ digitsC 1
agree-definitionally = refl

-- The shape used for the scaling measurement: N chained operations.
iterOp : (CanWord → CanWord → CanWord) → ℕ → CanWord
iterOp op zero    = digitsC 0
iterOp op (suc n) = op (iterOp op n) (digitsC 1)

iter-native : valueC (iterOp _⊕_ 20) ≡ 20
iter-native = refl

iter-transported : valueC (iterOp transported 20) ≡ 20
iter-transported = refl
