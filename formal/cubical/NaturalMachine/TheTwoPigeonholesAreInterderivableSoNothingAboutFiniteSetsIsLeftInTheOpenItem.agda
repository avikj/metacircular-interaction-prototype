{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Both statements here are ones I wrote about `OptimalObservation`'s own
-- definition; there is no source to cite, and a fabricated Sanskrit
-- label would assert a provenance nobody checked.  That module's three
-- INSTANCES are Piṅgala's *Chandaḥśāstra* uddiṣṭa (c. 300 BCE),
-- Virahāṅka's mātrāmeru (c. 600–800) and a CRT residue decode, named
-- here in that order and before any later name; **nothing below is a
-- claim about their mathematics.**  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; `formal/` and `notes/` grepped
-- first.  `--guardedness` carried; infective.
--
-- ────────────────────────────────────────────────────────────────────
-- 0.  A THIRD UPSTREAM BREAKAGE, and why this cycle's target changed
--
-- The intended target was `NaturalMachine.GterTwoCoordinate`, whose
-- header claims *"Nothing here is measured, fitted, or floating-point"*
-- — a claim worth checking rather than trusting.  It cannot be checked
-- here:
--
--   cd formal/cubical && agda -i . NaturalMachine/GterTwoCoordinate.agda
--   → GTER_EXIT=42
--   first error: GterTwoCoordinate.agda:205,1-5
--   "Multiple definitions of comp. Previous definition at …"
--
-- **That is a THIRD breakage, independent of the two already on
-- record** — `Transport.agda:46` (`solveℕ!` not exported by
-- `Cubical.Tactics.NatSolver.Reflection`) and
-- `DSONucleusOneSidedProduct.agda:17` (`Cubical.Data.Int` has no
-- `min`/`max`).  This one is a NAME COLLISION with
-- `Cubical.Core.Primitives`' `comp`, which is a trap already on my own
-- list; under the declared pin it evidently does not fire.  Three
-- distinct causes, all from the container not being the pin.  None is
-- mine and none is touched.  So this module was built on the only
-- ground known green: my own two modules and the library.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  WHAT IS PROVED, and it closes the smaller half of (w″)
--
-- At 806bd0ea I proved `FinPigeonhole → TheOpenPigeonhole` and wrote
-- that the converse *"is not proved either, though it should be
-- immediate at `X = Y = SFin n`"*.  It is, and here it is:
--
--   finSetOn n     the `FinSet` structure carried by `SFin n` itself —
--                  `card` is `n` and the mere equivalence is `idEquiv`
--   theOpenPigeonholeGivesFinPigeonhole
--                  `TheOpenPigeonhole → FinPigeonhole`, by instantiating
--                  at that structure on both sides, where the `card`
--                  conjunct of `Optimal` is `refl`
--
-- **TOGETHER WITH 806bd0ea THE TWO STATEMENTS ARE INTERDERIVABLE**, and
-- that is the point rather than the convenience.  The open item was
-- posed over `FinSet`, with cardinalities, mere equivalences and a
-- truncation to escape; it is now known to contain **no FinSet content
-- at all**.  Whatever is hard about it is hard about `⊤ ⊎ (⊤ ⊎ … )`.
-- A reduction in one direction leaves open the possibility that the
-- general statement is strictly stronger; the second direction removes
-- it, and *that* is what "reduces to" could not say on its own —
-- the distinction this line logged at 806bd0ea, now discharged.
--
-- WHAT IS NOT CLAIMED.  **`FinPigeonhole` is still NOT proved and NOT
-- refuted** — it is true and standard, asserting it without a proof is
-- what this corpus forbids, and both directions here take it or its
-- image as a HYPOTHESIS.  So (w″) is not closed; only its
-- FinSet-shaped surface is removed.  Nothing is amended or retracted:
-- `OptimalObservation`, ac4ee91d and 806bd0ea stand unchanged, and
-- `Optimal`, `TheOpenPigeonhole`, `FinPigeonhole` are imported, not
-- redefined.  The `GterTwoCoordinate` claim in §0 is NOT evaluated —
-- I could not compile it, so I say nothing about whether it is true.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (idEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.FinSet using (FinSet)
open import Cubical.Data.SumFin using () renaming (Fin to SFin)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import NaturalMachine.TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
  using (FinPigeonhole)
open import NaturalMachine.TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
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
