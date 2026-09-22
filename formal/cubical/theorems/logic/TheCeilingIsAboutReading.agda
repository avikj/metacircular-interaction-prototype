{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCeilingIsAboutReading
--
-- The result is a
-- characterisation of exactly which decoder spaces DO get the ceiling,
-- and `Laghava`'s is the boundary case.
--
-- ────────────────────────────────────────────────────────────────────
-- THE THEOREM
--
-- Give the observations a discrete PROBE `p : Y → Z` and restrict
-- decoders to those that read the probe only:
--
--     ProbeLaw q t p g x  =  g (p (q x)) ≡ t x        g : Z → T
--
-- Then the ceiling comes back with no hypothesis on Y at all:
--
--     probe-ceiling : Discrete Z
--                   → CollisionFree (p ∘ q) t (x₀ ∷ xs)
--                   → ¬ Refutes (ProbeLaw q t p) (x₀ ∷ xs)
--
-- because the table is now built over Z, where comparison is available.
-- Y never has to be compared with anything.
--
-- ────────────────────────────────────────────────────────────────────
-- AT LAGHAVA
--
-- One probe suffices: `p d = d 1`, so Z = ℕ.  The लाघव pair survives it
-- — `short` and `long` have the same denotation, hence the same value at
-- 1, and different sizes — so it is still a collision after probing, and
--
--     laghava-probe-is-two : WitnessNumberIs (ProbeLaw eval size probe1) 2
--
-- Over the probed decoders, EVERY absence at `Laghava` costs 2, the
-- लाघव one included.  And probing only removes decoders
-- (`probeFactors→meaningFactors`), so the probed absence is the weaker
-- statement: `Laghava`'s own theorem implies it and not conversely.
--
-- ────────────────────────────────────────────────────────────────────
--
-- SETTLED.  The ceiling is not about discreteness of the OBSERVATIONS.
-- It is about the decoders having something discrete to read.  Restrict
-- them to any discrete probe, however coarse, and the ceiling returns —
-- at `Laghava`, at a single evaluation point.
--
-- The FULL space
-- `Denotation → ℕ` is not reachable by a probe, and
-- deciding membership in it is deciding equality of functions ℕ → ℕ.
------------------------------------------------------------------------

module TheCeilingIsAboutReading where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc ; discreteℕ)
open import Cubical.Data.Nat.Order using (_<_ ; ¬-<-zero ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥ ; ⊥*)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import WitnessNumberIsTwo using (AllHold ; Refutes)
open import WitnessNumberIsThePotential using (WitnessNumberIs)
open import WhyTheSitesAreTwo using (Mem ; CollisionFree)
open import Laghava
  using (Expr ; Denotation ; eval ; size ; laghava-collision ; FactorsThroughMeaning)

private
  variable
    ℓx ℓy ℓz ℓt : Level

------------------------------------------------------------------------
-- 1.  The ceiling for decoders on a whole discrete codomain
--
-- The table is over Z, so this is the `LocatingIsEnough` argument with
-- the image machinery removed.  It is shorter, not longer.
------------------------------------------------------------------------

module _ {X : Type ℓx} {Z : Type ℓz} {T : Type ℓt}
         (dZ : Discrete Z) (r : X → Z) (t : X → T) (fb : T) where

  tableZ : Z → List X → T
  tableZ z []       = fb
  tableZ z (x ∷ xs) with dZ (r x) z
  ... | yes _ = t x
  ... | no  _ = tableZ z xs

  tableZ-correct :
    (ys : List X) → CollisionFree r t ys
    → (x : X) → Mem x ys → tableZ (r x) ys ≡ t x
  tableZ-correct []       cf x m = Empty.rec* m
  tableZ-correct (y ∷ ys) cf x m with dZ (r y) (r x)
  ... | yes e = cf y x (inl refl) m e
  ... | no ¬e = tableZ-correct ys cf' x (later m)
    where
    cf' : CollisionFree r t ys
    cf' a b ma mb = cf a b (inr ma) (inr mb)

    later : Mem x (y ∷ ys) → Mem x ys
    later (inl x≡y) = Empty.rec (¬e (sym (cong r x≡y)))
    later (inr l)   = l

------------------------------------------------------------------------
-- 2.  THE PROBED LAW, and its ceiling
------------------------------------------------------------------------

ProbeLaw : {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {T : Type ℓt}
         → (X → Y) → (X → T) → (Y → Z) → (Z → T) → X → Type ℓt
ProbeLaw q t p g x = g (p (q x)) ≡ t x

module _ {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {T : Type ℓt}
         (dZ : Discrete Z) (q : X → Y) (t : X → T) (p : Y → Z) where

  probe-ceiling :
    (x₀ : X) (xs : List X)
    → CollisionFree (λ x → p (q x)) t (x₀ ∷ xs)
    → ¬ Refutes (ProbeLaw q t p) (x₀ ∷ xs)
  probe-ceiling x₀ xs cf ref = ref decode (holds (x₀ ∷ xs) (λ _ m → m))
    where
    decode : Z → T
    decode z = tableZ dZ (λ x → p (q x)) t (t x₀) z (x₀ ∷ xs)

    holds : (ys : List X) → ((x : X) → Mem x ys → Mem x (x₀ ∷ xs))
          → AllHold (ProbeLaw q t p) decode ys
    holds []       _   = tt*
    holds (y ∷ ys) inc =
        tableZ-correct dZ (λ x → p (q x)) t (t x₀) (x₀ ∷ xs) cf y (inc y (inl refl))
      , holds ys (λ z m → inc z (inr m))

  -- the floor is unchanged: a constant decoder answers one point
  probe-singleton-never : (x : X) → ¬ Refutes (ProbeLaw q t p) (x ∷ [])
  probe-singleton-never x ref = ref (λ _ → t x) (refl , tt*)

  probe-empty-never : (x : X) → ¬ Refutes (ProbeLaw q t p) []
  probe-empty-never x ref = ref (λ _ → t x) tt*

  -- and a probed collision is a refuting pair
  probe-collision→refutes :
    {x x' : X} → p (q x) ≡ p (q x') → ¬ (t x ≡ t x')
    → Refutes (ProbeLaw q t p) (x ∷ x' ∷ [])
  probe-collision→refutes same differ g (at-x , at-x' , _) =
    differ (sym at-x ∙ cong g same ∙ at-x')

------------------------------------------------------------------------
-- 3.  AT LAGHAVA: one evaluation point is enough
------------------------------------------------------------------------

probe1 : Denotation → ℕ
probe1 d = d 1

-- probing only removes decoders, so the probed statement is the weaker
-- one and `Laghava`'s theorem implies it
probeFactors→meaningFactors :
  Σ[ g ∈ (ℕ → ℕ) ] ((e : Expr) → ProbeLaw eval size probe1 g e)
  → FactorsThroughMeaning size
probeFactors→meaningFactors (g , law) = (λ d → g (probe1 d)) , law

-- the लाघव pair survives probing: same denotation, hence same value at 1
laghava-probe-collision :
  probe1 (eval (laghava-collision .fst))
  ≡ probe1 (eval (laghava-collision .snd .fst))
laghava-probe-collision = cong probe1 (laghava-collision .snd .snd .fst)

laghava-probe-is-two : WitnessNumberIs (ProbeLaw eval size probe1) 2
laghava-probe-is-two =
    ( laghava-collision .fst ∷ laghava-collision .snd .fst ∷ []
    , refl
    , probe-collision→refutes discreteℕ eval size probe1
        {x = laghava-collision .fst} {x' = laghava-collision .snd .fst}
        laghava-probe-collision
        (laghava-collision .snd .snd .snd) )
  , least
  where
  e₀ : Expr
  e₀ = laghava-collision .fst

  least : (ys : List Expr) → length ys < 2 → ¬ Refutes (ProbeLaw eval size probe1) ys
  least []           _  = probe-empty-never discreteℕ eval size probe1 e₀
  least (a ∷ [])     _  = probe-singleton-never discreteℕ eval size probe1 a
  least (a ∷ b ∷ ys) lt = Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred lt)))

------------------------------------------------------------------------
-- 4.  What this settles.
--
-- SETTLED.  The ceiling was never about discreteness of the
-- OBSERVATIONS.  It is about the decoders having something discrete to
-- read.  Give them any probe into a discrete type — at `Laghava`, a
-- single evaluation point — and the ceiling returns in full: over the
-- probed decoders every absence there costs 2, with the लाघव pair still
-- doing the work.
--
-- That reframes the whole `WhyTheSitesAreTwo` / `LocatingIsEnough` line.
-- `Discrete Y` was the crudest sufficient condition; `Locates` narrowed
-- it to the witnesses; this drops it from Y entirely and puts it where
-- it belongs, on what the decoder is allowed to see.
--
-- Over the FULL space `Denotation → ℕ`: a decoder
-- there must recognise an arbitrary `d : ℕ → ℕ` as a listed denotation,
-- which is a decision of function equality.
------------------------------------------------------------------------
