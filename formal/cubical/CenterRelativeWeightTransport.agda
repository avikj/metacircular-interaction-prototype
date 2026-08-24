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
-- CenterRelativeWeightTransport
--
-- A bounded continuation of notes/CENTER_RELATIVE_CONE.md, successor seed 2.
-- The pair product is transported contravariantly along the checked
-- equivalence Pair ≃ CR.  On the parity sublattice, that transported
-- evaluator is exactly the unique division-free quarter of Q:
--
--   four (nativeWeight y) = Q y.
--
-- No division operation and no divisibility premise are hidden here.  The
-- parity evidence is already part of y : CR, and injectivity is only the
-- checked injectivity of doubling on the integers, used twice.
------------------------------------------------------------------------

module CenterRelativeWeightTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; _+_ ; _·_ ; pos)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

import CenterRelative as CR
import NaturalMachine.EvaluatorTransport as ET

------------------------------------------------------------------------
-- The pair evaluator and its checked contravariant transport
------------------------------------------------------------------------

pairWeight : CR.Pair → ℤ
pairWeight (p , q) = p · q

nativeWeight : CR.CR → ℤ
nativeWeight = ET.transportEvaluator CR.Pair≃CR pairWeight

-- The inverse of the equivalence constructed by CenterRelative is its Ψ.
-- Naming the computation keeps the orientation of evaluator transport
-- visible: an evaluator on Pair becomes an evaluator on CR by precomposition
-- with the inverse, never by forward composition.
nativeWeight-is-Ψ : (y : CR.CR) → nativeWeight y ≡ pairWeight (CR.Ψ y)
nativeWeight-is-Ψ y = refl

nativeWeight-preserves :
  (x : CR.Pair) → nativeWeight (CR.Φ x) ≡ pairWeight x
nativeWeight-preserves =
  ET.transportEvaluator-preserves CR.Pair≃CR pairWeight

-- Conservation on every paired point determines the transported evaluator.
nativeWeight-unique-conserved :
  (f : CR.CR → ℤ)
  → ((x : CR.Pair) → f (CR.Φ x) ≡ pairWeight x)
  → f ≡ nativeWeight
nativeWeight-unique-conserved f preserves =
  ET.transportEvaluator-unique CR.Pair≃CR pairWeight f preserves

------------------------------------------------------------------------
-- Q characterizes the transported evaluator without integer division
------------------------------------------------------------------------

qCR : CR.CR → ℤ
qCR (W , R , _) = CR.Q (W , R)

double : ℤ → ℤ
double z = z + z

four : ℤ → ℤ
four z = double (double z)

-- First orient the sampled module's Q = 4pq theorem on an entire pair.
-- Keeping this path outside a `with Ψ y` refinement is load-bearing: the
-- dependent parity witness in ΦΨ y need not normalize through that split.
pair-quarter : (x : CR.Pair) → four (pairWeight x) ≡ qCR (CR.Φ x)
pair-quarter (p , q) = sym (CR.thm16-8 p q)

-- Now transport the pair law from Φ(Ψ y) to y along the checked round trip.
nativeWeight-quarter : (y : CR.CR) → four (nativeWeight y) ≡ qCR y
nativeWeight-quarter y =
    cong four (nativeWeight-is-Ψ y)
  ∙ pair-quarter (CR.Ψ y)
  ∙ cong qCR (CR.ΦΨ y)

-- Doubling written additively is injective because multiplication by 2 is.
double-injective : (m n : ℤ) → double m ≡ double n → m ≡ n
double-injective m n h = CR.doubleInj m n
  (sym (double-is-two-times m) ∙ h ∙ double-is-two-times n)
  where
  double-is-two-times : (z : ℤ) → double z ≡ pos 2 · z
  double-is-two-times _ = solve! ℤCommRing

-- Hence no second integer-valued evaluator can satisfy the same quarter law.
-- This is double-doubling injectivity, not cancellation in an arbitrary ring.
nativeWeight-unique-quarter :
  (f : CR.CR → ℤ)
  → ((y : CR.CR) → four (f y) ≡ qCR y)
  → f ≡ nativeWeight
nativeWeight-unique-quarter f quarter = funExt λ y →
  double-injective (f y) (nativeWeight y)
    (double-injective (double (f y)) (double (nativeWeight y))
      (quarter y ∙ sym (nativeWeight-quarter y)))
