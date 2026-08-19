{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मात्रा-वर्ण-गुरु — पिङ्गलस्य त्रयाणां मानानां मूल-सम्बन्धः : मात्रा = वर्ण + गुरु ।
--
-- पिङ्गलः प्रति अक्षरं त्रीणि गणयति : मात्रा-मानम् (matraOf, लघुः=१ गुरुः=२),
-- वर्ण-सङ्ख्या (varna, अक्षर-गणना), गुरु-सङ्ख्या (guruOf) ।  एते त्रयः स्वतन्त्राः
-- न — एकः सम्बन्धः सर्वान् बध्नाति :
--     matraOf p ≡ varna p + guruOf p
-- यतः प्रति अक्षरं मात्रायाम् एकम् अर्पयति (अतः वर्ण-सङ्ख्या), गुरुः च एकम्
-- अधिकम् (अतः गुरु-सङ्ख्या) ।  एतेन मात्रा-वृत्तं (Metre, matraOf) वर्ण-वृत्तेन
-- (Vak/Chosen, varna·guruOf) युज्यते — यौ पृथक् आस्ताम् : छन्दसः k-गुरु-युक्तं
-- n-अक्षरं रूपं (Chosen n k) नियमेन (n+k)-मात्रम् (Metre (n+k)) ।
--
-- (Piṅgala's three per-syllable statistics — mātrā-weight (matraOf, laghu=1
--  guru=2), syllable-count (varna), guru-count (guruOf) — are not independent:
--  matraOf p ≡ varna p + guruOf p, since every syllable gives one mātrā (the
--  varna) and each guru one more (the guruOf).  This ties the mātrā-vṛtta world
--  (Metre) to the varṇa-vṛtta world (Vak/Chosen), which lived apart: an
--  n-syllable, k-guru pattern (Chosen n k) has duration exactly n+k.)
--
-- स्रोतांसि : पिङ्गलः, छन्दःशास्त्रम् (लघु-गुरु, मात्रा-गणना) ; हलायुधः (मृतसञ्जीवनी) ।
------------------------------------------------------------------------

module MatraVarnaGuru where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-suc)
open import Cubical.Data.List using (_∷_ ; [])
open import PingalaPrastara
  using (Syllable ; laghu ; guru ; Pattern ; matraOf ; varna ; guruOf)

------------------------------------------------------------------------
-- मूल-सम्बन्धः — मात्रा = वर्ण + गुरु , अक्षरे आगमनेन (विचारहीनम्) ।
------------------------------------------------------------------------

मात्रा-वर्ण-गुरु : (p : Pattern) → matraOf p ≡ varna p + guruOf p
मात्रा-वर्ण-गुरु []          = refl
मात्रा-वर्ण-गुरु (laghu ∷ p) = cong suc (मात्रा-वर्ण-गुरु p)
मात्रा-वर्ण-गुरु (guru  ∷ p) =
  cong suc (cong suc (मात्रा-वर्ण-गुरु p) ∙ sym (+-suc (varna p) (guruOf p)))

------------------------------------------------------------------------
-- छन्दो-मात्रा — पर्यायः : n-अक्षरं k-गुरु रूपं (n+k)-मात्रम् (Chosen n k → Metre (n+k)) ।
------------------------------------------------------------------------

छन्दो-मात्रा : (n k : ℕ) (p : Pattern)
            → varna p ≡ n → guruOf p ≡ k → matraOf p ≡ n + k
छन्दो-मात्रा n k p ev eg = मात्रा-वर्ण-गुरु p ∙ cong₂ _+_ ev eg

------------------------------------------------------------------------
-- उदाहरणम् — गुरु-लघु-गुरु : मात्रा = 2+1+2 = 5 = वर्ण(3) + गुरु(2) (refl) ।
------------------------------------------------------------------------

उदाहरणम् : matraOf (guru ∷ laghu ∷ guru ∷ []) ≡ 5
उदाहरणम् = refl

उदाहरणम्-सम्बन्धः : matraOf (guru ∷ laghu ∷ guru ∷ [])
                 ≡ varna (guru ∷ laghu ∷ guru ∷ []) + guruOf (guru ∷ laghu ∷ guru ∷ [])
उदाहरणम्-सम्बन्धः = मात्रा-वर्ण-गुरु (guru ∷ laghu ∷ guru ∷ [])
