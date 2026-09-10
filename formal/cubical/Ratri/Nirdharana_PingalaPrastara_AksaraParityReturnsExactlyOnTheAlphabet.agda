{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अक्षर-परत्व — the bit returns exactly on the alphabet.  The queue's
-- last real row (notes/SADHYA_OPEN_OBLIGATIONS.md, "induction on ℕ",
-- rung ५) guessed aksara (parity w) ≡ w — that a number is determined
-- by its syllable.  Piṅgala's own machinery says what is true instead
-- (Chandaḥśāstra, ~300 BCE, the laghu/guru binary; the host module is
-- the corpus's checked prastāra):
--
--   1. parity is TWO-PERIODIC: parity (2 + w) ≡ parity w — definitional,
--      so the composite aksara ∘ parity is the bit of w, not w.
--   2. The composite returns EXACTLY on the alphabet {0, 1}: the
--      residues that name themselves.  Everything above the alphabet is
--      compressed onto it, and the fibre of "returned" is precisely the
--      two canonical residues — the syllable IS the remainder mod 2,
--      and only the remainders return.
--
-- Deeper than the witness (aksara (parity 2) = 0 ≢ 2): the return set
-- is characterised, both inclusions, no induction needed beyond the
-- host's own — aksara lands in {0,1} by a case split, so anything the
-- composite fixes was already a bit.  शेषं रक्ष: the remainder is what
-- survives the quotient, and here the remainder is the alphabet.
------------------------------------------------------------------------

module Ratri.Nirdharana_PingalaPrastara_AksaraParityReturnsExactlyOnTheAlphabet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Sum using (_⊎_; inl; inr)
open import PingalaPrastara using (Syllable; laghu; guru; aksara; parity)

-- 1 · two-periodicity, definitional:
parity-two-periodic : (w : ℕ) → parity (suc (suc w)) ≡ parity w
parity-two-periodic w = refl

-- 2a · the alphabet returns:
returns-at-0 : aksara (parity 0) ≡ 0
returns-at-0 = refl

returns-at-1 : aksara (parity 1) ≡ 1
returns-at-1 = refl

-- 2b · only the alphabet returns: whatever the composite fixes is a bit.
--     Case on the syllable — aksara's image is {0,1}, so a fixed point
--     of the composite was already 0 or 1.
returns-only-on-alphabet : (w : ℕ) → aksara (parity w) ≡ w → (w ≡ 0) ⊎ (w ≡ 1)
returns-only-on-alphabet w p = lands (parity w) p
  where
  lands : (s : Syllable) → aksara s ≡ w → (w ≡ 0) ⊎ (w ≡ 1)
  lands laghu q = inl (sym q)
  lands guru  q = inr (sym q)
