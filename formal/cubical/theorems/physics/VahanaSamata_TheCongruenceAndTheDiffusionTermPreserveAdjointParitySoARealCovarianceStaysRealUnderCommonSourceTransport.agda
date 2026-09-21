{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}

------------------------------------------------------------------------
-- वहन-समता — evenness of the carrying.
--
-- CONJUGATION AND CONGRUENCE PRESERVE ADJOINT PARITY, SO A COVARIANCE
-- STAYS A COVARIANCE UNDER TRANSPORT FROM A COMMON SOURCE.
--
-- A covariance is not an arbitrary operator: it is a REAL one, `† Π ≡ Π`.
-- Every statement that says a covariance evolves — a Lyapunov generator
--
--     L · Π  +  Π · L†        (the drift congruence)
--
-- a diffusion term Σⱼ Dⱼ · Π · Dⱼ†, a transport Π ↦ 𝔼[ R · Π · R† ] —
-- is only a statement ABOUT COVARIANCES if realness survives it.  That
-- survival is usually left implicit.  It is an algebraic fact, it needs
-- no analysis, and it is what this module proves.
--
-- Everything holds in `LeakageCommutator`'s bare ring with involution:
-- no scalars, no positivity, no trace, no idempotence, no topology.
--
--   §1  CONJUGATION `conj a x = (a · x) · † a` preserves parity in both
--       rows: real ↦ real, and skew ↦ skew.  `a` is completely free —
--       no hypothesis on it at all, which is what makes the diffusion
--       term's directions arbitrary.
--
--   §2  CONGRUENCE `lyap a x = (a · x) + (x · † a)` likewise, in both
--       rows, again with `a` free.
--
--   §3  a finite sum of real elements is real (the base case is
--       `† 0r ≡ 0r`, imported rather than reproved).
--
--   §4  and therefore the whole generator
--
--         x  ↦  lyap L x  +  Σ_{j<k} conj (Dⱼ) x
--
--       carries real to real, for every drift `L`, every family of
--       directions `D`, and every `k`.  Nothing about the family is
--       assumed: not commutation, not self-adjointness, not a dimension.
--
--   §5  the same lemma reads the transport form: a finite average
--       Σ_{j<k} conj (Vⱼ) x of conjugations by a shared lift is real
--       whenever `x` is.  An expectation over a common source is, at
--       this level, a sum over its branches — and §3 does not care how
--       many branches there are or what weights they would carry, since
--       weights are conjugations too.
--
--   §6  and the parity table of `Vyatikrama` is completed.  That module
--       displays four cells and proves three; its remaining cell —
--       both elements self-adjoint, ANTIcommutator self-adjoint — is
--       §2's real row at `† a ≡ a`, and is discharged here.
--
-- WHAT THE TWO ROWS SAY TOGETHER.  Conjugation and congruence do not
-- MIX the two parities: they act diagonally on the real/skew split.  So
-- an operator that starts real can never acquire a skew part under any
-- amount of this transport, and no cancellation between the two sectors
-- is available to a flow built out of these pieces.  That is a stronger
-- statement than "the flow preserves realness", and both rows are needed
-- to make it.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–6 in any ring with involution, for all
-- elements satisfying the displayed parity equations, for every family
-- and every finite `k`.  NOT claimed: positivity — `≥ 0` is not
-- expressible here and no cone beyond the real/skew split is mentioned;
-- nothing about the SOLUTION of any evolution equation, only that its
-- right-hand side lands where its left-hand side lives; nothing about
-- expectations, measures, or probability — §5's "average" is a finite
-- fold and is named as one; no trace, no rank, no spectrum; and nothing
-- about which `Π` arises from which source, which is the modelling step
-- and is carried out in `SamanaMula` under its own hypothesis.
------------------------------------------------------------------------

module VahanaSamata_TheCongruenceAndTheDiffusionTermPreserveAdjointParitySoARealCovarianceStaysRealUnderCommonSourceTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import LeakageCommutator using (IsInvolution)
import Vyatikrama_TheCommutatorOfASelfAdjointWithASkewAdjointIsSelfAdjointSoTheCrossSectorCurrentIsARealPairing as VY

private
  variable
    ℓ : Level

module _ (R : Ring ℓ) (†_ : ⟨ R ⟩ → ⟨ R ⟩) (inv : IsInvolution R †_) where
  open RingStr (snd R)
  open RingTheory R
  open IsInvolution inv

  private
    A : Type ℓ
    A = ⟨ R ⟩

    †-0 : † 0r ≡ 0r
    †-0 = VY.†-pres-0' R †_ inv

  --------------------------------------------------------------------
  -- ० · The two ways an operator is carried.
  --------------------------------------------------------------------

  conj : A → A → A                        -- a · x · a†
  conj a x = (a · x) · († a)

  lyap : A → A → A                        -- a · x + x · a†
  lyap a x = (a · x) + (x · († a))

  --------------------------------------------------------------------
  -- १ · CONJUGATION IS PARITY-DIAGONAL.  No hypothesis on `a`.
  --
  --     †((a·x)·a†) = a†† · (a·x)†  =  a · (x† · a†) ,
  --
  -- and then the parity of `x` passes straight through.
  --------------------------------------------------------------------

  conj-real : (a x : A) → († x ≡ x) → † (conj a x) ≡ conj a x
  conj-real a x hx =
      † ((a · x) · († a))
    ≡⟨ †-· (a · x) († a) ⟩
      († († a)) · († (a · x))
    ≡⟨ cong₂ _·_ (†-invol a) (†-· a x) ⟩
      a · ((† x) · († a))
    ≡⟨ cong (λ z → a · (z · († a))) hx ⟩
      a · (x · († a))
    ≡⟨ ·Assoc a x († a) ⟩
      (a · x) · († a) ∎

  conj-skew : (a x : A) → († x ≡ - x) → † (conj a x) ≡ - (conj a x)
  conj-skew a x hx =
      † ((a · x) · († a))
    ≡⟨ †-· (a · x) († a) ⟩
      († († a)) · († (a · x))
    ≡⟨ cong₂ _·_ (†-invol a) (†-· a x) ⟩
      a · ((† x) · († a))
    ≡⟨ cong (λ z → a · (z · († a))) hx ⟩
      a · ((- x) · († a))
    ≡⟨ cong (a ·_) (-DistL· x († a)) ⟩
      a · (- (x · († a)))
    ≡⟨ -DistR· a (x · († a)) ⟩
      - (a · (x · († a)))
    ≡⟨ cong (λ z → - z) (·Assoc a x († a)) ⟩
      - ((a · x) · († a)) ∎

  --------------------------------------------------------------------
  -- २ · CONGRUENCE IS PARITY-DIAGONAL.  Again `a` is free: the two
  --     summands swap places under `†`, and the parity of `x` decides
  --     whether the swapped sum is the original or its negation.
  --------------------------------------------------------------------

  lyap-real : (a x : A) → († x ≡ x) → † (lyap a x) ≡ lyap a x
  lyap-real a x hx =
      † ((a · x) + (x · († a)))
    ≡⟨ †-+ (a · x) (x · († a)) ⟩
      († (a · x)) + († (x · († a)))
    ≡⟨ cong₂ _+_ (†-· a x) (†-· x († a)) ⟩
      ((† x) · († a)) + ((† († a)) · († x))
    ≡⟨ cong₂ (λ z w → (z · († a)) + (w · z)) hx (†-invol a) ⟩
      (x · († a)) + (a · x)
    ≡⟨ +Comm (x · († a)) (a · x) ⟩
      (a · x) + (x · († a)) ∎

  lyap-skew : (a x : A) → († x ≡ - x) → † (lyap a x) ≡ - (lyap a x)
  lyap-skew a x hx =
      † ((a · x) + (x · († a)))
    ≡⟨ †-+ (a · x) (x · († a)) ⟩
      († (a · x)) + († (x · († a)))
    ≡⟨ cong₂ _+_ (†-· a x) (†-· x († a)) ⟩
      ((† x) · († a)) + ((† († a)) · († x))
    ≡⟨ cong₂ (λ z w → (z · († a)) + (w · z)) hx (†-invol a) ⟩
      ((- x) · († a)) + (a · (- x))
    ≡⟨ cong₂ _+_ (-DistL· x († a)) (-DistR· a x) ⟩
      (- (x · († a))) + (- (a · x))
    ≡⟨ +Comm (- (x · († a))) (- (a · x)) ⟩
      (- (a · x)) + (- (x · († a)))
    ≡⟨ -Dist (a · x) (x · († a)) ⟩
      - ((a · x) + (x · († a))) ∎

  --------------------------------------------------------------------
  -- ३ · A FINITE SUM OF REAL ELEMENTS IS REAL.
  --------------------------------------------------------------------

  sum : ℕ → (ℕ → A) → A
  sum zero    f = 0r
  sum (suc k) f = f k + sum k f

  sum-real : (k : ℕ) (f : ℕ → A) → ((j : ℕ) → † (f j) ≡ f j)
    → † (sum k f) ≡ sum k f
  sum-real zero    f h = †-0
  sum-real (suc k) f h =
    †-+ (f k) (sum k f) ∙ cong₂ _+_ (h k) (sum-real k f h)

  --------------------------------------------------------------------
  -- ४ · THE GENERATOR CARRIES REAL TO REAL.
  --
  --     x ↦ L·x + x·L†  +  Σ_{j<k} Dⱼ·x·Dⱼ†
  --------------------------------------------------------------------

  generator : A → (ℕ → A) → ℕ → A → A
  generator L D k x = lyap L x + sum k (λ j → conj (D j) x)

  generator-real : (L : A) (D : ℕ → A) (k : ℕ) (x : A)
    → († x ≡ x) → † (generator L D k x) ≡ generator L D k x
  generator-real L D k x hx =
      †-+ (lyap L x) (sum k (λ j → conj (D j) x))
    ∙ cong₂ _+_ (lyap-real L x hx)
                (sum-real k (λ j → conj (D j) x) (λ j → conj-real (D j) x hx))

  --------------------------------------------------------------------
  -- ५ · AND THE TRANSPORT FORM.  A finite average of conjugations by a
  --     shared lift is real whenever what it carries is real.
  --------------------------------------------------------------------

  carry : (ℕ → A) → ℕ → A → A
  carry V k x = sum k (λ j → conj (V j) x)

  carry-real : (V : ℕ → A) (k : ℕ) (x : A)
    → († x ≡ x) → † (carry V k x) ≡ carry V k x
  carry-real V k x hx =
    sum-real k (λ j → conj (V j) x) (λ j → conj-real (V j) x hx)

  --------------------------------------------------------------------
  -- ६ · THE FOURTH CELL OF `Vyatikrama`'s PARITY TABLE.  That module
  --     proves three of the four and displays the fourth:
  --
  --                        [p,a]†            {p,a}†
  --       a self-adjoint   -[p,a]  (its §2)   {p,a}   (here)
  --       a skew-adjoint   +[p,a]  (its §1)  -{p,a}  (its §3)
  --
  --     With `† p ≡ p`, `lyap p a` IS the anticommutator, so §2's real
  --     row discharges it directly.
  --------------------------------------------------------------------

  anti-real-real : (p a : A) → († p ≡ p) → († a ≡ a)
    → † ((p · a) + (a · p)) ≡ (p · a) + (a · p)
  anti-real-real p a hp ha =
      † ((p · a) + (a · p))
    ≡⟨ cong (λ z → † ((p · a) + (a · z))) (sym hp) ⟩
      † ((p · a) + (a · († p)))
    ≡⟨ lyap-real p a ha ⟩
      (p · a) + (a · († p))
    ≡⟨ cong (λ z → (p · a) + (a · z)) hp ⟩
      (p · a) + (a · p) ∎
