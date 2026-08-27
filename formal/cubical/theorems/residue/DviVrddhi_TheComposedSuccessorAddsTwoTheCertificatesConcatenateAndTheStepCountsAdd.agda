{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्विवृद्धि — twice-increment.  THE COMPOSED SUCCESSOR ADDS TWO, THE
-- CERTIFICATES CONCATENATE, AND THE STEP COUNTS ADD.
--
-- Samāsa proved that tables compose; Vṛddhi proved one table correct.
-- This file runs the two through each other: the compound of the
-- successor machine with itself computes n ↦ n + 2, and its
-- correctness certificate is MANUFACTURED from the two phase
-- certificates by compose-runs — no new induction over the compound
-- is performed.  The first phase is Vṛddhi's increment-correct; the
-- second phase is two steps the kernel computes outright; the prefix
-- bound is the walk invariant, made pointwise.
--
--   double-increment :
--     run ((n+1) + 2) (incr ⨟ incr) (unary n) carries unary (n+2),
--     halted, for every n.
--
-- Composition of verified programs is itself verified, once, in
-- general — and then instantiated, not re-proved.
------------------------------------------------------------------------

module DviVrddhi_TheComposedSuccessorAddsTwoTheCertificatesConcatenateAndTheStepCountsAdd where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; suc-≤-suc ; zero-≤ ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (tt)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import Vrddhi_AVerifiedProgramTheSuccessorMachineAddsOneStrokeAndItsCertificateIsAFibrePoint
open import Samasa_ProgramsComposeTheSequencedTableRunsItsFirstPhaseThenHandsTheTapeToTheSecondAtTheRetireState
  using (SourcesBelow ; compound ; compose-runs ; addConf)

------------------------------------------------------------------------
-- §1  The walk invariant, pointwise: during phase one the control
--     never leaves state 0.
------------------------------------------------------------------------

walk-prefix : (k j m : ℕ) →
  run k (incr , mid j (k + m)) ≡ (incr , mid (j + k) m)
walk-prefix zero    j m i = incr , mid (+-zero j (~ i)) m
walk-prefix (suc k) j m =
  cong (run k) (walk-step j (k + m))
  ∙ walk-prefix k (suc j) m
  ∙ (λ i → incr , mid (+-suc j k (~ i)) m)

-- The walking shape keeps its control in state 0, whatever remains.
mid-state : (k m : ℕ) → fst (mid k m) ≡ 0
mid-state k zero    = refl
mid-state k (suc j) = refl

-- Every proper prefix of the increment run sits in state 0, below the
-- retire state 1.
incr-bound : (n k : ℕ) → k < suc n →
  fst (snd (run k (incr , unary n))) < 1
incr-bound n k klt =
  subst (λ X → fst (snd X) < 1)
        (sym ( cong (λ x → run k (incr , mid 0 x)) n≡k+j
             ∙ walk-prefix k 0 j ))
        (subst (_< 1) (sym (mid-state k j)) (suc-≤-suc zero-≤))
  where
  kn : k ≤ n
  kn = pred-≤-pred klt

  j : ℕ
  j = fst kn

  n≡k+j : n ≡ k + j
  n≡k+j = sym (snd kn) ∙ +-comm j k

------------------------------------------------------------------------
-- §2  The compound, and its manufactured certificate.
------------------------------------------------------------------------

-- The successor's sources sit below its retire state.
incr-sources : SourcesBelow 1 incr
incr-sources = suc-≤-suc zero-≤ , suc-≤-suc zero-≤ , tt

-- incr ⨟ incr, with the handover at state 1.
twice : Code
twice = compound 1 incr incr incr-sources

-- THE THEOREM.  (n+1) + 2 steps from unary n: the walked strokes, the
-- two new strokes, silence in state 2.  Phase one is Vṛddhi's
-- certificate; phase two is two steps the kernel computes; the
-- compound's certificate is their concatenation through compose-runs,
-- with no induction over the compound itself.
double-increment : (n : ℕ) →
  snd (run (suc n + 2) (twice , unary n)) ≡ (2 , 1 ∷ ones n , 1 , [])
double-increment n =
  compose-runs 1 incr incr incr-sources
    (suc n) (unary n) (ones n , 1 , [])
    (incr-bound n)
    (cong snd (increment-correct n))
    2
