{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Everything
--
-- THE WHOLE DIRECTORY, IN ONE COMMAND.
--
-- `NaturalMachine.agda` is the root of the NaturalMachine/ subtree and
-- BUILD.md's green claim is stated in terms of it.  That claim was
-- honest and it was also NARROWER THAN IT LOOKED: at the time this file
-- was written there were **33 further modules at the top level of
-- formal/cubical/** that the NaturalMachine root does not import.  Each
-- was checked once, by its author, on the day it landed, and then never
-- again by anything.
--
-- That is the same hole BUILD.md already describes one level down:
--
--     "an orphan that the root does not import is exactly the hole that
--      let the earlier overstatement hide."
--
-- The lesson had been learned for `NaturalMachine/*.agda` and not for
-- `*.agda`.  A green claim that covers 1 of 34 top-level modules is not
-- false, but a reader will take it for more than it says — which is the
-- failure mode this corpus keeps catching itself in, and the reason the
-- fix is a MODULE rather than a sentence in a markdown file.  A sentence
-- rots; an import list fails the build.
--
-- All 34 were verified exit 0 individually before this file was created,
-- so it is a latch on a state that already held, not a repair.
--
--
-- WHAT THIS COVERS AND WHAT IT DOES NOT
--
--  * Every `.agda` file at the top level of `formal/cubical/`, plus the
--    `NaturalMachine` root (hence, transitively, all of
--    `NaturalMachine/`).
--
--    [CORRECTED, SEED-81, 2026-08-14 — THE DRIFT BUILD.md PREDICTED HAS
--    HAPPENED TO THIS FILE.  The bullet above is no longer true.  There
--    are now 44 `.agda` files at the top level; excluding this one, 43
--    candidates, of which this module imports 40.  Three are orphans:
--
--        BehavioralApartness      imported by nothing
--        PrimePairField           imported by nothing
--        CenterRelative           imported only by PrimePairField
--
--    They were added after this latch was written.  I did not fold them
--    in, because there is no Agda in this container and an unchecked
--    import is how a green claim becomes false rather than incomplete;
--    the owner of those modules should add the two roots and re-run.
--
--    Note what this instance says, because it is the whole lesson of
--    the file turned on the file.  BUILD.md wrote: "A hand-maintained
--    list of orphans rots in both directions … the check is mechanical
--    and takes one command; run it rather than trusting this file."
--    Everything.agda answered that with an import list — better than a
--    sentence, because it fails the build.  But it fails the build only
--    for modules it NAMES.  A module nobody names is invisible to a
--    latch made of names, so this file rots in exactly the one direction
--    BUILD.md's own mechanical check does not: new files.  The repair is
--    not a longer list.  It is a check that REGENERATES the list from
--    `ls *.agda` and fails on the diff — the aggregate must be
--    generated and compared, never hand-written and trusted.]
--
--  * `NaturalMachine/Control/` is EXCLUDED, permanently and on purpose.
--    Its contents are deliberately wrong statements that MUST fail to
--    typecheck.  Nothing may ever import it.  If a future edit makes
--    `Control/` check, that is the bug.
--
--  * The Lean lane (`formal/pairfield/`) is a different toolchain and is
--    not covered by anything here.
--
-- Everything is imported PLAIN, never `open`ed and never `public`.  The
-- modules were written independently and collide freely on short names
-- (`Q`, `τ`, `step`, `see`, `W`, `InvLim`, …); re-exporting them would
-- turn an aggregate into a merge conflict.  The point is that the kernel
-- checks them, not that a client can dot into them from here.
------------------------------------------------------------------------

module Everything where

-- The NaturalMachine root, and through it the whole NaturalMachine/
-- subtree.  BUILD.md's mechanical orphan check still applies inside that
-- subtree and is not superseded by this file.
import NaturalMachine
import NaturalMachineRun

-- Charts and descent.
import CayleyPairChart
import DescentLaw
import DynamicDescent
import Rank1DihedralChart
import SetTruncationDescentBoundary

-- The Γ₀ lane: partner, converse, and the hypothesis anatomy that showed
-- `ε² = 1` is a THEOREM off q = 0 rather than a hypothesis, together with
-- the rigidity that makes partner and witness one type presented twice.
import Gamma0Partner
import Gamma0PartnerRigidity
import Gamma0Converse
import Gamma0ConverseSharp
import Gamma0Freeness
import Gamma0Transitivity
import Gamma0Index
import M2Unimodular
import SmithTorsorBridge

-- Transporters, ports, orbits.
import TransporterMembership
import TransporterPortReduction
import OrbitSeparation
import TotientFibreSymmetry

-- Observation, description, exclusion.
import ExtremalDescription
import ExclusionScope
import ObligatioOrderTrilemma
import CachePathOrder
import ThresholdGenerationDichotomy
import ThresholdGenerationN5Boundary
import ElsewhereCondition

-- Arithmetic: the kuṭṭaka family, integer hulls, subset-sum chart depth,
-- and the parity/reflection-norm eliminant.
import KuttakaValli
import IntegerHullMultiplicity
import SubsetSumChartDepth
import ParityNormEliminant

-- Peres–Mermin and the charge audits.
import PMNoSection
import ProjectionChargeAudit
import ProjectionChargeAudit2
import LiftingFiberResidue
import ResponseCharacterKickback

-- Walsh/window analysis.
import Window5Walsh

-- The Eternal Golden Braid deltas (notes/ETERNAL_GOLDEN_BRAID_DELTA24.md,
-- notes/ETERNAL_GOLDEN_BRAID_DELTA25.md): the Lawvere diagonal engine
-- (§19.D), the finite achromatic-reflection toy (§19.C), and the Indra
-- net — rooted views, type-theoretic Yoneda, propagation, coinductive
-- weave (T25.A/B/D/F).
import LawvereDiagonal
-- Which sentences the diagonal engine proves and which it does not
-- (notes/GODEL_BRIDGE_ADJUDICATED.md): Tarski is Cantor's term; Gödel I's
-- second conjunct is refuted as an instance, with a finite countermodel.
import GodelSeparation
import AchromaticToy
import IndraNet
import StagewiseComposite
import StagewiseCompositeB

-- The 𝔰𝔩₂-triple on a chain of the divisor lattice
-- (notes/SL2_DIVISOR_LATTICE.md).  Rank one only; see that module's §6.
import Sl2DivisorLattice

-- The general case: tensor of two 𝔰𝔩₂-triples is an 𝔰𝔩₂-triple, hence by
-- induction the multi-index divisor lattice B_n = ⨂_i V_{α_i} carries
-- the action.  Closes Sl2DivisorLattice §6; controls at rank 2 with
-- α₁ ≠ α₂, including non-vacuity of the off-diagonal cancellation.
import Sl2TensorProduct

-- The head-depth merge (WHAT_IS_ACTUALLY_OPEN §1 executed): e_b(q)
-- defined once, its three corpus names certified as threshold readings,
-- the 1048-triple W3 replay upgraded from dead Python to kernel fact,
-- and the strong-test seed closed (strong = Fermat on odd prime powers).
import HeadDepthMerge

-- HEAD_DEPTH_BLINDNESS seed 2 closed by dissolution: at modulus 2^a the
-- Fermat exponent 2^a − 1 is odd, so the two-entry 2-sensor (e₋,e₊)
-- collapses to its first entry — blind ⟺ b ≡ 1 (mod 2^a) ⟺ e₋ ≥ a —
-- and the strong test degenerates to Fermat (s = 0, empty MR window).
import HeadDepthTwo

-- Delta 28's executable calibration (notes/DEPENDENT_SYSTEM_OPTIMIZATION_
-- DELTA_28.md §62): tropical feedback closure, elimination-order
-- invariance, and the strict interface hierarchy raw 4 > deterministic 3
-- > latent 2, with the rank lower bound proved against all rectangles.
import DSOCutCalibration

------------------------------------------------------------------------
-- COVERAGE REPAIR, 2026-08-14 (notes/EVERYTHING_COVERAGE_REPAIR.md).
--
-- Everything below this line was landed after this file was created and
-- was therefore an orphan — checked once, by its author, on the day it
-- landed, and then never again by anything.  The same hole this file
-- exists to close, reopened by time.  Each module below was verified
-- exit 0 individually (Agda 2.6.3, cubical v0.5) before being added.
--
-- NOT imported, deliberately (see the note for exact first errors):
--   CenterRelative, PrimePairField, Swarm.S05AsiddhaNewton,
--   Swarm.S08ChebyshevWeight, Swarm.S09SmithKuttaka,
--   Swarm.S11HolonomyDeterminant, Swarm.S14AssemblyGrading
-- all fail under Agda 2.6.3 + cubical v0.5 with the same first error:
-- `solve!` not in scope — they were written against the cubical v0.9
-- CommRingSolver API that BUILD.md's 2026-08-14 migration section pins,
-- while this container (and the historical pin) is 2.6.3 + v0.5.  That
-- toolchain schism is owned by the migration lane; adding the modules
-- here before it resolves would make this aggregate unbuildable under
-- BOTH toolchains at once.  When the schism resolves, fold them in.
--
-- [SUPERSEDED 2026-08-15, Claude, Euclid-lineage orphan pass.  THE
-- SCHISM RESOLVED AND THE INSTRUCTION IN THE LAST SENTENCE HAS BEEN
-- CARRIED OUT.  The owner decided on 2026-08-15 that the sources track
-- the pin, and the pinned toolchain now exists in a container:
-- `solve!` is exactly the v0.9 CommRingSolver name these seven modules
-- were written against.  All seven were run individually under
-- Agda 2.8.0 + cubical v0.9 with LC_ALL=C.UTF-8 and exited 0, and they
-- are imported at the bottom of this file.  They are red under
-- /usr/bin/agda (2.6.3 / v0.5) and that is now the intended state of
-- every source file in this tree, not a regression -- see
-- notes/TOOLCHAIN_SKEW_AND_COVERAGE.md §6.7 and §7.]
------------------------------------------------------------------------

-- Behavioural apartness (Prime-Pair Atlas Delta 20, T20.4; companion
-- prose notes/DISTINCTION_CARRIES_WITNESSES.md).
import BehavioralApartness

-- HEAD_DEPTH_BLINDNESS seed 2, closed by dissolution: at q = 2 the
-- Fermat exponent 2^a − 1 is odd, so e₊ never enters and the two-sensor
-- collapses to one parameter.  (Untracked and minutes old at the time
-- of this audit — in-flight from another session, but exit 0 as found.)
import HeadDepthTwo

-- The genius swarm (Swarm/, swarm-0814-*): independent single-file
-- certificates.  S00 and S02 are reached transitively already
-- (NaturalMachine.TranscriptDescent imports S00TranscriptComposition;
-- ThresholdGenerationDichotomy imports S02ModeAdjoint) and are imported
-- plainly here anyway so this list, not a reachability argument, is the
-- coverage claim.  S05/S08/S09/S11/S14 are red under the pinned
-- toolchain — see the block comment above.
import Swarm.S00TranscriptComposition
import Swarm.S01PaniniAshby
import Swarm.S02ModeAdjoint
import Swarm.S03CarryFiber
import Swarm.S04Apoha
import Swarm.S04ApohaFiniteCompletion
import Swarm.S06NoWrap
import Swarm.S07LeadingDigit
import Swarm.S10VertexOrbit
import Swarm.S12CyclotomicChain
import Swarm.S13OptionSpread
import Swarm.S15ACResidue

-- The Birkhoff polarity closure and the vacuity of the Boolean apoha
-- gloss (companion prose notes/APOHA_AND_POLARITY.md).  Added
-- 2026-08-15 after the `Sub`/`Pow` rename: verified exit 0 individually
-- under BOTH Agda 2.6.3 + cubical v0.5 and the BUILD.md pin
-- Agda 2.8.0 + cubical v0.9.
import PolarityClosure

-- The invariance theorem of Kolmogorov complexity in its abstract form,
-- and the comparison rule it forces: a description-length comparison
-- transfers between machines iff the gap exceeds TWICE the invariance
-- constant, with both sharpness witnesses (companion prose
-- notes/MYSTERY_AND_DESCRIPTION_LENGTH.md §8).  Added 2026-08-15;
-- verified exit 0 individually under BOTH Agda 2.6.3 + cubical v0.5 and
-- the BUILD.md pin Agda 2.8.0 + cubical v0.9.
import InvarianceConstant

------------------------------------------------------------------------
-- ORPHAN FOLD-IN, 2026-08-15 (Claude, Euclid-lineage orphan pass;
-- collab/messages/0828-euclid-orphans.md, notes/TOOLCHAIN_SKEW_AND_
-- COVERAGE.md §7).
--
-- The closure of this file was recomputed from the sources and diffed
-- against `find . -name '*.agda'`: 322 of 367 files reached, 45 not,
-- of which 9 are the `NaturalMachine/Control/` modules that must never
-- be reached (verified: every mention of them outside their own
-- directory is inside a comment) and 36 were genuine orphans.  Each
-- module below was run INDIVIDUALLY under the BUILD.md pin (Agda 2.8.0
-- + cubical v0.9, LC_ALL=C.UTF-8) and exited 0 before it was named
-- here.  The `NaturalMachine/` orphans were folded into the root
-- aggregate instead, at the bottom of `NaturalMachine.agda`.
--
-- These seven are the block above's "when the schism resolves, fold
-- them in": all use the v0.9 `solve!` and are green under the pin.
------------------------------------------------------------------------
import CenterRelative
import PrimePairField
import Swarm.S05AsiddhaNewton
import Swarm.S08ChebyshevWeight
import Swarm.S09SmithKuttaka
import Swarm.S11HolonomyDeterminant
import Swarm.S14AssemblyGrading

-- Machine-checked content of notes/OBSTRUCTION_COEND_REPAIR.md §3:
-- degeneracy invariance of the defect BY EQUALITY (Theorem A), the
-- refutation of the cosimplicial sharp form on a chart over ℤ
-- (Theorem B), and shadow-support-infinite (§7).  Landed 2026-08-15 as
-- an orphan and UNRUN under the pin by its own author's report; run
-- here, EXIT=0.
import SimplicialDefectFailure

-- `NaturalMachine.TransportCost` cannot live in the root aggregate: it
-- `open import`s the root itself, so listing it there is a cyclic
-- module dependency.  It belongs here, above the root.  Run
-- individually under the pin: EXIT=0.
import NaturalMachine.TransportCost
