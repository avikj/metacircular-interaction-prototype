{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem
--
-- ON THE NAME.  No tradition term is used.  Both statements here are
-- about `OptimalObservation`'s own definition.  That module's three
-- INSTANCES are Pigala's *Chandastra* uddia (c. 300 BCE),
-- Virahka's mtrmeru (c. 600�800) and a CRT residue decode.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  WHAT IS PROVED
--
-- The converse of `FinPigeonhole � TheOpenPigeonhole` is
-- immediate at `X = Y = SFin n`, and here it is:
--
--   finSetOn n     the `FinSet` structure carried by `SFin n` itself —
--                  `card` is `n` and the mere equivalence is `idEquiv`
--   theOpenPigeonholeGivesFinPigeonhole
--                  `TheOpenPigeonhole → FinPigeonhole`, by instantiating
--                  at that structure on both sides, where the `card`
--                  conjunct of `Optimal` is `refl`
--
-- **THE TWO STATEMENTS ARE INTERDERIVABLE**, and
-- that is the point rather than the convenience.  The statement was
-- posed over `FinSet`, with cardinalities, mere equivalences and a
-- truncation to escape; it contains **no FinSet content
-- at all**.  Whatever is hard about it is hard about `⊤ ⊎ (⊤ ⊎ … )`.
-- A reduction in one direction leaves open the possibility that the
-- general statement is strictly stronger; the second direction removes
-- it, and *that* is what "reduces to" could not say on its own.
------------------------------------------------------------------------

module TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (idEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.FinSet using (FinSet)
open import Cubical.Data.SumFin using () renaming (Fin to SFin)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
  using (FinPigeonhole)
open import TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
  using (TheOpenPigeonhole)

------------------------------------------------------------------------
-- 2.  `SFin n` is its own finite set, with `card` definitionally `n`
------------------------------------------------------------------------

finSetOn : ℕ → FinSet ℓ-zero
finSetOn n = SFin n , n , ∣ idEquiv (SFin n) ∣₁

------------------------------------------------------------------------
-- 3.  …so the general statement instantiates back to the finite one
--
-- The `card` conjunct of `Optimal` is `card (finSetOn n) ≡ card
-- (finSetOn n)`, i.e. `n ≡ n`, so `refl` discharges it and only the
-- injectivity hypothesis is passed through.
------------------------------------------------------------------------

theOpenPigeonholeGivesFinPigeonhole : TheOpenPigeonhole → FinPigeonhole
theOpenPigeonholeGivesFinPigeonhole general n f inj =
  general (finSetOn n) (finSetOn n) f (inj , refl)
