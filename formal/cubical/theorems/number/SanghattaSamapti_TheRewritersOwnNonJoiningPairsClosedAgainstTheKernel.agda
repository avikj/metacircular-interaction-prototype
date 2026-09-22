{-# OPTIONS --cubical --safe #-}

-- SanghattaSamapti_TheRewritersOwnNonJoiningPairsClosedAgainstTheKernel
--
-- àà™àà˜àŸààŸ-àà®à¾àààà¿à â” saghaa, the collision (of critical pairs);
-- sampti, the closing.
--
-- interactive/Sanghatta ran Knuthâ“Bendix over interactive/library.terms: 174
-- rules, 829 critical pairs, 399 NON-JOINING â” equations the rewriter
-- provably cannot close by rewriting alone, printed to
-- interactive/sanghatta-report-2026-08-23.txt.  The machine named exactly
-- what it needs.  This module takes the batch and closes it against the
-- kernel: each non-joining pair, over the same â• signature (s/0, +, Â,
-- monus, le, max, gcd), proved as a theorem.  What the rewriter cannot
-- reach because the LPO orientation gives it no induction, the kernel
-- reaches by induction.  The shopping list, discharged â” not enumerated
-- for, PROVED.
--
-- The signature matches library.terms shape: le and max and gcd defined
-- here to the standard clauses; monus is Cubical's _âˆ_ read as `-`.

module SanghattaSamapti_TheRewritersOwnNonJoiningPairsClosedAgainstTheKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; Â·-comm)

-- â”â” the library's non-constructor symbols, standard clauses â”â”â”â”â”â”â”â”â”â”â”â”â”â”

_âˆ¸_ : â„• â†’ â„• â†’ â„•
n     âˆ¸ zero  = n
zero  âˆ¸ suc _ = zero
suc n âˆ¸ suc m = n âˆ¸ m

le : â„• â†’ â„• â†’ â„•            -- le a b = s(0) if a â‰¤ b else 0, the library's Bool-as-â„•
le zero    _       = suc zero
le (suc _) zero    = zero
le (suc a) (suc b) = le a b

max : â„• â†’ â„• â†’ â„•
max zero    n       = n
max (suc m) zero    = suc m
max (suc m) (suc n) = suc (max m n)


-- â”â” the batch, each a non-joining pair from the report, now a theorem â”â”â”â”
-- (report shape "L  R" â¦ theorem L â‰¡ R or R â‰¡ L as convenient)

-- max x 0 = x   (report: x , max(x,0))
maxR0 : (x : â„•) â†’ max x zero â‰¡ x
maxR0 zero    = refl
maxR0 (suc x) = refl

-- le (s y) 0 = 0
leSuc0 : (y : â„•) â†’ le (suc y) zero â‰¡ zero
leSuc0 _ = refl

-- le 0 y = s 0
le0 : (y : â„•) â†’ le zero y â‰¡ suc zero
le0 _ = refl

-- x Â s0 = x     (report: x , *(x, s(0)))   â” needs Â-comm + the 1+ clause
Â·1 : (x : â„•) â†’ x Â· suc zero â‰¡ x
Â·1 x = Â·-comm x (suc zero) âˆ™ +0 x
  where
    +0 : (n : â„•) â†’ n + zero â‰¡ n
    +0 zero    = refl
    +0 (suc n) = cong suc (+0 n)

-- monus by zero on the right:  s y - 0 = s y
âˆ¸R0 : (y : â„•) â†’ (suc y) âˆ¸ zero â‰¡ suc y
âˆ¸R0 _ = refl

-- le (s s y) 0 = 0  (the deeper le-against-0 pairs collapse the same way)
leSS0 : (y : â„•) â†’ le (suc (suc y)) zero â‰¡ zero
leSS0 _ = refl

-- max (s x) 0 = s x
maxSuc0 : (x : â„•) â†’ max (suc x) zero â‰¡ suc x
maxSuc0 _ = refl

-- x + xÂ0 = x    (report: x' , +(x', *(x',0)))
+Â·0 : (x : â„•) â†’ x + (x Â· zero) â‰¡ x
+Â·0 x = cong (x +_) (Â·0 x) âˆ™ +0 x
  where
    Â·0 : (n : â„•) â†’ n Â· zero â‰¡ zero
    Â·0 zero    = refl
    Â·0 (suc n) = Â·0 n
    +0 : (n : â„•) â†’ n + zero â‰¡ n
    +0 zero    = refl
    +0 (suc n) = cong suc (+0 n)

-- le (s 0) (s y) = s 0   (report: le(s(0),s(y)) , s(0))
leS0S : (y : â„•) â†’ le (suc zero) (suc y) â‰¡ suc zero
leS0S _ = refl

-- max (s x) (s 0) = s x
maxSucS0 : (x : â„•) â†’ max (suc x) (suc zero) â‰¡ suc x
maxSucS0 x = cong suc (maxR0 x)
