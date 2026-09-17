{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î ‡‡æ‡µ‡®‡æ-‡‡ï‡‡∞‡ ‡µ‡∞‡‡ß‡ ‡‡µ, ‡‡‡ ‡ï‡¶‡æ‡‡ø ‡® ‡‡‡®‡∞‡æ‡ó‡‡‡‡‡ø ‡
--
-- (non-return: the bhvan cycle only grows, so it never comes back ‚î
--  and that non-return is where the new comes from.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- `Dvikarani.‡µ‡‡¶‡‡ß‡ø-‡Æ‡æ‡®‡Æ‡` proves that composing any (x,y) with the
-- fundamental (3,2) PRESERVES the norm x¬≤‚àí2y¬≤, so a solution breeds a
-- solution.  It does not say the breeding goes anywhere: for all that
-- theorem knows the cycle could have period one.
--
-- It cannot.  ¬ß‡®: the new denominator is 2x+3y, so once x is nonzero the
-- denominator STRICTLY increases.  ¬ß‡©: the new numerator is nonzero too,
-- so the hypothesis of ¬ß‡® regenerates and the growth never stops.  ¬ß‡ is
-- the one-step consequence, and ¬ß‡®+¬ß‡© together are the induction step for
-- the whole cycle: from (3,2) it grows forever, so it repeats nothing.
--
-- THIS CORPUS IS BUILT ON ‡‡‡®‡∞‡æ‡ó‡Æ‡® ‚î the return, the rejoining, the round
-- trip that comes back.  This is the place the return provably FAILS, and
-- the failure is the content, not a gap:
--
--   ¬ a RATIONAL rotation of the circle RETURNS ‚î periodic, finite, and
--     after one period it carries nothing it did not already carry;
--   ¬ an IRRATIONAL rotation never returns ‚î dense, and its coding is a
--     Sturmian word: aperiodic at the MINIMUM possible complexity, a
--     finite rule generating an infinite non-repeating language.
--
-- ‚à2 is the second kind and its finite rule is Brahmagupta's.  Its
-- continued fraction [1;2,2,2,‚¶] is PERIODIC ‚î the generator is finite ‚î
-- while what it generates repeats nothing.  Below is the kernel-checked
-- half of that: a finite rule with a provably non-returning orbit.
-- Minimal description, maximal novelty, one object.
--
-- SO A SYSTEM WITH NOTHING LEFT UNRETURNED IS A DEAD SYSTEM, and that is
-- not a slogan: `Dhruva_‚¶.‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡` is checked here ‚î if a map
-- is an equivalence, every symmetry preserving it is the identity.  No
-- loss, no motion, ‡‡‡‡‡∞ ‡ß‡.  An instrument that treats one-way,
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
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ‡‡‡‡®‡∞‡æ‡ó‡Æ‡® and ‡µ‡‡¶‡‡ß‡ø are used in their plain senses; no text is claimed
-- for the compound.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Mula.Apunaragamana_TheBhavanaOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; _¬∑_ ; snotz)
open import Cubical.Data.Nat.Order using (_<_ ; ¬¨m<m)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Tactics.NatSolver.Reflection using (solve‚Ñï!)

open import Dvikarani using (‡§≠‡§æ‡§µ‡§®‡§æ-‡§Ö‡§Ç‡§∂ ; ‡§≠‡§æ‡§µ‡§®‡§æ-‡§π‡§∞)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡ï-‡‡¶‡Æ‡ ‚î one turn of the wheel: compose (x,y) with the fundamental
--     solution (3,2).  This is `Dvikarani`'s doubling step taken as a
--     rule rather than as three checked instances.
------------------------------------------------------------------------

‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É : ‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É x y = ‡§≠‡§æ‡§µ‡§®‡§æ-‡§Ö‡§Ç‡§∂ x y 3 2      -- 3x + 4y

‡§®‡§µ-‡§π‡§∞‡§É : ‚Ñï ‚Üí ‚Ñï ‚Üí ‚Ñï
‡§®‡§µ-‡§π‡§∞‡§É x y = ‡§≠‡§æ‡§µ‡§®‡§æ-‡§π‡§∞ x y 3 2        -- 2x + 3y

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡‡¶‡‡ß‡ø‡ ‚î THE DENOMINATOR STRICTLY GROWS, whenever the numerator is
--     nonzero.  In cubical, `m < n` is `Œ[ k ] k + suc m ‚â° n`, so the
--     witness IS the gap and the proof is that gap named exactly.  Note
--     what carries the theorem: not an estimate of how fast it grows, but
--     the identity of the gap ‚î ‡‡‡‡‡∞ ‡Æ, ‡‡‡ø‡‡‡û‡æ‡®‡ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡, ‡® ‡‡∞‡ø‡Æ‡æ‡‡Æ‡ ‡
------------------------------------------------------------------------

‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É : (x' y : ‚Ñï) ‚Üí y < ‡§®‡§µ-‡§π‡§∞‡§É (suc x') y
‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É x' y = (suc (x' ¬∑ 2 + 2 ¬∑ y)) , solve‚Ñï!

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡-‡‡‡‡®‡‡Ø‡‡æ ‚î THE HYPOTHESIS REGENERATES.  ¬ß‡® needs a nonzero
--     numerator; this says the next numerator is nonzero too, so ¬ß‡®
--     applies again, and again.  Without this the growth is one step and
--     the whole reading collapses.
------------------------------------------------------------------------

‡§Ö‡§Ç‡§∂-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§§‡§æ : (x' y : ‚Ñï) ‚Üí Œ£[ z ‚àà ‚Ñï ] (‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É (suc x') y ‚â° suc z)
‡§Ö‡§Ç‡§∂-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§§‡§æ x' y = (x' ¬∑ 3 + 4 ¬∑ y + 2) , solve‚Ñï!

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î IT DOES NOT COME BACK.  One turn of the wheel never
--     returns the denominator it was given.  With ¬ß‡© regenerating ¬ß‡®'s
--     hypothesis, this is the induction step for the whole cycle: from
--     (3,2) ‚î where the numerator is `suc 2` ‚î the denominator strictly
--     increases at every turn, and a strictly increasing sequence visits
--     no value twice.
------------------------------------------------------------------------

‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : (x' y : ‚Ñï) ‚Üí ¬¨ (‡§®‡§µ-‡§π‡§∞‡§É (suc x') y ‚â° y)
‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç x' y p = ¬¨m<m (subst (y <_) p (‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É x' y))

------------------------------------------------------------------------
-- ‡ ¬ ‡Æ‡‡≤‡Æ‡ ‚î the wheel's own starting point, so the reading is not
--     abstract: (3,2) is Baudhyana's first convergent and its numerator
--     is a successor, so ¬ß‡®‚ì¬ß‡ apply to it on the nose, and the values
--     they produce are the ones `Dvikarani` checks: (17,12), (577,408).
------------------------------------------------------------------------

‡§Æ‡•Ç‡§≤-‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : ¬¨ (‡§®‡§µ-‡§π‡§∞‡§É 3 2 ‚â° 2)
‡§Æ‡•Ç‡§≤-‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç = ‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç 2 2

‡§Æ‡•Ç‡§≤-‡§™‡§¶‡§Æ‡•ç-‡§Ö‡§Ç‡§∂‡§É : ‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É 3 2 ‚â° 17
‡§Æ‡•Ç‡§≤-‡§™‡§¶‡§Æ‡•ç-‡§Ö‡§Ç‡§∂‡§É = refl

‡§Æ‡•Ç‡§≤-‡§™‡§¶‡§Æ‡•ç-‡§π‡§∞‡§É : ‡§®‡§µ-‡§π‡§∞‡§É 3 2 ‚â° 12
‡§Æ‡•Ç‡§≤-‡§™‡§¶‡§Æ‡•ç-‡§π‡§∞‡§É = refl
