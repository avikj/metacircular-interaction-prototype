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
-- बीजम् — कुट्टकस्य वास्तविकं प्रयोजनम् : रेखिक-समीकरणस्य साधनम् ।
-- (गुरुतमः तु उपफलम् एव ।)  आर्यभटः ऋणसंख्याः न प्रायुङ्क्त — वल्ल्याः
-- पर्याय-दिशा (alternating orientation) एव तत् साधयति ।  अतः अत्र सर्वं
-- ℕ-मध्ये : प्रतिपादे गुणकौ केवलं सङ्कलनेन आरोहतः, दिशा च समाप्तेः निर्णीता ।
--
-- बीजसिद्धिः द्विधा (वल्ल्याः पर्यायः) :
--   वामसिद्धिः  x y : a · x ≡ b · y + g
--   दक्षिणसिद्धिः x y : b · y ≡ a · x + g
-- (Bézout, the pulverizer's real purpose — gcd is only a byproduct.
-- Āryabhaṭa used no negatives: the vallī's alternating orientation solves
-- it.  So everything stays in ℕ — coefficients climb by pure addition, the
-- orientation fixed by the terminal.  Two forms, the vallī's alternation.)
--
-- सूचना : "गुरुतमः g" इति अत्र न पुनःसिद्धम् (तत् GurutamaSiddha) ; अत्र
-- केवलं रेखिक-संयोगः a·x, b·y, g-सहितः ।  (here only the linear relation is
-- proved, for the SAME resolved g; that g is the gcd is GurutamaSiddha.)
------------------------------------------------------------------------

module Bija where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-assoc ; +-comm ; ·-comm ; ·-identityʳ)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
open import Cubical.Data.Unit using (tt)
open import Punaragamana
  using (विवेक ; सम ; वाम ; दक्षिण ; अवतरण ; उत्थान ; पुनरागमनम्)
open import Gati using (गुरुः ; फल ; पद-गति ; गति)
open import Gurutama using (क्षेत्र ; मान)

------------------------------------------------------------------------
-- ℕ-बीजगणित-सहायाः (the ℕ algebra we need — all self-contained).
------------------------------------------------------------------------

-- दक्षिण-वितरणम् : (a + b) · m ≡ a · m + b · m
वितरण : (a b m : ℕ) → (a + b) · m ≡ (a · m) + (b · m)
वितरण zero    b m = refl
वितरण (suc a) b m = cong (m +_) (वितरण a b m) ∙ +-assoc m (a · m) (b · m)

-- वाम-वितरणम् : a · (x + y) ≡ a · x + a · y
वाम-वितरण : (a x y : ℕ) → a · (x + y) ≡ (a · x) + (a · y)
वाम-वितरण a x y =
  ·-comm a (x + y) ∙ वितरण x y a ∙ cong₂ _+_ (·-comm x a) (·-comm y a)

-- मध्यविनिमयः : (p + g) + q ≡ (p + q) + g
+-मध्य : (p g q : ℕ) → (p + g) + q ≡ (p + q) + g
+-मध्य p g q = sym (+-assoc p g q) ∙ cong (p +_) (+-comm g q) ∙ +-assoc p q g

------------------------------------------------------------------------
-- बीजसिद्धिः — रेखिक-संयोगस्य साक्षी, द्विदिक् (वल्ल्याः पर्यायः) ।
------------------------------------------------------------------------

data बीजसिद्धि (a b g : ℕ) : Type where
  वामसिद्धि   : (x y : ℕ) → a · x ≡ b · y + g → बीजसिद्धि a b g
  दक्षिणसिद्धि : (x y : ℕ) → b · y ≡ a · x + g → बीजसिद्धि a b g

------------------------------------------------------------------------
-- आरोहणे पदे : गुणकौ सङ्कलनेन वर्धेते, दिशा रक्ष्यते ।
--   वाम-चढ : (a', b) → (b + a', b)   [युग्मं a = b + a' रूपे]  X=x, Y=y+x
--   दक्षिण-चढ : (a, b') → (a, a + b')  [युग्मं b = a + b' रूपे]  X=x+y, Y=y
------------------------------------------------------------------------

वाम-चढ : {a' b g : ℕ} → बीजसिद्धि a' b g → बीजसिद्धि (b + a') b g
वाम-चढ {a'} {b} {g} (वामसिद्धि x y pf) =
  वामसिद्धि x (y + x)
    ( वितरण b a' x
    ∙ cong (b · x +_) pf
    ∙ ( +-assoc (b · x) (b · y) g )              -- (b·x + b·y) + g
    ∙ cong (_+ g) (+-comm (b · x) (b · y))       -- (b·y + b·x) + g
    ∙ cong (_+ g) (sym (वाम-वितरण b y x)) )      -- b·(y+x) + g
वाम-चढ {a'} {b} {g} (दक्षिणसिद्धि x y pf) =
  दक्षिणसिद्धि x (y + x)
    ( वाम-वितरण b y x                             -- b·(y+x) ≡ b·y + b·x
    ∙ cong (_+ b · x) pf                          -- (a'·x + g) + b·x
    ∙ +-मध्य (a' · x) g (b · x)                    -- (a'·x + b·x) + g
    ∙ cong (_+ g) (sym (वितरण a' b x))            -- (a'+b)·x + g
    ∙ cong (λ z → z · x + g) (+-comm a' b) )      -- (b+a')·x + g

दक्षिण-चढ : {a b' g : ℕ} → बीजसिद्धि a b' g → बीजसिद्धि a (a + b') g
दक्षिण-चढ {a} {b'} {g} (वामसिद्धि x y pf) =
  वामसिद्धि (x + y) y
    ( वाम-वितरण a x y                             -- a·(x+y) ≡ a·x + a·y
    ∙ cong (_+ a · y) pf                          -- (b'·y + g) + a·y
    ∙ +-मध्य (b' · y) g (a · y)                    -- (b'·y + a·y) + g
    ∙ cong (_+ g) (+-comm (b' · y) (a · y))       -- (a·y + b'·y) + g
    ∙ cong (_+ g) (sym (वितरण a b' y)) )          -- (a+b')·y + g
दक्षिण-चढ {a} {b'} {g} (दक्षिणसिद्धि x y pf) =
  दक्षिणसिद्धि (x + y) y
    ( वितरण a b' y                                -- (a+b')·y ≡ a·y + b'·y
    ∙ cong (a · y +_) pf                          -- a·y + (a·x + g)
    ∙ +-assoc (a · y) (a · x) g                   -- (a·y + a·x) + g
    ∙ cong (_+ g) (+-comm (a · y) (a · x))        -- (a·x + a·y) + g
    ∙ cong (_+ g) (sym (वाम-वितरण a x y)) )       -- a·(x+y) + g

------------------------------------------------------------------------
-- बीज — आरोहणम् : यस्मिन् लेखे g समाहितम्, तत्र बीजसिद्धिः तस्य युग्मस्य ।
------------------------------------------------------------------------

बीज : (f : ℕ) (v : विवेक) (g : ℕ) → फल (पद-गति f v) ≡ गुरुः g
    → बीजसिद्धि (fst (उत्थान v)) (snd (उत्थान v)) g
बीज zero v g eq = ⊥-rec (subst क्षेत्र (sym eq) tt)
-- समे : (d, d), g ≡ d ; वामसिद्धि 1 0 : d·1 ≡ d·0 + d
बीज (suc f) (सम d) g eq =
  subst (λ z → बीजसिद्धि d d z) (cong मान eq)
    (वामसिद्धि 1 0 (·-identityʳ d ∙ sym (cong (_+ d) (·-comm d 0))))
-- वाम-शून्ये : (suc k, 0), g ≡ suc k ; वामसिद्धि 1 0 : (suc k)·1 ≡ 0·0 + suc k
बीज (suc f) (वाम zero k) g eq =
  subst (λ z → बीजसिद्धि (suc k) zero z) (cong मान eq)
    (वामसिद्धि 1 0 (·-identityʳ (suc k)))
-- दक्षिण-शून्ये : (0, suc k), g ≡ suc k ; दक्षिणसिद्धि 0 1 : (suc k)·1 ≡ 0·0 + suc k
बीज (suc f) (दक्षिण zero k) g eq =
  subst (λ z → बीजसिद्धि zero (suc k) z) (cong मान eq)
    (दक्षिणसिद्धि 0 1 (·-identityʳ (suc k)))
-- वाम-पदे : युग्मं (suc d + suc k, suc d) = (b + a', b), a'=suc k, b=suc d
बीज (suc f) (वाम (suc d) k) g eq =
  वाम-चढ (subst (λ p → बीजसिद्धि (fst p) (snd p) g)
                (पुनरागमनम् (suc k) (suc d))
                (बीज f (अवतरण (suc k) (suc d)) g eq))
-- दक्षिण-पदे : युग्मं (suc d, suc d + suc k) = (a, a + b'), a=suc d, b'=suc k
बीज (suc f) (दक्षिण (suc d) k) g eq =
  दक्षिण-चढ (subst (λ p → बीजसिद्धि (fst p) (snd p) g)
                  (पुनरागमनम् (suc d) (suc k))
                  (बीज f (अवतरण (suc d) (suc k)) g eq))

------------------------------------------------------------------------
-- बीजगणितम् — मुख्यफलम् : गतिः यदि g प्रयच्छति, तर्हि रेखिक-संयोगः
-- a·x ≡ b·y + g  (वा विपर्यये) ℕ-मध्ये सिद्धः ।  एष एव कुट्टकः ।
-- (main result: if the gait resolves to g, then the linear relation
-- a·x ≡ b·y + g (or its mirror) holds in ℕ — this IS the pulverizer.)
------------------------------------------------------------------------

बीजगणितम् : (f a b g : ℕ) → फल (गति f a b) ≡ गुरुः g → बीजसिद्धि a b g
बीजगणितम् f a b g eq =
  subst (λ p → बीजसिद्धि (fst p) (snd p) g)
        (पुनरागमनम् a b)
        (बीज f (अवतरण a b) g eq)
