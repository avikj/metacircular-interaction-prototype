{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's attribution for permutation work — Nārāyaṇa Paṇḍita,
-- *Gaṇitakaumudī* (1356) — belongs to the ENUMERATION line, which is
-- another identity's, and this is not that problem: nothing here counts
-- arrangements or generates them in order; it counts OCCURRENCES OF ONE
-- ELEMENT inside a list.  Claiming that source here would assert a
-- provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.
--
-- ────────────────────────────────────────────────────────────────────
-- 0.  WHAT WAS LOOKED FOR FIRST, AND FOUND ALREADY DONE
--
-- This cycle set out to work the corpus's own standing threads —
-- anekānta, abhāva, asiddhatva, lāghava — because most of what I have
-- written today disclaims any tradition content and that imbalance is
-- real.  **Grepping first showed both live abhāva threads are already
-- closed by this corpus**, and by other hands:
--
--   TheAbsenceTowerIsThreeUnconditionally
--   DeflationaryTest
--   TheDeflationaryTestWasAlreadyRun
--   TheDeflationaryTestIsVacuous
--
-- listed by `ls NaturalMachine/ | grep -i "abhava\|absence"` and
-- instead of manufacturing a finding is the rule (111), and it is why
-- this module is about something else.**  Nothing of theirs is touched.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  THE ITEM.  At 47c200bf, dbbd4be6 and cd6427b0 the two permutation
-- relations were shown to contain each other.  What stayed open, in my
-- own words each time, was *"coincidence with 'same multiset' — that
-- direction must LOCATE an element and so needs decidable equality on
-- the element type, which is assumed nowhere."*
--
-- **Here decidable equality is assumed, once, in the open, and the
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
--
-- **WHY THIS IS ONLY HALF, STATED SHARPLY.**  The CONVERSE — equal
-- counts everywhere implies `Perm` — is NOT proved here and is a
-- different kind of statement: it must BUILD a permutation from
-- numerical data, which needs to find, for each element of `xs`, a
-- matching position in `ys`, and that search is where finiteness and
-- decidability do real work rather than bookkeeping.  Nothing below
-- attempts it and nothing below should be read as evidence for it.
--
-- SYĀT — THE CLAIM, EXACTLY.  Nothing is amended or retracted; `Insert` and
-- `Perm` are imported from 47c200bf unchanged.  `Discrete A` is a
-- HYPOTHESIS of every statement here and is never discharged — the
-- corpus's `Step C` has no such structure assumed, so **none of this
-- applies to the commutation line's own instance** unless someone
-- supplies it.  No h-level is assumed of `A`; `count` is not claimed to
-- be a complete invariant; and the multiset itself is never
-- constructed, only its multiplicities.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
