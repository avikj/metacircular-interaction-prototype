{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDeflationaryTestIsVacuous
--
-- Closing thread (2), by showing that its conclusion is a theorem, its
-- stated mechanism was never needed, and the inference it was going to
-- license does not follow.
--
-- ────────────────────────────────────────────────────────────────────
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
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  every statement this corpus PROVES is stable, because `A →
--       Stable A`.  A witness is a witness; no double negation can add
--       anything to it.  Instantiated at the corpus's own floor lemma,
--       whose Σ is inhabited by a CONSTRUCTED constant decoder rather
--       than by a search.
--
--   §2  every negation is stable, with no hypothesis.
--
--   §3  so for any theorem of this corpus and for the negation of
--       anything whatever, the tower is two tall.  The test's middle
--       clause — "nothing here lives at level three" — therefore holds
--       for everything this corpus ASSERTS, with no survey and no
--       decidability.  It is not shown for the third class, the
--       HYPOTHESES, which are neither proved nor negated here; module
--       E covers those only to the extent that none can ever be
--       exhibited as unstable, which is not the same as showing them
--       stable.  Stating the clause without that qualification would
--       be claiming a collapse anekānta does not license.
--
--   §4  and the last clause does not follow.  Two-tallness says
--       NOTHING about the strength of an obstruction, and §4 proves it
--       in the only way that settles it: `Stable ⊥` and `Stable Unit`
--       both hold.  A property that every type has separates no types.
--       So "the tower is short, therefore the barrier language
--       overstates its objects" is a non-sequitur, and this thread was
--       one step from drawing it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT REPLACES IT
--
-- The test had content only where a statement is NOT proved — at the
-- hypotheses.  And module E closes that too: `¬ ¬ Stable A` holds for
-- every A, so no hypothesis can be exhibited as unstable either.  The
-- test as posed therefore admits no failing instance anywhere, which
-- is what "vacuous" means here and all it means.
--
-- स्यात् — in the respect of what it asks, the test is vacuous;
-- स्यात् — in the respect of what prompted it, it was not, and the
--          three modules it produced are the evidence: the tower is
--          three tall unconditionally, the price of an exclusion step
--          is stability rather than decidability, and the floor is a
--          search while the ceiling is not.
--
-- Calling the question empty and the work it caused empty would be two
-- different claims, and only the first is made.  A नय that dismissed
-- the second along with the first would be a दुर्नय.
--
-- The live remainder is positive and is not about absence at all:
-- which hypotheses in this corpus are DERIVABLE — isSet, Discrete,
-- Answerable, Dec — at the sites that assume them.  That question has
-- failing instances, which is what makes it a question.
--
-- NOT CLAIMED.  That stability is uninteresting (§1–§2 are used
-- throughout this thread as PREMISES; what §4 denies is only that they
-- discriminate); that the barrier language in this corpus is or is not
-- overstated (§4 says the tower height cannot settle it, and offers no
-- other settlement); that no absence anywhere is unstable — module E
-- says it cannot be EXHIBITED, which is a statement about this type
-- theory.
------------------------------------------------------------------------

module TheDeflationaryTestIsVacuous where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_ ; Stable)

open import TheUnstableGroundCannotBeExhibited
  using (affirmation→stable ; absence→stable ; ¬¬Stable)
open import TheFloorIsAnswerability
  using (Answerable ; factorLaw-answerable)
open import FiniteInformation using (FactorsThrough)
open import WitnessNumberIsTwo using (factorLaw)

private
  variable
    ℓ ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  A theorem is stable because it is a theorem
------------------------------------------------------------------------

provedIsStable : {A : Type ℓ} → A → Stable A
provedIsStable = affirmation→stable

-- the corpus's floor, at its central law.  The witness there is a
-- CONSTANT decoder, written down, not found: `factorLaw-answerable q t
-- x = (λ _ → t x) , refl`.  So the Σ that stopped the argument in
-- `WhereTheTowerCanStillBeThree` §5 is, at this site, already
-- inhabited, and stability is immediate.
floorIsStableHere :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T)
  → Stable (Answerable (factorLaw q t))
floorIsStableHere q t = provedIsStable (factorLaw-answerable q t)

------------------------------------------------------------------------
-- 2.  A negation is stable because it is a negation
------------------------------------------------------------------------

negationIsStable : {A : Type ℓ} → Stable (¬ A)
negationIsStable nnna a = nnna (λ na → na a)

obstructionIsStable :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) → Stable (¬ FactorsThrough q t)
obstructionIsStable q t = negationIsStable

------------------------------------------------------------------------
-- 3.  Hence the middle clause of the test, unconditionally
--
-- Given a proof, or given a negation, the tower over it is two tall.
-- Neither branch mentions decidability, and neither branch needed the
-- corpus to be examined.
------------------------------------------------------------------------

towerIsTwoTallForAnyTheorem : {A : Type ℓ} → A → Stable A
towerIsTwoTallForAnyTheorem = provedIsStable

towerIsTwoTallForAnyAbsence : {A : Type ℓ} → Stable (¬ A)
towerIsTwoTallForAnyAbsence = negationIsStable

------------------------------------------------------------------------
-- 4.  And the last clause does not follow: stability discriminates
--     nothing
--
-- The emptiest type and the fullest type are both stable.  A property
-- shared by ⊥ and Unit cannot be evidence that an obstruction is weak,
-- or strong, or anything else about the obstruction.
------------------------------------------------------------------------

stable⊥ : Stable ⊥
stable⊥ nn = ⊥.rec (nn (λ ()))

stableUnit : Stable Unit
stableUnit _ = tt

-- stated as the non-sequitur it blocks: from stability of a statement,
-- nothing about the statement's inhabitation follows in either
-- direction, since both cases are realised above.
stabilityDoesNotDecide : Stable ⊥ × Stable Unit
stabilityDoesNotDecide = stable⊥ , stableUnit

------------------------------------------------------------------------
-- PRIOR ART, found late and recorded here rather than by deletion.
--
-- `DeflationaryTest` was in the corpus and in
-- `RootsThreadLatch` throughout the cycles that produced this module,
-- and was not read.  It already contains the closure lemmas for
-- `¬`, `→`, `×`, `Π`, their instantiation at the corpus's obstruction
-- shapes, the observation that stability does not pass through `⊎`,
-- `no-barrier-claim : ¬ (¬ (Dec A))`, and the deflation that the
-- stabilisation level measures nothing.
--
-- `TheDeflationaryTestWasAlreadyRun` carries the ledger,
-- line by line, of what here is a rediscovery and what is not — and
-- proves the overlap by `refl`, the closure lemmas on both sides being
-- the same terms.  Read that ledger before citing anything below as
-- new.
------------------------------------------------------------------------
