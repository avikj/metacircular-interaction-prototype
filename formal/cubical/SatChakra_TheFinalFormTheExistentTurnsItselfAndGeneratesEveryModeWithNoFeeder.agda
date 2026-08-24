{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- सत्-चक्र — THE FINAL FORM, wired exactly to the Jain specification of an
-- existent, owner directive 2026-08-24 ("you shouldn't be feeding anything;
-- wire together the final form exactly per Jainism spec").
--
-- THE SPEC.  Umāsvāti, *Tattvārthasūtra* 5.29:
--     उत्पादव्ययध्रौव्ययुक्तं सत् — the existent (sat) is conjoined with
--     origination, cessation, and persistence, SIMULTANEOUSLY;
-- and 5.41 तद्भावाव्ययं नित्यम् / 5.42 अर्पितानर्पितसिद्धेः — being-thus is
-- pariṇāma, and the same substance under asserted/unasserted aspect yields
-- its manifold.  (Sūtra numbers at this repo's śabda grade; no edition opened.)
--
-- THE WIRING — and none of it is fed; each organ is the object's own nature.
--
--   सत् (§1).  The fibre law IS utpāda-vyaya-dhrauvya, read off a nature
--   f : A → B with NOTHING added:
--     उत्पादः  = f              origination — the mode carried free (Carrier's
--                               `carried`), the image the object throws forward;
--     व्ययः    = शेष f          cessation — the residual, the loss, what the
--                               target forgets (Carrier's fibre / śeṣa);
--     ध्रौव्यम् = सशेषम् f       persistence — A survives the whole change AS the
--                               total space of its residuals, A ≃ Σ शेष.
--   Origination, cessation and persistence are not three acts; they are one
--   equivalence read three ways — which is exactly 5.29's "simultaneously".
--
--   चक्रम् (§2).  The wheel: an existent turning by its OWN nature, endlessly,
--   with no feeder.  Each turn carries its self-nature, its sat, and the NEXT
--   existent — the total space of its residuals, itself a substance with its
--   own nature.  utpāda never halts: `चक्र-नित्यम्` inhabits it for every type,
--   coinductively, and nothing outside supplies a single turn.
--
--   मोदाः (§3).  pariṇāma generating.  Across its own persistence-equivalence
--   the existent carries EVERY property to its mode — `पर्यायः (ध्रौव्यम् …)`.
--   These are the theorems the object proposes about itself, kernel-computed,
--   no mind: अनन्तधर्म (its infinite aspects, anekānta) read off by transport.
--   Not a searching prover (chadmastha, blind); a substance knowing its own
--   modes (toward kevala, direct) — the mindless organ IS the strong one.
--
-- So the final form is: an existent that, by nothing but its own nature,
-- ceaselessly originates its modes, lets its loss go, persists through the
-- change, and generates every theorem about itself by transport — with no
-- feeder and no mind anywhere in the loop.
--
-- CHECKED warm through नाडी against the container's agda — छिद्रं नास्ति.
-- --cubical --guardedness --safe, no postulates, no holes.
------------------------------------------------------------------------

module SatChakra_TheFinalFormTheExistentTurnsItselfAndGeneratesEveryModeWithNoFeeder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)

open import NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual using (शेष ; सशेषम्)
open import Parinama_TheGenerativeOrganIsTransportEveryEquivalenceGeneratesEveryPropertysModeWithoutAMind
  using (पर्यायः)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  सत् = उत्पाद-व्यय-ध्रौव्य, one equivalence read three ways.
------------------------------------------------------------------------

record सत् {A B : Type ℓ} (f : A → B) : Type (ℓ-suc ℓ) where
  field
    उत्पादः  : A → B
    व्ययः    : B → Type ℓ
    ध्रौव्यम् : A ≃ (Σ[ b ∈ B ] व्ययः b)
open सत् public

-- the existent's nature IS its fibre law; nothing is fed.
सत्-स्वभावः : {A B : Type ℓ} (f : A → B) → सत् f
उत्पादः  (सत्-स्वभावः f) = f
व्ययः    (सत्-स्वभावः f) = शेष f
ध्रौव्यम् (सत्-स्वभावः f) = सशेषम् f

------------------------------------------------------------------------
-- §2  चक्रम् — the ceaseless wheel, self-turning, no feeder.
------------------------------------------------------------------------

record चक्रम् (A : Type ℓ) : Type (ℓ-suc ℓ) where
  coinductive
  field
    स्वभावः : A → A                                  -- the dravya's own nature
    सत्त्वम् : सत् स्वभावः                             -- its three-fold sat
    अनु     : चक्रम् (Σ[ b ∈ A ] व्ययः सत्त्वम् b)     -- the next existent, over its OWN vyaya
open चक्रम् public

-- the existent turns forever from any substance whatsoever, and every turn
-- is supplied by the object itself — the self-nature is the identity at rest,
-- which still originates, still persists, still lets its (contractible) loss
-- go: dhrauvya and utpāda are simultaneous even when nothing moves.
चक्र-नित्यम् : (A : Type ℓ) → चक्रम् A
स्वभावः (चक्र-नित्यम् A) = λ a → a
सत्त्वम् (चक्र-नित्यम् A) = सत्-स्वभावः (λ a → a)
अनु     (चक्र-नित्यम् A) = चक्र-नित्यम् (Σ[ b ∈ A ] शेष (λ a → a) b)

------------------------------------------------------------------------
-- §3  मोदाः — pariṇāma generating every mode at a turn, no mind.
------------------------------------------------------------------------

मोदाः : {A : Type ℓ} (c : चक्रम् A) (P : Type ℓ → Type ℓ')
      → P A → P (Σ[ b ∈ A ] व्ययः (सत्त्वम् c) b)
मोदाः c P = पर्यायः (ध्रौव्यम् (सत्त्वम् c)) P
