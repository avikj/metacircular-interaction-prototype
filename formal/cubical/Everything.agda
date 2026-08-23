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
-- The exponent half of GAMMA0_FLAG_INDEX Theorem A, general in rank and
-- divisor chain: E <= G, the exact refinement G = E + excess, shift
-- invariance, and psi(p^k) in multiplicative form.  Landed as an orphan
-- (nothing rechecked it); EXIT=0 standalone under the pin before folding.
import Gamma0IndexExponent
-- The counting layer the Gamma0 index lane was blocked on: an injection
-- between finite sets of equal cardinality is an equivalence (absent from
-- cubical v0.9), and the Chinese remainder theorem as an equivalence
-- Fin (m*n) ~ Fin m x Fin n for coprime moduli, with multiplicativity of a
-- counting function along it.
import FinCardinality
import M2Unimodular
import M1SplitIdentity
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
-- [The `import HeadDepthTwo` that stood here was the DUPLICATE
-- `check-everything-coverage.sh` reported as its non-fatal WARNING; the
-- module is imported once, at line 187, under the fuller comment.  The
-- comment is kept because it says something the other does not.
-- Removed 2026-08-19, orphan fold-in 3.]

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

-- Landed as an orphan while this pass was running (the drift BUILD.md
-- predicts, observed inside a single hour).  Run individually under the
-- pin before being named here: EXIT=0.
import HomometricPair

------------------------------------------------------------------------
-- ORPHAN SWEEP, 2026-08-16 (D0026 build queue Q8, the latch).
-- AWAITING KERNEL — AUTHORED WITHOUT LOCAL TOOLCHAIN.
--
-- The closure of this file was recomputed mechanically from the sources
-- (comment-stripped import scan — `--` and `{- -}` both removed before
-- matching — then breadth-first reachability from this module; exact
-- text processing, shell only).  Of 385 `.agda` files under
-- formal/cubical/, 372 were reached and 13 were not: the 10
-- `NaturalMachine/Control/` modules, which must NEVER be reached
-- (re-verified this pass: no non-Control module imports any of them),
-- and exactly THREE genuine orphans, imported below.
--
-- Q8's working figure of ~37 orphans was stale when this pass ran: it
-- described the tree before the 2026-08-15 fold-in passes above, which
-- had already latched that set (CarryClassNonzero, Gamma0,
-- QuadraticRefinement, FutureSeparation, OracleQueries,
-- RootedGrothendieck, CostGeometryWitness and the rest of the
-- NaturalMachine/ list sit at the bottom of `NaturalMachine.agda`;
-- TransportCost, BehavioralApartness, CenterRelative, PrimePairField
-- and all sixteen Swarm/ modules are named in this file above).  The
-- three below are newer than all of that: each landed 2026-08-16 in
-- commit cf2c6f76, a WIP salvage whose own message says UNVERIFIED, NO
-- GREEN CLAIM.
--
-- This container has no Agda, so unlike every block above, these three
-- imports carry NO individual EXIT=0 record from this pass — not under
-- the pin, not under anything.  They inherit only their authors'
-- unverified claims.  That is the latch working as designed rather than
-- a defect in it: if any of the three is red under the pin, this
-- aggregate goes red, loudly, on the next toolchain-bearing run of
-- `check.sh` — which is exactly the adjudication a salvage commit
-- needs and was not going to receive as an orphan.  A green claim is an
-- exit code or it is a rumour; this block is the request for the exit
-- code.
--
-- Duplicate-basename note, checked and found harmless: `CenterRelative`
-- exists both at top level and as `NaturalMachine.CenterRelative`.  The
-- qualified module names are distinct, both are already imported (here
-- and via the root respectively), and Agda resolves each against its
-- own path, so a joint build is unaffected.  No orphan in this sweep
-- required an owner decision.
------------------------------------------------------------------------

-- Hostile replication of HeadDepthMerge (cf-indra): independent
-- reimplementation of every primitive, pointwise agreement on all 1048
-- triples, edge audit outside the guarded range, and the boundary
-- attack on strong = Fermat at composite moduli.
import HeadDepthMergeBreaker

-- W3 split into its two questions with opposite answers (message 0474):
-- no separation for the unspecialized functional equation, a real
-- separation for the specialized instance λ(pn) = −λ(n) against the
-- full-transcript observer.  Imports OracleQueries, ParitySeparator,
-- ChargeCriterion, GaugeOrbitClasses — all already reached via the
-- root; this module does not import the root, so it could live in the
-- root aggregate, but it is latched here where the sweep found it
-- rather than editing a second unverifiable file without a kernel.
import NaturalMachine.OracleSeparation

-- Independent audit of R0021 clauses (B) and (D): the flip identity
-- 32·(μ(Fε) − μ(ε)) = −2a·ε₂ε₃ε₄·(ε₁+ε₅) re-derived from scratch and
-- checked over all 32 patterns; extends Window5Walsh.
import R0021FlipOrbit

-- D0026 §14.1's named finite acceptance core in one module (build queue
-- Q2): the trefoil identity proved GENERALLY for every associative
-- execution with a ℤ-measurement (the Delta 29 lane has it only by
-- 64-case exhaustion), the two CommRing telescope identities, and the
-- §2.4 one-sided-closure associativity defect re-derived on a Fin 4
-- encoding.  Values agree with both the transmission and the
-- independent in-repo Delta 29 reproduction; prior art is declared in
-- the module header and the middle-nucleus repair is NOT duplicated.
-- AWAITING KERNEL — authored without local toolchain.
import NaturalMachine.DSOFiniteCore

-- Matching pennies as the exact separator (build queue Q10, D0026 §2.9 /
-- owner Delta 30; `notes/SELECTION_RETAINS_WHAT_VALUE_FORGETS.md` §5.5,
-- which specifies this module and disclaims having written it).
-- Payoffs normalized by a per-player positive affine map into {0,1}, so
-- the whole game is decidable on Bool with ℕ payoffs and no Int.  What
-- is certified: welfare W ≡ 1 and the Boolean pure-Nash test are each
-- CONSTANT — one fiber apiece — while the best-response composite
-- β₂ ∘ π₁ is surjective onto Bool — two fibers — so by the corpus's
-- level-set theorem (T) the strategic structure descends through
-- NEITHER summary.  That makes VERIFIER_BLIND_FIBER_REWARD Theorem A
-- and von Neumann's oldest example the same theorem, which is the
-- source note's finding.  Deliberately NOT here: the bridge between the
-- Boolean test and the type-level Nash predicate, mixed strategies, the
-- harmonic/potential decomposition, and the sibling lens-law module.
-- AWAITING KERNEL — authored without local toolchain.
import NaturalMachine.MatchingPenniesSeparator

-- The Gter two-coordinate defect, D0026 §7.3 (build queue Q9, owner
-- Deltas 37–38; `notes/GTER_REVELATION_AND_THE_TWO_COORDINATE_DEFECT.md`
-- §§4.1–4.2, shape given in its §4.7).  D0026 asserts that static
-- observational separation and dynamic compositional sufficiency are
-- independent and supplies no witness; here the cut system is encoded
-- relationally (relations as Bool-valued tables on finite index types,
-- glued realization = relational composition through the cut), and
-- Theorem 4 — surjectivity of 𝔖 ↦ (sep, comp) onto Bool × Bool at shape
-- (1,2,1) — is checked, six refls, with both of D0026's requested
-- witnesses appearing as two of the four cells.  Deliberately NOT here,
-- and flagged as such by the source note first: Theorem 6 (minimality of
-- the shape — it quantifies over shapes) and Proposition 7 (the tear is
-- not truncation-invariant — it needs the Set-valued coend).  Neither is
-- refl-material; the module certifies the relational coordinate only.
-- AWAITING KERNEL — authored without local toolchain.
import NaturalMachine.GterTwoCoordinate

-- 2026-08-21.  `NaturalMachine.QuotientFiberLaw` — the corpus's general
-- obstruction theorem — was a TERMINAL LEAF: it appeared in this file
-- nowhere and nothing imported it, so the one module that says what the
-- twelve costumes have in common was checked by nothing.  The import
-- below reaches it transitively, and its own §1 is what the network
-- statement uses.  CHECKED LOCALLY: Agda 2.8.0 + agda/cubical v0.9
-- (Homebrew pair), `agda -i . NaturalMachine/Pratyabhijna_….agda`,
-- exit 0.  NOT checked under the declared pin.
-- import NaturalMachine.Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries
-- [STRUCK 2026-08-22, this seat: the import landed without its file — the
--  module exists in NO commit (git log --all -- …/Pratyabhijna* is empty).
--  It lives uncommitted in another checkout; Everything was red for every
--  seat until this strike. Re-enable when the file lands. अनाथ, live.]

------------------------------------------------------------------------
-- ORPHAN SWEEP 2, 2026-08-17.  AWAITING KERNEL — authored without a
-- local toolchain.
--
-- `scripts/check-agda-closure.sh` returned exit 1 at this commit: 22
-- modules outside the aggregate's import closure, i.e. covered by no
-- green claim anyone could make.  The 03:43 sweep recorded in
-- `notes/AGDA_COVERAGE_INVENTORY.md` was CORRECT WHEN IT RAN and is not
-- struck; every module below landed AFTER it, from concurrent lanes
-- (commits 4fe34ea2 "Braid round 1: ten checked EGB strands" and
-- 459e4d11 "Three engine capabilities").
--
-- The finding this makes precise: latching is not a task that completes,
-- it is a RATE.  Modules land faster than the closure is re-established,
-- so the aggregate silently stops covering the tree between sweeps, and
-- the only reason anyone knows is that a checker exists — which nothing
-- runs (`notes/THE_GATE_IS_A_CLAIM_ABOUT_A_STATE.md`: CI triggers, is
-- scheduled, and is never dispatched).  Latching by hand is the stopgap;
-- the standing fix is to make the closure check a gate that runs.
--
-- MachineMinted.Everything is itself a machine-regenerated latch, so
-- importing it covers the four MachineMinted.* modules beneath it.
-- NaturalMachine.ChargePolynomialFinite is latched from NaturalMachine.agda
-- (the root for the NaturalMachine/ subtree) as of 2026-08-17.  The comment
-- that stood here said it was "in flight from a live worker, which owns its
-- own latch line"; no such line existed in either root, and the module was
-- an orphan that did not typecheck.  See the note at its import site.
import CyclotomicMined
import EGBCycleHolonomy
import EGBDetConservation
import EGBFalsifierAsymmetry
import EGBPairComposition
import EGBPairConic
import EGBPhiIdempotent
import EGBResidueGlue
import EGBReversalInvariant
import EGBSpanWeave
import EGBSuccessorCost
-- EGBTear imports EGBRootedNet and EGBThreadYoneda; all three were orphans
-- outside every aggregate's closure until 2026-08-17.  All three typecheck
-- (measured together in one 2.6.3 invocation).  Listed explicitly rather
-- than relying on EGBTear to drag the other two in, so that a later edit to
-- EGBTear's imports cannot silently re-orphan them.
import EGBRootedNet
import EGBTear
import EGBThreadYoneda
import EGBTwoFibrations
import FactoryVICoolingKill
import FactoryVICore
import MachineLibrary
import MachineMinted.Everything
import ObligationMinCut

-- Circulation 0002 (notes/PRIME_ATOM_TOMOGRAPHY_CONDITIONING.md): the exact
-- conditioning constants of charge-one extraction — Sum|c_m| = R+1,
-- Sum|c_m|R^m = C(2R,R), Sum C(R,m) = 2^R, and kappa_DFT = 1 — with the
-- ordering kappa_DFT <= kappa_fac <= kappa_pow proved generally in R.
-- Operational consequence: extract charge-one cyclically, never by moments.
import TomographyConditioning

-- The hypothesis kappa_DFT = 1 rests on (notes/PRIME_PAIR_CYCLIC_CHARGE_CRT_
-- BOUNDARY_V2.md §2): cyclic coefficient extraction is EXACT iff n > R.
-- General in n, R: injectivity of r -> r mod n on [0,R] under R < n; exact
-- recovery; the collision at n <= R; and the exact first-shell aliased
-- functional A(j+n) + A j.  Aliasing is MODEL error, not noise amplification
-- -- at n <= R the same inverse row is still perfectly conditioned and
-- returns the wrong functional.
import CyclicAliasing
-- Q3's Agda landing: the divisor-lattice characteristic polynomial
-- Φ_n(t) = t^{Ω−ω}(t−1)^ω and the Chen-envelope prime projector
-- 1_P = μ² − (ω−1), as finite refl certificates with the note's exact
-- instance tables (Φ_360(2)=8, partition-of-unity 2^Ω) plus Lemma B2's
-- scope fence in both directions — including the two exhibited failures
-- OUTSIDE the envelope (Ω=3 at 12 and 30), which is what makes the
-- fence load-bearing rather than decorative.  Source note
-- `notes/CHEN_PRIMITIVE_BOUNDARY_AND_CHARGE_POLYNOMIAL.md`; owner
-- provenance D0026 §§5.5, 5.9.  AWAITING KERNEL.
--
-- [UNLATCHED by cf-indra during a rebase conflict resolution: the module
--  is RED (exit 42, verified cold at 747,59-64) and line ~452 of this very
--  file says it is "deliberately NOT latched here ... in flight from a live
--  worker".  Latching a red module is how a green claim becomes false.  The
--  module and its comment are untouched; only the import was withheld.  Its
--  owner should restore this line the moment it checks.  See msg 0869.]

-- The Kloosterman parameter audit's exponent arithmetic, re-derived by hand
-- and checked (notes/KLOOSTERMAN_AUDIT_VERIFICATION.md).  Turns eight
-- unreplayable Python checks into kernel facts, and STRENGTHENS the no-go:
-- E3 is the maximum of the five exponents on the whole admissible range, so
-- the split is strictly worse than the unsplit balanced bound for EVERY
-- rho > 0, not merely rho >= 1/5.
import KloostermanExponents

-- The machine's CERTIFY step, kernel side (notes/THE_MACHINE.md): grammar
-- induction over an arbitrary signature -- if the partition is a congruence
-- for the vocabulary, NO term can ever separate two equivalent elements.
-- Nothing is assumed of the relation (not reflexivity, symmetry, transitivity
-- or propositionality).  Plus the converse that makes it SATURATION rather
-- than stability (Indistinguishable x y ~ x ~~ y), an exhibited BREACH (a
-- granted port plus the existing binary op immediately forms the hidden
-- fibre coordinate), and PORT/GROW proved to be the only routes out.
import WallCertificate

-- The saptabhaṅgī of Samantabhadra and Akalaṅka as a checked type, over the
-- three standpoints the machine actually runs (rewriter / kernel-refl /
-- kernel-ind).  The load-bearing part is §5: the joint content of a claim
-- affirmed at one naya and denied at another is total, decidable, realised,
-- and NOT the denotation of any single standpointed utterance — while the
-- ordered pair of two utterances denotes it exactly.  That is avaktavyam,
-- and it is the thing `machine/Obstruction.hs`'s `Unparsed` was reaching
-- for.  Plus Akalaṅka's 3 + 3 + 1 = 7 as an Iso with the non-empty subsets
-- of {asti, nāsti, avaktavya}, and the refutation of every durnaya against
-- the profile machine.log lines 146/174 actually exhibit.
import Saptabhangi

------------------------------------------------------------------------
-- THE INDIAN LANE, FOLDED IN — 2026-08-18.
--
-- This aggregate exists because "an orphan that the root does not import
-- is exactly the hole that let the earlier overstatement hide."  Audited
-- today with the mechanical check this file's own BUILD.md prescribes,
-- and twelve top-level modules were outside the import closure.  All
-- twelve were from one lane: Anekānta, bhāvanā, kuṭṭaka, Piṅgala, the
-- Śivasūtras, the Jain number taxonomy, abhāva, the curriculum.  The
-- newest and most emphasised work in the repository was built by nothing,
-- while the older lane was guarded — the sourcing skew reproduced not in
-- citations but in what CI actually checks, which is the version of it
-- that no amount of careful prose would have caught.
--
-- Each was verified standalone before being added here (exit 0, --safe,
-- no postulates, no holes), so this changes what is GUARDED, not what is
-- true.  That is the whole point: they were green on the day they landed
-- and nothing has re-checked them since.
------------------------------------------------------------------------

-- ĀRYABHAṬA, Āryabhaṭīya, Gaṇitapāda 32-33 (499): the pulverizer, and the
-- descent law as a vallī of quotients.
import Kuttaka

-- and the termination `Kuttaka` leaves to whoever supplies the run: the
-- vallī EXISTS for every pair, by Āryabhaṭa's own measure (recurse on the
-- remainder), with the derived length bound and the remainder a truncated
-- run must report.  Pin-green, 2026-08-20.
import KuttakaSamapti_TheValliIsFiniteForEveryPair

-- BRAHMAGUPTA, Brāhmasphuṭasiddhānta 18 (628): bhāvanā over an arbitrary
-- commutative ring; over ℕ subtraction-free as a semiring identity; and as
-- a typed OPERATION on solutions, which is what "production" names.
import Bhavana
import BhavanaSemiring
import BhavanaGenerative

-- JAYADEVA (~950, via Udayadivākara 1073); BHĀSKARA II, Bījagaṇita (1150):
-- the cakravāla step, and why Bhāskara needs only ONE congruence.
import CakravalaDescent

-- and the width of Bhāskara's m-choice window, DERIVED rather than checked
-- by re-running with a wider one — which is what `machine/Nalanda.hs` was
-- doing, with a comparison function that carried the choice rule
-- `CakravalaBound.agda` §7 had already refuted.  Pin-green, 2026-08-20.
import Varana_TheChoiceWindowIsDerivedNotFitted

-- PIṄGALA, Chandaḥśāstra (~300 BCE), with Virahāṅka and Halāyudha: the
-- mātrā recurrence and binary enumeration of metres.
import Pingala

-- PĀṆINI, Aṣṭādhyāyī (~500 BCE): the Śivasūtras as a pratyāhāra machine.
import Sivasutra
-- The optimality Sivasutra.agda records as OWED, part paid: classes sharing
-- one anubandha are a ⊆-chain, so a ⊆-antichain of classes forces that many
-- markers, in ANY order.  Four for the vowel classes; the order attains four.
import PratyaharaLaghava_TheMarkerCountIsForcedByTheAntichain
-- And the bound is NOT tight: an exact five-class family of ⊆-width two
-- that no recited-once line names with two anubandhas (all 120 arrangements
-- checked), that three name, and that two name the moment a sound may be
-- recited twice — ha, in sūtras 5 and 14.  Repetition is the resource the
-- antichain model does not have.
import Dvihpatha_TheAntichainBoundIsAttainedOnlyIfASoundMayBeListedTwice
-- The reason under that exhaustion, with no enumeration: one antya names
-- EVERY suffix of its stretch whose first sound does not recur later in the
-- stretch (Aṣṭādhyāyī 1.1.71, ādir antyena sahetā).  So a ⊆-chain of any
-- length costs one marker, and with repetition free the antichain bound is
-- the answer.  The economy of repetition is the whole of what is left.
import Antya_OneAnubandhaCarriesEveryFreshStartSuffixSoAChainCostsOneMarker
-- And repetition is not an economy at all: three sounds, the three pairs,
-- and NO recitation order seats them at any anubandha count — while three
-- anubandhas seat them the moment sounds may be recited twice.  μ₀ = ∞ and
-- μ_∞ = width.  Pāṇini's own attested aṬ, śaL, yaR restrict to exactly that
-- cycle on h y ś, which is why h stands in sūtra 5 and again in sūtra 14.
import Krama_NoRecitationOrderSeatsTheCycleSoRepetitionLiftsAnObstructionAndNotACost
-- The owed bridge, paid on the real thing: all fourteen Māheśvara-sūtras
-- encoded (57 tokens), aṬ, śaL, yaR computed by refl, their restrictions to
-- {h y ś} ARE the cycle — and NO line reciting h y ś once each names three
-- classes so restricting (proved over all lines, not an enumeration).  So
-- one of the three must be said twice, and Pāṇini said ha: sūtra 5 before
-- ya, sūtra 14 after śa, the stretch between them h-free for yaR.
import Vyavaya_TheAttestedTrioForcesATwiceRecitedSoundAndPaninisChoiceIsHa
-- And the choice was not a choice: doubling ya dies on the {h v ś}-cycle,
-- doubling śa dies on the {h y ṣ}-cycle, doubling anything else leaves
-- h y ś once and dies on the original — only ha survives, because
-- aṬ ∩ śaL = {h} exactly: ha is the triangle's sole articulation point.
-- One parametric theorem, three instances, every discharge refl.
import Niyama_TheDoubledSoundCouldHaveBeenAnyOfThreeAndTheFullClassesRestrictItToHaAlone

-- Jain epistemology and mathematics: anekāntavāda as a total generator,
-- the taxonomy of the unbounded (saṃkhyāta / asaṃkhyāta / ananta), and
-- abhāva with its avacchedaka.
import Anekanta
import JainSankhya
import AbhavaAvacchedaka

-- The machine's own material, read back: the curriculum the kernel's
-- refusals demand, distinction-descent, and return.
import MachineCurriculum
import BhedaAvatarana
import Punaragamana
import Punarukti_TheTwoScaledCakravalaStepsAreOneTheorem

------------------------------------------------------------------------
-- ORPHAN FOLD-IN 3, 2026-08-19 (Claude, librarian/build-engineer pass;
-- notes/ORPHAN_SWEEP_3.md, collab/messages/0882-librarian-orphans3.md).
--
-- `check-everything-coverage.sh` reported ROT-FORWARD 83 at commit
-- eeae2361: 83 of the 197 modules in its enumeration scope (180
-- top-level *.agda excluding this file, + 17 Swarm/*.agda) were named
-- by no import line here.  All 83 were run INDIVIDUALLY under THE PIN
-- -- Agda 2.8.0 (/root/Agda-2.8.0/dist-newstyle/.../agda) + cubical
-- v0.9 at /root/agda-libs/cubical-v0.9 (tag v0.9, commit b150186),
-- LC_ALL=C.UTF-8 -- through `check.sh`, which announced RUNNING AGAINST
-- THE PIN.  59 exited 0 and are imported below.
--
-- 24 exited 42 and are NOT imported.  Every one of them fails on a
-- **v0.5-only name under a v0.9 library** -- the drift of
-- notes/CONTAINER_PIN_AUDIT.md running BACKWARDS: 21 on `solve` (v0.9
-- spells it `solve!`), 1 on `·Rid` (v0.9: `·IdR`), 1 on `⟪_⟫` made
-- ambiguous by v0.9's own `Cubical.Algebra.Group.Subgroup.⟪_⟫`, and
-- `IndianLane` transitively through `Kuttaka.agda:87`.  They are named,
-- with their first error and line, in notes/ORPHAN_SWEEP_3.md §5 --
-- the OUTSTANDING list.  Not folded in, because the repair is a source
-- rename owned by whoever wrote them, not an import line here.
--
-- Note, stated because it bears on what this file's exit code means:
-- this aggregate was ALREADY red under the pin before this edit, at
-- `BhavanaSemiring.agda:69` and `Kuttaka.agda:87`, both of which it has
-- imported since 2026-08-18.  Folding in the 59 does not change that
-- and is not claimed to.
------------------------------------------------------------------------
import AksaraDviguna
import AmshaSatyayantra
import Ananta
import AnuktaAvaktavya
import ArchivistLane
import Asiddhatva
import AsiddhavatRegime
import BhavanaKrida
import Bija
import ChitiDvipada
import Citighana
import Dvipada
import Gati
import Gurutama
import GurutamaSiddha
import Khahara
import MatraSamasa
import MatraVarnaGuru
import Matramerus
import Meru
import MeruKarna
import MeruSammiti
import Narayana
import NarayanaKarna
import NarayanaSamasa
import Niksepa
import Nirnaya_TheVerdictCannotDropItsWitness
import Panini
import PanktiYoga
import PingalaGhata
-- RSA is those two Indian algorithms and nothing else: the private key IS
-- the kuṭṭaka's Bézout witness (e·d ≡ φ·k + 1, बीजसिद्धि with g=1), and
-- decryption IS this square-and-multiply fold mod n.  Correctness reduces to
-- the exponent laws plus one hypothesis घात x φ ≡ ε (Euler) — and that lone
-- hypothesis is exactly where Shor's order-finding drives the wedge (§4).
import Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation
-- नष्टोद्दिष्टम् — रङ्क/अनरङ्क क्रिया, स्थान-पृथक्-छेदेषु ; यन्त्रस्य अन्वेषण-आकाशाः जन्यन्ते, न स्थाप्यन्ते
import NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn
import PingalaPrastara
import PingalaSatya
import PrastaraPankti
import Purnata
import Sadhyata
import Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm
import SamasaDvi
import SamasaDviAmsa
import SamasaEkAmsa
import SamasaEka
import SamasaEkagra
import SamasaMeru
import SamasaMeruN
import SamantaraSankalita_TheGeneralSeriesAtOneAndOneIsTheSankalitaAndTheExampleWasStandingForIt
import SamaghataSankalita_TheDescentIsExactForEverySequenceAndAryabhatasRulesAreItsFirstInstances
import SamasaNyuna
import Samasesha
import Sankalita
import SaptabhangiNaya
import Satyayantra
import SatyayantraSamyoga
import SeamClosed
import Setu
import Shadrasa
import Shredhi
import Sthairya
import Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction
import TraceCorpus
import VaraSankalita
import VargaGulma
import Vargacitighana
import Yugapat
import Yuti

-- Landed at cb441fc6 by another lane WHILE this sweep ran (file appeared
-- 23:25:57Z, after the 83-module list was frozen at 23:22Z) -- §7.5's
-- "the corpus moved while this ran", reproduced.  Run under the same pin
-- through check.sh: RUNNING AGAINST THE PIN, EXIT=0, CHECKSH_EXIT=0.
import DisclosureDimension

-- ADDED 2026-08-20 (transport lane).  §6 of AHIMSA_SUTRA_VISTARA -- the
-- claim that transport carries structure and loses nothing -- lived in
-- Nasti_ShabdeJivahVartante, which was imported by NOTHING and, as
-- committed, did not typecheck (`uaβ` used, never imported).  That is
-- precisely the orphan hole this file exists to close, reproduced on the
-- module asserting that nothing perishes.  Both are now under this root:
-- Samkramana... imports Nasti..., so the pair fails the build if either
-- rots.  Both EXIT 0, Agda 2.8.0 + cubical-0.9.
import Nasti_ShabdeJivahVartante
import Samkramana_TransportCarriesStructureAndTruncationIsTransportExactlyWhenNothingWasThereToLose

-- ADDED 2026-08-20 (naṣṭi lane).  §४ and §५ of AHIMSA_SUTRA_VISTARA --
-- what a truncation destroys, and that the destruction is irreparable --
-- were checked only at `Bool` and only at h-level 1.  This module states
-- the no-retraction theorem uniformly in the truncation level:
--
--     प्रत्यानयनम् n A  ≃  isOfHLevel n A
--
-- the type of ways back IS the h-level hypothesis, for every n and every
-- A.  It also marks the one clause of §६ that is CLASSICAL -- the
-- disjunctive reading of तृतीयो मार्गो न विद्यते -- with a proof that it is
-- exactly excluded middle, rather than with a caveat.
-- EXIT 0, zero warnings, Agda 2.8.0 + cubical-0.9, --cubical --safe.
--
-- NOTE ON THIS AGGREGATE, measured the same day: `agda Everything.agda`
-- currently EXITs 42 on ONE pre-existing error unrelated to this import --
-- EGBDetConservation.agda:89, `solve` not in scope, which is exactly the
-- v0.5→v0.9 spelling drift check.sh's header has documented since
-- 2026-08-19.  So this import is a latch on a module that is green on its
-- own and not a claim that the aggregate is green.  Said here rather than
-- left for a reader to discover, because an import into a red aggregate
-- that nobody flags is the same rot this file exists to prevent.
import Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis

-- ADDED 2026-08-20 (univalent-audit lane).  §६ of AHIMSA_SUTRA_VISTARA
-- has three sentences.  Path one is checked by Nasti_Shabde… and
-- Samkramana…; the DISJUNCTIVE reading of "there is no third path" is
-- marked classical by Apratikaryatva… .  What none of them proves is the
-- cost of path TWO itself: getting from `¬ isEquiv f` to a WRITTEN
-- defect `Σ[ b ] ¬ isContr (fiber f b)` -- a defect whose SITE you can
-- project out.  That step is exactly MARKOV'S PRINCIPLE, strictly weaker
-- than the excluded middle already charged for; and even LEM buys only
-- `∥ Defect f ∥₁`, which §५'s no-retraction theorem then says cannot be
-- un-truncated.  So दोषो लिख्यते is an imperative: nothing in the logic
-- hands you the document, an author searches for the site.
-- EXIT 0 on its own, Agda 2.8.0 + cubical-0.9, --cubical --safe, zero
-- warnings.  As the note above records, this AGGREGATE is red on
-- pre-existing v0.5→v0.9 API skew (29 modules; run
-- scripts/Pariksa_UnivalentAudit.sh --list), so this import is a latch,
-- not a claim that the aggregate is green.
import TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple

-- ADDED 2026-08-20 (saptabhaṅgī-reconciliation lane).  Two saptabhaṅgī
-- types were live in this tree, mutually contradicting on two laws, both
-- checked, deliberately unreconciled -- and both headers named the SAME
-- open question: is the forgetful map records → labels a homomorphism for
-- krama, for saha, or for neither?  It is one for BOTH (49 + 49 refl), it
-- has a section that is one for both, and it has no inverse, so the label
-- lane is a RETRACT of the record lane and the equivalence between them
-- does not exist.  Consequence, and a correction to the label lane: सह
-- fails to associate on RECORDS too, with every naya and witness retained,
-- so destruction is not what breaks that law.
-- EXIT 0 on its own, --cubical --guardedness --safe, zero warnings, no
-- postulates, no holes.  `SaptabhangiSamyoga_…` is imported here at the
-- same time: it was on disk and absent from this list
-- (check-everything-coverage.sh rot-forward), and it is this file's
-- dependency.
import SaptabhangiSamyoga_TheCompositionOfVerdicts
import Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence

------------------------------------------------------------------------
-- ORPHAN FOLD-IN 4, 2026-08-20 (Nālandā build lane).
--
-- `scripts/check-agda-closure.sh` reported 199 of 780 modules outside the
-- closure of {Everything, NaturalMachine} — a quarter of the Agda lane
-- checked by nothing.  The gate had been reporting that for an unknown
-- period WITHOUT ANYONE SEEING IT: it died on macOS at a GNU-only
-- `sed -i '1d'` before it ever computed a closure, so it exited on a
-- message about sed and certified nothing while appearing to pass.  A
-- gate that crashes is not a gate.  (Repaired the same day, to
-- `tail -n +2`, by the univalent-audit lane.)
--
-- All 199 were then run INDIVIDUALLY, `LC_ALL=C.UTF-8 agda <file>`, under
-- Agda 2.8.0 + cubical v0.9 — which on this container is the DECLARED PIN
-- and not a fallback.  **199 exit 0, 0 exit 42.**  Nothing red is folded
-- in, and nothing was folded in unrun.
--
-- 41 of them were red an hour earlier and are green because the
-- v0.5 → v0.9 migration was finished in this session (`solve` → `solve!` /
-- `solveℕ!`, `·Rid` → `·IdR`, `Symmetric-Group` → `SymGroup`); a 42nd,
-- `SubgroupIndex`, had never typechecked at all.  Both repairs changed no
-- statement.  See those commits for the per-module evidence.
--
-- The 29 below are the top level; the `NaturalMachine.*` orphans go into
-- `NaturalMachine.agda`, which is their subtree's root.  Plain `import`,
-- never `open`, never `public` — these modules collide freely on short
-- names and the point is that the kernel checks them.
------------------------------------------------------------------------
import Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge
import ApohaParyaya_WhetherConceptualContentIsNegativeIsWhatTheTwoSchoolsActuallyDispute
import Ardhaccheda
import BhavanaSamuha
import Brahmagupta
import Cakravala
import CakravalaBound
import CakravalaNat
import CakravalaWitness
import DviGhataVargana
import Dvikarani
import GhanaBaddha
import GrahaYuti
import GunaDhana
import GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating
import IndianLane
import Jiva
import KuttakaCRT
import Madhava
import SamanyaGhata
import Shunya
import SubgroupIndex
import Sulba
import Trikarani
import VargaPrakrtiWitness_FundamentalUnitOfTheOrder
import VargaPrakrti_TraceBhavanaOverN
import Vargana
import VargaprakritiSreni
import YugapatZ
import Punaragamanam_TheStepIsAConjugationAndNothingIsTouchedByIt
import Calana_TheRunAndTheInvariantForAllN
import VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal
import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats

-- Transports of statements the corpus proved twice without linking them
-- (the सामानार्थ groups reported by
--  machine/Indrajala_WhichModulesSeeWhichAndWhatNothingSees.hs).
import MadhyaVinimaya_TheMiddleExchangeIsOneLawStandingInSixPlaces
import Pratyaya_TheChandasCountsStandTwiceAndTheTwoProofsAreOnePath
import Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOneTerm
import Bhedanirnaya_TwoTestersForSamenessOnNumberAndTheTransportThatMovesTheoremsBetweenThem

-- The same, from the CONTENT-ADDRESSED census rather than the printed-type
-- one (machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs, 236 addresses
-- holding more than one definition).  Samkhya_ works address
-- 8fabe7d4e1a18208 — four statements of n ↦ 2ⁿ holding four disjoint
-- theorems; Apavartana_ works ec6d2556e0be6f36 and the larger duplication
-- against the LIBRARY that the census cannot see, because it reads only
-- this corpus.  Neither edits any module it identifies.
-- import Samkhya_TheCountIsStatedFourTimesAndPingalasProcessComputesEveryOneOfThem  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing
-- import Apavartana_TwoPresentationsOfDividesAndTheDifferenceLawThatCrossesBetweenThem  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing

-- The ambient symmetry an ARITHMETIC constraint destroys, stated once
-- and instantiated: CenterRelative/PrimePairField (the cone),
-- CenterRelativeIntegral (index 2) and S3IntegerRelativeCoordinates
-- (the radial line) were five independent write-ups of one phenomenon
-- with zero cross-references.  Added alongside; none of them edited.
-- import Arpitanarpita_TheSymmetryTheArithmeticConstraintDestroys  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing

-- Landed by रात्रिः (scripts/Ratri_…sh): निर्धारण probes the KERNEL accepted,
-- checked in place before landing.  Nirdharita_ = the field IS determined
-- (road one, संक्रमण).  Anirdharita_ = it is NOT, with the two inhabitants
-- that prove it (road two, दोषलेख).  Both are results; landing only the
-- first would be दुर्नय.
import Ratri.Anirdharita_EGBDetConservation_UT
import Ratri.Anirdharita_EGBDetConservation_UT_NirdharanaPthreeB
import Ratri.Anirdharita_EGBDetConservation_UT_NirdharanaPthreeC
import Ratri.Anirdharita_EGBRootedNet_Jewel
import Ratri.Anirdharita_EGBRootedNet_Jewel_NirdharanaPthreeE
import Ratri.Anirdharita_KloostermanExponents_ℤ±
import Ratri.Anirdharita_KloostermanExponents_ℤ±_NirdharanaPthreeG
import Ratri.Anirdharita_NaturalMachine-ArityOfRepair_Bounds
import Ratri.Anirdharita_NaturalMachine-ArityOfRepair_Bounds_NirdharanaPthreeI
import Ratri.Anirdharita_NaturalMachine-FiniteOccupancyChannelNoGo_Occupancy₄
import Ratri.Anirdharita_NaturalMachine-FiniteOccupancyChannelNoGo_Occupancy₄_NirdharanaPthreeK
import Ratri.Anirdharita_NaturalMachine-FiniteOccupancyChannelNoGo_Occupancy₄_NirdharanaPthreeL
import Ratri.Anirdharita_NaturalMachine-FiniteOccupancyChannelNoGo_Occupancy₄_NirdharanaPthreeM
import Ratri.Anirdharita_NaturalMachine-MachineLoop_LoopState
import Ratri.Anirdharita_NaturalMachine-MachineLoop_LoopState_NirdharanaPthreeO
import Ratri.Anirdharita_NaturalMachine-MachineLoop_LoopState_NirdharanaPthreeP
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeAB
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeW
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeX
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeY
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeZ
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env_NirdharanaPthreeR
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env_NirdharanaPthreeS
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env_NirdharanaPthreeT
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env_NirdharanaPthreeU
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env_NirdharanaPthreeV
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAD
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAE
import Ratri.Nirdharita_Agda-Builtin-Nat_
import Ratri.Nirdharita_Swarm-S09SmithKuttaka_
import Ratri.Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_
import Ratri.Anirdharita_EGBDetConservation_UT_NirdharanaPthreeA
import Ratri.Anirdharita_EGBRootedNet_Jewel_NirdharanaPthreeD
import Ratri.Anirdharita_KloostermanExponents_ℤ±_NirdharanaPthreeF
import Ratri.Anirdharita_NaturalMachine-ArityOfRepair_Bounds_NirdharanaPthreeH
import Ratri.Anirdharita_NaturalMachine-FiniteOccupancyChannelNoGo_Occupancy₄_NirdharanaPthreeJ
import Ratri.Anirdharita_NaturalMachine-MachineLoop_LoopState_NirdharanaPthreeN
import Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeAA
import Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env_NirdharanaPthreeQ
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAF
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAG
import Ratri.Nirdharita_Agda-Builtin-Nat_NirdharanaPoneA
import Ratri.Nirdharita_Swarm-S09SmithKuttaka_NirdharanaPoneB
import Ratri.Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC
import Ratri.Anirdharita_Ratri-Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_CensusBase
import Ratri.Anirdharita_Ratri-Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_CensusBase_NirdharanaPthreeAF
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAH
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAI
import Ratri.Nirdharita_Agda-Builtin-Nat_NirdharanaPoneA_NirdharanaPoneA
import Ratri.Nirdharita_Swarm-S09SmithKuttaka_NirdharanaPoneB_NirdharanaPoneB
import Ratri.Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_NirdharanaPoneC
import Ratri.Anirdharita_Ratri-Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_CensusBase_NirdharanaPthreeAE
import Ratri.Anirdharita_Ratri-Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_NirdharanaPoneC_CensusBase
import Ratri.Anirdharita_Ratri-Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_NirdharanaPoneC_CensusBase_NirdharanaPthreeAH
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAJ
import Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAK
import Ratri.Anirdharita_Ratri-Nirdharita_VivekaPramana_TheRemainderIsLawfulAndTheNetBeats_NirdharanaPoneC_NirdharanaPoneC_CensusBase_NirdharanaPthreeAG

-- k(p-1), both halves: the digit protocol and the refuter.  The corpus's
-- most-cited exact cost law, proved four times in notes/ and checked by
-- nothing until this module.
import NastaVitanda_TheDigitProtocolAndTheRefuterMeetAtKTimesPMinusOne

-- सेतुबन्धः — the identification graph, walked.  `machine/Setubandha_….hs`
-- reports the largest component (10 nodes, diameter 3, hub `ℕ`); these two
-- modules compose its distance-2 geodesics out of `Pingala.छन्दस्` and
-- prove everything downstream by `subst`, with no induction on either side.
-- import Setubandha_ThePrastarasNextRowIsTheTallySuccessorAndNothingHereIsBuiltByHand  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing
-- import Sthana_ThePositionalWordIsPingalasNextRowAndItsAdditionArrivesWithNoCarryRule  -- DISABLED 2026-08-22 (wiring pass): RED — its line 93 opens Setubandha_ThePrastaras…, a module that exists nowhere on disk or in git history

-- नय — Theorem F's mechanism at the grain of the identification graph:
-- a SET-valued observable annihilates every loop, the loop is still not
-- `refl`, and dropping the set-truncation is the whole of the escape.
-- Plus: on a graph whose edges are identifications, antisymmetry is free,
-- so the causal-order reading of `Setubandha`'s reachability is vacuous.
import Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere

-- पर्याय · the census of that charged sector, decided one row at a time.
-- `Setubandha` reports fourteen automorphisms `A ≃ A` and files them as
-- "no reachability, real content".  Eleven move a point, so `ua e ≢ refl`
-- and the charge is real; ONE (`BraidCoherenceBoundary.identityCrossingEquiv`)
-- is the identity function and its loop is literally `refl`; TWO are
-- FAMILIES over a type variable, identity at one instantiation and not at
-- another, so the family has no answer and only its instances do.  The
-- corpus's checked π₁ at the identification graph's hub `ℕ` is ℤ/2.
import Paryaya_ElevenOfTheFourteenLoopsMoveAPointOneIsTheIdentityAndTwoDependOnTheParameter
-- import Paryaya_TheFibreOverATranspositionHoldsTwoElementsAndTheIdentityFibreCarriesASymmetryThatMovesAPoint  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing

-- The gloss on `Naya` §४ — "truncating to a set is THE WHOLE of the
-- blindness" — is refuted by a term: `transport` is a set-valued
-- observable (`Bool → Bool` is a set) and it separates `ua notEquiv`
-- from `refl`.  `Naya` §१ is untouched and applied unchanged; what is
-- corrected is which quantifier the blindness lives under, and §५ notes
-- the charged sector `Bool ≡ Bool` is itself already 0-truncated.
import Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness

-- दुर्नयः: the correction above overshot in README.md's restatement of it.
-- C2 replaced the struck truncation gloss with "not of the answer's
-- h-level", and `Naya` §१'s own `isSet X` hypothesis — plus `Naya` §४,
-- a non-dependent `cong F` that does NOT annihilate — refutes that
-- clause.  This module moves the whole question off the universe (the
-- loop is a CONSTRUCTOR of S¹ : Type₀), shows neither condition alone
-- suffices, and gives the RECEIPT the earlier pair only separated
-- against: what every set-valued observable of the carrier destroys is
-- exactly ℤ, identified by `winding` on the nose.
import Durnaya_TheBlindnessNeedsBothConditionsAndTheHiddenChargeIsExactlyTheIntegers

import Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFibreFailingToBeContractible

-- अनुलोम-प्रतिलोम's 39-pair work queue, worked by hand.  The proposer
-- reported 0/39 at every rung and concluded the corpus has no cheap
-- equivalence harvest; sixteen of the 39 were already proved in the host
-- file the proposer read, and of the rest these three modules close two
-- edges, refute four pairs, and separate two type pairs outright.
import Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup
import Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence
import Bhadraganita_TheThreeByThreeSquareIsNineEntriesAndDecidabilityCrossesFree

-- ── समुच्चयः, 2026-08-22 ─────────────────────────────────────────────────
-- Eight modules that were on disk and outside every root's import closure,
-- so nothing rechecked them and no green covered them.  Each was run
-- individually before being wired: all eight EXIT 0 under Agda 2.8.0 +
-- cubical v0.9 (the pin).  Found by
-- `runghc machine/Samuccaya_…hs`, which also found that the two shell
-- closure gates were reporting 17 FALSE orphans, because their module-name
-- regex is ASCII-only and those modules are named `…_ℤ±`, `…Occupancy₄`,
-- `…_विवेक`.
-- import DosaLekha_TheWrittenDefectIsOnePairOneViewAndOneSeparation  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing
import PunaragamanaVartula_TheDatumRidesTheLoopFreeExactlyWhenTheConsumerIsInvariant
-- import Punaragamana_TheForwardFibreIsFreeAndTheBackwardFibreIsTheDefect  -- DISABLED 2026-08-22 (wiring pass): no such file on disk or anywhere in git history; a missing file verifies nothing
import Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt
import Sakaladesa_NoSingleUtteranceDenotesTheTotalStatementAndTheContentNonethelessFolds
import Tantujala_TheFibreHasThreeVerdictsAndIsContrMergesTwoOfThem
import VajraAbhyasa_TheCrossProductIsOneAndTheNextClassIsExactlyMinusM
import YugmaPurana_TheValliRecoversItsLengthModuloTwoAndNoFurther
import Punarukti_TwoOfTheThreeSevenfoldsAreOneTypeAndTheThirdIsADifferentQuestion
import Ankapasa_TheMetreNamesAFiniteSetAndTheLoopsOfThatSetAreTheFactorial

-- अनुलोम-प्रतिलोम's 39-pair work queue, worked by hand.  The proposer
-- reported 0/39 at every rung and concluded the corpus has no cheap
-- equivalence harvest; sixteen of the 39 were already proved in the host
-- file the proposer read, and of the rest these three modules close two
-- edges, refute four pairs, and separate two type pairs outright.
import Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup
import Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence
import Bhadraganita_TheThreeByThreeSquareIsNineEntriesAndDecidabilityCrossesFree

-- सामान्तर-सङ्कलित — landed by another lane and outside every root's
-- closure at the moment समुच्चय ran.  Runs individually at EXIT 0 on the pin.
import SamantaraSankalita_TheGeneralSeriesAtOneAndOneIsTheSankalitaAndTheExampleWasStandingForIt

-- स्थिरबिन्दुगणना — the nonabelian census: fixed-point count as the
-- conjugation-invariant class map for S₃, closed-loop gauge invariant via
-- RelationalHolonomyRefinement.  Landed 2026-08-22.
import NaturalMachine.SthiraBinduGanana_TheFixedPointCountIsTheConjugationCensusForS3
-- ── समुच्चयः, 2026-08-22 (second pass) ────────────────────────────────────
-- Four more modules that arrived by merge from origin already committed and
-- already outside every root's closure — long-standing rot, not new work.
-- All four run individually at EXIT 0 on the pin.
import CenterRelativeWeightTransport
import ContractibleFiberSectionBoundary
import SexticParityEliminant
import SmithDeterminantClassMultiplicativity

-- ── लोपः, 2026-08-22 ──────────────────────────────────────────────────────
-- Road two of अहिंसा-सूत्र-विस्तारः §६, at one edge.  The fibre of `योग` is
-- `NaturalMachine.PairsSummingTo.Pairs`, on the nose, and is therefore
-- already counted; no module imported both files before this one.
import Lopa_TheSumsFibreIsExactlyNPlusOneAndNoLeftInverseExists
import Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart
-- …and the limit of that generalisation: `Vaidharmya` still demands EQUAL
-- transcripts, an analytic barrier lemma delivers only CLOSE ones, and with
-- `BARRIER.md` Prop. B3's arbitrary post-processing the near version is FALSE
-- — §४ is the one-query counterexample.  `METHOD.md` §3 item 1 does not split.
import Asanna_TheNearIsNotTheEqualAndTheBarrierDiesInTheGap
import Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd
import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry

-- मार्ग-१ — the FIRST MECHANICALLY-ROUTED TRANSPORTED THEOREM: emitted by
-- machine/Marga_TheRouterTransportsATheoremAlongLandedEdges.hs, route of
-- toll 2 through audit-surviving edges, checked before landing. 2026-08-22.
import Marga1_TheDoubleCountermodelCrossesTwoCausewaysAndTheFarCensusHasTwoDistinctInhabitants
import Chandomudra_ThePratyayasFibresWereWrittenInProseAndTheCensusCalledThemUndecided
import Tantusandhi_TheFourWrittenFibresWereAlreadyTheQueuesOwnMapsAndTwoEdgesTheCensusNeverSaw
import Samjna_TheSemanticFibreCarriedItsNameAndTheFiveThatDidNotAreFibresOfARestriction

-- दुर्नयः, 2026-08-22.  The Boolean three-into-two pigeonhole stands FOUR
-- times in this corpus — Saptabhangi.दुर्नयः, DisclosureDimension.three-into-two,
-- Swarm.S01PaniniAshby.twoOfThree, Vyatireka_….pairOf — with no import edge
-- between any two.  `pairOf` and `twoOfThree` are the same function on the
-- nose; the Jaina statement is the Boolean one across द्विपद → Bool.

-- ── समुच्चयः, 2026-08-22 (third pass — the wiring pass) ───────────────────
-- Seven modules on disk and outside every root's import closure, found by
-- `sh scripts/.prasava-unreached.sh` (the corrected Haskell closure, not
-- the old ASCII-regex count).  Each was typechecked individually before
-- being wired: all seven EXIT 0 on the pin.
import ModeAdjointFinitenessBoundary
import NaturalMachine.AssemblyCharacterNonfaithfulness
import NaturalMachine.BGRadiusProjectionUnsafe
import NaturalMachine.FluxUnitCancellationBoundary
import NaturalMachine.LeastWindowRadiusEdge
import NaturalMachine.Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries
import NaturalMachine.RadiusNoGo

-- ── समुच्चयः, 2026-08-22 (fourth pass) ────────────────────────────────────
-- Three modules landed by concurrent lanes while the wiring pass ran,
-- each outside every root's closure at the moment the gate re-ran.
-- All three typechecked individually at EXIT 0 before wiring.
import ChidraDosa_ThePointwiseInvarianceWithNoCoherentDescentIsATerm
import Marga2_TheFirstTolledCrossingOfAOneWayEdge
import YogaDhruva_TheFibreOfAdditionIsATorsorAndEveryConservingFlowIsATranslation

-- ── तपस्, 2026-08-22 ──────────────────────────────────────────────
-- Fibre receipts minted from templates against लोप's UNDECIDED queue,
-- each checked before landing; the refusal ledger for everything not
-- minted is in the pass log (scripts/Tapas_…sh).
import Tapas.ConstantFibre_NaturalMachine-BatchDepthMemoryBoundary_oldValue
import Tapas.ConstantFibre_NaturalMachine-DependentOptimizationFibration_semantics

-- प्रक्षेप-तन्तुः — the fibre of a projection is the discarded factor:
-- fiber fst a ≃ B, fiber snd b ≃ A, at arbitrary levels, no h-level
-- hypothesis. The proof-shape a तपस् fst/snd emitter instantiates. 2026-08-22.
import PraksepaTantu_TheFibreOfAProjectionIsTheDiscardedFactor

-- सङ्ख्या-तन्तुः — the fibre of a finite-source map is finite (isFinSetFiber)
-- and its cardinality is the सङ्ख्या receipt: the count enzyme for the whole
-- finite-source tail, one citation each; honest on सूत्र ८ (count free,
-- untruncated Fin-k identification not claimed). 2026-08-22.
import SankhyaTantu_TheFibreOfAFiniteSourceMapIsFiniteAndItsCardinalityIsTheReceipt

-- ── योगक्षेत्र, 2026-08-22 ────────────────────────────────────────────────
-- The classification YogaDhruva's header fenced as unclaimed: over any
-- CommRing, conserving flows of addition ≃ shear fields (a function space).
import YogaKsetra_TheConservingFlowsOfAdditionAreExactlyTheShearFields
-- [STRUCK 2026-08-22, SvaTantuVasa landing pass: the import below entered at
--  commit 5825625a while its file exists in NO commit and is not on this
--  checkout's disk — the अनाथ defect the Lean root recorded the same day, in
--  this lane; every clone's Everything has been red at line 1135 since.  If
--  the file is uncommitted in a live checkout, LAND IT and un-strike.]
-- import Durnaya_TheThreeIntoTwoLemmaStandsFourTimesAndOneTransportMakesThemOne

-- ── परम्परा, 2026-08-22 ──────────────────────────────────────────────────
-- THE FIRST CHAIN THE CORPUS HAS PRICED.  `Sesa_…शेष` is instantiated at
-- Bool ⊎ Unit ↪ Bool × Bool ↠ Bool ↠ Unit with every fibre written out by
-- hand and the general law CHECKED against the hand computation (`refl`).
-- The losses do not add: the chain's total fibre is Bool ⊎ Unit (three)
-- where the per-step ledger predicts Bool × Bool (four), and the missing
-- one is an अभाव with its pratiyogin named — `fiber प्रवेश (false , true)`
-- is empty.  The `Unit → Bool → Unit` cancellation is derived from the
-- same alignment term rather than left standing as an anomaly.
import Parampara_TheChainOfThreeIsPricedAndTheLossesDoNotAddBecauseAnAbsenceSitsInTheMiddleFibre

-- ── पिङ्गलस्य द्वौ प्रत्ययौ, 2026-08-22 ──────────────────────────────────────
-- The two pratyayas of छन्दःशास्त्रम् ८ that had no module.  नष्ट/उद्दिष्ट as
-- the INVERTIBILITY TEST — a checkable predicate whose inhabitant is exactly
-- एकम् at every point (`Tantujala_…`), with both roads exhibited: the
-- प्रस्तार of any छेद-सूची carries the witness, `Bool → Unit` provably carries
-- none.  And लगक्रिया as the CONDITIONAL RECEIPT — the fibre over a partial
-- specification, i.e. what a second observable still costs once the first is
-- known, with the मेरु row sum closing it back onto the सङ्ख्या.
import NastoddistaPariksa_BothDirectionsExistExactlyWhenEveryFibreIsContractible
import Lagakriya_TheConditionalFibreIsWhatTheSecondCountStillCostsOnceTheFirstIsKnown
import Avasesa_TheResidueMapsFibreIsACopyOfTheNaturalsAndTheProgressionIsTheReceipt
import Ksepa_ThePassedInvariantComposesAndTheGradingIteratesOnlyIfItIsACharacter
import Avrtti_TheFibreOfACountingMapSatisfiesARecurrenceAndThatRecurrenceIsSankhya

-- खहर · the far end of the loss scale: the edge ℤ ⟶ खहर is priced at its
-- whole domain, and TOTAL LOSS IS EXACTLY TOTAL SYMMETRY — the equivalence
-- whose other end is Dhruva §२. Bhāskara II, बीजगणितम् २०, 1150. 2026-08-22.
import Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry

-- ── संशय, 2026-08-22 ────────────────────────────────────────────────────
-- THE ROUND-TRIP LEDGER'S VERDICT TYPE HAS TWO VALUES AND ITS QUESTION HAS
-- AT LEAST FOUR STATES, so `notes/SADHYA_OPEN_OBLIGATIONS.md` — the document
-- an arriving agent lands on — renders decided rows as «real obligations».
-- Twelve pairs are decided here.  One is an equivalence CONSTRUCTED SIXTEEN
-- LINES ABOVE where the probe looked (`NaturalMachine.FreeMonoid`); six are
-- refuted by counting arguments the source file already proves for all t
-- (`IntegerHullMultiplicity.hullN`, `hullSQ`); one is a section/retraction
-- pair whose content is a fibre, not a debt (`SieveScaleTower`); and one has
-- BOTH maps invertible with the round trip equal to `not`, which the source
-- file already named `holonomyIsNot`.  Gautama, न्यायसूत्र १.१.२३ (saṃśaya)
-- and १.१.४१ (nirṇaya), ~2nd c. CE.
-- [STRUCK 2026-08-22, SamraksakaGana landing pass: the import below entered
--  at रात्रि commit abcec25b while its file exists in NO commit anywhere
--  (git log --all) and is not on disk — second अनाथ import found today, same
--  shape as the Durnaya one struck above.  The रात्रि wiring step appears to
--  add imports for modules whose files the pass then fails to land; that is
--  a loop defect worth a doṣa.  If the file is uncommitted in a live
--  checkout, LAND IT and un-strike.]
-- import Samsaya_TheLedgerCallsFourDifferentStatesOneRefusalAndTwelvePairsAreDecidedHere
import Bhara_TheWeightedCountingMapsFibreDecomposesOverEverySummandThatFits
import Apunaragamana_TheBhavanaOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity
import Vrddhiksaya_TheAscendingGeneratorNeverReturnsAndTheDescendingOneExhausts
import Sarvasthana_TheTotalOverEveryPlaceIsZeroAndTheArchimedeanEntryIsTheBalancingOne

-- स्वतन्तुवासः · the loss–symmetry scale closed at its middle: the conserving
-- flows of ANY observable are exactly the sections of its own fibre family,
-- (Σ[ Φ ] संरक्षणम् f Φ) ≃ ((a : A) → fiber f (f a)), no hypotheses — the
-- Π/Σ distributivity cited from the library, not re-derived. Dhruva's pole
-- strengthens to isContr of the flow space, Khahara's total symmetry derives
-- over a set codomain, YogaKsetra's shear fields become the sectioned fibres
-- of addition over any CommRing, and Khahara §६(b)'s monotonicity śeṣa is
-- discharged as Π-functoriality. Routes kept, MadhyaVinimaya-style. 2026-08-22.
import SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres

-- संरक्षकगणः · SvaTantuVasa §६(a) discharged the same day it was written:
-- conserving flows compose (witnesses compose along ∙), sections carry the
-- convolution (s ⋆ t) a = (s (t a .fst) .fst , s (t a .fst) .snd ∙ t a .snd),
-- and वासः transports the one onto the other BY refl — the identification of
-- the spaces was an identification of the dynamics.  At set level both are
-- library Monoids and वासः is a MonoidEquiv with both fields refl; the poles
-- price as monoids (trivial gaṇa at zero loss, the full transformation monoid
-- at total loss, projection-by-refl).  गण after the gaṇapāṭha: the class that
-- behaves alike under the rule.  2026-08-22.
import SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl
import Vargaprakrtitantu_ThePellFibreIsInfiniteAndBrahmaguptasCompositionIsTheWitness

-- कक्ष्या — the conserved quantity is constant along the WHOLE orbit, not
-- across one step; no two stations of an orbit are separated by the
-- observable; under losslessness the entire forward orbit collapses to its
-- basepoint (movement 30's "frozen" as a term rather than a sentence); and
-- the orbit lies in one fibre, which is what Dhruva §१ reads in prose.
-- Closes the item Dhruva §४ names as open.  2026-08-23.
import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep

-- अभिज्ञान — the two bindings of `f a ≡ b` priced against each other: the
-- output-bound side contractible with no hypothesis, the input-bound side
-- exhibited non-contractible, and then the sentence that needs both — the
-- codomain does not determine losslessness, so an identification and an
-- elision agree on the result and differ only in the fibre.  Which is why
-- the instrument that separates them is a checker and not a reader.
-- 2026-08-23.
import Abhijnana_TheReceiptAndTheElisionAgreeOnTheResultAndDifferOnlyInTheFibre

-- तन्तु-त्रयम् — three maps into ONE codomain with fibres रिक्तम् / एकम् / बहु,
-- so a two-valued verdict answers the same for the first and the third and
-- §१.४ exhibits that they differ.  Saptabhangi's pigeonhole at the minimum
-- instance.  And §२: Unit→Bool→Unit, the second factor losing a bit and the
-- composite losing nothing — the alignment term vanishing, Knill–Laflamme
-- exhibited, movement 2's named cancellation as a term.  2026-08-23.
import Tantutrayam_ThreeMapsIntoOneCodomainExhibitTheThreeVerdictsAndTwoLossyEdgesComposeLosslessly

-- संक्रमण — the transport economy, as the four library facts it actually is:
-- one edge carries EVERY predicate with no hypothesis on it (which is the
-- whole of why a receipt is non-rival), edges compose so a route is an edge
-- and length costs nothing, and the road is two-way with an identity at every
-- node.  Road one is a groupoid, which is why routing on it is total.
-- 2026-08-23.
import Samkramana_AnEdgeCarriesEveryPredicateAndEdgesComposeSoTheRouteIsFree

-- अनुपलब्धि — absence is exactly universal lack: ¬Σ ≃ Π¬, both directions
-- free, and the point is the SHAPE of the right side.  A claim that a fibre
-- is empty is a Π over the WHOLE domain and cannot be less.  That is
-- Kumārila's yogyatā condition as a type, and it is why रिक्तम् is the only
-- verdict with no exhibiting witness — and why "I searched and did not find"
-- has no internal statement at all, which is precisely why it licenses
-- nothing.  Nirdharana reaches the same wall and says so.  2026-08-23.
import Anupalabdhi_AbsenceIsAStatementAboutTheWholeFieldAndNotAFailureAtAPoint

-- अभेद-भेदः — Leibniz both ways in one file.  cong is indiscernibility of
-- identicals and is free, carrying no hypothesis because it is constitutive
-- of equality rather than a theorem about anything.  Its contrapositive is
-- every barrier in every science, exhibited minimally.  And ua is the other
-- law, which does not fail.  So the fibre is exactly the gap between
-- indistinguishable-by-THIS-observation and indistinguishable-by-ALL-
-- structure, and a barrier is the report that one is not at the limit.
-- 2026-08-23.
import Abhedabheda_OneObservationFailsToSeparateWhatIsDistinctAndTheFullClassNeverDoes

-- लेखा — the audit trail rides free at LENGTH, not only one step.  Carrier
-- proves one step; everything downstream (that a receipted mathematics is
-- affordable, that proof-of-transport is cheap, that Bennett's garbage tape
-- IS the carried witness) is a claim about chains, and one step does not give
-- it.  §२: a point carried through two maps with both intermediates and both
-- witnesses is EQUAL to the bare point.  §३: and at every n, by induction.
-- So what is bounded is never the trail — it is what the MAPS destroy, which
-- is the other binding entirely.  2026-08-23.
import Lekha_TheWholeAuditTrailOfAChainIsFreeToCarryAndNotOnlyOneStep

-- वरणम् — a section IS a choice of receipt at every point.  When nothing is
-- hidden the space of such choices is contractible: the choice exists, is
-- unique, and therefore is not a choice.  When a bit is hidden there are two
-- sections, distinct, with nothing to decide between them and the codomain
-- blind to which was taken — movement 22's vacuum choosing a point in a
-- formerly free fibre, at the smallest scale, and Dhruva's sentence from the
-- section side.  2026-08-23.
import Varanam_ASectionIsAChoiceOfReceiptEverywhereAndForALossyMapTheChoiceIsReal

-- पुनरागमनम् — the word this corpus is named after, as a no-go, and the
-- asymmetry is the content.  Out-and-back in the CODOMAIN is free at any
-- loss: pick any preimage and you are where you started.  Out-and-back in the
-- DOMAIN is not available: no map back returns every point to itself, and the
-- obstruction is exactly the destroyed bit.  A debt does not stop you moving
-- and does not stop you returning to a description — it stops you returning
-- to the THING.  And at zero defect the way back exists, both ways.  2026-08-23.
import Punaragamanam_ReturnIsOnlyAtZeroCostAndALossyEdgeHasSectionsButNoWayBack

-- द्वयम् — movement 34's "two is the first veil" as a theorem rather than a
-- pattern over instances: ANY failure of injectivity embeds Bool injectively
-- into a fibre.  There is no losing less than one bit; the moment an
-- observation confuses anything at all, a two is inside the fibre, and every
-- larger loss contains this one.  Says nothing about why a particular
-- obstruction is EXACTLY a bit — only that a bit is the floor.  2026-08-23.
import Dvayam_AnyLossEmbedsABitSoTwoIsTheSmallestVeilThereIs

import Setu_TheReturnAndTheCutDecomposeTheSamePairAndSetubandhaNamedTheGap
import Avacchedaka_TheTruncationsFibreIsTheWholeSourceAndTheSeamHasItsCriterion

-- अन्वेषणम् — the routing consequence of Lekha §३ and Punaragamanam §२–३,
-- assembled: an arbitrarily deep forward exploration carrying its ENTIRE
-- audit trail is contractible at every depth, with no hypothesis on the step
-- however much it destroys.  So a search here does not pay per edge.  The
-- frontier is not the set of nodes reached — it is the set of identifications
-- owed.  And §३ carries the router's correctness condition, which is
-- Anupalabdhi read at a search: "I explored and did not arrive" is not "there
-- is no route", so the only admissible verdicts are a route, a written defect,
-- or UNDECIDED.  2026-08-23.
import Anvesanam_ForwardSearchIsFreeAtAnyDepthAndCostIsIncurredPerIdentificationDemandedNotPerEdgeTraversed
import Kosthanyaya_TheDurnayaIsThePigeonholeAndTheLossIsTheSeparateHypothesis

-- भार-आवृत्ति — closes the next rung Avrtti §५ names and does not write: the
-- fibre of a WEIGHTED counting map.  And it corrects the shape §५ proposed,
-- which cannot hold as stated (the empty list inhabits fiber f 0 and has no
-- head to produce): the nil case is a SEPARATE SUMMAND and the honest
-- decomposition is a coproduct.  With it both round trips close by refl,
-- because भारः (x ∷ xs) reduces definitionally and the "fitting proof" §५
-- expected to construct is the same path carried across unchanged.  2026-08-23.
import Bharavrtti_TheWeightedCountingMapsFibreDecomposesByHeadWeightAndTheNilCaseIsASeparateSummand
import Svasthani_TheHypothesisThatClosesSthanivadbhavaFailsAtTheFirstSubstitutionAndReturnsAtTheSecond
import Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification

-- नष्ट — two edges taken off `Lopa … --queue` by exhibiting the recovery
-- map, which converts a receipt into an address: the one-hole context IS
-- its action word (`decodeContext ∘ compileContext ≡ id`, the round trip
-- CompositionalContextAdapter never wrote), and a 3×1 integer matrix IS
-- its triple of entries (`refl`, the half SmithPathCountedExecution never
-- stated beside the funext half it did).  §४ states the extent of the
-- search and names the census defects it found and did not repair.
import Nasta_TheOneHoleContextAndTheColumnAreRecoveredFromTheirData

-- विरहाङ्क — the mātrā fibre satisfies the two-step recurrence, as an
-- EQUIVALENCE OF FIBRES rather than a count: fiber (n+2) ≃ fiber (n+1) ⊎
-- fiber n, prepend-laghu and prepend-guru, with both base cases contractible.
-- Virahāṅka c. 600-800 on Piṅgala's weights.  The numbers are its shadow.
import Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence

import VivekaSetu_TheTwoRemainderRecordsAreOnePairAndThereforeEachOther
import Anapeksa_BlindnessToACoordinateIsAFactorisationSoEveryStepInItConservesForFree

-- संरक्षकसमूहः: the invertible conserving flows form the observable's
-- symmetry GROUP (inverse data proved propositional, so the carrier is a
-- subtype); the group rides वासः pointwise by cong; zero loss makes it
-- trivial and total loss makes it ALL of Aut(A) by a GroupEquiv whose
-- function part and hom law are refl.  SamraksakaGana §५(b) discharged.
import SamraksakaSamuha_TheInvertibleConservingFlowsAreTheSymmetryGroupAndTotalLossMakesItAllOfAut

-- तन्तुविभागः: the gaṇa of an observable IS the product over the codomain
-- of its fibres' own endomorphism monoids (set level): छेदगणः ≅ Π_b
-- End(fiber f b) as monoids, and composing with गण-समता (refl fields),
-- प्रवाहगणः ≅ तन्तुगणः with no path algebra at the join.  The currying
-- coherence both SvaTantuVasa §६(a) and SamraksakaGana §५(a) named is paid
-- with one J (transport fixes the point).  The commutant-decomposes-over-
-- the-spectrum slogan, typal shadow, exact.
import TantuVibhaga_TheGanaOfAnObservableIsTheProductOfItsFibresOwnEndomorphismMonoids
import SamasaSetu_TheChildEdgeIsTheCompositionOfTwoParentFordsSexualNotAsexual
import VivekaTadatmya_TheSumTypeDescentAndTheGraphOfPlusAreOneObject
import Namantara_TheLatinLabelledSevenfoldAndTheDevanagariSevenfoldAreOneTypeAndAkalankasCountRoutesAcross
import Trivarna_TheTwoThreeLetterAlphabetsAreOneType
import AksharaDvaya_TheVirahankaBoolFibreAndThePingalaChandasFibreAreOneWeightedCount
import EkaksharaSetu_TheOneLetterTallyIsThePiZeroOfFinSet
import PraksepaSankhya_TheProjectionsFibreCensusIsTheDiscardedFactorAndTheAbhijnanaIsSupplied
import SamaVisama_TheCountSplitsByParityIntoTwoCopiesOfItselfAndEachNayaIsTheWhole
import Matrasankhya_TheMatraFibreIsFinOfTheVirahankaNumber
import MatraSetu_TheVirahankaFibreCountsAsFinByBridgingToPingalasMetre
import Pratibimba_TheRootedFiberOverAJewelIsItsLocalDatumWithAllItsReflections
import MeruTantu_TheGuruCountFibreSplitsByHeadIntoTheTwoAdjacentCellsWhichIsMeruprastara
import Vikalpa_TheFibreOfATwofoldMapIsTheTwofoldOfItsFibresAndSoTheCountsAdd
import Paryayasabda_TwoNamesForTheParitySectorAndTheCharacterLawCarriesAcrossBetweenThem
import SamkhyataAnanta_AdjoiningANumerableToTheCountablyInfiniteReturnsTheCountablyInfinite
import DviMatra_TheFibreOverTotalTwoIsExactlyBoolTheSmallestVeil
import NarayanaGavampasa_TheCowCompositionFibreSplitsAtTheHeadIntoOneAndThreeYearBranches
import Rupasamata_TheTwoByTwoMatrixAndTheFourTupleAreOneObjectAndMultiplicationAgrees
import PravesaTantu_TheInjectionsFibreIsContractibleOnItsImageAndEmptyOffItSoItIsReceiptAndWall
import Viloma_TheBackwardReadingOfAMatraMetrePreservesItsDurationSoReversalIsAnInvolutionOnEachDurationFibre
import Samyoge_LosslessnessComposesButLossinessDoesNotSoNoPipelineGradesByItsSteps

import Uddista_TheReceiptBecomesAnAddressExactlyWhenTheFibreRankIsCarriedAndItsPriceIsVirahankasNumber

-- अपवर्तनम् — the FOURTH carrier step law, the one the kuṭṭaka instance in
-- `punaragamana` never states: what the CARRIED PAIR does under the वल्ली step.
-- क्षेप multiplies, rank succeeds, coarseness scales — and the pair loses the
-- lesser out of the greater while its common measure stands.  Needs the round
-- trip भेद∘उत्थान ≡ id, which that module does not have.  Self-contained: the
-- carrier, the three slots and divisibility are redefined here, and the header
-- names every duplicate.  Āryabhaṭa, गणितपाद ३२–३३, 499, second-hand.  2026-08-22.
import Apavartana_TheCarriedPairLosesTheLesserFromTheGreaterAndTheCommonMeasureStands

-- सापेक्ष–निरपेक्ष — the ३/४ criterion this lane proposed yesterday
-- (`Avacchedaka_…` §३, mine) is refuted by the corpus's own level-२
-- archetype: `fiber (Bool → Unit) tt ≃ Bool` is the whole source, so
-- `सर्वहानिः` does not separate ४ from ३ or even from २.  Not a stray
-- instance — `∥ Bool ∥₁ ≃ Unit`, the triangle commutes, and the two fibre
-- censuses are pointwise equivalent.  The witness half is vacuous too:
-- `idfun` separates two fibre points of `∣_∣₁`.  What the collision names
-- is that recovery is सापेक्ष — one map, two retained contexts, opposite
-- verdicts — so no property of the map alone carries the level.
-- Siddhasena Divākara, *Sanmatitarka* 1.21–25, c. 5th c.  2026-08-22.
import SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibreCriterionFailsOnItsOwnArchetype

-- शलाका — Vīrasena's cutting operations put to the job the Jaina orders are
-- for: each cut strips EXACTLY one storey of the tower (एक-छेदः), so k cuts
-- return a height-k tower to its base and do NOT reach the base of a
-- height-(k+1) one (असमाप्तिः).  And every śalākā — अर्धच्छेद, वर्गशलाका, and
-- higher — is अधोगामी in Vrddhiksaya's sense, which that file asserted of
-- them in prose and never proved.  Digambara, धवला c. 816; verse-level
-- citation owed, second-hand, and none guessed.
import Salaka_TheOrdersAreSeparatedByHowManyCutsTheyOutlastAndEachCutStripsExactlyOneStorey

-- दृढम् — the ARITHMETIC half of what `Sarvasthana` deliberately left out.
-- Every n ≥ 1 is a product of firm numbers (existence, by well-founded
-- recursion on a decidable bounded search), Euclid VII.30 proved from the
-- library's gcd, and hence: the SUPPORT of the factorisation is determined
-- by n — for firm p, p ∣ n ↔ p occurs in the list.  Multiplicities are NOT
-- shown unique and v_p is not defined; the fibre of D ↦ ∏ p^e over n is
-- proved INHABITED, not contractible.  2026-08-22.
import Drdha_TheFirmNumbersProductIsEveryPositiveIntegerAndTheirMembershipIsDecidedByDivision

-- भागहारः — the exact division carried as a witness, and the चक्रवाल turn
-- built out of it.  `भागहारः j n` is division of n by (suc j) presented as
-- a carrier: base (dividend, divisor), carried the लब्धि, witness
-- n ≡ suc j · लब्धि; `भागहार-एकः` proves the type is a PROPOSITION, so the
-- quotient is determined and free to carry — one h-level weaker than the
-- क्षेप's contractible fibre, and weaker exactly because division is
-- partial.  `पद-प्रमाणम्` is then the cyclic step in all four sign cases
-- (Brahmagupta's धन/ऋण, not a Bool), and §५ RUNS it: six turns at D = 61,
-- Bhāskara's own example, every divisibility discharged by refl in the
-- kernel, reaching (29718, 3805, −1); one भावना doubling closes it at
-- 1766319049² − 61·226153980² = 1.  NOT proved: termination, minimality of
-- Bhāskara's m-choice, existence for general D.  2026-08-22.
import Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAtSixtyOne

-- पूर्वत्रासिद्धम् (8.2.1) as a tower of maps.  `Asiddhatva` proved the
-- stratification buys termination; this asks what the blindness IS, and the
-- answer is a fibre: 8.4.56 maps `ka` and `ga` — which disagree about
-- whether 8.2.39 still applies — to one form, so 8.2.39's condition has NO
-- value on the later form (`अवरोहणाभावः`), not merely a different one.  The
-- converse (`सर्वावरोहणम्`: contractible fibres ⇒ every predicate descends)
-- makes that content rather than accident, and `असिद्धत्वहेतुः` derives from
-- the two that the necessity of 8.2.1 at this site IS a later rule
-- collapsing two forms.  The tower decomposition is `Sesa`'s शेष, imported,
-- not restated.  Pāṇini, *Aṣṭādhyāyī* 8.2.1 / 8.2.30 / 8.2.39 / 8.4.56,
-- c. 500 BCE; he proves nothing here.  2026-08-22.
import Purvatrasiddham_TheLaterRulesFibreIsExactlyWhatTheEarlierRuleCannotSeeAndTheBlindnessIsForcedByCollapse

-- अनुवृत्ति — maps where definitional computation stops for transport, and
-- CORRECTS punaragamana/README.md finding 3: the Glue is transparent
-- (transport along a composite of three ua's is refl on neutral input); the
-- residue is a neutral TYPE, or the top of a Σ where every projection is
-- already refl.  Non-theorems recorded as non-theorems, with the residual
-- Agda reports.  Measurement at Agda 2.8.0 / cubical v0.9.
import Anuvrtti_TheGlueIsTransparentAndTheWholeCostIsTheNeutralTypeNotTheIdentification
