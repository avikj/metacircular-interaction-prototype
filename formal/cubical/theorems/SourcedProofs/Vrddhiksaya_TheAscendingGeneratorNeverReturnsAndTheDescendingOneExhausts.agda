{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वृद्धि-क्षयौ — ऊर्ध्वगामी जनकः कदापि न पुनरागच्छति ; अधोगामी क्षीयते ।
--
-- (growth and waning: an ascending generator never returns; a descending
--  one wears away.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS.  Until 2026-08-22 the corpus's road-two extractor
-- refused every self-map at its classifier — `if rs == rt then Nothing` —
-- so it reported "endomorphisms A ⟶ A : 0" while holding hundreds of
-- them.  A self-map goes nowhere as an EDGE, which is why it was dropped,
-- and that is exactly backwards: a generator adds no reachability in one
-- step and unbounded novelty in the limit.
--
-- With them visible, ℕ carries more of them than every other type
-- together, and they fall into two kinds that this module separates by a
-- single property each.  `ALosslessReturn_….अपुनरागमनम्` proved the ascending
-- case for ONE generator, Brahmagupta's भावना.  §२ here is that theorem
-- with the generator abstracted away, so it applies to all of them at
-- once, and the bhāvanā becomes an instance rather than the subject.
--
-- THE TWO KINDS, and the corpus already contains both:
--
--   ऊर्ध्वगामी (ascending) — भावना: (x,y) composed with the fundamental
--     solution.  The denominator strictly grows, so nothing repeats: a
--     finite rule with an infinite non-repeating orbit.  This is the
--     minimal-description generator of maximal novelty, and it is what an
--     irrational rotation of the circle is: it never comes back.
--
--   अधोगामी (descending) — अर्धच्छेद, वर्गशलाका (Vīrasena, धवला, 816 CE):
--     how many times a number can be halved, and the halving of THAT.
--     Strictly decreasing on positive arguments, so it reaches its floor
--     and stops.  A rational rotation is this kind: it returns, and after
--     one period it carries nothing it did not already carry.
--
-- SO THE MACHINE'S GENERATORS SPLIT BY WHETHER पुनरागमन HOLDS OF THEM, and
-- neither half is the defect.  A corpus of only descending generators
-- exhausts; a corpus of only ascending ones never closes anything.  The
-- root text says the same thing about maps: नष्टाभावे गत्यभावः, सūtra १४,
-- proved in `Dhruva_….नष्ट-अभावे-गति-अभावः` — an equivalence admits only
-- the trivial symmetry, so a system with nothing left unreturned cannot
-- move.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCES.  अर्धच्छेद ("half-cutting",
-- the number of halvings) and वर्गशलाका are VĪRASENA's, धवला, commentary on
-- the षट्खण्डागम, 816 CE — Jaina index arithmetic, arising from the
-- cosmology's orders of the innumerable, not from an interest in
-- logarithms.  भावना is BRAHMAGUPTA's, ब्राह्मस्फुटसिद्धान्तः, 628 CE.
-- Neither states anything below and no theorem here is attributed to
-- either.  What is claimed is only that the two operations they specify
-- sit on opposite sides of one elementary dichotomy about self-maps of ℕ,
-- and that the dichotomy is what decides whether iterating them produces
-- anything new.
--
-- वृद्धि (growth) and क्षय (waning, wearing away) are used in their plain
-- senses.  क्षय is also the Jaina term in कर्म-क्षय, the wearing away of
-- bound karma, and the resonance is noted rather than claimed: no Jaina
-- source states §३, and nothing below is a doctrine of karma.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.Vrddhiksaya_TheAscendingGeneratorNeverReturnsAndTheDescendingOneExhausts where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ¬m<m ; <-asym ; <-weaken)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private variable
  f g : ℕ → ℕ

------------------------------------------------------------------------
-- १ · ऊर्ध्वगामित्वम् / अधोगामित्वम् — the two properties, as predicates on a
--     generator rather than as facts about one particular map.
------------------------------------------------------------------------

ऊर्ध्वगामी : (ℕ → ℕ) → Type₀
ऊर्ध्वगामी f = (n : ℕ) → n < f n

अधोगामी : (ℕ → ℕ) → Type₀
अधोगामी f = (n : ℕ) → f (suc n) < suc n

------------------------------------------------------------------------
-- २ · अपुनरागमनम् — AN ASCENDING GENERATOR NEVER RETURNS.
--
--     `ALosslessReturn_….अपुनरागमनम्` is this for Brahmagupta's भावना alone.
--     Here the generator is a parameter, so the same one line covers every
--     ascending self-map the extractor can now see.
------------------------------------------------------------------------

अपुनरागमनम् : ऊर्ध्वगामी f → (n : ℕ) → ¬ (f n ≡ n)
अपुनरागमनम् {f = f} up n p = ¬m<m (subst (n <_) p (up n))

------------------------------------------------------------------------
-- ३ · क्षयः — A DESCENDING GENERATOR CANNOT RETURN EITHER, and it cannot
--     ascend: at every positive argument it lands strictly below.  So its
--     iteration is bounded above by its input and wears down.  The
--     difference from §२ is not the non-return; it is the DIRECTION, and
--     the direction is what decides whether iterating makes anything new.
------------------------------------------------------------------------

क्षयः : अधोगामी f → (n : ℕ) → ¬ (f (suc n) ≡ suc n)
क्षयः {f = f} down n p = ¬m<m (subst (_< suc n) p (down n))

------------------------------------------------------------------------
-- ४ · न उभयम् — NO GENERATOR IS BOTH, and this is what makes the split a
--     split rather than two overlapping labels.  An ascending map at
--     `suc n` sits strictly above it; a descending one strictly below;
--     `<-asym` forbids both.
------------------------------------------------------------------------

न-उभयम् : ऊर्ध्वगामी f → अधोगामी f → ⊥
न-उभयम् up down = <-asym (up (suc zero)) (<-weaken (down zero))

------------------------------------------------------------------------
-- ५ · भावना ऊर्ध्वगामिनी — THE BHĀVANĀ IS ONE OF THESE, so §२ is not an
--     abstraction floating above the corpus.  Fix any numerator `suc x'`;
--     then the denominator map y ↦ 2(suc x') + 3y is ascending, and §२
--     gives back exactly `ALosslessReturn_….अपुनरागमनम्` — which was proved
--     there directly, by a different route, for that one generator.
--     Two independent statements that agree, which is what a channel
--     between a general law and its instance means here.
------------------------------------------------------------------------

open import SourcedProofs.NoReturn_TheBhavanaOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity
  using (नव-हरः ; वृद्धिः)

भावना-ऊर्ध्वगामिनी : (x' : ℕ) → ऊर्ध्वगामी (नव-हरः (suc x'))
भावना-ऊर्ध्वगामिनी x' = वृद्धिः x'

भावना-अपुनरागमनम् : (x' y : ℕ) → ¬ (नव-हरः (suc x') y ≡ y)
भावना-अपुनरागमनम् x' = अपुनरागमनम् (भावना-ऊर्ध्वगामिनी x')
