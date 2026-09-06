{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ANonEmptyArchiveHasANonEmptyStratum
--
-- `TheParetoStratumIsDecidableAndTheFilterIsExact` computed the maximal
-- layer and closed with two admissions:
--
--   "No claim is made that the stratum is non-empty: for the empty
--    archive it is empty, and for a non-empty archive non-emptiness
--    needs an argument this module does not make."
--
-- and, separately, that one STRATUM is not a STRATIFICATION.  The first
-- is discharged here.  The second is not, and stays named.
--
-- Non-emptiness is not decoration.  DARWIN §5.2's controller "first
-- selects a Pareto stratum S" and then samples inside it; a stratum
-- that could be empty is a selection step that could have nothing to
-- sample from, which is a live failure mode for a scheduler and not a
-- pedantic gap.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ⊏-irrefl            nothing strictly dominates itself
--   ⊏-trans             strict domination is transitive — needed, and
--                       NOT implied by `≼-trans` alone: the negative
--                       half is what does the work
--   anyMap              a pointwise implication maps over `Any`
--   maximalExists       EVERY non-empty archive has a member that is
--                       Pareto-maximal in it, by list induction with a
--                       decision at each step
--   stratumIsNonEmpty   hence the computed stratum of a non-empty
--                       archive has a member
--
-- The induction is the whole content: given a maximal `m` of the tail,
-- DECIDE whether `m` strictly dominates the head.  If not, `m` is still
-- maximal.  If it does, the HEAD is maximal — because anything beating
-- the head would beat `m` by transitivity, contradicting `m`'s
-- maximality.  That second branch is why `⊏-trans` is needed at all.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  "A finite non-empty set has a maximal element for a
-- decidable partial order" is elementary; it is proved here because the
-- previous module named its absence, and because the constructive proof
-- needs the decision that module supplies rather than excluded middle.
--
-- THE SCOPE, EXACTLY.  A STRATIFICATION.  Removing the layer and
-- repeating needs a termination argument on the archive's length, and
-- nothing here iterates — that admission survives this cycle intact.
-- No claim about the SIZE of the stratum, nor that it is the set of ALL
-- maximal elements up to duplication (`filterDec` keeps multiplicity).
-- `maximalExists` produces ONE maximal element, not all of them, and no
-- claim is made that the one produced is canonical — it depends on the
-- list's order.  Costs are still unflipped: §5.2's wall time, tokens
-- and dollars are to be MINIMISED and no coordinate is negated
-- anywhere on this line.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ANonEmptyArchiveHasANonEmptyStratum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_≼_ ; ≼-refl ; ≼-trans)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; IsParetoMaximal ; decStrictlyDominates
        ; stratum ; stratumKeepsEveryMaximal)

------------------------------------------------------------------------
-- 1.  Strict domination is irreflexive and transitive
--
-- Transitivity is not inherited from `≼-trans`: the negative component
-- has to be argued, and it is where the antisymmetric shape of `≼`
-- would otherwise be missed.
------------------------------------------------------------------------

⊏-irrefl : (v : List ℕ) → ¬ StrictlyDominates v v
⊏-irrefl v (_ , ¬le) = ¬le (≼-refl v)

⊏-trans :
  (u v w : List ℕ)
  → StrictlyDominates u v → StrictlyDominates v w → StrictlyDominates u w
⊏-trans u v w (uv , ¬vu) (vw , ¬wv) =
  ≼-trans u v w uv vw , λ wu → ¬wv (≼-trans w u v wu uv)

------------------------------------------------------------------------
-- 2.  Any is functorial in the predicate
------------------------------------------------------------------------

anyMap :
  {A : Type} {P Q : A → Type}
  → ((a : A) → P a → Q a) → (xs : List A) → Any P xs → Any Q xs
anyMap f []       e       = ⊥.rec e
anyMap f (x ∷ xs) (inl p) = inl (f x p)
anyMap f (x ∷ xs) (inr a) = inr (anyMap f xs a)

------------------------------------------------------------------------
-- 3.  Every non-empty archive has a maximal member
------------------------------------------------------------------------

maximalExists :
  (x : List ℕ) (xs : List (List ℕ))
  → Σ[ m ∈ List ℕ ]
      ((Any (λ y → y ≡ m) (x ∷ xs)) × IsParetoMaximal m (x ∷ xs))
maximalExists x [] =
  x , (inl refl , λ where (inl sd) → ⊏-irrefl x sd)
maximalExists x (y ∷ ys) with maximalExists y ys
... | (m , (mem , max)) with decStrictlyDominates m x
...   | no ¬beat = m , (inr mem , λ where
                          (inl sd)  → ¬beat sd
                          (inr rest) → max rest)
...   | yes beat = x , (inl refl , λ where
                          (inl sd)   → ⊏-irrefl x sd
                          (inr rest) →
                            max (anyMap (λ w xw → ⊏-trans m x w beat xw)
                                        (y ∷ ys) rest))

------------------------------------------------------------------------
-- 4.  Hence the computed stratum is non-empty
------------------------------------------------------------------------

stratumIsNonEmpty :
  (x : List ℕ) (xs : List (List ℕ))
  → Σ[ m ∈ List ℕ ] Any (λ y → y ≡ m) (stratum (x ∷ xs))
stratumIsNonEmpty x xs with maximalExists x xs
... | (m , (mem , max)) =
  m , stratumKeepsEveryMaximal (x ∷ xs) m mem max

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "A STRATIFICATION.  Removing the layer and repeating needs a
--    termination argument on the archive's length, and nothing here
--    iterates."
--
-- The termination argument is the DECREASING MEASURE, and it is built
-- in
-- `TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   filterOut / partitionLength   the filter and its complement
--                                 PARTITION the list, so their lengths
--                                 sum to the whole
--   memberMakesItNonEmpty
--   nonEmptyFilterShortensTheComplement
--   theRemainderIsStrictlyShorter instantiated at the Pareto stratum,
--                                 USING `stratumIsNonEmpty` above
--
-- THE DEPENDENCY CHAIN IS THREE CYCLES DEEP AND NONE OF IT COULD HAVE
-- BEEN TAKEN IN ANOTHER ORDER: decidability of the order gave a
-- computable stratum; the computable stratum plus a decision gave
-- non-emptiness CONSTRUCTIVELY; non-emptiness gives the strict
-- decrease.  Each cycle's output was the next cycle's only route.
--
-- STILL NOT CLAIMED, and the remainder is now smaller and sharper: THE
-- ITERATION IS NOT WRITTEN.  No `strata` function exists, fuelled or
-- well-founded, and nothing claims the layers it would produce cover
-- the archive, are pairwise disjoint, or are ordered by domination.
-- What was missing for a stratification was never the recursion — it
-- was the measure the recursion decreases, and that is now present.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The admission this line has carried since it began —
-- that its theorems are about a vector all of whose coordinates point
-- the same way, while §5.2's objectives include quantities to be
-- MINIMISED — is DISCHARGED for `maximalExists` in
-- `RnaDhana_TheParetoMaximumTransfersToCostCoordinates`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- `mixedMaximalExists` proves that a non-empty archive of MIXED
-- benefit/cost vectors has a member nothing beats, by calling
-- `maximalExists` above on the flipped archive and pulling the result
-- back.  Nothing about maximality is re-proved there.
--
-- Two things that cycle established about the price:
--
--   * The bound is needed only in the NEGATIVE half — soundness of the
--     flip is unconditional, and it is turning "the flipped z does not
--     beat the flipped u" back into "z does not beat u" that needs a
--     cap on u.  Since u is a member, an archive-wide bound suffices.
--   * The pull-back cannot go through the flipped element, because the
--     flip is not injective; it goes through `anyMapBack`, which
--     recovers a member of the ORIGINAL archive whose flip is the
--     maximal element found.
--
-- STILL NOT TRANSFERRED: the stratification itself — `strata`,
-- `theStratificationCovers`, `theStrataArePairwiseDisjoint`,
-- `theStrataAreOrdered`.  Those need the peeling run on flipped
-- vectors and pulled back layer by layer, and that is a separate
-- cycle, not a corollary of this one.
------------------------------------------------------------------------
