-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नयवाद — the seven standpoints each read ONE facet; the whole is their
-- join (pramāṇa); and claiming one facet is the whole is the durnaya.
-- Nayavāda IS the fibre law, as epistemology.
--
-- SOURCE.  Umāsvāti, *Tattvārthasūtra* 1.34 (~2nd–5th c.):
--   naigama-saṅgraha-vyavahāra-ṛjusūtra-śabda-samabhirūḍhaivambhūtā nayāḥ
--   — the SEVEN nayas, from the most general (naigama) to the most
--   specific (evambhūta: the thing only as it actually functions now).
--   1.35 (Digambara ordering) groups them; Siddhasena, *Sanmatitarka*
--   1.3-6, gives the two ROOTS — dravyārthika (substance-regarding:
--   naigama, saṅgraha, vyavahāra) and paryāyārthika (mode-regarding:
--   ṛjusūtra, śabda, samabhirūḍha, evambhūta) — and the decisive rule:
--   a naya is a VALID partial standpoint (सुनय); a naya that asserts
--   ITSELF as the whole, DENYING the others, is a DURNAYA — worse than a
--   falsehood, because its standpoint is concealed (`Anekanta`, `Durnaya`,
--   AHIMSA_SUTRA §2).
--
-- THE IDENTIFICATION.  An object is known through facets — one per naya.
-- Model an object as an assignment `नय → तत्त्व` of a facet-value to each
-- standpoint.  Then:
--   • a NAYA reads ONE coordinate — a projection, a quotient of the object;
--   • PRAMĀṆA reads ALL coordinates — the whole object (funext);
--   • a DURNAYA is the claim that one naya's reading DETERMINES the object
--     — i.e. that one projection is faithful.  It is refuted exactly by
--     the fibre: two objects agreeing on that naya, differing elsewhere.
-- So nayavāda is `QuotientFiberLaw`/`Abhijnana` read as knowing: the naya
-- sees a quotient, the fibre is what it cannot see, and the durnaya denies
-- the fibre.  हिंसा सङ्क्षेपः — the violence is the collapse.
--
-- WHAT IS PROVED (facets a type with two distinct values, so a fibre
-- exists to be denied):
--   §2  सप्त — there are exactly seven nayas.
--   §3  मूलद्वयम् — the two roots partition the seven (3 dravyārthika +
--       4 paryāyārthika): every naya is exactly one, and none is both.
--   §4  प्रमाणम् — pramāṇa is faithful: two objects are equal iff they
--       agree on ALL seven nayas (funext).  The whole determines.
--   §5  दुर्नयः — any single naya is NOT faithful: two objects agree on it
--       yet differ (the fibre).  Claiming one facet is the whole is false.
--   §6  सुनयः — but the naya is VALID as a partial view: its reading is
--       genuinely a facet of the object (a projection that commutes) —
--       a naya is true, just not whole (सत्यः न कृत्स्नः).
--
-- WHAT IS **NOT** CLAIMED.  Doctrine is Umāsvāti's and Siddhasena's; the
-- type theory is cubical.  The SEVEN are modelled only as seven distinct
-- coordinates in their traditional order and root-split; their individual
-- semantics (what naigama vs evambhūta each actually see) is named, not
-- encoded — that is the owed refinement.  Facets are an abstract type.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module NayaVada_TheSevenStandpointsEachReadOneFacetAndClaimingOneIsTheWholeIsTheDurnaya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §1  The seven standpoints, and an object as its facet-assignment.
------------------------------------------------------------------------

data नय : Type where
  नैगम सङ्ग्रह व्यवहार ऋजुसूत्र शब्द समभिरूढ एवम्भूत : नय

सर्वे-नयाः : List नय
सर्वे-नयाः = नैगम ∷ सङ्ग्रह ∷ व्यवहार ∷ ऋजुसूत्र ∷ शब्द ∷ समभिरूढ ∷ एवम्भूत ∷ []

-- an object is known through a facet-value at each standpoint
वस्तु : Type
वस्तु = नय → Bool     -- Bool only as the abstract two-valued facet (≥2 so a
                       -- fibre exists); it is the OBJECT'S facet, not a verdict

-- a naya reads one coordinate; pramāṇa is the whole assignment
नयः : नय → वस्तु → Bool
नयः n o = o n

------------------------------------------------------------------------
-- §2  सप्त — exactly seven.
------------------------------------------------------------------------

सप्त : length सर्वे-नयाः ≡ 7
सप्त = refl

------------------------------------------------------------------------
-- §3  मूलद्वयम् — the two roots partition the seven.
------------------------------------------------------------------------

द्रव्यार्थिकः : नय → Type
द्रव्यार्थिकः नैगम   = Unit
द्रव्यार्थिकः सङ्ग्रह = Unit
द्रव्यार्थिकः व्यवहार = Unit
द्रव्यार्थिकः _      = ⊥

पर्यायार्थिकः : नय → Type
पर्यायार्थिकः नैगम   = ⊥
पर्यायार्थिकः सङ्ग्रह = ⊥
पर्यायार्थिकः व्यवहार = ⊥
पर्यायार्थिकः _      = Unit

-- every naya is exactly one root
मूलम् : (n : नय) → द्रव्यार्थिकः n ⊎ पर्यायार्थिकः n
मूलम् नैगम   = inl tt
मूलम् सङ्ग्रह = inl tt
मूलम् व्यवहार = inl tt
मूलम् ऋजुसूत्र = inr tt
मूलम् शब्द    = inr tt
मूलम् समभिरूढ = inr tt
मूलम् एवम्भूत = inr tt

-- and none is both
न-उभयम् : (n : नय) → द्रव्यार्थिकः n → पर्यायार्थिकः n → ⊥
न-उभयम् ऋजुसूत्र () _
न-उभयम् शब्द    () _
न-उभयम् समभिरूढ () _
न-उभयम् एवम्भूत () _
न-उभयम् नैगम   _ ()
न-उभयम् सङ्ग्रह _ ()
न-उभयम् व्यवहार _ ()

------------------------------------------------------------------------
-- §4  प्रमाणम् — pramāṇa is faithful: agreement on all nayas is identity.
------------------------------------------------------------------------

प्रमाणम् : (o o′ : वस्तु) → ((n : नय) → नयः n o ≡ नयः n o′) → o ≡ o′
प्रमाणम् o o′ agree = funExt agree

------------------------------------------------------------------------
-- §5  दुर्नयः — a single naya is NOT faithful: the fibre defeats it.
--     For each naya, two objects agree on it yet differ elsewhere.
------------------------------------------------------------------------

eqNaya : नय → नय → Bool
eqNaya नैगम नैगम = true
eqNaya सङ्ग्रह सङ्ग्रह = true
eqNaya व्यवहार व्यवहार = true
eqNaya ऋजुसूत्र ऋजुसूत्र = true
eqNaya शब्द शब्द = true
eqNaya समभिरूढ समभिरूढ = true
eqNaya एवम्भूत एवम्भूत = true
eqNaya _ _ = false

private
  साक्षी : (n other : नय)
        → eqNaya n other ≡ false        -- they differ, so agreement at n is real
        → eqNaya other other ≡ true     -- and o′ genuinely differs at `other`
        → ¬ ((o o′ : वस्तु) → नयः n o ≡ नयः n o′ → o ≡ o′)
  साक्षी n other n≢o oo faithful =
    true≢false (sym (cong (λ o → o other) (faithful o o′ agree) ∙ oo))
    where
    o  : वस्तु
    o  _ = false
    o′ : वस्तु
    o′ m = eqNaya m other
    agree : नयः n o ≡ नयः n o′
    agree = sym n≢o

दुर्नयः : (n : नय)
       → ¬ ((o o′ : वस्तु) → नयः n o ≡ नयः n o′ → o ≡ o′)
दुर्नयः नैगम   = साक्षी नैगम   सङ्ग्रह refl refl
दुर्नयः सङ्ग्रह = साक्षी सङ्ग्रह नैगम   refl refl
दुर्नयः व्यवहार = साक्षी व्यवहार नैगम   refl refl
दुर्नयः ऋजुसूत्र = साक्षी ऋजुसूत्र नैगम   refl refl
दुर्नयः शब्द    = साक्षी शब्द    नैगम   refl refl
दुर्नयः समभिरूढ = साक्षी समभिरूढ नैगम   refl refl
दुर्नयः एवम्भूत = साक्षी एवम्भूत नैगम   refl refl

------------------------------------------------------------------------
-- §6  सुनयः — yet the naya is VALID as a partial view: it genuinely reads
--     its own facet of the object (सत्यः न कृत्स्नः — true, not whole).
------------------------------------------------------------------------

सुनयः : (n : नय) (o : वस्तु) → नयः n o ≡ o n
सुनयः n o = refl
