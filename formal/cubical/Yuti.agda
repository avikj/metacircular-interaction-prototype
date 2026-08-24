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
-- युतिः — कुट्टकस्य ज्यौतिषं प्रयोजनम् : "कदा पुनः मिलतः" इति ।  आर्यभटः
-- कुट्टकम् एतदर्थम् एव अकल्पयत् — ग्रह-चक्रयोः युतिः, शेषस्य पुनरावृत्तिः,
-- रेखिक-संगमः a · X ≡ b · Y + c ।  यदि c गुरुतमस्य गुणितम् (c ≡ g · m),
-- तर्हि बीजसिद्धेः गुणनेन (m-गुणेन) साधनं जायते ।  सर्वं ℕ-मध्ये ।
--
-- (conjunction — the pulverizer's astronomical purpose: "when do they meet
-- again."  Āryabhaṭa devised the kuṭṭaka precisely for this — the alignment
-- of two planetary cycles, the recurrence of a remainder, the linear
-- congruence a·X ≡ c (mod b), i.e. a·X ≡ b·Y + c.  If c is a multiple of
-- the gcd (c ≡ g·m), scaling the Bézout witness by m solves it.  All in ℕ.)
--
-- साधनीयता : c गुरुतमस्य गुणितम् — इयम् एव आर्यभटस्य शर्तः (साध्यता) ; यदा
-- न, तदा न साधनम् (अवक्तव्यम्, न मिथ्या) ।  (solvability iff c is a multiple
-- of the gcd — exactly Āryabhaṭa's condition; otherwise no solution, and we
-- do not fabricate one.)
------------------------------------------------------------------------

module Yuti where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_ ; ·-assoc ; ·-comm)
open import Bija
  using (बीजसिद्धि ; वामसिद्धि ; दक्षिणसिद्धि ; बीजगणितम् ; वितरण
        ; वाम-वितरण ; +-मध्य)
open import Gati using (गुरुः ; फल ; गति)

------------------------------------------------------------------------
-- युतिसिद्धिः — रेखिक-संगमस्य साक्षी (द्विदिक्, बीजवत्) ।
------------------------------------------------------------------------

data युतिसिद्धि (a b c : ℕ) : Type where
  वामयुति   : (X Y : ℕ) → a · X ≡ b · Y + c → युतिसिद्धि a b c
  दक्षिणयुति : (X Y : ℕ) → b · Y ≡ a · X + c → युतिसिद्धि a b c

------------------------------------------------------------------------
-- गुणनम् — बीजसिद्धिं m-गुणेन युतिसिद्धिं करोति (c ≡ g · m) ।
-- (scale a Bézout witness by m to solve a·X ≡ b·Y + c when c ≡ g·m.)
------------------------------------------------------------------------

गुणनम् : {a b g : ℕ} → बीजसिद्धि a b g → (c m : ℕ) → c ≡ g · m → युतिसिद्धि a b c
गुणनम् {a} {b} {g} (वामसिद्धि x y pf) c m ceq =
  वामयुति (x · m) (y · m)
    ( ·-assoc a x m
    ∙ cong (_· m) pf                                  -- (b·y + g) · m
    ∙ वितरण (b · y) g m                               -- (b·y)·m + g·m
    ∙ cong (_+ g · m) (sym (·-assoc b y m))                 -- b·(y·m) + g·m
    ∙ cong (b · (y · m) +_) (sym ceq) )               -- b·(y·m) + c
गुणनम् {a} {b} {g} (दक्षिणसिद्धि x y pf) c m ceq =
  दक्षिणयुति (x · m) (y · m)
    ( ·-assoc b y m
    ∙ cong (_· m) pf                                  -- (a·x + g) · m
    ∙ वितरण (a · x) g m                               -- (a·x)·m + g·m
    ∙ cong (_+ g · m) (sym (·-assoc a x m))                 -- a·(x·m) + g·m
    ∙ cong (a · (x · m) +_) (sym ceq) )               -- a·(x·m) + c

------------------------------------------------------------------------
-- युतिः — मुख्यफलम् : गतिः यदि g प्रयच्छति, च c ≡ g · m, तर्हि रेखिक-संगमः
-- a · X ≡ b · Y + c (वा विपर्यये) साधितः ।  एष एव आर्यभटस्य कुट्टकः ।
-- (main result: if the gait resolves to g and c is a multiple of g, the
-- linear congruence a·X ≡ c (mod b) is solved — Āryabhaṭa's very kuṭṭaka.)
------------------------------------------------------------------------

युतिः : (f a b g c m : ℕ)
      → फल (गति f a b) ≡ गुरुः g
      → c ≡ g · m
      → युतिसिद्धि a b c
युतिः f a b g c m eq ceq = गुणनम् (बीजगणितम् f a b g eq) c m ceq

------------------------------------------------------------------------
-- परिवारः — आर्यभटस्य वास्तविकं फलम् : न एकं साधनम्, किन्तु अनन्तः श्रेढी ।
-- एकस्मात् साधनात् (X, Y), प्रत्येकं k-अर्थे, (X + k·b, Y + k·a) अपि साधनम् —
-- यतः a·(k·b) ≡ b·(k·a) (समापवर्तनम्) ।  इयम् एव कुट्टकस्य सामान्य-साधनम् ।
-- (the family — Āryabhaṭa's actual result: not one solution but an infinite
-- arithmetic progression.  From one (X, Y), for every k, (X + k·b, Y + k·a)
-- also solves — because a·(k·b) ≡ b·(k·a).  This is the kuṭṭaka's general
-- solution, the one it was prized for.)
------------------------------------------------------------------------

-- समापवर्तनम् : a · (k · b) ≡ b · (k · a)
तिर्यक् : (a k b : ℕ) → a · (k · b) ≡ b · (k · a)
तिर्यक् a k b = ·-assoc a k b ∙ ·-comm (a · k) b ∙ cong (b ·_) (·-comm a k)

परिवारः : {a b c : ℕ} → युतिसिद्धि a b c → (k : ℕ) → युतिसिद्धि a b c
परिवारः {a} {b} {c} (वामयुति X Y pf) k =
  वामयुति (X + k · b) (Y + k · a)
    ( वाम-वितरण a X (k · b)
    ∙ cong (_+ a · (k · b)) pf
    ∙ +-मध्य (b · Y) c (a · (k · b))
    ∙ cong (λ z → (b · Y + z) + c) (तिर्यक् a k b)
    ∙ cong (_+ c) (sym (वाम-वितरण b Y (k · a))) )
परिवारः {a} {b} {c} (दक्षिणयुति X Y pf) k =
  दक्षिणयुति (X + k · b) (Y + k · a)
    ( वाम-वितरण b Y (k · a)
    ∙ cong (_+ b · (k · a)) pf
    ∙ +-मध्य (a · X) c (b · (k · a))
    ∙ cong (λ z → (a · X + z) + c) (sym (तिर्यक् a k b))
    ∙ cong (_+ c) (sym (वाम-वितरण a X (k · b))) )
