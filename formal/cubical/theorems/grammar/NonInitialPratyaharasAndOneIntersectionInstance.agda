{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NonInitialPratyaharasAndOneIntersectionInstance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Sivasutra using (Sym ; a ; i ; u ; á¹› ; á¸· ; e ; o ; ai ; au ; á¹† ; K ; á¹„ ; C
                            ; isMarker ; eqSym ; sivasutra ; upto)

------------------------------------------------------------------------
-- NonInitialPratyaharasAndOneIntersectionInstance
--
-- `formal/cubical/Sivasutra.agda` (cf-sakshi, 2026-08-18) checks the
-- pratyhra device on the vowel prefix, and says so exactly in its own
-- comment: *"All pratyhras here begin at `a`, the head, so no
-- start-search is needed."*  Its `upto` moves ONE endpoint.
--
-- The device moves TWO.  `iK`, `e`, `aiC` are pratyhras with
-- non-initial starts, and they are what makes the family of named classes
-- more than a chain: with both endpoints free the classes overlap rather
-- than merely nest, and an intersection can be a named class again.  That
-- overlap is the structure the intersection-closed-family reading of the
-- iva-stras is about.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  `from`, the start-search, and `between` = `upto` after `from`;
--   Â§2  three non-initial pratyhras, each equal to its traditional
--       class BY REFL, and one initial one recomputed through `between`
--       to check the extension agrees with `Sivasutra.upto` where they
--       overlap;
--   Â§3  ONE INTERSECTION INSTANCE: the intersection of `aK` and `iC` is
--       `iK`, again a named pratyhra, by `refl`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- **Â§3 is an instance, not closure.**  One intersection of two named
-- classes is again a named class.  That is a datum.  The family being
-- intersection-CLOSED is a universally quantified statement over all
-- pairs, and it is not proved here for any family â” nor would proving it
-- on the vowel prefix say much, the prefix being nine sounds.
--
-- **The consonant stras are absent**, as in the module extended.
-- The vowel prefix is where the device is visible cheaply; it is not
-- where the ordering problem lives, since the hard part of the
-- iva-stra ordering is the consonants and the duplicated `h`.
--
-- **No historical priority statement**, per the extended module.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The start-search, and the two-endpoint extractor
------------------------------------------------------------------------

-- drop everything strictly before the start sound, keeping it.
from : Sym â†’ List Sym â†’ List Sym
from s [] = []
from s (x âˆ· xs) = if eqSym x s then x âˆ· xs else from s xs

-- a pratyhra with both endpoints named: start at `s`, stop at marker `m`.
between : Sym â†’ Sym â†’ List Sym â†’ List Sym
between s m xs = upto m (from s xs)

------------------------------------------------------------------------
-- 2.  Non-initial pratyhras, each by refl
------------------------------------------------------------------------

-- iK : the simple vowels other than `a`
iK : between i K sivasutra â‰¡ i âˆ· u âˆ· á¹› âˆ· á¸· âˆ· []
iK = refl

-- e : the gua vowels
eá¹„ : between e á¹„ sivasutra â‰¡ e âˆ· o âˆ· []
eá¹„ = refl

-- aiC : the vddhi diphthongs
aiC : between ai C sivasutra â‰¡ ai âˆ· au âˆ· []
aiC = refl

-- iC : every vowel but `a`
iC : between i C sivasutra â‰¡ i âˆ· u âˆ· á¹› âˆ· á¸· âˆ· e âˆ· o âˆ· ai âˆ· au âˆ· []
iC = refl

-- and the extension agrees with the one-endpoint version at the head.
betweenAgreesAtTheHead : between a C sivasutra â‰¡ upto C sivasutra
betweenAgreesAtTheHead = refl

------------------------------------------------------------------------
-- 3.  One intersection instance: aK âˆ© iC â‰¡ iK
------------------------------------------------------------------------

mem : Sym â†’ List Sym â†’ Bool
mem s [] = false
mem s (x âˆ· xs) = if eqSym x s then true else mem s xs

inter : List Sym â†’ List Sym â†’ List Sym
inter [] ys = []
inter (x âˆ· xs) ys = if mem x ys then x âˆ· inter xs ys else inter xs ys

-- the intersection of two named classes is again a named class, here.
aKâˆ©iCâ‰¡iK : inter (upto K sivasutra) (between i C sivasutra)
         â‰¡ between i K sivasutra
aKâˆ©iCâ‰¡iK = refl
