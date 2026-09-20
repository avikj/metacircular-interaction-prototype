{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSeparationQuestionIsVacuousUntilGeneralisationIsRequired
--
--
--   "Is there a mechanizable predicate on a note's *text* that decides
--    whether its principal object is outside arithmetic, and hence
--    whether a `SEARCH` flag is mandatory â” one that would have fired
--    on SEED-05 and SEED-09 and not on the 47 declared-classical
--    files?"
--
-- Two candidates have been killed by measurement in Â§9 and Â§10 of that
-- note (ÂPâ at a 77.3% base rate; Pâ firing on neither).  Both cycles
-- hunted a THIRD candidate.  This one does not.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE GAP, STATED AND NOT AMENDED (the note is untouched by this
-- cycle; the wording offer is the next cycle's named step).
--
-- **Â§6 AS PHRASED IS SATISFIED BY A LOOKUP TABLE.**  The predicate
-- "the file's path is one of these two" is mechanizable, decides in
-- constant time, fires on SEED-05 and SEED-09, and fires on none of
-- the 47.  So the search Â§9 and Â§10 conducted cannot be for a
-- predicate meeting Â§6's stated conditions â” one exists, and is
-- worthless.  Whatever Â§6 wants is a condition it does not state.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED, over an arbitrary type with decidable equality
--
--   lookup ps          the table predicate: `Mem a ps`
--   decLookup          it is decidable â” mechanizable in Â§6's sense
--   separatorExists    for ANY disjoint pair of finite lists of
--                      positives and negatives there is a decidable
--                      predicate firing on all the first and none of
--                      the second.  Exhibiting a separator is
--                      therefore not evidence about anything
--   noFiniteCheckSeparatesTheRuleFromTheTable
--                      ANY predicate meeting the same conditions
--                      agrees with the table on every listed document,
--                      in both directions.  So no enlargement of the
--                      evidence LIST can distinguish a rule from a
--                      lookup: the content lives entirely off the list
--   Generalises P ps   P fires on something not listed
--   lookupDoesNotGeneralise
--                      the table does not, which is exactly its defect
--   firingOffTheListIsGeneralisation
--                      and any predicate that beats the table beats it
--                      by generalising
--   tableFiresOnlyOnListedDocuments
--                      over any corpus, every firing of the table is a
--                      listed positive â” its base rate is |pos âˆ© corpus|
--
-- **THE CONCLUSION IS A CORRECTION TO THE QUESTION, NOT AN ANSWER TO
-- IT.**  Â§6's two conditions (fires on the two, not on the 47) are
-- satisfiable and hence not the criterion.  The two things that
-- actually did work in Â§9 and Â§10 were BASE RATE and OFF-LIST
-- BEHAVIOUR â” Â§9 killed ÂPâ by its base rate, not by an error on the
-- named instances.  That was the right instrument, and the theorems
-- here say why it had to be: on the named instances every candidate is
-- the table.
--
-- So the question that can be settled is:
--
--   Is there a decidable predicate that fires on SEED-05 and SEED-09,
--   on none of the 47, AND whose firing set over the whole snapshot is
--   small â” with the bound stated in advance?
--
-- That is answerable by a finite exhaustive check under the licence Â§6
-- itself sets, and it is not answerable by a lookup table.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY, AND THE PRIOR ART IS NOT MINE.  "A classifier that fits
-- finitely many labelled points proves nothing; the content is
-- generalisation and the false-positive rate" is the founding
-- observation of statistical learning theory (Vapnikâ“Chervonenkis
-- 1971) and, before any of it, the standard reply to enumerative
-- induction â” the Nyya requirement that a hetu be established by
-- vypti, a PERVASION holding wherever the mark holds, and not by a
-- list of sapaka instances; a hetu present only in the examples cited
-- is precisely the fallacy the school names and rejects.  Nothing here
-- adds to either.  What is added is the observation that SEED-83's Â§6
-- is stated in the enumerative form and therefore has a trivial
-- answer.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheSeparationQuestionIsVacuousUntilGeneralisationIsRequired where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; decAny)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem ; memberOfFilterSatisfies)

module _ {A : Type} (eq? : Discrete A) where

  ------------------------------------------------------------------
  -- 1.  The table, and the fact that it is mechanizable
  ------------------------------------------------------------------

  lookup : List A â†’ A â†’ Type
  lookup ps a = Mem a ps

  decLookup : (ps : List A) (a : A) â†’ Dec (lookup ps a)
  decLookup ps a = decAny (Î» y â†’ y â‰¡ a) (Î» y â†’ eq? y a) ps

  ------------------------------------------------------------------
  -- 2.  A separator always exists
  ------------------------------------------------------------------

  separatorExists :
    (pos neg : List A)
    â†’ ((a : A) â†’ Mem a pos â†’ Mem a neg â†’ âŠ¥)
    â†’ Î£[ P âˆˆ (A â†’ Type) ]
         ((a : A) â†’ Dec (P a))
       Ã— ((a : A) â†’ Mem a pos â†’ P a)
       Ã— ((a : A) â†’ Mem a neg â†’ Â¬ P a)
  separatorExists pos neg disj =
      lookup pos
    , decLookup pos
    , (Î» a mp â†’ mp)
    , (Î» a mn mp â†’ disj a mp mn)

  ------------------------------------------------------------------
  -- 3.  On the listed documents every candidate IS the table
  ------------------------------------------------------------------

  noFiniteCheckSeparatesTheRuleFromTheTable :
    (P : A â†’ Type) (pos neg : List A)
    â†’ ((a : A) â†’ Mem a pos â†’ P a)
    â†’ ((a : A) â†’ Mem a neg â†’ Â¬ P a)
    â†’ (a : A) â†’ Mem a pos âŠŽ Mem a neg
    â†’ (P a â†’ lookup pos a) Ã— (lookup pos a â†’ P a)
  noFiniteCheckSeparatesTheRuleFromTheTable P pos neg hp hn a (inl mp) =
    (Î» _ â†’ mp) , (Î» _ â†’ hp a mp)
  noFiniteCheckSeparatesTheRuleFromTheTable P pos neg hp hn a (inr mn) =
    (Î» pa â†’ âŠ¥.rec (hn a mn pa)) , (Î» mp â†’ hp a mp)

  ------------------------------------------------------------------
  -- 4.  Generalisation is the missing condition
  ------------------------------------------------------------------

  Generalises : (A â†’ Type) â†’ List A â†’ Type
  Generalises P ps = Î£[ a âˆˆ A ] (P a Ã— (Â¬ Mem a ps))

  lookupDoesNotGeneralise : (ps : List A) â†’ Â¬ Generalises (lookup ps) ps
  lookupDoesNotGeneralise ps (a , mp , Â¬mp) = Â¬mp mp

  firingOffTheListIsGeneralisation :
    (P : A â†’ Type) (ps : List A) (a : A)
    â†’ P a â†’ Â¬ Mem a ps â†’ Generalises P ps
  firingOffTheListIsGeneralisation P ps a pa Â¬mp = a , pa , Â¬mp

  ------------------------------------------------------------------
  -- 5.  â¦and the table's base rate over any corpus is its own length
  ------------------------------------------------------------------

  tableFiresOnlyOnListedDocuments :
    (pos docs : List A) (a : A)
    â†’ Mem a (filterDec (lookup pos) (decLookup pos) docs)
    â†’ Mem a pos
  tableFiresOnlyOnListedDocuments pos docs a =
    memberOfFilterSatisfies (lookup pos) (decLookup pos) docs a
