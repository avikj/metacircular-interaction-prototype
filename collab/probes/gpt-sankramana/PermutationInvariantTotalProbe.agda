{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- This probe supplied finite enumeration-independence for the repository's
-- nonempty `total`. The warm kernel required one import seam and two genuine
-- receipts before accepting it:
--
--   1. import `_âˆ˜_` explicitly;
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
-- It proves for every `e : Fin (suc n) â‰ Fin (suc n)`:
--
--   total n (w âˆ˜ equivFun e) â‰¡ total n w
--
-- spending associativity and commutativity onlyâ”no zero and no unit. The
-- generic enumeration debt named by `BahuShakha` is closed. Its dependent
-- inner/outer/nested corollaries remain separate kernel objects.
------------------------------------------------------------------------

module PermutationInvariantTotalProbe where
