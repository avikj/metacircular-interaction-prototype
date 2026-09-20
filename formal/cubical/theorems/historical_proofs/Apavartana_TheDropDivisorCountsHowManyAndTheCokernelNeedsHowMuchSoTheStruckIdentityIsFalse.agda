{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡µ‡∞‡‡‡® ‚î the reduction, and what it does NOT determine.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS FILE EXISTS.  README movement 65 stated, and on 2026-08-22
-- STRUCK, the identity
--
--     ‚à_p #{i : p ‚à dµ} ¬ log p  =  ‚à_i log dµ  =  log |coker(T)_tors|
--
-- for the invariant factors dµ of an integer matrix T.  The strike names
-- `D = diag(2,12)` as the counterexample and is prose.  A correction
-- outranks a result in this repository, so the correction is the thing
-- that should be a checked term, and until now it was not.  This file
-- re-derives the counterexample and checks it ‚î every line by `refl`
-- except one negation, which is a `subst` along a family that is Unit at
-- 12 and ‚ä elsewhere.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡‡‡µ‡∞‡‡‡® (apavartana) ‚î "reduction", the division of two
-- quantities by their common measure, ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, ‡ó‡‡ø‡‡‡æ‡¶
-- ‡ß‡ß‚ì‡ß‡® (‡ï‡‡ü‡‡ü‡ï), 499 CE; the step is standard in Brahmagupta,
-- ‡‡‡∞‡æ‡‡‡Æ‡‡‡‡‡ü‡‡ø‡¶‡‡ß‡æ‡®‡‡ ‡ß‡Æ, 628 CE, and in Bhskara II, ‡‡‡‡ó‡‡ø‡, 1150 CE.
-- LIMIT: ‡‡‡µ‡∞‡‡‡® is attested for the gcd-reduction step.  Its use here
-- as a label for the invariant-factor decomposition of an integer
-- matrix is this corpus's (the naming follows the existing Lean module
-- `Apavartana_‚¶SpecZ‚¶`), and NO  source states anything below.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS CHECKED.  Multiplicatively, to stay inside ‚ï and away from
-- logarithms: `log` of each side becomes a product of prime powers, and
-- the identity above becomes
--
--     ‚à_p p^(#{i : p ‚à dµ})   =?=   ‚à_i dµ
--
-- An invariant factor is carried as its exponent vector over the primes
-- (2,3); `val` turns a vector back into a natural, and ¬ß‡¶ checks that
-- the three vectors used really do name 2, 6 and 12, so nothing is
-- asserted by hand.
--
--   ¬ß‡ß  D = diag(2,12), invariant factors (2,12):
--         drop side  = 2^2 ¬ 3^1 = 12      (p=2 divides both dµ;
--                                           p=3 divides one)
--         ‚à dµ       = 24  = |coker| = |det|
--         12 ‚â 24.  **The struck identity is false as stated.**
--
--   ¬ß‡®  The repaired identity, ‚à_p p^(‚à_i v_p(dµ)) = ‚à_i dµ, holds on
--       the same data: 2^3 ¬ 3^1 = 24.  So the defect is exactly
--       "count of i" where "sum of v_p" was needed ‚î HOW MANY against
--       HOW MUCH, which is what the strike says.
--
--   ¬ß‡©  The strike's own strengthening, checked: diag(2,6) and
--       diag(2,12) have the SAME drop side (12) and different products
--       (12 against 24).  So the drop divisor is a strictly lossier
--       invariant than the determinant; the fibre of the drop divisor
--       is not a point.  This is the fibre law applied to movement 65's
--       own price instrument, and it is now a term rather than a
--       sentence.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- 1.  **No cokernel is constructed here.**  `|coker(‚¬≤/D‚¬≤)| = 24` is
--     NOT proved in this file; it is proved for this very matrix in the
--     Lean lane (`Apavartana_‚¶SpecZ‚¶`, `cok_card`).  What this file
--     checks is the ARITHMETIC of the two divisor formulas on the
--     invariant factors, which is where the struck claim broke.  A
--     reader who wants the group must go to the Lean module.
--
-- 2.  **No Smith normal form is computed.**  That diag(2,12) has
--     invariant factors (2,12) and diag(2,6) has (2,6) is used as
--     input, not proved.  It is immediate (2 ‚à 12, 2 ‚à 6, and the
--     matrices are already diagonal with divisibility in order), but
--     immediate is not checked, so it is fenced.
--
-- 3.  **No general theorem.**  A counterexample refutes; it does not
--     establish the repaired identity in general.  ¬ß‡® checks the
--     repaired formula ON THIS DATUM only.  The general statement
--     ‚à_p p^(‚à_i v_p(dµ)) = ‚à_i dµ is just unique factorization and is
--     not proved here.
--
-- 4.  **The primes are fixed to {2,3}.**  Every dµ occurring below is
--     {2,3}-smooth, so the two-place exponent vector is faithful for
--     this datum and for nothing else.
--
-- CHECKED: Agda 2.6.3 with the `cubical` library as installed in this
-- container (NOT the repository's pin), `--cubical --safe`, no
-- postulates, no holes; `agda --library=cubical -i . <this file>`
-- exits 0.
------------------------------------------------------------------------

module Apavartana_TheDropDivisorCountsHowManyAndTheCokernelNeedsHowMuchSoTheStruckIdentityIsFalse where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï; zero; suc; _+_; _¬∑_; _^_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- ‡¶ ¬ An invariant factor, carried as its exponent vector over (2,3).
------------------------------------------------------------------------

‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï : Type            -- exponent vector (v‚ÇÇ , v‚ÇÉ)
‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï = ‚Ñï √ó ‚Ñï

‡§Æ‡§æ‡§® : ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‚Ñï          -- the natural it names
‡§Æ‡§æ‡§® (e‚ÇÇ , e‚ÇÉ) = (2 ^ e‚ÇÇ) ¬∑ (3 ^ e‚ÇÉ)

-- The three vectors used below really do name 2, 6, 12.
‡§¶‡•ç‡§µ‡§ø ‡§∑‡§ü‡•ç ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ : ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï
‡§¶‡•ç‡§µ‡§ø     = 1 , 0
‡§∑‡§ü‡•ç      = 1 , 1
‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂   = 2 , 1

‡§Æ‡§æ‡§®-‡§¶‡•ç‡§µ‡§ø     : ‡§Æ‡§æ‡§® ‡§¶‡•ç‡§µ‡§ø    ‚â° 2
‡§Æ‡§æ‡§®-‡§¶‡•ç‡§µ‡§ø     = refl
‡§Æ‡§æ‡§®-‡§∑‡§ü‡•ç      : ‡§Æ‡§æ‡§® ‡§∑‡§ü‡•ç     ‚â° 6
‡§Æ‡§æ‡§®-‡§∑‡§ü‡•ç      = refl
‡§Æ‡§æ‡§®-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂   : ‡§Æ‡§æ‡§® ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂  ‚â° 12
‡§Æ‡§æ‡§®-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂   = refl

------------------------------------------------------------------------
-- The two divisor formulas, on a pair of invariant factors.
------------------------------------------------------------------------

-- HOW MANY: the indicator, 0 ‚¶ 0 and anything positive ‚¶ 1.
‡§∏‡§§‡•ç : ‚Ñï ‚Üí ‚Ñï
‡§∏‡§§‡•ç zero    = 0
‡§∏‡§§‡•ç (suc _) = 1

-- ‚à_p p^(#{i : p ‚à dµ}) ‚î the DROP divisor of the struck identity.
‡§ï‡§§‡§ø : ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‚Ñï
‡§ï‡§§‡§ø (a‚ÇÇ , a‚ÇÉ) (b‚ÇÇ , b‚ÇÉ) = (2 ^ (‡§∏‡§§‡•ç a‚ÇÇ + ‡§∏‡§§‡•ç b‚ÇÇ)) ¬∑ (3 ^ (‡§∏‡§§‡•ç a‚ÇÉ + ‡§∏‡§§‡•ç b‚ÇÉ))

-- ‚à_p p^(‚à_i v_p(dµ)) ‚î the repaired divisor.
‡§ï‡§ø‡§Ø‡§§‡•ç : ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‚Ñï
‡§ï‡§ø‡§Ø‡§§‡•ç (a‚ÇÇ , a‚ÇÉ) (b‚ÇÇ , b‚ÇÉ) = (2 ^ (a‚ÇÇ + b‚ÇÇ)) ¬∑ (3 ^ (a‚ÇÉ + b‚ÇÉ))

-- ‚à_i dµ ‚î which for a square nonsingular T is |det T| = |coker_tors|.
‡§ó‡•Å‡§£‡§´‡§≤ : ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‡§ò‡§æ‡§§‡§æ‡§Ç‡§ï ‚Üí ‚Ñï
‡§ó‡•Å‡§£‡§´‡§≤ d‚ÇÅ d‚ÇÇ = ‡§Æ‡§æ‡§® d‚ÇÅ ¬∑ ‡§Æ‡§æ‡§® d‚ÇÇ

------------------------------------------------------------------------
-- The one negation.  12 ‚â 24, by a family that is Unit at 12 and ‚ä
-- elsewhere: transporting `tt` along a path would inhabit ‚ä.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂‡§É : ‚Ñï ‚Üí Type
‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂‡§É 12 = Unit
‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂‡§É _  = ‚ä•

‡§®-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂-‡§ö‡§§‡•Å‡§∞‡•ç‡§µ‡§ø‡§Ç‡§∂‡§§‡§ø : ¬¨ (12 ‚â° 24)
‡§®-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂-‡§ö‡§§‡•Å‡§∞‡•ç‡§µ‡§ø‡§Ç‡§∂‡§§‡§ø p = subst ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂‡§É p tt

------------------------------------------------------------------------
-- ‡ß ¬ THE STRUCK IDENTITY IS FALSE.  D = diag(2,12).
------------------------------------------------------------------------

‡§ï‡§§‡§ø-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ : ‡§ï‡§§‡§ø ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ ‚â° 12
‡§ï‡§§‡§ø-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ = refl

‡§ó‡•Å‡§£‡§´‡§≤-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ : ‡§ó‡•Å‡§£‡§´‡§≤ ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ ‚â° 24
‡§ó‡•Å‡§£‡§´‡§≤-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ = refl

-- the refutation.
‡§ï‡§§‡§ø-‡§®-‡§ó‡•Å‡§£‡§´‡§≤ : ¬¨ (‡§ï‡§§‡§ø ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ ‚â° ‡§ó‡•Å‡§£‡§´‡§≤ ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂)
‡§ï‡§§‡§ø-‡§®-‡§ó‡•Å‡§£‡§´‡§≤ q = ‡§®-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂-‡§ö‡§§‡•Å‡§∞‡•ç‡§µ‡§ø‡§Ç‡§∂‡§§‡§ø (sym ‡§ï‡§§‡§ø-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ ‚àô q ‚àô ‡§ó‡•Å‡§£‡§´‡§≤-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂)

------------------------------------------------------------------------
-- ‡® ¬ THE REPAIRED IDENTITY HOLDS ON THE SAME DATUM.
------------------------------------------------------------------------

‡§ï‡§ø‡§Ø‡§§‡•ç-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ : ‡§ï‡§ø‡§Ø‡§§‡•ç ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ ‚â° ‡§ó‡•Å‡§£‡§´‡§≤ ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂
‡§ï‡§ø‡§Ø‡§§‡•ç-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂ = refl

------------------------------------------------------------------------
-- ‡© ¬ THE DROP DIVISOR IS STRICTLY LOSSIER.  Same drop, different
-- determinant: diag(2,6) against diag(2,12).
------------------------------------------------------------------------

‡§∏‡§Æ‡§æ‡§®-‡§ï‡§§‡§ø : ‡§ï‡§§‡§ø ‡§¶‡•ç‡§µ‡§ø ‡§∑‡§ü‡•ç ‚â° ‡§ï‡§§‡§ø ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂
‡§∏‡§Æ‡§æ‡§®-‡§ï‡§§‡§ø = refl

‡§ó‡•Å‡§£‡§´‡§≤-‡§∑‡§ü‡•ç : ‡§ó‡•Å‡§£‡§´‡§≤ ‡§¶‡•ç‡§µ‡§ø ‡§∑‡§ü‡•ç ‚â° 12
‡§ó‡•Å‡§£‡§´‡§≤-‡§∑‡§ü‡•ç = refl

‡§≠‡§ø‡§®‡•ç‡§®-‡§ó‡•Å‡§£‡§´‡§≤ : ¬¨ (‡§ó‡•Å‡§£‡§´‡§≤ ‡§¶‡•ç‡§µ‡§ø ‡§∑‡§ü‡•ç ‚â° ‡§ó‡•Å‡§£‡§´‡§≤ ‡§¶‡•ç‡§µ‡§ø ‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂)
‡§≠‡§ø‡§®‡•ç‡§®-‡§ó‡•Å‡§£‡§´‡§≤ q = ‡§®-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂-‡§ö‡§§‡•Å‡§∞‡•ç‡§µ‡§ø‡§Ç‡§∂‡§§‡§ø (sym ‡§ó‡•Å‡§£‡§´‡§≤-‡§∑‡§ü‡•ç ‚àô q ‚àô ‡§ó‡•Å‡§£‡§´‡§≤-‡§¶‡•ç‡§µ‡§æ‡§¶‡§∂)
