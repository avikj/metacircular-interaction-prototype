{-# OPTIONS --cubical --safe #-}

-- ShunyaParikrama_TwoCircuitsOfTheBasisDecidedPureGaugeAndTheDiscriminantIsProvenance
--
-- ‡‡‡®‡‡Ø-‡‡∞‡ø‡ï‡‡∞‡Æ‡æ ‚î the circuit walked and found empty.
--
-- WHAT THIS DECIDES.  interactive/Parikrama enumerated the complete cycle
-- basis of road one: dimension E ‚àí V + C = 36, every
-- circuit emitted as a kernel probe.
-- This module decides TWO:
--
--   circuit 34 ¬ base Pingala.‡‡®‡‡¶‡‡
--     ‡‡®‡‡¶‡‡‚â°‚ï , ‚ï‚â°CanWord , (‡‡®‡‡¶‡‡‚â°CanWord)‚ª¬
--   circuit 36 ¬ base InflationVersusSubgroup.Z2
--     ua Z2‚âH2 , H2‚â°H4 , (Z2‚â°H4)‚ª¬
--
-- both PURE GAUGE, and the reason is PROVENANCE, visible in the source:
-- the closing edge of each is DEFINED as the composite of the other two
-- (Sthana line 105: ‡‡®‡‡¶‡‡‚â°CanWord = ‡‡®‡‡¶‡‡‚â°‚ï ‚àô ‚ï‚â°CanWord; Vyatireka
-- line 273: Z2‚â°H4 = ua Z2‚âH2 ‚àô H2‚â°H4).  So each circuit composite is
-- literally q ‚àô sym q, and its nullity is rCancel ‚î a theorem of path
-- algebra, not a fact about the banks.
--
-- THE DISCRIMINANT THIS EXHIBITS: before
-- paying the kernel for a holonomy probe, ask the PROVENANCE question ‚î
-- is any edge of the circuit defined as the composite of the others?
-- If yes, the circuit is a second road by construction and its gauge
-- verdict is one rCancel; the interesting charge (Paryaya's 11-of-14
-- moved points) can live only in circuits whose edges are INDEPENDENT
-- constructions.

module ShunyaParikrama_TwoCircuitsOfTheBasisDecidedPureGaugeAndTheDiscriminantIsProvenance where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.GroupoidLaws using (rCancel)

open import Pingala using (‡§õ‡§®‡•ç‡§¶‡§∏‡•ç ; ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç‚â°‚Ñï)
open import Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence
  using (‚Ñï‚â°CanWord ; Z2‚âÉH2 ; Z2‚â°H4)
open import InflationVersusSubgroup using (Z2)
open import Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup
  using (H2‚â°H4)

-- ‚î‚î circuit 34 ¬ the Pigala loop is null ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- Sthana defines ‡‡®‡‡¶‡‡‚â°CanWord = ‡‡®‡‡¶‡‡‚â°‚ï ‚àô ‚ï‚â°CanWord.
-- The verdict is proved at the composite Sthana names, formed here from the two
-- edges; the identification of
-- ‡ï‡‡∞‡Æ‡ with its ‡‡®‡‡¶‡‡‚â°CanWord is refl by its own definition.

‡§ï‡•ç‡§∞‡§Æ‡§É : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç ‚â° _
‡§ï‡•ç‡§∞‡§Æ‡§É = ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç‚â°‚Ñï ‚àô ‚Ñï‚â°CanWord

‡§õ‡§®‡•ç‡§¶‡•ã-‡§µ‡•É‡§§‡•ç‡§§‡§Ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : ‡§ï‡•ç‡§∞‡§Æ‡§É ‚àô sym ‡§ï‡•ç‡§∞‡§Æ‡§É ‚â° refl {x = ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç}
‡§õ‡§®‡•ç‡§¶‡•ã-‡§µ‡•É‡§§‡•ç‡§§‡§Ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = rCancel ‡§ï‡•ç‡§∞‡§Æ‡§É

-- ‚î‚î circuit 36 ¬ the inflation loop is null ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- Z2‚â°H4 is definitionally ua Z2‚âH2 ‚àô H2‚â°H4.

‡§∏‡•ç‡§´‡•Ä‡§§‡§ø-‡§µ‡•É‡§§‡•ç‡§§‡§Ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç :
    (ua Z2‚âÉH2 ‚àô H2‚â°H4) ‚àô sym Z2‚â°H4 ‚â° refl {x = Z2}
‡§∏‡•ç‡§´‡•Ä‡§§‡§ø-‡§µ‡•É‡§§‡•ç‡§§‡§Ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = rCancel Z2‚â°H4
