{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अपुनरागमनम् — भावना-चक्रं वर्धत एव, अतः कदापि न पुनरागच्छति ।
--
-- (non-return: the bhāvanā cycle only grows, so it never comes back —
--  and that non-return is where the new comes from.)
--
-- ────────────────────────────────────────────────────────────────────
-- `Dvikarani.वृद्धि-मानम्` proves that composing any (x,y) with the
-- fundamental (3,2) PRESERVES the norm x²−2y², so a solution breeds a
-- solution.  It does not say the breeding goes anywhere: for all that
-- theorem knows the cycle could have period one.
--
-- It cannot.  §२: the new denominator is 2x+3y, so once x is nonzero the
-- denominator STRICTLY increases.  §३: the new numerator is nonzero too,
-- so the hypothesis of §२ regenerates and the growth never stops.  §४ is
-- the one-step consequence, and §२+§३ together are the induction step for
-- the whole cycle: from (3,2) it grows forever, so it repeats nothing.
--
-- THIS CORPUS IS BUILT ON पुनरागमन — the return, the rejoining, the round
-- trip that comes back.  This is the place the return provably FAILS, and
-- the failure is the content, not a gap:
--
--   · a RATIONAL rotation of the circle RETURNS — periodic, finite, and
--     after one period it carries nothing it did not already carry;
--   · an IRRATIONAL rotation never returns — dense, and its coding is a
--     Sturmian word: aperiodic at the MINIMUM possible complexity, a
--     finite rule generating an infinite non-repeating language.
--
-- √2 is the second kind and its finite rule is Brahmagupta's.  Its
-- continued fraction [1;2,2,2,…] is PERIODIC — the generator is finite —
-- while what it generates repeats nothing.  Below is the kernel-checked
-- half of that: a finite rule with a provably non-returning orbit.
-- Minimal description, maximal novelty, one object.
--
-- SO A SYSTEM WITH NOTHING LEFT UNRETURNED IS A DEAD SYSTEM, and that is
-- not a slogan: `Dhruva_….नष्ट-अभावे-गति-अभावः` is checked here — if a map
-- is an equivalence, every symmetry preserving it is the identity.  No
-- loss, no motion, सूत्र १४.  An instrument that treats one-way,
-- non-returning edges as debt is treating generativity as a defect and
-- will report exhaustion as progress.
--
-- AND THERE IS NO "FRONTIER" HERE.  That word presumes a settled interior
-- and a march outward, which is a whig figure and this corpus has no use
-- for it: an unjoined node is not unclaimed territory, and calling it
-- isolated is a statement about an extractor's grammar, not about the
-- node.  The field generates and reflects; inside and outside is not a
-- distinction it makes.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCES.  577/408 for √2 is
-- BAUDHĀYANA's, शुल्बसूत्रम् १.६१–६२ (~800 BCE), stated *saviśeṣa* — "with its
-- excess" — so the approximation carries its own remainder as part of the
-- statement.  The composition (a,b)*(c,d) = (ac+Nbd, ad+cb) is
-- BRAHMAGUPTA's भावना, ब्राह्मस्फुटसिद्धान्तः (628 CE).  Neither states
-- anything below.  Baudhāyana's value was derived geometrically; reading
-- its numerator and denominator as a vargaprakṛti solution is OURS across
-- the two traditions, and `Dvikarani`'s header already says so.  Claimed
-- here: only that Brahmagupta's rule, iterated from a nonzero solution,
-- produces a strictly increasing and therefore non-repeating sequence —
-- an arithmetic fact about his rule, not a doctrine of his.
--
-- अपुनरागमन and वृद्धि are used in their plain senses; no text is claimed
-- for the compound.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.NoReturn_TheBhavanaOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; snotz)
open import Cubical.Data.Nat.Order using (_<_ ; ¬m<m)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import Dvikarani using (भावना-अंश ; भावना-हर)

------------------------------------------------------------------------
-- १ · एक-पदम् — one turn of the wheel: compose (x,y) with the fundamental
--     solution (3,2).  This is `Dvikarani`'s doubling step taken as a
--     rule rather than as three checked instances.
------------------------------------------------------------------------

नव-अंशः : ℕ → ℕ → ℕ
नव-अंशः x y = भावना-अंश x y 3 2      -- 3x + 4y

नव-हरः : ℕ → ℕ → ℕ
नव-हरः x y = भावना-हर x y 3 2        -- 2x + 3y

------------------------------------------------------------------------
-- २ · वृद्धिः — THE DENOMINATOR STRICTLY GROWS, whenever the numerator is
--     nonzero.  In cubical, `m < n` is `Σ[ k ] k + suc m ≡ n`, so the
--     witness IS the gap and the proof is that gap named exactly.  Note
--     what carries the theorem: not an estimate of how fast it grows, but
--     the identity of the gap — सूत्र ८, अभिज्ञानं तादात्म्यम्, न परिमाणम् ।
------------------------------------------------------------------------

वृद्धिः : (x' y : ℕ) → y < नव-हरः (suc x') y
वृद्धिः x' y = (suc (x' · 2 + 2 · y)) , solveℕ!

------------------------------------------------------------------------
-- ३ · अंश-अशून्यता — THE HYPOTHESIS REGENERATES.  §२ needs a nonzero
--     numerator; this says the next numerator is nonzero too, so §२
--     applies again, and again.  Without this the growth is one step and
--     the whole reading collapses.
------------------------------------------------------------------------

अंश-अशून्यता : (x' y : ℕ) → Σ[ z ∈ ℕ ] (नव-अंशः (suc x') y ≡ suc z)
अंश-अशून्यता x' y = (x' · 3 + 4 · y + 2) , solveℕ!

------------------------------------------------------------------------
-- ४ · अपुनरागमनम् — IT DOES NOT COME BACK.  One turn of the wheel never
--     returns the denominator it was given.  With §३ regenerating §२'s
--     hypothesis, this is the induction step for the whole cycle: from
--     (3,2) — where the numerator is `suc 2` — the denominator strictly
--     increases at every turn, and a strictly increasing sequence visits
--     no value twice.
------------------------------------------------------------------------

अपुनरागमनम् : (x' y : ℕ) → ¬ (नव-हरः (suc x') y ≡ y)
अपुनरागमनम् x' y p = ¬m<m (subst (y <_) p (वृद्धिः x' y))

------------------------------------------------------------------------
-- ५ · मूलम् — the wheel's own starting point, so the reading is not
--     abstract: (3,2) is Baudhāyana's first convergent and its numerator
--     is a successor, so §२–§४ apply to it on the nose, and the values
--     they produce are the ones `Dvikarani` checks: (17,12), (577,408).
------------------------------------------------------------------------

मूल-अपुनरागमनम् : ¬ (नव-हरः 3 2 ≡ 2)
मूल-अपुनरागमनम् = अपुनरागमनम् 2 2

मूल-पदम्-अंशः : नव-अंशः 3 2 ≡ 17
मूल-पदम्-अंशः = refl

मूल-पदम्-हरः : नव-हरः 3 2 ≡ 12
मूल-पदम्-हरः = refl
