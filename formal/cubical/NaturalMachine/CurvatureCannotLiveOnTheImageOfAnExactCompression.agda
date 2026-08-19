{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CurvatureCannotLiveOnTheImageOfAnExactCompression
--
-- `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` §36–38 opens:
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
--
-- WHAT IS NOT CLAIMED.  NO CURVATURE IS EXHIBITED.  Nothing below
-- constructs `f' g' C` with genuine curvature, so this is a
-- constraint on where curvature can be and not evidence that it
-- occurs.  Theorem 28.14 ("fully abstract compression … preserves
-- semantics for every order") is NOT formalised: full abstraction is a
-- condition on the context FAMILY and no context family appears here;
-- what is proved is weaker in its hypothesis (only intertwining) and
-- weaker in its conclusion (only on the image).  ORDERS: two steps are
-- treated, so "for every order" is here just "the two orders of two
-- steps"; nothing is proved for `n` steps, and the `n`-step statement
-- needs the two-step case plus an induction that is not written.
-- HOLONOMY — §36–38's `h : Z ≃ Z` around loops in architecture space —
-- is untouched, and the module says nothing about caches, provenance,
-- or optimizer state.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.CurvatureCannotLiveOnTheImageOfAnExactCompression where

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
