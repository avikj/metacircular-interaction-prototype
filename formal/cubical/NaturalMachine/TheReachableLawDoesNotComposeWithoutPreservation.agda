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
-- NaturalMachine.TheReachableLawDoesNotComposeWithoutPreservation
--
-- Both modules on the certificate line closed with the same unstated
-- item:
--
--   "Nothing is said about migrations that preserve the observation
--    only on REACHABLE states, which is the version a real compiler
--    would use."
--
-- It is stated here, and it turns out NOT to be a weakening of the
-- global law with the same behaviour.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Reach step i        reachability from an initial state under a
--                       step relation — an inductive family, no Fin,
--                       no index matching
--   reachIsClosedUnderSteps
--                       so it is an invariant, which is what makes it
--                       a legitimate `R` below
--   LawfulOn R d e mig  the observation is preserved on R only
--   Preserves R d e mig the migration keeps R
--   globalLawIsLawfulOnAnything
--                       the global law implies the reachable law for
--                       EVERY R — so this really is a weakening
--   composeLawfulOn     reachable laws compose GIVEN preservation by
--                       the first migration
--   totalInvariantGivesBackTheGlobalLaw
--                       if R holds everywhere the two laws coincide
--   preservationIsNecessary
--                       three systems and two migrations, each lawful
--                       on R, whose composite is NOT lawful on R
--
-- **THE POINT IS THE LOSS OF A FREE COMPOSITION.**  On the certificate
-- line the global law was one of the components that composed for
-- nothing: `composeLawful` is two paths and a `∙`.  The reachable law
-- does not: `composeLawfulOn` needs `Preserves`, and
-- `preservationIsNecessary` shows the hypothesis cannot be dropped.
-- The witness is small and concrete — the first migration sends a
-- reachable state to an unreachable one, where the second migration's
-- law says nothing, and the composite observes the wrong thing.
--
-- So the version "a real compiler would use" is strictly more
-- expensive than the version already checked: a certificate carrying
-- the reachable law must carry a reachability-preservation component
-- as well, or it does not survive sequencing.  That is a SIXTH
-- component, and unlike the fifth it is needed for composition rather
-- than for meaning.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Refinement relative to an invariant, and the failure of
-- naive composition when the invariant is not preserved, are standard
-- in refinement calculi and in Floyd–Hoare style reasoning (the
-- invariant must be re-established at the interface); nothing here
-- improves on that.  The content is only that this corpus's own
-- certificate loses a free component when it moves to the reachable
-- law.
--
-- WHAT IS NOT CLAIMED.  `R` is an arbitrary family; `Reach` is offered
-- as the intended instance and is NOT plugged into the certificate
-- here.  No step relation is attached to the systems of the earlier
-- modules, so this does not amend `LCertified` — extending the record
-- with preservation is the next cycle's named step, not this one's.
-- Nothing says the reachable law is DECIDABLE, and nothing relates
-- `obs` to `sem`.  The counterexample uses a two-element state space
-- and a constant observation in the middle system; no claim is made
-- that failures require such degeneracy.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheReachableLawDoesNotComposeWithoutPreservation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.MigrationNeedsALawAndTheLawIsNotFree using (Lawful)

------------------------------------------------------------------------
-- 1.  Reachability is an invariant
------------------------------------------------------------------------

data Reach {S : Type} (step : S → S → Type) (i : S) : S → Type where
  here : Reach step i i
  next : {x y : S} → Reach step i x → step x y → Reach step i y

reachIsClosedUnderSteps :
  {S : Type} (step : S → S → Type) (i x y : S)
  → Reach step i x → step x y → Reach step i y
reachIsClosedUnderSteps step i x y r s = next r s

------------------------------------------------------------------------
-- 2.  The law relative to an invariant
------------------------------------------------------------------------

module _ {Sys O : Type}
         (M   : Sys → Type)
         (obs : (d : Sys) → M d → O)
         (R   : (d : Sys) → M d → Type)
  where

  LawfulOn : (d e : Sys) → (M d → M e) → Type
  LawfulOn d e mg = (m : M d) → R d m → obs e (mg m) ≡ obs d m

  Preserves : (d e : Sys) → (M d → M e) → Type
  Preserves d e mg = (m : M d) → R d m → R e (mg m)

  globalLawIsLawfulOnAnything :
    (d e : Sys) (mg : M d → M e) → Lawful M obs d e mg → LawfulOn d e mg
  globalLawIsLawfulOnAnything d e mg l m _ = l m

  composeLawfulOn :
    (d e f : Sys) (mg₁ : M d → M e) (mg₂ : M e → M f)
    → Preserves d e mg₁
    → LawfulOn d e mg₁ → LawfulOn e f mg₂
    → LawfulOn d f (λ m → mg₂ (mg₁ m))
  composeLawfulOn d e f mg₁ mg₂ pres l₁ l₂ m r =
    l₂ (mg₁ m) (pres m r) ∙ l₁ m r

  totalInvariantGivesBackTheGlobalLaw :
    ((d : Sys) (m : M d) → R d m)
    → (d e : Sys) (mg : M d → M e) → LawfulOn d e mg → Lawful M obs d e mg
  totalInvariantGivesBackTheGlobalLaw tot d e mg l m = l m (tot d m)

------------------------------------------------------------------------
-- 3.  Preservation cannot be dropped
--
-- Three systems, indexed 0, 1, 2.  Every state space is `Bool`; the
-- invariant is "the state is `true`" everywhere; the middle system
-- observes a constant.  `mg₁` sends the reachable state to the
-- unreachable one, where `mg₂`'s law says nothing.
------------------------------------------------------------------------

State : ℕ → Type
State _ = Bool

look : (d : ℕ) → State d → Bool
look zero          m = m
look (suc zero)    m = true
look (suc (suc _)) m = m

Inv : (d : ℕ) → State d → Type
Inv _ m = m ≡ true

mg₁ : State 0 → State 1
mg₁ _ = false

mg₂ : State 1 → State 2
mg₂ m = m

firstIsLawfulOnTheInvariant : LawfulOn State look Inv 0 1 mg₁
firstIsLawfulOnTheInvariant m r = sym r

secondIsLawfulOnTheInvariant : LawfulOn State look Inv 1 2 mg₂
secondIsLawfulOnTheInvariant m r = r

theCompositeIsNot : ¬ (LawfulOn State look Inv 0 2 (λ m → mg₂ (mg₁ m)))
theCompositeIsNot l = false≢true (l true refl)

preservationIsNecessary : ¬ (Preserves State look Inv 0 1 mg₁)
preservationIsNecessary p = false≢true (p true refl)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The next step named above — "extending the record with
-- preservation" — is taken in
-- `NaturalMachine.TheSixthComponentIsFreeToCarryAndIsWhatMakesTheFifthCompose`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
-- `RCertified`, `composePreserves`, `composeRCertified`,
-- `noSelfRCertified`, and the independence witness.
--
-- Two things there were not visible from here.  `Preserves` COMPOSES
-- FOR NOTHING, so the sixth component is free to carry — the price is
-- entirely in having to establish it per rewrite, not in sequencing.
-- And it is INDEPENDENT of the other five: the witness is a full
-- five-component `LCertified` whose observation type is `Unit`, so its
-- migration is globally lawful — the strongest form of the fifth
-- component — and it still leaves the invariant.
------------------------------------------------------------------------
