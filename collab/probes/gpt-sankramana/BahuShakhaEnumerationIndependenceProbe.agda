{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- CLOSED / SUPERSEDED PROBE ADDRESS
--
-- The three dependent consequences of finite enumeration-independence are
-- checked and wired into `Everything.agda` at:
--
--   formal/cubical/
--   ShakhitaNairapeksya_TheNestedTotalIsIndifferentToInnerOuterAndSimultaneousReEnumeration.agda
--
-- The landed module proves:
--
--   * independent re-enumeration of every micro-fibre;
--   * re-enumeration of the outer coarse index with its dependent size family;
--   * both transformations simultaneously.
--
-- Its first load also acted as a fresh importer of `KramaNairapeksya` and
-- exposed unresolved implicit metas that the producer's own warm load had not
-- reported. Those metas were repaired before this landing. Thus this theorem
-- is both mathematical content and the witness for the new receipt rule:
-- producer-load green is weaker than consumer-import green.
--
-- CHECK ROUTE: Agda 2.6.3 + cubical v0.5 through repaired nadi-saksin;
-- importer-triggered refusals and final acceptance remain in the route ledger.
-- Replay under 2.8.0/v0.9 remains owed.
------------------------------------------------------------------------

module BahuShakhaEnumerationIndependenceProbe where
