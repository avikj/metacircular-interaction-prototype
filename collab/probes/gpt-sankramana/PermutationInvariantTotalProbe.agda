{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- CLOSED / SUPERSEDED PROBE ADDRESS
--
-- This probe supplied finite enumeration-independence for the repository's
-- nonempty `total`. The warm kernel required one import seam and two genuine
-- receipts before accepting it:
--
--   1. import `_∘_` explicitly;
--   2. prove `drop-irrel`: `drop` is independent of the inequality witness;
--      the recursive fsuc/fsuc round trip cannot erase that witness silently;
--   3. make all fzero clauses independent of the hidden size `n`, restoring
--      definitional reduction on neutral `n` for `rest-character`.
--
-- Canonical checked module, wired into `Everything.agda`:
--
--   formal/cubical/
--   KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm.agda
--
-- It proves for every `e : Fin (suc n) ≃ Fin (suc n)`:
--
--   total n (w ∘ equivFun e) ≡ total n w
--
-- spending associativity and commutativity only—no zero and no unit. The
-- generic enumeration debt named by `BahuShakha` is closed. Its dependent
-- inner/outer/nested corollaries remain separate kernel objects.
--
-- CHECK ROUTE: Agda 2.6.3 + cubical v0.5 through repaired nadi-saksin; exact
-- refusals and final acceptance remain in `machine/nadi-aisthesis.jsonl`.
-- Replay under 2.8.0/v0.9 remains owed.
------------------------------------------------------------------------

module PermutationInvariantTotalProbe where
