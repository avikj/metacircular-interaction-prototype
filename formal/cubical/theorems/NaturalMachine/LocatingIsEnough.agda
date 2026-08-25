{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.LocatingIsEnough
--
-- `WhyTheSitesAreTwo` §6 left this open and refused to size it:
--
--     whether discreteness of Y can be weakened — the table walk needs
--     to compare observations, and nothing here says a weaker
--     comparison would not do.
--
-- It can, and this is exactly how far.  The theorem never compares two
-- arbitrary observations.  It compares the LIST'S observations against
-- an incoming one, and there are only finitely many of those.
--
-- ────────────────────────────────────────────────────────────────────
-- THE HYPOTHESIS THE PROOF ACTUALLY USES
--
--     Locates q []       = Unit
--     Locates q (x ∷ xs) = ((y : Y) → Dec (q x ≡ y)) × Locates q xs
--
-- "each listed point's observation is decidable against an arbitrary
-- one".  `Discrete Y` gives this for every list (§4) and is strictly
-- more than needed: it decides equality of any two observations
-- whatever, including the ones the walk never looks at.
--
--     locatingFree→notRefuting :
--       Locates q (x₀ ∷ xs) → CollisionFree q t (x₀ ∷ xs)
--       → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
--
-- and `WhyTheSitesAreTwo.collisionFree→notRefuting` is the corollary at
-- `Discrete Y`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THE WEAKENING IS THE RIGHT ONE, NOT MERELY A WEAKER ONE
--
-- Because it is the hypothesis of a LOCATION problem rather than of an
-- equality problem.  The decoder is handed an observation and must find
-- which listed point produced it — that is all it ever needs, and it is
-- what `Locates` says is possible.  Deciding equality throughout Y is a
-- statement about the whole observation space; deciding location is a
-- statement about the finitely many points the absence is witnessed at.
--
-- The measure was already local to the witnesses (`WitnessNumberIsTwo`).
-- This makes its hypothesis local too, which is the natural place for
-- it to have been.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT CLAIMED
--
-- CLAIMED: the ceiling theorem holds under a hypothesis about finitely
-- many observations rather than about all of Y, so a site with an
-- undecidable observation space can still be pinned at 2 provided its
-- witnesses can be located.
--
-- NOT CLAIMED: that `Locates` is minimal.  It is what this proof uses,
-- which is a different and weaker thing.  Named, not estimated.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.LocatingIsEnough where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥ ; ⊥*)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import NaturalMachine.WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw)
open import NaturalMachine.WhyTheSitesAreTwo using (Mem ; CollisionFree)

private
  variable
    ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  Locating a listed observation, as a recursive family
------------------------------------------------------------------------

Locates : {X : Type ℓx} {Y : Type ℓy} → (X → Y) → List X → Type (ℓ-max ℓx ℓy)
Locates {Y = Y} q []       = Unit*
Locates {Y = Y} q (x ∷ xs) = ((y : Y) → Dec (q x ≡ y)) × Locates q xs

------------------------------------------------------------------------
-- 2.  The table, now walking with its own decisions
------------------------------------------------------------------------

module _ {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
         (q : X → Y) (t : X → T) (fb : T) where

  table : (ys : List X) → Locates q ys → Y → T
  table []       _        y = fb
  table (x ∷ xs) (d , ds) y with d y
  ... | yes _ = t x
  ... | no  _ = table xs ds y

  table-correct :
    (ys : List X) (loc : Locates q ys) → CollisionFree q t ys
    → (x : X) → Mem x ys → table ys loc (q x) ≡ t x
  table-correct []       _        cf x m = Empty.rec* m
  table-correct (y ∷ ys) (d , ds) cf x m with d (q x)
  ... | yes e = cf y x (inl refl) m e
  ... | no ¬e = table-correct ys ds cf' x (later m)
    where
    cf' : CollisionFree q t ys
    cf' a b ma mb = cf a b (inr ma) (inr mb)

    later : Mem x (y ∷ ys) → Mem x ys
    later (inl x≡y) = Empty.rec (¬e (sym (cong q x≡y)))
    later (inr r)   = r

------------------------------------------------------------------------
-- 3.  THE THEOREM, under the located hypothesis
------------------------------------------------------------------------

module _ {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
         (q : X → Y) (t : X → T) where

  locatingFree→notRefuting :
    (x₀ : X) (xs : List X)
    → Locates q (x₀ ∷ xs)
    → CollisionFree q t (x₀ ∷ xs)
    → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
  locatingFree→notRefuting x₀ xs loc cf ref =
    ref decode (holds (x₀ ∷ xs) (λ _ m → m))
    where
    decode : Image q → T
    decode p = table q t (t x₀) (x₀ ∷ xs) loc (fst p)

    holds : (ys : List X) → ((x : X) → Mem x ys → Mem x (x₀ ∷ xs))
          → AllHold (factorLaw q t) decode ys
    holds []       _   = tt*
    holds (y ∷ ys) inc =
        table-correct q t (t x₀) (x₀ ∷ xs) loc cf y (inc y (inl refl))
      , holds ys (λ z m → inc z (inr m))

------------------------------------------------------------------------
-- 4.  `Discrete Y` is the special case
------------------------------------------------------------------------

discrete→locates :
  {X : Type ℓx} {Y : Type ℓy} (dY : Discrete Y) (q : X → Y)
  → (ys : List X) → Locates q ys
discrete→locates dY q []       = tt*
discrete→locates dY q (x ∷ xs) = (λ y → dY (q x) y) , discrete→locates dY q xs

-- `WhyTheSitesAreTwo.collisionFree→notRefuting`, rederived
discrete-corollary :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (dY : Discrete Y) (q : X → Y) (t : X → T)
  (x₀ : X) (xs : List X)
  → CollisionFree q t (x₀ ∷ xs)
  → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
discrete-corollary dY q t x₀ xs =
  locatingFree→notRefuting q t x₀ xs (discrete→locates dY q (x₀ ∷ xs))

------------------------------------------------------------------------
-- 5.  What moved.
--
-- The ceiling theorem no longer asks anything about the observation
-- space as a whole.  It asks that the finitely many observations the
-- absence is witnessed at can be recognised — a location problem, not
-- an equality problem — and under exactly that, a list still refutes
-- only by containing a collision, so the witness number is still 2.
--
-- A site whose Y is not discrete is therefore not automatically outside
-- the deflation.  It is outside only if its witnesses cannot be
-- located, which is a much smaller class and a checkable condition.
--
-- OPEN, named and not estimated: whether `Locates` is minimal.  It is
-- the hypothesis this proof consumes; that is not the same as being the
-- weakest one that works.
------------------------------------------------------------------------
