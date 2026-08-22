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
