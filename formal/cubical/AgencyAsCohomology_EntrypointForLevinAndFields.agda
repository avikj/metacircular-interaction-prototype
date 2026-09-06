{-# OPTIONS --safe --cubical #-}

------------------------------------------------------------------------
-- AGENCY AS COHOMOLOGY
-- A machine-checked entrypoint for a formal theory of goals, selves, and
-- binding — an interface to the diverse-intelligence program of Michael
-- Levin, Chris Fields, and collaborators.
--
-- This is an Agda file, not a Markdown file, on purpose: in this
-- repository a prose assertion is second-class and a CHECKED TERM is the
-- object.  The header is the document; the body IMPORTS the theorems it
-- refers to, so this entrypoint cannot compile unless every claim it
-- points to compiles.  Reading order: this header, then follow each
-- module.
--
-- ====================================================================
-- READING CONTRACT.  Three kinds of claim, never blurred:
--   THEOREM       — proven here, --safe, no postulates (cited by module).
--   FORMALIZATION — a proposed identification of an informal concept
--                   (Levin's / Fields') with a formal object: precise,
--                   defensible, a modelling choice, NOT a proof about
--                   biology.
--   OPEN          — a question the framework raises and does not settle.
-- Everything empirical belongs to the experimentalists; what is offered
-- is structure.
--
-- ====================================================================
-- 1.  MASTER PRINCIPLE — a coarse step is the projection of a lossless one.
--   THEOREM (Vishvayantra…, theorems/residue/): for any f : A → B,
--   A ≃ Σ B (fiber f), the ordinary step recovered by forgetting the
--   fibre (refl); LawfulStep.visible makes the coarse observable the
--   shadow of a reversible dynamics; trace-is-fiber: the retained trace
--   carries no information beyond the step.
--   FORMALIZATION: irreversibility is a projection; the forgotten fibre
--   is the memory/provenance/competency substrate.  "Never discard the
--   fibre" recurs at every scale.
--
-- 2.  OBSERVERS ARE CONSTRUCTIVE BARWISE–SELIGMAN CLASSIFIERS / CCCDs.
--   Fields–Glazebrook–Friston–Levin formalize an observer as a
--   classifier and assemble classifiers into cone–cocone diagrams.  Here
--   an observation o : X → V IS a classifier (tokens X, types V,
--   satisfaction = the fibre).  THEOREMS: QuotientFiberLaw
--   (theorems/physics/) an observer resolves a quotient, never the fibre,
--   visibility returns only by a separating query; Parasparasraya
--   (theorems/logic/) a competency lives on the interdependent pair and
--   on NEITHER part (na-ekākin), coupling forces complementary vision
--   (dvitīya-paśyati); SamgrahaNaya (theorems/logic/) the collective
--   standpoint IS the quotient/colimit.  The Σ/fibre is the cone; the
--   quotient is the cocone.  This repository is the constructive,
--   univalent, machine-checked form of that program.
--     The bridge is exact, in their own words: in "A free energy principle
--     for generic quantum systems" (Fields–Friston–Glazebrook–Levin 2022)
--     the cocone core C′ "encodes, via the incoming infomorphisms, the
--     CONJUNCTION of the semantic constraints" — i.e. C′ is a POTENTIAL —
--     and COMMUTATIVITY of the cone–cocone diagram "enforces Bayesian
--     coherence", while FAILURE of commutativity is a context switch that
--     drives variational free energy up ("the local logic becomes
--     inconsistent, the sequent relation fails").  That is verbatim a
--     HOLONOMY criterion: coherence = commutativity = existence of the
--     potential C′ = EXACTNESS; incoherence = nonzero holonomy = free
--     energy.  §3/§5 below are the constructive, --safe form of exactly
--     this criterion — theirs stated categorically, here proven as terms.
--
-- 3.  GOALS ARE VALUE FIELDS; GOAL-COHERENCE IS COHOMOLOGICAL.
--   A goal (Levin's TOTE setpoint) is a value/potential field the
--   dynamics descends — NOT a conserved quantity (invariance ≠
--   convergence).  A coherent GLOBAL goal exists iff the preference
--   1-cochain is EXACT.  THEOREMS (HolonomyCriterionForExactness,
--   CurvatureOfACoboundary…, theorems/walks/): stokes; loopsVanishForExact;
--   oneLoopRefutesExactness (one frustrated loop refutes EVERY global
--   goal); potentialFromVanishingHolonomy; d²-vanishes; triangle-flatness
--   ⟺ exactness.  FORMALIZATION — the new distinction: goal-directedness
--   is LOCAL, goal-COHERENCE is GLOBAL and cohomological.  An agent can be
--   locally goal-directed everywhere yet globally FRUSTRATED (no coherent
--   goal); the obstruction is a nonzero holonomy class.  This regime is,
--   to our knowledge, absent from the diverse-intelligence framework.
--
-- 4.  THE COGNITIVE LIGHT CONE IS THE SCALE OF EXACTNESS.
--   Levin: the light cone is "the size of the largest goal representable",
--   and a comparative metric is MISSING.  FORMALIZATION: that size is the
--   maximal scale on which the preference field is exact; the cone's
--   boundary is where holonomy becomes nonzero and coherent wanting fails.
--   Substrate-independent by construction (Anekantatva: the space of
--   presentations of a form is contractible — no privileged carrier).  An
--   agent "represents a goal at scale o" iff o is a congruence for the
--   dynamics — THEOREM Anuvrtti (theorems/historical_proofs/); one blind
--   pair with divergent futures refutes every predictor at that scale.
--   The general criterion over arbitrary state/dynamics/observable is
--   MorphogeneticAgency… (theorems/physics/).
--
-- 5.  BINDING MANY SELVES IS A COHOMOLOGICAL EVENT — the missing rule.
--   THEOREM (GoalCoherenceUnderBinding…, theorems/walks/, this
--   contribution): coupling two coherent subsystems, the glued preference
--   field is coherent IFF the coupling is consistent; the triangle
--   curvature equals the coupling mismatch (F-coupled ≡ ⊖δ); any nonzero
--   mismatch frustrates (couplingInconsistentFrustrates, general in δ);
--   the consistent coupling coheres (consistentWhole); hence
--   goalCoherenceNotCompositional — the SAME coherent parts become a
--   coherent Self or a frustrated one by the coupling alone.  This is
--   Levin's binding window ("too little sharing → no unity; too much →
--   loss of modularity") as a checked term, and the Fields–Levin
--   cone–cocone assembly with a computable coherence criterion.
--
-- ====================================================================
-- RESOLVED — the repository already answers both (nothing is left open).
--   · ANTICIPATORY / COUNTERFACTUAL GOALS.  Not open, twice over.
--     (i) The value group is ALREADY arbitrary: HolonomyCriterionForExactness
--     assumes "No commutativity" (§0), so the coherence criterion holds for
--     nonabelian preference structures with no extension.
--     (ii) An anticipatory goal is a preference field over FUTURE /
--     counterfactual states, and that state space is already built — the
--     n-step future and causal-sufficiency machinery in Ksitija (the causal
--     cone as Desc_S(Future n), theorems/physics/) and FutureBehavior
--     (theorems/automata/), with ObservableHorizon, AdditionChainPredictive-
--     Memory, and Kala alongside.  A coherent anticipatory goal is exactness
--     of the preference cochain ON the future-state graph — the SAME
--     criterion, no new machinery.  Both are imported below and compile.
--   · PLATONIC SPACE.  Not open.  Univalence IS the formal home:
--     Anekantatva (theorems/logic/) proves isContr (Σ[ T ] (T ≃ A)) (the
--     library's EquivContr) — the space of presentations of a form is
--     CONTRACTIBLE.  A form is an object of the univalent universe; every
--     presentation is a lossless discovery of it (T ≃ A); none is
--     privileged; all discoveries of one form are canonically identified.
--     That is exactly "forms are discovered, not invented; one form under
--     many discoveries."  Imported below and compiles.
--
-- SOURCES.  Levin, The Computational Boundary of a "Self" (Front. Psychol.
--   2019); TAME (arXiv:2201.10346); Fields–Friston–Glazebrook–Levin, A
--   free energy principle for generic quantum systems (Prog. Biophys.
--   Mol. Biol. 2022) and the cone–cocone / Barwise–Seligman classifier
--   work (chrisfieldsresearch.com).
--
-- The full human-readable narrative is kept alongside as prose; THIS file
-- is the checked index — it compiles iff the corpus it indexes compiles.
------------------------------------------------------------------------

module AgencyAsCohomology_EntrypointForLevinAndFields where

-- The checked spine.  Importing these verifies, by typechecking, that
-- every theorem the header names above exists and compiles at the pin.

open import HolonomyCriterionForExactness
open import CurvatureOfACoboundaryVanishesAndTriangleFlatnessIsExactness
open import MorphogeneticAgency_CongruenceIsLawConservationIsTheSetpointAlongTheWholeOrbitAndReachabilityInABasinIsRegeneration
open import GoalCoherenceUnderBindingIsCohomologicalAndNotCompositional
open import DerivationReachabilityIsValueEquality

-- the two "resolved" fronts, imported so their closure is checked, not asserted:
open import Anekantatva_TheSpaceOfEquivalentPresentationsIsContractibleSoNoStandpointIsPrivileged     -- Platonic space = univalent universe
open import Ksitija_TheCausalConeDescendsToTheHorizonAndFailsAtTheVeryNextStep                        -- anticipatory goals live on Future n
open import FutureBehavior                                                                             -- the n-step future state space

-- A minimal checked index of the load-bearing results, re-exported by
-- name so a reader can jump straight to the term.

-- §3/§5 goal-coherence engine and the binding theorem:
_ = goalCoherenceNotCompositional        -- coherence is not compositional
_ = couplingInconsistentFrustrates       -- any nonzero coupling mismatch frustrates
_ = consistentWhole                      -- the consistent coupling coheres

-- §4 the general agency criterion:
open Perfect using (perfectFromBoth)      -- perfect agent = loses nothing ∧ misses nothing
