-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकमूल — the roots of one.  The two-wall crystal's facets ARE the
-- square roots of 1 mod d, each built from an ordered coprime
-- factorization d = uv by the reciprocal
--
--     x  =  1 − 2·u·ū       (ū = u⁻¹ mod v),
--
-- for which x ≡ 1 (mod u) and x ≡ −1 (mod v) — the orientation of every
-- prime facet.  The reciprocal ū/v inside x IS the Kloosterman fraction
-- e(−2ak·ū/v): the phase at the analytic boundary is the Fourier image
-- of choosing which forbidden wall each prime reflects from.  (Owner's
-- Kloosterman-skeleton message; the exact modular core.)
--
-- WHY THIS IS THE MISSING COORDINATE.  Parity records only the PRODUCT
-- of facet orientations (μ(d)=∏±1).  The involution x records ALL of
-- them: x ≡ 1 on the u-primes (reflect from +a), x ≡ −1 on the v-primes
-- (reflect from −a).  The state is (u,v), not d — different
-- factorizations give different roots, hence different phases ū/v: a
-- real Kloosterman geometry.  Averaging over UNLABELLED factorizations
-- is empty; over WALL-LABELLED ones it moves.  This module makes the
-- label — the root from (u,v,ū) — a term.
--
-- CHECKED (over ℤ, m ∣ n := Σ k, n = k·m):
--   §1 root-mod-u : always u ∣ (x + (−1))            [x ≡ 1 (mod u)]
--   §2 root-mod-v : v ∣ (u·ū + (−1)) → v ∣ (x + 1)    [x ≡ −1 (mod v)]
--   §3 involution : u ∣ (x² + (−1)) and v ∣ (x² + (−1))
--
-- FENCE.  x² ≡ 1 (mod uv) from §3 needs (u,v) coprime — declared,
-- standard, not reproved.  The bijection {roots}↔{coprime factorizations}
-- and the Ramanujan/Kloosterman sum identities need the CRT count and ℝ;
-- the construction map factorization ⟶ root is what is a term.
--
-- Note on method: ring identities are proved with the CONSTANTS 1,2 kept
-- as variables (genU/genV/sqFactor) and instantiated, because a literal
-- `+ (- pos 1)` reduces to predℤ and the ring solver cannot parse it.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module Ekamula_TheWallOrientationsAreSquareRootsOfOneBuiltFromFactorizationsByTheKloostermanReciprocal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; pos; _+_; -_; _·_)
open import Cubical.Data.Sigma using (Σ; Σ-syntax; _,_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

_∣_ : ℤ → ℤ → Type
m ∣ n = Σ[ k ∈ ℤ ] (n ≡ k · m)

root : ℤ → ℤ → ℤ
root u ū = pos 1 + (- (pos 2 · (u · ū)))

private
  -- ring identities with 1,2 as variables (so the solver never meets predℤ).
  genU : (one two u ū : ℤ)
       → ((one + (- (two · (u · ū)))) + (- one)) ≡ (- (two · ū)) · u
  genU one two u ū = solve! ℤCommRing

  genV : (one u ū : ℤ)
       → ((one + (- (pos 2 · (u · ū)))) + one) ≡ (- pos 2) · (u · ū + (- one))
  genV one u ū = solve! ℤCommRing

  reassoc : (two k v : ℤ) → (- two) · (k · v) ≡ (- (two · k)) · v
  reassoc two k v = solve! ℤCommRing

  sqFactor : (one x : ℤ) → one · one ≡ one
           → (x + (- one)) · (x + one) ≡ (x · x) + (- one)
  sqFactor one x hyp = solve! ℤCommRing ∙ cong (λ w → (x · x) + (- w)) hyp

------------------------------------------------------------------------
-- §1 · x ≡ 1 (mod u), ALWAYS.
root-mod-u : (u ū : ℤ) → u ∣ (root u ū + (- pos 1))
root-mod-u u ū = (- (pos 2 · ū)) , genU (pos 1) (pos 2) u ū

------------------------------------------------------------------------
-- §2 · x ≡ −1 (mod v), GIVEN u·ū ≡ 1 (mod v).
root-mod-v : (u ū v : ℤ) → v ∣ (u · ū + (- pos 1)) → v ∣ (root u ū + pos 1)
root-mod-v u ū v (k , e) = (- (pos 2 · k)) , goal
  where
  goal : root u ū + pos 1 ≡ (- (pos 2 · k)) · v
  goal = genV (pos 1) u ū
       ∙ cong ((- pos 2) ·_) e
       ∙ reassoc (pos 2) k v

------------------------------------------------------------------------
-- §3 · x² ≡ 1 at each leg.
sq : ℤ → ℤ
sq x = x · x

∣-·ʳ : (m a b : ℤ) → m ∣ a → m ∣ (a · b)
∣-·ʳ m a b (k , e) = (k · b) , (cong (_· b) e ∙ solve! ℤCommRing)

∣-·ˡ : (m a b : ℤ) → m ∣ b → m ∣ (a · b)
∣-·ˡ m a b (k , e) = (a · k) , (cong (a ·_) e ∙ solve! ℤCommRing)

sq-1-factors : (x : ℤ) → sq x + (- pos 1) ≡ (x + (- pos 1)) · (x + pos 1)
sq-1-factors x = sym (sqFactor (pos 1) x refl)

involution-mod-u : (u ū : ℤ) → u ∣ (sq (root u ū) + (- pos 1))
involution-mod-u u ū =
  subst (u ∣_) (sym (sq-1-factors (root u ū)))
    (∣-·ʳ u (root u ū + (- pos 1)) (root u ū + pos 1) (root-mod-u u ū))

involution-mod-v : (u ū v : ℤ) → v ∣ (u · ū + (- pos 1))
  → v ∣ (sq (root u ū) + (- pos 1))
involution-mod-v u ū v h =
  subst (v ∣_) (sym (sq-1-factors (root u ū)))
    (∣-·ˡ v (root u ū + (- pos 1)) (root u ū + pos 1) (root-mod-v u ū v h))
