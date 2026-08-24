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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्थैर्यम् — समाहितं वचनं स्थिरम् ।  यत् गतिः पर्याप्तानुदानेन g इति वदति,
-- तत् अधिकानुदानेन अपि तत् एव g — न परावर्तते ।  स्यात्-वादः न अनिश्चयः :
-- पर्याप्त-भूमौ समाहितं सत्यं न चञ्चलम् ।  दुर्नयः निरपेक्षः चञ्चलः वा, न
-- स्यात्-वाक्यम् ।
--
-- (stability: a resolved utterance is steady.  What the pulverizer says is
-- g on a sufficient grant stays g under any larger grant — it does not
-- recant.  Syāt-vāda is NOT indecision: a truth resolved on adequate ground
-- does not waver.  Durnaya is the unconditional-or-fickle; the syāt-
-- conditioned assertion is neither.)
--
-- मूलम् : अनुदानं संरचनया अवरोहति ; समाप्तं मुखं (समाप्त) अनुदान-वृद्धौ न
-- चलति, पद-मुखं शेषे एव आश्रयते ।  अतः अधिक-अनुदानं समाप्तं न विकरोति ।
-- (root: fuel threads down structurally; a resolved head (समाप्त) is
-- independent of extra fuel, and a step-head defers to its tail — so more
-- grant cannot disturb a resolution.)
------------------------------------------------------------------------

module Sthairya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
open import Punaragamana using (विवेक ; सम ; वाम ; दक्षिण ; अवतरण)
open import Gati using (फल ; पद-गति ; गति ; गुरुः)
open import Gurutama using (क्षेत्र)

------------------------------------------------------------------------
-- फल-वृद्धौ — एकम् अधिकम् अनुदानं समाप्तं वचनं न विकरोति ।
-- (one extra grant does not alter a resolved utterance.)
------------------------------------------------------------------------

फल-वृद्धौ : (f : ℕ) (v : विवेक) (g : ℕ)
         → फल (पद-गति f v) ≡ गुरुः g
         → फल (पद-गति (suc f) v) ≡ गुरुः g
फल-वृद्धौ zero    v            g eq = ⊥-rec (subst क्षेत्र (sym eq) tt)
फल-वृद्धौ (suc f) (सम d)       g eq = eq
फल-वृद्धौ (suc f) (वाम zero k) g eq = eq
फल-वृद्धौ (suc f) (दक्षिण zero k) g eq = eq
फल-वृद्धौ (suc f) (वाम (suc d) k) g eq =
  फल-वृद्धौ f (अवतरण (suc k) (suc d)) g eq
फल-वृद्धौ (suc f) (दक्षिण (suc d) k) g eq =
  फल-वृद्धौ f (अवतरण (suc d) (suc k)) g eq

------------------------------------------------------------------------
-- स्थैर्य — यत्किञ्चित् अधिकम् अनुदानम् (n) समाप्तं वचनं न विकरोति ।
-- (any amount of extra grant leaves a resolved utterance unchanged.)
------------------------------------------------------------------------

स्थैर्य : (n f : ℕ) (v : विवेक) (g : ℕ)
       → फल (पद-गति f v) ≡ गुरुः g
       → फल (पद-गति (n + f) v) ≡ गुरुः g
स्थैर्य zero    f v g eq = eq
स्थैर्य (suc n) f v g eq = फल-वृद्धौ (n + f) v g (स्थैर्य n f v g eq)

------------------------------------------------------------------------
-- स्थैर्य-गति — गतेः स्तरे : समाहितं g अधिकानुदानेन अपि तत् एव ।
-- (at the gait level: a resolved g stays g under a larger grant.)
------------------------------------------------------------------------

स्थैर्य-गति : (n f a b g : ℕ)
           → फल (गति f a b) ≡ गुरुः g
           → फल (गति (n + f) a b) ≡ गुरुः g
स्थैर्य-गति n f a b g eq = स्थैर्य n f (अवतरण a b) g eq
