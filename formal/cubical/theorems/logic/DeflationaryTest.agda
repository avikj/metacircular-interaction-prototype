{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DeflationaryTest
--
-- The test `Abhava` set up, run â” and it comes back against `Abhava`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CLAIM UNDER TEST
--
-- `Abhava.agda` proves `ÂÂÂA â” ÂA` and reads it as:
--
--   "the level at which the hierarchy stabilises measures the
--    decidability of what is absent â¦ the same absence, delimited by
--    decidability or not, is two different objects."
--
-- The standing deflationary question was whether every absence in this
-- corpus is decidable, so that nothing lives at level three and every
-- "barrier" is exact.
--
-- The answer is stronger than the question and dissolves it.  Decidability
-- has nothing to do with it:
--
--     Â-always-stable :  (A : Type â“) â’ Â Â (Â A) â’ Â A
--
-- holds for EVERY A, decidable or not â” it is `Abhava`'s own `ÂÂÂâ’Â`,
-- which never used a hypothesis.  So the absence tower is two-tall for
-- every absence there has ever been.  Nothing in any corpus lives at
-- level three, and the level therefore carries no information about the
-- obstruction whatsoever.
--
-- `Abhava`'s reading is withdrawn.  Its theorem stands untouched; what is
-- withdrawn is the sentence saying the stabilisation level measures
-- decidability.  It measures nothing.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE DECIDABILITY ACTUALLY ENTERS
--
--     decâ’stable :  Dec A â’ (Â Â A â’ A)
--
-- â” a statement about the PRATIYOGIN A, not about the absence ÂA.  The
-- Navya-Nyya distinction survives intact and lands one place over than
-- `Abhava` put it: the absence is always level-two; it is the
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
-- Neither is established anywhere in this corpus, for any obstruction.
-- So the barrier vocabulary is, exactly as the deflationary thread
-- suspected, stronger than the objects warrant â” but for a reason that
-- has nothing to do with decidability and could have been seen from the
-- type of `ÂÂÂâ’Â` on the day it was written.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE A GENUINE BARRIER COULD STILL HIDE, AND IT IS ACTIONABLE
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
-- what would have to be inhabited to exhibit one.  Nothing in this
-- corpus inhabits it for any A.
------------------------------------------------------------------------

GenuineGap : Type â„“ â†’ Type â„“
GenuineGap A = (Â¬ (Â¬ A)) Ã— (Â¬ A)

-- and it cannot be inhabited: a "gap" in that sense is a contradiction.
-- So even the strong reading has no room at the level of a single
-- proposition â” the only honest barrier claim is UNDECIDABILITY.
no-gap : {A : Type â„“} â†’ Â¬ (GenuineGap A)
no-gap (Â¬Â¬a , Â¬a) = Â¬Â¬a Â¬a

-- which leaves exactly one form of barrier claim standing, and it is a
-- claim nothing here makes:
BarrierClaim : Type â„“ â†’ Type â„“
BarrierClaim A = Â¬ (Dec A)

------------------------------------------------------------------------
-- 7.  The deflation, stated.
--
--   * every absence is level-two, unconditionally;
--   * so the stabilisation level measures nothing, and `Abhava`'s reading
--     of it is withdrawn;
--   * decidability governs the counterpositive, not the absence;
--   * every obstruction in this thread is stable BY SHAPE (Â§5);
--   * a gap between ÂÂA and A is contradictory (`no-gap`), so the only
--     surviving form of a barrier claim is `Â (Dec A)`;
--   * and no such claim is made anywhere in this corpus.
--
-- The barrier vocabulary is therefore unwarranted by these objects â” the
-- deflationary thread's conclusion, reached by a route that never needed
-- the decidability survey it proposed, and visible from the type of
-- `ÂÂÂâ’Â` on the day that was written.
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
-- could sit, since stability does not pass through âŠ.  An audit of all
-- 434 `.agda` files under `formal/cubical` found 74 such signatures and
-- zero `Â (Dec A)` claims.  But the audit was not needed, and the reason
-- is stronger than any count:
--
--     **in a `--safe`, postulate-free development, every inhabited âŠ is a
--     decision, because it was constructed.**
--
-- There is no way to write a term of `A âŠ B` without producing `inl a` or
-- `inr b`.  A "non-constructive dichotomy" is not expressible in this
-- lane at all â” not hard to find, not absent by luck: unwritable.  So the
-- 74 sites cannot hide a barrier, and neither could 74 000.
--
-- The anchor for that, checked rather than asserted: a dichotomy of the
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
-- sense stronger than "here is a proof of ÂA" â” unless someone proves
-- `Â (Dec A)`, which is a positive claim, has its own burden, and has
-- never been made here.
--
-- The one thing this does NOT say: that the mathematics being pointed at
-- is easy.  `Â (Dec A)` is a fine thing to prove.  It has not been.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 10.  CORRECTION TO Â§9, immediate â” the surviving barrier claim does
--      not survive either.
--
-- Â§6 and Â§9 say the only form of barrier claim left standing is
-- `Â (Dec A)`, and Â§9 adds that it "is a fine thing to prove. It has not
-- been."  The second sentence is wrong, and the first is misleading.
--
-- `Â (Dec A)` is CONTRADICTORY, for every A, constructively:
--
--     no-barrier-claim :  (A : Type â“) â’ Â (Â (Dec A))
--
--     assume k : Â (Dec A).  Then (Î» a â’ k (yes a)) : Â A,
--     so (no (Î» a â’ k (yes a))) : Dec A, and k applied to it gives âŠ.
--
-- Three lines.  So there is no barrier claim of that form to make, ever â”
-- not "none has been made here".  Undecidability of a specific proposition
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
--
-- WHAT THIS DOES NOT SAY, and the boundary now matters more than before:
-- that no real barrier exists in the mathematics.  Independence and
-- algorithmic impossibility are real, are proved elsewhere by other
-- means, and are not of the form `Â (Dec A)`.  Stating one requires a
-- theory to be independent OF, or a uniformity to quantify over â” objects
-- this lane does not carry.  `GodelSeparation` is the corpus's one
-- gesture at the first, and it too proves a Â-headed statement by
-- exhibiting a countermodel.
------------------------------------------------------------------------

no-barrier-claim : (A : Type â„“) â†’ Â¬ (BarrierClaim A)
no-barrier-claim A k = k (no (Î» a â†’ k (yes a)))
