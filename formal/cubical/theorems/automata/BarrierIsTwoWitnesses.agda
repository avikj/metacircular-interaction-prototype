{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BarrierIsTwoWitnesses
--
-- The witness thread has been measuring absences of its own choosing.
-- This applies it to the corpus's own headline open problem, and the fit
-- is not an analogy — it is the same shape.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT `notes/BARRIER.md` ALREADY SAYS
--
-- **Proposition B3 (nonlinear closure).** *Any O = Φ(Q_{w₁},…,Q_{w_r})
-- with arbitrary — even non-computable — post-processing Φ is a function
-- of r numbers each of which factors as in B1.  Hence the entire class
-- WL_d(L,r) factors through the blurred measure σ_k * K_L.
-- Post-processing cannot recover information the windows did not pass.*
--
-- That is the PROBE structure of `TheCeilingIsAboutReading`, arrived at
-- independently and for analytic reasons: the decoders are exactly the
-- post-processings, and what they may read is exactly the blur.
--
-- And then, in the same note:
--
-- > **The barrier problem (precise).** Exhibit, or rule out, a pair of
-- > admissible zero configurations indistinguishable to all
-- > WL_d(L,poly) observables … but with different pair-correlation
-- > statistics.
--
-- A PAIR.  The note reached the number 2 on its own, from the
-- mathematics, before any of this measure existed.  What the measure
-- adds is why it is 2 and not 1 and not more.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE
--
-- Schematically, over abstract `Config`, `Blur`, `Stat` — which is the
-- right generality, because B3's content is precisely that Φ is
-- arbitrary:
--
--     Recovers Φ  =  (c : Config) → Φ (blur c) ≡ stat c
--     Barrier     =  ¬ Σ[ Φ ∈ (Blur → Stat) ] Recovers Φ
--
--   one-config-never-suffices : ¬ Refutes (FullLaw blur stat) (c ∷ [])
--   barrier-from-a-pair       : blur c ≡ blur c' → ¬ (stat c ≡ stat c')
--                             → Barrier
--   barrier-witness-number-2  : …and the witness number is exactly 2
--
-- The first is the methodological content and it holds with no
-- hypothesis whatever: **no single admissible configuration can
-- establish a barrier of this kind**, however extreme, because the
-- constant post-processing answers it.  A barrier here is irreducibly a
-- statement about two objects.
--
-- The second says the pair the note asks for is not merely sufficient
-- evidence — it is the entire content.  Given it, every post-processing
-- dies at once, non-computable ones included, which is what B3's
-- "arbitrary Φ" was for.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT PROVED, AND MUST NOT BE READ IN
--
-- Nothing analytic.  No claim that such a pair exists, that the zeros of
-- ζ admit one, that the counting law and functional equation can be met,
-- or anything about L, resolution, or admissibility.  `notes/BARRIER.md`
-- is explicit that B1–B3 do *not* establish a barrier against inferring
-- ζ's correlations, and this module establishes strictly less than B3.
--
-- What it establishes is the SHAPE: that the open problem is a
-- two-witness problem, that one witness is provably never enough, and
-- that "exhibit a pair" is not a convenient route to the barrier but its
-- exact statement.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module BarrierIsTwoWitnesses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ¬-<-zero ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Discrete)

open import WitnessNumberIsTwo using (Refutes ; refutes→absent)
open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import WhyTheSitesAreTwo using (CollisionFree)
open import SiteAudit
  using (FullLaw ; full-singleton-never ; full-empty-never ; full-collision→refutes)
open import TheCeilingIsAboutReading using (tableZ-correct)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1.  B3's structure, taken at its word
------------------------------------------------------------------------

module Barrier
  {Config : Type ℓ} {Blur : Type ℓ'} {Stat : Type ℓ''}
  (blur : Config → Blur) (stat : Config → Stat)
  where

  -- B3: an admissible observable is an arbitrary post-processing of the
  -- blurred measure.  No computability, no continuity, nothing.
  Observable : Type (ℓ-max ℓ' ℓ'')
  Observable = Blur → Stat

  Recovers : Observable → Type (ℓ-max ℓ ℓ'')
  Recovers Φ = (c : Config) → FullLaw blur stat Φ c

  BarrierHolds : Type (ℓ-max ℓ (ℓ-max ℓ' ℓ''))
  BarrierHolds = ¬ (Σ[ Φ ∈ Observable ] Recovers Φ)

  ----------------------------------------------------------------------
  -- 2.  ONE CONFIGURATION IS NEVER ENOUGH
  --
  -- Whatever a single admissible configuration does, the constant
  -- post-processing `λ _ → stat c` answers it.  So no barrier of this
  -- kind is ever established by exhibiting one object.
  ----------------------------------------------------------------------

  one-config-never-suffices : (c : Config) → ¬ Refutes (FullLaw blur stat) (c ∷ [])
  one-config-never-suffices = full-singleton-never blur stat

  no-config-never-suffices : (c : Config) → ¬ Refutes (FullLaw blur stat) []
  no-config-never-suffices = full-empty-never blur stat

  ----------------------------------------------------------------------
  -- 3.  A PAIR IS THE WHOLE CONTENT
  --
  -- Two configurations the blur identifies and the statistic separates
  -- kill every post-processing at once — which is exactly what B3's
  -- "arbitrary, even non-computable Φ" is there to make meaningful.
  ----------------------------------------------------------------------

  pair-refutes : {c c' : Config}
               → blur c ≡ blur c' → ¬ (stat c ≡ stat c')
               → Refutes (FullLaw blur stat) (c ∷ c' ∷ [])
  pair-refutes = full-collision→refutes blur stat

  barrier-from-a-pair : {c c' : Config}
                      → blur c ≡ blur c' → ¬ (stat c ≡ stat c')
                      → BarrierHolds
  barrier-from-a-pair {c} {c'} same differ =
    refutes→absent (FullLaw blur stat) (c ∷ c' ∷ [])
      (pair-refutes {c} {c'} same differ)

  ----------------------------------------------------------------------
  -- 4.  AND THE WITNESS NUMBER IS EXACTLY 2
  ----------------------------------------------------------------------

  barrier-witness-number-2 :
    (c c' : Config) → blur c ≡ blur c' → ¬ (stat c ≡ stat c')
    → WitnessNumberIs (FullLaw blur stat) 2
  barrier-witness-number-2 c c' same differ =
      (c ∷ c' ∷ [] , refl , pair-refutes {c} {c'} same differ)
    , least
    where
    least : (ys : List Config) → length ys < 2 → ¬ Refutes (FullLaw blur stat) ys
    least []           _  = no-config-never-suffices c
    least (a ∷ [])     _  = one-config-never-suffices a
    least (a ∷ b ∷ ys) lt = Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred lt)))

  ----------------------------------------------------------------------
  -- 5.  The converse, on any finite family of configurations
  --
  -- If a listed family contains NO such pair, a post-processing
  -- answering the whole family exists — so on that family the barrier
  -- fails.  This needs the blur values to be comparable, which is the
  -- `Discrete Blur` of `TheCeilingIsAboutReading`, and it is a statement
  -- about the listed family only, not about all of `Config`.
  ----------------------------------------------------------------------

  no-pair-on-a-family :
    (dB : Discrete Blur) (c₀ : Config) (cs : List Config)
    → CollisionFree blur stat (c₀ ∷ cs)
    → ¬ Refutes (FullLaw blur stat) (c₀ ∷ cs)
  no-pair-on-a-family dB c₀ cs cf ref =
    ref decode (holds (c₀ ∷ cs) (λ _ m → m))
    where
    open import WhyTheSitesAreTwo using (Mem)
    open import WitnessNumberIsTwo using (AllHold)
    open import Cubical.Data.Unit using (tt*)
    open import Cubical.Data.Sum using (inl ; inr)
    open import TheCeilingIsAboutReading using (tableZ)

    decode : Blur → Stat
    decode z = tableZ dB blur stat (stat c₀) z (c₀ ∷ cs)

    holds : (ys : List Config) → ((c : Config) → Mem c ys → Mem c (c₀ ∷ cs))
          → AllHold (FullLaw blur stat) decode ys
    holds []       _   = tt*
    holds (y ∷ ys) inc =
        tableZ-correct dB blur stat (stat c₀) (c₀ ∷ cs) cf y (inc y (inl refl))
      , holds ys (λ z m → inc z (inr m))

------------------------------------------------------------------------
-- 6.  What this does for the barrier programme.
--
-- It does not advance it by one inch analytically, and says so.  What it
-- fixes is the LOGICAL COST of the target, which `notes/BARRIER.md` had
-- already located correctly and without a reason:
--
--   * one configuration can never establish a barrier of this shape, no
--     matter how extreme — the constant post-processing answers it.  So
--     any programme of the form "construct a single spectrum with
--     property P" is looking at the wrong kind of object;
--   * a pair with equal blur and different statistic is not evidence for
--     the barrier, it IS the barrier, killing arbitrary Φ at once;
--   * and on any finite family with no such pair, the barrier provably
--     fails — so the search cannot be narrowed to a family that has been
--     checked pairwise.
--
-- The note's phrase "exhibit … a pair" is therefore exact rather than
-- idiomatic, and its own honesty ledger — that B1–B3 do not establish
-- the barrier — is confirmed from the other side: B3 gives the probe
-- structure, and the probe structure is what makes the cost exactly 2.
--
-- OPEN, and it is the note's own open problem, untouched here: whether
-- such a pair exists among admissible configurations.
------------------------------------------------------------------------
