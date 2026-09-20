{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà™àà˜àŸààŸ-à•à¾à°àà¯ â” the collision at work.
--
-- SanghattaBija made collision semantics abstract: a collision is an
-- off-diagonal kernel-pair point.  This module runs the document's
-- Â§12â“13 extraction chain CONCRETELY, on N = 15, and every step is a
-- checked term the analyzer can compute and read back:
--
--     square collision â’ zero divisor â’ idempotent projector â’ factor.
--
-- The collision (a = 4, b = 1, with 4Â² â‰¡ 1Â² mod 15) is GIVEN â” its
-- manufacture is the frontier the collision-semantics document is
-- explicit about and this module does not pretend to abolish.  What is
-- executed here is the EXTRACTOR, and the point is that the kernel does
-- not merely accept it â” it COMPUTES the factors:
--
--   Â§1  THE COLLISION.  4Â4 mod 15 â‰¡ 1Â1 mod 15, both 1, by refl.
--   Â§2  THE ZERO DIVISOR.  (4 âˆ 1)Â(4 + 1) = 3Â5 = 15 â‰¡ 0 mod 15.
--   Â§3  THE FACTORS.  gcd (4 âˆ 1) 15 = 3 and gcd (4 + 1) 15 = 5, each
--       a proper divisor 1 < d < 15 â” the congruence-of-squares
--       extractor, run.
--   Â§4  THE IDEMPOTENT PROJECTOR.  u = 4 is a nontrivial square root of
--       unity (4Â² â‰¡ 1, u â‰ Â1); e = 2â»Â(1+u) = 10 mod 15 is idempotent
--       (10Â² â‰¡ 10 mod 15), and its gcds with 15 recover the SAME two
--       factors â” the projector is the CRT decomposition made a number.
--
-- The whole chain is one worked point of Spec(â/15) split into its two
-- clopen components.  Read it with sadhana.vislesana: the factors 3 and
-- 5 come back as computed normal forms, not as inputs â” the analyzer
-- factoring 15 by reading its own arithmetic.
--
------------------------------------------------------------------------

module SanghattaKarya_ASquareCollisionExtractsAFactorAndAnIdempotentProjectorSplitsTheRingWorkedAndComputed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; _+_ ; _Â·_ ; _âˆ¸_)
open import Cubical.Data.Nat.Mod using (_mod_)
open import Cubical.Data.Nat.GCD using (gcd)

------------------------------------------------------------------------
-- The modulus and the given collision.
------------------------------------------------------------------------

N a b : â„•
N = 15
a = 4          -- one square root of 1 mod 15
b = 1          -- the trivial one

------------------------------------------------------------------------
-- à§ Â The collision: aÂ² and bÂ² agree mod N.
------------------------------------------------------------------------

collision : (a Â· a) mod N â‰¡ (b Â· b) mod N
collision = refl        -- 16 mod 15 = 1 = 1 mod 15

------------------------------------------------------------------------
-- à¨ Â The zero divisor: (a âˆ b)(a + b) â‰¡ 0 mod N.
------------------------------------------------------------------------

zeroDivisor : ((a âˆ¸ b) Â· (a + b)) mod N â‰¡ 0
zeroDivisor = refl      -- 3 Â· 5 = 15 â‰¡ 0

------------------------------------------------------------------------
-- à© Â The factors, extracted by gcd â” computed, not supplied.
------------------------------------------------------------------------

factorLo factorHi : â„•
factorLo = gcd (a âˆ¸ b) N     -- gcd 3 15
factorHi = gcd (a + b) N     -- gcd 5 15

factorLoâ‰¡3 : factorLo â‰¡ 3
factorLoâ‰¡3 = refl

factorHiâ‰¡5 : factorHi â‰¡ 5
factorHiâ‰¡5 = refl

-- and they multiply back to N: a genuine factorization, checked.
recompose : factorLo Â· factorHi â‰¡ N
recompose = refl        -- 3 Â· 5 = 15

------------------------------------------------------------------------
-- à Â The idempotent projector: e = 2â»Â(1+u) with u = 4, over â/15.
--     2â»Â = 8 (since 8Â2 = 16 â‰¡ 1), so e = 8Â5 = 40 â‰¡ 10.
------------------------------------------------------------------------

u e : â„•
u = 4                        -- uÂ² = 16 â‰¡ 1 mod 15, and u â‰¢ 1, u â‰¢ 14
e = (8 Â· (1 + u)) mod N      -- 2â»Â¹(1+u) = 10

idempotent : (e Â· e) mod N â‰¡ e
idempotent = refl            -- 10Â·10 = 100 â‰¡ 10 mod 15

-- the projector's gcds recover the same decomposition.
projFactorLo projFactorHi : â„•
projFactorLo = gcd e N          -- gcd 10 15 = 5
projFactorHi = gcd (e âˆ¸ 1) N    -- gcd 9 15 = 3

projFactorLoâ‰¡5 : projFactorLo â‰¡ 5
projFactorLoâ‰¡5 = refl

projFactorHiâ‰¡3 : projFactorHi â‰¡ 3
projFactorHiâ‰¡3 = refl
