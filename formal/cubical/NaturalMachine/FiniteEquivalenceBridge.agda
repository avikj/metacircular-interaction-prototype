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

------------------------------------------------------------------------
-- A small, proof-relevant bridge from a finite equivalence to its
-- decategorified cardinality equality.
--
-- The equivalence is on the underlying carriers; the FinSet witnesses are
-- propositions, so univalence lifts it to a path of FinSets.  Applying `card`
-- then gives the arithmetic equality.  This is deliberately weaker than a
-- chosen enumeration: it remembers exactly the invariant that cardinality
-- is allowed to retain.
------------------------------------------------------------------------

module NaturalMachine.FiniteEquivalenceBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.FinSet

finite-equivalence-path : {X Y : FinSet ℓ-zero}
  → (X .fst ≃ Y .fst) → X ≡ Y
finite-equivalence-path {X} {Y} e = equivFun (FinSet≡ X Y) (ua e)

card-of-finite-equivalence : {X Y : FinSet ℓ-zero}
  → (X .fst ≃ Y .fst) → card X ≡ card Y
card-of-finite-equivalence {X} {Y} e =
  cong card (finite-equivalence-path {X = X} {Y = Y} e)
