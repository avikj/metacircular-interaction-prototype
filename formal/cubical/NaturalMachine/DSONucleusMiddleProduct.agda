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
-- NaturalMachine.DSONucleusMiddleProduct
--
-- Delta 29's middle Isbell operator on the exact four-cell calibration.
-- The finite test family below is explicitly generated; it is not identified
-- with any paper's principal middle profiles.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusMiddleProduct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; min)
  renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)

import NaturalMachine.DSONucleusExecutionCalibration as E
import NaturalMachine.DSONucleusOneSidedProduct as L

Profile : Type₀
Profile = L.Profile

PairProfile : Type₀
PairProfile = E.Cell → E.Cell → ℤ

M3 : E.Cell → E.Cell → E.Cell → ℤ
M3 x b z =
  E.potential ((x E.·C b) E.·C z)
  -ℤ E.potential x -ℤ E.potential b -ℤ E.potential z

-- The ternary defect has both trefoil decompositions.
M3-left : (x b z : E.Cell)
  → M3 x b z ≡ E.M (x E.·C b) z +ℤ E.M x b
M3-left E.e E.e E.e = refl
M3-left E.e E.e E.a = refl
M3-left E.e E.e E.c = refl
M3-left E.e E.e E.d = refl
M3-left E.e E.a E.e = refl
M3-left E.e E.a E.a = refl
M3-left E.e E.a E.c = refl
M3-left E.e E.a E.d = refl
M3-left E.e E.c E.e = refl
M3-left E.e E.c E.a = refl
M3-left E.e E.c E.c = refl
M3-left E.e E.c E.d = refl
M3-left E.e E.d E.e = refl
M3-left E.e E.d E.a = refl
M3-left E.e E.d E.c = refl
M3-left E.e E.d E.d = refl
M3-left E.a E.e E.e = refl
M3-left E.a E.e E.a = refl
M3-left E.a E.e E.c = refl
M3-left E.a E.e E.d = refl
M3-left E.a E.a E.e = refl
M3-left E.a E.a E.a = refl
M3-left E.a E.a E.c = refl
M3-left E.a E.a E.d = refl
M3-left E.a E.c E.e = refl
M3-left E.a E.c E.a = refl
M3-left E.a E.c E.c = refl
M3-left E.a E.c E.d = refl
M3-left E.a E.d E.e = refl
M3-left E.a E.d E.a = refl
M3-left E.a E.d E.c = refl
M3-left E.a E.d E.d = refl
M3-left E.c E.e E.e = refl
M3-left E.c E.e E.a = refl
M3-left E.c E.e E.c = refl
M3-left E.c E.e E.d = refl
M3-left E.c E.a E.e = refl
M3-left E.c E.a E.a = refl
M3-left E.c E.a E.c = refl
M3-left E.c E.a E.d = refl
M3-left E.c E.c E.e = refl
M3-left E.c E.c E.a = refl
M3-left E.c E.c E.c = refl
M3-left E.c E.c E.d = refl
M3-left E.c E.d E.e = refl
M3-left E.c E.d E.a = refl
M3-left E.c E.d E.c = refl
M3-left E.c E.d E.d = refl
M3-left E.d E.e E.e = refl
M3-left E.d E.e E.a = refl
M3-left E.d E.e E.c = refl
M3-left E.d E.e E.d = refl
M3-left E.d E.a E.e = refl
M3-left E.d E.a E.a = refl
M3-left E.d E.a E.c = refl
M3-left E.d E.a E.d = refl
M3-left E.d E.c E.e = refl
M3-left E.d E.c E.a = refl
M3-left E.d E.c E.c = refl
M3-left E.d E.c E.d = refl
M3-left E.d E.d E.e = refl
M3-left E.d E.d E.a = refl
M3-left E.d E.d E.c = refl
M3-left E.d E.d E.d = refl

M3-right : (x b z : E.Cell)
  → M3 x b z ≡ E.M x (b E.·C z) +ℤ E.M b z
M3-right x b z = M3-left x b z ∙ E.trefoil x b z

min16 : ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ
      → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ
min16 a b c d e f g h i j k l m n o p =
  min (L.min4 a b c d) (min (L.min4 e f g h)
    (min (L.min4 i j k l) (L.min4 m n o p)))

Nstar : Profile → PairProfile
Nstar f x z =
  L.min4 (M3 x E.e z -ℤ f E.e)
         (M3 x E.a z -ℤ f E.a)
         (M3 x E.c z -ℤ f E.c)
         (M3 x E.d z -ℤ f E.d)

Nsub : PairProfile → Profile
Nsub g b =
  min16
    (M3 E.e b E.e -ℤ g E.e E.e) (M3 E.e b E.a -ℤ g E.e E.a)
    (M3 E.e b E.c -ℤ g E.e E.c) (M3 E.e b E.d -ℤ g E.e E.d)
    (M3 E.a b E.e -ℤ g E.a E.e) (M3 E.a b E.a -ℤ g E.a E.a)
    (M3 E.a b E.c -ℤ g E.a E.c) (M3 E.a b E.d -ℤ g E.a E.d)
    (M3 E.c b E.e -ℤ g E.c E.e) (M3 E.c b E.a -ℤ g E.c E.a)
    (M3 E.c b E.c -ℤ g E.c E.c) (M3 E.c b E.d -ℤ g E.c E.d)
    (M3 E.d b E.e -ℤ g E.d E.e) (M3 E.d b E.a -ℤ g E.d E.a)
    (M3 E.d b E.c -ℤ g E.d E.c) (M3 E.d b E.d -ℤ g E.d E.d)

clMid : Profile → Profile
clMid f = Nsub (Nstar f)

_⊙M_ : Profile → Profile → Profile
f ⊙M g = clMid (L.rawConvolution f g)

------------------------------------------------------------------------
-- A clearly defined finite generated family
------------------------------------------------------------------------

zeroSeed : Profile
zeroSeed _ = pos 0

leftZero : Profile
leftZero = L.clL zeroSeed

leftControl : Profile
leftControl = L.clL L.control

leftZero-closed : L.clL leftZero ≡ leftZero
leftZero-closed = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

leftControl-closed : L.clL leftControl ≡ leftControl
leftControl-closed = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

data Generator : Type₀ where
  genZero genA genC genControl : Generator

leftSeed : Generator → Profile
leftSeed genZero = leftZero
leftSeed genA = L.ell-a
leftSeed genC = L.ell-c
leftSeed genControl = leftControl

middleSeed : Generator → Profile
middleSeed generator = clMid (leftSeed generator)

-- Closure idempotence is checked on every generated member.
generated-middle-closed : (generator : Generator)
  → clMid (middleSeed generator) ≡ middleSeed generator
generated-middle-closed genZero =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
generated-middle-closed genA =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
generated-middle-closed genC =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
generated-middle-closed genControl =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: M3, both trefoil decompositions, exact middle Isbell operators,
-- and idempotence on the four explicitly generated middle profiles.
-- The associativity classification of their generated products follows in a
-- separate finite audit so a failed equality remains visible rather than
-- blocking this operator definition.
------------------------------------------------------------------------
