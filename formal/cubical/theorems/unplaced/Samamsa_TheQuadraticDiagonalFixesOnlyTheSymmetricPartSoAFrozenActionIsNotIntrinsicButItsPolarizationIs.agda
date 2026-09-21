{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समांश — the symmetric part.
--
-- THE QUADRATIC DIAGONAL DOES NOT DETERMINE ITS BILINEAR REALIZATION.
-- WHAT IT DETERMINES IS THE POLARIZATION, AND THAT IS THE DERIVATIVE.
--
-- `ActionResidual` records that a residual `q (step x) - predict (q x)`
-- is deliberately RELATIVE to a declared predictor: without one there is
-- behaviour but "no preferred origin for its second coordinate".  This
-- module is that observation for bilinear realizations of a quadratic
-- map, where the same thing happens and the preferred origin exists.
--
-- Given a two-argument map `b`, its DIAGONAL `diag b x = b x x` is the
-- autonomous object — the quadratic field.  Two facts, in opposite
-- directions:
--
--   §1  THE SYMMETRIZATION IS DETERMINED BY THE DIAGONAL.
--         b x y + b y x ≡ diag b (x + y) - (diag b x + diag b y) .
--       Every realization of one diagonal has the SAME symmetrization,
--       so the polarization — hence the derivative of the quadratic
--       field, which is that symmetrization — is intrinsic.  §1 needs
--       no division by two: it is stated on `b x y + b y x` rather than
--       on half of it, so it holds over any ring, ℤ and ℕ-graded ones
--       included.
--
--   §2  THE FROZEN ACTION IS NOT.  Two realizations of one diagonal
--       differ by an ALTERNATING map (§2a), and alternating maps are
--       exactly those with vanishing diagonal — which is why they are
--       invisible to the autonomous field.  §2b is the sharp form: at
--       any point x₀ and for ANY additive `G` annihilating x₀, there is
--       an alternating `a` with
--
--         a x₀ y ≡ G y ,
--
--       built explicitly from a functional ℓ with ℓ x₀ ≡ 1.  So `b + a`
--       has the same diagonal as `b` — the same autonomous equation —
--       while its frozen action at x₀ is `b x₀ - + G`, with G arbitrary
--       on the complement.  Freezing one argument of a realization and
--       reading off its response to arbitrary test inputs is therefore
--       reading a coordinate that the autonomous field does not fix.
--
-- The consequence for a two-sector reading: a frozen `A_u` and its
-- transpose-like partner `K_u` may each reproduce the field on its own
-- source and still differ off it; only their SUM is the variation of
-- the common source.  §1 is why the sum is the invariant one.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–2 in an arbitrary ring, with the
-- carrier taken as the ring itself, `additive` meaning preservation of
-- `+`, and bilinearity assumed only in the slots each statement uses.
-- NOT claimed: anything about the affine-space structure of the
-- realization fibre over `Hom(Λ² V , W)` (that needs the exterior
-- square, which is not built here); anything about vector spaces,
-- topology, or any particular equation; and nothing about halving —
-- every statement is on the symmetrized quantity, never on a half of
-- it, so no invertibility of 2 is used anywhere.
------------------------------------------------------------------------

module Samamsa_TheQuadraticDiagonalFixesOnlyTheSymmetricPartSoAFrozenActionIsNotIntrinsicButItsPolarizationIs where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Data.Sigma using (_×_ ; _,_)

private
  variable
    ℓ' : Level

module _ (R : Ring ℓ') where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ'
    A = ⟨ R ⟩

    infixl 6 _⊖_
    _⊖_ : A → A → A
    x ⊖ y = x + (- y)

  --------------------------------------------------------------------
  -- ० · Additivity in each slot, and the diagonal.
  --------------------------------------------------------------------

  Additive : (A → A) → Type ℓ'
  Additive f = (x y : A) → f (x + y) ≡ f x + f y

  AddL : (A → A → A) → Type ℓ'
  AddL b = (x y z : A) → b (x + y) z ≡ b x z + b y z

  AddR : (A → A → A) → Type ℓ'
  AddR b = (x y z : A) → b x (y + z) ≡ b x y + b x z

  diag : (A → A → A) → A → A
  diag b x = b x x

  --------------------------------------------------------------------
  -- १ · THE SYMMETRIZATION IS A FUNCTION OF THE DIAGONAL ALONE.
  --
  --   diag b (x + y) = b x x + b x y + b y x + b y y ,
  --
  -- so subtracting the two pure terms leaves exactly the symmetrization.
  -- Stated with the subtraction on the diagonal side, so that the result
  -- is an equation between the symmetrization and an expression in
  -- `diag b` only.
  --------------------------------------------------------------------

  module _ (b : A → A → A) (aL : AddL b) (aR : AddR b) where

    diag-expands : (x y : A)
      → diag b (x + y) ≡ ((diag b x + b x y) + b y x) + diag b y
    diag-expands x y =
        b (x + y) (x + y)
      ≡⟨ aL x y (x + y) ⟩
        b x (x + y) + b y (x + y)
      ≡⟨ cong₂ _+_ (aR x x y) (aR y x y) ⟩
        (b x x + b x y) + (b y x + b y y)
      ≡⟨ +Assoc (b x x + b x y) (b y x) (b y y) ⟩
        ((b x x + b x y) + b y x) + b y y ∎

    -- the symmetrization, recovered from the diagonal
    polarization-from-diagonal : (x y : A)
      → (b x y + b y x) ≡ (diag b (x + y) ⊖ diag b y) ⊖ diag b x
    polarization-from-diagonal x y =
        (b x y + b y x)
      ≡⟨ sym (+IdL (b x y + b y x)) ⟩
        0r + (b x y + b y x)
      ≡⟨ cong (_+ (b x y + b y x)) (sym (+InvL (diag b x))) ⟩
        ((- diag b x) + diag b x) + (b x y + b y x)
      ≡⟨ sym (+Assoc (- diag b x) (diag b x) (b x y + b y x)) ⟩
        (- diag b x) + (diag b x + (b x y + b y x))
      ≡⟨ cong (λ z → (- diag b x) + z) (+Assoc (diag b x) (b x y) (b y x)) ⟩
        (- diag b x) + ((diag b x + b x y) + b y x)
      ≡⟨ cong (λ z → (- diag b x) + z) (lem x y) ⟩
        (- diag b x) + (diag b (x + y) ⊖ diag b y)
      ≡⟨ +Comm (- diag b x) (diag b (x + y) ⊖ diag b y) ⟩
        (diag b (x + y) ⊖ diag b y) ⊖ diag b x ∎
      where
        lem : (x y : A)
          → ((diag b x + b x y) + b y x) ≡ (diag b (x + y) ⊖ diag b y)
        lem x y =
            ((diag b x + b x y) + b y x)
          ≡⟨ sym (+IdR _) ⟩
            (((diag b x + b x y) + b y x) + 0r)
          ≡⟨ cong (((diag b x + b x y) + b y x) +_) (sym (+InvR (diag b y))) ⟩
            (((diag b x + b x y) + b y x) + (diag b y + (- diag b y)))
          ≡⟨ +Assoc _ _ _ ⟩
            ((((diag b x + b x y) + b y x) + diag b y) + (- diag b y))
          ≡⟨ cong (_+ (- diag b y)) (sym (diag-expands x y)) ⟩
            (diag b (x + y) ⊖ diag b y) ∎

  --------------------------------------------------------------------
  -- २a · TWO REALIZATIONS OF ONE DIAGONAL DIFFER BY AN ALTERNATING MAP.
  --
  -- Vanishing diagonal forces antisymmetry, with no division: expanding
  -- `d (x+y) (x+y) ≡ 0r` leaves `d x y + d y x ≡ 0r` directly.
  --------------------------------------------------------------------

  module _ (d : A → A → A) (aL : AddL d) (aR : AddR d) where

    zero-diagonal→antisymmetric :
        ((x : A) → diag d x ≡ 0r)
      → (x y : A) → (d x y + d y x) ≡ 0r
    zero-diagonal→antisymmetric z x y =
        (d x y + d y x)
      ≡⟨ polarization-from-diagonal d aL aR x y ⟩
        (diag d (x + y) ⊖ diag d y) ⊖ diag d x
      ≡⟨ cong (λ w → (w ⊖ diag d y) ⊖ diag d x) (z (x + y)) ⟩
        (0r ⊖ diag d y) ⊖ diag d x
      ≡⟨ cong (λ w → (0r ⊖ w) ⊖ diag d x) (z y) ⟩
        (0r ⊖ 0r) ⊖ diag d x
      ≡⟨ cong (λ w → (0r ⊖ 0r) ⊖ w) (z x) ⟩
        (0r ⊖ 0r) ⊖ 0r
      ≡⟨ cong (_⊖ 0r) (+InvR 0r) ⟩
        0r ⊖ 0r
      ≡⟨ +InvR 0r ⟩
        0r ∎

  --------------------------------------------------------------------
  -- २b · AND THE FROZEN ACTION CAN BE MOVED ARBITRARILY OFF THE SOURCE.
  --
  -- Given ℓ with ℓ x₀ ≡ 1 and any G with G x₀ ≡ 0, put
  --
  --     a x y = (ℓ x · G y) ⊖ (ℓ y · G x) .
  --
  -- Then a has vanishing diagonal — so `b + a` and `b` have the same
  -- diagonal, the same autonomous field — and yet
  --
  --     a x₀ y ≡ G y ,
  --
  -- so the frozen action at x₀ has been shifted by G, which was
  -- arbitrary subject only to killing x₀.
  --------------------------------------------------------------------

  shift : (A → A) → (A → A) → (A → A → A)
  shift ℓ G x y = (ℓ x · G y) ⊖ (ℓ y · G x)

  -- vanishing diagonal: invisible to the autonomous field
  shift-diagonal-zero : (ℓ G : A → A) (x : A) → diag (shift ℓ G) x ≡ 0r
  shift-diagonal-zero ℓ G x = +InvR (ℓ x · G x)

  -- so adding it does not change the diagonal at all
  shift-preserves-diagonal :
      (b : A → A → A) (ℓ G : A → A) (x : A)
    → diag (λ p q → b p q + shift ℓ G p q) x ≡ diag b x
  shift-preserves-diagonal b ℓ G x =
      (b x x + shift ℓ G x x)
    ≡⟨ cong (b x x +_) (shift-diagonal-zero ℓ G x) ⟩
      (b x x + 0r)
    ≡⟨ +IdR (b x x) ⟩
      b x x ∎

  -- and at x₀ it IS G
  shift-at-source :
      (ℓ G : A → A) (x₀ : A)
    → (ℓ x₀ ≡ 1r) → (G x₀ ≡ 0r)
    → (y : A) → shift ℓ G x₀ y ≡ G y
  shift-at-source ℓ G x₀ hℓ hG y =
      ((ℓ x₀ · G y) ⊖ (ℓ y · G x₀))
    ≡⟨ cong (λ z → (z · G y) ⊖ (ℓ y · G x₀)) hℓ ⟩
      ((1r · G y) ⊖ (ℓ y · G x₀))
    ≡⟨ cong (_⊖ (ℓ y · G x₀)) (·IdL (G y)) ⟩
      (G y ⊖ (ℓ y · G x₀))
    ≡⟨ cong (λ z → G y ⊖ (ℓ y · z)) hG ⟩
      (G y ⊖ (ℓ y · 0r))
    ≡⟨ cong (λ z → G y ⊖ z) (0RightAnnihilates (ℓ y)) ⟩
      (G y ⊖ 0r)
    ≡⟨ cong (G y +_) 0Selfinverse ⟩
      (G y + 0r)
    ≡⟨ +IdR (G y) ⟩
      G y ∎

  -- the two together: same autonomous field, frozen action shifted by G
  frozen-action-is-not-intrinsic :
      (b : A → A → A) (ℓ G : A → A) (x₀ : A)
    → (ℓ x₀ ≡ 1r) → (G x₀ ≡ 0r)
    → ((x : A) → diag (λ p q → b p q + shift ℓ G p q) x ≡ diag b x)
    × ((y : A) → (b x₀ y + shift ℓ G x₀ y) ≡ (b x₀ y + G y))
  frozen-action-is-not-intrinsic b ℓ G x₀ hℓ hG =
      shift-preserves-diagonal b ℓ G
    , λ y → cong (b x₀ y +_) (shift-at-source ℓ G x₀ hℓ hG y)
