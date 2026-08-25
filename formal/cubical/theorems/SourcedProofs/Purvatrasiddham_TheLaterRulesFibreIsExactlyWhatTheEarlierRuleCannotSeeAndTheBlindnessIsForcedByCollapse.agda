{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Pūrvatrāsiddham — the tripādī as a tower of maps, and the fibre as the
-- thing the earlier rule is forbidden to read.
--
-- THE SOURCE, with the sūtra numbers, so nothing here is recalled.
-- Pāṇini, *Aṣṭādhyāyī*, c. 500 BCE:
--
--   8.2.1   पूर्वत्रासिद्धम्  pūrvatrāsiddham — from this sūtra to the end of
--           the text, a rule is *asiddha*, "as if not having taken
--           effect", with respect to everything that PRECEDES it.  The
--           blindness is one-way and ordered: later output is invisible
--           backwards.
--   8.2.30  चोः कुः  coḥ kuḥ — cU becomes kU at pada-end.
--   8.2.39  झलां जशोऽन्ते  jhalāṃ jaśo 'nte — jhaL becomes jaŚ at pada-end.
--   8.4.56  वाऽवसाने  vā'vasāne — jhaL becomes caR in pause.
--
-- Kātyāyana's vārttikas c. 250 BCE and Patañjali's *Mahābhāṣya* c. 150 BCE
-- are the commentarial layer on 8.2.1; they are named, not used, here.
--
-- WHAT IS AND IS NOT CLAIMED OF PĀṆINI.  He states 8.2.1 and he states the
-- three operational sūtras.  He proves no theorem below.  The fibre-
-- theoretic statements — that the earlier rule's condition fails to
-- descend along the later rules, and that the failure is exactly a
-- non-contractible fibre — are mine, and they are a reading of what
-- asiddhatva accomplishes, not a translation of anything he wrote.  The
-- Sanskrit names on the theorems are labels in the vocabulary of the
-- object, not attributions.  Where a claim about the sūtras themselves is
-- made it is at sūtra level and is marked as such.
--
-- RECOGNITION BEFORE CONSTRUCTION, as this repository requires, and it
-- changed what this module is.  Three things were already here:
--
--   `Asiddhatva.agda`     — 8.2.1 buys TERMINATION: the unstratified
--                           system has no normal form and, sharply, no
--                           strict order orients it at all.
--   `AsiddhavatRegime.agda` — 8.2.1 (krama) and 6.4.22 (saha) are
--                           different devices and the choice CHANGES THE
--                           DERIVED FORM.
--   `ElsewhereCondition.agda` — utsarga/apavāda is logically INDEPENDENT
--                           of 1.4.2, proved by an equivariance argument.
--
-- So termination, regime and the metarule ordering are done, and none of
-- them is redone here.  What was not here is the structure the blindness
-- HAS.  And the instrument for it was already in the corpus and had never
-- been pointed at Pāṇini: `Sesa_TheCompositesRemainderIsTheSecondRemainder
-- SummedOverTheFirstAndTheAreasAdd.शेष` decomposes the fibre of a
-- composite.  The tripādī IS a composite — 8.2.1 makes the enumeration
-- order into function composition — so its blindness decomposes, rule by
-- rule, by a lemma already proved.  It is imported below, not restated.
--
-- THE READING, stated before the code so it can be disagreed with.
--
--   A rule earlier in the tripādī is applied to the form as it stood when
--   its turn came.  Later rules then act.  8.2.1 forbids the earlier rule
--   to look at what they produced.  The question this module asks is what
--   would be WRONG with looking, and the answer is not "it would loop"
--   (that is `Asiddhatva.agda`) but something prior:
--
--     THE EARLIER RULE'S CONDITION IS NOT A CONDITION ON THE LATER FORM.
--
--   It does not merely give a different answer there; it has no value
--   there.  `अवरोहणाभावः` proves that: there is NO Bool-valued function on
--   the later forms that agrees with 8.2.39's applicability, because
--   8.4.56 maps two forms that disagree about it to one form.  The two
--   disagreeing forms are the two points of one fibre, exhibited in
--   `तन्तुभेदः`.  So the fibre is not a metaphor for the invisible part —
--   it is, on the nose, the set of things the later form fails to
--   distinguish, and the earlier rule's condition is exactly a function on
--   it that does not descend.
--
--   The converse is proved too, and it is what makes the first half
--   content rather than an accident: `सर्वावरोहणम्` shows that if every
--   fibre is contractible then EVERY predicate descends, so asiddhatva
--   would be doing nothing.  Hence `असिद्धत्वहेतुः`: the necessity of 8.2.1
--   at this site is precisely that some later rule collapses two forms
--   into one.  It is derived from the two halves, not asserted.  At this
--   site both later rules collapse, and both witnesses are exhibited.
--
-- PRIOR ART, searched.  Asiddhatva read as rule suspension / level
-- ordering is documented (Kiparsky, "On the Architecture of Pāṇini's
-- Grammar", 2009; the elsewhere condition, Kiparsky 1973 — a restatement,
-- named here after the thing it restates).  Staged and layered rewriting
-- is standard (Bergstra–Klop; Ohlebusch on modularity of termination).
-- What I did not find is the descent formulation: the blindness as failure
-- of a predicate to factor through the later strata, with the obstruction
-- identified as the fibre and localised to a named sūtra.  If that is
-- stated somewhere I did not reach, this is a re-derivation and the
-- citation is owed.
--
-- SCOPE OF THE CARRIER, so the model is not read as more than it is.  The
-- carrier is the pada-final consonant of `vāc` ("speech") along the
-- trajectory the derivation actually takes, exactly as in
-- `Asiddhatva.agda`, and the rules are their restrictions to it.  `ca` is
-- never presented to 8.2.39 in a real derivation because 8.2.30 has
-- already removed it; that is not assumed, it is `कस्यापि-न-चः` below.
--
-- No postulates, no holes, --safe.  2026-08-22.
------------------------------------------------------------------------

module SourcedProofs.Purvatrasiddham_TheLaterRulesFibreIsExactlyWhatTheEarlierRuleCannotSeeAndTheBlindnessIsForcedByCollapse where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

import Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd as Sesa

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १.  The carrier and its separation.
------------------------------------------------------------------------

data Rupa : Type where
  ca ka ga : Rupa

isKa : Rupa → Bool
isKa ca = false
isKa ka = true
isKa ga = false

isCa : Rupa → Bool
isCa ca = true
isCa ka = false
isCa ga = false

ka≢ga : ¬ (ka ≡ ga)
ka≢ga p = true≢false (cong isKa p)

eqRupa : Rupa → Rupa → Bool
eqRupa ca ca = true
eqRupa ka ka = true
eqRupa ga ga = true
eqRupa _  _  = false

------------------------------------------------------------------------
-- २.  The three sūtras, each as the total function it is on this carrier.
--     Nothing is stated about forms off the trajectory; see the scope note.
------------------------------------------------------------------------

-- 8.2.30 चोः कुः
r30 : Rupa → Rupa
r30 ca = ka
r30 ka = ka
r30 ga = ga

-- 8.2.39 झलां जशोऽन्ते
r39 : Rupa → Rupa
r39 ca = ca
r39 ka = ga
r39 ga = ga

-- 8.4.56 वाऽवसाने
r56 : Rupa → Rupa
r56 ca = ca
r56 ka = ka
r56 ga = ka

-- 8.2.1 makes the text's enumeration order into composition.  Everything
-- after 8.2.30, as one map: this is what 8.2.30 is blind to.
after30 : Rupa → Rupa
after30 x = r56 (r39 x)

tripada : Rupa → Rupa
tripada x = after30 (r30 x)

-- vāc ↦ vāk, on the nose.  (The same derivation `Asiddhatva.agda` runs;
-- reproduced here only so the carrier is anchored to a real form.)
vak : tripada ca ≡ ka
vak = refl

-- `ca` is never presented to 8.2.39: it is not in 8.2.30's image.
कस्यापि-न-चः : (x : Rupa) → ¬ (r30 x ≡ ca)
कस्यापि-न-चः ca p = true≢false (sym (cong isCa p))
कस्यापि-न-चः ka p = true≢false (sym (cong isCa p))
कस्यापि-न-चः ga p = true≢false (sym (cong isCa p))

------------------------------------------------------------------------
-- ३.  8.2.39's applicability, DERIVED from the rule rather than tabulated:
--     "does 8.2.39 still change this form?"
------------------------------------------------------------------------

punar : Rupa → Bool
punar x = not (eqRupa (r39 x) x)

punar-ka : punar ka ≡ true
punar-ka = refl

punar-ga : punar ga ≡ false
punar-ga = refl

------------------------------------------------------------------------
-- ४.  THE FIBRE.  Two forms that 8.2.39 tells apart and the later rules
--     do not.  This is the invisible part, exhibited, not described.
------------------------------------------------------------------------

तन्तु-ka : fiber after30 ka
तन्तु-ka = ka , refl

तन्तु-ga : fiber after30 ka
तन्तु-ga = ga , refl

तन्तुभेदः : ¬ (तन्तु-ka ≡ तन्तु-ga)
तन्तुभेदः p = ka≢ga (cong fst p)

तन्तौ-नैकत्वम् : ¬ (isProp (fiber after30 ka))
तन्तौ-नैकत्वम् h = तन्तुभेदः (h तन्तु-ka तन्तु-ga)

तन्तौ-न-सङ्कोचः : ¬ (isContr (fiber after30 ka))
तन्तौ-न-सङ्कोचः c = तन्तौ-नैकत्वम् (isContr→isProp c)

------------------------------------------------------------------------
-- ५.  THE NON-DESCENT.  8.2.39's condition is not a condition on the form
--     the later rules leave behind.  Not "gives the wrong answer there" —
--     has no value there.
------------------------------------------------------------------------

अवरोहणाभावः : ¬ (Σ[ q ∈ (Rupa → Bool) ] ((x : Rupa) → q (after30 x) ≡ punar x))
अवरोहणाभावः (q , h) = true≢false (sym (h ka) ∙ h ga)

-- and the reason, isolated: the condition is not constant on the fibre.
समताभङ्गः : Σ[ x ∈ Rupa ] Σ[ y ∈ Rupa ]
              ((after30 x ≡ after30 y) × (¬ (punar x ≡ punar y)))
समताभङ्गः = ka , ga , refl , λ p → true≢false p

------------------------------------------------------------------------
-- ६.  THE CONVERSE, in general.  Fibre-constancy plus a section is enough
--     to descend, and contractible fibres are enough on their own.  These
--     are what make §५ content: the obstruction is the fibre and nothing
--     else.
------------------------------------------------------------------------

अवरोहणम् : {A : Type ℓ} {B : Type ℓ'}
           (f : A → B) (s : B → A) (sec : (b : B) → f (s b) ≡ b)
           (q : A → Bool)
           (fc : (x y : A) → f x ≡ f y → q x ≡ q y)
           → Σ[ q̄ ∈ (B → Bool) ] ((x : A) → q̄ (f x) ≡ q x)
अवरोहणम् f s sec q fc = (λ b → q (s b)) , λ x → fc (s (f x)) x (sec (f x))

सर्वावरोहणम् : {A : Type ℓ} {B : Type ℓ'}
              (f : A → B) → ((b : B) → isContr (fiber f b))
              → (q : A → Bool)
              → Σ[ q̄ ∈ (B → Bool) ] ((x : A) → q̄ (f x) ≡ q x)
सर्वावरोहणम् f cf q =
  (λ b → q (fst (fst (cf b))))
  , λ x → cong q (cong fst (snd (cf (f x)) (x , refl)))

------------------------------------------------------------------------
-- ७.  THE TOWER.  8.2.1 turns the text's order into composition, so the
--     earlier rule's blindness DECOMPOSES over the rules that follow it —
--     by the corpus's own composite-remainder lemma, imported, not
--     restated.  What 8.2.30 cannot see about the final form is what
--     8.4.56 cannot see, summed over what 8.2.39 cannot see beneath it.
------------------------------------------------------------------------

शेष-असिद्धम् : (z : Rupa)
              → fiber after30 z ≃ (Σ[ p ∈ fiber r56 z ] fiber r39 (fst p))
शेष-असिद्धम् = Sesa.शेष r56 r39

शून्य-असिद्धम् : ((z : Rupa) → isContr (fiber r39 z))
               → ((z : Rupa) → isContr (fiber r56 z))
               → (z : Rupa) → isContr (fiber after30 z)
शून्य-असिद्धम् = Sesa.शून्यशेष r56 r39

------------------------------------------------------------------------
-- ८.  THE NECESSITY, LOCALISED.  Put §५ against §६ and §७: if no later
--     rule collapsed anything, 8.2.39's condition would descend and 8.2.1
--     would be doing nothing at this site.  It does not, so some later
--     rule collapses.  This is derived; it is not a restatement of §४.
------------------------------------------------------------------------

असिद्धत्वहेतुः : ¬ (((z : Rupa) → isContr (fiber r39 z))
                 × ((z : Rupa) → isContr (fiber r56 z)))
असिद्धत्वहेतुः (c39 , c56) =
  अवरोहणाभावः (सर्वावरोहणम् after30 (शून्य-असिद्धम् c39 c56) punar)

-- and both of them do collapse, at this site, with the witnesses named.
-- 8.4.56 sends both ka and ga to ka:
सङ्कोचः-८-४-५६ : ¬ (isContr (fiber r56 ka))
सङ्कोचः-८-४-५६ c =
  ka≢ga (cong fst (isContr→isProp c (ka , refl) (ga , refl)))

-- 8.2.39 sends both ka and ga to ga:
सङ्कोचः-८-२-३९ : ¬ (isContr (fiber r39 ga))
सङ्कोचः-८-२-३९ c =
  ka≢ga (cong fst (isContr→isProp c (ka , refl) (ga , refl)))

------------------------------------------------------------------------
-- ९.  WHAT THIS DOES NOT SAY.
--
-- It does not say the later form is "less informative" in general — the
-- tripādī is deterministic and the final form is a function of the
-- earlier one.  The asymmetry is the other way: the earlier form is not a
-- function of the later one, and 8.2.39's condition lives on the earlier.
--
-- It does not say 8.2.1 is derivable from the collapse.  §८ gives one
-- direction only: collapse is NECESSARY for the blindness to have content
-- at this site.  Pāṇini states 8.2.1 as a metarule over the whole tripādī
-- and nothing here bears on why he stated it in that generality.
--
-- It does not model 6.4.22 असिद्धवदत्राभात्, the simultaneous regime.  That
-- is `AsiddhavatRegime.agda`, and the two are different devices; reading
-- them as one is the misattribution that file was written to correct.
------------------------------------------------------------------------
