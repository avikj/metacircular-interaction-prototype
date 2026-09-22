{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø-‡‡®‡‡‡‡ ‚î ‡ï‡‡‡‡‡‡‡Ø ‡‡®‡‡‡‡ ‡‡®‡®‡‡‡, ‡‡æ‡µ‡®‡æ ‡ ‡‡‡‡Ø ‡‡æ‡ï‡‡‡ ‡
--
-- (the vargaprakti fiber: the fiber of the kepa over one is infinite,
--  and Brahmagupta's composition is the witness.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS, AND WHY IT IS THE CRITERION AND NOT AN EXAMPLE.
--
-- `fiber/src/Fiber/Composition_‚¶` builds ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø as
-- `Carrier (‡ï‡‡‡‡‡ D)`: base = the two roots, carried = the ‡ï‡‡‡‡, because
-- the roots DETERMINE it.  Its fiber `Œ[ k ] (‡ï‡‡‡‡‡ D x ‚â° k)` is
-- `singl`, contractible, and (‚ ó ‚) ‚â ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø D.  The carried datum
-- rides free.
--
-- Bind the OTHER side of the same equation and everything changes:
--
--     Œ[ x ] (‡ï‡‡‡‡‡ D x ‚â° 1)
--
-- is `fiber (‡ï‡‡‡‡‡ D) 1`, and it is not contractible and not free.  It is
-- THE SET OF SOLUTIONS of the vargaprakti ‚î what the ‡ï‡‡ü‡‡ü‡ï, the ‡‡æ‡µ‡®‡æ
-- and the ‡‡ï‡‡∞‡µ‡æ‡≤ were all built to produce.  ‡‡‡‡‡∞ ‡: ‡ï‡ ‡‡ï‡‡‡ã ‡‡¶‡‡ß ‡‡‡ø
-- ‡‡∞‡‡µ‡Æ‡ ‚î which side is bound, that is everything.  One map, two
-- bindings: the carrier is free, the subject is the fiber.
--
-- SO THIS FILE IS THE TWO HALVES JOINED, and neither half says it alone:
--
--   ¬ `Composition_‚¶.‡‡æ‡µ‡®‡æ-‡ï‡‡‡‡‡` proves the carried datum MULTIPLIES:
--     ‡ï‡‡‡‡(compose) = ‡ï‡‡‡‡ ¬ ‡ï‡‡‡‡.  Hence composing a k=1 row with the
--     fundamental k=1 row stays at k=1 ‚î the orbit never leaves the
--     fiber.  ¬ß‡ß below is that invariance, over ‚ï and independently.
--   ¬ `ALosslessReturn_‚¶.‡µ‡‡¶‡‡ß‡ø‡` proves the orbit STRICTLY ASCENDS and so
--     never returns.  ¬ß‡© below is that, chained.
--
--   Invariance alone gives an orbit inside the fiber and says nothing
--   about how much of it is visited.  Growth alone says the orbit is
--   infinite and says nothing about where it lives.  Together: ¬ß‡, the
--   fiber contains a strictly increasing sequence, so it is infinite.
--
-- WHY THE INFINITUDE IS NOT A COUNT.  ‡‡‡‡‡∞ ‡Æ ‚î ‡‡‡ø‡‡‡û‡æ‡®‡ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡Æ‡, ‡®
-- ‡‡∞‡ø‡Æ‡æ‡‡Æ‡.  ¬ß‡ does not report a number; it exhibits an injection out of
-- ‚ï, so the identification is a map you can evaluate, and the n-th
-- solution is `‡‡ô‡‡ï‡‡‡ø n`.  That is the receipt.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- SOURCES.  BRAHMAGUPTA, ‡‡‡∞‡æ‡‡‡Æ‡‡‡‡‡ü‡‡ø‡¶‡‡ß‡æ‡®‡‡‡ ‡ß‡Æ (‡ï‡‡ü‡‡ü‡ï‡æ‡ß‡‡Ø‡æ‡Ø‡), 628 CE ‚î
-- ‡‡æ‡µ‡®‡æ, the composition law for ‡µ‡∞‡‡ó‡‡‡∞‡ï‡‡‡ø, with ‡‡‡∞‡ï‡‡‡ø for the multiplier,
-- ‡‡‡Ø‡‡‡‡† and ‡ï‡®‡ø‡‡‡† for the two roots, ‡ï‡‡‡‡ for the interpolator.  The
-- root (3,2) for D=2 and the value 577/408 are BAUDHYANA's, ‡‡‡≤‡‡‡‡‡‡‡∞‡Æ‡
-- ‡ß.‡‡ß‚ì‡‡® (~800 BCE), stated *saviea*, "with its excess".  JAYADEVA
-- (c. 950, surviving inside Udayadivkara's ‡‡‡®‡‡¶‡∞‡) and BHSKARA II,
-- ‡‡‡‡ó‡‡ø‡ 1150 ‚î the ‡‡ï‡‡∞‡µ‡æ‡≤.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE METHOD'S REACH.
--
-- ¬ß‡ß-¬ß‡ reach the fiber by composing against a FUNDAMENTAL ROW, and that
-- needs a small k=1 row to seed with.  For D = 2 the ulba value supplies
-- one.  FOR D = 61 THERE IS NONE, and D = 61 is Bhskara.s own worked
-- example -- so this method does not reach the case the tradition is
-- famous for.
--
-- What reaches it is the ‡‡ï‡‡∞‡µ‡æ‡≤, and
-- `Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAtSixtyOne
-- .agda` runs one in the kernel: six turns from (8,1,+3) to
-- (29718, 3805, ‚àí1) with every divisibility witness discharged by `refl`,
-- then Brahmagupta.s composition of a k = ‚àí1 row with itself giving
-- 1766319049¬≤ ‚àí 61 ¬ 226153980¬≤ = 1.
--
-- The distinction: here the
-- ‡ï‡‡‡‡ fiber is `singl`, CONTRACTIBLE -- every pair has a ‡ï‡‡‡‡, so the
-- datum rides free.  There the ‡‡æ‡ó‡‡æ‡∞ fiber is a PROPOSITION AND NOT IN
-- GENERAL INHABITED, because division by k is partial and the inhabitant
-- IS the divisibility.  Contractible versus merely propositional is the
-- whole difference between the ‡‡æ‡µ‡®‡æ being free and the ‡‡ï‡‡∞‡µ‡æ‡≤ not being
-- free, and Bhskara.s choice of m is what supplies the inhabitant.
------------------------------------------------------------------------

module Vargaprakrtifiber_ThePellFiberIsInfiniteAndBrahmaguptasCompositionIsTheWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; _¬∑_)
open import Cubical.Data.Nat.Order using (_<_ ; _‚â§_ ; <-trans ; ¬¨m<m)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Tactics.NatSolver.Reflection using (solve‚Ñï!)

open import NoReturn_TheCompositionOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity
  using (‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É ; ‡§®‡§µ-‡§π‡§∞‡§É ; ‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É)

------------------------------------------------------------------------
-- ‡¶ ¬ the equation, in the subtraction-free form ‚ï can state.
--     a¬≤ ‚àí 2b¬≤ = 1  is written  a¬≤ ‚â° 2b¬≤ + 1.
------------------------------------------------------------------------

‡§µ‡§∞‡•ç‡§ó‡§™‡•ç‡§∞‡§ï‡•É‡§§‡§ø‡§É : ‚Ñï √ó ‚Ñï ‚Üí Type‚ÇÄ
‡§µ‡§∞‡•ç‡§ó‡§™‡•ç‡§∞‡§ï‡•É‡§§‡§ø‡§É x = fst x ¬∑ fst x ‚â° 2 ¬∑ (snd x ¬∑ snd x) + 1

-- the fiber of the kepa over 1: the SOLUTION SET, which is what a bound
-- base gives where a bound carried gave `singl`.
‡§§‡§®‡•ç‡§§‡•Å‡§É : Type‚ÇÄ
‡§§‡§®‡•ç‡§§‡•Å‡§É = Œ£[ x ‚àà ‚Ñï √ó ‚Ñï ] ‡§µ‡§∞‡•ç‡§ó‡§™‡•ç‡§∞‡§ï‡•É‡§§‡§ø‡§É x

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡µ‡ø‡ï‡æ‡∞‡ ‚î THE STEP DOES NOT LEAVE THE FIBER.
--
--     (a,b) ‚¶ (3a+4b , 2a+3b)
--
-- is ‡‡æ‡µ‡®‡æ against the fundamental row (3,2) at D=2, whose own ‡ï‡‡‡‡ is 1.
-- Brahmagupta's identity says the composed ‡ï‡‡‡‡ is the PRODUCT, so it is
-- k¬1 = k and the fiber is preserved.  Proved here directly in ‚ï rather
-- than imported, because the ‚ statement lives in a different library
-- with its own agda-lib; two independent statements that agree is the
-- channel this corpus accepts, and asserting the import would be the
-- third road ‡‡‡‡‡∞ ‡ß‡ß denies.
------------------------------------------------------------------------

‡§™‡§¶‡§Æ‡•ç : ‚Ñï √ó ‚Ñï ‚Üí ‚Ñï √ó ‚Ñï
‡§™‡§¶‡§Æ‡•ç x = ‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É (fst x) (snd x) , ‡§®‡§µ-‡§π‡§∞‡§É (fst x) (snd x)

‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡§É : (a b : ‚Ñï) ‚Üí ‡§µ‡§∞‡•ç‡§ó‡§™‡•ç‡§∞‡§ï‡•É‡§§‡§ø‡§É (a , b) ‚Üí ‡§µ‡§∞‡•ç‡§ó‡§™‡•ç‡§∞‡§ï‡•É‡§§‡§ø‡§É (‡§™‡§¶‡§Æ‡•ç (a , b))
‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡§É a b h = ‡§µ‡§æ‡§Æ ‚àô cong (Œª z ‚Üí 9 ¬∑ z + (24 ¬∑ (a ¬∑ b) + 16 ¬∑ (b ¬∑ b))) h
              ‚àô ‡§Æ‡§ß‡•ç‡§Ø‡§Æ ‚àô sym (cong (Œª z ‚Üí 8 ¬∑ z + (24 ¬∑ (a ¬∑ b) + 18 ¬∑ (b ¬∑ b)) + 1) h)
              ‚àô sym ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£
  where
  ‡§µ‡§æ‡§Æ : ‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É a b ¬∑ ‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É a b
      ‚â° 9 ¬∑ (a ¬∑ a) + (24 ¬∑ (a ¬∑ b) + 16 ¬∑ (b ¬∑ b))
  ‡§µ‡§æ‡§Æ = solve‚Ñï!

  ‡§Æ‡§ß‡•ç‡§Ø‡§Æ : 9 ¬∑ (2 ¬∑ (b ¬∑ b) + 1) + (24 ¬∑ (a ¬∑ b) + 16 ¬∑ (b ¬∑ b))
        ‚â° 8 ¬∑ (2 ¬∑ (b ¬∑ b) + 1) + (24 ¬∑ (a ¬∑ b) + 18 ¬∑ (b ¬∑ b)) + 1
  ‡§Æ‡§ß‡•ç‡§Ø‡§Æ = solve‚Ñï!

  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : 2 ¬∑ (‡§®‡§µ-‡§π‡§∞‡§É a b ¬∑ ‡§®‡§µ-‡§π‡§∞‡§É a b) + 1
         ‚â° 8 ¬∑ (a ¬∑ a) + (24 ¬∑ (a ¬∑ b) + 18 ¬∑ (b ¬∑ b)) + 1
  ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ = solve‚Ñï!

------------------------------------------------------------------------
-- ‡® ¬ ‡Æ‡‡≤‡Æ‡ ‚î the fundamental row.  3¬≤ = 2¬2¬≤ + 1, i.e. 9 = 8 + 1.
--     Baudhyana's first convergent, and the seed of the whole orbit.
------------------------------------------------------------------------

‡§Æ‡•Ç‡§≤‡§Æ‡•ç : ‡§§‡§®‡•ç‡§§‡•Å‡§É
‡§Æ‡•Ç‡§≤‡§Æ‡•ç = (3 , 2) , refl

------------------------------------------------------------------------
-- ‡© ¬ ‡‡ô‡‡ï‡‡‡ø ‚î THE SEQUENCE, and it lands IN the fiber by ¬ß‡ß.
------------------------------------------------------------------------

‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø : ‚Ñï ‚Üí ‡§§‡§®‡•ç‡§§‡•Å‡§É
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø zero    = ‡§Æ‡•Ç‡§≤‡§Æ‡•ç
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø (suc n) with ‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n
... | (a , b) , h = ‡§™‡§¶‡§Æ‡•ç (a , b) , ‡§Ö‡§µ‡§ø‡§ï‡§æ‡§∞‡§É a b h

-- the second root of the n-th solution
‡§ï‡§®‡§ø‡§∑‡•ç‡§† : ‚Ñï ‚Üí ‚Ñï
‡§ï‡§®‡§ø‡§∑‡•ç‡§† n = snd (fst (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n))

-- the first root is always a successor, so ¬ß‡'s growth applies at every
-- step.  Proved alongside the sequence rather than after it, because it
-- is what keeps the growth hypothesis alive.
-- the successor form the growth lemma needs, named so solve‚ï! has a target
‡§Ö‡§Ç‡§∂-‡§∏‡•Å‡§ï‡•ç : (z b : ‚Ñï) ‚Üí ‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É (suc z) b ‚â° suc (z ¬∑ 3 + 4 ¬∑ b + 2)
‡§Ö‡§Ç‡§∂-‡§∏‡•Å‡§ï‡•ç z b = solve‚Ñï!

‡§ú‡•ç‡§Ø‡•á‡§∑‡•ç‡§†-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (n : ‚Ñï) ‚Üí Œ£[ z ‚àà ‚Ñï ] (fst (fst (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n)) ‚â° suc z)
‡§ú‡•ç‡§Ø‡•á‡§∑‡•ç‡§†-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç zero    = 2 , refl
‡§ú‡•ç‡§Ø‡•á‡§∑‡•ç‡§†-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç (suc n) with ‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n | ‡§ú‡•ç‡§Ø‡•á‡§∑‡•ç‡§†-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç n
... | (a , b) , _ | z , p =
      (z ¬∑ 3 + 4 ¬∑ b + 2) , (cong (Œª w ‚Üí ‡§®‡§µ-‡§Ö‡§Ç‡§∂‡§É w b) p ‚àô ‡§Ö‡§Ç‡§∂-‡§∏‡•Å‡§ï‡•ç z b)

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡‡¶‡‡ß‡ø‡ ‡‡ô‡‡ï‡‡‡ ‚î the second root strictly grows at every step.
--     `ALosslessReturn_‚¶.‡µ‡‡¶‡‡ß‡ø‡` needs a nonzero first root; ¬ß‡©'s
--     ‡‡‡Ø‡‡‡‡†-‡‡‡‡®‡‡Ø‡Æ‡ is what keeps supplying it.
------------------------------------------------------------------------

‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§™‡§¶‡•á : (n : ‚Ñï) ‚Üí ‡§ï‡§®‡§ø‡§∑‡•ç‡§† n < ‡§ï‡§®‡§ø‡§∑‡•ç‡§† (suc n)
‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§™‡§¶‡•á n with ‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n | ‡§ú‡•ç‡§Ø‡•á‡§∑‡•ç‡§†-‡§Ö‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç n
... | (a , b) , _ | z , p =
      subst (Œª w ‚Üí b < ‡§®‡§µ-‡§π‡§∞‡§É w b) (sym p) (‡§µ‡•É‡§¶‡•ç‡§ß‡§ø‡§É z b)

-- and therefore across any gap, by chaining.
‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§¶‡•Ç‡§∞‡•á : (n k : ‚Ñï) ‚Üí ‡§ï‡§®‡§ø‡§∑‡•ç‡§† n < ‡§ï‡§®‡§ø‡§∑‡•ç‡§† (suc (k + n))
‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§¶‡•Ç‡§∞‡•á n zero     = ‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§™‡§¶‡•á n
‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§¶‡•Ç‡§∞‡•á n (suc k)  = <-trans (‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§¶‡•Ç‡§∞‡•á n k) (‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§™‡§¶‡•á (suc (k + n)))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡®‡®‡‡‡ ‚î THE FIBER IS INFINITE.
--
--     No entry of the sequence is ever equal to a LATER entry, because
--     their second roots differ and a strict inequality forbids the
--     equality.  No trichotomy is needed: "later" is enough, and it is
--     the direction that says the sequence does not close up.
--
--     This is the join.  ¬ß‡ß (invariance, Brahmagupta) puts the orbit
--     inside the fiber and says nothing about how much of it is reached.
--     ¬ß‡ (growth) says the orbit never repeats and says nothing about
--     where it lives.  Only together do they give a fiber containing a
--     sequence with no repetitions ‚î an infinite solution set, with the
--     n-th solution EXHIBITED rather than counted (‡‡‡‡‡∞ ‡Æ).
------------------------------------------------------------------------

‡§Ö‡§®‡§®‡•ç‡§§‡§É : (n k : ‚Ñï) ‚Üí ¬¨ (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø n ‚â° ‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø (suc (k + n)))
‡§Ö‡§®‡§®‡•ç‡§§‡§É n k e = ¬¨m<m (subst (‡§ï‡§®‡§ø‡§∑‡•ç‡§† n <_) (sym (cong (Œª t ‚Üí snd (fst t)) e))
                           (‡§µ‡•É‡§¶‡•ç‡§ß‡§ø-‡§¶‡•Ç‡§∞‡•á n k))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡ß‡æ‡Ø‡®‡‡‡Ø ‡Æ‡æ‡®‡Æ‡ ‚î and it lands on the ulba value.
--
--     (3,2) ‚í (17,12) ‚í (99,70) ‚í (577,408), and 577/408 is exactly the
--     *saviea* value BAUDHYANA gives for ‚à2, ‡‡‡≤‡‡‡‡‡‡‡∞‡Æ‡ ‡ß.‡‡ß‚ì‡‡®, about
--     twelve centuries before the composition that generates it here.
--     Each of these holds by `refl`, so Agda executes the arithmetic.
--
--     A DISTINCTION, and it matters.
--     `Dvikarani.agda` records the chain (3,2) ‚í (17,12) ‚í (577,408) by
--     DOUBLING ‚î composing each row with ITSELF.  This module composes
--     each row against the FIXED fundamental row, and gets (99,70) in
--     between.  Both are ‡‡æ‡µ‡®‡æ and both reach Baudhyana.s value; they
--     are not the same sequence.  Self-composition is the subsequence of
--     SQUARES and skips solutions; composition against the fundamental
--     row visits them in order.  For ¬ß‡ that difference is the whole
--     point -- infinitude wants the sequence that does not skip.
------------------------------------------------------------------------

‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•¶ : fst (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 0) ‚â° (3 , 2)
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•¶ = refl

‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•ß : fst (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 1) ‚â° (17 , 12)
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•ß = refl

‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•® : fst (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 2) ‚â° (99 , 70)
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•® = refl

‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•© : fst (‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø 3) ‚â° (577 , 408)
‡§™‡§ô‡•ç‡§ï‡•ç‡§§‡§ø-‡•© = refl

-- and the equation still holds there, computed rather than assumed
‡§Æ‡§æ‡§®‡§Æ‡•ç-‡•´‡•≠‡•≠ : 577 ¬∑ 577 ‚â° 2 ¬∑ (408 ¬∑ 408) + 1
‡§Æ‡§æ‡§®‡§Æ‡•ç-‡•´‡•≠‡•≠ = refl
