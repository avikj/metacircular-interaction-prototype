{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RootWeightIndex
--
-- Delta 17 T17.24, corrected, and the correction turns out to be the
-- corpus's parity obstruction.
--
-- WHAT T17.24 SAYS: "For the diagonal torus action on (G_m)^k, character
-- lattice modulo diagonal character is the A_{kâˆ’1} root lattice."
--
-- WHAT IS TRUE: â^k / âÂ(1,â¦,1) is the A_{kâˆ’1} **weight** lattice P.
-- The **root** lattice Q is the sublattice {x : Îxµ = 0} âŠ â^k, which is
-- a different object: Q injects into P (they meet âÎ´ only at 0) with
--
--     P / Q  â‰  â/k.
--
-- Proof, for the record and because it is three lines: the coordinate sum
-- Ï : â^k â’ â is surjective with kernel exactly Q, and Ï(Î´) = k, so
-- â^k/(Q + âÎ´) â‰ â/kâ.  Root and weight lattice differ by exactly the
-- centre of SL_k, which is standard; T17.24 states the quotient and names
-- the sublattice.
--
-- WHY THIS IS NOT PEDANTRY.  T17.24 is load-bearing: it is cited by
-- `SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md`, whose
-- 108,596-instance exact verification of Î½_p(H) = k âˆ’ rank Î¦_p(H) is a
-- statement about the ROOT system.  A note resting on a lattice named
-- wrongly is a note whose ranks might be off by the index.  (They are
-- not â” rank is insensitive to the P/Q distinction â” but that is a fact
-- to check, not to assume, and it is checked by the fact that the
-- singular-series note uses rank alone.)
--
-- AND THE PAYOFF.  At k = 2 the index is â/2, and that â/2 is not a new
-- object: it is `PairCoordinates.sumIsDouble`, the parity constraint on
-- Delta 17's cone, which `ConeImage.cone-image` proved is exactly the
-- image condition of the pair map.  So the cone's parity constraint IS
-- the root-versus-weight index of A_1.  Three items in the Delta ledger
-- â” T17.13's congruence, T17.24's lattice, and T22.5's discriminant â”
-- are one index computation.
--
-- Contents (all by the commutative-ring solver, no holes, no postulates):
--
--   diff                       the weight-lattice coordinate: RÂ²/RÎ´ â‰ R
--                              via (x,y) â¦ y âˆ’ x
--   diff-kills-diagonal        Î´ spans the kernel â¦
--   diagonal-spans-kernel      â¦ and nothing else does
--   root                       the root sublattice of A_1: (x, âˆ’x)
--   rootâ’double                image of Q in P lands in 2P â¦
--   doubleâ’root                â¦ and fills it
--   index-is-two               the two together: image of Q = 2P exactly
--
-- Everything is over an ARBITRARY commutative ring, so "the index is 2"
-- is stated in the form that survives base change: the image of the root
-- lattice is the doubles.  Over â the doubles have index 2 and that final
-- step is the â-specific parity fact, already checked elsewhere in this
-- development rather than re-derived here.
--
------------------------------------------------------------------------

module RootWeightIndex where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

private
  variable
    â„“ : Level

module A1 (R : CommRing â„“) where
  open CommRingStr (snd R)

  ----------------------------------------------------------------------
  -- Â§1  The weight lattice: RÂ² modulo the diagonal.
  --
  -- Rather than form the quotient, use the difference map, which is a
  -- surjection RÂ² â’ R whose kernel is exactly the diagonal.  That is the
  -- quotient, presented by a coordinate, and it makes every statement
  -- below a ring identity instead of a quotient argument.
  ----------------------------------------------------------------------

  diff : fst R â†’ fst R â†’ fst R
  diff x y = y - x

  -- Î´ = (n,n) is in the kernel â¦
  diff-kills-diagonal : (n : fst R) â†’ diff n n â‰¡ 0r
  diff-kills-diagonal n = solve! R

  -- â¦ and the kernel is no bigger: two points with the same difference
  -- differ by a diagonal vector, exhibited.
  diagonal-spans-kernel : (x y x' y' : fst R) â†’ diff x y â‰¡ diff x' y'
                        â†’ Î£[ n âˆˆ fst R ] ((x - x' â‰¡ n) Ã— (y - y' â‰¡ n))
  diagonal-spans-kernel x y x' y' p = (x - x') , refl , lemma
    where
      -- y âˆ’ yâ² = (y âˆ’ x) âˆ’ (yâ² âˆ’ xâ²) + (x âˆ’ xâ²), and the bracket is 0.
      step : (x y x' y' : fst R)
           â†’ y - y' â‰¡ ((y - x) - (y' - x')) + (x - x')
      step x y x' y' = solve! R

      zeroed : (x y x' y' : fst R) â†’ (0r + (x - x')) â‰¡ x - x'
      zeroed x y x' y' = solve! R

      lemma : y - y' â‰¡ x - x'
      lemma = step x y x' y'
            âˆ™ cong (Î» z â†’ z + (x - x')) (cong (Î» z â†’ z - diff x' y') p)
            âˆ™ cong (Î» z â†’ z + (x - x')) (rearrange (diff x' y'))
            âˆ™ zeroed x y x' y'
        where
          rearrange : (z : fst R) â†’ z - z â‰¡ 0r
          rearrange z = solve! R

  -- Surjectivity of the difference coordinate: every weight is hit.
  diff-surjective : (m : fst R) â†’ Î£[ p âˆˆ fst R Ã— fst R ]
                                    (diff (fst p) (snd p) â‰¡ m)
  diff-surjective m = (0r , m) , surj m
    where
      surj : (m : fst R) â†’ diff 0r m â‰¡ m
      surj m = solve! R

  ----------------------------------------------------------------------
  -- Â§2  The root lattice, and its image in the weight lattice.
  --
  -- Q = {(x,y) : x + y = 0} = {(x, âˆ’x)}, the A_1 root lattice.  Its image
  -- under the difference coordinate is exactly the set of doubles â” index
  -- two, in the form that does not need â.
  ----------------------------------------------------------------------

  root : fst R â†’ fst R Ã— fst R
  root x = x , - x

  root-sums-to-zero : (x : fst R) â†’ fst (root x) + snd (root x) â‰¡ 0r
  root-sums-to-zero x = solve! R

  -- The image lands in the doubles: diff(x, âˆ’x) = âˆ’x âˆ’ x = 2Â(âˆ’x).
  rootâ†’double : (x : fst R)
              â†’ Î£[ m âˆˆ fst R ] (diff (fst (root x)) (snd (root x)) â‰¡ m + m)
  rootâ†’double x = (- x) , img x
    where
      img : (x : fst R) â†’ diff x (- x) â‰¡ (- x) + (- x)
      img x = solve! R

  -- And it fills them: every double is the image of a root vector.
  doubleâ†’root : (m : fst R)
              â†’ Î£[ x âˆˆ fst R ] (diff (fst (root x)) (snd (root x)) â‰¡ m + m)
  doubleâ†’root m = (- m) , fillD m
    where
      fillD : (m : fst R) â†’ diff (- m) (- (- m)) â‰¡ m + m
      fillD m = solve! R

  ----------------------------------------------------------------------
  -- Â§3  The index, both inclusions at once.
  --
  -- image(Q â’ P) = 2P.  Over â this is the statement that the A_1 root
  -- lattice sits inside the weight lattice with index two, i.e. P/Q â‰
  -- â/2 â” and that â/2 is the parity constraint on Delta 17's cone,
  -- already checked as `PairCoordinates.sumIsDouble` and characterised as
  -- the image condition by `ConeImage.cone-image`.
  ----------------------------------------------------------------------

  index-is-two : ((x : fst R) â†’ Î£[ m âˆˆ fst R ]
                    (diff (fst (root x)) (snd (root x)) â‰¡ m + m))
               Ã— ((m : fst R) â†’ Î£[ x âˆˆ fst R ]
                    (diff (fst (root x)) (snd (root x)) â‰¡ m + m))
  index-is-two = rootâ†’double , doubleâ†’root
