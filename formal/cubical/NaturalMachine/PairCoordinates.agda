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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PairCoordinates
--
-- Delta 17 T17.1/C17.2, C17.12/C17.14; Delta 18 T18.3; Delta 22 T22.5.
-- Checked over an ARBITRARY commutative ring, which is the whole point.
--
-- Delta 17 observes that the centre-relative decomposition "reappears" at
-- three levels — values, local valuations, Mellin exponents — and calls
-- this "striking".  Delta 22 T22.5 observes that centre, product and gap
-- are coefficient/discriminant coordinates of the quadratic with the pair
-- as roots, and calls it "a major compression of the atlas".
--
-- Both observations are the same algebra, and once it is proved over an
-- arbitrary commutative ring the repetition stops being striking and
-- becomes a triviality — which is the correct outcome.  The self-
-- similarity of Delta 17 C17.12/C17.14 is then not an observed
-- coincidence across levels; it is ONE theorem instantiated twice, and
-- §3 does exactly that.
--
-- Contents (all proved by the commutative-ring solver, no holes, no
-- postulates, --safe):
--
--   e1≡2w, e2≡w²−r², disc≡4r²   T22.5: centre, product, gap ARE the
--                                coefficient/discriminant coordinates
--   splitNorm                    T17.1/C17.2: the multiplicative product
--                                is the split quadratic norm of the
--                                additive centre-relative vector
--   wedge, wedge≡det             T18.3: the gap h is the exterior product
--                                (B,t) ∧ (A,s)
--   sumIsDouble                  the parity obstruction, stated where it
--                                belongs: the map is NOT invertible, and
--                                Delta 17 T17.13's congruence s ≡ d mod 2
--                                is exactly this
--   ValueLevel, ValuationLevel   §3: the same theorem, twice
--
-- NOT claimed: novelty.  Every identity here is one line of ring algebra;
-- Delta 22 says so itself.  What is contributed is that they are checked
-- at the generality that makes Delta 17's cross-level repetition a
-- consequence rather than an observation.
------------------------------------------------------------------------

module NaturalMachine.PairCoordinates where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The centre-relative change of coordinates, over any commutative ring
------------------------------------------------------------------------

module Pair (R : CommRing ℓ) where
  open CommRingStr (snd R)

  -- The two legs, from centre w and half-gap r.  (Delta 18's x₁, x₂;
  -- Delta 22's L₁, L₂; Delta 17's p, q.)
  leg₁ leg₂ : fst R → fst R → fst R
  leg₁ w r = w - r
  leg₂ w r = w + r

  -- T22.5, first coefficient: the sum of the roots is twice the centre.
  e₁≡2w : (w r : fst R) → leg₁ w r + leg₂ w r ≡ (1r + 1r) · w
  e₁≡2w w r = solve! R

  -- T22.5, second coefficient: the PRODUCT of the roots is the split
  -- quadratic norm w² − r².  This is Delta 17 C17.2 and Delta 22's
  -- "w²−r²=pq is the second elementary symmetric polynomial", in one
  -- statement.
  e₂≡splitNorm : (w r : fst R) → leg₁ w r · leg₂ w r ≡ w · w - r · r
  e₂≡splitNorm w r = solve! R

  -- T22.5, discriminant: e₁² − 4e₂ = 4r².  The gap is the discriminant
  -- coordinate, up to the square.
  disc≡4r² : (w r : fst R)
           → (leg₁ w r + leg₂ w r) · (leg₁ w r + leg₂ w r)
             - ((1r + 1r) · (1r + 1r)) · (leg₁ w r · leg₂ w r)
           ≡ ((1r + 1r) · (1r + 1r)) · (r · r)
  disc≡4r² w r = solve! R

  -- T17.1 in its own words: with W the sum and R the difference, the
  -- light-cone factors u∓ = W ∓ R multiply to the split norm.  This is
  -- the same identity read in the other direction, and it is worth
  -- stating separately because Delta 17 treats the two as different
  -- observations.
  splitNorm : (W Rr : fst R) → (W - Rr) · (W + Rr) ≡ W · W - Rr · Rr
  splitNorm W Rr = solve! R

  ----------------------------------------------------------------------
  -- The parity obstruction, stated where it belongs.
  --
  -- The map (w,r) ↦ (w−r, w+r) is NOT invertible over a general ring:
  -- recovering w needs a halving.  The obstruction is exactly that the
  -- sum of the legs is always a double, which is Delta 17 T17.13's
  -- congruence s ≡ d (mod 2) — the cone condition is not decoration, it
  -- is the image of this map.
  ----------------------------------------------------------------------

  sumIsDouble : (w r : fst R)
              → Σ[ k ∈ fst R ] (leg₁ w r + leg₂ w r ≡ (1r + 1r) · k)
  sumIsDouble w r = w , e₁≡2w w r

  diff≡2r : (w r : fst R) → leg₂ w r - leg₁ w r ≡ (1r + 1r) · r
  diff≡2r w r = solve! R

  diffIsDouble : (w r : fst R)
               → Σ[ k ∈ fst R ] (leg₂ w r - leg₁ w r ≡ (1r + 1r) · k)
  diffIsDouble w r = r , diff≡2r w r

------------------------------------------------------------------------
-- §2  Delta 18 T18.3: the gap is an exterior product
--
-- After divisors A | n and B | n+h, the residual forms Bm+t and Am+s
-- satisfy Bs − At = h, and the matrix [[B,t],[A,s]] has determinant h.
-- So the additive gap, the determinant invariant, and (at good primes)
-- the p-adic collision depth are carried by one element.
------------------------------------------------------------------------

module Wedge (R : CommRing ℓ) where
  open CommRingStr (snd R)

  -- The exterior product of two planar vectors.
  wedge : fst R → fst R → fst R → fst R → fst R
  wedge B t A s = B · s - A · t

  -- The 2×2 determinant, written independently.
  det2 : fst R → fst R → fst R → fst R → fst R
  det2 a b c d = a · d - b · c

  -- T18.3: they are the same element.  (Trivial, and stated because
  -- Delta 18 makes the identification carry weight: "the SAME h is
  -- additive gap; determinant/wedge invariant; p-adic collision-depth
  -- carrier".)
  wedge≡det : (B t A s : fst R) → wedge B t A s ≡ det2 B t A s
  wedge≡det B t A s = solve! R

  -- Antisymmetry, which is what makes it an exterior product rather than
  -- a bilinear form with a sign convention.
  wedge-antisym : (B t A s : fst R) → wedge B t A s ≡ - wedge A s B t
  wedge-antisym B t A s = solve! R

  -- Peeling preserves the invariant: this is Delta 18's det M' = det M,
  -- in the form that does not need the matrix product spelled out —
  -- scaling one row and shearing does not move the wedge.
  wedge-shear : (B t A s c : fst R)
              → wedge B (t + c · B) A (s + c · A) ≡ wedge B t A s
  wedge-shear B t A s c = solve! R

------------------------------------------------------------------------
-- §3  The self-similarity of Delta 17 C17.12/C17.14, as a consequence
--
-- Delta 17 notes that the centre-relative split appears at the level of
-- VALUES (W = p+q, R = q−p) and again at the level of LOCAL VALUATIONS
-- (s_ℓ = v_ℓ(p)+v_ℓ(q), d_ℓ = v_ℓ(q)−v_ℓ(p)), and calls the repetition
-- striking.
--
-- Because §1 is proved over an arbitrary commutative ring, the two are
-- the same theorem at the same instance ℤ, applied to different data.
-- Instantiating twice is the whole proof, and the "striking" repetition
-- is thereby explained away rather than admired — which is the outcome
-- the corpus's own standard asks for.
------------------------------------------------------------------------

module ValueLevel where
  open Pair ℤCommRing public
  -- legs are the two primes p, q; centre is w = (p+q)/2, half-gap r.

module ValuationLevel where
  open Pair ℤCommRing public
  -- legs are v_ℓ(p), v_ℓ(q); the centre-relative pair is (s_ℓ, d_ℓ).

-- The two modules are definitionally the same theorem.  Stating the
-- shared instance explicitly, so that nobody re-proves it a third time
-- when the Mellin-exponent level (Delta 18's (ρ,ρ′) ↔ (s,ν)) is reached.
same-theorem : (w r : fst ℤCommRing)
             → ValueLevel.leg₁ w r ≡ ValuationLevel.leg₁ w r
same-theorem w r = refl
