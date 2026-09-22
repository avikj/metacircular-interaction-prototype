{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's attribution for permutation work â” Nryaa Paita,
-- *Gaitakaumud* (1356) â” belongs to the ENUMERATION line,
-- and this is not that problem: nothing here counts
-- arrangements or generates them in order; it counts OCCURRENCES OF ONE
-- ELEMENT inside a list.  Claiming that source here would assert a
-- provenance nobody checked.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- 1.  **Here decidable equality is assumed, once, in the open, and the
-- forward half is proved.**  What `Discrete A` buys is exactly one
-- thing: a function `bump` that adds one or nothing.  Everything else
-- is that function commuting with itself.
--
-- WHAT IS PROVED
--
--   bump / count   `count a` is defined THROUGH `bump a`, so
--                  `count a (x âˆ xs) â‰¡ bump a x (count a xs)` holds by
--                  definition and never needs a lemma
--   bumpComm       two bumps commute â” four cases, all `refl`.  **This
--                  is the entire mathematical content**: an occurrence
--                  count cannot tell the order of two increments
--   insertCount    inserting `x` anywhere gives the same counts as
--                  consing it at the front, i.e. `Insert` is invisible
--                  to `count`.  One induction, one `bumpComm`
--   permPreservesCount
--                  `Perm xs ys â’ (a : A) â’ count a xs â‰¡ count a ys`
------------------------------------------------------------------------

module CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Relation.Nullary using (Discrete ; Dec ; yes ; no)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using (Insert ; here ; there ; Perm ; pnil ; pcons)

module _ {A : Type} (dA : Discrete A) where

  ------------------------------------------------------------------
  -- 2.  What decidable equality buys: one increment-or-not
  ------------------------------------------------------------------

  bump : (a x : A) â†’ â„• â†’ â„•
  bump a x n with dA a x
  ... | yes _ = suc n
  ... | no  _ = n

  count : (a : A) â†’ List A â†’ â„•
  count a []       = zero
  count a (x âˆ· xs) = bump a x (count a xs)

  -- the entire mathematical content: a count cannot see the order of
  -- two increments
  bumpComm : (a x y : A) (n : â„•)
           â†’ bump a y (bump a x n) â‰¡ bump a x (bump a y n)
  bumpComm a x y n with dA a x | dA a y
  ... | yes _ | yes _ = refl
  ... | yes _ | no  _ = refl
  ... | no  _ | yes _ = refl
  ... | no  _ | no  _ = refl

  ------------------------------------------------------------------
  -- 3.  `Insert` is invisible to `count`
  ------------------------------------------------------------------

  insertCount :
    {x : A} {xs ys : List A} â†’ Insert x xs ys
    â†’ (a : A) â†’ count a ys â‰¡ count a (x âˆ· xs)
  insertCount here             a = refl
  insertCount (there {y = y} i) a =
    cong (bump a y) (insertCount i a) âˆ™ bumpComm a _ y _

  ------------------------------------------------------------------
  -- 4.  â¦hence every multiplicity survives a permutation
  ------------------------------------------------------------------

  permPreservesCount :
    {xs ys : List A} â†’ Perm xs ys â†’ (a : A) â†’ count a xs â‰¡ count a ys
  permPreservesCount pnil               a = refl
  permPreservesCount (pcons {x = x} p ins) a =
    cong (bump a x) (permPreservesCount p a) âˆ™ sym (insertCount ins a)
