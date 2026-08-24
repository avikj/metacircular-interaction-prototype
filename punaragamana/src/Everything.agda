{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Everything
--
-- The single entry point: typechecking this module typechecks the library.
-- check.sh drives exactly this file, so a module that is not reachable from
-- here is verified by nothing.

module Everything where

-- The law, and the machinery it generates.
open import Punaragamana.Carrier
open import Punaragamana.Orbit
open import Punaragamana.Nucleus

-- The law's other projection: the residual, and the price of a refusal.
-- Its two-valued test is a दुर्नय; see the struck paragraph in its header.
open import Punaragamana.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

-- The repair: the diagnosis is a CENSUS, not a verdict.  A fibre fails to
-- be contractible in two opposite ways — empty (अवक्तव्यम्, धनात्मकम्,
-- nothing lost) and crowded (नष्टि, अप्रतिकार्या) — and `isContr` merges
-- them.  Contains the computed refutation of the sequential diagnostic.
open import Punaragamana.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic

-- …and the census's own collapse, one level up.  A fourth outcome exists
-- that `देश` structurally cannot express — the question with no subject —
-- and `machine/Obstruction.hs` has carried it in a type all along while
-- the Agda lane has never had it.  Silence is not denial.
open import Punaragamana.Adharmin_TheUnposedQuestionIsNotAnEmptyFibreAndTheCensusCannotSayIt

-- …and the census made a TERM: being an equivalence splits, fibrewise and
-- on the nose, into embedding × split-surjection, so the two ways a
-- residual refuses contractibility — crowded (नष्टि) and empty
-- (अवक्तव्यम्) — are the two orthogonal factors failing apart, each
-- exhibited failing while the other holds.  The struck "two opposite ways"
-- of Sesa's header, now proved.
open import Punaragamana.SamataDvidha_TheContractibleFibreSplitsAsEmbeddingTimesSurjectionAndTheEmptyAndCrowdedRefusalsAreTheTwoFactorsFailingApart

-- …and समता-द्विधा's own two factors are exactly the triviality of the
-- image factorisation A ↠ प्रतिबिम्ब f ↪ B: the first leg unconditionally
-- surjects, the second unconditionally embeds, and f is an equivalence iff
-- both legs are — SamataDvidha's per-point product and this factorisation
-- read as the same theorem at two granularities (§3 of the header bridges
-- the untruncated छादनम् to the truncated isSurjection).
open import Punaragamana.Pratibimba_TheImageFactorsEveryMapAsSurjectionThenEmbeddingAndSamataDvidhaIsBothLegsTrivial

-- The arithmetic instance, and the proof that it computes.
open import Punaragamana.Viveka
open import Punaragamana.Compute

-- The two number-theoretic instances.
--
-- कुट्टक (Āryabhaṭa, Āryabhaṭīya, गणितपाद 32–33, 499 CE): base = the three
-- slots पक्षः / परिमाणम् / शेषः, none of which is a function of the other
-- two — three theorems say so — and carried = the pair of magnitudes.
open import Punaragamana.KuttakaValli_TheSideIsAFreeSlotAndThatIsWhatMakesTheStepDecisionFree

-- वर्गप्रकृति (Brahmagupta, Brāhmasphuṭasiddhānta 18, 628 CE; the चक्रवाल
-- of Jayadeva c. 950 and Bhāskara II, Bījagaṇita, 1150): base = the two
-- roots ज्येष्ठ / कनिष्ठ over ℤ, carried = the क्षेप a² − D b², which the
-- roots determine exactly.
open import Punaragamana.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt

-- स्थानिवद्भाव (Pāṇini, Aṣṭādhyāyī 1.1.56 स्थानिवदादेशोऽनल्विधौ, ~500 BCE;
-- with 1.1.60, 1.1.62, 1.3.9, 1.1.5): a वर्ण's three fields are mutually
-- independent — three theorems say so — so the base is (वर्ण , the form
-- substituted) and the carried datum is (स्थानी , सञ्ज्ञा) of the output,
-- both functions of the base.  The अल्/अनल् exception of 1.1.56 is the
-- base/carried split, and the orbit carries the designation through the
-- whole derivation rather than one step.
open import Punaragamana.Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried

-- भित्ति: the carrier is not two-valued, and the wall crosses its own ford.
open import Punaragamana.BhittiSthanivat_PaninisCarrierIsNotTwoValuedAndTheWallCrossesItsOwnFord

-- स्थानिवत्सङ्ख्या — the machine's own frontier ask (jīva join score 2970):
-- the ādeśa state space enumerated, स्थानिवत् ≃ Fin 81, the carried datum
-- adding nothing to the count — ahiṃsā read as a number.
open import Punaragamana.SthanivatSankhya_TheAdesaStateSpaceIsExactlyEightyOneAndTheJoinToTheNumberComponentIsChecked
