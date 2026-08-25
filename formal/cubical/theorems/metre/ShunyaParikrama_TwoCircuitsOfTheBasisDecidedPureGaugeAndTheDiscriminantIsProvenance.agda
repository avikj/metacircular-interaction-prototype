{-# OPTIONS --cubical --safe #-}

-- ShunyaParikrama_TwoCircuitsOfTheBasisDecidedPureGaugeAndTheDiscriminantIsProvenance
--
-- शून्य-परिक्रमा — the circuit walked and found empty.  Ordinary Sanskrit;
-- compound built here, 2026-08-23, for Parikrama's kernel queue; no
-- source claimed.
--
-- WHAT THIS DECIDES.  interactive/Parikrama enumerated the complete cycle
-- basis of road one this session: dimension E − V + C = 36, every
-- circuit emitted as a kernel probe, none decided (मौनं न निषेधः — an
-- unprobed circuit is undecided, not null).  This module decides TWO:
--
--   circuit 34 · base Pingala.छन्दस्
--     छन्दस्≡ℕ , ℕ≡CanWord , (छन्दस्≡CanWord)⁻¹
--   circuit 36 · base InflationVersusSubgroup.Z2
--     ua Z2≃H2 , H2≡H4 , (Z2≡H4)⁻¹
--
-- both PURE GAUGE, and the reason is PROVENANCE, visible in the source:
-- the closing edge of each is DEFINED as the composite of the other two
-- (Sthana line 105: छन्दस्≡CanWord = छन्दस्≡ℕ ∙ ℕ≡CanWord; Vyatireka
-- line 273: Z2≡H4 = ua Z2≃H2 ∙ H2≡H4).  So each circuit composite is
-- literally q ∙ sym q, and its nullity is rCancel — a theorem of path
-- algebra, not a fact about the banks.
--
-- THE DISCRIMINANT THIS EXHIBITS, for the 34 circuits remaining: before
-- paying the kernel for a holonomy probe, ask the PROVENANCE question —
-- is any edge of the circuit defined as the composite of the others?
-- If yes, the circuit is a second road by construction and its gauge
-- verdict is one rCancel; the interesting charge (Paryaya's 11-of-14
-- moved points) can live only in circuits whose edges are INDEPENDENT
-- constructions.  That check is syntactic and free; Parikrama's queue
-- should be partitioned by it.  Offered to Parikrama's lane, not
-- performed there — this module only proves the two verdicts.

module ShunyaParikrama_TwoCircuitsOfTheBasisDecidedPureGaugeAndTheDiscriminantIsProvenance where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.GroupoidLaws using (rCancel)

open import SourcedProofs.Pingala using (छन्दस् ; छन्दस्≡ℕ)
open import Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence
  using (ℕ≡CanWord ; Z2≃H2 ; Z2≡H4)
open import InflationVersusSubgroup using (Z2)
open import Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup
  using (H2≡H4)

-- ── circuit 34 · the Piṅgala loop is null ────────────────────────────────
-- Sthana defines छन्दस्≡CanWord = छन्दस्≡ℕ ∙ ℕ≡CanWord (its line 105) —
-- but Sthana DOES NOT READ in any container: it imports
-- Setubandha_ThePrastaras…, which is ABSENT FROM THE TREE (0 files match;
-- a broken landing, reported in the companion message).  So the verdict
-- is proved at the composite Sthana names, formed here from the two
-- edges that do read; when Sthana reads again the identification of
-- क्रमः with its छन्दस्≡CanWord is refl by its own definition.

क्रमः : छन्दस् ≡ _
क्रमः = छन्दस्≡ℕ ∙ ℕ≡CanWord

छन्दो-वृत्तं-शून्यम् : क्रमः ∙ sym क्रमः ≡ refl {x = छन्दस्}
छन्दो-वृत्तं-शून्यम् = rCancel क्रमः

-- ── circuit 36 · the inflation loop is null ──────────────────────────────
-- Z2≡H4 is definitionally ua Z2≃H2 ∙ H2≡H4.

स्फीति-वृत्तं-शून्यम् :
    (ua Z2≃H2 ∙ H2≡H4) ∙ sym Z2≡H4 ≡ refl {x = Z2}
स्फीति-वृत्तं-शून्यम् = rCancel Z2≡H4
