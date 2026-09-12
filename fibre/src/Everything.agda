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

-- The law's other projection: the residual, and the price of a collapse.
-- Its two-valued test is a दुर्नय; see the struck paragraph in its header.
open import Fibre.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

-- The repair: the diagnosis is a CENSUS, not a verdict.  A fibre fails to
-- be contractible in two opposite ways — empty (नास्ति: no source over b,
-- धनात्मकम्) and crowded (नष्टि, अप्रतिकार्या) — and `isContr` merges
-- them.  Contains the computed refutation of the sequential diagnostic.
open import Fibre.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic

-- The census's seam, closed: the fibre of the truncation map is the whole
-- source, so the level-४ criterion is a theorem and not a conjecture.
open import Fibre.Avaccheda_TheTruncationsFibreIsTheWholeSourceSoTheSeamConjectureIsATheorem

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
-- substituted) and carried = (स्थानी , सञ्ज्ञा) of the output.
open import Fibre.Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried

open import Fibre.BhittiSthanivat_PaninisCarrierIsNotTwoValuedAndTheWallCrossesItsOwnFord
open import Fibre.SthanivatSankhya_TheAdesaStateSpaceIsExactlyEightyOneAndTheJoinToTheNumberComponentIsChecked
open import Fibre.JivitaSmrti
open import Fibre.TheCarrierIsTheMotiveAndEachReadingIsARealization
open import Fibre.AReadingIsACollapseWithItsKeptMiddleAndOwedResidual

-- The generalisation from representation to computation.
open import Fibre.Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase
open import Fibre.LawfulStep_TheVisibleStepNeedNotBeInvertibleAndItsResidueIsStillExactlyOneFibre
open import Fibre.Krama_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained
open import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers

-- The corpus itself as the same guarded interactive coalgebra: state is
-- Σ A . A, questions are exactly typed maps out of the current A, and the
-- successor is ordinary application.  Carrier then lifts any reading of that
-- state into an equivalent carried presentation of the whole interaction.
open import Fibre.CorpusSamvada
