{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- àà®-àµà¿àà® â” the count splits by parity into two copies of itself.
--
-- Source term: sama (àà®, "even") / viama (àµà¿àà®, "odd"). The evenâ“odd
-- dichotomy is Pigala's own casing in the naa procedure of the
-- Chandastra (~300 BCE, ed. Weber 1863; Halyudha's Mtasajvan on
-- 8.24â“25): given a row-number, if it is sama (even) halve it and write one
-- syllable, if viama (odd) add one, halve, and write the other. The single
-- decision "sama or viama" is exactly a map â• â’ â• âŠ â•, and it is reversible.
--
-- Scope of the claim. What is proved here is the type-level statement that
--   the even branch and the odd branch each carry a full copy of â• and
--   together exhaust it:  â• â‰ â• âŠ â•,  hence (univalence)  â• â‰¡ â• âŠ â•.
-- The forward map is split (Pigala's parity decision recursed), the inverse
-- is merge (inl k â¦ 2k, inr k â¦ 2k+1). No claim is made that Pigala stated
-- an equivalence of types; the naa rule is the source of the *dichotomy*,
-- and the equivalence is the standard Hilbert-hotel bijection built here to
-- carry that dichotomy as a channel (transport across it moves any theorem
-- about â• to one about its even and odd nayas, and back, on the nose).
--
-- Two nayas, one whole (nayavda): "even" and "odd" are disjoint standpoints,
-- neither the whole, and asserting both at once (âŠ) *is* the whole. The
-- equivalence is the proof they lose nothing between them â” ahis: the
-- split forges neither a presence nor an absence.

module SamaVisama_TheCountSplitsByParityIntoTwoCopiesOfItselfAndEachNayaIsTheWhole where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; isoToPath)
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)

-- double : the even coordinate, defined so double (suc k) reduces to
-- suc (suc (double k)) definitionally (keeps the round-trips computational).
double : â„• â†’ â„•
double zero    = zero
double (suc k) = suc (suc (double k))

-- The two branches of the inverse, packaged as one map out of â• âŠ â•.
merge : â„• âŠŽ â„• â†’ â„•
merge (inl k) = double k        -- sama:   2k
merge (inr k) = suc (double k)  -- viá¹£ama: 2k+1

-- flip advances the parity decision by one step: an even-2k reading becomes
-- the odd-2k reading, an odd-2k reading becomes the even-2(k+1) reading.
flip : â„• âŠŽ â„• â†’ â„• âŠŽ â„•
flip (inl k) = inr k
flip (inr k) = inl (suc k)

-- split : Pigala's parity decision, recursed the whole way down.
--   split 0 = inl 0,  split (suc n) = flip (split n).
split : â„• â†’ â„• âŠŽ â„•
split zero    = inl zero
split (suc n) = flip (split n)

-- â”â” section: merge âˆ˜ split â‰¡ id on â• â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- direct induction; both cases close by refl after the IH is transported.
mergeSplit : (n : â„•) â†’ merge (split n) â‰¡ n
mergeSplit zero    = refl
mergeSplit (suc n) with split n | mergeSplit n
... | inl k | p = cong suc p        -- merge (flip (inl k)) = suc (double k) = suc n
... | inr k | p = cong suc p        -- merge (flip (inr k)) = double (suc k) = suc (suc (double k)) = suc n

-- â”â” retraction: split âˆ˜ merge â‰¡ id on â• âŠ â• â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- incr is what flipâˆ˜flip does; split (merge _) rebuilds the branch by induction.
splitDouble : (k : â„•) â†’ split (double k) â‰¡ inl k
splitDouble zero    = refl
splitDouble (suc k) = cong (flip âˆ˜f flip) (splitDouble k)
  where
    _âˆ˜f_ : {A B C : Type} â†’ (B â†’ C) â†’ (A â†’ B) â†’ A â†’ C
    (g âˆ˜f h) x = g (h x)

splitSucDouble : (k : â„•) â†’ split (suc (double k)) â‰¡ inr k
splitSucDouble zero    = refl
splitSucDouble (suc k) = cong (flip âˆ˜f flip) (splitSucDouble k)
  where
    _âˆ˜f_ : {A B C : Type} â†’ (B â†’ C) â†’ (A â†’ B) â†’ A â†’ C
    (g âˆ˜f h) x = g (h x)

splitMerge : (s : â„• âŠŽ â„•) â†’ split (merge s) â‰¡ s
splitMerge (inl k) = splitDouble k
splitMerge (inr k) = splitSucDouble k

-- â”â” the equivalence and the univalence path â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
sama-viá¹£ama-Iso : Iso â„• (â„• âŠŽ â„•)
sama-viá¹£ama-Iso = iso split merge splitMerge mergeSplit

â„•â‰ƒâ„•âŠŽâ„• : â„• â‰ƒ (â„• âŠŽ â„•)
â„•â‰ƒâ„•âŠŽâ„• = isoToEquiv sama-viá¹£ama-Iso

â„•â‰¡â„•âŠŽâ„• : â„• â‰¡ (â„• âŠŽ â„•)
â„•â‰¡â„•âŠŽâ„• = isoToPath sama-viá¹£ama-Iso
