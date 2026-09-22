{-# OPTIONS --cubical --safe --guardedness #-}

-- Punargamana ¬ Everything
--
-- The single entry point: typechecking this module typechecks the library.
-- check.sh drives exactly this file, so a module that is not reachable from
-- here is verified by nothing.

module Everything where

-- The law, and the machinery it generates.
open import Fibre.Carrier
open import Fibre.Orbit
open import Fibre.Nucleus

-- The law's other projection: the residual, and the price of a collapse.
open import Fibre.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

-- The repair: the diagnosis is a CENSUS, not a verdict.  A fibre fails to
-- be contractible in two opposite ways ‚î empty (‡®‡æ‡‡‡‡ø: no source over b,
-- ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡) and crowded (‡®‡‡‡ü‡ø, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ) ‚î and `isContr` merges
-- them.  Contains the computed refutation of the sequential diagnostic.
open import Fibre.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic

-- The census's seam, closed: the fibre of the truncation map is the whole
-- source, so the level-‡ criterion is a theorem and not a conjecture.
open import Fibre.Avaccheda_TheTruncationsFibreIsTheWholeSourceSoTheSeamConjectureIsATheorem

-- ‚¶and the census's own collapse, one level up.  A fourth outcome exists
-- that `‡¶‡‡` structurally cannot express ‚î the question with no subject ‚î
-- and `interactive/Obstruction.hs` has carried it in a type all along while
-- the Agda lane has never had it.  Silence is not denial.
open import Fibre.Adharmin_TheUnposedQuestionIsNotAnEmptyFibreAndTheCensusCannotSayIt

-- The arithmetic instance, and the proof that it computes.
open import Fibre.Viveka
open import Fibre.Compute

-- The two number-theoretic instances.
--
-- ‡ï‡‡ü‡‡ü‡ï (ryabhaa, ryabhaya, ‡ó‡‡ø‡‡‡æ‡¶ 32‚ì33, 499 CE): base = the three
-- slots ‡‡ï‡‡‡ / ‡‡∞‡ø‡Æ‡æ‡‡Æ‡ / ‡‡‡‡, none of which is a function of the other
-- two ‚î three theorems say so ‚î and carried = the pair of magnitudes.
open import Fibre.KuttakaValli_TheSideIsAFreeSlotAndThatIsWhatMakesTheStepDecisionFree

-- ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø (Brahmagupta, Brhmasphuasiddhnta 18, 628 CE; the ‡‡ï‡‡∞‡µ‡æ‡≤
-- of Jayadeva c. 950 and Bhskara II, Bjagaita, 1150): base = the two
-- roots ‡‡‡Ø‡‡‡‡† / ‡ï‡®‡ø‡‡‡† over ‚, carried = the ‡ï‡‡‡‡ a¬≤ ‚àí D b¬≤, which the
-- roots determine exactly.
open import Fibre.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt

-- ‡‡‡‡æ‡®‡ø‡µ‡¶‡‡‡æ‡µ (Pini, Adhyy 1.1.56 ‡‡‡‡æ‡®‡ø‡µ‡¶‡æ‡¶‡‡‡ã‡Ω‡®‡≤‡‡µ‡ø‡ß‡, ~500 BCE;
-- with 1.1.60, 1.1.62, 1.3.9, 1.1.5): a ‡µ‡∞‡‡'s three fields are mutually
-- independent ‚î three theorems say so ‚î so the base is (‡µ‡∞‡‡ , the form
-- substituted) and the carried datum is (‡‡‡‡æ‡®‡ , ‡‡û‡‡‡‡û‡æ) of the output,
-- both functions of the base.  The ‡‡≤‡/‡‡®‡≤‡ exception of 1.1.56 is the
-- base/carried split, and the orbit carries the designation through the
-- whole derivation rather than one step.
open import Fibre.Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried

-- ‡‡ø‡‡‡‡ø: the carrier is not two-valued, and the wall crosses its own ford.
open import Fibre.BhittiSthanivat_PaninisCarrierIsNotTwoValuedAndTheWallCrossesItsOwnFord

-- ‡‡‡‡æ‡®‡ø‡µ‡‡‡‡ô‡‡ñ‡‡Ø‡æ ‚î the machine's own frontier ask (jva join score 2970):
-- the dea state space enumerated, ‡‡‡‡æ‡®‡ø‡µ‡‡ ‚â Fin 81, the carried datum
-- adding nothing to the count ‚î ahis read as a number.
open import Fibre.SthanivatSankhya_TheAdesaStateSpaceIsExactlyEightyOneAndTheJoinToTheNumberComponentIsChecked

-- ‡‡‡µ‡ø‡‡æ-‡‡‡Æ‡‡‡ø ‚î the carried memory is alive at every depth of the infinite
-- orbit: at rung n it is ‡Ø‡ã‡ó of the n-th state, never a stale payload.
-- ‡‡‡®‡∞‡æ‡ó‡Æ‡® read forward into infinity ‚î losslessness as ‡â‡‡Ø‡ã‡ó at every rung.
open import Fibre.JivitaSmrti

-- The naming of the law: Carrier IS the motive (the universal lossless
-- middle), each projection of ¬ßSesa's graph is a realization, and every
-- map factors as realize ‚àò to-motive (middle-out).  Adds the mediation:
-- two realizations of one motive-source translate through the shared
-- middle rather than by a direct compiler.
open import Fibre.TheCarrierIsTheMotiveAndEachReadingIsARealization

-- A reading, as a reusable shape: a collapse into a set, with its kept
-- middle (Carrier) and owed residual (‡‡‡) derived at the record level,
-- and the two halves of the law as its derived theorems.  The verdict
-- reading (Bool ‚í Unit) is a checked instance; the six domain readings
-- named in the kernel overview instantiate this shape in their own files.
open import Fibre.AReadingIsACollapseWithItsKeptMiddleAndOwedResidual
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
--   * strategies with memory.  A strategy in `Fibre.Samvada_‚¶` is a
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
-- the map it induces ‚î so the residue of a computation is not a design
-- choice.  Carrier is the contractible end of that same scale.
open import Fibre.Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase

-- A state transition need not be invertible for its residue to be typed.
-- `collapse` (n ‚¶ 0) is the witness: provably not an equivalence, residue
-- provably ‚ï, and lossless all the same.  `suc` is the opposite failure ‚î
-- an EMPTY fibre ‚î which isContr alone cannot distinguish from the first.
open import Fibre.LawfulStep_TheVisibleStepNeedNotBeInvertibleAndItsResidueIsStillExactlyOneFibre

-- Commutation is the certificate that a serialisation was removable: any
-- interleaving of two commuting steps reduces to the two counts.  When it
-- fails, it fails computably, and the order stays in the answer.
open import Fibre.Krama_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained

-- The orbit is the one-query case of the interactive coalgebra: under the
-- deterministic embedding every strategy observes the same prefix, and
-- `counter` shows that in general two strategies disagree at step one.
open import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers

-- The formal corpus itself is the same coalgebra: a state is Œ A . A and a
-- question is exactly a typed map out of the current A.  No finite-depth
-- approximation or external scheduler is introduced.
open import Fibre.CorpusSamvada

-- Mechanical bridge from the active Agda namespace to one raw checked value.
open import Fibre.CorpusReflection
