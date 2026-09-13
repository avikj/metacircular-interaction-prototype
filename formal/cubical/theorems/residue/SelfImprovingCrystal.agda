{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SelfImprovingCrystal
--
-- The self-improvement object, assembled by APPLYING existing checked
-- constructs — not by proving anything new.  `SemanticCrystal` is the
-- elementary seed (one certified defect-preserving architecture rewrite);
-- everything else here is composition:
--
--   * the interactive coalgebra is `Prashna.ISC` (existing);
--   * the deterministic policy run is `Fibre.Orbit.unfold` (existing) —
--     which, by `Samvada`, is the one-query case of the interactive
--     coalgebra;
--   * CONVERGENCE and MEANING-IDENTITY across the whole infinite run are
--     `Fibre.Orbit.bisim` / `path≡bisim` (existing): a bisimulation IS a
--     path, so a coinductive convergence proof yields an equality with no
--     new machinery;
--   * the runtime self-improvement DRIVE already exists as
--     `Ashanti` (formal/karma) — cost-dissatisfaction-as-a-drive: the body
--     reads its own record, poses its expensive knowledge back to itself in
--     cheaper form (the laghava economy lens), proves it, installs it.
--     This module is that drive's cubical/coalgebraic face.
--
--   §1  THE INTERACTIVE COALGEBRA.  `Self a = ISC A Move Ev a` with
--       `accept` the corecursor: accept any offered non-worsening rewrite,
--       carry its certificate, continue.  The crystal's certified rewrite
--       is one edge (`crystalMove`).
--
--   §2  THE DETERMINISTIC RUN, via `Fibre.Orbit`.  A non-worsening policy
--       is an endomorphism; its run is `unfold policy`.  For the crystal
--       policy the run CONVERGES to a fixed point after one step
--       (`crystalConverges`, by `bisim`), and that convergence is an
--       equality of orbits (`crystalConverges≡`, by `bisim` again) — the
--       meaning held to identity across the whole infinite run.
--
-- Boundary (apply, don't reinvent): a strictly-DESCENDING defect (genuine
-- optimisation, not preservation) converges by `PurnataSutra` /
-- `HistoryCompletion` (existing take-metric completion); the crystal edge
-- preserves defect, so its run converges to a fixed point after one step.
------------------------------------------------------------------------

module SelfImprovingCrystal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ)

open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC)
open ISC
open import Fibre.Orbit using (Orbit ; here ; next ; unfold ; _≈_ ; ≈here ; ≈next ; bisim)
open import SemanticCrystal
  using ( Architecture ; amplitudeChart ; projectiveChart
        ; SemanticCrystal ; measuredDefect ; rewriteCrystal
        ; rewrite-preserves-defect )

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The interactive self-improvement coalgebra (Prashna.ISC).
------------------------------------------------------------------------

module Generic (A : Type ℓ) (_⊑_ : A → A → Type ℓ) where

  Move : A → Type ℓ
  Move a = Σ[ a' ∈ A ] (a' ⊑ a)

  Ev : (a : A) → Move a → A → Type ℓ
  Ev a _ a' = a' ⊑ a

  Self : A → Type ℓ
  Self = ISC A Move Ev

  -- accept any offered non-worsening rewrite, carry its certificate, continue
  accept : (a : A) → Self a
  respond (accept a) (a' , le) = a' , le , accept a'

------------------------------------------------------------------------
-- §2  The crystal instance.
--
-- State = a chart with a crystal on it; non-worsening = defect preserved,
-- as a RIGID record so instantiation never unfolds into `measuredDefect`.
------------------------------------------------------------------------

CState : Type₁
CState = Σ[ arch ∈ Architecture ] SemanticCrystal arch

cdefect : CState → ℤ
cdefect (_ , c) = measuredDefect c

record _⊑ᶜ_ (a' a : CState) : Type₁ where
  constructor keeps
  field keep : cdefect a' ≡ cdefect a

module OnCrystal = Generic CState _⊑ᶜ_

-- the certified crystal rewrite, as one non-worsening edge
crystalMove : (c : SemanticCrystal amplitudeChart)
            → OnCrystal.Move (amplitudeChart , c)
crystalMove c =
  (projectiveChart , rewriteCrystal c) , keeps (rewrite-preserves-defect c)

crystalSelf : (c : SemanticCrystal amplitudeChart)
            → OnCrystal.Self (amplitudeChart , c)
crystalSelf c = OnCrystal.accept (amplitudeChart , c)

-- taking the certified rewrite is one productive step
crystalStep : (c : SemanticCrystal amplitudeChart)
  → fst (respond (crystalSelf c) (crystalMove c)) ≡ (projectiveChart , rewriteCrystal c)
crystalStep c = refl

------------------------------------------------------------------------
-- §3  The deterministic policy run, via Fibre.Orbit — convergence and
--     meaning-identity by `bisim`, no new machinery.
------------------------------------------------------------------------

-- a deterministic non-worsening policy: projectivise an amplitude crystal,
-- otherwise stand still (a fixed point).
cpolicy : CState → CState
cpolicy (amplitudeChart  , c) = projectiveChart , rewriteCrystal c
cpolicy (projectiveChart , c) = projectiveChart , c

-- a projective state is a fixed point, so its run is the constant orbit —
-- proven by `bisim`'s record coinduction.
stable : (a : SemanticCrystal projectiveChart)
       → unfold cpolicy (projectiveChart , a) ≈ unfold (λ z → z) (projectiveChart , a)
≈here (stable a) = refl
≈next (stable a) = stable a

-- THE RUN CONVERGES: after one step the crystal run is the constant orbit.
crystalConverges : (c : SemanticCrystal amplitudeChart)
  → next (unfold cpolicy (amplitudeChart , c))
    ≈ unfold (λ z → z) (projectiveChart , rewriteCrystal c)
crystalConverges c = stable (rewriteCrystal c)

-- …and because a bisimulation IS a path (`Orbit.path≡bisim`), that
-- convergence is an EQUALITY of orbits: meaning held to identity across
-- the whole infinite run.
crystalConverges≡ : (c : SemanticCrystal amplitudeChart)
  → next (unfold cpolicy (amplitudeChart , c))
    ≡ unfold (λ z → z) (projectiveChart , rewriteCrystal c)
crystalConverges≡ c = bisim (crystalConverges c)
