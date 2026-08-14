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
import AchromaticToy
import IndraNet
