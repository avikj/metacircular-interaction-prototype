{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सङ्घट्ट-कार्य — the collision at work.
--
-- SanghattaBija made collision semantics abstract: a collision is an
-- off-diagonal kernel-pair point.  This module runs the document's
-- §12–13 extraction chain CONCRETELY, on N = 15, and every step is a
-- checked term the analyzer can compute and read back:
--
--     square collision → zero divisor → idempotent projector → factor.
--
-- The collision (a = 4, b = 1, with 4² ≡ 1² mod 15) is GIVEN — its
-- manufacture is the frontier the collision-semantics document is
-- explicit about and this module does not pretend to abolish.  What is
-- executed here is the EXTRACTOR, and the point is that the kernel does
-- not merely accept it — it COMPUTES the factors:
--
--   §1  THE COLLISION.  4·4 mod 15 ≡ 1·1 mod 15, both 1, by refl.
--   §2  THE ZERO DIVISOR.  (4 ∸ 1)·(4 + 1) = 3·5 = 15 ≡ 0 mod 15.
--   §3  THE FACTORS.  gcd (4 ∸ 1) 15 = 3 and gcd (4 + 1) 15 = 5, each
--       a proper divisor 1 < d < 15 — the congruence-of-squares
--       extractor, run.
--   §4  THE IDEMPOTENT PROJECTOR.  u = 4 is a nontrivial square root of
--       unity (4² ≡ 1, u ≢ ±1); e = 2⁻¹(1+u) = 10 mod 15 is idempotent
--       (10² ≡ 10 mod 15), and its gcds with 15 recover the SAME two
--       factors — the projector is the CRT decomposition made a number.
--
-- The whole chain is one worked point of Spec(ℤ/15) split into its two
-- clopen components.  Read it with sadhana.vislesana: the factors 3 and
-- 5 come back as computed normal forms, not as inputs — the analyzer
-- factoring 15 by reading its own arithmetic.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 for N = 15 with the given
-- collision, every value computed.  NOT claimed: that the collision was
-- found rather than supplied, nor any statement about N in general —
-- this is the extractor executed on one worked instance, which is what
-- makes the factors READABLE rather than merely provable.
------------------------------------------------------------------------

module SanghattaKarya_ASquareCollisionExtractsAFactorAndAnIdempotentProjectorSplitsTheRingWorkedAndComputed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Nat.Mod using (_mod_)
open import Cubical.Data.Nat.GCD using (gcd)

------------------------------------------------------------------------
-- The modulus and the given collision.
------------------------------------------------------------------------

N a b : ℕ
N = 15
a = 4          -- one square root of 1 mod 15
b = 1          -- the trivial one

------------------------------------------------------------------------
-- १ · The collision: a² and b² agree mod N.
------------------------------------------------------------------------

collision : (a · a) mod N ≡ (b · b) mod N
collision = refl        -- 16 mod 15 = 1 = 1 mod 15

------------------------------------------------------------------------
-- २ · The zero divisor: (a ∸ b)(a + b) ≡ 0 mod N.
------------------------------------------------------------------------

zeroDivisor : ((a ∸ b) · (a + b)) mod N ≡ 0
zeroDivisor = refl      -- 3 · 5 = 15 ≡ 0

------------------------------------------------------------------------
-- ३ · The factors, extracted by gcd — computed, not supplied.
------------------------------------------------------------------------

factorLo factorHi : ℕ
factorLo = gcd (a ∸ b) N     -- gcd 3 15
factorHi = gcd (a + b) N     -- gcd 5 15

factorLo≡3 : factorLo ≡ 3
factorLo≡3 = refl

factorHi≡5 : factorHi ≡ 5
factorHi≡5 = refl

-- and they multiply back to N: a genuine factorization, checked.
recompose : factorLo · factorHi ≡ N
recompose = refl        -- 3 · 5 = 15

------------------------------------------------------------------------
-- ४ · The idempotent projector: e = 2⁻¹(1+u) with u = 4, over ℤ/15.
--     2⁻¹ = 8 (since 8·2 = 16 ≡ 1), so e = 8·5 = 40 ≡ 10.
------------------------------------------------------------------------

u e : ℕ
u = 4                        -- u² = 16 ≡ 1 mod 15, and u ≢ 1, u ≢ 14
e = (8 · (1 + u)) mod N      -- 2⁻¹(1+u) = 10

idempotent : (e · e) mod N ≡ e
idempotent = refl            -- 10·10 = 100 ≡ 10 mod 15

-- the projector's gcds recover the same decomposition.
projFactorLo projFactorHi : ℕ
projFactorLo = gcd e N          -- gcd 10 15 = 5
projFactorHi = gcd (e ∸ 1) N    -- gcd 9 15 = 3

projFactorLo≡5 : projFactorLo ≡ 5
projFactorLo≡5 = refl

projFactorHi≡3 : projFactorHi ≡ 3
projFactorHi≡3 = refl
