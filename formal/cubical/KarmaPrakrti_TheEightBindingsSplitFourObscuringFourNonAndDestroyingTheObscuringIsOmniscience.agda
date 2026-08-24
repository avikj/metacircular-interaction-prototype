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
-- कर्मप्रकृति — the eight karma-natures split four OBSCURING (ghātī) and
-- four non-obscuring (aghātī); destroying the four obscuring is kevala
-- (omniscience); destroying all eight is mokṣa.  The bridge from the
-- karma-dynamics to knowing.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra* (~2nd–5th c.):
--   8.5   the eight mūla-prakṛtis (root natures) of bound karma:
--         jñānāvaraṇa (knowledge-obscuring), darśanāvaraṇa (perception-
--         obscuring), vedanīya (feeling), mohanīya (deluding), āyus
--         (lifespan), nāma (body-making), gotra (status), antarāya
--         (obstructive).
--   10.1  moha-kṣayāj jñāna-darśanāvaraṇāntarāya-kṣayāc ca kevalam —
--         from the destruction of the deluding (moha) AND of the
--         knowledge- and perception-obscuring and the obstructive, arises
--         KEVALA (omniscience).  Those four — mohanīya, jñānāvaraṇa,
--         darśanāvaraṇa, antarāya — are the GHĀTĪ (obscuring) karmas.
--   10.2  the remaining four (vedanīya, āyus, nāma, gotra) are AGHĀTĪ;
--         their destruction, with no new bondage, is kṛtsna-karma-
--         vipramokṣa — mokṣa (`Karma.मोक्षः`).
--
-- So there are two thresholds, not one: kevala (the four ghātī gone —
-- the veil on KNOWING lifted, `NayaVada.प्रमाणम्` become total) precedes
-- mokṣa (all eight gone — release from the arena, `Karma`).  The
-- sayoga-kevalī (guṇasthāna 13) has kevala but not yet mokṣa.
--
-- WHAT IS PROVED:
--   §2  अष्ट — exactly eight prakṛtis.
--   §3  घाति-अघाति — the four ghātī and four aghātī PARTITION the eight:
--       every prakṛti is exactly one, none both, four each.
--   §4  केवलम् — kevala is destruction of the four ghātī; मोक्षः is
--       destruction of all eight.
--   §5  मोक्षात्-केवलम् — mokṣa ENTAILS kevala: if all eight are destroyed
--       the four ghātī are, so the liberated is omniscient.
--   §6  केवलं-न-मोक्षः — but kevala is strictly weaker: a state with the
--       four ghātī gone and an aghātī remaining is kevala WITHOUT mokṣa
--       (the sayoga-kevalī).  Omniscience precedes liberation.
--
-- WHAT IS **NOT** CLAIMED.  Doctrine is Umāsvāti's; type theory cubical.
-- Only the eight ROOT natures and the ghātī/aghātī split are modelled;
-- the uttara-prakṛtis (148 sub-types), sthiti/anubhāga, and the
-- guṇasthāna ascent are named, owed, not encoded.  "Destroyed" is a
-- per-prakṛti boolean-free predicate on a state.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module KarmaPrakrti_TheEightBindingsSplitFourObscuringFourNonAndDestroyingTheObscuringIsOmniscience where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §1  The eight root natures, and the ghātī / aghātī predicates.
------------------------------------------------------------------------

data प्रकृति : Type where
  ज्ञानावरण दर्शनावरण मोहनीय अन्तराय : प्रकृति      -- the four GHĀTĪ (obscuring)
  वेदनीय आयुस् नाम गोत्र : प्रकृति                   -- the four AGHĀTĪ

अष्टप्रकृतयः : List प्रकृति
अष्टप्रकृतयः = ज्ञानावरण ∷ दर्शनावरण ∷ मोहनीय ∷ अन्तराय
            ∷ वेदनीय ∷ आयुस् ∷ नाम ∷ गोत्र ∷ []

घातिन् : प्रकृति → Type
घातिन् ज्ञानावरण = Unit
घातिन् दर्शनावरण = Unit
घातिन् मोहनीय   = Unit
घातिन् अन्तराय  = Unit
घातिन् _        = ⊥

अघातिन् : प्रकृति → Type
अघातिन् वेदनीय = Unit
अघातिन् आयुस्  = Unit
अघातिन् नाम    = Unit
अघातिन् गोत्र  = Unit
अघातिन् _      = ⊥

------------------------------------------------------------------------
-- §2  अष्ट — exactly eight.
------------------------------------------------------------------------

अष्ट : length अष्टप्रकृतयः ≡ 8
अष्ट = refl

------------------------------------------------------------------------
-- §3  घाति-अघाति — the two classes partition the eight (4 + 4).
------------------------------------------------------------------------

चतुर्घातिनः : List प्रकृति
चतुर्घातिनः = ज्ञानावरण ∷ दर्शनावरण ∷ मोहनीय ∷ अन्तराय ∷ []

चत्वारः-घातिनः : length चतुर्घातिनः ≡ 4
चत्वारः-घातिनः = refl

विभागः : (p : प्रकृति) → घातिन् p ⊎ अघातिन् p
विभागः ज्ञानावरण = inl tt
विभागः दर्शनावरण = inl tt
विभागः मोहनीय   = inl tt
विभागः अन्तराय  = inl tt
विभागः वेदनीय   = inr tt
विभागः आयुस्    = inr tt
विभागः नाम      = inr tt
विभागः गोत्र    = inr tt

न-उभयम् : (p : प्रकृति) → घातिन् p → अघातिन् p → ⊥
न-उभयम् वेदनीय   () _
न-उभयम् आयुस्    () _
न-उभयम् नाम      () _
न-उभयम् गोत्र    () _
न-उभयम् ज्ञानावरण _ ()
न-उभयम् दर्शनावरण _ ()
न-उभयम् मोहनीय   _ ()
न-उभयम् अन्तराय  _ ()

------------------------------------------------------------------------
-- §4  केवलम् / मोक्षः — the two thresholds as predicates on a state.
--     A state records, per prakṛti, whether it is destroyed (क्षीण).
------------------------------------------------------------------------

अवस्था : Type₁
अवस्था = प्रकृति → Type      -- क्षीण p holds when p is destroyed in this state

-- kevala: every ghātī is destroyed
केवलम् : अवस्था → Type
केवलम् क्षीण = (p : प्रकृति) → घातिन् p → क्षीण p

-- mokṣa: every prakṛti is destroyed (kṛtsna-karma-kṣaya)
मोक्षः : अवस्था → Type
मोक्षः क्षीण = (p : प्रकृति) → क्षीण p

------------------------------------------------------------------------
-- §5  मोक्षात्-केवलम् — mokṣa entails kevala (the liberated is omniscient).
------------------------------------------------------------------------

मोक्षात्-केवलम् : (क्षीण : अवस्था) → मोक्षः क्षीण → केवलम् क्षीण
मोक्षात्-केवलम् क्षीण m = λ p _ → m p

------------------------------------------------------------------------
-- §6  केवलं-न-मोक्षः — kevala is strictly weaker: ghātī gone, an aghātī
--     remaining, is kevala without mokṣa (the sayoga-kevalī, guṇasthāna 13).
------------------------------------------------------------------------

-- the state where exactly the ghātī are destroyed (aghātī remain)
सयोगकेवली : अवस्था
सयोगकेवली = घातिन्        -- क्षीण p := घातिन् p : destroyed iff obscuring

सयोगकेवली-केवलम् : केवलम् सयोगकेवली
सयोगकेवली-केवलम् p g = g          -- ghātī p ⟹ (क्षीण p = घातिन् p) holds

सयोगकेवली-न-मोक्षः : ¬ मोक्षः सयोगकेवली
सयोगकेवली-न-मोक्षः m = m वेदनीय   -- would need घातिन् वेदनीय = ⊥
