{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Checked before naming: `.claude/hooks/priority-ledger.txt` (CURRENT
-- header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- permutation work — Nārāyaṇa Paṇḍita, *Gaṇitakaumudī* (1356) — is for
-- the ENUMERATION line, which is another identity's and is NOT what
-- this module does: nothing here counts arrangements or generates them
-- in order.  Claiming that source for a containment of two inductively
-- defined relations would assert a provenance nobody checked, so it is
-- not claimed.
--
-- ────────────────────────────────────────────────────────────────────
-- THE PHRASE UNDER AUDIT
--
-- `PairwiseCommutationGivesEveryOrder` defines `_~_` by four
-- constructors — `~nil`, `~cons`, `~swap`, `~trans` — and says in its
-- NOT-CLAIMED section:
--
--   "`_~_` is a DEFINITION, not a characterisation: nothing here proves
--    it coincides with 'same multiset' or with any other notion of
--    permutation, so 'every order' means 'every order reachable by
--    adjacent transpositions', **which is all of them for the usual
--    reasons and is not proved to be**."
--
-- The flag is honest and the phrase inside it is an appeal.  **"The
-- usual reasons" is a proof, and it fits in a page**; §§1–3 are that
-- page, and §4 lands it on the corpus's own relation.
--
-- WHAT IS PROVED, over an ARBITRARY element type — no decidable
-- equality, no h-level, no finiteness:
--
--   Insert x xs ys      `ys` is `xs` with one `x` put in at some place
--   Perm xs ys          the standard inductive permutation relation:
--                       permute the tail, then insert the head anywhere
--   _≈_                 the adjacent-transposition closure, the same
--                       four constructors as the corpus's `_~_`
--   ≈-refl              reflexivity, by induction on the list — NOT a
--                       constructor, and needed before anything else
--   insertIsAnAdjacentChain
--                       `Insert x xs ys → (x ∷ xs) ≈ ys`.  **This is
--                       the whole content**: sliding one element past
--                       `k` others is `k` adjacent swaps, and the
--                       induction is exactly that slide
--   permIsAnAdjacentChain
--                       `Perm xs ys → xs ≈ ys`
--   permGivesTheCorpusRelation
--                       and at `A := Step C` the same proof lands in
--                       `PairwiseCommutationGivesEveryOrder._~_`, via a
--                       constructor-for-constructor translation
--
-- **WHY THE INSERTION LEMMA IS WHERE THE WORK IS.**  Reflexivity,
-- symmetry and transitivity of `≈` are cheap or given.  What "usual
-- reasons" hides is that a permutation is built by INSERTION at an
-- arbitrary depth while `≈` only ever exchanges NEIGHBOURS, and the
-- bridge between the two is the one induction that has to walk down the
-- list.  Everything else is plumbing.
--
-- WHAT IS NOT CLAIMED.  **The audited module is NOT amended and NOT
-- retracted**; its flag was accurate and this discharges half of it.
-- The OTHER half is untouched: nothing here proves `Perm` (or `≈`)
-- coincides with "same multiset" — that direction needs to LOCATE an
-- element and so needs decidable equality on `A`, which is not assumed
-- anywhere here, and no multiset appears in this module at all.  The
-- CONVERSE containment `≈ → Perm` is also not proved; only one
-- inclusion is.  (u′) — the GLOBAL commutation hypothesis in
-- `permInvariant` — is a different flag on that module and is NOT
-- addressed: nothing here mentions `comm`, `runS`, or any step
-- semantics.  No curvature is exhibited.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)

open import OrderIndependenceTransfersAlongAnyNumberOfSteps
  using (Step)
open import PairwiseCommutationGivesEveryOrder
  using (_~_ ; ~nil ; ~cons ; ~swap ; ~trans)

------------------------------------------------------------------------
-- 1.  Insertion, permutation, and adjacency — over any element type
------------------------------------------------------------------------

module _ {A : Type} where

  data Insert (x : A) : List A → List A → Type where
    here  : {xs : List A} → Insert x xs (x ∷ xs)
    there : {y : A} {xs ys : List A}
            → Insert x xs ys → Insert x (y ∷ xs) (y ∷ ys)

  data Perm : List A → List A → Type where
    pnil  : Perm [] []
    pcons : {x : A} {xs ys zs : List A}
            → Perm xs ys → Insert x ys zs → Perm (x ∷ xs) zs

  -- the same four constructors the corpus's `_~_` has
  data _≈_ : List A → List A → Type where
    ≈nil   : [] ≈ []
    ≈cons  : {p : A} {xs ys : List A} → xs ≈ ys → (p ∷ xs) ≈ (p ∷ ys)
    ≈swap  : {p q : A} {xs : List A} → (p ∷ q ∷ xs) ≈ (q ∷ p ∷ xs)
    ≈trans : {xs ys zs : List A} → xs ≈ ys → ys ≈ zs → xs ≈ zs

  ----------------------------------------------------------------------
  -- 2.  Reflexivity is a theorem, not a constructor
  ----------------------------------------------------------------------

  ≈-refl : (xs : List A) → xs ≈ xs
  ≈-refl []       = ≈nil
  ≈-refl (x ∷ xs) = ≈cons (≈-refl xs)

  ----------------------------------------------------------------------
  -- 3.  Insertion at depth k is k adjacent swaps
  --
  -- `there` walks one step further down; the chain gains one `≈swap`
  -- to move `x` past the element it has just walked over, then `≈cons`
  -- to continue underneath it.  That is the slide, and it is the only
  -- induction in this module.
  ----------------------------------------------------------------------

  insertIsAnAdjacentChain :
    {x : A} {xs ys : List A} → Insert x xs ys → (x ∷ xs) ≈ ys
  insertIsAnAdjacentChain {x = x} (here {xs = xs}) = ≈-refl (x ∷ xs)
  insertIsAnAdjacentChain (there ins) =
    ≈trans ≈swap (≈cons (insertIsAnAdjacentChain ins))

  permIsAnAdjacentChain : {xs ys : List A} → Perm xs ys → xs ≈ ys
  permIsAnAdjacentChain pnil = ≈nil
  permIsAnAdjacentChain (pcons p ins) =
    ≈trans (≈cons (permIsAnAdjacentChain p)) (insertIsAnAdjacentChain ins)

------------------------------------------------------------------------
-- 4.  …and it lands on the corpus's own relation
--
-- `_~_` is declared inside `module _ {S T : Type} (C : S → T)` over
-- `List (Step C)`, with exactly the four constructors of `_≈_`.  The
-- translation is therefore constructor-for-constructor, and the point
-- of writing it out is that it is: no side condition appears, so the
-- general theorem above IS a theorem about that module's relation.
------------------------------------------------------------------------

module _ {S T : Type} (C : S → T) where

  toCorpusRelation :
    {xs ys : List (Step C)} → _≈_ {A = Step C} xs ys → _~_ C xs ys
  toCorpusRelation ≈nil          = ~nil
  toCorpusRelation (≈cons r)     = ~cons (toCorpusRelation r)
  toCorpusRelation ≈swap         = ~swap
  toCorpusRelation (≈trans r s)  = ~trans (toCorpusRelation r) (toCorpusRelation s)

  permGivesTheCorpusRelation :
    {xs ys : List (Step C)} → Perm {A = Step C} xs ys → _~_ C xs ys
  permGivesTheCorpusRelation p = toCorpusRelation (permIsAnAdjacentChain p)
