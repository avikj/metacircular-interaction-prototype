{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà•ààà°-àà°àààµ â” the bit returns exactly on the alphabet.  The guess
-- aksara (parity w) â‰¡ w, that a number is determined
-- by its syllable.  Pigala's own machinery says what is true instead
-- (Chandastra, ~300 BCE, the laghu/guru binary; the host module is
-- the corpus's checked prastra):
--
--   1. parity is TWO-PERIODIC: parity (2 + w) â‰¡ parity w â” definitional,
--      so the composite aksara âˆ˜ parity is the bit of w, not w.
--   2. The composite returns EXACTLY on the alphabet {0, 1}: the
--      residues that name themselves.  Everything above the alphabet is
--      compressed onto it, and the fibre of "returned" is precisely the
--      two canonical residues â” the syllable IS the remainder mod 2,
--      and only the remainders return.
--
-- Deeper than the witness (aksara (parity 2) = 0 â‰ 2): the return set
-- is characterised, both inclusions, no induction needed beyond the
-- host's own â” aksara lands in {0,1} by a case split, so anything the
-- composite fixes was already a bit.  àààà à°à•àà: the remainder is what
-- survives the quotient, and here the remainder is the alphabet.
------------------------------------------------------------------------

module Ratri.Nirdharana_PingalaPrastara_AksaraParityReturnsExactlyOnTheAlphabet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; zero; suc)
open import Cubical.Data.Sum using (_âŠŽ_; inl; inr)
open import PingalaPrastara using (Syllable; laghu; guru; aksara; parity)

-- 1 Â two-periodicity, definitional:
parity-two-periodic : (w : â„•) â†’ parity (suc (suc w)) â‰¡ parity w
parity-two-periodic w = refl

-- 2a Â the alphabet returns:
returns-at-0 : aksara (parity 0) â‰¡ 0
returns-at-0 = refl

returns-at-1 : aksara (parity 1) â‰¡ 1
returns-at-1 = refl

-- 2b Â only the alphabet returns: whatever the composite fixes is a bit.
--     Case on the syllable â” aksara's image is {0,1}, so a fixed point
--     of the composite was already 0 or 1.
returns-only-on-alphabet : (w : â„•) â†’ aksara (parity w) â‰¡ w â†’ (w â‰¡ 0) âŠŽ (w â‰¡ 1)
returns-only-on-alphabet w p = lands (parity w) p
  where
  lands : (s : Syllable) â†’ aksara s â‰¡ w â†’ (w â‰¡ 0) âŠŽ (w â‰¡ 1)
  lands laghu q = inl (sym q)
  lands guru  q = inr (sym q)
