{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- धन-विभेद — the positive cone does not separate.
--
-- A theorem that an observation kernel contains no nonzero POSITIVE
-- element says every positive defect is detected relative to zero.  It
-- does not say two positive defects are told apart: for that the
-- kernel must miss every DIFFERENCE of cone elements, and differences
-- of positive semidefinite stresses fill the whole symmetric space.
-- The distinction is exact and elementary, and Navier–Stokes realises
-- it: two globally smooth solutions u^σ, σ = ±1, with identical coarse
-- velocity, pressure, positive energy reading and resolved flux at an
-- instant, whose resolved stresses R^σ are both positive semidefinite,
-- differ by an indefinite secant R⁺ − R⁻ that the coarse momentum
-- equation feels — ∂_t U^σ(0) = (σA²/2) e₃ sin x₂ — and one resolved
-- continuation test w = e₃ sin x₂ reads the sign.
--
--   §1  THE CRITERION.  For an observer O on a group that respects
--       differences, injectivity on a subset C is exactly the vanishing
--       of the kernel on C − C.  Detecting nonzero elements of C is the
--       weaker statement with C in place of C − C.
--   §2  THE WITNESS, at the level of coefficients.  A stress is a pair
--       (trace coefficient , cross coefficient); the energy observer
--       reads the trace; the cone is trace ≥ |cross|.  The kernel meets
--       the cone only at zero — every positive defect is detected — yet
--       (1 , 1) and (1 , −1) are both in the cone, observed alike, and
--       their difference (0 , 2) is in the kernel and outside the cone.
--       The continuation receiver reads the cross coefficient and
--       separates them.
--   §3  NON-DESCENT.  By SankramanaShreni's localization the receiver
--       does not factor through the observation: the fibre over the
--       common reading has explicit distinct witnesses.  This is the
--       error a singularity-exclusion argument must avoid — a
--       positive-kernel theorem cannot be promoted to continuation
--       faithfulness.
--
-- धन (dhana, positive) and विभेद (vibheda, distinction) are ordinary
-- Sanskrit.
------------------------------------------------------------------------

module DhanaVibheda_DetectingEveryPositiveDefectDoesNotDistinguishTwoPositiveDefectsSoAnObserverInjectiveOnAConeNeedsTheDifferenceKernelToVanish where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; isSetℤ ; injPos) renaming (_+_ to _+ℤ_ ; -_ to -ℤ_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (module Localization)

private
  variable
    ℓ ℓ′ ℓc : Level

------------------------------------------------------------------------
-- १ · Injective on C  ⇔  the kernel misses C − C.
------------------------------------------------------------------------

module _ (V : Group ℓ) (W : Group ℓ′) where
  private
    module V = GroupStr (snd V)
    module W = GroupStr (snd W)
    module VT = GroupTheory V
    module WT = GroupTheory W

  -- the difference x − y
  _−_ : ⟨ V ⟩ → ⟨ V ⟩ → ⟨ V ⟩
  x − y = x V.· V.inv y

  -- an observer that respects differences
  module _ (O : ⟨ V ⟩ → ⟨ W ⟩)
           (O-diff : (x y : ⟨ V ⟩) → O (x − y) ≡ O x W.· W.inv (O y))
           (C : ⟨ V ⟩ → Type ℓc) where

    -- injective on C
    Pṛthak : Type (ℓ-max (ℓ-max ℓ ℓ′) ℓc)
    Pṛthak = (x y : ⟨ V ⟩) → C x → C y → O x ≡ O y → x ≡ y

    -- the kernel meets C − C only at the unit
    Bheda-śūnya : Type (ℓ-max (ℓ-max ℓ ℓ′) ℓc)
    Bheda-śūnya = (x y : ⟨ V ⟩) → C x → C y → O (x − y) ≡ W.1g → x − y ≡ V.1g

    -- the weaker statement: the kernel meets C only at the unit
    Dhana-śūnya : Type (ℓ-max (ℓ-max ℓ ℓ′) ℓc)
    Dhana-śūnya = (x : ⟨ V ⟩) → C x → O x ≡ W.1g → x ≡ V.1g

    -- x − y ≡ 1 ⇒ x ≡ y, and back
    diff-unit→eq : (x y : ⟨ V ⟩) → x − y ≡ V.1g → x ≡ y
    diff-unit→eq x y p =
        sym (V.·IdR x)
      ∙ cong (x V.·_) (sym (V.·InvL y))
      ∙ V.·Assoc x (V.inv y) y
      ∙ cong (V._· y) p
      ∙ V.·IdL y

    eq→diff-unit : (x y : ⟨ V ⟩) → x ≡ y → x − y ≡ V.1g
    eq→diff-unit x y p = cong (V._· V.inv y) p ∙ V.·InvR y

    -- O x ≡ O y ⇒ O (x − y) ≡ 1, and back
    obs-eq→diff-ker : (x y : ⟨ V ⟩) → O x ≡ O y → O (x − y) ≡ W.1g
    obs-eq→diff-ker x y p = O-diff x y ∙ cong (W._· W.inv (O y)) p ∙ W.·InvR (O y)

    diff-ker→obs-eq : (x y : ⟨ V ⟩) → O (x − y) ≡ W.1g → O x ≡ O y
    diff-ker→obs-eq x y p =
        sym (W.·IdR (O x))
      ∙ cong (O x W.·_) (sym (W.·InvL (O y)))
      ∙ W.·Assoc (O x) (W.inv (O y)) (O y)
      ∙ cong (W._· O y) (sym (O-diff x y) ∙ p)
      ∙ W.·IdL (O y)

    -- THE CRITERION
    pṛthak→bheda : Pṛthak → Bheda-śūnya
    pṛthak→bheda inj x y cx cy k =
      eq→diff-unit x y (inj x y cx cy (diff-ker→obs-eq x y k))

    bheda→pṛthak : Bheda-śūnya → Pṛthak
    bheda→pṛthak sep x y cx cy e =
      diff-unit→eq x y (sep x y cx cy (obs-eq→diff-ker x y e))

------------------------------------------------------------------------
-- २ · The witness: two positive stresses the energy reading cannot tell apart.
------------------------------------------------------------------------

-- a stress, at the level of coefficients: (trace , cross)
Stress : Type₀
Stress = ℤ × ℤ

-- the energy reading sees the trace
ūrjā : Stress → ℤ
ūrjā (tr , _) = tr

-- the continuation receiver reads the cross coefficient
pratigrāha : Stress → ℤ
pratigrāha (_ , c) = c

-- the two resolved stresses R^σ, σ = ±1, in units of A²/2 … with A² = 2
R⁺ R⁻ : Stress
R⁺ = pos 1 , pos 1
R⁻ = pos 1 , negsuc 0

-- observed alike by energy (and by pressure source and flux, which are
-- constant on this pair), separated by the receiver
sama-ūrjā : ūrjā R⁺ ≡ ūrjā R⁻
sama-ūrjā = refl

bhinna-grāha : ¬ (pratigrāha R⁺ ≡ pratigrāha R⁻)
bhinna-grāha p = posNotNegsuc p
  where
  posNotNegsuc : pos 1 ≡ negsuc 0 → ⊥
  posNotNegsuc q = subst P q tt
    where
    P : ℤ → Type₀
    P (pos _)    = Unit
    P (negsuc _) = ⊥

-- the two are distinct stresses
R⁺≢R⁻ : ¬ (R⁺ ≡ R⁻)
R⁺≢R⁻ p = bhinna-grāha (cong pratigrāha p)

------------------------------------------------------------------------
-- ३ · Non-descent: the receiver does not factor through the energy reading.
------------------------------------------------------------------------

-- cost the receiver as a natural number: 1 on the σ = + stress, 0 on σ = −
mūlya : Stress → ℕ
mūlya (_ , pos _)    = suc zero
mūlya (_ , negsuc _) = zero

mūlya-apart : ¬ (mūlya R⁺ ≡ mūlya R⁻)
mūlya-apart p = snotz p

open Localization {X = Stress} {Y = ℤ} isSetℤ ūrjā mūlya

-- no function of the energy reading recovers the continuation sign
dhana-na-avatarati : ¬ (Σ[ c ∈ (Ĝ → ℕ) ] ((s : Stress) → c (L s) ≡ mūlya s))
dhana-na-avatarati = costDoesNotDescend R⁺ R⁻ sama-ūrjā mūlya-apart
