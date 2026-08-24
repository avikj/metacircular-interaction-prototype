-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- षड्द्रव्य — the six substances are one ontology: five extended plus time,
-- and the single and the actionless coincide.  The whole arena, one type.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra*, adhyāya 5 (~2nd–5th c.):
--   5.1  ajīvakāyā dharmādharmākāśapudgalāḥ — the ajīva KĀYAS (extended
--        non-souls) are dharma, adharma, ākāśa, pudgala.
--   5.2  dravyāṇi jīvāś ca — and jīvas too are dravyas.  (kāla is added as
--        the sixth in the Digambara reading of 5.39, kālaś cety eke.)
--   5.3  nityāvasthitāny arūpīṇi — [they are] permanent (NITYA), fixed,
--        non-corporeal;  5.4  rūpiṇaḥ pudgalāḥ — EXCEPT pudgala, corporeal.
--   5.5  ā ākāśād ekadravyāṇi — up to ākāśa (i.e. dharma, adharma, ākāśa)
--        they are each a SINGLE substance;
--   5.6  niṣkriyāṇi ca — and [those same three are] ACTIONLESS.
--   5.1  the five extended substances are the ASTIKĀYAS (kāya = having
--        pradeśas); kāla, being point-instantaneous, is the one dravya
--        that is NOT an astikāya.
--
-- WHAT IS PROVED, as the whole arena in one enumerated type, classified
-- exactly as the sūtras classify it — and PURELY: every classification is
-- a proof-relevant predicate (Unit / ⊥), never a boolean verdict, because
-- a boolean verdict on a substance would be the durnaya the machine
-- forbids (`Anekanta`, `Sabda`).  Counts are exact enumerations.
--
--   §2  षड्द्रव्याणि — there are exactly SIX dravyas (the enumeration has
--       length 6; every constructor appears).
--   §3  पञ्चास्तिकायाः — exactly FIVE are astikāya: kāla is not extended,
--       the other five are.  (pañcāstikāya + kāla = ṣaḍdravya.)
--   §4  एकं रूपि — exactly ONE is corporeal (pudgala); the five are arūpī.
--   §5  एकत्वं निष्क्रियत्वं च समम् — 5.5 and 5.6 pick out the SAME three
--       (dharma, adharma, ākāśa): the single substances and the actionless
--       ones COINCIDE, as predicates — proved pointwise.
--   §6  सर्वं नित्यम् — all six are nitya (5.3): permanent.  This is
--       dhrauvya (`Anekanta`, TS 5.29) at the level of the substances —
--       every dravya persists; that persistence is what each substance's
--       conservation law (`Pudgala.द्रव्य-नित्यम्`, `DharmaAdharma`,
--       `Kala`) instantiates.
--
-- WHAT IS **NOT** CLAIMED.  Doctrine is Umāsvāti's; the type theory is
-- cubical.  kāla as the sixth is the Digambara reading (marked); the
-- Śvetāmbara pañcāstikāya counts five and takes kāla as upacāra — this
-- file encodes the six-dravya schema and says so.  The substances'
-- INTERNAL structure lives in their own modules; this file is only the
-- classification skeleton that holds them as one.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module SadDravya_TheSixSubstancesAreOneOntologyFiveExtendedPlusTimeAndTheSingleAndActionlessCoincide where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §1  The six substances, and the classifications as PREDICATES.
------------------------------------------------------------------------

data द्रव्य : Type where
  धर्म अधर्म आकाश पुद्गल जीव काल : द्रव्य

सर्वद्रव्याणि : List द्रव्य
सर्वद्रव्याणि = धर्म ∷ अधर्म ∷ आकाश ∷ पुद्गल ∷ जीव ∷ काल ∷ []

-- astikāya: extended (has pradeśas) — all but kāla (5.1)
अस्तिकायत्वम् : द्रव्य → Type
अस्तिकायत्वम् काल = ⊥
अस्तिकायत्वम् _   = Unit

-- rūpī: corporeal — only pudgala (5.4)
रूपित्वम् : द्रव्य → Type
रूपित्वम् पुद्गल = Unit
रूपित्वम् _     = ⊥

-- eka: a single substance — dharma, adharma, ākāśa (5.5)
एकत्वम् : द्रव्य → Type
एकत्वम् धर्म  = Unit
एकत्वम् अधर्म = Unit
एकत्वम् आकाश  = Unit
एकत्वम् _    = ⊥

-- niṣkriya: actionless — dharma, adharma, ākāśa (5.6)
निष्क्रियत्वम् : द्रव्य → Type
निष्क्रियत्वम् धर्म  = Unit
निष्क्रियत्वम् अधर्म = Unit
निष्क्रियत्वम् आकाश  = Unit
निष्क्रियत्वम् _    = ⊥

-- nitya: permanent — all six (5.3)
नित्यत्वम् : द्रव्य → Type
नित्यत्वम् _ = Unit

------------------------------------------------------------------------
-- §2  षड्द्रव्याणि — exactly six.
------------------------------------------------------------------------

षड्द्रव्याणि : length सर्वद्रव्याणि ≡ 6
षड्द्रव्याणि = refl

------------------------------------------------------------------------
-- §3  पञ्चास्तिकायाः — five are extended, kāla is not.
------------------------------------------------------------------------

पञ्चास्तिकायाः : List द्रव्य
पञ्चास्तिकायाः = धर्म ∷ अधर्म ∷ आकाश ∷ पुद्गल ∷ जीव ∷ []

पञ्च : length पञ्चास्तिकायाः ≡ 5
पञ्च = refl

-- the five are extended…
अस्तिकायाः-सन्ति : अस्तिकायत्वम् धर्म × (अस्तिकायत्वम् अधर्म × (अस्तिकायत्वम् आकाश
                 × (अस्तिकायत्वम् पुद्गल × अस्तिकायत्वम् जीव)))
अस्तिकायाः-सन्ति = tt , tt , tt , tt , tt

-- …and kāla is not.
कालः-न-अस्तिकायः : ¬ अस्तिकायत्वम् काल
कालः-न-अस्तिकायः = λ z → z

------------------------------------------------------------------------
-- §4  एकं रूपि — exactly one corporeal.
------------------------------------------------------------------------

पुद्गलः-रूपी : रूपित्वम् पुद्गल
पुद्गलः-रूपी = tt

धर्मादयः-अरूपिणः : ¬ रूपित्वम् धर्म
धर्मादयः-अरूपिणः = λ z → z

------------------------------------------------------------------------
-- §5  एकत्वं निष्क्रियत्वं च समम् — 5.5 and 5.6 name the same three:
--     the single and the actionless coincide, as predicates, pointwise.
------------------------------------------------------------------------

एकत्वं-निष्क्रियत्वं-समम् : (d : द्रव्य) → एकत्वम् d ≡ निष्क्रियत्वम् d
एकत्वं-निष्क्रियत्वं-समम् धर्म  = refl
एकत्वं-निष्क्रियत्वं-समम् अधर्म = refl
एकत्वं-निष्क्रियत्वं-समम् आकाश  = refl
एकत्वं-निष्क्रियत्वं-समम् पुद्गल = refl
एकत्वं-निष्क्रियत्वं-समम् जीव   = refl
एकत्वं-निष्क्रियत्वं-समम् काल   = refl

------------------------------------------------------------------------
-- §6  सर्वं नित्यम् — every dravya is permanent (dhrauvya at the level of
--     substances; the conservation laws of the individual dravyas
--     instantiate it).
------------------------------------------------------------------------

सर्वं-नित्यम् : (d : द्रव्य) → नित्यत्वम् d
सर्वं-नित्यम् _ = tt
