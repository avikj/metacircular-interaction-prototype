{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Checked before naming: `.claude/hooks/priority-ledger.txt` (CURRENT
-- header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- permutation work â” Nryaa Paita, *Gaitakaumud* (1356) â” is for
-- the ENUMERATION line, which is another identity's and is NOT what
-- this module does: nothing here counts arrangements or generates them
-- in order.  Claiming that source for a containment of two inductively
-- defined relations would assert a provenance nobody checked, so it is
-- not claimed.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE PHRASE UNDER AUDIT
--
-- `PairwiseCommutationGivesEveryOrder` defines `_~_` by four
-- constructors â” `~nil`, `~cons`, `~swap`, `~trans` â” and says in its
-- NOT-CLAIMED section:
--
--   "`_~_` is a DEFINITION, not a characterisation: nothing here proves
--    it coincides with 'same multiset' or with any other notion of
--    permutation, so 'every order' means 'every order reachable by
--    adjacent transpositions', **which is all of them for the usual
--    reasons and is not proved to be**."
--
-- The flag is honest and the phrase inside it is an appeal.  **"The
-- usual reasons" is a proof, and it fits in a page**; Â§Â§1â“3 are that
-- page, and Â§4 lands it on the corpus's own relation.
--
-- WHAT IS PROVED, over an ARBITRARY element type â” no decidable
-- equality, no h-level, no finiteness:
--
--   Insert x xs ys      `ys` is `xs` with one `x` put in at some place
--   Perm xs ys          the standard inductive permutation relation:
--                       permute the tail, then insert the head anywhere
--   _â‰ˆ_                 the adjacent-transposition closure, the same
--                       four constructors as the corpus's `_~_`
--   â‰ˆ-refl              reflexivity, by induction on the list â” NOT a
--                       constructor, and needed before anything else
--   insertIsAnAdjacentChain
--                       `Insert x xs ys â’ (x âˆ xs) â‰ˆ ys`.  **This is
--                       the whole content**: sliding one element past
--                       `k` others is `k` adjacent swaps, and the
--                       induction is exactly that slide
--   permIsAnAdjacentChain
--                       `Perm xs ys â’ xs â‰ˆ ys`
--   permGivesTheCorpusRelation
--                       and at `A := Step C` the same proof lands in
--                       `PairwiseCommutationGivesEveryOrder._~_`, via a
--                       constructor-for-constructor translation
--
-- **WHY THE INSERTION LEMMA IS WHERE THE WORK IS.**  Reflexivity,
-- symmetry and transitivity of `â‰ˆ` are cheap or given.  What "usual
-- reasons" hides is that a permutation is built by INSERTION at an
-- arbitrary depth while `â‰ˆ` only ever exchanges NEIGHBOURS, and the
-- bridge between the two is the one induction that has to walk down the
-- list.  Everything else is plumbing.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)

open import OrderIndependenceTransfersAlongAnyNumberOfSteps
  using (Step)
open import PairwiseCommutationGivesEveryOrder
  using (_~_ ; ~nil ; ~cons ; ~swap ; ~trans)

------------------------------------------------------------------------
-- 1.  Insertion, permutation, and adjacency â” over any element type
------------------------------------------------------------------------

module _ {A : Type} where

  data Insert (x : A) : List A â†’ List A â†’ Type where
    here  : {xs : List A} â†’ Insert x xs (x âˆ· xs)
    there : {y : A} {xs ys : List A}
            â†’ Insert x xs ys â†’ Insert x (y âˆ· xs) (y âˆ· ys)

  data Perm : List A â†’ List A â†’ Type where
    pnil  : Perm [] []
    pcons : {x : A} {xs ys zs : List A}
            â†’ Perm xs ys â†’ Insert x ys zs â†’ Perm (x âˆ· xs) zs

  -- the same four constructors the corpus's `_~_` has
  data _â‰ˆ_ : List A â†’ List A â†’ Type where
    â‰ˆnil   : [] â‰ˆ []
    â‰ˆcons  : {p : A} {xs ys : List A} â†’ xs â‰ˆ ys â†’ (p âˆ· xs) â‰ˆ (p âˆ· ys)
    â‰ˆswap  : {p q : A} {xs : List A} â†’ (p âˆ· q âˆ· xs) â‰ˆ (q âˆ· p âˆ· xs)
    â‰ˆtrans : {xs ys zs : List A} â†’ xs â‰ˆ ys â†’ ys â‰ˆ zs â†’ xs â‰ˆ zs

  ----------------------------------------------------------------------
  -- 2.  Reflexivity is a theorem, not a constructor
  ----------------------------------------------------------------------

  â‰ˆ-refl : (xs : List A) â†’ xs â‰ˆ xs
  â‰ˆ-refl []       = â‰ˆnil
  â‰ˆ-refl (x âˆ· xs) = â‰ˆcons (â‰ˆ-refl xs)

  ----------------------------------------------------------------------
  -- 3.  Insertion at depth k is k adjacent swaps
  --
  -- `there` walks one step further down; the chain gains one `â‰ˆswap`
  -- to move `x` past the element it has just walked over, then `â‰ˆcons`
  -- to continue underneath it.  That is the slide, and it is the only
  -- induction in this module.
  ----------------------------------------------------------------------

  insertIsAnAdjacentChain :
    {x : A} {xs ys : List A} â†’ Insert x xs ys â†’ (x âˆ· xs) â‰ˆ ys
  insertIsAnAdjacentChain {x = x} (here {xs = xs}) = â‰ˆ-refl (x âˆ· xs)
  insertIsAnAdjacentChain (there ins) =
    â‰ˆtrans â‰ˆswap (â‰ˆcons (insertIsAnAdjacentChain ins))

  permIsAnAdjacentChain : {xs ys : List A} â†’ Perm xs ys â†’ xs â‰ˆ ys
  permIsAnAdjacentChain pnil = â‰ˆnil
  permIsAnAdjacentChain (pcons p ins) =
    â‰ˆtrans (â‰ˆcons (permIsAnAdjacentChain p)) (insertIsAnAdjacentChain ins)

------------------------------------------------------------------------
-- 4.  â¦and it lands on the corpus's own relation
--
-- `_~_` is declared inside `module _ {S T : Type} (C : S â’ T)` over
-- `List (Step C)`, with exactly the four constructors of `_â‰ˆ_`.  The
-- translation is therefore constructor-for-constructor, and the point
-- of writing it out is that it is: no side condition appears, so the
-- general theorem above IS a theorem about that module's relation.
------------------------------------------------------------------------

module _ {S T : Type} (C : S â†’ T) where

  toCorpusRelation :
    {xs ys : List (Step C)} â†’ _â‰ˆ_ {A = Step C} xs ys â†’ _~_ C xs ys
  toCorpusRelation â‰ˆnil          = ~nil
  toCorpusRelation (â‰ˆcons r)     = ~cons (toCorpusRelation r)
  toCorpusRelation â‰ˆswap         = ~swap
  toCorpusRelation (â‰ˆtrans r s)  = ~trans (toCorpusRelation r) (toCorpusRelation s)

  permGivesTheCorpusRelation :
    {xs ys : List (Step C)} â†’ Perm {A = Step C} xs ys â†’ _~_ C xs ys
  permGivesTheCorpusRelation p = toCorpusRelation (permIsAnAdjacentChain p)
