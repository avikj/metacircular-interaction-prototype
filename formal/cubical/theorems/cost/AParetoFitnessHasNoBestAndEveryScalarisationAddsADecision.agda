{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
--
-- 'number of exciting claims'", lists eight objectives, and says the
-- controller "maintains Pareto strata" and samples WITHIN a stratum.
-- The design is stated; the reason it must be that shape is not.
--
-- It is forced, and the two halves are checked here.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ≼-refl / ≼-trans / ≼-antisym
--       the pointwise (product) order on fitness vectors is a partial
--       order — antisymmetry included, so it really is an order and not
--       merely a preorder, unlike the threshold ⊑ elsewhere in this
--       corpus
--   incomparable
--       (2,0) and (0,3) dominate each other in neither direction, so
--       the order is NOT total and "the best node" does not denote
--   sumIsMonotone
--       a scalarisation cannot CONTRADICT dominance …
--   scalarisationDecidesAnIncomparablePair
--       … but it does DECIDE the incomparable pair above: sum says
--       2 < 3 where the objectives say nothing
--   monotoneStrictnessRefutesDominance
--       and generally, for any monotone f, `f v < f w` refutes `w ≼ v`
--       — which is exactly the strength a scalarisation has and no more
--
-- **So a scalar fitness is a strict extension of the objective order,
-- and every such extension is a CHOICE that the objectives do not
-- license.**  That is why §5.2's two-stage shape — pick a stratum, then
-- sample inside it — is not a refinement of "pick the best": there is
-- no best to pick, and any rule that produces one has smuggled in a
-- preference ordering under the name of a measurement.
--
-- CONNECTS TO THE OTHER DARWIN CYCLE.  §2's seam 3, checked in
-- `AscendingFirstIsTheWorstUnlessTheArchiveIsConstant`, is a bug in a
-- branch that assumes a TOTAL order on accuracy.  §5.2 says the fitness
-- is a vector.  Those two facts sit in one note: the seam is in code
-- selecting by a scalar, and the design section says the scalar does not
-- exist.  Nothing here claims the released code implements §5.2 — it
-- does not, §5.2 is this repository's proposed controller — only that
-- the two sections are about the same missing total order.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  The product order, its failure of totality, and the fact
-- that monotone scalarisations are strict extensions are standard
-- multi-objective optimisation, going back to Pareto (`Cours
-- d'économie politique`, 1896) and Edgeworth before him; the Agda is
-- attached to §5.2, not discovered.
--
-- SYĀT — THE CLAIM, EXACTLY.  Vectors are `List ℕ` and the order is only
-- defined between lists of equal length — mismatched lengths are `⊥`
-- rather than an error, and no length index appears (no `Fin`, the
-- standing idiom here).  §5.2's objectives include wall time, tokens,
-- and dollar cost, which are to be MINIMISED; nothing below flips any
-- coordinate, so the theorems are about a vector all of whose
-- coordinates point the same way, and applying them needs the costs
-- negated first.  Real-valued objectives are not modelled — these are
-- ℕ.  Nothing is claimed about `Q_i`, the sampling weights, the
-- exploration mass η, or whether the stratum mixture is well-defined;
-- and no claim is made that a Pareto stratification EXISTS
-- constructively for an arbitrary archive, which would need a decision
-- on `≼` and is not proved here.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-antisym ; ≤-+-≤ ; ¬m<m)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  The product order on fitness vectors
------------------------------------------------------------------------

_≼_ : List ℕ → List ℕ → Type
[]       ≼ []       = Unit
[]       ≼ (_ ∷ _)  = ⊥
(_ ∷ _)  ≼ []       = ⊥
(x ∷ xs) ≼ (y ∷ ys) = (x ≤ y) × (xs ≼ ys)

≼-refl : (v : List ℕ) → v ≼ v
≼-refl []       = tt
≼-refl (x ∷ xs) = ≤-refl , ≼-refl xs

≼-trans : (u v w : List ℕ) → u ≼ v → v ≼ w → u ≼ w
≼-trans []       []       []       _          _          = tt
≼-trans (x ∷ xs) (y ∷ ys) (z ∷ zs) (le , les) (le' , les') =
  ≤-trans le le' , ≼-trans xs ys zs les les'

≼-antisym : (v w : List ℕ) → v ≼ w → w ≼ v → v ≡ w
≼-antisym []       []       _          _          = refl
≼-antisym (x ∷ xs) (y ∷ ys) (le , les) (ge , ges) =
  cong₂ _∷_ (≤-antisym le ge) (≼-antisym xs ys les ges)

------------------------------------------------------------------------
-- 2.  It is not total, so "the best node" does not denote
------------------------------------------------------------------------

yieldFirst costFirst : List ℕ
yieldFirst = 2 ∷ 0 ∷ []
costFirst  = 0 ∷ 3 ∷ []

¬2≤0 : ¬ (2 ≤ 0)
¬2≤0 (k , e) = snotz (sym (+-comm k 2) ∙ e)

¬3≤0 : ¬ (3 ≤ 0)
¬3≤0 (k , e) = snotz (sym (+-comm k 3) ∙ e)

incomparable : (¬ (yieldFirst ≼ costFirst)) × (¬ (costFirst ≼ yieldFirst))
incomparable = (λ p → ¬2≤0 (fst p)) , (λ p → ¬3≤0 (fst (snd p)))

------------------------------------------------------------------------
-- 3.  A scalarisation cannot contradict dominance
------------------------------------------------------------------------

sum : List ℕ → ℕ
sum []       = 0
sum (x ∷ xs) = x + sum xs

sumIsMonotone : (v w : List ℕ) → v ≼ w → sum v ≤ sum w
sumIsMonotone []       []       _          = ≤-refl
sumIsMonotone (x ∷ xs) (y ∷ ys) (le , les) =
  ≤-+-≤ le (sumIsMonotone xs ys les)

-- the general strength of ANY monotone scalarisation, and its limit
monotoneStrictnessRefutesDominance :
  (f : List ℕ → ℕ)
  → ((v w : List ℕ) → v ≼ w → f v ≤ f w)
  → (v w : List ℕ) → f v < f w → ¬ (w ≼ v)
monotoneStrictnessRefutesDominance f mono v w lt dom =
  ¬m<m (≤-trans lt (mono w v dom))

------------------------------------------------------------------------
-- 4.  But it decides a pair the objectives leave undecided
------------------------------------------------------------------------

sumOrdersThem : sum yieldFirst < sum costFirst
sumOrdersThem = 0 , refl

scalarisationDecidesAnIncomparablePair :
    (¬ (yieldFirst ≼ costFirst))
  × (¬ (costFirst ≼ yieldFirst))
  × (sum yieldFirst < sum costFirst)
scalarisationDecidesAnIncomparablePair =
  fst incomparable , snd incomparable , sumOrdersThem

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "it is NOT proved that a Pareto stratification EXISTS
--    constructively for an arbitrary archive, which would need a
--    decision on `≼` and is not proved here."
--
-- The decision is now proved, in
-- `TheParetoStratumIsDecidableAndTheFilterIsExact`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   dec≤ / dec≼            from `splitℕ-≤` alone
--   decStrictlyDominates
--   decIsParetoMaximal     against a finite archive, reusing `decAny`
--   stratum                the maximal layer, as a COMPUTED list
--   stratumOnlyKeepsMaximal / stratumKeepsEveryMaximal
--                          sound and complete, so the computed stratum
--                          and the specified one have the same members
--
-- What that adds to §5.2 is the half this module could not say.  Here:
-- there is no best to pick.  There: the thing §5.2 picks INSTEAD — "the
-- controller first selects a Pareto stratum S" — is constructible, and
-- a controller cannot select what it cannot compute.
--
-- STILL NOT CLAIMED, and the word matters: that is ONE STRATUM, the
-- maximal layer.  A STRATIFICATION is the iterated construction — remove
-- the layer, repeat — and it needs a termination argument on the
-- archive's length that is NOT given; nothing there iterates.  So the
-- sentence quoted above is only half discharged, and the half that
-- remains is the one with the word "stratification" in it.  Also
-- unproved: that the stratum is non-empty for a non-empty archive.
-- `filterDec` preserves multiplicity and order, so a duplicated vector
-- appears twice — `≼`'s antisymmetry is not used to quotient anything.
-- Costs remain unflipped.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "§5.2's objectives include wall time, tokens, and dollar cost,
--    which are to be MINIMISED; nothing below flips any coordinate, so
--    the theorems are about a vector all of whose coordinates point the
--    same way, and applying them needs the costs negated first."
--
-- Every module on this line repeated that sentence, and the min-plus
-- line then showed twice that reversing an order is load-bearing.  So
-- the flip was given its own theorem, in
-- `FlippingACostCoordinateIsSoundButNotFaithful`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
--   Vec ds / Dom ds   vectors over a DIRECTION list, and MIXED
--                     dominance: `≤` at a benefit coordinate, `≥` at a
--                     cost coordinate — what §5.2 actually means
--   ∸-antitone        from the monus adjunction on the min-plus line
--   flipWith cap      `cap ∸ x` at a cost coordinate
--   flipIsSound       mixed dominance IMPLIES ordinary `≼` of the
--                     flipped vectors, so §§1–4 above transfer
--   flipIsNotFaithful and the CONVERSE FAILS: at `cap = 3` the costs
--                     `5` and `7` both flip to `0`
--
-- **The sentence quoted above is half true.**  Flipping suffices to
-- APPLY these theorems — soundness is the only direction that needs.
-- It does NOT suffice to transport a conclusion back, because the cap
-- identifies every cost above it.  The honest form is "negate the
-- costs, and pick a cap above every cost you will ever compare", which
-- is a modelling obligation and not a rewriting step.
--
-- STILL NOT CLAIMED there: the RESTRICTED converse — presumably sound
-- once every cost is `≤ cap` — is not checked, only the unrestricted
-- one refuted.  The cap is one number shared by all cost coordinates.
-- And nothing transports `stratum` or `maximalExists` along the flip;
-- that is a further step.
------------------------------------------------------------------------
