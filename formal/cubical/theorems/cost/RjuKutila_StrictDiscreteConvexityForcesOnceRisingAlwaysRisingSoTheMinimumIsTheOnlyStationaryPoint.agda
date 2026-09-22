{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à‹àà-à•ààŸà¿à² â” the straight and the bent.  The licensing theorem behind the
-- machine's convexity certificate (runtime/physics/geodesic.py): on a
-- discrete family, STRICT CONVEXITY forces once-weakly-rising âŸ
-- strictly-rising-forever â” no plateau, no second dip â” so the extracted
-- minimum is the ONLY stationary point, and "cost-minimal route" may be
-- read as "physical ray".  Fermat is stationarity (Î´OPL = 0); extraction
-- is minimisation; minimal âŸ stationary always, and the converse is
-- exactly what this theorem licenses.  The mirror maximum (geodesic.py's
-- own counterexample) violates the hypothesis, not the theorem.
--
-- STATED WITHOUT SUBTRACTION.  Over â• the second difference is not a
-- term, but strict convexity at the interior point i+1 is:
--
--     v(i) + v(i+2)  >  v(i+1) + v(i+1).
--
-- CHECKED:
--   Â§1  step  â” one weak rise forces the next rise strict:
--         v i â‰ v (suc i)  â’  v (suc i) < v (suc (suc i)).
--       (If v(i+2) â‰ v(i+1), then 2Âv(i+1) < v(i)+v(i+2) â‰ v(i+1)+v(i+2)
--        â‰ 2Âv(i+1) â” a term less than itself.  Âm<m.)
--   Â§2  always â” by induction, strictly rising at every later point:
--         v i â‰ v (suc i) â’ âˆ k, v (k + suc i) < v (suc (k + suc i)).
--       (k on the LEFT so every index reduces definitionally.)
--   Â§3  no-return â” the corollary the certificate quotes: after a weak
--       rise the value never returns to or below the pre-rise floor:
--       v(i+1) â‰ every later value.  A minimiser that has risen has
--       finished: nothing later is smaller, so no stationary point
--       other than the minimum exists.
--
-- The certificate in geodesic.py checks the hypothesis (every interior
-- second difference > 0, exact Surd signs); this term is the implication
-- it then invokes.  Declared there, proved here.
--
-- This term proves the
-- implication for â•-VALUED families.  geodesic.py's OPL values are exact
-- Surds (quadratic irrationals); the implication at Surd values has the
-- same proof shape over any cancellative ordered additive structure but
-- is not itself this term.  "Declared there, proved here" holds at â•.
------------------------------------------------------------------------

module RjuKutila_StrictDiscreteConvexityForcesOnceRisingAlwaysRisingSoTheMinimumIsTheOnlyStationaryPoint where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; zero; suc; _+_)
open import Cubical.Data.Nat.Order
  using (_â‰¤_; _<_; â‰¤-refl; â‰¤-trans; â‰¤-+k; â‰¤-k+; Â¬m<m; <-weaken; â‰¤<-trans; <â‰¤-trans)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Data.Sum using (_âŠŽ_; inl; inr)

module _ (v : â„• â†’ â„•)
         (convex : (i : â„•) â†’ (v (suc i) + v (suc i)) < (v i + v (suc (suc i))))
  where

  ------------------------------------------------------------------
  -- Â§1 Â one weak rise forces the next rise strict.  Trichotomy-free:
  -- suppose not (v(i+2) â‰ v(i+1)); chain the certificate's inequality
  -- through both monotonicities into m < m.
  private
    absurd-chain : (i : â„•) â†’ v i â‰¤ v (suc i) â†’ v (suc (suc i)) â‰¤ v (suc i) â†’ âŠ¥
    absurd-chain i rise fall =
      Â¬m<m (<â‰¤-trans (<â‰¤-trans (convex i) monoâ‚) monoâ‚‚)
      where
      -- v(i) + v(i+2) â‰ v(i+1) + v(i+2)
      monoâ‚ : v i + v (suc (suc i)) â‰¤ v (suc i) + v (suc (suc i))
      monoâ‚ = â‰¤-+k rise
      -- v(i+1) + v(i+2) â‰ v(i+1) + v(i+1)
      monoâ‚‚ : v (suc i) + v (suc (suc i)) â‰¤ v (suc i) + v (suc i)
      monoâ‚‚ = â‰¤-k+ fall

  -- â‰ on â• is decidable through splitting <; here we use the library's
  -- Ââ‰â’< shape via Dichotomyâ•-free route: derive < from Â â‰ by the
  -- standard split lemma.
  open import Cubical.Data.Nat.Order using (splitâ„•-â‰¤; â‰¤-split)

  step : (i : â„•) â†’ v i â‰¤ v (suc i) â†’ v (suc i) < v (suc (suc i))
  step i rise with splitâ„•-â‰¤ (v (suc (suc i))) (v (suc i))
  ... | inl fall = Empty.rec (absurd-chain i rise fall)
  ... | inr gt   = gt

  ------------------------------------------------------------------
  -- Â§2 Â strictly rising at every later point.  k rides on the LEFT of +
  -- so both the base and the inductive index reduce definitionally.
  always : (i : â„•) â†’ v i â‰¤ v (suc i)
         â†’ (k : â„•) â†’ v (k + suc i) < v (suc (k + suc i))
  always i rise zero    = step i rise
  always i rise (suc k) = step (k + suc i) (<-weaken (always i rise k))

  ------------------------------------------------------------------
  -- Â§3 Â NO RETURN.  After a weak rise at i, every later value dominates
  -- v (suc i): the family never dips again, so the minimum the extractor
  -- found is the only stationary point â” the certificate's license.
  no-return : (i : â„•) â†’ v i â‰¤ v (suc i)
            â†’ (k : â„•) â†’ v (suc i) â‰¤ v (k + suc i)
  no-return i rise zero    = â‰¤-refl
  no-return i rise (suc k) =
    â‰¤-trans (no-return i rise k) (<-weaken (always i rise k))
