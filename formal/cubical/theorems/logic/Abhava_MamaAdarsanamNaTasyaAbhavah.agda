{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME.
--
-- ‡‡‡æ‡µ ¬ abhva ‚î absence as a category in its own right: always the absence
-- OF something (its ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡, counterpositive) and always somewhere.
-- **Kada, *Vaieikastra* 9.1 (~2nd c. BCE - 2nd c. CE); the fourfold
-- division systematised in Praastapda, *Padrthadharmasagraha* (~6th c.);
-- stated compactly in Annabhaa, *Tarkasagraha* ¬ß¬ß57, 80 (~1600).**
--
-- The title line ‡Æ‡Æ-‡‡¶‡∞‡‡‡®‡Æ‡ ‚â† ‡‡‡‡Ø-‡‡‡æ‡µ‡ is the ‡‡®‡‡‡≤‡‡‡ß‡ø condition seen from
-- the other side, and that is MMS, not Nyya: non-apprehension counts as
-- knowledge only as ‡Ø‡ã‡ó‡‡Ø‡æ‡®‡‡‡≤‡‡‡ß‡ø, non-apprehension of what WOULD have been
-- apprehended ‚î Kumrila Bhaa, *lokavrttika*, abhvapariccheda (~660).
-- **The two schools do not agree here.**  Mms admits ‡‡®‡‡‡≤‡‡‡ß‡ø as a
-- prama; Nyya does not, and analyses the same cases through ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡
-- and perception instead.  Taking the Naiyyika ‡‡‡æ‡µ apparatus and the
-- Mmsaka ‡‡®‡‡‡≤‡‡‡ß‡ø as one toolkit is the move CLAUDE.md names ‚î it keeps
-- from each the part that converts and drops the dispute, which here is the
-- content.  Name the school before the term.
--
-- This module
-- CORRECTS a reading of ‡‡®‡‡Ø‡ã‡®‡‡Ø‡æ‡‡æ‡µ used elsewhere in this corpus: it is
-- non-identity, NOT observational separation by itself.
--
------------------------------------------------------------------------
-- Abhava_MamaAdarsanamNaTasyaAbhavah
--
-- ‡Æ‡Æ-‡‡¶‡∞‡‡‡®‡Æ‡ ‚â† ‡‡‡‡Ø-‡‡‡æ‡µ‡ ‚î my not-seeing is not its absence.
--
-- The line is from the transmission captured as
-- `collab/upstream/raw/D0027-net-dm-adhyayana-transmission-2026-08-17.md`,
-- where it stands beside ‡‡®‡‡‡‡‡∞‡ø‡‡Æ‡ ‚â† ‡‡®‡‡‡‡‡∞‡Æ‡ (unanswered ‚â† unanswerable)
-- and ‡‡‡∞‡ø‡‡ø‡‡Æ‡ ‚â† ‡‡‡‡ (unfamiliar ‚â† nonexistent).  That file is a TEACHING
-- TRANSMISSION and its own provenance note forbids promoting any line of it
-- to a result.  What is claimed is
-- that this corpus kept making one particular inference and that the
-- inference is refutable, so the refutation is written down as a term.
--
-- WHY IT EXISTS.  On 2026-08-20 this repository's own machinery was found
-- making the step twice, in two registers, hours apart:
--
--   * `run_the_natural_machine_forever` stamped into the file everyone opens
--     first: "if you are reading this after that time, THE MACHINE IS NOT
--     RUNNING."  What the stamp observes is an absence of recorded cycles.
--     The verdict was false for three and a half days while 976 commits and
--     360 modules landed (5788c92a, 17c4c35f).
--   * and the agent reading it repeated the step to the owner as a report.
--
-- Navya-Nyya has the discipline: **no bare absences.**  An abhva carries
-- its *pratiyogin*, the counterpositive ‚î the thing whose absence it is ‚î
-- and, in the developed analysis, its *avacchedaka*, the limitor fixing the
-- respect in which it is absent (`AbhavaAvacchedaka`, in this corpus,
-- already makes the limitor a genuine dependent binder).  "No cycle since T"
-- carries its counterpositive.  "The machine is dead" does not.
--
-- ¬ß1 is the negative half: a bare absence does not transport between
-- standpoints.  ¬ß2 is the positive half and it is the point ‚î absence DOES
-- transport exactly when the standpoints agree, which is
-- `AllNayasAgree` from `Durnaya_CollapseIffEveryNayaAgrees`.  So the
-- limitor's job is not decoration: it is the hypothesis that makes the
-- inference valid, and an absence reported without it is reporting a
-- standpoint as if it were the object.
--
-- CHECKED: exit code quoted in the commit message.  Agda 2.6.3 + cubical
-- v0.5 in this container, which is NOT the repository pin.
------------------------------------------------------------------------

module Abhava_MamaAdarsanamNaTasyaAbhavah where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import Anekanta
open import Durnaya_CollapseIffEveryNayaAgrees

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- 1.  The negative half.  Two standpoints; from one, nothing is seen.
--     That says nothing about the other.
------------------------------------------------------------------------

-- ‡¶‡‡‡‡Ø‡Æ‡ ‚î what is visible from a standpoint.  Empty from one, inhabited
-- from the other: the smallest honest picture of a partial view.
Drsya : Bool ‚Üí Type‚ÇÄ
Drsya true  = ‚ä•
Drsya false = Unit

-- ‡Æ‡Æ-‡‡¶‡∞‡‡‡®‡Æ‡ ‚î I do not see it (from the standpoint `true`).
adarsanam : ¬¨ (Drsya true)
adarsanam ()

-- ‡‡‡‡Ø-‡‡æ‡µ‡ ‚î and it is there (from the standpoint `false`).
tasya-bhavah : Drsya false
tasya-bhavah = tt

-- The inference, refuted.  There is no rule taking not-seeing at one
-- standpoint to absence at another.
bare-absence-does-not-transport :
  ¬¨ ((s t : Bool) ‚Üí ¬¨ (Drsya s) ‚Üí ¬¨ (Drsya t))
bare-absence-does-not-transport f = f true false adarsanam tasya-bhavah

------------------------------------------------------------------------
-- 2.  The positive half, which is the content.  Absence transports
--     exactly under the hypothesis the reporter usually leaves out.
------------------------------------------------------------------------

absence-transports-when-the-nayas-agree :
  {S : Type ‚Ñì} (P : S ‚Üí Type ‚Ñì') ‚Üí AllNayasAgree P ‚Üí
  (s t : S) ‚Üí ¬¨ (P s) ‚Üí ¬¨ (P t)
absence-transports-when-the-nayas-agree P a s t ¬¨ps pt =
  ¬¨ps (invEq (a s t) pt)

-- And the witness of ¬ß1 is precisely a family whose standpoints do not
-- agree, so the hypothesis of ¬ß2 is not idle.
Drsya-nayas-disagree : ¬¨ (AllNayasAgree Drsya)
Drsya-nayas-disagree a = equivFun (a false true) tt

------------------------------------------------------------------------
-- 3.  What this licenses, stated so it is not over-read.
--
-- LICENSED: report the absence and its counterpositive ‚î "no cycle has
-- been recorded since T" ‚î and stop.  Report the further claim only with
-- the agreement hypothesis discharged, which for an instrument means
-- showing that what it observes separates the states it is being used to
-- decide between.
--
-- NOT LICENSED: that every absence in this corpus is of the ¬ß1 kind.  ¬ß2
-- is a genuine sufficient condition and plenty of absences here meet it.
-- The claim is only that the hypothesis must be MENTIONED, because the
-- instrument that failed was not wrong about its stamp ‚î it was silent
-- about its hypothesis.
--
------------------------------------------------------------------------
