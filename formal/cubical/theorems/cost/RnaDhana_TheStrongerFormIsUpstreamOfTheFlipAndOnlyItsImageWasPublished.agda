{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheStrongerFormIsUpstreamOfTheFlipAndOnlyItsImageWasPublished
--
-- ऋणधन · ṛṇa-dhana — Brahmagupta, *Brāhmasphuṭasiddhānta* (628): one
-- magnitude read as *dhana* (asset) or *ṛṇa* (debt).  The term is the
-- audited module's and is kept unchanged; his are the sign rules, and
-- the caps, filters, strata and the statement below are NOT his and are
-- not claimed to be.  Ledger and frame file checked before naming.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target: `RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum`,
-- an `IsExactly` — and the LAST actionable target of the title sweep.
--
-- **THE TITLE IS EARNED IN THE STRONGEST READING AVAILABLE TO IT.**
-- `theMixedStratumIsTheFlippedStratum` is a LIST equality, not a
-- membership correspondence, and the module says exactly why it can be:
-- both sides are filters of the same list in the same order, so order
-- and multiplicity survive.  `mixedMaximalIff` is both directions.
-- Nothing is overstated.
--
-- **BUT A STRICTLY STRONGER STATEMENT IS PROVED INSIDE IT AND NOT
-- PUBLISHED.**  The proof is one `∙` of two steps, and its FIRST step
-- is an equality UPSTREAM of the flip:
--
--     mixedStratum ds vs ≡ filterDec (paretoMaximal ∘ flip …) … vs
--
-- — the mixed layer IS the sublist of `vs` that the flipped test
-- selects.  The published theorem is the image of that under
-- `map flip`, obtained by `cong` and `filterMapCommutes`.  The stronger
-- form is inlined as an anonymous argument and discarded.
--
-- **AND THE DIFFERENCE IS EXACTLY THE NON-INJECTIVITY THE MODULE
-- NAMES.**  It observes that `flip` is not injective — that is why
-- element-level reasoning would not give the lists.  The same fact
-- means an equality DOWNSTREAM of `map flip` does not determine what
-- stood upstream: from `map flip A ≡ map flip B` one cannot conclude
-- `A ≡ B`.  So the published form is genuinely weaker than what the
-- proof establishes, and the gap is measured by the very map the module
-- warns about.  §"SYĀT — THE CLAIM, EXACTLY" there lists the iterated
-- stratification, the remainder half and the existence of caps — not
-- this.
--
-- **THE SWEEP'S PATTERN, ONE LAST TIME AND INVERTED.**  Nine earlier
-- targets had a title claiming more than the file proved.  This one
-- proves more than its title claims, and the surplus is thrown away
-- mid-proof.  Both are the same defect — a mismatch between the
-- strongest available statement and the recorded one — and only the
-- first is caught by reading titles.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   mixedStratumIsSelectedByTheFlippedTest
--       the upstream equality, named: the mixed stratum is the sublist
--       of `vs` picked out by the flipped Pareto test.  Its proof is
--       the audited module's own first step, extracted rather than
--       re-derived.
--   thePublishedFormIsItsImage
--       and `theMixedStratumIsTheFlippedStratum` follows from it by
--       `cong (map flip)` and `filterMapCommutes` — so nothing is lost
--       and the published statement is visibly the image.
--
-- SYĀT — THE CLAIM, EXACTLY.  Still ONE layer: the iterated statement
-- (`strata`, coverage, disjointness, order on mixed vectors) needs the
-- remainder transferred and an induction in which the caps must bound a
-- shrinking archive, and is not written here any more than there.
-- Nothing says caps EXIST — `AllBounded` is a hypothesis throughout.
-- No claim that `map flip` reflects equality; the point is precisely
-- that it need not.  No new list lemma: `filterRespectsOn` and
-- `filterMapCommutes` are imported unchanged.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheStrongerFormIsUpstreamOfTheFlipAndOnlyItsImageWasPublished where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; map)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps ; flipWithCaps)
open import RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedMaximal ; AllBounded ; boundedAtMember)
open import RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (mixedStratum ; decMixedMaximal ; mixedMaximalIff
        ; filterRespectsOn ; filterMapCommutes)

module _ (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds)) where

  private
    f : Vec ds → List _
    f = flipWithCaps ds cs

    FlippedTest : Vec ds → Type
    FlippedTest u = IsParetoMaximal (f u) (map f vs)

  ------------------------------------------------------------------
  -- 1.  The equality upstream of the flip
  ------------------------------------------------------------------

  mixedStratumIsSelectedByTheFlippedTest :
    AllBounded ds cs vs
    → mixedStratum ds vs
      ≡ filterDec FlippedTest (λ u → decIsParetoMaximal (f u) (map f vs)) vs
  mixedStratumIsSelectedByTheFlippedTest ab =
    filterRespectsOn
      (MixedMaximal ds vs)
      FlippedTest
      (decMixedMaximal ds vs)
      (λ u → decIsParetoMaximal (f u) (map f vs))
      vs
      (λ a m → mixedMaximalIff ds cs vs ab a (boundedAtMember ds cs vs a ab m))

  ------------------------------------------------------------------
  -- 2.  The published form is its image, and follows from it
  ------------------------------------------------------------------

  thePublishedFormIsItsImage :
    AllBounded ds cs vs
    → map f (mixedStratum ds vs) ≡ stratum (map f vs)
  thePublishedFormIsItsImage ab =
      cong (map f) (mixedStratumIsSelectedByTheFlippedTest ab)
    ∙ sym (filterMapCommutes f
            (λ y → IsParetoMaximal y (map f vs))
            (λ y → decIsParetoMaximal y (map f vs))
            vs)
