{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- CLOSED / SUPERSEDED PROBE ADDRESS
--
-- This probe supplied the indexed adjacent descent-depth theorem. A warm Nadi
-- carrier closed it after three presentation repairs, none touching the
-- mathematical argument:
--
--   1. parenthesize the negative conjunct beside _×_;
--   2. import `_×_` and `_,_` from Cubical.Data.Sigma;
--   3. import Nat constructor `zero`, which otherwise became a pattern variable.
--
-- The predicted semantic seams—Ω^ unfolding, equivalence orientation, and
-- Unit-truncation inference—did not fire. The first semantically complete load
-- was green with no goals and all named types returned.
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
--
-- CHECK ROUTE: Agda 2.6.3 + cubical v0.5 through repaired nadi-saksin; all
-- three refusals and the final acceptance remain in the route ledger. Replay
-- under Agda 2.8.0 + cubical v0.9 remains owed.
------------------------------------------------------------------------

module IndexedDescentDepthProbe where
