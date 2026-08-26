{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Everything
--
-- The single entry point: typechecking this module typechecks the library.
-- check.sh drives exactly this file, so a module that is not reachable from
-- here is verified by nothing.

module Everything where

-- The law, and the machinery it generates.
open import Fibre.Carrier
open import Fibre.Orbit
open import Fibre.Nucleus

-- The law's other projection: the residual, and the price of a refusal.
-- Its two-valued test is a दुर्नय; see the struck paragraph in its header.
open import Fibre.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

-- The repair: the diagnosis is a CENSUS, not a verdict.  A fibre fails to
-- be contractible in two opposite ways — empty (नास्ति: no source over b,
-- धनात्मकम्) and crowded (नष्टि, अप्रतिकार्या) — and `isContr` merges
-- them.  Contains the computed refutation of the sequential diagnostic.
open import Fibre.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic

-- …and the census's own collapse, one level up.  A fourth outcome exists
-- that `देश` structurally cannot express — the question with no subject —
-- and `interactive/Obstruction.hs` has carried it in a type all along while
-- the Agda lane has never had it.  Silence is not denial.
open import Fibre.Adharmin_TheUnposedQuestionIsNotAnEmptyFibreAndTheCensusCannotSayIt

-- The arithmetic instance, and the proof that it computes.
open import Fibre.Viveka
open import Fibre.Compute

-- The two number-theoretic instances.
--
-- कुट्टक (Āryabhaṭa, Āryabhaṭīya, गणितपाद 32–33, 499 CE): base = the three
-- slots पक्षः / परिमाणम् / शेषः, none of which is a function of the other
-- two — three theorems say so — and carried = the pair of magnitudes.
open import Fibre.KuttakaValli_TheSideIsAFreeSlotAndThatIsWhatMakesTheStepDecisionFree

-- वर्गप्रकृति (Brahmagupta, Brāhmasphuṭasiddhānta 18, 628 CE; the चक्रवाल
-- of Jayadeva c. 950 and Bhāskara II, Bījagaṇita, 1150): base = the two
-- roots ज्येष्ठ / कनिष्ठ over ℤ, carried = the क्षेप a² − D b², which the
-- roots determine exactly.
open import Fibre.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt

-- स्थानिवद्भाव (Pāṇini, Aṣṭādhyāyī 1.1.56 स्थानिवदादेशोऽनल्विधौ, ~500 BCE;
-- with 1.1.60, 1.1.62, 1.3.9, 1.1.5): a वर्ण's three fields are mutually
-- independent — three theorems say so — so the base is (वर्ण , the form
-- substituted) and the carried datum is (स्थानी , सञ्ज्ञा) of the output,
-- both functions of the base.  The अल्/अनल् exception of 1.1.56 is the
-- base/carried split, and the orbit carries the designation through the
-- whole derivation rather than one step.
open import Fibre.Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried

-- भित्ति: the carrier is not two-valued, and the wall crosses its own ford.
open import Fibre.BhittiSthanivat_PaninisCarrierIsNotTwoValuedAndTheWallCrossesItsOwnFord

-- स्थानिवत्सङ्ख्या — the machine's own frontier ask (jīva join score 2970):
-- the ādeśa state space enumerated, स्थानिवत् ≃ Fin 81, the carried datum
-- adding nothing to the count — ahiṃsā read as a number.
open import Fibre.SthanivatSankhya_TheAdesaStateSpaceIsExactlyEightyOneAndTheJoinToTheNumberComponentIsChecked

-- जीविता-स्मृति — the carried memory is alive at every depth of the infinite
-- orbit: at rung n it is योग of the n-th state, never a stale payload.
-- पुनरागमन read forward into infinity — losslessness as उपयोग at every rung.
open import Fibre.JivitaSmrti

------------------------------------------------------------------------
-- The generalisation: from lossless RE-PRESENTATION to lossless
-- COMPUTATION, and from an unfolding stream to an interaction.
--
-- `Fibre.Carrier` proves that a computation may carry its own image and
-- the witness that it IS that image at no informational cost, because the
-- fibre singl (f a) is contractible.  That is a change of PRESENTATION.
-- The four modules below are the change of COMPUTATION and of STATE, and
-- the boundary between the two is the whole point:
--
--   univalence transports a PROVED EQUIVALENCE.  It does not turn a
--   many-to-one map into one, and nothing here pretends otherwise.
--
-- WHAT IS NOT ESTABLISHED BY ANY OF IT, stated here because a library
-- that only lists its theorems has dropped half its witness:
--
--   * effects, capability, disclosure, authority.  `Conservative` has two
--     fields and both are mathematics.  Naming a field `Admissible` does
--     not make a system admissible; no obligation of that kind is
--     expressed by the shape of these records or smuggled in by their
--     vocabulary.
--   * higher coherence.  `Commutes` is ONE path between two composites.
--     That several such squares assemble into a filled cube is a further
--     obligation, and proving the faces does not prove the cube.
--   * strategies with memory.  A strategy in `Fibre.Samvada_…` is a
--     function of the state alone; histories, protocols and adversaries
--     are not modelled.
--   * cost.  Nothing here says a trace is small, cheap to store, or safe
--     to transmit.  It says what it is.
--   * verifier correctness, protocol security, availability, revocation,
--     key recovery, privacy accounting, measurement integrity, upgrade
--     governance, specification adequacy.  None of these is a corollary
--     of a transport law, and none of them appears below.
------------------------------------------------------------------------

-- The trace family of a factorisation is FORCED to be the fibre family of
-- the map it induces — so the residue of a computation is not a design
-- choice.  Carrier is the contractible end of that same scale.
open import Fibre.Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase

-- A state transition need not be invertible for its residue to be typed.
-- `collapse` (n ↦ 0) is the witness: provably not an equivalence, residue
-- provably ℕ, and lossless all the same.  `suc` is the opposite failure —
-- an EMPTY fibre — which isContr alone cannot distinguish from the first.
open import Fibre.LawfulStep_TheVisibleStepNeedNotBeInvertibleAndItsResidueIsStillExactlyOneFibre

-- Commutation is the certificate that a serialisation was removable: any
-- interleaving of two commuting steps reduces to the two counts.  When it
-- fails, it fails computably, and the order stays in the answer.
open import Fibre.Krama_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained

-- The orbit is the one-query case of the interactive coalgebra: under the
-- deterministic embedding every strategy observes the same prefix, and
-- `counter` shows that in general two strategies disagree at step one.
open import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers
