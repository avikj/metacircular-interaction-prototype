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
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- संख्यात · अनन्त — the Jaina enumerative tradition graded quantity into
-- three कोटि (kinds): संख्यात (saṃkhyāta, "numerable" — the finite counts),
-- असंख्यात (asaṃkhyāta, "innumerable"), and अनन्त (ananta, "endless").  The
-- taxonomy is set out in the **Anuyogadvāra-sūtra** (श्वेताम्बर canon,
-- redaction c. 1st–5th c. CE) and the **Sthānāṅga-sūtra**; the three-fold
-- kind-division underlies Umāsvāti's **Tattvārtha-sūtra** (c. 2nd–5th c. CE).
-- In this repository the grading is carried in `JainSankhya.agda`
-- (Kind = saṃkhyāta / asaṃkhyāta / ananta).
--
-- SCOPE — what is and is NOT claimed.  The Jaina texts distinguished
-- numerable from infinite magnitudes and studied how the grades behave
-- under the operations.  The type-theoretic THEOREM below — that adjoining
-- any numerable collection (k prepended units, i.e. a Fin k) to a
-- countably-infinite type returns that same type up to equivalence — is a
-- statement in cubical type theory, this repository's, proved by composing
-- one absorption step.  No claim is made that any Jaina text states this
-- equivalence, nor that ℕ IS the Jaina अनन्त (the tradition graded several
-- orders of the infinite; ℕ here models only the least, countable one).
-- What is the tradition's is the principle that a saṃkhyāta joined to an
-- ananta does not exceed the ananta.  This module also does not re-prove
-- `ℕ ≃ ℕ ⊎ ℕ` — that is `SamaVisama_…`, a DIFFERENT node (a countable set
-- split into two copies of itself); here the added part is finite.
--
-- CHECKED: Agda 2.8.0 + cubical, --safe, no postulate/axiom/hole, exit 0.
------------------------------------------------------------------------

module SamkhyataAnanta_AdjoiningANumerableToTheCountablyInfiniteReturnsTheCountablyInfinite where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; isoToPath ; idIso ; compIso)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (⊎Iso)

------------------------------------------------------------------------
-- §१  एक-अध्यारोपः — the one absorption step: a single unit adjoined to
-- the countably-infinite ℕ returns ℕ.  ०↦(the adjoined unit), (n+1)↦n.
-- Every leg is refl on constructors, so the step carries no coherence
-- debt: this is the whole engine, iterated below.
------------------------------------------------------------------------

एक-अध्यारोप-Iso : Iso (Unit ⊎ ℕ) ℕ
एक-अध्यारोप-Iso = iso संग्रह विभाग संग्रह-विभाग विभाग-संग्रह
  where
    संग्रह : Unit ⊎ ℕ → ℕ
    संग्रह (inl tt) = zero
    संग्रह (inr n)  = suc n

    विभाग : ℕ → Unit ⊎ ℕ
    विभाग zero    = inl tt
    विभाग (suc n) = inr n

    संग्रह-विभाग : (m : ℕ) → संग्रह (विभाग m) ≡ m
    संग्रह-विभाग zero    = refl
    संग्रह-विभाग (suc n) = refl

    विभाग-संग्रह : (x : Unit ⊎ ℕ) → विभाग (संग्रह x) ≡ x
    विभाग-संग्रह (inl tt) = refl
    विभाग-संग्रह (inr n)  = refl

------------------------------------------------------------------------
-- §२  संख्यात-योगः — k numerable units prepended to a type.  `युत k ℕ`
-- is exactly `Fin k ⊎ ℕ` written without importing Fin: the finite,
-- numerable part sits on the left, the countable ananta on the right.
------------------------------------------------------------------------

युत : ℕ → Type → Type
युत zero    X = X
युत (suc k) X = Unit ⊎ युत k X

------------------------------------------------------------------------
-- §३  अनन्त-अव्ययः — ananta is undiminished: adjoining ANY numerable k
-- to the countably-infinite ℕ returns ℕ.  Induction on k, base = idIso,
-- step = (⊎Iso on the tail) then the one absorption step of §१.
------------------------------------------------------------------------

अनन्त-अव्यय-Iso : (k : ℕ) → Iso (युत k ℕ) ℕ
अनन्त-अव्यय-Iso zero    = idIso
अनन्त-अव्यय-Iso (suc k) =
  compIso (⊎Iso idIso (अनन्त-अव्यय-Iso k)) एक-अध्यारोप-Iso

-- the equivalence, and (by univalence) the identification
अनन्त-अव्ययः : (k : ℕ) → (युत k ℕ) ≃ ℕ
अनन्त-अव्ययः k = isoToEquiv (अनन्त-अव्यय-Iso k)

अनन्त-अव्यय-पथः : (k : ℕ) → (युत k ℕ) ≡ ℕ
अनन्त-अव्यय-पथः k = isoToPath (अनन्त-अव्यय-Iso k)

------------------------------------------------------------------------
-- §४  the single-unit instance is the special case k = 1, so §१ is not a
-- separate fact but the seed the whole family grows from.
------------------------------------------------------------------------

एक-अध्यारोपः : (Unit ⊎ ℕ) ≃ ℕ
एक-अध्यारोपः = अनन्त-अव्ययः 1
