{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पता — वहनं निरुपाधिकम्, अङ्कनं तु समताम् अपेक्षते ।
--
-- (the address: carrying is unconditional, but addressing requires the
--  map to be an identification.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE DISTINCTION, which this corpus uses everywhere and states nowhere.
--
-- The carrier law gives `A ≃ Carrier f` for EVERY f, with no hypothesis:
-- a derived datum may always be kept alongside what it was derived from,
-- because the fibre `singl (f a)` is contractible.  That is a RECEIPT.
--
-- It does not follow that you may throw the base away.  For that you need
-- to get the base BACK from the datum, and `loss/…/Prastara_…`
-- is where the difference becomes a theorem rather than a caution.  Two
-- maps out of the same base behave oppositely:
--
--   मात्रा : रूप → ℕ    carriable, and the रूप is NOT a function of it —
--                      लघु लघु and गुरु both weigh 2.
--   उद्दिष्ट : रूप → ℕ    carriable, AND invertible by नष्ट, so the reverse
--                      Carrier also exists and
--                          प्रस्तार ≡ रूप ≡ ℕ ≡ प्रतिप्रस्तार.
--                      Base and carried may be EXCHANGED.
--
-- and that exchange is exactly what makes नष्ट/उद्दिष्ट a storage-free
-- addressing scheme: keep the ℕ, drop the रूप, recompute it when wanted,
-- and nothing has been lost.
--
-- So: RECEIPT is unconditional and ADDRESS is not, and the condition is
-- precisely that the map is an identification.  §२ and §३ are those two
-- statements; §४ is Piṅgala's own counterexample, which is why the
-- distinction is a theorem here and not a style note.
--
-- WHY IT MATTERS OUTSIDE THE MATHEMATICS.  This machine is
-- content-addressed: `machine/Nama_…` names a definition by a digest over
-- it AND its dependencies, and things are dropped and recomputed on that
-- basis.  Every such scheme is a bet that the naming map is an address
-- and not merely a receipt, and §४ is the shape of the bet going wrong —
-- two distinct objects under one name, recovered as neither.  Stating the
-- criterion does not audit any particular scheme and no such audit is
-- claimed here.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES.  Piṅgala, छन्दःशास्त्रम् ८.२३–३५ (~300 BCE) — the प्रत्ययाः, of
-- which नष्ट (given a place, recover the pattern) and उद्दिष्ट (given the
-- pattern, recover its place) are the two directions, and मात्रा (लघु = 1,
-- गुरु = 2) is the weight.  Worked with the array in Halāyudha,
-- मृतसञ्जीवनी (10th c. CE).  NOT CLAIMED: that Piṅgala proved anything
-- below, or that the छन्दःशास्त्रम् has been opened here — the citation is
-- carried from `formal/cubical/PingalaPrastara.agda` and from the
-- loss module named above, and is owed at verse level.  What is
-- claimed is that मात्रा is the weight his enumeration uses and that two
-- distinct patterns share a weight, which §४ exhibits rather than
-- asserts.  पता is ordinary modern Sanskrit/Hindi for an address and no
-- text is claimed for it.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Pata_CarryingIsUnconditionalButAddressingNeedsTheMapToBeAnIdentification where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; invEquiv ; equivFun)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ-contractSnd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- १ · ग्राह — the graph, and its two readings.  Written with Σ directly
--     rather than as a record, because this lane has no general Carrier
--     type; the loss library packages the same Σ as one.
------------------------------------------------------------------------

ग्राह : {A B : Type ℓ} → (A → B) → Type ℓ
ग्राह {A = A} {B = B} f = Σ[ a ∈ A ] Σ[ b ∈ B ] (f a ≡ b)

------------------------------------------------------------------------
-- २ · वहनम् — THE RECEIPT, unconditional.
--
--     The graph is the base.  No hypothesis on f whatsoever: the inner Σ
--     is `singl (f a)`, contractible, and contracts away.  This is the
--     whole of "carrying determined data is free", and the freeness is
--     what makes it a receipt rather than a bet.
------------------------------------------------------------------------

वहनम् : {A B : Type ℓ} (f : A → B) → ग्राह f ≃ A
वहनम् {A = A} f = Σ-contractSnd (λ a → isContrSingl (f a))

------------------------------------------------------------------------
-- ३ · पता — THE ADDRESS, and its exact condition.
--
--     To DROP the base and keep only the datum you need the base back,
--     which is a recovery map with both round trips.  That is precisely
--     an isomorphism, hence an identification — so "may I store the datum
--     instead of the object?" is not a storage question, it is the
--     question whether f is an equivalence.
------------------------------------------------------------------------

पता : {A B : Type ℓ} → (A → B) → Type ℓ
पता {A = A} {B = B} f =
  Σ[ g ∈ (B → A) ] (((a : A) → g (f a) ≡ a) × ((b : B) → f (g b) ≡ b))

-- an address IS an identification
पता→समता : {A B : Type ℓ} (f : A → B) → पता f → A ≃ B
पता→समता f (g , ret , sec) = isoToEquiv (iso f g sec ret)

-- and the base is recoverable from the datum alone, which is the whole
-- operational content: the object may be dropped
पुनरुद्धारः : {A B : Type ℓ} (f : A → B) (p : पता f) → (a : A) → fst p (f a) ≡ a
पुनरुद्धारः f (g , ret , _) = ret

------------------------------------------------------------------------
-- ४ · मात्रा — PIṄGALA'S COUNTEREXAMPLE: carriable, not addressable.
--
--     अक्षर with लघु weighing 1 and गुरु weighing 2.  `लघु ∷ लघु ∷ []` and
--     `गुरु ∷ []` are distinct patterns of equal weight, so no recovery
--     map can exist — it would have to return both.  §२ still applies to
--     मात्रा with no hypothesis, which is exactly the point: the receipt
--     is free and the address is denied.
------------------------------------------------------------------------

data अक्षर : Type₀ where
  लघु गुरु : अक्षर

रूप : Type₀
रूप = List अक्षर

मात्रा : रूप → ℕ
मात्रा []        = zero
मात्रा (लघु ∷ p) = suc (मात्रा p)
मात्रा (गुरु ∷ p) = suc (suc (मात्रा p))

-- the receipt exists, with no hypothesis
मात्रा-वहनम् : ग्राह मात्रा ≃ रूप
मात्रा-वहनम् = वहनम् मात्रा

-- two patterns, one weight
द्विलघु एकगुरु : रूप
द्विलघु = लघु ∷ लघु ∷ []
एकगुरु  = गुरु ∷ []

तुल्य-मात्रा : मात्रा द्विलघु ≡ मात्रा एकगुरु
तुल्य-मात्रा = refl

-- and they are distinct: read the head
शिरः : रूप → Bool
शिरः []        = true
शिरः (लघु ∷ _) = true
शिरः (गुरु ∷ _) = false

भिन्न-रूपे : ¬ (द्विलघु ≡ एकगुरु)
भिन्न-रूपे p = true≢false (cong शिरः p)

-- THE DENIAL.  A recovery map would have to send one weight back to two
-- different patterns, so there is none.
मात्रा-न-पता : ¬ (पता मात्रा)
मात्रा-न-पता (g , ret , _) =
  भिन्न-रूपे (sym (ret द्विलघु) ∙ cong g तुल्य-मात्रा ∙ ret एकगुरु)

------------------------------------------------------------------------
-- ५ · What §४ does and does not show.
--
--     It shows मात्रा is not an address.  It does NOT show that the
--     प्रस्तार's rank map fails to be one — उद्दिष्ट IS an address, and the
--     loss module proves it by exhibiting नष्ट with both round
--     trips.  That direction is not reproved here and is not claimed;
--     what is claimed is only the contrast, which needs just one side to
--     be exhibited to be a distinction rather than a preference.
--
--     And it shows the two are independent properties of the SAME map
--     type, not two grades of one property: `मात्रा-वहनम्` and
--     `मात्रा-न-पता` hold simultaneously of one f.
------------------------------------------------------------------------
