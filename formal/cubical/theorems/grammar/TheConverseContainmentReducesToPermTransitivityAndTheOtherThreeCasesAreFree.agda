{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's established attribution for permutation work â”
-- Nryaa Paita, *Gaitakaumud* (1356) â” belongs to the
-- ENUMERATION line, and this is not that
-- problem: nothing here counts or generates arrangements.  Claiming
-- that source for a containment between two inductively defined
-- relations would assert a provenance nobody checked.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- 1.  WHAT IS PROVED HERE
--
-- `TheUsualReasonsMadeExplicitâ¦` proves `Perm âŠ â‰ˆ` (the inductive
-- permutation relation embeds in the adjacent-transposition closure).
-- Here the converse **reduces to exactly one lemma**:
--
--   permRefl / permCons / permSwap    three of the four cases of `â‰ˆ`,
--                                     free, by induction and by one
--                                     application of `pcons`
--   permTransitivityGivesTheConverse
--       (transitivity of `Perm`) â’ (xs â‰ˆ ys â’ Perm xs ys)
--
-- so `â‰ˆnil`, `â‰ˆcons` and `â‰ˆswap` cost nothing and **`â‰ˆtrans` is the
-- whole obstacle**, because `Perm` has no transitivity constructor and
-- transitivity of `Perm` is not derivable by structural induction alone
-- â” it needs an exchange lemma moving an `Insert` past a `Perm`.
--
-- **THE ASYMMETRY IS THE POINT.**  `â‰ˆ` has transitivity as a
-- CONSTRUCTOR; `Perm` builds it into the shape of `pcons` instead.  So
-- one direction of the containment is a constructor-for-constructor
-- walk (47c200bf) and the other is blocked at precisely the constructor
-- the two representations disagree about.  Nothing about permutations
-- is at stake in that gap â” only which relation pays for composition.
------------------------------------------------------------------------

module TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using ( Insert ; here ; there
        ; Perm ; pnil ; pcons
        ; _â‰ˆ_ ; â‰ˆnil ; â‰ˆcons ; â‰ˆswap ; â‰ˆtrans )

module _ {A : Type} where

  ------------------------------------------------------------------
  -- 2.  Three of the four cases, free
  ------------------------------------------------------------------

  permRefl : (xs : List A) â†’ Perm xs xs
  permRefl []       = pnil
  permRefl (x âˆ· xs) = pcons (permRefl xs) here

  permCons : {x : A} {xs ys : List A} â†’ Perm xs ys â†’ Perm (x âˆ· xs) (x âˆ· ys)
  permCons p = pcons p here

  permSwap : {p q : A} {xs : List A} â†’ Perm (p âˆ· q âˆ· xs) (q âˆ· p âˆ· xs)
  permSwap {q = q} {xs = xs} = pcons (permRefl (q âˆ· xs)) (there here)

  ------------------------------------------------------------------
  -- 3.  â¦and the fourth is the whole obstacle
  ------------------------------------------------------------------

  PermTransitivity : Type
  PermTransitivity =
    {xs ys zs : List A} â†’ Perm xs ys â†’ Perm ys zs â†’ Perm xs zs

  permTransitivityGivesTheConverse :
    PermTransitivity â†’ {xs ys : List A} â†’ xs â‰ˆ ys â†’ Perm xs ys
  permTransitivityGivesTheConverse tr â‰ˆnil          = pnil
  permTransitivityGivesTheConverse tr (â‰ˆcons r)     =
    permCons (permTransitivityGivesTheConverse tr r)
  permTransitivityGivesTheConverse tr â‰ˆswap         = permSwap
  permTransitivityGivesTheConverse tr (â‰ˆtrans r s)  =
    tr (permTransitivityGivesTheConverse tr r)
       (permTransitivityGivesTheConverse tr s)
