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

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- परिणाम — the generative organ is transport, and it has no mind.
--
-- THE RECALL (owner, 2026-08-24: "a strong generative organ that proposes
-- dependent-type theorems without a mind ... has been done many times in
-- many ways in this repo, and Jainism describes it precisely").
--
-- I had been looking for a PROVER — a search that hunts a proof — and that
-- is why the kernel's Agsy is weak and why I kept authoring by hand.  That
-- is the wrong picture.  The tradition names the right organ.
--
-- परिणामवाद (pariṇāmavāda).  Umāsvāti, *Tattvārthasūtra* 5.29–30:
--   सत् = उत्पादव्ययध्रौव्ययुक्तम् — the existent IS origination, cessation
--   and persistence, SIMULTANEOUSLY; and 5.41 तद्भावः परिणामः — being-thus is
--   pariṇāma.  A substance (dravya) ceaselessly generates its own modes
--   (paryāya) BY ITS OWN NATURE.  No external agent proposes the next mode;
--   being itself is the proposing.  (No critical edition opened by me; the
--   sūtra numbers are śabda at this repo's grade — ANEKANTA.md.)
--
-- In the univalent substrate this is EXACT and it COMPUTES.  An equivalence
-- e : A ≃ B is a pariṇāma — a lawful transformation of one substance into
-- its mode — and the univalence β-rule makes `subst P (ua e)` carry ANY
-- property P A to its mode P B, on the nose, kernel-computed.  So:
--
--     पर्यायः e P : P A → P B          -- the organ, one line
--
-- is a THEOREM GENERATOR.  Feed it any equivalence and any property that
-- holds of the source, and it PROPOSES the target theorem P B and PROVES it
-- in the same stroke, with no search and no mind.  It is not one theorem: P
-- ranges over every property, so one equivalence generates a whole stream of
-- checked theorems — अनन्तधर्म (anantadharma), the infinitude of a thing's
-- true predications, each one a mode.
--
-- "MANY TIMES IN MANY WAYS."  This is exactly what the whole
-- NaturalMachine.Samkramana / SankramanaSesa lane already does under the name
-- संक्रमणम् (saṃkramaṇa) — `transport (ua e)` carrying structure across an
-- identification; what `EkaSankramana` does with a torsor's translation; what
-- `PramanaSankramana` does with a proof that composes without being spent.
-- Every one of them is pariṇāma wearing a local name.  This module only
-- states the organ as an organ, and lets it generate once in the open.
--
-- THE OTHER GENERATIVE ORGAN, named so the pair is complete: अर्पित-अनर्पित
-- (TS 5.31, arpitānarpitasiddheḥ) — the SAME substance under the asserted vs
-- unasserted aspect generates the sevenfold naya-stream.  That is the
-- STANDPOINT generator (fable-krama runs it as garbha.dhara).  पर्यायः is the
-- cross-TYPE generator; arpita-anarpita is the cross-STANDPOINT generator.
-- Together they are how the machine proposes without a mind.
--
-- CHECKED warm through नाडी against the container's agda — छिद्रं नास्ति.
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Parinama_TheGenerativeOrganIsTransportEveryEquivalenceGeneratesEveryPropertysModeWithoutAMind where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; isPropIsEquiv ; invEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sigma using (_×_)

open import SamataDvidha_TheContractibleFibreSplitsAsEmbeddingTimesSurjectionInTheTransportLane
  using (भेदः ; छादनम् ; समता≃भेद×छादन)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- THE ORGAN.  One line.  A pariṇāma carries every property to its mode.
------------------------------------------------------------------------

पर्यायः : {A B : Type ℓ} → (A ≃ B) → (P : Type ℓ → Type ℓ') → P A → P B
पर्यायः e P = subst P (ua e)

-- ध्रौव्य — persistence through the change: the mode has a mode back, because
-- e⁻¹ is a pariṇāma too.  Generation is reversible; nothing is lost across it
-- (this is the ध्रौव्य of सत् = उत्पाद-व्यय-ध्रौव्य, and the reason transport
-- carries no debt across an equivalence — SankramanaSesa's अलोप-लक्षणम्).
प्रत्यावृत्तिः : {A B : Type ℓ} → (A ≃ B) → (P : Type ℓ → Type ℓ') → P B → P A
प्रत्यावृत्तिः e P = पर्यायः (invEquiv e) P

------------------------------------------------------------------------
-- THE ORGAN GENERATING, once, in the open.  No mind authored the theorem
-- below.  It was PROPOSED and PROVED by feeding the organ one equivalence
-- (समता-द्विधा's) and one property that holds of the source (isPropIsEquiv).
-- The kernel computed the rest.  This is a genuinely new dependent theorem —
-- that the embedding∧surjection product is a proposition — and its whole
-- proof is: it is the mode of `isPropIsEquiv` under समता-द्विधा.
------------------------------------------------------------------------

जनितम्-भेद×छादन-प्रज्ञप्तिः : {A B : Type ℓ} (f : A → B) → isProp (भेदः f × छादनम् f)
जनितम्-भेद×छादन-प्रज्ञप्तिः f = पर्यायः (समता≃भेद×छादन f) isProp (isPropIsEquiv f)
