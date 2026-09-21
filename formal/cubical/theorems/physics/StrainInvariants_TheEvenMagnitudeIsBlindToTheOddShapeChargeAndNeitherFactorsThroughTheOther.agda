{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- StrainInvariants — at a trace-free symmetric 3×3 matrix, the even
-- magnitude tr S² is blind to the odd shape charge det S, the charge is
-- blind to the magnitude, and neither factors through the other.
--
-- WHAT THIS IS.  The infinitesimal strain of an incompressible flow is a
-- trace-free symmetric matrix.  Its two SO(3)-invariant readings of
-- lowest degree are the quadratic magnitude I₂ = tr S² (the dissipation
-- reading) and the cubic charge I₃ = det S (the reading whose sign says
-- whether the strain has two expanding directions or one).  Over any
-- commutative ring:
--
--   §1  the involution S ↦ −S fixes I₂ and negates I₃ (solver);
--   §2  tr S³ ≡ 3·det S, and 2·e₂ ≡ −tr S² where e₂ is the second
--       elementary symmetric function — so the characteristic polynomial
--       of S is determined by (I₂ , I₃), the even sense fixing e₂ up to
--       the factor 2 and the odd sense being e₃ itself (solver);
--   §3  over ℤ, the two blind pairs: I₂ identifies S₀ = diag(2,−1,−1)
--       with −S₀ and I₃ separates them; I₃ identifies diag(1,0,−1) with
--       diag(2,0,−2) and I₂ separates them.  Hence, by the corpus's one
--       descent lemma (DescentObstructionUnified.factorObstruction),
--       det does not factor through tr S² and tr S² does not factor
--       through det: an interdependent pair in the sense of Jyotiryugma,
--       one even sense and one odd, neither post-processing of the other;
--   §4  the pointwise interaction ωᵀSω does not factor through the pair
--       (S , |ω|²): at S₀ the unit vectors e₁ and e₂ give 2 and −1.  And
--       the coupling witness: two couplings of the same strain marginal
--       {S₀ , S₀'} with the same vorticity marginal {e₁ , e₂} have total
--       production 4 and −2 — the VitaranaYugma shape (marginals agree,
--       the joint escapes), with the production as the named point.
--
-- READING, offered as a reading.  Every energy-type estimate for
-- Navier–Stokes is invariant under u ↦ −u, which is S ↦ −S on strain;
-- §1 and §3 say such an estimate is provably blind to the sign of the
-- enstrophy production, whose integral on the torus is −4∫det S
-- (Betchov's identity — an integration by parts, NOT proved here).
--
-- SYĀT — THE CLAIM, EXACTLY.  Ring identities and two-point witnesses over
-- ℤ.  No matrices as a type, no eigenvalues, no SO(3), no integral, no
-- fluid.  "Strain" and "production" name the readings; the theorems are
-- about six ring elements.  Trace-freeness is by construction: the third
-- diagonal entry is −(a + b).
------------------------------------------------------------------------

module StrainInvariants_TheEvenMagnitudeIsBlindToTheOddShapeChargeAndNeitherFactorsThroughTheOther where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver

open import DescentObstructionUnified using (FactorsThrough ; factorObstruction)

------------------------------------------------------------------------
-- §0  Trace-free symmetric matrices over a commutative ring, as their
--     five free entries: diagonal a, b (the third is −(a+b)), off-diagonal
--     d = S₁₂, e = S₁₃, f = S₂₃.
------------------------------------------------------------------------

module Strain {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd)

  private
    R : Type ℓ
    R = fst R'

  record Sym : Type ℓ where
    constructor sym3
    field
      a b d e f : R
  open Sym public

  c : Sym → R
  c S = - (a S + b S)

  -- the involution
  neg : Sym → Sym
  neg (sym3 a b d e f) = sym3 (- a) (- b) (- d) (- e) (- f)

  -- I₂ = tr S²
  trSq : Sym → R
  trSq S = a S · a S + b S · b S + c S · c S
         + (1r + 1r) · (d S · d S + e S · e S + f S · f S)

  -- I₃ = det S, expanded along the first row of [[a,d,e],[d,b,f],[e,f,c]]
  det : Sym → R
  det S = a S · (b S · c S - f S · f S)
        - d S · (d S · c S - f S · e S)
        + e S · (d S · f S - b S · e S)

  -- tr S³, from the diagonal of S·S·S
  trCube : Sym → R
  trCube S =
      (a S · a S + d S · d S + e S · e S) · a S
    + (a S · d S + d S · b S + e S · f S) · d S
    + (a S · e S + d S · f S + e S · c S) · e S
    + (d S · a S + b S · d S + f S · e S) · d S
    + (d S · d S + b S · b S + f S · f S) · b S
    + (d S · e S + b S · f S + f S · c S) · f S
    + (e S · a S + f S · d S + c S · e S) · e S
    + (e S · d S + f S · b S + c S · f S) · f S
    + (e S · e S + f S · f S + c S · c S) · c S

  -- e₂ : the second elementary symmetric function of S (sum of principal 2-minors)
  e₂ : Sym → R
  e₂ S = (a S · b S - d S · d S) + (a S · c S - e S · e S) + (b S · c S - f S · f S)

  -- the interaction ωᵀSω
  prod : Sym → R × (R × R) → R
  prod S (x , y , z) =
      x · (a S · x + d S · y + e S · z)
    + y · (d S · x + b S · y + f S · z)
    + z · (e S · x + f S · y + c S · z)

  ------------------------------------------------------------------------
  -- §1  The involution fixes the magnitude and negates the charge.
  ------------------------------------------------------------------------

  magnitude-even : (S : Sym) → trSq (neg S) ≡ trSq S
  magnitude-even (sym3 a b d e f) = solve! R'

  charge-odd : (S : Sym) → det (neg S) ≡ - det S
  charge-odd (sym3 a b d e f) = solve! R'

  ------------------------------------------------------------------------
  -- §2  The two invariants determine the characteristic data.
  ------------------------------------------------------------------------

  trCube≡3det : (S : Sym) → trCube S ≡ (1r + 1r + 1r) · det S
  trCube≡3det (sym3 a b d e f) = solve! R'

  2e₂≡-trSq : (S : Sym) → (1r + 1r) · e₂ S ≡ - trSq S
  2e₂≡-trSq (sym3 a b d e f) = solve! R'

------------------------------------------------------------------------
-- §3  Over ℤ: the two blind pairs, and neither reading factors through
--     the other.
------------------------------------------------------------------------

open Strain ℤCommRing

S₀ : Sym                      -- diag(2, −1, −1)
S₀ = sym3 (pos 2) (negsuc 0) (pos 0) (pos 0) (pos 0)

S₁ : Sym                      -- diag(1, 0, −1)
S₁ = sym3 (pos 1) (pos 0) (pos 0) (pos 0) (pos 0)

S₃ : Sym                      -- diag(2, 0, −2)
S₃ = sym3 (pos 2) (pos 0) (pos 0) (pos 0) (pos 0)

-- the values, by computation
det-S₀ : det S₀ ≡ pos 2
det-S₀ = refl

det-negS₀ : det (neg S₀) ≡ negsuc 1
det-negS₀ = refl

trSq-S₀ : trSq S₀ ≡ pos 6
trSq-S₀ = refl

trSq-S₁ : trSq S₁ ≡ pos 2
trSq-S₁ = refl

trSq-S₃ : trSq S₃ ≡ pos 8
trSq-S₃ = refl

private
  pos≢negsuc : {m n : ℕ} → pos m ≡ negsuc n → ⊥
  pos≢negsuc p = subst T p tt
    where
    open import Cubical.Data.Unit using (Unit ; tt)
    T : ℤ → Type
    T (pos _) = Unit
    T (negsuc _) = ⊥

  2≢8 : pos 2 ≡ pos 8 → ⊥
  2≢8 p = znots (injSuc (injSuc (injPos p)))
    where
    open import Cubical.Data.Int using (injPos)
    open import Cubical.Data.Nat using (znots ; injSuc)

-- the magnitude identifies S₀ with −S₀; the charge separates them
magnitude-blind-pair : (trSq S₀ ≡ trSq (neg S₀)) × (¬ (det S₀ ≡ det (neg S₀)))
magnitude-blind-pair = refl , pos≢negsuc

-- the charge identifies S₁ with S₃; the magnitude separates them
charge-blind-pair : (det S₁ ≡ det S₃) × (¬ (trSq S₁ ≡ trSq S₃))
charge-blind-pair = refl , 2≢8

-- THE DESCENT OBSTRUCTION, both ways, by the corpus's one lemma.
det-not-through-trSq : ¬ (FactorsThrough trSq det)
det-not-through-trSq =
  factorObstruction trSq det S₀ (neg S₀) refl pos≢negsuc

trSq-not-through-det : ¬ (FactorsThrough det trSq)
trSq-not-through-det =
  factorObstruction det trSq S₁ S₃ refl 2≢8

------------------------------------------------------------------------
-- §4  The interaction does not factor through (S , |ω|²), and the
--     coupling escapes the marginals.
------------------------------------------------------------------------

e₁ e₂' : ℤ × (ℤ × ℤ)
e₁ = pos 1 , pos 0 , pos 0
e₂' = pos 0 , pos 1 , pos 0

normSq : ℤ × (ℤ × ℤ) → ℤ
normSq (x , y , z) = x · x + y · y + z · z
  where open CommRingStr (ℤCommRing .snd)

-- same strain, same |ω|², different production
prod-S₀-e₁ : prod S₀ e₁ ≡ pos 2
prod-S₀-e₁ = refl

prod-S₀-e₂ : prod S₀ e₂' ≡ negsuc 0
prod-S₀-e₂ = refl

magnitudes : Sym × (ℤ × (ℤ × ℤ)) → Sym × ℤ
magnitudes (S , ω) = S , normSq ω

prod-not-through-magnitudes :
  ¬ (FactorsThrough magnitudes (λ p → prod (fst p) (snd p)))
prod-not-through-magnitudes =
  factorObstruction magnitudes (λ p → prod (fst p) (snd p))
    (S₀ , e₁) (S₀ , e₂') refl pos≢negsuc

-- the coupling witness: S₀' = diag(−1, 2, −1)
S₀' : Sym
S₀' = sym3 (negsuc 0) (pos 2) (pos 0) (pos 0) (pos 0)

open CommRingStr (ℤCommRing .snd) using (_+_)

-- coupling A pairs (S₀,e₁),(S₀',e₂'); coupling B pairs (S₀,e₂'),(S₀',e₁).
-- Same two strains, same two vorticities; total production 4 against −2.
couplingA : prod S₀ e₁ + prod S₀' e₂' ≡ pos 4
couplingA = refl

couplingB : prod S₀ e₂' + prod S₀' e₁ ≡ negsuc 1
couplingB = refl

couplings-differ : ¬ (prod S₀ e₁ + prod S₀' e₂' ≡ prod S₀ e₂' + prod S₀' e₁)
couplings-differ = pos≢negsuc
