{-# OPTIONS --cubical --safe #-}

-- ValliBhavanaSandhi_TheSeedIsAReflChainAndPratilomaIsTranspose
--
-- वल्ली: Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33 (499).  भावना: Brahmagupta,
-- Brāhmasphuṭasiddhānta 18.64–65 (628).  सन्धिः: junction; the compound
-- वल्ली-भावना-सन्धिः is built in this corpus (2026-08-23,
-- notes/ValliBhavanaSandhi_ThePeriodsCloseIsWhereTheFreeGarlandLandsInTheCommutativeWheel.md)
-- and no source is claimed for it.  NOT CLAIMED: that any Indian text
-- states a matrix, a monoid, or a representation.  What is claimed of the
-- sources is exactly what the machine lane already claims: the vallī is the
-- quotient column, the भावना is the composition rule (xx'+Dyy', xy'+x'y).
--
-- WHAT THIS MODULE CHECKS, checked forms of the note's derivation:
--
--   1. प्रतिलोम-मुक्तम् — the generator column M(a) = [[a,1],[1,0]] is its
--      own transpose (refl), so reversal of a garland is transposition.
--   2. प्रतिलोमः — transpose is an anti-automorphism of the matrix monoid:
--      (A·B)ᵀ = Bᵀ·Aᵀ, proved componentwise from ·Comm alone.
--   3. सन्धि-बीजम् (D = 2, the seed instance of the note's Theorem):
--      M(1)·M(2)·M(1)·M(0) ≡ ι(3 + 2√2), where ι x y = [[x, Dy],[y, x]]
--      is the regular representation on the basis (1, √D).  One refl:
--      both sides compute to [[3,4],[2,3]].  det bookkeeping: 9 − 2·4 = 1.
--
-- OWED, said here so nobody mistakes scope: the general theorem
-- P·M(a₀)·M(0) ≡ ι(x + y√D) for every non-square D (its proof is the two
-- matching equations of the note, per-D a finite computation); and
-- भावना-as-matrix-multiplication in general, mm (ι x y) (ι x' y') ≡
-- ι (xx'+D yy') (xy'+x'y), which needs ·Assoc and distributivity and is
-- left as the next term so this module's import surface stays two lemmas.
--
-- ~~DEFECT, WRITTEN AT THE MOMENT OF THE ACT: this module was authored in a
-- container with no agda binary (2026-08-23; the same container that could
-- not run ValliMala).  It has NOT been checked here.~~
-- DISCHARGED, same day: agda 2.6.3 + cubical v0.5 were installed into the
-- container and the module CHECKS (exit 0, LC_ALL forced per Certificate.hs's
-- own locale warning).  Both kernel controls were watched first: the negative
-- control (pos 1 ≡ pos 2 by refl) was rejected with a located type error
-- (exit 42, "1 != 2"), so the kernel was seen rejecting a falsehood before
-- this module's green was believed.  The strike is left standing because the
-- first landing of this file was unchecked and that history should be
-- readable.

module ValliBhavanaSandhi_TheSeedIsAReflChainAndPratilomaIsTranspose where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
open import Cubical.Data.Int.Properties using (·Comm)

-- ── the matrix monoid, four slots, no list and no vector ─────────────────

record Mat : Type where
  constructor mat
  field
    m00 m01 m10 m11 : ℤ

open Mat

_⋆_ : Mat → Mat → Mat
A ⋆ B = mat (m00 A · m00 B + m01 A · m10 B) (m00 A · m01 B + m01 A · m11 B)
            (m10 A · m00 B + m11 A · m10 B) (m10 A · m01 B + m11 A · m11 B)

infixl 20 _⋆_

-- the vallī generator: one digit, one column move
गणकः : ℤ → Mat
गणकः a = mat a (pos 1) (pos 1) (pos 0)

-- transpose
प्रतिलोमम् : Mat → Mat
प्रतिलोमम् A = mat (m00 A) (m10 A) (m01 A) (m11 A)

-- the regular representation of x + y√D on the basis (1, √D)
ι : (D x y : ℤ) → Mat
ι D x y = mat x (D · y) y x

-- ── १ · the generator is its own reverse ─────────────────────────────────

प्रतिलोम-मुक्तम् : (a : ℤ) → प्रतिलोमम् (गणकः a) ≡ गणकः a
प्रतिलोम-मुक्तम् a = refl

-- ── २ · transpose is an anti-automorphism: (A⋆B)ᵀ ≡ Bᵀ⋆Aᵀ ────────────────
-- Componentwise; each slot is two applications of ·Comm under _+_.

प्रतिलोमः : (A B : Mat) → प्रतिलोमम् (A ⋆ B) ≡ प्रतिलोमम् B ⋆ प्रतिलोमम् A
प्रतिलोमः A B i =
  mat (cong₂ _+_ (·Comm (m00 A) (m00 B)) (·Comm (m01 A) (m10 B)) i)
      (cong₂ _+_ (·Comm (m10 A) (m00 B)) (·Comm (m11 A) (m10 B)) i)
      (cong₂ _+_ (·Comm (m00 A) (m01 B)) (·Comm (m01 A) (m11 B)) i)
      (cong₂ _+_ (·Comm (m10 A) (m01 B)) (·Comm (m11 A) (m11 B)) i)

-- ── ३ · the seed sandhi, D = 2 ───────────────────────────────────────────
-- Digits of √2 across the closed period: 1, 2, 1; dressed with M(0).
-- The garland lands on ι 2 3 2 — the regular representation of 3 + 2√2,
-- Brahmagupta's fundamental for D = 2, norm 9 − 2·4 = 1.

सन्धि-बीजम् :
    गणकः (pos 1) ⋆ गणकः (pos 2) ⋆ गणकः (pos 1) ⋆ गणकः (pos 0)
  ≡ ι (pos 2) (pos 3) (pos 2)
सन्धि-बीजम् = refl
