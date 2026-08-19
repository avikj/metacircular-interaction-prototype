{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnuktaAvaktavya — अनुक्तम् is not अवक्तव्यम्, and the difference is a
-- swapped quantifier.
--
-- WHAT THIS CORRECTS, and it is a claim already in this repository rather
-- than one I am importing from outside it.
--
-- `Satyayantra.agda` opens by describing its third position:
--
--     अनुक्तं न मिथ्या, न ⊥ — तृतीयं पदम् (avaktavyam), बूलियन्-रहितम् ।
--     "the un-said is not false, not ⊥ — a third position (avaktavyam),
--      boolean-free."
--
-- Everything in that line is right except the parenthesis.  The un-said of
-- the honest machine is a genuine third position, it is not falsity and not
-- ⊥, and there is no boolean anywhere.  But it is NOT the fourth bhaṅga of
-- the saptabhaṅgī, and `SaptabhangiNaya.agda` — sitting in the same
-- directory, also checked, also --safe — proves the opposite modality.
--
-- THE TWO MODULES SAY, IN THEIR OWN WORDS:
--
--   Purnata.agda:  अनुक्तं सामयिकम् एव, न अन्तः ।
--                  सत्यं न त्यक्तम्, केवलम् अद्यापि अनुक्तम् — अनुदानेन प्रकाश्यम् ।
--                  "the un-said is only ever TEMPORARY, never a dead end.
--                   Truth was never abandoned, only not-yet-said —
--                   uncovered by grant."
--
--   SaptabhangiNaya.agda §5:  no single utterance denotes the joint
--                  content, exhaustively over all six atoms of the
--                  language, each with its own separating profile.  The
--                  remedy is not more of anything.  It is a SECOND
--                  utterance, taken in succession (krama).
--
-- So one third position is removed by giving the machine more, and the
-- other is not removed by giving anything more.  Same word, opposite
-- modality: "not yet" against "not ever, in one breath".
--
-- THE SEPARATION IS EXACT AND IT IS A QUANTIFIER.  Both facts already
-- exist as theorems; what was missing is that they have the same shape
-- with ∃ and ∀ exchanged, which is why one word could cover both and
-- hide it.
--
--     सामयिक  bad : I → R → Type      (i : I) → Σ[ r ] ¬ bad i r
--              for EVERY instance there is SOME remedy that removes it
--
--     नित्य    bad : I → R → Type      (r : R) → Σ[ i ] bad i r
--              for EVERY remedy there is SOME instance that survives it
--
-- `Purnata.पूर्णता` gives the first for the kuṭṭaka's un-said, with the
-- remedy being the grant.  `SaptabhangiNaya.no-single-vacana` IS the
-- second, with the remedy being a single utterance.  Neither theorem is
-- reproved here; this module only exhibits that they instantiate the two
-- dual shapes, which is the content of the distinction.
--
-- WHY IT MATTERS RATHER THAN BEING A LABELLING QUIBBLE.  A machine that
-- reports its third position has to tell a caller what to DO about it, and
-- the two answers are incompatible: spend more, or speak again.  Calling
-- both avaktavyam tells the caller to do nothing, twice.  Nyāya keeps them
-- apart too — a hetu that is asiddha (unestablished) is a defect of the
-- MEANS, repaired by establishing it; avaktavyam in the Jain scheme is a
-- positive predication about the ARTHA, and there is nothing to repair.
--
-- SOURCES.  Bhagavatī Sūtra (pre-CE strata, redacted c. 5th c.); Umāsvāti,
-- Tattvārthasūtra 5.31 arpitānarpitasiddheḥ (c. 2nd–5th c.); Siddhasena
-- Divākara, Sanmatitarka 1.21 (c. 5th c.); Akalaṅka, Laghīyastraya
-- (c. 720–780) for kramārpaṇa against sahārpaṇa — succession against
-- simultaneity, which is precisely the ∃/∀ difference below; Mallisena,
-- Syādvādamañjarī (1292) for sakalādeśa against vikalādeśa.  The kuṭṭaka
-- itself is Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33 (499 CE).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module AnuktaAvaktavya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc ; _+_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Gati using (फलम् ; गुरुः ; अनुक्तफलम् ; फल ; गति)
open import Purnata using (पूर्णता)
open import SaptabhangiNaya using (Vacana ; Profile ; denotes ; joint ; no-single-vacana)

------------------------------------------------------------------------
-- 1.  The two dual shapes.
--
-- `bad i r` reads: instance i is STILL in the third position when remedy r
-- has been applied.
------------------------------------------------------------------------

सामयिक : {I R : Type} → (I → R → Type) → Type
सामयिक {I} {R} bad = (i : I) → Σ[ r ∈ R ] (¬ bad i r)

नित्य : {I R : Type} → (I → R → Type) → Type
नित्य {I} {R} bad = (r : R) → Σ[ i ∈ I ] (bad i r)

------------------------------------------------------------------------
-- 2.  अनुक्तम् is सामयिक.  The remedy is the grant, and it always exists.
------------------------------------------------------------------------

-- "the result is still un-said"
अनुक्तमस्ति : फलम् → Type
अनुक्तमस्ति (गुरुः _)       = ⊥
अनुक्तमस्ति (अनुक्तफलम् _)  = Unit

बद्धम् : (ℕ × ℕ) → ℕ → Type
बद्धम् (a , b) n = अनुक्तमस्ति (फल (गति n a b))

अनुक्तम्-सामयिकम् : सामयिक बद्धम्
अनुक्तम्-सामयिकम् (a , b) =
  suc (a + b) , λ h → subst अनुक्तमस्ति (snd (पूर्णता a b)) h

------------------------------------------------------------------------
-- 3.  अवक्तव्यम् is नित्य.  For every single utterance there is a profile
-- that survives it — which is `no-single-vacana`, exactly, with nothing
-- added.
------------------------------------------------------------------------

असमर्थम् : Profile → Vacana → Type
असमर्थम् φ v = ¬ (denotes v φ ≡ joint φ)

अवक्तव्यम्-नित्यम् : नित्य असमर्थम्
अवक्तव्यम्-नित्यम् = no-single-vacana

------------------------------------------------------------------------
-- 4.  So the two words name dual shapes, and one word cannot carry both.
--
-- Stated as a type rather than a sentence: a predicate that is सामयिक
-- gives, at every instance, a remedy under which it fails; a predicate
-- that is नित्य gives, at every remedy, an instance under which it holds.
-- Nothing below asserts that no predicate can be both — for an empty
-- instance type or an empty remedy type the shapes degenerate, and that
-- is a separate statement I am not making.  What is exhibited is only
-- this: the two theorems already in this repository sit at the two poles,
-- and `Satyayantra.agda`'s parenthetical puts one under the other's name.
------------------------------------------------------------------------

-- the un-said, at the pole it actually occupies
अनुक्त-पदम् : सामयिक बद्धम्
अनुक्त-पदम् = अनुक्तम्-सामयिकम्

-- the fourth bhaṅga, at the other one
अवक्तव्य-पदम् : नित्य असमर्थम्
अवक्तव्य-पदम् = अवक्तव्यम्-नित्यम्
