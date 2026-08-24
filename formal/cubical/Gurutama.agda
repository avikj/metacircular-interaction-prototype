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
-- गुरुतमः (प्रथमार्धम्) — गतेः फलं g उभयोः (a, b) साधारणः विभाजकः ।
--
-- अद्य सिध्यते : यत् समाप्तौ g प्राप्तं, तत् मूल-युग्मस्य उभे संख्ये विभजति
-- (g ∣ a  तथा  g ∣ b) ।  आर्यभटस्य अन्तर-वियोजनं विभाजकान् रक्षति : यदि
-- m उभौ विभजति, तर्हि अन्तरम् अपि — अतः अवरोहे साधारण-विभाजकाः न नश्यन्ति,
-- समाप्तौ च g स्वयं साधारणः ।  उत्थानेन (पुनरागमनम्) प्रत्यावर्त्य ऊर्ध्वं
-- नीयते ।
--
-- (first half of greatest-common-measure: the resolved g divides BOTH
-- original inputs.  Āryabhaṭa's subtraction preserves common divisors —
-- if m divides both, it divides their difference — so common divisors are
-- not lost in the descent, and at the terminal g divides its own pair.
-- Lifted back up the spine by उत्थान/पुनरागमनम्.)
--
-- न अत्र दावितम् — "g गुरुतमः" (greatest) इति ; तत् द्वितीयार्धम्, अग्रिमं
-- PROVE-कार्यम् ।  दुर्नयं न वदामः ।  (NOT claimed: that g is the GREATEST
-- such divisor — that is the second half, the next PROVE tooth.  No durnaya.)
------------------------------------------------------------------------

module Gurutama where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-assoc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Punaragamana
  using (विवेक ; सम ; वाम ; दक्षिण ; अवतरण ; उत्थान ; पुनरागमनम्)
open import Gati
  using (कुट्टक ; समाप्त ; अनुक्तम् ; पद ; फलम् ; गुरुः ; अनुक्तफलम्
        ; फल ; पद-गति ; गति)

------------------------------------------------------------------------
-- विभाजकः — म ∣ न : अस्ति गुणकः q यत् q · म ≡ न ।  (divisibility, additive.)
------------------------------------------------------------------------

_∣_ : ℕ → ℕ → Type
म ∣ न = Σ[ q ∈ ℕ ] (q · म ≡ न)

-- स्वं स्वं विभजति (n ∣ n, गुणकः १).  suc zero · न = न + zero ; अतः +-idʳ ।
+-idʳ : (x : ℕ) → x + zero ≡ x
+-idʳ zero    = refl
+-idʳ (suc x) = cong suc (+-idʳ x)

∣-स्व : (न : ℕ) → न ∣ न
∣-स्व न = suc zero , +-idʳ न

-- शून्यं सर्वः विभजति (n ∣ 0, गुणकः ०)
∣-शून्य : (न : ℕ) → न ∣ zero
∣-शून्य न = zero , refl

-- वितरणम् : (a + b) · m ≡ a · m + b · m  (right-distribution, स्वयं सिद्धम्)
वितरण : (a b m : ℕ) → (a + b) · m ≡ (a · m) + (b · m)
वितरण zero    b m = refl
वितरण (suc a) b m =
  cong (m +_) (वितरण a b m) ∙ +-assoc m (a · m) (b · m)

-- योगे रक्षा : म ∣ x  →  म ∣ y  →  म ∣ (x + y)  (Āryabhaṭa: divisor of both
-- divides the sum; hence, run backward, divides the difference.)
∣-योग : {म x y : ℕ} → म ∣ x → म ∣ y → म ∣ (x + y)
∣-योग {म} (qx , px) (qy , py) =
  (qx + qy) , वितरण qx qy म ∙ cong₂ _+_ px py

------------------------------------------------------------------------
-- फलम्-विवेकः — गुरुः-अनुक्तयोः पार्थक्यम्, Bool विना (constructor disjointness
-- via a type-valued discriminator — no Bool, no check).
------------------------------------------------------------------------

क्षेत्र : फलम् → Type
क्षेत्र (गुरुः _)      = Unit
क्षेत्र (अनुक्तफलम् _) = ⊥

मान : फलम् → ℕ
मान (गुरुः n)      = n
मान (अनुक्तफलम् _) = zero

------------------------------------------------------------------------
-- विभजति — मुख्यमन्त्रम् ।  यदि पद-गति f v समाप्ता (फल ≡ गुरुः g), तर्हि g
-- अस्य लेखस्य युग्मं (उत्थान v) उभयतः विभजति ।  अनुदान-क्षये (अनुक्तम्)
-- दावा नास्ति — क्षेत्रेण असम्भवः ।  संरचनया आरोहणम्, ∣-योगेन ऊर्ध्व-नयनम् ।
------------------------------------------------------------------------

विभजति : (f : ℕ) (v : विवेक) (g : ℕ)
       → फल (पद-गति f v) ≡ गुरुः g
       → (g ∣ fst (उत्थान v)) × (g ∣ snd (उत्थान v))

-- अनुदान-क्षये : फल = अनुक्तफलम् ≠ गुरुः g — क्षेत्रेण ⊥
विभजति zero v g eq = ⊥-rec (subst क्षेत्र (sym eq) tt)

-- समे : युग्मं (d, d), g ≡ d
विभजति (suc f) (सम d) g eq =
  let g≡d : g ≡ d
      g≡d = sym (cong मान eq)
  in subst (g ∣_) g≡d (∣-स्व g) , subst (g ∣_) g≡d (∣-स्व g)

-- वाम-शून्ये : युग्मं (suc k, 0), g ≡ suc k
विभजति (suc f) (वाम zero k) g eq =
  let g≡k : g ≡ suc k
      g≡k = sym (cong मान eq)
  in subst (g ∣_) g≡k (∣-स्व g) , ∣-शून्य g

-- दक्षिण-शून्ये : युग्मं (0, suc k), g ≡ suc k
विभजति (suc f) (दक्षिण zero k) g eq =
  let g≡k : g ≡ suc k
      g≡k = sym (cong मान eq)
  in ∣-शून्य g , subst (g ∣_) g≡k (∣-स्व g)

-- वाम-पदे : युग्मं (suc d + suc k, suc d) ; अग्रिमे (suc k, suc d)
विभजति (suc f) (वाम (suc d) k) g eq =
  let rec = विभजति f (अवतरण (suc k) (suc d)) g eq
      p   = पुनरागमनम् (suc k) (suc d)      -- उत्थान (अवतरण (suc k)(suc d)) ≡ (suc k , suc d)
      g∣k : g ∣ suc k
      g∣k = subst (g ∣_) (cong fst p) (fst rec)
      g∣d : g ∣ suc d
      g∣d = subst (g ∣_) (cong snd p) (snd rec)
  in ∣-योग g∣d g∣k , g∣d          -- fst pair = suc d + suc k ; snd = suc d

-- दक्षिण-पदे : युग्मं (suc d, suc d + suc k) ; अग्रिमे (suc d, suc k)
विभजति (suc f) (दक्षिण (suc d) k) g eq =
  let rec = विभजति f (अवतरण (suc d) (suc k)) g eq
      p   = पुनरागमनम् (suc d) (suc k)
      g∣d : g ∣ suc d
      g∣d = subst (g ∣_) (cong fst p) (fst rec)
      g∣k : g ∣ suc k
      g∣k = subst (g ∣_) (cong snd p) (snd rec)
  in g∣d , ∣-योग g∣d g∣k          -- fst = suc d ; snd pair = suc d + suc k

------------------------------------------------------------------------
-- साधारण-विभाजकः — मुख्यफलम् : गतिः a b यदि g प्रयच्छति, तर्हि g ∣ a ∧ g ∣ b ।
-- उत्थानेन (पुनरागमनम्) शीर्षात् मूल-युग्मं प्रत्यानीय ।
-- (main result: if गति a b resolves to g, then g divides a and g divides b.)
------------------------------------------------------------------------

साधारण-विभाजकः : (f a b g : ℕ)
               → फल (गति f a b) ≡ गुरुः g
               → (g ∣ a) × (g ∣ b)
साधारण-विभाजकः f a b g eq =
  let rec = विभजति f (अवतरण a b) g eq
      p   = पुनरागमनम् a b        -- उत्थान (अवतरण a b) ≡ (a , b)
  in subst (g ∣_) (cong fst p) (fst rec)
   , subst (g ∣_) (cong snd p) (snd rec)
