{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तन्तुविभागः — अवलोकनस्य गणः तत्-तन्तूनाम् स्व-अन्तःक्रिया-गणानां गुणनम् एव ।
--
-- (the fibre decomposition: the gaṇa of an observable IS the product,
--  over the codomain, of its fibres' own endomorphism monoids.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  `SvaTantuVasa` §६(a) and `SamraksakaGana` §५(a) both
-- hand the same remainder forward: currying along A ≃ Σ B (fiber f)
-- identifies the section CARRIER with (b : B) → fiber f b → fiber f b,
-- "but carrying ⋆ onto pointwise composition needs the transport
-- coherence of that currying, and it is not given here."  This module
-- gives it, over set carriers:
--
--   विभागः      :  छेदः f  ≃  ((b : B) → fiber f b → fiber f b)
--   विभाग-गण-समता : MonoidEquiv छेदगणः तन्तुगणः
--   प्रवाह-तन्तु-समता : MonoidEquiv प्रवाहगणः तन्तुगणः
--
-- where तन्तुगणः is the PRODUCT monoid Π_b End(fiber f b) under
-- pointwise composition.  Composing with `SamraksakaGana.गण-समता`
-- (whose preservation fields are refl), the chain becomes: conserving
-- flows ≅ sections of one's own fibres ≅ the product of the fibres'
-- endomorphism monoids — the typal shadow of "the commutant decomposes
-- over the spectrum", now exact and checked end to end.
--
-- THE ONE COHERENCE, and why it is small.  The transport that currying
-- introduces is `subst (fiber f) p`, and over a SET codomain the only
-- fact needed about it is that it fixes the point:
--
--   लम्बः : subst (fiber f) p w .fst ≡ w .fst        (one J)
--
-- because equality of sections and of fibre-endomorphisms alike reduces
-- to their point components (the path components are propositions).
-- All four preservation/round-trip proofs are लम्बः plus plumbing; the
-- coherence tax the ∞-version would pay (the full subst-action law
-- subst p (x , r) ≡ (x , r ∙ p) and its associativity) is named in §५
-- and not paid here, because at set level nothing consumes it.
--
-- ────────────────────────────────────────────────────────────────────
-- TERMS.  तन्तु for the fibre follows this corpus's own use
-- (`Vargaprakrtitantu`); विभाग in its plain sense, division into parts.
-- The compound तन्तुविभाग is built here; no text is claimed for it.
-- गण as in `SamraksakaGana` (gaṇapāṭha, Pāṇini, ~500 BCE, applied to
-- flows in this corpus).
--
-- WHAT IS NOT CLAIMED.  Nothing analytic — no commutant, no spectrum,
-- no von Neumann algebra; the slogan names a rhyme, and the theorem is
-- its finite/typal shadow only.  The ∞-version (arbitrary carriers,
-- where the witness components carry real path algebra) is śeṣa, §५.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed bundle), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module Texts.TantuVibhaga_TheGanaOfAnObservableIsTheProductOfItsFibresOwnEndomorphismMonoids where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
  using (isSetΣ ; isSetΠ ; isPropΠ)
open import Cubical.Data.Sigma
open import Cubical.Algebra.Monoid

open import SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres
open import Texts.SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl

private variable ℓ : Level

------------------------------------------------------------------------
-- §१ · THE TWO SIDES, over any f.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  -- the product of the fibres' endomorphism types
  तन्तु-अन्तः : Type ℓ
  तन्तु-अन्तः = (b : B) → fiber f b → fiber f b

  _∘त_ : तन्तु-अन्तः → तन्तु-अन्तः → तन्तु-अन्तः
  (t ∘त t') b x = t b (t' b x)

  त-एकः : तन्तु-अन्तः
  त-एकः b x = x

  -- currying: a section of one's own fibres acts on each fibre, the
  -- transport along x's residence certificate doing the bookkeeping …
  प्रति : छेदः f → तन्तु-अन्तः
  प्रति s b x = subst (fiber f) (x .snd) (s (x .fst))

  -- … and every fibre-endomorphism family reads back as a section.
  आगमः : तन्तु-अन्तः → छेदः f
  आगमः t a = t (f a) (a , refl)

------------------------------------------------------------------------
-- §२ · THE COHERENCE, over a set codomain: transport fixes the point.
------------------------------------------------------------------------

module तन्तौ {A B : Type ℓ} (setA : isSet A) (setB : isSet B) (f : A → B) where

  open गणे setA setB f using (छेद-समता ; छेदगणः ; प्रवाहगणः ; गण-समता)

  लम्बः : {y b : B} (p : y ≡ b) (w : fiber f y)
        → subst (fiber f) p w .fst ≡ w .fst
  लम्बः {y = y} p w =
    J (λ b' q → subst (fiber f) q w .fst ≡ w .fst)
      (cong fst (substRefl {B = fiber f} w)) p

  तन्तु-समता : (t t' : तन्तु-अन्तः f)
             → ((b : B) (x : fiber f b) → t b x .fst ≡ t' b x .fst)
             → t ≡ t'
  तन्तु-समता t t' h =
    funExt (λ b → funExt (λ x → Σ≡Prop (λ _ → setB _ _) (h b x)))

  ------------------------------------------------------------------
  -- §३ · THE CARRIER EQUIVALENCE.
  ------------------------------------------------------------------

  विभाग-Iso : Iso (छेदः f) (तन्तु-अन्तः f)
  Iso.fun विभाग-Iso = प्रति f
  Iso.inv विभाग-Iso = आगमः f
  Iso.rightInv विभाग-Iso t = तन्तु-समता _ _ (λ b x →
      लम्बः (x .snd) (आगमः f t (x .fst))
    ∙ (λ i → t (x .snd i) (x .fst , (λ j → x .snd (i ∧ j))) .fst))
  Iso.leftInv विभाग-Iso s = छेद-समता _ _ (λ a → लम्बः refl (s a))

  विभागः : छेदः f ≃ तन्तु-अन्तः f
  विभागः = isoToEquiv विभाग-Iso

  ------------------------------------------------------------------
  -- §४ · THE MONOIDS, AND THE IDENTIFICATION CARRIES THEM.
  ------------------------------------------------------------------

  तन्तुगणः : Monoid ℓ
  तन्तुगणः = makeMonoid {M = तन्तु-अन्तः f} (त-एकः f) (_∘त_ f)
    (isSetΠ (λ b → isSetΠ (λ _ → isSetΣ setA (λ _ → isProp→isSet (setB _ _)))))
    (λ _ _ _ → refl) (λ _ → refl) (λ _ → refl)

  -- currying carries the unit to the identity …
  प्रति-एकः : प्रति f (छेद-एकः f) ≡ त-एकः f
  प्रति-एकः = तन्तु-समता _ _ (λ b x → लम्बः (x .snd) (x .fst , refl))

  -- … and the convolution ⋆ to pointwise composition.
  प्रति-गुणः : (s s' : छेदः f)
             → प्रति f (_⋆_ f s s') ≡ _∘त_ f (प्रति f s) (प्रति f s')
  प्रति-गुणः s s' = तन्तु-समता _ _ (λ b x →
      लम्बः (x .snd) (_⋆_ f s s' (x .fst))
    ∙ sym ( लम्बः (प्रति f s' b x .snd) (s (प्रति f s' b x .fst))
          ∙ cong (λ w → s w .fst) (लम्बः (x .snd) (s' (x .fst)))))

  विभाग-गण-समता : MonoidEquiv छेदगणः तन्तुगणः
  विभाग-गण-समता = विभागः , monoidequiv प्रति-एकः प्रति-गुणः

  ------------------------------------------------------------------
  -- §४′ · THE COMPOSITE: flows ≅ the product of the fibres' monoids.
  -- `गण-समता`'s preservation fields are refl, so the composite's are
  -- exactly this module's — no path algebra joins the two legs.
  ------------------------------------------------------------------

  प्रवाह-तन्तु-समता : MonoidEquiv प्रवाहगणः तन्तुगणः
  प्रवाह-तन्तु-समता =
      compEquiv (वासः f) विभागः
    , monoidequiv प्रति-एकः
        (λ σ τ → प्रति-गुणः (equivFun (वासः f) σ) (equivFun (वासः f) τ))

------------------------------------------------------------------------
-- §५ · शेषः.
--
-- (a) THE ∞-VERSION.  Over arbitrary carriers the point-reduction of
--     लम्बः is not available: the full action law subst (fiber f) p
--     (x , r) ≡ (x , r ∙ p) and its compatibility with ∙-assoc must be
--     carried through every preservation proof.  Named, not paid.
-- (b) THE GROUP LEG.  `SamraksakaSamuha`'s symmetry group should ride
--     प्रवाह-तन्तु-समता to a subgroup of Π_b Aut(fiber f b); pointwise
--     that is §३ of that module repeated here, and it is not written.
-- (c) THE POLES.  At zero loss every fibre is contractible and तन्तुगणः
--     is trivial pointwise; at total loss over a pointed connected
--     codomain the product collapses to one factor.  Both are
--     transports of the poles already proved in SamraksakaGana and are
--     not restated.
------------------------------------------------------------------------
