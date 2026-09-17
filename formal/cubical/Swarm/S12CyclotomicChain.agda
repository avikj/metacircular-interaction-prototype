{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Swarm.S12CyclotomicChain
--
-- The reindexing that turns the unbounded lifting-the-exponent answer
-- into a BOUNDED sequence of local contributions, and the uniqueness of
-- that bounded sequence.
--
-- Setting (see collab/swarm/2026-08-14/swarm-0814-12-cyclotomic-comb.md).
-- Fix an odd prime p and an integer a with p âˆ a; let d = ord_p(a) and
-- e = v_p(a^d âˆ’ 1) â‰ 1.  Lifting-the-exponent says
--
--     v_p(a^n âˆ’ 1) = e + v_p(n)   when d âˆ n,   and 0 otherwise.
--
-- The divisors of n = dÂp^j that carry any p-adic content are exactly
-- dÂp^0, â¦, dÂp^j (a CHAIN, not a general divisor lattice), and the
-- factorisation a^n âˆ’ 1 = âˆ_{m âˆ n} Î¦_m(a) makes v_p additive along it.
-- So the arithmetic reduces, exactly, to a statement about partial sums
-- of one sequence indexed by the chain position k = 0,1,2,â¦.  That
-- sequence is
--
--     cyc e k  =  v_p(Î¦_{dÂp^k}(a))  =  e (k = 0),  1 (k â‰ 1).
--
-- Four theorems, no postulates:
--
--   lteFromCyc   chain (cyc e) j â‰¡ e + j
--                â” the unbounded LTE answer IS the j-th partial sum of
--                  the bounded local sequence.  The indicator [d âˆ n]
--                  has disappeared into the indexing.
--
--   cycUnique    chain g j â‰¡ e + j for all j  âŸ  g â‰¡ cyc e
--                â” the bounded decomposition is not one choice among
--                  many: the LTE law determines each tooth uniquely.
--
--   cycBound     cyc e k â‰ suc e
--                â” every local contribution is bounded by the
--                  observation depth K = e+1 of R0025 Theorem 2.  On the
--                  cyclotomic chart, cost â‰ answer is restored.
--
--   chainGrows   j â‰ chain (cyc e) j
--                â” while the SUM is unbounded.  R0025(3)'s "depth â‰ 
--                  answer" is exactly this gap, and it is an artefact of
--                  reading a^n âˆ’ 1 whole rather than tooth by tooth.
--
-- Nothing here is measured.  `chain` is the p-chain restriction of the
-- divisor sum; the arithmetic input (that the chain is the whole support
-- and that its length is v_p(n)) is proved in the note, not assumed here.
------------------------------------------------------------------------

module Swarm.S12CyclotomicChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-zero ; +-suc
                                   ; +-comm ; inj-m+)
open import Cubical.Data.Nat.Order using (_â‰¤_)
open import Cubical.Data.Sigma using (_,_)

------------------------------------------------------------------------
-- The chain and its teeth
------------------------------------------------------------------------

-- chain g j = g 0 + g 1 + â‹¯ + g j : the divisor sum restricted to the
-- p-chain d, dÂp, â¦, dÂp^j, which is where all the p-adic content sits.
chain : (â„• â†’ â„•) â†’ â„• â†’ â„•
chain g zero    = g zero
chain g (suc j) = chain g j + g (suc j)

-- The cyclotomic tooth sequence: v_p(Î¦_{dÂp^k}(a)).
cyc : â„• â†’ â„• â†’ â„•
cyc e zero    = e
cyc e (suc _) = 1

------------------------------------------------------------------------
-- 1.  The reindexing identity
------------------------------------------------------------------------

lteFromCyc : âˆ€ e j â†’ chain (cyc e) j â‰¡ e + j
lteFromCyc e zero    = sym (+-zero e)
lteFromCyc e (suc j) =
    cong (_+ 1) (lteFromCyc e j)
  âˆ™ +-comm (e + j) 1
  âˆ™ sym (+-suc e j)

------------------------------------------------------------------------
-- 2.  Uniqueness of the bounded decomposition
------------------------------------------------------------------------

cycUnique : âˆ€ (g : â„• â†’ â„•) (e : â„•)
          â†’ (âˆ€ j â†’ chain g j â‰¡ e + j)
          â†’ âˆ€ k â†’ g k â‰¡ cyc e k
cycUnique g e h zero    = h zero âˆ™ +-zero e
cycUnique g e h (suc j) = inj-m+ step
  where
    step : (e + j) + g (suc j) â‰¡ (e + j) + 1
    step =
        cong (_+ g (suc j)) (sym (h j))
      âˆ™ h (suc j)
      âˆ™ +-suc e j
      âˆ™ sym (+-comm (e + j) 1)

------------------------------------------------------------------------
-- 3.  Bounded teeth, unbounded sum
------------------------------------------------------------------------

-- Every tooth is at most the observation depth K = e + 1.
cycBound : âˆ€ e k â†’ cyc e k â‰¤ suc e
cycBound e zero    = 1 , refl
cycBound e (suc _) = e , +-comm e 1

-- The partial sums are cofinal in â•: the whole-object answer is unbounded.
chainGrows : âˆ€ e j â†’ j â‰¤ chain (cyc e) j
chainGrows e j = e , sym (lteFromCyc e j)

------------------------------------------------------------------------
-- 4.  The p = 2 branch: the same comb with a two-term head
------------------------------------------------------------------------
--
-- For a odd, d = ordâ(a) = 1, and the chain is 1, 2, 4, 8, â¦.  Its
-- teeth are vâ(Î¦â(a)) = vâ(aâˆ’1) = eâ‹, vâ(Î¦â(a)) = vâ(a+1) = eâŠ, and
-- vâ(Î¦_{2^k}(a)) = vâ(a^{2^{kâˆ’1}} + 1) = 1 for k â‰ 2 (a^{2^{kâˆ’1}} is an
-- odd square, â‰¡ 1 mod 8, so the successor is â‰¡ 2 mod 4).  Summing the
-- chain up to k = vâ(n) reproduces R0025 Theorem 1's p = 2 clause,
--
--     vâ(a^n âˆ’ 1) = eâ‹ + eâŠ + vâ(n) âˆ’ 1   (n even),
--
-- so the branch that R0025's preservation ledger flags as "genuinely
-- different in shape" is, on the cyclotomic chart, the same shape with
-- one extra head term.  The classification of tooth sequences over all
-- primes is therefore exhaustive: a head of length 1 (p odd) or 2
-- (p = 2), then constantly 1.

cycâ‚‚ : â„• â†’ â„• â†’ â„• â†’ â„•
cycâ‚‚ em ep zero          = em
cycâ‚‚ em ep (suc zero)    = ep
cycâ‚‚ em ep (suc (suc _)) = 1

-- chain (cycâ eâ‹ eâŠ) (suc j) â‰¡ (eâ‹ + eâŠ) + j, i.e. at n with vâ(n) = suc j.
lteFromCycâ‚‚ : âˆ€ em ep j â†’ chain (cycâ‚‚ em ep) (suc j) â‰¡ (em + ep) + j
lteFromCycâ‚‚ em ep zero    = sym (+-zero (em + ep))
lteFromCycâ‚‚ em ep (suc j) =
    cong (_+ 1) (lteFromCycâ‚‚ em ep j)
  âˆ™ +-comm ((em + ep) + j) 1
  âˆ™ sym (+-suc (em + ep) j)

cycâ‚‚Bound : âˆ€ em ep k â†’ cycâ‚‚ em ep k â‰¤ suc (em + ep)
cycâ‚‚Bound em ep zero          = suc ep , cong suc (+-comm ep em)
cycâ‚‚Bound em ep (suc zero)    = suc em , refl
cycâ‚‚Bound em ep (suc (suc _)) = em + ep , +-comm (em + ep) 1
