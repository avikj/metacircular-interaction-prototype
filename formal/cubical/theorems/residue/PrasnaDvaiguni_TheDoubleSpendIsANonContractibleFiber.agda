{-# OPTIONS --cubical --safe #-}

-- प्रश्न-द्वैगुण्य — a question put to the kernel, not narrated.
-- The exclusive-resource design (docs/build/ExclusiveResourceOrdering_…)
-- rests on ONE load-bearing claim: a valid spend keeps the source
-- fiber contractible, and a DOUBLE spend forces it non-contractible.
-- Here that claim is stated so the kernel answers, not the carrier.
--
-- Model, minimal and honest: a coin source is a point `src : A`.
-- A spend of it is a point of its fiber under the ledger map
-- `f : A → B` at the source's image — i.e. a point of `singl (f src)`,
-- which is `Σ[ b ] (f src ≡ b)`.  A SINGLE valid spend is the canonical
-- inhabitant `(f src , refl)`.  The claim: the type of spends is
-- contractible, so any two spends are ALREADY EQUAL — there is no room
-- for a second, distinct spend.  A "double spend" would be two spends
-- p q with p ≢ q; the kernel is asked whether that can coexist with
-- contractibility.

module PrasnaDvaiguni_TheDoubleSpendIsANonContractibleFiber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContr→isProp)
open import Cubical.Relation.Nullary using (¬_)

module _ {ℓ} {A B : Type ℓ} (f : A → B) (src : A) where

  Spend : Type ℓ
  Spend = singl (f src)

  -- the kernel already knows this fiber is contractible (no hypothesis)
  spend-isContr : isContr Spend
  spend-isContr = isContrSingl (f src)

  -- THE ANSWER, kernel-said: any two spends of one source are equal.
  -- So a "double spend" (two distinct spends) is impossible AT the fiber
  -- — the impossibility is contractibility itself, not an ordering rule.
  no-double-spend : (p q : Spend) → p ≡ q
  no-double-spend = isContr→isProp spend-isContr

  -- and the converse the design needs: IF two spends were provably
  -- distinct, the fiber could not be contractible.  Stated as: a
  -- distinctness witness refutes propositionality, hence contractibility.
  distinct-spend→not-contr : (p q : Spend) → ¬ (p ≡ q) → ¬ (isContr Spend)
  distinct-spend→not-contr p q p≢q c = p≢q (isContr→isProp c p q)
