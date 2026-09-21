{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SubsetSumCostLocus
--
-- An honest attempt to run the "answer is a projection" mode on a
-- concrete NP-complete problem: SUBSET-SUM. weights `xs`, target `t`;
-- a witness is a selection mask `sel`; the instance is solvable iff some
-- mask's selected sum equals `t`.
--
-- What compiles, checked --safe:
--
--  · VERIFY is a projection over the input. `selSum` is a linear fold and
--    `verify?` decides `selSum xs sel ≡ t` in one pass — O(input). Given a
--    witness, checking is cheap and total.
--
--  · The WITNESS SPACE deciding must range over has size 2^n. `masks n`
--    enumerates every selection of length n, and `count-masks` proves
--    `length (masks n) ≡ 2 ^ n` — checked. The witness is NOT a projection
--    of `(xs , t)`; it is a point of this exponential fibre.
--
-- So on a concrete NP instance the two halves separate exactly: verifying
-- a handed witness is linear; obtaining one ranges over 2^n. This module
-- does NOT exhibit an O(input+output) decider — none is written, because
-- the witness is not recoverable from the instance by projection. It marks,
-- in checked code, the precise locus of the cost.
------------------------------------------------------------------------

module SubsetSumCostLocus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; discreteℕ ; +-zero)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length ; _++_ ; length++)
open import Cubical.Data.Sigma using (Σ ; _,_)
open import Cubical.Relation.Nullary using (Dec)

------------------------------------------------------------------------
-- §1  Verify : a linear fold = a projection over the input.
------------------------------------------------------------------------

-- sum of the weights the mask selects
selSum : List ℕ → List Bool → ℕ
selSum []       _            = 0
selSum (x ∷ xs) (true  ∷ bs) = x + selSum xs bs
selSum (x ∷ xs) (false ∷ bs) = selSum xs bs
selSum (x ∷ xs) []           = 0

-- verification of a candidate witness, decided in one pass
Verify : List ℕ → ℕ → List Bool → Type
Verify xs t sel = selSum xs sel ≡ t

verify? : (xs : List ℕ) (t : ℕ) (sel : List Bool) → Dec (Verify xs t sel)
verify? xs t sel = discreteℕ (selSum xs sel) t

------------------------------------------------------------------------
-- §2  Solvability : an existential over the witness space.
------------------------------------------------------------------------

Solvable : List ℕ → ℕ → Type
Solvable xs t = Σ (List Bool) (Verify xs t)

------------------------------------------------------------------------
-- §3  The witness space has size 2^n.  This is the fibre the decider
--     must inhabit, and it is not a projection of the instance.
------------------------------------------------------------------------

-- 2 to the n
pow2 : ℕ → ℕ
pow2 zero    = 1
pow2 (suc n) = 2 · pow2 n

-- prepend a fixed bit to every mask in a list
prepend : Bool → List (List Bool) → List (List Bool)
prepend b []       = []
prepend b (m ∷ ms) = (b ∷ m) ∷ prepend b ms

-- every selection mask of length n
masks : ℕ → List (List Bool)
masks zero    = [] ∷ []
masks (suc n) = prepend true (masks n) ++ prepend false (masks n)

private
  len-prepend : (b : Bool) (ms : List (List Bool)) → length (prepend b ms) ≡ length ms
  len-prepend b []       = refl
  len-prepend b (m ∷ ms) = cong suc (len-prepend b ms)

  two-k : (k : ℕ) → k + k ≡ 2 · k
  two-k k = cong (k +_) (sym (+-zero k))

  len-masks : (n : ℕ) → length (masks n) ≡ pow2 n
  len-masks zero    = refl
  len-masks (suc n) =
      length++ (prepend true (masks n)) (prepend false (masks n))
    ∙ cong₂ _+_ (len-prepend true (masks n)) (len-prepend false (masks n))
    ∙ cong (λ k → k + k) (len-masks n)
    ∙ two-k (pow2 n)

-- THE COST LOCUS : verifying a witness is one linear pass (§1); the space
-- a decider must range over to FIND one has size 2^n.
count-masks : (n : ℕ) → length (masks n) ≡ pow2 n
count-masks = len-masks
