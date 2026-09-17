{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ò‡æ‡‡‡®‡‡‡ ‚î the discrete log is the fiber of Pigala's power, and Shor's
-- period query is the separating query that reads it.
--
-- This is the floor under the whole night's crypto arc.  ‡ò‡æ‡ g is EASY
-- (Pigala's fold, log-time); its inverse is HARD (the discrete log).
-- That asymmetry is all of public-key cryptography, and it is this
-- repository's ONE theorem ‚î the quotient/fiber law (`
-- QuotientFiberLaw`, `Abhijnana`):
--
--   an observation sees exactly a quotient; the fiber is what it cannot
--   see; no post-processing manufactures the fiber; visibility returns
--   only by a separating query.
--
-- Read at ‡ò‡æ‡, the two bindings of `f a ‚â° b` (which `Abhijnana` proved
-- are contractible one way, arbitrary the other) ARE the crypto asymmetry:
--
--   BIND THE OUTPUT.  The public value.  `singl (‡ò‡æ‡ g a)` is
--   contractible ‚î publishing ‡ò‡æ‡ g a costs nothing and reveals nothing
--   beyond itself.  This is why the public key is safe to broadcast.
--   (`‡‡‡ø‡‡‡û‡æ‡®‡-‡Æ‡‡ï‡‡‡Æ‡`, ¬ß2 ‚î the free road.)
--
--   BIND THE INPUT.  The secret.  `fiber (‡ò‡æ‡ g) b` is the set of
--   exponents mapping to b ‚î the discrete logarithm as a TYPE.  In a
--   finite group it is a whole coset of the order subgroup (every a, a+r,
--   a+2r, ‚¶), so it is NOT contractible: the public value does not
--   determine the exponent.  ¬ß3 exhibits this concretely in C‚: ‡ò‡æ‡ g 0
--   and ‡ò‡æ‡ g 3 are BOTH Œµ, two distinct points of one fiber, so the
--   fiber over Œµ is not contractible ‚î proof, not assertion.
--
-- WHAT IS PROVED (in the checked cyclic group C‚ of `BijamulaKrida`):
--
--   ¬ß2  ‡‡‡∞‡ï‡æ‡-‡Æ‡‡ï‡‡‡ : isContr (singl (‡ò‡æ‡ g a))       -- the public road is free
--   ¬ß3  ‡‡®‡‡‡‡-‡¶‡‡µ‡ø‡‡¶‡ : ¬ isContr (fiber (‡ò‡æ‡ g) Œµ)     -- the secret is not
--                                                          determined: 0 and 3
--                                                          both land on Œµ
--   ¬ß3  ‡ï‡‡∞‡Æ‡-‡‡®‡‡‡‡  : the fiber over Œµ contains a full period ‚î 0, 3, 6
--       are all in it ‚î so the ambiguity is exactly the ORDER, r = 3.
--
-- WHY SHOR IS THE SEPARATING QUERY.  The fiber law says visibility of the
-- fiber returns ONLY by a separating (charged) query.  A classical
-- machine has no such query for ‡òÿßÿ's fiber ‚î that is the hardness
-- assumption, the "faith".  Shor's period-finding IS the separating
-- query: it measures the PERIOD r of the fiber directly (the spacing of
-- the coset), and once r is known the fiber collapses to a single
-- residue and the exponent ‚î and hence the factor, via the pulverizer
-- (`Shora`) ‚î falls out.  So the whole arc closes: RSA, DH, factoring
-- publish a quotient and hide a fiber; Shor is the one query that reads
-- it; and the reading, the key, the trace, and the metre are all ‡ò‡æ‡ and
-- its inverse (`GhataViparyaya`, `MalaSetu`, `Bijamula`, `Samvit`,
-- `Shora`).
--
-- WHAT IS **NOT** CLAIMED:
--   * That the classical discrete log is hard (the security assumption;
--     here shown only that the fiber is non-trivial, which is the
--     INFORMATION-theoretic root, not the COMPUTATIONAL hardness).
--   * Shor's quantum period-finding as an algorithm (owed throughout).
--   * That the C‚ fiber being a coset generalises as a checked term to
--     all cyclic groups (exhibited on C‚; the general coset statement is
--     owed).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module GhataTantu_TheDiscreteLogIsTheFiberOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Properties using (snotz ; znots)
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded
  using (C‚ÇÉ ; e‚ÇÄ ; g ; g¬≤ ; pow ; ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É)

------------------------------------------------------------------------
-- ¬ß1  ‡ò‡æ‡ g at the generator, and the identity element (BijamulaKrida's Œµ
--     is e‚).  We write powg for ‡ò‡æ‡ g and ŒµC for e‚.
------------------------------------------------------------------------

powg : ‚Ñï ‚Üí C‚ÇÉ
powg = pow g

ŒµC : C‚ÇÉ
ŒµC = e‚ÇÄ

------------------------------------------------------------------------
-- ¬ß2  The public road is free: the value binds to a contractible singl.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§ï‡§æ‡§∂-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É : (a : ‚Ñï) ‚Üí isContr (singl (powg a))
‡§™‡•ç‡§∞‡§ï‡§æ‡§∂-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É a = isContrSingl (powg a)

------------------------------------------------------------------------
-- ¬ß3  The secret road is not: the fiber over Œµ is not contractible,
--     because 0 and 3 are two distinct exponents landing on Œµ.
------------------------------------------------------------------------

-- pow g 0 = e‚ definitionally; pow g 3 = e‚ is BijamulaKrida.‡Ø‡‡≤‡∞-‡‡ø‡¶‡‡ß‡ø‡
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É : fiber powg ŒµC
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É = 0 , refl

‡§§‡•ç‡§∞‡§Ø‡§É : fiber powg ŒµC
‡§§‡•ç‡§∞‡§Ø‡§É = 3 , ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É

-- distinct exponents, so the fiber has two different points
‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É : ¬¨ isContr (fiber powg ŒµC)
‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É c = znots (cong fst (sym (c .snd ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É) ‚àô c .snd ‡§§‡•ç‡§∞‡§Ø‡§É))

-- the period is visible in the fiber: 0, 3, 6 all land on Œµ, spacing r=3
‡§∑‡§ü‡•ç‡§ï‡§É : fiber powg ŒµC
‡§∑‡§ü‡•ç‡§ï‡§É = 6 , ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É¬≤
  where
  -- pow g 6 = (pow g 3) composed... but pow g 6 reduces to e‚ directly
  ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É¬≤ : powg 6 ‚â° ŒµC
  ‡§Ø‡•Ç‡§≤‡§∞-‡§∏‡§ø‡§¶‡•ç‡§ß‡§ø‡§É¬≤ = refl

------------------------------------------------------------------------
-- ¬ß4  The reading, stated: the fiber-law's two bindings ARE the crypto
--     asymmetry.  ¬ß2 is Abhijnana's ‡‡‡ø‡‡‡û‡æ‡®‡-‡Æ‡‡ï‡‡‡Æ‡ at f = powg (the
--     public value is free); ¬ß3 is the input-binding fiber being
--     non-contractible (the secret is undetermined).  Shor's period query
--     reads the r=3 spacing of ¬ß3's fiber; classically there is no such
--     query, which is the hardness.  (The general theorem is
--     QuotientFiberLaw; this is its instance at ‡ò‡æ‡.)
------------------------------------------------------------------------
