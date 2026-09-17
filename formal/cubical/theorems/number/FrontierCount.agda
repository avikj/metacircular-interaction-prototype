{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FrontierCount
--
-- The assembly `CoprimePowersN` Â§5 left named: the walk's residue count at
-- a GENERAL frontier, as one term.
--
--     frontier-count :
--       (es : List Entry) â’ AllPrime es â’ Distinct es
--       â’ Fin (prodOf es) â‰ VecOf es
--
-- Given a list of (prime, exponent) pairs with distinct primes, the
-- residue vector against those prime powers has exactly as many values as
-- their product.  No frontier is named; `WalkObservationCount`'s
-- hand-composed three steps at frontier 8 were the special case.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT MAKES IT GO
--
-- `CoprimePowers.bez-mul`.  Coprimality to each factor gives coprimality
-- to the product, by one ring identity and no primality â” so the head's
-- coprimality to the whole tail product (`bezHead`) is a fold, and the
-- CRT chain is then an induction with nothing arithmetic left in it.
--
-- Primality enters exactly once, at `primesâ’coprime-powers`, to produce
-- the base certificate for two distinct primes.  Everything after that is
-- the certificate composing.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- That the walk's installs, as a list, satisfy `AllPrime` and `Distinct`
-- at every frontier.  `WalkPrimePowers.installs-are-prime-powers` says
-- each install is a prime power; turning the install STREAM into a list
-- with distinct bases is a statement about the walk's dynamics, not about
-- arithmetic, and is not proved here.  What is closed is that the count
-- follows from those hypotheses with no further arithmetic input.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module FrontierCount where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; isContrâ†’Equiv)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; _^_)
open import Cubical.Data.Nat.GCD using (isGCD)
open import Cubical.Data.Int using (â„¤ ; pos)
open import Cubical.Data.Int.Properties using (posÂ·pos)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (isContrFin1)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open import FinCardinality using (crtEquiv)
open import WalkJumps using (IsPrime)
open import CoprimePowers using (module Bezout)
open import CoprimePowersN
  using (Bezâ†’isGCD ; isGCDâ†’Bez ; primesâ†’coprime-powers)

open Bezout â„¤CommRing using (Bez ; bez-one ; bez-mul)

------------------------------------------------------------------------
-- 1.  Frontiers as lists of (prime, exponent)
------------------------------------------------------------------------

Entry : Type
Entry = â„• Ã— â„•

prodOf : List Entry â†’ â„•
prodOf []             = 1
prodOf ((p , i) âˆ· es) = (p ^ i) Â· prodOf es

VecOf : List Entry â†’ Type
VecOf []             = Unit
VecOf ((p , i) âˆ· es) = Fin (p ^ i) Ã— VecOf es

AllPrime : List Entry â†’ Type
AllPrime []             = Unit
AllPrime ((p , _) âˆ· es) = IsPrime p Ã— AllPrime es

FreshFrom : â„• â†’ List Entry â†’ Type
FreshFrom p []             = Unit
FreshFrom p ((q , _) âˆ· es) = (Â¬ (p â‰¡ q)) Ã— FreshFrom p es

Distinct : List Entry â†’ Type
Distinct []             = Unit
Distinct ((p , _) âˆ· es) = FreshFrom p es Ã— Distinct es

------------------------------------------------------------------------
-- 2.  Positivity, carried as a successor witness
------------------------------------------------------------------------

Pos : â„• â†’ Type
Pos a = Î£[ m âˆˆ â„• ] (a â‰¡ suc m)

pos-Â· : (a b : â„•) â†’ Pos a â†’ Pos b â†’ Pos (a Â· b)
pos-Â· a b (m , pa) (n , pb) =
    (n + m Â· suc n)
  , congâ‚‚ _Â·_ pa pb

pos-^ : (p : â„•) â†’ Pos p â†’ (i : â„•) â†’ Pos (p ^ i)
pos-^ p _  zero    = 0 , refl
pos-^ p pp (suc i) = pos-Â· p (p ^ i) pp (pos-^ p pp i)

primeâ†’Pos : (p : â„•) â†’ IsPrime p â†’ Pos p
primeâ†’Pos zero          pr = Empty.rec (Â¬-<-zero (pr .fst))
  where open import Cubical.Data.Empty as Empty using (âŠ¥)
        open import Cubical.Data.Nat.Order using (Â¬-<-zero)
primeâ†’Pos (suc p)       _  = p , refl

pos-prod : (es : List Entry) â†’ AllPrime es â†’ Pos (prodOf es)
pos-prod []             _          = 0 , refl
pos-prod ((p , i) âˆ· es) (pp , rest) =
  pos-Â· (p ^ i) (prodOf es) (pos-^ p (primeâ†’Pos p pp) i) (pos-prod es rest)

------------------------------------------------------------------------
-- 3.  The head is coprime to the whole tail product â” a fold of `bez-mul`
------------------------------------------------------------------------

bezHead : (p i : â„•) â†’ IsPrime p â†’ (es : List Entry)
        â†’ AllPrime es â†’ FreshFrom p es
        â†’ Bez (pos (p ^ i)) (pos (prodOf es))
bezHead p i pp []             _           _              = bez-one (pos (p ^ i))
bezHead p i pp ((q , j) âˆ· es) (qq , rest) (pâ‰¢q , fresh) =
  subst (Bez (pos (p ^ i))) (sym (posÂ·pos (q ^ j) (prodOf es)))
    (bez-mul {a = pos (p ^ i)} {b = pos (q ^ j)} {c = pos (prodOf es)}
             (isGCDâ†’Bez (p ^ i) (q ^ j)
                (primesâ†’coprime-powers p q pp qq pâ‰¢q i j))
             (bezHead p i pp es rest fresh))

headCoprime : (p i : â„•) â†’ IsPrime p â†’ (es : List Entry)
            â†’ AllPrime es â†’ FreshFrom p es
            â†’ isGCD (p ^ i) (prodOf es) 1
headCoprime p i pp es rest fresh =
  Bezâ†’isGCD (p ^ i) (prodOf es) (bezHead p i pp es rest fresh)

------------------------------------------------------------------------
-- 4.  CRT at positive moduli, and the chain
------------------------------------------------------------------------

crtPos : (a b : â„•) â†’ Pos a â†’ Pos b â†’ isGCD a b 1
       â†’ Fin (a Â· b) â‰ƒ (Fin a Ã— Fin b)
crtPos a b (m , pa) (n , pb) cop =
  subst2 (Î» u v â†’ Fin (u Â· v) â‰ƒ (Fin u Ã— Fin v)) (sym pa) (sym pb)
    (crtEquiv m n (subst2 (Î» u v â†’ isGCD u v 1) pa pb cop))

frontier-count :
  (es : List Entry) â†’ AllPrime es â†’ Distinct es
  â†’ Fin (prodOf es) â‰ƒ VecOf es
frontier-count []             _           _              =
  isContrâ†’Equiv isContrFin1 isContrUnit
frontier-count ((p , i) âˆ· es) (pp , rest) (fresh , dist) =
  compEquiv
    (crtPos (p ^ i) (prodOf es)
            (pos-^ p (primeâ†’Pos p pp) i) (pos-prod es rest)
            (headCoprime p i pp es rest fresh))
    (â‰ƒ-Ã— (idEquiv (Fin (p ^ i))) (frontier-count es rest dist))
  where open import Cubical.Foundations.Equiv using (compEquiv ; idEquiv)
        open import Cubical.Data.Sigma using (â‰ƒ-Ã—)

------------------------------------------------------------------------
-- 5.  Frontier 8 again, now as an instance rather than a construction.
--
--   2Â³ Â 3 Â 5 Â 7 = 840
------------------------------------------------------------------------

open import PrimalityDecision using (decIsPrime)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)
open import Cubical.Data.Bool using (Bool ; true ; false ; falseâ‰¢true)
open import Cubical.Data.Empty as E using (âŠ¥)
open import Cubical.Data.Nat using (znots ; injSuc)

isYes : {A : Type} â†’ Dec A â†’ Bool
isYes (yes _) = true
isYes (no  _) = false

fromDec : {A : Type} (d : Dec A) â†’ isYes d â‰¡ true â†’ A
fromDec (yes a) _ = a
fromDec (no  _) p = E.rec (falseâ‰¢true p)

frontier8 : List Entry
frontier8 = (2 , 3) âˆ· (3 , 1) âˆ· (5 , 1) âˆ· (7 , 1) âˆ· []

frontier8-prod : prodOf frontier8 â‰¡ 840
frontier8-prod = refl

frontier8-primes : AllPrime frontier8
frontier8-primes =
    fromDec (decIsPrime 2) refl
  , fromDec (decIsPrime 3) refl
  , fromDec (decIsPrime 5) refl
  , fromDec (decIsPrime 7) refl
  , tt

frontier8-count : Fin 840 â‰ƒ VecOf frontier8
frontier8-count =
  frontier-count frontier8 frontier8-primes frontier8-distinct
  where
  n2â‰¢3 : Â¬ (2 â‰¡ 3)
  n2â‰¢3 x = znots (injSuc (injSuc x))
  n2â‰¢5 : Â¬ (2 â‰¡ 5)
  n2â‰¢5 x = znots (injSuc (injSuc x))
  n2â‰¢7 : Â¬ (2 â‰¡ 7)
  n2â‰¢7 x = znots (injSuc (injSuc x))
  n3â‰¢5 : Â¬ (3 â‰¡ 5)
  n3â‰¢5 x = znots (injSuc (injSuc (injSuc x)))
  n3â‰¢7 : Â¬ (3 â‰¡ 7)
  n3â‰¢7 x = znots (injSuc (injSuc (injSuc x)))
  n5â‰¢7 : Â¬ (5 â‰¡ 7)
  n5â‰¢7 x = znots (injSuc (injSuc (injSuc (injSuc (injSuc x)))))

  frontier8-distinct : Distinct frontier8
  frontier8-distinct =
      (n2â‰¢3 , n2â‰¢5 , n2â‰¢7 , tt)
    , (n3â‰¢5 , n3â‰¢7 , tt)
    , (n5â‰¢7 , tt)
    , tt
    , tt

------------------------------------------------------------------------
-- 6.  What changed.
--
-- `WalkObservationCount` composed CRT three times by hand for one
-- frontier.  Here the frontier is data: a list of (prime, exponent)
-- pairs, primality read off `decIsPrime`, distinctness by computation,
-- and the count follows.  The arithmetic that made this impossible in the
-- earlier module â” coprimality of prime powers â” is `CoprimePowers` plus
-- `DistinctPrimesAreCoprime`, and it enters here exactly once.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PROVENANCE CORRECTION, 2026-08-18.
--
-- This module says "the Chinese remainder theorem" for the simultaneous
-- congruence result it runs on, and that name was used without being
-- checked â” in a session whose brief was to build from Indian sources and
-- credit the origin rather than the restatement, and three modules after
-- building ryabhaa's kuaka by name.
--
-- The **kuaka** (*ryabhaya* 2.32â“33, 499 CE) is a general
-- constructive method for exactly this problem â” given remainders against
-- two moduli, produce the number â” and Brahmagupta (628) and Bhskara II
-- (1150) extend it.  The *Sun Zi Suanjing* (c. 3rdâ“5th c.) poses the
-- problem with a rule for a special case; Qin Jiushao's general method is
-- 1247.  Both traditions have it, and this file's own chain runs on the
-- Indian one: `CoprimePowers`, `BezoutIsGCD` and `CoprimePowersN` all
-- carry B©zout certificates, which is what the pulveriser returns.
--
-- Nothing mathematical changes.  The citation does.  See
------------------------------------------------------------------------
