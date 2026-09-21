{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Factorisation
--
-- `FrontierDivides` Â§2 names the hard half of the universal property and
-- says why it is hard: it needs EXISTENCE OF PRIME FACTORISATION, which
-- no certificate-composition produces.  Here it is.
--
--     factorise : (n : â•) â’ 0 < n â’ Î[ ps ] (AllPrimeL ps — (prodL ps â‰¡ n))
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PRIOR ART
--
-- `CoprimeSplitting.primeDivisor` already provides the
-- atom â” `(n : â•) â’ 1 < n â’ Î[ p ] (IsPrime p — (p âˆ n))`, a fuelled
-- linear search with the fuel accounted for honestly in that module's
-- header.  Factorisation is that atom plus a descent, and the descent is
-- the only new thing here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE DESCENT
--
-- Peel a prime divisor `p` off `n`, leaving `c` with `c Â p â‰¡ n`.  Then
-- `c < n`, because `1 < p` and `0 < c` give `c < 2Âc â‰ pÂc â‰¡ n` â” and the
-- recursion is on `c`.  Fuel carries the termination, in the same style
-- as `primeDivisor-fuel`, because that is this lane's idiom for searches
-- whose bound is obvious and whose well-foundedness is not worth a
-- separate development.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS UNLOCKS
--
-- Every positive `n` is a product of primes, with the list as data.
------------------------------------------------------------------------

module Factorisation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-untrunc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (âŠ¥)

open import WalkJumps using (IsPrime)
open import CoprimeSplitting using (primeDivisor)

------------------------------------------------------------------------
-- 1.  Factorisations
------------------------------------------------------------------------

prodL : List â„• â†’ â„•
prodL []       = 1
prodL (p âˆ· ps) = p Â· prodL ps

AllPrimeL : List â„• â†’ Type
AllPrimeL []       = Unit
AllPrimeL (p âˆ· ps) = IsPrime p Ã— AllPrimeL ps

Factorisation : â„• â†’ Type
Factorisation n = Î£[ ps âˆˆ List â„• ] (AllPrimeL ps Ã— (prodL ps â‰¡ n))

------------------------------------------------------------------------
-- 2.  The descent step: peeling a prime strictly shrinks the cofactor
------------------------------------------------------------------------

private
  c<2c : (c : â„•) â†’ 0 < c â†’ c < 2 Â· c
  c<2c c 0<c = subst2 _â‰¤_ (+-comm c 1) (sym two-c) (â‰¤-k+ 0<c)
    where
    two-c : 2 Â· c â‰¡ c + c
    two-c = cong (c +_) (+-zero c)

  cofactor-shrinks : (c p n : â„•) â†’ 0 < c â†’ 1 < p â†’ c Â· p â‰¡ n â†’ c < n
  cofactor-shrinks c p n 0<c 1<p pc =
    subst (c <_) (Â·-comm p c âˆ™ pc) (<â‰¤-trans (c<2c c 0<c) (â‰¤-Â·k 1<p))

  cofactor-pos : (c p n : â„•) â†’ 0 < n â†’ c Â· p â‰¡ n â†’ 0 < c
  cofactor-pos zero    p n 0<n pc = Empty.rec (Â¬-<-zero (subst (0 <_) (sym pc) 0<n))
  cofactor-pos (suc c) p n _   _  = suc-â‰¤-suc zero-â‰¤

------------------------------------------------------------------------
-- 3.  THE THEOREM, by fuel â” this lane's idiom for a bounded search
------------------------------------------------------------------------

factorise-fuel : (fuel n : â„•) â†’ 0 < n â†’ n â‰¤ fuel â†’ Factorisation n
factorise-fuel zero    n 0<n nâ‰¤f = Empty.rec (Â¬-<-zero (<â‰¤-trans 0<n nâ‰¤f))
factorise-fuel (suc f) n 0<n nâ‰¤f = go (splitâ„•-â‰¤ n 1)
  where
  go : ((n â‰¤ 1) âŠŽ (1 < n)) â†’ Factorisation n
  go (inl nâ‰¤1) = [] , tt , â‰¤-antisym 0<n nâ‰¤1
  go (inr 1<n) = peel (primeDivisor n 1<n)
    where
    peel : Î£[ p âˆˆ â„• ] (IsPrime p Ã— (p âˆ£ n)) â†’ Factorisation n
    peel (p , pp , pâˆ£n) = split (âˆ£-untrunc pâˆ£n)
      where
      split : Î£[ c âˆˆ â„• ] (c Â· p â‰¡ n) â†’ Factorisation n
      split (c , pc) =
        (p âˆ· rec .fst) , (pp , rec .snd .fst) ,
        (cong (p Â·_) (rec .snd .snd) âˆ™ Â·-comm p c âˆ™ pc)
        where
        0<c : 0 < c
        0<c = cofactor-pos c p n 0<n pc

        c<n : c < n
        c<n = cofactor-shrinks c p n 0<c (pp .fst) pc

        rec : Factorisation c
        rec = factorise-fuel f c 0<c (pred-â‰¤-pred (<â‰¤-trans c<n nâ‰¤f))

factorise : (n : â„•) â†’ 0 < n â†’ Factorisation n
factorise n 0<n = factorise-fuel n n 0<n â‰¤-refl

------------------------------------------------------------------------
-- 4.  It runs.
------------------------------------------------------------------------

fact-12 : Factorisation 12
fact-12 = factorise 12 (suc-â‰¤-suc zero-â‰¤)

fact-12-product : prodL (fact-12 .fst) â‰¡ 12
fact-12-product = fact-12 .snd .snd

------------------------------------------------------------------------
-- 5.  Where this sits.
--
--   `CoprimeSplitting.primeDivisor`   every n > 1 has a prime divisor
--   here                              hence a factorisation
--   `FrontierDivides`                 coprime divisors multiply (Gauss)
--   `FrontierCount`                   and the residue count is CRT
------------------------------------------------------------------------
