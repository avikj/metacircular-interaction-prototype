{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OrderIndependenceTransfersAlongAnyNumberOfSteps
--
-- The n-step generalisation of `CurvatureCannotLiveOnTheImageOfAnExactCompression`.
-- The induction turns out NOT to need the two-step
-- case at all — which is the finding.  What the two-step proof did by
-- pasting three squares, the n-step proof does by pasting ONE square
-- per step and then using the uncompressed order-independence once.
-- The earlier module is a corollary, not a lemma.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Step              a step, its compressed counterpart, and the
--                     intertwining square, packaged so a LIST of them
--                     carries its own hypotheses
--   runS / runT       run a list of steps, rightmost first
--   simFold           `C (runS ps s) ≡ runT ps (C s)` — intertwining
--                     extends from one step to any composite, by a
--                     one-line induction
--   orderIndependenceTransfers
--                     if two composites agree UNCOMPRESSED, their
--                     compressed counterparts agree on the image
--   disagreementIsOffTheImage
--                     hence a point where two compressed composites
--                     disagree is not `C` of anything
--   twoStepsAreAnInstance
--                     the earlier two-step theorem, recovered by taking
--                     the two lists to be `f ∷ g ∷ []` and `g ∷ f ∷ []`
--
-- **The generalisation is cheaper than the special case.**  The
-- two-step proof pasted a simulation square, the commuting square, and
-- a second simulation square in sequence; the n-step proof separates
-- those concerns — `simFold` is pure simulation and knows nothing about
-- commuting, and the commuting hypothesis is applied exactly once,
-- under a single `cong C`.  Generality removed the interleaving that
-- made the two-step argument look like a chain.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  A simulation extends to composites by induction, and
-- transports equalities of composites onto the image; this is the
-- functoriality of simulation and is standard.
------------------------------------------------------------------------

module OrderIndependenceTransfersAlongAnyNumberOfSteps where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

module _ {S T : Type} (C : S → T) where

  ------------------------------------------------------------------
  -- 1.  A step carries its own intertwining square
  ------------------------------------------------------------------

  Step : Type
  Step = Σ[ f ∈ (S → S) ] Σ[ f' ∈ (T → T) ]
           ((s : S) → C (f s) ≡ f' (C s))

  runS : List Step → S → S
  runS []       s = s
  runS (p ∷ ps) s = fst p (runS ps s)

  runT : List Step → T → T
  runT []       t = t
  runT (p ∷ ps) t = fst (snd p) (runT ps t)

  ------------------------------------------------------------------
  -- 2.  Intertwining extends to composites
  ------------------------------------------------------------------

  simFold : (ps : List Step) (s : S) → C (runS ps s) ≡ runT ps (C s)
  simFold []       s = refl
  simFold (p ∷ ps) s =
    snd (snd p) (runS ps s) ∙ cong (fst (snd p)) (simFold ps s)

  ------------------------------------------------------------------
  -- 3.  So order-independence transfers, for any number of steps
  ------------------------------------------------------------------

  orderIndependenceTransfers :
    (ps qs : List Step)
    → ((s : S) → runS ps s ≡ runS qs s)
    → (s : S) → runT ps (C s) ≡ runT qs (C s)
  orderIndependenceTransfers ps qs eq s =
    sym (simFold ps s) ∙ cong C (eq s) ∙ simFold qs s

  disagreementIsOffTheImage :
    (ps qs : List Step)
    → ((s : S) → runS ps s ≡ runS qs s)
    → (t : T) → ¬ (runT ps t ≡ runT qs t) → ¬ (Σ[ s ∈ S ] C s ≡ t)
  disagreementIsOffTheImage ps qs eq t bent (s , e) =
    bent (subst (λ x → runT ps x ≡ runT qs x) e
                (orderIndependenceTransfers ps qs eq s))

  ------------------------------------------------------------------
  -- 4.  The two-step theorem is an instance
  ------------------------------------------------------------------

  twoStepsAreAnInstance :
    (p q : Step)
    → ((s : S) → fst p (fst q s) ≡ fst q (fst p s))
    → (s : S)
    → fst (snd p) (fst (snd q) (C s)) ≡ fst (snd q) (fst (snd p) (C s))
  twoStepsAreAnInstance p q comm =
    orderIndependenceTransfers (p ∷ q ∷ []) (q ∷ p ∷ []) comm

------------------------------------------------------------------------
-- `PairwiseCommutationGivesEveryOrder` derives the hypothesis that two
-- uncompressed composites agree from pairwise commutation of the steps:
--
--   _~_             permutation in the standard inductive presentation
--                   (identity, congruence, ADJACENT transposition,
--                    transitivity)
--   permInvariant   under pairwise commutation of the STEPS, any two
--                   permutations have the same uncompressed composite —
--                   and the transposition case IS the hypothesis
--   everyOrderAgreesAfterCompression / disagreementUnderPermutationIsOffTheImage
--
-- So Δ 28 §36�38's "for every order" holds at the level it
-- is stated: assume the steps commute PAIRWISE, and every order agrees,
-- compressed and uncompressed alike.
--
-- ONE CUBICAL DETAIL WORTH CARRYING: `permInvariant` matches on the
-- RELATION only and keeps the lists implicit.  Matching the lists too
-- makes Agda warn that the function "will not compute when applied to
-- transports", because it would rely on injectivity of `_∷_`, which
-- cubical does not support.
------------------------------------------------------------------------
