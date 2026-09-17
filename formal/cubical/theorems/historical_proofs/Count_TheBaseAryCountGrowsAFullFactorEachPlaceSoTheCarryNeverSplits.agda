{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ô‡‡ñ‡‡Ø‡æ ‚î sakhy, the COUNT of the prastra.  Pigala's sixth
-- pratyaya: the number of distinct n-place patterns, 2^n at base two,
-- stated together with the process that computes it by repeated
-- squaring-and-doubling on the binary expansion of n.  Pigala,
-- *Chandastra* 8.23-35 (~300 BCE); the process worked out in
-- Halyudha, *Mtasajvan* (10th c.).
--
-- ‡‡ô‡‡ñ‡‡Ø‡æ names the OBJECT b ^ n ‚î the count of n-place base-b words.
-- The base-b generalisation (Pigala counts base two) and the
-- group-theoretic reading below are the atlas's, not Pigala's; no
-- claim is made that he proved a group extension non-split.
--
-- WHAT IT PROVES, and why it is here.  Vahita_‚¶ checked the carry
-- extension  0 ‚í ‚/b ‚í ‚/b^{n+1} ‚í ‚/b^n ‚í 0  does not split at its
-- MINIMAL instance (b = 2, one digit) by the kernel-of-forgetting.
-- runtime/atlas/residual.py's splitting_exponent_argument computes the
-- GENERAL certificate ‚î ATLAS_OF_N ¬ß8 Prop. 2.11: the class vanishes
-- iff the extension splits iff the two exponents agree ‚î but only per
-- (b, n) it is handed.  This module proves that certificate for EVERY
-- (b ‚â 2, n ‚â 1):
--
--   ¬ß1  ‡â‡‡≤‡‡‡ß‡ø ‚î b ‚à b^{n+1}: the carry digit's order b divides the
--       n+1-place register's order, so lcm(b^{n+1}, b) = b^{n+1}; and
--       the same divisibility at exponent n gives exponent_lhs =
--       lcm(b^n, b) = b^n (the split group ‚/b^n ‚äï ‚/b has exponent b^n).
--   ¬ß2  ‡µ‡‡¶‡‡ß‡ø ‚î b^n < b^{n+1} for b ‚â 2: the count grows a FULL factor
--       of the base at each place.  So exponent_lhs = b^n < b^{n+1} =
--       exponent_rhs: the two exponents disagree at every (b, n).
--   ¬ß3  the certificate assembled: by_exponent holds for all (b ‚â 2, n),
--       so by Prop. 2.11 the carry extension never splits ‚î the top
--       digit is BOUND to the register, not free (‡ï‡ ‡‡ï‡‡‡ã ‡‡¶‡‡ß).
--
-- The fibre reading (README ¬ßTHE LAW): the carry is the fibre a
-- carry-free reading ‚/b^n ‚äï ‚/b would make free; the strict growth of
-- the count is exactly why it cannot be ‚î visibility of the top place
-- is not manufacturable by keeping the digits apart.
--
-- Sources for the mathematics: runtime/atlas/residual.py
-- Prop. 2.11.  Complements Vahita_‚¶  (the b=2,n=1 group instance).
--
-- CHECKED under the pin (Agda 2.8.0 + cubical library).
------------------------------------------------------------------------

module Sankhya_TheBaseAryCountGrowsAFullFactorEachPlaceSoTheCarryNeverSplits where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility

------------------------------------------------------------------------
-- ¬ß1  ‡â‡‡≤‡‡‡ß‡ø ‚î the carry digit's order divides the register's order.
--     b ‚à b^{n+1}, hence lcm collapses (lcm(b^{k+1}, b) = b^{k+1}, and
--     at exponent n ‚â 1 : lcm(b^n, b) = b^n).  b ^ suc n ‚â° b ¬ b ^ n.
------------------------------------------------------------------------

‡§â‡§™‡§≤‡§¨‡•ç‡§ß‡§ø‡§É : (b n : ‚Ñï) ‚Üí b ‚à£ (b ^ (suc n))
‡§â‡§™‡§≤‡§¨‡•ç‡§ß‡§ø‡§É b n = ‚à£-left (b ^ n)

------------------------------------------------------------------------
-- ¬ß2  ‡µ‡‡¶‡‡ß‡ø ‚î the count grows a full factor of the base each place.
------------------------------------------------------------------------

-- b^n is positive when the base is.
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§æ‡§§‡•ç‡§™‡§∞‡§Æ‡•ç : (b n : ‚Ñï) ‚Üí 0 < b ‚Üí 0 < b ^ n
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§æ‡§§‡•ç‡§™‡§∞‡§Æ‡•ç b zero    _   = ‚â§-refl
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§æ‡§§‡•ç‡§™‡§∞‡§Æ‡•ç b (suc n) 0<b =
  ‚â§-trans (‡§∂‡•Ç‡§®‡•ç‡§Ø‡§æ‡§§‡•ç‡§™‡§∞‡§Æ‡•ç b n 0<b)
          (subst (_‚â§ b ¬∑ b ^ n) (¬∑-identityÀ° (b ^ n))
                 (‚â§-¬∑k {1} {b} {b ^ n} 0<b))

‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : (b n : ‚Ñï) ‚Üí 1 < b ‚Üí b ^ n < b ^ (suc n)
‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É b n 1<b =
  subst (Œª z ‚Üí z < b ¬∑ b ^ n) (¬∑-identityÀ° (b ^ n))
    (subst (Œª z ‚Üí 1 ¬∑ z < b ¬∑ z) (sym sp)
           (<-¬∑sk {1} {b} {pred‚Ñï (b ^ n)} 1<b))
  where
  0<b : 0 < b
  0<b = ‚â§<-trans zero-‚â§ 1<b
  ‚â¢0 : ¬¨ (b ^ n ‚â° 0)
  ‚â¢0 e = ¬¨-<-zero (subst (1 ‚â§_) e (‡§∂‡•Ç‡§®‡•ç‡§Ø‡§æ‡§§‡•ç‡§™‡§∞‡§Æ‡•ç b n 0<b))
  sp : b ^ n ‚â° suc (pred‚Ñï (b ^ n))
  sp = suc-pred‚Ñï (b ^ n) ‚â¢0

------------------------------------------------------------------------
-- ¬ß3  the certificate assembled.  For every b ‚â 2 and n ‚â 1 the two
--     exponents of Prop. 2.11 disagree: exponent_lhs = lcm(b^n, b) = b^n
--     (from ¬ß1's divisibility) and exponent_rhs = b^{n+1}, and b^n <
--     b^{n+1} (¬ß2).  by_exponent = exponent_lhs < exponent_rhs holds
--     UNCONDITIONALLY in (b, n), so the carry class never vanishes: the
--     extension never splits.  This is the general form of
--     residual.py's per-instance splitting_exponent_argument.
------------------------------------------------------------------------

‡§ò‡§æ‡§§‡§µ‡§ø‡§ö‡•ç‡§õ‡•á‡§¶‡§É : (b n : ‚Ñï) ‚Üí 1 < b ‚Üí b ^ (suc n) < b ^ (suc (suc n))
‡§ò‡§æ‡§§‡§µ‡§ø‡§ö‡•ç‡§õ‡•á‡§¶‡§É b n 1<b = ‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É b (suc n) 1<b
