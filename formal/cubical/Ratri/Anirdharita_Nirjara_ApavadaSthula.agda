{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡ø‡∞‡‡ß‡æ‡∞‡ø‡ ‚î apavda does not shed sthla's provenance, and that is
-- the host's thesis, not its failure.  The probe's open row
-- (notes/SADHYA_OPEN_OBLIGATIONS.md, "host enumeration", rung ‡®/‡©)
-- asked apavada (sthula t) ‚â° t.  But sthula t = yoga (nyasa t) (mita 0)
-- ‚î the coarse embedding that stamps a "+0" of provenance ‚î and apavada
-- is structural: it carries the stamp through, landing at
-- yoga' t (mita' 0), never back at t.  The host proves the two
-- embeddings ‡®‡‡Ø‡æ‡ and ‡‡‡‡‡≤ are observationally inseparable in value
-- (nyasa-sthula-avishesha) yet distinct in cost (mulya-bheda); a probe
-- that closed this row green would have collapsed exactly the
-- distinction the module exists to hold apart.  Road two, witness cara'.
------------------------------------------------------------------------

module Ratri.Anirdharita_Nirjara_ApavadaSthula where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false; true‚â¢false)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import NaturalMachine.Nirjara_SheddingAPrimitiveCostsLaghava
  using (Laghu; cara'; mita'; yoga'; apavada; sthula)

-- The composite keeps the provenance stamp:
composite-lands : apavada (sthula cara') ‚â° yoga' cara' (mita' 0)
composite-lands = refl

-- and the stamped term is not the bare variable:
isCara' : Laghu ‚Üí Bool
isCara' cara'       = true
isCara' (mita' _)   = false
isCara' (yoga' _ _) = false

stamped‚â¢bare : yoga' cara' (mita' 0) ‚â° cara' ‚Üí ‚ä•
stamped‚â¢bare p = true‚â¢false (cong isCara' (sym p))

-- THE VERDICT.  Green here means the field is NOT determined:
-- apavada ‚àò sthula is not the identity ‚î shedding does not remove
-- provenance, it preserves it, which is the module's own theorem
-- held from the other side.
NOT-DETERMINED : apavada (sthula cara') ‚â° cara' ‚Üí ‚ä•
NOT-DETERMINED p = stamped‚â¢bare (sym composite-lands ‚àô p)
