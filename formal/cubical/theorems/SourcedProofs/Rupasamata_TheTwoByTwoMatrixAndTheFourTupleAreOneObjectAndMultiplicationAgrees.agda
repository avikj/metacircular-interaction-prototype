{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रूप-समता — the 2×2 matrix and the four-tuple are one object.
--
-- (rūpa-samatā — sameness of form: two encodings of a 2×2 quantity that
--  print as different types are joined here by a genuine equivalence, and
--  the two multiplications are carried onto each other by it.)
--
-- ────────────────────────────────────────────────────────────────────
-- TERM, TEXT, DATE.  रूप-समता is a plain descriptive Sanskrit compound —
-- रूप (rūpa, "form") + समता (samatā, "sameness") — and is BUILT HERE, not
-- attributed to a source: the object it names (an equivalence of two type
-- encodings) is not an Indian-source result and none is claimed for it.
-- This follows note 2 of the file-naming rule in CLAUDE.md ("Where the
-- mathematics genuinely originates elsewhere, say so in the header rather
-- than inventing a Sanskrit label").  The substrate — `transport`, `Iso`,
-- and the fact that a path between types carries structure both ways — is
-- Voevodsky's, this repository's one admitted non-Indian frame.
--
-- The matrix multiplication `mul` on the four-tuple whose intertwining is
-- checked below is Gamma0Partner's, which realises Brahmagupta's bhāvanā
-- (composition) on the pair field; the header of that module carries the
-- *ब्राह्मस्फुटसिद्धान्त* (628 CE) citation and scope, not repeated here.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS FILE EXISTS.  The corpus defines the same object twice:
--
--   Coefficient.Mat 2 2   (the cubical library's 2×2 integer matrix,
--                          = Fin 2 → Fin 2 → ℤ), the type the certified
--                          Smith normalizer and SmithTorsorBridge speak in;
--   Gamma0Partner.M        (= ℤ × ℤ × ℤ × ℤ), the four-tuple the pair-field
--                          / Γ₀(q)-torsor modules quantify over.
--
-- SmithTorsorBridge gives ONE direction, `toTuple : Mat 2 2 → M`, and shows
-- it preserves multiplication — but never that it is an EQUIVALENCE.  So the
-- two encodings sit side by side as "the same object" with nothing checked
-- that lets a theorem cross from one to the other.  This module closes that:
-- §1–§3 exhibit `Mat 2 2 ≃ M`, and §4 checks that the equivalence intertwines
-- the library's matrix product `_⋆_` with Gamma0Partner's `mul`.  A receipt
-- is an IDENTIFICATION of the two, never a bound (README, "the receipt
-- economy"): the equivalence computes, so `transp (ua e)` carries any theorem
-- across, both ways, on the nose.
------------------------------------------------------------------------

module SourcedProofs.Rupasamata_TheTwoByTwoMatrixAndTheFourTupleAreOneObjectAndMultiplicationAgrees where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.FinData using (Fin ; zero ; suc ; one)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Algebra.Matrix.CommRingCoefficient

open import Gamma0Partner using (R ; M ; mul)
open Coefficient ℤCommRing

------------------------------------------------------------------------
-- §1 · the two changes of representation.
--
-- `toTuple` is exactly SmithTorsorBridge's, restated here so this module
-- does not need to import the normalizer's heavy dependency graph; `fromTuple`
-- is the reverse it was missing, defined by matching on the two inhabitants
-- of `Fin 2` (`zero` and `suc zero`).
------------------------------------------------------------------------

toTuple : Mat 2 2 → M
toTuple A = (A zero zero , A zero one , A one zero , A one one)

fromTuple : M → Mat 2 2
fromTuple (a , b , c , d) zero          zero          = a
fromTuple (a , b , c , d) zero          (suc zero)    = b
fromTuple (a , b , c , d) (suc zero)    zero          = c
fromTuple (a , b , c , d) (suc zero)    (suc zero)    = d

------------------------------------------------------------------------
-- §2 · the two round-trips.
--
-- `toFrom` is definitional (`one` reduces to `suc zero`, on which `fromTuple`
-- was matched); `fromTo` needs function extensionality over Fin 2 × Fin 2,
-- taken pointwise by the same four-way match.  Coverage of Fin 2 is complete
-- with `zero` and `suc zero`: the remaining `suc (suc _)` case is over Fin 0
-- and is discharged by Agda automatically.
------------------------------------------------------------------------

toFrom : (t : M) → toTuple (fromTuple t) ≡ t
toFrom (a , b , c , d) = refl

fromTo-pt : (A : Mat 2 2) (i j : Fin 2) → fromTuple (toTuple A) i j ≡ A i j
fromTo-pt A zero       zero       = refl
fromTo-pt A zero       (suc zero) = refl
fromTo-pt A (suc zero) zero       = refl
fromTo-pt A (suc zero) (suc zero) = refl

fromTo : (A : Mat 2 2) → fromTuple (toTuple A) ≡ A
fromTo A i j k = fromTo-pt A j k i

------------------------------------------------------------------------
-- §3 · the equivalence: the two encodings are one object.
------------------------------------------------------------------------

Iso-Mat-M : Iso (Mat 2 2) M
Iso-Mat-M = iso toTuple fromTuple toFrom fromTo

Mat≃M : Mat 2 2 ≃ M
Mat≃M = isoToEquiv Iso-Mat-M

------------------------------------------------------------------------
-- §4 · the equivalence intertwines the two multiplications.
--
-- Each component is the library's own 2-element product law `mul2`, which
-- states (A ⋆ B) i j ≡ A i zero · B zero j + A i one · B one j.  Reading it
-- off at the four (i,j) reproduces exactly Gamma0Partner.mul's four entries,
-- so `toTuple` is a multiplication homomorphism — the fact SmithTorsorBridge
-- used, now standing on the equivalence rather than beside it.
------------------------------------------------------------------------

homMul : (A B : Mat 2 2) → toTuple (A ⋆ B) ≡ mul (toTuple A) (toTuple B)
homMul A B i =
  ( mul2 A B zero zero i
  , mul2 A B zero one  i
  , mul2 A B one  zero i
  , mul2 A B one  one  i )
