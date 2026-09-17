{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MigrationNeedsALawAndTheLawIsNotFree
--
-- `ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem` closed
-- with the sharpest thing it could see about Œî 28 ¬ß39‚ì47:
--
--   "MIGRATION is a bare function with no law ‚î nothing says it
--    preserves the boundary semantics, and a compiler would need
--    exactly that, so the composite's migration is only as meaningful
--    as its components'."
--
-- The law is stated here, and two things are checked about it: it
-- COMPOSES, so the certificate keeps its meaning under sequencing; and
-- it is NOT FREE, so requiring it is a real constraint on a rewrite
-- rather than a formality.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   Lawful obs mig    the migration is observation-preserving:
--                     `obs e (mig m) ‚â° obs d m`
--   composeLawful     lawful migrations compose ‚î paths compose, so
--                     this half is as free as the three components that
--                     were already free
--   lawTransportsEveryInvariant
--                     ANY function of the observation is preserved
--                     too, by one `cong` ‚î so a lawful migration moves
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
-- one-line witness that the guarantee has content.  So ¬ß39‚ì47's four
-- components are better counted as THREE FREE, ONE EARNED (complexity,
-- by `‚ä-trans`), AND ONE UNDER-SPECIFIED (migration, which needs this
-- law added before it means anything).
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  "A map between state spaces commutes with the
-- observation" is the definition of a simulation/refinement and is as
-- old as the notion; `not` failing it is immediate.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module MigrationNeedsALawAndTheLawIsNotFree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false‚â¢true)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- 1.  The law
------------------------------------------------------------------------

module _ {Sys B : Type} (M : Sys ‚Üí Type) (obs : (d : Sys) ‚Üí M d ‚Üí B) where

  Lawful : (d e : Sys) ‚Üí (M d ‚Üí M e) ‚Üí Type
  Lawful d e mig = (m : M d) ‚Üí obs e (mig m) ‚â° obs d m

  composeLawful :
    (d e f : Sys) (mig‚ÇÅ : M d ‚Üí M e) (mig‚ÇÇ : M e ‚Üí M f)
    ‚Üí Lawful d e mig‚ÇÅ ‚Üí Lawful e f mig‚ÇÇ
    ‚Üí Lawful d f (Œª m ‚Üí mig‚ÇÇ (mig‚ÇÅ m))
  composeLawful d e f mig‚ÇÅ mig‚ÇÇ l‚ÇÅ l‚ÇÇ m = l‚ÇÇ (mig‚ÇÅ m) ‚àô l‚ÇÅ m

  lawTransportsEveryInvariant :
    {C : Type} (g : B ‚Üí C)
    (d e : Sys) (mig : M d ‚Üí M e) ‚Üí Lawful d e mig
    ‚Üí (m : M d) ‚Üí g (obs e (mig m)) ‚â° g (obs d m)
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

BoolState : BoolSys ‚Üí Type
BoolState _ = Bool

boolObs : (d : BoolSys) ‚Üí BoolState d ‚Üí Bool
boolObs _ b = b

unlawfulMigrationExists :
  ¬¨ (Lawful BoolState boolObs true false not)
unlawfulMigrationExists l = false‚â¢true (l true)

lawfulMigrationAlsoExists :
  Lawful BoolState boolObs true false (Œª b ‚Üí b)
lawfulMigrationAlsoExists m = refl
