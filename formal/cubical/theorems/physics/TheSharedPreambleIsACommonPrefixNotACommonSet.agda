{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSharedPreambleIsACommonPrefixNotACommonSet
--
-- `interactive/TraceLibrary.hs` computes the shared helper preamble of its
-- trace records as `foldr1 lcp` â” the longest common PREFIX â” after its
-- own `selfTest` refuted the first version, which had assumed the whole
-- preamble was shared ("records disagree on the helper preamble: 16 of
-- 17", the module catching its own author).
--
-- Why the prefix and not the intersection is the right meet, checked:
--
--   * the common prefix IS the greatest common prefix (Â§2), so `lcp` is
--     a meet and not a heuristic;
--   * the common SET is not a preamble at all (Â§3) â” two records can
--     share every declaration and have empty common prefix, and any
--     ordering of the shared set fails to be a prefix of one of them.
--
-- That second half is what makes the choice forced rather than
-- conservative: a preamble is a sequence whose later lemmas may cite
-- earlier ones, so a set of declarations is not a preamble until it is
-- ordered, and no single ordering serves two records that disagree.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT I READ FIRST
--
-- `interactive/TraceLibrary.hs` end to end, including
-- `sharedPreamble recs = Right (foldr1 lcp (map (fst . splitAtCandidate
-- . recBody) recs))` and its `selfTest`.  The declaration names below â”
-- `addZero`, `addSuc` â” are that file's own, and `addZero : (a : â•) â’
-- (a + zero) â‰¡ a` is the lemma its header says every record carries.
--
-- ADJACENT AND NOT MERGED.  `Anuvrtti` proves that a
-- measure sensitive to inheritance does not descend to the rule SET, and
-- Â§3 here is the same shape one level down â” order carrying what the set
-- does not.  They are different statements about different objects and
-- neither derives the other: Anuvrtti is about a cost failing to factor
-- through `asSet`; Â§3 is about a common set failing to BE a preamble.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheSharedPreambleIsACommonPrefixNotACommonSet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Declarations, preambles, and being a prefix
------------------------------------------------------------------------

data Decl : Type where
  addZero addSuc : Decl

private
  isAddZero : Decl â†’ Type
  isAddZero addZero = Unit
  isAddZero addSuc  = âŠ¥

addZeroâ‰¢addSuc : Â¬ (addZero â‰¡ addSuc)
addZeroâ‰¢addSuc p = transport (cong isAddZero p) tt

Preamble : Type
Preamble = List Decl

Prefix : Preamble â†’ Preamble â†’ Type
Prefix []       _        = Unit
Prefix (_ âˆ· _)  []       = âŠ¥
Prefix (x âˆ· xs) (y âˆ· ys) = (x â‰¡ y) Ã— Prefix xs ys

------------------------------------------------------------------------
-- 2.  The longest common prefix is a meet
------------------------------------------------------------------------

lcp : Preamble â†’ Preamble â†’ Preamble
lcp []              _               = []
lcp (_ âˆ· _)         []              = []
lcp (addZero âˆ· xs) (addZero âˆ· ys)   = addZero âˆ· lcp xs ys
lcp (addSuc  âˆ· xs) (addSuc  âˆ· ys)   = addSuc  âˆ· lcp xs ys
lcp (addZero âˆ· _)  (addSuc  âˆ· _)    = []
lcp (addSuc  âˆ· _)  (addZero âˆ· _)    = []

lcpPrefixLeft : (xs ys : Preamble) â†’ Prefix (lcp xs ys) xs
lcpPrefixLeft []              _               = tt
lcpPrefixLeft (_ âˆ· _)         []              = tt
lcpPrefixLeft (addZero âˆ· xs) (addZero âˆ· ys)   = refl , lcpPrefixLeft xs ys
lcpPrefixLeft (addSuc  âˆ· xs) (addSuc  âˆ· ys)   = refl , lcpPrefixLeft xs ys
lcpPrefixLeft (addZero âˆ· _)  (addSuc  âˆ· _)    = tt
lcpPrefixLeft (addSuc  âˆ· _)  (addZero âˆ· _)    = tt

lcpPrefixRight : (xs ys : Preamble) â†’ Prefix (lcp xs ys) ys
lcpPrefixRight []              _              = tt
lcpPrefixRight (_ âˆ· _)         []             = tt
lcpPrefixRight (addZero âˆ· xs) (addZero âˆ· ys)  = refl , lcpPrefixRight xs ys
lcpPrefixRight (addSuc  âˆ· xs) (addSuc  âˆ· ys)  = refl , lcpPrefixRight xs ys
lcpPrefixRight (addZero âˆ· _)  (addSuc  âˆ· _)   = tt
lcpPrefixRight (addSuc  âˆ· _)  (addZero âˆ· _)   = tt

-- and it is the GREATEST such: any common prefix is a prefix of it
lcpGreatest :
  (r xs ys : Preamble) â†’ Prefix r xs â†’ Prefix r ys â†’ Prefix r (lcp xs ys)
lcpGreatest []       _               _               _ _ = tt
lcpGreatest (_ âˆ· _)  []              _               p _ = p
lcpGreatest (_ âˆ· _)  (_ âˆ· _)         []              _ q = q
lcpGreatest (addZero âˆ· r) (addZero âˆ· xs) (addZero âˆ· ys) (_ , p) (_ , q) =
  refl , lcpGreatest r xs ys p q
lcpGreatest (addSuc âˆ· r)  (addSuc âˆ· xs)  (addSuc âˆ· ys)  (_ , p) (_ , q) =
  refl , lcpGreatest r xs ys p q
lcpGreatest (addZero âˆ· _) (addSuc âˆ· _)   _              (e , _) _ =
  âŠ¥.rec (addZeroâ‰¢addSuc e)
lcpGreatest (addSuc âˆ· _)  (addZero âˆ· _)  _              (e , _) _ =
  âŠ¥.rec (addZeroâ‰¢addSuc (sym e))
lcpGreatest (addZero âˆ· _) (addZero âˆ· _)  (addSuc âˆ· _)   _ (e , _) =
  âŠ¥.rec (addZeroâ‰¢addSuc e)
lcpGreatest (addSuc âˆ· _)  (addSuc âˆ· _)   (addZero âˆ· _)  _ (e , _) =
  âŠ¥.rec (addZeroâ‰¢addSuc (sym e))

------------------------------------------------------------------------
-- 3.  The common SET is not a preamble
--
-- Two records carrying exactly the same two declarations, in opposite
-- orders.  Their common prefix is empty, and neither ordering of the
-- shared pair is a prefix of both.
------------------------------------------------------------------------

recordOne recordTwo : Preamble
recordOne = addZero âˆ· addSuc âˆ· []
recordTwo = addSuc âˆ· addZero âˆ· []

commonPrefixIsEmpty : lcp recordOne recordTwo â‰¡ []
commonPrefixIsEmpty = refl

neitherOrderingServesBoth :
    (Â¬ Prefix recordOne recordTwo)
  Ã— (Â¬ Prefix recordTwo recordOne)
neitherOrderingServesBoth =
    (Î» p â†’ addZeroâ‰¢addSuc (p .fst))
  , (Î» p â†’ addZeroâ‰¢addSuc (sym (p .fst)))

------------------------------------------------------------------------
-- 4.  The reading
--
-- Â§2 says `foldr1 lcp` is not a conservative guess: it computes the
-- greatest object of the right kind.  Â§3 says the tempting alternative â”
-- take the declarations both records share â” is not an object of that
-- kind at all, because a preamble is a SEQUENCE and a set has to be
-- ordered before it can be one.  Two records sharing every declaration
-- can share no prefix.
--
-- So the first version of that module was not merely optimistic; the
-- notion it reached for does not exist.  Its `selfTest` caught the
-- symptom (16 of 17 disagree) and the choice of `lcp` is the cure, and
-- Â§2â“Â§3 are why the cure is forced.
------------------------------------------------------------------------
