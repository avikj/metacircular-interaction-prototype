{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Bija_TheOneGeneratorIsFiniteAndItsInfiniteClosureIsNeverStored
--
-- TERM.  ààà Â bja â” a seed.  The seed is finite; the tree it grows is not,
-- and you do not store the tree.  Common  word.
--
-- THE POINT.  "Iterating the fibre law makes arbitrary form" does NOT mean
-- writing infinitely many theorems.  It means writing ONE generator â” a
-- single â•-indexed term â” and letting it produce the family on demand.  The
-- infinitude lives in the function, not in the filesystem.  `Sphere` is one
-- definition that already IS the whole tower Sâ° â’ SÂ â’ SÂ² â’ â¦ : one fibre
-- operation (suspension, a pushout) iterated.  Ask for a level and it
-- computes; ask for nothing and nothing is stored.  This is the corpus's own
-- discipline (a materialised table of contents decays; compute at run time)
-- applied to form itself.
--
-- Reading: every homotopy type is reachable by
-- iterating such fibre constructions in towers, so a finite generator scheme
-- suffices for arbitrary form â” and univalence makes each step COMPUTE, which
-- is why the seed is runnable and not merely a description.
------------------------------------------------------------------------

module Bija_TheOneGeneratorIsFiniteAndItsInfiniteClosureIsNeverStored where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.HITs.Susp using (Susp)

-- ONE TERM, the whole infinite tower of forms: a single fibre operation
-- (suspension) iterated.  Nothing is stored; asking a level computes it.
Sphere : â„• â†’ Type
Sphere zero    = Bool            -- Sâ° = two points
Sphere (suc n) = Susp (Sphere n) -- Sâ¿âºÂ¹ = the suspension (a pushout) of Sâ¿

-- the family exists for every n at once â” this is ONE term, not âˆ files.
tower : (n : â„•) â†’ Type
tower = Sphere

-- any level you name falls out by computation, from the same one seed.
example-SÂ¹ : Type
example-SÂ¹ = Sphere 1
example-SÂ² : Type
example-SÂ² = Sphere 2
example-Sâ· : Type
example-Sâ· = Sphere 7

-- THE SEED GROWS THE CIRCLE.  Its first nontrivial level is Susp Bool, which
-- IS the circle SÂ â” the object the whole corpus's winding : Î©SÂ â’ â is read
-- on.  So the generator produces the very form the fibre law is measured by,
-- and the content of that form (a â of winding) is itself read by ONE term,
-- not stored â” finite seed, finite reader, infinite family between them.
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; invEquiv)
open import Cubical.HITs.S1 using (SÂ¹)
open import Cubical.HITs.Susp using (SÂ¹â‰ƒSuspBool)

level1-is-the-circle : Sphere 1 â‰ƒ SÂ¹
level1-is-the-circle = invEquiv SÂ¹â‰ƒSuspBool
