{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PythagoreanTransition
--
-- `SuccessorIsNotTropical` ends with a sentence this corpus never acted
-- on:  "The object to build is the transition itself."
--
-- Here it is built.  Not on the line, where it does not exist, but on the
-- conic, where it does â” and the construction is Brahmagupta's, 628 CE.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT WAS ACTUALLY PROVED IN `SuccessorIsNotTropical`
--
-- `disjoint-support` says: no prime divides two consecutive integers, so
-- n and n+1 share NOT ONE coordinate in the multiplicative chart.  That
-- was read here as "the parity barrier is a chart incompatibility".
--
-- That reading over-claims, and this module is the correction.  What was
-- proved is a fact about â• **with the successor as its additive law**.
-- It is not a fact about arithmetic.  It is a fact about a particular
-- additive structure whose generator, 1, is multiplicatively invisible â”
-- a unit, hence norm 1 in a chart where norms are all that is seen.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CONIC HAS THE TRANSITION, EXACTLY
--
-- Put the additive law on a circle instead of a line.  A point is a pair
-- (a,b); the norm is aÂ² + bÂ²; and the group law is
--
--     (aâ,bâ) âŠ— (aâ,bâ) = (aâaâ âˆ’ bâbâ , aâbâ + aâbâ).
--
-- This is **samsa-bhvan at D = âˆ’1** â” Brhmasphuasiddhnta ch. 18,
-- 628 CE, the composition law whose whole content is that the norm is
-- multiplicative.  `Bhavana.agda` in this repository already checks the
-- general D; this module takes D = âˆ’1, which is the case that is a
-- CIRCLE, and asks what the circle's additive law does to the chart.
--
-- The answer is the sharpest possible contrast with `disjoint-support`:
--
--     N (u âŠ— g)  â‰¡  N u Â N g                       (`rot-norm`)
--
-- The conic's successor â” translation by a fixed g â” is not merely
-- visible in the multiplicative chart.  It is MULTIPLICATION BY A
-- CONSTANT there.  Where â•'s successor has zero locality, the circle's
-- has total locality.  Same arithmetic, different additive law, opposite
-- answer.  So the barrier is not arithmetic's; it belongs to the line.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TRIPLES ARE THE GROUP, AND EUCLID'S FORMULA IS SQUARING
--
-- A Pythagorean triple is a pair whose norm is a square.  Then:
--
--   * `triple-âŠ—`  triples are CLOSED under bhvan.  (3,4,5) composed
--     with (5,12,13) is (33,56,65) â” checked by `refl` at the bottom of
--     this file.  Triples are not a list; they are a monoid.
--
--   * `euclid`  every pair squares to a triple, with hypotenuse its own
--     norm: gen (p,q) = (pÂ²âˆ’qÂ², 2pq) and N (gen t) = (N t)Â².  Euclid's
--     parametrisation is the single word **squaring**, once the pair is
--     the object rather than the number.
--
--   * `gen-hom`  and this is the transition map: squaring is a monoid
--     homomorphism,  gen (s âŠ— t) â‰¡ gen s âŠ— gen t.  The parameter chart
--     and the triple chart carry the SAME composition, intertwined by
--     the parametrisation.  One chart change, no defect, exactly.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE UNIVALENCE ENTERS, AND IT IS NOT DECORATION
--
-- When N g â‰¡ 1, `rot g` is invertible â” its inverse is composition with
-- the conjugate, which is antara-bhvan, Brahmagupta's second law.  So
-- `rotEquiv` is an equivalence of the pair-type with itself, `rotPath`
-- is the identification univalence supplies, and `defect-vanishes`
-- computes Delta 15's structured defect for the norm along it: it is
-- refl-level zero.  The circle's translations are identifications of
-- the circle carrying its structure with itself.
--
-- The line has no such family: by `disjoint-support` the successor
-- carries NO multiplicative structure along.  Two additive laws, one
-- arithmetic; one is a family of structured identifications and one is
-- not.  That difference â” not any statement about primes â” is what the
-- barrier language has been pointing at.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- Everything below is proved over an ARBITRARY commutative ring, so it
-- holds over â, over â, and over every ring the repository may later
-- want.  Ring identities go through the CommRingSolver â” exact symbolic
-- computation, which CLAUDE.md admits as proof; nothing is measured.
------------------------------------------------------------------------

module PythagoreanTransition where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- The circle over any commutative ring
------------------------------------------------------------------------

module Circle (R : CommRing â„“) where

  open CommRingStr (snd R)

  A : Type â„“
  A = fst R

  Pair : Type â„“
  Pair = A Ã— A

  -- the norm: this is the form xÂ² + yÂ², i.e. xÂ² âˆ’ D yÂ² at D = âˆ’1
  N : Pair â†’ A
  N u = fst u Â· fst u + snd u Â· snd u

  infixl 7 _âŠ—_

  -- àà®à¾à-àà¾àµà¨à¾, D = âˆ’1
  _âŠ—_ : Pair â†’ Pair â†’ Pair
  u âŠ— v = ((fst u Â· fst v) - (snd u Â· snd v))
        , ((fst u Â· snd v) + (fst v Â· snd u))

  -- àà¨ààà°-àà¾àµà¨à¾: the same law with the second sign flipped
  conj : Pair â†’ Pair
  conj u = fst u , (- snd u)

  one : Pair
  one = 1r , 0r

  ----------------------------------------------------------------------
  -- The ring identities.  Each is a polynomial identity in the ring's
  -- own variables, discharged by the solver: exact, not measured.
  ----------------------------------------------------------------------

  private
    brahmagupta :
      (aâ‚ bâ‚ aâ‚‚ bâ‚‚ : A) â†’
        ((aâ‚ Â· aâ‚‚) - (bâ‚ Â· bâ‚‚)) Â· ((aâ‚ Â· aâ‚‚) - (bâ‚ Â· bâ‚‚))
      + ((aâ‚ Â· bâ‚‚) + (aâ‚‚ Â· bâ‚)) Â· ((aâ‚ Â· bâ‚‚) + (aâ‚‚ Â· bâ‚))
      â‰¡ (aâ‚ Â· aâ‚ + bâ‚ Â· bâ‚) Â· (aâ‚‚ Â· aâ‚‚ + bâ‚‚ Â· bâ‚‚)
    brahmagupta aâ‚ bâ‚ aâ‚‚ bâ‚‚ = solve! R

    sq-Â· : (z w : A) â†’ (z Â· z) Â· (w Â· w) â‰¡ (z Â· w) Â· (z Â· w)
    sq-Â· z w = solve! R

    Â·-one : (x : A) â†’ x Â· 1r â‰¡ x
    Â·-one x = solve! R

    idÊ³-fst : (a b : A) â†’ (a Â· 1r) - (b Â· 0r) â‰¡ a
    idÊ³-fst a b = solve! R

    idÊ³-snd : (a b : A) â†’ (a Â· 0r) + (1r Â· b) â‰¡ b
    idÊ³-snd a b = solve! R

    comm-fst : (aâ‚ bâ‚ aâ‚‚ bâ‚‚ : A) â†’
               (aâ‚ Â· aâ‚‚) - (bâ‚ Â· bâ‚‚) â‰¡ (aâ‚‚ Â· aâ‚) - (bâ‚‚ Â· bâ‚)
    comm-fst aâ‚ bâ‚ aâ‚‚ bâ‚‚ = solve! R

    comm-snd : (aâ‚ bâ‚ aâ‚‚ bâ‚‚ : A) â†’
               (aâ‚ Â· bâ‚‚) + (aâ‚‚ Â· bâ‚) â‰¡ (aâ‚‚ Â· bâ‚) + (aâ‚ Â· bâ‚‚)
    comm-snd aâ‚ bâ‚ aâ‚‚ bâ‚‚ = solve! R

    assoc-fst : (aâ‚ bâ‚ aâ‚‚ bâ‚‚ aâ‚ƒ bâ‚ƒ : A) â†’
        (((aâ‚ Â· aâ‚‚) - (bâ‚ Â· bâ‚‚)) Â· aâ‚ƒ) - (((aâ‚ Â· bâ‚‚) + (aâ‚‚ Â· bâ‚)) Â· bâ‚ƒ)
      â‰¡ (aâ‚ Â· ((aâ‚‚ Â· aâ‚ƒ) - (bâ‚‚ Â· bâ‚ƒ))) - (bâ‚ Â· ((aâ‚‚ Â· bâ‚ƒ) + (aâ‚ƒ Â· bâ‚‚)))
    assoc-fst aâ‚ bâ‚ aâ‚‚ bâ‚‚ aâ‚ƒ bâ‚ƒ = solve! R

    assoc-snd : (aâ‚ bâ‚ aâ‚‚ bâ‚‚ aâ‚ƒ bâ‚ƒ : A) â†’
        (((aâ‚ Â· aâ‚‚) - (bâ‚ Â· bâ‚‚)) Â· bâ‚ƒ) + (aâ‚ƒ Â· ((aâ‚ Â· bâ‚‚) + (aâ‚‚ Â· bâ‚)))
      â‰¡ (aâ‚ Â· ((aâ‚‚ Â· bâ‚ƒ) + (aâ‚ƒ Â· bâ‚‚))) + (((aâ‚‚ Â· aâ‚ƒ) - (bâ‚‚ Â· bâ‚ƒ)) Â· bâ‚)
    assoc-snd aâ‚ bâ‚ aâ‚‚ bâ‚‚ aâ‚ƒ bâ‚ƒ = solve! R

    conj-fst : (a b : A) â†’ (a Â· a) - (b Â· (- b)) â‰¡ a Â· a + b Â· b
    conj-fst a b = solve! R

    conj-snd : (a b : A) â†’ (a Â· (- b)) + (a Â· b) â‰¡ 0r
    conj-snd a b = solve! R

  ----------------------------------------------------------------------
  -- 1.  Brahmagupta: the norm is multiplicative
  ----------------------------------------------------------------------

  N-âŠ— : (u v : Pair) â†’ N (u âŠ— v) â‰¡ N u Â· N v
  N-âŠ— u v = brahmagupta (fst u) (snd u) (fst v) (snd v)

  ----------------------------------------------------------------------
  -- 2.  (Pair, âŠ—, one) is a commutative monoid
  ----------------------------------------------------------------------

  âŠ—-idÊ³ : (u : Pair) â†’ u âŠ— one â‰¡ u
  âŠ—-idÊ³ u = Î£PathP (idÊ³-fst (fst u) (snd u) , idÊ³-snd (fst u) (snd u))

  âŠ—-comm : (u v : Pair) â†’ u âŠ— v â‰¡ v âŠ— u
  âŠ—-comm u v = Î£PathP ( comm-fst (fst u) (snd u) (fst v) (snd v)
                      , comm-snd (fst u) (snd u) (fst v) (snd v) )

  âŠ—-assoc : (u v w : Pair) â†’ (u âŠ— v) âŠ— w â‰¡ u âŠ— (v âŠ— w)
  âŠ—-assoc u v w =
    Î£PathP ( assoc-fst (fst u) (snd u) (fst v) (snd v) (fst w) (snd w)
           , assoc-snd (fst u) (snd u) (fst v) (snd v) (fst w) (snd w) )

  âŠ—-conj : (u : Pair) â†’ u âŠ— conj u â‰¡ (N u , 0r)
  âŠ—-conj u = Î£PathP (conj-fst (fst u) (snd u) , conj-snd (fst u) (snd u))

  ----------------------------------------------------------------------
  -- 3.  THE CONTRAST WITH `SuccessorIsNotTropical`.
  --
  -- On the line, `disjoint-support`: the successor shares no coordinate
  -- with its argument in the multiplicative chart.  On the circle, the
  -- successor multiplies the norm by a constant.  Total locality.
  ----------------------------------------------------------------------

  rot : Pair â†’ Pair â†’ Pair
  rot g u = u âŠ— g

  rot-norm : (g u : Pair) â†’ N (rot g u) â‰¡ N u Â· N g
  rot-norm g u = N-âŠ— u g

  ----------------------------------------------------------------------
  -- 4.  Triples: closed under bhvan, generated by squaring
  ----------------------------------------------------------------------

  IsTriple : Pair â†’ A â†’ Type â„“
  IsTriple u z = N u â‰¡ z Â· z

  triple-âŠ— : (u v : Pair) (z w : A)
           â†’ IsTriple u z â†’ IsTriple v w â†’ IsTriple (u âŠ— v) (z Â· w)
  triple-âŠ— u v z w hu hv = N-âŠ— u v âˆ™ congâ‚‚ _Â·_ hu hv âˆ™ sq-Â· z w

  -- Euclid's parametrisation IS squaring in this monoid
  gen : Pair â†’ Pair
  gen t = t âŠ— t

  euclid : (t : Pair) â†’ IsTriple (gen t) (N t)
  euclid t = N-âŠ— t t

  -- THE TRANSITION MAP: the parametrisation intertwines the two
  -- composition laws, so parameter chart and triple chart are one chart.
  gen-hom : (s t : Pair) â†’ gen (s âŠ— t) â‰¡ gen s âŠ— gen t
  gen-hom s t =
      âŠ—-assoc s t (s âŠ— t)
    âˆ™ cong (s âŠ—_) ( sym (âŠ—-assoc t s t)
                  âˆ™ cong (_âŠ— t) (âŠ—-comm t s)
                  âˆ™ âŠ—-assoc s t t )
    âˆ™ sym (âŠ—-assoc s s (t âŠ— t))

  ----------------------------------------------------------------------
  -- 5.  Norm-one rotations are equivalences (Voevodsky), and their
  --     structured defect for the norm vanishes (Delta 15).
  ----------------------------------------------------------------------

  rot-invË¡ : (g u : Pair) â†’ N g â‰¡ 1r â†’ rot (conj g) (rot g u) â‰¡ u
  rot-invË¡ g u h =
      âŠ—-assoc u g (conj g)
    âˆ™ cong (u âŠ—_) (âŠ—-conj g âˆ™ cong (Î» x â†’ (x , 0r)) h)
    âˆ™ âŠ—-idÊ³ u

  rot-invÊ³ : (g u : Pair) â†’ N g â‰¡ 1r â†’ rot g (rot (conj g) u) â‰¡ u
  rot-invÊ³ g u h =
      âŠ—-assoc u (conj g) g
    âˆ™ cong (u âŠ—_) ( âŠ—-comm (conj g) g
                  âˆ™ âŠ—-conj g
                  âˆ™ cong (Î» x â†’ (x , 0r)) h )
    âˆ™ âŠ—-idÊ³ u

  rotIso : (g : Pair) â†’ N g â‰¡ 1r â†’ Iso Pair Pair
  Iso.fun      (rotIso g h)   = rot g
  Iso.inv      (rotIso g h)   = rot (conj g)
  Iso.rightInv (rotIso g h) u = rot-invÊ³ g u h
  Iso.leftInv  (rotIso g h) u = rot-invË¡ g u h

  rotEquiv : (g : Pair) â†’ N g â‰¡ 1r â†’ Pair â‰ƒ Pair
  rotEquiv g h = isoToEquiv (rotIso g h)

  -- univalence: a translation of the circle IS an identification of the
  -- circle with itself
  rotPath : (g : Pair) â†’ N g â‰¡ 1r â†’ Pair â‰¡ Pair
  rotPath g h = ua (rotEquiv g h)

  -- and it carries the structure exactly: zero structured defect
  rot-preserves-N : (g : Pair) â†’ N g â‰¡ 1r â†’ (u : Pair) â†’ N (rot g u) â‰¡ N u
  rot-preserves-N g h u = rot-norm g u âˆ™ cong (N u Â·_) h âˆ™ Â·-one (N u)

  Defect : (g : Pair) â†’ N g â‰¡ 1r â†’ Type â„“
  Defect g h = (Î» u â†’ N (rot g u)) â‰¡ N

  defect-vanishes : (g : Pair) (h : N g â‰¡ 1r) â†’ Defect g h
  defect-vanishes g h = funExt (rot-preserves-N g h)

------------------------------------------------------------------------
-- 6.  It runs.  Over â, by computation.
--
--   gen (2,1)        = (3,4)          â” the 3-4-5 triple, by squaring
--   (3,4) âŠ— (5,12)   = (âˆ’33,56)       â” 33Â² + 56Â² = 65Â² = (5Â13)Â²
--
-- Triples compose.  The two smallest primitive triples produce a third
-- by Brahmagupta's law, and its hypotenuse is the product of theirs.
------------------------------------------------------------------------

open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open Circle â„¤CommRing

tâ‚‚â‚ : Pair
tâ‚‚â‚ = pos 2 , pos 1

gen-2-1 : gen tâ‚‚â‚ â‰¡ (pos 3 , pos 4)
gen-2-1 = refl

tri345 : Pair
tri345 = pos 3 , pos 4

tri51213 : Pair
tri51213 = pos 5 , pos 12

composite : tri345 âŠ— tri51213 â‰¡ (negsuc 32 , pos 56)
composite = refl

-- and its norm is 65Â², the product of the two hypotenuses
composite-norm : N (tri345 âŠ— tri51213) â‰¡ pos 4225
composite-norm = refl

composite-is-triple : IsTriple (tri345 âŠ— tri51213) (pos 65)
composite-is-triple = refl
