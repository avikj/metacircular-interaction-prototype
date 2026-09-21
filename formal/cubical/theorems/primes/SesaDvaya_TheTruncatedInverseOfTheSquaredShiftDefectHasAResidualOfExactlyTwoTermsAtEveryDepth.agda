{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शेष-द्वय — the twofold remainder.
--
-- TRUNCATING THE INVERSE OF A SQUARED SHIFT DEFECT LEAVES EXACTLY TWO
-- TERMS.  At every depth, with no unspecified approximation remainder
-- and no estimate anywhere in the proof.
--
-- `AdrsyaMana` handles the ADDITIVE second difference: its kernel is the
-- affine sequences, exactly.  This module handles the MULTIPLICATIVE
-- one.  In a commutative ring with a distinguished element `x` — read as
-- an attenuated shift — the operator
--
--     sq x  =  (1 - x) · (1 - x)
--
-- is the second difference of the shift algebra, and its formal inverse
-- is the double sum Σ (j+1) xʲ.  Truncating that sum at depth N gives
--
--   §2  sq x · arith x N
--         ≡  1  -  (N+2) x^{N+1}  +  (N+1) x^{N+2} .
--
--       Two terms.  Not "two terms plus a controlled tail" — the
--       identity is exact at every N, and the whole proof is one
--       induction whose step is that successive right-hand sides differ
--       by (N+2) x^{N+1} (1-x)², which is precisely the term the sum
--       gained.  Nothing is dropped, so nothing needs bounding.
--
--       Integer coefficients are iterated addition (`scale`), so the
--       statement holds over ANY commutative ring: no characteristic
--       hypothesis, no division by N, and no numerals.
--
--   §1  the four facts about iterated addition the induction needs —
--       that it distributes over a sum, over a negation, over a product
--       on the right, and that its index adds.  Each is a short
--       induction whose algebra step is closed by the ring solver.
--
--   §3  and the two-term shape, isolated: the residual of the truncation
--       is `(N+1) x^{N+2} - (N+2) x^{N+1}`, both terms carrying the
--       depth explicitly in their coefficient AND their power.  A reader
--       who wants a bound reads it off this; the theorem does not
--       provide one and does not need one to be exact.
--
-- WHY THE COEFFICIENTS ARE `scale` AND NOT NUMERALS.  A numeral would
-- require a map ℕ → R and an argument that it behaves; `scale n a` is
-- `a + ⋯ + a` and its four laws in §1 are all that is ever used.  This
-- is the same choice `AdrsyaMana` makes for `n · (Δ f 0)`, for the same
-- reason, and it is why both modules hold in every characteristic.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–3 over any commutative ring, for every
-- element and every depth.  NOT claimed: convergence of the untruncated
-- sum, which is not formed here — `arith x N` is a finite sum and every
-- statement is at finite N; that `x` is a shift, an operator, or has any
-- norm — it is a ring element; that the residual is SMALL, which needs
-- an order and an estimate and is exactly what this module refuses to
-- assert; anything about a convolution, a packet, or a transform; and
-- nothing about what the inverse is an inverse OF beyond the displayed
-- equation.
------------------------------------------------------------------------

module SesaDvaya_TheTruncatedInverseOfTheSquaredShiftDefectHasAResidualOfExactlyTwoTermsAtEveryDepth where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_+_ to _+ℕ_)
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

  --------------------------------------------------------------------
  -- ० · Iterated addition, powers, the truncated double sum, and the
  --     squared defect.
  --------------------------------------------------------------------

  scale : ℕ → A → A
  scale zero    a = 0r
  scale (suc n) a = a + scale n a

  pow : A → ℕ → A
  pow x zero    = 1r
  pow x (suc n) = x · pow x n

  -- Σ_{j=0}^{N} (j+1) xʲ
  arith : A → ℕ → A
  arith x zero    = 1r
  arith x (suc n) = arith x n + scale (suc (suc n)) (pow x (suc n))

  sq : A → A
  sq x = (1r + (- x)) · (1r + (- x))

  --------------------------------------------------------------------
  -- १ · THE FOUR LAWS OF ITERATED ADDITION.
  --------------------------------------------------------------------

  scale-+ : (m n : ℕ) (a : A) → scale (m +ℕ n) a ≡ scale m a + scale n a
  scale-+ zero    n a = sym (+IdL (scale n a))
  scale-+ (suc m) n a =
      cong (a +_) (scale-+ m n a) ∙ +Assoc a (scale m a) (scale n a)

  scale-dist : (n : ℕ) (a b : A) → scale n (a + b) ≡ scale n a + scale n b
  scale-dist zero    a b = sym (+IdL 0r)
  scale-dist (suc n) a b =
      cong ((a + b) +_) (scale-dist n a b) ∙ shuffle a b (scale n a) (scale n b)
    where
      shuffle : (p q u v : A) → (p + q) + (u + v) ≡ (p + u) + (q + v)
      shuffle p q u v = solve! R

  scale-neg : (n : ℕ) (a : A) → scale n (- a) ≡ - scale n a
  scale-neg zero    a = negZero
    where
      negZero : 0r ≡ - 0r
      negZero = solve! R
  scale-neg (suc n) a =
      cong ((- a) +_) (scale-neg n a) ∙ pull a (scale n a)
    where
      pull : (p u : A) → (- p) + (- u) ≡ - (p + u)
      pull p u = solve! R

  scale-mul : (n : ℕ) (a b : A) → (scale n a) · b ≡ scale n (a · b)
  scale-mul zero    a b = zeroL b
    where
      zeroL : (u : A) → 0r · u ≡ 0r
      zeroL u = solve! R
  scale-mul (suc n) a b =
      ·DistL+ a (scale n a) b ∙ cong ((a · b) +_) (scale-mul n a b)

  --------------------------------------------------------------------
  -- ३ · THE TWO-TERM RESIDUAL SHAPE.
  --------------------------------------------------------------------

  Res : A → ℕ → A
  Res x N =
      (1r + (- scale (suc (suc N)) (pow x (suc N))))
    + scale (suc N) (pow x (suc (suc N)))

  --------------------------------------------------------------------
  -- २ · THE IDENTITY, at every depth.
  --------------------------------------------------------------------

  truncated-inverse : (x : A) (N : ℕ) → sq x · arith x N ≡ Res x N
  truncated-inverse x zero = base x
    where
      base : (y : A)
        → ((1r + (- y)) · (1r + (- y))) · 1r
          ≡ (1r + (- ((y · 1r) + ((y · 1r) + 0r)))) + ((y · (y · 1r)) + 0r)
      base y = solve! R
  truncated-inverse x (suc N) =
      sq x · (arith x N + scale (suc (suc N)) P)
    ≡⟨ ·DistR+ (sq x) (arith x N) (scale (suc (suc N)) P) ⟩
      (sq x · arith x N) + (sq x · scale (suc (suc N)) P)
    ≡⟨ cong₂ _+_ (truncated-inverse x N) pullOut ⟩
      Res x N + scale (suc (suc N)) (sq x · P)
    ≡⟨ cong (λ z → Res x N + scale (suc (suc N)) z) (expandShape x P) ⟩
      Res x N + scale (suc (suc N)) ((P + (- (Q + Q))) + Rr)
    ≡⟨ cong (Res x N +_) distribute ⟩
      Res x N
        + ((scale (suc (suc N)) P
              + (- (scale (suc (suc N)) Q + scale (suc (suc N)) Q)))
           + scale (suc (suc N)) Rr)
    ≡⟨ cong (λ z → Res x N
                     + ((scale (suc (suc N)) P + (- z))
                        + scale (suc (suc N)) Rr)) key ⟩
      Res x N
        + ((scale (suc (suc N)) P
              + (- (scale (suc N) Q + scale (suc (suc (suc N))) Q)))
           + scale (suc (suc N)) Rr)
    ≡⟨ collapse 1r (scale (suc (suc N)) P) (scale (suc N) Q)
                (scale (suc (suc (suc N))) Q) (scale (suc (suc N)) Rr) ⟩
      Res x (suc N) ∎
    where
      P Q Rr : A
      P  = pow x (suc N)
      Q  = x · P
      Rr = x · Q

      pullOut : sq x · scale (suc (suc N)) P ≡ scale (suc (suc N)) (sq x · P)
      pullOut =
          ·Comm (sq x) (scale (suc (suc N)) P)
        ∙ scale-mul (suc (suc N)) P (sq x)
        ∙ cong (scale (suc (suc N))) (·Comm P (sq x))

      expandShape : (y p : A)
        → ((1r + (- y)) · (1r + (- y))) · p
          ≡ (p + (- ((y · p) + (y · p)))) + (y · (y · p))
      expandShape y p = solve! R

      distribute :
          scale (suc (suc N)) ((P + (- (Q + Q))) + Rr)
        ≡ (scale (suc (suc N)) P
             + (- (scale (suc (suc N)) Q + scale (suc (suc N)) Q)))
          + scale (suc (suc N)) Rr
      distribute =
          scale-dist (suc (suc N)) (P + (- (Q + Q))) Rr
        ∙ cong (_+ scale (suc (suc N)) Rr)
               ( scale-dist (suc (suc N)) P (- (Q + Q))
               ∙ cong (scale (suc (suc N)) P +_)
                      ( scale-neg (suc (suc N)) (Q + Q)
                      ∙ cong -_ (scale-dist (suc (suc N)) Q Q) ) )

      key : scale (suc (suc N)) Q + scale (suc (suc N)) Q
          ≡ scale (suc N) Q + scale (suc (suc (suc N))) Q
      key =
          sym (scale-+ (suc (suc N)) (suc (suc N)) Q)
        ∙ cong (λ m → scale m Q) index
        ∙ scale-+ (suc N) (suc (suc (suc N))) Q
        where
          index : (suc (suc N)) +ℕ (suc (suc N))
                ≡ (suc N) +ℕ (suc (suc (suc N)))
          index = solveℕ!

      collapse : (u p q₁ q₃ s : A)
        → ((u + (- p)) + q₁) + ((p + (- (q₁ + q₃))) + s) ≡ (u + (- q₃)) + s
      collapse u p q₁ q₃ s = solve! R
