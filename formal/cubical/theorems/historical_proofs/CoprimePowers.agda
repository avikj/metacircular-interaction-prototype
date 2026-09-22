{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CoprimePowers
--
-- `CRTChain` needs that the walk's installed prime
-- powers are pairwise coprime.  This is its algebra, and the
-- algebra is all of it â” no primality is needed, only that the BASES are
-- coprime.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
-- Coprimality is carried as a B©zout pair, which is what ryabhaa's
-- kuaka produces (`Kuttaka.bezout`, 499 CE, already checked here):
--
--     Bez a b  =  Î x, Î y,  aÂx + bÂy â‰¡ 1
--
-- and then
--
--     bez-mul       :  Bez a b â’ Bez a c â’ Bez a (b Â c)
--     bez-pow       :  Bez a b â’ (n : â•) â’ Bez a (b ^ n)
--     coprime-powers:  Bez a b â’ (m n : â•) â’ Bez (a ^ m) (b ^ n)
--
-- `bez-mul` is one polynomial identity:
--
--     (ax + by)(au + cv)  =  aÂ(axu + cxv + byu)  +  (bc)Â(yv)
--
-- so a B©zout certificate for `(a, bc)` is assembled from the two given
-- ones by multiplication.  Everything else is two inductions and a
-- symmetry.
--
-- Concretely, and this is the walk's own case: **8 and 9 are coprime
-- because 2 and 3 are**, with the certificate computed rather than
-- guessed (`bez-8-9`).
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY B‰ZOUT AND NOT `gcd`
--
-- Because the kuaka produces a certificate, not a predicate.  ryabhaa's
-- procedure returns the multipliers; `Kuttaka.bezout` returns them as a
-- term; and a certificate composes under multiplication by a ring
-- identity, where `isGCD` would need Euclid's lemma to do the same work.
-- Keeping the witness is what makes this module four theorems long
-- instead of a development.
--
-- That is the kuaka's own design: *"keep the remainder and recurse on
-- it"* returns a construction, and the construction is what composes.
--
-- This
-- module assumes coprime bases;
-- for the walk's actual moduli they are computed one gcd at a time
-- (`CRTChain.walk8-coprimes`).
------------------------------------------------------------------------

module CoprimePowers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)


------------------------------------------------------------------------
-- 1.  Coprimality as a kept certificate, over any commutative ring
------------------------------------------------------------------------

private
  variable
    â„“ : Level

module Bezout (R : CommRing â„“) where

  open CommRingStr (snd R)

  A : Type â„“
  A = fst R

  Bez : A â†’ A â†’ Type â„“
  Bez a b = Î£[ x âˆˆ A ] Î£[ y âˆˆ A ] ((a Â· x) + (b Â· y) â‰¡ 1r)

  pow : A â†’ â„• â†’ A
  pow a zero    = 1r
  pow a (suc n) = a Â· pow a n

  ----------------------------------------------------------------------
  -- 2.  The ring identities the whole module runs on
  ----------------------------------------------------------------------

  private
    symId : (a b x y : A) â†’ (b Â· y) + (a Â· x) â‰¡ (a Â· x) + (b Â· y)
    symId a b x y = solve! R

    oneId : (a : A) â†’ (a Â· 0r) + (1r Â· 1r) â‰¡ 1r
    oneId a = solve! R

    -- (ax + by)(au + cv) = a(axu + cxv + byu) + (bc)(yv)
    mulId : (a b c x y u v : A) â†’
        (a Â· (((a Â· x) Â· u) + (((c Â· x) Â· v) + ((b Â· y) Â· u))))
        + ((b Â· c) Â· (y Â· v))
      â‰¡ ((a Â· x) + (b Â· y)) Â· ((a Â· u) + (c Â· v))
    mulId a b c x y u v = solve! R

    unitId : (1r Â· 1r) â‰¡ 1r
    unitId = solve! R

  ----------------------------------------------------------------------
  -- 3.  The three closure laws
  ----------------------------------------------------------------------

  bez-sym : {a b : A} â†’ Bez a b â†’ Bez b a
  bez-sym {a} {b} (x , y , p) = y , x , symId a b x y âˆ™ p

  bez-one : (a : A) â†’ Bez a 1r
  bez-one a = 0r , 1r , oneId a

  -- THE COMPOSITION.  One polynomial identity assembles the certificate.
  bez-mul : {a b c : A} â†’ Bez a b â†’ Bez a c â†’ Bez a (b Â· c)
  bez-mul {a} {b} {c} (x , y , p) (u , v , q) =
      (((a Â· x) Â· u) + (((c Â· x) Â· v) + ((b Â· y) Â· u)))
    , (y Â· v)
    , ( mulId a b c x y u v
      âˆ™ congâ‚‚ _Â·_ p q
      âˆ™ unitId )

  bez-pow : {a b : A} â†’ Bez a b â†’ (n : â„•) â†’ Bez a (pow b n)
  bez-pow {a} _   zero    = bez-one a
  bez-pow     bab (suc n) = bez-mul bab (bez-pow bab n)

  -- THE STATEMENT `CRTChain` asked for.
  coprime-powers : {a b : A} â†’ Bez a b â†’ (m n : â„•) â†’ Bez (pow a m) (pow b n)
  coprime-powers bab m n =
    bez-sym (bez-pow (bez-sym (bez-pow bab n)) m)

------------------------------------------------------------------------
-- 4.  The walk's own case, computed over â.
--
--   2Â(âˆ’1) + 3Â1 = 1, so Bez 2 3;  hence Bez (2Â³) (3Â²), i.e. 8 and 9.
--
-- The certificate for 8 and 9 is not guessed â” it is what
-- `coprime-powers` builds out of the certificate for 2 and 3.
------------------------------------------------------------------------

open Bezout â„¤CommRing

bez-2-3 : Bez (pos 2) (pos 3)
bez-2-3 = negsuc 0 , pos 1 , refl

bez-8-9 : Bez (pow (pos 2) 3) (pow (pos 3) 2)
bez-8-9 = coprime-powers {a = pos 2} {b = pos 3} bez-2-3 3 2

-- and the bases really are 8 and 9
pow-2-3-is-8 : pow (pos 2) 3 â‰¡ pos 8
pow-2-3-is-8 = refl

pow-3-2-is-9 : pow (pos 3) 2 â‰¡ pos 9
pow-3-2-is-9 = refl

------------------------------------------------------------------------
-- 5.  The composition law.
--
-- Coprimality of powers follows from
-- coprimality of bases by one ring identity plus two inductions, with the
-- B©zout witness carried throughout â” which is the kuaka's output, not
-- a predicate reconstructed after the fact.
------------------------------------------------------------------------
