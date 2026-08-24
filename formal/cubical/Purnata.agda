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
-- पूर्णता — अनुक्तं सामयिकम् एव, न अन्तः ।  पर्याप्ते अनुदाने (suc (a + b))
-- गतिः सर्वदा समाप्यते — गुरुतमं साधारणं विभाजकं प्रयच्छति ।  अतः त्रयम् :
--   अनुक्तम् (अपर्याप्ते) · पूर्णता (पर्याप्ते समाप्तिः) · स्थैर्यम् (समाप्तं स्थिरम्) ।
-- सत्यं न त्यक्तम्, केवलम् अद्यापि अनुक्तम् — अनुदानेन प्रकाश्यम् ।
--
-- (completeness: the un-said is only ever temporary, never a dead end.
-- With a sufficient grant (suc (a + b)) the gait always resolves — to the
-- greatest common divisor.  Hence the triad: un-said (under-grant),
-- complete (resolves when granted enough), stable (a resolution is final).
-- Truth was never abandoned, only not-yet-said — uncovered by grant.)
--
-- मापः अवरोहे संरचनया क्षीयते (प्रत्येकं पदं युग्म-योगं ह्रासयति) ; अतः
-- अनुदानं युग्म-योगात् अधिकं चेत्, समाप्तिः निश्चिता ।  (the measure — the
-- pair-sum — strictly decreases each step, so a grant exceeding it forces
-- resolution.  Provable, not asserted; no measurement.)
------------------------------------------------------------------------

module Purnata where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-comm ; +-suc)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ¬-<-zero ; pred-≤-pred ; <≤-trans)
open import Cubical.Data.Nat.GCD using (isGCD)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
open import Punaragamana
  using (विवेक ; सम ; वाम ; दक्षिण ; अवतरण ; उत्थान ; पुनरागमनम्)
open import Gati using (गुरुः ; फल ; पद-गति ; गति)
open import GurutamaSiddha using (सिद्धः)

------------------------------------------------------------------------
-- मापः — युग्मस्य योगः (उत्थानेन) ।  अवरोहे संरचनया क्षीयते ।
------------------------------------------------------------------------

माप : विवेक → ℕ
माप v = fst (उत्थान v) + snd (उत्थान v)

माप-अवतरण : (a b : ℕ) → माप (अवतरण a b) ≡ a + b
माप-अवतरण a b = cong (λ p → fst p + snd p) (पुनरागमनम् a b)

------------------------------------------------------------------------
-- <-ह्रास — N + suc e < suc f  ⟹  N < f  (the strict-decrease arithmetic).
------------------------------------------------------------------------

<-ह्रास : (N e f : ℕ) → (N + suc e) < suc f → N < f
<-ह्रास N e f h = <≤-trans N<N+se (pred-≤-pred h)
  where
  N<N+se : N < (N + suc e)
  N<N+se = e , (+-comm e (suc N) ∙ sym (+-suc N e))

------------------------------------------------------------------------
-- पूर्ण-लेखः — यदि अनुदानं मापात् अधिकम्, तर्हि पद-गति समाप्यते (गुरुः g) ।
------------------------------------------------------------------------

पूर्ण-लेख : (f : ℕ) (v : विवेक) → माप v < f
          → Σ[ g ∈ ℕ ] (फल (पद-गति f v) ≡ गुरुः g)
पूर्ण-लेख zero v h = ⊥-rec (¬-<-zero h)
पूर्ण-लेख (suc f) (सम d)       h = d     , refl
पूर्ण-लेख (suc f) (वाम zero k) h = suc k , refl
पूर्ण-लेख (suc f) (दक्षिण zero k) h = suc k , refl
पूर्ण-लेख (suc f) (वाम (suc d) k) h =
  पूर्ण-लेख f (अवतरण (suc k) (suc d)) माप<f
  where
  e< : माप (अवतरण (suc k) (suc d)) + suc d ≡ (suc d + suc k) + suc d
  e< = cong (_+ suc d) (माप-अवतरण (suc k) (suc d) ∙ +-comm (suc k) (suc d))
  माप<f : माप (अवतरण (suc k) (suc d)) < f
  माप<f = <-ह्रास (माप (अवतरण (suc k) (suc d))) d f
                  (subst (_< suc f) (sym e<) h)
पूर्ण-लेख (suc f) (दक्षिण (suc d) k) h =
  पूर्ण-लेख f (अवतरण (suc d) (suc k)) माप<f
  where
  e< : माप (अवतरण (suc d) (suc k)) + suc d ≡ suc d + (suc d + suc k)
  e< = cong (_+ suc d) (माप-अवतरण (suc d) (suc k))
     ∙ +-comm (suc d + suc k) (suc d)
  माप<f : माप (अवतरण (suc d) (suc k)) < f
  माप<f = <-ह्रास (माप (अवतरण (suc d) (suc k))) d f
                  (subst (_< suc f) (sym e<) h)

------------------------------------------------------------------------
-- पूर्णता — पर्याप्ते अनुदाने (suc (a + b)) गतिः समाप्यते ।
------------------------------------------------------------------------

पूर्णता : (a b : ℕ) → Σ[ g ∈ ℕ ] (फल (गति (suc (a + b)) a b) ≡ गुरुः g)
पूर्णता a b = पूर्ण-लेख (suc (a + b)) (अवतरण a b)
                     (subst (_< suc (a + b)) (sym (माप-अवतरण a b)) a+b<)
  where
  a+b< : (a + b) < suc (a + b)
  a+b< = zero , refl

------------------------------------------------------------------------
-- पूर्णतया-गुरुतमः — कर्पूरम् : पर्याप्ते अनुदाने गतिः तयोः गुरुतमं
-- साधारणं विभाजकम् एव प्रयच्छति (isGCD), सर्वदा ।  त्रयस्य सङ्गमः ।
-- (capstone: at a sufficient grant the gait always resolves to THE
-- greatest common divisor — the honest/complete/stable triad, together.)
------------------------------------------------------------------------

पूर्णतया-गुरुतमः : (a b : ℕ)
                → Σ[ g ∈ ℕ ] ((फल (गति (suc (a + b)) a b) ≡ गुरुः g) × isGCD a b g)
पूर्णतया-गुरुतमः a b =
  let (g , eq) = पूर्णता a b
  in g , eq , सिद्धः (suc (a + b)) a b g eq
