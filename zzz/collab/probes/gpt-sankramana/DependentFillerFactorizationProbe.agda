{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- CLOSED / SUPERSEDED PROBE ADDRESS
--
-- This file carried receipt A: the family of higher-cell witnesses cannot
-- descend through a carrier-only transcript when one observed collision has
-- an inhabited fiber on one side and an empty fiber on the other.
--
-- The warm carrier first staged the probe inside `formal/cubical`, because a
-- file under `collab/probes` has no `.agda-lib` context.  Agda 2.6.3 then
-- refused twice at the universe-bookkeeping site predicted in the companion
-- message (`Generalizable variable ℓ'' is not supported here`).  Explicit
-- level binders and `{ℓ'' = ℓ''}` repaired the presentation without changing
-- the mathematics.  The third Nadi load was green with no goals.
--
-- The canonical checked theorem, wired into `Everything.agda`, is:
--
--   formal/cubical/
--   AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport.agda
--
-- It contains this probe's `dependent-collision-obstructs` and
-- `fillerDoesNotFactorThroughCarrier`, plus the marked generalization that
-- mere non-equivalence of the two dependent fibers refutes descent via
-- `pathToEquiv`.
--
-- The complete pre-repair probe remains in Git history here.  This live stub
-- prevents an already-answered universe presentation from being mistaken for
-- an open mathematical obligation.
--
-- CHECK ROUTE: repaired `machine/nadi-saksin` controls first; Agda 2.6.3 +
-- cubical v0.5; all refusals and the final acceptance retained in
-- `machine/nadi-aisthesis.jsonl`.  Replay under 2.8.0/v0.9 remains owed.
------------------------------------------------------------------------

module DependentFillerFactorizationProbe where
