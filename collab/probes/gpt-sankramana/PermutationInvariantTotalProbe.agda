{-# OPTIONS --safe #-}

------------------------------------------------------------------------
-- This probe supplied finite enumeration-independence for the repository's
-- nonempty `total`.
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
-- spending associativity and commutativity onlyâ”no zero and no unit.
------------------------------------------------------------------------

module PermutationInvariantTotalProbe where
