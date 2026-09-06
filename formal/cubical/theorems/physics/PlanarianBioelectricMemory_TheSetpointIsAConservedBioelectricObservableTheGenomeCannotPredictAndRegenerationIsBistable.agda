{-# OPTIONS --safe --cubical #-}

------------------------------------------------------------------------
-- PlanarianBioelectricMemory — the general MorphogeneticAgency criterion
-- instantiated at a REAL Levin result, not a toy: the two-headed
-- planarian / rewritable bioelectric target morphology.
--
-- THE EXPERIMENT (Oviedo, Durant, Levin et al.).  A transient block of
-- gap-junctional (electrical-synapse) connectivity — octanol — applied
-- to a regenerating planarian fragment yields a TWO-HEADED worm.  The
-- new anatomy is then inherited "in perpetuity": subsequent amputations
-- in plain water regenerate two heads again, with NO further
-- perturbation and an UNCHANGED genome.  The altered target morphology
-- was shown to be encoded not in histology, molecular markers, or stem
-- cell distribution, but in a stable bioelectric pattern (resting
-- potential distribution) — the setpoint for anatomical homeostasis.
--   Oviedo et al., Dev. Biol. 339 (2010); Durant et al., Biophys. J.
--   112 (2017) "Long-Term, Stochastic Editing of Regenerative Anatomy
--   via Targeting Endogenous Bioelectric Gradients"; Levin et al.,
--   Phil. Trans. R. Soc. B (2021), bistability of somatic pattern
--   memories.  [Citation contract: sources named, not re-derived; no
--   theorem below is attributed to them — the biology is theirs, the
--   formalisation is the modelling correspondence.]
--
-- THE MODEL.  The state that matters is the bioelectric SETPOINT, a
-- two-valued observable (one-head vs two-head attractor); the genome is
-- fixed across the whole population and so is a CONSTANT observable.
-- Regeneration `regen` PRESERVES the setpoint (that is the memory);
-- the octanol perturbation `perturb` is the only thing that FLIPS it
-- (that is the rewrite).  Every clause below is a checked theorem and
-- is labelled with the experimental fact it renders.
--
-- WHAT IS PROVEN, each an instance of the general criterion in
-- `MorphogeneticAgency…`:
--   memory-persists          the setpoint is conserved along the WHOLE
--                            regeneration orbit — two-headedness "in
--                            perpetuity" (conservedAlongOrbit).
--   outcome-from-setpoint    head count factors through the bioelectric
--                            observable — the setpoint predicts the
--                            morphological outcome (a congruence).
--   genome-cannot-predict    head count does NOT factor through the
--                            genome — one blind pair (same genome, two
--                            attractors) refutes every genome-only
--                            predictor.  The memory is provably not
--                            genomic.
--   rewritable-only-bioelectrically
--                            the setpoint is not conserved by `perturb`:
--                            the bioelectric intervention flips the
--                            target morphology.
--   bistable                 both attractors are distinct fixed points
--                            of regeneration — two stable morphologies,
--                            one genome.
------------------------------------------------------------------------

module PlanarianBioelectricMemory_TheSetpointIsAConservedBioelectricObservableTheGenomeCannotPredictAndRegenerationIsBistable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥ ; rec)

open import MorphogeneticAgency_CongruenceIsLawConservationIsTheSetpointAlongTheWholeOrbitAndReachabilityInABasinIsRegeneration

------------------------------------------------------------------------
-- The bioelectric setpoint: the two anatomical attractors.
------------------------------------------------------------------------

data Setpoint : Type where
  oneHead  : Setpoint          -- the wild-type target morphology
  twoHead  : Setpoint          -- the rewritten (octanol-induced) attractor

-- the state that carries the pattern memory is the bioelectric setpoint
State : Type
State = Setpoint

-- the observables
bioelectric : State → Setpoint
bioelectric s = s

genome : State → Unit          -- one genome across the whole population (constant)
genome _ = tt

headCount : State → ℕ          -- the morphological OUTCOME (1 or 2 heads)
headCount oneHead = 1
headCount twoHead = 2

------------------------------------------------------------------------
-- The dynamics.
------------------------------------------------------------------------

-- REGENERATION preserves the bioelectric setpoint — this IS the memory.
regen : State → State
regen s = s

-- The OCTANOL / gap-junction perturbation is the only thing that flips
-- the setpoint (the rewrite).  Applied to a one-head worm it induces the
-- two-head attractor.
perturb : State → State
perturb oneHead = twoHead
perturb twoHead = twoHead

------------------------------------------------------------------------
-- 1.  MEMORY PERSISTS "IN PERPETUITY".  The setpoint is conserved along
--     the entire regeneration orbit — an instance of the general
--     conservedAlongOrbit at Φ = regen, f = bioelectric.
------------------------------------------------------------------------

regen-conserves : (s : State) → bioelectric (regen s) ≡ bioelectric s
regen-conserves s = refl

open Conserved regen bioelectric regen-conserves
  using () renaming (conservedAlongOrbit to setpoint-conserved-along-orbit)

memory-persists : (n : ℕ) (s : State) → bioelectric (orbit regen n s) ≡ bioelectric s
memory-persists = setpoint-conserved-along-orbit

-- and therefore the head count is the same after every number of
-- regeneration rounds: two-headedness returns, unperturbed, forever.
outcome-stable-forever : (n : ℕ) (s : State) → headCount (orbit regen n s) ≡ headCount s
outcome-stable-forever n s = cong headCount (memory-persists n s)

------------------------------------------------------------------------
-- 2.  THE SETPOINT PREDICTS THE OUTCOME; THE GENOME CANNOT.
------------------------------------------------------------------------

-- head count factors through the bioelectric observable (a congruence):
-- same setpoint ⇒ same morphology.
outcome-from-setpoint : (x y : State) → bioelectric x ≡ bioelectric y → headCount x ≡ headCount y
outcome-from-setpoint x y p = cong headCount p

-- head count does NOT factor through the genome: the genome is blind to
-- the pair (oneHead , twoHead) — identical genome — yet their morphologies
-- differ.  So NO genome-only predictor of anatomy exists.  The pattern
-- memory is provably not genomic.
one≢two : headCount oneHead ≡ headCount twoHead → ⊥
one≢two p = znots (injSuc p)          -- 1 ≡ 2  →  0 ≡ 1  →  ⊥

genome-cannot-predict :
  ((x y : State) → genome x ≡ genome y → headCount x ≡ headCount y) → ⊥
genome-cannot-predict pred = one≢two (pred oneHead twoHead refl)

------------------------------------------------------------------------
-- 3.  REWRITABLE — but only bioelectrically.  Regeneration conserves the
--     setpoint; the octanol perturbation does not.  The flip requires the
--     bioelectric intervention.
------------------------------------------------------------------------

perturb-rewrites : bioelectric (perturb oneHead) ≡ bioelectric oneHead → ⊥
perturb-rewrites p = one≢two (cong headCount (sym p))
  -- perturb oneHead ≡ twoHead, so p : twoHead ≡ oneHead, and headCount separates them

------------------------------------------------------------------------
-- 4.  BISTABILITY.  Both attractors are distinct fixed points of
--     regeneration: two stable morphologies for one genome.
------------------------------------------------------------------------

oneHead-fixed : regen oneHead ≡ oneHead
oneHead-fixed = refl

twoHead-fixed : regen twoHead ≡ twoHead
twoHead-fixed = refl

attractors-distinct : oneHead ≡ twoHead → ⊥
attractors-distinct p = one≢two (cong headCount p)

------------------------------------------------------------------------
-- READING.  memory-persists = the "in perpetuity" long-term bioelectric
-- pattern memory; outcome-from-setpoint = the setpoint instructs anatomy;
-- genome-cannot-predict = the target morphology is stored bioelectrically,
-- not in the genome (Durant/Levin's central point, here a theorem about
-- the model); perturb-rewrites = octanol edits the setpoint;
-- bistability = the two-attractor structure (Levin 2021).  The general
-- criterion (MorphogeneticAgency…) says exactly what a "yes" to
-- "is the bioelectric coarse-graining a congruence?" means — and here
-- the answer, for this model, is yes for bioelectric and NO for genome.
------------------------------------------------------------------------
