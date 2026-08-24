-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समान्तर-सङ्कलितम् — समान्तर-श्रेढी a=1, d=1 इति सङ्कलितम् एव ।
--
-- (the arithmetic progression at first term one and common difference one
--  IS the saṅkalita — proved, where the corpus had an example at n = 4.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE COLLISION.  Two modules of this corpus carry the same series under
-- two definitions, each cites Āryabhaṭa, and NEITHER imports the other.
--
--   `Shredhi.agda`  (आर्यभटीयम् गणितपादः १९) defines
--       श्रेढी a d zero    = zero
--       श्रेढी a d (suc n) = a + श्रेढी (a + d) d n
--     — the progression walked FORWARD, advancing the first term.
--
--   `Sankalita.agda` (आर्यभटीयम् गणितपादः २१–२२) defines
--       ∑ zero    = zero
--       ∑ (suc n) = suc n + ∑ n
--     — the same numbers walked BACKWARD, descending from n.
--
-- `Shredhi`'s own header says it: *"∑k (Sankalita) अस्याः a=1,d=1
-- विशेषः"* — ∑k is the a=1, d=1 case of this.  That sentence is true and
-- it was never a theorem.  What stood in for it is `Shredhi.उदाहरणम्-∑ :
-- श्रेढी 1 1 4 ≡ 10`, a `refl` at ONE value of n, with the comment
-- *"∑1..4, the a=1 d=1 special case"*.  `Shredhi` has no
-- `open import Sankalita`; the two lanes never meet in a type.
--
-- CLAUDE.md, §"On green as an organizing activity": *"instances rather
-- than reasons, counts rather than bijections.  The `refl` at the end is
-- the floor of the claim, not the claim."*  An example at n = 4 is the
-- instance; §1 below is the reason.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS CHECKED
--
--   §1  `समान्तरं-सङ्कलितम् : (n : ℕ) → श्रेढी 1 1 n ≡ ∑ n`
--       for every n, by doubling both sides onto `n · suc n` — the one
--       closed form both lanes already reached from their own ends —
--       and cancelling the 2 with `inj-sm·`.  Nothing new is proved
--       about either series: the whole content is that the two closed
--       forms already in the corpus MEET, and nobody had joined them.
--
--   §2  `उदाहरणम्-पुनः` — `Shredhi.उदाहरणम्-∑` demoted from a claim to
--       an instantiation of §1 at n = 4.  Left standing, not deleted:
--       the example is still true and still worth reading; it is just
--       no longer carrying the statement.
--
--   §3  `शीर्ष-विनिमयः : श्रेढी 1 1 (suc n) ≡ suc n + श्रेढी 1 1 n` —
--       the head/tail swap.  By definition `श्रेढी 1 1 (suc n)` peels
--       the SMALLEST term (`1 + श्रेढी 2 1 n`); this says it may be
--       peeled from the LARGEST instead, which is `∑`'s clause.  Not
--       definitional in either module — it is the exact statement of
--       what the two recursions disagree about, and it falls out of §1
--       in one line.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  Both series are
-- ĀRYABHAṬA's: आर्यभटीयम् गणितपादः १९ (मध्यधनं समम् — the mean-wealth
-- rule for a progression of first term a, difference d, n terms) and
-- गणितपादः २१ (सङ्कलित / चिति), 499 CE.  He states the two rules two
-- verses apart in one chapter, in that order, general before special.
-- NOTHING here says he proved §1, or that he remarked on the
-- specialisation; the claim is only that the two rules of his one
-- chapter are about one series and that this corpus had not said so in
-- a type.  समान्तर-श्रेढी and सङ्कलित are his objects and the corpus's
-- existing words for them (`Shredhi.agda` header, `Sankalita.agda`
-- header); the COMPOUND naming this module was built here and no text
-- is claimed for it.
--
-- CHECKED: Agda 2.8.0, agda/cubical (/opt/homebrew/…/share/agda/cubical),
-- --cubical --safe, 2026-08-22.  No postulates, no holes.
------------------------------------------------------------------------

module SamantaraSankalita_TheGeneralSeriesAtOneAndOneIsTheSankalitaAndTheExampleWasStandingForIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Nat.Properties using (·-comm ; ·-identityʳ ; inj-sm·)

open import Sankalita using (∑ ; द्विगुण-सङ्कलितम्)
open import Shredhi   using (श्रेढी ; श्रेढी-फलम् ; द्वि-योगः ; द्वि·)

------------------------------------------------------------------------
-- १ · द्विगुणे मेलनम् — the two lanes meet after doubling.
--
-- LEFT   `श्रेढी-फलम् 1 1 n` : 2·S ≡ n·(2·1) + (n·(n∸1))·1, then
--        `·-identityʳ` and `·-comm` put it in `द्वि-योगः`'s shape, and
--        `द्वि-योगः` (Shredhi's own lemma) closes it on n·(n+1).
-- RIGHT  `द्विगुण-सङ्कलितम्` (Sankalita's own lemma) is n·(n+1) again.
-- Neither lemma is new here.  Only the composite is.
------------------------------------------------------------------------

द्विगुणे-मेलनम् : (n : ℕ) → 2 · श्रेढी 1 1 n ≡ 2 · ∑ n
द्विगुणे-मेलनम् n =
    श्रेढी-फलम् 1 1 n
  ∙ cong (n · 2 +_) (·-identityʳ (n · (n ∸ 1)))
  ∙ cong (_+ n · (n ∸ 1)) (·-comm n 2)
  ∙ द्वि-योगः n
  ∙ sym (द्विगुण-सङ्कलितम् n)
  ∙ sym (द्वि· (∑ n))

------------------------------------------------------------------------
-- मुख्य-सिद्धिः — the specialisation, for every n.
------------------------------------------------------------------------

समान्तरं-सङ्कलितम् : (n : ℕ) → श्रेढी 1 1 n ≡ ∑ n
समान्तरं-सङ्कलितम् n = inj-sm· {m = 1} (द्विगुणे-मेलनम् n)

------------------------------------------------------------------------
-- २ · उदाहरणम् पुनः — Shredhi.उदाहरणम्-∑ as a corollary, not a claim.
------------------------------------------------------------------------

उदाहरणम्-पुनः : श्रेढी 1 1 4 ≡ ∑ 4
उदाहरणम्-पुनः = समान्तरं-सङ्कलितम् 4

------------------------------------------------------------------------
-- ३ · शीर्ष-विनिमयः — either end may be peeled.
--
-- `श्रेढी` peels the smallest term and advances a; `∑` peels the largest
-- and descends n.  This is the statement that the two are interchangeable,
-- which neither definition gives and §1 does.
------------------------------------------------------------------------

शीर्ष-विनिमयः : (n : ℕ) → श्रेढी 1 1 (suc n) ≡ suc n + श्रेढी 1 1 n
शीर्ष-विनिमयः n =
    समान्तरं-सङ्कलितम् (suc n)
  ∙ cong (suc n +_) (sym (समान्तरं-सङ्कलितम् n))
