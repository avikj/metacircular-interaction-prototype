{-# OPTIONS --safe --cubical #-}

------------------------------------------------------------------------
-- MorphogeneticAgency — the formal spine of goal-directed agency, over
-- an ARBITRARY state space, ARBITRARY dynamics, and ARBITRARY observable.
-- No finiteness, no decidability, no chosen carrier: the criteria hold
-- for every S, Φ, o at once.  This is the general theorem the
-- Levin-bridge document names; the corpus's own modules are its
-- instances (cited per theorem).
--
-- READING (each Agda statement is proven; each biological reading is a
-- modelling correspondence — the theorem supplies the skeleton):
--
--   S            a state space (configurations of a cell / tissue / collective)
--   Φ : S → S    the dynamics (a developmental / regenerative step)
--   o : S → V    an observable at some scale (what an agent/scope resolves)
--   f : S → W    a conserved observable = a target morphology / setpoint
--
-- THE THEOREMS.
--   conservedAlongOrbit   the setpoint is invariant along the WHOLE
--                         trajectory, not merely step to step
--                         (generalises Kaksya.ध्रुवं-कक्ष्यायाम्).
--   lawImpliesCongruence  an observer that has a deterministic law over
--                         its own readings is a congruence for the
--                         dynamics (generalises Anuvrtti.भाव्य-अनुकूलम्).
--   carriesForward        and then its entire future is fixed by its
--                         present reading, forever
--                         (generalises Anuvrtti.अनुवृत्तिः).
--   oneBlindPairRefutesAllLaws
--                         one blind pair whose futures diverge refutes
--                         EVERY predictor at once — the hard boundary of
--                         a cognitive light cone
--                         (generalises Anuvrtti.अभाव्यम्).
--   reachPreservesObservable / basinShareObservable
--                         regeneration is reachability under a shared
--                         invariant: states in one basin share the
--                         setpoint (soundness direction, general; the
--                         full iff for a concrete rule is
--                         walks.DerivationReachabilityIsValueEquality).
--   perfectAgent≡losesNothing×missesNothing
--                         a perfect agent (equivalence) is exactly one
--                         that loses nothing AND misses nothing
--                         (generalises Kevalajnana.केवलम्); one
--                         non-whole fibre breaks it (durnaya).
--
-- THE UNITY.  Every notion here is read off ONE object — the fibre of
-- the observable.  Conservation keeps the orbit inside one fibre;
-- competency is compatibility of the fibre-partition with Φ; blindness
-- is a crowded fibre; perfection is every fibre contractible.  "Never
-- discard the fibre" is the single principle, and these are its faces.
------------------------------------------------------------------------

module MorphogeneticAgency_CongruenceIsLawConservationIsTheSetpointAlongTheWholeOrbitAndReachabilityInABasinIsRegeneration where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv)
open import Cubical.Foundations.Equiv.Base using (fiber)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open isEquiv

private
  variable
    ℓ ℓ' ℓ'' : Level

  -- local, to avoid import-path hunting across container/pin
  contr→prop : {A : Type ℓ} → isContr A → isProp A
  contr→prop (c , h) x y = sym (h x) ∙ h y

------------------------------------------------------------------------
-- The dynamics and the orbit.
------------------------------------------------------------------------

module _ {S : Type ℓ} (Φ : S → S) where

  orbit : ℕ → S → S
  orbit zero    s = s
  orbit (suc n) s = Φ (orbit n s)

  -- reachability: t is a future of s
  Reaches : S → S → Type ℓ
  Reaches s t = Σ[ n ∈ ℕ ] (orbit n s ≡ t)

  -- two states lie in one basin: their orbits meet
  Basin : S → S → Type ℓ
  Basin s t = Σ[ m ∈ ℕ ] Σ[ n ∈ ℕ ] (orbit m s ≡ orbit n t)

  ----------------------------------------------------------------------
  -- 1.  CONSERVATION IS THE SETPOINT ALONG THE WHOLE ORBIT.
  ----------------------------------------------------------------------

  module Conserved {W : Type ℓ'} (f : S → W) (cons : (s : S) → f (Φ s) ≡ f s) where

    conservedAlongOrbit : (n : ℕ) (s : S) → f (orbit n s) ≡ f s
    conservedAlongOrbit zero    s = refl
    conservedAlongOrbit (suc n) s = cons (orbit n s) ∙ conservedAlongOrbit n s

    -- REGENERATION (soundness): if t is a future of s, they share the setpoint.
    reachPreservesObservable : {s t : S} → Reaches s t → f s ≡ f t
    reachPreservesObservable {s} (n , p) = sym (conservedAlongOrbit n s) ∙ cong f p

    -- and two states in one basin share the setpoint — the regenerative
    -- equivalence class is level for the target morphology.
    basinShareObservable : {s t : S} → Basin s t → f s ≡ f t
    basinShareObservable {s} {t} (m , n , p) =
      sym (conservedAlongOrbit m s) ∙ cong f p ∙ conservedAlongOrbit n t

  ----------------------------------------------------------------------
  -- 2.  COMPETENCY-AT-A-SCALE IS A CONGRUENCE, AND IT CARRIES FORWARD.
  ----------------------------------------------------------------------

  module Observed {V : Type ℓ'} (o : S → V) where

    -- the observer's class is compatible with the dynamics
    Congruence : Type (ℓ-max ℓ ℓ')
    Congruence = (x y : S) → o x ≡ o y → o (Φ x) ≡ o (Φ y)

    -- the observer has a deterministic law over its own readings
    Law : Type (ℓ-max ℓ ℓ')
    Law = Σ[ g ∈ (V → V) ] ((s : S) → o (Φ s) ≡ g (o s))

    -- "sees a law" ⇒ "is a congruence" — the two cannot come apart
    lawImpliesCongruence : Law → Congruence
    lawImpliesCongruence (g , e) x y ox≡oy =
      e x ∙ cong g ox≡oy ∙ sym (e y)

    -- a congruence carries the present reading forward FOREVER
    carriesForward : Congruence → (x y : S) → o x ≡ o y
                   → (n : ℕ) → o (orbit n x) ≡ o (orbit n y)
    carriesForward _   x y ox≡oy zero    = ox≡oy
    carriesForward cong x y ox≡oy (suc n) =
      cong (orbit n x) (orbit n y) (carriesForward cong x y ox≡oy n)

    -- ONE BLIND PAIR WHOSE FUTURES DIVERGE REFUTES EVERY PREDICTOR.
    oneBlindPairRefutesAllLaws :
      (x y : S) → o x ≡ o y → (o (Φ x) ≡ o (Φ y) → ⊥) → Law → ⊥
    oneBlindPairRefutesAllLaws x y blind diverge law =
      diverge (lawImpliesCongruence law x y blind)

------------------------------------------------------------------------
-- 3.  THE PERFECT AGENT IS EXACTLY "LOSES NOTHING AND MISSES NOTHING".
--     (Independent of any dynamics: a property of the observable alone.)
------------------------------------------------------------------------

module Perfect {S : Type ℓ} {V : Type ℓ'} (o : S → V) where

  LosesNothing : Type (ℓ-max ℓ ℓ')
  LosesNothing = (v : V) → isProp (fiber o v)      -- injective: no fibre crowded

  MissesNothing : Type (ℓ-max ℓ ℓ')
  MissesNothing = (v : V) → fiber o v              -- surjective: no fibre empty

  -- loses nothing AND misses nothing = perfect grasp = equivalence
  perfectFromBoth : LosesNothing → MissesNothing → isEquiv o
  perfectFromBoth ln mn .equiv-proof v =
    mn v , λ w → ln v (mn v) w

  -- and conversely a perfect agent loses nothing and misses nothing
  losesNothingFromPerfect : isEquiv o → LosesNothing
  losesNothingFromPerfect eq v = contr→prop (eq .equiv-proof v)

  missesNothingFromPerfect : isEquiv o → MissesNothing
  missesNothingFromPerfect eq v = fst (eq .equiv-proof v)

  -- DURNAYA: a single non-whole fibre refutes perfection.
  oneCrowdedFibreBreaksPerfection :
    (Σ[ v ∈ V ] (isProp (fiber o v) → ⊥)) → isEquiv o → ⊥
  oneCrowdedFibreBreaksPerfection (v , notprop) eq =
    notprop (losesNothingFromPerfect eq v)
