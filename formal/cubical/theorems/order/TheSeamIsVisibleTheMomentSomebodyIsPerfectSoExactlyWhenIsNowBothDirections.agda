{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections
--
-- What is checked is the order-theoretic content of §2's sentence, on the
-- assumption that the sentence describes the released function
-- correctly.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target: `ExcludingPerfectScorersRemovesOnlyGainlessCandidates`.
--
-- **THE MODULE TITLE IS EARNED, AND THE DANGEROUS CONVERSE IS ALREADY
-- DISCLAIMED.**  `Only` here is the direction REMOVED ⟹ GAINLESS, which
-- is exactly `noStrictImprovementAtTheCap`.  The reverse reading —
-- every gainless candidate is removed — is false in general, and that
-- module's §"SYĀT — THE CLAIM, EXACTLY" says so in its own words: the cap
-- bounds the score, it does not populate it.
--
-- **THE FAULT IS ONE LEVEL DOWN, IN A THEOREM NAME.**  §3 is called
-- `theSeamIsInvisibleExactlyWhenNobodyIsPerfect` and proves ONE
-- direction: if no agent attains the cap, eligibility keeps every
-- member.  The converse — if eligibility keeps every member of every
-- list, then no agent attains the cap — is not there, and the module's
--
-- **AND THE CONVERSE IS SHORT, WITH A ONE-ELEMENT LIST.**  If `a`
-- attains the cap, feed the invisibility statement `a ∷ []`.  It
-- returns `a` as a member of `eligible (a ∷ [])`; every member of a
-- filtered list satisfies the predicate (`filterDecOnlyKeepsSatisfiers`);
-- so `Imperfect a`, which contradicts `AtCap a`.
-- The two sides are joined by a FILTER whose
-- exactness lemmas both already exist, so neither direction is a search.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   memberOfAnAllList   `All P ys` and membership give `P a` — the
--                       bridge between the two recursive families, by
--                       induction, since the filter kit ships `All`-
--                       and `Any`-shaped lemmas that never meet
--   theSeamIsVisibleWhenSomebodyIsPerfect
--                       the missing direction, refuting invisibility
--                       from a single at-cap agent
------------------------------------------------------------------------

module TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (All ; filterDecOnlyKeepsSatisfiers)
open import ExcludingPerfectScorersRemovesOnlyGainlessCandidates
  using (AtCap ; Imperfect ; decImperfect ; eligible)

------------------------------------------------------------------------
-- 1.  The bridge the filter kit does not ship
--
-- `filterDecOnlyKeepsSatisfiers` lands in `All`; membership is stated
-- with `Any`.  The two families never meet in the kit, so the step is
-- written here once.
------------------------------------------------------------------------

memberOfAnAllList :
  {A : Type} (P : A → Type) (a : A) (ys : List A)
  → All P ys → Any (λ y → y ≡ a) ys → P a
memberOfAnAllList P a []       _          e       = ⊥.rec e
memberOfAnAllList P a (y ∷ ys) (py , pys) (inl q) = subst P q py
memberOfAnAllList P a (y ∷ ys) (py , pys) (inr m) =
  memberOfAnAllList P a ys pys m

------------------------------------------------------------------------
-- 2.  The missing direction: one perfect agent makes the seam visible
------------------------------------------------------------------------

module _ {A : Type} (score : A → ℕ) (cap : ℕ)
         (bounded : (a : A) → score a ≤ cap) where

  private
    Imp : A → Type
    Imp = Imperfect score cap bounded

    elig : List A → List A
    elig = eligible score cap bounded

  theSeamIsVisibleWhenSomebodyIsPerfect :
    (a : A) → AtCap score cap bounded a
    → ¬ ( (xs : List A) (b : A)
          → Any (λ y → y ≡ b) xs → Any (λ y → y ≡ b) (elig xs) )
  theSeamIsVisibleWhenSomebodyIsPerfect a atcap invisible =
    memberOfAnAllList Imp a (elig (a ∷ []))
      (filterDecOnlyKeepsSatisfiers Imp (decImperfect score cap bounded) (a ∷ []))
      (invisible (a ∷ []) a (inl refl))
      atcap
