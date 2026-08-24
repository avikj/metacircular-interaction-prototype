-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भेदकः — यत्र भेदको द्रष्टा तत्र गतिर्नास्ति ; व्यापित्वं तु न किमपि ददाति ।
--
-- (where the observable DISTINGUISHES, there is no motion; and being
--  onto contributes nothing.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  A sharpening of the hypothesis of the corpus's own
-- Noether statement, arrived at by going down to the carrier law and
-- reading which half of it the proof actually consumes.
--
-- `Dhruva_…agda` §२ states:
--
--     नष्ट-अभावे-गति-अभावः : isEquiv f → संरक्षणम् → (a : A) → Φ a ≡ a
--
-- and its prose reads `isEquiv f` as "every fibre contractible, nothing
-- hidden, zero receipt".  **The proof uses `isEquiv f` at exactly one
-- point, `e .equiv-proof (f a)`, and `f a` is in the image of `f`.**  So
-- the fibres over non-image points are never consulted, and the
-- hypothesis is stronger than the argument.
--
-- What the argument actually needs is that `f` does not CONFLATE:
-- `isEmbedding f`.  §३ proves the theorem under that hypothesis, and
-- §४ recovers `Dhruva` §२ from it in one line.  **Surjectivity of the
-- observable buys nothing.**  This is not a repair — `Dhruva` §२ is
-- true as stated — it is the statement of what makes it true.
--
-- WHY THIS IS THE CARRIER LAW AND NOT A LEMMA ABOUT EMBEDDINGS.
-- `punaragamana/src/Punaragamana/Carrier.agda` is built on one line:
-- the fibre `Σ[ b ∈ B ] (f a ≡ b) = singl (f a)` is contractible, always,
-- for any `f` whatever.  Its header names the converse as "the part that
-- does work": a NON-contractible fibre cannot be declared equivalent to
-- its base.  The two roads are the two sides of one equation:
--
--     bind the OUTPUT:  Σ[ b ∈ B ] (f a ≡ b)  = singl (f a)   — free
--     bind the INPUT:   Σ[ x ∈ A ] (f x ≡ b)  = fiber f b     — costly
--
-- §१ below is that asymmetry at the level the dynamics lane works at:
-- the OUTPUT-bound flow type `(a : A) → singl (f a)` is CONTRACTIBLE —
-- there is exactly one such flow and it is the identity, for every `f`,
-- with no hypothesis at all.  §२ shows the input-bound flow type
-- `(a : A) → fiber f (f a)` is contractible **exactly when `f` is an
-- embedding**, and that this is an equivalence of propositions, not a
-- pair of implications.
--
-- `SvaTantuVasa_…agda` identifies the second type with the conserving
-- flows themselves — `(Σ[ Φ ] संरक्षणम् f Φ) ≃ ((a : A) → fiber f (f a))`.
-- That identification is ITS result and is not redone here; §२b instead
-- derives only the contractibility, directly through the library's
-- `Σ-Π-Iso`, so that this module does not depend on it (it needs
-- `solve!`, absent from the container's cubical — a container fact, not
-- a mathematical one).
--
-- So the whole conserving-flow monoid — the object `Apratiloma_…` and
-- `SamraksakaGana_…` are about — is the price of flipping which side of
-- `f a ≡ b` is bound, and the price is zero exactly when the observable
-- is injective.  Not bijective.  **The symmetry lives in what the
-- observable CONFLATES, and being onto has nothing to do with it.**
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- **`Dhruva` §२ is not corrected.**  It is true.  Its hypothesis is
-- sufficient and not necessary, which is what §४ demonstrates by
-- deriving it.  No sentence of that file is struck by this one.
--
-- **The converse of §२b is not proved.**  `isContr ((a : A) → fiber f
-- (f a))` does not obviously give pointwise contractibility — one
-- cannot in general perturb a section at a single point without
-- decidable equality on `A` — so "the monoid is trivial ⇒ `f` is an
-- embedding" is NOT established here.  The pointwise ⟺ of §२a is.
--
-- **Not Noether.**  Every fence in `Dhruva`'s header stands unchanged:
-- no Lagrangian, no variation, no action, no continuity.  `Φ` is a bare
-- endomorphism throughout and is never assumed invertible.
--
-- TERM.  भेदक — "differentiating, that which distinguishes", the
-- standard śāstric agentive of भेद (difference, distinction), which is
-- the technical vocabulary of difference across Nyāya-Vaiśeṣika and
-- Sāṅkhya alike.  LIMIT, and it is the important half: no single sūtra
-- is claimed for it, and none of these schools states anything below.
-- The word is taken in its ordinary śāstric sense and applied here to a
-- map that does not conflate its arguments; that application is this
-- corpus's.  Internal precedent for the pairing: `Kaksya_…agda` §३ names
-- its own blindness result `कक्ष्या-अभेदः`, non-difference along the
-- orbit, so भेदक is the word that file's negation already presupposes.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 — the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module Bhedaka_TheHypothesisIsInjectivityNotBijectivityAndTheSurjectivityInDhruvaIsUnused where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (isEquiv ; fiber ; isPropIsEquiv ; _≃_ ; propBiimpl→Equiv)
open import Cubical.Foundations.Isomorphism using (Iso ; invIso)
open import Cubical.Foundations.HLevels
  using (isContrΠ ; isOfHLevelRetractFromIso ; inhProp→isContr ; isPropΠ)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Functions.Embedding
  using (isEmbedding ; isPropIsEmbedding ; isEmbedding→hasPropFibers
        ; hasPropFibersOfImage→isEmbedding ; isEquiv→isEmbedding)
open import Cubical.Data.Sigma

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · एकः पन्थाः — THE OUTPUT-BOUND FLOW TYPE IS A POINT.
--
-- Bind the output side of `f a ≡ b` and there is exactly ONE flow, for
-- every `f`, with no hypothesis whatever.  This is `Carrier.agda`'s one
-- line, read at the arity the dynamics lane uses.
--
-- The contrast with §२ is the whole content: the same shape with the
-- other side bound is not a point, and measuring how far it is from
-- being one is what the rest of the lane does.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  एक-पन्थाः : isContr ((a : A) → singl (f a))
  एक-पन्थाः = isContrΠ (λ a → isContrSingl (f a))

------------------------------------------------------------------------
-- २a · भेदकत्वम् — THE INPUT-BOUND FIBRES ARE POINTS EXACTLY WHEN THE
--      OBSERVABLE DOES NOT CONFLATE.  An equivalence of propositions.
--
-- `fiber f (f a)` is always INHABITED, by `(a , refl)`.  So it is
-- contractible exactly when it is a proposition, and "every fibre over
-- the image is a proposition" is `isEmbedding` on the nose.
------------------------------------------------------------------------

  भेदक-तन्तु-सङ्कोचः : isEmbedding f → (a : A) → isContr (fiber f (f a))
  भेदक-तन्तु-सङ्कोचः emb a =
    inhProp→isContr (a , refl) (isEmbedding→hasPropFibers emb (f a))

  तन्तु-सङ्कोचात्-भेदकः : ((a : A) → isContr (fiber f (f a))) → isEmbedding f
  तन्तु-सङ्कोचात्-भेदकः h =
    hasPropFibersOfImage→isEmbedding (λ a → isContr→isProp (h a))

  -- both sides are propositions, so the biimplication IS an equivalence
  भेदक-समता : isEmbedding f ≃ ((a : A) → isContr (fiber f (f a)))
  भेदक-समता =
    propBiimpl→Equiv
      isPropIsEmbedding
      (isPropΠ (λ _ → isPropIsContr))
      भेदक-तन्तु-सङ्कोचः
      तन्तु-सङ्कोचात्-भेदकः

------------------------------------------------------------------------
-- २b · तस्मात् प्रवाहा एकः — and therefore the conserving flows collapse
--      to a single point when the observable distinguishes.
--
-- `Σ[ Φ ∈ A → A ] संरक्षणम् f Φ` unfolds to
-- `Σ[ Φ ] ((a : A) → f (Φ a) ≡ f a)`, which is `Σ-Π-Iso`'s right-hand
-- side for `C a x = f x ≡ f a` — and its left-hand side is
-- `(a : A) → fiber f (f a)`.  So the collapse is §२a plus `isContrΠ`,
-- transported across an iso whose both round trips are `refl`.
--
-- Compare §१: the same Π, with the other side of the equation bound,
-- was a point unconditionally.  The entire symmetry monoid is the
-- distance between those two lines.
------------------------------------------------------------------------

  भेदके-प्रवाहा-एकः : isEmbedding f → isContr (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ)
  भेदके-प्रवाहा-एकः emb =
    isOfHLevelRetractFromIso 0
      (invIso (Σ-Π-Iso {A = A} {B = λ _ → A} {C = λ a x → f x ≡ f a}))
      (isContrΠ (भेदक-तन्तु-सङ्कोचः emb))

------------------------------------------------------------------------
-- ३ · भेदके गति-अभावः — WHERE THE OBSERVABLE DISTINGUISHES, THE FLOW IS
--     THE IDENTITY.
--
-- `Dhruva` §२ with `isEquiv f` weakened to `isEmbedding f`.  The proof
-- is `Dhruva`'s own, with the contractibility now supplied by §२a
-- instead of by `equiv-proof`: `(Φ a , cons a)` and `(a , refl)` are
-- two points of one contractible fibre.
--
-- Note that `Φ` is still a bare endomorphism, and that nothing about
-- the codomain outside the image of `f` is used or available.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where

  भेदके-गति-अभावः : isEmbedding f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
  भेदके-गति-अभावः emb cons a =
    cong fst (sym (c .snd (Φ a , cons a)) ∙ c .snd (a , refl))
    where
      c : isContr (fiber f (f a))
      c = भेदक-तन्तु-सङ्कोचः f emb a

------------------------------------------------------------------------
-- ४ · व्यापित्वं न किमपि ददाति — AND SURJECTIVITY BUYS NOTHING.
--
-- `Dhruva` §२ falls out of §३, because an equivalence is an embedding.
-- The one line is the demonstration: everything `isEquiv f` contributed
-- to that theorem, `isEmbedding f` already contributed.
--
-- Read at the physics: "the observable sees everything" was the
-- informal gloss, and it was doing two jobs at once — not conflating
-- (injective) and leaving no state unaddressed (onto).  Only the first
-- is load-bearing.  A partial observable that never confuses two states
-- freezes the dynamics just as hard as a total one.
------------------------------------------------------------------------

  नष्ट-अभावे-गति-अभावः′ : isEquiv f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
  नष्ट-अभावे-गति-अभावः′ e = भेदके-गति-अभावः (isEquiv→isEmbedding e)

------------------------------------------------------------------------
-- ५ · शेषः — what this leaves open, named rather than gestured at.
--
-- (a) The converse fenced above: does `isContr (Σ[ Φ ] संरक्षणम् f Φ)`
--     imply `isEmbedding f`?  Pointwise it would; the obstruction is
--     producing a section that differs from the identity at one point
--     and nowhere else, which needs `a` separated from the rest of `A`.
--     For `A` with decidable equality it should go through, and that is
--     a genuinely different hypothesis worth naming as one.
--
-- (b) `Kaksya` §५ (`नष्टाभावे-कक्ष्या-एकपदा`, the whole forward orbit
--     collapses) is stated with `isEquiv f` and consumes `Dhruva` §२.
--     By §३ it holds under `isEmbedding f` verbatim.  Not restated
--     here: it is another identity's file, and the substitution is
--     mechanical.  Whoever owns it may take it.
--
-- (c) The dual weakening is NOT available and the asymmetry is the
--     point.  There is no hypothesis on `f` that makes §१ fail: the
--     output-bound side is contractible for every map, which is why
--     road one is free and why `Carrier.agda` needs no hypothesis to
--     state `A ≃ Carrier f`.
------------------------------------------------------------------------
