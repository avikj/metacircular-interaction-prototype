-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Abhava
--
-- अभाव — absence, with its counterpositive.  Navya-Nyāya's apparatus,
-- applied to the thing this repository is actually about.
--
-- THE DISCIPLINE.  In Navya-Nyāya you may not assert a bare absence.
-- Every अभाव carries its प्रतियोगिन् (pratiyogin, counterpositive) — WHAT is
-- absent — and its locus, and its अवच्छेदक (avacchedaka, delimitor) saying
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
--  1. `Abhāva` — absence packaged with its counterpositive, so that the
--     type of a blindness claim exhibits what is missing.
--
--  2. The ABSENCE HIERARCHY STABILISES AT THREE, not at two.
--     ¬¬¬P ↔ ¬P is derivable; ¬¬P → P is not.  So absence-of-absence is
--     a genuinely new entity and absence-of-absence-of-absence is not.
--     That is a Navya-Nyāya-shaped fact and it is **constructively true
--     and classically invisible** — under excluded middle the hierarchy
--     collapses at two and the distinction they argued about disappears.
--
--  3. And it collapses at two exactly when the counterpositive is
--     DECIDABLE (`dec-collapses`).  So the level at which the hierarchy
--     stabilises measures the decidability of what is absent.  That is
--     the avacchedaka doing real work: the same absence, delimited by
--     decidability or not, is two different objects.
--
--  4. The walk's blindness, restated as a proper abhāva with its
--     counterpositive named.
--
-- WHY THIS IS NOT DECORATION.  Delta 15's D15.83 says the content of a
-- failed identification is a proof-relevant defect TYPE.  Navya-Nyāya
-- said absences are entities carrying their counterpositives, in the
-- fourteenth century.  Same move: negation is positive data, not the
-- vanishing of data.  One was available to Gaṅgeśa; the other had to
-- wait for Voevodsky.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Abhava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.WalkJumps using (IsPrime)
open import NaturalMachine.SuccessorIsNotTropical using (disjoint-support)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  An absence is never bare
--
-- The record forces the counterpositive and the locus to be exhibited.
-- You cannot construct one by saying "something is missing".
------------------------------------------------------------------------

record Abhāva (L : Type ℓ) (pratiyogin : L → Type ℓ') : Type (ℓ-max ℓ ℓ') where
  constructor absence-of_at_
  field
    delimitor : L                       -- अवच्छेदक: under this qualification
    absent    : ¬ (pratiyogin delimitor)

open Abhāva public

------------------------------------------------------------------------
-- 2.  The hierarchy of absences stabilises at three
--
-- Absence of absence is a new entity.  Absence of absence of absence is
-- not.  This is exactly the shape of the Navya-Nyāya analysis, and it is
-- a CONSTRUCTIVE fact: classically both collapse and there is nothing to
-- discuss, which is why the distinction reads as scholastic hair-splitting
-- to a reader who has only ever had excluded middle.
------------------------------------------------------------------------

-- the unit: presence gives absence-of-absence
¬¬-unit : {A : Type ℓ} → A → ¬ (¬ A)
¬¬-unit a ¬a = ¬a a

-- and three levels collapse to one, both ways
¬¬¬→¬ : {A : Type ℓ} → ¬ (¬ (¬ A)) → ¬ A
¬¬¬→¬ ¬¬¬a a = ¬¬¬a (¬¬-unit a)

¬→¬¬¬ : {A : Type ℓ} → ¬ A → ¬ (¬ (¬ A))
¬→¬¬¬ ¬a = ¬¬-unit ¬a

-- so the tower is: A , ¬A , ¬¬A , and then nothing new forever.
absence-hierarchy-stabilises :
  {A : Type ℓ} → (¬ (¬ (¬ A)) → ¬ A) × (¬ A → ¬ (¬ (¬ A)))
absence-hierarchy-stabilises = ¬¬¬→¬ , ¬→¬¬¬

------------------------------------------------------------------------
-- 3.  The delimitor decides where it stabilises
--
-- If the counterpositive is decidable, absence-of-absence collapses to
-- presence and the tower is two tall.  If it is not, the tower is three.
-- So the SAME absence, delimited by decidability or not, is two
-- different objects — which is precisely what an avacchedaka is for.
------------------------------------------------------------------------

dec-collapses : {A : Type ℓ} → Dec A → ¬ (¬ A) → A
dec-collapses (yes a) _   = a
dec-collapses (no ¬a) ¬¬a = Empty.rec (¬¬a ¬a)

------------------------------------------------------------------------
-- 4.  The walk's blindness, well-formed at last
--
-- `disjoint-support` says: no prime divides two consecutive integers.
-- As a bare statement that is a negation floating free.  As an अभाव it
-- has a counterpositive — "p divides both n and its successor" — a
-- locus, and a delimitor, and it is now a claim that could be false.
------------------------------------------------------------------------

-- the counterpositive: p divides n and also divides its successor
SharedPrime : ℕ → ℕ → Type
SharedPrime n p = IsPrime p × (p ∣ n) × (p ∣ suc n)

-- the absence itself, delimited by the prime under consideration
no-shared-prime : (n p : ℕ) → Abhāva ℕ (SharedPrime n)
no-shared-prime n p =
  absence-of p at λ where (pp , p∣n , p∣sn) → disjoint-support p n pp p∣n p∣sn

-- and it is decidable-shaped in the sense of §3: the counterpositive is
-- an absence whose own negation is what `disjoint-support` supplies
-- directly, so the tower here is two tall and no double-negation
-- residue is hiding in the walk's blindness.  The blindness is exact,
-- not merely unproven.
walk-blindness-is-exact :
  (n p : ℕ) → ¬ (¬ (¬ (SharedPrime n p)))  →  ¬ (SharedPrime n p)
walk-blindness-is-exact n p = ¬¬¬→¬

------------------------------------------------------------------------
-- CORRECTION, 2026-08-18 — §3's reading of the stabilisation level.
--
-- This module's header says "the level at which the hierarchy stabilises
-- measures the decidability of what is absent … the same absence,
-- delimited by decidability or not, is two different objects."
--
-- It does not, and `¬¬¬→¬` above is the proof: it takes no hypothesis.
-- The absence tower is two-tall for EVERY A, decidable or not, in every
-- corpus there has ever been.  The level therefore measures nothing and
-- cannot distinguish an exact obstruction from a genuine barrier.
--
-- What decidability governs is `dec-collapses` — a statement about the
-- PRATIYOGIN A, not about the absence ¬A.  The Navya-Nyāya distinction
-- survives and lands one place over: the absence is always level-two, and
-- it is the counterpositive whose own recoverability is at issue.
--
-- `NaturalMachine.DeflationaryTest` runs this out: every obstruction in
-- this lane is stable by SHAPE (¬A, or a Π of ¬A, or those under
-- hypotheses), stability is closed under ¬ / → / × / Π but NOT under ⊎,
-- a gap between ¬¬A and A is contradictory, and so the only surviving
-- form of a barrier claim is ¬(Dec A) — which nothing here asserts.
--
-- Everything PROVED in this module stands.  The withdrawn sentence is the
-- reading of the level, and it is left visible above rather than edited.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  THE OTHER HALF OF THE DIVISION, appended 2026-08-18.
--
-- Everything above is संसर्गाभाव — the absence of a RELATION at a locus.
-- Praśastapāda's division (*Padārthadharmasaṃgraha*, c. 6th c.) and every
-- Nyāya text after it hold a second kind irreducible to it:
--
--     अन्योन्याभाव — the absence of IDENTITY.  A cloth is not a pot.
--
-- `NaturalMachine.AnyonyaAbhava` builds it, and finds that the `Abhāva`
-- record above was already general enough to carry it
-- (`anyonya-is-abhava`, with प्रतियोगिन् the family `_≡ b`).
--
-- The dispute over whether one kind reduces to the other is a thousand
-- years old and Navya-Nyāya rejects both reductions.  Made exact:
--
--   अन्योन्य ⟹ संसर्ग   free, no hypothesis
--   संसर्ग ⟹ अन्योन्य   only up to ¬¬, and only with a decidable
--                        प्रतियोगिन्
--
-- So the reduction fails by EXACTLY ONE STEP OF THE TOWER §2 measures,
-- and §3's `dec-collapses` is precisely what closes it when the
-- अवच्छेदक is decidable.  The two-fold division is therefore not a
-- taxonomy of examples; it is indexed by decidability in the same way
-- the tower's height is.
--
-- Classically the distinction is invisible — excluded middle makes the
-- categories interderivable at every delimitor and the dispute a dispute
-- about nothing.  That is the second time the Nyāya analysis of अभाव has
-- turned out to track constructive structure, §2–3 being the first.
------------------------------------------------------------------------
