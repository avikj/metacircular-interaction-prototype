{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मान-शेष — the measure's remainder.
--
-- THE SCALE RESIDUAL OF A HOMOGENEOUS OBSERVABLE IS ITS DEGREE, TIMES
-- ITSELF.  So "critical" is not a name for a coincidence of exponents:
-- it is exactly the vanishing of `ActionResidual`'s failed-equivariance
-- coordinate, at the naive predictor.
--
-- `ActionResidual` builds, from an observable `q`, an installed action
-- `step`, and a DECLARED predictor, the coordinate
--
--     residual x  =  q (step x)  -  predict (q x) ,
--
-- and is careful that without a declared predictor there is behaviour
-- but no preferred origin for its second coordinate.  This module
-- declares the naive predictor — `predict = id`, "the action changes
-- nothing" — and asks what the residual is when the action instead
-- scales the observable by a fixed factor `c`:
--
--   §1  residual x  ≡  (c - 1) · q x .
--
--       The residual is supported entirely on the observable itself,
--       with the whole content of the action in one ring element.  For
--       a quantity of scaling degree α under one contraction by q, that
--       element is `q^α - 1`, which is what makes §2 say what it says.
--
--   §2  c ≡ 1  ⟹  the residual vanishes identically;
--
--   §3  and conversely, at any state where the observable is nonzero and
--       in a ring without zero divisors, a vanishing residual forces
--       c ≡ 1.  So
--
--         zero scale residual  ⟺  degree zero,
--
--       away from the zero locus of the observable.  Criticality is the
--       failed-equivariance coordinate of the scale action, and nothing
--       else.  Both hypotheses in §3 are necessary and both are carried:
--       at `q x ≡ 0` the residual vanishes for every `c` whatsoever.
--
-- AND THE CONSEQUENCE FOR A SHRINKING RECURRENCE, over ℕ where the order
-- lives:
--
--   §4  if the observable is EXACTLY recurrent under the action —
--       q (step x) ≡ k · q x — and also nonincreasing along it, then at
--       any state where it is positive, `k` cannot exceed 1.
--
--       Read at a renormalization step: a positive functional that never
--       increases in physical time cannot have a scale degree that makes
--       it grow under rescaling.  A cascade recurring at ever smaller
--       scale is killed by ANY such functional of the wrong degree — one
--       does not need it to be an energy, an invariant, or a norm.
--
--   §5  and at degree exactly one, the same pair of hypotheses forbids
--       STRICT decrease: exact recurrence and strict monotonicity cannot
--       both hold.
--
-- WHY THIS IS NOT A METAPHOR.  §§1–3 are `ActionResidual`'s residual,
-- imported and computed, not a rephrasing of it; §§4–5 are the order
-- statements the residual's sign would carry if the ring were ordered,
-- stated over ℕ where it is.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 and §2 in any ring, for any state type,
-- observable, action, and factor satisfying the homogeneity equation.
-- §3 additionally under absence of zero divisors and nonvanishing of the
-- observable at the state in question.  §§4–5 over ℕ, for every state
-- type, observable, action and factor.  NOT claimed: that any concrete
-- functional is homogeneous, monotone, or positive — all three are
-- hypotheses; anything about ℝ, about exponents `α` as numbers, or about
-- `q^α` — `c` is a ring element and no exponentiation occurs; anything
-- about existence of a recurrent orbit, which §4 refutes only under its
-- hypotheses and never constructs; and nothing about which functionals a
-- particular dynamics admits, which is the whole remaining question and
-- is untouched here.
------------------------------------------------------------------------

module ManaSesa_TheScaleResidualIsTheDegreeTimesTheObservableSoZeroResidualIsCriticalityAndANegativeDegreeMonotoneForbidsShrinkingRecurrence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; +-zero) renaming (_·_ to _·ℕ_)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; <-·sk ; <-asym ; ¬m<m ; ¬-<-zero)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

import ActionResidual as AR

private
  variable
    ℓ ℓ' : Level

  positive→suc : (m : ℕ) → 0 < m → Σ[ j ∈ ℕ ] (m ≡ suc j)
  positive→suc zero    p = ⊥-rec (¬-<-zero p)
  positive→suc (suc j) _ = j , refl

------------------------------------------------------------------------
-- THE RESIDUAL OF A SCALING ACTION, AT THE NAIVE PREDICTOR.
------------------------------------------------------------------------

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

    sub-cancel : (x y : A) → (x + (- y)) + y ≡ x
    sub-cancel x y =
        (x + (- y)) + y
      ≡⟨ sym (+Assoc x (- y) y) ⟩
        x + ((- y) + y)
      ≡⟨ cong (x +_) (+InvL y) ⟩
        x + 0r
      ≡⟨ +IdR x ⟩
        x ∎

    fromDiff : (x y : A) → x + (- y) ≡ 0r → x ≡ y
    fromDiff x y h = sym (sub-cancel x y) ∙ cong (_+ y) h ∙ +IdL y

  module _ {X : Type ℓ'}
           (q : X → A) (step : X → X) (c : A)
           (homogeneous : (x : X) → q (step x) ≡ c · q x)
           where

    -- `ActionResidual`'s coordinate, at predict = id.
    open AR.DefectCoordinate {X = X} (Ring→AbGroup R) q step (λ z → z)
      using (residual)

    ------------------------------------------------------------------
    -- १ · THE RESIDUAL IS THE DEGREE TIMES THE OBSERVABLE.
    ------------------------------------------------------------------

    residual-is-the-degree : (x : X) → residual x ≡ (c + (- 1r)) · q x
    residual-is-the-degree x =
        q (step x) + (- q x)
      ≡⟨ cong (_+ (- q x)) (homogeneous x) ⟩
        (c · q x) + (- q x)
      ≡⟨ cong ((c · q x) +_) (-IsMult-1 (q x)) ⟩
        (c · q x) + ((- 1r) · q x)
      ≡⟨ sym (·DistL+ c (- 1r) (q x)) ⟩
        (c + (- 1r)) · q x ∎

    ------------------------------------------------------------------
    -- २ · DEGREE ZERO KILLS THE RESIDUAL EVERYWHERE.
    ------------------------------------------------------------------

    critical→no-residual : c ≡ 1r → (x : X) → residual x ≡ 0r
    critical→no-residual h x =
        residual-is-the-degree x
      ∙ cong (λ z → (z + (- 1r)) · q x) h
      ∙ cong (_· q x) (+InvR 1r)
      ∙ 0LeftAnnihilates (q x)

    ------------------------------------------------------------------
    -- ३ · AND CONVERSELY, AWAY FROM THE OBSERVABLE'S ZERO LOCUS.
    ------------------------------------------------------------------

    no-residual→critical :
        ((a b : A) → a · b ≡ 0r → ¬ (b ≡ 0r) → a ≡ 0r)
      → (x : X) → ¬ (q x ≡ 0r) → residual x ≡ 0r → c ≡ 1r
    no-residual→critical noZeroDivisors x nz h =
      fromDiff c 1r
        (noZeroDivisors (c + (- 1r)) (q x)
          (sym (residual-is-the-degree x) ∙ h) nz)

------------------------------------------------------------------------
-- A SHRINKING RECURRENCE IS KILLED BY THE WRONG DEGREE.
------------------------------------------------------------------------

module _ {X : Type ℓ'} (q : X → ℕ) (step : X → X) (k : ℕ)
         (recurrent  : (x : X) → q (step x) ≡ k ·ℕ q x)
         (nonincreasing : (x : X) → q (step x) ≤ q x)
         where

  --------------------------------------------------------------------
  -- ४ · A POSITIVE NONINCREASING OBSERVABLE FORBIDS k > 1.
  --------------------------------------------------------------------

  wrong-degree-forbids-recurrence : (x : X) → 0 < q x → ¬ (1 < k)
  wrong-degree-forbids-recurrence x pos h =
    <-asym grow (subst (_≤ q x) (recurrent x) (nonincreasing x))
    where
      w : Σ[ j ∈ ℕ ] (q x ≡ suc j)
      w = positive→suc (q x) pos

      grow : q x < k ·ℕ q x
      grow =
        subst (λ z → z < k ·ℕ z) (sym (snd w))
          (subst (_< k ·ℕ suc (fst w)) (+-zero (suc (fst w)))
                 (<-·sk {k = fst w} h))

  --------------------------------------------------------------------
  -- ५ · AND AT DEGREE ONE, STRICT DECREASE IS EXCLUDED TOO.
  --------------------------------------------------------------------

  critical-degree-forbids-strict-decrease :
    k ≡ 1 → (x : X) → ¬ (q (step x) < q x)
  critical-degree-forbids-strict-decrease hk x lt =
    ¬m<m (subst (_< q x) (recurrent x ∙ cong (_·ℕ q x) hk ∙ +-zero (q x)) lt)
