{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समास-एक-अंशः — यथेच्छ-एक-अंश-गणः {L} : सामान्य-आवर्तनम् a(n+L) = a(n) ।
--
-- समास-एकः {१} ध्रुवम् (a(n+1)=a(n)), समास-द्विः {२} युग्म-सूचकम् (a(n+2)=a(n))
-- अदर्शयत् — उभे एकस्य सामान्य-नियमस्य रूपे ।  एक-अंश-गणः {L} (ps = k ∷ [],
-- अंश-मानः L = suc k) : n केवलं L-गुणैः अंशैः रच्यते, अतः श्रेढी शुद्धम् आवर्तते :
--     length (सर्गः {L} (n + L)) ≡ length (सर्गः {L} n) ।
-- (k=0 → {१} ध्रुवः ; k=1 → {२} युग्मः ; सामान्यतया L-आवर्तनम् — L-भाज्य-सूचकः ।)
-- सामान्य-समास-आवृत्तिः (अंश-गणनया) एतत् सर्वेषु L वहति ; अन्तरः (n+k)∸k=n
-- शेष-रद्दनेन ।  एककम् अंशं विना अपि भावना सम्यक् चलति (L≥2 चेत् छिद्रवती) ।
--
-- (The general single-part {L} law, of which समास-एकः {1} (constant, a(n+1)=
--  a(n)) and समास-द्विः {2} (even-indicator, a(n+2)=a(n)) are the k=0 and k=1
--  cases: with one part of size L = k+1, an n is composable only by L's, so the
--  sequence is pure period-L, length(सर्गः {L} (n+L)) ≡ length(सर्गः {L} n) —
--  the L-divisibility indicator.  The general समास-आवृत्तिः yields it for every
--  L via अंश-गणना, the difference (n+k)∸k=n cancelled explicitly.)
--
-- स्रोतांसि : नारायणपण्डितः, गणितकौमुदी, अङ्कपाशः (१३५६) ; विरहाङ्कः (मेरुः) ।
------------------------------------------------------------------------

module SamasaEkAmsa where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; _·_)
open import Cubical.Data.Nat.Properties using (+-suc ; +-zero ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; suc-≤-suc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map ; length)
open import SamasaMeruN using (सर्गः ; समास-आवृत्तिः ; अंश-गणना ; रिक्त-अपाकरणम्)

------------------------------------------------------------------------
-- अन्तर-रद्दनम् — (n+k) ∸ k ≡ n (k-आगमनेन, विचारहीनम्) ।
------------------------------------------------------------------------

अन्तर-रद्दनम् : (n k : ℕ) → (n + k) ∸ k ≡ n
अन्तर-रद्दनम् n zero    = +-zero n
अन्तर-रद्दनम् n (suc k) = cong (_∸ suc k) (+-suc n k) ∙ अन्तर-रद्दनम् n k

------------------------------------------------------------------------
-- एक-अंश-आवृत्तिः — {L}-श्रेढेः L-आवर्तनम् : a(n+L) = a(n) (L = suc k) ।
------------------------------------------------------------------------

एक-अंश-आवृत्तिः : (k n : ℕ)
  → length (सर्गः (k ∷ []) (n + suc k))
  ≡ length (सर्गः (k ∷ []) n)
एक-अंश-आवृत्तिः k n =
    cong (λ m → length (सर्गः (k ∷ []) m)) (+-suc n k)
  ∙ समास-आवृत्तिः (k ∷ []) (n + k)
  ∙ cong (_+ 0) (अंश-गणना (k ∷ []) (n + k) k (n , refl))
  ∙ +-zero (length (सर्गः (k ∷ []) ((n + k) ∸ k)))
  ∙ cong (λ m → length (सर्गः (k ∷ []) m)) (अन्तर-रद्दनम् n k)

------------------------------------------------------------------------
-- उदाहरणे — {३}-श्रेढी (L=3) : त्रि-भाज्य-सूचकः १,०,०,१,०,०,१ … (refl-सिद्धानि) ।
------------------------------------------------------------------------

त्रि-३ : length (सर्गः (2 ∷ []) 3) ≡ 1     -- ३ = ३ (एकः समासः)
त्रि-३ = refl

त्रि-४ : length (सर्गः (2 ∷ []) 4) ≡ 0     -- ४ अ-त्रि-भाज्यम्
त्रि-४ = refl

त्रि-६ : length (सर्गः (2 ∷ []) 6) ≡ 1     -- ६ = ३+३
त्रि-६ = refl

------------------------------------------------------------------------
-- गुण-मानम् — {L}-श्रेढेः निश्चित-मूल्यम् गुणकेषु : प्रति L-गुणस्य एकः एव समासः
-- (सर्वे L-अंशाः) ।  length (सर्गः {L} (m·L)) ≡ 1 (m-आगमनेन, आवृत्ति-पुनरावर्तनेन) ।
-- (एतत् एव L-भाज्य-सूचकस्य धन-पक्षः ; गुणनं प्रथमम् अत्र प्रविशति ।)
--
-- (The exact value of the {L}-sequence at multiples: every multiple of L has
--  exactly one composition (all L-parts), length(सर्गः {L} (m·L)) ≡ 1, by
--  induction on m iterating एक-अंश-आवृत्तिः.  The positive half of the
--  L-divisibility indicator; multiplication enters here for the first time.)
------------------------------------------------------------------------

गुण-मानम् : (k m : ℕ) → length (सर्गः (k ∷ []) (m · suc k)) ≡ 1
गुण-मानम् k zero    = refl
गुण-मानम् k (suc m) =
    cong (λ t → length (सर्गः (k ∷ []) t)) (+-comm (suc k) (m · suc k))
  ∙ एक-अंश-आवृत्तिः k (m · suc k)
  ∙ गुण-मानम् k m

-- उदाहरणम् — {३}-श्रेढी नवमे (३·३) एकम् (आवृत्ति-पुनरावर्तनेन साधितम्) ।
गुण-९ : length (सर्गः (2 ∷ []) 9) ≡ 1
गुण-९ = गुण-मानम् 2 3

------------------------------------------------------------------------
-- न्यून-शून्यम् — {L}-श्रेढी शून्यम् L-अधः : यदि 0 < m < L (अर्थात् suc n ≤ k),
-- तर्हि m न रच्यते — अंशः (मानेन L) न योग्यः, अतः रिक्त-अपाकरणम् ।
--     length (सर्गः {L} (suc n)) ≡ 0   (suc n ≤ k, L = suc k) ।
-- गुण-मानेन सह पूर्णः L-भाज्य-सूचकः : गुणकेषु १, अन्तराले (L-अधः) ० ।
--
-- (The {L}-sequence is zero below L: for 0 < m < L (suc n ≤ k) the value m
--  cannot be built — the sole part, of size L, does not fit — via SamasaMeruN's
--  रिक्त-अपाकरणम्.  With गुण-मानम् (one at multiples) this is the full
--  L-divisibility indicator: 1 at multiples of L, 0 in the gaps below.)
------------------------------------------------------------------------

न्यून-शून्यम् : (k n : ℕ) → suc n ≤ k → length (सर्गः (k ∷ []) (suc n)) ≡ 0
न्यून-शून्यम् k n le =
  cong (λ z → length (map (k ∷_) z ++ []))
       (रिक्त-अपाकरणम् (k ∷ []) n (suc n) (suc k) (suc-≤-suc le))

-- उदाहरणम् — {४}-श्रेढी (L=4) : m=2 शून्यम् (suc 1 = 2 ≤ 3 = k) ।
न्यून-४ : length (सर्गः (3 ∷ []) 2) ≡ 0
न्यून-४ = न्यून-शून्यम् 3 1 (1 , refl)
