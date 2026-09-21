{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समान-मूल — the common source.
--
-- IF THE COMMUTATOR WITH A DIRECTION MOVES THE SOURCE, THEN IT MOVES IT
-- AGAIN, AND SUMMING THE DOUBLED COMMUTATOR OVER THE DIRECTIONS PUTS THE
-- SOURCE'S LAPLACIAN IN THE SLOT.
--
-- A state-dependent operator `Π u` is TRANSLATION COVARIANT when
-- differentiating it in a direction is the same as differentiating the
-- state it was built from:
--
--     [ D , Π u ]  ≡  Π (∂ u) .
--
-- That single equation is the whole hypothesis of this module.  It is
-- not derived here — it is what a source-linear construction supplies,
-- and it is carried in the open as a parameter.
--
-- What is proved is that the equation ITERATES, and what iteration buys:
--
--   §1  the inner commutator `ad D` is a derivation of the ring — it is
--       additive, and it satisfies Leibniz for the ring product.  Both
--       from the ring axioms, with no hypothesis on `D` whatsoever.
--
--   §2  ad D ^ n (Π u) ≡ Π (∂ ^ n u) , every n .
--
--   §3  in particular [ D , [ D , Π u ] ] ≡ Π (∂ (∂ u)) : the doubled
--       commutator sees the SECOND derivative of the source and nothing
--       else.  No first-order term survives, and no cross term appears —
--       the source slot is linear, so there is no product to cross.
--
--   §4  and therefore, summing over a family of directions Dⱼ with
--       matching ∂ⱼ, and with `Π` additive,
--
--         Σⱼ [ Dⱼ , [ Dⱼ , Π u ] ]  ≡  Π ( Σⱼ ∂ⱼ (∂ⱼ u) ) ,
--
--       which is the Laplacian statement: the second-order transport of
--       the operator is the operator at the Laplacian of its source.
--       The sum is a finite fold over the first `k` directions; `k` is
--       arbitrary and no dimension is fixed anywhere.
--
--   §5  the PRODUCT is where a cross term does appear, and §1 hands the
--       computation straight to `DvitiyaLeibniz`.  Instantiating that
--       module's second-order defect at `d := ad D` and `br := _·_`, and
--       then rewriting every occurrence by covariance:
--
--         ( ad² (Π u · Π v)  ⊖  Π u · Π (∂ (∂ v)) )  ⊖  Π (∂ (∂ u)) · Π v
--           ≡  Π (∂ u) · Π (∂ v)  +  Π (∂ u) · Π (∂ v) .
--
--       So the whole second-order defect of a product of two covariant
--       operators is carried by the pair of ONCE-differentiated sources,
--       doubled.  The two second derivatives are exactly the subtracted
--       terms; nothing else is left.
--
-- WHY §1 IS THE LOAD-BEARING LINE.  `DvitiyaLeibniz` is stated for an
-- abstract additive `d` obeying a Leibniz law, and deliberately assumes
-- nothing about where such a `d` comes from.  §1 supplies one: in ANY
-- ring, every element `D` generates a derivation by commutation.  So the
-- second-order defect theorem applies to transport by a direction with
-- no further hypothesis — the derivation property is not an assumption
-- about the physics, it is a fact about rings.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 in an arbitrary ring, for every `D`.
-- §§2–3 for every state type, every `Π`, every `∂`, and every `D`
-- satisfying the displayed covariance equation.  §4 additionally for a
-- family of directions each with its own covariance, and for `Π`
-- additive — additivity is a hypothesis, carried, not discharged.  §5
-- for every pair of states.  NOT claimed: that any particular `Π` is
-- covariant, which is the modelling step and happens elsewhere; nothing
-- about the Jacobi identity, about Lie–Poisson structure, or about any
-- naturality of `Π` under a flow; nothing about ℝ, positivity, or any
-- analytic estimate; no self-adjointness — `†` does not appear in this
-- file; and no equation of motion — `∂` here is a direction, not time.
------------------------------------------------------------------------

module SamanaMula_TranslationCovarianceIteratesSoTheSummedDoubleCommutatorIsTheSourcesLaplacianAndTheProductDefectIsTheDifferentiatedPair where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

import DvitiyaLeibniz_TheSecondOrderDefectOfADerivationIsExactlyTwiceTheCrossTermSoALaplacianSeesOnlyTheProduct as DL

private
  variable
    ℓ ℓ' : Level

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

    infixl 6 _⊖_
    _⊖_ : A → A → A
    x ⊖ y = x + (- y)

    -- the one additive cancellation §1 needs
    mid : (a m b : A) → (a ⊖ m) + (m ⊖ b) ≡ a ⊖ b
    mid a m b =
        (a + (- m)) + (m + (- b))
      ≡⟨ sym (+Assoc a (- m) (m + (- b))) ⟩
        a + ((- m) + (m + (- b)))
      ≡⟨ cong (a +_) (+Assoc (- m) m (- b)) ⟩
        a + (((- m) + m) + (- b))
      ≡⟨ cong (λ z → a + (z + (- b))) (+InvL m) ⟩
        a + (0r + (- b))
      ≡⟨ cong (a +_) (+IdL (- b)) ⟩
        a + (- b) ∎

  --------------------------------------------------------------------
  -- ० · Transport in a direction: the inner commutator.
  --------------------------------------------------------------------

  ad : A → A → A                          -- ad D x = [ D , x ]
  ad D x = (D · x) ⊖ (x · D)

  --------------------------------------------------------------------
  -- १ · EVERY DIRECTION IS A DERIVATION.  No hypothesis on `D`.
  --------------------------------------------------------------------

  ad-+ : (D x y : A) → ad D (x + y) ≡ ad D x + ad D y
  ad-+ D x y =
      (D · (x + y)) + (- ((x + y) · D))
    ≡⟨ cong₂ (λ p q → p + (- q)) (·DistR+ D x y) (·DistL+ x y D) ⟩
      ((D · x) + (D · y)) + (- ((x · D) + (y · D)))
    ≡⟨ cong (((D · x) + (D · y)) +_) (sym (-Dist (x · D) (y · D))) ⟩
      ((D · x) + (D · y)) + ((- (x · D)) + (- (y · D)))
    ≡⟨ +ShufflePairs (D · x) (D · y) (- (x · D)) (- (y · D)) ⟩
      ((D · x) + (- (x · D))) + ((D · y) + (- (y · D))) ∎

  ad-leibniz : (D x y : A) → ad D (x · y) ≡ (ad D x · y) + (x · ad D y)
  ad-leibniz D x y =
      (D · (x · y)) ⊖ ((x · y) · D)
    ≡⟨ sym (mid (D · (x · y)) (x · (D · y)) ((x · y) · D)) ⟩
      ((D · (x · y)) ⊖ (x · (D · y))) + ((x · (D · y)) ⊖ ((x · y) · D))
    ≡⟨ cong₂ _+_ (sym leftFactor) (sym rightFactor) ⟩
      (ad D x · y) + (x · ad D y) ∎
    where
      leftFactor : ad D x · y ≡ (D · (x · y)) ⊖ (x · (D · y))
      leftFactor =
          ((D · x) + (- (x · D))) · y
        ≡⟨ ·DistL+ (D · x) (- (x · D)) y ⟩
          ((D · x) · y) + ((- (x · D)) · y)
        ≡⟨ cong₂ _+_ (sym (·Assoc D x y))
                     (-DistL· (x · D) y ∙ cong (λ z → - z) (sym (·Assoc x D y))) ⟩
          (D · (x · y)) + (- (x · (D · y))) ∎

      rightFactor : x · ad D y ≡ (x · (D · y)) ⊖ ((x · y) · D)
      rightFactor =
          x · ((D · y) + (- (y · D)))
        ≡⟨ ·DistR+ x (D · y) (- (y · D)) ⟩
          (x · (D · y)) + (x · (- (y · D)))
        ≡⟨ cong ((x · (D · y)) +_)
                (-DistR· x (y · D) ∙ cong (λ z → - z) (·Assoc x y D)) ⟩
          (x · (D · y)) + (- ((x · y) · D)) ∎

  --------------------------------------------------------------------
  -- The source and the operator it builds.  `Π` is completely
  -- arbitrary: no linearity is assumed until §4 asks for it.
  --------------------------------------------------------------------

  module _ (U : Type ℓ') (Π : U → A) where

    ------------------------------------------------------------------
    -- ONE DIRECTION, with its matching motion of the source.
    ------------------------------------------------------------------

    module _ (D : A) (∂ : U → U)
             (cov : (u : U) → ad D (Π u) ≡ Π (∂ u))
             where

      adPow : ℕ → A → A
      adPow zero    x = x
      adPow (suc n) x = ad D (adPow n x)

      ∂Pow : ℕ → U → U
      ∂Pow zero    u = u
      ∂Pow (suc n) u = ∂ (∂Pow n u)

      ----------------------------------------------------------------
      -- २ · COVARIANCE ITERATES, at every order.
      ----------------------------------------------------------------

      covariance-iterates : (n : ℕ) (u : U) → adPow n (Π u) ≡ Π (∂Pow n u)
      covariance-iterates zero    u = refl
      covariance-iterates (suc n) u =
        cong (ad D) (covariance-iterates n u) ∙ cov (∂Pow n u)

      ----------------------------------------------------------------
      -- ३ · THE DOUBLED COMMUTATOR IS THE SECOND MOTION OF THE SOURCE.
      ----------------------------------------------------------------

      doubled-commutator : (u : U) → ad D (ad D (Π u)) ≡ Π (∂ (∂ u))
      doubled-commutator u = covariance-iterates 2 u

      ----------------------------------------------------------------
      -- ५ · THE PRODUCT DEFECT.  §1 makes `ad D` a derivation, so
      --     `DvitiyaLeibniz` applies verbatim; covariance then converts
      --     every term into the source language.
      ----------------------------------------------------------------

      product-defect : (u v : U)
        → ((ad D (ad D (Π u · Π v)) ⊖ (Π u · Π (∂ (∂ v)))) ⊖ (Π (∂ (∂ u)) · Π v))
          ≡ (Π (∂ u) · Π (∂ v)) + (Π (∂ u) · Π (∂ v))
      product-defect u v =
          ((ad D (ad D (Π u · Π v)) ⊖ (Π u · Π (∂ (∂ v)))) ⊖ (Π (∂ (∂ u)) · Π v))
        ≡⟨ cong₂ (λ p q → (ad D (ad D (Π u · Π v)) ⊖ (Π u · p)) ⊖ (q · Π v))
                 (sym (doubled-commutator v)) (sym (doubled-commutator u)) ⟩
          ((ad D (ad D (Π u · Π v)) ⊖ (Π u · ad D (ad D (Π v))))
             ⊖ (ad D (ad D (Π u)) · Π v))
        ≡⟨ DL.second-order-defect R _·_ (ad D) (ad-+ D) (ad-leibniz D) (Π u) (Π v) ⟩
          ((ad D (Π u) · ad D (Π v)) + (ad D (Π u) · ad D (Π v)))
        ≡⟨ cong₂ (λ p q → (p · q) + (p · q)) (cov u) (cov v) ⟩
          ((Π (∂ u) · Π (∂ v)) + (Π (∂ u) · Π (∂ v))) ∎

    ------------------------------------------------------------------
    -- A FAMILY OF DIRECTIONS, and an additive source slot.  `_⊞_` is
    -- the addition of states; `Π-⊞` and `Π-0` say `Π` respects it.
    ------------------------------------------------------------------

    module _ (D : ℕ → A) (∂ : ℕ → U → U)
             (cov : (j : ℕ) (u : U) → ad (D j) (Π u) ≡ Π (∂ j u))
             (_⊞_ : U → U → U) (0u : U)
             (Π-⊞ : (u v : U) → Π (u ⊞ v) ≡ Π u + Π v)
             (Π-0 : Π 0u ≡ 0r)
             where

      sumR : ℕ → (ℕ → A) → A
      sumR zero    f = 0r
      sumR (suc k) f = f k + sumR k f

      sumU : ℕ → (ℕ → U) → U
      sumU zero    g = 0u
      sumU (suc k) g = g k ⊞ sumU k g

      Π-sum : (k : ℕ) (g : ℕ → U) → Π (sumU k g) ≡ sumR k (λ j → Π (g j))
      Π-sum zero    g = Π-0
      Π-sum (suc k) g = Π-⊞ (g k) (sumU k g) ∙ cong (Π (g k) +_) (Π-sum k g)

      sumR-cong : (k : ℕ) (f g : ℕ → A)
        → ((j : ℕ) → f j ≡ g j) → sumR k f ≡ sumR k g
      sumR-cong zero    f g h = refl
      sumR-cong (suc k) f g h = cong₂ _+_ (h k) (sumR-cong k f g h)

      double-at : (j : ℕ) (u : U) → ad (D j) (ad (D j) (Π u)) ≡ Π (∂ j (∂ j u))
      double-at j u = cong (ad (D j)) (cov j u) ∙ cov j (∂ j u)

      ----------------------------------------------------------------
      -- ४ · THE SUMMED DOUBLE COMMUTATOR IS THE SOURCE'S LAPLACIAN.
      ----------------------------------------------------------------

      laplacian-covariance : (k : ℕ) (u : U)
        → sumR k (λ j → ad (D j) (ad (D j) (Π u)))
          ≡ Π (sumU k (λ j → ∂ j (∂ j u)))
      laplacian-covariance k u =
          sumR-cong k (λ j → ad (D j) (ad (D j) (Π u)))
                      (λ j → Π (∂ j (∂ j u)))
                      (λ j → double-at j u)
        ∙ sym (Π-sum k (λ j → ∂ j (∂ j u)))
