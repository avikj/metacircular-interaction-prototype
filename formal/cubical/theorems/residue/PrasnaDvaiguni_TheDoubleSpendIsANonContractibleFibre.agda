{-# OPTIONS --cubical --safe #-}

-- ààà°ààà¨-à¦ààµàˆà—àààà¯ â” a question put to the kernel, not narrated.
-- The exclusive-resource design (docs/build/ExclusiveResourceOrdering_â¦)
-- rests on ONE load-bearing claim: a valid spend keeps the source
-- fibre contractible, and a DOUBLE spend forces it non-contractible.
-- Here that claim is stated so the kernel answers, not the carrier.
--
-- Model, minimal and honest: a coin source is a point `src : A`.
-- A spend of it is a point of its fibre under the ledger map
-- `f : A â’ B` at the source's image â” i.e. a point of `singl (f src)`,
-- which is `Î[ b ] (f src â‰¡ b)`.  A SINGLE valid spend is the canonical
-- inhabitant `(f src , refl)`.  The claim: the type of spends is
-- contractible, so any two spends are ALREADY EQUAL â” there is no room
-- for a second, distinct spend.  A "double spend" would be two spends
-- p q with p â‰ q; the kernel is asked whether that can coexist with
-- contractibility.

module PrasnaDvaiguni_TheDoubleSpendIsANonContractibleFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContrâ†’isProp)
open import Cubical.Relation.Nullary using (Â¬_)

module _ {â„“} {A B : Type â„“} (f : A â†’ B) (src : A) where

  Spend : Type â„“
  Spend = singl (f src)

  -- the kernel already knows this fibre is contractible (no hypothesis)
  spend-isContr : isContr Spend
  spend-isContr = isContrSingl (f src)

  -- THE ANSWER, kernel-said: any two spends of one source are equal.
  -- So a "double spend" (two distinct spends) is impossible AT the fibre
  -- â” the impossibility is contractibility itself, not an ordering rule.
  no-double-spend : (p q : Spend) â†’ p â‰¡ q
  no-double-spend = isContrâ†’isProp spend-isContr

  -- and the converse the design needs: IF two spends were provably
  -- distinct, the fibre could not be contractible.  Stated as: a
  -- distinctness witness refutes propositionality, hence contractibility.
  distinct-spendâ†’not-contr : (p q : Spend) â†’ Â¬ (p â‰¡ q) â†’ Â¬ (isContr Spend)
  distinct-spendâ†’not-contr p q pâ‰¢q c = pâ‰¢q (isContrâ†’isProp c p q)
