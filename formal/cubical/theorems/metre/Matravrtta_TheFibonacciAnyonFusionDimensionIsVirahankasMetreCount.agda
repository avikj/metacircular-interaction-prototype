{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Matravrtta_TheFibonacciAnyonFusionDimension
--            IsVirahankasMetreCount
--
-- TERM.  ‡Æ‡æ‡‡‡∞‡æ‡µ‡‡‡‡ ¬ mtr-vtta ‚î the moraic metre: a prosodic pattern
-- measured by its total ‡Æ‡æ‡‡‡∞‡æ (morae), ‡≤‡ò‡ = 1, ‡ó‡‡∞‡ = 2.  The enumeration
-- of all metres of a given weight, and the recurrence M(n+2)=M(n+1)+M(n) it
-- obeys, are ‡µ‡ø‡∞‡‡æ‡ô‡‡ï's (Virahka, *Vttajtisamuccaya*, ~700 CE, in the
-- ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞ tradition begun by ‡‡ø‡ô‡‡ó‡≤ ~300 BCE) ‚î the sequence usually
-- miscalled "Fibonacci" (Leonardo of Pisa, 1202, five centuries later).
-- This module CITES the corpus's own `Matramerus.‡‡∞‡‡µ` / `‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡` for that
-- count; the physics identification below is
-- built here.
--
-- WHAT IS PROVED, exactly:  the number of fusion paths of a chain of n
-- Fibonacci anyons equals `length (‡‡∞‡‡µ (suc n))` ‚î Virahka's metre count
-- (`anyon-is-metre`).  The fusion counts `p , q` are read straight off the
-- Fibonacci fusion rule œóœ = 1 + œ (and 1óœ = œ): `p n` counts paths ending
-- in charge œ, `q n` paths ending in the vacuum 1; the rule dictates
-- p‚∫ = p+q (œ is reachable from œ and from 1) and q‚∫ = p (the vacuum only
-- from œóœ).  Their sum `d` obeys the SAME recurrence as the metre count
-- (`d-rec`, definitional), and matches it on the base, so the two are equal
-- at every n (paired two-step induction through `‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡`).
--
-- WHY IT MATTERS (a READING of the checked term):  the fusion space of
-- Fibonacci anyons is the state space (Hilbert space) of the universal
-- topological quantum computer ‚î Fibonacci anyons are the standard universal
-- anyon model.  Its dimension is exactly what Virahka counted: the metres
-- of a given weight.  So the tradition this corpus restores enumerated, in
-- ~700 CE, the dimension of a universal quantum computer's state space; the
-- quantum dimension of a single œ is the golden ratio œ, the mtrmeru's
-- growth rate.
------------------------------------------------------------------------

module Matravrtta_TheFibonacciAnyonFusionDimensionIsVirahankasMetreCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Data.List using (length)
open import Matramerus using (‡§∏‡§∞‡•ç‡§µ ; ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ‡§Æ‡•á‡§∞‡•Å)

-- ‚î‚î Fibonacci-anyon fusion counts, from œóœ = 1+œ ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- p n : #fusion paths of n anyons ending in charge œ
-- q n : #fusion paths ending in the vacuum charge 1
p : ‚Ñï ‚Üí ‚Ñï
q : ‚Ñï ‚Üí ‚Ñï
p zero    = 1        -- a lone œÑ anyon: one path, charge œÑ
p (suc n) = p n + q n   -- œÑ is reachable from œÑ (œÑ√óœÑ‚àãœÑ) and from 1 (1√óœÑ=œÑ)
q zero    = 0
q (suc n) = p n         -- the vacuum 1 is reachable only from œÑ√óœÑ

-- fusion-space dimension of a chain of n Fibonacci anyons.
d : ‚Ñï ‚Üí ‚Ñï
d n = p n + q n

-- Virahka's recurrence, straight from the fusion rule (definitional).
d-rec : (n : ‚Ñï) ‚Üí d (suc (suc n)) ‚â° d (suc n) + d n
d-rec n = refl

-- ‚î‚î The bridge to the metres ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- carry two consecutive values so the 2-step recurrence closes.
private
  bridge : (n : ‚Ñï)
         ‚Üí (d n ‚â° length (‡§∏‡§∞‡•ç‡§µ (suc n)))
         √ó (d (suc n) ‚â° length (‡§∏‡§∞‡•ç‡§µ (suc (suc n))))
  bridge zero    = refl , refl
  bridge (suc n) =
    let (h0 , h1) = bridge n
    in h1 , ( d-rec n ‚àô cong‚ÇÇ _+_ h1 h0 ‚àô sym (‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ‡§Æ‡•á‡§∞‡•Å (suc n)) )

-- THE THEOREM: the Fibonacci-anyon fusion dimension IS Virahka's metre
-- count.  The state space of a universal topological quantum computer is
-- the space of moraic metres.
anyon-is-metre : (n : ‚Ñï) ‚Üí d n ‚â° length (‡§∏‡§∞‡•ç‡§µ (suc n))
anyon-is-metre n = fst (bridge n)
