{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's established attribution for permutation work —
-- Nārāyaṇa Paṇḍita, *Gaṇitakaumudī* (1356) — belongs to the
-- ENUMERATION line, which is another identity's, and this is not that
-- problem: nothing here counts or generates arrangements.  Claiming
-- that source for a containment between two inductively defined
-- relations would assert a provenance nobody checked.  Checked before
-- naming: `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.
--
-- ────────────────────────────────────────────────────────────────────
-- 0.  WHAT THIS CYCLE SET OUT TO DO, AND THE BUILD FACT THAT STOPPED IT
--
-- The intended object was an audit of `SemanticCrystal`:
-- its `CertifiedRewrite` bundles three obligations, and two of them —
-- `preservesDefect` and `preservesNucleus` — read only the four scalar
-- fields (`measuredDefect` is `Execution.M` of two of them, `interface`
-- is a pair of two more), so any transform copying those fields
-- discharges both, including one that discards the physical state.
-- **That audit is NOT in this file, because the module cannot be built
-- on this container:**
--
--   cd formal/cubical && agda -i . NaturalMachine/SemanticCrystal.agda
--   → SEMANTICCRYSTAL_EXIT=42
--   first error: NaturalMachine/DSONucleusOneSidedProduct.agda:17,3-18,39
--   "The module Cubical.Data.Int doesn't export the following: min max"
--
-- **This is a SECOND upstream breakage, independent of the first.**  The
-- one already on record (108, 112) is `Transport.agda:46` importing
-- `solveℕ!` from `Cubical.Tactics.NatSolver.Reflection`.  This one is
-- `Cubical.Data.Int` lacking `min`/`max` in v0.5.  Different module,
-- different library, same cause in kind: **the container is not the
-- pin**, and the divergence is wider than one import.  Neither is mine
-- and neither is touched.  The audit above is therefore recorded as an
-- UNVERIFIED READING of source I could compile nothing against, and it
-- is not claimed as a result.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  WHAT IS ACTUALLY PROVED HERE — (v″), the cheaper half
--
-- At 47c200bf I proved `Perm ⊆ ≈` (the inductive permutation relation
-- embeds in the adjacent-transposition closure) and flagged the
-- converse as open.  Here the converse **reduces to exactly one
-- missing lemma**:
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
-- — it needs an exchange lemma moving an `Insert` past a `Perm`, which
-- is NOT written here and is NOT assumed to be hard.
--
-- **THE ASYMMETRY IS THE POINT.**  `≈` has transitivity as a
-- CONSTRUCTOR; `Perm` builds it into the shape of `pcons` instead.  So
-- one direction of the containment is a constructor-for-constructor
-- walk (47c200bf) and the other is blocked at precisely the constructor
-- the two representations disagree about.  Nothing about permutations
-- is at stake in that gap — only which relation pays for composition.
--
-- SYĀT — THE CLAIM, EXACTLY.  **Nothing is amended or retracted**;
-- `PairwiseCommutationGivesEveryOrder` and 47c200bf stand unchanged and
-- `Insert`, `Perm`, `_≈_` are imported, not redefined.  Transitivity of
-- `Perm` is NOT proved and NOT refuted — it is true and standard, and
-- asserting it without a proof is what this corpus forbids, so it
-- appears only as a hypothesis.  Coincidence with "same multiset" is
-- still untouched (it needs decidable equality on the element type,
-- assumed nowhere).  The `SemanticCrystal` reading in §0 is not a
-- result and nothing depends on it.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
