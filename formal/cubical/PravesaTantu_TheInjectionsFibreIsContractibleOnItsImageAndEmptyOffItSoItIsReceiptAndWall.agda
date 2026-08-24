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
-- प्रवेशतन्तुः — the fibre of an ENTERING (a coproduct injection).
--
-- THE DUAL OF प्रक्षेपतन्तुः.  `PraksepaTantu_…` computed the fibre of a
-- PROJECTION `fst , snd : A × B → A , B`: a projection FORGETS a factor, and
-- its fibre IS the whole discarded factor — a genuine loss, priced at that
-- factor's cardinality.  An INJECTION `inl , inr : A , B → A ⊎ B` is the
-- opposite move: it FORGETS NOTHING.  This file prices its fibre, and the
-- price is the corpus's two extremes and nothing between them.
--
-- ON ITS IMAGE THE FIBRE IS A RECEIPT.  Over a point `inl a₀` that lies in
-- the left summand, `fiber inl (inl a₀)` is CONTRACTIBLE — equivalent to
-- `Unit`.  A contractible fibre is exactly what `Abhijnana_…` and
-- `Avaccheda_…` call a receipt: the preimage is a single point together with
-- the unique proof it maps correctly, no choice to make, no memory to carry.
-- An injection is therefore LOSSLESS on its image, a ford in the corpus's
-- ledger, not a lossy edge.
--
-- OFF ITS IMAGE THE FIBRE IS A WALL.  Over a point `inr b` in the OTHER
-- summand, `fiber inl (inr b)` is EMPTY — equivalent to `⊥`.  This is
-- `Bhitti_…`'s wall at the level of a single point: a proved absence, an
-- `inl a ≡ inr b` that cannot exist, so `inl` misses the right summand
-- entirely.  The two summands are disjoint, and disjointness is a wall.
--
-- So `inl` (and `inr`) is all receipt and all wall, with nothing in the
-- middle — which is precisely the sense in which it "forgets nothing": every
-- fibre is either the whole answer (contractible) or the impossibility of an
-- answer (empty), never a proper set of alternatives the way a projection's
-- fibre `B` is.
--
-- The four equivalences compose the library's coproduct path characterisation
-- (`⊎Path.Cover≃Path`, itself an encode–decode) with `Σ-cong-equiv-snd`,
-- `isContr→≃Unit` and `uninhabEquiv`.  The mathematics is elementary and
-- classical (coproduct injections are embeddings with disjoint images).  No
-- source is claimed for it.  प्रवेश is ordinary Sanskrit for entering /
-- insertion, the dual reading to प्रक्षेप (throwing / projection) already used
-- in the corpus; the compound is built here, 2026-08-22.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module PravesaTantu_TheInjectionsFibreIsContractibleOnItsImageAndEmptyOffItSoItIsReceiptAndWall where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; invEquiv ; compEquiv ; LiftEquiv)
open import Cubical.Data.Sigma using (Σ-cong-equiv-snd ; Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (module ⊎Path)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.Unit.Properties using (isContr→≃Unit)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Empty.Properties using (uninhabEquiv)

private variable ℓ ℓ' : Level

------------------------------------------------------------------------
-- ० · स्थलम् — the based path space `Σ[ t ] t ≡ t₀` is contractible.
-- (`isContrSingl` names the t₀ ≡ t orientation; this is its mirror.)
------------------------------------------------------------------------
स्थलम् : {T : Type ℓ} (t₀ : T) → isContr (Σ[ t ∈ T ] (t ≡ t₀))
स्थलम् t₀ .fst = t₀ , refl
स्थलम् t₀ .snd (t , p) i = p (~ i) , λ j → p (~ i ∨ j)

module _ {A : Type ℓ} {B : Type ℓ'} where

  ------------------------------------------------------------------------
  -- १ · वाम-प्रवेशः on its image — `fiber inl (inl a₀) ≃ Unit`.
  -- Per point: `(inl a ≡ inl a₀) ≃ (a ≡ a₀)` by the injectivity built into
  -- the coproduct's own path cover; then the base space is contractible.
  ------------------------------------------------------------------------
  वाम-प्रवेश-प्रतिबिम्बे : (a₀ : A)
    → fiber (inl {A = A} {B = B}) (inl a₀) ≃ Unit
  वाम-प्रवेश-प्रतिबिम्बे a₀ =
    compEquiv
      (Σ-cong-equiv-snd
        (λ a → compEquiv (invEquiv (⊎Path.Cover≃Path (inl a) (inl a₀)))
                          (invEquiv LiftEquiv)))
      (isContr→≃Unit (स्थलम् a₀))

  ------------------------------------------------------------------------
  -- २ · वाम-प्रवेशः off its image — `fiber inl (inr b) ≃ ⊥`.
  -- `inl a ≡ inr b` transports (encode) to `Lift ⊥`, so the fibre is empty.
  ------------------------------------------------------------------------
  वाम-प्रवेश-बहिः : (b : B)
    → fiber (inl {A = A} {B = B}) (inr b) ≃ ⊥
  वाम-प्रवेश-बहिः b =
    uninhabEquiv (λ { (a , p) → ⊎Path.encode (inl a) (inr b) p .lower })
                 (λ z → z)

  ------------------------------------------------------------------------
  -- ३ · दक्षिण-प्रवेशः on its image — `fiber inr (inr b₀) ≃ Unit`.
  ------------------------------------------------------------------------
  दक्षिण-प्रवेश-प्रतिबिम्बे : (b₀ : B)
    → fiber (inr {A = A} {B = B}) (inr b₀) ≃ Unit
  दक्षिण-प्रवेश-प्रतिबिम्बे b₀ =
    compEquiv
      (Σ-cong-equiv-snd
        (λ b → compEquiv (invEquiv (⊎Path.Cover≃Path (inr b) (inr b₀)))
                          (invEquiv LiftEquiv)))
      (isContr→≃Unit (स्थलम् b₀))

  ------------------------------------------------------------------------
  -- ४ · दक्षिण-प्रवेशः off its image — `fiber inr (inl a) ≃ ⊥`.
  ------------------------------------------------------------------------
  दक्षिण-प्रवेश-बहिः : (a : A)
    → fiber (inr {A = A} {B = B}) (inl a) ≃ ⊥
  दक्षिण-प्रवेश-बहिः a =
    uninhabEquiv (λ { (b , p) → ⊎Path.encode (inr b) (inl a) p .lower })
                 (λ z → z)
