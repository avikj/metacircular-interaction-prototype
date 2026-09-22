{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessNumberIsInvariant
--
-- The ‡≤‡æ‡ò‡µ question asks for a measure on presentations stable
-- under ‡‡®‡‡µ‡‡‡‡‡ø / ‡‡‡∞‡‡‡Ø‡æ‡‡æ‡∞ / ‡‡‡µ‡æ‡¶.  `Laghava` answered the question
-- it was asked and the answer was no:
--
--     laghava-is-not-semantic :
--       ¬ Œ[ f ‚àà (Denotation ‚í ‚ï) ] ((e : Expr) ‚í f (eval e) ‚â° size e)
--
-- size lives on the presentation, and univalence discards presentations.
--
-- This module records a measure
-- that DOES survive, and says exactly why the two differ.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE MEASURE
--
-- `WitnessNumberIsTwo` fixes it: an absence is measured by the least
-- list of points on which no decoder survives.  Unlike `size`, that
-- quantity is not read off a syntax ‚î it is a property of the pair
-- (decoder space, law).  So:
--
--   ¬ß1  it is a `subst` away from being transported along ANY path of
--       decoder systems, hence a univalent invariant by construction;
--   ¬ß3  it is PRESERVED by every reindexing of the decoder space, with
--       no hypothesis at all;
--   ¬ß4  and REFLECTED by surjective ones ‚î so it depends only on the
--       image, which is the precise sense in which it is not a
--       presentation-level quantity.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY LAGHAVA FAILS AND THIS DOES NOT
--
-- Both are "sizes".  The difference is the direction of the quantifier.
--
--   size    is a function OUT OF the presentation.  Two presentations
--           with one denotation get two values, so no function on
--           denotations reproduces it ‚î `Laghava.laghava-collision` is
--           the pair, and it is a collision in the sense of ¬ß4 of
--           `WitnessNumberIsTwo`.
--
--   witness number  is a quantification OVER the decoder space.  Any
--           reindexing feeds the same laws to the same points, so the
--           value cannot move.
--
-- A measure defined by ‚à over a space is invariant under maps into that
-- space; a measure defined by a function out of a space is not.  That is
-- the whole content, and it is why the ‡≤‡æ‡ò‡µ answer was no and this one
-- is yes without either being surprising once stated.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
------------------------------------------------------------------------

module WitnessNumberIsInvariant where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEq ; equivFun ; secEq)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (‚ä• ; isProp‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Relation.Nullary.Properties using (isProp¬¨)
open import Cubical.Functions.Surjection using (isSurjection)
open import Cubical.HITs.PropositionalTruncation as PT using (‚à•_‚à•‚ÇÅ)

open import WitnessNumberIsTwo using (AllHold ; Refutes)

private
  variable
    ‚Ñìd ‚Ñìd' ‚Ñìx ‚Ñì : Level

------------------------------------------------------------------------
-- 1.  A decoder system, and transport along paths of them
------------------------------------------------------------------------

DecoderSystem : (X : Type ‚Ñìx) (‚Ñìd ‚Ñì : Level) ‚Üí Type (‚Ñì-max ‚Ñìx (‚Ñì-max (‚Ñì-suc ‚Ñìd) (‚Ñì-suc ‚Ñì)))
DecoderSystem X ‚Ñìd ‚Ñì = Œ£[ D ‚àà Type ‚Ñìd ] (D ‚Üí X ‚Üí Type ‚Ñì)

RefutesS : {X : Type ‚Ñìx} ‚Üí DecoderSystem X ‚Ñìd ‚Ñì ‚Üí List X ‚Üí Type (‚Ñì-max ‚Ñìd ‚Ñì)
RefutesS (D , law) xs = (d : D) ‚Üí ¬¨ AllHold law d xs

-- univalent invariance, by construction: refutation is a property of the
-- system, so it moves along any path of systems
refutes-transport :
  {X : Type ‚Ñìx} (S T : DecoderSystem X ‚Ñìd ‚Ñì) ‚Üí S ‚â° T
  ‚Üí (xs : List X) ‚Üí RefutesS S xs ‚Üí RefutesS T xs
refutes-transport S T p xs = subst (Œª Z ‚Üí RefutesS Z xs) p

------------------------------------------------------------------------
-- 2.  Reindexing the decoder space, on the nose
--
-- `AllHold` recurses on the list, so at a variable list neither side
-- reduces and the two readings must be related by an induction rather
-- than by definitional equality.  Both directions are the same three
-- lines.
------------------------------------------------------------------------

reindex : {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
        ‚Üí (D' ‚Üí D) ‚Üí (D ‚Üí X ‚Üí Type ‚Ñì) ‚Üí (D' ‚Üí X ‚Üí Type ‚Ñì)
reindex f law d' = law (f d')

allHold-out : {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
              (f : D' ‚Üí D) (law : D ‚Üí X ‚Üí Type ‚Ñì) (d' : D') (xs : List X)
            ‚Üí AllHold (reindex f law) d' xs ‚Üí AllHold law (f d') xs
allHold-out f law d' []       h = h
allHold-out f law d' (x ‚à∑ xs) h = h .fst , allHold-out f law d' xs (h .snd)

allHold-in : {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
             (f : D' ‚Üí D) (law : D ‚Üí X ‚Üí Type ‚Ñì) (d' : D') (xs : List X)
           ‚Üí AllHold law (f d') xs ‚Üí AllHold (reindex f law) d' xs
allHold-in f law d' []       h = h
allHold-in f law d' (x ‚à∑ xs) h = h .fst , allHold-in f law d' xs (h .snd)

------------------------------------------------------------------------
-- 3.  PRESERVED by every reindexing, with no hypothesis
------------------------------------------------------------------------

refutes-reindex :
  {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
  (f : D' ‚Üí D) (law : D ‚Üí X ‚Üí Type ‚Ñì) (xs : List X)
  ‚Üí Refutes law xs ‚Üí Refutes (reindex f law) xs
refutes-reindex f law xs ref d' h = ref (f d') (allHold-out f law d' xs h)

------------------------------------------------------------------------
-- 4.  REFLECTED by surjective ones ‚î it depends only on the image
------------------------------------------------------------------------

refutes-reflect :
  {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
  (f : D' ‚Üí D) ‚Üí isSurjection f
  ‚Üí (law : D ‚Üí X ‚Üí Type ‚Ñì) (xs : List X)
  ‚Üí Refutes (reindex f law) xs ‚Üí Refutes law xs
refutes-reflect f surj law xs ref d h =
  PT.rec isProp‚ä•
         (Œª fib ‚Üí ref (fib .fst)
                    (allHold-in f law (fib .fst) xs
                      (subst (Œª z ‚Üí AllHold law z xs) (sym (fib .snd)) h)))
         (surj d)

------------------------------------------------------------------------
-- 5.  Equivalences are the special case, both directions
------------------------------------------------------------------------

equiv‚Üísurj : {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} (e : D' ‚âÉ D) ‚Üí isSurjection (equivFun e)
equiv‚Üísurj e d = PT.‚à£ invEq e d , secEq e d ‚à£‚ÇÅ

refutes-‚âÉ :
  {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
  (e : D' ‚âÉ D) (law : D ‚Üí X ‚Üí Type ‚Ñì) (xs : List X)
  ‚Üí Refutes law xs ‚Üí Refutes (reindex (equivFun e) law) xs
refutes-‚âÉ e law xs = refutes-reindex (equivFun e) law xs

refutes-‚âÉ-back :
  {D : Type ‚Ñìd} {D' : Type ‚Ñìd'} {X : Type ‚Ñìx}
  (e : D' ‚âÉ D) (law : D ‚Üí X ‚Üí Type ‚Ñì) (xs : List X)
  ‚Üí Refutes (reindex (equivFun e) law) xs ‚Üí Refutes law xs
refutes-‚âÉ-back e law xs = refutes-reflect (equivFun e) (equiv‚Üísurj e) law xs

------------------------------------------------------------------------
-- 6.  The contrast, side by side.
--
--   Laghava.laghava-is-not-semantic
--       ¬ Œ[ f ‚àà (Denotation ‚í ‚ï) ] ((e : Expr) ‚í f (eval e) ‚â° size e)
--   here ¬ß3, ¬ß4
--       Refutes law xs is preserved by every reindexing of the decoder
--       space and reflected by every surjection onto it
--
-- A measure defined by ‚à over a space is invariant under maps into that
-- space.  A measure defined by a function out of a space is not.
------------------------------------------------------------------------
