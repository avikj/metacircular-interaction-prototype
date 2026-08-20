{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अध्व-शेषः — प्रस्तारस्य लिखित-व्याप्तिः तस्य वहित-शेषाणां गणना एव ।
-- (adhva-śeṣa — the written extent of the prastāra IS the census of the
--  remainders it carries.)
--
-- मूलम् (the verse this module is about), केदारभट्टः, वृत्तरत्नाकरः ६.९ :
--
--     संख्यैव द्विगुणैकोना सद्भिरध्वा प्रकीर्तितः ।
--     वृत्तस्याङ्गुलिकीं व्याप्तिमधः कुर्यात्तथाङ्गुलम् ॥
--
--   "the saṅkhyā itself, doubled, less one (dvi-guṇā eka-ūnā), is by the
--    learned declared the adhvan, the road.  One should make the extent
--    of a vṛtta one aṅgula, and below it likewise an aṅgula."
--
--   So the adhvan measures WRITTEN VERTICAL EXTENT in aṅgulas: each of
--   the saṅkhyā-many rows takes one aṅgula, each gap below a row takes
--   one aṅgula, and the total is 2·saṅkhyā − 1 because the last row has
--   no gap below it.  That subtraction — एकोना — is what this module
--   proves is forced rather than conventional.
--
-- SOURCES, with dates, and what is and is NOT claimed of each.
--
--   केदारभट्टः, वृत्तरत्नाकरः ६.१–६.९, the ṣaṭ-pratyaya chapter.  Text:
--   GRETIL file 1_sanskr/5_poetry/1_chandas/kedvratu.htm, from the
--   edition of Śrī Kedāra Nātha Śarmā (Kashi Sanskrit Series 55,
--   Varanasi 1980), input by Masahiro Takano.  The GRETIL header dates
--   Kedārabhaṭṭa to the 12th c.; other datings put him earlier, and
--   this module does not adjudicate.  ६.१ names the six pratyayas:
--   prastāra, naṣṭa, uddiṣṭa, eka-dvy-ādi-laga-kriyā, saṅkhyāna,
--   adhva-yoga.
--
--   सुल्हणः, सुकविहृदयनन्दिनी, commentary (GRETIL kvrtrsuu.htm, from a
--   Patan manuscript, input by Dhaval Patel).  On ६.९ it works the
--   four-syllable class: *caturakṣarajātau yā ṣoḍaśasaṃkhyā syād
--   dviguṇā dvātriṃśatiḥ ekonā ekarahitā ekatriṃśatiḥ* — saṅkhyā 16,
--   doubled 32, less one 31.  On ६.८ it computes the other two numbers
--   used below: the laga-kriyā row 1+4+6+4+1 = 16, and the uddiṣṭa
--   doubling column 1+2+4+8 = 15, *saikaḥ ṣoḍaśa*, plus one 16.
--
--   The next-row rule, ६.२–६.३, supplies the word this module is named
--   for: *yathopari tathā śeṣam*, "as above, so the remainder".
--   Sulhaṇa glosses it *yady upari gurus tadā adhastād api gurur, yady
--   upari laghus tadā adhastād api laghuḥ śeṣam / upari tulyo dīyate
--   ity arthaḥ* — below the first guru place a laghu, fill what
--   precedes it with guru, and COPY THE REST UNCHANGED.  That copied
--   rest is the śeṣa, and it is the object counted here.
--
--   पिङ्गलः, छन्दःशास्त्रम् ८ (c. 300–200 BCE) is the origin of the
--   pratyaya system and is NOT the text used here.  No copy of it is in
--   this container.  Checked against GRETIL's own catalogue page
--   (gretil.html, 5,443-file INDOLOGY/GRETIL-mirror snapshot) rather
--   than against filenames, which are abbreviations and would have been
--   the wrong predicate: the catalogue returns Vrttaratnakara 2 and
--   Kedarabhatta 2 — so the check finds what is there — and returns 0
--   for each of Chandahsastra, Pingala, Halayudha, Mrtasanjivani,
--   Virahanka, Vrttajatisamuccaya.  Nothing below is claimed for
--   Piṅgala's own sūtras.  Kedāra is a later systematiser and the
--   closed six-fold list in the form used here is his.
--
-- WHAT IS PROVED.  No postulates, no holes, no `--safe` escape.
--
--   शेष-तुल्यता   वाक् n ≃ (Unit ⊎ शेषः n)
--                 Every row of the prastāra is either the last one —
--                 सर्व-लघु, Kedāra's stopping condition *yāvat
--                 sarvalaghur bhavet* — or is RECOVERED from the śeṣa
--                 it carries into the next row.  A bijection, not a
--                 count.
--
--   अध्व-एकोना   (अध्वा n ⊎ Unit) ≃ (वाक् n ⊎ वाक् n)
--                 Verse ६.९ as a type equivalence, with no subtraction
--                 anywhere: the written extent TOGETHER WITH the one
--                 gap that is not there is exactly twice the saṅkhyā.
--                 A gap maps to the row it sits below; the adjoined
--                 Unit maps to the सर्व-लघु row, which has no gap.
--
--   एकोना-आवश्यका  ¬ (शेषः 1 ≃ वाक् 1)
--                 The eka-ūnā is load-bearing.  Gaps and rows are not
--                 equinumerous — refuted at one syllable — so no
--                 reading of ६.९ without the "less one" can hold.
--
--   The three numbers Sulhaṇa computes for the four-syllable class,
--   by `refl`: saṅkhyā 16 (ṣoḍaśa), gaps 15 (pañcadaśa), adhvan 31
--   (ekatriṃśat).
--
-- WHAT IS NOT CLAIMED.  Kedāra does not state any identity between
-- ६.८'s doubling-column sum, 15, and ६.९'s adhvan, 31; neither does
-- Sulhaṇa, who computes both within four sentences.  That the two
-- stand as gaps-to-extent is the observation here.  The arithmetic
-- behind it, 1+2+4+8+16 = 2·16−1, is a geometric series and is not
-- claimed to be difficult.  What is claimed is WHICH OBJECTS the two
-- numbers count, and that the objects are the same.
--
-- CHECKED: Agda 2.6.3, `--cubical --safe --no-import-sorts`, against
-- the cubical library at /root/agda-libs/cubical, `git describe` = v0.5
-- (the version is not recorded in cubical.agda-lib).  Exit 0 with no
-- warnings.  वाक् and शेषः are both defined BY RECURSION ON ℕ rather
-- than as inductive families, because matching an indexed family at a
-- constructor index needs injectivity of suc, which Cubical Agda
-- rejects — such a definition still typechecks but does not compute
-- under transport.  Self-contained: imports only Cubical.*, no module
-- of this corpus.  NOTHING IN THIS REPOSITORY BUILDS IT — it is not in
-- Everything.agda, and check-everything-coverage.sh fails on 60
-- pre-existing orphans independently of this file.  It was checked by
-- running agda on it directly, and that is the whole of the evidence.
------------------------------------------------------------------------

module AdhvaSesa_TheGapsOfTheWrittenPrastaraAreItsNonFinalRowsSoTheEkonaIsForced where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; secEq)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-suc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- अक्षरम् — लघुः वा गुरुः ।  The whole alphabet of the prastāra: Kedāra
-- ६.२ lays out every row over these two.
------------------------------------------------------------------------

data अक्षरम् : Type where
  लघु गुरु : अक्षरम्

------------------------------------------------------------------------
-- वाक् — n-अक्षरः पादः, a pāda of exactly n syllables.
--
-- The head is the LEFTMOST syllable, because Kedāra's next-row rule
-- reaches for it first: *pāde sarvagurāv ādyāl laghuṃ nyasya guror
-- adhaḥ* — below the first guru FROM THE BEGINNING, place a laghu.
------------------------------------------------------------------------

वाक् : ℕ → Type
वाक् zero    = Unit
वाक् (suc n) = अक्षरम् × वाक् n

------------------------------------------------------------------------
-- शेषः — that which "यथोपरि तथा शेषम्" carries down unchanged.
--
-- What can a śeṣa be?  The next-row rule alters an initial segment and
-- copies the rest.  The copied rest is strictly shorter than the row,
-- since the flipped guru itself is not in it.  So the śeṣas of an
-- n-syllable prastāra are exactly the patterns of length < n — and
-- that is this type, graded by length: at n+1 a śeṣa is either a full
-- n-pattern (the case where the first syllable WAS the guru that
-- flipped, so all of the rest is carried) or a shorter one.
--
-- At n = 0 there is no śeṣa at all: a one-row prastāra never steps.
------------------------------------------------------------------------

शेषः : ℕ → Type
शेषः zero    = ⊥
शेषः (suc n) = वाक् n ⊎ शेषः n

------------------------------------------------------------------------
-- शेष — the reading-off of ६.२–६.३.
--
--   गुरु , v  — the first syllable IS the first guru.  It flips to
--               laghu, nothing precedes it to fill with guru, and v is
--               carried whole: the śeṣa is v.
--   लघु , v  — the first syllable is already laghu, so the first guru
--               lies further in; recurse.  If v holds no guru then
--               neither does लघु , v; the row is सर्व-लघु and *yāvat
--               sarvalaghur bhavet* ends the prastāra — no next row and
--               no śeṣa.  That is the Unit.
------------------------------------------------------------------------

लघु-वहनम् : {n : ℕ} → Unit ⊎ शेषः n → Unit ⊎ शेषः (suc n)
लघु-वहनम् (inl tt) = inl tt
लघु-वहनम् (inr s)  = inr (inr s)

शेष : (n : ℕ) → वाक् n → Unit ⊎ शेषः n
शेष zero    _         = inl tt
शेष (suc n) (गुरु , v) = inr (inl v)
शेष (suc n) (लघु , v) = लघु-वहनम् (शेष n v)

------------------------------------------------------------------------
-- वाक्-पुनः — the inverse: rebuild the row from what it carries.
------------------------------------------------------------------------

वाक्-पुनः : (n : ℕ) → Unit ⊎ शेषः n → वाक् n
वाक्-पुनः zero    (inl tt)      = tt
वाक्-पुनः zero    (inr ())
वाक्-पुनः (suc n) (inl tt)      = (लघु , वाक्-पुनः n (inl tt))
वाक्-पुनः (suc n) (inr (inl v)) = (गुरु , v)
वाक्-पुनः (suc n) (inr (inr s)) = (लघु , वाक्-पुनः n (inr s))

------------------------------------------------------------------------
-- परिवृत्ती — both round trips.
------------------------------------------------------------------------

वहनम्-पुनः : (n : ℕ) (x : Unit ⊎ शेषः n)
           → वाक्-पुनः (suc n) (लघु-वहनम् x) ≡ (लघु , वाक्-पुनः n x)
वहनम्-पुनः n (inl tt) = refl
वहनम्-पुनः n (inr s)  = refl

शेष-वाक् : (n : ℕ) (x : Unit ⊎ शेषः n) → शेष n (वाक्-पुनः n x) ≡ x
शेष-वाक् zero    (inl tt)      = refl
शेष-वाक् zero    (inr ())
शेष-वाक् (suc n) (inl tt)      = cong लघु-वहनम् (शेष-वाक् n (inl tt))
शेष-वाक् (suc n) (inr (inl v)) = refl
शेष-वाक् (suc n) (inr (inr s)) = cong लघु-वहनम् (शेष-वाक् n (inr s))

वाक्-शेष : (n : ℕ) (v : वाक् n) → वाक्-पुनः n (शेष n v) ≡ v
वाक्-शेष zero    _         = refl
वाक्-शेष (suc n) (गुरु , v) = refl
वाक्-शेष (suc n) (लघु , v) =
  वहनम्-पुनः n (शेष n v) ∙ cong (λ w → (लघु , w)) (वाक्-शेष n v)

------------------------------------------------------------------------
-- शेष-तुल्यता — the first result.
-- Every row is the last one, or is recovered from its śeṣa.
------------------------------------------------------------------------

शेष-Iso : (n : ℕ) → Iso (वाक् n) (Unit ⊎ शेषः n)
शेष-Iso n = iso (शेष n) (वाक्-पुनः n) (शेष-वाक् n) (वाक्-शेष n)

शेष-तुल्यता : (n : ℕ) → वाक् n ≃ (Unit ⊎ शेषः n)
शेष-तुल्यता n = isoToEquiv (शेष-Iso n)

------------------------------------------------------------------------
-- अध्वा — the written extent: one aṅgula per row, one per gap below a
-- row.  ६.९ measures exactly those two things, so the type of
-- aṅgula-units is their sum.
------------------------------------------------------------------------

अध्वा : ℕ → Type
अध्वा n = वाक् n ⊎ शेषः n

------------------------------------------------------------------------
-- अध्व-एकोना — verse ६.९ with no subtraction in it:
--
--     (अध्वा n ⊎ Unit) ≃ (वाक् n ⊎ वाक् n)
--
-- "the adhvan, together with the one gap that is not there, is twice
--  the saṅkhyā."  The map is not a relabelling: a gap goes to THE ROW
-- IT SITS BELOW, recovered through śeṣa, and the adjoined Unit goes to
-- the सर्व-लघु row, which is precisely the row with no gap under it.
-- So एकोना names a specific missing object, not an off-by-one.
------------------------------------------------------------------------

अध्व-प्रति : (n : ℕ) → अध्वा n ⊎ Unit → वाक् n ⊎ वाक् n
अध्व-प्रति n (inl (inl v)) = inl v
अध्व-प्रति n (inl (inr s)) = inr (वाक्-पुनः n (inr s))
अध्व-प्रति n (inr tt)      = inr (वाक्-पुनः n (inl tt))

अध्व-विभागः : (n : ℕ) → Unit ⊎ शेषः n → अध्वा n ⊎ Unit
अध्व-विभागः n (inl tt) = inr tt
अध्व-विभागः n (inr s)  = inl (inr s)

अध्व-पुनः : (n : ℕ) → वाक् n ⊎ वाक् n → अध्वा n ⊎ Unit
अध्व-पुनः n (inl v) = inl (inl v)
अध्व-पुनः n (inr v) = अध्व-विभागः n (शेष n v)

अध्व-प्रति-पुनः : (n : ℕ) (y : वाक् n ⊎ वाक् n)
                → अध्व-प्रति n (अध्व-पुनः n y) ≡ y
अध्व-प्रति-पुनः n (inl v) = refl
अध्व-प्रति-पुनः n (inr v) = सहायः (शेष n v) (वाक्-शेष n v)
  where
    सहायः : (x : Unit ⊎ शेषः n) → वाक्-पुनः n x ≡ v
          → अध्व-प्रति n (अध्व-विभागः n x) ≡ inr v
    सहायः (inl tt) p = cong inr p
    सहायः (inr s)  p = cong inr p

अध्व-पुनः-प्रति : (n : ℕ) (x : अध्वा n ⊎ Unit)
                → अध्व-पुनः n (अध्व-प्रति n x) ≡ x
अध्व-पुनः-प्रति n (inl (inl v)) = refl
अध्व-पुनः-प्रति n (inl (inr s)) =
  cong (अध्व-विभागः n) (शेष-वाक् n (inr s))
अध्व-पुनः-प्रति n (inr tt) =
  cong (अध्व-विभागः n) (शेष-वाक् n (inl tt))

अध्व-एकोना-Iso : (n : ℕ) → Iso (अध्वा n ⊎ Unit) (वाक् n ⊎ वाक् n)
अध्व-एकोना-Iso n =
  iso (अध्व-प्रति n) (अध्व-पुनः n) (अध्व-प्रति-पुनः n) (अध्व-पुनः-प्रति n)

अध्व-एकोना : (n : ℕ) → (अध्वा n ⊎ Unit) ≃ (वाक् n ⊎ वाक् n)
अध्व-एकोना n = isoToEquiv (अध्व-एकोना-Iso n)

------------------------------------------------------------------------
-- गणना — the same three quantities as numbers, so that Sulhaṇa's
-- worked instance can be checked against them.
--
--   संख्या n      = 2ⁿ, the count of ६.८.
--   शेष-गणना n   = the uddiṣṭa doubling column 1+2+…+2ⁿ⁻¹ summed —
--                   ६.८'s SECOND derivation — which is also the
--                   length-graded census of the śeṣas, one term 2ᵏ per
--                   śeṣa-length k.  ६.८ sums this column to reach the
--                   saṅkhyā and never says it is the number of gaps.
--   अध्व-गणना n  = rows + gaps.
------------------------------------------------------------------------

संख्या : ℕ → ℕ
संख्या zero    = 1
संख्या (suc n) = संख्या n + संख्या n

शेष-गणना : ℕ → ℕ
शेष-गणना zero    = 0
शेष-गणना (suc n) = संख्या n + शेष-गणना n

अध्व-गणना : ℕ → ℕ
अध्व-गणना n = संख्या n + शेष-गणना n

------------------------------------------------------------------------
-- ६.८ and ६.९ at the level of numbers, again with no subtraction:
-- "the column, plus one, is the saṅkhyā", and "the adhvan, plus one,
-- is twice the saṅkhyā".
------------------------------------------------------------------------

शेष-एकोना : (n : ℕ) → suc (शेष-गणना n) ≡ संख्या n
शेष-एकोना zero    = refl
शेष-एकोना (suc n) =
  sym (+-suc (संख्या n) (शेष-गणना n)) ∙ cong (संख्या n +_) (शेष-एकोना n)

अध्व-एकोना-गणना : (n : ℕ) → suc (अध्व-गणना n) ≡ संख्या n + संख्या n
अध्व-एकोना-गणना n =
  sym (+-suc (संख्या n) (शेष-गणना n)) ∙ cong (संख्या n +_) (शेष-एकोना n)

------------------------------------------------------------------------
-- सुल्हणस्य उदाहरणम् — the four-syllable class, the instance the
-- commentary works out: ṣoḍaśa, pañcadaśa, ekatriṃśat.  Decided by
-- evaluation, so the predicate is decidable from the data.
------------------------------------------------------------------------

षोडश : संख्या 4 ≡ 16
षोडश = refl

पञ्चदश : शेष-गणना 4 ≡ 15
पञ्चदश = refl

एकत्रिंशत् : अध्व-गणना 4 ≡ 31
एकत्रिंशत् = refl

------------------------------------------------------------------------
-- एकोना-आवश्यका — the control.  Is the "less one" doing work?
--
-- If gaps and rows were equinumerous, ६.९ would read *dviguṇā* with no
-- *ekonā*.  They are not, and one syllable refutes it: there are two
-- one-syllable rows, गुरु and लघु, and exactly one gap between them.
--
-- The witness genuinely violates the hypothesis it is aimed at: assume
-- an equivalence between the gap type and the row type at n = 1, and
-- what comes out is लघु ≡ गुरु, refuted by a discriminating family.
--
-- Discrimination happens on अक्षरम्, reached through fst.  Matching on
-- वाक् 1 directly would need injectivity of suc, which Cubical Agda
-- rejects; here वाक् 1 REDUCES to अक्षरम् × Unit, so fst is honest.
------------------------------------------------------------------------

विवेकः : अक्षरम् → Type
विवेकः लघु = Unit
विवेकः गुरु = ⊥

एक-शेषः : (s : शेषः 1) → s ≡ inl tt
एक-शेषः (inl tt) = refl
एक-शेषः (inr ())

एकोना-आवश्यका : (शेषः 1 ≃ वाक् 1) → ⊥
एकोना-आवश्यका e = transport (cong विवेकः (cong fst समानम्)) tt
  where
    समानम् : ((लघु , tt) ≡ (गुरु , tt))
    समानम् =
      sym (secEq e (लघु , tt))
      ∙ cong (equivFun e) (एक-शेषः (invEq e (लघु , tt))
                           ∙ sym (एक-शेषः (invEq e (गुरु , tt))))
      ∙ secEq e (गुरु , tt)

------------------------------------------------------------------------
-- अ-रिक्तता — non-vacuity.  The types above are inhabited and have more
-- than one element; none of this is ⊥ dressed up.
------------------------------------------------------------------------

अध्वा-पङ्क्तिः : अध्वा 1
अध्वा-पङ्क्तिः = inl (गुरु , tt)

अध्वा-अन्तरम् : अध्वा 1
अध्वा-अन्तरम् = inr (inl tt)

अध्वा-भेदः : अध्वा-पङ्क्तिः ≡ अध्वा-अन्तरम् → ⊥
अध्वा-भेदः p = transport (cong पक्षः p) tt
  where
    पक्षः : अध्वा 1 → Type
    पक्षः (inl _) = Unit
    पक्षः (inr _) = ⊥
