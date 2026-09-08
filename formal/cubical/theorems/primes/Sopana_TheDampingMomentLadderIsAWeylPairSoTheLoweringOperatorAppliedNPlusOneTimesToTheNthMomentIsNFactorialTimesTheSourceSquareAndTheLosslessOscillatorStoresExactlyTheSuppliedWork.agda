{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- सोपान — the ladder.
--
-- The damping-moment kernels  G_n = ∫ tⁿ e^{−2st} Z(T+t) Z̄(U+t) dt
-- (handoff §57, [S09]) obey, with  ℒ = 2s − ∂_T − ∂_U  and  R = −½∂_s,
--
--     R G_n = G_{n+1},   ℒ G_0 = Z⊗Z̄,   ℒ G_n = n G_{n−1},   [ℒ, R] = I,
--
-- hence  ℒⁿ⁺¹ G_n = n! Z⊗Z̄.  Three finite pieces are checked here:
--
--   १  the ladder: for ANY additive ℒ and sequence G with ℒ G₀ = ZZ and
--      ℒ G_{n+1} = (n+1) G_n,   ℒⁿ⁺¹ G_n ≡ n! · ZZ;
--   २  the Weyl pair: for a derivation ∂ (= ∂_s) with ∂ s = 1 and an
--      additive D (= ∂_T + ∂_U) commuting with ∂,
--         ℒ(∂φ) − ∂(ℒφ) ≡ −2φ,     i.e.  [ℒ, −½∂] = I,
--      and raising is just ∂ of the damping factor:  ∂(tⁿE) = −2 tⁿ⁺¹E
--      when ∂E = −2tE, ∂t = 0;
--   ३  the lossless oscillator of §61: with  a′ = iγ a + f  written in
--      real coordinates  p′ = −γq + f₁,  q′ = γp + f₂,
--         ∂(p² + q²) ≡ 2 (p f₁ + q f₂),
--      i.e. the stored energy changes exactly by the supplied work Re(f̄ a).
------------------------------------------------------------------------
module Sopana_TheDampingMomentLadderIsAWeylPairSoTheLoweringOperatorAppliedNPlusOneTimesToTheNthMomentIsNFactorialTimesTheSourceSquareAndTheLosslessOscillatorStoresExactlyTheSuppliedWork where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_·_ to _·ℕ_ ; _+_ to _+ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

fact : ℕ → ℕ
fact zero    = 1
fact (suc n) = suc n ·ℕ fact n

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  ι : ℕ → A
  ι zero    = 0r
  ι (suc n) = 1r + ι n

  scale : ℕ → A → A
  scale zero    x = 0r
  scale (suc n) x = x + scale n x

  private
    scale-+ : (m n : ℕ) (x : A) → scale (m +ℕ n) x ≡ scale m x + scale n x
    scale-+ zero    n x = sym (+IdL (scale n x))
    scale-+ (suc m) n x = cong (x +_) (scale-+ m n x) ∙ +Assoc x (scale m x) (scale n x)

    scale-· : (m n : ℕ) (x : A) → scale (m ·ℕ n) x ≡ scale m (scale n x)
    scale-· zero    n x = refl
    scale-· (suc m) n x = scale-+ n (m ·ℕ n) x ∙ cong (scale n x +_) (scale-· m n x)

  ----------------------------------------------------------------
  -- १ · THE LADDER
  ----------------------------------------------------------------
  module Ladder (ℒ : A → A) (ℒ-add : (x y : A) → ℒ (x + y) ≡ ℒ x + ℒ y)
                (G : ℕ → A) (ZZ : A)
                (base : ℒ (G zero) ≡ ZZ)
                (step : (n : ℕ) → ℒ (G (suc n)) ≡ scale (suc n) (G n))
                where

    -- iterate, applying ℒ innermost first
    ℒ^ : ℕ → A → A
    ℒ^ zero    x = x
    ℒ^ (suc n) x = ℒ^ n (ℒ x)

    private
      ℒ-zero : ℒ 0r ≡ 0r
      ℒ-zero = sym ( sym (+InvR (ℒ 0r)) ∙ cong (_+ (- (ℒ 0r))) h ∙ cancelR (ℒ 0r) (ℒ 0r) )
        where
          h : ℒ 0r ≡ ℒ 0r + ℒ 0r
          h = cong ℒ (sym (+IdR 0r)) ∙ ℒ-add 0r 0r
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      ℒ-scale : (n : ℕ) (x : A) → ℒ (scale n x) ≡ scale n (ℒ x)
      ℒ-scale zero    x = ℒ-zero
      ℒ-scale (suc n) x = ℒ-add x (scale n x) ∙ cong (ℒ x +_) (ℒ-scale n x)

      ℒ^-scale : (m n : ℕ) (x : A) → ℒ^ m (scale n x) ≡ scale n (ℒ^ m x)
      ℒ^-scale zero    n x = refl
      ℒ^-scale (suc m) n x = cong (ℒ^ m) (ℒ-scale n x) ∙ ℒ^-scale m n (ℒ x)

    ladder : (n : ℕ) → ℒ^ (suc n) (G n) ≡ scale (fact n) ZZ
    ladder zero    = base ∙ sym (+IdR ZZ)
    ladder (suc n) =
        cong (ℒ^ (suc n)) (step n)
      ∙ ℒ^-scale (suc n) (suc n) (G n)
      ∙ cong (scale (suc n)) (ladder n)
      ∙ sym (scale-· (suc n) (fact n) ZZ)

    -- the first three rungs, explicitly
    _ : ℒ (G 0) ≡ ZZ + 0r
    _ = ladder 0
    _ : ℒ (ℒ (G 1)) ≡ ZZ + 0r
    _ = ladder 1
    _ : ℒ (ℒ (ℒ (G 2))) ≡ ZZ + (ZZ + 0r)
    _ = ladder 2

  ----------------------------------------------------------------
  -- २ · THE WEYL PAIR
  ----------------------------------------------------------------
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

      ∂ιx : (n : ℕ) (x : A) → ∂ (ι n · x) ≡ ι n · ∂ x
      ∂ιx n x = ∂-leib (ι n) x ∙ cong (_+ ι n · ∂ x) (cong (_· x) (∂ι n) ∙ zeroL x) ∙ +IdL (ι n · ∂ x)
        where zeroL : (y : A) → 0r · y ≡ 0r
              zeroL y = solve! R

    module _ (s : A) (∂s : ∂ s ≡ 1r)
             (D : A → A) (D-add : (x y : A) → D (x + y) ≡ D x + D y)
             (D∂ : (x : A) → D (∂ x) ≡ ∂ (D x))
             where

      -- ℒ = 2s − D
      ℒ : A → A
      ℒ φ = ι 2 · (s · φ) + (- (D φ))

      -- [ℒ, ∂] = −2,  i.e.  [ℒ, −½∂] = 1
      weyl : (φ : A) → ℒ (∂ φ) + (- (∂ (ℒ φ))) ≡ - (ι 2 · φ)
      weyl φ =
          cong (λ u → ℒ (∂ φ) + (- u)) ∂ℒ
        ∙ cong (λ u → (ι 2 · (s · ∂ φ) + (- u)) + (- (ι 2 · (1r · φ + s · ∂ φ) + (- (∂ (D φ)))))) (D∂ φ)
        ∙ shape φ (∂ φ) (∂ (D φ))
        where
          ∂ℒ : ∂ (ℒ φ) ≡ ι 2 · (1r · φ + s · ∂ φ) + (- (∂ (D φ)))
          ∂ℒ = ∂-add _ _
             ∙ cong₂ _+_ (∂ιx 2 (s · φ) ∙ cong (ι 2 ·_) (∂-leib s φ ∙ cong (_+ s · ∂ φ) (cong (_· φ) ∂s)))
                         (∂-neg (D φ))
          shape : (φ φ' w : A)
            → ((1r + (1r + 0r)) · (s · φ') + (- w)) + (- ((1r + (1r + 0r)) · (1r · φ + s · φ') + (- w))) ≡ - ((1r + (1r + 0r)) · φ)
          shape φ φ' w = solve! R

    -- raising:  ∂ of the damping factor,  ∂E = −2tE, ∂t = 0
    module _ (t E : A) (∂t : ∂ t ≡ 0r) (∂E : ∂ E ≡ - (ι 2 · (t · E))) where

      pow : A → ℕ → A
      pow x zero    = 1r
      pow x (suc n) = x · pow x n

      private
        ∂pow : (n : ℕ) → ∂ (pow t n) ≡ 0r
        ∂pow zero    = ∂-one
        ∂pow (suc n) = ∂-leib t (pow t n) ∙ cong₂ _+_ (cong (_· pow t n) ∂t ∙ zeroL _) (cong (t ·_) (∂pow n) ∙ zeroR t) ∙ +IdR 0r
          where zeroL : (y : A) → 0r · y ≡ 0r
                zeroL y = solve! R
                zeroR : (y : A) → y · 0r ≡ 0r
                zeroR y = solve! R

      raising : (n : ℕ) → ∂ (pow t n · E) ≡ - (ι 2 · (pow t (suc n) · E))
      raising n =
          ∂-leib (pow t n) E
        ∙ cong₂ _+_ (cong (_· E) (∂pow n)) (cong (pow t n ·_) ∂E)
        ∙ shape (pow t n)
        where
          shape : (P : A) → 0r · E + P · (- ((1r + (1r + 0r)) · (t · E))) ≡ - ((1r + (1r + 0r)) · ((t · P) · E))
          shape P = solve! R

    ----------------------------------------------------------------
    -- ३ · THE LOSSLESS OSCILLATOR STORES EXACTLY THE SUPPLIED WORK
    ----------------------------------------------------------------
    module _ (γ p q f₁ f₂ : A)
             (p′ : ∂ p ≡ (- (γ · q)) + f₁)
             (q′ : ∂ q ≡ γ · p + f₂)
             where

      stored-work : ∂ (p · p + q · q) ≡ ι 2 · (p · f₁ + q · f₂)
      stored-work =
          ∂-add (p · p) (q · q)
        ∙ cong₂ _+_ (∂-leib p p) (∂-leib q q)
        ∙ cong₂ (λ u v → (u · p + p · u) + (v · q + q · v)) p′ q′
        ∙ shape
        where
          shape : (((- (γ · q)) + f₁) · p + p · ((- (γ · q)) + f₁)) + ((γ · p + f₂) · q + q · (γ · p + f₂))
                  ≡ (1r + (1r + 0r)) · (p · f₁ + q · f₂)
          shape = solve! R
