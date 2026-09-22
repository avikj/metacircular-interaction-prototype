{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's attribution for permutation work — Nārāyaṇa Paṇḍita,
-- *Gaitakaumud* (1356) — belongs to the ENUMERATION line,
-- and this is not that problem: nothing here counts
-- arrangements or generates them in order; it counts OCCURRENCES OF ONE
-- ELEMENT inside a list.  Claiming that source here would assert a
-- provenance nobody checked.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  **Here decidable equality is assumed, once, in the open, and the
-- forward half is proved.**  What `Discrete A` buys is exactly one
-- thing: a function `bump` that adds one or nothing.  Everything else
-- is that function commuting with itself.
--
-- WHAT IS PROVED
--
--   bump / count   `count a` is defined THROUGH `bump a`, so
--                  `count a (x ∷ xs) ≡ bump a x (count a xs)` holds by
--                  definition and never needs a lemma
--   bumpComm       two bumps commute — four cases, all `refl`.  **This
--                  is the entire mathematical content**: an occurrence
--                  count cannot tell the order of two increments
--   insertCount    inserting `x` anywhere gives the same counts as
--                  consing it at the front, i.e. `Insert` is invisible
--                  to `count`.  One induction, one `bumpComm`
--   permPreservesCount
--                  `Perm xs ys → (a : A) → count a xs ≡ count a ys`
------------------------------------------------------------------------

module CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (Discrete ; Dec ; yes ; no)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using (Insert ; here ; there ; Perm ; pnil ; pcons)

module _ {A : Type} (dA : Discrete A) where

  ------------------------------------------------------------------
  -- 2.  What decidable equality buys: one increment-or-not
  ------------------------------------------------------------------

  bump : (a x : A) → ℕ → ℕ
  bump a x n with dA a x
  ... | yes _ = suc n
  ... | no  _ = n

  count : (a : A) → List A → ℕ
  count a []       = zero
  count a (x ∷ xs) = bump a x (count a xs)

  -- the entire mathematical content: a count cannot see the order of
  -- two increments
  bumpComm : (a x y : A) (n : ℕ)
           → bump a y (bump a x n) ≡ bump a x (bump a y n)
  bumpComm a x y n with dA a x | dA a y
  ... | yes _ | yes _ = refl
  ... | yes _ | no  _ = refl
  ... | no  _ | yes _ = refl
  ... | no  _ | no  _ = refl

  ------------------------------------------------------------------
  -- 3.  `Insert` is invisible to `count`
  ------------------------------------------------------------------

  insertCount :
    {x : A} {xs ys : List A} → Insert x xs ys
    → (a : A) → count a ys ≡ count a (x ∷ xs)
  insertCount here             a = refl
  insertCount (there {y = y} i) a =
    cong (bump a y) (insertCount i a) ∙ bumpComm a _ y _

  ------------------------------------------------------------------
  -- 4.  …hence every multiplicity survives a permutation
  ------------------------------------------------------------------

  permPreservesCount :
    {xs ys : List A} → Perm xs ys → (a : A) → count a xs ≡ count a ys
  permPreservesCount pnil               a = refl
  permPreservesCount (pcons {x = x} p ins) a =
    cong (bump a x) (permPreservesCount p a) ∙ sym (insertCount ins a)
