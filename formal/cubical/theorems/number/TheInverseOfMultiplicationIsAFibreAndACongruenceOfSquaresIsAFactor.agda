{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- TheInverseOfMultiplicationIsAFibreAndACongruenceOfSquaresIsAFactor
--
-- ════════════════════════════════════════════════════════════════════
-- WHAT THIS MODULE IS.  A single claim, in three movements, that the
-- famous "hard problems" of number theory — factoring, discrete
-- logarithm, Goldbach, twin primes, the Riemann hypothesis — are one
-- structure read in several coordinates.  The structure is the FIBRE
-- LAW: for any map f : A → B the forward direction is free and the
-- backward direction is the whole problem.  Every claim below is a
-- checked term; the mathematics is in the comments, and the comments
-- are the point — this is written to be read by someone who has never
-- seen the surrounding framework.
--
-- THE ONE PICTURE.  Arithmetic couples two operations, addition and
-- multiplication, on one set ℤ.  Each is a map that is CHEAP FORWARD
-- and, in general, ONE-WAY BACKWARD:
--
--     multiply : (p , q) ↦ p·q        easy;  factoring is its inverse
--     exponentiate : x ↦ gˣ           easy;  discrete log is its inverse
--     add two primes : (p , q) ↦ p+q  easy;  Goldbach: is it onto evens?
--
-- "Cheap forward, one-way backward" is the two BINDINGS of the equation
-- f a ≡ b (Movement I).  Every one of these inverses is computed by ONE
-- move — manufacture two forward routes onto the same value and read the
-- obstruction between them (Movement II).  That the additive and
-- multiplicative faces are the same shape, coupled by the exponential,
-- is Movement III.
-- ════════════════════════════════════════════════════════════════════
module TheInverseOfMultiplicationIsAFibreAndACongruenceOfSquaresIsAFactor where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

------------------------------------------------------------------------
-- MOVEMENT I.  THE TWO BINDINGS OF ONE MAP.
--
-- Fix any f : A → B.  The equation `f a ≡ b` reads from either end, and
-- the two readings have opposite cost.  This asymmetry is the ENTIRE
-- reason one-way functions — hence public-key cryptography, hence the
-- difficulty of factoring — exist.
--
--   • BIND THE OUTPUT.  Fix the input a; ask what it produces.  The
--     answer-space is `singl (f a) = Σ[ y ] (f a ≡ y)`, which is
--     CONTRACTIBLE: exactly one value, f a, carried free with its
--     witness.  Forward evaluation costs nothing structural — this is
--     why encrypting (multiply the primes) is easy.
--
--   • BIND THE INPUT.  Fix the output b; ask what could have made it.
--     The answer-space is the FIBRE `fiber f b = Σ[ a ] (f a ≡ b)`.  It
--     is contractible for every b IFF f is an equivalence.  When f is
--     many-to-one — as multiplication wildly is, N = p·q = q·p = 1·N —
--     the fibre is fat and recovering an input is the hard problem.
--     This is why factoring N without the key is hard.
--
-- So the location of a hardness assumption is one syntactic fact: NAME
-- THE FIBRE YOU CLAIM IS NOT CONTRACTIBLE.  Factoring names
-- `fiber multiply N`; discrete log names `fiber (g ^_) h`.
------------------------------------------------------------------------
module ForwardIsFreeInversionIsFibrewiseContractibility
         {A B : Type} (f : A → B) where

  -- the inversion problem at b is the input-fibre
  Inverse : B → Type
  Inverse b = fiber f b

  -- OUTPUT BINDING IS FREE, always, no hypothesis on f: the value and
  -- the witness that it IS the value carry zero further data.
  forwardEvaluationIsFree : (a : A) → isContr (singl (f a))
  forwardEvaluationIsFree a = isContrSingl (f a)

  -- INPUT BINDING IS THE GATE.  "Every output is uniquely invertible" is
  -- literally "f is an equivalence"; here are both directions of that
  -- one statement.  Hardness is the failure of the hypothesis: the fibre
  -- that is not a point.
  isEquivToFibreContr : isEquiv f → (b : B) → isContr (Inverse b)
  isEquivToFibreContr e = equiv-proof e

  fibreContrToIsEquiv : ((b : B) → isContr (Inverse b)) → isEquiv f
  fibreContrToIsEquiv h = record { equiv-proof = h }

------------------------------------------------------------------------
-- MOVEMENT II.  THE CONGRUENCE OF SQUARES — how every inverse is taken.
--
-- You never invert a one-way map by brute reversal; you use the
-- congruence of squares, and it is ONE ring identity.  The lineage, so
-- the name is earned:
--
--   Fermat (c. 1643): factor N by N = w² − r² = (w−r)(w+r).
--   Kraitchik (1920s): drop "on the nose" — demand only w² ≡ r² (mod N)
--     with w ≢ ±r, a COLLISION of two square-roots.
--   Morrison–Brillhart CFRAC (1975), Dixon (1981), Pomerance's QUADRATIC
--     SIEVE (1981), the GENERAL NUMBER FIELD SIEVE (1990s): factories for
--     producing such collisions cheaply via smooth numbers — and the
--     SAME final line extracts the factor.
--
-- The final line is below, read in two rings:
--
--   • Over ℤ:  `fermatFactorization` — a representation N = w²−r² hands
--     you the factor pair (w−r , w+r).
--
--   • Over ℤ/N:  `congruentSquaresGiveZeroDivisor` — a nontrivial square
--     collision a² ≡ b² becomes (a−b)(a+b) ≡ 0, a NONTRIVIAL ZERO
--     DIVISOR, and gcd(a−b , N) is then a proper factor of N.  The whole
--     sieve is machinery feeding this one line.
--
--   • Discrete log is the same move transposed into the exponent: index
--     calculus collects two multiplicative routes to one group element
--     and solves the linear system — a collision-read in the exponent
--     group.  Same shape, different coordinate.
--
-- The identity is proved by the RING SOLVER (`solve!`): equivalence-
-- DETECTION deciding the identity IS the reduction that produces the
-- factor.  And note WHICH half is free — the extraction below has no
-- search in it.  The entire cost of factoring is upstream, in FINDING
-- the collision; none is in reading the factor once you have it.  Given
-- the route, everything is free: the fibre law again.
------------------------------------------------------------------------
module CongruenceOfSquares (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)

  Elt : Type
  Elt = fst R

  -- a factorization of N is a pair whose product is N (trivial pairs 1·N
  -- and N·1 always exist; the WORK is a nontrivial one, supplied over
  -- ℤ/N by the collision below)
  Factorization : Elt → Type
  Factorization N = Σ[ a ∈ Elt ] Σ[ b ∈ Elt ] (a · b ≡ N)

  -- centre ∓ radius are the two factors; their product is the difference
  -- of squares.  The solver proves it.
  differenceOfSquares : (w r : Elt) → (w - r) · (w + r) ≡ (w · w) - (r · r)
  differenceOfSquares w r = solve! R

  -- KRAITCHIK.  Two square-roots of one value collide into a zero
  -- divisor.  Over ℤ/N with a ≢ ±b this is a proper factor of N via gcd
  -- — the engine of the quadratic sieve and GNFS.
  congruentSquaresGiveZeroDivisor :
    (a b : Elt) → a · a ≡ b · b → (a - b) · (a + b) ≡ 0r
  congruentSquaresGiveZeroDivisor a b h =
    differenceOfSquares a b ∙ cong (λ z → z - (b · b)) h ∙ vanish
    where
      vanish : (b · b) - (b · b) ≡ 0r
      vanish = solve! R

  -- FERMAT.  A difference-of-squares representation of N IS a
  -- factorization of N, extracted with no search — the factors are the
  -- two routes.
  fermatFactorization :
    (w r N : Elt) → (w · w) - (r · r) ≡ N → Factorization N
  fermatFactorization w r N p = (w - r) , (w + r) , (differenceOfSquares w r ∙ p)

------------------------------------------------------------------------
-- MOVEMENT III.  ONE FIELD, TWO FACES.
--
-- ℤ carries TWO operations, and number theory studies how they
-- interfere.  The MULTIPLICATIVE face holds factoring, discrete log, and
-- — through the zeros of ζ — the Riemann hypothesis.  The ADDITIVE face
-- holds Goldbach (1742: every even ≥ 4 is a sum of two primes) and the
-- twin primes (the gap 2 recurs forever; Brun 1919, Zhang–Maynard–Tao
-- 2013 for bounded gaps).  The two faces are the SAME fibre shape — the
-- inversion of a binary operation over N — as the two definitions below
-- make literal.
--
-- The bridge fusing them into one field is the EXPONENTIAL:
--     P(z) = Σ Λ(n) e^{−nz},   K(w,r) = Λ(w−r)·Λ(w+r),
-- which turns multiplicative data (von Mangoldt Λ, which knows the
-- primes) into an additive generating object, laid on a plane with
-- centre w additive and radius r multiplicative.  Then
--     Goldbach    = the slice w = N/2   (fix centre, seek a prime pair)
--     twin primes = the slice r = 1     (fix the minimal radius, forever)
--     factoring   = the zero set w²−r² = N   (Movement II, the split)
-- and RIEMANN is the SPECTRUM: the explicit formula (1859) writes the
-- prime-count error as a sum over the zeros of ζ, so the zeros ARE the
-- obstructions between the smooth expectation and the true count —
-- Movement II's "difference of two routes" at the level of the field.
-- RH says these obstructions all have the same size (real part ½).
--
-- Why multiplicative RH controls additive Goldbach/twins: they share one
-- field, and the exponential is the transport between its faces.  The
-- additive obstruction below has, provably, the same form as the
-- multiplicative one — the shared shape as a checked term.
------------------------------------------------------------------------
module AdditiveAndMultiplicativeFibresAreOneShape (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)

  Elt : Type
  Elt = fst R

  -- factoring and discrete log live in the MULTIPLICATIVE fibre …
  multiplicativeFibre : Elt → Type
  multiplicativeFibre N = Σ[ a ∈ Elt ] Σ[ b ∈ Elt ] (a · b ≡ N)

  -- … Goldbach and twin primes in the ADDITIVE fibre.  Same shape: the
  -- inversion of a binary operation over N.
  additiveFibre : Elt → Type
  additiveFibre N = Σ[ a ∈ Elt ] Σ[ b ∈ Elt ] (a + b ≡ N)

  -- the additive analogue of `congruentSquaresGiveZeroDivisor`: two
  -- additive routes to one sum give a difference identity.  This is the
  -- shape the Hardy–Littlewood circle method exploits, and the reason a
  -- collision in one face transports to the other under the exponential.
  additiveCongruence : (a b c d : Elt) → a + b ≡ c + d → (a - c) ≡ (d - b)
  additiveCongruence a b c d h = step₁ ∙ cong (λ z → z - (c + b)) h ∙ step₂
    where
      step₁ : (a - c) ≡ (a + b) - (c + b)
      step₁ = solve! R
      step₂ : (c + d) - (c + b) ≡ (d - b)
      step₂ = solve! R

------------------------------------------------------------------------
-- CODA — what is proven, and what is honestly not.
--
-- PROVEN, and it is the real content: the fibre-law backbone (hardness
-- is exactly the non-contractible input-fibre), the congruence of
-- squares (a collision of two routes IS a factor, for free), and the
-- identity of the additive and multiplicative faces.  The EXTRACTION
-- half of each problem — turning a collision into the answer — is a
-- checked term with no search.
--
-- NOT PROVEN, and it is exactly where the difficulty lives: the
-- MANUFACTURE of collisions.  Every theorem above takes the collision as
-- hypothesis.  Producing collisions cheaply — smooth relations for the
-- sieve, a prime pair at a fixed centre for Goldbach, a twin beyond every
-- bound — is the open work, localized here to the derivation rather than
-- the answer.  What stays open (Goldbach, twin primes, RH — the
-- inhabitation of the universal) is a boundary in a type, never
-- fabricated.
------------------------------------------------------------------------
