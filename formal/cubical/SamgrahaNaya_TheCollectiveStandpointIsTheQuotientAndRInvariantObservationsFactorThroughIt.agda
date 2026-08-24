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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सङ्ग्रहनयः — the collective standpoint IS the quotient: an R-invariant
-- observation is exactly a map out of A/R.  The universal property of
-- quotients, read as one of the seven nayas.
--
-- THE ASCENT (continuing `SarvavibhagaH`).  Among the seven nayas
-- (`NayaVada`, Tattvārthasūtra 1.34) the SAṄGRAHA-naya is the collective
-- standpoint: it grasps particulars under a universal, identifying what a
-- chosen relation makes the same.  In mathematics that operation is the
-- QUOTIENT.  And the quotient's universal property is exactly the naya's
-- character: an observation that RESPECTS the relation R (identifies
-- R-related things — sees only the collected universal, blind to the
-- within-class distinction) is precisely a map out of A / R.
--
--     (A → B) respecting R    ≃    (A / R → B)          [B a set]
--
-- So the saṅgraha-naya is not a metaphor for the quotient; it is the
-- quotient's universal property.  The fibre of the quotient map over a
-- class is the class itself — exactly what the collective standpoint
-- cannot separate (the fibre law, `SarvavibhagaH`, `QuotientFiberLaw`).
--
-- WHAT IS PROVED:
--   §2  सङ्ग्रह-सार्वत्रिकम् : (A → B respecting R) ≃ (A/R → B), for B a
--       set — the universal property (library's `setQuotUniversal`), named
--       as the naya: an R-invariant observation IS a factoring through the
--       collective standpoint, and uniquely.
--   §3  प्रमाणम्-आच्छादयति : the quotient map [_] : A → A/R is surjective
--       — pramāṇa (all of A) covers every collected class; no class is
--       unseen.
--   §4  कक्ष्या-लोपः : the collective standpoint is genuinely BLIND within
--       a class: if R a b then [ a ] ≡ [ b ] — R-related particulars are
--       identified, their difference is the fibre the naya forgets.
--
-- WHAT IS **NOT** CLAIMED.  The universal property is the library's; no
-- novelty in it.  The identification — that the saṅgraha-naya IS the
-- quotient and its universal property is the naya's defining character —
-- is the claim, made a term.  R need not be an equivalence for §2/§4;
-- effectivity (fibre over [a] = exactly R-class of a) needs R an
-- equivalence and is cited to the library, not re-proved.  Doctrine is
-- Jaina (the seven nayas, Siddhasena); the type theory is cubical.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module SamgrahaNaya_TheCollectiveStandpointIsTheQuotientAndRInvariantObservationsFactorThroughIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.HITs.SetQuotients using (_/_ ; [_] ; eq/ ; setQuotUniversal)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Data.Sigma using (Σ ; _,_ ; Σ-syntax)

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ {A : Type ℓ} {B : Type ℓ'} (R : A → A → Type ℓ'') where

  ------------------------------------------------------------------------
  -- §2  सङ्ग्रह-सार्वत्रिकम् — an R-invariant observation is exactly a map
  --     out of the collective standpoint (the quotient).
  ------------------------------------------------------------------------

  -- the R-respecting observations of A: standpoints that identify R-related
  -- particulars (see only the collected universal)
  सङ्ग्रह-दृष्टि : Type _
  सङ्ग्रह-दृष्टि = Σ[ f ∈ (A → B) ] ((a b : A) → R a b → f a ≡ f b)

  सङ्ग्रह-सार्वत्रिकम् : isSet B → (A / R → B) ≃ सङ्ग्रह-दृष्टि
  सङ्ग्रह-सार्वत्रिकम् Bset = setQuotUniversal Bset

------------------------------------------------------------------------
-- §3  प्रमाणम्-आच्छादयति — the quotient map covers every class.
-- §4  कक्ष्या-लोपः — R-related particulars are identified (the blindness).
------------------------------------------------------------------------

module _ {A : Type ℓ} {R : A → A → Type ℓ'} where

  सङ्ग्रहः : A → A / R                       -- the collective standpoint's map
  सङ्ग्रहः a = [ a ]

  -- pramāṇa covers: every class is [ a ] for some a (surjectivity, as the
  -- image-inhabitation of SarvavibhagaH.आच्छादकः, propositionally)
  open import Cubical.HITs.SetQuotients using (elimProp)
  open import Cubical.Foundations.HLevels using (isPropΠ)
  open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; isPropPropTrunc)

  प्रमाणम्-आच्छादयति : (x : A / R) → ∥ Σ[ a ∈ A ] (सङ्ग्रहः a ≡ x) ∥₁
  प्रमाणम्-आच्छादयति = elimProp (λ _ → isPropPropTrunc) (λ a → ∣ a , refl ∣₁)

  -- the blindness: R a b ⟹ the collective standpoint identifies a and b
  कक्ष्या-लोपः : (a b : A) → R a b → सङ्ग्रहः a ≡ सङ्ग्रहः b
  कक्ष्या-लोपः a b r = eq/ a b r
