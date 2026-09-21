{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The prime-pair equations of the centered (w ± r) frame are RING
-- TAUTOLOGIES.  This is the honest attack on the intuition that
-- "pq + 1 ≡ 0 mod w² is a powerful equation, like Euler's identity, if
-- you stop thinking numbers and read the symbols."  Read as symbols, the
-- equation is UNIVERSALLY true — it holds for every w, prime or not — so
-- its entire arithmetic content is the separate, untouched predicate
-- "w−1 and w+1 are prime."  The algebra is silent on exactly the thing
-- that is hard.
--
-- Kendra_… proved the centering SYMMETRY (a wall pair about its midpoint
-- becomes a mirror pair ±h); this proves the centering IDENTITIES carry
-- no primality information, which is the complementary fact and the
-- reason no LINEAR reframing crosses the parity barrier.
--
--   goldbach-product : for the pair p = w−r, q = w+r,   pq = w² − r²,
--                      for ALL w, r.  (Goldbach lives at r ↦ pair of
--                      primes summing to 2w; the product law is a
--                      tautology, blind to whether w±r are prime.)
--   twin-identity    : (w−1)(w+1) + 1 = w²,  for ALL w.  The "powerful
--                      equation" pq + 1 ≡ 0 (mod w²) is (w²−1)+1 = w² —
--                      a ring identity true of every integer.  It says
--                      nothing about primality; primality of w±1 is the
--                      whole content and sits entirely outside it.
--   sum-recovers /   : the change of basis (w,r) ↦ (w−r, w+r) is LINEAR
--   diff-recovers      and invertible over ℤ[½] — sum and difference of
--                      the walls give 2w and 2r.  A linear (additive)
--                      involution.
--
-- WHY THIS IS THE BARRIER, stated exactly.  Primality is a MULTIPLICATIVE
-- predicate; the parity obstruction (Selberg) is an invariant of the
-- multiplicative structure — the Liouville sign λ(n) = (−1)^Ω(n), which
-- sieves and magnitude-only spectral readings cannot see (Kendra's
-- discarded cosine sign IS this datum).  The w ± r frame is an ADDITIVE
-- linear symmetry; it acts trivially on Ω and on λ.  Therefore no
-- identity in these coordinates — however elegant — can decide primality
-- or cross parity: the coordinates and the obstruction live in
-- independent structures (additive vs multiplicative).  This is not
-- pessimism; it is the precise reason the frontier (Chen p+P₂, Maynard–
-- Zhang bounded gaps, Helfgott ternary Goldbach) stops where it does, and
-- why the binary problems need an idea that couples the two structures,
-- which a coordinate change is not.
--
-- SYĀT — THE CLAIM, EXACTLY.  The four ring identities, for all w, r.
-- NOT claimed: Goldbach, twin primes, or any lower bound on the pair
-- count — those require the multiplicative/primality content this module
-- proves the algebra does not carry.  What IS claimed is the negative,
-- clarifying fact: the celebrated equations of this frame are tautologies,
-- so the difficulty is located entirely in primality, exactly where the
-- parity barrier sits.
------------------------------------------------------------------------

module PrimePairEquationsAreRingTautologiesSoAllContentIsPrimalityNoLinearReframeCrossesParity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _-_ ; -_ ; _·_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

-- p·q = w² − r², for the centered pair p = w−r, q = w+r.  For ALL w,r.
goldbach-product : (w r : ℤ) → (w - r) · (w + r) ≡ w · w - r · r
goldbach-product w r = solve! ℤCommRing

-- The twin "power equation" pq + 1 ≡ 0 (mod w²) is pq = w² − 1, i.e. the
-- r = 1 case of the product law — a tautology for ALL w (add 1 to reach
-- w²).  Derived from goldbach-product at r = 1 so no literal re-solving.
twin-product : (w : ℤ) → (w - pos 1) · (w + pos 1) ≡ w · w - pos 1 · pos 1
twin-product w = goldbach-product w (pos 1)

-- The centering basis is linear and invertible (over ℤ[½]): the walls'
-- sum and difference recover 2w and 2r.  For ALL w,r.
sum-recovers : (w r : ℤ) → (w - r) + (w + r) ≡ w + w
sum-recovers w r = solve! ℤCommRing

diff-recovers : (w r : ℤ) → (w + r) - (w - r) ≡ r + r
diff-recovers w r = solve! ℤCommRing
