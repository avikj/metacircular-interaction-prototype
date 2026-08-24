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
-- NaturalMachine.PowModHasTheSameShape
--
-- The criterion in `FuelAdequacyIsACollision` found `FrontierList.expOf`
-- retrospectively.  Applied forward across the twenty modules that
-- MENTION fuel or gas, it finds one more — and only one, though see §5
-- for why that search is not exhaustive.  Different subsystem, different
-- hand:
--     HeadDepthMerge.powMod : ℕ → ℕ → ℕ → ℕ → ℕ
--     powMod zero    m b e = 1 %% m          -- exhausted
--     powMod (suc f) m b e = … if e == 0 then 1 %% m …   -- legitimate
--
-- Fuel as bare data, result as bare data — `expOf`'s shape exactly.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUTHOR ALREADY SAW THE SYMPTOM
--
-- `HeadDepthMergeBreaker` §edge records it, and honestly:
--
--     -- powMod fuel exhaustion silently returns 1 %% m: with fuel 1,
--     -- 2^4 mod 7 comes out 1; the true value is 2 …
--     -- In the certified range e ≤ 23^4 − 1 < 2^40 so fuel 40 never
--     -- exhausts, but the wart is real outside it.
--     edge-powMod-fuel-wart : HDM.powMod 1 7 2 4 ≡ 1
--
-- That is a `refl` at one input plus an adequacy claim in prose — the
-- same arrangement `frontier8 = refl` had, found independently, and
-- filed as a caveat about a range rather than as a fact about a type.
-- Nothing here disputes the range claim.  What the criterion adds is
-- that the range claim is the ONLY thing that can save the call site,
-- because no decoder on the returned number can.
--
-- ────────────────────────────────────────────────────────────────────
-- THE COLLISION
--
-- Exhaustion and the legitimate `e ≡ 0` branch return the same
-- expression, `1 %% m`.  So:
--
--     powMod  1 7 2 4  =  1      exhausted; the true value is 2
--     powMod 40 7 2 0  =  1      correct;   2⁰ mod 7 really is 1
--
-- Same returned number, opposite correctness.  Hence
--
--     ¬ FactorsThrough value correct
--
-- and the returned ℕ provably does not tell a caller whether it is the
-- answer.  This is the second site of one phenomenon, not an analogy:
-- the repair below is `FuelAdequacyIsACollision`'s `withK` with the
-- bound replaced by (m , b , e).
--
-- ────────────────────────────────────────────────────────────────────
-- OWNERSHIP
--
-- `HeadDepthMerge` and `HeadDepthMergeBreaker` are another identity's
-- files and are not edited.  This module imports them and adds the
-- theorem beside them, per the repository's standing norm.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PowModHasTheSameShape where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Agda.Builtin.Nat using (_==_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Functions.Image using (Image ; restrictToImage)

import HeadDepthMerge as HDM
open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The call, and what a caller wants to know about it
------------------------------------------------------------------------

Inputs : Type
Inputs = ℕ × (ℕ × (ℕ × ℕ))          -- (fuel , modulus , base , exponent)

value : Inputs → ℕ
value (f , m , b , e) = HDM.powMod f m b e

truth : ℕ → ℕ → ℕ → ℕ
truth m b e = HDM.power b e HDM.%% m

correct : Inputs → Bool
correct (f , m , b , e) = HDM.powMod f m b e == truth m b e

------------------------------------------------------------------------
-- 2.  The two calls, computed
------------------------------------------------------------------------

exhausted : Inputs
exhausted = (1 , 7 , 2 , 4)

legitimate : Inputs
legitimate = (40 , 7 , 2 , 0)

-- the author's own witness, restated in this module's vocabulary
exhausted-value : value exhausted ≡ 1
exhausted-value = refl

legitimate-value : value legitimate ≡ 1
legitimate-value = refl

-- 2⁴ mod 7 = 2, so the exhausted call is wrong; 2⁰ mod 7 = 1, so the
-- other is right
exhausted-truth : truth 7 2 4 ≡ 2
exhausted-truth = refl

legitimate-truth : truth 7 2 0 ≡ 1
legitimate-truth = refl

same-value : value exhausted ≡ value legitimate
same-value = refl

exhausted-wrong : correct exhausted ≡ false
exhausted-wrong = refl

legitimate-right : correct legitimate ≡ true
legitimate-right = refl

different-status : ¬ (correct exhausted ≡ correct legitimate)
different-status p =
  true≢false (sym legitimate-right ∙ sym p ∙ exhausted-wrong)

------------------------------------------------------------------------
-- 3.  THE OBSTRUCTION
------------------------------------------------------------------------

powMod-correctness-does-not-factor : ¬ FactorsThrough value correct
powMod-correctness-does-not-factor =
  collisionObstructsDecoder value correct
    {x = exhausted} {x' = legitimate}
    same-value
    different-status

------------------------------------------------------------------------
-- 4.  THE REPAIR, identical in shape to the first site
------------------------------------------------------------------------

withSpec : Inputs → (ℕ × (ℕ × (ℕ × ℕ)))
withSpec (f , m , b , e) = (m , b , e , HDM.powMod f m b e)

correct-factors : FactorsThrough withSpec correct
correct-factors = decode , law
  where
  decode : Image withSpec → Bool
  decode ((m , b , e , v) , _) = v == truth m b e

  law : (x : Inputs) → decode (restrictToImage withSpec x) ≡ correct x
  law (f , m , b , e) = refl

------------------------------------------------------------------------
-- 5.  What two sites establish that one did not.
--
-- One site is an anecdote about `expOf`.  Two sites, in unrelated
-- subsystems, written by different hands, with the same return-type
-- shape and the same failure — an adequacy claim that lives in a
-- comment because it cannot live in the type — make it a property of
-- the shape.
--
-- The criterion is therefore promoted from an observation to a check
-- worth running: a fuelled function whose fuel is bare data and whose
-- result is bare data has an adequacy obligation that the type system
-- will not carry, and searching for `fuel` will not find it, because
-- the risky ones do not name their fuel parameter.  `expOf` is
-- `ℕ → ℕ → ℕ → ℕ`; `powMod` is `ℕ → ℕ → ℕ → ℕ → ℕ`.  Both are invisible
-- to the obvious grep, which is why both survived.
--
-- Not claimed: that `powMod` is used incorrectly anywhere.  The Breaker
-- states a range in which fuel 40 suffices, and this module does not
-- evaluate that claim — it shows only that the claim is load-bearing
-- and cannot be replaced by inspection of results.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  CORRECTION, appended 2026-08-18.
--
-- §1 above says the criterion "finds one more — and only one".  That is
-- wrong.  It finds at least nine.
--
-- The error is instructive and is exactly the one this pair of files is
-- about.  The search that produced "only one" read top-level SIGNATURES
-- containing the word `fuel`.  But the whole point of the criterion is
-- that the risky functions take their fuel as bare, unnamed data —
-- `expOf : ℕ → ℕ → ℕ → ℕ`, `powMod : ℕ → ℕ → ℕ → ℕ → ℕ` — so that
-- search was looking for the very property it had just proved absent.
-- §5 named this limit and then the next paragraph up violated it.
--
-- The correct search is over bare arrow chains, and it turns up
-- `remF`, `quoF`, `gcdF`, `spfF` (TransmissionRefutations), `divF`,
-- `modF`, `omegaF` (SieveFiber) and `gcdF` (Gamma0Index) alongside these
-- two.  Every one defaults on exhaustion to a value that is also a
-- legitimate output — which is forced, not careless, since a total
-- function into ℕ must return something.
--
-- `NaturalMachine.ExhaustionIsSystematic` carries the corrected claim,
-- the shared packaging, and computed collisions in three subsystems.
-- It also records that the cheap surrogate — "did more fuel change the
-- answer?" — fails for `powMod` itself: exhaustion there is stable
-- across a step, `powMod 1 7 2 4 ≡ powMod 2 7 2 4 ≡ 1`, answer 2.
------------------------------------------------------------------------
