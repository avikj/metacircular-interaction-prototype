{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- VieillefosseFibre — the discriminant D = 27R² + 4Q³ is a first integral
-- of restricted Euler, its zero fibre is unbounded and realized by sheet
-- strain, and the pushforward of the true vector field to the (Q, R)
-- plane is a BRANCHING fibre.
--
-- Continuing QRClosure.  With the fractions cleared (Q₂ = tr A² = −2Q,
-- R₃ = tr A³ = −3R), restricted Euler reads Q̇₂ = −2R₃, Ṙ₃ = −½Q₂², and
-- twice the discriminant is Δ = 6R₃² − Q₂³.
--
--   §1  FIRST INTEGRAL.  Along the (doubled) restricted-Euler field
--       W = (−4R₃, −Q₂²) the directional derivative of Δ vanishes
--       identically: ∂Δ/∂Q₂ · (−4R₃) + ∂Δ/∂R₃ · (−Q₂²) ≡ 0 (solver).
--       No calculus: the derivative of a polynomial along a polynomial
--       field is a polynomial, and that polynomial is zero.
--   §2  THE ZERO FIBRE IS REALIZED AND UNBOUNDED.  The sheet strain
--       diag(s, s, −2s) has Q₂ = 6s², R₃ = −6s³, so Δ = 0 for every s
--       (solver), and n ↦ diag(n, n, −2n) is an injection of ℕ into the
--       set of trace-free matrices on the zero fibre: it contains a copy
--       of the naturals.  Conservation traps
--       the motion in this fibre (Dhruva); the fibre has room to escape.
--   §3  THE PUSHFORWARD BRANCHES.  At the observed point y = (Q₂ A₀ , R₃ A₀)
--       the pushforward set { Q-rhs x : invariants x ≡ y } has two
--       distinct points (QRClosure's witnesses), so the induced world on
--       the (Q, R) plane has a BranchingFiber in LawfulContinuationCore's
--       sense: the deterministic field upstairs projects to a relation,
--       and restricted Euler is one section of it (the zero-residual one).
--
-- SYĀT — THE CLAIM, EXACTLY.  Three ring identities and one two-point
-- witness.  No flow, no time, no blow-up theorem: "first integral" names
-- the vanishing of a polynomial, "unbounded" names an injection of ℕ,
-- "branching" names LawfulContinuationCore.BranchingFiber.
------------------------------------------------------------------------

module VieillefosseFibre_TheDiscriminantIsAFirstIntegralOfRestrictedEulerItsZeroFibreIsUnboundedAndThePushforwardOfTheTrueFieldBranches where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver

open import LawfulContinuationCore using (BranchingFiber)
open import QRClosure_TheRestrictedEulerQuotientClosesByRingIdentityAndThePressureHessianCouplingDoesNotDescendThroughIt

module Discriminant {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd)
  open Gradient R'

  private
    K : Type ℓ
    K = fst R'

  -- twice the discriminant, in the cleared invariants
  Δ : K → K → K
  Δ q r = (1r + 1r + 1r + 1r + 1r + 1r) · (r · r) - q · q · q

  -- its partial derivatives, written out
  ∂Δ/∂q : K → K → K
  ∂Δ/∂q q r = - ((1r + 1r + 1r) · (q · q))

  ∂Δ/∂r : K → K → K
  ∂Δ/∂r q r = (1r + 1r + 1r + 1r + 1r + 1r + 1r + 1r + 1r + 1r + 1r + 1r) · r

  -- the doubled restricted-Euler field W = (−4 r , −q²)
  W₁ : K → K → K
  W₁ q r = - ((1r + 1r + 1r + 1r) · r)

  W₂ : K → K → K
  W₂ q r = - (q · q)

  ------------------------------------------------------------------------
  -- §1  Δ is a first integral: its derivative along W is the zero polynomial.
  ------------------------------------------------------------------------

  first-integral : (q r : K) → ∂Δ/∂q q r · W₁ q r + ∂Δ/∂r q r · W₂ q r ≡ 0r
  first-integral q r = solve! R'

  ------------------------------------------------------------------------
  -- §2  The sheet strain diag(s, s, −2s) lies on Δ = 0 for every s.
  ------------------------------------------------------------------------

  sheet : K → T3
  sheet s = t3 s 0r 0r 0r s 0r 0r 0r

  sheet-Q₂ : (s : K) → Q₂ (sheet s) ≡ (1r + 1r + 1r + 1r + 1r + 1r) · (s · s)
  sheet-Q₂ s = solve! R'

  sheet-R₃ : (s : K) → R₃ (sheet s) ≡ - ((1r + 1r + 1r + 1r + 1r + 1r) · (s · s · s))
  sheet-R₃ s = solve! R'

  sheet-on-tail : (s : K) → Δ (Q₂ (sheet s)) (R₃ (sheet s)) ≡ 0r
  sheet-on-tail s = solve! R'

------------------------------------------------------------------------
-- §2'  Over ℤ the tail is unbounded: ℕ injects into the zero fibre.
------------------------------------------------------------------------

open Discriminant ℤCommRing
open Gradient ℤCommRing

-- the tail, as matrices: trace-free A whose invariants satisfy Δ = 0
TailFibre : Type
TailFibre = Σ[ A ∈ T3 ] Δ (Q₂ A) (R₃ A) ≡ pos 0

tail : ℕ → TailFibre
tail n = sheet (pos n) , sheet-on-tail (pos n)

-- and the family is injective: the (1,1) entry of sheet (pos n) is pos n.
tail-injective : (m n : ℕ) → tail m ≡ tail n → m ≡ n
tail-injective m n p = injPos (cong (λ t → b₁₁ (fst t)) p)
  where open import Cubical.Data.Int using (injPos)

-- the invariants along the tail, as computed: Q₂ = 6n², R₃ = −6n³
open import Cubical.Data.Int using () renaming (_·_ to _·ℤ_)

tail-Q₂ : (n : ℕ) → Q₂ (fst (tail n)) ≡ pos 6 ·ℤ (pos n ·ℤ pos n)
tail-Q₂ n = sheet-Q₂ (pos n)

------------------------------------------------------------------------
-- §3  The pushforward of the true field to the (Q, R) plane branches.
------------------------------------------------------------------------

Observed : Type
Observed = (ℤ × ℤ) × M3

-- the pushforward set at an observed point: values of the Q̇ right-hand
-- side taken on states that read as y
Pushforward : Observed → Type
Pushforward y = Σ[ v ∈ ℤ ] Σ[ x ∈ T3 × M3 ] (invariants x ≡ y) × (Q-rhs x ≡ v)

y₀ : Observed
y₀ = invariants (A₀ , H)

private
  pos≢negsuc : {m n : ℕ} → pos m ≡ negsuc n → ⊥
  pos≢negsuc p = subst T p tt
    where
    T : ℤ → Type
    T (pos _) = Unit
    T (negsuc _) = ⊥

pushforward-branches : BranchingFiber (Pushforward y₀)
pushforward-branches =
    (Q-rhs (A₀ , H) , (A₀ , H) , refl , refl)
  , (Q-rhs (A₁ , H) , (A₁ , H) , refl , refl)
  , λ p → pos≢negsuc (sym (cong fst p))
