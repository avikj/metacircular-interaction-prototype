{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExponentBound
--
-- The first of the three pieces `PFreePart` named:
--
--     exponent-bounded : 1 < p â’ 0 < n â’ n â‰ k â’ (p ^ a) âˆ n
--                      â’ a â‰ logOf p k
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SPECIFICATION OF `logOf`
--
-- `PFreePart` said this piece was "a â‰ âŠlog_p kâ‹ when p^a âˆ m â‰ k",
-- as though âŠlog_p kâ‹ were a known quantity with known properties.  It
-- is not.  `FrontierList.logOf` is
--
--     expOf p k zero    = 0
--     expOf p k (suc g) = if p ^ suc (expOf p k g) â‰ k then suc â¦ else â¦
--     logOf p k         = expOf p k k
--
-- â€” a gas-driven climb whose gas budget is `k` itself.  The content here
-- is the SPECIFICATION of `logOf`, in both directions, and the divisor
-- bound is a corollary of it:
--
--     logOf-le : 0 < k â’ p ^ (logOf p k)       â‰ k
--     logOf-lt : 1 < p â’ k < p ^ (suc (logOf p k))
--
-- The second is the one that needed an argument.  It holds because the
-- climb obeys a dichotomy: after `g` steps EITHER it has advanced once
-- per step (`g â‰ expOf p k g`) OR it has already saturated, and once it
-- saturates the same `no` recurs forever.  Saturation must happen by
-- step `k` because a climb that never saturates gives `p ^ k â‰ k`,
-- against `k < p ^ k`.
--
-- That last inequality is the load-bearing one and is proved here from
-- nothing: `k < p^k` for `1 < p`, by induction, using only that
-- `x < p Â x` for positive `x`.
------------------------------------------------------------------------

module ExponentBound where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-refl ; mâˆ£nâ†’mâ‰¤n)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import FrontierList using (expOf ; logOf)

------------------------------------------------------------------------
-- 1.  Positivity, and the one strict inequality everything rests on
------------------------------------------------------------------------

private
  0<p-of : {p : â„•} â†’ 1 < p â†’ 0 < p
  0<p-of 1<p = â‰¤-trans â‰¤-sucâ„• 1<p

  posÂ· : (a b : â„•) â†’ 0 < a â†’ 0 < b â†’ 0 < (a Â· b)
  posÂ· zero    b       0<a _   = Empty.rec (Â¬-<-zero 0<a)
  posÂ· (suc a) zero    _   0<b = Empty.rec (Â¬-<-zero 0<b)
  posÂ· (suc a) (suc b) _   _   = suc-â‰¤-suc zero-â‰¤

  -- the same shape as `PFreePart.shrink`, which is private there
  c<2c : (c : â„•) â†’ 0 < c â†’ c < 2 Â· c
  c<2c c 0<c = subst2 _â‰¤_ (+-comm c 1) (sym two-c) (â‰¤-k+ 0<c)
    where
    two-c : 2 Â· c â‰¡ c + c
    two-c = cong (c +_) (+-zero c)

-- exported: `FrontierDividesHard` needs it to see m' < p^a Â m'
x<pÂ·x : (p x : â„•) â†’ 1 < p â†’ 0 < x â†’ x < (p Â· x)
x<pÂ·x p x 1<p 0<x = <â‰¤-trans (c<2c x 0<x) (â‰¤-Â·k 1<p)

^-pos : (p a : â„•) â†’ 0 < p â†’ 0 < (p ^ a)
^-pos p zero    _   = â‰¤-refl
^-pos p (suc a) 0<p = posÂ· p (p ^ a) 0<p (^-pos p a 0<p)

-- THE inequality that makes the fuel budget `k` adequate.
k<p^k : (p k : â„•) â†’ 1 < p â†’ k < (p ^ k)
k<p^k p zero    1<p = â‰¤-refl
k<p^k p (suc k) 1<p =
  â‰¤<-trans (k<p^k p k 1<p)
           (x<pÂ·x p (p ^ k) 1<p (^-pos p k (0<p-of 1<p)))

------------------------------------------------------------------------
-- 2.  Powers are monotone in the exponent
------------------------------------------------------------------------

private
  ^-mono-shift : (p a d : â„•) â†’ 0 < p â†’ (p ^ a) â‰¤ (p ^ (d + a))
  ^-mono-shift p a zero    _   = â‰¤-refl
  ^-mono-shift p a (suc d) 0<p = â‰¤-trans (^-mono-shift p a d 0<p) step
    where
    step : (p ^ (d + a)) â‰¤ (p ^ (suc d + a))
    step = subst (_â‰¤ (p Â· (p ^ (d + a))))
                 (Â·-identityË¡ (p ^ (d + a)))
                 (â‰¤-Â·k 0<p)

^-mono : (p a b : â„•) â†’ 0 < p â†’ a â‰¤ b â†’ (p ^ a) â‰¤ (p ^ b)
^-mono p a b 0<p (d , q) =
  subst (Î» z â†’ (p ^ a) â‰¤ (p ^ z)) q (^-mono-shift p a d 0<p)

------------------------------------------------------------------------
-- 3.  The climb: it never overshoots
------------------------------------------------------------------------

expOf-le : (p k gas : â„•) â†’ 0 < k â†’ (p ^ (expOf p k gas)) â‰¤ k
expOf-le p k zero      0<k = 0<k
expOf-le p k (suc gas) 0<k with â‰¤Dec (p ^ (suc (expOf p k gas))) k
... | yes h = h
... | no  _ = expOf-le p k gas 0<k

------------------------------------------------------------------------
-- 4.  The climb: advance-or-saturate, and it cannot advance forever
------------------------------------------------------------------------

private
  Â¬â‰¤â†’< : (a b : â„•) â†’ Â¬ (a â‰¤ b) â†’ b < a
  Â¬â‰¤â†’< a b h with splitâ„•-â‰¤ a b
  ... | inl le = Empty.rec (h le)
  ... | inr strict = strict

  yesStep : (p k gas : â„•)
          â†’ (p ^ (suc (expOf p k gas))) â‰¤ k
          â†’ ((gas â‰¤ expOf p k gas) âŠŽ (k < (p ^ (suc (expOf p k gas)))))
          â†’ ((suc gas â‰¤ suc (expOf p k gas))
             âŠŽ (k < (p ^ (suc (suc (expOf p k gas))))))
  yesStep p k gas h (inl le) = inl (suc-â‰¤-suc le)
  yesStep p k gas h (inr strict) = Empty.rec (<-asym strict h)

expOf-dich : (p k gas : â„•)
           â†’ (gas â‰¤ expOf p k gas) âŠŽ (k < (p ^ (suc (expOf p k gas))))
expOf-dich p k zero      = inl zero-â‰¤
expOf-dich p k (suc gas) with â‰¤Dec (p ^ (suc (expOf p k gas))) k
... | yes h = yesStep p k gas h (expOf-dich p k gas)
... | no  h = inr (Â¬â‰¤â†’< (p ^ (suc (expOf p k gas))) k h)

------------------------------------------------------------------------
-- 5.  THE SPECIFICATION of `logOf`, both directions
------------------------------------------------------------------------

logOf-le : (p k : â„•) â†’ 0 < k â†’ (p ^ (logOf p k)) â‰¤ k
logOf-le p k 0<k = expOf-le p k k 0<k

logOf-lt : (p k : â„•) â†’ 1 < p â†’ k < (p ^ (suc (logOf p k)))
logOf-lt p zero    1<p = posÂ· p 1 (0<p-of 1<p) â‰¤-refl
logOf-lt p (suc k) 1<p = go (expOf-dich p (suc k) (suc k))
  where
  e : â„•
  e = expOf p (suc k) (suc k)

  go : ((suc k â‰¤ e) âŠŽ (suc k < (p ^ (suc e)))) â†’ suc k < (p ^ (suc e))
  go (inr strict) = strict
  go (inl le) = Empty.rec (Â¬m<m (â‰¤<-trans chain (k<p^k p (suc k) 1<p)))
    where
    chain : (p ^ (suc k)) â‰¤ suc k
    chain = â‰¤-trans (^-mono p (suc k) e (0<p-of 1<p) le)
                    (expOf-le p (suc k) (suc k) (suc-â‰¤-suc zero-â‰¤))

------------------------------------------------------------------------
-- 6.  THE PIECE `PFreePart` NAMED
------------------------------------------------------------------------

exponent-bounded : (p k n a : â„•) â†’ 1 < p â†’ 0 < n â†’ n â‰¤ k
                 â†’ (p ^ a) âˆ£ n â†’ a â‰¤ logOf p k
exponent-bounded p k n a 1<p 0<n nâ‰¤k div = go (splitâ„•-â‰¤ a (logOf p k))
  where
  nâ‰¢0 : Â¬ (n â‰¡ 0)
  nâ‰¢0 q = Â¬-<-zero (subst (0 <_) q 0<n)

  p^aâ‰¤k : (p ^ a) â‰¤ k
  p^aâ‰¤k = â‰¤-trans (mâˆ£nâ†’mâ‰¤n nâ‰¢0 div) nâ‰¤k

  go : ((a â‰¤ logOf p k) âŠŽ (logOf p k < a)) â†’ a â‰¤ logOf p k
  go (inl le) = le
  go (inr strict) =
    Empty.rec (<-asym (logOf-lt p k 1<p)
                      (â‰¤-trans (^-mono p (suc (logOf p k)) a (0<p-of 1<p) strict)
                               p^aâ‰¤k))

------------------------------------------------------------------------
-- 7.  It runs, on the walk's own frontier
--
--   `FrontierList.frontier8` records (2,3) âˆ â¦ and asserts it by `refl`.
--   Here the entry is derived: 2Â³ â‰ 8 < 2â´, and any 2-power dividing any
--   n â‰ 8 has exponent at most 3.
------------------------------------------------------------------------

log-2-8 : logOf 2 8 â‰¡ 3
log-2-8 = refl

log-3-8 : logOf 3 8 â‰¡ 1
log-3-8 = refl

log-7-8 : logOf 7 8 â‰¡ 1
log-7-8 = refl

-- the specification, instantiated
spec-2-8-le : (2 ^ (logOf 2 8)) â‰¤ 8
spec-2-8-le = logOf-le 2 8 (suc-â‰¤-suc zero-â‰¤)

spec-2-8-lt : 8 < (2 ^ (suc (logOf 2 8)))
spec-2-8-lt = logOf-lt 2 8 (suc-â‰¤-suc (suc-â‰¤-suc zero-â‰¤))

-- 2Â³ âˆ 8 and 8 â‰ 8, so 3 â‰ logâ 8 â” the exponent the frontier records
bound-8 : 3 â‰¤ logOf 2 8
bound-8 = exponent-bounded 2 8 8 3
            (suc-â‰¤-suc (suc-â‰¤-suc zero-â‰¤))
            (suc-â‰¤-suc zero-â‰¤)
            â‰¤-refl
            (âˆ£-refl refl)
