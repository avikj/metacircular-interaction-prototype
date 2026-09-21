{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मध्य-छेद — the midpoint secant.
--
-- FOR A QUADRATIC MAP, THE SECANT FROM `a` TO `a + b` IS THE DERIVATIVE
-- AT THE MIDPOINT, EXACTLY.  Freezing the derivative at `a` loses the
-- square of the hidden part; freezing it at `a + b` counts it twice.
-- And the work the returning force does on the visible part is exactly
-- minus the nonlinear work on the hidden part — for every split, with no
-- projection in sight.
--
-- This is the identity the source-dependent memory representation
-- rests on [S19 §2, §4; handoff §8.1].  It is stated here for a
-- BIADDITIVE map `B` on the additive group of a ring, with `N v = B v v`
-- its diagonal and `DN x b = B x b + B b x` the actual derivative of
-- `N` at `x` in the direction `b`.  The ring's own product is never
-- used; any ring's product is itself an instance of `B`, and so is any
-- bilinear map on a vector space.  Halves are cleared throughout, so
-- there is no division by two and no scalar field.
--
--   §1  THE SECANT IS THE MIDPOINT DERIVATIVE:
--
--         DN (2a + b) b  ≡  2 · ( N (a + b) - N a ) ,
--
--       which is `N(a+b) - N(a) = DN(a + b/2) b` with the half cleared.
--       The midpoint is not a modelling choice; it is what the
--       polynomial identity forces.
--
--   §2  FREEZING AT EITHER END IS WRONG BY EXACTLY THE HIDDEN SQUARE:
--
--         ( N (a + b) - N a ) - DN a b        ≡  N b ,
--         DN (a + b) b - ( N (a + b) - N a )  ≡  N b .
--
--       The frozen-at-`a` tangent loses `N b`; the frozen-at-`a+b`
--       tangent gains it.  Both errors are the same term with opposite
--       sign, which is why the midpoint is exact.
--
--   §3  THE RETURNING WORK IS MINUS THE HIDDEN WORK.  If `N` conserves a
--       pairing — ⟪ v , N v ⟫ ≡ 0 for every `v` — then for every split
--       `u = a + b`,
--
--         ⟪ a , N (a + b) - N a ⟫  +  ⟪ b , N (a + b) ⟫  ≡  0 .
--
--       The force returned to the visible part performs exactly the
--       negative of the work the full nonlinearity performs on the
--       hidden part.  No projection, no orthogonality, and no
--       contractivity of any propagator is assumed: the identity is
--       algebra on the split alone.
--
--   §4  AND HIDDEN AMPLIFICATION DOES NOT CONTRADICT §3.  The retained
--       finite control — visible input fixed at one, hidden equation
--       y′ = 1 + (1 − ν) y with an amplifying homogeneous part when
--       ν < 1, returned force r = −y − y² — satisfies
--
--         x·r  +  y·y′  +  ν y²  ≡  0 ,
--
--       i.e. the returned work is exactly minus the hidden storage rate
--       minus dissipation, however the hidden part grows.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–2 for every biadditive `B` on the
-- additive group of any ring and every `a`, `b`.  §3 additionally for
-- every biadditive pairing conserved by `N`.  §4 in any commutative
-- ring.  NOT claimed: that any particular `N` conserves any particular
-- pairing — that is the incompressibility identity ⟨v, N v⟩ = 0 and it
-- is a hypothesis here; anything about a projection, an evolution, a
-- propagator, or an integral in time — `a` and `b` are two elements, not
-- two histories; and no bound on anything: §3 is an exchange, not an
-- estimate.
------------------------------------------------------------------------

module MadhyaCheda_TheQuadraticSecantIsTheDerivativeAtTheMidpointFreezingAtEitherEndMissesTheHiddenSquareAndTheReturningWorkIsExactlyMinusTheHiddenWork where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ ℓ' : Level

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

    cancelR : (x y : A) → (x + y) + (- y) ≡ x
    cancelR x y = sym (+Assoc x y (- y)) ∙ cong (x +_) (+InvR y) ∙ +IdR x

    cancelL : (p w : A) → (p + w) + (- p) ≡ w
    cancelL p w = cong (_+ (- p)) (+Comm p w) ∙ cancelR w p

  ------------------------------------------------------------------
  -- ० · A biadditive map, its diagonal, and its actual derivative.
  ------------------------------------------------------------------

  module _ (B : A → A → A)
           (B-addL : (x y z : A) → B (x + y) z ≡ B x z + B y z)
           (B-addR : (x y z : A) → B x (y + z) ≡ B x y + B x z)
           where

    N : A → A
    N v = B v v

    DN : A → A → A
    DN x b = B x b + B b x

    private
      -- the four atoms every identity below is written in
      N-sum : (a b : A) → N (a + b) ≡ (B a a + B a b) + (B b a + B b b)
      N-sum a b = B-addL a b (a + b) ∙ cong₂ _+_ (B-addR a a b) (B-addR b a b)

      diff : (a b : A) → N (a + b) + (- N a) ≡ B a b + (B b a + B b b)
      diff a b =
          cong (_+ (- N a)) (N-sum a b)
        ∙ cong (_+ (- B a a)) (sym (+Assoc (B a a) (B a b) (B b a + B b b)))
        ∙ cancelL (B a a) (B a b + (B b a + B b b))

      -- 2Y + 2Z + 2W, two associations
      twice : (Y Z W : A)
        → (Y + (Y + W)) + (Z + (Z + W)) ≡ (Y + (Z + W)) + (Y + (Z + W))
      twice Y Z W = left ∙ sym right
        where
          nf : A
          nf = Y + (Y + (Z + (Z + (W + W))))

          left : (Y + (Y + W)) + (Z + (Z + W)) ≡ nf
          left =
              sym (+Assoc Y (Y + W) (Z + (Z + W)))
            ∙ cong (Y +_) (sym (+Assoc Y W (Z + (Z + W))))
            ∙ cong (λ z → Y + (Y + z)) (+Assoc-comm1 W Z (Z + W))
            ∙ cong (λ z → Y + (Y + (Z + z))) (+Assoc-comm1 W Z W)

          right : (Y + (Z + W)) + (Y + (Z + W)) ≡ nf
          right =
              sym (+Assoc Y (Z + W) (Y + (Z + W)))
            ∙ cong (Y +_) (+Assoc-comm1 (Z + W) Y (Z + W))
            ∙ cong (λ z → Y + (Y + z)) (sym (+Assoc Z W (Z + W)))
            ∙ cong (λ z → Y + (Y + (Z + z))) (+Assoc-comm1 W Z W)

    ----------------------------------------------------------------
    -- १ · THE SECANT IS THE MIDPOINT DERIVATIVE, halves cleared.
    ----------------------------------------------------------------

    secant-is-midpoint-derivative : (a b : A)
      → DN (a + (a + b)) b ≡ (N (a + b) + (- N a)) + (N (a + b) + (- N a))
    secant-is-midpoint-derivative a b =
        cong₂ _+_ (B-addL a (a + b) b ∙ cong (B a b +_) (B-addL a b b))
                  (B-addR b a (a + b) ∙ cong (B b a +_) (B-addR b a b))
      ∙ twice (B a b) (B b a) (B b b)
      ∙ sym (cong (λ d → d + d) (diff a b))

    ----------------------------------------------------------------
    -- २ · FREEZING AT EITHER END IS WRONG BY THE HIDDEN SQUARE.
    ----------------------------------------------------------------

    frozen-at-source-loses-the-square : (a b : A)
      → (N (a + b) + (- N a)) + (- DN a b) ≡ N b
    frozen-at-source-loses-the-square a b =
        cong (_+ (- DN a b)) (diff a b ∙ +Assoc (B a b) (B b a) (B b b))
      ∙ cancelL (B a b + B b a) (B b b)

    frozen-at-sum-doubles-the-square : (a b : A)
      → DN (a + b) b + (- (N (a + b) + (- N a))) ≡ N b
    frozen-at-sum-doubles-the-square a b =
        cong₂ (λ p q → p + (- q))
              ( cong₂ _+_ (B-addL a b b) (B-addR b a b)
              ∙ sym (+Assoc (B a b) (B b b) (B b a + B b b))
              ∙ cong (B a b +_) (+Comm (B b b) (B b a + B b b))
              ∙ +Assoc (B a b) (B b a + B b b) (B b b) )
              (diff a b)
      ∙ cancelL (B a b + (B b a + B b b)) (B b b)

    ----------------------------------------------------------------
    -- ३ · THE RETURNING WORK IS MINUS THE HIDDEN WORK.
    ----------------------------------------------------------------

    module _ (K : Ring ℓ') (⟪_,_⟫ : A → A → ⟨ K ⟩)
             (pair-addL : (x y v : A) → ⟪ x + y , v ⟫ ≡ RingStr._+_ (snd K) ⟪ x , v ⟫ ⟪ y , v ⟫)
             (pair-addR : (x v w : A) → ⟪ x , v + w ⟫ ≡ RingStr._+_ (snd K) ⟪ x , v ⟫ ⟪ x , w ⟫)
             (conserved : (v : A) → ⟪ v , N v ⟫ ≡ RingStr.0r (snd K))
             where

      private
        module K = RingStr (snd K)
        open RingTheory K using () renaming (implicitInverse to implicitInverseK)

        pair-zeroR : (x : A) → ⟪ x , 0r ⟫ ≡ K.0r
        pair-zeroR x =
          sym ( sym (K.+InvR ⟪ x , 0r ⟫)
              ∙ cong (K._+ (K.- ⟪ x , 0r ⟫))
                     (cong (λ z → ⟪ x , z ⟫) (sym (+IdR 0r)) ∙ pair-addR x 0r 0r)
              ∙ sym (K.+Assoc ⟪ x , 0r ⟫ ⟪ x , 0r ⟫ (K.- ⟪ x , 0r ⟫))
              ∙ cong (⟪ x , 0r ⟫ K.+_) (K.+InvR ⟪ x , 0r ⟫)
              ∙ K.+IdR ⟪ x , 0r ⟫ )

        pair-negR : (x v : A) → ⟪ x , - v ⟫ ≡ K.- ⟪ x , v ⟫
        pair-negR x v =
          implicitInverseK ⟪ x , v ⟫ ⟪ x , - v ⟫
            (sym (pair-addR x v (- v)) ∙ cong (λ z → ⟪ x , z ⟫) (+InvR v) ∙ pair-zeroR x)

      returning-work-is-minus-hidden-work : (a b : A)
        → ⟪ a , N (a + b) + (- N a) ⟫ K.+ ⟪ b , N (a + b) ⟫ ≡ K.0r
      returning-work-is-minus-hidden-work a b =
          cong (K._+ ⟪ b , N (a + b) ⟫)
               ( pair-addR a (N (a + b)) (- N a)
               ∙ cong (⟪ a , N (a + b) ⟫ K.+_)
                      (pair-negR a (N a) ∙ cong K.-_ (conserved a) ∙ negZero)
               ∙ K.+IdR ⟪ a , N (a + b) ⟫ )
        ∙ sym (pair-addL a b (N (a + b)))
        ∙ conserved (a + b)
        where
          negZero : K.- K.0r ≡ K.0r
          negZero = sym (K.+IdL (K.- K.0r)) ∙ K.+InvR K.0r

------------------------------------------------------------------------
-- ४ · HIDDEN AMPLIFICATION DOES NOT CONTRADICT THE EXCHANGE.
--     The retained finite control, in any commutative ring.
------------------------------------------------------------------------

module _ (C : CommRing ℓ) where
  open CommRingStr (snd C)

  -- visible input x ≡ 1r; hidden law y′ = 1 + (1 − ν) y; returned force
  -- r = −y − y².  Then x·r + y·y′ + ν·y² ≡ 0 identically.
  passive-despite-amplification : (y ν : ⟨ C ⟩)
    → (1r · ((- y) + (- (y · y))))
      + ((y · (1r + ((1r + (- ν)) · y))) + (ν · (y · y)))
      ≡ 0r
  passive-despite-amplification y ν = solve! C
