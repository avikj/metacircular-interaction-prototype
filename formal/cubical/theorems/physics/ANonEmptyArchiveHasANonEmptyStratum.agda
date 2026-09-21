{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ANonEmptyArchiveHasANonEmptyStratum
--
-- `TheParetoStratumIsDecidableAndTheFilterIsExact` computed the maximal
-- layer.  For the empty archive it is empty; for a non-empty archive
-- non-emptiness needs an argument, made here.
--
-- Non-emptiness is not decoration.  DARWIN ¬ß5.2's controller "first
-- selects a Pareto stratum S" and then samples inside it; a stratum
-- that could be empty is a selection step that could have nothing to
-- sample from, which is a live failure mode for a scheduler and not a
-- pedantic gap.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ‚ä-irrefl            nothing strictly dominates itself
--   ‚ä-trans             strict domination is transitive ‚î needed, and
--                       NOT implied by `‚âº-trans` alone: the negative
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
-- maximal.  If it does, the HEAD is maximal ‚î because anything beating
-- the head would beat `m` by transitivity, contradicting `m`'s
-- maximality.  That second branch is why `‚ä-trans` is needed at all.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  "A finite non-empty set has a maximal element for a
-- decidable partial order" is elementary; it is proved here because the
-- constructive proof needs the decision
-- `TheParetoStratumIsDecidableAndTheFilterIsExact` supplies rather than
-- excluded middle.
------------------------------------------------------------------------

module ANonEmptyArchiveHasANonEmptyStratum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_‚âº_ ; ‚âº-refl ; ‚âº-trans)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; IsParetoMaximal ; decStrictlyDominates
        ; stratum ; stratumKeepsEveryMaximal)

------------------------------------------------------------------------
-- 1.  Strict domination is irreflexive and transitive
--
-- Transitivity is not inherited from `‚âº-trans`: the negative component
-- has to be argued, and it is where the antisymmetric shape of `‚âº`
-- would otherwise be missed.
------------------------------------------------------------------------

‚äè-irrefl : (v : List ‚Ñï) ‚Üí ¬¨ StrictlyDominates v v
‚äè-irrefl v (_ , ¬¨le) = ¬¨le (‚âº-refl v)

‚äè-trans :
  (u v w : List ‚Ñï)
  ‚Üí StrictlyDominates u v ‚Üí StrictlyDominates v w ‚Üí StrictlyDominates u w
‚äè-trans u v w (uv , ¬¨vu) (vw , ¬¨wv) =
  ‚âº-trans u v w uv vw , Œª wu ‚Üí ¬¨wv (‚âº-trans w u v wu uv)

------------------------------------------------------------------------
-- 2.  Any is functorial in the predicate
------------------------------------------------------------------------

anyMap :
  {A : Type} {P Q : A ‚Üí Type}
  ‚Üí ((a : A) ‚Üí P a ‚Üí Q a) ‚Üí (xs : List A) ‚Üí Any P xs ‚Üí Any Q xs
anyMap f []       e       = ‚ä•.rec e
anyMap f (x ‚à∑ xs) (inl p) = inl (f x p)
anyMap f (x ‚à∑ xs) (inr a) = inr (anyMap f xs a)

------------------------------------------------------------------------
-- 3.  Every non-empty archive has a maximal member
------------------------------------------------------------------------

maximalExists :
  (x : List ‚Ñï) (xs : List (List ‚Ñï))
  ‚Üí Œ£[ m ‚àà List ‚Ñï ]
      ((Any (Œª y ‚Üí y ‚â° m) (x ‚à∑ xs)) √ó IsParetoMaximal m (x ‚à∑ xs))
maximalExists x [] =
  x , (inl refl , Œª where (inl sd) ‚Üí ‚äè-irrefl x sd)
maximalExists x (y ‚à∑ ys) with maximalExists y ys
... | (m , (mem , max)) with decStrictlyDominates m x
...   | no ¬¨beat = m , (inr mem , Œª where
                          (inl sd)  ‚Üí ¬¨beat sd
                          (inr rest) ‚Üí max rest)
...   | yes beat = x , (inl refl , Œª where
                          (inl sd)   ‚Üí ‚äè-irrefl x sd
                          (inr rest) ‚Üí
                            max (anyMap (Œª w xw ‚Üí ‚äè-trans m x w beat xw)
                                        (y ‚à∑ ys) rest))

------------------------------------------------------------------------
-- 4.  Hence the computed stratum is non-empty
------------------------------------------------------------------------

stratumIsNonEmpty :
  (x : List ‚Ñï) (xs : List (List ‚Ñï))
  ‚Üí Œ£[ m ‚àà List ‚Ñï ] Any (Œª y ‚Üí y ‚â° m) (stratum (x ‚à∑ xs))
stratumIsNonEmpty x xs with maximalExists x xs
... | (m , (mem , max)) =
  m , stratumKeepsEveryMaximal (x ‚à∑ xs) m mem max

------------------------------------------------------------------------
-- A STRATIFICATION ‚î removing the layer and repeating ‚î needs a
-- termination argument on the archive's length.  That argument is the
-- DECREASING MEASURE, built in
-- `TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure`:
--
--   filterOut / partitionLength   the filter and its complement
--                                 PARTITION the list, so their lengths
--                                 sum to the whole
--   memberMakesItNonEmpty
--   nonEmptyFilterShortensTheComplement
--   theRemainderIsStrictlyShorter instantiated at the Pareto stratum,
--                                 USING `stratumIsNonEmpty` above
--
-- THE DEPENDENCY CHAIN, WHICH CAN BE TAKEN IN NO OTHER ORDER:
-- decidability of the order gives a computable stratum; the computable
-- stratum plus a decision gives non-emptiness CONSTRUCTIVELY;
-- non-emptiness gives the strict decrease.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- The theorems above are about a vector all of whose coordinates point
-- the same way, while ¬ß5.2's objectives include quantities to be
-- MINIMISED.  `maximalExists` transfers to MIXED vectors in
-- `RnaDhana_TheParetoMaximumTransfersToCostCoordinates`.
--
-- `mixedMaximalExists` proves that a non-empty archive of MIXED
-- benefit/cost vectors has a member nothing beats, by calling
-- `maximalExists` above on the flipped archive and pulling the result
-- back.  Nothing about maximality is re-proved there.
--
-- Two things about the price:
--
--   * The bound is needed only in the NEGATIVE half ‚î soundness of the
--     flip is unconditional, and it is turning "the flipped z does not
--     beat the flipped u" back into "z does not beat u" that needs a
--     cap on u.  Since u is a member, an archive-wide bound suffices.
--   * The pull-back cannot go through the flipped element, because the
--     flip is not injective; it goes through `anyMapBack`, which
--     recovers a member of the ORIGINAL archive whose flip is the
--     maximal element found.
------------------------------------------------------------------------
