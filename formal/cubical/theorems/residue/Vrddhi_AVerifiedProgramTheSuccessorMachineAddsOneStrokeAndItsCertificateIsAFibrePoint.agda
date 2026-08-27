{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वृद्धि — increment.  A VERIFIED PROGRAM, AND ITS CERTIFICATE IS A
-- FIBRE POINT.
--
-- A two-rule table for the universal machine of Vishvayantra:
--
--   state 0, reading 1 : write 1, move right, stay in state 0
--   state 0, reading 0 : write 1, stay put,  go to state 1
--
-- State 1 has no rules, so state 1 is halting silence.  On a tape
-- carrying n strokes (unary n) with the head on the first stroke, the
-- machine walks the block, writes one more stroke in the first blank,
-- and halts: it computes the successor.
--
-- THE THEOREM (`increment-correct`): for every n, exactly n+1 steps
-- run the machine from unary n to a halted configuration carrying
-- unary (n+1) — the walked strokes on the left, the new stroke under
-- the head, nothing on the right.  The proof is an induction whose
-- every step the kernel COMPUTES: the invariant is a configuration
-- shape, the step lemma is refl in both of its cases, and the
-- arithmetic is +-zero and +-suc.
--
-- THE POINT (`increment-certificate`): the correctness proof is not
-- beside the run, it IS a point of the kept fibre — the pair
-- (source, proof) inhabits fiber (run (suc n)) (end configuration).
-- A verified program is a program whose fibre point is written down.
------------------------------------------------------------------------

module Vrddhi_AVerifiedProgramTheSuccessorMachineAddsOneStrokeAndItsCertificateIsAFibrePoint where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Foundations.Equiv using (invEq ; fiber)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource

------------------------------------------------------------------------
-- §1  The program and the tape shapes.
------------------------------------------------------------------------

-- The table: walk the strokes right; at the first blank, write a
-- stroke and retire to the silent state.
incr : Code
incr = (0 , 1 , 0 , 1 , right) ∷ (0 , 0 , 1 , 1 , stay) ∷ []

-- n strokes.
ones : ℕ → List ℕ
ones zero    = []
ones (suc n) = 1 ∷ ones n

-- The running shape: k strokes already walked (left), m strokes still
-- ahead (head and right), control in state 0.
mid : ℕ → ℕ → Conf
mid k zero    = 0 , ones k , 0 , []
mid k (suc j) = 0 , ones k , 1 , ones j

-- The start: nothing walked, n strokes ahead.
unary : ℕ → Conf
unary n = mid 0 n

-- The end: n strokes walked, the new stroke under the head, silence.
done : ℕ → Conf
done n = 1 , ones n , 1 , []

------------------------------------------------------------------------
-- §2  The kernel computes each step of the invariant.
------------------------------------------------------------------------

-- One step over a stroke extends the walked block: refl in both cases.
walk-step : (k m : ℕ) → uStep (incr , mid k (suc m)) ≡ (incr , mid (suc k) m)
walk-step k zero    = refl
walk-step k (suc j) = refl

-- The invariant carried to the end of the block.
walk : (k m : ℕ) → run (suc m) (incr , mid k m) ≡ (incr , done (k + m))
walk k zero    i = incr , done (+-zero k (~ i))
walk k (suc j) =
  cong (run (suc j)) (walk-step k j)
  ∙ walk (suc k) j
  ∙ (λ i → incr , done (+-suc k j (~ i)))

------------------------------------------------------------------------
-- §3  The theorem, and the certificate as a fibre point.
------------------------------------------------------------------------

-- The successor machine is correct: n+1 steps from unary n reach the
-- halted configuration carrying unary (n+1).
increment-correct : (n : ℕ) → run (suc n) (incr , unary n) ≡ (incr , done n)
increment-correct n = walk 0 n

-- The end really is silence: state 1 addresses no rule.
done-halts : (n : ℕ) → Halted (incr , done n)
done-halts n = refl

-- THE POINT.  The correctness certificate inhabits the kept fibre of
-- the completed run: a verified program is a program whose fibre
-- point is written down.
increment-certificate : (n : ℕ) → fiber (run (suc n)) (incr , done n)
increment-certificate n = (incr , unary n) , increment-correct n

-- And the lossless run reads the source back out of the certificate,
-- definitionally: reverse execution of the verified program is a
-- projection.
increment-reversed : (n : ℕ) →
  invEq (run-lossless (suc n)) ((incr , done n) , increment-certificate n)
    ≡ (incr , unary n)
increment-reversed n = refl
