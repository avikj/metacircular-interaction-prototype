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

------------------------------------------------------------------------
-- ७ · THE BOTTOM IS A SUBMONOID AND IT IS NOT SATURATED.
--
--     §६ closes the bottom under composition.  The converse FAILS, and
--     that is `Samyoge` §३ restated where it belongs — in the order's own
--     vocabulary rather than as a remark about pipelines:
--
--         `g ∘ f` at the bottom does NOT imply `f` or `g` is.
--
--     Witness, and both halves are already in the corpus:
--       सत् : Unit → Bool, tt ↦ true — HAS a retraction (Unit is the
--         target of one trivially), so सत् IS at the bottom.
--       एकम् : Bool → Unit — has NO retraction (§४ of Bahupratyanayana,
--         and §५ below reproves it in one line), so एकम् is NOT.
--       एकम् ∘ सत् : Unit → Unit is the identity, which is the bottom.
--
--     So the composite lies at the bottom while its second factor does
--     not.  A submonoid that is not saturated: membership propagates
--     FORWARD along composition and not BACKWARD.
--
--     That is the exact content of "certification composes, refutation
--     does not", with no pipeline and no metaphor: you may conclude the
--     whole is undoable from the parts, and you may NOT conclude a part is
--     not undoable from the whole.
------------------------------------------------------------------------

open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

सत् : Unit → Bool
सत् _ = true

एकम् : Bool → Unit
एकम् _ = tt

-- सत् is at the bottom: anything into Unit retracts it
सत्-अधःस्थम् : सत् व्याप्नोति (idfun Unit)
सत्-अधःस्थम् = (λ _ → tt) , (λ { tt → refl })

-- एकम् is not: two distinct sources over the one target
एकम्-न-प्रत्यानयनीयम् : ¬ (प्रत्यानयनम् एकम्)
एकम्-न-प्रत्यानयनीयम् (r , ret) =
  false≢true (sym (ret false) ∙ ret true)

-- and the composite is the identity, hence at the bottom
सन्धिः-अधःस्थः : (λ (u : Unit) → एकम् (सत् u)) व्याप्नोति (idfun Unit)
सन्धिः-अधःस्थः = (λ _ → tt) , (λ { tt → refl })

------------------------------------------------------------------------
-- ८ · FOUR STATEMENTS OF ONE THEOREM, three of them over `isEquiv`.
--
--   Dhruva.नष्ट-अभावे-गति-अभावः          isEquiv, via a contractible FIBRE
--   Vyapti.नष्ट-अभावे-गति-अभावः-व्याप्त्या  isEquiv, via the ORDER
--   SvaTantuVasa.तादात्म्यम्             isEquiv, via contractibility of
--                                      the whole FLOW SPACE
--   §५ here                            f व्याप्नोति (idfun A) — the bottom
--
-- Same conclusion, four routes, and the fourth needs none of the other
-- three's machinery: no fibre, no flow space, no equivalence.  §८ derives
-- the isEquiv form from §५ so the containment is a term and not a remark.
--
-- AND ONE OF THAT FILE'S TWO IS SHARP, which is the distinction worth
-- keeping.  `SvaTantuVasa.ध्रुव-बिन्दुः : isEquiv f → isContr (Σ[Φ] संरक्षणम् f Φ)`
-- CANNOT weaken: the flow space is `Π[a] fiber f (f a)` (its own वासः),
-- contractible exactly when every fibre is — which IS `isEquiv f`.  So in
-- one module one theorem needs the equivalence essentially and the other
-- does not, and only the second is over-hypothesised.
--
-- This is the corpus's characteristic shape rather than a defect: it
-- proves things several times, and each proof knows something the others
-- do not.  `Kosthanyaya` found the pigeonhole at five sites; `Yamaja`
-- found the third `eqℕ`; this is the fourth Dhruva.  The value is not in
-- deleting copies — it is that the copies disagree about what is needed.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (isEquiv ; invEq ; retEq)

-- an equivalence is at the bottom (Vyapti's समत्वम्-अधःस्थम्, restated so
-- §८ is self-contained), and then the isEquiv form is one application
समता-अधःस्थम् : {A B : Type ℓ} (f : A → B) → isEquiv f → f व्याप्नोति (idfun A)
समता-अधःस्थम् f e = invEq (f , e) , λ a → sym (retEq (f , e) a)

समतायाः : {A B : Type ℓ} {f : A → B} {Φ : A → A}
        → isEquiv f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
समतायाः {f = f} e = अधःस्थे-संरक्षणं-निष्क्रियम् (समता-अधःस्थम् f e)

------------------------------------------------------------------------
-- ९ · THE ORBIT COLLAPSES AT THE BOTTOM TOO — the fifth site.
--
--   `Kaksya_….नष्टाभावे-कक्ष्या-एकपदा : isEquiv f → संरक्षणम् f Φ →
--    (n : ℕ) (a : A) → कक्ष्या f Φ n a ≡ a`
--
--   — the whole orbit collapses to its basepoint — is proved by calling
--   `Dhruva.नष्ट-अभावे-गति-अभावः` once per step, so it inherits §५'s
--   hypothesis immediately: bottom-ness suffices, and the induction is the
--   seed again, `cong Φ (IH) ∙ (one step)`.
--
--   The iterate is defined here rather than imported, because that module
--   carries it inside a parametrised block; it is the same function and
--   the duplication is named, not hidden.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

पुनरावृत्तिः : {A : Type ℓ} → (A → A) → ℕ → A → A
पुनरावृत्तिः Φ zero    a = a
पुनरावृत्तिः Φ (suc n) a = Φ (पुनरावृत्तिः Φ n a)

अधःस्थे-कक्ष्या-एकपदा :
    {A B : Type ℓ} {f : A → B} {Φ : A → A}
  → f व्याप्नोति (idfun A) → संरक्षणम् f Φ
  → (n : ℕ) (a : A) → पुनरावृत्तिः Φ n a ≡ a
अधःस्थे-कक्ष्या-एकपदा b cons zero    a = refl
अधःस्थे-कक्ष्या-एकपदा {Φ = Φ} b cons (suc n) a =
  cong Φ (अधःस्थे-कक्ष्या-एकपदा b cons n a)
  ∙ अधःस्थे-संरक्षणं-निष्क्रियम् b cons a

------------------------------------------------------------------------
-- १० · WHAT THE LIGHT DID NOT WEAKEN, and this half is the point.
--
--   Asking every declaration in the lane "is `isEquiv` a hypothesis where
--   bottom-ness would do" returns sites that are SHARP, and a blanket
--   sweep would have been wrong about them:
--
--     SvaTantuVasa.ध्रुव-बिन्दुः — the flow space is `Π[a] fiber f (f a)`,
--       contractible exactly when every fibre is, which IS `isEquiv f`.
--     NastoddistaPariksa.समता-चक्रम् / समता→परीक्षा — stated as an
--       equivalence in both directions; `isEquiv` is the content.
--     Kevalajnana.समानता→सर्वसकलम् — केवलज्ञान read as losing nothing AND
--       missing nothing.  An equivalence is exactly both halves, and the
--       doctrine is both halves; weakening it would break the reading, not
--       improve the theorem.
--
--   So the finding is not "isEquiv is usually too strong".  It is that
--   two theorems in ONE module can differ on this, and only opening each
--   says which — SvaTantuVasa's pair is exactly that case.
------------------------------------------------------------------------
