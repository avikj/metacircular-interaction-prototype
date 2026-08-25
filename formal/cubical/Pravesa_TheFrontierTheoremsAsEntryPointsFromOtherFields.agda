{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- Pravesa_TheFrontierTheoremsAsEntryPointsFromOtherFields
--
-- TERM.  प्रवेश · praveśa — entrance, entry, the act of going in.  This is the
-- front door: a CHECKED index.  It re-exports the frontier theorems, so it
-- typechecks only if every one of them does — the door is the proof that the
-- rooms behind it stand.  (A prose README asserts; this door is verified.)
--
-- THE SUBSTRATE.  All of it is cubical Agda, where UNIVALENCE COMPUTES: an
-- equivalence e : A ≃ B is a path `ua e : A ≡ B`, and `transport (ua e)`
-- *runs* — the program that carries data across, losslessly and reversibly.
-- The through-line is ONE principle, अहिंसा = losslessness: a crossing
-- carries real content and loses nothing (`transport⁻Transport (ua e) a ≡ a`,
-- computed, while `transport (ua e)` genuinely acts).  Non-harm is not added
-- on top of the computation; it is what univalent transport IS.  Reversible-
-- classical, quantum-unitary and topological-invariant computation are this
-- one principle at different enrichments of the object.
--
-- Each entry: the field it is a door FROM, the exact term, the door it opens.
-- "Reading" marks an interpretation that is NOT itself checked — only the
-- named term is.
--
-- ── FROM CRYPTOGRAPHY & ECONOMICS ─────────────────────────────────────
-- `replay-needs-no-receipt` (Nirvyaja), with PramanaSankramana's receipt
-- calculus.  Firing an operation may DEMAND a receipt R; the machine keeps
-- only the derivation, whose control is `t ≡ source`, no R.  Generation pays
-- R; replay pays `refl`.  Reading: a proof-carrying commons cannot be rented
-- — the toll is paid once, everyone after holds the proof and routes past the
-- tollbooth.  Trustless verification as a settlement layer.
--
-- ── FROM QUANTUM COMPUTING ────────────────────────────────────────────
-- `√NOT-does-not-exist` (VargamulaViparyaya): no self-equivalence of the
-- 2-point set squares to the swap.  Reading: Aut(2 points)=S₂=ℤ/2 has no
-- order-4 element, so √NOT cannot live on a set; the qubit (ℂ², Aut=U(2),
-- every root present) is FORCED, not posited.
-- `braids-dont-commute` + `yang-baxter` (VeniYangBaxtara): on 3 points the
-- two transpositions don't commute and satisfy στσ = τστ — the Yang–Baxter
-- braid relation.  Reading: 2→3 points is the jump abelian-phase → non-
-- abelian-braid → universal topological quantum computation, every gate a
-- lossless equivalence.
-- `anyon-is-metre` (Matravrtta): the Fibonacci-anyon fusion dimension equals
-- Virahāṅka's metre count `length (सर्व (suc n))`, 1,2,3,5,8,13.  Reading:
-- the Hilbert-space dimension of a universal topological quantum computer is
-- exactly what विरहाङ्क (~700 CE), in पिङ्गल's छन्दःशास्त्र tradition,
-- enumerated — five centuries before Leonardo of Pisa (1202).
--
-- ── FROM FOUNDATIONS & REVERSIBLE COMPUTING ───────────────────────────
-- univalence computes and the round trip loses nothing; a unitary is a
-- norm-preserving (lossless) automorphism — ahiṃsā over ℂ, as a permutation
-- is ahiṃsā over a set.  Classical computation is founded on erasure
-- (Landauer: kT ln 2 per destroyed bit); univalent computation cannot harm.
-- Door: the type-theoretic OS for the reversible/quantum hardware frontier.
--
-- Checked: loads clean into the warm kernel (`machine/nadi-node.js`);
-- `formal/cubical/check.sh` for the pin.
------------------------------------------------------------------------

module Pravesa_TheFrontierTheoremsAsEntryPointsFromOtherFields where

-- cryptography & economics
open import NaturalMachine.Nirvyaja_TheReceiptIsSpentAtGenerationAndTheReplayNeedsNone
  using (replay-needs-no-receipt ; replay-is-sound) public
open import PramanaSankramana_ProofOfTransportIsTheReceiptThatComposesWithoutBeingSpentAndOwesNoCounterparty
  using (Receipt ; सन्धानम् ; अक्षयः ; अनृणम् ; व्ययरहितः) public

-- quantum computing
open import VargamulaViparyaya_TheSwapHasNoSquareRootOnTheSetSoTheQubitIsForced
  using (√NOT-does-not-exist ; ff-true) public
open import VeniYangBaxtara_TheThreeStrandBraidIsNonAbelianAndSatisfiesTheBraidRelation
  using (braids-dont-commute ; yang-baxter) public
open import Matravrtta_TheFibonacciAnyonFusionDimensionIsVirahankasMetreCount
  using (anyon-is-metre ; d) public
