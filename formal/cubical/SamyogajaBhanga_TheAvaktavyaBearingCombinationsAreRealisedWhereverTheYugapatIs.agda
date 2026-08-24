{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Saṃyogaja-bhaṅga — the combination-born predications are realised
-- wherever the yugapat content is, and avaktavya dominates them.
--
-- SOURCE OF THE OBJECT.  Akalaṅka (Laghīyastraya / Aṣṭaśatī, c. 720–780
-- CE) distinguishes the three MŪLA (primary) predicates — asti, nāsti,
-- avaktavya — from the SAṂYOGA (combinations) built out of them.  Of the
-- seven bhaṅgas, three are mūla-only (b1 asti, b2 nāsti, b4 avaktavya) and
-- four are saṃyogaja: b3 (asti·nāsti), b5 (asti·avaktavya), b6
-- (nāsti·avaktavya), b7 (asti·nāsti·avaktavya).  The three that carry
-- avaktavya are b5, b6, b7.  The bhaṅga names and the 3+3+1 count are
-- Akalaṅka's; the theorem below about their REALISATION is not his and is
-- not claimed to be — it is an observation in the profile semantics that
-- `SaptabhangiNaya` sets up.
--
-- WHAT THIS CLOSES.  `SaptabhangiNaya` §8.3 records, of b5 and b7:
--   "DEFINABLE (they are in saptabhangi-iso) but no instance of either is
--    constructed here, and none was found in the machine's data.  They
--    would need a claim simultaneously affirmed, denied, and inexpressible.
--    Their emptiness in the data is reported there as a measured fact and
--    is not evidence that they are incoherent."
-- Two DIFFERENT objects are in that sentence and this file touches exactly
-- one.  The "machine's data" is `machine/machine.log`, an empirical,
-- gitignored, regenerated file; whether b5/b7 occur THERE is a measurement
-- and this file says nothing about it.  The PROFILE SEMANTICS —
-- `Profile`, `joint`, `denotes` — is a definitional object, and there the
-- instances are not merely constructible, they are FORCED: wherever the
-- avaktavya (yugapat, b4) content is realised, asti and nāsti are realised
-- too, so the same profile realises b5, b6 and b7.  b4 dominates its own
-- avaktavya-bearing combinations.
--
-- The engine of the domination is `SaptabhangiNaya`'s own `joint`, here
-- split by `and-split`: `joint φ = φ rewriter ∧ ¬ (φ kernel-refl)`, and a
-- conjunction is true only when both conjuncts are — which is exactly
-- `φ` affirming at rewriter (asti) and denying at kernel-refl (nāsti).
--
-- Uses only SaptabhangiNaya's own terms; nothing named is invented.
-- Checked warm through नाडी against the container's agda — छिद्रं नास्ति.
------------------------------------------------------------------------

module SamyogajaBhanga_TheAvaktavyaBearingCombinationsAreRealisedWhereverTheYugapatIs where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_
                                    ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using ()

open import SaptabhangiNaya
  using ( Naya ; rewriter ; kernel-refl
        ; Profile ; mk ; machine-profile
        ; Vacana ; asti-from ; nasti-from ; denotes
        ; joint )

------------------------------------------------------------------------
-- §1  REALISATION of the primaries at a profile
--
-- A profile realises `asti` when some standpoint affirms, `nāsti` when
-- some standpoint denies, and `avaktavya` when the joint (yugapat) content
-- is true.  These are the profile-level readings of the three mūla
-- predicates — the same denotations SaptabhangiNaya's `denotes`/`joint`
-- already carry, packaged as realisation conditions.
------------------------------------------------------------------------

Asti-at : Profile → Type₀
Asti-at φ = Σ[ n ∈ Naya ] (denotes (asti-from n) φ ≡ true)

Nasti-at : Profile → Type₀
Nasti-at φ = Σ[ n ∈ Naya ] (denotes (nasti-from n) φ ≡ true)

Avaktavya-at : Profile → Type₀
Avaktavya-at φ = joint φ ≡ true

------------------------------------------------------------------------
-- §2  The conjunction split — the whole mechanism in one lemma
--
-- `a ∧ b ≡ true` forces `a ≡ true` and `b ≡ true`.  Exhaustive on the two
-- bits; the two false branches are `and`'s definitional `false`.
------------------------------------------------------------------------

and-split : (a b : Bool) → (a and b) ≡ true → (a ≡ true) × (b ≡ true)
and-split true  true  _ = refl , refl
and-split true  false h = ⊥.rec (false≢true h)
and-split false _     h = ⊥.rec (false≢true h)

------------------------------------------------------------------------
-- §3  AVAKTAVYA DOMINATES.  For EVERY profile, realising the yugapat
-- content realises asti (at rewriter) and nāsti (at kernel-refl).  So the
-- avaktavya-bearing combinations are not independent existence problems:
-- b4's realiser is already a b5, b6 and b7 realiser.
--
-- `denotes (asti-from rewriter) φ = φ rewriter`     (asti at rewriter)
-- `denotes (nasti-from kernel-refl) φ = ¬ (φ kernel-refl)` (nāsti at refl)
-- and `joint φ = φ rewriter ∧ ¬ (φ kernel-refl)`, so `and-split` hands
-- back exactly these two.
------------------------------------------------------------------------

avaktavya→asti : (φ : Profile) → Avaktavya-at φ → Asti-at φ
avaktavya→asti φ h = rewriter , fst (and-split (φ rewriter) (not (φ kernel-refl)) h)

avaktavya→nasti : (φ : Profile) → Avaktavya-at φ → Nasti-at φ
avaktavya→nasti φ h = kernel-refl , snd (and-split (φ rewriter) (not (φ kernel-refl)) h)

------------------------------------------------------------------------
-- §4  THE COMBINATION-BORN PREDICATIONS, realised.
--
-- b5 = asti ∧ avaktavya ; b6 = nāsti ∧ avaktavya ; b7 = asti ∧ nāsti ∧
-- avaktavya.  Each is the conjunction of its constituent realisations.
------------------------------------------------------------------------

B5-at : Profile → Type₀              -- asti · avaktavya
B5-at φ = Asti-at φ × Avaktavya-at φ

B6-at : Profile → Type₀              -- nāsti · avaktavya
B6-at φ = Nasti-at φ × Avaktavya-at φ

B7-at : Profile → Type₀              -- asti · nāsti · avaktavya
B7-at φ = Asti-at φ × Nasti-at φ × Avaktavya-at φ

-- Each avaktavya realiser is already a b5, b6 and b7 realiser — the
-- domination, packaged at the level of the compound bhaṅgas.
avaktavya→b5 : (φ : Profile) → Avaktavya-at φ → B5-at φ
avaktavya→b5 φ h = avaktavya→asti φ h , h

avaktavya→b6 : (φ : Profile) → Avaktavya-at φ → B6-at φ
avaktavya→b6 φ h = avaktavya→nasti φ h , h

avaktavya→b7 : (φ : Profile) → Avaktavya-at φ → B7-at φ
avaktavya→b7 φ h = avaktavya→asti φ h , avaktavya→nasti φ h , h

------------------------------------------------------------------------
-- §5  THE WITNESSES §8.3 SAID WERE NOT CONSTRUCTED.
--
-- `machine-profile = mk true false true` — the profile the log carries,
-- affirmed by the rewriter, denied by kernel-refl.  Its `joint` is `true`
-- (`true ∧ ¬ false = true`), so it realises avaktavya, and by §3 it
-- realises b5, b6 and b7.  Concrete inhabitants, not existence claims.
------------------------------------------------------------------------

machine-avaktavya : Avaktavya-at machine-profile
machine-avaktavya = refl

b5-witness : B5-at machine-profile
b5-witness = avaktavya→b5 machine-profile machine-avaktavya

b6-witness : B6-at machine-profile
b6-witness = avaktavya→b6 machine-profile machine-avaktavya

b7-witness : B7-at machine-profile
b7-witness = avaktavya→b7 machine-profile machine-avaktavya
