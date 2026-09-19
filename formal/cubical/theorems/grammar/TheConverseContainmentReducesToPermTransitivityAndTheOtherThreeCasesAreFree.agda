{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's established attribution for permutation work â”
-- Nryaa Paita, *Gaitakaumud* (1356) â” belongs to the
-- ENUMERATION line, which is another identity's, and this is not that
-- problem: nothing here counts or generates arrangements.  Claiming
-- that source for a containment between two inductively defined
-- relations would assert a provenance nobody checked.  Checked before
-- naming: `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- 0.  WHAT THIS CYCLE SET OUT TO DO, AND THE BUILD FACT THAT STOPPED IT
--
-- The intended object was an audit of `SemanticCrystal`:
-- its `CertifiedRewrite` bundles three obligations, and two of them â”
-- `preservesDefect` and `preservesNucleus` â” read only the four scalar
-- fields (`measuredDefect` is `Execution.M` of two of them, `interface`
-- is a pair of two more), so any transform copying those fields
-- discharges both, including one that discards the physical state.
-- **That audit is NOT in this file, because the module cannot be built
-- on this container:**
--
--   cd formal/cubical && agda -i . NaturalMachine/SemanticCrystal.agda
--   â’ SEMANTICCRYSTAL_EXIT=42
--   first error: NaturalMachine/DSONucleusOneSidedProduct.agda:17,3-18,39
--   "The module Cubical.Data.Int doesn't export the following: min max"
--
-- **This is a SECOND upstream breakage, independent of the first.**  The
-- one already on record (108, 112) is `Transport.agda:46` importing
-- `solveâ•!` from `Cubical.Tactics.NatSolver.Reflection`.  This one is
-- `Cubical.Data.Int` lacking `min`/`max` in v0.5.  Different module,
-- different library, same cause in kind: **the container is not the
-- pin**, and the divergence is wider than one import.  Neither is mine
-- and neither is touched.  The audit above is therefore recorded as an
-- UNVERIFIED READING of source I could compile nothing against, and it
-- is not claimed as a result.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- 1.  WHAT IS ACTUALLY PROVED HERE â” (vâ³), the cheaper half
--
-- At 47c200bf I proved `Perm âŠ â‰ˆ` (the inductive permutation relation
-- embeds in the adjacent-transposition closure) and flagged the
-- converse as open.  Here the converse **reduces to exactly one
-- missing lemma**:
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
-- â” it needs an exchange lemma moving an `Insert` past a `Perm`, which
-- is NOT written here and is NOT assumed to be hard.
--
-- **THE ASYMMETRY IS THE POINT.**  `â‰ˆ` has transitivity as a
-- CONSTRUCTOR; `Perm` builds it into the shape of `pcons` instead.  So
-- one direction of the containment is a constructor-for-constructor
-- walk (47c200bf) and the other is blocked at precisely the constructor
-- the two representations disagree about.  Nothing about permutations
-- is at stake in that gap â” only which relation pays for composition.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
