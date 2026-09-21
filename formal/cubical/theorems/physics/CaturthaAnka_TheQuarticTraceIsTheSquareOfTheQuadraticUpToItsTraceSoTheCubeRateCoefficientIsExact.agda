{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चतुर्थ-अङ्क — the fourth power.
--
-- FOR EVERY 3×3 MATRIX OVER EVERY COMMUTATIVE RING, TWICE THE QUARTIC
-- TRACE IS THE SQUARE OF THE QUADRATIC TRACE, UP TO AN EXPLICIT
-- MULTIPLE OF THE TRACE ITSELF.  So at trace zero the two agree exactly,
-- and the cube-rate coefficient that follows is a checked number rather
-- than a quoted one.
--
--   §1  THE GENERAL IDENTITY, with no hypothesis on the matrix at all:
--
--         2·tr(M⁴)  ≡  (tr M²)²
--                      + (tr M)·( 2·(tr M)(tr M²) + 8·det M - (tr M)³ ) .
--
--       This is Newton's identity for a 3×3 characteristic polynomial,
--       stated so that the trace-free case is a substitution and not a
--       separate computation.  It is one call to the commutative-ring
--       solver on the nine entries; no eigenvalues, no field, no
--       characteristic hypothesis, no symmetry.
--
--   §2  HENCE AT TRACE ZERO:  2·tr(M⁴) ≡ (tr M²)² .
--
--   §3  AND IN DEVIATORIC FORM.  Writing `dev M = 3M - (tr M)·I` for the
--       trace-free part CLEARED OF ITS THIRD,
--
--         2·tr( M² · dev(M²) )  ≡  (tr M²)²      when tr M ≡ 0 .
--
--       This is the whole content of the cube-rate coefficient: the
--       quadratic invariant's square, with a factor of two and nothing
--       else.
--
--   §4  SO THE COEFFICIENT IS EXACT.  If a strain law reads, cleared of
--       its denominator,
--
--         21·X  ≡  -5·dev(S²)  -  21·K
--
--       — which is `∂S = -(5/7)(S²)₀ - K` multiplied by 21 — then for
--       every correction `K` whatsoever,
--
--         42·tr(S²·X)  ≡  -5·(tr S²)²  -  42·tr(S²·K) .
--
--       Dividing by 42 and using ∂(tr S³) = 3·tr(S²·X) this is the
--       -5/14 law; the division is left to the reader because the ring
--       need not admit it.  `K` is arbitrary — it is never assumed to be
--       a pressure term, and §4 says nothing about what it contains.
--
-- WHY §1 AND NOT ONLY §2.  Carrying the trace correction costs one
-- solver call and buys the identity for every matrix, so a later use at
-- a non-trace-free matrix does not need a new computation; and it makes
-- the trace-free hypothesis visible as the ONE place it enters, rather
-- than baked into a substituted representation.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 over any commutative ring, for every
-- 3×3 matrix.  NOT claimed: anything about a material derivative — `X`
-- in §4 is an arbitrary matrix constrained only by the displayed
-- equation, and no evolution is differentiated anywhere; that any
-- particular `K` is what a pressure Hessian, a rotation term, or a
-- viscous term contributes; symmetry or trace-freeness of anything
-- beyond the stated hypothesis; and no eigenvalues, discriminants, or
-- orderings — `q³ - 6r²` does not appear and no order relation exists in
-- this file.
------------------------------------------------------------------------

module CaturthaAnka_TheQuarticTraceIsTheSquareOfTheQuadraticUpToItsTraceSoTheCubeRateCoefficientIsExact where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_+_ to _+ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  ------------------------------------------------------------------
  -- ० · Iterated addition, and 3×3 matrices with their operations.
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
      cong ((a + b) +_) (scale-dist n a b) ∙ shuffle a b (scale n a) (scale n b)
    where
      shuffle : (p q u v : A) → (p + q) + (u + v) ≡ (p + u) + (q + v)
      shuffle p q u v = solve! R

  record M3 : Type ℓ where
    constructor mat
    field
      a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ : A
  open M3 public

  infixl 7 _⊗_
  infixl 6 _⊕_

  _⊗_ : M3 → M3 → M3
  (M ⊗ N) .a₁₁ = (a₁₁ M · a₁₁ N) + ((a₁₂ M · a₂₁ N) + (a₁₃ M · a₃₁ N))
  (M ⊗ N) .a₁₂ = (a₁₁ M · a₁₂ N) + ((a₁₂ M · a₂₂ N) + (a₁₃ M · a₃₂ N))
  (M ⊗ N) .a₁₃ = (a₁₁ M · a₁₃ N) + ((a₁₂ M · a₂₃ N) + (a₁₃ M · a₃₃ N))
  (M ⊗ N) .a₂₁ = (a₂₁ M · a₁₁ N) + ((a₂₂ M · a₂₁ N) + (a₂₃ M · a₃₁ N))
  (M ⊗ N) .a₂₂ = (a₂₁ M · a₁₂ N) + ((a₂₂ M · a₂₂ N) + (a₂₃ M · a₃₂ N))
  (M ⊗ N) .a₂₃ = (a₂₁ M · a₁₃ N) + ((a₂₂ M · a₂₃ N) + (a₂₃ M · a₃₃ N))
  (M ⊗ N) .a₃₁ = (a₃₁ M · a₁₁ N) + ((a₃₂ M · a₂₁ N) + (a₃₃ M · a₃₁ N))
  (M ⊗ N) .a₃₂ = (a₃₁ M · a₁₂ N) + ((a₃₂ M · a₂₂ N) + (a₃₃ M · a₃₂ N))
  (M ⊗ N) .a₃₃ = (a₃₁ M · a₁₃ N) + ((a₃₂ M · a₂₃ N) + (a₃₃ M · a₃₃ N))

  _⊕_ : M3 → M3 → M3
  (M ⊕ N) .a₁₁ = a₁₁ M + a₁₁ N
  (M ⊕ N) .a₁₂ = a₁₂ M + a₁₂ N
  (M ⊕ N) .a₁₃ = a₁₃ M + a₁₃ N
  (M ⊕ N) .a₂₁ = a₂₁ M + a₂₁ N
  (M ⊕ N) .a₂₂ = a₂₂ M + a₂₂ N
  (M ⊕ N) .a₂₃ = a₂₃ M + a₂₃ N
  (M ⊕ N) .a₃₁ = a₃₁ M + a₃₁ N
  (M ⊕ N) .a₃₂ = a₃₂ M + a₃₂ N
  (M ⊕ N) .a₃₃ = a₃₃ M + a₃₃ N

  ⊖_ : M3 → M3
  (⊖ M) .a₁₁ = - a₁₁ M
  (⊖ M) .a₁₂ = - a₁₂ M
  (⊖ M) .a₁₃ = - a₁₃ M
  (⊖ M) .a₂₁ = - a₂₁ M
  (⊖ M) .a₂₂ = - a₂₂ M
  (⊖ M) .a₂₃ = - a₂₃ M
  (⊖ M) .a₃₁ = - a₃₁ M
  (⊖ M) .a₃₂ = - a₃₂ M
  (⊖ M) .a₃₃ = - a₃₃ M

  0M : M3
  0M = mat 0r 0r 0r 0r 0r 0r 0r 0r 0r

  scaleM : ℕ → M3 → M3
  scaleM zero    M = 0M
  scaleM (suc n) M = M ⊕ scaleM n M

  trM : M3 → A
  trM M = a₁₁ M + (a₂₂ M + a₃₃ M)

  detM : M3 → A
  detM M =
      (a₁₁ M · ((a₂₂ M · a₃₃ M) + (- (a₂₃ M · a₃₂ M))))
    + ( (- (a₁₂ M · ((a₂₁ M · a₃₃ M) + (- (a₂₃ M · a₃₁ M)))))
      + (a₁₃ M · ((a₂₁ M · a₃₂ M) + (- (a₂₂ M · a₃₁ M)))))

  -- the trace-free part, cleared of its third:  dev M = 3M - (tr M)·I
  dev : M3 → M3
  dev M .a₁₁ = (a₁₁ M + (a₁₁ M + a₁₁ M)) + (- trM M)
  dev M .a₁₂ = a₁₂ M + (a₁₂ M + a₁₂ M)
  dev M .a₁₃ = a₁₃ M + (a₁₃ M + a₁₃ M)
  dev M .a₂₁ = a₂₁ M + (a₂₁ M + a₂₁ M)
  dev M .a₂₂ = (a₂₂ M + (a₂₂ M + a₂₂ M)) + (- trM M)
  dev M .a₂₃ = a₂₃ M + (a₂₃ M + a₂₃ M)
  dev M .a₃₁ = a₃₁ M + (a₃₁ M + a₃₁ M)
  dev M .a₃₂ = a₃₂ M + (a₃₂ M + a₃₂ M)
  dev M .a₃₃ = (a₃₃ M + (a₃₃ M + a₃₃ M)) + (- trM M)

  ------------------------------------------------------------------
  -- Trace-pairing is linear in its second slot.  Three solver lines
  -- and one induction; used only in §4.
  ------------------------------------------------------------------

  tr⊗-add : (M N P : M3) → trM (M ⊗ (N ⊕ P)) ≡ trM (M ⊗ N) + trM (M ⊗ P)
  tr⊗-add M N P = solve! R

  tr⊗-neg : (M N : M3) → trM (M ⊗ (⊖ N)) ≡ - trM (M ⊗ N)
  tr⊗-neg M N = solve! R

  tr⊗-zero : (M : M3) → trM (M ⊗ 0M) ≡ 0r
  tr⊗-zero M = solve! R

  tr⊗-scale : (n : ℕ) (M N : M3)
    → trM (M ⊗ scaleM n N) ≡ scale n (trM (M ⊗ N))
  tr⊗-scale zero    M N = tr⊗-zero M
  tr⊗-scale (suc n) M N =
    tr⊗-add M N (scaleM n N) ∙ cong (trM (M ⊗ N) +_) (tr⊗-scale n M N)

  ------------------------------------------------------------------
  -- १ · THE GENERAL QUARTIC TRACE IDENTITY.
  ------------------------------------------------------------------

  quartic-trace : (M : M3)
    → let Q = M ⊗ M
          t = trM M
          q = trM Q
      in (trM (Q ⊗ Q) + trM (Q ⊗ Q))
         ≡ (q · q)
           + (t · ( (((t · q) + (t · q))
                     + (detM M + (detM M + (detM M + (detM M
                       + (detM M + (detM M + (detM M + detM M))))))))
                    + (- (t · (t · t)))))
  quartic-trace M = solve! R

  ------------------------------------------------------------------
  -- २ · HENCE AT TRACE ZERO.
  ------------------------------------------------------------------

  quartic-trace-free : (M : M3) → trM M ≡ 0r
    → let Q = M ⊗ M in (trM (Q ⊗ Q) + trM (Q ⊗ Q)) ≡ trM Q · trM Q
  quartic-trace-free M h =
      quartic-trace M
    ∙ cong (λ z → (q · q) + (z · P)) h
    ∙ cong ((q · q) +_) (kill P)
    ∙ +IdR (q · q)
    where
      t q : A
      t = trM M
      q = trM (M ⊗ M)

      P : A
      P = (((t · q) + (t · q))
            + (detM M + (detM M + (detM M + (detM M
              + (detM M + (detM M + (detM M + detM M))))))))
          + (- (t · (t · t)))

      kill : (x : A) → 0r · x ≡ 0r
      kill x = solve! R

  ------------------------------------------------------------------
  -- ३ · AND IN DEVIATORIC FORM.  This is the cube-rate coefficient.
  ------------------------------------------------------------------

  dev-pairing : (N : M3)
    → trM (N ⊗ dev N)
      ≡ (trM (N ⊗ N) + (trM (N ⊗ N) + trM (N ⊗ N))) + (- (trM N · trM N))
  dev-pairing N = solve! R

  deviatoric-square : (M : M3) → trM M ≡ 0r
    → let Q = M ⊗ M in
      (trM (Q ⊗ dev Q) + trM (Q ⊗ dev Q)) ≡ trM Q · trM Q
  deviatoric-square M h =
      cong₂ _+_ (dev-pairing (M ⊗ M)) (dev-pairing (M ⊗ M))
    ∙ collapse (trM ((M ⊗ M) ⊗ (M ⊗ M))) (trM (M ⊗ M))
               (quartic-trace-free M h)
    where
      collapse : (t4 q : A)
        → (t4 + t4) ≡ q · q
        → ((t4 + (t4 + t4)) + (- (q · q))) + ((t4 + (t4 + t4)) + (- (q · q)))
          ≡ q · q
      collapse t4 q e =
          cong (λ z → ((t4 + (t4 + t4)) + (- z))
                        + ((t4 + (t4 + t4)) + (- z))) (sym e)
        ∙ shape t4
        ∙ e
        where
          shape : (u : A)
            → ((u + (u + u)) + (- (u + u))) + ((u + (u + u)) + (- (u + u)))
              ≡ u + u
          shape u = solve! R

  ------------------------------------------------------------------
  -- ४ · SO THE CUBE-RATE COEFFICIENT IS EXACT.
  ------------------------------------------------------------------

  cube-rate : (S K X : M3) → trM S ≡ 0r
    → scaleM 21 X ≡ (⊖ (scaleM 5 (dev (S ⊗ S)))) ⊕ (⊖ (scaleM 21 K))
    → scale 42 (trM ((S ⊗ S) ⊗ X))
      ≡ (- (scale 5 (trM (S ⊗ S) · trM (S ⊗ S))))
        + (- (scale 42 (trM ((S ⊗ S) ⊗ K))))
  cube-rate S K X h law =
      scale-+ 21 21 dts
    ∙ cong (λ z → z + z) twentyone
    ∙ regroup (scale 5 u) (scale 21 k)
    ∙ cong₂ (λ p q → (- p) + (- q))
            ( sym (scale-dist 5 u u)
            ∙ cong (scale 5) (deviatoric-square S h) )
            (sym (scale-+ 21 21 k))
    where
      Q : M3
      Q = S ⊗ S

      dts u k : A
      dts = trM (Q ⊗ X)
      u   = trM (Q ⊗ dev Q)
      k   = trM (Q ⊗ K)

      twentyone : scale 21 dts ≡ (- (scale 5 u)) + (- (scale 21 k))
      twentyone =
          sym (tr⊗-scale 21 Q X)
        ∙ cong (λ z → trM (Q ⊗ z)) law
        ∙ tr⊗-add Q (⊖ (scaleM 5 (dev Q))) (⊖ (scaleM 21 K))
        ∙ cong₂ _+_
            (tr⊗-neg Q (scaleM 5 (dev Q))
              ∙ cong -_ (tr⊗-scale 5 Q (dev Q)))
            (tr⊗-neg Q (scaleM 21 K)
              ∙ cong -_ (tr⊗-scale 21 Q K))

      regroup : (p q : A)
        → ((- p) + (- q)) + ((- p) + (- q)) ≡ (- (p + p)) + (- (q + q))
      regroup p q = solve! R
