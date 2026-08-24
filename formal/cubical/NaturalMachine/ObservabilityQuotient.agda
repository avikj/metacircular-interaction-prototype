-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ObservabilityQuotient
--
-- DELTA 19 §19.6: THE SAFE QUOTIENT IS N_obs, NOT ker P.
--
-- Delta 19 calls C19.13 "a strong correction to static
-- sufficient-interface thinking", and it is one — including to work
-- landed in this repository earlier today.  The statement:
--
--     N_obs = ⋂_{n≥0} ker(P Tⁿ)
--
--     • is T-invariant                                        (T19.12)
--     • is the future-observational equivalence               (T19.11)
--     • is a congruence for the dynamics                      (C19.36)
--     • and is STRICTLY FINER than ker P.                     (C19.13)
--
-- The last point is the correction and it is the one that needs a
-- witness rather than a definition, so §3 supplies one: three states,
-- two of them instantaneously indistinguishable, separated at the very
-- next step.  Without that witness the whole section is vacuous
-- bookkeeping; with it, "quotient by what you cannot see now" is
-- *proved* unsound as a compression rule.
--
--
-- WHAT THIS CORRECTS IN THIS REPOSITORY
--
-- `NaturalMachine.SensorNerode` proves that a sensor family sees a pair
-- only through `lcm S`, and that the relation determines the lcm — a
-- minimality result.  That relation is **static**: it quantifies over
-- the sensor family, not over time.  Delta 19's distinction says such a
-- result licenses discarding a distinction only if the walk's dynamics
-- cannot later expose it.  For that lane the two happen to coincide
-- (installing a sensor only ever refines the profile, never coarsens
-- it), but the coincidence is a fact about the walk and **not** about
-- observation in general, and `SensorNerode` does not state it.  Flagged
-- here rather than edited into someone else's module.
--
--
-- WHAT IS CHECKED
--
--   §1  `iterT`, `obsAt`      the observation trajectory.
--       `InstantEq`           `ker P` — indistinguishable NOW.
--       `ForeverEq`           `N_obs` — indistinguishable at every
--                             future step.  T19.11 by definition.
--
--   §2  `forever→instant`     N_obs refines ker P (the easy inclusion).
--       `forever-invariant`   **T19.12 / T19.35 / C19.36**: `ForeverEq`
--                             is preserved by the step, so the safe
--                             quotient is automatically a congruence.
--                             This is what makes it safe; a relation
--                             that the dynamics does not respect cannot
--                             be quotiented by.
--       `forever-refl/sym/trans`
--
--   §3  `Three`, `step`, `see`  **C19.13's witness.**  Three states with
--       `a≈b-now`               `see a ≡ see b` …
--       `a≉b-later`             … and `obsAt 1 a ≢ obsAt 1 b`.
--       `instant↛forever`       Hence `InstantEq` does NOT imply
--                               `ForeverEq`: the inclusion of §2 is
--                               STRICT, and quotienting by instantaneous
--                               observation is unsound.
--
--   §4  `markov-iff-defect0`    **T19.20**, the minimal excursion–return
--                               obstruction, read off `CompressionDefect`:
--                               the one-step compressed operator squares
--                               to the two-step one exactly when the
--                               defect vanishes.  Imported, not reproved.
--
--
-- WHAT IS NOT CLAIMED
--
--  * **The quotient TYPE is not constructed.**  `U/N_obs` as a
--    `SetQuotient`, and the induced dynamics on it, are not built.  What
--    is proved is that `ForeverEq` is an equivalence relation and a
--    congruence — which is exactly the input a quotient construction
--    needs, and is the part with content.  Building the quotient is
--    routine and is left to whoever needs it.
--
--  * **MAXIMALITY was not proved here — it is now, elsewhere.**  This
--    header calls `N_obs` "the maximal safe compression", but §2 checks
--    only that `ForeverEq` refines `InstantEq` and is step-invariant,
--    i.e. that it IS safe.  That every safe relation is contained in it
--    is `ExtremalDescription.greatest-safe` (three lines, by induction on
--    `n`, using exactly the `iterT` bracketing §1 chose).  With it,
--    §3's witness sharpens: `ExtremalDescription.instant-not-invariant`
--    shows `ker P` fails safety at the INVARIANCE clause, not at
--    soundness.  Pointer comment only; nothing here edited.
--
--  * **§19.1–19.5 are absent.**  The path expansion (T19.1), the
--    first-return kernels `F_m`, the renewal equation (T19.3), the
--    generating resolvent `K(z) = (I − F(z))⁻¹` (T19.5) and the
--    Feshbach/Schur complement (T19.6) are NOT here.  T19.3 is a real
--    induction over sector words and T19.5 needs formal power series in
--    a noncommutative ring; both are genuine work rather than missing
--    imports.  `CompressionDefect.compression-defect` is the n = 2 case
--    of the whole family and is all that is checked.
--
--  * **No arithmetic instance.**  §§19.8–19.14 — charge sectors, the
--    parity coarse-graining, the half-line self-energy, the Hecke tree —
--    are the point and none is here.  In particular C19.19 (whether a
--    parity-only observer can be dynamically sufficient) is exactly the
--    kind of statement §3's witness shows must be *proved in a finite
--    model rather than asserted*, and Delta 19 says so itself.
--
--  * **Not novel, and Delta 19 says so first**: S19.14 — "this is
--    classical minimal realization/observability theory in the linear
--    case.  Do not reinvent it."  S19.31 identifies the same skeleton as
--    Mori–Zwanzig.  Nothing here claims otherwise; the contribution is
--    that the core now has the congruence lemma and the strictness
--    witness as terms.
------------------------------------------------------------------------

module NaturalMachine.ObservabilityQuotient where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty as Empty using (⊥)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  The observation trajectory.
------------------------------------------------------------------------

module _ {X : Type ℓ} {Y : Type ℓ'} (T : X → X) (p : X → Y) where

  -- Iterating the step.  This bracketing — push the step in first — is
  -- what makes `obsAt n (T x)` and `obsAt (suc n) x` DEFINITIONALLY
  -- equal, which is the whole of §2's proof.
  iterT : ℕ → X → X
  iterT zero    x = x
  iterT (suc n) x = iterT n (T x)

  obsAt : ℕ → X → Y
  obsAt n x = p (iterT n x)

  -- `ker P`: indistinguishable at this instant.
  InstantEq : X → X → Type ℓ'
  InstantEq x y = p x ≡ p y

  -- `N_obs`: indistinguishable at every future step.  T19.11 holds by
  -- definition once the relation is written this way, which is the point
  -- of writing it this way.
  ForeverEq : X → X → Type ℓ'
  ForeverEq x y = (n : ℕ) → obsAt n x ≡ obsAt n y

  ----------------------------------------------------------------------
  -- 2.  The safe quotient is a congruence.
  ----------------------------------------------------------------------

  forever→instant : {x y : X} → ForeverEq x y → InstantEq x y
  forever→instant h = h zero

  -- T19.12 / T19.35 / C19.36.  The whole proof is that shifting the
  -- trajectory by one step is a re-indexing.
  forever-invariant : {x y : X} → ForeverEq x y → ForeverEq (T x) (T y)
  forever-invariant h n = h (suc n)

  forever-refl : (x : X) → ForeverEq x x
  forever-refl x n = refl

  forever-sym : {x y : X} → ForeverEq x y → ForeverEq y x
  forever-sym h n = sym (h n)

  forever-trans : {x y z : X} → ForeverEq x y → ForeverEq y z → ForeverEq x z
  forever-trans h k n = h n ∙ k n

------------------------------------------------------------------------
-- 3.  C19.13's WITNESS: the inclusion is strict.
--
-- Delta 19: "Instantaneous observation can discard distinctions that
-- later become visible."  Three states suffice, and without this the
-- section would be vacuous.
--
--     see a = see b = false,   see c = true
--     step a = a,  step b = c,  step c = c
--
-- so `a` and `b` look identical now and differ at the very next step.
------------------------------------------------------------------------

data Three : Type₀ where
  a b c : Three

step : Three → Three
step a = a
step b = c
step c = c

see : Three → Bool
see a = false
see b = false
see c = true

-- Indistinguishable now …
a≈b-now : InstantEq step see a b
a≈b-now = refl

-- … and separated at the very next step.
a≉b-later : obsAt step see 1 a ≡ obsAt step see 1 b → ⊥
a≉b-later q = true≢false (sym q)

-- Therefore `InstantEq` does not imply `ForeverEq`.  Quotienting by what
-- you cannot see NOW is unsound; only `N_obs` may be discarded.
instant↛forever :
  ({x y : Three} → InstantEq step see x y → ForeverEq step see x y) → ⊥
instant↛forever f = a≉b-later (f {a} {b} a≈b-now 1)

------------------------------------------------------------------------
-- 4.  T19.20, the minimal excursion–return obstruction.
--
-- Delta 19 §19.11: "No Markovian one-step operator A = P₁ T P₁ can
-- reproduce both one-step and two-step charge-one dynamics unless
-- T₁₂T₂₁ = 0."  In the operator setting that is exactly
-- `CompressionDefect.compression-defect` at t = s = 1, so it is imported
-- rather than reproved — the compressed one-step operator squares to the
-- two-step one precisely when the defect vanishes.
--
-- Stated here as a pointer, because the theorem lives there and
-- duplicating it is the failure this corpus keeps catching itself in.
------------------------------------------------------------------------

open import NaturalMachine.CompressionDefect using (module Observability)
