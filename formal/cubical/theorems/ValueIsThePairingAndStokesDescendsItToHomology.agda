{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ValueIsThePairingAndStokesDescendsItToHomology
--
--   trace     = chain      γ : C
--   evaluator = cochain     ω : D
--   value     = pairing     pair ω γ : R
--
-- Neither side holds the value; it is the interaction.  This file proves
-- the two boxed invariances of the theory: given the Stokes adjunction
--
--     pair (δ ω) c  ≡  pair ω (∂ c),
--
-- and a bilinear pairing into an additive scalar object R,
--
--   * changing the evaluator by a coboundary leaves the value of a CYCLE
--     unchanged:   ∂ γ ≡ 0  ⟹  pair (ω + δ η) γ ≡ pair ω γ ;
--   * changing the trace by a boundary leaves the value under a COCYCLE
--     unchanged:   δ ω ≡ 0  ⟹  pair ω (γ + ∂ σ) ≡ pair ω γ .
--
-- Hence the value factors through cohomology-in-the-evaluator and
-- homology-in-the-trace: the pairing descends to  H • × H_• → R.  This
-- is the exact statement that "a scalar weight is only the value of one
-- cochain against one chain, while the trace can be re-evaluated by
-- evaluators that do not yet exist" — the movement from weights to
-- traces, made a theorem.
--
-- The algebra is abstract on purpose: any concrete (co)chain complex
-- over any additive R with a Stokes adjunction instantiates it.  The
-- content is the DERIVATION of invariance from closedness + adjunction.
--
-- Machine-checked, Agda 2.8.0 + cubical v0.9, --safe, no postulates.
------------------------------------------------------------------------

module ValueIsThePairingAndStokesDescendsItToHomology where

open import Cubical.Foundations.Prelude

module _
  {ℓ : Level}
  (C D R : Type ℓ)
  (pair : D → C → R)
  (∂ : C → C) (δ : D → D)
  (_+C_ : C → C → C) (0C : C)
  (_+D_ : D → D → D) (0D : D)
  (_+R_ : R → R → R) (0R : R)
  -- the Stokes adjunction: δ is adjoint to ∂ under the pairing.
  (stokes : (ω : D) (c : C) → pair (δ ω) c ≡ pair ω (∂ c))
  -- the pairing is additive (bilinear) and sends the zeros to 0R.
  (pair-+D : (ω η : D) (c : C) → pair (ω +D η) c ≡ (pair ω c +R pair η c))
  (pair-+C : (ω : D) (c c' : C) → pair ω (c +C c') ≡ (pair ω c +R pair ω c'))
  (pair-0C : (ω : D) → pair ω 0C ≡ 0R)
  (pair-0D : (c : C) → pair 0D c ≡ 0R)
  (rUnitR  : (r : R) → (r +R 0R) ≡ r)
  where

  -- A cycle: ∂ γ ≡ 0C.  A cocycle: δ ω ≡ 0D.

  -- Changing the evaluator by a coboundary δη does not change the value
  -- of a cycle.
  gauge-invariance : (ω η : D) (γ : C) → ∂ γ ≡ 0C
                   → pair (ω +D δ η) γ ≡ pair ω γ
  gauge-invariance ω η γ cyc =
      pair-+D ω (δ η) γ
    ∙ cong (λ r → pair ω γ +R r)
        ( stokes η γ
        ∙ cong (λ c → pair η c) cyc
        ∙ pair-0C η )
    ∙ rUnitR (pair ω γ)

  -- Changing the trace by a boundary ∂σ does not change the value under
  -- a cocycle.
  boundary-invariance : (ω : D) (γ σ : C) → δ ω ≡ 0D
                      → pair ω (γ +C ∂ σ) ≡ pair ω γ
  boundary-invariance ω γ σ cocyc =
      pair-+C ω γ (∂ σ)
    ∙ cong (λ r → pair ω γ +R r)
        ( sym (stokes ω σ)
        ∙ cong (λ w → pair w σ) cocyc
        ∙ pair-0D σ )
    ∙ rUnitR (pair ω γ)
