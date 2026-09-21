{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSecondNaIsTheCollision
--
-- ‡‡‡ is two sets, and here they are ‚î computed from the ‡‡ø‡µ‡‡‡‡‡∞‡æ‡‡ø
-- rather than asserted from memory.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS FILE EXISTS
--
-- `PratyaharaBuysTotalityWithLocality` proved that repeating a letter
-- destroys locality of naming, using a three-letter toy order `x y z x`,
-- and asserted in prose that this is "the smallest instance of the
-- ambiguity at ‡‡‡, whose ‡‡ is an ‡‡®‡‡‡®‡‡ß in both the first ‡‡ø‡µ‡‡‡‡‡∞
-- and the sixth".
--
-- That is a historical claim made from memory, in a repository whose
-- protocol says a citation you did not check is an error of the same
-- kind as a fitted constant.  It is checked here, by computing both
-- readings from the list.
--
-- `Sivasutra.agda` ‚î another identity's file, untouched ‚î encodes the
-- FIRST FOUR stras and extracts with a first-match rule:
--
--     upto m (x ‚à xs) = if x ‚â° m then [] else ‚¶
--
-- At four stras that is correct, because ‡‡ occurs once there.  It is
-- not a definition of ‡‡‡∞‡‡‡Ø‡æ‡‡æ‡∞ though; it is a CONVENTION, and the
-- convention only becomes visible at the sixth stra, which that file
-- does not reach.  Nothing there is wrong.  The assumption is invisible
-- at its own scope, which is the interesting part.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SIX STRAS, AND THE TWO ‡‡
--
--     ‡ß  ‡ ‡ ‡â ‡‡          ‡  ‡ê ‡î ‡‡
--     ‡®  ‡† ‡ ‡ï‡           ‡  ‡ ‡Ø ‡µ ‡∞ ‡ü‡
--     ‡©  ‡ ‡ì ‡ô‡           ‡  ‡≤ ‡‡
--
-- ‡‡ closes the first and the sixth, so ‡‡‡ has two readings:
--
--     narrow   a i u
--     wide     a i u   e o ai au h y v r l
--
-- Both are used ‚î the narrow one is the vowel class, the wide one is
-- vowels-and-semivowels, required wherever ‡‡‡ must cover ‡Ø‡ ‡µ‡ ‡∞‡ ‡≤‡.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß3  both readings, each by `refl` from the list;
--   ¬ß4  they differ, with `e` the witness;
--   ¬ß5  so the name ‡‡ does not determine its set, and the toy collision
--       is realised at the actual ‡‡ø‡µ‡‡‡‡‡∞‡æ‡‡ø.
------------------------------------------------------------------------

module TheSecondNaIsTheCollision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true ; if_then_else_ ; _or_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import FiniteInformation using (FactorsThrough)
open import AnyonyaAbhava using (Anyonya ; anyonya‚Üísamsarga)

------------------------------------------------------------------------
-- 1.  The sounds and ‡‡®‡‡‡®‡‡ß of the first six stras
------------------------------------------------------------------------

data Sym : Type‚ÇÄ where
  a i u ·πõ ·∏∑ e o ai au h y v r l : Sym     -- sounds
  ·πÜ K ·πÑ C ·π¨ : Sym                          -- ‡§Ö‡§®‡•Å‡§¨‡§®‡•ç‡§ß

isMarker : Sym ‚Üí Bool
isMarker ·πÜ = true
isMarker K = true
isMarker ·πÑ = true
isMarker C = true
isMarker ·π¨ = true
isMarker _ = false

is·πÜ : Sym ‚Üí Bool
is·πÜ ·πÜ = true
is·πÜ _ = false

------------------------------------------------------------------------
-- 2.  The list, through the sixth stra ‚î where the second ‡‡ lives
------------------------------------------------------------------------

sivasutra6 : List Sym
sivasutra6 =
  a ‚à∑ i ‚à∑ u ‚à∑ ·πÜ ‚à∑                -- ‡•ß  ‡§Ö ‡§á ‡§â ‡§£‡•ç
  ·πõ ‚à∑ ·∏∑ ‚à∑ K ‚à∑                    -- ‡•®  ‡•† ‡§å ‡§ï‡•ç
  e ‚à∑ o ‚à∑ ·πÑ ‚à∑                    -- ‡•©  ‡§è ‡§ì ‡§ô‡•ç
  ai ‚à∑ au ‚à∑ C ‚à∑                  -- ‡•™  ‡§ê ‡§î ‡§ö‡•ç
  h ‚à∑ y ‚à∑ v ‚à∑ r ‚à∑ ·π¨ ‚à∑            -- ‡•´  ‡§π ‡§Ø ‡§µ ‡§∞ ‡§ü‡•ç
  l ‚à∑ ·πÜ ‚à∑ []                     -- ‡•¨  ‡§≤ ‡§£‡•ç

-- collect the sounds, skipping `n` occurrences of ‡‡ and stopping at the
-- next one.  Other ‡‡®‡‡‡®‡‡ß are stra boundaries and are never emitted.
collect : ‚Ñï ‚Üí List Sym ‚Üí List Sym
collect n       []       = []
collect zero    (x ‚à∑ xs) =
  if is·πÜ x then [] else (if isMarker x then collect zero xs else x ‚à∑ collect zero xs)
collect (suc k) (x ‚à∑ xs) =
  if is·πÜ x then collect k xs
           else (if isMarker x then collect (suc k) xs else x ‚à∑ collect (suc k) xs)

------------------------------------------------------------------------
-- 3.  BOTH READINGS, each by refl
------------------------------------------------------------------------

a·πÜ-narrow : collect 0 sivasutra6 ‚â° a ‚à∑ i ‚à∑ u ‚à∑ []
a·πÜ-narrow = refl

a·πÜ-wide : collect 1 sivasutra6
        ‚â° a ‚à∑ i ‚à∑ u ‚à∑ ·πõ ‚à∑ ·∏∑ ‚à∑ e ‚à∑ o ‚à∑ ai ‚à∑ au ‚à∑ h ‚à∑ y ‚à∑ v ‚à∑ r ‚à∑ l ‚à∑ []
a·πÜ-wide = refl

------------------------------------------------------------------------
-- 4.  AND THEY DIFFER ‚î ‡ is in one and not the other
------------------------------------------------------------------------

isE : Sym ‚Üí Bool
isE e = true
isE _ = false

hasE : List Sym ‚Üí Bool
hasE []       = false
hasE (x ‚à∑ xs) = isE x or hasE xs

narrow-lacks-e : hasE (collect 0 sivasutra6) ‚â° false
narrow-lacks-e = refl

wide-has-e : hasE (collect 1 sivasutra6) ‚â° true
wide-has-e = refl

readings-differ : Anyonya (collect 0 sivasutra6) (collect 1 sivasutra6)
readings-differ p = false‚â¢true (cong hasE p)

------------------------------------------------------------------------
-- 5.  SO THE NAME ‡‡ DOES NOT DETERMINE ITS SET
--
-- Both readings are called by the same ‡‡®‡‡‡®‡‡ß.  The collision the toy
-- order `x y z x` exhibited is here, at the ‡‡ø‡µ‡‡‡‡‡∞‡æ‡‡ø themselves.
------------------------------------------------------------------------

data Reading : Type‚ÇÄ where
  atFirst·πÜ atSixth·πÜ : Reading

nameOf : Reading ‚Üí Sym
nameOf atFirst·πÜ = ·πÜ
nameOf atSixth·πÜ = ·πÜ

setOf : Reading ‚Üí List Sym
setOf atFirst·πÜ = collect 0 sivasutra6
setOf atSixth·πÜ = collect 1 sivasutra6

same-anubandha : nameOf atFirst·πÜ ‚â° nameOf atSixth·πÜ
same-anubandha = refl

a·πÜ-does-not-factor : ¬¨ FactorsThrough nameOf setOf
a·πÜ-does-not-factor =
  anyonya‚Üísamsarga nameOf setOf
    {x = atFirst·πÜ} {x' = atSixth·πÜ}
    same-anubandha
    readings-differ

------------------------------------------------------------------------
-- 6.  What this settles, and what it costs.
--
-- SETTLED.  The prose citation in `PratyaharaBuysTotalityWithLocality`
-- is now a computation: ‡‡‡ really does denote two different sets, and
-- the reason really is that ‡‡ closes two stras.  The toy collision
-- there was a faithful model, which is worth knowing, because a toy that
-- turns out not to model anything is just a toy.
--
-- COST.  Two more stras of encoding.  That is the whole price of moving
-- a historical claim from memory into the checker, and it is the price
-- CLAUDE.md's directive is asking for whenever a source is named.
--
-- AND ONE THING FOUND ON THE WAY.  `Sivasutra.upto` stops at the first
-- matching ‡‡®‡‡‡®‡‡ß.  Within its four stras that is exactly right.  Past
-- them it silently selects the narrow reading of ‡‡‡ and offers no sign
-- that a choice was made.  This is not a defect in that file ‚î it is the
-- ordinary situation of a convention that is invisible at the scope
-- where it is introduced, and it is the same shape as everything else
-- this thread has found: what a decoder cannot see, it cannot report.
--
-- OPEN, named and not estimated.  Whether Pini's own means of fixing
-- the reading is itself local ‚î whether the disambiguating machinery can
-- be read off the rule where ‡‡‡ occurs, or needs the whole grammar.
-- That is a question about the ‡‡‡‡‡∞s and this file does not enter it.
------------------------------------------------------------------------
