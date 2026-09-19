{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDeflationaryTestIsVacuous
--
-- Closing thread (2), by showing that its conclusion is a theorem, its
-- stated mechanism was never needed, and the inference it was going to
-- license does not follow.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TEST, AS THIS THREAD HAS BEEN CARRYING IT
--
--   "if the absence tower is two-tall exactly for decidable
--    counterpositives, and every absence in this corpus looks
--    decidable, then nothing here lives at level three, every
--    'obstruction' is exact, and the barrier language is stronger than
--    the objects warrant."
--
-- Three clauses.  They come apart completely.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  every statement this corpus PROVES is stable, because `A â’
--       Stable A`.  A witness is a witness; no double negation can add
--       anything to it.  Instantiated at the corpus's own floor lemma,
--       whose Î is inhabited by a CONSTRUCTED constant decoder rather
--       than by a search.
--
--   Â§2  every negation is stable, with no hypothesis.
--
--   Â§3  so for any theorem of this corpus and for the negation of
--       anything whatever, the tower is two tall.  The test's middle
--       clause â” "nothing here lives at level three" â” therefore holds
--       for everything this corpus ASSERTS, with no survey and no
--       decidability.  It is not shown for the third class, the
--       HYPOTHESES, which are neither proved nor negated here; module
--       E covers those only to the extent that none can ever be
--       exhibited as unstable, which is not the same as showing them
--       stable.  Stating the clause without that qualification would
--       be claiming a collapse aneknta does not license.
--
--   Â§4  and the last clause does not follow.  Two-tallness says
--       NOTHING about the strength of an obstruction, and Â§4 proves it
--       in the only way that settles it: `Stable âŠ` and `Stable Unit`
--       both hold.  A property that every type has separates no types.
--       So "the tower is short, therefore the barrier language
--       overstates its objects" is a non-sequitur, and this thread was
--       one step from drawing it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT REPLACES IT
--
-- The test had content only where a statement is NOT proved â” at the
-- hypotheses.  And module E closes that too: `Â Â Stable A` holds for
-- every A, so no hypothesis can be exhibited as unstable either.  The
-- test as posed therefore admits no failing instance anywhere, which
-- is what "vacuous" means here and all it means.
--
-- ààà¯à¾àà â” in the respect of what it asks, the test is vacuous;
-- ààà¯à¾àà â” in the respect of what prompted it, it was not, and the
--          three modules it produced are the evidence: the tower is
--          three tall unconditionally, the price of an exclusion step
--          is stability rather than decidability, and the floor is a
--          search while the ceiling is not.
--
-- Calling the question empty and the work it caused empty would be two
-- different claims, and only the first is made.  A à¨à¯ that dismissed
-- the second along with the first would be a à¦àà°àà¨à¯.
--
-- The live remainder is positive and is not about absence at all:
-- which hypotheses in this corpus are DERIVABLE â” isSet, Discrete,
-- Answerable, Dec â” at the sites that assume them.  That question has
-- failing instances, which is what makes it a question.
--
------------------------------------------------------------------------

module TheDeflationaryTestIsVacuous where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_ ; Stable)

open import TheUnstableGroundCannotBeExhibited
  using (affirmationâ†’stable ; absenceâ†’stable ; Â¬Â¬Stable)
open import TheFloorIsAnswerability
  using (Answerable ; factorLaw-answerable)
open import FiniteInformation using (FactorsThrough)
open import WitnessNumberIsTwo using (factorLaw)

private
  variable
    â„“ â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  A theorem is stable because it is a theorem
------------------------------------------------------------------------

provedIsStable : {A : Type â„“} â†’ A â†’ Stable A
provedIsStable = affirmationâ†’stable

-- the corpus's floor, at its central law.  The witness there is a
-- CONSTANT decoder, written down, not found: `factorLaw-answerable q t
-- x = (Î» _ â’ t x) , refl`.  So the Î that stopped the argument in
-- `WhereTheTowerCanStillBeThree` Â§5 is, at this site, already
-- inhabited, and stability is immediate.
floorIsStableHere :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T)
  â†’ Stable (Answerable (factorLaw q t))
floorIsStableHere q t = provedIsStable (factorLaw-answerable q t)

------------------------------------------------------------------------
-- 2.  A negation is stable because it is a negation
------------------------------------------------------------------------

negationIsStable : {A : Type â„“} â†’ Stable (Â¬ A)
negationIsStable nnna a = nnna (Î» na â†’ na a)

obstructionIsStable :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) â†’ Stable (Â¬ FactorsThrough q t)
obstructionIsStable q t = negationIsStable

------------------------------------------------------------------------
-- 3.  Hence the middle clause of the test, unconditionally
--
-- Given a proof, or given a negation, the tower over it is two tall.
-- Neither branch mentions decidability, and neither branch needed the
-- corpus to be examined.
------------------------------------------------------------------------

towerIsTwoTallForAnyTheorem : {A : Type â„“} â†’ A â†’ Stable A
towerIsTwoTallForAnyTheorem = provedIsStable

towerIsTwoTallForAnyAbsence : {A : Type â„“} â†’ Stable (Â¬ A)
towerIsTwoTallForAnyAbsence = negationIsStable

------------------------------------------------------------------------
-- 4.  And the last clause does not follow: stability discriminates
--     nothing
--
-- The emptiest type and the fullest type are both stable.  A property
-- shared by âŠ and Unit cannot be evidence that an obstruction is weak,
-- or strong, or anything else about the obstruction.
------------------------------------------------------------------------

stableâŠ¥ : Stable âŠ¥
stableâŠ¥ nn = âŠ¥.rec (nn (Î» ()))

stableUnit : Stable Unit
stableUnit _ = tt

-- stated as the non-sequitur it blocks: from stability of a statement,
-- nothing about the statement's inhabitation follows in either
-- direction, since both cases are realised above.
stabilityDoesNotDecide : Stable âŠ¥ Ã— Stable Unit
stabilityDoesNotDecide = stableâŠ¥ , stableUnit

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `Â`, `â’`, `—`, `Î `, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `âŠ`,
-- `no-barrier-claim : Â (Â (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not â” and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------
