{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- बीजम् — एकम् एव बीजं चतुर्षु सिद्धान्तेषु ; प्रत्यानयनम् एव अधःस्थानं, न समता ।
--
-- (one seed in four theorems; and a RETRACTION already puts a map at the
--  bottom of the loss order — an equivalence is more than is needed.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE SEED.  Four theorems in this corpus are the SAME TERM:
--
--   Vyapti.संरक्षक-वृद्धिः   (h , p) cons a  = p _  ∙ cong h (cons a) ∙ sym (p a)
--   Vyapti.तन्तु-वृद्धिः      (h , p) a (x,q) = p x  ∙ cong h q        ∙ sym (p a)
--   Vyapti.समता-वृद्धिः      (h , p) a a' q  = p a  ∙ cong h q        ∙ sym (p a')
--   Bahupratyanayana.प्रत्यानयनम्-तनुः
--        (r , ret) b (a₁,p₁) (a₂,p₂)  = sym (ret a₁) ∙ cong r (p₁ ∙ sym p₂) ∙ ret a₂
--
-- `α ∙ cong k β ∙ sym γ` — conjugate a path by a coherence.  Each is
-- proved directly in its own module; none is derived from another; and
-- the shape is not remarked anywhere.  §२ names it once.
--
-- AND NAMING IT SHOWS A HYPOTHESIS IS TOO STRONG.  Read the fourth in the
-- vocabulary of the first three: with `g = idfun A` and `k = r`, the
-- coherence `p : (a : A) → g a ≡ k (f a)` IS `a ≡ r (f a)` — which is
-- exactly a retraction, reversed.  So
--
--     a RETRACTION of f is a व्याप्नोति-witness that f is at the BOTTOM
--     of the loss order  (§३).
--
-- `Vyapti.समत्वम्-अधःस्थम्` puts an EQUIVALENCE at the bottom, using
-- `invEq`/`retEq`.  Only the retraction half is used.  §४ therefore
-- weakens `Dhruva`'s theorem — and `Vyapti`'s one-line reproof of it —
-- from `isEquiv f` to `प्रत्यानयनम् f`:
--
--     प्रत्यानयनम् f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
--
-- No loss, no motion — and "no loss" needs only that the map can be
-- UNDONE, not that it is an identification.  A retraction is strictly
-- weaker: `Unit → S¹` has one and is not an equivalence, and
-- `Bahupratyanayana` §५ is that example.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  Nothing here is new mathematics — every term is
-- three path components, and the four theorems above were already
-- checked.  What is claimed is that they are one term, and that seeing
-- them so weakens a hypothesis in two of them.  §४ is NOT stronger than
-- Dhruva in what it concludes; it concludes the same thing from less.
--
-- No claim that the seed is the ONLY shape in the corpus, nor that every
-- theorem of this form is an instance of §२ — `प्रत्यानयनम्-तनुः`'s inner
-- path is `p₁ ∙ sym p₂`, built from the two fibre witnesses, and §२ takes
-- that path as given rather than constructing it.  The seed is the
-- conjugation, not the whole proof.
--
-- बीज (seed) in its plain sense; no text is claimed.  The mathematics is
-- cubical type theory.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Bijam_TheRetractionIsAlreadyABottomOfTheLossOrderSoDhruvaNeedsNoEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)

open import Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt
  using (_व्याप्नोति_ ; संरक्षक-वृद्धिः)
open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)

private variable ℓ : Level

------------------------------------------------------------------------
-- २ · बीजम् — the seed, once.  A coherence carries an identification.
--     This is `समता-वृद्धिः` with the factorisation unpacked, written to
--     be the thing the other three instantiate rather than a fifth copy.
------------------------------------------------------------------------

बीजम् : {A B C : Type ℓ} {f : A → B} {g : A → C}
      → (k : B → C) → ((a : A) → g a ≡ k (f a))
      → {a a' : A} → f a ≡ f a' → g a ≡ g a'
बीजम् k p {a} {a'} q = p a ∙ cong k q ∙ sym (p a')

------------------------------------------------------------------------
-- ३ · प्रत्यानयनम् IS a bottom-witness.  A retraction of f factors the
--     identity through f — which is what `व्याप्नोति` asks for — so f
--     lies at the bottom of the loss order with no equivalence anywhere.
------------------------------------------------------------------------

प्रत्यानयनम् : {A : Type ℓ} {B : Type ℓ} → (A → B) → Type ℓ
प्रत्यानयनम् {A = A} {B = B} f = Σ[ r ∈ (B → A) ] ((a : A) → r (f a) ≡ a)

प्रत्यानयन-अधःस्थम् : {A B : Type ℓ} (f : A → B)
                   → प्रत्यानयनम् f → f व्याप्नोति (idfun A)
प्रत्यानयन-अधःस्थम् f (r , ret) = r , λ a → sym (ret a)

------------------------------------------------------------------------
-- ४ · नष्ट-अभावे-गति-अभावः, from a retraction alone.
--
--     Dhruva §२ and Vyapti's reproof both take `isEquiv f`.  Only the
--     retraction is used.  The conclusion is unchanged; the hypothesis
--     is strictly weaker, and `Unit → S¹` is a map that HAS a retraction
--     and is NOT an equivalence.
------------------------------------------------------------------------

नष्ट-अभावे-गति-अभावः-प्रत्यानयनेन :
    {A B : Type ℓ} {f : A → B} {Φ : A → A}
  → प्रत्यानयनम् f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
नष्ट-अभावे-गति-अभावः-प्रत्यानयनेन {f = f} ret =
  संरक्षक-वृद्धिः (प्रत्यानयन-अधःस्थम् f ret)

------------------------------------------------------------------------
-- ५ · THE STRONGEST FORM, and it names no external notion at all.
--
--     §४ was written as "Dhruva with a weaker hypothesis", which is the
--     wrong way round: a weaker hypothesis is a STRONGER THEOREM — same
--     conclusion, strictly larger domain.  And the hypothesis it actually
--     consumes is neither `isEquiv` nor `प्रत्यानयनम्`.  It is
--
--         f व्याप्नोति (idfun A)
--
--     — f is at the BOTTOM of the loss order — and that is the whole of
--     it.  Both `isEquiv f` (Vyapti.समत्वम्-अधःस्थम्) and `प्रत्यानयनम् f`
--     (§३) are ways of EXHIBITING bottom-ness, and neither is the
--     hypothesis.  Stated this way the law is internal: it mentions only
--     the order and conservation, and nothing from outside.
--
--     So the reading of `नष्ट-अभावे-गति-अभावः` is not "an equivalence
--     admits only the trivial symmetry".  It is:
--
--         AT THE BOTTOM OF THE LOSS ORDER, CONSERVATION IS TRIVIALITY.
--
--     which is what Vyapti already said about the order's ends and did
--     not say about this theorem.
------------------------------------------------------------------------

अधःस्थे-संरक्षणं-निष्क्रियम् :
    {A B : Type ℓ} {f : A → B} {Φ : A → A}
  → f व्याप्नोति (idfun A) → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
अधःस्थे-संरक्षणं-निष्क्रियम् = संरक्षक-वृद्धिः

-- and the two named hypotheses are corollaries, not the law
प्रत्यानयनात् : {A B : Type ℓ} {f : A → B} {Φ : A → A}
              → प्रत्यानयनम् f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
प्रत्यानयनात् {f = f} r = अधःस्थे-संरक्षणं-निष्क्रियम् (प्रत्यानयन-अधःस्थम् f r)

------------------------------------------------------------------------
-- ६ · THE BOTTOM IS CLOSED UNDER COMPOSITION, and this strengthens
--     `Samyoge` §२ the same way §५ strengthens Dhruva.
--
--     `Samyoge_…agda` §२ says "lossless composes" and proves it with
--     `compEquiv` — two EQUIVALENCES.  What composes is bottom-ness, and
--     the proof is the seed with its first component `refl`:
--
--         p a ∙ cong h (q (f a))
--
--     So a route every step of which can merely BE UNDONE is itself
--     undoable, at any length.  That is the version the machine actually
--     needs: it demands receipts, and a receipt in the operative sense is
--     a way back, not an identification.
--
--     And with §५ this is one statement: certification composes because
--     THE BOTTOM OF THE ORDER IS A SUBMONOID, and conservation is trivial
--     there.  Vyapti proved the conserving flows form a submonoid at a
--     fixed observation; this is the other axis.
------------------------------------------------------------------------

अधःस्थ-सन्धिः : {A B C : Type ℓ} (f : A → B) (g : B → C)
              → f व्याप्नोति (idfun A) → g व्याप्नोति (idfun B)
              → (λ a → g (f a)) व्याप्नोति (idfun A)
अधःस्थ-सन्धिः f g (h , p) (k , q) =
  (λ c → h (k c)) , λ a → p a ∙ cong h (q (f a))

-- the same for the named form, since that is what callers hold
प्रत्यानयन-सन्धिः : {A B C : Type ℓ} (f : A → B) (g : B → C)
                  → प्रत्यानयनम् f → प्रत्यानयनम् g
                  → प्रत्यानयनम् (λ a → g (f a))
प्रत्यानयन-सन्धिः f g (r , ret) (s , sec) =
  (λ c → r (s c)) , λ a → cong r (sec (f a)) ∙ ret a
