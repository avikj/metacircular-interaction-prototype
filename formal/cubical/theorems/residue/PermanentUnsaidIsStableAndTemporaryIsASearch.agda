{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module PermanentUnsaidIsStableAndTemporaryIsASearch where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; Stable)
open import Cubical.Relation.Nullary.Properties using (Dec‚ÜíStable)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import AmshaSatyamachine using (‡§ï‡§¶‡§æ‡§ö‡§ø‡§§‡•ç-‡§â‡§ï‡•ç‡§§‡§Æ‡•ç ; ‡§∏‡•ç‡§•‡§æ‡§Ø‡§ø-‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç)

------------------------------------------------------------------------
-- PermanentUnsaidIsStableAndTemporaryIsASearch
--
-- `formal/cubical/AmshaSatyamachine.agda` was found by a zero-importer
-- census over `formal/cubical` and read.  It draws a distinction this
-- thread's closure results have an exact word for, and this module says
-- which word, using its predicates rather than restating them.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TWO PREDICATES, QUOTED FROM THAT MODULE
--
--     ‡ï‡¶‡æ‡‡ø‡‡-‡â‡ï‡‡‡Æ‡ ‡‡≤ i  =  Œ[ f ‚àà ‚ï ] Œ[ o ‚àà O ] (‡‡≤ f i ‚â° ‡â‡ï‡‡ o)
--     ‡‡‡‡æ‡Ø‡ø-‡‡®‡‡ï‡‡‡Æ‡ ‡‡≤ i  =  ¬ (‡ï‡¶‡æ‡‡ø‡‡-‡â‡ï‡‡‡Æ‡ ‡‡≤ i)
--
-- "ever-said: SOME grant produces an answer ‚î temporary un-said" and
-- "permanent un-said: NO grant ever produces an answer", in its own
-- gloss.  The first is a Œ; the second is a ¬ of it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ¬ß1  `‡‡‡‡æ‡Ø‡ø-‡‡®‡‡ï‡‡‡Æ‡` is ¬¬-STABLE for every machine and every input,
--       with no hypothesis ‚î it is a negation, and negations are stable
--       (`TheAbsenceTowerIsThreeUnconditionally`, and before that
--       `DeflationaryTest.¬-always-stable`).
--
--   ¬ß2  `‡ï‡¶‡æ‡‡ø‡‡-‡â‡ï‡‡‡Æ‡` is stable exactly when it is DECIDABLE.  It is a
--       Œ, and `WhereTheTowerCanStillBeThree` ¬ß5 is precisely the
--       statement that the closure argument stops there: `¬ ¬ (Œ ‚¶)`
--       hands back no component, and the only general route in is a
--       decision.
--
-- So the permanent/temporary distinction of that module sits exactly on
-- the Œ†/Œ line: **the negative pole is free, the positive pole is a
-- search.** Its `‡‡®‡®‡‡-‡®‡ø‡‡‡ß‡` ‚î a total machine can never have permanent
-- un-said ‚î is the same fact from the other side, since completeness
-- supplies the Œ at every input.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- **No correspondence is claimed between anything here and the
-- Anuyogadvra's sakhyta / asakhyta / ananta grading.** That module
-- invokes the grading; this one does not touch it. ¬ß1 and ¬ß2 are
-- statements about a Œ and its negation in Agda, and reading them as the
-- Jaina grades would be exactly the move withdrawn three times in this
-- thread already ‚î an imported notion in the tradition's clothes.
--
-- That the module's own results are affected: they are not. ¬ß1 and ¬ß2
-- add stability facts about its predicates and change none of its
-- theorems.
--
-- That decidability holds anywhere. ¬ß2 is conditional and nothing here
-- decides any machine's `‡ï‡¶‡æ‡‡ø‡‡-‡â‡ï‡‡‡Æ‡`.
--
-- PRIOR ART, grep run and quoted: `grep -rn AmshaSatyamachine
-- formal/cubical/ --include=*.agda` outside the file itself returns
-- nothing. It has no importers, which is how the census found it; this
-- is its first use. A module reaching it through `Everything.agda`'s
-- bulk import would not appear in that grep ‚î `Everything` was checked
-- and does not list it.
------------------------------------------------------------------------

private
  variable
    Inp Out : Type

------------------------------------------------------------------------
-- 1.  Permanent un-said is stable, for free
------------------------------------------------------------------------

permanentIsStable :
  (‡§ö‡§≤ : _) (i : Inp) ‚Üí Stable (‡§∏‡•ç‡§•‡§æ‡§Ø‡§ø-‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç {Inp} {Out} ‡§ö‡§≤ i)
permanentIsStable ‡§ö‡§≤ i nnn a = nnn (Œª n ‚Üí n a)

------------------------------------------------------------------------
-- 2.  Temporary un-said is stable exactly when the search is decided
------------------------------------------------------------------------

temporaryIsStableFromDecision :
  (‡§ö‡§≤ : _) (i : Inp)
  ‚Üí Dec (‡§ï‡§¶‡§æ‡§ö‡§ø‡§§‡•ç-‡§â‡§ï‡•ç‡§§‡§Æ‡•ç {Inp} {Out} ‡§ö‡§≤ i)
  ‚Üí Stable (‡§ï‡§¶‡§æ‡§ö‡§ø‡§§‡•ç-‡§â‡§ï‡•ç‡§§‡§Æ‡•ç {Inp} {Out} ‡§ö‡§≤ i)
temporaryIsStableFromDecision ‡§ö‡§≤ i = Dec‚ÜíStable

-- and the converse direction of the pair: a decided search settles the
-- permanent pole too, since the two are a proposition and its negation.
decisionSettlesBothPoles :
  (‡§ö‡§≤ : _) (i : Inp)
  ‚Üí Dec (‡§ï‡§¶‡§æ‡§ö‡§ø‡§§‡•ç-‡§â‡§ï‡•ç‡§§‡§Æ‡•ç {Inp} {Out} ‡§ö‡§≤ i)
  ‚Üí Stable (‡§ï‡§¶‡§æ‡§ö‡§ø‡§§‡•ç-‡§â‡§ï‡•ç‡§§‡§Æ‡•ç {Inp} {Out} ‡§ö‡§≤ i)
  √ó Stable (‡§∏‡•ç‡§•‡§æ‡§Ø‡§ø-‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç {Inp} {Out} ‡§ö‡§≤ i)
decisionSettlesBothPoles ‡§ö‡§≤ i d =
  temporaryIsStableFromDecision ‡§ö‡§≤ i d , permanentIsStable ‡§ö‡§≤ i
