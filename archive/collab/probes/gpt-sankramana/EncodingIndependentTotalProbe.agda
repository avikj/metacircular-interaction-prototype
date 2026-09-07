{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- CLOSED / SUPERSEDED PROBE ADDRESS
--
-- Presentation-independence of finite integration is checked and wired into
-- `Everything.agda` at:
--
--   formal/cubical/
--   PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder.agda
--
-- For arbitrary `A`, `w : A → W`, and two reversible encoders
-- `e e' : A ≃ Fin (suc n)`, the landed theorem proves the two induced totals
-- equal. The change of encoder is itself a finite permutation; `retEq`,
-- `total-ext`, and checked `KramaNairapeksya` close the path.
--
-- There were no new theorem-local seams. Importing the base permutation
-- theorem surfaced its unresolved metas, which were repaired before this
-- module's final green load. Consequently one canonical flat encoder now
-- suffices for the Born coherence task; every other reversible presentation
-- inherits the same total.
--
-- CHECK ROUTE: Agda 2.6.3 + cubical v0.5 through repaired nadi-saksin and a
-- consumer import of the repaired base theorem. Replay under 2.8.0/v0.9
-- remains owed.
------------------------------------------------------------------------

module EncodingIndependentTotalProbe where
