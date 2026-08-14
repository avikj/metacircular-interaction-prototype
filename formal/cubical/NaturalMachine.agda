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

open import NaturalMachine.PathIsSymmetry public
open import NaturalMachine.FreeMonoid public
open import NaturalMachine.CountedExecution public
open import NaturalMachine.SmithPathCountedExecution public
open import NaturalMachine.Decategorification public
open import NaturalMachine.SymmetryCardinality public
open import NaturalMachine.SymmetryArithmeticAction public
open import NaturalMachine.SmithCapability public
open import NaturalMachine.SymmetryEnumeration public
open import NaturalMachine.CountedComposition public
-- Accepted mathematics can change several later resource coordinates at
-- once.  This keeps their Pareto order non-scalar and checks the concrete
-- representation-reopening antichain `(120,0)` / `(104,32)`.
import NaturalMachine.ParetoCost
import NaturalMachine.FutureBehavior
-- A bounded response kernel compiles into FutureBehavior's native
-- behavioral-congruence interface exactly when every installed action
-- preserves it.  The resulting congruence upgrades bounded equality to
-- complete future equality without importing the Lean visited-pair queue.
import NaturalMachine.ObservableHorizon
-- Adaptive distinguishing trees and ordinary word tests induce exactly the
-- same residual relation.  Cubical quotient effectivity upgrades that iff to
-- an Iso with the path space between named FutureQuotient meanings; adaptive
-- depth remains a separate cost coordinate.
import NaturalMachine.AdaptiveResidualAdapter
-- Binary-algebra one-hole contexts are FutureBehavior actions.  Their
-- future relation is the greatest observation-compatible magma congruence,
-- so the original operation descends to the quotient; the raw present-time
-- observation kernel fails this interface on an explicit four-state model.
import NaturalMachine.CompositionalContextAdapter
-- Equality of raw operation syntax is stronger than contextual equivalence.
-- Mutual generator-to-word simulations identify complete futures and induce
-- an identity-on-states Iso of their Cubical behavioral quotients.
import NaturalMachine.ContextCloneEquivalence
-- Observer revisions compose only through their retained response paths.
-- Decidable response equality gives the pointwise defect-union bound, while
-- a three-value control refutes every Bool×Bool composite-defect decoder.
import NaturalMachine.ObserverRevisionComposition
import NaturalMachine.HolonomyDescent
-- Finite lattice-gauge/LQG kinematic seam: subdividing one edge introduces
-- an internal gauge coordinate, and the Cubical orbit quotient is equivalent
-- to the original coarse holonomy.  This is cylindrical refinement
-- consistency, not a claim to implement full LQG dynamics.
import NaturalMachine.RelationalHolonomyRefinement
import NaturalMachine.FiniteInformation
-- Lossless postcomposition of an observation by an equivalence preserves
-- exactly which set-valued targets factor through it; a Bool collapse is
-- the checked control showing why mere postprocessing is not enough.
import NaturalMachine.ObservationPresentation
import NaturalMachine.StabilizerTorsor
import NaturalMachine.CapabilityGraph
import NaturalMachine.LawfulContinuationCore
import NaturalMachine.AcceptanceTest
import NaturalMachine.Obstruction
import NaturalMachine.StructuredDefect
-- A collision between an installed observation and a certified action
-- returns its minimal conservative repair: the product observer.  Its
-- universal factorisation and collision-forced strictness are checked.
import NaturalMachine.ActionRefinement
-- A declared quotient predictor turns the same one-step encounter into an
-- equivariance residual; pointed translations choose the standard
-- cross-effect, and square under successor forms the faithful integer sensor
-- 2x.  Root-covered checked formation event.
import NaturalMachine.ActionResidual
-- A response character compiles the action residual as a relative phase only
-- modulo its kernel.  In particular every sign character annihilates the
-- classically injective square/successor residual 2x.
import NaturalMachine.ActionResidualPhase
-- Residual separation is not enough to make the predicted phase factor
-- executable from a retained phase carrier.  The two-sign swap passes the
-- residual kernel test while predictor pullback requires the missing second
-- character; adjoining it closes the update exactly.
import NaturalMachine.PhasePredictorClosure
-- Orthogonal stopping histories with a diagonal cost observable dephase
-- exactly to Ananta's classical survival masses.  The opposite-phase pair
-- is the checked boundary: every diagonal cost agrees, while a declared
-- off-diagonal recombination port separates the states.
import NaturalMachine.CoherentSurvivalDephasing
-- A residual/two-reading carrier predicts its own action exactly when the
-- third reading descends through it.  A checked four-state clock supplies the
-- collision no-go and the strict three-reading repair; the repaired carrier
-- reconstructs state and compiles its next update.
import NaturalMachine.PredictorFormation
import NaturalMachine.VacuityVerdict
import NaturalMachine.ExcursionReturn
import NaturalMachine.EndogenousHorizon
import NaturalMachine.PairCoordinates
import NaturalMachine.ChargeGrading
import NaturalMachine.ConeImage
import NaturalMachine.BuchstabDegree
import NaturalMachine.RootWeightIndex
import NaturalMachine.TwoProjections
import NaturalMachine.ConeOrder
import NaturalMachine.ParitySeparator
import NaturalMachine.ChargeCriterion
-- and the class theorem TARGET.md's headline promised: Signs is a TORSOR
-- over the gauge torus, not a set with a distinguished involution, so the
-- fibres of the transcript map are exactly the COSETS of the annihilator
-- subgroup of the query set.  `flip` is one group element among many; the
-- right lemma is bilinearity, not flip-law, and flip-law comes back out.
-- Also: val lands in a group of exponent 2, so every SQUARE query lies in
-- every annihilator -- unboundedly large queries with separating power
-- exactly zero.
import NaturalMachine.GaugeOrbitClasses
import NaturalMachine.GenerativeLoop
import NaturalMachine.TermFreeMonoid
import NaturalMachine.PayloadMorphism
import NaturalMachine.CompileBridge
import NaturalMachine.ArithmeticPayloadCounterexample
-- The executable Haskell explorer once admitted a false gcd recursion as a
-- defining rewrite.  This import checks the counterexample and the smaller
-- sound gcd boundary that now remains in its proof kernel.
import NaturalMachine.HaskellDefinitionBoundary
import NaturalMachine.HaskellDiscoveryBoundary
import NaturalMachine.DatumSensitivePayload
import NaturalMachine.RealizedPayloadCapability
import NaturalMachine.ProofLabelNoGo
import NaturalMachine.RewriteCertificate
-- Execution and semantic preservation are eliminations of one intrinsically
-- indexed rewrite run; no external candidate/validation seam is involved.
import NaturalMachine.IntrinsicRewrite
import NaturalMachine.ControlledGrammar
import NaturalMachine.GenerativeKernel
import NaturalMachine.FiniteIndraWeave
import NaturalMachine.ProductiveIndraNet
import NaturalMachine.RootedIndraTotal
import NaturalMachine.DSOFinite
import NaturalMachine.DSOBellmanFinite
import NaturalMachine.DSOArchitecture
import NaturalMachine.DSOOption
import NaturalMachine.DSONucleusFinite
import NaturalMachine.BehavioralHankel
-- Prime-Pair/Delta-26 calibration: {0,4} has a mod-3 local-unit witness,
-- while the materialized {0,2,4} waypoint architecture is locally empty.
import NaturalMachine.PrimePairDecompositionCurvature
-- Bellman observations over all continuations reconstruct the full finite
-- cost relation; any selected continuation family can lose distinctions.
-- This is the checked boundary behind the executable query-extension guard.
import NaturalMachine.DSOContinuationFullAbstract
-- General finite-index min-plus semantics: ExtNat fold, Bellman
-- functoriality, associative matrix composition, and both identity laws.
-- Argmin remains a proof-relevant fiber over the scalar consequence.
import NaturalMachine.DSOMinPlusFinite
-- Divisor-history observation as a nontrivial DSO instance: block flags,
-- residual permutation fibers, refinement, and continuation-sensitive choice.
import NaturalMachine.DivisorHistoryDSO
import NaturalMachine.ProductiveTear
import NaturalMachine.IntrinsicProductiveInstall
import NaturalMachine.PolynomialRewrite
-- Endogenous names are conservative signature extensions: the generated
-- evaluator equals elimination back into the previous language for every
-- algebra and environment.
import NaturalMachine.ConservativePrimitiveExtension
import NaturalMachine.LeastWitnessFactory
-- Factory III's exact finish line: a proof-relevant fabric of independently
-- bounded radius-transfer edges compiles a bounded-gap recurrent seed into
-- radius-one recurrence.  No edge or prime theorem is assumed here.
import NaturalMachine.RadiusTransferCompiler
import NaturalMachine.ReflectionAttachment
import NaturalMachine.DependentOptimizationFibration
import NaturalMachine.ChargeTwoHistories
import NaturalMachine.GeneratedCapability
import NaturalMachine.AtomicSatisfaction
-- A total response square maps each revised univalent response image into
-- the old (or declared comparison) image.  A genuinely novel outcome thus
-- forces an interface defect; Bool controls separate conservative state
-- splitting from a new response value.
import NaturalMachine.ProstheticImageAdapter
import NaturalMachine.TranscriptDescent
-- Fixed random base-4 borrow-table contact, returned to the decoder core:
-- complement transports borrow to carry, positive borrow excludes every
-- nonzero least-significant digit, but a literal observation collision
-- prevents complete-word descent.
import NaturalMachine.CarryBorrowObservation
import NaturalMachine.WitnessPolicy
import NaturalMachine.ProgressDefinition
import NaturalMachine.TypedUnfold
import NaturalMachine.DefinitionalExtension
import NaturalMachine.PMTorus
-- and the operator layer under it: the Peres-Mermin sign vector derived
-- from the Weyl representation, rather than transcribed from a script.
import NaturalMachine.PauliWeyl
import NaturalMachine.FlipObservable
import NaturalMachine.AtlasResiduals
import NaturalMachine.LinearOrderFinite
-- the walk's two laws (msgs 0374, 0382): forcing and capacity.  Plain
-- imports, not `public`: both carry local list predicates (All, _∈_)
-- whose names would clash on re-export; the aggregate still checks them.
import NaturalMachine.WalkForcing
import NaturalMachine.WalkCapacity
-- and §(b), the bridge that composes them (2026-08-14): the install
-- stream IS the increasing enumeration of the capacity function's jump
-- points, plus the walk's step as a total computable function.
import NaturalMachine.WalkBridge
-- independent second derivation of §(b), which also removes WalkBridge's
-- `1 ≤ m` hypothesis, so the walk's first step stops being a base case.
import NaturalMachine.WalkBridgeUniform
-- the walk's Nerode theorem: a sensor family is seen only through its lcm.
import NaturalMachine.SensorNerode
-- U0006's named first experiment: the sieve quotient, its fibres, and the
-- charge obstruction as an actual fibre rather than prose.
import NaturalMachine.SieveFiber
-- and the X-uniform lemma the one-bit story rests on: below the isqrt
-- horizon, a rough number is 1 or prime.
import NaturalMachine.RoughSplit
-- Delta 14, the perspectival deltas made executable: the general
-- transport/fibre/sector toolkit, and the w±r centre-relative instance.
import NaturalMachine.PerspectiveCore
-- A random prime-pair image returned an exact instance of that API:
-- ambient reflection restricts on negation-invariant fibres, while the
-- positive cone supplies a literal sector-break witness.
import NaturalMachine.PairReflectionSector
import NaturalMachine.CenterRelative
-- Delta 15, theorem factory II: the defect calculus -- structured
-- equivalence, the structured defect type, stabilisers, polarization,
-- charge shift, kernel-pair descent, and refutation transport.
import NaturalMachine.DefectCalculus
-- Delta 17 sections 17.4 and 17.8: the same chart when 2 is NOT
-- invertible -- the composites are doubling, which is what `half` was
-- dividing away, plus C17.7's two-involutions distinction.
import NaturalMachine.CenterRelativeIntegral
-- Delta 18 T18.4-T18.6: the excursion-return defect -- what a
-- non-invariant selected sector costs dynamically, and the
-- observability kernel that decides whether it can ever be seen again.
import NaturalMachine.CompressionDefect
-- Delta 19 section 19.6: the safe quotient is N_obs, not ker P, with a
-- three-state witness that the inclusion is strict.
import NaturalMachine.ObservabilityQuotient
-- For the linear productive Net, coinductive bisimulation is equivalent to
-- equality of every future rooted view.  Both inverse paths are explicit;
-- this is not transferred to the indexed/branching Indra net.
import NaturalMachine.ProductiveObservabilityBridge
-- The free monoid on one generator reindexes wordwise FutureEq into the
-- depthwise trajectory above.  Under ObservableHorizon action closure, a
-- bounded unary kernel therefore maps to and from productive bisimulation.
import NaturalMachine.SingletonActionObservability
-- A productive complete-code fibre is proof-relevant data over one centre,
-- not the behavioral quotient carrier.  With set-valued jewels, its canonical
-- map to FutureQuotient is checked constant at the centre's meaning class.
import NaturalMachine.ProductiveFiberQuotientAdapter
-- T15.40 with the SPLIT hypothesis dropped: descent along one map of
-- sets is unobstructed, restriction along a surjection is an
-- equivalence onto the coequalising maps, and surjectivity comes BACK
-- out of the conclusion (tested at hProp alone).  No SetQuotients: the
-- factorisation is built by PT.rec->Set, the argument FiniteInformation
-- already ran four files away.
import NaturalMachine.EffectiveDescent
-- Programs 14.74-14.76: charge as a dependent index, the finite scale
-- tower, and the monodromy kill test -- which came back DISSOLVED: over
-- a set base there is no loop to act, so the parity-monodromy route is
-- dead unless the base leaves the 0-types.
import NaturalMachine.ChargeGradedPeeling
import NaturalMachine.SieveScaleTower
import NaturalMachine.SetBaseNoMonodromy
-- Programs 14.72/14.73: the positive-cone SectorBreak against a
-- parameterised strict order, and R^k = R x V_k at every k with the
-- transposition non-scalar for k >= 3 unless 1+1 = 0.
import NaturalMachine.OrderedSectorBreak
import NaturalMachine.MeanStandardRep
-- Noether lane: the certificate counting argument replaced by Sigma-eta,
-- and the stabiliser as an actual Subgroup once the h-levels are stated.
import NaturalMachine.CertificateFibration
import NaturalMachine.StabilizerSubgroup
-- Archimedes lane: the base-b divisibility automaton's Myhill-Nerode
-- invariant in TWO coordinates, alphabet-independent.
import NaturalMachine.RadixSymptoma
-- ATLAS_OF_N Prop 2.11 / Cor 2.11.1: no digit set eliminates carrying.
import NaturalMachine.CarryObstruction
-- The quotient-level obstruction now acts on the actual canonical numeral
-- chart: MSD deletion agrees with reduction after forced normalization, while
-- raw deletion itself is proved not to preserve canonical words.
import NaturalMachine.CarryChartBridge
-- Retaining the finite level repairs composition: the existing Fin-indexed
-- digit tower maps strictly through raw words to the same carry reduction,
-- with normalization used only as a stagewise projection.
import NaturalMachine.FixedCarryChart
-- and the composition, WALK_FORCING_LAW.md statement (2) as a term: the
-- walk installs exactly the prime powers, in increasing order.
import NaturalMachine.WalkPrimePowers
-- and the trajectory form of the same law.
import NaturalMachine.WalkInduction
-- and the exchange rate that makes the walk cheap to execute: `next m` is
-- the least PRIME POWER above m, so the Theta(e^psi(m)) divisibility test
-- is replaced by a test at size ~m.  The theorem is the speedup.
import NaturalMachine.WalkFast
-- Delta 15 §§15.3, 15.4, 15.6 (owner-supplied, collab/upstream/raw/D0015):
-- the stabilizer is the self-defect, polarization loci, charge shifts.
import NaturalMachine.PerspectiveSymmetry
open import NaturalMachine.DigitTowerLimit public
-- The Fin presentation of the same tower.  Imported unopened: it defines its
-- own `InvLim`/`W`/`MSDLimit`, which would clash with the `public` open above.
import NaturalMachine.FinTopSplit
import NaturalMachine.DigitTowerFinLimit
import NaturalMachine.DigitTowerFin

import NaturalMachine.Digits
import NaturalMachine.Endian
import NaturalMachine.Transport
import NaturalMachine.TransportInstance
import NaturalMachine.Controls
import NaturalMachine.CountedDigits
import NaturalMachine.ResidueTransport
-- multiplication survives the transport (2026-08-14): `_·_` carried
-- along `ua ℕ≃CanWord` IS native shift-and-add on digit words, by the
-- same mechanism `transport-+-is-⊕` uses for addition.  The witness
-- module runs the multiplier at bases 10 and 2.
import NaturalMachine.TransportMul
import NaturalMachine.TransportMulWitness
-- the leakage lane's commutator-rank identity, folded in so that the root
-- aggregate's green claim and the directory's contents finally coincide.
import NaturalMachine.LeakageCommutator
-- Physical learning joint: the exact classical state compiled from a
-- coherent two-state system depends on the admitted interaction.  Population
-- observation needs one state; a coherent port reopens the quotient and
-- retains the phase bit, with both claims connected to exact density matrices.
import NaturalMachine.PhysicalLearningCore
-- Interaction-relative facts form a dependent family over loci; comparison
-- is transport along an explicit interaction path.  The Bool double cover of
-- S¹ has local facts but no global section, while pulling it back to its
-- rooted total space supplies a canonical coherent repair.
import NaturalMachine.RelationalProcessCore
import NaturalMachine.RelativeFrameChange
import NaturalMachine.RelativeFrameObservable
import NaturalMachine.RelativeInstrument
import NaturalMachine.RelationalHolonomyInteraction
import NaturalMachine.PMRelativeProcessBridge
import NaturalMachine.AbstractSpinNetworkKinematics
-- Abstract holonomy--flux boundary: any represented group holonomy carrying
-- a declared derivation satisfies the two-edge Leibniz/refinement law.  The
-- concrete surface, intersection, Lie-algebra, and operator data remain open.
import NaturalMachine.HolonomyFluxDerivation
-- Two successive edge subdivisions are coherent: the three-edge internal
-- gauge quotient is univalently identical to the coarse holonomy, and its
-- direct universe path equals the staged three-to-two-to-one path.
import NaturalMachine.IteratedCylindricalConsistency
-- Flux evaluation respects that refinement coherence: direct and staged
-- three-edge contractions agree, and their two Leibniz expansion trees are
-- connected without an extra coherence axiom.
import NaturalMachine.FluxCylindricalCoherence
-- Disjoint finite networks compose cartesianly at the present abstraction:
-- equivariant vertex maps satisfy serial/parallel interchange, refinement
-- distributes over components, and product flux projects to each component.
-- No Hilbert tensor product is claimed.
import NaturalMachine.ParallelNetworkComposition
-- Univalence is the source geometry of that compiled physical state: a phase
-- symmetry is a nontrivial universe loop, and observation is conserved only
-- when evaluator and state transport together.
import NaturalMachine.UnivalentPhysicalProcess
-- Local population interfaces compose but do not reconstruct the coherent
-- joint sector.  Its exchange is retained as a nontrivial universe path;
-- admitting a joint interference port reopens exactly the forgotten fibre.
import NaturalMachine.UnivalentTensorInteraction
-- The relational S¹ obstruction and the tensor reconstruction obstruction
-- share the Bool/negation residual but require different diagrams: global
-- descent versus a quotient retraction.  A bare local choice separates them.
import NaturalMachine.RelationalTensorObstructionBridge
-- The compiled joint phase is faithfully realized as PauliWeyl's central
-- {+I,-I} sector; -I multiplication executes exchange, and the checked
-- Peres--Mermin R0/C2 products supply its two endpoints.
import NaturalMachine.PauliJointPhaseRealization
import NaturalMachine.ProgrammableActionFibers
-- Batch learning composes domain growth with chart refinement.  A two-point
-- valuation encounter raises exact coherent-environment demand 2 -> 3, while
-- the fixed-source refinement control lowers 4 -> 3.
import NaturalMachine.BatchDepthMemoryBoundary
-- A precise contextuality boundary: contextwise satisfying assignments form
-- an inhabited dependent section, while the true PM section requires one
-- shared overlap-compatible valuation and is empty.
import NaturalMachine.PMRelationalNoFit
-- The missing overlap geometry: a context-incidence HIT with one path per
-- shared observable.  Its ZZ-twisted Bool local system has negation holonomy
-- around a concrete six-edge PM cycle and therefore no global section.
import NaturalMachine.PMIncidenceLocalSystem
-- Context signs determine the odd PM class but not a canonical supporting
-- edge: every rule using only endpoint signs has trivial six-cycle charge.
-- The ZZ-supported twist is an explicit gauge representative of that class.
import NaturalMachine.PMMonodromyDerivationNoGo
-- The Peres--Mermin obstruction as a representative-independent finite
-- Cech/H¹ carrier: edge signs modulo context gauge, with cycle parity
-- descended to the quotient and identified with the derived Pauli sign.
import NaturalMachine.PMGaugeCohomology
-- Generic finite-graph C⁰→C¹ gauge translation and representative-
-- independent cycle evaluation; the PM odd class is one exact instance.
import NaturalMachine.FiniteGraphCohomology
-- Exact Gaussian-integer two-state amplitudes and unnormalised Born weights;
-- Pauli X/Z and Z₄ global phase preserve the checked norm.
import NaturalMachine.ExactTwoStateAmplitudes
import NaturalMachine.ExactTwoStateInstrument
import NaturalMachine.ExactHadamardInterference
import NaturalMachine.ExactProjectivePhase
import NaturalMachine.ExactProjectiveCircuits
import NaturalMachine.HadamardReadoutInstrument
import NaturalMachine.SequentialHadamardReadout
import NaturalMachine.ExactLocalJointSeparation
-- A branching-and-loop graph presented as a Cubical HIT: connections are
-- functors from its path ∞-groupoid, gauge changes are natural, and graph
-- contraction preserves the named refined holonomies.
import NaturalMachine.FiniteGraphHolonomyGroupoid
-- Network-level cylindrical consistency for a subdivided fork+loop graph:
-- refined assignments modulo midpoint gauge are univalently the coarse
-- assignments, with transport computing to holonomy contraction.
import NaturalMachine.FiniteGraphCylindricalEquivalence
import NaturalMachine.FiniteGraphFluxCylindrical
import NaturalMachine.OrientedSurfaceFlux
import NaturalMachine.SurfaceFluxCylindricalSquare

------------------------------------------------------------------------
-- The base-dependent development, instantiated.  Every statement holds
-- for every base b = 2 + k; these are two concrete witnesses that the
-- parameterised modules really do instantiate.
------------------------------------------------------------------------

module Base2 where
  open NaturalMachine.Digits    0 public
  open NaturalMachine.Endian    0 public
  open NaturalMachine.Transport 0 public
  open NaturalMachine.Controls  0 public
  open NaturalMachine.ResidueTransport 0 public

module Base10 where
  open NaturalMachine.Digits    8 public
  open NaturalMachine.Endian    8 public
  open NaturalMachine.Transport 8 public
  open NaturalMachine.Controls  8 public
  open NaturalMachine.CountedDigits 8 public
  open NaturalMachine.ResidueTransport 8 public

-- Sanity, definitional only: both are `refl` on literals, certifying
-- nothing beyond the definition of `b`.
base2-is-2 : Base2.b ≡ 2
base2-is-2 = refl

base10-is-10 : Base10.b ≡ 10
base10-is-10 = refl
