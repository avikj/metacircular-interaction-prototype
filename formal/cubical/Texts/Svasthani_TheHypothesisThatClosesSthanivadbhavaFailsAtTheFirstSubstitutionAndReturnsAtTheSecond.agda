{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्वस्थानी — यत् स्वस्मिन्नेव तिष्ठति ।  प्रथमादेशे नश्यति, द्वितीये पुनरागच्छति ।
--
-- (self-standing: what stands in place of itself.  It is destroyed by the
--  first substitution and comes back at the second.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS COMES FROM.  `punaragamana/…/Sthanivadbhava_…` instantiates
-- the carrier law at the ādeśa operation and finds that 1.1.56's अल्/अनल्
-- exception IS the base/carried split: the form is the free slot, the
-- sthānin and the designation are carried, and a designation-reading rule
-- cannot see which form was substituted BY refl.
--
-- It also states, as a written defect, exactly what the law does NOT buy:
--
--     THE LAW DERIVES 1.1.56'S BLINDNESS ACROSS SUBSTITUTIONS
--     DEFINITIONALLY AND DOES NOT DERIVE ITS BLINDNESS BETWEEN A
--     SUBSTITUTE AND ITS ORIGINAL
--
-- because those two points do not lie in one fibre of the carried map.
-- It then names the exact hypothesis that closes the gap rather than
-- describing it: `स्थानी v ≡ रूपम् v` — v stands in place of itself.
--
-- This file asks what that hypothesis is, and the answer is not a
-- technicality.  §२: for a SUBSTITUTE, it holds exactly when the
-- substitution changed nothing, so a genuine ādeśa destroys it — the
-- theorem is the hypothesis, definitionally, because `sthanin (adesa f v)`
-- is `rupa v` and `rupa (adesa f v)` is `f`.  §३: and applying the SAME
-- substitution again restores it.
--
-- SO THE HYPOTHESIS IS A DEPTH CONDITION, and an odd one: it holds before
-- any substitution, fails immediately after the first non-vacuous one, and
-- returns at the second application of the same form.  The blindness of an
-- अनल्विधि between a substitute and its original is therefore available at
-- the start of a derivation and at repeated sites, and not in between.
--
-- WHAT THIS IS AND IS NOT ABOUT THE GRAMMAR.  It is a fact about the
-- `adesa` of `Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm`,
-- which models 1.1.56 as a three-slot record and one constructor.  The
-- tradition DOES restrict 1.1.56 for iterated substitution — that is what
-- Kātyāyana's vārttikas on the sūtra are for — and it is tempting to read
-- §२ as the formal shadow of that restriction.  **That reading is not
-- claimed.**  The vārttikas have not been opened by the author of this
-- file, their restrictions are conditioned on material this model does not
-- have (environment, stratum, the त्रिपादी's असिद्धत्व), and a formal fact
-- resembling a grammatical dispute is not evidence about the dispute.
-- What IS claimed is the arithmetic of the model, and the resemblance is
-- recorded as a question worth someone opening the vārttikas for.
--
-- Pāṇini, अष्टाध्यायी १.१.५६ (स्थानिवदादेशोऽनल्विधौ), ~500 BCE; Kātyāyana's
-- vārttikas ~250 BCE; Patañjali's महाभाष्य ~150 BCE.  Nothing below is
-- attributed to any of them, and the citation is carried from the module
-- imported here and is owed at sūtra level.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Texts.Svasthani_TheHypothesisThatClosesSthanivadbhavaFailsAtTheFirstSubstitutionAndReturnsAtTheSecond where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)

open import Texts.Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm
  using (Rupa ; Varna ; mk ; adesa ; AnalVidhi ; anal-blind)
open Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm.Varna
  using (rupa ; sthanin ; samjna)

------------------------------------------------------------------------
-- १ · स्वस्थानित्वम् — the hypothesis, named so it can be reasoned about
--     rather than carried around as a side condition.
------------------------------------------------------------------------

स्वस्थानी : Varna → Type
स्वस्थानी v = sthanin v ≡ rupa v

------------------------------------------------------------------------
-- २ · आदेशो नाशयति — A SUBSTITUTION DESTROYS IT, exactly when it
--     substitutes something.
--
--     `adesa f v = mk f (rupa v) (samjna v)`, so for the substitute the
--     hypothesis unfolds to `rupa v ≡ f`.  The theorem IS the hypothesis;
--     both directions are the identity function, and that is the content:
--     "the substitute stands for itself" and "the substitution changed
--     nothing" are the same proposition, not merely equivalent.
------------------------------------------------------------------------

आदेश-स्वस्थानी-सम : (f : Rupa) (v : Varna) → स्वस्थानी (adesa f v) ≡ (rupa v ≡ f)
आदेश-स्वस्थानी-सम f v = refl

आदेश-नाशयति : (f : Rupa) (v : Varna) → ¬ (rupa v ≡ f) → ¬ (स्वस्थानी (adesa f v))
आदेश-नाशयति f v h = h

आदेश-वृथा-रक्षति : (f : Rupa) (v : Varna) → rupa v ≡ f → स्वस्थानी (adesa f v)
आदेश-वृथा-रक्षति f v p = p

------------------------------------------------------------------------
-- ३ · द्वितीये पुनरागमनम् — AND THE SECOND APPLICATION RESTORES IT.
--
--     `adesa f (adesa f v)` is `mk f f (samjna v)`: the second ādeśa puts
--     the same form in, and the form it displaces is that same form, so
--     the substitute stands for itself again.  By refl.
--
--     Whatever the first substitution destroyed is not destroyed further
--     by repeating it — which is why this is पुनरागमन and not merely
--     idempotence: the property returns, it is not preserved.
------------------------------------------------------------------------

द्विरादेशे-स्वस्थानी : (f : Rupa) (v : Varna) → स्वस्थानी (adesa f (adesa f v))
द्विरादेशे-स्वस्थानी f v = refl

------------------------------------------------------------------------
-- ४ · What the depth condition buys, at the sites where it holds.
--
--     `anal-blind` needs no hypothesis: an अनल्विधि cannot tell an ādeśa
--     from its sthānin, ever.  The gap the punaragamana module names is a
--     different comparison — the substitute against the ORIGINAL VARṆA —
--     and §४ closes it exactly where स्वस्थानी holds, which by §२ and §३ is
--     before the first substitution and at every repeated one.
------------------------------------------------------------------------

स्वस्थाने-अन्धः : {A : Type} (r : Varna → A) → AnalVidhi A r
                → (v : Varna) → स्वस्थानी v
                → (f : Rupa) → r (adesa f v) ≡ r v
स्वस्थाने-अन्धः r av v _ f = anal-blind r av f v

-- and at a doubled site, with no hypothesis to supply, by §३
द्विरादेशे-अन्धः : {A : Type} (r : Varna → A) → AnalVidhi A r
                → (f : Rupa) (v : Varna)
                → r (adesa f (adesa f v)) ≡ r (adesa f v)
द्विरादेशे-अन्धः r av f v = anal-blind r av f (adesa f v)
