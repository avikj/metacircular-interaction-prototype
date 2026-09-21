{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ScaleFluxContinuity — the finite, checked shadow of the Navier–Stokes
-- "final shot": energy is NOT dynamically closed, its completion is the
-- signed scale-flux, and a singularity is flux through the K=∞ boundary.
--
-- THE ARGUMENT THIS MAKES A TERM (zero poetry).  The L² energy identity
-- gives every smooth NS trajectory a FINITE dissipation budget, and that
-- budget is noncoercive: the ultraviolet boundary K=∞ is Zeno-accessible
-- under the energy metric (∑ 2⁻ⁿ < ∞ at the self-similar scaling).  So
-- energy is the wrong observable.  The right object is its dynamical
-- completion: energy-below-a-cut together with the NONLINEAR FLUX through
-- that cut,
--        E_{<K}  ⟼  (E_{<K}, Π_K),
-- and the scale-space continuity law ∂ₜE_{<K} = −Π_K (−sink).  This is the
-- corpus's own completion rule "observable + its Lie derivative"
-- (Dhruva / the (Q,R)→(Q̇,Ṙ) branching fibre), and the conservation of
-- the nonlinear term is Dhruva's "the transfer lives in a conserved
-- fibre": internal transfers telescope, so only the boundary flux and the
-- dissipative sink can change the total.
--
-- MODEL (finite, ℤ-valued — the decategorified shadow, per the discipline
-- of ObstructionCalculus).  Shells k = 0,1,2,…; `c k` is the signed flux
-- crossing the cut BELOW shell k (between shell k−1 and k), with the
-- boundary condition c 0 = 0 (no flux enters from below the bottom).  The
-- net internal energy rate in shell k is (c k − c(k+1)); Π_K := c K is the
-- flux through cut K.  Everything below is a checked term.
--
--   §1  CONTINUITY (telescoping):  ∑_{k<K}(c k − c(k+1)) ≡ −Π_K.
--       Internal transfer cancels; only the boundary flux survives.
--   §2  CONSERVATION (Dhruva):  no flux out the top (c N = 0) ⇒ the total
--       internal energy change is exactly 0.  Pure redistribution.
--   §3  SINGULARITY = BOUNDARY FLUX:  the total change equals −(flux out
--       the top).  Finite-time singularity is a nonzero flux reaching the
--       K=∞ boundary; it is invisible to the total-energy reading, which
--       §2 shows is 0 for every internal redistribution.
--   §4  ENERGY IS NOT DYNAMICALLY SUFFICIENT (VitaranaYugma):  two flux
--       fields with the SAME total-energy evolution but DIFFERENT Π_K at
--       an interior cut.  The scalar energy marginal identifies states the
--       flux separates — the reduced observable does not close.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 for this finite signed-flux model.
-- NOT claimed: the continuum NS flux, its cubic (third-order-increment)
-- structure, or any bound on it — that bound IS the Clay problem, and it
-- is exactly the one thing this shadow does not touch.  What IS claimed is
-- the STRUCTURE the problem must be phrased in: energy is a noncoercive
-- marginal, its completion is the signed flux, the flux conserves the
-- total from within, and singularity is the boundary term.  The viscous
-- sink is an additive −D ≤ 0 that only strengthens §2–§3; it is not
-- carried in the telescoping core (it needs a sum-splitting lemma and adds
-- nothing to the structure).
------------------------------------------------------------------------

module ScaleFluxContinuity_EnergyIsNotDynamicallyClosedTheCompletionIsTheSignedFluxAndSingularityIsFluxThroughTheBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; -_ ; +Assoc ; pos0+ ; -Cancel ; -Cancel' ; injPos)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- ० · signed difference and the finite sum below a cut.
------------------------------------------------------------------------

_⊝_ : ℤ → ℤ → ℤ
a ⊝ b = a + (- b)

sumBelow : (ℕ → ℤ) → ℕ → ℤ
sumBelow f zero    = pos 0
sumBelow f (suc k) = sumBelow f k + f k

-- the internal energy rate in shell k: inflow at cut k, outflow at cut k+1.
flowBelow : (ℕ → ℤ) → ℕ → ℤ
flowBelow c = sumBelow (λ k → c k ⊝ c (suc k))

-- the flux through cut K.
Π : (ℕ → ℤ) → ℕ → ℤ
Π c K = c K

------------------------------------------------------------------------
-- The one algebraic move: adjacent differences telescope, no
-- commutativity used beyond ℤ's group laws.
------------------------------------------------------------------------

rearr : (a b c : ℤ) → (a ⊝ b) + (b ⊝ c) ≡ a ⊝ c
rearr a b c =
    sym (+Assoc a (- b) (b + (- c)))
  ∙ cong (a +_) (+Assoc (- b) b (- c))
  ∙ cong (a +_) (cong (_+ (- c)) (-Cancel' b))
  ∙ cong (a +_) (sym (pos0+ (- c)))

------------------------------------------------------------------------
-- १ · CONTINUITY.  The internal rate below cut K telescopes to the
--      boundary difference; with no flux from below, to −Π_K.
------------------------------------------------------------------------

teleSum : (f : ℕ → ℤ) (K : ℕ) → flowBelow f K ≡ (f 0 ⊝ f K)
teleSum f zero    = sym (-Cancel (f 0))
teleSum f (suc K) =
    cong (_+ (f K ⊝ f (suc K))) (teleSum f K)
  ∙ rearr (f 0) (f K) (f (suc K))

continuity : (c : ℕ → ℤ) (K : ℕ) → c 0 ≡ pos 0 → flowBelow c K ≡ - (c K)
continuity c K c0 =
    teleSum c K
  ∙ cong (λ z → z ⊝ c K) c0
  ∙ sym (pos0+ (- (c K)))

------------------------------------------------------------------------
-- २ · CONSERVATION (Dhruva).  No flux out the top ⇒ total change is 0.
------------------------------------------------------------------------

conservation : (c : ℕ → ℤ) (N : ℕ) → c 0 ≡ pos 0 → c N ≡ pos 0
             → flowBelow c N ≡ pos 0
conservation c N c0 cN = continuity c N c0 ∙ cong -_ cN

------------------------------------------------------------------------
-- ३ · SINGULARITY = BOUNDARY FLUX.  Total change = −(flux out the top);
--      a singularity is a nonzero flux reaching the K=∞ boundary.
------------------------------------------------------------------------

singularityIsBoundaryFlux : (c : ℕ → ℤ) (N : ℕ) → c 0 ≡ pos 0
                          → flowBelow c N ≡ - (Π c N)
singularityIsBoundaryFlux = continuity

------------------------------------------------------------------------
-- ४ · ENERGY IS NOT DYNAMICALLY SUFFICIENT (VitaranaYugma).  Two flux
--      fields, identical total-energy evolution, different interior flux.
------------------------------------------------------------------------

still : ℕ → ℤ                       -- no transfer anywhere
still _ = pos 0

oneEddy : ℕ → ℤ                     -- one unit of flux through cut 1, none out the top
oneEddy (suc zero) = pos 1
oneEddy _          = pos 0

-- both conserve the total (§2): pure internal redistribution.
totalsAgree : flowBelow still 2 ≡ flowBelow oneEddy 2
totalsAgree =
    conservation still   2 refl refl
  ∙ sym (conservation oneEddy 2 refl refl)

-- yet the interior flux separates them: Π₁ is 0 for one, 1 for the other.
fluxSeparates : ¬ (Π still 1 ≡ Π oneEddy 1)
fluxSeparates p = znots (injPos p)

energyNotSufficient :
  (flowBelow still 2 ≡ flowBelow oneEddy 2) × (¬ (Π still 1 ≡ Π oneEddy 1))
energyNotSufficient = totalsAgree , fluxSeparates
