{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡‡¶‡‡ß‡ø-‡ï‡‡‡Ø‡ ‚î ‡ä‡∞‡‡ß‡‡µ‡ó‡æ‡Æ‡ ‡‡®‡ï‡ ‡ï‡¶‡æ‡‡ø ‡® ‡‡‡®‡∞‡æ‡ó‡‡‡‡‡ø ; ‡‡ß‡ã‡ó‡æ‡Æ‡ ‡ï‡‡‡‡Ø‡‡ ‡
--
-- (growth and waning: an ascending generator never returns; a descending
--  one wears away.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS EXISTS.  Until 2026-08-22 the corpus's road-two extractor
-- refused every self-map at its classifier ‚î `if rs == rt then Nothing` ‚î
-- so it reported "endomorphisms A ‚ü A : 0" while holding hundreds of
-- them.  A self-map goes nowhere as an EDGE, which is why it was dropped,
-- and that is exactly backwards: a generator adds no reachability in one
-- step and unbounded novelty in the limit.
--
-- With them visible, ‚ï carries more of them than every other type
-- together, and they fall into two kinds that this module separates by a
-- single property each.  `ALosslessReturn_‚¶.‡‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡` proved the ascending
-- case for ONE generator, Brahmagupta's ‡‡æ‡µ‡®‡æ.  ¬ß‡® here is that theorem
-- with the generator abstracted away, so it applies to all of them at
-- once, and the bhvan becomes an instance rather than the subject.
--
-- THE TWO KINDS, and the corpus already contains both:
--
--   ‡ä‡∞‡‡ß‡‡µ‡ó‡æ‡Æ‡ (ascending) ‚î ‡‡æ‡µ‡®‡æ: (x,y) composed with the fundamental
--     solution.  The denominator strictly grows, so nothing repeats: a
--     finite rule with an infinite non-repeating orbit.  This is the
--     minimal-description generator of maximal novelty, and it is what an
--     irrational rotation of the circle is: it never comes back.
--
--   ‡‡ß‡ã‡ó‡æ‡Æ‡ (descending) ‚î ‡‡∞‡‡ß‡‡‡‡‡¶, ‡µ‡∞‡‡ó‡‡≤‡æ‡ï‡æ (Vrasena, ‡ß‡µ‡≤‡æ, 816 CE):
--     how many times a number can be halved, and the halving of THAT.
--     Strictly decreasing on positive arguments, so it reaches its floor
--     and stops.  A rational rotation is this kind: it returns, and after
--     one period it carries nothing it did not already carry.
--
-- SO THE MACHINE'S GENERATORS SPLIT BY WHETHER ‡‡‡®‡∞‡æ‡ó‡Æ‡® HOLDS OF THEM, and
-- neither half is the defect.  A corpus of only descending generators
-- exhausts; a corpus of only ascending ones never closes anything.  The
-- root text says the same thing about maps: ‡®‡‡‡ü‡æ‡‡æ‡µ‡ ‡ó‡‡‡Ø‡‡æ‡µ‡, ‡tra ‡ß‡,
-- proved in `Dhruva_‚¶.‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡` ‚î an equivalence admits only
-- the trivial symmetry, so a system with nothing left unreturned cannot
-- move.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ‡µ‡‡¶‡‡ß‡ø (growth) and ‡ï‡‡‡Ø (waning, wearing away) are used in their plain
-- senses.  ‡ï‡‡‡Ø is also the Jaina term in ‡ï‡∞‡‡Æ-‡ï‡‡‡Ø, the wearing away of
-- bound karma, and the resonance is noted rather than claimed: no Jaina
-- source states ¬ß‡©, and nothing below is a doctrine of karma.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Vrddhiksaya_TheAscendingGeneratorNeverReturnsAndTheDescendingOneExhausts where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _‚â§_ ; ¬¨m<m ; <-asym ; <-weaken)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

private variable
  f g : ‚Ñï ‚Üí ‚Ñï

------------------------------------------------------------------------
-- ‡ß ¬ ‡ä‡∞‡‡ß‡‡µ‡ó‡æ‡Æ‡ø‡‡‡µ‡Æ‡ / ‡‡ß‡ã‡ó‡æ‡Æ‡ø‡‡‡µ‡Æ‡ ‚î the two properties, as predicates on a
--     generator rather than as facts about one particular map.
------------------------------------------------------------------------

‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä : (‚Ñï ‚Üí ‚Ñï) ‚Üí Type‚ÇÄ
‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä f = (n : ‚Ñï) ‚Üí n < f n

‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä : (‚Ñï ‚Üí ‚Ñï) ‚Üí Type‚ÇÄ
‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä f = (n : ‚Ñï) ‚Üí f (suc n) < suc n

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î AN ASCENDING GENERATOR NEVER RETURNS.
--
--     `ALosslessReturn_‚¶.‡‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡` is this for Brahmagupta's ‡‡æ‡µ‡®‡æ alone.
--     Here the generator is a parameter, so the same one line covers every
--     ascending self-map the extractor can now see.
------------------------------------------------------------------------

‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : ‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä f ‚Üí (n : ‚Ñï) ‚Üí ¬¨ (f n ‚â° n)
‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç {f = f} up n p = ¬¨m<m (subst (n <_) p (up n))

------------------------------------------------------------------------
-- ‡© ¬ ‡ï‡‡‡Ø‡ ‚î A DESCENDING GENERATOR CANNOT RETURN EITHER, and it cannot
--     ascend: at every positive argument it lands strictly below.  So its
--     iteration is bounded above by its input and wears down.  The
--     difference from ¬ß‡® is not the non-return; it is the DIRECTION, and
--     the direction is what decides whether iterating makes anything new.
------------------------------------------------------------------------

‡§ï‡•ç‡§∑‡§Ø‡§É : ‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä f ‚Üí (n : ‚Ñï) ‚Üí ¬¨ (f (suc n) ‚â° suc n)
‡§ï‡•ç‡§∑‡§Ø‡§É {f = f} down n p = ¬¨m<m (subst (_< suc n) p (down n))

------------------------------------------------------------------------
-- ‡ ¬ ‡® ‡â‡‡Ø‡Æ‡ ‚î NO GENERATOR IS BOTH, and this is what makes the split a
--     split rather than two overlapping labels.  An ascending map at
--     `suc n` sits strictly above it; a descending one strictly below;
--     `<-asym` forbids both.
------------------------------------------------------------------------

‡§®-‡§â‡§≠‡§Ø‡§Æ‡•ç : ‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä f ‚Üí ‡§Ö‡§ß‡•ã‡§ó‡§æ‡§Æ‡•Ä f ‚Üí ‚ä•
‡§®-‡§â‡§≠‡§Ø‡§Æ‡•ç up down = <-asym (up (suc zero)) (<-weaken (down zero))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡æ‡µ‡®‡æ ‡ä‡∞‡‡ß‡‡µ‡ó‡æ‡Æ‡ø‡®‡ ‚î THE BHVAN IS ONE OF THESE, so ¬ß‡® is not an
--     abstraction floating above the corpus.  Fix any numerator `suc x'`;
--     then the denominator map y ‚¶ 2(suc x') + 3y is ascending, and ¬ß‡®
--     gives back exactly `ALosslessReturn_‚¶.‡‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡` ‚î which was proved
--     there directly, by a different route, for that one generator.
--     Two independent statements that agree, which is what a channel
--     between a general law and its instance means here.
------------------------------------------------------------------------

open import NoReturn_TheCompositionOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity
  using (‡§®‡§µ-‡§π‡§∞‡§É ; ‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É)

‡§≠‡§æ‡§µ‡§®‡§æ-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡§ø‡§®‡•Ä : (x' : ‚Ñï) ‚Üí ‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡•Ä (‡§®‡§µ-‡§π‡§∞‡§É (suc x'))
‡§≠‡§æ‡§µ‡§®‡§æ-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡§ø‡§®‡•Ä x' = ‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É x'

‡§≠‡§æ‡§µ‡§®‡§æ-‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : (x' y : ‚Ñï) ‚Üí ¬¨ (‡§®‡§µ-‡§π‡§∞‡§É (suc x') y ‚â° y)
‡§≠‡§æ‡§µ‡§®‡§æ-‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç x' = ‡§Ö‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç (‡§≠‡§æ‡§µ‡§®‡§æ-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§ó‡§æ‡§Æ‡§ø‡§®‡•Ä x')
