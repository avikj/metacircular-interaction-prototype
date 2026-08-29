{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OrderIndependenceTransfersAlongAnyNumberOfSteps
--
-- `CurvatureCannotLiveOnTheImageOfAnExactCompression` closed with:
--
--   "ORDERS: two steps are treated, so 'for every order' is here just
--    'the two orders of two steps'; nothing is proved for `n` steps,
--    and the `n`-step statement needs the two-step case plus an
--    induction that is not written."
--
-- The induction is written, and it turns out NOT to need the two-step
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
--
-- SYĀT — THE CLAIM, EXACTLY, and this is now the sharp remainder.
-- PERMUTATIONS ARE NOT MODELLED.  "For every order" is encoded as the
-- HYPOTHESIS that the two uncompressed composites agree — which is what
-- Δ 28 means by "exact elimination commutes" — and NO theorem here
-- derives that hypothesis from pairwise commutation of the steps.  That
-- derivation (pairwise commuting ⇒ all permutations of a composite
-- agree) is a real induction on lists with a permutation relation, and
-- it is not written; it is also the only part of §36–38's "for every
-- order" that remains open.  Nothing is said about `n` steps of which
-- only SOME commute.  As before, NO CURVATURE IS EXHIBITED — this
-- constrains where disagreement can live, and is not evidence that it
-- occurs.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "PERMUTATIONS ARE NOT MODELLED.  'For every order' is encoded as
--    the HYPOTHESIS that two uncompressed composites agree … and NO
--    theorem here derives that hypothesis from pairwise commutation."
--
-- Derived, in `PairwiseCommutationGivesEveryOrder`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   _~_             permutation in the standard inductive presentation
--                   (identity, congruence, ADJACENT transposition,
--                    transitivity)
--   permInvariant   under pairwise commutation of the STEPS, any two
--                   permutations have the same uncompressed composite —
--                   and the transposition case IS the hypothesis
--   everyOrderAgreesAfterCompression / disagreementUnderPermutationIsOffTheImage
--
-- So Δ 28 §36–38's "for every order" is now discharged at the level it
-- is stated: three cycles ago it was two orders of two steps; here it
-- was any two composites ASSUMED equal; there it is — assume the steps
-- commute PAIRWISE, and every order agrees, compressed and
-- uncompressed alike.
--
-- ONE CUBICAL DETAIL WORTH CARRYING: `permInvariant` matches on the
-- RELATION only and keeps the lists implicit.  Matching the lists too
-- makes Agda warn that the function "will not compute when applied to
-- transports", because it would rely on injectivity of `_∷_`, which
-- cubical does not support.  The first draft did exactly that and was
-- rewritten.
--
-- STILL NOT CLAIMED there: the commutation hypothesis is GLOBAL — it
-- quantifies over ALL steps of the type, not over the members of the
-- list.  Restricting it needs a membership index carried through `swap`
-- and `trans`, which is not done, so the result covers a system whose
-- elimination steps all commute rather than one with a commuting
-- sub-family.  And `_~_` is a DEFINITION, not a characterisation:
-- nothing proves it coincides with "same multiset".
------------------------------------------------------------------------
