{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- शिखर — the peak.
--
-- The exact peak ledger of handoff §27 ([S13]) and the scaling
-- identities of §28.  Write ω = m ξ with |ξ| = 1.  Then
--
--     ξ·Δω = Δm − m|∇ξ|²          (the unit direction absorbs no Laplacian)
--     ξ·D_t ω = D_t m
--
-- and the vorticity equation D_tω = Sω + νΔω, dotted with ξ, gives
--
--     D_t m = α m + ν(Δm − m|∇ξ|²),   α = ξᵀSξ,
--
-- which at an increasing maximum (m = M, D_t m = M′) is the ledger
--     α = M′/M + ν|∇ξ|² + ν(−Δm)/M.
--
-- Everything is checked over a commutative ring with derivations, in
-- the DOUBLED form  2·(…) ≡ 2·(…): differentiating |ξ|² = 1 gives
-- 2 ξ·∂ξ = 0, and no division by 2 is available in a general ring.
--
-- Scaling (§28, d = 3): the gains g_ω = Aℓ, g_E = A²ℓ⁻³, g_C = A²ℓ⁻²
-- satisfy g_C⁵ = g_ω² g_E⁴, and the energy chart ℓ = M^{−2/5},
-- A = M^{−3/5} (with M = μ⁵) normalizes vorticity and retains energy.
------------------------------------------------------------------------
module Sikhara_TheUnitDirectionAbsorbsNoLaplacianSoTheVorticityMagnitudeObeysItsOwnEquationAndThePeakLedgerIsItsRearrangementWhileTheThreeScaleGainsObeyOneMonomialRelation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
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
  -- one derivation, three components, |ξ|² = 1
  ----------------------------------------------------------------
  module OneDirection (∂ : A → A)
                      (∂-add  : (x y : A) → ∂ (x + y) ≡ ∂ x + ∂ y)
                      (∂-leib : (x y : A) → ∂ (x · y) ≡ ∂ x · y + x · ∂ y)
                      (ξ₁ ξ₂ ξ₃ m : A)
                      (unit : (ξ₁ · ξ₁ + ξ₂ · ξ₂) + ξ₃ · ξ₃ ≡ 1r)
                      where

    private
      ∂-zero : ∂ 0r ≡ 0r
      ∂-zero = sym ( sym (+InvR (∂ 0r)) ∙ cong (_+ (- (∂ 0r))) h ∙ cancelR (∂ 0r) (∂ 0r) )
        where
          h : ∂ 0r ≡ ∂ 0r + ∂ 0r
          h = cong ∂ (sym (+IdR 0r)) ∙ ∂-add 0r 0r
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      ∂-one : ∂ 1r ≡ 0r
      ∂-one = sym ( sym (+InvR (∂ 1r)) ∙ cong (_+ (- (∂ 1r))) h ∙ cancelR (∂ 1r) (∂ 1r) )
        where
          h : ∂ 1r ≡ ∂ 1r + ∂ 1r
          h = cong ∂ (sym (·IdR 1r)) ∙ ∂-leib 1r 1r ∙ cong₂ _+_ (·IdR (∂ 1r)) (·IdL (∂ 1r))
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      -- X = ξ·∂ξ,  Y = ξ·∂∂ξ + |∂ξ|²
      X Y Q : A
      X = (ξ₁ · ∂ ξ₁ + ξ₂ · ∂ ξ₂) + ξ₃ · ∂ ξ₃
      Y = ((ξ₁ · ∂ (∂ ξ₁) + ∂ ξ₁ · ∂ ξ₁) + (ξ₂ · ∂ (∂ ξ₂) + ∂ ξ₂ · ∂ ξ₂)) + (ξ₃ · ∂ (∂ ξ₃) + ∂ ξ₃ · ∂ ξ₃)
      Q = (∂ ξ₁ · ∂ ξ₁ + ∂ ξ₂ · ∂ ξ₂) + ∂ ξ₃ · ∂ ξ₃

      two-first : ι 2 · X ≡ 0r
      two-first = sym shape ∙ sym (∂-add _ _ ∙ cong₂ _+_ (∂-add _ _ ∙ cong₂ _+_ (∂-leib ξ₁ ξ₁) (∂-leib ξ₂ ξ₂)) (∂-leib ξ₃ ξ₃))
                ∙ cong ∂ unit ∙ ∂-one
        where
          shape : ((∂ ξ₁ · ξ₁ + ξ₁ · ∂ ξ₁) + (∂ ξ₂ · ξ₂ + ξ₂ · ∂ ξ₂)) + (∂ ξ₃ · ξ₃ + ξ₃ · ∂ ξ₃) ≡ (1r + (1r + 0r)) · X
          shape = solve! R

      two-second : ι 2 · Y ≡ 0r
      two-second = sym shape ∙ sym (cong ∂ shape1 ∙ ∂-leib (ι 2) X ∙ cong₂ _+_ (cong (_· X) ∂two) (cong (ι 2 ·_) ∂X))
                 ∙ cong ∂ two-first ∙ ∂-zero
        where
          ∂two : ∂ (ι 2) ≡ 0r
          ∂two = ∂-add 1r (1r + 0r) ∙ cong₂ _+_ ∂-one (∂-add 1r 0r ∙ cong₂ _+_ ∂-one ∂-zero ∙ +IdR 0r) ∙ +IdR 0r
          ∂X : ∂ X ≡ ((∂ ξ₁ · ∂ ξ₁ + ξ₁ · ∂ (∂ ξ₁)) + (∂ ξ₂ · ∂ ξ₂ + ξ₂ · ∂ (∂ ξ₂))) + (∂ ξ₃ · ∂ ξ₃ + ξ₃ · ∂ (∂ ξ₃))
          ∂X = ∂-add _ _ ∙ cong₂ _+_ (∂-add _ _ ∙ cong₂ _+_ (∂-leib ξ₁ (∂ ξ₁)) (∂-leib ξ₂ (∂ ξ₂))) (∂-leib ξ₃ (∂ ξ₃))
          shape1 : ι 2 · X ≡ ι 2 · X
          shape1 = refl
          shape : 0r · X + (1r + (1r + 0r)) · (((∂ ξ₁ · ∂ ξ₁ + ξ₁ · ∂ (∂ ξ₁)) + (∂ ξ₂ · ∂ ξ₂ + ξ₂ · ∂ (∂ ξ₂))) + (∂ ξ₃ · ∂ ξ₃ + ξ₃ · ∂ (∂ ξ₃)))
                  ≡ (1r + (1r + 0r)) · Y
          shape = solve! R

      ∂∂mξ : (ξ : A) → ∂ (∂ (m · ξ)) ≡ (∂ (∂ m) · ξ + ∂ m · ∂ ξ) + (∂ m · ∂ ξ + m · ∂ (∂ ξ))
      ∂∂mξ ξ = cong ∂ (∂-leib m ξ) ∙ ∂-add _ _ ∙ cong₂ _+_ (∂-leib (∂ m) ξ) (∂-leib m (∂ ξ))

    -- the unit direction absorbs no second derivative:
    --   2 ξ·∂∂(mξ) ≡ 2 (∂∂m − m |∂ξ|²)
    direction-absorbs-nothing :
        ι 2 · ((ξ₁ · ∂ (∂ (m · ξ₁)) + ξ₂ · ∂ (∂ (m · ξ₂))) + ξ₃ · ∂ (∂ (m · ξ₃)))
        ≡ ι 2 · (∂ (∂ m) + (- (m · Q)))
    direction-absorbs-nothing =
        cong (λ u → ι 2 · u) (cong₂ _+_ (cong₂ _+_ (cong (ξ₁ ·_) (∂∂mξ ξ₁)) (cong (ξ₂ ·_) (∂∂mξ ξ₂))) (cong (ξ₃ ·_) (∂∂mξ ξ₃)))
      ∙ shape
      ∙ cong₂ (λ u v → (ι 2 · (∂ (∂ m) · u + (- (m · Q))) + ι 2 · (∂ m · v)) + m · (ι 2 · Y)) unit two-first
      ∙ cong (λ w → (ι 2 · (∂ (∂ m) · 1r + (- (m · Q))) + ι 2 · (∂ m · 0r)) + m · w) two-second
      ∙ finish
      where
        shape : (1r + (1r + 0r)) · ((ξ₁ · ((∂ (∂ m) · ξ₁ + ∂ m · ∂ ξ₁) + (∂ m · ∂ ξ₁ + m · ∂ (∂ ξ₁)))
                        + ξ₂ · ((∂ (∂ m) · ξ₂ + ∂ m · ∂ ξ₂) + (∂ m · ∂ ξ₂ + m · ∂ (∂ ξ₂))))
                       + ξ₃ · ((∂ (∂ m) · ξ₃ + ∂ m · ∂ ξ₃) + (∂ m · ∂ ξ₃ + m · ∂ (∂ ξ₃))))
                ≡ ((1r + (1r + 0r)) · (∂ (∂ m) · ((ξ₁ · ξ₁ + ξ₂ · ξ₂) + ξ₃ · ξ₃) + (- (m · Q))) + (1r + (1r + 0r)) · (∂ m · ((1r + (1r + 0r)) · X))) + m · ((1r + (1r + 0r)) · Y)
        shape = solve! R
        finish : ((1r + (1r + 0r)) · (∂ (∂ m) · 1r + (- (m · Q))) + (1r + (1r + 0r)) · (∂ m · 0r)) + m · 0r ≡ (1r + (1r + 0r)) · (∂ (∂ m) + (- (m · Q)))
        finish = solve! R

    -- the unit direction absorbs no first derivative either:
    --   2 ξ·∂(mξ) ≡ 2 ∂m
    direction-absorbs-no-rate :
        ι 2 · ((ξ₁ · ∂ (m · ξ₁) + ξ₂ · ∂ (m · ξ₂)) + ξ₃ · ∂ (m · ξ₃)) ≡ ι 2 · ∂ m
    direction-absorbs-no-rate =
        cong (ι 2 ·_) (cong₂ _+_ (cong₂ _+_ (cong (ξ₁ ·_) (∂-leib m ξ₁)) (cong (ξ₂ ·_) (∂-leib m ξ₂))) (cong (ξ₃ ·_) (∂-leib m ξ₃)))
      ∙ shape
      ∙ cong₂ (λ u v → ι 2 · (∂ m · u) + m · v) unit two-first
      ∙ finish
      where
        shape : (1r + (1r + 0r)) · ((ξ₁ · (∂ m · ξ₁ + m · ∂ ξ₁) + ξ₂ · (∂ m · ξ₂ + m · ∂ ξ₂)) + ξ₃ · (∂ m · ξ₃ + m · ∂ ξ₃))
                ≡ (1r + (1r + 0r)) · (∂ m · ((ξ₁ · ξ₁ + ξ₂ · ξ₂) + ξ₃ · ξ₃)) + m · ((1r + (1r + 0r)) · X)
        shape = solve! R
        finish : (1r + (1r + 0r)) · (∂ m · 1r) + m · 0r ≡ (1r + (1r + 0r)) · ∂ m
        finish = solve! R

    -- exported name for |∂ξ|²
    grad² : A
    grad² = Q

  ----------------------------------------------------------------
  -- the magnitude equation, with three space derivations and one
  -- time derivation
  ----------------------------------------------------------------
  module Magnitude
    (∂₁ ∂₂ ∂₃ D : A → A)
    (∂₁-add : (x y : A) → ∂₁ (x + y) ≡ ∂₁ x + ∂₁ y) (∂₁-leib : (x y : A) → ∂₁ (x · y) ≡ ∂₁ x · y + x · ∂₁ y)
    (∂₂-add : (x y : A) → ∂₂ (x + y) ≡ ∂₂ x + ∂₂ y) (∂₂-leib : (x y : A) → ∂₂ (x · y) ≡ ∂₂ x · y + x · ∂₂ y)
    (∂₃-add : (x y : A) → ∂₃ (x + y) ≡ ∂₃ x + ∂₃ y) (∂₃-leib : (x y : A) → ∂₃ (x · y) ≡ ∂₃ x · y + x · ∂₃ y)
    (D-add  : (x y : A) → D (x + y) ≡ D x + D y)    (D-leib  : (x y : A) → D (x · y) ≡ D x · y + x · D y)
    (ξ₁ ξ₂ ξ₃ m ν α S₁ S₂ S₃ : A)
    (unit : (ξ₁ · ξ₁ + ξ₂ · ξ₂) + ξ₃ · ξ₃ ≡ 1r)
    -- the vorticity equation componentwise:  D(mξᵢ) = Sᵢ + ν Δ(mξᵢ)
    (vorticity : (ξ : A) (S : A) → D (m · ξ) ≡ S + ν · ((∂₁ (∂₁ (m · ξ)) + ∂₂ (∂₂ (m · ξ))) + ∂₃ (∂₃ (m · ξ))))
    (stretch : (ξ₁ · S₁ + ξ₂ · S₂) + ξ₃ · S₃ ≡ α · m)
    where

    private
      module O₁ = OneDirection ∂₁ ∂₁-add ∂₁-leib ξ₁ ξ₂ ξ₃ m unit
      module O₂ = OneDirection ∂₂ ∂₂-add ∂₂-leib ξ₁ ξ₂ ξ₃ m unit
      module O₃ = OneDirection ∂₃ ∂₃-add ∂₃-leib ξ₁ ξ₂ ξ₃ m unit
      module OD = OneDirection D D-add D-leib ξ₁ ξ₂ ξ₃ m unit

    Δ : A → A
    Δ x = (∂₁ (∂₁ x) + ∂₂ (∂₂ x)) + ∂₃ (∂₃ x)

    -- |∇ξ|²
    ∇ξ² : A
    ∇ξ² = (O₁.grad² + O₂.grad²) + O₃.grad²

    -- 2 D_t m = 2 (α m + ν (Δm − m |∇ξ|²))
    magnitude-equation : ι 2 · D m ≡ ι 2 · (α · m + ν · (Δ m + (- (m · ∇ξ²))))
    magnitude-equation =
        sym OD.direction-absorbs-no-rate
      ∙ cong (ι 2 ·_) (cong₂ _+_ (cong₂ _+_ (cong (ξ₁ ·_) (vorticity ξ₁ S₁)) (cong (ξ₂ ·_) (vorticity ξ₂ S₂))) (cong (ξ₃ ·_) (vorticity ξ₃ S₃)))
      ∙ split
      ∙ cong₂ (λ u v → ι 2 · u + ν · v) stretch three
      ∙ finish
      where
        split : ι 2 · ((ξ₁ · (S₁ + ν · Δ (m · ξ₁)) + ξ₂ · (S₂ + ν · Δ (m · ξ₂))) + ξ₃ · (S₃ + ν · Δ (m · ξ₃)))
                ≡ ι 2 · ((ξ₁ · S₁ + ξ₂ · S₂) + ξ₃ · S₃)
                  + ν · ( (ι 2 · ((ξ₁ · ∂₁ (∂₁ (m · ξ₁)) + ξ₂ · ∂₁ (∂₁ (m · ξ₂))) + ξ₃ · ∂₁ (∂₁ (m · ξ₃)))
                          + ι 2 · ((ξ₁ · ∂₂ (∂₂ (m · ξ₁)) + ξ₂ · ∂₂ (∂₂ (m · ξ₂))) + ξ₃ · ∂₂ (∂₂ (m · ξ₃))))
                        + ι 2 · ((ξ₁ · ∂₃ (∂₃ (m · ξ₁)) + ξ₂ · ∂₃ (∂₃ (m · ξ₂))) + ξ₃ · ∂₃ (∂₃ (m · ξ₃))) )
        split = shape ξ₁ ξ₂ ξ₃ S₁ S₂ S₃ ν
                  (∂₁ (∂₁ (m · ξ₁))) (∂₂ (∂₂ (m · ξ₁))) (∂₃ (∂₃ (m · ξ₁)))
                  (∂₁ (∂₁ (m · ξ₂))) (∂₂ (∂₂ (m · ξ₂))) (∂₃ (∂₃ (m · ξ₂)))
                  (∂₁ (∂₁ (m · ξ₃))) (∂₂ (∂₂ (m · ξ₃))) (∂₃ (∂₃ (m · ξ₃)))
          where
            shape : (ξ₁ ξ₂ ξ₃ S₁ S₂ S₃ ν a₁ b₁ c₁ a₂ b₂ c₂ a₃ b₃ c₃ : A)
              → (1r + (1r + 0r)) · ((ξ₁ · (S₁ + ν · ((a₁ + b₁) + c₁)) + ξ₂ · (S₂ + ν · ((a₂ + b₂) + c₂))) + ξ₃ · (S₃ + ν · ((a₃ + b₃) + c₃)))
                ≡ (1r + (1r + 0r)) · ((ξ₁ · S₁ + ξ₂ · S₂) + ξ₃ · S₃)
                  + ν · ( ((1r + (1r + 0r)) · ((ξ₁ · a₁ + ξ₂ · a₂) + ξ₃ · a₃) + (1r + (1r + 0r)) · ((ξ₁ · b₁ + ξ₂ · b₂) + ξ₃ · b₃))
                        + (1r + (1r + 0r)) · ((ξ₁ · c₁ + ξ₂ · c₂) + ξ₃ · c₃) )
            shape ξ₁ ξ₂ ξ₃ S₁ S₂ S₃ ν a₁ b₁ c₁ a₂ b₂ c₂ a₃ b₃ c₃ = solve! R
        three : (ι 2 · ((ξ₁ · ∂₁ (∂₁ (m · ξ₁)) + ξ₂ · ∂₁ (∂₁ (m · ξ₂))) + ξ₃ · ∂₁ (∂₁ (m · ξ₃)))
                 + ι 2 · ((ξ₁ · ∂₂ (∂₂ (m · ξ₁)) + ξ₂ · ∂₂ (∂₂ (m · ξ₂))) + ξ₃ · ∂₂ (∂₂ (m · ξ₃))))
                + ι 2 · ((ξ₁ · ∂₃ (∂₃ (m · ξ₁)) + ξ₂ · ∂₃ (∂₃ (m · ξ₂))) + ξ₃ · ∂₃ (∂₃ (m · ξ₃)))
                ≡ (ι 2 · (∂₁ (∂₁ m) + (- (m · O₁.grad²))) + ι 2 · (∂₂ (∂₂ m) + (- (m · O₂.grad²))))
                  + ι 2 · (∂₃ (∂₃ m) + (- (m · O₃.grad²)))
        three = cong₂ _+_ (cong₂ _+_ O₁.direction-absorbs-nothing O₂.direction-absorbs-nothing) O₃.direction-absorbs-nothing
        finish : ι 2 · (α · m) + ν · ((ι 2 · (∂₁ (∂₁ m) + (- (m · O₁.grad²))) + ι 2 · (∂₂ (∂₂ m) + (- (m · O₂.grad²))))
                                     + ι 2 · (∂₃ (∂₃ m) + (- (m · O₃.grad²))))
                 ≡ ι 2 · (α · m + ν · (Δ m + (- (m · ∇ξ²))))
        finish = shape' (α · m) ν (∂₁ (∂₁ m)) (∂₂ (∂₂ m)) (∂₃ (∂₃ m)) m O₁.grad² O₂.grad² O₃.grad²
          where
            shape' : (p ν a b c m q₁ q₂ q₃ : A)
              → (1r + (1r + 0r)) · p + ν · (((1r + (1r + 0r)) · (a + (- (m · q₁))) + (1r + (1r + 0r)) · (b + (- (m · q₂)))) + (1r + (1r + 0r)) · (c + (- (m · q₃))))
                ≡ (1r + (1r + 0r)) · (p + ν · (((a + b) + c) + (- (m · ((q₁ + q₂) + q₃)))))
            shape' p ν a b c m q₁ q₂ q₃ = solve! R

    -- the ledger: at m = M with D m = M′ this is  α M = M′ + ν M|∇ξ|² − νΔm
    peak-ledger : ι 2 · (α · m) ≡ ι 2 · D m + ι 2 · (ν · (m · ∇ξ²) + (- (ν · Δ m)))
    peak-ledger =
        shape (α · m) ν (m · ∇ξ²) (Δ m)
      ∙ cong (_+ ι 2 · (ν · (m · ∇ξ²) + (- (ν · Δ m)))) (sym magnitude-equation)
      where
        shape : (p ν q l : A) → (1r + (1r + 0r)) · p ≡ (1r + (1r + 0r)) · (p + ν · (l + (- q))) + (1r + (1r + 0r)) · (ν · q + (- (ν · l)))
        shape p ν q l = solve! R

  ----------------------------------------------------------------
  -- §28 scaling identities, d = 3
  ----------------------------------------------------------------
  -- g_C⁵ = g_ω² g_E⁴  with  g_ω = Aℓ,  g_E = A²λ³,  g_C = A²λ²,  ℓλ = 1  (λ written il)
  gain-relation : (Am l il : A) → l · il ≡ 1r
    → let gω = Am · l ; gE = (Am · Am) · ((il · il) · il) ; gC = (Am · Am) · (il · il)
      in  (((gC · gC) · gC) · gC) · gC ≡ (gω · gω) · (((gE · gE) · gE) · gE)
  gain-relation Am l il h =
      shape ∙ sym (·IdR P) ∙ cong (P ·_) (sym (cong₂ _·_ h h ∙ ·IdR 1r)) ∙ sym shape'
    where
      A⁵ il⁵ P : A
      A⁵ = (((Am · Am) · Am) · Am) · Am
      il⁵ = (((il · il) · il) · il) · il
      P = (A⁵ · A⁵) · (il⁵ · il⁵)
      shape : let gC = (Am · Am) · (il · il) in (((gC · gC) · gC) · gC) · gC ≡ P
      shape = solve! R
      shape' : let gω = Am · l ; gE = (Am · Am) · ((il · il) · il) in
               (gω · gω) · (((gE · gE) · gE) · gE) ≡ P · ((l · il) · (l · il))
      shape' = solve! R

  -- the energy chart:  ℓ = μ⁻², A = μ⁻³, M = μ⁵  normalizes vorticity (AℓM = 1)
  -- and retains energy (A²ℓ⁻³ = 1)
  energy-chart : (μ μ⁻¹ : A) → μ · μ⁻¹ ≡ 1r
    → let l = μ⁻¹ · μ⁻¹ ; Am = (μ⁻¹ · μ⁻¹) · μ⁻¹ ; M = (((μ · μ) · μ) · μ) · μ
      in  ((Am · l) · M ≡ 1r) × ((Am · Am) · ((μ · μ) · μ) · ((μ · μ) · μ) ≡ 1r)
  energy-chart μ μ⁻¹ h =
      (shape₁ μ μ⁻¹ ∙ five h , shape₂ μ μ⁻¹ ∙ six h)
    where
      shape₁ : (μ μ⁻¹ : A) → let l = μ⁻¹ · μ⁻¹ ; Am = (μ⁻¹ · μ⁻¹) · μ⁻¹ ; M = (((μ · μ) · μ) · μ) · μ in
               (Am · l) · M ≡ ((((μ · μ⁻¹) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)
      shape₁ μ μ⁻¹ = solve! R
      shape₂ : (μ μ⁻¹ : A) → let Am = (μ⁻¹ · μ⁻¹) · μ⁻¹ in
               (Am · Am) · ((μ · μ) · μ) · ((μ · μ) · μ) ≡ (((((μ · μ⁻¹) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)
      shape₂ μ μ⁻¹ = solve! R
      five : (h : μ · μ⁻¹ ≡ 1r) → ((((μ · μ⁻¹) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹) ≡ 1r
      five h = cong (λ u → (((u · u) · u) · u) · u) h ∙ ones
        where ones : (((1r · 1r) · 1r) · 1r) · 1r ≡ 1r
              ones = solve! R
      six : (h : μ · μ⁻¹ ≡ 1r) → (((((μ · μ⁻¹) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹)) · (μ · μ⁻¹) ≡ 1r
      six h = cong (λ u → ((((u · u) · u) · u) · u) · u) h ∙ ones
        where ones : ((((1r · 1r) · 1r) · 1r) · 1r) · 1r ≡ 1r
              ones = solve! R
