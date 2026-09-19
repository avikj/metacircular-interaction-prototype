{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡‡ï‡‡‡æ ‚î ‡Æ‡æ‡®‡ ‡Ø‡ ‡‡ï‡‡‡ ‡® ‡‡‡‡Ø‡‡ø, ‡‡‡‡∞ ‡‡∞‡‡µ‡ ‡‡¶‡ ‡‡‡µ‡Ø‡Æ‡‡µ ‡‡‡∞‡ï‡‡‡‡ø ‡
--
-- (non-dependence: the coordinate an invariant cannot see is the one in
--  which every step conserves it by itself.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHERE THIS COMES FROM.  `loss/‚¶/AntyaSamskara_‚¶` instantiates
-- the carrier law at Mdhava's end-correction: base = (index of the
-- correction , the point it is evaluated at), carried = that convergent's
-- ‡‡‡‡‡≤‡‡Ø, coarseness.  Its finding is the exact mirror of the ‡‡‡∞‡‡‡‡æ‡∞
-- module in the same library ‚î there the carried datum sees the WHOLE
-- base and the base may be dropped; here the base has a coordinate the
-- carried datum CANNOT SEE:
--
--     ‡‡‡‡‡≤‡‡Ø-‡Æ‡‡≤-‡‡¶‡‡‡‡Ø‡Æ‡ : (k : ‚ï) (n n' : ‚) ‚í ‡‡‡‡‡≤‡‡Ø (k , n) ‚â° ‡‡‡‡‡≤‡‡Ø (k , n')
--
-- and it reads that blindness as the correctness criterion itself:
--
--     "A correction that misses by a fixed integer is a correction; one
--      that misses by something growing with n is an estimate.  That the
--      argument is invisible to the coarseness IS the statement that
--      these are corrections, and it is why the Kerala mathematicians
--      could find them without any analysis: they were solving a
--      difference equation in closed form."
--
-- ¬ß‡®‚ì¬ß‡ below are that as a law rather than an instance.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IT BUYS, and it is an operational thing, not a tidier statement.
--
-- `Dhruva_‚¶.‡‡‡∞‡ï‡‡‡‡Æ‡` is the per-step condition `(a : A) ‚í f (Œ¶ a) ‚â° f a`,
-- and `Kaksya_‚¶` carries a conserved quantity along a whole orbit from
-- it.  Both take conservation as a HYPOTHESIS about the step, to be
-- checked for each Œ¶ one meets.
--
-- Blindness is checked ONCE, about the invariant, and then EVERY step
-- that moves only the invisible coordinate conserves ‚î automatically, for
-- all of them at once, with nothing to verify per step (¬ß‡©).  That is the
-- difference between a property re-established at each move and a
-- property of the design, and it is what "uniform in a parameter" means
-- when it is made precise: an algorithm is uniform in a coordinate
-- exactly when its invariant does not read that coordinate.
--
-- ¬ß‡ is the converse, so the criterion is not merely sufficient: an
-- invariant blind to a coordinate FACTORS through the rest, and one that
-- factors is blind.  Blindness and factorisation are the same property,
-- which is why it can be checked once.
--
-- ¬ß‡ is the contrast that makes it a distinction: the second projection
-- is NOT blind to its own coordinate, and a step moving that coordinate
-- provably fails to conserve.  Without it, ¬ß‡© would be true and empty.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- SOURCES. Mdhava of Sagamagrma (c. 1340‚ì1425), transmitted in Nlakaha,
-- ‡‡®‡‡‡‡∞‡‡ô‡‡ó‡‡∞‡‡ ‡®.‡®‡‡ß‚ì‡®‡‡ (1501) and Jyehadeva, ‡Ø‡‡ï‡‡‡ø‡‡æ‡‡æ (c. 1530) ‚î the
-- ‡‡®‡‡‡‡Ø‡‡‡‡‡ï‡æ‡∞ and ‡‡‡‡‡≤‡‡Ø. Nothing here is about œ, and there is no limit,
-- no ‚ and no error bound in this file.
--
-- ‡‡®‡‡‡ï‡‡‡æ is ordinary  for non-dependence and no text is claimed
-- for the compound.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Anapeksa_BlindnessToACoordinateIsAFactorisationSoEveryStepInItConservesForFree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

module _ {A C B : Type ‚Ñì} (f : A √ó C ‚Üí B) where

  ------------------------------------------------------------------------
  -- ‡ß ¬ ‡‡®‡‡‡ï‡‡‡æ ‚î the invariant does not read the second coordinate.
  ------------------------------------------------------------------------

  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ : Type ‚Ñì
  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ = (a : A) (c c' : C) ‚Üí f (a , c) ‚â° f (a , c')

  ------------------------------------------------------------------------
  -- ‡® ¬ ‡‡‡‡ø‡‡ø-‡‡¶‡Æ‡ ‚î a step that moves ONLY the invisible coordinate.
  --     The first coordinate is untouched, which is the only thing the
  --     invariant can see, so ¬ß‡© needs nothing about œà at all.
  ------------------------------------------------------------------------

  ‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ-‡§™‡§¶‡§Æ‡•ç : (C ‚Üí C) ‚Üí (A √ó C ‚Üí A √ó C)
  ‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ-‡§™‡§¶‡§Æ‡•ç œà x = fst x , œà (snd x)

  ------------------------------------------------------------------------
  -- ‡© ¬ ‡‡∞‡‡µ-‡‡¶‡ ‡‡‡∞‡ï‡‡‡‡ø ‚î EVERY SUCH STEP CONSERVES, for free.
  --
  --     Quantified over œà: one blindness proof discharges the conservation
  --     condition for all of them simultaneously.  `Dhruva`'s ‡‡‡∞‡ï‡‡‡‡Æ‡ is
  --     a hypothesis per step; here it is a conclusion, once.
  ------------------------------------------------------------------------

  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç : ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ ‚Üí (œà : C ‚Üí C) (x : A √ó C)
                     ‚Üí f (‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ-‡§™‡§¶‡§Æ‡•ç œà x) ‚â° f x
  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç blind œà x = blind (fst x) (œà (snd x)) (snd x)

  -- and therefore along every finite trajectory of every such step
  ‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (C ‚Üí C) ‚Üí ‚Ñï ‚Üí A √ó C ‚Üí A √ó C
  ‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É œà zero    x = x
  ‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É œà (suc n) x = ‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É œà n (‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ-‡§™‡§¶‡§Æ‡•ç œà x)

  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ : ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ ‚Üí (œà : C ‚Üí C) (n : ‚Ñï) (x : A √ó C)
                   ‚Üí f (‡§™‡•Å‡§®‡§∞‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É œà n x) ‚â° f x
  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ blind œà zero    x = refl
  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ blind œà (suc n) x =
    ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ blind œà n (‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ-‡§™‡§¶‡§Æ‡•ç œà x)
    ‚àô ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç blind œà x

  ------------------------------------------------------------------------
  -- ‡ ¬ ‡‡®‡‡‡ï‡‡‡æ IS FACTORISATION, both directions.  This is why the check
  --     is once and not per step: there is one property here, not two.
  ------------------------------------------------------------------------

  ‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç : Type ‚Ñì
  ‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç = Œ£[ g ‚àà (A ‚Üí B) ] ((x : A √ó C) ‚Üí f x ‚â° g (fst x))

  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç : C ‚Üí ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ ‚Üí ‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç
  ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ‚Üí‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç c‚ÇÄ blind = (Œª a ‚Üí f (a , c‚ÇÄ)) , (Œª x ‚Üí blind (fst x) (snd x) c‚ÇÄ)

  ‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç‚Üí‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ : ‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç ‚Üí ‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ
  ‡§ï‡§æ‡§∞‡§£‡§Æ‡•ç‚Üí‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ (g , h) a c c' = h (a , c) ‚àô sym (h (a , c'))

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡‡‡‡Ø‡Æ‡ ‚î the contrast, so ¬ß‡© is a distinction and not a vacuity.
--
--     The second projection reads exactly the coordinate ¬ß‡ß forbids
--     reading.  It is not blind, and `not` moving that coordinate
--     provably fails to conserve it.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§Æ‡•ç : ‚Ñï √ó Bool ‚Üí Bool
‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§Æ‡•ç = snd

‡§®-‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ : ¬¨ (‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§Æ‡•ç)
‡§®-‡§Ö‡§®‡§™‡•á‡§ï‡•ç‡§∑‡§æ blind = true‚â¢false (blind zero true false)

-- and the step that flips it does not conserve
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏‡§É : Bool ‚Üí Bool
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏‡§É true  = false
‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏‡§É false = true

‡§®-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç : ¬¨ (‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§Æ‡•ç (‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ-‡§™‡§¶‡§Æ‡•ç ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§Æ‡•ç ‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏‡§É (zero , true))
              ‚â° ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§Æ‡•ç (zero , true))
‡§®-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç = true‚â¢false ‚àò sym
  where
  _‚àò_ : {X Y Z : Type‚ÇÄ} ‚Üí (Y ‚Üí Z) ‚Üí (X ‚Üí Y) ‚Üí X ‚Üí Z
  (g ‚àò h) x = g (h x)
