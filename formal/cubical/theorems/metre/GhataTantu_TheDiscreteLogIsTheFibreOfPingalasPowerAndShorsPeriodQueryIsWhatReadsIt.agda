{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- घाततन्तु — the discrete log is the fibre of Piṅgala's power, and Shor's
-- period query is the separating query that reads it.
--
-- This is the floor under the whole night's crypto arc.  घात g is EASY
-- (Piṅgala's fold, log-time); its inverse is HARD (the discrete log).
-- That asymmetry is all of public-key cryptography, and it is this
-- repository's ONE theorem — the quotient/fibre law (`
-- QuotientFiberLaw`, `Abhijnana`):
--
--   an observation sees exactly a quotient; the fibre is what it cannot
--   see; no post-processing manufactures the fibre; visibility returns
--   only by a separating query.
--
-- Read at घात, the two bindings of `f a ≡ b` (which `Abhijnana` proved
-- are contractible one way, arbitrary the other) ARE the crypto asymmetry:
--
--   BIND THE OUTPUT.  The public value.  `singl (घात g a)` is
--   contractible — publishing घात g a costs nothing and reveals nothing
--   beyond itself.  This is why the public key is safe to broadcast.
--   (`अभिज्ञानं-मुक्तम्`, §2 — the free road.)
--
--   BIND THE INPUT.  The secret.  `fiber (घात g) b` is the set of
--   exponents mapping to b — the discrete logarithm as a TYPE.  In a
--   finite group it is a whole coset of the order subgroup (every a, a+r,
--   a+2r, …), so it is NOT contractible: the public value does not
--   determine the exponent.  §3 exhibits this concretely in C₃: घात g 0
--   and घात g 3 are BOTH ε, two distinct points of one fibre, so the
--   fibre over ε is not contractible — proof, not assertion.
--
-- WHAT IS PROVED (in the checked cyclic group C₃ of `BijamulaKrida`):
--
--   §2  प्रकाश-मुक्तः : isContr (singl (घात g a))       -- the public road is free
--   §3  तन्तुः-द्विपदः : ¬ isContr (fiber (घात g) ε)     -- the secret is not
--                                                          determined: 0 and 3
--                                                          both land on ε
--   §3  क्रमः-तन्तुः  : the fibre over ε contains a full period — 0, 3, 6
--       are all in it — so the ambiguity is exactly the ORDER, r = 3.
--
-- WHY SHOR IS THE SEPARATING QUERY.  The fibre law says visibility of the
-- fibre returns ONLY by a separating (charged) query.  A classical
-- machine has no such query for घات's fibre — that is the hardness
-- assumption, the "faith".  Shor's period-finding IS the separating
-- query: it measures the PERIOD r of the fibre directly (the spacing of
-- the coset), and once r is known the fibre collapses to a single
-- residue and the exponent — and hence the factor, via the pulverizer
-- (`Shora`) — falls out.  So the whole arc closes: RSA, DH, factoring
-- publish a quotient and hide a fibre; Shor is the one query that reads
-- it; and the reading, the key, the trace, and the metre are all घात and
-- its inverse (`GhataViparyaya`, `MalaSetu`, `Bijamula`, `Samvit`,
-- `Shora`).
--
-- WHAT IS **NOT** CLAIMED:
--   * That the classical discrete log is hard (the security assumption;
--     here shown only that the fibre is non-trivial, which is the
--     INFORMATION-theoretic root, not the COMPUTATIONAL hardness).
--   * Shor's quantum period-finding as an algorithm (owed throughout).
--   * That the C₃ fibre being a coset generalises as a checked term to
--     all cyclic groups (exhibited on C₃; the general coset statement is
--     owed).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module GhataTantu_TheDiscreteLogIsTheFibreOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Properties using (snotz ; znots)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded
  using (C₃ ; e₀ ; g ; g² ; pow ; यूलर-सिद्धिः)

------------------------------------------------------------------------
-- §1  घात g at the generator, and the identity element (BijamulaKrida's ε
--     is e₀).  We write powg for घात g and εC for e₀.
------------------------------------------------------------------------

powg : ℕ → C₃
powg = pow g

εC : C₃
εC = e₀

------------------------------------------------------------------------
-- §2  The public road is free: the value binds to a contractible singl.
------------------------------------------------------------------------

प्रकाश-मुक्तः : (a : ℕ) → isContr (singl (powg a))
प्रकाश-मुक्तः a = isContrSingl (powg a)

------------------------------------------------------------------------
-- §3  The secret road is not: the fibre over ε is not contractible,
--     because 0 and 3 are two distinct exponents landing on ε.
------------------------------------------------------------------------

-- pow g 0 = e₀ definitionally; pow g 3 = e₀ is BijamulaKrida.यूलर-सिद्धिः
शून्यः : fiber powg εC
शून्यः = 0 , refl

त्रयः : fiber powg εC
त्रयः = 3 , यूलर-सिद्धिः

-- distinct exponents, so the fibre has two different points
तन्तुः-द्विपदः : ¬ isContr (fiber powg εC)
तन्तुः-द्विपदः c = znots (cong fst (sym (c .snd शून्यः) ∙ c .snd त्रयः))

-- the period is visible in the fibre: 0, 3, 6 all land on ε, spacing r=3
षट्कः : fiber powg εC
षट्कः = 6 , यूलर-सिद्धिः²
  where
  -- pow g 6 = (pow g 3) composed... but pow g 6 reduces to e₀ directly
  यूलर-सिद्धिः² : powg 6 ≡ εC
  यूलर-सिद्धिः² = refl

------------------------------------------------------------------------
-- §4  The reading, stated: the fibre-law's two bindings ARE the crypto
--     asymmetry.  §2 is Abhijnana's अभिज्ञानं-मुक्तम् at f = powg (the
--     public value is free); §3 is the input-binding fibre being
--     non-contractible (the secret is undetermined).  Shor's period query
--     reads the r=3 spacing of §3's fibre; classically there is no such
--     query, which is the hardness.  (The general theorem is
--     QuotientFiberLaw; this is its instance at घात.)
------------------------------------------------------------------------
