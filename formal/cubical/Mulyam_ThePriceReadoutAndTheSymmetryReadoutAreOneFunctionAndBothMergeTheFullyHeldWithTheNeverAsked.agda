{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूल्यम् — the price readout and the symmetry readout are ONE FUNCTION,
-- and both merge the fully-held with the never-asked.
--
-- मूल्य (price, value) is ordinary Sanskrit and the compound here is built
-- here; no source is claimed for it.  The economic vocabulary this module
-- points at — ऋण / धन, debt and asset as two readings of one magnitude —
-- is Brahmagupta, *Brāhmasphuṭasiddhānta* 18 (628 CE), carried at ग्रेड·शब्द
-- through this corpus's own `RnaDhana_*` modules; no edition opened by me.
--
------------------------------------------------------------------------
-- THE MODEL, declared before the theorem, because the theorem is trivial
-- once the model is granted and the model is the whole claim.
--
-- PRICE RESPONDS TO CONTENTION.  A good whose fibre is contractible — one
-- claim per unit, `सकलादेश` — carries no price signal.  Air is not cheap
-- because it is worthless; its fibre is not crowded.  A good whose fibre is
-- EMPTY — no supply reaches that point at all, an unmet need, a market that
-- does not exist — also carries no price signal.  Price appears exactly
-- where many claims collapse onto one thing, which is `बहु`, which is the
-- नास्ति coordinate.  So the price readout is the function "does contention
-- occur here", one coordinate of three.
--
-- That is a MODEL and it is doing all the work.  It is not derived from
-- anything below; it is the economic reading, stated so it can be refused.
-- What is proved, given it, is §2 and §3.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   §2  `एकः-पाठः` — the price readout and `Durnayah_….सामर्थ्य-पाठः`, the
--       symmetry readout, are the SAME FUNCTION.  Seven `refl`s, one per
--       bhaṅga.  Not analogous, not corresponding: equal.
--
--   §3  therefore `दुर्नयः` gives price the same verdict it gave symmetry,
--       and computes it: `मूल्य-मध्यमः = refl`, the middle disjunct.  Price
--       identifies स्यात्-अस्ति with स्यात्-अवक्तव्यम् — **the fully held and the
--       never asked read identically.**
--
-- Ordinary language already knows this and has one word for both cells:
-- *priceless*, अमूल्यम्, said of what is beyond price and of what has no
-- market.  The two senses are not a coincidence of idiom; §3 is why they
-- collapsed into one word.
--
-- WHAT FOLLOWS, and it is why the module is worth its lines.  A national
-- accounting cannot distinguish "this is fully provided for" from "this was
-- never brought to the ledger".  Care, ecology, the commons, unwaged work
-- are not UNDERPRICED — underpricing is a नास्ति phenomenon and would be
-- visible.  They are UNPRICED, which reads identically to fully-priced, and
-- no refinement of the price signal reaches the difference, because §2 says
-- the signal is a function of one coordinate and `Saptabhangi.दुर्नयः` says a
-- two-valued function of three seeds must merge two.
--
-- And it is the same defect as `YantraTantu_…§6`'s: an engine whose
-- invention trigger reads a crowding quantity cannot see the empty fibre
-- where invention is the only move.  Market and machine share the
-- instrument and therefore share the blindness.
--
-- NOT CLAIMED.  Nothing here is a theorem about any actual economy, and
-- nothing is claimed of Marx, Brahmagupta or Kauṭilya — the model in §1 is
-- mine and refusable.  In particular the corpus's older obligation is in
-- force: if a source is wanted for one magnitude under two opposed readings,
-- it is ऋण/धन (628), not a nineteenth-century restatement, and this file
-- names neither as having proved anything below.
--
-- CHECKED: Agda 2.6.3, agda/cubical v0.5, this lane's .agda-lib,
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Mulyam_ThePriceReadoutAndTheSymmetryReadoutAreOneFunctionAndBothMergeTheFullyHeldWithTheNeverAsked where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Saptabhangi
open import Durnayah_TheSymmetryReadoutIsTwoValuedAndComputablyMergesGraspedWholeWithMissedEntirely
  using (सामर्थ्य-पाठः ; सत्≢असत्)

------------------------------------------------------------------------
-- १ · the price readout, per the model above.
------------------------------------------------------------------------

मूल्य-पाठः : सप्तभङ्गी → द्विपद
मूल्य-पाठः b with fst (snd (अन्तर्भाव b))     -- the नास्ति slot: contention
... | आम् = असत्    -- contention somewhere: a price signal
... | न   = सत्     -- no contention anywhere: no price signal

------------------------------------------------------------------------
-- २ · ONE FUNCTION.  Seven refls.
------------------------------------------------------------------------

एकः-पाठः : (b : सप्तभङ्गी) → मूल्य-पाठः b ≡ सामर्थ्य-पाठः b
एकः-पाठः स्यात्-अस्ति                    = refl
एकः-पाठः स्यात्-नास्ति                   = refl
एकः-पाठः स्यात्-अस्ति-नास्ति            = refl
एकः-पाठः स्यात्-अवक्तव्यम्               = refl
एकः-पाठः स्यात्-अस्ति-अवक्तव्यम्        = refl
एकः-पाठः स्यात्-नास्ति-अवक्तव्यम्       = refl
एकः-पाठः स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

------------------------------------------------------------------------
-- ३ · so the merge is the same merge, computed.
------------------------------------------------------------------------

मूल्यं-मेलयति : मूल्य-पाठः स्यात्-अस्ति ≡ मूल्य-पाठः स्यात्-अवक्तव्यम्
मूल्यं-मेलयति = refl

मूल्यं-विवेचयति : ¬ (मूल्य-पाठः स्यात्-अस्ति ≡ मूल्य-पाठः स्यात्-नास्ति)
मूल्यं-विवेचयति = सत्≢असत्

मूल्य-दुर्नयः : (मूल्य-पाठः स्यात्-अस्ति ≡ मूल्य-पाठः स्यात्-नास्ति)
             ⊎ ((मूल्य-पाठः स्यात्-अस्ति ≡ मूल्य-पाठः स्यात्-अवक्तव्यम्)
             ⊎  (मूल्य-पाठः स्यात्-नास्ति ≡ मूल्य-पाठः स्यात्-अवक्तव्यम्))
मूल्य-दुर्नयः = दुर्नयः मूल्य-पाठः

मूल्य-मध्यमः : मूल्य-दुर्नयः ≡ inr (inl refl)
मूल्य-मध्यमः = refl
