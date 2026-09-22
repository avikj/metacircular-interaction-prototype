{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhereTheCircleSplits
--
-- **Is the circle actually a circle?**
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TRIVIALISING POSSIBILITY
--
-- `PythagoreanTransition` builds the conic over an arbitrary commutative
-- ring and finds that its additive law is multiplicative on norms â” the
-- exact opposite of `disjoint-support` on the line.  That is only
-- interesting if the conic is a conic.  If âˆ’1 happens to be a square in
-- the ring, say iÂi = âˆ’1, then
--
--     aÂ² + bÂ²  =  (a + i b)(a âˆ’ i b)
--
-- and the "circle" is two crossing LINES.  Its group law degenerates to
-- multiplication on each line separately, `gen-hom` becomes a statement
-- about products of scalars, and the whole apparatus is a disguised
-- restatement of ring multiplication carrying no geometry at all.
--
-- `norm-factors` below proves the factorisation exactly, over any
-- commutative ring in which such an i exists.  So the trivialising case
-- is real and must be excluded, not assumed away.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- IT IS EXCLUDED OVER â
--
-- `â-has-no-i`: no integer squares to âˆ’1, because every product of two
-- equal integers is `pos` of something â” two cases, both closed by
-- `posNotnegsuc`.  So over â the conic does not split, and every
-- statement in `PythagoreanTransition` and `IdempotenceForbidsDescent`
-- that was checked at â is a statement about a genuine circle.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND THAT IS THE DICHOTOMY THE WHOLE SUBJECT TURNS ON
--
-- Whether âˆ’1 is a square is exactly the split/inert question for the
-- Gaussian integers, and it is the reason the two-squares problem is a
-- problem: the form represents a prime p when p splits and does not when
-- p is inert.  Brahmagupta's form xÂ² âˆ’ D yÂ² asks the same question with
-- D in place of âˆ’1, and the cakravla's whole labour is at the values of
-- D where the form does not degenerate.
--
-- So the object `PythagoreanTransition` found â” an additive law visible
-- in the multiplicative chart â” is not free.  It exists exactly where the
-- norm form is irreducible, and where the form splits, the "additive law"
-- was multiplication all along.
------------------------------------------------------------------------

module WhereTheCircleSplits where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (â„• ; suc) renaming (_Â·_ to _Â·â„•_)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc) renaming (_Â·_ to _Â·â„¤_)
open import Cubical.Data.Int.Properties using (posNotnegsuc ; posÂ·pos ; negsucÂ·negsuc)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import PythagoreanTransition using (module Circle)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  If âˆ’1 is a square, the norm form splits
------------------------------------------------------------------------

module Split (R : CommRing â„“) where

  open CommRingStr (snd R)
  open Circle R

  private
    expand : (i a b : A) â†’
      (a + (i Â· b)) Â· (a - (i Â· b)) â‰¡ (a Â· a) - ((i Â· i) Â· (b Â· b))
    expand i a b = solve! R

    close : (a b : A) â†’ (a Â· a) - ((- 1r) Â· (b Â· b)) â‰¡ (a Â· a) + (b Â· b)
    close a b = solve! R

  -- THE DEGENERATION.  With iÂi = âˆ’1 the circle is two lines.
  norm-factors : (i : A) â†’ (i Â· i) â‰¡ (- 1r)
               â†’ (u : Pair) â†’ N u â‰¡ (fst u + (i Â· snd u)) Â· (fst u - (i Â· snd u))
  norm-factors i h u =
      sym ( expand i (fst u) (snd u)
          âˆ™ cong (Î» z â†’ (fst u Â· fst u) - (z Â· (snd u Â· snd u))) h
          âˆ™ close (fst u) (snd u) )

------------------------------------------------------------------------
-- 2.  Over â no such i exists, so the circle stays a circle
------------------------------------------------------------------------

â„¤-has-no-i : (a : â„¤) â†’ Â¬ (a Â·â„¤ a â‰¡ negsuc 0)
â„¤-has-no-i (pos n)    p = posNotnegsuc (n Â·â„• n) 0 (posÂ·pos n n âˆ™ p)
â„¤-has-no-i (negsuc n) p =
  posNotnegsuc (suc n Â·â„• suc n) 0
    (posÂ·pos (suc n) (suc n) âˆ™ sym (negsucÂ·negsuc n n) âˆ™ p)

------------------------------------------------------------------------
-- 3.  The sentence.
--
-- An additive law that is multiplicative on norms is not a free gift of
-- writing pairs.  It exists exactly where the norm form is irreducible.
-- Over â that holds, so `PythagoreanTransition`'s conic is a conic and
-- its transition map is geometry.  Over a ring where âˆ’1 is a square the
-- same construction returns ring multiplication wearing a costume.
------------------------------------------------------------------------
