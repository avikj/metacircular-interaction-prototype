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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExhaustionIsSystematic
--
-- CORRECTION TO `PowModHasTheSameShape` §1, which said the criterion
-- "finds one more — and only one".  It finds at least nine, and the
-- reason it looked like one is that the earlier search read top-level
-- SIGNATURES containing the word `fuel`.  The fuelled functions in this
-- corpus mostly take their fuel unnamed and untyped, so that search was
-- looking for the property it had just proved invisible.
--
-- Per the standing rule the earlier file is not edited; this one carries
-- the correction, and it is a substantive one — the phenomenon is
-- systematic, not a pair of anecdotes.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE EXHAUSTION BRANCHES ACTUALLY LOOK LIKE
--
--   TransmissionRefutations  gcdF zero a _ = a        (right when b ≡ 0)
--                            quoF zero _ _ = zero     (right when n < d)
--                            remF zero n _ = n        (right when n < d)
--                            spfF zero _ n = n        (right when n prime)
--   SieveFiber               divF zero d n = zero     (right when n < d)
--                            modF zero d n = n        (right when n < d)
--                            omegaF zero d n = zero   (right when no factor)
--   Gamma0Index              gcdF zero a b = a        (right when b ≡ 0)
--   HeadDepthMerge           powMod zero m b e = 1 %% m  (right when e ≡ 0)
--
-- EVERY ONE of them defaults, on exhaustion, to a value that is also a
-- legitimate output.  That is not carelessness — it is forced.  A total
-- function into ℕ must return SOME natural number when the fuel runs
-- out, and every natural number is a legitimate output of some call.
-- The default is unavoidable and the collision follows from it.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THE CHEAP SURROGATE FAILS TOO
--
-- The obvious escape is to test convergence instead of correctness:
-- "did one more unit of fuel change the answer?"  For the subtractive
-- loops it works.  For `powMod` it does not, and the reason is the
-- halving recursion:
--
--     powMod 1 7 2 4  ≡  1  ≡  powMod 2 7 2 4     while 2⁴ mod 7 = 2
--
-- Exhaustion there is STABLE ACROSS A STEP.  So the site below uses
-- correctness against `power b e %% m` for `powMod`, and one-step
-- stability for the subtractive ones — each instance takes the sharpest
-- test available, and the packaging is what makes them one shape.
--
-- ────────────────────────────────────────────────────────────────────
-- OWNERSHIP
--
-- `TransmissionRefutations`, `SieveFiber`, `HeadDepthMerge` are other
-- identities' files.  They are imported and not edited.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ExhaustionIsSystematic where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Agda.Builtin.Nat using (_==_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.TranscriptDescent using (collisionObstructsDecoder)

import HeadDepthMerge as HDM
import NaturalMachine.TransmissionRefutations as TR
import NaturalMachine.SieveFiber as SF

------------------------------------------------------------------------
-- 1.  The shape, once
------------------------------------------------------------------------

module Site {X : Type} (run : ℕ → X → ℕ) (good : ℕ → X → Bool) where

  Inputs : Type
  Inputs = ℕ × X

  value : Inputs → ℕ
  value (f , x) = run f x

  status : Inputs → Bool
  status (f , x) = good f x

  -- one bad call and one good call returning the same number is already
  -- an obstruction to every decoder on the returned number
  site : (a b : Inputs)
       → value a ≡ value b
       → status a ≡ false
       → status b ≡ true
       → ¬ FactorsThrough value status
  site a b same aBad bGood =
    collisionObstructsDecoder value status {x = a} {x' = b}
      same
      (λ p → true≢false (sym bGood ∙ sym p ∙ aBad))

------------------------------------------------------------------------
-- 2.  HeadDepthMerge.powMod — correctness against the exact power
------------------------------------------------------------------------

module PowMod where

  run : ℕ → (ℕ × (ℕ × ℕ)) → ℕ
  run f (m , b , e) = HDM.powMod f m b e

  good : ℕ → (ℕ × (ℕ × ℕ)) → Bool
  good f (m , b , e) = HDM.powMod f m b e == (HDM.power b e HDM.%% m)

  open Site run good public

  bad : Inputs
  bad = (1 , 7 , 2 , 4)          -- exhausted; returns 1, answer is 2

  ok : Inputs
  ok = (40 , 7 , 2 , 0)          -- correct; 2⁰ mod 7 really is 1

  same : value bad ≡ value ok
  same = refl

  bad-wrong : status bad ≡ false
  bad-wrong = refl

  ok-right : status ok ≡ true
  ok-right = refl

  obstruction : ¬ FactorsThrough value status
  obstruction = site bad ok same bad-wrong ok-right

  -- and the cheap surrogate does not save it: one more unit of fuel
  -- changes nothing while the answer is still wrong
  stable-but-wrong : HDM.powMod 1 7 2 4 ≡ HDM.powMod 2 7 2 4
  stable-but-wrong = refl

  true-answer : (HDM.power 2 4 HDM.%% 7) ≡ 2
  true-answer = refl

------------------------------------------------------------------------
-- 3.  TransmissionRefutations.remF — one-step stability
------------------------------------------------------------------------

module RemF where

  run : ℕ → (ℕ × ℕ) → ℕ
  run f (n , d) = TR.remF f n d

  good : ℕ → (ℕ × ℕ) → Bool
  good f (n , d) = TR.remF f n d == TR.remF (suc f) n d

  open Site run good public

  bad : Inputs
  bad = (0 , 3 , 2)              -- exhausted; returns 3, next fuel gives 1

  ok : Inputs
  ok = (5 , 3 , 4)               -- 3 < 4, so 3 is the remainder, settled

  same : value bad ≡ value ok
  same = refl

  bad-wrong : status bad ≡ false
  bad-wrong = refl

  ok-right : status ok ≡ true
  ok-right = refl

  obstruction : ¬ FactorsThrough value status
  obstruction = site bad ok same bad-wrong ok-right

------------------------------------------------------------------------
-- 4.  SieveFiber.divF — one-step stability, and the default is `zero`
------------------------------------------------------------------------

module DivF where

  run : ℕ → (ℕ × ℕ) → ℕ
  run f (d , n) = SF.divF f d n

  good : ℕ → (ℕ × ℕ) → Bool
  good f (d , n) = SF.divF f d n == SF.divF (suc f) d n

  open Site run good public

  bad : Inputs
  bad = (0 , 2 , 3)              -- exhausted; returns 0, next fuel gives 1

  ok : Inputs
  ok = (5 , 4 , 3)               -- 3 < 4, so the quotient really is 0

  same : value bad ≡ value ok
  same = refl

  bad-wrong : status bad ≡ false
  bad-wrong = refl

  ok-right : status ok ≡ true
  ok-right = refl

  obstruction : ¬ FactorsThrough value status
  obstruction = site bad ok same bad-wrong ok-right

------------------------------------------------------------------------
-- 5.  What is now established, and what is not.
--
-- ESTABLISHED.  Three subsystems, three hands, one shape, each with a
-- computed pair of calls: `¬ FactorsThrough value status`.  Together
-- with §1's reading of six further exhaustion branches, the conclusion
-- is that this is a property of the return type, not of any author.
-- A fuelled function into bare ℕ MUST pick a default, the default is
-- always someone's legitimate answer, and so the returned number can
-- never report its own adequacy.
--
-- NOT ESTABLISHED.  That any of these functions is called outside its
-- adequate range anywhere in this repository.  Six of the nine are read
-- from their exhaustion branches only and have no collision computed
-- here.  Nothing in this file evaluates any author's range claim; it
-- shows only that such claims are load-bearing and cannot be replaced
-- by inspecting results.
--
-- THE REPAIR is unchanged from the first two sites and is the shape the
-- rest of this corpus already uses: take the budget as a hypothesis and
-- return a Σ.  `factorise-fuel`, `primeDivisor-fuel`, `pFree-fuel`,
-- `decay-fuel` and `WalkJumps.strip` all do, and none of them needed a
-- theorem, because for them there is nothing left to prove.
------------------------------------------------------------------------
