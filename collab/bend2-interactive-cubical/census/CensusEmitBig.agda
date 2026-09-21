{-# OPTIONS --cubical --guardedness #-}
module CensusEmitBig where
open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.String
open import Agda.Builtin.Nat
open import Agda.Builtin.Unit
import AffineProjectionQuantumBoundary as M0
import AskingIsNotAPropertyOfTheFunction as M1
import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport as M2
import Bahuguna_TheMultiPrimeDivisorLatticeIsRankSymmetricRankUnimodalAndSpernerBySymmetricChains as M3
import BezoutIsGCD as M4
import Bhangi_TheOrderFindingStepIsProvedAndANontrivialSquareRootOfOneSplitsTheModulus as M5
import BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded as M6
import BuchstabDegree as M7
import CRTChain as M8
import CakravalaNat as M9
import CakravalaWitness as M10
import CarryFiber as M11
import CenterRelative as M12
import ChargeGradedPeeling as M13
import ChargePolynomialFinite as M14
import ChargeTwoHistories as M15
import ChenTwoChargeProjector as M16

headCode : Term → Nat
headCode (var _ _)      = 0
headCode (con _ _)      = 1
headCode (def _ _)      = 2
headCode (lam _ _)      = 3
headCode (pat-lam _ _)  = 4
headCode (pi _ _)       = 5
headCode (agda-sort _)  = 6
headCode (lit _)        = 7
headCode (meta _ _)     = 8
headCode unknown        = 9

argTerms : List (Arg Term) → List Term
argTerms []             = []
argTerms (arg _ t ∷ as) = t ∷ argTerms as

children : Term → List Term
children (var _ as)            = argTerms as
children (con _ as)            = argTerms as
children (def _ as)            = argTerms as
children (lam _ (abs _ t))     = t ∷ []
children (pat-lam _ as)        = argTerms as
children (pi (arg _ a) (abs _ b)) = a ∷ b ∷ []
children (agda-sort (set t))   = t ∷ []
children (agda-sort (prop t))  = t ∷ []
children (agda-sort _)         = []
children (lit _)               = []
children (meta _ as)           = argTerms as
children unknown               = []

------------------------------------------------------------------------
-- serialization to a bend Shape literal:  @N{<code>n, k1 <> k2 <> []}
------------------------------------------------------------------------
digit : Nat → String
digit 0 = "0n"
digit 1 = "1n"
digit 2 = "2n"
digit 3 = "3n"
digit 4 = "4n"
digit 5 = "5n"
digit 6 = "6n"
digit 7 = "7n"
digit 8 = "8n"
digit _ = "9n"

-- fuel-bounded (structurally terminating on the Nat).  Corpus type Terms
-- are far shallower than the fuel, so no truncation occurs in practice.
shapeStr : Nat → Term → String
kidsStr  : Nat → List Term → String
shapeStr zero    t = primStringAppend "@N{" (primStringAppend (digit (headCode t)) ", []}")
shapeStr (suc f) t = primStringAppend "@N{"
                     (primStringAppend (digit (headCode t))
                     (primStringAppend ", "
                     (primStringAppend (kidsStr f (children t)) "}")))
kidsStr _ []       = "[]"
kidsStr f (t ∷ ts) = primStringAppend (shapeStr f t)
                     (primStringAppend " <> " (kidsStr f ts))

------------------------------------------------------------------------
-- reflect a list of Names � one bend list literal of their type-shapes
------------------------------------------------------------------------
joinShapes : List Name → String → TC String
joinShapes [] acc = returnTC (primStringAppend acc "[]")
joinShapes (n ∷ ns) acc =
  bindTC (getType n) λ ty →
  joinShapes ns (primStringAppend acc
                 (primStringAppend (shapeStr 100 ty) " <> "))

macro
  emitShapes : List Name → Term → TC ⊤
  emitShapes ns _ =
    bindTC (joinShapes ns "") λ s →
    typeError (strErr "BEND_SHAPES_BEGIN\n" ∷ strErr s ∷ strErr "\nBEND_SHAPES_END" ∷ [])


_emit_ : ⊤
_emit_ = emitShapes
  ( quote M0.ProjectedX
  ∷ quote M0.EliminatedKernel
  ∷ quote M0.Solutions
  ∷ quote M0.isSetSolutions
  ∷ quote M0.projectX
  ∷ quote M0.kernelCoordinate
  ∷ quote M0.projectFiberIso
  ∷ quote M0.projection-environment-lower
  ∷ quote M0.kernel-coordinate-completes
  ∷ quote M0.projection-environment-attains
  ∷ quote M0.symbolicSummary
  ∷ quote M0.summaryFiberIso
  ∷ quote M1.verdict
  ∷ quote M1.ask
  ∷ quote M1.discreteBool
  ∷ quote M1.askBool
  ∷ quote M1.peel
  ∷ quote M1.peel-step
  ∷ quote M1.peel-diagonal
  ∷ quote M1.peel-off
  ∷ quote M1.same
  ∷ quote M1.sameFunction
  ∷ quote M1.ask-step
  ∷ quote M1.run
  ∷ quote M2.DependentFactorsThrough
  ∷ quote M2.dependent-collision-obstructs
  ∷ quote M2.Filler
  ∷ quote M2.carrierTranscript
  ∷ quote M2.sameCarrierTranscript
  ∷ quote M2.fillerDoesNotFactorThroughCarrier
  ∷ quote M3.mirrorM
  ∷ quote M3.mirrorM-rank
  ∷ quote M3.mirrorM-mirrorM
  ∷ quote M3.generalRankSymmetry
  ∷ quote M3.mkSU
  ∷ quote M3.box
  ∷ quote M3.drop
  ∷ quote M3.box-zero
  ∷ quote M3.box-diff
  ∷ quote M3.drop-ge
  ∷ quote M3.drop-lt
  ∷ quote M3.splitLE
  ∷ quote M4.BezN
  ∷ quote M4.unit-from-step
  ∷ quote M4.bez-8-9
  ∷ quote M4.gcd-8-9
  ∷ quote M5.double
  ∷ quote M5.NontrivialFactor
  ∷ quote M5.sqrt1-splits
  ∷ quote M5.two-to-the-fourth
  ∷ quote M5.fifteen-order
  ∷ quote M5.fifteen-sqrt1
  ∷ quote M5.notOne15
  ∷ quote M5.notMinusOne15
  ∷ quote M5.fifteen-splits
  ∷ quote M5.gcd-3-15
  ∷ quote M5.one-is-a-square-root
  ∷ quote M5.one-gives-back-N
  ∷ quote M6.pow
  ∷ quote M7.St
  ∷ quote M7.C
  ∷ quote M7.D
  ∷ quote M7.A
  ∷ quote M7.lvl
  ∷ quote M7.parent-return
  ∷ quote M7.return-at-root
  ∷ quote M8.Prod
  ∷ quote M8.prodStep
  ∷ quote M8.Vec
  ∷ quote M8.Coprimes
  ∷ quote M8.crtChain
  ∷ quote M8.walk8
  ∷ quote M8.walk8-prod
  ∷ quote M8.walk8-coprimes
  ∷ quote M8.walk8-residues
  ∷ quote M9.ca
  ∷ quote M9.cb
  ∷ quote M10.D
  ∷ quote M10.turn0
  ∷ quote M10.turn1
  ∷ quote M10.turn2
  ∷ quote M10.turn3
  ∷ quote M10.turn4
  ∷ quote M10.turn5
  ∷ quote M10.turn6
  ∷ quote M10.turn7
  ∷ quote M10.divA0
  ∷ quote M10.divB0
  ∷ quote M10.divK0
  ∷ quote M11.wt
  ∷ quote M11.Word
  ∷ quote M11.value
  ∷ quote M11.Fib
  ∷ quote M11.Is1
  ∷ quote M11.DCode
  ∷ quote M11.pt1
  ∷ quote M11.wordPath1
  ∷ quote M11.isContrFib1
  ∷ quote M11.no-uniform-chart
  ∷ quote M12.Pair
  ∷ quote M12.thm16-1
  ∷ quote M12.Q
  ∷ quote M12.thm16-6-J
  ∷ quote M12.thm16-8
  ∷ quote M12.Pos
  ∷ quote M12.InCone
  ∷ quote M12.posAnti
  ∷ quote M12.thm16-3-diff
  ∷ quote M12.thm16-3-sum
  ∷ quote M12.exchangePreservesCone
  ∷ quote M12.thm16-4
  ∷ quote M13.lpfF
  ∷ quote M13.lpf
  ∷ quote M13.peel
  ∷ quote M13.chkPeelDom
  ∷ quote M13.chkPos
  ∷ quote M13.chkDrop
  ∷ quote M13.peelDrops
  ∷ quote M13.chkFlip
  ∷ quote M13.peelFlips
  ∷ quote M13.H
  ∷ quote M13.peelGrade
  ∷ quote M13.peelFixesUnit
  ∷ quote M14.hereL
  ∷ quote M14.thereL
  ∷ quote M14.allL
  ∷ quote M14.allL-sound
  ∷ quote M14.mapL
  ∷ quote M14.concatMapL
  ∷ quote M14.countUp
  ∷ quote M14.range
  ∷ quote M14.Fact
  ∷ quote M14.value
  ∷ quote M14.consP
  ∷ quote M14.splitsExp
  ∷ quote M15.SquareHistory
  ∷ quote M15.SplitHistory
  ∷ quote M15.square-history-unique
  ∷ quote M15.split-histories-distinct
  ∷ quote M15.SplitProfile
  ∷ quote M15.augment
  ∷ quote M15.relative
  ∷ quote M15.sign
  ∷ quote M15.zeroProfile
  ∷ quote M15.augment-sign
  ∷ quote M15.relative-sign
  ∷ quote M15.kernel-is-sign
  ∷ quote M16.liouvilleParity
  ∷ quote M16.chargeOneProjector
  ∷ quote M16.chargeOneFiber
  ∷ quote M16.SupportField
  ∷ quote M16.Support
  ∷ quote M16.projections-commute
  ∷ quote M16.CenteredField
  ∷ quote M16.RadiusOneCofinal
  ∷ quote M16.ChargeOneCofinal
  ∷ quote M16.CornerCofinal
  ∷ quote M16.CrossedFaces
  ∷ quote M16.radius-one-is-cofinal
  ∷ [] )
