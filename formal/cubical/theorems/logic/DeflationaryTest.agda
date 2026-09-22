{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DeflationaryTest
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ABSENCE TOWER
--
-- Decidability plays no part in the absence tower:
--
--     Â-always-stable :  (A : Type â“) â’ Â Â (Â A) â’ Â A
--
-- holds for EVERY A, decidable or not â” it is `Abhava`'s own `ÂÂÂâ’Â`,
-- which never used a hypothesis.  So the absence tower is two-tall for
-- every absence there has ever been.  Nothing in any corpus lives at
-- level three, and the level therefore carries no information about the
-- obstruction whatsoever.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE DECIDABILITY ACTUALLY ENTERS
--
--     decâ’stable :  Dec A â’ (Â Â A â’ A)
--
-- â” a statement about the PRATIYOGIN A, not about the absence ÂA.  The
-- Navya-Nyya distinction lands here:
-- the absence is always level-two; it is the
-- counterpositive whose own recoverability decidability governs.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THE STABLE FRAGMENT SWALLOWS THIS WHOLE CORPUS
--
-- Stability is closed under Â, under â’, under —, and under Î 
-- (`Î -stable`).  Every obstruction in this thread has one of the shapes
--
--     Â A          (p âˆ suc n ;  Â Idempotent i ;  Â Reformulation)
--     (x : X) â’ Â A  (â-has-no-i ;  sign-is-not-accumulable)
--
-- so all of them are stable by SHAPE, before anyone asks whether anything
-- is decidable.  Â§7 below instantiates the closure lemmas at those exact
-- shapes.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT A BARRIER CLAIM WOULD HAVE TO SAY INSTEAD
--
-- If "barrier" is to mean more than "here is a proof of ÂA", it must be a
-- claim about A:
--
--   (a) A is undecidable, or
--   (b) ÂÂA holds while A fails.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE DECIDABILITY ENTERS: THE DISJUNCTIONS
--
-- Stability is NOT closed under âŠ â” a stable-closure proof for sums is
-- exactly excluded middle.  So every place this corpus asserts an
-- either/or is a place where the deflation does not reach.  `Anekanta`'s
-- `collapse-dichotomy`, `Apavada`'s `kinds-exclude`, `NoNormOnAJoin`'s
-- `two-valued` and `three-collide` are all âŠ-shaped, and each obtains its
-- disjunction from a DECIDABLE source (`splitâ•-â‰`, `discreteâ`, an
-- explicit case split).  That is where decidability was doing work all
-- along â” in the disjunctions, not in the absences.
------------------------------------------------------------------------

module DeflationaryTest where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  Stability
------------------------------------------------------------------------

Stable : Type â„“ â†’ Type â„“
Stable A = Â¬ (Â¬ A) â†’ A

------------------------------------------------------------------------
-- 2.  EVERY absence is stable.  No hypothesis, no decidability.
------------------------------------------------------------------------

Â¬-always-stable : (A : Type â„“) â†’ Stable (Â¬ A)
Â¬-always-stable A Â¬Â¬Â¬a a = Â¬Â¬Â¬a (Î» Â¬a â†’ Â¬a a)

-- the tower, stated as the corpus states it, now visibly unconditional
absence-tower-is-two-tall :
  (A : Type â„“) â†’ (Â¬ (Â¬ (Â¬ A)) â†’ Â¬ A) Ã— (Â¬ A â†’ Â¬ (Â¬ (Â¬ A)))
absence-tower-is-two-tall A =
  Â¬-always-stable A , (Î» Â¬a k â†’ k Â¬a)

------------------------------------------------------------------------
-- 3.  Decidability governs the COUNTERPOSITIVE, not the absence
------------------------------------------------------------------------

decâ†’stable : {A : Type â„“} â†’ Dec A â†’ Stable A
decâ†’stable (yes a) _   = a
decâ†’stable (no Â¬a) Â¬Â¬a = Empty.rec (Â¬Â¬a Â¬a)

------------------------------------------------------------------------
-- 4.  The stable fragment is closed under everything but âŠ
------------------------------------------------------------------------

Î -stable : {X : Type â„“} {P : X â†’ Type â„“'}
         â†’ ((x : X) â†’ Stable (P x)) â†’ Stable ((x : X) â†’ P x)
Î -stable st h x = st x (Î» k â†’ h (Î» f â†’ k (f x)))

â†’-stable : {A : Type â„“} {B : Type â„“'} â†’ Stable B â†’ Stable (A â†’ B)
â†’-stable stB = Î -stable (Î» _ â†’ stB)

Ã—-stable : {A : Type â„“} {B : Type â„“'}
         â†’ Stable A â†’ Stable B â†’ Stable (A Ã— B)
Ã—-stable stA stB h =
    stA (Î» ka â†’ h (Î» p â†’ ka (fst p)))
  , stB (Î» kb â†’ h (Î» p â†’ kb (snd p)))

------------------------------------------------------------------------
-- 5.  The corpus's obstruction shapes, all stable by shape
------------------------------------------------------------------------

-- shape 1: a bare absence.  `disjoint-support`'s conclusion,
-- `bhavana-is-not-a-join`, `â-has-no-i` pointwise, `i-is-not-one`.
shape-absence : (A : Type â„“) â†’ Stable (Â¬ A)
shape-absence = Â¬-always-stable

-- shape 2: a family of absences.  `â-has-no-i`,
-- `sign-is-not-accumulable`, `disjoint-support` with its arguments.
shape-family : {X : Type â„“} (P : X â†’ Type â„“')
             â†’ Stable ((x : X) â†’ Â¬ (P x))
shape-family P = Î -stable (Î» x â†’ Â¬-always-stable (P x))

-- shape 3: hypotheses in front of an absence, any number of them.
shape-conditional : {X : Type â„“} {H : X â†’ Type â„“'} (P : X â†’ Type â„“')
                  â†’ Stable ((x : X) â†’ H x â†’ Â¬ (P x))
shape-conditional P = Î -stable (Î» x â†’ â†’-stable (Â¬-always-stable (P x)))

------------------------------------------------------------------------
-- 6.  What a barrier claim would have to be, as a type
--
-- Not "here is ÂA" â” that is always stable and always exact.  A barrier
-- in the strong sense is a gap between ÂÂA and A, and the type below is
-- what would have to be inhabited to exhibit one.
------------------------------------------------------------------------

GenuineGap : Type â„“ â†’ Type â„“
GenuineGap A = (Â¬ (Â¬ A)) Ã— (Â¬ A)

-- and it cannot be inhabited: a "gap" in that sense is a contradiction.
-- So even the strong reading has no room at the level of a single
-- proposition â” the only honest barrier claim is UNDECIDABILITY.
no-gap : {A : Type â„“} â†’ Â¬ (GenuineGap A)
no-gap (Â¬Â¬a , Â¬a) = Â¬Â¬a Â¬a

-- which leaves exactly one form of barrier claim standing:
BarrierClaim : Type â„“ â†’ Type â„“
BarrierClaim A = Â¬ (Dec A)

------------------------------------------------------------------------
-- 7.  The deflation, stated.
--
--   * every absence is level-two, unconditionally;
--   * so the stabilisation level measures nothing;
--   * decidability governs the counterpositive, not the absence;
--   * every obstruction in this thread is stable BY SHAPE (Â§5);
--   * a gap between ÂÂA and A is contradictory (`no-gap`), so the only
--     surviving form of a barrier claim is `Â (Dec A)`.
--
-- The barrier vocabulary is therefore unwarranted by these objects.
--
-- Where decidability WAS doing work all along: the âŠ-shaped results.
-- Stability does not pass through sums, and `Anekanta.collapse-dichotomy`,
-- `Apavada.kinds-exclude`, `NoNormOnAJoin.two-valued` and `three-collide`
-- are all disjunctions obtained from decidable sources.  That is the
-- honest home of the avacchedaka in this corpus.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  The âŠ-sites close too, and for a reason about the SUBSTRATE.
--
-- Â§7 leaves the sum-shaped results as the one place a genuine barrier
-- could sit, since stability does not pass through âŠ:
--
--     **in a `--safe`, postulate-free development, every inhabited âŠ is a
--     decision, because it was constructed.**
--
-- There is no way to write a term of `A âŠ B` without producing `inl a` or
-- `inr b`.  A "non-constructive dichotomy" is not expressible in this
-- lane at all â” not hard to find, not absent by luck: unwritable.
--
-- The anchor for that: a dichotomy of the
-- form `A âŠ Â A` is literally decidability, up to the obvious iso.
------------------------------------------------------------------------

sumâ†’dec : {A : Type â„“} â†’ A âŠŽ (Â¬ A) â†’ Dec A
sumâ†’dec (inl a)  = yes a
sumâ†’dec (inr Â¬a) = no Â¬a

decâ†’sum : {A : Type â„“} â†’ Dec A â†’ A âŠŽ (Â¬ A)
decâ†’sum (yes a)  = inl a
decâ†’sum (no Â¬a)  = inr Â¬a

sumâ†’decâ†’sum : {A : Type â„“} (d : A âŠŽ (Â¬ A)) â†’ decâ†’sum (sumâ†’dec d) â‰¡ d
sumâ†’decâ†’sum (inl _) = refl
sumâ†’decâ†’sum (inr _) = refl

decâ†’sumâ†’dec : {A : Type â„“} (d : Dec A) â†’ sumâ†’dec (decâ†’sum d) â‰¡ d
decâ†’sumâ†’dec (yes _) = refl
decâ†’sumâ†’dec (no  _) = refl

------------------------------------------------------------------------
-- 9.  The deflation, closed.
--
--   * every absence is stable, unconditionally (Â§2) â” nothing sits at
--     level three, and the level measures nothing;
--   * every obstruction in this lane is Â-headed or a Î  of such, hence
--     stable by shape (Â§5);
--   * a gap between ÂÂA and A is contradictory (Â§6), so the only
--     surviving barrier claim is Â (Dec A);
--   * and every dichotomy that could have carried one is a decision,
--     because in a postulate-free development it had to be built (Â§8).
--
-- So no statement in this repository is, or can be, a barrier in any
-- sense stronger than "here is a proof of ÂA".
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 10.  The last candidate barrier form is itself contradictory.
-- `Â (Dec A)` is CONTRADICTORY, for every A, constructively:
--
--     no-barrier-claim :  (A : Type â“) â’ Â (Â (Dec A))
--
--     assume k : Â (Dec A).  Then (Î» a â’ k (yes a)) : Â A,
--     so (no (Î» a â’ k (yes a))) : Dec A, and k applied to it gives âŠ.
--
-- Three lines.  So there is no barrier claim of that form to make, ever.
-- Undecidability of a specific proposition
-- is not something a constructive development can assert; what genuinely
-- undecidable results assert is something else entirely (independence
-- from a theory, or non-existence of an algorithm uniform in a
-- parameter), and neither is `Â (Dec A)` for a fixed A.
--
-- THE DEFLATION IS THEREFORE TOTAL:
--
--   * every absence is stable (Â§2);
--   * every obstruction here is Â-headed or a Î  of such (Â§5);
--   * a gap between ÂÂA and A is contradictory (Â§6);
--   * every dichotomy is a decision, since it had to be built (Â§8);
--   * and the last candidate barrier form is itself contradictory (Â§10).
--
-- There is no sense available in this lane in which any statement here is
-- a barrier, other than "here is a proof of ÂA" â” and that reading is
-- exact.  The word has nothing left to mean.
------------------------------------------------------------------------

no-barrier-claim : (A : Type â„“) â†’ Â¬ (BarrierClaim A)
no-barrier-claim A k = k (no (Î» a â†’ k (yes a)))
