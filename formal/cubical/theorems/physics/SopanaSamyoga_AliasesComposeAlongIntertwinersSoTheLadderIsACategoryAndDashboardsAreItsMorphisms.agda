{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सोपान-संयोग — the ladder composes.
--
-- The divisor order, made categorical.  An ALIASED OBSERVABLE is a
-- pair (O, g) with O ∘ turn = g ∘ O; a DASHBOARD between aliased
-- observables is a post-processing h that intertwines the aliases,
-- h ∘ g₁ = g₂ ∘ h.  Then:
--
--   §1  DASHBOARDS TRANSPORT ALIASES: the composite h ∘ O₁ is itself
--       aliased, through g₂ — two lines.  Coarsening inherits its
--       rung from the intertwiner, so the ladder's structure descends
--       automatically along every dashboard.
--
--   §2  DASHBOARDS COMPOSE: intertwiners of intertwiners intertwine —
--       the aliased observables form a category, and the reading
--       theorem is functorial over it.
--
--   §3  THE XOR RUNG IS RECOVERED, not re-proved: the xor observable
--       is the dashboard of the identity rung along the intertwiner
--       xor ∘ turn = not ∘ xor, so its mod-two reading is an instance
--       of §1 applied to the top rung.  One rung is fundamental; the
--       rest are its images under dashboards.
--
-- The full picture: the top of the ladder is the identity reading
-- with the quarter turn; every aliased observable is a dashboard
-- image of it; the divisor order is the category's reachability; and
-- climbing against the arrows is the new-sense gate.  Resolution is
-- a category, division is its geometry, and the ladder needed to be
-- proved only once, at the top.
--
-- SYĀT — THE CLAIM, EXACTLY.  The category structure and the
-- recovered rung; universality of the top rung (every aliased
-- observable a dashboard of it) is the standing construction.
------------------------------------------------------------------------

module SopanaSamyoga_AliasesComposeAlongIntertwinersSoTheLadderIsACategoryAndDashboardsAreItsMorphisms where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; not)

open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import MatraSopana_EachObservableReadsTheTwistCountModuloTheOrderOfItsOwnBlindness
  using (vyatyaya ; vyatyaya-cala)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · Dashboards transport aliases.
------------------------------------------------------------------------

pravāha-vahana :
    {A : Type ℓ} {B : Type ℓ'}
    (O : Sūtra → A) (g₁ : A → A)
    (h : A → B) (g₂ : B → B)
  → ((x : Sūtra) → O (caturaṃśa x) ≡ g₁ (O x))
  → ((a : A) → h (g₁ a) ≡ g₂ (h a))
  → (x : Sūtra) → h (O (caturaṃśa x)) ≡ g₂ (h (O x))
pravāha-vahana O g₁ h g₂ fac inter x =
  cong h (fac x) ∙ inter (O x)

------------------------------------------------------------------------
-- २ · Dashboards compose.
------------------------------------------------------------------------

vahana-saṃyoga :
    {A : Type ℓ} {B : Type ℓ'} {C : Type ℓ''}
    (g₁ : A → A) (g₂ : B → B) (g₃ : C → C)
    (h₁ : A → B) (h₂ : B → C)
  → ((a : A) → h₁ (g₁ a) ≡ g₂ (h₁ a))
  → ((b : B) → h₂ (g₂ b) ≡ g₃ (h₂ b))
  → (a : A) → h₂ (h₁ (g₁ a)) ≡ g₃ (h₂ (h₁ a))
vahana-saṃyoga g₁ g₂ g₃ h₁ h₂ i₁ i₂ a =
  cong h₂ (i₁ a) ∙ i₂ (h₁ a)

------------------------------------------------------------------------
-- ३ · The xor rung, recovered from the top by transport.
------------------------------------------------------------------------

vyatyaya-sopāna : (x : Sūtra) → vyatyaya (caturaṃśa x) ≡ not (vyatyaya x)
vyatyaya-sopāna =
  pravāha-vahana (λ x → x) caturaṃśa vyatyaya not
    (λ x → refl) vyatyaya-cala
