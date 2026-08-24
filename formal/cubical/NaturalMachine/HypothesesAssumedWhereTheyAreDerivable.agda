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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.HypothesesAssumedWhereTheyAreDerivable
--
-- The live remainder left by `TheDeflationaryTestIsVacuous`, applied
-- first to the modules this thread itself wrote.
--
-- ────────────────────────────────────────────────────────────────────
-- THE QUESTION THAT REPLACED THE OLD ONE
--
-- Thread (2) asked whether the corpus's absences are stable and turned
-- out to admit no failing instance, which is what made it worth
-- closing.  What replaced it: at each site that ASSUMES a hypothesis —
-- `isSet T`, `Discrete T`, stable paths, `Answerable`, `Dec` — is the
-- hypothesis derivable there?  That question has failing instances,
-- and the first one it finds is in this thread's own work.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FINDING
--
-- `ExclusionRecoversGroundAtAPrice` §6 assumes BOTH
--
--     (isSetT : isSet T) (discT : Discrete T)
--
-- and `Discrete→isSet` is in the library.  The first hypothesis is
-- derivable from the second at that site: it is redundant.  It entered
-- at `984a26b0` (found with `git log -S`, not recalled) and survived
-- every cycle since, because the two hypotheses were written down
-- together and neither was ever checked against the other.
--
-- `WhereTheTowerCanStillBeThree` §3 assumes `isSet T` alongside
-- POINTWISE path-stability along `t`.  That one is NOT redundant, and
-- the reason is exact: Hedberg's argument needs stability at ALL pairs
-- of the type, and stability along the image of a particular `t` does
-- not give it.  Strengthening the hypothesis to `Separated T` makes
-- `isSet T` derivable there too — at the cost of assuming stability
-- where none was needed.
--
-- ────────────────────────────────────────────────────────────────────
-- SO THERE ARE TWO FORMS AND NEITHER DOMINATES
--
-- स्यात् — in the respect of path-stability demanded, the pointwise
--          form asks less: only the pairs `t` actually compares;
-- स्यात् — in the respect of hypothesis COUNT, the separated form asks
--          less: one hypothesis instead of two, since Hedberg supplies
--          the other.
--
-- These are two नयs and the collision between them is not a defect to
-- be resolved by picking one.  Anekānta licenses a collapse only where
-- there is agreement; here the two forms disagree about which
-- hypothesis is cheap, and a module that shipped only one of them
-- would be asserting a standpoint by denying the other.  Both are
-- proved below.
--
-- What is NOT said: that either form is better.  There is no scale
-- here on which to say it, and inventing one to rank them would be the
-- move this thread has been correcting all session.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  the derivability chain, quoted from the library so the claim
--       is checkable at a glance rather than asserted;
--   §2  the §6 statement with `isSet T` DROPPED — same conclusion,
--       one fewer hypothesis;
--   §3  the §3 statement in separated form, `isSet T` dropped, and the
--       pointwise form beside it with `isSet T` retained, so the two
--       nayas stand together;
--   §4  and the one thing that makes this a finding rather than a
--       tidy-up: `Discrete T` is strictly more than `isSet T` needs,
--       and §4 records what is NOT shown — that no weaker hypothesis
--       than separatedness yields isSet.  Hedberg's argument is not
--       proved optimal here and nothing below claims it is.
--
-- NOT CLAIMED.  That the original statements are wrong (they are not —
-- a redundant hypothesis weakens a theorem, it does not falsify it);
-- that this exhausts the redundant hypotheses in this corpus (two
-- sites were read, which is two sites); that pointwise stability
-- cannot yield isSet (it is not shown to, which is not the same).
------------------------------------------------------------------------

module NaturalMachine.HypothesesAssumedWhereTheyAreDerivable where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_ ; Discrete ; Stable ; Separated)
open import Cubical.Relation.Nullary.Properties
  using (Discrete→Separated ; Separated→isSet ; Discrete→isSet)

open import NaturalMachine.FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstant→factorsThrough ; factorsThrough→fiberConstant)
open import NaturalMachine.ExclusionRecoversGroundAtAPrice
  using (CoExclude ; fiberConstant-transfer-stableTarget)
open import NaturalMachine.WhereTheTowerCanStillBeThree
  using (stableFiberConstant ; Stable-↔)

private
  variable
    ℓx ℓy ℓy' ℓt : Level

------------------------------------------------------------------------
-- 1.  The chain, quoted rather than asserted
------------------------------------------------------------------------

discrete→separated : {T : Type ℓt} → Discrete T → Separated T
discrete→separated = Discrete→Separated

separated→set : {T : Type ℓt} → Separated T → isSet T
separated→set = Separated→isSet

discrete→set : {T : Type ℓt} → Discrete T → isSet T
discrete→set = Discrete→isSet

------------------------------------------------------------------------
-- 2.  The transfer theorem with `isSet T` dropped
--
-- Identical conclusion to `ExclusionRecoversGroundAtAPrice`
-- §6/§9, with the redundant hypothesis removed and Hedberg supplying
-- it from the one that remains.
------------------------------------------------------------------------

factorsThrough-transfer-discreteTarget′ :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (discT : Discrete T)
  (q : X → Y) (q' : X → Y') (t : X → T)
  → CoExclude q q' → FactorsThrough q t → FactorsThrough q' t
factorsThrough-transfer-discreteTarget′ discT q q' t ce ft =
  fiberConstant→factorsThrough (Discrete→isSet discT) q' t
    (fiberConstant-transfer-stableTarget q q' t
      (λ x x' → Discrete→Separated discT (t x) (t x'))
      ce (factorsThrough→fiberConstant q t ft))

------------------------------------------------------------------------
-- 3.  The two nayas on stability of factoring, standing together
--
-- 3a asks less of the type and keeps `isSet T`.
-- 3b asks stability everywhere and derives `isSet T`.
-- Neither is an instance of the other.
------------------------------------------------------------------------

stableFactorsThrough-pointwise :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T)
  → ((x x' : X) → Stable (t x ≡ t x'))
  → Stable (FactorsThrough q t)
stableFactorsThrough-pointwise isSetT q t st =
  Stable-↔ (fiberConstant→factorsThrough isSetT q t)
           (factorsThrough→fiberConstant q t)
           (stableFiberConstant q t st)

stableFactorsThrough-separated :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (sepT : Separated T) (q : X → Y) (t : X → T)
  → Stable (FactorsThrough q t)
stableFactorsThrough-separated sepT q t =
  stableFactorsThrough-pointwise (Separated→isSet sepT) q t
    (λ x x' → sepT (t x) (t x'))

------------------------------------------------------------------------
-- 4.  What is not shown
--
-- §1 gives `Discrete → Separated → isSet`.  Nothing here shows the
-- converse of either step, nothing shows that separatedness is the
-- weakest hypothesis yielding `isSet`, and nothing shows that
-- pointwise stability along a single `t` fails to yield it.  Those are
-- three separate open statements and none is claimed in either
-- direction.  What IS established is only this: at two sites in this
-- thread a hypothesis was assumed that the site could derive, and one
-- of the two was genuinely redundant.
------------------------------------------------------------------------

-- recorded as an object so the redundancy cannot quietly return: the
-- old hypothesis is recoverable from the new one, at the same site.
redundantHypothesis :
  {T : Type ℓt} → Discrete T → isSet T
redundantHypothesis = Discrete→isSet
