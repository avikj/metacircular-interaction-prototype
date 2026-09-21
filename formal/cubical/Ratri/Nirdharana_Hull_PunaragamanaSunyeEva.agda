{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ààà¨à°à¾à—à®à¨à ààà¨àà¯à ààµ â” return is only at zero.  (Sarakaa-stra à§à
-- reads: ààà¨à°à¾à—à®à¨à ààà¨àà¯-àµàà¯à¯àà¨ ààµ, return is only at zero cost.  The
-- stra names the discipline; this module proves the stra's shape as a
-- theorem about a concrete priced cycle, and the identification of the
-- two is a READING, said as one.)
--
-- DEEPER than the witnesses.  Anirdharita_IntegerHullMultiplicity_
-- AllFourSections killed the four section guesses at t = 1.
-- The host's price theorems license the general law, every t at once:
-- hull's census is six per unit (hullN : N (hull t) â‰¡ t Â 6) and eight
-- per unit squared (hullSQ : SQ (hull t) â‰¡ t Â 8), so the loop
-- â• â’ Config â’ â• through hull returns to its argument EXACTLY at zero:
--
--     N  (hull t) â‰¡ t   âŸº   t â‰¡ 0
--     SQ (hull t) â‰¡ t   âŸº   t â‰¡ 0
--
-- The engine underneath is one lemma with no solver and no ordering
-- theory: a cycle whose price per turn is a positive multiplier has no
-- fixed point above zero â” suc (k + s Â suc m) â‰¡ s is refutable by
-- descent on s, the multiplier peeling one suc into the additive debt k
-- each round.  The probe measured this negatively (no section); this
-- states it positively: the fibre of "returned" is the singleton {0}.
-- Zero cost, zero content, the only weightless walk â” and the walked
-- ledger's own chronology-protection reading (README movement 6), here
-- as a two-line term about lists of naturals.
------------------------------------------------------------------------

module Ratri.Nirdharana_Hull_PunaragamanaSunyeEva where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„•; zero; suc; _+_; _Â·_; snotz; injSuc; +-suc; +-assoc)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import IntegerHullMultiplicity using (Config; hull; N; SQ; hullN; hullSQ)

-- A positively-priced loop cannot close above zero: descent on s,
-- each round converting one unit of the multiplier into standing debt.
noReturn : (m s k : â„•) â†’ suc (k + s Â· suc m) â‰¡ s â†’ âŠ¥
noReturn m zero    k p = snotz p
noReturn m (suc s) k p = noReturn m s (k + m) (sym step âˆ™ injSuc p)
  where
  step : k + (suc m + s Â· suc m) â‰¡ suc ((k + m) + s Â· suc m)
  step = +-suc k (m + s Â· suc m) âˆ™ cong suc (+-assoc k m (s Â· suc m))

-- t Â 6 â‰¡ t forces t â‰¡ 0 â¦
sixâ‰¡selfâ†’zero : (t : â„•) â†’ t Â· 6 â‰¡ t â†’ t â‰¡ 0
sixâ‰¡selfâ†’zero zero    _ = refl
sixâ‰¡selfâ†’zero (suc s) p = Empty.rec (noReturn 5 s 4 (injSuc p))

-- â¦ and t Â 8 â‰¡ t likewise.
eightâ‰¡selfâ†’zero : (t : â„•) â†’ t Â· 8 â‰¡ t â†’ t â‰¡ 0
eightâ‰¡selfâ†’zero zero    _ = refl
eightâ‰¡selfâ†’zero (suc s) p = Empty.rec (noReturn 7 s 6 (injSuc p))

------------------------------------------------------------------------
-- THE LAW, both loops, both directions.

N-returns-only-at-zero : (t : â„•) â†’ N (hull t) â‰¡ t â†’ t â‰¡ 0
N-returns-only-at-zero t p = sixâ‰¡selfâ†’zero t (sym (hullN t) âˆ™ p)

SQ-returns-only-at-zero : (t : â„•) â†’ SQ (hull t) â‰¡ t â†’ t â‰¡ 0
SQ-returns-only-at-zero t p = eightâ‰¡selfâ†’zero t (sym (hullSQ t) âˆ™ p)

-- and at zero, both return:
N-returns-at-zero : N (hull 0) â‰¡ 0
N-returns-at-zero = refl

SQ-returns-at-zero : SQ (hull 0) â‰¡ 0
SQ-returns-at-zero = refl
