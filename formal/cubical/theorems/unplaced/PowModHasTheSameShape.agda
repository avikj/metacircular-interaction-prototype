{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PowModHasTheSameShape
--
-- The criterion in `FuelAdequacyIsACollision` found `FrontierList.expOf`
-- retrospectively.  Applied forward across the corpus it finds at least
-- nine more, listed in `ExhaustionIsSystematic`.  Different subsystem,
-- different hand:
--     HeadDepthMerge.powMod : ℕ → ℕ → ℕ → ℕ → ℕ
--     powMod zero    m b e = 1 %% m          -- exhausted
--     powMod (suc f) m b e = … if e == 0 then 1 %% m …   -- legitimate
--
-- Fuel as bare data, result as bare data — `expOf`'s shape exactly.
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
------------------------------------------------------------------------

module PowModHasTheSameShape where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Agda.Builtin.Nat using (_==_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Functions.Image using (Image ; restrictToImage)

import HeadDepthMerge as HDM
open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

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
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  THE FULL LIST.
--
-- A search over top-level SIGNATURES containing the word `fuel` finds
-- only these two.  The whole point of the criterion is
-- that the risky functions take their fuel as bare, unnamed data —
-- `expOf : ℕ → ℕ → ℕ → ℕ`, `powMod : ℕ → ℕ → ℕ → ℕ → ℕ` — so that
-- search looks for the very property §5 proves absent.
--
-- The search over bare arrow chains turns up
-- `remF`, `quoF`, `gcdF`, `spfF` (TransmissionRefutations), `divF`,
-- `modF`, `omegaF` (SieveFiber) and `gcdF` (Gamma0Index) alongside these
-- two.  Every one defaults on exhaustion to a value that is also a
-- legitimate output — which is forced, not careless, since a total
-- function into ℕ must return something.
--
-- `ExhaustionIsSystematic` carries the claim,
-- the shared packaging, and computed collisions in three subsystems.
-- It also records that the cheap surrogate — "did more fuel change the
-- answer?" — fails for `powMod` itself: exhaustion there is stable
-- across a step, `powMod 1 7 2 4 ≡ powMod 2 7 2 4 ≡ 1`, answer 2.
------------------------------------------------------------------------
