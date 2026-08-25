{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheLeastRefutingListIsNotUniqueSoTheMeasureIsANumberAndNotACanonicalWitness
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The audited module belongs to the standing लाघव (lāghava) thread and
-- names its sites अवक्तव्य (avaktavya — Jaina) and अनुवृत्ति /
-- प्रत्याहार / अपवाद (anuvṛtti / pratyāhāra / apavāda — Pāṇinian);
-- **the school is named before the term**, as the naming rule requires.
-- This module touches none of that material — its subject is whether a
-- minimiser is unique — and **makes no claim whatever about avaktavya,
-- anuvṛtti, pratyāhāra or apavāda.**  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; `formal/` and `notes/` grepped
-- first.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ITEM.  At 78a82d16 I completed the range below 2 for
-- `WitnessNumberIsTwo`'s measure — the least list of points on which no
-- decoder survives — and left open, in my own words: *"is the least
-- refuting list UNIQUE at a site?"*
--
-- **It is not, and the counterexample is the site's own pair reversed.**
-- A collision is symmetric: `q x ≡ q x'` gives `q x' ≡ q x`, and
-- `¬ (t x ≡ t x')` gives `¬ (t x' ≡ t x)`.  So `collision→refutes`
-- applies to `x' ∷ x ∷ []` exactly as it applies to `x ∷ x' ∷ []`, and
-- the two lists are distinct because the collision forces `x ≢ x'`.
--
-- WHAT IS PROVED
--
--   theReversedPairAlsoRefutes   the same collision, read the other way
--   theTwoPointsDiffer           `x ≢ x'`, from `differ` by `cong t` —
--                                the hypothesis that makes it a
--                                collision is exactly what separates
--                                the points
--   theTwoListsDiffer            hence the two refuting lists are not
--                                equal, by `cong (hd x)`
--   theLeastRefutingListIsNotUnique
--                                all three together: two distinct lists,
--                                both refuting, both of length 2, which
--                                78a82d16 and `singleton-never-refutes`
--                                show is least
--
-- **WHAT THIS SETTLES ABOUT THE MEASURE, AND IT IS THE POINT.**
-- `WitnessNumberIsInvariant` records that this thread found "a measure
-- that DOES survive" where `size` did not.  It survives as a **NUMBER**.
-- The minimiser is not canonical, so there is no such thing as *the*
-- least refuting list to transport, quotient by, or read a further
-- invariant off — only its length.  That is not a defect: a measure is
-- allowed to be a number.  It does mean any future construction that
-- says "take the least refuting list" is under-specified, and the
-- audited line does not make that mistake anywhere I have read.
--
-- WHAT IS NOT CLAIMED.  **`WitnessNumberIsTwo` is NOT amended and NOT
-- retracted** — `Refutes`, `factorLaw`, `collision→refutes` and
-- `singleton-never-refutes` are imported unchanged and every theorem
-- there is true as written; "exactly 2" is about the LENGTH and is
-- untouched by this.  It is NOT claimed that non-uniqueness holds at
-- every site: the अवक्तव्य site has a six-atom decoder space and its own
-- lower bound, and **nothing here is applied to it**.  It is NOT
-- claimed that the two lists are the only two.  No least list is
-- CONSTRUCTED anywhere.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheLeastRefutingListIsNotUniqueSoTheMeasureIsANumberAndNotACanonicalWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.WitnessNumberIsTwo
  using (Refutes ; factorLaw ; collision→refutes ; singleton-never-refutes)

private
  variable
    ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  A head with a default — the only list surgery needed
------------------------------------------------------------------------

hd : {ℓ : Level} {A : Type ℓ} → A → List A → A
hd d []      = d
hd _ (a ∷ _) = a

------------------------------------------------------------------------
-- 2.  The reversed pair refutes just as well, and is a different list
------------------------------------------------------------------------

module _ {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
         (q : X → Y) (t : X → T) {x x' : X}
         (same : q x ≡ q x') (differ : ¬ (t x ≡ t x'))
  where

  theReversedPairAlsoRefutes : Refutes (factorLaw q t) (x' ∷ x ∷ [])
  theReversedPairAlsoRefutes =
    collision→refutes q t (sym same) (λ p → differ (sym p))

  theTwoPointsDiffer : ¬ (x ≡ x')
  theTwoPointsDiffer p = differ (cong t p)

  theTwoListsDiffer : ¬ ((x ∷ x' ∷ []) ≡ (x' ∷ x ∷ []))
  theTwoListsDiffer p = theTwoPointsDiffer (cong (hd x) p)

  ----------------------------------------------------------------------
  -- 3.  So the minimiser is not canonical
  ----------------------------------------------------------------------

  theLeastRefutingListIsNotUnique :
      Refutes (factorLaw q t) (x ∷ x' ∷ [])
    × Refutes (factorLaw q t) (x' ∷ x ∷ [])
    × (¬ ((x ∷ x' ∷ []) ≡ (x' ∷ x ∷ [])))
    × ((z : X) → ¬ Refutes (factorLaw q t) (z ∷ []))
  theLeastRefutingListIsNotUnique =
      collision→refutes q t same differ
    , theReversedPairAlsoRefutes
    , theTwoListsDiffer
    , singleton-never-refutes q t
