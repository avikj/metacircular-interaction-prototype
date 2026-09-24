{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DiscriminantIsTheOnlyFirstIntegral — up to cubic degree, every
-- polynomial first integral of the restricted-Euler field is affine in
-- the discriminant; and the pushforward fibre over a (Q, R) point is
-- unbounded.
--
-- Continuing VieillefosseFibre.  In the cleared invariants (q, r) =
-- (tr A², tr A³) the doubled restricted-Euler field is W = (−4r, −q²),
-- and Δ = 6r² − q³ was shown to be a first integral.  The question left:
-- is there any OTHER polynomial first integral, i.e. a coercive fold
-- the closed quotient dynamics might respect?
--
--   §1  A polynomial of total degree ≤ 3 in (q, r) is ten coefficients.
--       Its derivative along W is a polynomial of degree ≤ 4, computed
--       SYMBOLICALLY as a linear map on coefficients (`along`), and
--       `along-evaluates` checks (solver, twelve variables) that the
--       symbolic derivative evaluates to ∂F/∂q·W₁ + ∂F/∂r·W₂.
--   §2  THE CLASSIFICATION.  If the symbolic derivative is the zero
--       polynomial then all coefficients vanish except c₀₀ and c₃₀, and
--       c₀₂ ≡ −6·c₃₀: F ≡ c₀₀ + c₃₀·(q³ − 6r²) = c₀₀ − c₃₀·Δ.  Each step is
--       a cancellation in ℤ (isIntegralℤ).  So up to cubic degree the
--       discriminant is the only first integral, and it is not coercive
--       (VieillefosseFibre: its zero fibre carries ℕ).
--   §3  THE PUSHFORWARD FIBRE IS UNBOUNDED.  Over the observed point
--       y₀ = (Q₂ A₀ , R₃ A₀), scaling the Hessian direction H by t gives
--       Q̇ right-hand sides −3·tr A₀³ − 6t, an injection of ℤ into the
--       pushforward set.  Read with the fact that for a spatially linear
--       field u = Ax the deviatoric Hessian is a free parameter (a
--       reading, not proved here): the escape move at every point of the
--       tail is inhabited at every magnitude and both signs, so nothing
--       confined to (Q, R, H) can empty it.
--
-- SYĀT — THE CLAIM, EXACTLY.  Linear algebra over ℤ on ten coefficients,
-- one solver identity, one injection.  Degree ≤ 3 only; no claim about
-- higher degree or non-polynomial integrals.  No flow, no time.
------------------------------------------------------------------------

module DiscriminantIsTheOnlyFirstIntegral_UpToCubicDegreeEveryPolynomialFirstIntegralOfRestrictedEulerIsAffineInTheDiscriminantAndThePushforwardFibreIsUnbounded where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _·_ ; _+_ ; -_ ; _-_)
open import Cubical.Data.Int.Properties using (isIntegralℤ)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver

open import QRClosure_TheRestrictedEulerQuotientClosesByRingIdentityAndThePressureHessianCouplingDoesNotDescendThroughIt
open import VieillefosseFibre_TheDiscriminantIsAFirstIntegralOfRestrictedEulerItsZeroFibreIsUnboundedAndThePushforwardOfTheTrueFieldBranches
  using (Pushforward ; y₀)

------------------------------------------------------------------------
-- §1  Polynomials of degree ≤ 3, their evaluation, and the symbolic
--     derivative along W = (−4r, −q²).
------------------------------------------------------------------------

record P3 : Type where
  constructor p3
  field
    c00 c10 c01 c20 c11 c02 c30 c21 c12 c03 : ℤ
open P3

eval3 : P3 → ℤ → ℤ → ℤ
eval3 F q r =
    c00 F + c10 F · q + c01 F · r
  + c20 F · (q · q) + c11 F · (q · r) + c02 F · (r · r)
  + c30 F · (q · q · q) + c21 F · (q · q · r) + c12 F · (q · r · r) + c03 F · (r · r · r)

-- the explicit partial derivatives, as functions
∂q : P3 → ℤ → ℤ → ℤ
∂q F q r =
    c10 F + (pos 2 · c20 F) · q + c11 F · r
  + (pos 3 · c30 F) · (q · q) + (pos 2 · c21 F) · (q · r) + c12 F · (r · r)

∂r : P3 → ℤ → ℤ → ℤ
∂r F q r =
    c01 F + c11 F · q + (pos 2 · c02 F) · r
  + c21 F · (q · q) + (pos 2 · c12 F) · (q · r) + (pos 3 · c03 F) · (r · r)

-- the derivative along W, as a polynomial of degree ≤ 4: only the
-- monomials that can occur are carried.  Coefficient of qᵃrᵇ is
--   −4(a+1)·c_{a+1,b−1} − (b+1)·c_{a−2,b+1}.
record P4 : Type where
  constructor p4
  field
    d01 d02 d03 d11 d12 d20 d21 d22 d30 d31 d40 : ℤ
open P4

along : P3 → P4
d01 (along F) = - (pos 4 · c10 F)
d02 (along F) = - (pos 4 · c11 F)
d03 (along F) = - (pos 4 · c12 F)
d11 (along F) = - (pos 8 · c20 F)
d12 (along F) = - (pos 8 · c21 F)
d20 (along F) = - c01 F
d21 (along F) = - (pos 12 · c30 F) - pos 2 · c02 F
d22 (along F) = - (pos 3 · c03 F)
d30 (along F) = - c11 F
d31 (along F) = - (pos 2 · c12 F)
d40 (along F) = - c21 F

eval4 : P4 → ℤ → ℤ → ℤ
eval4 D q r =
    d01 D · r + d02 D · (r · r) + d03 D · (r · r · r)
  + d11 D · (q · r) + d12 D · (q · r · r)
  + d20 D · (q · q) + d21 D · (q · q · r) + d22 D · (q · q · r · r)
  + d30 D · (q · q · q) + d31 D · (q · q · q · r)
  + d40 D · (q · q · q · q)

W₁ W₂ : ℤ → ℤ → ℤ
W₁ q r = - (pos 4 · r)
W₂ q r = - (q · q)

-- the symbolic derivative evaluates to the analytic one
along-evaluates : (F : P3) (q r : ℤ)
                → eval4 (along F) q r ≡ ∂q F q r · W₁ q r + ∂r F q r · W₂ q r
along-evaluates (p3 c00 c10 c01 c20 c11 c02 c30 c21 c12 c03) q r = solve! ℤCommRing

------------------------------------------------------------------------
-- §2  The classification: zero derivative ⇒ affine in the discriminant.
------------------------------------------------------------------------

IsZero4 : P4 → Type
IsZero4 D = (d01 D ≡ pos 0) × (d02 D ≡ pos 0) × (d03 D ≡ pos 0)
          × (d11 D ≡ pos 0) × (d12 D ≡ pos 0) × (d20 D ≡ pos 0)
          × (d21 D ≡ pos 0) × (d22 D ≡ pos 0) × (d30 D ≡ pos 0)
          × (d31 D ≡ pos 0) × (d40 D ≡ pos 0)

-- the shape a first integral must have
AffineInΔ : P3 → Type
AffineInΔ F = (c10 F ≡ pos 0) × (c01 F ≡ pos 0) × (c20 F ≡ pos 0) × (c11 F ≡ pos 0)
            × (c21 F ≡ pos 0) × (c12 F ≡ pos 0) × (c03 F ≡ pos 0)
            × (c02 F ≡ - (pos 6 · c30 F))

private
  pos≢negsuc : {m n : ℕ} → pos m ≡ negsuc n → ⊥
  pos≢negsuc p = subst T p tt
    where
    T : ℤ → Type
    T (pos _) = Unit
    T (negsuc _) = ⊥

  -- k·c ≡ 0 with k a positive numeral forces c ≡ 0
  cancel : (k : ℕ) (c : ℤ) → pos (suc k) · c ≡ pos 0 → c ≡ pos 0
  cancel k c p = isIntegralℤ (pos (suc k)) c p (λ e → pos≢zero e)
    where
    open import Cubical.Data.Nat using (snotz)
    open import Cubical.Data.Int using (injPos)
    pos≢zero : pos (suc k) ≡ pos 0 → ⊥
    pos≢zero e = snotz (injPos e)

  -- −x ≡ 0 ⇒ x ≡ 0
  neg-zero : (x : ℤ) → - x ≡ pos 0 → x ≡ pos 0
  neg-zero x p = sym (-Involutive x) ∙ cong -_ p
    where open import Cubical.Data.Int.Properties using (-Involutive)

first-integrals-are-affine-in-Δ : (F : P3) → IsZero4 (along F) → AffineInΔ F
first-integrals-are-affine-in-Δ F (z01 , z02 , z03 , z11 , z12 , z20 , z21 , z22 , z30 , z31 , z40) =
    cancel 3 (c10 F) (neg-zero _ z01)
  , neg-zero _ z20
  , cancel 7 (c20 F) (neg-zero _ z11)
  , neg-zero _ z30
  , neg-zero _ z40
  , cancel 3 (c12 F) (neg-zero _ z03)
  , cancel 2 (c03 F) (neg-zero _ z22)
  , c02-fixed
  where
  -- from −12·c30 − 2·c02 ≡ 0: 2·(c02 + 6·c30) ≡ 0, so c02 ≡ −6·c30
  open CommRingStr (ℤCommRing .snd) using () renaming (_·_ to _*_ ; _+_ to _⊕_)
  rearrange : - (pos 12 · c30 F) - pos 2 · c02 F ≡ - (pos 2 · (c02 F + pos 6 · c30 F))
  rearrange = solve! ℤCommRing
  sum-zero : c02 F + pos 6 · c30 F ≡ pos 0
  sum-zero = cancel 1 _ (neg-zero _ (sym rearrange ∙ z21))
  c02-fixed : c02 F ≡ - (pos 6 · c30 F)
  c02-fixed = lemma (c02 F) (pos 6 · c30 F) sum-zero
    where
    lemma : (x y : ℤ) → x + y ≡ pos 0 → x ≡ - y
    lemma x y h = step ∙ cong (_+ (- y)) h ∙ zero-left
      where
      step : x ≡ (x + y) + (- y)
      step = solve! ℤCommRing
      zero-left : pos 0 + (- y) ≡ - y
      zero-left = solve! ℤCommRing

-- and the converse, so the classification is exact: every affine
-- combination of 1 and Δ = 6r² − q³ has zero derivative along W.
affine : ℤ → ℤ → P3          -- a + b·(q³ − 6r²)
affine a b = p3 a (pos 0) (pos 0) (pos 0) (pos 0) (- (pos 6 · b)) b (pos 0) (pos 0) (pos 0)

affine-is-first-integral : (a b : ℤ) → IsZero4 (along (affine a b))
affine-is-first-integral a b =
  refl , refl , refl , refl , refl , refl , l21 , refl , refl , refl , refl
  where
  l21 : - (pos 12 · b) - pos 2 · (- (pos 6 · b)) ≡ pos 0
  l21 = solve! ℤCommRing

------------------------------------------------------------------------
-- §3  The pushforward fibre over y₀ is unbounded: ℤ injects into it.
------------------------------------------------------------------------

-- The value identity is proved in an abstract ring, where the solver reads
-- the literals 1r, 0r; over ℤ it is then instantiated.
module Lin {ℓ : Level} (R' : CommRing ℓ) where
  open CommRingStr (R' .snd) using (1r ; 0r) renaming (-_ to neg ; _+_ to _+r_ ; _·_ to _·r_)
  open Gradient R'
  A₀' : T3                   -- diag(1, −1, 0)
  A₀' = t3 1r 0r 0r 0r (neg 1r) 0r 0r 0r
  H' : M3                    -- diag(1, −1, 0)
  H' = m3 1r 0r 0r 0r (neg 1r) 0r 0r 0r 0r
  six : fst R'
  six = 1r +r 1r +r 1r +r 1r +r 1r +r 1r
  -- the Q̇ right-hand side at (A₀' , k·H'): −3·tr A₀'³ − 3·tr(A₀'·kH') = −6k
  rhs-at-kH : (k : fst R') → tr (full A₀' * rhs A₀' (scale k H')) ≡ neg (six ·r k)
  rhs-at-kH k = solve! R'

open Gradient ℤCommRing
open Lin ℤCommRing

six≡6 : six ≡ pos 6
six≡6 = refl

-- the (Q, R)-only reading, so that rescaling H moves inside one fibre
invariantsQR : T3 × M3 → ℤ × ℤ
invariantsQR (A , M) = Q₂ A , R₃ A

PushforwardQR : ℤ × ℤ → Type
PushforwardQR y = Σ[ v ∈ ℤ ] Σ[ x ∈ T3 × M3 ] (invariantsQR x ≡ y) × (Q-rhs x ≡ v)

escape : ℤ → PushforwardQR (invariantsQR (A₀' , H'))
escape t = Q-rhs (A₀' , scale t H') , (A₀' , scale t H') , refl , refl

escape-injective : (s t : ℤ) → escape s ≡ escape t → s ≡ t
escape-injective s t p = diff-zero→eq s t (isIntegralℤ (pos 6) (s - t) six-diff six≢0)
  where
  open import Cubical.Data.Int using (injPos)
  open import Cubical.Data.Int.Properties using (-Involutive)
  open import Cubical.Data.Nat using (snotz)
  e : - (pos 6 · s) ≡ - (pos 6 · t)
  e = sym (rhs-at-kH s) ∙ cong fst p ∙ rhs-at-kH t
  neg-cancel : pos 6 · s ≡ pos 6 · t
  neg-cancel = sym (-Involutive _) ∙ cong -_ e ∙ -Involutive _
  six≢0 : ¬ (pos 6 ≡ pos 0)
  six≢0 q = snotz (injPos q)
  distribute : pos 6 · (s - t) ≡ pos 6 · s - pos 6 · t
  distribute = solve! ℤCommRing
  self-cancel : (x : ℤ) → x - x ≡ pos 0
  self-cancel x = solve! ℤCommRing
  six-diff : pos 6 · (s - t) ≡ pos 0
  six-diff = distribute ∙ cong (_- pos 6 · t) neg-cancel ∙ self-cancel (pos 6 · t)
  diff-zero→eq : (x y : ℤ) → x - y ≡ pos 0 → x ≡ y
  diff-zero→eq x y h = step ∙ cong (_+ y) h ∙ zero-left
    where
    step : x ≡ (x - y) + y
    step = solve! ℤCommRing
    zero-left : pos 0 + y ≡ y
    zero-left = solve! ℤCommRing
