{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- QRClosure — the restricted-Euler quotient (Q, R) closes by ring
-- identity, and the pressure-Hessian coupling does not descend through it.
--
-- WHAT THIS IS.  Along a particle path the velocity gradient A = ∇u of an
-- incompressible flow obeys (Vieillefosse 1982, Cantwell 1992)
--
--     DA/Dt = −A² + ⅓ tr(A²) I − H + ν ΔA,      tr A = 0, tr H = 0,
--
-- with H the deviatoric pressure Hessian.  Restricted Euler is H = 0,
-- ν = 0, and on Q = −½ tr A², R = −⅓ tr A³ it CLOSES: Q̇ = −3R, Ṙ = ⅔Q².
-- The calculus (D/Dt, the chain rule) is not in this module.  What IS in
-- it is every algebraic identity that closure rests on, over an arbitrary
-- commutative ring and with the fractions cleared, and then the descent
-- obstruction for the coupling terms:
--
--   §1  for a trace-free 3×3 matrix A and ANY 3×3 matrix M,
--         tr(A · (−3A² + tr(A²)·I − 3M))  ≡  −3·tr A³ − 3·tr(A M)
--         2·tr(A² · (−3A² + tr(A²)·I − 3M)) ≡  −(tr A²)² − 6·tr(A² M)
--       (the second uses tr A⁴ ≡ ½(tr A²)², which is Cayley–Hamilton at
--       tr A = 0; both by the solver).  Read at M = H − νΔA these are
--       the exact right-hand sides of Q̇ and Ṙ: the restricted-Euler
--       part is a function of (tr A², tr A³), i.e. of (Q, R), and the
--       whole correction is tr(AM), tr(A²M).
--   §2  over ℤ: A₀ = diag(1,−1,0) and A₁ = diag(0,1,−1) have the same
--       tr A², tr A³ (the same Q, R), and at the trace-free symmetric
--       H = diag(1,−1,0) the couplings tr(A₀H) = 2 and tr(A₁H) = −1
--       differ; likewise tr(A₀²H) = 0 and tr(A₁²H) = −1.  So by the
--       corpus's one descent lemma (DescentObstructionUnified.
--       factorObstruction) neither coupling factors through
--       (Q, R, H): the (Q, R) quotient identifies states whose
--       right-hand sides differ, and no autonomous vector field on
--       (Q, R) reproduces the coupled dynamics.  Restricted Euler is
--       what remains when the non-descending residual is discarded.
--
-- SYĀT — THE CLAIM, EXACTLY.  Ring identities in the entries of two 3×3
-- matrices, and two-point witnesses over ℤ.  No derivative, no flow, no
-- pressure, no Vieillefosse blow-up; "closure" names the algebraic fact
-- that the leading terms are functions of the two invariants and the
-- correction terms are not.
------------------------------------------------------------------------

module QRClosure_TheRestrictedEulerQuotientClosesByRingIdentityAndThePressureHessianCouplingDoesNotDescendThroughIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver

open import DescentObstructionUnified using (FactorsThrough ; factorObstruction)

module Gradient {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd)

  private
    K : Type ℓ
    K = fst R'

  -- a 3×3 matrix, row by row
  record M3 : Type ℓ where
    constructor m3
    field
      a₁₁ a₁₂ a₁₃ a₂₁ a₂₂ a₂₃ a₃₁ a₃₂ a₃₃ : K
  open M3 public

  -- a trace-free 3×3 matrix: eight free entries, a₃₃ = −(a₁₁ + a₂₂)
  record T3 : Type ℓ where
    constructor t3
    field
      b₁₁ b₁₂ b₁₃ b₂₁ b₂₂ b₂₃ b₃₁ b₃₂ : K
  open T3 public

  full : T3 → M3
  full (t3 b₁₁ b₁₂ b₁₃ b₂₁ b₂₂ b₂₃ b₃₁ b₃₂) =
    m3 b₁₁ b₁₂ b₁₃ b₂₁ b₂₂ b₂₃ b₃₁ b₃₂ (- (b₁₁ + b₂₂))

  infixl 20 _*_
  _*_ : M3 → M3 → M3
  X * Y = m3
    (a₁₁ X · a₁₁ Y + a₁₂ X · a₂₁ Y + a₁₃ X · a₃₁ Y)
    (a₁₁ X · a₁₂ Y + a₁₂ X · a₂₂ Y + a₁₃ X · a₃₂ Y)
    (a₁₁ X · a₁₃ Y + a₁₂ X · a₂₃ Y + a₁₃ X · a₃₃ Y)
    (a₂₁ X · a₁₁ Y + a₂₂ X · a₂₁ Y + a₂₃ X · a₃₁ Y)
    (a₂₁ X · a₁₂ Y + a₂₂ X · a₂₂ Y + a₂₃ X · a₃₂ Y)
    (a₂₁ X · a₁₃ Y + a₂₂ X · a₂₃ Y + a₂₃ X · a₃₃ Y)
    (a₃₁ X · a₁₁ Y + a₃₂ X · a₂₁ Y + a₃₃ X · a₃₁ Y)
    (a₃₁ X · a₁₂ Y + a₃₂ X · a₂₂ Y + a₃₃ X · a₃₂ Y)
    (a₃₁ X · a₁₃ Y + a₃₂ X · a₂₃ Y + a₃₃ X · a₃₃ Y)

  tr : M3 → K
  tr X = a₁₁ X + a₂₂ X + a₃₃ X

  -- the invariants, fractions cleared: Q₂ = tr A² = −2Q, R₃ = tr A³ = −3R
  Q₂ : T3 → K
  Q₂ A = tr (full A * full A)

  R₃ : T3 → K
  R₃ A = tr (full A * full A * full A)

  -- the couplings with a correction matrix M
  c₁ : T3 → M3 → K
  c₁ A M = tr (full A * M)

  c₂ : T3 → M3 → K
  c₂ A M = tr (full A * full A * M)

  -- the right-hand side 3·(DA/Dt) with M standing for H − νΔA:
  --   −3A² + tr(A²)·I − 3M
  scale : K → M3 → M3
  scale k (m3 x₁₁ x₁₂ x₁₃ x₂₁ x₂₂ x₂₃ x₃₁ x₃₂ x₃₃) =
    m3 (k · x₁₁) (k · x₁₂) (k · x₁₃) (k · x₂₁) (k · x₂₂) (k · x₂₃)
       (k · x₃₁) (k · x₃₂) (k · x₃₃)

  infixl 15 _⊕_
  _⊕_ : M3 → M3 → M3
  X ⊕ Y = m3 (a₁₁ X + a₁₁ Y) (a₁₂ X + a₁₂ Y) (a₁₃ X + a₁₃ Y)
             (a₂₁ X + a₂₁ Y) (a₂₂ X + a₂₂ Y) (a₂₃ X + a₂₃ Y)
             (a₃₁ X + a₃₁ Y) (a₃₂ X + a₃₂ Y) (a₃₃ X + a₃₃ Y)

  I₃ : M3
  I₃ = m3 1r 0r 0r 0r 1r 0r 0r 0r 1r

  three : K
  three = 1r + 1r + 1r

  rhs : T3 → M3 → M3
  rhs A M = scale (- three) (full A * full A) ⊕ scale (Q₂ A) I₃ ⊕ scale (- three) M

  ------------------------------------------------------------------------
  -- §1  The two closure identities, over any commutative ring.
  ------------------------------------------------------------------------

  Q-closure : (A : T3) (M : M3)
            → tr (full A * rhs A M) ≡ - (three · R₃ A) - three · c₁ A M
  Q-closure (t3 b₁₁ b₁₂ b₁₃ b₂₁ b₂₂ b₂₃ b₃₁ b₃₂)
            (m3 m₁₁ m₁₂ m₁₃ m₂₁ m₂₂ m₂₃ m₃₁ m₃₂ m₃₃) = solve! R'

  R-closure : (A : T3) (M : M3)
            → (1r + 1r) · tr (full A * full A * rhs A M)
              ≡ - (Q₂ A · Q₂ A) - (three + three) · c₂ A M
  R-closure (t3 b₁₁ b₁₂ b₁₃ b₂₁ b₂₂ b₂₃ b₃₁ b₃₂)
            (m3 m₁₁ m₁₂ m₁₃ m₂₁ m₂₂ m₂₃ m₃₁ m₃₂ m₃₃) = solve! R'

------------------------------------------------------------------------
-- §2  Over ℤ: the coupling does not descend through (Q, R, H).
------------------------------------------------------------------------

open Gradient ℤCommRing

A₀ : T3                    -- diag(1, −1, 0)
A₀ = t3 (pos 1) (pos 0) (pos 0) (pos 0) (negsuc 0) (pos 0) (pos 0) (pos 0)

A₁ : T3                    -- diag(0, 1, −1)
A₁ = t3 (pos 0) (pos 0) (pos 0) (pos 0) (pos 1) (pos 0) (pos 0) (pos 0)

H : M3                     -- diag(1, −1, 0): symmetric, trace-free
H = m3 (pos 1) (pos 0) (pos 0) (pos 0) (negsuc 0) (pos 0) (pos 0) (pos 0) (pos 0)

H-trace-free : tr H ≡ pos 0
H-trace-free = refl

-- the same invariants …
same-Q : Q₂ A₀ ≡ Q₂ A₁
same-Q = refl

same-R : R₃ A₀ ≡ R₃ A₁
same-R = refl

-- … different couplings
c₁-A₀ : c₁ A₀ H ≡ pos 2
c₁-A₀ = refl

c₁-A₁ : c₁ A₁ H ≡ negsuc 0
c₁-A₁ = refl

c₂-A₀ : c₂ A₀ H ≡ pos 0
c₂-A₀ = refl

c₂-A₁ : c₂ A₁ H ≡ negsuc 0
c₂-A₁ = refl

private
  pos≢negsuc : {m n : ℕ} → pos m ≡ negsuc n → ⊥
  pos≢negsuc p = subst T p tt
    where
    T : ℤ → Type
    T (pos _) = Unit
    T (negsuc _) = ⊥

-- the quotient reading: the two invariants and the Hessian
invariants : T3 × M3 → (ℤ × ℤ) × M3
invariants (A , M) = (Q₂ A , R₃ A) , M

-- THE DESCENT OBSTRUCTION: neither coupling is a function of (Q, R, H).
c₁-not-through-QR : ¬ (FactorsThrough invariants (λ p → c₁ (fst p) (snd p)))
c₁-not-through-QR =
  factorObstruction invariants (λ p → c₁ (fst p) (snd p))
    (A₀ , H) (A₁ , H) refl pos≢negsuc

c₂-not-through-QR : ¬ (FactorsThrough invariants (λ p → c₂ (fst p) (snd p)))
c₂-not-through-QR =
  factorObstruction invariants (λ p → c₂ (fst p) (snd p))
    (A₀ , H) (A₁ , H) refl pos≢negsuc

-- and therefore the full right-hand side of Q̇ does not either: the
-- restricted-Euler part agrees on the pair (same R₃) while the whole differs.
Q-rhs : T3 × M3 → ℤ
Q-rhs (A , M) = tr (full A * rhs A M)

Q-rhs-not-through-QR : ¬ (FactorsThrough invariants Q-rhs)
Q-rhs-not-through-QR =
  factorObstruction invariants Q-rhs (A₀ , H) (A₁ , H) refl λ p → pos≢negsuc (sym p)
  where
  -- Q-rhs (A₀ , H) = −6, Q-rhs (A₁ , H) = 3, by computation
  _ : Q-rhs (A₀ , H) ≡ negsuc 5
  _ = refl
  _ : Q-rhs (A₁ , H) ≡ pos 3
  _ = refl
