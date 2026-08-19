{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
--
-- `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` §39–47 opens:
--
--   "A certified rewrite carries: boundary-semantics preservation,
--    complexity improvement (peak semantic width / Pareto), state
--    migration, provenance."
--
-- Four components, listed.  A compiler applies rewrites in sequence, so
-- the question the list does not answer is whether the certificate
-- COMPOSES — and if it does, which component costs anything.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Certified d e     the four components as one Σ: the boundary
--                     semantics agree, the cost vector strictly
--                     improves, the state migrates, provenance is
--                     carried
--   composeCertified  certified rewrites compose
--   noSelfRewrite     and no system is a certified rewrite of itself,
--                     so a rewrite sequence never marks time
--
-- **THREE OF THE FOUR COMPOSE FOR FREE.**  Boundary preservation is a
-- path and paths compose; migration is a function and functions
-- compose; provenance is a list and lists append.  Only COMPLEXITY
-- IMPROVEMENT needs a theorem — transitivity of strict Pareto
-- domination — and that theorem already exists in this corpus, proved
-- on the DARWIN §5.2 stratum line for an unrelated purpose
-- (`⊏-trans` in `ANonEmptyArchiveHasANonEmptyStratum`, where it was
-- needed because a maximal element of the tail might be beaten by the
-- head).  `noSelfRewrite` is likewise `⊏-irrefl` from that module.
--
-- So the two notes are joined by a lemma neither asked for: §5.2's
-- parent selection and §39–47's compiler need the SAME fact about the
-- Pareto order, and it was proved once.
--
-- ────────────────────────────────────────────────────────────────────
-- ON THE COST CONVENTION, because it is a live hazard on this line.
-- The cost vector is compared with `StrictlyDominates`, which is the
-- BENEFIT reading — higher is better.  §39–47's "complexity" is a cost,
-- lower is better, so applying this to it requires the flip, and the
-- flip is SOUND BUT NOT FAITHFUL: it needs a cap above every cost ever
-- compared, and identifies costs above that cap
-- (`FlippingACostCoordinateIsSoundButNotFaithful`).  That obligation is
-- inherited here and not discharged.
--
-- NO NOVELTY.  Composing certificates componentwise is what
-- certificates are for; the content is only the count — three free,
-- one earned.
--
-- WHAT IS NOT CLAIMED.  "Peak semantic width" is NOT modelled: the cost
-- is an abstract vector, and nothing says it is a width, a Pareto
-- stratum index, or anything computed from a cut.  MIGRATION is a bare
-- function with no law — nothing says it preserves the boundary
-- semantics, and a compiler would need exactly that, so the composite's
-- migration is only as meaningful as its components'.  PROVENANCE is an
-- opaque list; append is not claimed to be the right combination, and
-- nothing checks that a provenance entry corresponds to a step.
-- Nothing here is a compiler: there is no rewrite SEARCH, no strategy,
-- no meta-Bellman `V(D) = min_a (K(D,a,D′) + V(D′))` — §39–47's
-- self-referential planner is untouched and would need a fixpoint.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates)
open import NaturalMachine.ANonEmptyArchiveHasANonEmptyStratum
  using (⊏-irrefl ; ⊏-trans)

module _ {Sys B Prov : Type}
         (sem  : Sys → B)
         (cost : Sys → List ℕ)
         (M    : Sys → Type)
  where

  ------------------------------------------------------------------
  -- 1.  The four components
  ------------------------------------------------------------------

  Certified : Sys → Sys → Type
  Certified d e =
      (sem e ≡ sem d)                              -- boundary preserved
    × (StrictlyDominates (cost d) (cost e))        -- strictly improved
    × (M d → M e)                                  -- state migration
    × List Prov                                    -- provenance

  ------------------------------------------------------------------
  -- 2.  They compose — three for free, one by ⊏-trans
  ------------------------------------------------------------------

  composeCertified :
    (d e f : Sys) → Certified d e → Certified e f → Certified d f
  composeCertified d e f (sde , imp₁ , mig₁ , prov₁)
                         (sef , imp₂ , mig₂ , prov₂) =
      sef ∙ sde
    , ⊏-trans (cost d) (cost e) (cost f) imp₁ imp₂
    , (λ m → mig₂ (mig₁ m))
    , prov₁ ++ prov₂

  ------------------------------------------------------------------
  -- 3.  And a rewrite never marks time
  ------------------------------------------------------------------

  noSelfRewrite : (d : Sys) → ¬ Certified d d
  noSelfRewrite d (_ , imp , _ , _) = ⊏-irrefl (cost d) imp
