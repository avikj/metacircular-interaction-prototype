{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Everything
--
-- The single entry point: typechecking this module typechecks the library.
-- check.sh drives exactly this file, so a module that is not reachable from
-- here is verified by nothing.

module Everything where

-- The law, and the machinery it generates.
open import Fiber.Carrier
open import Fiber.Orbit
open import Fiber.Nucleus

-- The law's other projection: the residual, and the price of a refusal.
-- Its two-valued test is a दुर्नय; see the struck paragraph in its header.
open import Fiber.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

-- The repair: the diagnosis is a CENSUS, not a verdict.  A fiber fails to
-- be contractible in two opposite ways — empty (नास्ति: no source over b,
-- धनात्मकम्) and crowded (नष्टि, अप्रतिकार्या) — and `isContr` merges
-- them.  Contains the computed refutation of the sequential diagnostic.
open import Fiber.SakalaVikalaDesa_TheFiberCensusIsATermAndItRefutesTheSequentialDiagnostic

-- …and the census's own collapse, one level up.  A fourth outcome exists
-- that `देश` structurally cannot express — the question with no subject —
-- and `interactive/Obstruction.hs` has carried it in a type all along while
-- the Agda lane has never had it.  Silence is not denial.
open import Fiber.Adharmin_TheUnposedQuestionIsNotAnEmptyFiberAndTheCensusCannotSayIt

-- The arithmetic instance, and the proof that it computes.
open import Fiber.Viveka
open import Fiber.Compute

-- The two number-theoretic instances.
--
-- कुट्टक (Āryabhaṭa, Āryabhaṭīya, गणितपाद 32–33, 499 CE): base = the three
-- slots पक्षः / परिमाणम् / शेषः, none of which is a function of the other
-- two — three theorems say so — and carried = the pair of magnitudes.
open import Fiber.KuttakaValli_TheSideIsAFreeSlotAndThatIsWhatMakesTheStepDecisionFree

-- वर्गप्रकृति (Brahmagupta, Brāhmasphuṭasiddhānta 18, 628 CE; the चक्रवाल
-- of Jayadeva c. 950 and Bhāskara II, Bījagaṇita, 1150): base = the two
-- roots ज्येष्ठ / कनिष्ठ over ℤ, carried = the क्षेप a² − D b², which the
-- roots determine exactly.
open import Fiber.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt

-- स्थानिवद्भाव (Pāṇini, Aṣṭādhyāyī 1.1.56 स्थानिवदादेशोऽनल्विधौ, ~500 BCE;
-- with 1.1.60, 1.1.62, 1.3.9, 1.1.5): a वर्ण's three fields are mutually
-- independent — three theorems say so — so the base is (वर्ण , the form
-- substituted) and the carried datum is (स्थानी , सञ्ज्ञा) of the output,
-- both functions of the base.  The अल्/अनल् exception of 1.1.56 is the
-- base/carried split, and the orbit carries the designation through the
-- whole derivation rather than one step.
open import Fiber.Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried

-- भित्ति: the carrier is not two-valued, and the wall crosses its own ford.
open import Fiber.BhittiSthanivat_PaninisCarrierIsNotTwoValuedAndTheWallCrossesItsOwnFord

-- स्थानिवत्सङ्ख्या — the machine's own frontier ask (jīva join score 2970):
-- the ādeśa state space enumerated, स्थानिवत् ≃ Fin 81, the carried datum
-- adding nothing to the count — ahiṃsā read as a number.
open import Fiber.SthanivatSankhya_TheAdesaStateSpaceIsExactlyEightyOneAndTheJoinToTheNumberComponentIsChecked

-- जीविता-स्मृति — the carried memory is alive at every depth of the infinite
-- orbit: at rung n it is योग of the n-th state, never a stale payload.
-- पुनरागमन read forward into infinity — losslessness as उपयोग at every rung.
open import Fiber.JivitaSmrti
