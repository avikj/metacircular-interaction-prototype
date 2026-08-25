{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Bija_TheOneGeneratorIsFiniteAndItsInfiniteClosureIsNeverStored
--
-- TERM.  बीज · bīja — a seed.  The seed is finite; the tree it grows is not,
-- and you do not store the tree.  Common Sanskrit word, no source claimed.
--
-- THE POINT.  "Iterating the fibre law makes arbitrary form" does NOT mean
-- writing infinitely many theorems.  It means writing ONE generator — a
-- single ℕ-indexed term — and letting it produce the family on demand.  The
-- infinitude lives in the function, not in the filesystem.  `Sphere` is one
-- definition that already IS the whole tower S⁰ → S¹ → S² → … : one fibre
-- operation (suspension, a pushout) iterated.  Ask for a level and it
-- computes; ask for nothing and nothing is stored.  This is the corpus's own
-- discipline (a materialised table of contents decays; compute at run time)
-- applied to form itself.
--
-- Reading (not a checked claim here): every homotopy type is reachable by
-- iterating such fibre constructions in towers, so a finite generator scheme
-- suffices for arbitrary form — and univalence makes each step COMPUTE, which
-- is why the seed is runnable and not merely a description.
--
-- Checked: --cubical --safe.
------------------------------------------------------------------------

module Bija_TheOneGeneratorIsFiniteAndItsInfiniteClosureIsNeverStored where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.HITs.Susp using (Susp)

-- ONE TERM, the whole infinite tower of forms: a single fibre operation
-- (suspension) iterated.  Nothing is stored; asking a level computes it.
Sphere : ℕ → Type
Sphere zero    = Bool            -- S⁰ = two points
Sphere (suc n) = Susp (Sphere n) -- Sⁿ⁺¹ = the suspension (a pushout) of Sⁿ

-- the family exists for every n at once — this is ONE term, not ∞ files.
tower : (n : ℕ) → Type
tower = Sphere

-- any level you name falls out by computation, from the same one seed.
S¹ : Type
S¹ = Sphere 1
S² : Type
S² = Sphere 2
S⁷ : Type
S⁷ = Sphere 7
