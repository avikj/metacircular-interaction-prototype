{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- ğ’¦ := âˆ âˆ˜ Î“   and the trichotomy of Ï(Dğ’¦).
--
--   Ï < 1   àµà¿à˜àà¨à•ààà¯à        `decay`      : the orbit reaches 0 in finite time
--   Ï = 1   ààà®à¾à¨àà¨à¾à¦à        `resonance`  : the orbit is stationary
--   Ï > 1   àµà¿à˜àà¨àà¾à–àà•à°àà®à    `branching`  : the orbit never reaches 0
--
-- The three cases are theorems about one â•-valued obstruction measure âˆ and
-- one response Î“; the spectral radius is not measured, it is the sign of the
-- step.  Nothing here is a fit.

module KFlow where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.Nat.Order
  using (_<_ ; _â‰¤_ ; zero-â‰¤ ; suc-â‰¤-suc ; pred-â‰¤-pred ; Â¬-<-zero ; â‰¤-trans ; <-trans ; â‰¤<-trans)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

-- âˆ âˆ˜ Î“, already evaluated: one step of the obstruction measure.
ğ’¦ : Typeâ‚€
ğ’¦ = â„• â†’ â„•

iterate : ğ’¦ â†’ â„• â†’ â„• â†’ â„•
iterate f zero n = n
iterate f (suc k) n = iterate f k (f n)

--------------------------------------------------------------------------
-- Ï < 1
--------------------------------------------------------------------------

Contracting : ğ’¦ â†’ Typeâ‚€
Contracting f = (n : â„•) â†’ 0 < n â†’ f n < n

â‰¤zeroâ†’â‰¡zero : (n : â„•) â†’ n â‰¤ 0 â†’ n â‰¡ 0
â‰¤zeroâ†’â‰¡zero zero _ = refl
â‰¤zeroâ†’â‰¡zero (suc n) p = âŠ¥.rec (Â¬-<-zero p)

decay-fuel :
    (f : ğ’¦) â†’ Contracting f
  â†’ (fuel n : â„•) â†’ n â‰¤ fuel
  â†’ Î£[ k âˆˆ â„• ] iterate f k n â‰¡ 0
decay-fuel f c fuel zero _ = 0 , refl
decay-fuel f c zero (suc n) p = âŠ¥.rec (snotz (â‰¤zeroâ†’â‰¡zero (suc n) p))
decay-fuel f c (suc fuel) (suc n) p =
  let step : f (suc n) < suc n
      step = c (suc n) (suc-â‰¤-suc zero-â‰¤)

      shrink : f (suc n) â‰¤ n
      shrink = pred-â‰¤-pred step

      room : f (suc n) â‰¤ fuel
      room = â‰¤-trans shrink (pred-â‰¤-pred p)

      rest : Î£[ k âˆˆ â„• ] iterate f k (f (suc n)) â‰¡ 0
      rest = decay-fuel f c fuel (f (suc n)) room
  in suc (fst rest) , snd rest

-- àµà¿à˜àà¨à•ààà¯à : a strictly contracting response annihilates every obstruction.
decay : (f : ğ’¦) â†’ Contracting f â†’ (n : â„•) â†’ Î£[ k âˆˆ â„• ] iterate f k n â‰¡ 0
decay f c n = decay-fuel f c n n (0 , refl)

--------------------------------------------------------------------------
-- Ï = 1
--------------------------------------------------------------------------

Stationary : ğ’¦ â†’ â„• â†’ Typeâ‚€
Stationary f n = f n â‰¡ n

-- ààà®à¾à¨àà¨à¾à¦à : the orbit is the point; no response is left to apply.
resonance :
    (f : ğ’¦) (n : â„•) â†’ Stationary f n
  â†’ (k : â„•) â†’ iterate f k n â‰¡ n
resonance f n s zero = refl
resonance f n s (suc k) = cong (iterate f k) s âˆ™ resonance f n s k

--------------------------------------------------------------------------
-- Ï > 1
--------------------------------------------------------------------------

Expanding : ğ’¦ â†’ Typeâ‚€
Expanding f = (n : â„•) â†’ 0 < n â†’ n < f n

expand-positive :
    (f : ğ’¦) â†’ Expanding f
  â†’ (k n : â„•) â†’ 0 < n â†’ 0 < iterate f k n
expand-positive f e zero n p = p
expand-positive f e (suc k) n p =
  expand-positive f e k (f n) (<-trans p (e n p))

-- àµà¿à˜àà¨àà¾à–àà•à°àà®à : no finite number of responses closes an expanding
-- obstruction, so the branch is permanent, not a slow decay.
branching :
    (f : ğ’¦) â†’ Expanding f
  â†’ (k n : â„•) â†’ 0 < n â†’ Â¬ (iterate f k n â‰¡ 0)
branching f e k n p q = Â¬-<-zero (subst (0 <_) q (expand-positive f e k n p))

------------------------------------------------------------------------
-- Two facts about how these theorems are USED, checked in
-- `OneStepDecidesResonanceAndNoPrefixDecidesDecay`:
--
--   oneStepIsStationary : iterate f 1 n â‰¡ n â’ Stationary f n
--       the converse of `resonance`'s hypothesis, definitionally.  So
--       ONE comparison decides the whole orbit, and a runner comparing
--       many consecutive iterates is doing redundant work.
--
--   noPrefixDecidesDecay : (N : â•) â’ â¦
--       for EVERY prefix length N there is a CONTRACTING map (the
--       predecessor) and a start whose orbit shows no zero within N and
--       is zero at N+1.  So no finite prefix decides `decay`, and no
--       larger constant repairs it â” the statement is quantified over N.
--       What decides it is `Contracting f`, this module's own
--       hypothesis.
------------------------------------------------------------------------
