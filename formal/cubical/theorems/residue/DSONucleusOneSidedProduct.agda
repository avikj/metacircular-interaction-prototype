{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DSONucleusOneSidedProduct
--
-- Delta 29's left Isbell closure and one-sided product, computed on the exact
-- four-cell execution defect.  Every extremum below is over the full finite
-- fiber dictated by the multiplication table; no reported product vector is
-- inserted into the definitions.
------------------------------------------------------------------------

module DSONucleusOneSidedProduct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; min ; max)
  renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

import DSONucleusExecutionCalibration as E

Profile : Type₀
Profile = E.Cell → ℤ

min4 : ℤ → ℤ → ℤ → ℤ → ℤ
min4 w x y z = min (min w x) (min y z)

max6 : ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ
max6 u v w x y z = max (max (max u v) (max w x)) (max y z)

Mstar : Profile → Profile
Mstar f b =
  min4 (E.M E.e b -ℤ f E.e)
       (E.M E.a b -ℤ f E.a)
       (E.M E.c b -ℤ f E.c)
       (E.M E.d b -ℤ f E.d)

Msub : Profile → Profile
Msub g cell =
  min4 (E.M cell E.e -ℤ g E.e)
       (E.M cell E.a -ℤ g E.a)
       (E.M cell E.c -ℤ g E.c)
       (E.M cell E.d -ℤ g E.d)

clL : Profile → Profile
clL f = Msub (Mstar f)

term : Profile → Profile → E.Cell → E.Cell → ℤ
term f g left right = f left +ℤ g right -ℤ E.M left right

-- Multiplication fibers, read from E._·C_.  e and a have two factorizations;
-- c and d have six.  Thus no empty-fiber convention or infinity is needed.
rawConvolution : Profile → Profile → Profile
rawConvolution f g E.e =
  max (term f g E.e E.e) (term f g E.a E.a)
rawConvolution f g E.a =
  max (term f g E.e E.a) (term f g E.a E.e)
rawConvolution f g E.c =
  max6 (term f g E.e E.c) (term f g E.a E.c)
       (term f g E.c E.e) (term f g E.c E.c)
       (term f g E.d E.a) (term f g E.d E.c)
rawConvolution f g E.d =
  max6 (term f g E.e E.d) (term f g E.a E.d)
       (term f g E.c E.a) (term f g E.c E.d)
       (term f g E.d E.e) (term f g E.d E.d)

_⊙L_ : Profile → Profile → Profile
f ⊙L g = clL (rawConvolution f g)

------------------------------------------------------------------------
-- Principal left-closed calibration profiles supplied by Delta 29
------------------------------------------------------------------------

ell-c ell-a : Profile
ell-c E.e = negsuc 5
ell-c E.a = pos 0
ell-c E.c = pos 0
ell-c E.d = negsuc 5

ell-a E.e = negsuc 5
ell-a E.a = pos 0
ell-a E.c = negsuc 3
ell-a E.d = negsuc 6

-- They really lie in the left nucleus for the execution-derived M.
ell-c-closed : clL ell-c ≡ ell-c
ell-c-closed = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

ell-a-closed : clL ell-a ≡ ell-a
ell-a-closed = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

control : Profile
control E.e = negsuc 5
control E.a = negsuc 2
control E.c = negsuc 2
control E.d = negsuc 5

-- Both product orders derive the same control profile (-6,-3,-3,-6).
ell-c⊙ell-a : ell-c ⊙L ell-a ≡ control
ell-c⊙ell-a = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

ell-a⊙ell-c : ell-a ⊙L ell-c ≡ control
ell-a⊙ell-c = funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

leftAssociated rightAssociated : Profile
leftAssociated = (ell-c ⊙L ell-a) ⊙L ell-c
rightAssociated = ell-c ⊙L (ell-a ⊙L ell-c)

left-associated-values :
  (leftAssociated E.e ≡ negsuc 7)
  × ((leftAssociated E.a ≡ negsuc 1)
  × ((leftAssociated E.c ≡ negsuc 1)
  × (leftAssociated E.d ≡ negsuc 7)))
left-associated-values = refl , (refl , (refl , refl))

right-associated-values :
  (rightAssociated E.e ≡ negsuc 4)
  × ((rightAssociated E.a ≡ negsuc 1)
  × ((rightAssociated E.c ≡ negsuc 1)
  × (rightAssociated E.d ≡ negsuc 4)))
right-associated-values = refl , (refl , (refl , refl))

minus-eight≢minus-five : ¬ (negsuc 7 ≡ negsuc 4)
minus-eight≢minus-five path = subst distinguish path tt
  where
  distinguish : ℤ → Type₀
  distinguish (pos _) = ⊥
  distinguish (negsuc 4) = ⊥
  distinguish (negsuc _) = Unit

one-sided-product-is-not-associative :
  ¬ (((ell-c ⊙L ell-a) ⊙L ell-c) ≡ (ell-c ⊙L (ell-a ⊙L ell-c)))
one-sided-product-is-not-associative equality =
  minus-eight≢minus-five
    (sym (fst left-associated-values)
    ∙ cong (λ profile → profile E.e) equality
    ∙ fst right-associated-values)

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: finite Isbell operators, left closure, raw convolution over every
-- exact factorization, closure of the two calibration profiles, both control
-- products, and the explicit associator defect (-8 versus -5 at e).
--
-- Not claimed: the middle closure or a ternary repair; Delta 29's ternary
-- profile formula has not entered this module.
------------------------------------------------------------------------
