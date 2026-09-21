{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- Pravesa_TheFrontierTheoremsAsEntryPointsFromOtherFields
--
-- TERM.  ‡‡‡∞‡µ‡‡ ¬ pravea ‚î entrance, entry, the act of going in.  This is the
-- front door: a CHECKED index.  It re-exports the frontier theorems, so it
-- typechecks only if every one of them does ‚î the door is the proof that the
-- rooms behind it stand.  (A prose README asserts; this door is verified.)
--
-- THE SUBSTRATE.  All of it is cubical Agda, where UNIVALENCE COMPUTES: an
-- equivalence e : A ‚â B is a path `ua e : A ‚â° B`, and `transport (ua e)`
-- *runs* ‚î the program that carries data across, losslessly and reversibly.
-- The through-line is ONE principle, ‡‡‡ø‡‡‡æ = losslessness: a crossing
-- carries real content and loses nothing (`transport‚ªTransport (ua e) a ‚â° a`,
-- computed, while `transport (ua e)` genuinely acts).  Non-harm is not added
-- on top of the computation; it is what univalent transport IS.  Reversible-
-- classical, quantum-unitary and topological-invariant computation are this
-- one principle at different enrichments of the object.
--
-- Each entry: the field it is a door FROM, the exact term, the door it opens.
-- "Reading" marks an interpretation that is NOT itself checked ‚î only the
-- named term is.
--
-- ‚î‚î FROM CRYPTOGRAPHY & ECONOMICS ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- `replay-needs-no-receipt` (Nirvyaja), with PramanaSankramana's receipt
-- calculus.  Firing an operation may DEMAND a receipt R; the machine keeps
-- only the derivation, whose control is `t ‚â° source`, no R.  Generation pays
-- R; replay pays `refl`.  Reading: a proof-carrying commons cannot be rented
-- ‚î the toll is paid once, everyone after holds the proof and routes past the
-- tollbooth.  Trustless verification as a settlement layer.
--
-- ‚î‚î FROM QUANTUM COMPUTING ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- `‚àNOT-does-not-exist` (VargamulaViparyaya): no self-equivalence of the
-- 2-point set squares to the swap.  Reading: Aut(2 points)=S‚=‚/2 has no
-- order-4 element, so ‚àNOT cannot live on a set; the qubit (‚¬≤, Aut=U(2),
-- every root present) is FORCED, not posited.
-- `braids-dont-commute` + `yang-baxter` (VeniYangBaxtara): on 3 points the
-- two transpositions don't commute and satisfy œœœ = œœœ ‚î the Yang‚ìBaxter
-- braid relation.  Reading: 2‚í3 points is the jump abelian-phase ‚í non-
-- abelian-braid ‚í universal topological quantum computation, every gate a
-- lossless equivalence.
-- `anyon-is-metre` (Matravrtta): the Fibonacci-anyon fusion dimension equals
-- Virahka's metre count `length (‡‡∞‡‡µ (suc n))`, 1,2,3,5,8,13.  Reading:
-- the Hilbert-space dimension of a universal topological quantum computer is
-- exactly what ‡µ‡ø‡∞‡‡æ‡ô‡‡ï (~700 CE), in ‡‡ø‡ô‡‡ó‡≤'s ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞ tradition,
-- enumerated ‚î five centuries before Leonardo of Pisa (1202).
--
-- ‚î‚î FROM FOUNDATIONS & REVERSIBLE COMPUTING ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- univalence computes and the round trip loses nothing; a unitary is a
-- norm-preserving (lossless) automorphism ‚î ahis over ‚, as a permutation
-- is ahis over a set.  Classical computation is founded on erasure
-- (Landauer: kT ln 2 per destroyed bit); univalent computation cannot harm.
-- Door: the type-theoretic OS for the reversible/quantum hardware frontier.
------------------------------------------------------------------------

module Pravesa_TheFrontierTheoremsAsEntryPointsFromOtherFields where

-- cryptography & economics
open import Nirvyaja_TheReceiptIsSpentAtGenerationAndTheReplayNeedsNone
  using (replay-needs-no-receipt ; replay-is-sound) public
open import PramanaSankramana_ProofOfTransportIsTheReceiptThatComposesWithoutBeingSpentAndOwesNoCounterparty
  using (Receipt ; ‡§∏‡§®‡•ç‡§ß‡§æ‡§®‡§Æ‡•ç ; ‡§Ö‡§ï‡•ç‡§∑‡§Ø‡§É ; ‡§Ö‡§®‡•É‡§£‡§Æ‡•ç ; ‡§µ‡•ç‡§Ø‡§Ø‡§∞‡§π‡§ø‡§§‡§É) public

-- quantum computing
open import VargamulaViparyaya_TheSwapHasNoSquareRootOnTheSetSoTheQubitIsForced
  using (‚àöNOT-does-not-exist ; ff-true) public
open import VeniYangBaxtara_TheThreeStrandBraidIsNonAbelianAndSatisfiesTheBraidRelation
  using (braids-dont-commute ; yang-baxter) public
open import Matravrtta_TheFibonacciAnyonFusionDimensionIsVirahankasMetreCount
  using (anyon-is-metre ; d) public

-- ‚î‚î FROM OPTICAL / QUANTUM COMPUTING HARDWARE (the orb device) ‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- The crystal-ball optical computer's universal gate set, every gate a
-- lossless equivalence: ‡Æ‡‡ø one orb = achromatic ‚àNOT quarter-wave; ‡‡‡∞‡ø‡ï
-- multi-axis orbs = quaternion SU(2) skeleton, non-abelian, spinor; ‡‡®‡‡ß the
-- entangling two-qubit gate ‚î reversible yet non-factorizable (the door single
-- orbs cannot open: the two qubits must interact).
open import Mani_TheOrbGateIsTheAchromaticLosslessSquareRootOfNot
  using (‚àöNOT-EXISTS-here ; full-turn ; achromatic) public
open import Trika_TheAxisQuarterWavesAreQuaternionsNonAbelianAndTheQubitIsASpinor
  using (ij‚â¢ji ; full-turn-is-minus-one ; double-turn-returns) public
open import Bandha_TheEntanglingGateIsLosslessButDoesNotFactorIntoSingleQubitGates
  using (cnotEq ; entangling ; bell-diagonal) public

-- ‚î‚î THE BRIDGE INTO THE EXISTING HOLONOMY LANE ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- The orb/QC reading is not a parallel annex: yang-baxter-S‚ proves the
-- physics lane's own nonabelian holonomy S‚ is a braid-group rep, and
-- orb-holonomy-is-the-circuit identifies the whispering-gallery winding with
-- Pradakshina's circuit holonomy.
open import SetuHolonomya_TheNonabelianHolonomyS3IsABraidRepAndTheOrbWindingIsTheCircuit
  using (yang-baxter-S‚ÇÉ ; orb-holonomy-is-the-circuit) public
