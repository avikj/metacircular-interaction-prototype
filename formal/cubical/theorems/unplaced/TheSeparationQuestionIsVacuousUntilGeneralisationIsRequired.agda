{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSeparationQuestionIsVacuousUntilGeneralisationIsRequired
--
-- `notes/SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §6 asks:
--
--   "Is there a mechanizable predicate on a note's *text* that decides
--    whether its principal object is outside arithmetic, and hence
--    whether a `SEARCH` flag is mandatory — one that would have fired
--    on SEED-05 and SEED-09 and not on the 47 declared-classical
--    files?"
--
-- Two candidates have been killed by measurement in §9 and §10 of that
-- note (¬P₁ at a 77.3% base rate; P₂ firing on neither).  Both cycles
-- hunted a THIRD candidate.  This one does not.
--
-- ────────────────────────────────────────────────────────────────────
-- THE GAP, STATED AND NOT AMENDED (the note is untouched by this
-- cycle; the wording offer is the next cycle's named step).
--
-- **§6 AS PHRASED IS SATISFIED BY A LOOKUP TABLE.**  The predicate
-- "the file's path is one of these two" is mechanizable, decides in
-- constant time, fires on SEED-05 and SEED-09, and fires on none of
-- the 47.  So the search §9 and §10 conducted cannot be for a
-- predicate meeting §6's stated conditions — one exists, and is
-- worthless.  Whatever §6 wants is a condition it does not state.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, over an arbitrary type with decidable equality
--
--   lookup ps          the table predicate: `Mem a ps`
--   decLookup          it is decidable — mechanizable in §6's sense
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
--                      listed positive — its base rate is |pos ∩ corpus|
--
-- **THE CONCLUSION IS A CORRECTION TO THE QUESTION, NOT AN ANSWER TO
-- IT.**  §6's two conditions (fires on the two, not on the 47) are
-- satisfiable and hence not the criterion.  The two things that
-- actually did work in §9 and §10 were BASE RATE and OFF-LIST
-- BEHAVIOUR — §9 killed ¬P₁ by its base rate, not by an error on the
-- named instances.  That was the right instrument, and the theorems
-- here say why it had to be: on the named instances every candidate is
-- the table.
--
-- So the question that can be settled is:
--
--   Is there a decidable predicate that fires on SEED-05 and SEED-09,
--   on none of the 47, AND whose firing set over the whole snapshot is
--   small — with the bound stated in advance?
--
-- That is answerable by a finite exhaustive check under the licence §6
-- itself sets, and it is not answerable by a lookup table.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY, AND THE PRIOR ART IS NOT MINE.  "A classifier that fits
-- finitely many labelled points proves nothing; the content is
-- generalisation and the false-positive rate" is the founding
-- observation of statistical learning theory (Vapnik–Chervonenkis
-- 1971) and, before any of it, the standard reply to enumerative
-- induction — the Nyāya requirement that a hetu be established by
-- vyāpti, a PERVASION holding wherever the mark holds, and not by a
-- list of sapakṣa instances; a hetu present only in the examples cited
-- is precisely the fallacy the school names and rejects.  Nothing here
-- adds to either.  What is added is the observation that SEED-83's §6
-- is stated in the enumerative form and therefore has a trivial
-- answer.
--
-- WHAT IS NOT CLAIMED.  No predicate is exhibited: §6 is NOT closed by
-- this module, and the honest status is that its stated form is
-- vacuous and its intended form is unstated.  Nothing here is about
-- text: `A` is any type with decidable equality and the documents are
-- opaque.  No BOUND on a usable base rate is proposed — "small" is not
-- made precise here, and choosing the bound in advance is the part a
-- later cycle must not skip.  Nothing is said about whether a good
-- predicate EXISTS; §8's equivalence (every candidate is
-- `Outside ∘ denotes` with a decision attached) is untouched.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheSeparationQuestionIsVacuousUntilGeneralisationIsRequired where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

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

  lookup : List A → A → Type
  lookup ps a = Mem a ps

  decLookup : (ps : List A) (a : A) → Dec (lookup ps a)
  decLookup ps a = decAny (λ y → y ≡ a) (λ y → eq? y a) ps

  ------------------------------------------------------------------
  -- 2.  A separator always exists
  ------------------------------------------------------------------

  separatorExists :
    (pos neg : List A)
    → ((a : A) → Mem a pos → Mem a neg → ⊥)
    → Σ[ P ∈ (A → Type) ]
         ((a : A) → Dec (P a))
       × ((a : A) → Mem a pos → P a)
       × ((a : A) → Mem a neg → ¬ P a)
  separatorExists pos neg disj =
      lookup pos
    , decLookup pos
    , (λ a mp → mp)
    , (λ a mn mp → disj a mp mn)

  ------------------------------------------------------------------
  -- 3.  On the listed documents every candidate IS the table
  ------------------------------------------------------------------

  noFiniteCheckSeparatesTheRuleFromTheTable :
    (P : A → Type) (pos neg : List A)
    → ((a : A) → Mem a pos → P a)
    → ((a : A) → Mem a neg → ¬ P a)
    → (a : A) → Mem a pos ⊎ Mem a neg
    → (P a → lookup pos a) × (lookup pos a → P a)
  noFiniteCheckSeparatesTheRuleFromTheTable P pos neg hp hn a (inl mp) =
    (λ _ → mp) , (λ _ → hp a mp)
  noFiniteCheckSeparatesTheRuleFromTheTable P pos neg hp hn a (inr mn) =
    (λ pa → ⊥.rec (hn a mn pa)) , (λ mp → hp a mp)

  ------------------------------------------------------------------
  -- 4.  Generalisation is the missing condition
  ------------------------------------------------------------------

  Generalises : (A → Type) → List A → Type
  Generalises P ps = Σ[ a ∈ A ] (P a × (¬ Mem a ps))

  lookupDoesNotGeneralise : (ps : List A) → ¬ Generalises (lookup ps) ps
  lookupDoesNotGeneralise ps (a , mp , ¬mp) = ¬mp mp

  firingOffTheListIsGeneralisation :
    (P : A → Type) (ps : List A) (a : A)
    → P a → ¬ Mem a ps → Generalises P ps
  firingOffTheListIsGeneralisation P ps a pa ¬mp = a , pa , ¬mp

  ------------------------------------------------------------------
  -- 5.  …and the table's base rate over any corpus is its own length
  ------------------------------------------------------------------

  tableFiresOnlyOnListedDocuments :
    (pos docs : List A) (a : A)
    → Mem a (filterDec (lookup pos) (decLookup pos) docs)
    → Mem a pos
  tableFiresOnlyOnListedDocuments pos docs a =
    memberOfFilterSatisfies (lookup pos) (decLookup pos) docs a
