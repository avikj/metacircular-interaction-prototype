{-# OPTIONS --cubical --safe --guardedness #-}

-- Punargamana ¬ Everything
--
-- The single entry point: typechecking this module typechecks the library.
-- check.sh drives exactly this file, so a module that is not reachable from
-- here is verified by nothing.

module Everything where

-- The law, and the machinery it generates.
open import Fiber.Carrier
open import Fiber.Orbit
open import Fiber.Nucleus

-- The law's other projection: the residual, and the price of a collapse.
open import Fiber.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

-- The repair: the diagnosis is a CENSUS, not a verdict.  A fiber fails to
-- be contractible in two opposite ways ‚î empty (‡®‡æ‡‡‡‡ø: no source over b,
-- ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡) and crowded (‡®‡‡‡ü‡ø, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ) ‚î and `isContr` merges
-- them.  Contains the computed refutation of the sequential diagnostic.
open import Fiber.SakalaVikalaDesa_TheFiberCensusIsATermAndItRefutesTheSequentialDiagnostic

-- ‚¶and the census's own collapse, one level up.  A fourth outcome exists
-- that `‡¶‡‡` structurally cannot express ‚î the question with no subject ‚î
-- and `interactive/Obstruction.hs` has carried it in a type all along while
-- the Agda lane has never had it.  Silence is not denial.
open import Fiber.Adharmin_TheUnposedQuestionIsNotAnEmptyFiberAndTheCensusCannotSayIt

-- The arithmetic instance, and the proof that it computes.
open import Fiber.Viveka
open import Fiber.Compute

-- The two number-theoretic instances.
--
-- ‡ï‡‡ü‡‡ü‡ï (ryabhaa, ryabhaya, ‡ó‡‡ø‡‡‡æ‡¶ 32‚ì33, 499 CE): base = the three
-- slots ‡‡ï‡‡‡ / ‡‡∞‡ø‡Æ‡æ‡‡Æ‡ / ‡‡‡‡, none of which is a function of the other
-- two ‚î three theorems say so ‚î and carried = the pair of magnitudes.
open import Fiber.KuttakaValli_TheSideIsAFreeSlotAndThatIsWhatMakesTheStepDecisionFree

-- ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø (Brahmagupta, Brhmasphuasiddhnta 18, 628 CE; the ‡‡ï‡‡∞‡µ‡æ‡≤
-- of Jayadeva c. 950 and Bhskara II, Bjagaita, 1150): base = the two
-- roots ‡‡‡Ø‡‡‡‡† / ‡ï‡®‡ø‡‡‡† over ‚, carried = the ‡ï‡‡‡‡ a¬≤ ‚àí D b¬≤, which the
-- roots determine exactly.
open import Fiber.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt

-- ‡‡‡‡æ‡®‡ø‡µ‡¶‡‡‡æ‡µ (Pini, Adhyy 1.1.56 ‡‡‡‡æ‡®‡ø‡µ‡¶‡æ‡¶‡‡‡ã‡Ω‡®‡≤‡‡µ‡ø‡ß‡, ~500 BCE;
-- with 1.1.60, 1.1.62, 1.3.9, 1.1.5): a ‡µ‡∞‡‡'s three fields are mutually
-- independent ‚î three theorems say so ‚î so the base is (‡µ‡∞‡‡ , the form
-- substituted) and the carried datum is (‡‡‡‡æ‡®‡ , ‡‡û‡‡‡‡û‡æ) of the output,
-- both functions of the base.  The ‡‡≤‡/‡‡®‡≤‡ exception of 1.1.56 is the
-- base/carried split, and the orbit carries the designation through the
-- whole derivation rather than one step.
open import Fiber.Sthanivadbhava_TheAdesasFormIsTheFreeSlotAndItsDesignationsAreCarried

-- ‡‡ø‡‡‡‡ø: the carrier is not two-valued, and the wall crosses its own ford.
open import Fiber.BhittiSthanivat_PaninisCarrierIsNotTwoValuedAndTheWallCrossesItsOwnFord

-- ‡‡‡‡æ‡®‡ø‡µ‡‡‡‡ô‡‡ñ‡‡Ø‡æ ‚î the machine's own frontier ask (jva join score 2970):
-- the dea state space enumerated, ‡‡‡‡æ‡®‡ø‡µ‡‡ ‚â Fin 81, the carried datum
-- adding nothing to the count ‚î ahis read as a number.
open import Fiber.SthanivatSankhya_TheAdesaStateSpaceIsExactlyEightyOneAndTheJoinToTheNumberComponentIsChecked

-- ‡‡‡µ‡ø‡‡æ-‡‡‡Æ‡‡‡ø ‚î the carried memory is alive at every depth of the infinite
-- orbit: at rung n it is ‡Ø‡ã‡ó of the n-th state, never a stale payload.
-- ‡‡‡®‡∞‡æ‡ó‡Æ‡® read forward into infinity ‚î losslessness as ‡â‡‡Ø‡ã‡ó at every rung.
open import Fiber.JivitaSmrti
