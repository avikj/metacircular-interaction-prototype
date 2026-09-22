{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PingalaIsOptimal
--
-- The same two theorems that make the walk optimal make Pigala's
-- naa/uddia optimal, and they were separated by about 2300 years.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS ALREADY HERE
--
-- `formal/cubical/Pingala.agda` carries the Chandastra's pratyaya as
-- checked types, including
--
--     uddistaIso : (n : ‚ï) ‚í Iso (Vak n) (Fin (sankhya n))
--
-- whose forward map is the explicit uddia algorithm (pattern ‚¶ row
-- number), whose inverse is the explicit naa halving algorithm (row
-- number ‚¶ pattern), and whose round trips are both proved.  That is a
-- LOSSLESS OBSERVATION WITH AN EXPLICIT DECODE,
-- written down around 300 BCE.
--
-- `LosslessLowerBound` carries the other half: any lossless
-- observation needs at least as many outcomes as it has inputs.
--
-- Neither module knows about the other.  This one is the sentence.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE STATEMENT
--
--     pingala-optimal :
--       (n : ‚ï) (Y : FinSet ‚ì-zero) (obs : Vak n ‚í Y .fst)
--       ‚í Injective obs ‚í sankhya n ‚â card Y
--
-- No scheme whatever ‚î not uddia, not a cleverer one, not one nobody
-- has thought of ‚î observes the metres of n syllables losslessly with
-- fewer than sakhy n = 2‚ø outcomes.  And `uddistaIso` has exactly that
-- many.  Pigala's algorithm is optimal, and the proof of optimality is
-- one instantiation of a bound proved for every observation scheme.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS IS NOT A DECORATIVE PAIRING
--
-- The walk and the pratyaya are the same problem: enumerate a finite
-- family losslessly, in an order, with an index you can convert back and
-- forth.  The walk's state is a residue vector and its count is CRT
-- (`WalkObservationCount`); Pigala's state is a binary pattern and his
-- count is sakhy.  Both are optimal, both for the same reason, and the
-- reason is pigeonhole plus an explicit decode.
--
-- The difference is that Pigala SUPPLIED the decode.  naa is not a
-- proof that the enumeration is invertible; it is the inverse, as an
-- algorithm, with its own name.  That is the standard this corpus's
-- `FactorsThrough` results have mostly not met ‚î they establish that a
-- decode exists or does not, and `Pingala.agda` exhibits one.
------------------------------------------------------------------------

module PingalaIsOptimal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.Equiv using (compEquiv ; invEquiv)
open import Cubical.Functions.Embedding using (injEmbedding)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Nat.Order using (_‚â§_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet using (FinSet ; card ; isFinSet‚ÜíisSet)
open import Cubical.Data.FinSet.Cardinality using (card‚Ü™Inequality')
open import Cubical.HITs.PropositionalTruncation using (‚à£_‚à£‚ÇÅ)
open import Cubical.Data.SumFin using () renaming (SumFin‚âÉFin to sumFin‚âÉFin)

open import Cubical.Data.Nat using (suc ; _+_)
open import PingalaPrastara using (Vak ; sankhya ; uddistaIso ; Metre ; matra ; matraCount ; matraRecurrence)

------------------------------------------------------------------------
-- 1.  The metres of n syllables, as a finite set of size sakhy n
------------------------------------------------------------------------

Injective : {A B : Type} ‚Üí (A ‚Üí B) ‚Üí Type
Injective {A = A} f = {x y : A} ‚Üí f x ‚â° f y ‚Üí x ‚â° y

VakFinSet : (n : ‚Ñï) ‚Üí FinSet ‚Ñì-zero
VakFinSet n =
  Vak n , sankhya n ,
  ‚à£ compEquiv (isoToEquiv (uddistaIso n)) (invEquiv (sumFin‚âÉFin (sankhya n))) ‚à£‚ÇÅ

card-Vak : (n : ‚Ñï) ‚Üí card (VakFinSet n) ‚â° sankhya n
card-Vak n = refl

------------------------------------------------------------------------
-- 2.  THE BOUND, at Pigala's problem
------------------------------------------------------------------------

pingala-optimal :
  (n : ‚Ñï) (Y : FinSet ‚Ñì-zero) (obs : Vak n ‚Üí Y .fst)
  ‚Üí Injective obs
  ‚Üí sankhya n ‚â§ card Y
pingala-optimal n Y obs inj =
  card‚Ü™Inequality' (VakFinSet n) Y obs
    (injEmbedding (isFinSet‚ÜíisSet (Y .snd)) inj)

------------------------------------------------------------------------
-- 3.  And uddia attains it, because it is an equivalence.
--
-- `uddistaIso n : Iso (Vak n) (Fin (sankhya n))` ‚î the target has
-- sakhy n elements, which by ¬ß2 is the minimum.  Bound and attainment,
-- both terms.
--
-- The sakhy recurrence sakhy (n+1) = sakhy n + sakhy n is
-- `Pingala.sankhya` by definition, so the count is the doubling Pigala
-- states, not a translation of it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  The mtr-vtta case.
--
-- `Pingala.matraCount : (n : ‚ï) ‚í Iso (Metre n) (Fin (matra n))` is the
-- same shape for metres of fixed DURATION rather than fixed syllable
-- count, and `Pingala.matraRecurrence` proves
--
--     matra (n+2) ‚â° matra (n+1) + matra n
--
-- which is Virahka's mtrmeru (c. 600‚ì800 CE), four centuries before
-- the *Liber Abaci*.  So the bound applies verbatim, and it says:
--
--     no lossless observation of the metres of duration n has fewer
--     than mtr n outcomes,
--
-- with Virahka's number appearing as an information-theoretic minimum
-- rather than as a count.
------------------------------------------------------------------------

MetreFinSet : (n : ‚Ñï) ‚Üí FinSet ‚Ñì-zero
MetreFinSet n =
  Metre n , matra n ,
  ‚à£ compEquiv (isoToEquiv (matraCount n)) (invEquiv (sumFin‚âÉFin (matra n))) ‚à£‚ÇÅ

virahanka-optimal :
  (n : ‚Ñï) (Y : FinSet ‚Ñì-zero) (obs : MetreFinSet n .fst ‚Üí Y .fst)
  ‚Üí Injective obs
  ‚Üí matra n ‚â§ card Y
virahanka-optimal n Y obs inj =
  card‚Ü™Inequality' (MetreFinSet n) Y obs
    (injEmbedding (isFinSet‚ÜíisSet (Y .snd)) inj)

-- the mtrmeru recurrence, quoted from `Pingala` so the number in the
-- bound is visibly Virahka's and not a re-derivation
matrameru-recurrence : (n : ‚Ñï) ‚Üí matra (suc (suc n)) ‚â° matra (suc n) + matra n
matrameru-recurrence = matraRecurrence
