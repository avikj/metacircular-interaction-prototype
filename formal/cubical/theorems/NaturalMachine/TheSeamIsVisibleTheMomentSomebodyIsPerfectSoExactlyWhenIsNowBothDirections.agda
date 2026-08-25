{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- `notes/` grepped.  **No tradition term is claimed and none is
-- invented.**  The subject is a seam recorded in this corpus's own
-- `notes/DARWIN_GODEL_MATH.md` §2 plus elementary order theory.
--
-- **GRADE, INHERITED AND UNCHANGED: I DID NOT READ THE DGM CODE.**  The
-- audited module says so and this says so again — no request to
-- github.com was made, here or there.  What is checked is the
-- order-theoretic content of §2's sentence, on the assumption that the
-- sentence describes the released function correctly.  If §2 misread
-- it, nothing here is affected and nothing here defends §2.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target: `ExcludingPerfectScorersRemovesOnlyGainlessCandidates`.
--
-- **THE MODULE TITLE IS EARNED, AND THE DANGEROUS CONVERSE IS ALREADY
-- DISCLAIMED.**  `Only` here is the direction REMOVED ⟹ GAINLESS, which
-- is exactly `noStrictImprovementAtTheCap`.  The reverse reading —
-- every gainless candidate is removed — is false in general, and that
-- module's §"WHAT IS NOT CLAIMED" says so in its own words: the cap
-- bounds the score, it does not populate it.  **This is the first
-- target in the sweep whose `Only` was already guarded against its own
-- second reading**, and it is worth recording as such.
--
-- **THE FAULT IS ONE LEVEL DOWN, IN A THEOREM NAME.**  §3 is called
-- `theSeamIsInvisibleExactlyWhenNobodyIsPerfect` and proves ONE
-- direction: if no agent attains the cap, eligibility keeps every
-- member.  The converse — if eligibility keeps every member of every
-- list, then no agent attains the cap — is not there, and the module's
-- §"WHAT IS NOT CLAIMED" lists the sampling weights, the ℕ-vs-accuracy
-- gap, the modelling of "perfect", and seams 2 and 4, but not this.
-- **Same defect as ecb432c2, one level in: `Exactly` unearned, this
-- time in a theorem's name rather than a module's.**
--
-- **AND THE CONVERSE IS SHORT, WITH A ONE-ELEMENT LIST.**  If `a`
-- attains the cap, feed the invisibility statement `a ∷ []`.  It
-- returns `a` as a member of `eligible (a ∷ [])`; every member of a
-- filtered list satisfies the predicate (`filterDecOnlyKeepsSatisfiers`);
-- so `Imperfect a`, which contradicts `AtCap a`.  Diagnostic (1) placed
-- it before it was written: the two sides are joined by a FILTER whose
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
--
-- WHAT IS NOT CLAIMED.  Nothing empirical: no code was read and no
-- corpus scanned.  Nothing about SAMPLING WEIGHTS — `p_i` and the
-- exploration mass `η` do not appear, so no share of wasted budget is
-- computed here any more than there.  "Perfect" is still attaining a
-- stated cap, and no claim is made that the DGM's notion is that.
-- Scores are ℕ; §2's are accuracies.  Seams 2 and 4 are untouched.
-- The invisibility statement quantified over ALL lists is what gets
-- refuted; nothing is claimed about a fixed archive that happens to
-- omit its perfect agents.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact
  using (All ; filterDecOnlyKeepsSatisfiers)
open import NaturalMachine.ExcludingPerfectScorersRemovesOnlyGainlessCandidates
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
