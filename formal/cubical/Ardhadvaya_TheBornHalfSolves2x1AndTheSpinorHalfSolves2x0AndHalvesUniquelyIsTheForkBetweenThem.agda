{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अर्धद्वयम् — the two halves.  The Born ½ and the spinor ½ are the two
-- faces of ONE equation, doubling `x + x = c`, at two right-hand sides,
-- and `halvesUniquely` is the fork between them.
--
-- WHERE THIS COMES FROM.  `EkatvaMatraDvaya` forces the symmetric
-- two-outcome Born weight to ½ from two vows — योगः (normalisation,
-- w true + w false ≡ 𝟙) and साम्यम् (permutation invariance, w true ≡
-- w false) — PROVIDED its carrier parameter
--     halvesUniquely : isProp (Σ[ y ] y + y ≡ 𝟙)
-- holds: 𝟙 has a UNIQUE half.  The Born ½ is that half — the unique
-- solution of `2x = 𝟙`.  This file asks what that hypothesis is, by
-- watching it fail, and finds the spinor on the other side of it.
--
-- THE TWO FACES, one equation `x + x = c`:
--
--   • ARCHIMEDEAN FACE, c = 𝟙 (the unit).  Over a char-0 carrier (ℚ, ℝ)
--     the half of 𝟙 exists and is unique — halvesUniquely holds — and
--     EkatvaMatraDvaya forces the Born weight ½.  This is the interior of
--     the Born measure, reached exactly over the archimedean carrier.
--
--   • TORSION FACE, c = 0 (the additive identity), with x ≠ 0.  A nonzero
--     solution of `x + x = 0` is a 2-TORSION element.  That is the
--     generator of ℤ/2 — and π₁(SO(3)) = ℤ/2, the double cover of the
--     rotation group whose nontrivial loop is the 2π rotation that sends a
--     SPINOR to its negative and needs 4π to return.  The spinor ½ is the
--     j = ½ that this torsion carries.  (This physical reading is header
--     commentary marking the horn; what is CHECKED below is the algebra:
--     over ℤ/2 the doubling equation has the torsion solution and the
--     forcing collapses.)
--
-- THE FORK.  The SAME predicate `halvesUniquely` that MAKES the Born
-- weight forced is precisely what the torsion carrier VIOLATES.  Over
-- ℤ/2 = (Bool, ⊕, false):
--   • at c = 0 (false): the half is NON-unique — false and true both
--     double to 0 (`two-halves`).  This is the torsion, the spinor's home,
--     and EkatvaMatraDvaya's hypothesis cannot hold here.
--   • at c = 1 (true): the half does NOT EXIST — no y doubles to 1
--     (`no-half-of-one`), because ℤ/2 is not 2-divisible.
--   • consequently the Born weight is NOT forced over ℤ/2: two distinct
--     symmetric normalised weights exist at c = 0 (`born-not-forced`),
--     the exact non-uniqueness EkatvaMatraDvaya's halvesUniquely excludes.
--
-- So the Born ½ and the spinor ½ are not the same number wearing two
-- coats; they are the archimedean and torsion solutions of one doubling
-- equation, and the corpus already isolated the fork as `halvesUniquely`.
-- The organ still ungrown is the general nonabelian spectrum √(j(j+1))
-- (the Casimir), of which this torsion generator j = ½ is the first rung;
-- see AkramaBhara for the loop-charge half of the same open horn.
--
-- Uses only the Cubical library's Bool; EkatvaMatraDvaya is cited, not
-- imported (its record lives behind the very hypothesis that fails here).
-- Checked warm through नाडी against the container's agda — छिद्रं नास्ति.
------------------------------------------------------------------------

module Ardhadvaya_TheBornHalfSolves2x1AndTheSpinorHalfSolves2x0AndHalvesUniquelyIsTheForkBetweenThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _⊕_
                                    ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- ℤ/2 as (Bool, ⊕, false).  Doubling sends everything to 0.
------------------------------------------------------------------------

dbl : Bool → Bool
dbl y = y ⊕ y

dbl-zero : (y : Bool) → dbl y ≡ false
dbl-zero true  = refl
dbl-zero false = refl

------------------------------------------------------------------------
-- THE TORSION FACE.  0 has two distinct halves — false and true — so
-- `halvesUniquely` at c = 0 FAILS.  `true` is the 2-torsion generator:
-- nonzero, and it doubles to 0.  That is the spinor.
------------------------------------------------------------------------

spinor-generator : Σ[ y ∈ Bool ] ((dbl y ≡ false) × (¬ (y ≡ false)))
spinor-generator = true , dbl-zero true , true≢false

two-halves : ¬ (isProp (Σ[ y ∈ Bool ] (dbl y ≡ false)))
two-halves hp =
  true≢false (cong fst (hp (true , dbl-zero true) (false , dbl-zero false)))

------------------------------------------------------------------------
-- THE ARCHIMEDEAN FACE has no home here: 1 has NO half in ℤ/2, because
-- doubling never reaches 1.  (Over ℚ it would exist and be unique — that
-- is where the Born ½ lives; EkatvaMatraDvaya proves the forcing there.)
------------------------------------------------------------------------

no-half-of-one : ¬ (Σ[ y ∈ Bool ] (dbl y ≡ true))
no-half-of-one (y , p) = false≢true (sym (dbl-zero y) ∙ p)

------------------------------------------------------------------------
-- THE FORCING COLLAPSES over the torsion carrier.  Both vows —
-- normalisation to 0 and permutation-invariance — are met by two DISTINCT
-- symmetric weights, so EkatvaMatraDvaya's uniqueness does not hold when
-- its halvesUniquely hypothesis is dropped.  The two weights are the two
-- halves of 0: the constant-0 rule and the constant-generator rule.
------------------------------------------------------------------------

-- a symmetric normalised weight over (Bool, ⊕, false): both outcomes
-- equal, and they xor to 0.
record SymWeight : Type where
  field
    w      : Bool → Bool
    योगः    : (w true ⊕ w false) ≡ false      -- normalisation to 0
    साम्यम्  : w true ≡ w false                 -- permutation invariance
open SymWeight

weight-zero : SymWeight
w     weight-zero _ = false
योगः   weight-zero   = refl
साम्यम् weight-zero   = refl

weight-generator : SymWeight
w     weight-generator _ = true
योगः   weight-generator   = refl
साम्यम् weight-generator   = refl

-- the two weights disagree at every outcome: the Born value is NOT forced.
born-not-forced : ¬ (w weight-zero true ≡ w weight-generator true)
born-not-forced = false≢true
