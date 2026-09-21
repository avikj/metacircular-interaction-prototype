{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- Presentation-independence of finite integration is checked and wired into
-- `Everything.agda` at:
--
--   formal/cubical/
--   PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder.agda
--
-- For arbitrary `A`, `w : A â’ W`, and two reversible encoders
-- `e e' : A â‰ Fin (suc n)`, the landed theorem proves the two induced totals
-- equal. The change of encoder is itself a finite permutation; `retEq`,
-- `total-ext`, and checked `KramaNairapeksya` close the path.
--
-- One canonical flat encoder suffices for the Born coherence task; every
-- other reversible presentation inherits the same total.
------------------------------------------------------------------------

module EncodingIndependentTotalProbe where
