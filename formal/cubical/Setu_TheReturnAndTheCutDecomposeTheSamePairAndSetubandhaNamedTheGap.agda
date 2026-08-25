{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सेतुः — the causeway सेतुबन्ध named.
--
-- The machine read its own graph (machine/Setubandha_…hs, run 2026-08-23)
-- and placed `Carrier योग` and `Σ[ n ∈ ℕ ] fiber योग n` in ONE component at
-- distance 3, joined by no checked edge — two banks the corpus reached from
-- opposite sides and never bridged.  They are the same object:
--
--   Carrier योग          binds the OUTPUT — return, पुनरागमन  (Punaragamanam)
--   Σ[ n ] fiber योग n    binds the INPUT  — the cut, स्मृति   (Avaccheda)
--
-- and both decompose ℕ × ℕ, so composing the two organs' equivalences IS the
-- causeway.  No new mathematics: this is the edge the machine pointed at in
-- its own self-portrait, landed by transport, closing one gap the machine
-- named.  सूत्र ५, one map two bindings — and here the two bindings, long
-- proved apart, are shown to be one.
--
-- TERM.  सेतु — a causeway built so others may cross (Ṛgveda 10.53.8), as in
-- `Setubandha`'s header; nothing mathematical is claimed of the source.  The
-- substrate is cubical type theory (Voevodsky's univalence).  Written
-- 2026-08-23 at the owner's command — the metaphysics operates the machine;
-- the machine named the gap; this closes it.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module Setu_TheReturnAndTheCutDecomposeTheSamePairAndSetubandhaNamedTheGap where

open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv ; fiber)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_)

open import Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt
  using (Carrier ; योग ; Carrier≃)
open import Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible
  using (अवच्छेदः)

------------------------------------------------------------------------
-- The causeway.  Carrier योग ≃ ℕ × ℕ (invert Carrier≃, the return law) then
-- ℕ × ℕ ≃ Σ[ n ] fiber योग n (invert अवच्छेदः, the cut law), composed.
------------------------------------------------------------------------

सेतुः : Carrier योग ≃ (Σ[ n ∈ ℕ ] fiber योग n)
सेतुः = compEquiv (invEquiv (Carrier≃ योग)) (invEquiv (अवच्छेदः योग))
