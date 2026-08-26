{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MigrationNeedsALawAndTheLawIsNotFree
--
-- `ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem` closed
-- with the sharpest thing it could see about Δ 28 §39–47:
--
--   "MIGRATION is a bare function with no law — nothing says it
--    preserves the boundary semantics, and a compiler would need
--    exactly that, so the composite's migration is only as meaningful
--    as its components'."
--
-- The law is stated here, and two things are checked about it: it
-- COMPOSES, so the certificate keeps its meaning under sequencing; and
-- it is NOT FREE, so requiring it is a real constraint on a rewrite
-- rather than a formality.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Lawful obs mig    the migration is observation-preserving:
--                     `obs e (mig m) ≡ obs d m`
--   composeLawful     lawful migrations compose — paths compose, so
--                     this half is as free as the three components that
--                     were already free
--   lawTransportsEveryInvariant
--                     ANY function of the observation is preserved
--                     too, by one `cong` — so a lawful migration moves
--                     no derived quantity, which is what "state
--                     migration" has to mean for provenance and caches
--                     to survive it
--   unlawfulMigrationExists
--                     `not` on `Bool`, with the identity observation,
--                     is a migration that is NOT lawful
--
-- **The last one is the point.**  Everything else in the certificate
-- composed for free, and it would be easy to read the migration
-- component the same way.  It is not: a bare function is exactly a
-- migration with no guarantee, and `unlawfulMigrationExists` is a
-- one-line witness that the guarantee has content.  So §39–47's four
-- components are better counted as THREE FREE, ONE EARNED (complexity,
-- by `⊏-trans`), AND ONE UNDER-SPECIFIED (migration, which needs this
-- law added before it means anything).
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  "A map between state spaces commutes with the
-- observation" is the definition of a simulation/refinement and is as
-- old as the notion; `not` failing it is immediate.
--
-- WHAT IS NOT CLAIMED.  This does NOT amend the earlier `Certified`:
-- that module's four-component Σ is unchanged and its
-- `composeCertified` still composes a bare function.  What is offered
-- is the law and its composition, so a later definition can require it;
-- rewriting the earlier record is that module's own next step and is
-- not done here.  `obs` is an arbitrary family and no relation between
-- `obs` and the earlier `sem` is asserted — a compiler would want
-- `sem` to be recoverable from `obs`, and nothing here says it is.
-- Nothing is said about migrations that preserve the observation only
-- on REACHABLE states, which is the version a real compiler would use.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module MigrationNeedsALawAndTheLawIsNotFree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  The law
------------------------------------------------------------------------

module _ {Sys B : Type} (M : Sys → Type) (obs : (d : Sys) → M d → B) where

  Lawful : (d e : Sys) → (M d → M e) → Type
  Lawful d e mig = (m : M d) → obs e (mig m) ≡ obs d m

  composeLawful :
    (d e f : Sys) (mig₁ : M d → M e) (mig₂ : M e → M f)
    → Lawful d e mig₁ → Lawful e f mig₂
    → Lawful d f (λ m → mig₂ (mig₁ m))
  composeLawful d e f mig₁ mig₂ l₁ l₂ m = l₂ (mig₁ m) ∙ l₁ m

  lawTransportsEveryInvariant :
    {C : Type} (g : B → C)
    (d e : Sys) (mig : M d → M e) → Lawful d e mig
    → (m : M d) → g (obs e (mig m)) ≡ g (obs d m)
  lawTransportsEveryInvariant g d e mig l m = cong g (l m)

------------------------------------------------------------------------
-- 2.  And it is not free
--
-- Two systems whose state space is `Bool`, observed by the identity.
-- `not` migrates states and changes what is observed, so it is a
-- migration in the earlier module's sense and not a lawful one.
------------------------------------------------------------------------

BoolSys : Type
BoolSys = Bool

BoolState : BoolSys → Type
BoolState _ = Bool

boolObs : (d : BoolSys) → BoolState d → Bool
boolObs _ b = b

unlawfulMigrationExists :
  ¬ (Lawful BoolState boolObs true false not)
unlawfulMigrationExists l = false≢true (l true)

lawfulMigrationAlsoExists :
  Lawful BoolState boolObs true false (λ b → b)
lawfulMigrationAlsoExists m = refl
