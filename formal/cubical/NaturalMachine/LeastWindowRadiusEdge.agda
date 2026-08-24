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

module NaturalMachine.LeastWindowRadiusEdge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp×)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; isProp≤ ; ≤Dec ; <Dec)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

import LiftingFiberResidue as LFR
import NaturalMachine.LeastWitnessFactory as LWF
import NaturalMachine.RadiusTransferCompiler as RTC

private
  variable
    A B : Type₀

dec× : Dec A → Dec B → Dec (A × B)
dec× (yes a) (yes b) = yes (a , b)
dec× (yes _) (no ¬b) = no (λ ab → ¬b (snd ab))
dec× (no ¬a) _ = no (λ ab → ¬a (fst ab))

module _
  (PP : ℕ → ℕ → Type₀)
  (isPropPP : (center radius : ℕ) → isProp (PP center radius))
  (decPP : (center radius : ℕ) → Dec (PP center radius))
  where

  WindowPredicate :
    (bound : ℕ → ℕ) (target center later : ℕ) → Type₀
  WindowPredicate bound target center later =
    (center < later) × (later ≤ bound center) × PP later target

  MereBoundedWindowHit :
    (bound : ℕ → ℕ) (source target : ℕ) → Type₀
  MereBoundedWindowHit bound source target =
    (center : ℕ) → PP center source →
    LWF.MereWitness (WindowPredicate bound target center)

  window-isProp :
    (bound : ℕ → ℕ) (target center later : ℕ) →
    isProp (WindowPredicate bound target center later)
  window-isProp bound target center later =
    isProp× isProp≤ (isProp× isProp≤ (isPropPP later target))

  window? :
    (bound : ℕ → ℕ) (target center later : ℕ) →
    Dec (WindowPredicate bound target center later)
  window? bound target center later =
    dec× (<Dec center later)
      (dec× (≤Dec later (bound center)) (decPP later target))

  edgeOfMereWindow :
    {source target : ℕ} (bound : ℕ → ℕ) →
    MereBoundedWindowHit bound source target →
    RTC.BoundedEdge PP source target
  edgeOfMereWindow {target = target} bound hit = record
    { bound = bound
    ; advances = advance
    }
    where
    advance :
      (center : ℕ) → PP center _ →
      Σ[ later ∈ ℕ ]
        (center < later) × (later ≤ bound center) × PP later target
    advance center source-pair = later , evidence
      where
      selected =
        LWF.leastSelector
          (window-isProp bound target center)
          (window? bound target center)
          (hit center source-pair)

      later : ℕ
      later = fst selected

      evidence : WindowPredicate bound target center later
      evidence = fst (snd selected)

DoubleNegationLiftBoundary : (ℓ : Level) → Type (ℓ-suc ℓ)
DoubleNegationLiftBoundary = LFR.LiftDNS

double-negation-lift-implies-LEM :
  (ℓ : Level) → DoubleNegationLiftBoundary ℓ → LFR.LEM ℓ
double-negation-lift-implies-LEM ℓ = LFR.liftDNS→LEM
