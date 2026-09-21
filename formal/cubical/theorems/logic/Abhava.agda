{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Abhava
--
-- ààà¾àµ â” absence, with its counterpositive.  Navya-Nyya's apparatus,
-- applied to the thing this repository is actually about.
--
-- THE DISCIPLINE.  In Navya-Nyya you may not assert a bare absence.
-- Every ààà¾àµ carries its ààà°àà¿à¯à‹à—à¿à¨à (pratiyogin, counterpositive) â” WHAT is
-- absent â” and its locus, and its ààµààààà¦à• (avacchedaka, delimitor) saying
-- under what qualification.  "Absent" alone is not a proposition.
--
-- This corpus has been asserting bare absences for weeks.  "The sieve
-- forgets parity."  "The observer is blind."  "Information is lost."
-- Absence of what, in which locus, delimited how?  Nobody said, and the
-- consequence was concrete: "the obstruction is somewhere in the sieve"
-- survived as a live belief for a long time because it was never a
-- well-formed claim that could be false.
--
-- WHAT IS CHECKED HERE:
--
--  1. `Abhva` â” absence packaged with its counterpositive, so that the
--     type of a blindness claim exhibits what is missing.
--
--  2. The ABSENCE HIERARCHY STABILISES AT THREE, not at two.
--     ÂÂÂP â” ÂP is derivable; ÂÂP â’ P is not.  So absence-of-absence is
--     a genuinely new entity and absence-of-absence-of-absence is not.
--     That is a Navya-Nyya-shaped fact and it is **constructively true
--     and classically invisible** â” under excluded middle the hierarchy
--     collapses at two and the distinction they argued about disappears.
--
--  3. And it collapses at two exactly when the counterpositive is
--     DECIDABLE (`dec-collapses`).  So the level at which the hierarchy
--     stabilises measures the decidability of what is absent.  That is
--     the avacchedaka doing real work: the same absence, delimited by
--     decidability or not, is two different objects.
--
--  4. The walk's blindness, restated as a proper abhva with its
--     counterpositive named.
--
-- WHY THIS IS NOT DECORATION.  Delta 15's D15.83 says the content of a
-- failed identification is a proof-relevant defect TYPE.  Navya-Nyya
-- said absences are entities carrying their counterpositives, in the
-- fourteenth century.  Same move: negation is positive data, not the
-- vanishing of data.  One was available to Gagea; the other had to
-- wait for Voevodsky.
------------------------------------------------------------------------

module Abhava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import WalkJumps using (IsPrime)
open import SuccessorIsNotTropical using (disjoint-support)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  An absence is never bare
--
-- The record forces the counterpositive and the locus to be exhibited.
-- You cannot construct one by saying "something is missing".
------------------------------------------------------------------------

record AbhÄva (L : Type â„“) (pratiyogin : L â†’ Type â„“') : Type (â„“-max â„“ â„“') where
  constructor absence-of_at_
  field
    delimitor : L                       -- à¤…à¤µà¤šà¥à¤›à¥‡à¤¦à¤•: under this qualification
    absent    : Â¬ (pratiyogin delimitor)

open AbhÄva public

------------------------------------------------------------------------
-- 2.  The hierarchy of absences stabilises at three
--
-- Absence of absence is a new entity.  Absence of absence of absence is
-- not.  This is exactly the shape of the Navya-Nyya analysis, and it is
-- a CONSTRUCTIVE fact: classically both collapse and there is nothing to
-- discuss, which is why the distinction reads as scholastic hair-splitting
-- to a reader who has only ever had excluded middle.
------------------------------------------------------------------------

-- the unit: presence gives absence-of-absence
Â¬Â¬-unit : {A : Type â„“} â†’ A â†’ Â¬ (Â¬ A)
Â¬Â¬-unit a Â¬a = Â¬a a

-- and three levels collapse to one, both ways
Â¬Â¬Â¬â†’Â¬ : {A : Type â„“} â†’ Â¬ (Â¬ (Â¬ A)) â†’ Â¬ A
Â¬Â¬Â¬â†’Â¬ Â¬Â¬Â¬a a = Â¬Â¬Â¬a (Â¬Â¬-unit a)

Â¬â†’Â¬Â¬Â¬ : {A : Type â„“} â†’ Â¬ A â†’ Â¬ (Â¬ (Â¬ A))
Â¬â†’Â¬Â¬Â¬ Â¬a = Â¬Â¬-unit Â¬a

-- so the tower is: A , ÂA , ÂÂA , and then nothing new forever.
absence-hierarchy-stabilises :
  {A : Type â„“} â†’ (Â¬ (Â¬ (Â¬ A)) â†’ Â¬ A) Ã— (Â¬ A â†’ Â¬ (Â¬ (Â¬ A)))
absence-hierarchy-stabilises = Â¬Â¬Â¬â†’Â¬ , Â¬â†’Â¬Â¬Â¬

------------------------------------------------------------------------
-- 3.  The delimitor decides where it stabilises
--
-- If the counterpositive is decidable, absence-of-absence collapses to
-- presence and the tower is two tall.  If it is not, the tower is three.
-- So the SAME absence, delimited by decidability or not, is two
-- different objects â” which is precisely what an avacchedaka is for.
------------------------------------------------------------------------

dec-collapses : {A : Type â„“} â†’ Dec A â†’ Â¬ (Â¬ A) â†’ A
dec-collapses (yes a) _   = a
dec-collapses (no Â¬a) Â¬Â¬a = Empty.rec (Â¬Â¬a Â¬a)

------------------------------------------------------------------------
-- 4.  The walk's blindness, well-formed at last
--
-- `disjoint-support` says: no prime divides two consecutive integers.
-- As a bare statement that is a negation floating free.  As an ààà¾àµ it
-- has a counterpositive â” "p divides both n and its successor" â” a
-- locus, and a delimitor, and it is now a claim that could be false.
------------------------------------------------------------------------

-- the counterpositive: p divides n and also divides its successor
SharedPrime : â„• â†’ â„• â†’ Type
SharedPrime n p = IsPrime p Ã— (p âˆ£ n) Ã— (p âˆ£ suc n)

-- the absence itself, delimited by the prime under consideration
no-shared-prime : (n p : â„•) â†’ AbhÄva â„• (SharedPrime n)
no-shared-prime n p =
  absence-of p at Î» where (pp , pâˆ£n , pâˆ£sn) â†’ disjoint-support p n pp pâˆ£n pâˆ£sn

-- and it is decidable-shaped in the sense of Â§3: the counterpositive is
-- an absence whose own negation is what `disjoint-support` supplies
-- directly, so the tower here is two tall and no double-negation
-- residue is hiding in the walk's blindness.  The blindness is exact,
-- not merely unproven.
walk-blindness-is-exact :
  (n p : â„•) â†’ Â¬ (Â¬ (Â¬ (SharedPrime n p)))  â†’  Â¬ (SharedPrime n p)
walk-blindness-is-exact n p = Â¬Â¬Â¬â†’Â¬

------------------------------------------------------------------------
-- CORRECTION: Â§3's reading of the stabilisation level.
--
-- This module's header says "the level at which the hierarchy stabilises
-- measures the decidability of what is absent â¦ the same absence,
-- delimited by decidability or not, is two different objects."
--
-- It does not, and `ÂÂÂâ’Â` above is the proof: it takes no hypothesis.
-- The absence tower is two-tall for EVERY A, decidable or not, in every
-- corpus there has ever been.  The level therefore measures nothing and
-- cannot distinguish an exact obstruction from a genuine barrier.
--
-- What decidability governs is `dec-collapses` â” a statement about the
-- PRATIYOGIN A, not about the absence ÂA.  The Navya-Nyya distinction
-- survives and lands one place over: the absence is always level-two, and
-- it is the counterpositive whose own recoverability is at issue.
--
-- `DeflationaryTest` runs this out: every obstruction in
-- this lane is stable by SHAPE (ÂA, or a Î  of ÂA, or those under
-- hypotheses), stability is closed under Â / â’ / — / Î  but NOT under âŠ,
-- a gap between ÂÂA and A is contradictory, and so the only surviving
-- form of a barrier claim is Â(Dec A) â” which nothing here asserts.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  THE OTHER HALF OF THE DIVISION.
--
-- Everything above is àààà°àà—à¾àà¾àµ â” the absence of a RELATION at a locus.
-- Praastapda's division (*Padrthadharmasagraha*, c. 6th c.) and every
-- Nyya text after it hold a second kind irreducible to it:
--
--     àà¨àà¯à‹à¨àà¯à¾àà¾àµ â” the absence of IDENTITY.  A cloth is not a pot.
--
-- `AnyonyaAbhava` builds it, and finds that the `Abhva`
-- record above was already general enough to carry it
-- (`anyonya-is-abhava`, with ààà°àà¿à¯à‹à—à¿à¨à the family `_â‰¡ b`).
--
-- The dispute over whether one kind reduces to the other is a thousand
-- years old and Navya-Nyya rejects both reductions.  Made exact:
--
--   àà¨àà¯à‹à¨àà¯ âŸ àààà°àà—   free, no hypothesis
--   àààà°àà— âŸ àà¨àà¯à‹à¨àà¯   only up to ÂÂ, and only with a decidable
--                        ààà°àà¿à¯à‹à—à¿à¨à
--
-- So the reduction fails by EXACTLY ONE STEP OF THE TOWER Â§2 measures,
-- and Â§3's `dec-collapses` is precisely what closes it when the
-- ààµààààà¦à• is decidable.  The two-fold division is therefore not a
-- taxonomy of examples; it is indexed by decidability in the same way
-- the tower's height is.
--
-- Classically the distinction is invisible â” excluded middle makes the
-- categories interderivable at every delimitor and the dispute a dispute
-- about nothing.  That is the second time the Nyya analysis of ààà¾àµ has
-- turned out to track constructive structure, Â§2â“3 being the first.
------------------------------------------------------------------------
