{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's established attribution for permutation work —
-- Nārāyaṇa Paṇḍita, *Gaṇitakaumudī* (1356) — belongs to the
-- ENUMERATION line, and this is not that
-- problem: nothing here counts or generates arrangements.  Claiming
-- that source for a containment between two inductively defined
-- relations would assert a provenance nobody checked.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  WHAT IS PROVED HERE
--
-- `TheUsualReasonsMadeExplicit` proves `Perm  ≈` (the inductive
-- permutation relation embeds in the adjacent-transposition closure).
-- Here the converse **reduces to exactly one lemma**:
--
--   permRefl / permCons / permSwap    three of the four cases of `≈`,
--                                     free, by induction and by one
--                                     application of `pcons`
--   permTransitivityGivesTheConverse
--       (transitivity of `Perm`) → (xs ≈ ys → Perm xs ys)
--
-- so `≈nil`, `≈cons` and `≈swap` cost nothing and **`≈trans` is the
-- whole obstacle**, because `Perm` has no transitivity constructor and
-- transitivity of `Perm` is not derivable by structural induction alone
-- — it needs an exchange lemma moving an `Insert` past a `Perm`.
--
-- **THE ASYMMETRY IS THE POINT.**  `≈` has transitivity as a
-- CONSTRUCTOR; `Perm` builds it into the shape of `pcons` instead.  So
-- one direction of the containment is a constructor-for-constructor
-- walk (47c200bf) and the other is blocked at precisely the constructor
-- the two representations disagree about.  Nothing about permutations
-- is at stake in that gap — only which relation pays for composition.
------------------------------------------------------------------------

module TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using ( Insert ; here ; there
        ; Perm ; pnil ; pcons
        ; _≈_ ; ≈nil ; ≈cons ; ≈swap ; ≈trans )

module _ {A : Type} where

  ------------------------------------------------------------------
  -- 2.  Three of the four cases, free
  ------------------------------------------------------------------

  permRefl : (xs : List A) → Perm xs xs
  permRefl []       = pnil
  permRefl (x ∷ xs) = pcons (permRefl xs) here

  permCons : {x : A} {xs ys : List A} → Perm xs ys → Perm (x ∷ xs) (x ∷ ys)
  permCons p = pcons p here

  permSwap : {p q : A} {xs : List A} → Perm (p ∷ q ∷ xs) (q ∷ p ∷ xs)
  permSwap {q = q} {xs = xs} = pcons (permRefl (q ∷ xs)) (there here)

  ------------------------------------------------------------------
  -- 3.  …and the fourth is the whole obstacle
  ------------------------------------------------------------------

  PermTransitivity : Type
  PermTransitivity =
    {xs ys zs : List A} → Perm xs ys → Perm ys zs → Perm xs zs

  permTransitivityGivesTheConverse :
    PermTransitivity → {xs ys : List A} → xs ≈ ys → Perm xs ys
  permTransitivityGivesTheConverse tr ≈nil          = pnil
  permTransitivityGivesTheConverse tr (≈cons r)     =
    permCons (permTransitivityGivesTheConverse tr r)
  permTransitivityGivesTheConverse tr ≈swap         = permSwap
  permTransitivityGivesTheConverse tr (≈trans r s)  =
    tr (permTransitivityGivesTheConverse tr r)
       (permTransitivityGivesTheConverse tr s)
