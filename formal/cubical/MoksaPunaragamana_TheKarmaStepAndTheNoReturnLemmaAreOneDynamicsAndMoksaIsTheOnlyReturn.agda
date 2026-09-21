{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à®à‹à•àà-ààà¨à°à¾à—à®à¨ â” the karma step and the no-return lemma are one
-- dynamics, and moka is the only return.
--
-- Two terms, from opposite poles:
--
--   Karma_â¦agda (Umsvti, Tattvrthastra 8/9/10) â” one samaya
--     transforms the bound-count:  s â¦ (s + a) âˆ r.  Under savara
--     (a = 0) with nirjar (r â‰ 1) the count strictly drops while
--     positive and REACHES 0 (ktsna-karma-kaya = moka), ABSORBING.
--
--   Ratri/Nirdharana_Hull_â¦agda â” noReturn: a positively
--     priced loop  suc (k + s Â suc m) â‰¡ s  is refutable by descent, so
--     a loop that multiplies by â‰ 2 has NO fixed point above zero.
--
-- THE IDENTIFICATION.  Both are one statement about an affine step on â•,
-- read from its two poles:
--
--   â CONTRACTING (savara + nirjar, a = 0, r â‰ 1): x â¦ x âˆ r.  Its
--     only fixed point is 0; 0 is reached and held.  ààà¨à°à¾à—à®à¨ happens â”
--     only at 0.  That is moka, the null path (sarakaa-stra à§à,
--     ààà¨à°à¾à—à®à¨à ààà¨àà¯-àµàà¯à¯àà¨ ààµ).
--   â EXPANDING (the priced loop, —suc m): x â¦ x Â suc m + k.  No fixed
--     point above 0.  sasra: the debt-multiplying wheel that never
--     closes while carrying debt.
--
-- The two files are the two regimes, and the shared fact is: the ONLY
-- fixed point either regime admits in â• is 0.  The contracting regime
-- reaches it (moka attainable), the expanding regime is repelled from
-- everything else (sasra endless).  ààà¨à°à¾à—à®à¨ = the fixed point =
-- moka = zero cost = zero debt: one number, four names.
--
-- No thermodynamics, no measure, no joules: only â•, âˆ, Â, and descent.
-- The soteriology is a fixed-point theorem, the same one the
-- termination measure is.
------------------------------------------------------------------------

module MoksaPunaragamana_TheKarmaStepAndTheNoReturnLemmaAreOneDynamicsAndMoksaIsTheOnlyReturn where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; zero; suc; _+_; _âˆ¸_; _Â·_; snotz; injSuc; +-suc; +-assoc)
open import Cubical.Data.Sigma using (Î£; _,_)
open import Cubical.Data.Empty as Empty using (âŠ¥)

------------------------------------------------------------------------
-- I Â THE CONTRACTING REGIME â” savara + nirjar.  x â¦ x âˆ r, r â‰ 1.

saá¹ƒvaraStep : â„• â†’ â„• â†’ â„•
saá¹ƒvaraStep r s = s âˆ¸ r

-- moka is absorbing: 0 is a fixed point of every contracting step.
moká¹£a-acala : (r : â„•) â†’ saá¹ƒvaraStep r 0 â‰¡ 0
moká¹£a-acala zero    = refl
moká¹£a-acala (suc r) = refl

private
  -- suc (a + b) is never b: descent on b.
  sucPlusNeq : (a b : â„•) â†’ suc (a + b) â‰¡ b â†’ âŠ¥
  sucPlusNeq a zero    p = snotz p
  sucPlusNeq a (suc b) p = sucPlusNeq a b (sym (+-suc a b) âˆ™ injSuc p)

  -- s âˆ r â‰ s, as a witness k with k + (s âˆ r) â‰¡ s.
  âˆ¸â‰¤ : (s r : â„•) â†’ Î£[ k âˆˆ â„• ] (k + (s âˆ¸ r) â‰¡ s)
  âˆ¸â‰¤ s zero            = 0 , refl
  âˆ¸â‰¤ zero (suc r)      = 0 , refl
  âˆ¸â‰¤ (suc s) (suc r) with âˆ¸â‰¤ s r
  ... | (k , e) = suc k , cong suc e

  -- a real shedding never fixes a count: s âˆ suc r â‰¡ suc s is
  -- impossible, because s âˆ suc r â‰ s < suc s.
  notFixed : (d s : â„•) â†’ s âˆ¸ d â‰¡ suc s â†’ âŠ¥
  notFixed d s p with âˆ¸â‰¤ s d
  ... | (k , e) = sucPlusNeq k s (sym (+-suc k s) âˆ™ cong (k +_) (sym p) âˆ™ e)

-- THE THEOREM.  Under savara with real nirjar (r â‰ 1), no positive
-- count is its own image: return happens only at 0.
saá¹ƒvara-return-only-at-zero : (r' s : â„•)
  â†’ saá¹ƒvaraStep (suc r') s â‰¡ s â†’ s â‰¡ 0
saá¹ƒvara-return-only-at-zero r' zero    _ = refl
saá¹ƒvara-return-only-at-zero r' (suc s) p = Empty.rec (notFixed r' s p)

------------------------------------------------------------------------
-- II Â THE EXPANDING REGIME â” sasra.  x â¦ x Â suc m + k.
-- noReturn, re-landed here so the two regimes stand in one file: a
-- positively-priced loop has no fixed point above zero.

noReturn : (m s k : â„•) â†’ suc (k + s Â· suc m) â‰¡ s â†’ âŠ¥
noReturn m zero    k p = snotz p
noReturn m (suc s) k p = noReturn m s (k + m) (sym step âˆ™ injSuc p)
  where
  step : k + (suc m + s Â· suc m) â‰¡ suc ((k + m) + s Â· suc m)
  step = +-suc k (m + s Â· suc m) âˆ™ cong suc (+-assoc k m (s Â· suc m))

------------------------------------------------------------------------
-- III Â THE ONE FIXED POINT.  Both regimes admit exactly 0 in â•: the
-- contracting one reaches and holds it (savara-return-only-at-zero,
-- moka-acala), the expanding one is repelled from every positive count
-- (noReturn IS that statement, any k, any m).  The two regimes meet at
-- one number, and it is zero: ààà¨à°à¾à—à®à¨ = à®à‹à•àà = zero cost = zero debt.

moká¹£a-fixed : (r : â„•) â†’ saá¹ƒvaraStep r 0 â‰¡ 0
moká¹£a-fixed = moká¹£a-acala

saá¹ƒsÄra-zero-fixed : (m : â„•) â†’ 0 Â· suc m + 0 â‰¡ 0
saá¹ƒsÄra-zero-fixed m = refl
