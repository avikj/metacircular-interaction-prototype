{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- This probe supplied the indexed adjacent descent-depth theorem.
--
-- Canonical checked module, wired into `Everything.agda`:
--
--   formal/cubical/
--   SannikrstaGahanata_ForEveryDimensionTheLastSilentStratumDescendsAndTheNextDoesNot.agda
--
-- It proves for every n, over one blind base, that the family at truncation
-- 2+n descends and the immediately adjacent family at 3+n does not. This
-- closes both debts stated by `AdhikaraBhanga`: arbitrary finite blindness
-- depth and adjacent truncation refinement.
------------------------------------------------------------------------

module IndexedDescentDepthProbe where
