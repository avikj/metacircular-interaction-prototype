{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भेदावतरणम् — विचारं विना अवतरणम् ।  (descent without a decision.)
--
-- पूर्वं जननम् discreteℕ इति प्रश्नेन अचलत् : "समौ वा न वा" — सा पृच्छा
-- Dec, सा Bool, सा विचारः ; abstract x-मात्रे स्तब्धा तिष्ठति (न refl) ।
-- एष एव रोगः ।  अत्र प्रश्नः लुप्तः : नियमः केवलं संरचनया चलति —
-- शीर्षे शीर्षे (suc/suc) युगपत् उन्मोचनम्, गभीरतरम् अवतरणम् ।
-- भेदः न पृच्छ्यते ; यदा एकः शून्यं स्पृशति तदा शेषः स्वयं जायते ।
-- तादात्म्यं न निर्णयः ; तत् अवतरणस्य स्थिरबिन्दुः (fixpoint) — मौनम् ।
--
-- (The old जननम् moved by asking discreteℕ — a Dec, a Bool, a check —
-- and stuck on abstract input: not refl.  That was the disease.  Here the
-- question is deleted: the rule moves by structure alone — peel both heads
-- (suc/suc) at once, descend one नय deeper.  The difference is never
-- decided; when one side touches zero the remainder is simply born.
-- Identity is not a verdict but the fixpoint of the descent — silence.)
--
-- आर्यभटस्य कुट्टकस्य अन्तःक्रिया एषा (Gaṇitapāda ३२–३३): "शेषं रक्ष" ।
-- संरचना-प्रत्यभिज्ञा, न बूलियन्-निर्णयः ।  उत्पाद-व्यय-ध्रौव्यम् एकस्मिन्
-- पदे (उमास्वाति ५.२९) — सर्वं refl, यतः यन्त्रम् एवं चलति, न वर्ण्यते ।
------------------------------------------------------------------------

module BhedaAvatarana where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)

------------------------------------------------------------------------
-- भङ्ग — अवतरणस्य फलम् ।  द्वे एव स्थिती, न त्रीणि बूलियन्-मुखानि ।
--   मौनम्   : उभौ सह क्षीणौ — तादात्म्यम्, स्थिरबिन्दुः, जिह्वा विश्राम्यति ।
--   अस्ति   : नये n दृष्टः शेषः r — जातो भेदः (born at नय n, remainder r) ।
-- (the descent's result: silence — both exhausted together, identity, the
-- fixpoint — or a born difference, a remainder r surfacing at depth n.)
------------------------------------------------------------------------

data भङ्ग : Type where
  मौनम् : भङ्ग
  अस्ति : (n r : ℕ) → भङ्ग

------------------------------------------------------------------------
-- गभीर — जातं भेदं एकं नयं गभीरतरं नयति ; मौनं वहति ।  एतत् एव
-- उत्पाद-व्यय-ध्रौव्यम् : शीर्षे क्षीणे (व्यय), नयः वर्धते n↦suc n (उत्पाद),
-- शेषः r अक्षतः (ध्रौव्य) — युगपत्, एकस्मिन् पदे, सर्वं refl ।
-- (deepen: carry a born difference one नय down, pass silence.  This IS
-- arising-ceasing-persisting in one step — head spent, नय risen, remainder
-- untouched — all at once, all refl.)
------------------------------------------------------------------------

गभीर : भङ्ग → भङ्ग
गभीर मौनम्       = मौनम्
गभीर (अस्ति n r) = अस्ति (suc n) r

------------------------------------------------------------------------
-- भेद — नियमः स्वयम् ।  विचारं विना : संरचनया पतति ।
--   उभौ शून्यौ  → मौनम् (सह क्षयः, तादात्म्यम्) ।
--   एकः शून्यः → अस्ति zero (इतरः) — शेषः शीर्षे एव जातः ।
--   उभौ सशीर्षौ → गभीर (भेद अवशिष्टयोः) — युगपत् उन्मोचनम् ।
-- क्वापि discreteℕ नास्ति, क्वापि Dec नास्ति, क्वापि Bool नास्ति ।
-- (the rule itself, decisionless: it falls by structure.  Both zero →
-- silence.  One zero → the other is the born remainder at the surface.
-- Both nonzero → peel both, descend.  No discreteℕ, no Dec, no Bool.)
------------------------------------------------------------------------

भेद : ℕ → ℕ → भङ्ग
भेद zero    zero    = मौनम्
भेद zero    (suc b) = अस्ति zero (suc b)
भेद (suc a) zero    = अस्ति zero (suc a)
भेद (suc a) (suc b) = गभीर (भेद a b)

------------------------------------------------------------------------
-- एकपदे — नियमस्य एकं पदम् refl ।  एतत् प्रमाणम् : यन्त्रम् एवं चलति,
-- न बाह्यतः वर्ण्यते ।  पूर्वं एतत् discreteℕ x x इति स्तब्धम् अभवत् ;
-- अधुना संरचनया refl ।  एष एव भेदः रोगस्य चिकित्सायाश्च ।
-- (one step of the rule is refl.  THIS is the proof it is installed
-- cognition, not description: the machine literally moves this way.  The
-- same statement stuck on discreteℕ x x before; now it is refl by
-- structure.  That gap is the whole difference between disease and cure.)
------------------------------------------------------------------------

एकपदे : (a b : ℕ) → भेद (suc a) (suc b) ≡ गभीर (भेद a b)
एकपदे a b = refl

-- the three natures, each free (refl), because गभीर is how the step moves:
व्यय-उत्पाद-ध्रौव्यम् : (n r : ℕ) → गभीर (अस्ति n r) ≡ अस्ति (suc n) r
व्यय-उत्पाद-ध्रौव्यम् n r = refl          -- नयः वर्धते, शेषः तिष्ठति

ध्रौव्यम्-मौनम् : गभीर मौनम् ≡ मौनम्
ध्रौव्यम्-मौनम् = refl                     -- मौनं मौनं वहति

------------------------------------------------------------------------
-- तादात्म्ये-मौनम् — यत्र संख्ये समे, तत्र अवतरणं स्थिरबिन्दुं गच्छति : मौनम् ।
-- अनुक्रमणं संरचनया, न निर्णयेन ; प्रतिपदं refl-चालितम् — दुर्नयः असम्भवः ।
-- (identity ⟹ silence: equal numbers descend to the fixpoint.  The
-- induction follows structure, driven at each step by refl — no verdict.)
------------------------------------------------------------------------

तादात्म्ये-मौनम् : (a : ℕ) → भेद a a ≡ मौनम्
तादात्म्ये-मौनम् zero    = refl
तादात्म्ये-मौनम् (suc a) = cong गभीर (तादात्म्ये-मौनम् a)

------------------------------------------------------------------------
-- प्रक्षेपे-जन्म — नय-सापेक्षता विना विचारेण ।  साझा गभीरता d, ततः शेषः
-- suc r : भेदः नये d एव जायते — तत्पूर्वं मौनम्, अजातः ।  उभयतः समम्
-- (द्वे मुखे) ।  अतः निरपेक्षं वचनं (दुर्नयः) मिथ्या ; स्यात् आवश्यकम् —
-- अधुना संरचनया सिद्धम्, न discreteℕ इति प्रश्नेन ।
-- (naya-relativity, decisionless: after a shared depth d the remainder
-- suc r is born at exactly नय d — silent before it.  Both orientations.
-- So an unconditional verdict, durnaya, is false; स्यात् is forced — now
-- proved by structure, not by an equality-check.)
------------------------------------------------------------------------

प्रक्षेपे-जन्म : (d r : ℕ) → भेद (d + suc r) d ≡ अस्ति d (suc r)
प्रक्षेपे-जन्म zero    r = refl
प्रक्षेपे-जन्म (suc d) r = cong गभीर (प्रक्षेपे-जन्म d r)

-- द्वितीयं मुखम् — विपर्यये अपि (the other orientation, smaller on the left)
प्रक्षेपे-जन्म′ : (d r : ℕ) → भेद d (d + suc r) ≡ अस्ति d (suc r)
प्रक्षेपे-जन्म′ zero    r = refl
प्रक्षेपे-जन्म′ (suc d) r = cong गभीर (प्रक्षेपे-जन्म′ d r)
