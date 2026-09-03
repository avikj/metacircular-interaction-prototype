{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MinPlusResiduationIsAGaloisConnectionAtOneCut
--
-- `TheSaturationClosureNeedsOnlyAGaloisConnection` reduced Δ 28
-- §31–32's saturation obligation to exactly two lines and then said:
--
--   "the min-plus instance itself: neither `galFwd` nor `galBwd` is
--    proved for a semiring-valued kernel here, and no quantale is
--    constructed anywhere in this repository.  The idempotence result
--    therefore STILL does not apply to min-plus convolution."
--
-- The debt is paid at ONE CUT — a single burden and a single residual —
-- and paid with the real min-plus data, not a stand-in.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ORDER IS REVERSED, AND THAT IS THE WHOLE POINT.  In min-plus,
-- lower cost is better, so the quantale order is `a ⊑ b = b ≤ ℕ-a`.
-- With ℕ's own `≤` the residuation is NOT a Galois connection and the
-- failure is not subtle: `∸` truncates, and `truncationBreaksTheNaiveOrder`
-- below exhibits `K = 0, φ = 0, ψ = 5` where one side holds and the
-- other does not.  Getting the direction right is not bookkeeping; it
-- is the difference between the obligation being dischargeable and
-- being false.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ∸-adjˡ / ∸-adjʳ     the monus adjunction, K ∸ ψ ≤ φ  ⟺  K ≤ φ + ψ,
--                       which cubical v0.5 does not ship
--   galFwd / galBwd     both directions of the contravariant adjunction
--                       for `u = d = (K ∸_)` under the reversed order —
--                       and both are the SAME statement, since the two
--                       sides are `K ≤ φ + ψ` and `K ≤ ψ + φ`
--   MinPlusCut          the instantiation of `module Galois`, from which
--                       antitonicity, unit, counit, the triangles,
--                       idempotence of `c a = K ∸ (K ∸ a)`, and the
--                       fixed-point characterisation all follow with
--                       NOTHING re-proved
--   truncationBreakstheNaiveOrder
--                       the same maps under ℕ's own order fail
--
-- So Δ 28 §31–32's "re-saturate" is, at one cut, a checked closure over
-- genuine min-plus data: saturate once and stop.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  `(_∸ b) ⊣ (_+ b)` is the standard residuation in ℕ and
-- makes it a residuated monoid; that Isbell conjugation over a quantale
-- is a Galois connection is likewise standard (Lawvere's metric-space
-- reading of enriched categories, `Metric spaces, generalized logic,
-- and closed categories`, 1973, is where min-plus becomes the value
-- object).  What is contributed is only that this repository's own
-- obligation is now discharged for one cut rather than named.
--
-- THE SCOPE, EXACTLY, and it is the larger half.  ONE CUT means
-- ONE burden and ONE residual: `X = Y = Unit`, so no infimum over an
-- index appears.  Δ 28's cut has a PROFILE on each side, and its `↑`
-- takes a meet over all burdens — that needs `min` over a finite index
-- and its universal property, which is NOT built here.  So the general
-- residuation is still owed, and what this settles is that the
-- OBSTRUCTION IS NOT THE RESIDUATION LAW — it is the meet.  No `∞` is
-- adjoined, so this is ℕ and not the min-plus semiring proper, whose
-- unit for `min` is missing; nothing below needs it and nothing below
-- may be cited as constructing it.  Convolution does not appear at all.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module MinPlusResiduationIsAGaloisConnectionAtOneCut where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +-zero ; +-suc ; +-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-refl ; ≤-trans ; zero-≤ ; suc-≤-suc ; pred-≤-pred)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)

------------------------------------------------------------------------
-- 1.  The monus adjunction, which v0.5 does not ship
------------------------------------------------------------------------

∸-adjˡ : (K ψ φ : ℕ) → K ∸ ψ ≤ φ → K ≤ φ + ψ
∸-adjˡ K       zero     φ h = subst (K ≤_) (sym (+-zero φ)) h
∸-adjˡ zero    (suc ψ)  φ _ = zero-≤
∸-adjˡ (suc K) (suc ψ)  φ h =
  subst (suc K ≤_) (sym (+-suc φ ψ)) (suc-≤-suc (∸-adjˡ K ψ φ h))

∸-adjʳ : (K ψ φ : ℕ) → K ≤ φ + ψ → K ∸ ψ ≤ φ
∸-adjʳ K       zero     φ h = subst (K ≤_) (+-zero φ) h
∸-adjʳ zero    (suc ψ)  φ _ = zero-≤
∸-adjʳ (suc K) (suc ψ)  φ h =
  ∸-adjʳ K ψ φ (pred-≤-pred (subst (suc K ≤_) (+-suc φ ψ) h))

------------------------------------------------------------------------
-- 2.  The min-plus order: lower cost is better, so ℕ's ≤ is reversed
------------------------------------------------------------------------

module _ (K : ℕ) where

  _⊑_ : ℕ → ℕ → Type
  a ⊑ b = b ≤ a

  ⊑-refl : (a : ℕ) → a ⊑ a
  ⊑-refl a = ≤-refl

  ⊑-trans : (a b c : ℕ) → a ⊑ b → b ⊑ c → a ⊑ c
  ⊑-trans a b c ab bc = ≤-trans bc ab

  res : ℕ → ℕ
  res φ = K ∸ φ

  -- both directions are the same statement, once `+` is commuted
  galFwd : (a b : ℕ) → a ⊑ res b → b ⊑ res a
  galFwd a b h =
    ∸-adjʳ K a b (subst (K ≤_) (+-comm a b) (∸-adjˡ K b a h))

  galBwd : (a b : ℕ) → b ⊑ res a → a ⊑ res b
  galBwd a b h =
    ∸-adjʳ K b a (subst (K ≤_) (+-comm b a) (∸-adjˡ K a b h))

  -- and the whole closure theory follows with nothing re-proved
  open Galois _⊑_ _⊑_ ⊑-refl ⊑-trans ⊑-refl ⊑-trans res res galFwd galBwd
    public

------------------------------------------------------------------------
-- 3.  Under ℕ's own order it is false, and truncation is why
--
-- With `K = 0`, `φ = 0`, `ψ = 5`: `φ ≤ K ∸ ψ` holds (both are 0) and
-- `ψ ≤ K ∸ φ` does not.  So the naive reading — costs ordered upward —
-- does not even give one direction of the adjunction.
------------------------------------------------------------------------

naiveHolds : 0 ≤ (0 ∸ 5)
naiveHolds = zero-≤

naiveFails : ¬ (5 ≤ (0 ∸ 0))
naiveFails (k , e) = snotz (sym (+-comm k 5) ∙ e)

truncationBreaksTheNaiveOrder :
  (0 ≤ (0 ∸ 5)) × (¬ (5 ≤ (0 ∸ 0)))
truncationBreaksTheNaiveOrder = naiveHolds , naiveFails

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says the remaining obstruction
-- "is not the residuation law; it is the meet", and adds that the meet
-- "needs `min` over a finite index and its universal property".
--
-- The meet is built and the profile cut is done, in
-- `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- AND THE OPERATION NAMED ABOVE IS WRONG.  **The meet is `max`, not
-- `min`.**  §2 here had to reverse ℕ's order because lower cost is
-- better; a meet in a reversed order is a JOIN in the original, so `⋀`
-- over burdens is `max` in ℕ.  Writing "min-plus, so take a min" names
-- the operation by its role in the semiring rather than by its role in
-- the order — which is exactly the error §2's reversal was supposed to
-- have taught, made one level up and two cycles later.
--
--   max / max-≤ˡ / max-≤ʳ / max-least   the meet, with its universal
--                                       property
--   Profile ks                          profiles as a RECURSIVE FAMILY
--                                       over the kernel, so a length
--                                       mismatch is not representable
--   up ks φ = ⋀ᵢ (kᵢ ∸ φᵢ) ,  dn ks ψ = (kᵢ ∸ ψ)ᵢ
--   goFwd / goBwd                       both directions
--   ProfileCut                          `module Galois` instantiated
--
-- STILL NOT CLAIMED there: one side is still SCALAR — burdens form a
-- profile, residuals are one value, which is what makes `up` land in ℕ.
-- Profiles on BOTH sides need a meet per residual index and are not
-- built.  No `∞`, so the empty meet is `0` by ℕ's bottom rather than by
-- choice.  CONVOLUTION is absent, so nothing there speaks to Δ 28's
-- COMPOSITION step — only to re-saturation.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above — including the 2026-08-19 append above it, which is
-- correct and is what convicts a later claim of mine.  TWO items.
--
-- ────────────────────────────────────────────────────────────────────
-- (1)  A FALSE CLAIM OF MINE, MADE ONE CYCLE AGO, REFUTED BY THIS FILE.
--
-- Commit 3aa3c78c appended a correction to
-- `TheSaturationClosureNeedsOnlyAGaloisConnection` and said of the
-- `min`/`max` meet correction:
--
--   "That correction was made in `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`
--    … and it was recorded THERE AND NOWHERE ELSE."
--
-- **That is false, and the counterexample is the paragraph directly
-- above this one.**  The 2026-08-19 append in THIS file states the
-- correction in its own words — *"AND THE OPERATION NAMED ABOVE IS
-- WRONG.  The meet is `max`, not `min`"* — with the reason, the
-- reversal, and the diagnosis that naming an operation by its role in
-- the semiring rather than in the order is the error.  So the
-- correction was propagated to two of its three sites; exactly one site
-- was missed.
--
-- **AND THE WAY I GOT IT WRONG IS THE SAME SHAPE AS THE THING I WAS
-- REPORTING.**  I grepped for the wrong phrase, saw three files, and
-- read all three hits as uncorrected without opening them — when one
-- was the correction itself and one was this file quoting the wrong
-- sentence in order to refute it.  **A grep for the wrong word finds
-- the corrections too, because a correction has to quote what it
-- corrects.  Counting hits is not reading them.**  That is the
-- operative repair, and it is narrower and more useful than "grep for
-- the word, not the module", which is what 3aa3c78c concluded and which
-- remains true but insufficient.
--
-- The substantive half of 3aa3c78c stands: the wrong word DID survive
-- unpropagated in `TheSaturationClosureNeedsOnlyAGaloisConnection`, and
-- is now corrected there.  Only the scope claim was wrong.
--
-- ────────────────────────────────────────────────────────────────────
-- (2)  AND ONE SENTENCE ABOVE IS NOW STALE.
--
-- The append above ends: *"Profiles on BOTH sides need a meet per
-- residual index and are not built."*  Built —
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` (83d6edb8) takes the
-- burdens as a profile so `UpP` produces a residual PROFILE;
-- `TheTwoSidedCutExistsOverANonEmptyResidualIndex` (89c9b7f0) gives the
-- adjunction over a non-empty index; and `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`
-- (8f3acebb) removes the restriction entirely, over an ARBITRARY
-- residual index list with no `∞`.
--
-- **AND THIS FILE HAD THE REASON RIGHT BEFORE I LOST IT.**  The
-- paragraph above already says *"the empty meet is `0` by ℕ's bottom
-- rather than by choice."*  That is exactly the fact I later denied —
-- claiming the empty meet forced `ℕ ⊎ ∞` (89c9b7f0's signature),
-- retracted at 819e0a57 — and it was written here, correctly, before I
-- made the error.  Nothing was needed to fix it except reading my own
-- file.
--
-- WHAT IS NOT RETRACTED.  Everything else in this module and in the
-- append above.  `∸-adjˡ`/`∸-adjʳ`, the two adjunction directions,
-- `MinPlusCut`, and `truncationBreaksTheNaiveOrder` are unaltered and
-- true.  CONVOLUTION is still absent everywhere, so Δ 28's COMPOSITION
-- step is untouched by any of this.
------------------------------------------------------------------------
