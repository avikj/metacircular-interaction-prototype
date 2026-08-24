{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परार्थानुमानम् — inference for another.  Siddhasena Divākara,
-- *Nyāyāvatāra* (c. 5th–7th c. CE), the classical division: svārtha,
-- inference for oneself, against parārtha, inference set out for
-- another.  School named: Jaina.  The corpus already carries the
-- svārtha half (SvarthaAnumana: the machine infers for itself, the
-- pervasion grasped within); this module is the other half, and it is
-- the NET: what one standpoint proves for itself crosses to another
-- AS a parārtha utterance — the rule with its certificate — and the
-- receiver extends its record without re-proving, because the type
-- carries the warrant.  Transport instead of trust (IndraJala).
-- Claimed of the source: the division and its names, nothing else.
--
-- WHAT IS SET UP.  Two standpoints of the one knowing:
--
--   अ — the norm eye with the syntactic exchange (सूक्ष्म-यन्त्रम्)
--   ब — the factoring heap eye with the surgical exchange (राशि-यन्त्रम्)
--
-- Each can breathe the elder's store alone; and they can HOLD COUNCIL
-- (संवादः): breathe in turn on one shared record, each pass re-offering
-- only the residue the other could not close.  Every rule that crosses
-- between them carries its साक्षी by construction, so the exchange
-- verifies nothing and loses nothing.
--
-- WHAT THE COMPILED RUN MEASURED (2026-08-24, this container, the
-- elder's 102), kept because the first title of this module claimed
-- more than the measurement allows.  Alone, standpoints reach:
--
--   norm+सूक्ष्म 93   norm+राशि 94   norm+संयुक्त 94
--   गूढ+सूक्ष्म 101   गूढ+राशि 102   गूढ+संयुक्त 102
--
-- so on THIS store the factoring heap eye with the surgical exchange
-- DOMINATES — राशि alone suffices for all 102, the composite
-- instrument buys nothing here (the kernel census had only ever been
-- run with संयुक्त; this is new).  The council of अ and ब reaches 102,
-- which is ब's own reach: the exchange lifts the weaker standpoint
-- (+9) and costs the stronger nothing.  And the near-miss pair was
-- probed: गूढ+सूक्ष्म (101) in council with norm+राशि (94) reaches
-- 101, NOT 102 — the one rule गूढ+सूक्ष्म misses needs the surgery
-- itself, no current standpoint's testimony substitutes for it.  So
-- "the net reaches what neither alone can" is REFUTED at n=2 with
-- these organs on this store; what survives, measured, is the lift of
-- the weaker and the price-free-ness of the exchange.  A strict-gain
-- pair, if one exists, needs organs with incomparable blindness —
-- that is the open item this module leaves.
------------------------------------------------------------------------

module PararthaAnumana_TheWarrantedExchangeLiftsTheWeakerStandpointAndTheMeasuredStoreHasADominatingEye where

open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Sigma using (_,_ ; fst ; snd)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Eq')
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using ( नियमः ; दृक् ; यन्त्रम् ; नेत्रम्-न ; गूढ-दृक्
        ; सूक्ष्म-यन्त्रम् ; राशि-यन्त्रम् ; नय-प्राणः ; इन्धनम् ; _×_ )

------------------------------------------------------------------------
-- §1  The two standpoints.
------------------------------------------------------------------------

अ-दृक् : दृक्
अ-दृक् = नेत्रम्-न

अ-यन्त्रम् : यन्त्रम्
अ-यन्त्रम् = सूक्ष्म-यन्त्रम्

ब-दृक् : दृक्
ब-दृक् = गूढ-दृक्

ब-यन्त्रम् : यन्त्रम्
ब-यन्त्रम् = राशि-यन्त्रम्

------------------------------------------------------------------------
-- §2  Alone: one standpoint breathes to its own quiet.
------------------------------------------------------------------------

एकाकी : दृक् → यन्त्रम् → List Eq' → List नियमः × List Eq'
एकाकी E Y es = नय-प्राणः E Y इन्धनम् [] es

------------------------------------------------------------------------
-- §3  The council: the two breathe in turn on ONE shared record.
--     Every rule either mints carries its certificate, so the record
--     each hands the other is received whole — parārtha, warranted,
--     nothing re-proven, nothing taken on authority.
------------------------------------------------------------------------

संवादः : Nat → List नियमः → List Eq' → List नियमः × List Eq'
संवादः zero    Γ es = Γ , es
संवादः (suc n) Γ es = next
  where
  अ-फलम् : List नियमः × List Eq'
  अ-फलम् = नय-प्राणः अ-दृक् अ-यन्त्रम् इन्धनम् Γ es

  ब-फलम् : List नियमः × List Eq'
  ब-फलम् = नय-प्राणः ब-दृक् ब-यन्त्रम् इन्धनम् (fst अ-फलम्) (snd अ-फलम्)

  next : List नियमः × List Eq'
  next = संवादः n (fst ब-फलम्) (snd ब-फलम्)
