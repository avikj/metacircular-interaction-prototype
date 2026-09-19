{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TwoTruthsCompute
--
-- checked, computing term.
--
-- Interpretation (marked as interpretation, per the note's discipline â”
-- the checked fact below is plain type theory; the reading is argued, not
-- asserted by the term): univalence produces, from an equivalence e, an
-- identity `ua e`.  Transport along that identity is the ULTIMATE face â”
-- it says the two types are not two.  Applying the equivalence, `equivFun e`,
-- is the CONVENTIONAL face â” a concrete operation you run.  The computation
-- rule uaÎ² says these are the SAME, and cubical makes it hold by REDUCTION
-- (transportRefl): the ultimate is reached only by running the conventional.
-- That is MMK 24.10 â” without relying on the conventional, the ultimate is
-- not taught â” as a term that computes rather than a claim.
--
--   ultimate-through-conventional
--       transport (ua e) x â‰¡ equivFun e x
--     the transported (ultimate) value equals the plainly-applied
--     (conventional) value; the two truths are one operation.
--
-- This is uaÎ², re-exhibited.  No new theorem; the point is that the
-- correspondence is not prose here â” it is a reduction the kernel checks.
------------------------------------------------------------------------

module TwoTruthsCompute where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaÎ²)

private
  variable
    â„“ : Level
    A B : Type â„“

-- Transport along the identity univalence builds from `e` (the ultimate:
-- the two types identified) computes to the plain action of `e` (the
-- conventional: an operation you run).  The two truths, one reduction.
ultimate-through-conventional : (e : A â‰ƒ B) (x : A)
                              â†’ transport (ua e) x â‰¡ equivFun e x
ultimate-through-conventional e x = uaÎ² e x
