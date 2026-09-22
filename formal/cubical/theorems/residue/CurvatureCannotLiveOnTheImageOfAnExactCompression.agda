{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CurvatureCannotLiveOnTheImageOfAnExactCompression
--
--   "Exact elimination commutes; compression C can make orders differ:
--    Δ^C_{ij} > 0 is architecture curvature. … Curvature arises only
--    from too-small context families, approximation, dropped witnesses,
--    or incoherent interface updates."
--
-- The second sentence is a LIST OF CAUSES, offered without an argument
-- that the list is exhaustive.  It is, and the argument is short — but
-- it needs the causes to be read as ONE condition, which is what this
-- module supplies.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, for any `C : S → T`, eliminations `f g : S → S` and
-- their compressed counterparts `f' g' : T → T`
--
--   curvatureVanishesOnTheImage
--       if `C` INTERTWINES both steps — `C (f s) ≡ f' (C s)` and the
--       same for `g` — and the uncompressed steps commute, then the
--       compressed steps commute at every `C s`.  NO injectivity, no
--       full abstraction, no surjectivity is used: the two simulation
--       squares and the commuting square are the whole proof.
--
--   curvatureIsOffTheImage
--       hence, contrapositively, a point where the compressed steps
--       FAIL to commute is not `C` of anything.
--
-- **So §36–38's four causes are one cause, split by where it bites.**
-- "Too-small context family" is the image being too small — the
-- curvature sits at a `t` no context reaches.  "Approximation",
-- "dropped witnesses" and "incoherent interface updates" are all the
-- intertwining square failing, i.e. `C (f s) ≢ f' (C s)`.  There is no
-- fifth possibility, because those two hypotheses are everything the
-- proof consumes.  That is a stronger statement than the list, and it
-- says what to check when curvature is observed: FIND THE POINT, and
-- ask whether it is reachable; if it is, one of the two squares is a
-- lie.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  This is the elementary fact that a simulation transports
-- commuting diagrams onto the image; it is the pasting of two squares
-- and is standard in any category.  It is checked here because §36–38
-- states the causal list without it, and because "curvature" invites a
-- geometric reading that suggests the phenomenon is subtler than the
-- pasting.
------------------------------------------------------------------------

module CurvatureCannotLiveOnTheImageOfAnExactCompression where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

module _ {S T : Type}
  (C  : S → T)
  (f  g  : S → S)
  (f' g' : T → T)
  (sf : (s : S) → C (f s) ≡ f' (C s))
  (sg : (s : S) → C (g s) ≡ g' (C s))
  (comm : (s : S) → f (g s) ≡ g (f s))
  where

  ------------------------------------------------------------------
  -- 1.  Two simulation squares and one commuting square paste
  ------------------------------------------------------------------

  curvatureVanishesOnTheImage :
    (s : S) → f' (g' (C s)) ≡ g' (f' (C s))
  curvatureVanishesOnTheImage s =
      cong f' (sym (sg s))
    ∙ sym (sf (g s))
    ∙ cong C (comm s)
    ∙ sg (f s)
    ∙ cong g' (sf s)

  ------------------------------------------------------------------
  -- 2.  So curvature is evidence about REACHABILITY
  ------------------------------------------------------------------

  curvatureIsOffTheImage :
    (t : T) → ¬ (f' (g' t) ≡ g' (f' t)) → ¬ (Σ[ s ∈ S ] C s ≡ t)
  curvatureIsOffTheImage t bent (s , e) =
    bent (subst (λ x → f' (g' x) ≡ g' (f' x))
                e (curvatureVanishesOnTheImage s))

------------------------------------------------------------------------
-- The n-step generalisation is `OrderIndependenceTransfersAlongAnyNumberOfSteps`:
--
--   Step        a step, its compressed counterpart, and the
--               intertwining square, packaged so a LIST carries its own
--               hypotheses
--   simFold     `C (runS ps s) ≡ runT ps (C s)` — intertwining extends
--               to composites, by a one-line induction
--   orderIndependenceTransfers / disagreementIsOffTheImage
--   twoStepsAreAnInstance   §1–2 here, recovered as `p ∷ q ∷ []` versus
--                           `q ∷ p ∷ []`
--
-- **THE GENERALISATION IS CHEAPER THAN THE SPECIAL CASE.**  The proof
-- above pastes a simulation square, the commuting square, and a second
-- simulation square in sequence.  The n-step proof SEPARATES those:
-- `simFold` is pure simulation and knows nothing about commuting, and
-- the commuting hypothesis is used exactly once under a single
-- `cong C`.  Generality removed the interleaving that made this
-- argument look like a chain.
--
-- Every order, not just two: `PairwiseCommutationGivesEveryOrder`.
-- `_~_` is the permutation relation —
-- identity, congruence under `∷`, adjacent transposition, transitivity
-- — and `permInvariant` is the induction, with the transposition case
-- BEING the commutation hypothesis.  `everyOrderAgreesAfterCompression`
-- and `disagreementUnderPermutationIsOffTheImage` then carry it to the
-- compressed side.
--
-- THE HYPOTHESIS there, in the closing module's own
-- words: the commutation hypothesis is GLOBAL — `comm` quantifies over
-- ALL steps of the type, not over the steps appearing in the list.
-- So the line covers a system whose elimination steps all
-- commute, not a system with a commuting sub-family.
------------------------------------------------------------------------
