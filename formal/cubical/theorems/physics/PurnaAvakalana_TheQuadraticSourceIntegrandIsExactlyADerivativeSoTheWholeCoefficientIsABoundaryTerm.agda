{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूर्ण-अवकलन — the complete differential.
--
-- THE QUADRATIC SOURCE INTEGRAND IS EXACTLY A DERIVATIVE.  So the whole
-- coefficient it produces is a boundary term, and the value comes from
-- the ends alone — no interior contribution survives, and nothing is
-- estimated.
--
-- A degree-two source projection with matrix-valued radial profile emits
-- a quadratic expression whose radial integral is the pressure
-- coefficient.  The claim that this coefficient is a pure number rests
-- entirely on the integrand being an exact derivative of an explicit
-- primitive.  That is an algebraic fact about a derivation, it holds in
-- ANY ring — in particular a NONCOMMUTATIVE one, so the radial profile
-- may change eigenframe freely and no two of `G`, `G'`, `G''` need
-- commute — and it is what this module proves.
--
-- Writing `anti x y = x·y + y·x` for the unhalved symmetric product,
-- `B = d G`, `C = d B`, and taking `r` with `d r ≡ 1`:
--
--   §4  d ( 15·G²  +  3·(r · anti G B)  -  (r·r)·B² )
--         ≡  18·anti G B  +  4·(r · B²)  +  3·(r · anti G C)
--                          -  (r·r)·anti C B .
--
-- The right-hand side is the integrand; the left is a derivative; the
-- primitive is displayed rather than asserted to exist.  Halves have
-- been cleared throughout — `anti` is twice the Jordan product — so the
-- identity holds with no division by two and hence in every
-- characteristic.
--
--   §1  `scale` and its two laws, and a cancellation.  Everything is
--       iterated addition; there are no numerals in any statement.
--
--   §2  THE FOUR FACTS ABOUT THE DERIVATION that the computation needs:
--       it kills zero, it commutes with negation, it commutes with
--       iterated addition, and it acts on `anti` and on a square by the
--       Leibniz rule.  Each follows from additivity and Leibniz alone —
--       `d 0 ≡ 0` and `d (- x) ≡ - d x` are DERIVED, not assumed.
--
--   §3  d (r · x) ≡ x + r · (d x)  and  d (r·r) ≡ r + r, from `d r ≡ 1`.
--
-- WHAT IS NOT NEEDED, and it is worth saying because it is what makes
-- the identity transportable: `r` is NOT assumed central.  Centrality is
-- needed only to rewrite the integrand into the `V = r·B`, `W = r·r·C`
-- variables in which it is usually displayed; the identity itself, in
-- the form above, never moves `r` past anything.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 in any ring, for any additive `d`
-- obeying the Leibniz rule, any `r` with `d r ≡ 1r`, and any `G`.  NOT
-- claimed: that the integrand IS the angular average of anything — the
-- spherical moment computation producing it is an integral over the
-- sphere and has no carrier in this corpus, so the expression is taken
-- as given and only its exactness is proved; the value of the boundary
-- term, which needs decay hypotheses and a limit; the coefficient -2/7,
-- which is that boundary value divided by seven and is therefore NOT
-- stated here; anything about pressure, strain, symmetry, or
-- trace-freeness — `G` is an arbitrary ring element; and nothing about
-- integration, which does not occur below.
------------------------------------------------------------------------

module PurnaAvakalana_TheQuadraticSourceIntegrandIsExactlyADerivativeSoTheWholeCoefficientIsABoundaryTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_+_ to _+ℕ_)
open import Cubical.Algebra.Ring

private
  variable
    ℓ : Level

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

  ------------------------------------------------------------------
  -- १ · Iterated addition, its two laws, and one cancellation.
  ------------------------------------------------------------------

  scale : ℕ → A → A
  scale zero    a = 0r
  scale (suc n) a = a + scale n a

  scale-+ : (m n : ℕ) (a : A) → scale (m +ℕ n) a ≡ scale m a + scale n a
  scale-+ zero    n a = sym (+IdL (scale n a))
  scale-+ (suc m) n a =
    cong (a +_) (scale-+ m n a) ∙ +Assoc a (scale m a) (scale n a)

  scale-dist : (n : ℕ) (a b : A) → scale n (a + b) ≡ scale n a + scale n b
  scale-dist zero    a b = sym (+IdL 0r)
  scale-dist (suc n) a b =
      cong ((a + b) +_) (scale-dist n a b)
    ∙ +ShufflePairs a b (scale n a) (scale n b)

  private
    cancelR : (x y : A) → (x + y) + (- y) ≡ x
    cancelR x y =
      sym (+Assoc x y (- y)) ∙ cong (x +_) (+InvR y) ∙ +IdR x

  -- six copies minus two copies is four copies
  six-minus-two : (x : A) → scale 6 x + (- (x + x)) ≡ scale 4 x
  six-minus-two x =
      cong (λ z → z + (- (x + x)))
           ( scale-+ 4 2 x
           ∙ cong (scale 4 x +_) (cong (x +_) (+IdR x)) )
    ∙ cancelR (scale 4 x) (x + x)

  ------------------------------------------------------------------
  -- The symmetric product, unhalved.
  ------------------------------------------------------------------

  anti : A → A → A
  anti x y = (x · y) + (y · x)

  anti-sym : (x y : A) → anti x y ≡ anti y x
  anti-sym x y = +Comm (x · y) (y · x)

  ------------------------------------------------------------------
  -- २ · The derivation, and the four facts the computation needs.
  ------------------------------------------------------------------

  module _ (d : A → A)
           (dAdd : (x y : A) → d (x + y) ≡ d x + d y)
           (leib : (x y : A) → d (x · y) ≡ (d x · y) + (x · d y))
           where

    d-zero : d 0r ≡ 0r
    d-zero =
      sym ( sym (+InvR (d 0r))
          ∙ cong (_+ (- (d 0r))) h
          ∙ cancelR (d 0r) (d 0r) )
      where
        h : d 0r ≡ d 0r + d 0r
        h = cong d (sym (+IdR 0r)) ∙ dAdd 0r 0r

    d-neg : (x : A) → d (- x) ≡ - (d x)
    d-neg x =
      implicitInverse (d x) (d (- x))
        (sym (dAdd x (- x)) ∙ cong d (+InvR x) ∙ d-zero)

    d-scale : (n : ℕ) (x : A) → d (scale n x) ≡ scale n (d x)
    d-scale zero    x = d-zero
    d-scale (suc n) x = dAdd x (scale n x) ∙ cong (d x +_) (d-scale n x)

    d-sqr : (x : A) → d (x · x) ≡ anti (d x) x
    d-sqr x = leib x x

    d-anti : (x y : A) → d (anti x y) ≡ anti (d x) y + anti x (d y)
    d-anti x y =
        dAdd (x · y) (y · x)
      ∙ cong₂ _+_ (leib x y) (leib y x)
      ∙ cong (((d x · y) + (x · d y)) +_) (+Comm (d y · x) (y · d x))
      ∙ +ShufflePairs (d x · y) (x · d y) (y · d x) (d y · x)

    ----------------------------------------------------------------
    -- ३ · The radius: everything the hypothesis `d r ≡ 1` gives.
    ----------------------------------------------------------------

    module _ (r : A) (dr : d r ≡ 1r) where

      d-rmul : (x : A) → d (r · x) ≡ x + (r · d x)
      d-rmul x = leib r x ∙ cong (_+ (r · d x)) (cong (_· x) dr ∙ ·IdL x)

      d-rr : d (r · r) ≡ r + r
      d-rr =
          leib r r
        ∙ cong₂ _+_ (cong (_· r) dr ∙ ·IdL r) (cong (r ·_) dr ∙ ·IdR r)

      --------------------------------------------------------------
      -- ४ · THE INTEGRAND IS EXACTLY A DERIVATIVE.
      --------------------------------------------------------------

      module _ (G : A) where

        private
          B C : A
          B = d G
          C = d B

          X Y Z T : A
          X = r · (B · B)
          Y = r · anti G C
          Z = (r · r) · anti C B
          T = anti G B

        antiderivative : A
        antiderivative =
          scale 15 (G · G) + (scale 3 (r · anti G B) + (- ((r · r) · (B · B))))

        integrand : A
        integrand = scale 18 T + (scale 4 X + (scale 3 Y + (- Z)))

        exact : d antiderivative ≡ integrand
        exact =
            d (scale 15 (G · G)
                 + (scale 3 (r · anti G B) + (- ((r · r) · (B · B)))))
          ≡⟨ dAdd (scale 15 (G · G))
                  (scale 3 (r · anti G B) + (- ((r · r) · (B · B)))) ⟩
            d (scale 15 (G · G))
              + d (scale 3 (r · anti G B) + (- ((r · r) · (B · B))))
          ≡⟨ cong₂ _+_ head
                  ( dAdd (scale 3 (r · anti G B)) (- ((r · r) · (B · B)))
                  ∙ cong₂ _+_ middle tail ) ⟩
            scale 15 T + ((scale 3 T + (scale 6 X + scale 3 Y))
                            + (- ((X + X) + Z)))
          ≡⟨ +Assoc (scale 15 T)
                    (scale 3 T + (scale 6 X + scale 3 Y))
                    (- ((X + X) + Z)) ⟩
            (scale 15 T + (scale 3 T + (scale 6 X + scale 3 Y)))
              + (- ((X + X) + Z))
          ≡⟨ cong (_+ (- ((X + X) + Z)))
                  (+Assoc (scale 15 T) (scale 3 T) (scale 6 X + scale 3 Y)) ⟩
            ((scale 15 T + scale 3 T) + (scale 6 X + scale 3 Y))
              + (- ((X + X) + Z))
          ≡⟨ cong (λ z → (z + (scale 6 X + scale 3 Y)) + (- ((X + X) + Z)))
                  (sym (scale-+ 15 3 T)) ⟩
            (scale 18 T + (scale 6 X + scale 3 Y)) + (- ((X + X) + Z))
          ≡⟨ sym (+Assoc (scale 18 T) (scale 6 X + scale 3 Y)
                         (- ((X + X) + Z))) ⟩
            scale 18 T + ((scale 6 X + scale 3 Y) + (- ((X + X) + Z)))
          ≡⟨ cong (λ z → scale 18 T + ((scale 6 X + scale 3 Y) + z))
                  (sym (-Dist (X + X) Z)) ⟩
            scale 18 T + ((scale 6 X + scale 3 Y) + ((- (X + X)) + (- Z)))
          ≡⟨ cong (scale 18 T +_)
                  (+ShufflePairs (scale 6 X) (scale 3 Y) (- (X + X)) (- Z)) ⟩
            scale 18 T + ((scale 6 X + (- (X + X))) + (scale 3 Y + (- Z)))
          ≡⟨ cong (λ z → scale 18 T + (z + (scale 3 Y + (- Z))))
                  (six-minus-two X) ⟩
            scale 18 T + (scale 4 X + (scale 3 Y + (- Z))) ∎
          where
            head : d (scale 15 (G · G)) ≡ scale 15 T
            head =
                d-scale 15 (G · G)
              ∙ cong (scale 15) (d-sqr G ∙ anti-sym B G)

            inner : d (r · anti G B) ≡ T + ((X + X) + Y)
            inner =
                d-rmul (anti G B)
              ∙ cong (anti G B +_)
                     ( cong (r ·_) (d-anti G B)
                     ∙ ·DistR+ r (anti B B) (anti G C)
                     ∙ cong (_+ (r · anti G C))
                            (·DistR+ r (B · B) (B · B)) )

            middle : d (scale 3 (r · anti G B))
                   ≡ scale 3 T + (scale 6 X + scale 3 Y)
            middle =
                d-scale 3 (r · anti G B)
              ∙ cong (scale 3) inner
              ∙ scale-dist 3 T ((X + X) + Y)
              ∙ cong (scale 3 T +_)
                     ( scale-dist 3 (X + X) Y
                     ∙ cong (_+ scale 3 Y)
                            (scale-dist 3 X X ∙ sym (scale-+ 3 3 X)) )

            tail : d (- ((r · r) · (B · B))) ≡ - ((X + X) + Z)
            tail =
                d-neg ((r · r) · (B · B))
              ∙ cong -_
                     ( leib (r · r) (B · B)
                     ∙ cong₂ _+_
                         (cong (_· (B · B)) d-rr ∙ ·DistL+ r r (B · B))
                         (cong ((r · r) ·_) (d-sqr B)) )
