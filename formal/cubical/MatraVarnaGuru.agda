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
open import Cubical.Data.Nat.Properties using (+-suc ; +-assoc ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_)
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

------------------------------------------------------------------------
-- लघु-सङ्ख्या — गुरु-प्रतिपक्षः : अक्षराणि लघु-गुरु-भेदेन द्विधा विभक्तानि ।
-- (The laghu counter, the complement of guruOf: syllables split into the two
--  kinds.  MeruSammiti names this complement in prose (guru↔laghu reversal,
--  C(n,k)=C(n,n−k)) but at the number level only; here it is a Pattern
--  statistic, and the partition वर्ण = लघु + गुरु is a checked term.)
------------------------------------------------------------------------

लघु-सङ्ख्या : Pattern → ℕ
लघु-सङ्ख्या []          = 0
लघु-सङ्ख्या (laghu ∷ p) = suc (लघु-सङ्ख्या p)
लघु-सङ्ख्या (guru  ∷ p) = लघु-सङ्ख्या p

------------------------------------------------------------------------
-- वर्ण-विभागः — अक्षर-विभागः : लघु-सङ्ख्या + गुरु-सङ्ख्या ≡ वर्ण-सङ्ख्या ।
------------------------------------------------------------------------

वर्ण-विभागः : (p : Pattern) → लघु-सङ्ख्या p + guruOf p ≡ varna p
वर्ण-विभागः []          = refl
वर्ण-विभागः (laghu ∷ p) = cong suc (वर्ण-विभागः p)
वर्ण-विभागः (guru  ∷ p) = +-suc (लघु-सङ्ख्या p) (guruOf p) ∙ cong suc (वर्ण-विभागः p)

------------------------------------------------------------------------
-- मात्रा-विभागः — मात्रा = १·(लघु) + २·(गुरु) : mora-नियमः (लघु=१ गुरु=२) पूर्ण-छन्दसि ।
-- मात्रा = वर्ण + गुरु = (लघु + गुरु) + गुरु = लघु + (गुरु + गुरु) ।
------------------------------------------------------------------------

मात्रा-विभागः : (p : Pattern)
             → matraOf p ≡ लघु-सङ्ख्या p + (guruOf p + guruOf p)
मात्रा-विभागः p =
    मात्रा-वर्ण-गुरु p
  ∙ cong (_+ guruOf p) (sym (वर्ण-विभागः p))
  ∙ sym (+-assoc (लघु-सङ्ख्या p) (guruOf p) (guruOf p))

-- उदाहरणम् — गुरु-लघु-गुरु : लघु=1, गुरु=2 ; मात्रा = 1 + (2+2) = 5 (refl) ।
विभाग-उदाहरणम् : matraOf (guru ∷ laghu ∷ guru ∷ [])
              ≡ लघु-सङ्ख्या (guru ∷ laghu ∷ guru ∷ [])
                + (guruOf (guru ∷ laghu ∷ guru ∷ []) + guruOf (guru ∷ laghu ∷ guru ∷ []))
विभाग-उदाहरणम् = मात्रा-विभागः (guru ∷ laghu ∷ guru ∷ [])

------------------------------------------------------------------------
-- मेरु-अवधिः — पिङ्गलस्य मेरु-पङ्क्तेः विस्तारः, रूप-स्तरे : n-अक्षरे गुरु-सङ्ख्या
-- ० तः n पर्यन्तम् (अतः मेरु C(n,k) केवलं k≤n इति सार्थकः) ; मात्रा च n तः 2n ।
-- साक्षी विभागात् एव : लघु-सङ्ख्या = गुरु-अवधेः अन्तरम् (witness) ।
--
-- (The support of Piṅgala's meru row, at the Pattern level: in an n-syllable
--  metre the guru-count runs 0..n (so C(n,k) is meaningful only for k≤n), and
--  the mātrā runs n..2n.  The witnessing difference is read straight off the
--  partition — the laghu-count IS the gap for guruOf ≤ varna.  This is the
--  Pattern-level companion to MeruSammiti's endpoint symmetry C(n,0)=C(n,n)=1.)
------------------------------------------------------------------------

गुरु-अवधिः : (p : Pattern) → guruOf p ≤ varna p
गुरु-अवधिः p = लघु-सङ्ख्या p , वर्ण-विभागः p

लघु-अवधिः : (p : Pattern) → लघु-सङ्ख्या p ≤ varna p
लघु-अवधिः p = guruOf p , (+-comm (guruOf p) (लघु-सङ्ख्या p) ∙ वर्ण-विभागः p)

मात्रा-अधः : (p : Pattern) → varna p ≤ matraOf p
मात्रा-अधः p = guruOf p , (+-comm (guruOf p) (varna p) ∙ sym (मात्रा-वर्ण-गुरु p))

मात्रा-ऊर्ध्वम् : (p : Pattern) → matraOf p ≤ varna p + varna p
मात्रा-ऊर्ध्वम् p =
    लघु-सङ्ख्या p
  , ( cong (लघु-सङ्ख्या p +_) (मात्रा-वर्ण-गुरु p)
    ∙ +-assoc (लघु-सङ्ख्या p) (varna p) (guruOf p)
    ∙ cong (_+ guruOf p) (+-comm (लघु-सङ्ख्या p) (varna p))
    ∙ sym (+-assoc (varna p) (लघु-सङ्ख्या p) (guruOf p))
    ∙ cong (varna p +_) (वर्ण-विभागः p) )
