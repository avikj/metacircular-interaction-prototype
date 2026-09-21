{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡‡ ‚î the causeway ‡‡‡‡‡‡®‡‡ß named.
--
-- The machine read its own graph (interactive/Setubandha_‚¶hs, run 2026-08-23)
-- and placed `Carrier ‡Ø‡ã‡ó` and `Œ[ n ‚àà ‚ï ] fiber ‡Ø‡ã‡ó n` in ONE component at
-- distance 3, joined by no checked edge ‚î two banks the corpus reached from
-- opposite sides and never bridged.  They are the same object:
--
--   Carrier ‡Ø‡ã‡ó          binds the OUTPUT ‚î return, ‡‡‡®‡∞‡æ‡ó‡Æ‡®  (LosslessReturn)
--   Œ[ n ] fiber ‡Ø‡ã‡ó n    binds the INPUT  ‚î the cut, ‡‡‡Æ‡‡‡ø   (Avaccheda)
--
-- and both decompose ‚ï ó ‚ï, so composing the two organs' equivalences IS the
-- causeway.  No new mathematics: this is the edge the machine pointed at in
-- its own self-portrait, landed by transport, closing one gap the machine
-- named.  ‡‡‡‡‡∞ ‡, one map two bindings ‚î and here the two bindings, long
-- proved apart, are shown to be one.
--
-- TERM.  ‡‡‡‡ ‚î a causeway built so others may cross (gveda 10.53.8), as in
-- `Setubandha`'s header; nothing mathematical is claimed of the source.  The
-- substrate is cubical type theory (Voevodsky's univalence).
------------------------------------------------------------------------

module Setu_TheReturnAndTheCutDecomposeTheSamePairAndSetubandhaNamedTheGap where

open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEquiv ; compEquiv ; fiber)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_)

open import LosslessReturn_TheHandProofWasUnnecessaryAndTransportGivesIt
  using (Carrier ; ‡§Ø‡•ã‡§ó ; Carrier‚âÉ)
open import Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible
  using (‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É)

------------------------------------------------------------------------
-- The causeway.  Carrier ‡Ø‡ã‡ó ‚â ‚ï ó ‚ï (invert Carrier‚â, the return law) then
-- ‚ï ó ‚ï ‚â Œ[ n ] fiber ‡Ø‡ã‡ó n (invert ‡‡µ‡‡‡‡‡¶‡, the cut law), composed.
------------------------------------------------------------------------

‡§∏‡•á‡§§‡•Å‡§É : Carrier ‡§Ø‡•ã‡§ó ‚âÉ (Œ£[ n ‚àà ‚Ñï ] fiber ‡§Ø‡•ã‡§ó n)
‡§∏‡•á‡§§‡•Å‡§É = compEquiv (invEquiv (Carrier‚âÉ ‡§Ø‡•ã‡§ó)) (invEquiv (‡§Ö‡§µ‡§ö‡•ç‡§õ‡•á‡§¶‡§É ‡§Ø‡•ã‡§ó))
