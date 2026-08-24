-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.DSONucleusExecutionCalibration
--
-- Delta 29's execution-derived four-state calibration.  The defect M is
-- computed from the supplied state multiplication and potential; its complete
-- table and trefoil identity are kernel reductions, not imported outputs.
--
-- The later one-sided closure product is intentionally not guessed here: its
-- displayed profile values do not define the operator which produced them.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusExecutionCalibration where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc) renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)

data Cell : Type₀ where
  e a c d : Cell

_·C_ : Cell → Cell → Cell
e ·C y = y
a ·C e = a
a ·C a = e
a ·C c = c
a ·C d = d
c ·C e = c
c ·C a = d
c ·C c = c
c ·C d = d
d ·C e = d
d ·C a = c
d ·C c = c
d ·C d = d

potential : Cell → ℤ
potential e = pos 0
potential a = negsuc 2  -- -3
potential c = pos 1
potential d = pos 4

-- Derived, not transcribed: execution defect of the potential.
M : Cell → Cell → ℤ
M x y = potential (x ·C y) -ℤ potential x -ℤ potential y

-- Complete expected matrix, in row/column order e,a,c,d.
M-e-row : (M e e ≡ pos 0) × (M e a ≡ pos 0)
        × (M e c ≡ pos 0) × (M e d ≡ pos 0)
M-e-row = refl , refl , refl , refl

M-a-row : (M a e ≡ pos 0) × (M a a ≡ pos 6)
        × (M a c ≡ pos 3) × (M a d ≡ pos 3)
M-a-row = refl , refl , refl , refl

M-c-row : (M c e ≡ pos 0) × (M c a ≡ pos 6)
        × (M c c ≡ negsuc 0) × (M c d ≡ negsuc 0)
M-c-row = refl , refl , refl , refl

M-d-row : (M d e ≡ pos 0) × (M d a ≡ pos 0)
        × (M d c ≡ negsuc 3) × (M d d ≡ negsuc 3)
M-d-row = refl , refl , refl , refl

-- The state multiplication itself is associative.  This is useful provenance:
-- the later nonassociativity is not smuggled in at the execution layer.
·C-assoc : (x y z : Cell) → (x ·C y) ·C z ≡ x ·C (y ·C z)
·C-assoc e e e = refl
·C-assoc e e a = refl
·C-assoc e e c = refl
·C-assoc e e d = refl
·C-assoc e a e = refl
·C-assoc e a a = refl
·C-assoc e a c = refl
·C-assoc e a d = refl
·C-assoc e c e = refl
·C-assoc e c a = refl
·C-assoc e c c = refl
·C-assoc e c d = refl
·C-assoc e d e = refl
·C-assoc e d a = refl
·C-assoc e d c = refl
·C-assoc e d d = refl
·C-assoc a e e = refl
·C-assoc a e a = refl
·C-assoc a e c = refl
·C-assoc a e d = refl
·C-assoc a a e = refl
·C-assoc a a a = refl
·C-assoc a a c = refl
·C-assoc a a d = refl
·C-assoc a c e = refl
·C-assoc a c a = refl
·C-assoc a c c = refl
·C-assoc a c d = refl
·C-assoc a d e = refl
·C-assoc a d a = refl
·C-assoc a d c = refl
·C-assoc a d d = refl
·C-assoc c e e = refl
·C-assoc c e a = refl
·C-assoc c e c = refl
·C-assoc c e d = refl
·C-assoc c a e = refl
·C-assoc c a a = refl
·C-assoc c a c = refl
·C-assoc c a d = refl
·C-assoc c c e = refl
·C-assoc c c a = refl
·C-assoc c c c = refl
·C-assoc c c d = refl
·C-assoc c d e = refl
·C-assoc c d a = refl
·C-assoc c d c = refl
·C-assoc c d d = refl
·C-assoc d e e = refl
·C-assoc d e a = refl
·C-assoc d e c = refl
·C-assoc d e d = refl
·C-assoc d a e = refl
·C-assoc d a a = refl
·C-assoc d a c = refl
·C-assoc d a d = refl
·C-assoc d c e = refl
·C-assoc d c a = refl
·C-assoc d c c = refl
·C-assoc d c d = refl
·C-assoc d d e = refl
·C-assoc d d a = refl
·C-assoc d d c = refl
·C-assoc d d d = refl

-- Delta 29's trefoil/cocycle equation.  All 64 instances reduce from M's
-- definition and the table; no separate axiom enters.
trefoil : (x y z : Cell)
  → M (x ·C y) z +ℤ M x y ≡ M x (y ·C z) +ℤ M y z
trefoil e e e = refl
trefoil e e a = refl
trefoil e e c = refl
trefoil e e d = refl
trefoil e a e = refl
trefoil e a a = refl
trefoil e a c = refl
trefoil e a d = refl
trefoil e c e = refl
trefoil e c a = refl
trefoil e c c = refl
trefoil e c d = refl
trefoil e d e = refl
trefoil e d a = refl
trefoil e d c = refl
trefoil e d d = refl
trefoil a e e = refl
trefoil a e a = refl
trefoil a e c = refl
trefoil a e d = refl
trefoil a a e = refl
trefoil a a a = refl
trefoil a a c = refl
trefoil a a d = refl
trefoil a c e = refl
trefoil a c a = refl
trefoil a c c = refl
trefoil a c d = refl
trefoil a d e = refl
trefoil a d a = refl
trefoil a d c = refl
trefoil a d d = refl
trefoil c e e = refl
trefoil c e a = refl
trefoil c e c = refl
trefoil c e d = refl
trefoil c a e = refl
trefoil c a a = refl
trefoil c a c = refl
trefoil c a d = refl
trefoil c c e = refl
trefoil c c a = refl
trefoil c c c = refl
trefoil c c d = refl
trefoil c d e = refl
trefoil c d a = refl
trefoil c d c = refl
trefoil c d d = refl
trefoil d e e = refl
trefoil d e a = refl
trefoil d e c = refl
trefoil d e d = refl
trefoil d a e = refl
trefoil d a a = refl
trefoil d a c = refl
trefoil d a d = refl
trefoil d c e = refl
trefoil d c a = refl
trefoil d c c = refl
trefoil d c d = refl
trefoil d d e = refl
trefoil d d a = refl
trefoil d d c = refl
trefoil d d d = refl

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: execution multiplication, associativity, potential, the complete
-- derived M table, and every trefoil instance.
--
-- Not checked here: Delta 29's principal left closures or their one-sided
-- product.  The reported vectors alone are outputs, not a definition of that
-- product.  Formalizing them as constants would plant the counterexample
-- instead of deriving it; an exact closure/product definition is required.
------------------------------------------------------------------------
