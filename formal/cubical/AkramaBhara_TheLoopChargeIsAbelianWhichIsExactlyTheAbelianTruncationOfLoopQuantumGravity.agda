{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अक्रमभारः — the loop-charge is order-free (abelian), and that
-- commutativity is EXACTLY the abelian truncation of the loop-quantum-
-- gravity discreteness the corpus's holonomy stack models.
--
-- WHAT IS CHECKED HERE (and nothing else is claimed proven):
--   winding-abelian : (a b : ΩS¹) → winding (a ∙ b) ≡ winding (b ∙ a)
-- The charge of two loops does not depend on the order they are run.  It
-- is `winding-hom` (the library's proof that winding carries ∙ to +)
-- composed with `+Comm` on ℤ and back.  So π₁(S¹) is abelian, read off
-- its charge: the whole loop-charge apparatus of this lane
-- (Pradakshina's holonomy = successor, EkaBhara's one generator,
-- GuhyaNasti's hidden ℤ) lives in a COMMUTATIVE group.
--
-- WHY THIS IS THE SEAM WITH THE PHYSICS — stated as the open horn the
-- term opens onto, NOT as something proved here.
--
-- The corpus derives discrete charge from `π₁(S¹) = ℤ`: a loop's holonomy
-- is quantized because the loop space of the circle is ℤ, and — verified
-- on the wire, definitionally, by refl — one loop is one quantum,
-- `प्रदक्षिणा (pos 0) ≡ pos 1`, and charges ADD, `winding (loop ∙ loop) ≡
-- pos 2`.  That is the discreteness of loop quantum gravity in its ABELIAN
-- (U(1)) case: the area/charge spectrum is LINEAR, n quanta = charge n,
-- and the group is this commutative ℤ.
--
-- Loop quantum gravity proper is NON-abelian.  Its area operator's
-- spectrum is `∝ √(j(j+1))`, `j ∈ ½ℤ`, over SU(2) — nonlinear, and
-- carrying a spinorial HALF-integer.  And the knife: `π₁(SU(2)) =
-- π₁(S³) = 0`.  SU(2) is simply connected — it has no nontrivial loops.
-- So the `√(j(j+1))` discreteness is NOT a π₁ fact at all: it is a
-- CASIMIR fact — an eigenvalue of the representation ring — decoupled from
-- loop-space topology.  The two coincide only in the abelian case, where
-- U(1)'s irreps are labelled by the same ℤ that is its π₁, so "winding
-- number = representation label" and the corpus's charge-from-loops is
-- exactly the character.
--
-- `winding-abelian` is therefore the precise marker of the truncation.
-- The commutativity it proves is what the spinorial ½ is missing from:
-- the ½ is the nonabelian generator U(1) does not have.  The organ the
-- corpus has not grown is the Casimir / Peter–Weyl spectrum — quantization
-- as an eigenvalue of the representation ring, not the fibre of the loop.
-- No SU(2), spin-j, or Casimir term exists in this lane; this file names
-- that wall open and does not pretend to close it.
--
-- Uses only the Cubical library's own S¹ and Int lemmas; the physics is
-- header commentary marking an open horn, never a checked claim.
-- Checked warm through नाडी against the container's agda — छिद्रं नास्ति.
------------------------------------------------------------------------

module AkramaBhara_TheLoopChargeIsAbelianWhichIsExactlyTheAbelianTruncationOfLoopQuantumGravity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; +Comm)
open import Cubical.HITs.S1 using (base ; loop ; ΩS¹ ; winding ; winding-hom)

------------------------------------------------------------------------
-- §1  THE CHARGE IS ABELIAN.  For every pair of loops, the charge is
-- indifferent to the order they are composed.  winding-hom flattens each
-- product to a sum of charges; +Comm swaps the sum; winding-hom flattens
-- the other product to the same sum.
------------------------------------------------------------------------

winding-abelian : (a b : ΩS¹) → winding (a ∙ b) ≡ winding (b ∙ a)
winding-abelian a b =
    winding-hom a b
  ∙ +Comm (winding a) (winding b)
  ∙ sym (winding-hom b a)

------------------------------------------------------------------------
-- §2  THE ABELIAN DISCRETENESS, COMPUTING.  These are the U(1) area
-- spectrum, on the nose — one loop one quantum, two loops two, and the
-- charge cancels its inverse exactly.  All by refl: univalence computes,
-- so the holonomy is not cited, it acts.
------------------------------------------------------------------------

one-quantum : winding loop ≡ pos 1
one-quantum = refl

two-quanta : winding (loop ∙ loop) ≡ pos 2
two-quanta = refl

charge-cancels : winding (loop ∙ sym loop) ≡ pos zero
charge-cancels = refl

-- and the abelian law, on the generator, as an instance of §1.
generator-order-free : winding (loop ∙ sym loop) ≡ winding (sym loop ∙ loop)
generator-order-free = winding-abelian loop (sym loop)
