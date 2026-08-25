{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AscendingFirstIsTheWorstUnlessTheArchiveIsConstant
--
-- `notes/DARWIN_GODEL_MATH.md` §2 lists four paper/code seams "that a
-- derivative must not silently inherit".  Seam 3 reads:
--
--   "The otherwise unreachable/programmatic `best` branch sorts accuracy
--    in ascending order and selects the first nodes, despite its comment
--    saying it selects the best score."
--
-- Stated that way it is a bug report.  What it is mathematically is a
-- statement about WHEN the two selections agree, and that is the thing
-- worth knowing, because it says when the seam is observable at all.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   lowerAndUpperForcesConstant
--       a score that is both a lower and an upper bound of the archive
--       forces EVERY score to equal it — so "first of ascending" and
--       "best" coincide only on a constant archive
--   nonConstantMakesTheLowestStrictlyWorse
--       and as soon as one score differs from the lower bound, the
--       selection has passed over an element that is ≥ it and unequal
--   twoScoresAlreadySeparateThem
--       1 ∷ 2 ∷ [] : lower bound 1, upper bound 2, and ¬ (1 ≡ 2)
--   theSeamIsInvisibleExactlyWhereSelectionIsVacuous
--       the two halves packaged as the dichotomy they are
--
-- **The seam is invisible exactly where the selection is vacuous.**  On
-- a constant archive ascending-first and best return the same score —
-- and on a constant archive, choosing a parent BY score carries no
-- information.  So there is no regime in which the branch is both
-- correct and doing work: it agrees with its comment only when the
-- comment describes nothing.  That is sharper than "the sort is
-- backwards", and it is why the seam is not cosmetic.
--
-- ────────────────────────────────────────────────────────────────────
-- GRADE, and it is the whole caveat.  **I DID NOT READ THE CODE.**
-- §2's own header restricts its observations to one pinned commit of an
-- external repository, and this repository's egress rules mean I did
-- not fetch it: no request to github.com was made.  What is checked
-- below is the ORDER-THEORETIC CONTENT OF §2'S SENTENCE, on the
-- assumption that the sentence describes the branch correctly.  If §2
-- has misread the code, nothing here is affected and nothing here
-- defends §2 — the theorem is about ascending selection versus maximal
-- selection and would stand if the branch did not exist.
--
-- NO NOVELTY.  That a minimum and a maximum coincide only on a constant
-- list is elementary order theory; it is here to be ATTACHED to §2, not
-- because it is new.
--
-- WHAT IS NOT CLAIMED.  No sorting algorithm appears — the argument is
-- entirely about bounds, so nothing depends on how the ascending order
-- is produced or on its stability.  Nothing is claimed about the other
-- three seams: the missing perfect-score exclusion, the adjacent string
-- literals Python concatenates, and who reads the logs are not
-- order-theoretic and are untouched.  Scores are ℕ here; §2's are
-- accuracies, and no claim is made that they are linearly ordered
-- without ties or that ties break the same way.  "Selects the first
-- nodeS" is plural and this treats the BOUND, not the prefix — a
-- prefix statement would need the sort.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.AscendingFirstIsTheWorstUnlessTheArchiveIsConstant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; injSuc ; znots)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-antisym ; ≤-suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Bounds, as recursive families
------------------------------------------------------------------------

All : (P : ℕ → Type) → List ℕ → Type
All P []       = Unit
All P (x ∷ xs) = P x × All P xs

Any : (P : ℕ → Type) → List ℕ → Type
Any P []       = ⊥
Any P (x ∷ xs) = P x ⊎ Any P xs

Lower Upper : ℕ → List ℕ → Type
Lower b xs = All (b ≤_) xs
Upper b xs = All (_≤ b) xs

------------------------------------------------------------------------
-- 2.  The two selections coincide only on a constant archive
------------------------------------------------------------------------

lowerAndUpperForcesConstant :
  (b : ℕ) (xs : List ℕ) → Lower b xs → Upper b xs → All (_≡ b) xs
lowerAndUpperForcesConstant b []       _          _          = tt
lowerAndUpperForcesConstant b (x ∷ xs) (lo , los) (hi , his) =
  ≤-antisym hi lo , lowerAndUpperForcesConstant b xs los his

------------------------------------------------------------------------
-- 3.  And where it is not constant, the lowest is strictly passed over
------------------------------------------------------------------------

nonConstantMakesTheLowestStrictlyWorse :
  (b : ℕ) (xs : List ℕ) → Lower b xs → Any (λ x → ¬ (b ≡ x)) xs
  → Σ[ x ∈ ℕ ] ((b ≤ x) × (¬ (b ≡ x)))
nonConstantMakesTheLowestStrictlyWorse b []       _          e       = ⊥.rec e
nonConstantMakesTheLowestStrictlyWorse b (x ∷ xs) (lo , _)   (inl ne) = x , (lo , ne)
nonConstantMakesTheLowestStrictlyWorse b (x ∷ xs) (_  , los) (inr a)  =
  nonConstantMakesTheLowestStrictlyWorse b xs los a

------------------------------------------------------------------------
-- 4.  Two scores already separate them
------------------------------------------------------------------------

scores : List ℕ
scores = 1 ∷ 2 ∷ []

lowestIsOne : Lower 1 scores
lowestIsOne = ≤-refl , (≤-suc ≤-refl , tt)

bestIsTwo : Upper 2 scores
bestIsTwo = ≤-suc ≤-refl , (≤-refl , tt)

oneIsNotTwo : ¬ (1 ≡ 2)
oneIsNotTwo e = znots (injSuc e)

twoScoresAlreadySeparateThem :
  (Lower 1 scores) × (Upper 2 scores) × (¬ (1 ≡ 2))
twoScoresAlreadySeparateThem = lowestIsOne , bestIsTwo , oneIsNotTwo

------------------------------------------------------------------------
-- 5.  The dichotomy, packaged
------------------------------------------------------------------------

theSeamIsInvisibleExactlyWhereSelectionIsVacuous :
  (b : ℕ) (xs : List ℕ) → Lower b xs
  → (Upper b xs → All (_≡ b) xs)
  × (Any (λ x → ¬ (b ≡ x)) xs → Σ[ x ∈ ℕ ] ((b ≤ x) × (¬ (b ≡ x))))
theSeamIsInvisibleExactlyWhereSelectionIsVacuous b xs lo =
    lowerAndUpperForcesConstant b xs lo
  , nonConstantMakesTheLowestStrictlyWorse b xs lo
