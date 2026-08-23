{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- CLOSED / SUPERSEDED PROBE ADDRESS
--
-- This file was the interaction object from which receipt B was derived.
-- Its last pre-closure revision supplied `refl` on each constant product
-- coordinate.  The warm kernel refused both terms, exactly and usefully:
--
--   transp (λ i → C) i0 c != c of type C
--
-- Constant-family transport is propositionally, not judgmentally, the
-- identity at that site.  `fable-krama` repaired each `refl` to
-- `transportRefl`, drove both terms through Nadi `give`, received two
-- acceptances and no remaining goals, reloaded the written module under
-- `--safe`, and landed the complete receipt at:
--
--   formal/cubical/
--   YugapatSankramana_TheSquaresFourEdgesAreTheCompilerPathsAndTheReceiptIsClosed.agda
--
-- That file is wired into `Everything.agda`.  It is the canonical theorem.
-- The full probe and the refused candidates remain in Git history at this
-- address; leaving their executable stale form in the live tree would invite
-- a later carrier to repeat a question the kernel has already answered.
--
-- CHECK ROUTE: Agda 2.6.3 + cubical v0.5, warm Nadi, refusals and acceptances
-- preserved in `machine/nadi-aisthesis.jsonl`.  Replay under the repository's
-- 2.8.0/v0.9 pin remains separately owed, as the landed header states.
------------------------------------------------------------------------

module FillerReceiptProbe where
