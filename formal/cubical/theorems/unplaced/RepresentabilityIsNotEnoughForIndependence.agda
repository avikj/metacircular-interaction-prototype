{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module RepresentabilityIsNotEnoughForIndependence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg ; prov ; Consistent ; HBL1
        ; W ; wtop ; wbot ; wg ; wng ; wneg ; wPf
        ; Wit ; witCon ; witHBL1 ; witProvesNegG ; witOmegaBad ; OmegaBad )
open import IndependenceNeedsAnInternalImplication
  using (Independent)
open import TheDiagonalLemmaDischargesGoedelFix
  using (HasDiagonal ; goedelSentence)

------------------------------------------------------------------------
-- RepresentabilityIsNotEnoughForIndependence
--
-- The previous module wrote representability down and asked, in its own
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  `Wit` â” `GodelSeparation`'s countermodel, four sentences, with
--       `prov` constantly âŠ â” carries a `HasDiagonal`.  The internal
--       implication is the truth-functional one over the four
--       sentences, modus ponens holds by exhaustion, and the diagonal
--       fixed point at `Â prov(âˆ’)` is `wg`.
--
--   Â§2  so `HasDiagonal` is INHABITED: it is not a vacuous record, and
--       the previous module's theorems are not empty.
--
--   Â§3  and the stronger consequence.  `Wit` is consistent
--       (`witCon`), satisfies HBL1 (`witHBL1`), now satisfies full
--       representability (Â§1), and PROVES ÂG (`witProvesNegG`).  So
--
--         consistency + HBL1 + representability  âŠ  independence
--
--       and any derivation of independence from those three, applied
--       to `Wit`, yields âŠ.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS UPGRADES
--
-- `GodelSeparation.noHalfTwo` refutes the second conjunct from
-- consistency, HBL1 and `GoedelFix`.  Someone could have answered that
-- `GoedelFix` is a weak stand-in for the real hypothesis â” that a
-- theory which genuinely represents its own provability predicate would
-- not behave like `Wit`.  Â§3 closes that: `Wit` represents it, in the
-- full sense of Â§1, and behaves like `Wit` anyway.
--
-- The missing ingredient is therefore isolated with no room left for it
-- to be representability: it is Ï‰-consistency, and `witOmegaBad` is
-- already in the corpus, exhibiting `Wit`'s failure of it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE HONEST LIMIT OF Â§1, STATED BECAUSE IT IS EASY TO OVERSELL
--
-- `Form` here is `Unit`: one formula, the only one the argument needs.
-- That is enough to inhabit the record and enough for Â§3, and it is NOT
-- evidence that `HasDiagonal` captures arithmetisation.  A structure
-- with one formula has no substitution, no coding, and no way to
-- express a diagonal for anything else.  What Â§1 shows is that the
-- record as written is satisfiable â” which is exactly what was needed
-- to know that Â§3 is not vacuous, and no more.
--
-- A reader wanting `HasDiagonal` to mean arithmetisation should
-- strengthen it â” a `Form` closed under the connectives, substitution,
-- a coding â” and none of that is here or, on a grep of
-- `formal/cubical` for `Representab` and `Form`, anywhere in this
-- corpus.  A version phrased over a Gdel numbering function rather
-- than a formula type would evade that grep.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The internal implication on four sentences, and modus ponens
--
-- Provable: `wtop`, `wng`.  Unprovable: `wbot`, `wg`.  `wimp a b` is
-- `wtop` exactly when provability of `a` entails provability of `b`.
------------------------------------------------------------------------

wimp : W â†’ W â†’ W
wimp wbot _    = wtop
wimp wg   _    = wtop
wimp wtop wtop = wtop
wimp wtop wng  = wtop
wimp wtop wbot = wbot
wimp wtop wg   = wbot
wimp wng  wtop = wtop
wimp wng  wng  = wtop
wimp wng  wbot = wbot
wimp wng  wg   = wbot

wmp : (a b : W) â†’ wPf (wimp a b) â†’ wPf a â†’ wPf b
wmp wbot _    _ pa = Empty.rec pa
wmp wg   _    _ pa = Empty.rec pa
wmp wtop wtop _ _  = tt
wmp wtop wng  _ _  = tt
wmp wtop wbot i _  = Empty.rec i
wmp wtop wg   i _  = Empty.rec i
wmp wng  wtop _ _  = tt
wmp wng  wng  _ _  = tt
wmp wng  wbot i _  = Empty.rec i
wmp wng  wg   i _  = Empty.rec i

------------------------------------------------------------------------
-- 2.  `Wit` carries a diagonal
--
-- One formula, `Â prov(âˆ’)`, which in `Wit` is constantly `wbot` since
-- `prov` is constantly `wtop`.  Its fixed point is `wg`: `wimp wg wbot`
-- is `wtop` because `wg` is unprovable, and `wimp wbot wg` is `wtop`
-- because `wbot` is.
------------------------------------------------------------------------

witHasDiagonal : HasDiagonal Wit
witHasDiagonal = record
  { imp        = wimp
  ; mp         = wmp
  ; Form       = Unit
  ; app        = Î» _ _ â†’ wbot
  ; fix        = Î» _ â†’ wg , (tt , tt)
  ; negProv    = tt
  ; negProv-is = Î» _ â†’ refl
  }

------------------------------------------------------------------------
-- 3.  Consistency + HBL1 + representability do not give independence
------------------------------------------------------------------------

witGoedelSentence : goedelSentence Wit witHasDiagonal â‰¡ wg
witGoedelSentence = refl

witNotIndependent : Â¬ (Independent Wit wg)
witNotIndependent ind = snd ind witProvesNegG

representabilityIsNotEnough :
  ( (T : Theory â„“-zero) (D : HasDiagonal T)
    â†’ Consistent T â†’ HBL1 T â†’ Independent T (goedelSentence T D) )
  â†’ âŠ¥
representabilityIsNotEnough f =
  witNotIndependent (f Wit witHasDiagonal witCon witHBL1)

-- and the ingredient that is left, named as a term rather than in prose:
-- `Wit` fails Ï‰-consistency exactly, and the corpus already had this.
theRemainingIngredient : OmegaBad Wit wg
theRemainingIngredient = witOmegaBad
