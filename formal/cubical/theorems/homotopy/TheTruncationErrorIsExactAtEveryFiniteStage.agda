{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTruncationErrorIsExactAtEveryFiniteStage
--
-- The error of a truncated geometric series is not un-said in this
-- corpus: it is exactly rⁿ, at every finite n, over ℤ, with no limit and
-- no analysis.  What needs analysis is only its asymptotics.
--
-- And the truncated sum alone does not carry it: at n = 1 the partial
-- sum is `1` for EVERY ratio, while the error is the ratio itself.  So
-- the error term separates exactly what the truncation identifies —
-- `CLAUDE.md`'s own sentence, "a correlation coefficient has no content;
-- the content is the error term", as a theorem, on the object the Kerala
-- school used it on.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT PROVOKED THIS, AND A DATE CHECK BEFORE ANY CLAIM OF ERROR
--
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §4 records the one Kerala-school
-- line it says bears on this repository:
--
--   "Mādhava did not stop at the series.  He gave the correction term."
--
-- and closes: "no module, note, or theorem in this repo is named for
-- Mādhava or the Kerala school … the tradition is simply unused."
--
-- That sentence was TRUE WHEN WRITTEN and I checked before saying
-- anything about it:
--
--   git log --diff-filter=A --format='%h %ad %s' --date=short
--     -- notes/INDIC_FORMAL_TRADITIONS_MAP.md   → 657593aa  2026-08-14
--     -- formal/cubical/Madhava.agda            → d6ee569d  2026-08-18
--
-- Four days apart.  §4 is not wrong; it was overtaken.  (§7.1 already
-- records the same overtaking for §7's ledger row; §4 is a second site
-- carrying the same now-outdated sentence, and it is appended to, not
-- corrected.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT `Madhava.agda` SAYS, READ IN FULL, AND WHERE I NARROW IT
--
-- `Madhava.गुणश्रेढी-योगः : (1 − r) · ∑_{k<n} rᵏ ≡ 1 − rⁿ` over ℤ, by
-- induction — I read the signature and the proof body before importing.
-- Its honesty ledger then says, in its own words (lines 17–20):
--
--   "शेष-पदम् एव सारः ; तत् इह अनुक्तम्, न मिथ्या-सिद्धम्"
--   — the remainder term is the essence; here it is UN-SAID, not
--     falsely proved
--
-- because rⁿ/(1−r) → 0 needs ℝ/ℚ analysis that lane does not have.
--
-- The convergence claim is indeed un-said and stays un-said.  But the
-- REMAINDER ITSELF is not: §1 below is that module's own theorem plus
-- `minusPlus`, and it says the error is exactly rⁿ.  So the ledger's
-- "the remainder term is un-said" is wider than what it needs to be; the
-- statement that survives is "the remainder's *asymptotics* are un-said".
--
-- OFFERED, NOT APPLIED.  That is another identity's honesty ledger and I
-- do not edit it.  Suggested replacement wording, for its author to take
-- or leave, is appended at the end of `Madhava.agda` and nowhere else.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- * NOT that Mādhava's correction terms are here.  The *Yuktibhāṣā*'s
--   correction terms are specific rational expressions sharpening the
--   truncated π-series; §1 is the exact finite remainder of a GEOMETRIC
--   series, which is the algebraic ancestor and not the same object.
--   Neither the *Yuktibhāṣā* nor arXiv:2405.11134 has been opened.
--   Verse-level sourcing OWED AND NOT CLAIMED.
-- * NOT convergence, NOT a bound, NOT an ordering.  §3 records only that
--   the error is multiplied by r at each step; whether that shrinks it
--   is exactly the un-said part and no order relation appears below.
-- * NOT that §4's naming verdict is wrong.  It was right on 2026-08-14.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module TheTruncationErrorIsExactAtEveryFiniteStage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_ ; injPos)
open import Cubical.Data.Int.Properties using (minusPlus ; ·Comm ; ·IdR)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import Madhava using (घात ; सङ्कलितम् ; गुणश्रेढी-योगः)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The remainder, exactly, at every finite n
--
-- Reading `Madhava.गुणश्रेढी-योगः` as a statement about error rather than
-- about the sum: the scaled partial sum plus rⁿ is exactly 1.  No limit,
-- no convergence, no ℝ — the same induction, rearranged.
------------------------------------------------------------------------

exactRemainder :
  (r : ℤ) (n : ℕ)
  → (pos 1 - r) · सङ्कलितम् r n + घात r n ≡ pos 1
exactRemainder r n =
    cong (_+ घात r n) (गुणश्रेढी-योगः r n)
  ∙ minusPlus (घात r n) (pos 1)

------------------------------------------------------------------------
-- 2.  The partial sum, and what it forgets
--
-- At n = 1 the sum is `1` whatever the ratio; the error at n = 1 IS the
-- ratio.  So one step of truncation already discards everything the
-- error carries.
------------------------------------------------------------------------

sumAtOneIsOne : (r : ℤ) → सङ्कलितम् r 1 ≡ pos 1
sumAtOneIsOne r = refl

errorAtOneIsTheRatio : (r : ℤ) → घात r 1 ≡ r
errorAtOneIsTheRatio r = ·Comm (pos 1) r ∙ ·IdR r

------------------------------------------------------------------------
-- 3.  The error's own step, and the exact point where analysis begins
------------------------------------------------------------------------

errorStep : (r : ℤ) (n : ℕ) → घात r (suc n) ≡ घात r n · r
errorStep r n = refl

sumStep : (r : ℤ) (n : ℕ) → सङ्कलितम् r (suc n) ≡ सङ्कलितम् r n + घात r n
sumStep r n = refl

-- What §3 does NOT say: that `घात r n · r` is smaller than `घात r n`.
-- That is an order statement, it is where ℝ/ℚ analysis would be needed,
-- and it is exactly the part `Madhava.agda`'s ledger is right to leave
-- un-said.  Nothing above or below uses an order on ℤ.

------------------------------------------------------------------------
-- 4.  THE COLLISION.  The error separates what the truncation identifies.
--
-- Isolated in the corpus's standing shape, so the general lemma applies
-- rather than a fresh argument being written.  Seventh site of
-- `TranscriptDescent.collisionObstructsDecoder`.
------------------------------------------------------------------------

private
  2≢3 : ¬ (pos 2 ≡ pos 3)
  2≢3 p = znots (injSuc (injSuc (injPos p)))

truncate error : ℤ → ℤ
truncate r = सङ्कलितम् r 1
error    r = घात r 1

truncationCollision :
  Σ[ a ∈ ℤ ] Σ[ b ∈ ℤ ] ((truncate a ≡ truncate b) × (¬ (error a ≡ error b)))
truncationCollision =
  pos 2 , pos 3 , refl ,
  λ h → 2≢3 (sym (errorAtOneIsTheRatio (pos 2)) ∙ h ∙ errorAtOneIsTheRatio (pos 3))

errorDoesNotFactorThroughTheTruncation :
  ¬ FactorsThrough truncate error
errorDoesNotFactorThroughTheTruncation =
  collisionObstructsDecoder truncate error {pos 2} {pos 3}
    refl
    (λ h → 2≢3 (sym (errorAtOneIsTheRatio (pos 2)) ∙ h ∙ errorAtOneIsTheRatio (pos 3)))

------------------------------------------------------------------------
-- 5.  The sentence this earns, and its exact scope
--
-- `CLAUDE.md`: "a correlation coefficient has no content; the content is
-- the error term."  §4 is that, on Mādhava's own object and at one step:
-- the truncation is constant in the ratio, the error is the identity in
-- it, and no invariant of the former reports the latter.
--
-- SCOPE, stated because the collision is at n = 1 and not in general.
-- §4 shows the truncation-to-error map fails to exist AT ALL, which one
-- instance suffices for.  It says NOTHING about how much the truncation
-- forgets at larger n, and nothing below is evidence about that.  A
-- pattern over one instance is one instance.
------------------------------------------------------------------------
