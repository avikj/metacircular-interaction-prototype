{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡‡‡‡‡‡∞-‡‡Æ‡æ‡‡ ‚î the survivor census composes across charts: over two
-- charts with distinct walls the joint survivor set is Fin (m ¬ m'),
-- i.e. (p‚àí2)¬(q‚àí2).  The singular series' LOCAL PRODUCT, as a checked
-- equivalence ‚î closing the two-chart case of the atlas ‡¶‡ã‡‡≤‡‡ñ that
-- ‡¶‡‡µ‡ø-‡≤‡ã‡ and ‡‡‡‡ü‡ø‡ï left open.
--
-- ‡ï‡‡ü‡‡ü‡ï-‡ï‡ã‡ Lemma 3 (prose): the joint congruence system has exactly
-- ‚à (p ‚àí œâ_p) solutions per period.  Here, for two charts at distinct-wall
-- (œâ_p = 2) primes, that product is a TERM:
--
--     ‡‡ø‡‡‡ü‡Æ‡ a‚ b‚ ó ‡‡ø‡‡‡ü‡Æ‡ a‚ b‚  ‚â  Fin (m ¬‚ï m')
--
-- built as ‡¶‡‡µ‡ø-‡≤‡ã‡ on each chart (survivors of one chart ‚â Fin (p‚àí2)),
-- combined by ‚â-ó, then Fin m ó Fin m' ‚â Fin (m ¬ m') by the library's
-- factorEquiv.  Three lines; the content is that each factor is exactly
-- the elided-two-residue count and the counts multiply.
--
-- THE MODELLING CHOICE, stated so it is not smuggled.  The joint survivor
-- set is taken to be the PRODUCT of the local survivor sets.  That is the
-- sieve's own model: the two-wall condition at a prime is independent of
-- the condition at a coprime prime, so a joint survivor is a tuple of
-- local survivors.  The identification of this product with the survivors
-- inside Fin (p¬q) is the Chinese Remainder ring-iso (‚/pq ‚â ‚/p ó ‚/q,
-- coprime), which is NOT proved here ‚î this module works on the product
-- carrier directly, where the count is exact and needs no CRT.  So the
-- result is the DENSITY product, honestly on the product carrier; the
-- CRT identification with the residue line mod p¬q is the remaining,
-- named, half of the atlas.
--
-- No claim about primes as such: p = 2+m is any modulus ‚â 2 with two
-- distinct walls; primality and coprimality enter only when this product
-- is read as the singular series, which ‡ï‡‡ü‡‡ü‡ï-‡ï‡ã‡ does.  ‡ï‡‡‡‡‡‡∞-‡‡Æ‡æ‡‡ is
-- built here, 2026-08-23.
------------------------------------------------------------------------

module KsetraSamasa_TheTwoChartSurvivorCensusIsTheProductPMinusTwoTimesQMinusTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv)
open import Cubical.Data.Nat using (‚Ñï ; suc) renaming (_¬∑_ to _¬∑‚Ñï_)
open import Cubical.Data.Fin using (Fin ; factorEquiv)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; ‚âÉ-√ó)
open import Cubical.Relation.Nullary using (¬¨_)

open import DviLopa_TheTwoWallsElideTwoResiduesAndTheSurvivorsAreExactlyCounted
  using (‡§¶‡•ç‡§µ‡§ø-‡§≤‡•ã‡§™‡§É)

private
  variable
    m m' : ‚Ñï

------------------------------------------------------------------------
-- the survivor set of one chart: the y in Fin (p) surviving both walls,
-- exactly ‡¶‡‡µ‡ø-‡≤‡ã‡'s domain (p = suc (suc m)).
------------------------------------------------------------------------

‡§∂‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç : (a b : Fin (suc (suc m))) ‚Üí Type
‡§∂‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç {m = m} a b = Œ£[ y ‚àà Fin (suc (suc m)) ] ((¬¨ a ‚â° y) √ó (¬¨ b ‚â° y))

------------------------------------------------------------------------
-- ‡ï‡‡‡‡‡‡∞-‡‡Æ‡æ‡‡ ‚î the two-chart joint census is Fin (m ¬ m') = (p‚àí2)(q‚àí2).
------------------------------------------------------------------------

‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§∏‡§Æ‡§æ‡§∏‡§É :
    (a‚ÇÅ b‚ÇÅ : Fin (suc (suc m)))  ‚Üí (¬¨ a‚ÇÅ ‚â° b‚ÇÅ)
  ‚Üí (a‚ÇÇ b‚ÇÇ : Fin (suc (suc m'))) ‚Üí (¬¨ a‚ÇÇ ‚â° b‚ÇÇ)
  ‚Üí (‡§∂‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç a‚ÇÅ b‚ÇÅ √ó ‡§∂‡§ø‡§∑‡•ç‡§ü‡§Æ‡•ç a‚ÇÇ b‚ÇÇ) ‚âÉ Fin (m ¬∑‚Ñï m')
‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞-‡§∏‡§Æ‡§æ‡§∏‡§É a‚ÇÅ b‚ÇÅ ne‚ÇÅ a‚ÇÇ b‚ÇÇ ne‚ÇÇ =
  compEquiv (‚âÉ-√ó (‡§¶‡•ç‡§µ‡§ø-‡§≤‡•ã‡§™‡§É a‚ÇÅ b‚ÇÅ ne‚ÇÅ) (‡§¶‡•ç‡§µ‡§ø-‡§≤‡•ã‡§™‡§É a‚ÇÇ b‚ÇÇ ne‚ÇÇ)) factorEquiv

------------------------------------------------------------------------
-- ‡¶‡ã‡‡≤‡‡ñ‡.  Two charts, both at distinct-wall count p‚àí2; the merged-wall
-- case (p ‚à 2a, count p‚àí1) and the arbitrary-length atlas (‚à over a list
-- of charts, by iterating this composition) are the next steps, and the
-- CRT identification of the product carrier with the residue line mod p¬q
-- is the named other half.  What is proved: the elided-two-residue counts
-- MULTIPLY across charts, exactly, as an equivalence ‚î the local product
-- of the singular series is now a term.
------------------------------------------------------------------------
