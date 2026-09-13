{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्तन — the turning.
--
-- THE FIRST-RETURN RADIAL OPERATOR IS THREE BOUNDARY FORMS PLUS AN EXACT
-- DERIVATIVE; AND THE INDICIAL POLYNOMIAL OF EVERY TOROIDAL DEGREE
-- FACTORS, SO DEGREE TWO IS THE ONLY CHANNEL WITH INWARD EXPONENT ZERO.
--
-- Two identities from the toroidal return calculation [S15 §5, S20
-- §§6–8], both algebra about a derivation, both exact.
--
--   §1  THE RETURN OPERATOR'S INTEGRATION BY PARTS.  With `g′ = d g`
--       and so on, and
--
--         𝒞 = 15 g h + 6 r g′ h + 3 r g h′ + p f − r p′ f − 4 r p f′ ,
--
--       the identity
--
--         r 𝒞  ≡  3 [ (3 r g + r² g′) h + (3 r p + r² p′) f ]
--                 +  d ( 3 r² g h − 4 r² p f )
--
--       holds in any commutative ring with a derivation `d` and `d r ≡ 1`.
--       The two bracketed forms are exactly the unit Green responses
--       `3 t g_s(t) + t² g_s′(t)` and `3 s p_t(s) + s² p_t′(s)` that
--       become the two-radius kernel L₂₄; the derivative term is what a
--       compactly supported source integrates to zero.  So the return
--       kernel is those two boundary forms and nothing else.
--
--   §2  THE INDICIAL POLYNOMIAL FACTORS.  The radial equation for the
--       degree-l toroidal vector potential, q″ + (6/r) q′ − (l−2)(l+3)
--       q/r² = −f/r², has indicial polynomial
--
--         k (k − 1) + 6 k − (l − 2)(l + 3)  ≡  (k − (l − 2)) (k + (l + 3)) ,
--
--       an identity in any commutative ring.  Its roots are the two
--       radial exponents, inward `l − 2` and outward `−(l + 3)`.
--
--   §3  AND `r^{l−2}` IS THE INWARD SOLUTION, for every l ≥ 2: with
--       k = l − 2,
--
--         r² · d(d(r^k)) + 6 r · d(r^k)  ≡  k (k + 5) · r^k ,
--
--       and k (k + 5) = (l − 2)(l + 3).  For l = 2 the right side is
--       zero: the interior potential is constant, the interior velocity
--       is linear, and a remote shell contributes a constant strain —
--       the marginal channel.  For every l ≥ 3 the exponent is
--       positive and a remote shell's contribution is attenuated by the
--       radius ratio to that power.  Degree one has exponent −1, the
--       translation gauge.
--
-- WHY §3 IS STATED WITH k AND NOT l − 2.  Subtraction in ℕ is a
-- truncation; the honest statement is over the exponent k with l = k+2,
-- which is every toroidal degree from two upward.  The degree-one case
-- has a negative exponent and is the gauge channel the commentary
-- names; it is not in §3 because `r^{-1}` is not a polynomial.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 in any commutative ring with an
-- additive Leibniz `d` and any `r` with `d r ≡ 1`, for all g, h, p, f.
-- §2 in any commutative ring.  §3 in any such ring with derivation, for
-- every exponent.  NOT claimed: that 𝒞 IS the projected return (that is
-- the spherical-moment computation, an integral, taken as given); the
-- value 7/45 or any kernel value, which need division; the outward
-- solution r^{−(l+3)}, which needs negative powers; anything about
-- attenuation as an inequality — no order relation occurs here; and
-- nothing about degree one beyond the reading above.
------------------------------------------------------------------------

module Vartana_TheFirstReturnRadialOperatorIsThreeBoundaryFormsPlusAnExactDerivativeAndTheIndicialPolynomialOfEveryToroidalDegreeFactorsSoDegreeTwoIsTheOnlyMarginalChannel where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.Tactics.NatSolver using (solveℕ!)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  scale : ℕ → A → A
  scale zero    a = 0r
  scale (suc n) a = a + scale n a

  pow : A → ℕ → A
  pow x zero    = 1r
  pow x (suc n) = x · pow x n

  private
    scale-+ : (m n : ℕ) (a : A) → scale (m +ℕ n) a ≡ scale m a + scale n a
    scale-+ zero    n a = sym (+IdL (scale n a))
    scale-+ (suc m) n a = cong (a +_) (scale-+ m n a) ∙ +Assoc a (scale m a) (scale n a)

    scale-· : (m n : ℕ) (a : A) → scale (m ·ℕ n) a ≡ scale m (scale n a)
    scale-· zero    n a = refl
    scale-· (suc m) n a = scale-+ n (m ·ℕ n) a ∙ cong (scale n a +_) (scale-· m n a)

    scale-mulR : (n : ℕ) (a b : A) → scale n a · b ≡ scale n (a · b)
    scale-mulR zero    a b = zeroL b
      where
        zeroL : (x : A) → 0r · x ≡ 0r
        zeroL x = solve! R
    scale-mulR (suc n) a b = ·DistL+ a (scale n a) b ∙ cong ((a · b) +_) (scale-mulR n a b)

    scale-mulL : (n : ℕ) (a b : A) → b · scale n a ≡ scale n (b · a)
    scale-mulL n a b = ·Comm b (scale n a) ∙ scale-mulR n a b ∙ cong (scale n) (·Comm a b)

  ------------------------------------------------------------------
  -- ० · A derivation, and the facts about it the identities use.
  ------------------------------------------------------------------

  module _ (d : A → A)
           (d-add  : (x y : A) → d (x + y) ≡ d x + d y)
           (d-leib : (x y : A) → d (x · y) ≡ d x · y + x · d y)
           where

    private
      d-zero : d 0r ≡ 0r
      d-zero = sym ( sym (+InvR (d 0r)) ∙ cong (_+ (- (d 0r))) h ∙ cancelR (d 0r) (d 0r) )
        where
          h : d 0r ≡ d 0r + d 0r
          h = cong d (sym (+IdR 0r)) ∙ d-add 0r 0r
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      d-neg : (x : A) → d (- x) ≡ - d x
      d-neg x = negOf (d x) (d (- x)) (sym (d-add x (- x)) ∙ cong d (+InvR x) ∙ d-zero)
        where
          negOf : (a b : A) → a + b ≡ 0r → b ≡ - a
          negOf a b h = sym (+IdL b) ∙ cong (_+ b) (sym (+InvL a)) ∙ sym (+Assoc (- a) a b) ∙ cong ((- a) +_) h ∙ +IdR (- a)

      d-scale : (n : ℕ) (x : A) → d (scale n x) ≡ scale n (d x)
      d-scale zero    x = d-zero
      d-scale (suc n) x = d-add x (scale n x) ∙ cong (d x +_) (d-scale n x)

    ----------------------------------------------------------------
    -- With a radius:  d r ≡ 1.
    ----------------------------------------------------------------

    module _ (r : A) (dr : d r ≡ 1r) where

      private
        d-rr : d (r · r) ≡ r + r
        d-rr = d-leib r r ∙ cong₂ _+_ (cong (_· r) dr ∙ ·IdL r) (cong (r ·_) dr ∙ ·IdR r)

        -- d of a product of the radius squared with two profiles
        d-r²xy : (x y : A)
          → d ((r · r) · x · y)
            ≡ (((r + r) · x + (r · r) · d x) · y) + ((r · r) · x · d y)
        d-r²xy x y =
            d-leib ((r · r) · x) y
          ∙ cong (λ z → (z · y) + ((r · r) · x · d y))
                 (d-leib (r · r) x ∙ cong (_+ (r · r) · d x) (cong (_· x) d-rr))

      ----------------------------------------------------------------
      -- १ · THE RETURN OPERATOR IS BOUNDARY FORMS PLUS A DERIVATIVE.
      ----------------------------------------------------------------

      𝒞 : A → A → A → A → A
      𝒞 g h p f =
          scale 15 (g · h) + (scale 6 (r · d g · h) + scale 3 (r · g · d h))
        + ((p · f + (- (r · d p · f))) + (- (scale 4 (r · p · d f))))

      boundary-forms : A → A → A → A → A
      boundary-forms g h p f =
        scale 3 ( (scale 3 (r · g) + (r · r) · d g) · h
                + (scale 3 (r · p) + (r · r) · d p) · f )

      antiderivative : A → A → A → A → A
      antiderivative g h p f =
        scale 3 ((r · r) · g · h) + (- (scale 4 ((r · r) · p · f)))

      return-integrates-by-parts : (g h p f : A)
        → r · 𝒞 g h p f ≡ boundary-forms g h p f + d (antiderivative g h p f)
      return-integrates-by-parts g h p f =
        sym ( cong (boundary-forms g h p f +_)
                   ( d-add (scale 3 ((r · r) · g · h)) (- (scale 4 ((r · r) · p · f)))
                   ∙ cong₂ _+_
                       (d-scale 3 ((r · r) · g · h) ∙ cong (scale 3) (d-r²xy g h))
                       ( d-neg (scale 4 ((r · r) · p · f))
                       ∙ cong -_ (d-scale 4 ((r · r) · p · f) ∙ cong (scale 4) (d-r²xy p f)) ) )
            ∙ shape r g (d g) h (d h) p (d p) f (d f) )
        where
          shape : (r g g' h h' p p' f f' : A)
            → scale 3 ( (scale 3 (r · g) + (r · r) · g') · h
                      + (scale 3 (r · p) + (r · r) · p') · f )
              + ( scale 3 ((((r + r) · g + (r · r) · g') · h) + ((r · r) · g · h'))
                + (- scale 4 ((((r + r) · p + (r · r) · p') · f) + ((r · r) · p · f'))) )
              ≡ r · ( scale 15 (g · h) + (scale 6 (r · g' · h) + scale 3 (r · g · h'))
                    + ((p · f + (- (r · p' · f))) + (- (scale 4 (r · p · f')))) )
          shape r g g' h h' p p' f f' = solve! R

      ----------------------------------------------------------------
      -- ३ · rᵏ IS THE INWARD SOLUTION OF THE DEGREE-(k+2) EQUATION.
      ----------------------------------------------------------------

      private
        predℕ : ℕ → ℕ
        predℕ zero    = zero
        predℕ (suc n) = n

        d-pow : (n : ℕ) → d (pow r n) ≡ scale n (pow r (predℕ n))
        d-pow zero    = d-zero'
          where
            d-zero' : d 1r ≡ 0r
            d-zero' = sym ( sym (+InvR (d 1r)) ∙ cong (_+ (- (d 1r))) h ∙ cancelR (d 1r) (d 1r) )
              where
                h : d 1r ≡ d 1r + d 1r
                h = cong d (sym (·IdR 1r)) ∙ d-leib 1r 1r ∙ cong₂ _+_ (·IdR (d 1r)) (·IdL (d 1r))
                cancelR : (x y : A) → (x + y) + (- y) ≡ x
                cancelR x y = solve! R
        d-pow (suc n) =
            d-leib r (pow r n)
          ∙ cong₂ _+_ (cong (_· pow r n) dr ∙ ·IdL (pow r n))
                      (cong (r ·_) (d-pow n) ∙ scale-mulL n (pow r (predℕ n)) r ∙ r·pred n)
          where
            -- at m = 0 both sides are 0r; at m = suc k, r · pow r k is pow r (suc k) on the nose
            r·pred : (m : ℕ) → scale m (r · pow r (predℕ m)) ≡ scale m (pow r m)
            r·pred zero    = refl
            r·pred (suc m) = refl

      -- the radial operator on a power, with the ℕ coefficient exposed
      radial-power : (k : ℕ)
        → (r · r) · d (d (pow r k)) + scale 6 (r · d (pow r k))
          ≡ scale (k ·ℕ (k +ℕ 5)) (pow r k)
      radial-power zero =
          cong₂ _+_ (cong (λ z → (r · r) · d z) d-pow0 ∙ cong ((r · r) ·_) d-zero ∙ 0RightAnnihilates' (r · r))
                    (cong (λ z → scale 6 (r · z)) d-pow0 ∙ cong (scale 6) (0RightAnnihilates' r) ∙ scale-zero 6)
        ∙ +IdR 0r
        where
          d-pow0 : d (pow r zero) ≡ 0r
          d-pow0 = d-pow zero
          0RightAnnihilates' : (x : A) → x · 0r ≡ 0r
          0RightAnnihilates' x = solve! R
          scale-zero : (n : ℕ) → scale n 0r ≡ 0r
          scale-zero zero    = refl
          scale-zero (suc n) = +IdL (scale n 0r) ∙ scale-zero n
      radial-power (suc zero) =
          cong₂ _+_ (cong (λ z → (r · r) · d z) (d-pow 1 ∙ +IdR 1r) ∙ cong ((r · r) ·_) d-one ∙ zeroR (r · r))
                    (cong (λ z → scale 6 (r · z)) (d-pow 1 ∙ +IdR 1r))
        ∙ +IdL (scale 6 (r · 1r))
        where
          d-one : d 1r ≡ 0r
          d-one = d-pow zero
          zeroR : (x : A) → x · 0r ≡ 0r
          zeroR x = solve! R
      radial-power (suc (suc m)) =
          cong₂ _+_ second first
        ∙ sym (scale-+ ((suc (suc m)) ·ℕ (suc m)) (6 ·ℕ (suc (suc m))) (pow r (suc (suc m))))
        ∙ cong (λ n → scale n (pow r (suc (suc m)))) (coef m)
        where
          second : (r · r) · d (d (pow r (suc (suc m))))
                 ≡ scale ((suc (suc m)) ·ℕ (suc m)) (pow r (suc (suc m)))
          second =
              cong (λ z → (r · r) · d z) (d-pow (suc (suc m)))
            ∙ cong ((r · r) ·_) (d-scale (suc (suc m)) (pow r (suc m)) ∙ cong (scale (suc (suc m))) (d-pow (suc m)))
            ∙ scale-mulL (suc (suc m)) (scale (suc m) (pow r m)) (r · r)
            ∙ cong (scale (suc (suc m))) (scale-mulL (suc m) (pow r m) (r · r))
            ∙ sym (scale-· (suc (suc m)) (suc m) ((r · r) · pow r m))
            ∙ cong (scale ((suc (suc m)) ·ℕ (suc m))) (sym (·Assoc r r (pow r m)))

          first : scale 6 (r · d (pow r (suc (suc m))))
                ≡ scale (6 ·ℕ (suc (suc m))) (pow r (suc (suc m)))
          first =
              cong (λ z → scale 6 (r · z)) (d-pow (suc (suc m)))
            ∙ cong (scale 6) (scale-mulL (suc (suc m)) (pow r (suc m)) r)
            ∙ sym (scale-· 6 (suc (suc m)) (r · pow r (suc m)))

          coef : (n : ℕ)
            → ((suc (suc n)) ·ℕ (suc n)) +ℕ (6 ·ℕ (suc (suc n)))
              ≡ (suc (suc n)) ·ℕ ((suc (suc n)) +ℕ 5)
          coef n = solveℕ!

  ------------------------------------------------------------------
  -- २ · THE INDICIAL POLYNOMIAL FACTORS.
  ------------------------------------------------------------------

  private
    two three six : A
    two   = 1r + 1r
    three = 1r + (1r + 1r)
    six   = three + three

  indicial-factors : (k l : A)
    → (k · (k + (- 1r))) + ((six · k) + (- ((l + (- two)) · (l + three))))
      ≡ (k + (- (l + (- two)))) · (k + (l + three))
  indicial-factors k l = solve! R

  -- and at the inward root the coefficient is k(k+5), as §3 exposes
  inward-root-coefficient : (k : A)
    → (k + two + (- two)) · (k + two + three) ≡ k · (k + (three + two))
  inward-root-coefficient k = solve! R
