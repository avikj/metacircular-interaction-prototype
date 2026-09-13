{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- स्मृति-मूल — the root of the memory.
--
-- The finite identities under the first quadrupole memory (handoff
-- §21, §24; [S12],[S16]).  Throughout, ∂ is a derivation on a
-- commutative ring and r is a radius with ∂ r = 1; the toroidal inverse
-- relation  r² g″ + 6 r g′ = −f  defines f from g.
--
--   १  β₂ is exact:   r⁴ g · (5gf + 2rg′f + rgf′) ≡ ∂(r⁵ g² f).
--   २  β₄ is exact:   with f = r² h φ and g = h³,
--                    3rgf′ − 6gf − rg′f ≡ 3 r³ h⁴ ∂φ.
--      So both emitted radial forcings are derivatives of brackets that
--      vanish at the support ends: they are generically signed.
--   ३  the weighted forcing is the memory quadratic plus an exact
--      derivative:   2 r (5gf + 2rg′f + rgf′)
--                     ≡ 2 (9 r g² − r³ g′²) + ∂(−2r⁴gg″ − 18r³gg′ − r⁴g′² − 9r²g²),
--      which is  ∫ r β₂ dr = (6/7) 𝓘[f]  with  𝓘[f] = ∫(9rg² − r³g′²).
--   ४  in log radius (D = r∂ᵣ, so D r = r): with b = r g and F = r f,
--                    F ≡ (4 − 3D − D²) b,      i.e. F = (1 − D)(4 + D) b,
--      and the memory integrand is  9b² − (rDg)² ≡ 8b² − (Db)² + D(b²),
--      i.e. 𝓘[f] = 8‖b‖² − ‖b′‖².
--   ५  the symbol:  |(1 − iξ)(4 + iξ)|² = (4 + ξ²)² + 9ξ² ≡ (1 + ξ²)(16 + ξ²),
--      so 𝓘[f] = (1/2π)∫ (8 − ξ²)/((1+ξ²)(16+ξ²)) |F̂|².
--   ६  the two-radius kernel matrix at radii 1 and 2, scaled by 80, is
--      [[8,11],[11,8]]; 19 and −3 are its eigenvalues.
--
-- Numerals are ι n = 1 + ⋯ + 1, which unfold definitionally, so the
-- ring solver sees them as constants in the `shape` lemmas.
------------------------------------------------------------------------
module SmrtiMula_TheEmittedForcingsAreExactDerivativesTheWeightedQuadrupoleForcingIsTheMemoryQuadraticPlusAnExactDerivativeTheLogRadiusSourceIsAFactoredOperatorAndItsSymbolIsTheProductOfTwoShiftedSquares where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  ι : ℕ → A
  ι zero    = 0r
  ι (suc n) = 1r + ι n

  ----------------------------------------------------------------
  -- ५ · the symbol modulus
  ----------------------------------------------------------------
  symbol-modulus : (ξ : A)
    → (ι 4 + ξ · ξ) · (ι 4 + ξ · ξ) + ι 9 · (ξ · ξ) ≡ (1r + ξ · ξ) · (ι 16 + ξ · ξ)
  symbol-modulus ξ = shape ξ
    where
      shape : (ξ : A) → ((1r + (1r + (1r + (1r + 0r)))) + ξ · ξ) · ((1r + (1r + (1r + (1r + 0r)))) + ξ · ξ) + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))) · (ξ · ξ) ≡ (1r + ξ · ξ) · ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))))))))))) + ξ · ξ)
      shape ξ = solve! R

  ----------------------------------------------------------------
  -- ६ · the scaled kernel matrix [[8,11],[11,8]] at radii 1, 2
  ----------------------------------------------------------------
  kernel-eigenvalue-19 : (ι 8 + (- ι 19)) · (ι 8 + (- ι 19)) + (- (ι 11 · ι 11)) ≡ 0r
  kernel-eigenvalue-19 = shape
    where
      shape : ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))) + (- (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))))))))))))) · ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))) + (- (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))))))))))))) + (- ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))) · (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))))) ≡ 0r
      shape = solve! R

  kernel-eigenvalue-minus-3 : (ι 8 + ι 3) · (ι 8 + ι 3) + (- (ι 11 · ι 11)) ≡ 0r
  kernel-eigenvalue-minus-3 = shape
    where
      shape : ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))) + (1r + (1r + (1r + 0r)))) · ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))) + (1r + (1r + (1r + 0r)))) + (- ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))) · (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))))))) ≡ 0r
      shape = solve! R

  module _ (∂ : A → A)
           (∂-add  : (x y : A) → ∂ (x + y) ≡ ∂ x + ∂ y)
           (∂-leib : (x y : A) → ∂ (x · y) ≡ ∂ x · y + x · ∂ y)
           where

    private
      ∂-zero : ∂ 0r ≡ 0r
      ∂-zero = sym ( sym (+InvR (∂ 0r)) ∙ cong (_+ (- (∂ 0r))) h ∙ cancelR (∂ 0r) (∂ 0r) )
        where
          h : ∂ 0r ≡ ∂ 0r + ∂ 0r
          h = cong ∂ (sym (+IdR 0r)) ∙ ∂-add 0r 0r
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      ∂-neg : (x : A) → ∂ (- x) ≡ - ∂ x
      ∂-neg x = negOf (∂ x) (∂ (- x)) (sym (∂-add x (- x)) ∙ cong ∂ (+InvR x) ∙ ∂-zero)
        where
          negOf : (a b : A) → a + b ≡ 0r → b ≡ - a
          negOf a b h = sym (+IdL b) ∙ cong (_+ b) (sym (+InvL a)) ∙ sym (+Assoc (- a) a b) ∙ cong ((- a) +_) h ∙ +IdR (- a)

      ∂-one : ∂ 1r ≡ 0r
      ∂-one = sym ( sym (+InvR (∂ 1r)) ∙ cong (_+ (- (∂ 1r))) h ∙ cancelR (∂ 1r) (∂ 1r) )
        where
          h : ∂ 1r ≡ ∂ 1r + ∂ 1r
          h = cong ∂ (sym (·IdR 1r)) ∙ ∂-leib 1r 1r ∙ cong₂ _+_ (·IdR (∂ 1r)) (·IdL (∂ 1r))
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      ∂ι : (n : ℕ) → ∂ (ι n) ≡ 0r
      ∂ι zero    = ∂-zero
      ∂ι (suc n) = ∂-add 1r (ι n) ∙ cong₂ _+_ ∂-one (∂ι n) ∙ +IdR 0r

      -- derivative of a numeral multiple
      ∂ιx : (n : ℕ) (x : A) → ∂ (ι n · x) ≡ ι n · ∂ x
      ∂ιx n x = ∂-leib (ι n) x ∙ cong (_+ ι n · ∂ x) (cong (_· x) (∂ι n) ∙ zeroL x) ∙ +IdL (ι n · ∂ x)
        where zeroL : (y : A) → 0r · y ≡ 0r
              zeroL y = solve! R

    ----------------------------------------------------------------
    -- radius:  ∂ r ≡ 1
    ----------------------------------------------------------------
    module _ (r : A) (∂r : ∂ r ≡ 1r) where

      private
        r² r³ r⁴ r⁵ : A
        r² = r · r
        r³ = r² · r
        r⁴ = r³ · r
        r⁵ = r⁴ · r

        ∂r² : ∂ r² ≡ r + r
        ∂r² = ∂-leib r r ∙ cong₂ _+_ (cong (_· r) ∂r ∙ ·IdL r) (cong (r ·_) ∂r ∙ ·IdR r)
        ∂r³ : ∂ r³ ≡ ι 3 · r²
        ∂r³ = ∂-leib r² r ∙ cong₂ _+_ (cong (_· r) ∂r²) (cong (r² ·_) ∂r) ∙ shape
          where shape : (r + r) · r + r² · 1r ≡ (1r + (1r + (1r + 0r))) · r²
                shape = solve! R
        ∂r⁴ : ∂ r⁴ ≡ ι 4 · r³
        ∂r⁴ = ∂-leib r³ r ∙ cong₂ _+_ (cong (_· r) ∂r³) (cong (r³ ·_) ∂r) ∙ shape
          where shape : ((1r + (1r + (1r + 0r))) · r²) · r + r³ · 1r ≡ (1r + (1r + (1r + (1r + 0r)))) · r³
                shape = solve! R
        ∂r⁵ : ∂ r⁵ ≡ ι 5 · r⁴
        ∂r⁵ = ∂-leib r⁴ r ∙ cong₂ _+_ (cong (_· r) ∂r⁴) (cong (r⁴ ·_) ∂r) ∙ shape
          where shape : ((1r + (1r + (1r + (1r + 0r)))) · r³) · r + r⁴ · 1r ≡ (1r + (1r + (1r + (1r + (1r + 0r))))) · r⁴
                shape = solve! R

      ----------------------------------------------------------------
      -- १ · β₂ is exact
      ----------------------------------------------------------------
      β₂-is-exact : (g f : A)
        → (r⁴ · g) · ((ι 5 · (g · f) + ι 2 · ((r · ∂ g) · f)) + (r · g) · ∂ f)
          ≡ ∂ (r⁵ · (g · g) · f)
      β₂-is-exact g f = sym (∂-leib (r⁵ · (g · g)) f
                         ∙ cong (_+ (r⁵ · (g · g)) · ∂ f)
                                (cong (_· f) (∂-leib r⁵ (g · g)
                                              ∙ cong₂ _+_ (cong (_· (g · g)) ∂r⁵)
                                                          (cong (r⁵ ·_) (∂-leib g g))))
                         ∙ shape g f (∂ g) (∂ f))
        where
          shape : (g f g₁ f₁ : A)
            → ((((1r + (1r + (1r + (1r + (1r + 0r))))) · r⁴) · (g · g) + r⁵ · (g₁ · g + g · g₁)) · f) + (r⁵ · (g · g)) · f₁
              ≡ (r⁴ · g) · (((1r + (1r + (1r + (1r + (1r + 0r))))) · (g · f) + (1r + (1r + 0r)) · ((r · g₁) · f)) + (r · g) · f₁)
          shape g f g₁ f₁ = solve! R

      ----------------------------------------------------------------
      -- २ · β₄ is exact:  f = r² h φ,  g = h³
      ----------------------------------------------------------------
      β₄-is-exact : (h φ : A)
        → (ι 3 · ((r · (h · h · h)) · ∂ (r² · h · φ)) + (- (ι 6 · ((h · h · h) · (r² · h · φ)))))
          + (- ((r · ∂ (h · h · h)) · (r² · h · φ)))
          ≡ ι 3 · ((r³ · (h · h · h · h)) · ∂ φ)
      β₄-is-exact h φ =
          cong₂ (λ u v → (ι 3 · ((r · (h · h · h)) · u) + (- (ι 6 · ((h · h · h) · (r² · h · φ)))))
                         + (- ((r · v) · (r² · h · φ))))
                ∂f ∂g
        ∙ shape h φ (∂ h) (∂ φ)
        where
          ∂f : ∂ (r² · h · φ) ≡ ((r + r) · h + r² · ∂ h) · φ + (r² · h) · ∂ φ
          ∂f = ∂-leib (r² · h) φ ∙ cong (_+ (r² · h) · ∂ φ) (cong (_· φ) (∂-leib r² h ∙ cong (_+ r² · ∂ h) (cong (_· h) ∂r²)))
          ∂g : ∂ (h · h · h) ≡ (∂ h · h + h · ∂ h) · h + (h · h) · ∂ h
          ∂g = ∂-leib (h · h) h ∙ cong (_+ (h · h) · ∂ h) (cong (_· h) (∂-leib h h))
          shape : (h φ h₁ φ₁ : A)
            → ((1r + (1r + (1r + 0r))) · ((r · (h · h · h)) · (((r + r) · h + r² · h₁) · φ + (r² · h) · φ₁))
                + (- ((1r + (1r + (1r + (1r + (1r + (1r + 0r)))))) · ((h · h · h) · (r² · h · φ)))))
              + (- ((r · ((h₁ · h + h · h₁) · h + (h · h) · h₁)) · (r² · h · φ)))
              ≡ (1r + (1r + (1r + 0r))) · ((r³ · (h · h · h · h)) · φ₁)
          shape h φ h₁ φ₁ = solve! R

      ----------------------------------------------------------------
      -- ३ · weighted forcing = memory quadratic + exact derivative,
      --     with f the toroidal inverse of g:  f = −(r² g″ + 6 r g′)
      ----------------------------------------------------------------
      toroidal-f : A → A
      toroidal-f g = - (r² · ∂ (∂ g) + ι 6 · (r · ∂ g))

      memory-bracket : A → A
      memory-bracket g =
          (- (ι 2 · (r⁴ · (g · ∂ (∂ g)))))
        + (- (ι 18 · (r³ · (g · ∂ g))))
        + (- (r⁴ · (∂ g · ∂ g)))
        + (- (ι 9 · (r² · (g · g))))

      weighted-forcing-is-memory-plus-exact : (g : A)
        → let f = toroidal-f g in
          ι 2 · (r · ((ι 5 · (g · f) + ι 2 · ((r · ∂ g) · f)) + (r · g) · ∂ f))
          ≡ ι 2 · (ι 9 · (r · (g · g)) + (- (r³ · (∂ g · ∂ g)))) + ∂ (memory-bracket g)
      weighted-forcing-is-memory-plus-exact g =
          cong (λ u → ι 2 · (r · ((ι 5 · (g · toroidal-f g) + ι 2 · ((r · ∂ g) · toroidal-f g)) + (r · g) · u))) ∂f
        ∙ shape g (∂ g) (∂ (∂ g)) (∂ (∂ (∂ g)))
        ∙ sym (cong (ι 2 · (ι 9 · (r · (g · g)) + (- (r³ · (∂ g · ∂ g)))) +_) ∂Ψ)
        where
          ∂f : ∂ (toroidal-f g)
               ≡ - ( ((r + r) · ∂ (∂ g) + r² · ∂ (∂ (∂ g)))
                   + ι 6 · (1r · ∂ g + r · ∂ (∂ g)) )
          ∂f = ∂-neg _ ∙ cong -_
                 ( ∂-add (r² · ∂ (∂ g)) (ι 6 · (r · ∂ g))
                 ∙ cong₂ _+_ (∂-leib r² (∂ (∂ g)) ∙ cong (_+ r² · ∂ (∂ (∂ g))) (cong (_· ∂ (∂ g)) ∂r²))
                             (∂ιx 6 (r · ∂ g) ∙ cong (ι 6 ·_) (∂-leib r (∂ g) ∙ cong (_+ r · ∂ (∂ g)) (cong (_· ∂ g) ∂r))) )
          t1 : ∂ (- (ι 2 · (r⁴ · (g · ∂ (∂ g)))))
               ≡ - (ι 2 · ((ι 4 · r³) · (g · ∂ (∂ g)) + r⁴ · (∂ g · ∂ (∂ g) + g · ∂ (∂ (∂ g)))))
          t1 = ∂-neg _ ∙ cong -_ (∂ιx 2 _ ∙ cong (ι 2 ·_) (∂-leib r⁴ _ ∙ cong₂ _+_ (cong (_· (g · ∂ (∂ g))) ∂r⁴) (cong (r⁴ ·_) (∂-leib g (∂ (∂ g))))))
          t2 : ∂ (- (ι 18 · (r³ · (g · ∂ g))))
               ≡ - (ι 18 · ((ι 3 · r²) · (g · ∂ g) + r³ · (∂ g · ∂ g + g · ∂ (∂ g))))
          t2 = ∂-neg _ ∙ cong -_ (∂ιx 18 _ ∙ cong (ι 18 ·_) (∂-leib r³ _ ∙ cong₂ _+_ (cong (_· (g · ∂ g)) ∂r³) (cong (r³ ·_) (∂-leib g (∂ g)))))
          t3 : ∂ (- (r⁴ · (∂ g · ∂ g)))
               ≡ - ((ι 4 · r³) · (∂ g · ∂ g) + r⁴ · (∂ (∂ g) · ∂ g + ∂ g · ∂ (∂ g)))
          t3 = ∂-neg _ ∙ cong -_ (∂-leib r⁴ _ ∙ cong₂ _+_ (cong (_· (∂ g · ∂ g)) ∂r⁴) (cong (r⁴ ·_) (∂-leib (∂ g) (∂ g))))
          t4 : ∂ (- (ι 9 · (r² · (g · g))))
               ≡ - (ι 9 · ((r + r) · (g · g) + r² · (∂ g · g + g · ∂ g)))
          t4 = ∂-neg _ ∙ cong -_ (∂ιx 9 _ ∙ cong (ι 9 ·_) (∂-leib r² _ ∙ cong₂ _+_ (cong (_· (g · g)) ∂r²) (cong (r² ·_) (∂-leib g g))))
          ∂Ψ : ∂ (memory-bracket g)
               ≡ ((- (ι 2 · ((ι 4 · r³) · (g · ∂ (∂ g)) + r⁴ · (∂ g · ∂ (∂ g) + g · ∂ (∂ (∂ g))))))
                  + (- (ι 18 · ((ι 3 · r²) · (g · ∂ g) + r³ · (∂ g · ∂ g + g · ∂ (∂ g))))))
                 + (- ((ι 4 · r³) · (∂ g · ∂ g) + r⁴ · (∂ (∂ g) · ∂ g + ∂ g · ∂ (∂ g))))
                 + (- (ι 9 · ((r + r) · (g · g) + r² · (∂ g · g + g · ∂ g))))
          ∂Ψ = ∂-add _ _ ∙ cong₂ _+_ (∂-add _ _ ∙ cong₂ _+_ (∂-add _ _ ∙ cong₂ _+_ t1 t2) t3) t4
          shape : (g g₁ g₂ g₃ : A)
            → (1r + (1r + 0r)) · (r · (((1r + (1r + (1r + (1r + (1r + 0r))))) · (g · (- (r² · g₂ + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))) · (r · g₁)))) + (1r + (1r + 0r)) · ((r · g₁) · (- (r² · g₂ + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))) · (r · g₁)))))
                          + (r · g) · (- (((r + r) · g₂ + r² · g₃) + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))) · (1r · g₁ + r · g₂)))))
              ≡ (1r + (1r + 0r)) · ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))) · (r · (g · g)) + (- (r³ · (g₁ · g₁))))
                + ( ((- ((1r + (1r + 0r)) · (((1r + (1r + (1r + (1r + 0r)))) · r³) · (g · g₂) + r⁴ · (g₁ · g₂ + g · g₃))))
                     + (- ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))))))))))))) · (((1r + (1r + (1r + 0r))) · r²) · (g · g₁) + r³ · (g₁ · g₁ + g · g₂)))))
                    + (- (((1r + (1r + (1r + (1r + 0r)))) · r³) · (g₁ · g₁) + r⁴ · (g₂ · g₁ + g₁ · g₂)))
                    + (- ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))) · ((r + r) · (g · g) + r² · (g₁ · g + g · g₁)))) )
          shape g g₁ g₂ g₃ = solve! R

    ----------------------------------------------------------------
    -- ४ · log radius:  D r ≡ r  (D = r ∂ᵣ)
    ----------------------------------------------------------------
    module _ (r : A) (Dr : ∂ r ≡ r) where

      -- F = (4 − 3D − D²) b  with  b = r g,  F = r f,  f = −(D²g + 5 Dg)
      factored-operator : (g : A)
        → (ι 4 · (r · g) + (- (ι 3 · ∂ (r · g)))) + (- (∂ (∂ (r · g))))
          ≡ r · (- (∂ (∂ g) + ι 5 · ∂ g))
      factored-operator g =
          cong₂ (λ u v → (ι 4 · (r · g) + (- (ι 3 · u))) + (- v)) D1 D2 ∙ shape g (∂ g) (∂ (∂ g))
        where
          D1 : ∂ (r · g) ≡ r · g + r · ∂ g
          D1 = ∂-leib r g ∙ cong (_+ r · ∂ g) (cong (_· g) Dr)
          D2 : ∂ (∂ (r · g)) ≡ (r · g + r · ∂ g) + (r · ∂ g + r · ∂ (∂ g))
          D2 = cong ∂ D1 ∙ ∂-add (r · g) (r · ∂ g)
             ∙ cong₂ _+_ (∂-leib r g ∙ cong (_+ r · ∂ g) (cong (_· g) Dr))
                         (∂-leib r (∂ g) ∙ cong (_+ r · ∂ (∂ g)) (cong (_· ∂ g) Dr))
          shape : (g g₁ g₂ : A)
            → ((1r + (1r + (1r + (1r + 0r)))) · (r · g) + (- ((1r + (1r + (1r + 0r))) · (r · g + r · g₁)))) + (- ((r · g + r · g₁) + (r · g₁ + r · g₂)))
              ≡ r · (- (g₂ + (1r + (1r + (1r + (1r + (1r + 0r))))) · g₁))
          shape g g₁ g₂ = solve! R

      -- 9 b² − (r Dg)²  ≡  8 b² − (Db)² + D(b²)
      memory-integrand : (g : A)
        → ι 9 · ((r · g) · (r · g)) + (- ((r · ∂ g) · (r · ∂ g)))
          ≡ (ι 8 · ((r · g) · (r · g)) + (- (∂ (r · g) · ∂ (r · g)))) + ∂ ((r · g) · (r · g))
      memory-integrand g =
          sym ( cong₂ (λ u v → (ι 8 · ((r · g) · (r · g)) + (- (u · u))) + v) D1 D3
              ∙ shape g (∂ g) )
        where
          D1 : ∂ (r · g) ≡ r · g + r · ∂ g
          D1 = ∂-leib r g ∙ cong (_+ r · ∂ g) (cong (_· g) Dr)
          D3 : ∂ ((r · g) · (r · g)) ≡ (r · g + r · ∂ g) · (r · g) + (r · g) · (r · g + r · ∂ g)
          D3 = ∂-leib (r · g) (r · g) ∙ cong₂ _+_ (cong (_· (r · g)) D1) (cong ((r · g) ·_) D1)
          shape : (g g₁ : A)
            → ((1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))) · ((r · g) · (r · g)) + (- ((r · g + r · g₁) · (r · g + r · g₁))))
                + ((r · g + r · g₁) · (r · g) + (r · g) · (r · g + r · g₁))
              ≡ (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r))))))))) · ((r · g) · (r · g)) + (- ((r · g₁) · (r · g₁)))
          shape g g₁ = solve! R
