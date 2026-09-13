{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SelfImprovingCrystal
--
-- The coinductive self-improvement object, of which `SemanticCrystal` is
-- the elementary (deterministic-collapse) seed.
--
-- `SemanticCrystal` gives ONE certified rewrite (amplitudeChart →
-- projectiveChart) that preserves three receivers (defect, nucleus,
-- observation).  One step, two fixed architectures, receipt event,
-- defect PRESERVED — i.e. the `Prashna.deterministic-collapse` point.
--
-- Here that seed is uncollapsed into the interactive coalgebra
-- `Prashna.ISC`: an UNBOUNDED coinductive process whose every transition
-- is a self-rewrite carrying its own non-worsening witness, so the
-- defect is monotone along every run.  The machine `accept` is: at any
-- state, accept any offered non-worsening rewrite, carry its certificate,
-- and continue — forever.  The certified crystal rewrite is exhibited as
-- ONE such edge, so the toy is literally an edge of the real object.
--
--   §1  GENERIC.  For any state type with a preorder `⊑` ("does not
--       worsen"), `Self a = ISC A Move Ev a` with `Move a = Σ a'. a' ⊑ a`
--       and `Ev a _ a' = a' ⊑ a`.  `accept` is the corecursor; `monotone`
--       proves the driven trajectory never worsens: `trajectory σ n a ⊑ a`.
--
--   §2  A CLEAN INSTANCE ON ℕ.  Defect = the number; improvement =
--       `a' ≤ a`.  The self-improvement process on ℕ, monotone by §1.
--
--   §3  THE CRYSTAL IS ONE EDGE.  With the non-worsening relation taken as
--       "measured defect preserved", `SemanticCrystal.projectivizingRewrite`
--       is a `Move` at an amplitude-chart crystal, and `accept` unfolds the
--       ongoing self-improvement process from it.  The seed sits inside the
--       coinductive object as a single certified transition.
--
-- NOT claimed here (the honest boundary; these are the next generalisations,
-- each with its machinery already in the corpus):
--   * convergence to a certified fixed-point limit — needs a well-founded
--     STRICT decrease and the take-metric completion (`PurnataSutra` /
--     `HistoryCompletion`); here the order is a preorder and the crystal
--     edge PRESERVES defect, so the run is non-worsening, not strictly
--     descending.
--   * meaning-preservation across the whole run as identity — `Orbit.path≡bisim`
--     (bisimulation = path) is the tool; not invoked here.
--   * a GROWING receiver family — `learn = install`
--     (`ControlledGrammar.install`, `TheGenerativeLoop…`); here the preserved
--     relation is fixed.
------------------------------------------------------------------------

module SelfImprovingCrystal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-trans)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; _×_)

open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC)
open ISC

open import SemanticCrystal
  using ( Architecture ; amplitudeChart ; projectiveChart
        ; SemanticCrystal ; measuredDefect ; rewriteCrystal
        ; rewrite-preserves-defect )

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The generic self-improvement coalgebra.
------------------------------------------------------------------------

module Generic
  (A : Type ℓ)
  (_⊑_ : A → A → Type ℓ)                       -- "does not worsen"
  (⊑-refl  : (a : A) → a ⊑ a)
  (⊑-trans : {a b c : A} → a ⊑ b → b ⊑ c → a ⊑ c)
  where

  -- a non-worsening rewrite offered at a
  Move : A → Type ℓ
  Move a = Σ[ a' ∈ A ] (a' ⊑ a)

  -- the event carried by the transition: exactly the non-worsening witness
  Ev : (a : A) → Move a → A → Type ℓ
  Ev a _ a' = a' ⊑ a

  Self : A → Type ℓ
  Self = ISC A Move Ev

  -- THE MACHINE.  Accept any offered non-worsening rewrite, carry its
  -- certificate, continue.  Coinductive, productive.
  accept : (a : A) → Self a
  respond (accept a) (a' , le) = a' , le , accept a'

  -- a strategy drives a concrete trajectory
  trajectory : ((a : A) → Move a) → ℕ → A → A
  trajectory σ zero    a = a
  trajectory σ (suc n) a = trajectory σ n (fst (σ a))

  -- THE INVARIANT.  Along any driven run the state never worsens.
  monotone : (σ : (a : A) → Move a) (n : ℕ) (a : A)
           → trajectory σ n a ⊑ a
  monotone σ zero    a = ⊑-refl a
  monotone σ (suc n) a = ⊑-trans (monotone σ n (fst (σ a))) (snd (σ a))

------------------------------------------------------------------------
-- §2  A clean instance on ℕ: defect = the number, improvement = ≤.
------------------------------------------------------------------------

module OnNat = Generic ℕ (λ a' a → a' ≤ a) (λ _ → ≤-refl) ≤-trans

-- the self-improvement process on ℕ, from any seed
natSelf : (n : ℕ) → OnNat.Self n
natSelf = OnNat.accept

------------------------------------------------------------------------
-- §3  The crystal is one edge.
--
-- State = a chart together with a crystal on it; "does not worsen" =
-- measured defect preserved (Lifted to the state's universe).  The
-- certified projectivizing rewrite is then a Move, and `accept` unfolds
-- the process from it.
------------------------------------------------------------------------

CState : Type₁
CState = Σ[ arch ∈ Architecture ] SemanticCrystal arch

cdefect : CState → ℤ
cdefect (_ , c) = measuredDefect c

-- The non-worsening witness, as a RIGID record so it does not unfold into
-- the `measuredDefect`/`potential` expression during module instantiation
-- (a reducible definition stalls unification on the crystal's fields).
record _⊑ᶜ_ (a' a : CState) : Type₁ where
  constructor keeps
  field keep : cdefect a' ≡ cdefect a
open _⊑ᶜ_

⊑ᶜ-refl : (a : CState) → a ⊑ᶜ a
⊑ᶜ-refl a = keeps refl

⊑ᶜ-trans : {a b c : CState} → a ⊑ᶜ b → b ⊑ᶜ c → a ⊑ᶜ c
⊑ᶜ-trans p q = keeps (keep p ∙ keep q)

module OnCrystal = Generic CState _⊑ᶜ_ ⊑ᶜ-refl ⊑ᶜ-trans

-- THE CERTIFIED CRYSTAL REWRITE, as one non-worsening move at an
-- amplitude-chart crystal: go to the projectivised crystal, witnessed by
-- `rewrite-preserves-defect`.
crystalMove : (c : SemanticCrystal amplitudeChart)
            → OnCrystal.Move (amplitudeChart , c)
crystalMove c =
  (projectiveChart , rewriteCrystal c) , keeps (rewrite-preserves-defect c)

-- the ongoing self-improvement process seeded at an amplitude-chart crystal
crystalSelf : (c : SemanticCrystal amplitudeChart)
            → OnCrystal.Self (amplitudeChart , c)
crystalSelf c = OnCrystal.accept (amplitudeChart , c)

-- taking the certified rewrite is one productive step of that process:
-- the successor is the projectivised crystal, carrying the defect-preserved
-- witness, and the process continues from there.
crystalStep : (c : SemanticCrystal amplitudeChart)
  → fst (respond (crystalSelf c) (crystalMove c)) ≡ (projectiveChart , rewriteCrystal c)
crystalStep c = refl
