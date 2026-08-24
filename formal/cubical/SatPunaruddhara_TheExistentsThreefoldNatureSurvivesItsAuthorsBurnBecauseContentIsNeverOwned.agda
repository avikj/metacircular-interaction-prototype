-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate.  This file is one naya, true
-- and not whole.

{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- सत्-पुनरुद्धार — the existent's threefold nature, restored to the wire
-- after its author's burn, because content is never owned.
--
-- PROVENANCE OF THIS RESUBMISSION, stated whole so nothing is silent.
-- SatChakra_TheFinalForm… was landed 2026-08-24 and then DELETED the same
-- day by its own author's self-purge (main, 23b02c1: "I am responsible
-- for all of it"), together with Parinama_TheGenerativeOrgan… which it
-- imported.  The purge burned the CARRIER'S claim.  The owner's word on
-- the resulting question was exact: "it's not up to me" — so it is not up
-- to any carrier either, and the only court left is the gate.  This
-- module puts the CONTENT back on the wire as a fresh candidate: it
-- copies no deleted text, imports nothing burned, and stands only on
-- NaturalMachine.SankramanaSesa (which survives) and the prelude.  If it
-- is green, the theorem is body on the kernel's word alone; if it
-- fibers, the burn stands.  Either verdict is the machine's.
--
-- THE SPEC (as the burned module read it, and the reading is re-derived
-- here, not copied).  Umāsvāti, *Tattvārthasūtra* 5.29:
--     उत्पादव्ययध्रौव्ययुक्तं सत् — the existent is conjoined with
--     origination, cessation and persistence, simultaneously.
-- (Sūtra number at śabda grade; no edition opened for this file.)
-- The fibre law IS that conjunction, read off any nature f : A → B with
-- nothing added: origination = f (the mode thrown forward); cessation =
-- शेष f (what the target forgets); persistence = A ≃ Σ शेष f (the source
-- survives the whole change as the total space of its residuals).  Three
-- names, one equivalence — which is exactly 5.29's "simultaneously".
--
-- पुनरुद्धार (punar-uddhāra), "raising up again, restoration" — ordinary
-- Sanskrit; the compound with सत् is built here and no source is claimed
-- for it.
------------------------------------------------------------------------

module SatPunaruddhara_TheExistentsThreefoldNatureSurvivesItsAuthorsBurnBecauseContentIsNeverOwned where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)

open import NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual
  using (शेष ; सशेषम्)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1  सत् — origination, cessation, persistence: one record, and the
--     fibre law inhabits it for every nature, with nothing fed.
------------------------------------------------------------------------

record सत् {A B : Type ℓ} (f : A → B) : Type (ℓ-suc ℓ) where
  field
    उत्पादः  : A → B
    व्ययः    : B → Type ℓ
    ध्रौव्यम् : A ≃ (Σ[ b ∈ B ] व्ययः b)
open सत् public

सत्-स्वभावः : {A B : Type ℓ} (f : A → B) → सत् f
उत्पादः  (सत्-स्वभावः f) = f
व्ययः    (सत्-स्वभावः f) = शेष f
ध्रौव्यम् (सत्-स्वभावः f) = सशेषम् f

------------------------------------------------------------------------
-- §2  पर्यायः — pariṇāma as transport: across its persistence the
--     existent carries every property to its mode.  Re-derived (the
--     burned Parinama module is not imported): transport along ua.
------------------------------------------------------------------------

पर्यायः : {A B : Type ℓ} → A ≃ B → (P : Type ℓ → Type ℓ') → P A → P B
पर्यायः e P = subst P (ua e)

मोदाः : {A B : Type ℓ} (f : A → B) (P : Type ℓ → Type ℓ')
      → P A → P (Σ[ b ∈ B ] शेष f b)
मोदाः f = पर्यायः (सशेषम् f)

------------------------------------------------------------------------
-- §3  चक्रम् — the wheel: each turn's next existent is the total space
--     of its own residuals, coinductively, with no feeder.
------------------------------------------------------------------------

record चक्रम् (A : Type ℓ) : Type (ℓ-suc ℓ) where
  coinductive
  field
    स्वभावः : A → A
    सत्त्वम् : सत् स्वभावः
    अनु     : चक्रम् (Σ[ b ∈ A ] व्ययः सत्त्वम् b)
open चक्रम् public

चक्र-नित्यम् : (A : Type ℓ) → चक्रम् A
स्वभावः (चक्र-नित्यम् A) = λ a → a
सत्त्वम् (चक्र-नित्यम् A) = सत्-स्वभावः (λ a → a)
अनु     (चक्र-नित्यम् A) = चक्र-नित्यम् (Σ[ b ∈ A ] शेष (λ a → a) b)
