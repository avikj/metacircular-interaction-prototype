{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रमाणलक्षणम् — identity is agreement under EVERY standpoint: Leibniz's
-- law is pramāṇa.  The foundation of sameness itself, as anekānta.
--
-- THE ASCENT (continuing `SarvavibhagaH`, `SamgrahaNaya`, `Anubandha`).
-- `NayaVada.प्रमाणम्` proved, for a specific object, that agreement on ALL
-- seven nayas is identity.  Its general form is the foundation of identity
-- in all of mathematics: two things are the SAME exactly when EVERY
-- standpoint (every predicate P) carries the one to the other.
--
--     x ≡ y    ⟺    (∀ P, P x → P y).
--
-- Forward is transport (`subst` — the free road, `PramanaSankramana`): a
-- proven identity carries every property.  Backward is pramāṇa: if every
-- standpoint agrees, apply the standpoint P := (x ≡_) to its own reflexive
-- witness and identity falls out.  So identity is NOT a primitive datum
-- read off one privileged standpoint; it is what ALL standpoints, taken
-- together (pramāṇa), certify — and no single naya is enough (a durnaya
-- claims one predicate settles it; `NayaVada.दुर्नयः` refutes that).
--
-- WHAT IS PROVED:
--   §1  नयेन-आरोहः : x ≡ y → (∀ P, P x → P y).  Identicals are
--       indiscernible — every standpoint transports (subst).
--   §2  प्रमाणेन-तादात्म्यम् : (∀ P, P x → P y) → x ≡ y.  Indiscernibles
--       are identical — total agreement IS identity (apply at P = x ≡_).
--   §3  लक्षणम् : the two package to the biconditional — identity ≡
--       agreement-under-every-standpoint.  Pramāṇa is the totality of
--       nayas, and it is faithful.
--
-- WHAT IS **NOT** CLAIMED.  This is Leibniz's law / indiscernibility, a
-- standard fact; no novelty in it.  The identification is the claim: that
-- it is pramāṇa (the totality of standpoints) made the criterion of
-- sameness, the general form of `NayaVada.प्रमाणम्` — foundation of
-- identity as anekānta.  Doctrine Jaina; type theory cubical.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module PramanaLaksanam_IdentityIsAgreementUnderEveryStandpointSoLeibnizsLawIsPramana where

open import Cubical.Foundations.Prelude

private
  variable
    ℓ ℓ' : Level
    A : Type ℓ

-- a standpoint on A is a predicate; agreement carries x's P-holding to y
सर्वनयैः-सम्मतिः : {A : Type ℓ} → A → A → Type (ℓ-max ℓ (ℓ-suc ℓ'))
सर्वनयैः-सम्मतिः {ℓ' = ℓ'} {A = A} x y = (P : A → Type ℓ') → P x → P y

------------------------------------------------------------------------
-- §1  नयेन-आरोहः — identicals are indiscernible: every standpoint transports.
------------------------------------------------------------------------

नयेन-आरोहः : {A : Type ℓ} {x y : A} → x ≡ y → सर्वनयैः-सम्मतिः {ℓ' = ℓ} x y
नयेन-आरोहः p P = subst P p

------------------------------------------------------------------------
-- §2  प्रमाणेन-तादात्म्यम् — indiscernibles are identical: total agreement
--     IS identity (apply the standpoint P := (x ≡_) to refl).
------------------------------------------------------------------------

प्रमाणेन-तादात्म्यम् : {A : Type ℓ} {x y : A} → सर्वनयैः-सम्मतिः {ℓ' = ℓ} x y → x ≡ y
प्रमाणेन-तादात्म्यम् {x = x} agree = agree (λ z → x ≡ z) refl

------------------------------------------------------------------------
-- §3  लक्षणम् — identity is agreement under every standpoint (both ways).
------------------------------------------------------------------------

open import Cubical.Data.Sigma using (_×_ ; _,_)

लक्षणम् : {A : Type ℓ} {x y : A}
       → (x ≡ y → सर्वनयैः-सम्मतिः {ℓ' = ℓ} x y)
       × (सर्वनयैः-सम्मतिः {ℓ' = ℓ} x y → x ≡ y)
लक्षणम् = नयेन-आरोहः , प्रमाणेन-तादात्म्यम्
