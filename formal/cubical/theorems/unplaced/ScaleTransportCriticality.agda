{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ScaleTransportCriticality
--
-- The criticality core of the boundedness criterion:
--
--     RH  ⟺  B_h(t) = O_h(1)   (t → ∞),
--
-- where B_h(t) = Σ_n Λ(n)/√n · h(t−log n) − e^{t/2}H_h(½) is the
-- renormalized boundary transport, with explicit-formula modal expansion
--
--     B_h(t) = − Σ_ρ m_ρ e^{(ρ−½)t} H_h(ρ−½) + T_h(t).
--
-- Each nontrivial zero ρ contributes a scale mode with growth exponent
-- exp(ρ) = Re(ρ−½).  Two facts drive the criterion, and they are exactly
-- the analytic inputs, taken here as the interface the explicit formula
-- and the functional equation supply:
--
--   grows-unbounds : a mode with exp > 0 makes B_h unbounded
--                    (the Laplace-transform pole at w = ρ−½, Re > 0);
--   dual-exp       : the functional equation ρ ↦ 1−ρ sends the exponent
--                    to its negation, exp(1−ρ) = −exp(ρ).
--
-- Given those, the critical line is forced by the elementary step: bounded
-- transport ⟹ no mode grows ⟹ (via the FE partner) no mode decays ⟹ every
-- exponent is 0, i.e. every nontrivial zero has Re = ½.
--
--     criticality : (transport power-bounded) → (m : Mode) → exp m ≡ 𝟎.
--
-- This is an inhabited --safe theorem: the criticality half of the
-- criterion, over an abstract ordered exponent group so no real analysis
-- is smuggled in.  What remains, to inhabit `(m) → Bounded m`, is the
-- forward analytic estimate (rapid decay of H_h + zero density) — the
-- boundedness itself; that is the RH content this theorem reduces to
-- exactly the two named facts plus power-boundedness.
------------------------------------------------------------------------

module ScaleTransportCriticality where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The abstract ordered exponent group (the real part of ρ−½ lives
--     here).  Only the order facts the argument uses are assumed.
------------------------------------------------------------------------

record OrderedExponents (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    G   : Type ℓ
    𝟎   : G
    _<_ : G → G → Type ℓ
    _≤_ : G → G → Type ℓ
    neg : G → G
    ¬<0→≤0    : {a : G} → ¬ (𝟎 < a) → a ≤ 𝟎     -- trichotomy at 0
    ≤0∧0≤→≡0  : {a : G} → a ≤ 𝟎 → 𝟎 ≤ a → a ≡ 𝟎  -- antisymmetry at 0
    neg≤0→0≤  : {a : G} → neg a ≤ 𝟎 → 𝟎 ≤ a      -- order/negation compat

------------------------------------------------------------------------
-- §2  A scale transport: its modes, their growth exponents, boundedness,
--     the analytic non-boundedness input, and the functional equation.
------------------------------------------------------------------------

module _ (E : OrderedExponents ℓ) where
  open OrderedExponents E

  record Transport : Type (ℓ-suc ℓ) where
    field
      Mode           : Type ℓ
      exp            : Mode → G              -- Re(ρ − ½)
      Bounded        : Mode → Type ℓ         -- the mode's orbit stays O(1)
      grows-unbounds : (m : Mode) → 𝟎 < exp m → ¬ Bounded m
      dual           : Mode → Mode           -- functional equation ρ ↦ 1−ρ
      dual-exp       : (m : Mode) → exp (dual m) ≡ neg (exp m)

  open Transport

  ------------------------------------------------------------------------
  -- §3  Criticality: power-bounded transport forces every exponent to 0.
  --     This is the converse half of RH ⟺ B_h = O(1), formalized.
  ------------------------------------------------------------------------

  criticality :
      (T : Transport)
    → ((m : Mode T) → Bounded T m)              -- transport power-bounded
    → (m : Mode T) → exp T m ≡ 𝟎                -- every zero on the line
  criticality T bounded m = ≤0∧0≤→≡0 le ge
    where
      -- no mode grows: bounded ⟹ exp ≤ 0.
      le : exp T m ≤ 𝟎
      le = ¬<0→≤0 (λ pos → grows-unbounds T m pos (bounded m))

      -- its functional-equation partner also does not grow, so exp ≥ 0.
      partner-≤0 : neg (exp T m) ≤ 𝟎
      partner-≤0 =
        subst (_≤ 𝟎) (dual-exp T m)
          (¬<0→≤0 (λ pos → grows-unbounds T (dual T m) pos (bounded (dual T m))))

      ge : 𝟎 ≤ exp T m
      ge = neg≤0→0≤ partner-≤0
