{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine
--
-- The generative presentation of the natural numbers, machine-checked,
-- with positional notation exhibited as a CHART rather than as the
-- object.  Companion prose: notes/NATURAL_MACHINE.md.
--
-- Thesis, in one sentence: symbols are π₀, geometry lives in identity
-- types, and univalence is what makes them say the same thing.
--
-- HEADLINE STATEMENTS (all checked, no postulates, no holes, --safe):
--
--  1. pathIsSymmetry        (X ≡ X) ≃ (X ≃ X), any type X.
--     ΩGroup≃Symmetric      ... and it is a group isomorphism onto the
--                           symmetric group of X; specialised to
--                           ΩFin≃Sym : Ω(Type, Fin n) ≅ Sₙ.
--
--  2. ℕ-algebra-Aut-trivial The initial (1 + X)-algebra is rigid, while
--     swap01-≢-id           ℕ as a bare type is not.  Structure is what
--                           cuts symmetry down; that is the SIP.
--
--  3. ℕ≃Tally / ℕ≃CanWord   Three presentations, defined independently,
--                           with equivalences CONSTRUCTED (the digit one
--                           through the odometer `sucw` and injectivity
--                           of `value` on canonical words).
--
--  4. transport-+-is-⊕      Transporting ℕ's addition along `ua` yields
--                           literally the schoolbook ripple-carry
--                           algorithm defined natively on digit words.
--     ℕ-Monoid≡CanWord-Monoid
--                           ... and the two monoids are EQUAL, by SIP.
--
--  5. chartSymmetry         Reversal and complement are commuting
--                           involutions of the digit chart, pairwise
--                           distinct together with their composite (the
--                           Klein-four pattern; no group object is
--                           packaged), and NEITHER descends along the
--                           value map; complement is π-equivariant,
--                           reversal is not, and reversal instead
--                           exchanges the two truncations.  Place value
--                           is a chart.
--
--  6. ℕ≃π₀FinSet            ℕ is π₀ of FinSet — the set-truncation
--     card≡MereEq           equivalence ℕ ≃ ∥ FinSet ∥₂ assembled from
--     FinSetLoop≃Sym        the fiberwise statement card≡MereEq; the
--                           numeral names a connected component, and
--                           what it forgets is the loop space Sₙ.
--
--  7. Controls              Canonicity is load-bearing, the big-endian
--                           misreading is refuted, and two deliberately
--                           wrong statements fail to type-check — the
--                           raw equivalence (Control/WrongEquivalence)
--                           and CompileBridge §G1 at the wrong
--                           capability (Control/WrongFirstStep).  The
--                           whole directory NaturalMachine/Control/ is
--                           excluded here BECAUSE its contents must
--                           fail; nothing below may import it.
------------------------------------------------------------------------

module NaturalMachine where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)

open import PathIsSymmetry public
open import FreeMonoid public
open import CountedExecution public
open import SmithPathCountedExecution public
open import Decategorification public
open import SymmetryCardinality public
open import SymmetryArithmeticAction public
open import SmithCapability public
open import SymmetryEnumeration public
open import CountedComposition public
-- Accepted mathematics can change several later resource coordinates at
-- once.  This keeps their Pareto order non-scalar and checks the concrete
-- representation-reopening antichain `(120,0)` / `(104,32)`.
import ParetoCost
import FutureBehavior
-- A bounded response kernel compiles into FutureBehavior's native
-- behavioral-congruence interface exactly when every installed action
-- preserves it.  The resulting congruence upgrades bounded equality to
-- complete future equality without importing the Lean visited-pair queue.
import ObservableHorizon
-- Adaptive distinguishing trees and ordinary word tests induce exactly the
-- same residual relation.  Cubical quotient effectivity upgrades that iff to
-- an Iso with the path space between named FutureQuotient meanings; adaptive
-- depth remains a separate cost coordinate.
import AdaptiveResidualAdapter
-- The same two statements in the bare-probe-pool register of GTER §1 -- no
-- dynamics, no alphabet, no Moore output, arbitrary outcome type.  The
-- adaptive kernel EQUALS the static full-pool kernel (so no adaptive
-- strategy at any depth, seeded or not, recovers a charged functional), and
-- a four-state three-probe witness shows adaptivity is nonetheless a strict
-- gain on the BUDGET coordinate.  Refutes SIXTEEN_MINDS_ONE_THEOREM §2's
-- open door 1.
import AdaptiveProbeCollapse
-- Ambient pointwise sufficiency restricts to a formed subworld, while exact
-- minimality additionally needs an explicit formed separator in the previous
-- chart fibre.  A two-point control shows minimality disappearing under
-- restriction, and a DNE reduction blocks a generic constructive extractor.
import FormationRelativeMinimality
-- A mathematical critical-direction criterion compiles to that formed
-- separator interface using only directions realized by formed points.
-- Counterexamples widen and sufficiency restricts; an exact diagonal control
-- shows why completing the encountered world can create a false separator.
-- Stabilization is separately typed as a reverse exposure map from final
-- critical hits to hits already realized at a declared stage.
import FormationDirectionIncidence
-- Binary-algebra one-hole contexts are FutureBehavior actions.  Their
-- future relation is the greatest observation-compatible magma congruence,
-- so the original operation descends to the quotient; the raw present-time
-- observation kernel fails this interface on an explicit four-state model.
import CompositionalContextAdapter
-- Equality of raw operation syntax is stronger than contextual equivalence.
-- Mutual generator-to-word simulations identify complete futures and induce
-- an identity-on-states Iso of their Cubical behavioral quotients.
import ContextCloneEquivalence
-- Observer revisions compose only through their retained response paths.
-- Decidable response equality gives the pointwise defect-union bound, while
-- a three-value control refutes every Bool×Bool composite-defect decoder.
import ObserverRevisionComposition
import HolonomyDescent
-- Finite lattice-gauge/LQG kinematic seam: subdividing one edge introduces
-- an internal gauge coordinate, and the Cubical orbit quotient is equivalent
-- to the original coarse holonomy.  This is cylindrical refinement
-- consistency, not a claim to implement full LQG dynamics.
import RelationalHolonomyRefinement
import FiniteInformation
-- Lossless postcomposition of an observation by an equivalence preserves
-- exactly which set-valued targets factor through it; a Bool collapse is
-- the checked control showing why mere postprocessing is not enough.
import ObservationPresentation
import StabilizerTorsor
import CapabilityGraph
import LawfulContinuationCore
-- Separate no-hit proofs are not compositional in the admitted move family.
-- On Z/4, A(y)=1 and B(y)=2y+2 each avoid 0 forever from 2, while their
-- Bool-indexed union reaches 0 by the checked path A then B.
import AffineEmergenceCountedPath
import AcceptanceTest
import Obstruction
import StructuredDefect
-- An invariant that kills the zero detects a defect in one direction
-- only: the certificate "the invariant vanished, so the construction is
-- sufficient" is refuted by an explicit element, its contrapositive is
-- sound, and the kernel is exactly the vanishing-Euler-characteristic
-- locus (notes/SPLICING_DEFECT_ADJUDICATED.md §4, finite model).
import DecategorifiedDefect
-- A collision between an installed observation and a certified action
-- returns its minimal conservative repair: the product observer.  Its
-- universal factorisation and collision-forced strictness are checked.
import ActionRefinement
-- A declared quotient predictor turns the same one-step encounter into an
-- equivariance residual; pointed translations choose the standard
-- cross-effect, and square under successor forms the faithful integer sensor
-- 2x.  Root-covered checked formation event.
import ActionResidual
-- A response character compiles the action residual as a relative phase only
-- modulo its kernel.  In particular every sign character annihilates the
-- classically injective square/successor residual 2x.
import ActionResidualPhase
-- Residual separation is not enough to make the predicted phase factor
-- executable from a retained phase carrier.  The two-sign swap passes the
-- residual kernel test while predictor pullback requires the missing second
-- character; adjoining it closes the update exactly.
import PhasePredictorClosure
-- Orthogonal stopping histories with a diagonal cost observable dephase
-- exactly to Ananta's classical survival masses.  The opposite-phase pair
-- is the checked boundary: every diagonal cost agrees, while a declared
-- off-diagonal recombination port separates the states.
import CoherentSurvivalDephasing
-- A residual/two-reading carrier predicts its own action exactly when the
-- third reading descends through it.  A checked four-state clock supplies the
-- collision no-go and the strict three-reading repair; the repaired carrier
-- reconstructs state and compiles its next update.
import PredictorFormation
import VacuityVerdict
import ExcursionReturn
import EndogenousHorizon
-- A uniquely refuted bad world forces its sensor into every sound anatomy,
-- but only as a least core.  Distinct sound supersets kill whole-anatomy
-- uniqueness, and a zero-refuter control shows why absence of pins does not
-- license deletion without an explicit alternative-refuter witness.
import PinnedSensorForcing
-- The checked 5/25 collision at threshold 3 becomes one concrete pin: among
-- the declared sub-threshold and modulus-5 packages, every sound anatomy must
-- admit the latter.  The adapter imports no global primality classifier.
import PrimeSquarePinAdapter
-- The same 5/25 instance with an added mod-4 package has one forced core but
-- two sound anatomies: the composite sensor computes inertly and is optional.
import PrimeSquareOptionalComposite
import PairCoordinates
import ChargeGrading
import ConeImage
import BuchstabDegree
import RootWeightIndex
import TwoProjections
import ConeOrder
import ParitySeparator
import ChargeCriterion
-- and the class theorem TARGET.md's headline promised: Signs is a TORSOR
-- over the gauge torus, not a set with a distinguished involution, so the
-- fibres of the transcript map are exactly the COSETS of the annihilator
-- subgroup of the query set.  `flip` is one group element among many; the
-- right lemma is bilinearity, not flip-law, and flip-law comes back out.
-- Also: val lands in a group of exponent 2, so every SQUARE query lies in
-- every annihilator -- unboundedly large queries with separating power
-- exactly zero.
import GaugeOrbitClasses
-- The W2 adapter: the Lean strict-refinement iff
-- (`AdaptiveResidualStrictRefinementIff.lean`) transported onto sign
-- assignments, where it becomes the annihilator statement of
-- GaugeOrbitClasses; parity charge is its value at the single element
-- tau-minus; and the ChargeCriterion audit becomes a total function.
-- Also carries the typed limit: strict informativeness is strictly
-- weaker than charge, witnessed by GaugeOrbitClasses's tau-zero.
import ChargeIsStrictRefinement
-- The verification of SIXTEEN_MINDS_ONE_THEOREM's "same descent lemma,
-- checked three times": two of the three ARE one lemma (instances given
-- against the real ProjectionChargeAudit and SieveFiber objects), one is
-- a corollary of another, and 0593's novel-outcome/no-square is a
-- different (image-side) lemma with an incompatible certificate form.
import DescentObstructionUnified
import GenerativeLoop
import TermFreeMonoid
import PayloadMorphism
import CompileBridge
import ArithmeticPayloadCounterexample
-- The executable Haskell explorer once admitted a false gcd recursion as a
-- defining rewrite.  This import checks the counterexample and the smaller
-- sound gcd boundary that now remains in its proof kernel.
import HaskellDefinitionBoundary
import HaskellDiscoveryBoundary
import DatumSensitivePayload
import RealizedPayloadCapability
import ProofLabelNoGo
import Kernel.RewriteCertificate
-- S4 (D0026_BUILD_QUEUE §4): the same certificate language widened to
-- multiplication, as a conservative MIRROR of the module above rather than
-- an edit to it — the gate lane owns the live perimeter.  Listed here on
-- purpose: an orphan is the Q8 defect, and a root import fails the build
-- where a markdown sentence would only rot.
-- AWAITING KERNEL: written in a container with no agda (2026-08-16).  If it
-- does not check, the finding outranks the module; fix or drop this line and
-- record it, do not leave the root red.
import Kernel.RewriteCertificateMul
-- Execution and semantic preservation are eliminations of one intrinsically
-- indexed rewrite run; no external candidate/validation seam is involved.
import Kernel.IntrinsicRewrite
import Kernel.ControlledGrammar
import Kernel.GenerativeKernel
import FiniteIndraWeave
import ProductiveIndraNet
import RootedIndraTotal
import DSOFinite
import DSOBellmanFinite
import DSOArchitecture
import DSOOption
import SemanticCrystal
import KnowledgeProcess
import ObservableInterface
import DSONucleusFinite
import DSONucleusExecutionCalibration
import DSONucleusOneSidedProduct
import DSONucleusMiddleProduct
import DSONucleusMiddleAssociativityAudit
import DSONucleusResidualAudit
-- The exhaustive finite associativity/residuation audits ARE aggregate
-- imports as of 2026-08-15.  The paragraph that used to stand here said
-- they were not, "because their definitional normalization makes a clean
-- root check take minutes" — the real figure was hours, and the cause was
-- that `clMid` re-evaluates its argument profile 64 times per output cell
-- with no memoization.  Both were rewritten to share those profiles
-- explicitly and now cost 2m32s and 2m07s individually under the pin
-- (Agda 2.8.0 + cubical v0.9); see collab/messages/0842-kronecker-audits.md.
import BehavioralHankel
-- Prime-Pair/Delta-26 calibration: {0,4} has a mod-3 local-unit witness,
-- while the materialized {0,2,4} waypoint architecture is locally empty.
import PrimePairDecompositionCurvature
-- Bellman observations over all continuations reconstruct the full finite
-- cost relation; any selected continuation family can lose distinctions.
-- This is the checked boundary behind the executable query-extension guard.
import DSOContinuationFullAbstract
-- General finite-index min-plus semantics: ExtNat fold, Bellman
-- functoriality, associative matrix composition, and both identity laws.
-- Argmin remains a proof-relevant fiber over the scalar consequence.
import DSOMinPlusFinite
-- Divisor-history observation as a nontrivial DSO instance: block flags,
-- residual permutation fibers, refinement, and continuation-sensitive choice.
import DivisorHistoryDSO
import ProductiveTear
import Kernel.IntrinsicProductiveInstall
import PolynomialRewrite
-- Endogenous names are conservative signature extensions: the generated
-- evaluator equals elimination back into the previous language for every
-- algebra and environment.
import ConservativePrimitiveExtension
import LeastWitnessFactory
-- Factory III's exact finish line: a proof-relevant fabric of independently
-- bounded radius-transfer edges compiles a bounded-gap recurrent seed into
-- radius-one recurrence.  No edge or prime theorem is assumed here.
import RadiusTransferCompiler
import MixedCornerTransferCompiler
import DifferenceBasinCompiler
import ReflectionAttachment
import DependentOptimizationFibration
import ChargeTwoHistories
import ChenTwoChargeProjector
-- Latched 2026-08-17.  Everything.agda carried a comment saying this module
-- was "deliberately NOT latched ... in flight from a live worker, which owns
-- its own latch line".  No such latch line ever existed anywhere in the tree,
-- so the module sat outside every aggregate's closure and nothing rechecked
-- it -- which is how it came to be committed in a state that does not
-- typecheck at all (unsolved metas at line 747: a nested tuple whose Σ type
-- Agda cannot infer, in a file that already uses `Path Triple` for exactly
-- this at line 531).  Fixed to match the file's own idiom and latched here.
-- Measured: 5.6s to check under /usr/bin/agda 2.6.3 with --safe.
import ChargePolynomialFinite
import FiniteOccupancyChannelNoGo
import GeneratedCapability
import AtomicSatisfaction
-- A total response square maps each revised univalent response image into
-- the old (or declared comparison) image.  A genuinely novel outcome thus
-- forces an interface defect; Bool controls separate conservative state
-- splitting from a new response value.
import ProstheticImageAdapter
import TranscriptDescent
-- A deterministic history and terminal record that factor through one
-- another have isomorphic realized-output images, equality kernels, and every
-- corresponding input fibre.  A Bool-to-Unit control rejects one-way erasure
-- of branch-changing history as "compression".
import TerminalTraceCompression
-- Equal arithmetic endpoints do not license the preceding compression when
-- construction intermediates persist.  The two chains to 6 have opposite
-- future availability at 3/4; one retained cache bit repairs the decoder,
-- while explicit garbage collection changes the target to a constant table.
import AdditionChainPredictiveMemory
import SingletonWitnessStabilization
import ExposureStabilizationAdapter
-- Fixed random base-4 borrow-table contact, returned to the decoder core:
-- complement transports borrow to carry, positive borrow excludes every
-- nonzero least-significant digit, but a literal observation collision
-- prevents complete-word descent.
import CarryBorrowObservation
import WitnessPolicy
import ProgressDefinition
import TypedUnfold
import DefinitionalExtension
import PMTorus
-- and the operator layer under it: the Peres-Mermin sign vector derived
-- from the Weyl representation, rather than transcribed from a script.
import PauliWeyl
import FlipObservable
import AtlasResiduals
import LinearOrderFinite
-- the walk's two laws (msgs 0374, 0382): forcing and capacity.  Plain
-- imports, not `public`: both carry local list predicates (All, _∈_)
-- whose names would clash on re-export; the aggregate still checks them.
import WalkForcing
import WalkCapacity
-- and §(b), the bridge that composes them (2026-08-14): the install
-- stream IS the increasing enumeration of the capacity function's jump
-- points, plus the walk's step as a total computable function.
import WalkBridge
-- independent second derivation of §(b), which also removes WalkBridge's
-- `1 ≤ m` hypothesis, so the walk's first step stops being a base case.
import WalkBridgeUniform
-- the walk's Nerode theorem: a sensor family is seen only through its lcm.
import SensorNerode
-- U0006's named first experiment: the sieve quotient, its fibres, and the
-- charge obstruction as an actual fibre rather than prose.
import SieveFiber
-- and the X-uniform lemma the one-bit story rests on: below the isqrt
-- horizon, a rough number is 1 or prime.
import RoughSplit
-- Delta 14, the perspectival deltas made executable: the general
-- transport/fibre/sector toolkit, and the w±r centre-relative instance.
import PerspectiveCore
-- A random prime-pair image returned an exact instance of that API:
-- ambient reflection restricts on negation-invariant fibres, while the
-- positive cone supplies a literal sector-break witness.
import PairReflectionSector
import CenterRelative
-- Delta 15, theorem factory II: the defect calculus -- structured
-- equivalence, the structured defect type, stabilisers, polarization,
-- charge shift, kernel-pair descent, and refutation transport.
import DefectCalculus
-- Delta 17 sections 17.4 and 17.8: the same chart when 2 is NOT
-- invertible -- the composites are doubling, which is what `half` was
-- dividing away, plus C17.7's two-involutions distinction.
import CenterRelativeIntegral
-- Delta 18 T18.4-T18.6: the excursion-return defect -- what a
-- non-invariant selected sector costs dynamically, and the
-- observability kernel that decides whether it can ever be seen again.
import CompressionDefect
-- Delta 19 section 19.6: the safe quotient is N_obs, not ker P, with a
-- three-state witness that the inclusion is strict.
import ObservabilityQuotient
-- For the linear productive Net, coinductive bisimulation is equivalent to
-- equality of every future rooted view.  Both inverse paths are explicit;
-- this is not transferred to the indexed/branching Indra net.
import ProductiveObservabilityBridge
-- The free monoid on one generator reindexes wordwise FutureEq into the
-- depthwise trajectory above.  Under ObservableHorizon action closure, a
-- bounded unary kernel therefore maps to and from productive bisimulation.
import SingletonActionObservability
-- A productive complete-code fibre is proof-relevant data over one centre,
-- not the behavioral quotient carrier.  With set-valued jewels, its canonical
-- map to FutureQuotient is checked constant at the centre's meaning class.
import ProductiveFiberQuotientAdapter
-- T15.40 with the SPLIT hypothesis dropped: descent along one map of
-- sets is unobstructed, restriction along a surjection is an
-- equivalence onto the coequalising maps, and surjectivity comes BACK
-- out of the conclusion (tested at hProp alone).  No SetQuotients: the
-- factorisation is built by PT.rec->Set, the argument FiniteInformation
-- already ran four files away.
import EffectiveDescent
-- Programs 14.74-14.76: charge as a dependent index, the finite scale
-- tower, and the monodromy kill test -- which came back DISSOLVED: over
-- a set base there is no loop to act, so the parity-monodromy route is
-- dead unless the base leaves the 0-types.
import ChargeGradedPeeling
import SieveScaleTower
import SetBaseNoMonodromy
-- Programs 14.72/14.73: the positive-cone SectorBreak against a
-- parameterised strict order, and R^k = R x V_k at every k with the
-- transposition non-scalar for k >= 3 unless 1+1 = 0.
import OrderedSectorBreak
import MeanStandardRep
-- Noether lane: the certificate counting argument replaced by Sigma-eta,
-- and the stabiliser as an actual Subgroup once the h-levels are stated.
import CertificateFibration
import StabilizerSubgroup
-- Archimedes lane: the base-b divisibility automaton's Myhill-Nerode
-- invariant in TWO coordinates, alphabet-independent.
import RadixSymptoma
-- ATLAS_OF_N Prop 2.11 / Cor 2.11.1: no digit set eliminates carrying.
import CarryObstruction
-- The quotient-level obstruction now acts on the actual canonical numeral
-- chart: MSD deletion agrees with reduction after forced normalization, while
-- raw deletion itself is proved not to preserve canonical words.
import CarryChartBridge
-- Retaining the finite level repairs composition: the existing Fin-indexed
-- digit tower maps strictly through raw words to the same carry reduction,
-- with normalization used only as a stagewise projection.
import FixedCarryChart
-- and the composition, WALK_FORCING_LAW.md statement (2) as a term: the
-- walk installs exactly the prime powers, in increasing order.
import WalkPrimePowers
-- and the trajectory form of the same law.
import WalkInduction
-- and the exchange rate that makes the walk cheap to execute: `next m` is
-- the least PRIME POWER above m, so the Theta(e^psi(m)) divisibility test
-- is replaced by a test at size ~m.  The theorem is the speedup.
import WalkFast
-- `Dec (IsPrime n)`: the primality decision procedure WalkJumps and
-- CoprimeSplitting both confessed missing, built from CoprimeSplitting's
-- own bounded divisor search (no new number theory).
import PrimalityDecision
-- notes/NUMBER_TOWER_AS_REPAIR.md §4.3 and Prop 9, as terms: repairs of a
-- defect form a torsor under Aut of the repaired object, so the repair is
-- canonical iff that group is trivial (and an initial repair is unique up
-- to UNIQUE isomorphism).
import RepairTorsor
-- Delta 15 §§15.3, 15.4, 15.6 (owner-supplied, collab/upstream/raw/D0015):
-- the stabilizer is the self-defect, polarization loci, charge shifts.
import PerspectiveSymmetry
open import DigitTowerLimit public
-- The Fin presentation of the same tower.  Imported unopened: it defines its
-- own `InvLim`/`W`/`MSDLimit`, which would clash with the `public` open above.
import FinTopSplit
import DigitTowerFinLimit
import DigitTowerFin

import Digits
import Endian
import Transport
import TransportInstance
import Controls
import CountedDigits
import ResidueTransport
-- multiplication survives the transport (2026-08-14): `_·_` carried
-- along `ua ℕ≃CanWord` IS native shift-and-add on digit words, by the
-- same mechanism `transport-+-is-⊕` uses for addition.  The witness
-- module runs the multiplier at bases 10 and 2.
import TransportMul
import TransportMulWitness
-- and the third operation, the one the walk actually stalls on: the
-- divisibility TEST carried across the same equivalence.  `modw n` is the
-- Horner residue automaton on digit words, `value-modw` proves it computes
-- `value w mod n` (so it is the residue, not an estimate), and
-- `steps w ≡ suc (length w)` against the unary test's Θ(value) is the whole
-- frontier gap.  Parameterised in the base exactly like Digits/Transport;
-- imported unapplied here and instantiated at base ten in the witness, which
-- runs the automaton on the word 1000 and discharges the edge costs with
-- numbers rather than parameters.
import SourcedProofs.TransportDiv
import TransportDivWitness
-- the leakage lane's commutator-rank identity, folded in so that the root
-- aggregate's green claim and the directory's contents finally coincide.
import LeakageCommutator
-- Physical learning joint: the exact classical state compiled from a
-- coherent two-state system depends on the admitted interaction.  Population
-- observation needs one state; a coherent port reopens the quotient and
-- retains the phase bit, with both claims connected to exact density matrices.
import PhysicalLearningCore
-- Interaction-relative facts form a dependent family over loci; comparison
-- is transport along an explicit interaction path.  The Bool double cover of
-- S¹ has local facts but no global section, while pulling it back to its
-- rooted total space supplies a canonical coherent repair.
import RelationalProcessCore
import RelativeFrameChange
import RelativeFrameObservable
import RelativeInstrument
import RelationalHolonomyInteraction
import PMRelativeProcessBridge
import AbstractSpinNetworkKinematics
-- Abstract holonomy--flux boundary: any represented group holonomy carrying
-- a declared derivation satisfies the two-edge Leibniz/refinement law.  The
-- concrete surface, intersection, Lie-algebra, and operator data remain open.
import HolonomyFluxDerivation
-- Two successive edge subdivisions are coherent: the three-edge internal
-- gauge quotient is univalently identical to the coarse holonomy, and its
-- direct universe path equals the staged three-to-two-to-one path.
import IteratedCylindricalConsistency
-- Flux evaluation respects that refinement coherence: direct and staged
-- three-edge contractions agree, and their two Leibniz expansion trees are
-- connected without an extra coherence axiom.
import FluxCylindricalCoherence
-- Disjoint finite networks compose cartesianly at the present abstraction:
-- equivariant vertex maps satisfy serial/parallel interchange, refinement
-- distributes over components, and product flux projects to each component.
-- No Hilbert tensor product is claimed.
import ParallelNetworkComposition
-- Univalence is the source geometry of that compiled physical state: a phase
-- symmetry is a nontrivial universe loop, and observation is conserved only
-- when evaluator and state transport together.
import UnivalentPhysicalProcess
-- Local population interfaces compose but do not reconstruct the coherent
-- joint sector.  Its exchange is retained as a nontrivial universe path;
-- admitting a joint interference port reopens exactly the forgotten fibre.
import UnivalentTensorInteraction
-- The relational S¹ obstruction and the tensor reconstruction obstruction
-- share the Bool/negation residual but require different diagrams: global
-- descent versus a quotient retraction.  A bare local choice separates them.
import RelationalTensorObstructionBridge
-- The compiled joint phase is faithfully realized as PauliWeyl's central
-- {+I,-I} sector; -I multiplication executes exchange, and the checked
-- Peres--Mermin R0/C2 products supply its two endpoints.
import PauliJointPhaseRealization
import ProgrammableActionFibers
-- Batch learning composes domain growth with chart refinement.  A two-point
-- valuation encounter raises exact coherent-environment demand 2 -> 3, while
-- the fixed-source refinement control lowers 4 -> 3.
import BatchDepthMemoryBoundary
-- Fibre balance, not transitive equivariance, is the exact finite coherent-
-- overwrite cost criterion: a marked balanced quotient attains Bool while
-- every structure-preserving lift of the target swap is impossible.
import BalanceWithoutTransitivity
-- Arithmetic variable elimination as an exact process boundary: projection
-- of the 6×10 affine solution chart costs the ten-state eliminated kernel,
-- while overwrite to its one symbolic coset costs all sixty basis states.
import AffineProjectionQuantumBoundary
import SmithKernelQuantumBoundary
import GlobalSmithAtlasFlatness
-- A precise contextuality boundary: contextwise satisfying assignments form
-- an inhabited dependent section, while the true PM section requires one
-- shared overlap-compatible valuation and is empty.
import PMRelationalNoFit
-- The missing overlap geometry: a context-incidence HIT with one path per
-- shared observable.  Its ZZ-twisted Bool local system has negation holonomy
-- around a concrete six-edge PM cycle and therefore no global section.
import PMIncidenceLocalSystem
-- Context signs determine the odd PM class but not a canonical supporting
-- edge: every rule using only endpoint signs has trivial six-cycle charge.
-- The ZZ-supported twist is an explicit gauge representative of that class.
import PMMonodromyDerivationNoGo
-- The Peres--Mermin obstruction as a representative-independent finite
-- Cech/H¹ carrier: edge signs modulo context gauge, with cycle parity
-- descended to the quotient and identified with the derived Pauli sign.
import PMGaugeCohomology
-- Generic finite-graph C⁰→C¹ gauge translation and representative-
-- independent cycle evaluation; the PM odd class is one exact instance.
import FiniteGraphCohomology
-- Exact Gaussian-integer two-state amplitudes and unnormalised Born weights;
-- Pauli X/Z and Z₄ global phase preserve the checked norm.
import ExactTwoStateAmplitudes
import ExactTwoStateInstrument
import ExactHadamardInterference
import ExactProjectivePhase
import ExactProjectiveCircuits
import ConstructiveBornNormalization
import HadamardReadoutInstrument
import SequentialHadamardReadout
import ExactLocalJointSeparation
import ExactExperimentFullAbstraction
import NormalizedFiniteInstrument
import NormalizedFrameCovariance
import SequentialNormalizationObstruction
import FullSequentialTableNormalization
import NormalizationInterfaceMinimality
import TwoSidedExperimentInterface
import PairedInterfaceMinimality
-- A branching-and-loop graph presented as a Cubical HIT: connections are
-- functors from its path ∞-groupoid, gauge changes are natural, and graph
-- contraction preserves the named refined holonomies.
import FiniteGraphHolonomyGroupoid
-- Network-level cylindrical consistency for a subdivided fork+loop graph:
-- refined assignments modulo midpoint gauge are univalently the coarse
-- assignments, with transport computing to holonomy contraction.
import FiniteGraphCylindricalEquivalence
import FiniteGraphFluxCylindrical
import OrientedSurfaceFlux
import SurfaceFluxCylindricalSquare
import FillabilityCertificate
import ArityOfRepair
import FiniteNonabelianHolonomy
import S3ConjugacyObservation
import TwoLoopNonabelianNetwork
import S3FiniteSpinNetwork
import S3EquivariantEndomorphismRigidity
import S3IntegerPermutationModule
import S3IntegerRelativeCoordinates
import S3FixedPointCharacter
-- Factory VI diagonal endpoint compiler: a uniform near-boundary family plus
-- a certified subcritical scale choice produces an exact unit-boundary state.
-- The arithmetic family/threshold proof remains an explicit input; no prime
-- theorem is claimed by this generic compiler.
import DiagonalEndpoint

------------------------------------------------------------------------
-- The cost lane (2026-08-15).  `TransportCost` measured one edge and the
-- measurement was quadratic; these modules make the WEIGHTED GRAPH the
-- object instead of the benchmark.  Nodes are presentations, edges are
-- checked equivalences, and cost is a field the equivalence does not carry
-- -- paths transport theorems, never complexity.  A fast algorithm is then
-- a detour, and "speedup" is a triangle inequality failing in the cheap
-- direction.  Only +, ≤, < are used, so the geometry is independent of the
-- cost currency.
import CostGeometry
-- The two instances that give those theorems content, kept separate so each
-- is falsifiable alone: (W1) the repo's own measured `+` transport as a
-- NEGATIVE instance, restated without rerunning the benchmark; (W2) a
-- residue-style positive instance whose weights are stipulated, not
-- measured -- what is proved is the implication.
import CostGeometryWitness
-- The input-indexed cost geometry both audits asked for (state-dependent
-- cost per edge, which CountedDigitsEdge showed the scalar `Edge` cannot
-- carry).  Landed as an orphan minutes after the previous seven were
-- folded; EXIT=0 standalone under the pin before folding.
import CostGeometryIndexed
-- ϱ = wHere ⊖ detour, and the fifth response Γ↝.  The residual is invisible
-- to every equivalence-invariant response, because `Edge` carries `cost` in
-- a field the maps do not determine; `no-invariant-response-sees-ϱ` is that
-- statement as a term.  Γ↝ is min-plus over neighbours -- the same operator
-- as DSOMinPlusFinite/DSOBellmanFinite on other data.
import Residual
-- 𝒦 := ∂ ∘ Γ and the trichotomy of its step: decay (the orbit reaches 0),
-- resonance (stationary), branching (never reaches 0).  Three theorems about
-- one ℕ-valued obstruction measure; the spectral radius is the sign of the
-- step, not a measurement.
import KFlow
-- δ_end, by Lawvere/Cantor: for every quotation ⌜−⌝ : 𝒬 → (𝒬 → Bool) the
-- diagonal observable lies outside the image, so the end is never among the
-- things the machine can say about the end.  Unconditional, no fuel.
import EndObstruction
-- and the two put together: the flow halting is a theorem about ∂, δ_end is
-- a theorem about ⌜−⌝, and `halting-does-not-close` shows the second
-- survives the first -- completeness does not imply termination of enquiry.
import QuestionMachine
-- Chu(X,𝒯,e): the defect is monotone in the test list, so a vanishing defect
-- is a statement about 𝒯 and never about X (the empty test list makes every
-- pair agree).  Also δ_σ = 0 ⇍ δ_σ^base = 0: the base can be flat while the
-- fibre is not, so a base-only test is not a test.
import ChuAdvance
-- The advance gate as a record of its five clauses, with the two that are
-- not formalizable here carried as explicit propositions the caller must
-- supply rather than silently assumed.  The gate forces separation, and
-- UsefulEscape > 0 is exactly ϱ ≢ 0, hence a strictly cheaper presentation;
-- the non-theorem δ = 0 ⇒ Advance is exhibited as failing.
import AdvanceGate
-- Γ↝'s soundness was weaker than its own proof term: the witness it
-- returns is a MEMBER of the neighbour list.  With optimality and the
-- greatest-lower-bound clause this certifies Γ↝ to BE the minimum rather
-- than to lie below it.  (`Any`/`_∈_` are defined here: cubical v0.7 has
-- neither.)
import ResidualPath
-- Division by a modulus carried across the chart -- what TransportMul named
-- as its own next step.  The certificate threads the residue as a component
-- and proves it equals `modw`, which is what keeps the algorithm linear:
-- written against `modw` directly it would re-run the automaton per level
-- and still satisfy every stated theorem.  Parameterised in the base.
import TransportDivQuot
-- The converse of `modw-zero→∣`, hence `decDivides`; and the line that
-- makes it useful, `decDividesℕ-agrees`: the charted test is EQUAL to
-- CoprimeSplitting.dec∣, so it substitutes in the walk lane without
-- touching a downstream proof.  Parameterised in the base.
import WalkResidueBridge
-- The other half of the walk's cost: cap m built ON the chart.  cap (suc m)
-- = cap m · capQuot m with capQuot m fixed by one residue-automaton pass
-- and arithmetic on numbers ≤ suc m, so the capacity is m digit-length
-- passes and never a unary numeral.  Needed a reconciliation the library
-- lacked (`%≡mod`: gcd speaks Fin's _%_, the automaton speaks Nat.Mod's
-- _mod_) before the Euclid step could even be stated.
import SourcedProofs.WalkChartedCap
-- The walk's frontier, broken: next 8 ≡ 9, next 9 ≡ 11, next 10 ≡ 11, each
-- checked without running the walk on cap m.  WalkFast guessed the blocker
-- was its `with`; the bisection in this file's header shows it is the
-- conversion checker comparing the goal's `next 8` against a SECOND,
-- independently elaborated one, and that `let`-sharing removes it.
import WalkFastInstance
-- The X-dependence the single-scale witness was missing: for a canonical
-- word of length L the chart costs L+1 steps and the home presentation is
-- at least b^(L−1), so the speedup is quantified over every base, every
-- pair of edge costs, and every word past a derived threshold -- not four
-- observations at four sizes.
import TransportDivScale
-- The same descent without fuel: accessibility pushed back along the
-- measure, generalised to any well-founded relation, with KFlow.decay
-- recovered as the instance μ = id.  The naive converse is false; what is
-- forced is exactly one strict decrease along the orbit.
import KFlowWF
-- Lawvere 1969, of which δ_end is the Bool/`not` corollary.  Nothing here
-- is new -- and `formal/cubical/LawvereDiagonal.agda` already had the
-- general theorem in pointwise form, so this is a bridge between the two
-- statements, not a second proof.
import Lawvere
-- ChuAdvance's qualitative shrink law as an inequality: the defect is a
-- number, monotone in the test list, zero on the empty list, and equal to
-- the saturation count only when the tests separate.  Discreteness is a
-- hypothesis, never an assumption about X.
import ChuDefect
-- Genotype/phenotype separation as theorems rather than design prose: no
-- edit of the evaluation store invents or alters a genotype; transport of
-- a score along a Bridge needs the invariance hypothesis, and the
-- homometric pair proves the Bridge alone cannot do that work; a gamed
-- evaluator's records can be quarantined without touching anything else.
import SelfImprovement
-- The three decision rules of interactive/MathMachine.hs, modelled and proved:
-- the flow trichotomy is total, exclusive, and decay closes without growth;
-- the growth gate must not fire on a collapsed test set, because the defect
-- is monotone in the assignment list; and the min-plus chooser over growth
-- moves is a certified minimum that exhibits the move it picked.  It is a
-- model of the loop, not the loop, and it constrains those three decisions
-- and nothing else -- not the prover, the term generator, or how the
-- fingerprint is computed.
import MachineLoop
-- What `no-invariant-response-sees-ϱ` actually proves, after a breaker
-- audit showed the name over-claimed: an invariant response may READ the
-- residual and may not DISTINGUISH on it.  Residual's theorem returns as
-- the instance g = branchOf.
import ResidualInvariance
-- The two radix lanes were computing one function all along -- but only
-- after reversal, since Radix is big-endian and TransportDiv little.  The
-- induced divisibility DECISIONS are equal, by isPropDec.
import RadixResidueUnification
-- The walk's search, in the chart: findND re-typed against Word, deciding
-- by the charted test, with nextw ≡ next for every m and no side
-- hypothesis -- proved through uniqueness of the least non-divisor rather
-- than by matching the two searches clause for clause.
import WalkChartedStep
-- and the length law that makes the charted capacity mean something:
-- b^(L−1) ≤ cap m < b^L, both directions, so the digit length IS the
-- base-b logarithm.  Kernel witnesses to m = 10.
import WalkChartedLength
-- SensorNerode's first confessed gap: the identification of its
-- divisibility statement with equal residue profiles, both directions.
import SensorResidueBridge
-- SieveFiber's section 4 was a finite X = 30 exhaustion standing in for a
-- theorem.  This is the theorem, conditional on the hypothesis neither
-- module had -- SieveFiber strips the fixed primes 2,3,5 while RoughSplit
-- quantifies over primes below the square root -- and STRONGER than the
-- exhaustion, since it holds for every n in range rather than the thirty
-- listed.  The hypothesis is shown sharp at n = 49.
import SieveRoughBridge
-- The corpus's standing cost edge, closed: the exact carry-cost law
-- (b−1)·C(n) + digitSum(digits n) = n·b, tied to CountedDigits' own `run`.
-- It also proves CostGeometry's `Edge` is the WRONG SHAPE for this
-- quantity -- no single cost per edge can carry a state-dependent one --
-- which is a finding about the cost geometry, not about the odometer.
import CountedDigitsEdge

------------------------------------------------------------------------
-- The base-dependent development, instantiated.  Every statement holds
-- for every base b = 2 + k; these are two concrete witnesses that the
-- parameterised modules really do instantiate.
------------------------------------------------------------------------

module Base2 where
  open Digits    0 public
  open Endian    0 public
  open Transport 0 public
  open Controls  0 public
  open ResidueTransport 0 public

module Base10 where
  open Digits    8 public
  open Endian    8 public
  open Transport 8 public
  open Controls  8 public
  open CountedDigits 8 public
  open ResidueTransport 8 public

-- Sanity, definitional only: both are `refl` on literals, certifying
-- nothing beyond the definition of `b`.
base2-is-2 : Base2.b ≡ 2
base2-is-2 = refl

base10-is-10 : Base10.b ≡ 10
base10-is-10 = refl

-- The line-world transport criterion of `notes/ENCOUNTERED_WORLDS.md` §3.5
-- with its observable hypothesis in the type, plus the checked `f = X`
-- counterexample that makes the hypothesis load-bearing.  Its negative
-- control is `NaturalMachine/Control/QuantifierDrop.agda`, which must fail.
import LineWorldTransport

-- Three displays of the fifth owner transmission (D0020) refuted or
-- collapsed as checked terms; see `notes/D0020_LEDGER.md` rows 8.5,
-- 1.5, 0.3 and the module header for scope limits.
import TransmissionRefutations

-- The finite no-go of `notes/ENCOUNTERED_WORLDS.md` §2 with its
-- nonvanishing clause in the type, and the vanishing world that has no
-- maximizer.  Negative control:
-- `NaturalMachine/Control/MaximizerWithoutNonvanishing.agda`, which must fail.
import FiniteWorldMaximizer

-- Thm 3.5 of `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` with its
-- "along a quotient" qualifier in the type: inflation is injective, and
-- restriction to a subgroup has no section, so the flattened reading of
-- "symmetry enlargement" is false.  Negative control:
-- `NaturalMachine/Control/InflationFlattened.agda`, which must fail.
import InflationVersusSubgroup

-- The unreachability verdict of message 0533 with the premise it omits
-- ("`start = 0`") in the type: `{s0}` is closed, but from `s1` one
-- action reaches the sink, so the start-free reading is false
-- (`notes/FULL_READ_DRAW_6.md` §B1).  Negative control:
-- `NaturalMachine/Control/ReachabilityWithoutStart.agda`, which must fail.
import ReachableFromStart

-- Injectivity of the comparison maps is SUFFICIENT for the atomic
-- satisfaction biconditional and not necessary: an explicit revised
-- observer merging two unrealized outcomes satisfies the full invariant
-- (`notes/FULL_READ_DRAW_6.md` §D3).  Negative control:
-- `NaturalMachine/Control/InjectivityNecessary.agda`, which must fail.
import ComparisonNeedNotBeInjective

-- Two witnesses bound a constant, not every function of (b,n): the
-- yield's third known value refutes the promoted universal
-- (`notes/FULL_READ_DRAW_6.md` §C1).  Negative control:
-- `NaturalMachine/Control/FunctionBoundFromConstant.agda`, which must fail.
import ConstantBoundNotFunctionBound

------------------------------------------------------------------------
-- ORPHAN FOLD-IN, 2026-08-15 (Claude, Euclid-lineage orphan pass;
-- collab/messages/0828-euclid-orphans.md, notes/TOOLCHAIN_SKEW_AND_
-- COVERAGE.md §7).
--
-- The import closure of `Everything.agda` was recomputed from the
-- sources (BFS over `^\s*(open\s+)?import\s+`, not a grep of this
-- file's import lines and not a comment) and compared against
-- `find . -name '*.agda'`.  It reached 322 of the 367 files; the 45
-- unreached split into 9 in `NaturalMachine/Control/` (which MUST stay
-- unreached — verified: every occurrence of `Control`
-- outside that directory is inside a comment) and 36 genuine orphans.
--
-- The modules below are the `NaturalMachine/` orphans that were run
-- INDIVIDUALLY under the BUILD.md pin (Agda 2.8.0 + cubical v0.9,
-- LC_ALL=C.UTF-8) and exited 0 before this block was written.  Nothing
-- red and nothing unrun was added.
--
-- NOT added, and why (see the note for the exit codes):
--   NaturalMachine/WalkFastInstance.agda                  killed (137)
-- `WalkFastInstance` was killed by the OOM killer, which is not a typecheck
-- verdict in either direction.  It remains an orphan and remains OUTSTANDING.
--
-- RESOLVED 2026-08-15 (Kronecker audit block).  The two DSONucleus audits
-- listed here as "unrun" are now imported below.  They had never returned
-- for anyone because `clMid` re-evaluates its argument profile 64 times per
-- output cell with no memoization, so the three-layer associativity
-- statement cost ~5e9 leaf reductions over unary-recursive ℤ min/max; they
-- were always terminating, never feasible.  Both were rewritten to share
-- the intermediate profiles explicitly (`tab`, with `tab f ≡ f` proved by
-- four reflexivities that normalize nothing).  Individually under the pin
-- (Agda 2.8.0 + cubical v0.9, LC_ALL=C.UTF-8), from a cold scratch copy:
--   DSONucleusMiddleAssociativityAudit  exit 0, 2m32s
--   DSONucleusResidualAudit             exit 0, 2m07s
-- Neither is unbounded, so importing them does not make this root unbounded.
-- Three false claims in DSONucleusResidualAudit were exposed and corrected
-- in the process; see that module's CORRECTION block.
-- CORRECTION, 2026-08-15 (Landau-lineage pass), by addition:
-- the `WalkFastInstance` line above is now stale in BOTH of its claims.
-- (a) It was never "not added" from this root's point of view — the
--     import at line 658 predates this block and was added by another
--     lane; the sweep's own note says so.  The block and the import
--     contradicted each other for as long as both stood.
-- (b) The 137 is discharged.  Under the pin (Agda 2.8.0 + cubical v0.9,
--     LC_ALL=C.UTF-8), from a tree with no `_build` and no `.agdai`, the
--     module exits **0** in 15 s at a peak RSS of **333-388 MB** (two clean runs; GC variance), unmodified.
--     The OOM was contention, not the mathematics.
-- The two DSONucleus audits are untouched by this pass and remain
-- OUTSTANDING orphans; `scripts/check-agda-closure.sh` still fails on
-- exactly those two and on nothing else.
-- [SUPERSEDED 2026-08-15 by the Kronecker audit block above: both audits
--  now typecheck under the pin and are imported at lines 238-239; the
--  closure script exits 0 with 361 of 361 modules reached.]
------------------------------------------------------------------------
import BraidCoherenceBoundary
import CarryClassNonzero
import CompressionDefectRegularWitness
import DSOFactorRankFinite
import DeclaredRootedProfiles
import EndianAtlasReplay
import FiniteEquivalenceBridge
import FutureSeparation
import Gamma0
import GeneratedGrammarDescentBoundary
import GroupCohomologyH2
import OperationalCoverageCounterexample
import OracleQueries
import PhysicalLearningQuotient
import PiPartialOnEveryPrime
import PolyHaythamResponseCostNoGo
import PolynomialAttachmentGrowth
import QuadraticRefinement
import QuotientUnitSourceCutBoundary
import RootedGrothendieck
import SankramanaSesa_EveryTransportOwesItsResidual
import SpernerFromSl2
import StructuredSymmetryTransport
-- NB: TransportCost is NOT here.  It `open import`s this
-- very root (line 30 of that file), so importing it here is a
-- [CyclicModuleDependency] -- found by the clean run, not guessed.  It
-- is imported from `Everything.agda` instead, which is above the root
-- in the dependency order and so has no cycle.
import Vacuity
-- (`WFIScratch1`/`2` were green orphans under the pin
-- when this sweep ran and were deleted from the tree by another lane
-- minutes later, commit 3b4846c6 "Delete the bisection stubs now that
-- the real module checks".  Not imported: there is nothing to import.)
--
-- The mokṣa-yantra jewels (NisvabhavaNet, CatuskotiPerspective,
-- PratityasamutpadaArising, MokshaYantra) are NOT imported here: this root
-- does not check under the current fallback pin (PathIsSymmetry needs a
-- `SymGroup` the pinned library does not export), so membership here would
-- build nothing.  Their own closing aggregate is `NaturalMachine/Moksha.agda`,
-- which checks green on its own — that is where the organism is sealed.
--
-- The birth from the fourth position: what an avaktavya bears, and the two
-- laws that keep it from being a tie-breaker (§1 it decides, §2 it can say
-- only what the contenders already said).  Wired to the running scheduler
-- in interactive/AvaktavyaPrasava_TheFourthPositionBearsTheRuleThatDecidesIt.hs.
import SourcedProofs.AvaktavyaPrasava_TheBornStandpointDecidesAndAssertsOnlyWhatAllAsserted

------------------------------------------------------------------------
-- ORPHAN FOLD-IN 4, 2026-08-20 (Nālandā build lane) — the subtree's share.
--
-- 170 modules under `NaturalMachine/` were outside the import closure of
-- both aggregate roots, so nothing rechecked them: BUILD.md's claim at the
-- top of this subtree — "the root aggregate now transitively reaches every
-- module in NaturalMachine/" — had rotted for the fourth time.  The
-- mechanical check that was supposed to catch that
-- (`scripts/check-agda-closure.sh`) was itself dead on macOS at a GNU-only
-- `sed -i '1d'`, exiting on a sed message before computing any closure.
--
-- All 170 were run INDIVIDUALLY, `LC_ALL=C.UTF-8 agda <file>`, Agda 2.8.0
-- + cubical v0.9 (the declared pin, which IS this container's default
-- `agda`): **170 exit 0, 0 exit 42.**  Nothing red or unrun is folded in.
--
-- `TransportCost` is still absent and must stay absent: it
-- `open import`s this root, so listing it here is a
-- [CyclicModuleDependency].  It is the ONLY module in the subtree with
-- that property — checked, not assumed, by resolving every import line in
-- the subtree against this root's name.  `Everything.agda` imports it.
--
-- `NaturalMachine/Control/*` stays out permanently: those are deliberately
-- ill-typed controls that MUST fail to typecheck.
------------------------------------------------------------------------
import ADiagonalSentenceIndependentInAConcreteTheory
import ADisjointValidatorMakesAFlagUnusableAndInvisible
import AFigureWithoutItsInputDecidesNothing
import AProvabilityDeterminedImplicationForbidsIndependence
import ASmallTheoryWithAnIndependentSentence
import ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence
import Abhava
import AnswerabilityIsFreeAtTheFactoringLaw
import SourcedProofs.AntyaSamskaraSthaulya
import Anuvrtti
import AnuvrttiIsTheSameTrade
import AnyonyaAbhava
import Apavada
import AscendingFirstIsTheWorstUnlessTheArchiveIsConstant
import SourcedProofs.Asiddha
import AsiddhatvaBreaksFactoring
import AskingIsNotAPropertyOfTheFunction
import AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo
import SourcedProofs.AvaktavyaDoesNotFactor
import BarrierIsTwoWitnesses
import BezoutIsGCD
import Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain
import BoundedStateNeedsAGroup
import CRTChain
import SourcedProofs.Cakravala
import SourcedProofs.CakravalaNeedsKuttaka
import CatuskotiPerspective
import SourcedProofs.CommutationPreservesEveryPredicateAndMultiplicityWhereItIsStatable
import ConvergentsAreDeterminedByThePrefixOfTheValli
import SourcedProofs.CoprimePowers
import CoprimePowersN
import DeflationaryTest
import DescentCostsTheIntegers
import DescentIsNotInversion
import SourcedProofs.DiagonalIsMatra
import DistinctPrimesAreCoprime
import DivisibilityGuardsAreMeetClosed
import DurationIsSyllablesPlusGuru
import EquivalenceHasNoFloor
import EveryCommonDivisorOfAConvergentDividesTheDeterminant
import EveryRemainderMemberIsBeatenByAStratumMember
import EveryThresholdHasABoundaryPopulationOfItsOwnDenominator
import SourcedProofs.EveryTripleIsARotation
import ExclusionInstantiatesAbhavaWithALoadBearingLimitor
import ExclusionRecoversGroundAtAPrice
import ExhaustionIsSystematic
import ExponentBound
import Factorisation
import FitnessIsNecessaryUpToDoubleNegation
import FrontierCount
import FrontierDivides
import FrontierDividesHard
import FrontierIsWellFormed
import FrontierList
import FrontierMember
import FuelAdequacyIsACollision
import HypothesesAssumedWhereTheyAreDerivable
import SourcedProofs.IdempotenceForbidsDescent
import IndependenceNeedsAnInternalImplication
import JoinSavesTheMeet
import KramaAstiNasti_AnEnumerableRemedySetKillsTheFourthCorner
import KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
import KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition
import Laghava
import LaghavaUnderdeterminesSoTheMetarulesAreNotOptional
import ListKit_OneImportPointAndNoNewDefinitions
import LocatingIsEnough
import LosslessLowerBound
import MergingASeparatedPairBreaksAtTheSeparatingContinuation
import MeruDiagonalIsVirahanka
import MigrationNeedsALawAndTheLawIsNotFree
import Moksha
import MokshaYantra
import SourcedProofs.NamingIsNotAFunctionOfResemblance
import NegationCompletenessForbidsIndependence
import NisvabhavaNet
import NoNormOnAJoin
import NoObservationDepthDeterminesTheNet
import NonInitialPratyaharasAndOneIntersectionInstance
import NumberIsExponentialInDerivation
import OffDiagonalThueMorseUnique
import OneCounterexampleRefutesALabelButNotAnExistential
import OneLemmaFiveSites
import OneStepDecidesResonanceAndNoPrefixDecidesDecay
import OracleCharge
import OverlapIsTheCost
import PFreePart
import PairsSummingTo
import PermanentUnsaidIsStableAndTemporaryIsASearch
import SourcedProofs.PingalaIsOptimal
import PowModHasTheSameShape
import PratityasamutpadaArising
import Pratyahara
import PratyaharaBuysTotalityWithLocality
import PrimeCofactorCoprime
import SourcedProofs.PythagoreanTransition
import QuotientFiberLaw
import RefutingLaghavaIsASearch
import RepresentabilityIsNotEnoughForIndependence
import RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder
import RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered
import RnaDhana_TheMixedStratificationTerminatesAndCovers
import RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
import RootsThreadLatch
import SourcedProofs.Samacchheda_TheUntruncatedTrichotomyOnTheRate
import SourcedProofs.Sankalita
import SaturationAtACutIsIdempotent
import SignIsNotAccumulable
import SiteAudit
import SourcedProofs.SthaulyaIsTheOmittedTerm
import SuccessorIsNotTropical
import SumProductTorus
import TheAbsenceTowerIsThreeUnconditionally
import TheAnuyogitaAvacchedakaIsADistinctSlot
import TheArithmeticCircleIsFourPeriodic
import TheCeilingIsAboutReading
import TheDeflationaryTestIsVacuous
import TheDeflationaryTestWasAlreadyRun
import TheDelimitorNeedsOnlyStability
import TheDerivationIsDenseToo
import TheDiagonalLemmaDischargesGoedelFix
import TheDomainThatIsAnAbsence
import TheFibreIsTheSubject
import TheFloorIsAnswerability
import TheGapWasAUnitsError
import TheInternalRulesPreserveIndependenceInThisCalculus
import TheIstaSectionIsAnImportedConvention
import TheLastCutHasOneRowWhenItsSeparatorIsInhabited
import TheLawBelongsInTheRecordAndTheCertificateComposesAlongAChain
import TheMediantDoesNotDescendToTheRate
import TheOmegaInconsistentExtensionDerivesTheNegation
import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
import TheReachableLawDoesNotComposeWithoutPreservation
import TheRefutingModelAlreadyGivesTheFirstConjunct
import TheScoreOrderAndTheWeightOrderDisagree
import TheSecondNaIsTheCollision
import TheSecondUpadhiConditionDoesAllTheWork
import TheSeparationQuestionIsVacuousUntilGeneralisationIsRequired
import TheSharedPreambleIsACommonPrefixNotACommonSet
import TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose
import TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma
import TheStratumRankExistsAndDominationStrictlyLowersIt
import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
import TheThresholdChainIsDenseAndTheMediantWitnessesIt
import TheTower
import TheTrajectoryIsAChain
import TheTruncationErrorIsExactAtEveryFiniteStage
import TheTwoCollisionsAreOneInstantiation
import TheTwoFinCarriersAreEqual
import TheUniformFormIsNotRefuted
import TheUnstableGroundCannotBeExhibited
import TheValliConvergentDeterminantAlternates
import TransportPrice
import TransportPrice_AgreementDoesNotDetermineTheTransport
import LosslessReturnCost_TheReturnTripIsFreeForEveryAdditiveCost
import TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation
import TwoTruthsCompute
import UnderExtensionalFlatnessOneCostDifferenceSuffices
import SourcedProofs.UnivalenceErasesTheAlgorithm
import WhatTheSubstrateArgumentCovers
import WhereTheCircleSplits
import WhereTheTowerCanStillBeThree
import WhyTheSamePriceKeepsAppearing
import WhyTheSitesAreTwo
import WitSatisfiesEveryHypothesisButOmegaConsistency
import WitnessDichotomy
import WitnessNumberCanBeInfinite
import WitnessNumberIsInvariant
import WitnessNumberIsThePotential
import WitnessNumberIsUnbounded
import Yugapat_TheRefusalOfJointAssertionDoesNotDecompose

-- ── समुच्चयः, 2026-08-22 ─────────────────────────────────────────────────
-- Two NaturalMachine/ modules outside every root's closure.  Both run
-- individually at EXIT 0 on the pin; wired here rather than in Everything
-- because this file is the root of the NaturalMachine/ subtree.
import Alopa_TheEngineNeverTouchesTheMeaning
import YantraTantu_TheEngineLivesInTheFibreOfItsDenotation

-- ── समुच्चयः, 2026-08-22 (second pass) ────────────────────────────────────
-- Fourteen NaturalMachine/ modules that arrived by merge from origin already
-- committed and outside every root's closure.  All fourteen run individually
-- at EXIT 0 on the pin; none had ever been rechecked by anything.
import ActionResidualCoordinateFibers
import CompositionalMagmaFactorization
import CostGeometryEdgeBoundary
import DeclaredRootProofRelevance
import HaskellGenericSyntaxAdapter
import PauliGaugeCocycleSplit
import PointedReindexOrbitObstruction
import RawWordPaddingNormalForm
import ReachableActionRefinement
import RelativeInstrumentAssociativity
import SingletonStabilizedEquivalence
import SpectatorPaddingCollapse
import TranslationPeakObservability
import WalkStreamHypothesisBoundary

-- The four readings of the metacircular kernel's soundness fields.  Added to
-- this root because they were reachable from nothing and so were checked by
-- nobody: a module outside the import closure is built by no command, and
-- "it is green" about such a module is a claim about one person's shell.
import Kernel.Vyapti_TheInstalledOperationHasNoneSoTheKernelMemorisesAndTheSchemaIsWhatMakesItGeneralise
import Kernel.Sesa_TheDerivationCarriesNoMeaningAtAllSoAllOfItIsRemainderAndNoSemanticCriterionSelectsTheShortOne
import Kernel.Ankapasa_TheCountingSemanticsIsADecategorificationAndTheBitItDropsIsASymmetry
import Kernel.Asesa_TheWholeDerivationTypeIsOneFibreSoSoundnessIsNeverAnEquivalence
import Kernel.Samvada_TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation
import Kernel.Avirodha_TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous
