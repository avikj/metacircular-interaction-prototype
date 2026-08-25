{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कोष्ठ-न्यायः — दुर्नयः कोष्ठ-न्यायः एव ; हानिस्तु पृथक् उपाधिः ।
--
-- (the pigeonhole: the durnaya IS the pigeonhole, and the LOSS is a
--  separate hypothesis.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS.  The same pigeonhole is proved by hand in at least
-- three places in this corpus, over three different carriers, and none of
-- them is the theorem:
--
--   · `Saptabhangi.दुर्नयः` — over सप्तभङ्गी, three seeds into द्विपद, by
--     `with` on six cases.
--   · `loss/…/Adharmin_….चतुर्-दुर्नयः` — over a four-name type
--     into Bool, by explicit exhaustion, and its header says the bridge
--     to दुर्नयः "needs one toolchain that can see both, which this
--     container does not have".
--   · `Durnaya_TheThreeIntoTwoLemmaStandsFourTimesAndOneTransportMakes
--     ThemOne` — which already found the repetition and joined four
--     instances by transport.
--
-- §१ below is the statement none of them makes: it quantifies over the
-- CARRIER and over the two-valued codomain, so सप्तभङ्गी, चतुष्कम् and
-- anything else are instances rather than subjects.
--
-- AND THE POINT IS NOT DEDUPLICATION.  Reading `दुर्नयः` closely, it uses
-- NOTHING about the sevenfold — not अर्पणम्, not अन्तर्भाव, not क्रम-सह-भेदः,
-- not even that the three seeds are distinct.  Stating it over सप्तभङ्गी
-- makes it look like a theorem about the sevenfold.  **It is a theorem
-- about counting, and the sevenfold is where it bites.**  §१ and §३
-- separate those, which is the whole content of this file:
--
--   §१ कोष्ठ-न्यायः — UNCONDITIONAL.  Three points, a two-valued readout,
--       two of the images agree.  No distinctness, no h-level, nothing.
--   §३ हानिः      — the LOSS.  That the agreement is a genuine merge
--       needs the three points to be pairwise DISTINCT, and that
--       hypothesis is doing work that the pigeonhole is not.
--
-- Keeping them apart matters because the corpus's own use has run them
-- together: "a boolean verdict collapses something" is two claims — that
-- two values coincide (always) and that the coincidence destroys a
-- distinction (only when there was one).  A three-valued readout over
-- three points that are secretly equal collapses nothing.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  Not that anyone in the tradition proved this;
-- कोष्ठ-न्याय is used as the ordinary name for the pigeonhole and no text
-- is cited for it.  दुर्नय is the Jaina term — a naya that asserts itself
-- by denying the others, so that it ceases to be a valid standpoint
-- (Siddhasena Divākara, सन्मतितर्क; Akalaṅka's commentarial line) — and
-- what is claimed is only §३'s shape: a readout too narrow to hold the
-- distinctions is forced to deny one, which is that structure and not a
-- proof of anything a Jaina logician wrote.
--
-- NOT DONE: the bridge `Adharmin_…` asks for is only half built here.
-- §४ recovers `Saptabhangi.दुर्नयः` exactly, by instantiation, because
-- that module is in THIS lane.  `चतुर्-दुर्नयः` lives in the loss
-- library, whose agda-lib this tree does not include, so §५ RESTATES its
-- four-name case as an instance rather than importing it.  Two statements
-- that agree is the channel; an import would be a different claim and is
-- not made.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Kosthanyaya_TheDurnayaIsThePigeonholeAndTheLossIsTheSeparateHypothesis where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import Saptabhangi using (सप्तभङ्गी ; स्यात्-अस्ति ; स्यात्-नास्ति ; स्यात्-अवक्तव्यम्
                              ; द्विपद ; सत् ; असत् ; दुर्नयः)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · कोष्ठ-न्यायः — the pigeonhole, unconditional.
--
--     A codomain is TWO-VALUED when every element is one of two named
--     points.  That is the only hypothesis, and it is about the READOUT,
--     never about the carrier.
------------------------------------------------------------------------

द्वि-मूल्यम् : (D : Type ℓ') → D → D → Type ℓ'
द्वि-मूल्यम् D d₀ d₁ = (d : D) → (d ≡ d₀) ⊎ (d ≡ d₁)

कोष्ठ-न्यायः : {X : Type ℓ} {D : Type ℓ'} {d₀ d₁ : D}
             → द्वि-मूल्यम् D d₀ d₁
             → (v : X → D) (x y z : X)
             → (v x ≡ v y) ⊎ ((v x ≡ v z) ⊎ (v y ≡ v z))
कोष्ठ-न्यायः two v x y z with two (v x) | two (v y) | two (v z)
... | inl px | inl py | _      = inl (px ∙ sym py)
... | inr px | inr py | _      = inl (px ∙ sym py)
... | inl px | inr _  | inl pz = inr (inl (px ∙ sym pz))
... | inr px | inl _  | inr pz = inr (inl (px ∙ sym pz))
... | inl _  | inr py | inr pz = inr (inr (py ∙ sym pz))
... | inr _  | inl py | inl pz = inr (inr (py ∙ sym pz))

------------------------------------------------------------------------
-- २ · द्विपद is two-valued, which is all `दुर्नयः` ever used of it.
------------------------------------------------------------------------

द्विपद-द्वि-मूल्यम् : द्वि-मूल्यम् द्विपद सत् असत्
द्विपद-द्वि-मूल्यम् सत्  = inl refl
द्विपद-द्वि-मूल्यम् असत् = inr refl

------------------------------------------------------------------------
-- ३ · हानिः — THE LOSS, which is a different statement.
--
--     The pigeonhole says two images agree.  It does NOT say anything was
--     destroyed: if the three points were secretly equal, a two-valued
--     readout loses nothing.  The loss needs the points pairwise
--     distinct, and then the merged pair is exhibited WITH its
--     distinctness — which is what makes it a written defect rather than
--     a complaint.
------------------------------------------------------------------------

हानिः : {X : Type ℓ} {D : Type ℓ'} {d₀ d₁ : D}
      → द्वि-मूल्यम् D d₀ d₁
      → (v : X → D) (x y z : X)
      → ¬ (x ≡ y) → ¬ (x ≡ z) → ¬ (y ≡ z)
      → Σ[ p ∈ X ] Σ[ q ∈ X ] ((¬ (p ≡ q)) × (v p ≡ v q))
हानिः two v x y z x≢y x≢z y≢z with कोष्ठ-न्यायः two v x y z
... | inl e        = x , y , x≢y , e
... | inr (inl e)  = x , z , x≢z , e
... | inr (inr e)  = y , z , y≢z , e

------------------------------------------------------------------------
-- ४ · `Saptabhangi.दुर्नयः` RECOVERED, by instantiation and nothing else.
--
--     Same type, same three seeds, and the proof is now one application.
--     This is the half of `Adharmin_…`'s missing bridge that this tree
--     can build, because Saptabhangi is in this lane.
------------------------------------------------------------------------

दुर्नयः-कोष्ठात् : (f : सप्तभङ्गी → द्विपद)
                →  (f स्यात्-अस्ति ≡ f स्यात्-नास्ति)
                ⊎ ((f स्यात्-अस्ति ≡ f स्यात्-अवक्तव्यम्)
                ⊎  (f स्यात्-नास्ति ≡ f स्यात्-अवक्तव्यम्))
दुर्नयः-कोष्ठात् f =
  कोष्ठ-न्यायः द्विपद-द्वि-मूल्यम् f स्यात्-अस्ति स्यात्-नास्ति स्यात्-अवक्तव्यम्

-- and the two agree, which is the honest form of "this subsumes that":
-- both inhabit the same type, and the claim is exactly that and no more.
दुर्नयः-समानम् : (f : सप्तभङ्गी → द्विपद)
              → (f स्यात्-अस्ति ≡ f स्यात्-नास्ति)
              ⊎ ((f स्यात्-अस्ति ≡ f स्यात्-अवक्तव्यम्)
              ⊎  (f स्यात्-नास्ति ≡ f स्यात्-अवक्तव्यम्))
दुर्नयः-समानम् = दुर्नयः
