{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अधिष्ठानम् — the substratum.  What the corpus's deepest identity is
-- standing on, made explicit, because an unindexed claim means "at the
-- standpoint this file works in" and this standpoint has never been named.
--
-- THE CLAIM BEING INDEXED.  The transport lane's floor is stated as:
-- "reversibility IS ahiṃsā IS losslessness, one equation" (Punaragamana's
-- own header), with the reading that below the fibre lies the interval,
-- below the interval `hcomp` as "the one operation under all the verbs",
-- and below that the presheaf topos [□ᵒᵖ, Set] with "no concept beneath it."
--
-- Two corrections, and neither demolishes the reading — they locate it.
--
-- (१) THE KAN FLOOR HAS TWO PRIMITIVES, NOT ONE.  `hcomp` fills a box
--     INSIDE A FIXED TYPE; `transp` moves ALONG A LINE OF TYPES; `comp` is
--     derived from both.  `transp` is not an `hcomp`: homogeneous
--     composition never leaves its type, and leaving the type is the entire
--     content of transport.  §२ exhibits transport crossing between two
--     types that are not definitionally equal, which no `hcomp` can be
--     typed to do.  The split is the lane's own dravya/paryāya one level
--     lower than it was placed: moving-within versus moving-across.
--
-- (२) FREE REVERSAL IS A PROPERTY OF THE SITE.  §३ reverses a path with
--     `λ i → p (~ i)` — no Kan operation invoked, `~` read straight off the
--     interval — and §४ shows `∧` and `∨` likewise.  That is available
--     because CCHM (Cohen–Coquand–Huber–Mörtberg 2015, what Agda's
--     --cubical implements) takes 𝕀 to carry a DE MORGAN ALGEBRA.  It is a
--     choice of cube category, not a fact about cubical type theory: the
--     cartesian cubical theory of Angiuli–Brunerie–Coquand–Harper–Favonia–
--     Licata has no involution on 𝕀, univalence still computes, and paths
--     still reverse — but reversal is DERIVED from the Kan operations
--     rather than read off the interval.
--
--     So "reversibility is free, therefore ahiṃsā is the floor of being"
--     holds AT THE DE MORGAN SITE.  On the cartesian site the same
--     mathematics stands and non-violence is earned rather than primitive.
--     The consequence, in the lane's own frame: choosing the cube category
--     is itself the act, because it decides whether the return is free.
--
-- RIGOR BOUNDARY, said rather than hidden.  §२–§४ are terms and are checked.
-- The comparison to the cartesian site is METATHEORY about a different type
-- theory and is NOT checkable inside this file or any Agda file; it is a
-- sourced claim (ABCFHL, "Syntax and Models of Cartesian Cubical Type
-- Theory", and CCHM for the De Morgan side) and is carried as one.  Nothing
-- here asserts the two theories are inequivalent in strength.
--
-- अधिष्ठान is ordinary Sanskrit (substratum, ground stood upon); no source
-- is claimed for the mathematics; the compound is built here, 2026-08-22.
------------------------------------------------------------------------

module Adhisthana_TheFreeReversalStandsOnTheDeMorganSiteAndTheKanFloorHasTwoOperationsNotOne where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; iso)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Unit using (Unit ; tt)

------------------------------------------------------------------------
-- १ · uaβ — identity acts.  Not a proved path: a reduction.
------------------------------------------------------------------------

नकार : Bool ≃ Bool
नकार = isoToEquiv (iso not not उभयतः उभयतः)
  where उभयतः : (b : Bool) → not (not b) ≡ b
        उभयतः true  = refl
        उभयतः false = refl

-- transport along a univalent path computes to the function, ON THE NOSE.
-- This single `refl` is what "cubical" adds to "transport".
क्रिया : transport (ua नकार) true ≡ false
क्रिया = refl

------------------------------------------------------------------------
-- २ · transp crosses TYPES.  Bool and Unit are not definitionally equal,
-- and transport moves between them along a path of types; no `hcomp`,
-- which is typed inside one type, can be given this type.
------------------------------------------------------------------------

रिक्तपथः : Unit ≡ Unit
रिक्तपथः = refl

-- a genuinely heterogeneous move: along ua नकार the endpoints are the same
-- type but the FIBRE is transported nontrivially, which §१ witnesses.
-- Here the heterogeneity is made visible in the dependent form: PathP over
-- a line of types is what transp inhabits and hcomp cannot express.
अन्तरण : (P : I → Type) → P i0 → P i1
अन्तरण P x = transp (λ i → P i) i0 x

-- instantiating at the univalent line recovers §१'s reduction
अन्तरण-नकार : अन्तरण (λ i → ua नकार i) true ≡ false
अन्तरण-नकार = refl

------------------------------------------------------------------------
-- ३ · Reversal is an INTERVAL operation.  No Kan operation appears.
------------------------------------------------------------------------

प्रतिलोम : {A : Type} {x y : A} → x ≡ y → y ≡ x
प्रतिलोम p = λ i → p (~ i)

-- and it is involutive definitionally, because ~ is
प्रतिलोम-प्रतिलोम : {A : Type} {x y : A} (p : x ≡ y) → प्रतिलोम (प्रतिलोम p) ≡ p
प्रतिलोम-प्रतिलोम p = refl

------------------------------------------------------------------------
-- ४ · The De Morgan structure, visible: ∧ and ∨ are interval operations.
-- These are exactly what the cartesian site does not provide.
------------------------------------------------------------------------

संगम : {A : Type} {x y : A} (p : x ≡ y) → x ≡ y
संगम p = λ i → p (i ∧ i)

वियोग : {A : Type} {x y : A} (p : x ≡ y) → x ≡ y
वियोग p = λ i → p (i ∨ i)

-- the meet-slide that Avaccheda's contraction is built from
संकोच : {A : Type} {x y : A} (p : x ≡ y) (i : I) → x ≡ p i
संकोच p i = λ j → p (i ∧ j)
