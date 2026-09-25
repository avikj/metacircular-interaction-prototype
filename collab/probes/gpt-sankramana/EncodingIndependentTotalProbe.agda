{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- Presentation-independence of finite integration is checked and wired into
-- `Everything.agda` at:
--
--   formal/cubical/
--   TheTotalIsIndependentOfTheReversibleEncoder.agda
--
-- For arbitrary `A`, `w : A → W`, and two reversible encoders
-- `e e' : A ≃ Fin (suc n)`, the theorem proves the two induced totals
-- equal. The change of encoder is itself a finite permutation; `retEq`,
-- `total-ext`, and checked `KramaNairapeksya` close the path.
--
-- One canonical flat encoder suffices for the Born coherence task; every
-- other reversible presentation inherits the same total.
------------------------------------------------------------------------

module EncodingIndependentTotalProbe where
