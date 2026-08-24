{-# OPTIONS --erased-cubical --erasure --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- द्रव्यश्रुतम् — the word as substance.
--
-- SOURCE.  The Jaina distinction dravya-śruta / bhāva-śruta: the
-- scripture as physical record — leaves, ink, sound — against the
-- knowing it carries.  *Anuyogadvārasūtra* (āgama, c. 1st–5th c. CE)
-- draws the dravya/bhāva division for āvaśyaka and śruta at its
-- opening; the school is Jaina.  Claimed of the source: the division
-- and its names, nothing else.
--
-- WHAT THIS IS.  The certified compiled census.  Mukham's flat count
-- answered "how many of the elder's rules does the act close?" with a
-- number the reader had to trust.  After the reflection weld
-- (SatyaMahavrata), the number is REPLACED BY A LIST OF RECORDS, each
-- carrying the closed rule AND its kernel warrant — semantic truth
-- over every environment — as an ERASED field: present at
-- type-checking, gone at runtime.  The binary is dravya-śruta: what
-- runs is the substance, leaves and ink; what it carried to get built
-- is bhāva, and the kernel saw all of it.  A record of this type
-- CANNOT be constructed for a rule the act did not truly close.
------------------------------------------------------------------------

module DravyaShruta_TheCompiledWordCarriesItsKnowingErasedSoTheBinaryIsScripture where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Equality using (_≡_ ; refl)
open import Agda.Builtin.Sigma using (_,_)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; Eq' ; norm ; समः)
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)

-- the knowledge-portion, crossing erased: usable in @0 positions only
open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
  using (⊨_)
open import NaturalMachine.SatyaMahavrata_TheMouthsTrueWordLiftsToAKernelPathItsFalseWordToARefutationSoTheCompiledActCannotLie
  using (मुख-सत्यम्)
open import Cubical.Data.Equality using (eqToPath)

------------------------------------------------------------------------
-- §1  The certified entry: the rule as substance, the knowing erased.
------------------------------------------------------------------------

record सिद्ध-नियमः : Type where
  constructor siddha
  field
    lhs rhs : Tm
    @0 भावः : ⊨ (lhs , rhs)

------------------------------------------------------------------------
-- §2  The census that cannot lie: an entry exists exactly when the
--     act's own test came back true, and the entry's erased field is
--     the theorem that test earned (मुख-सत्यम् through eqToPath).
------------------------------------------------------------------------

श्रुत-गणना : List Eq' → List सिद्ध-नियमः
श्रुत-गणना [] = []
श्रुत-गणना ((l , r) ∷ es) with समः (norm l) (norm r) in eq
... | true  = siddha l r (मुख-सत्यम् l r (eqToPath eq)) ∷ श्रुत-गणना es
... | false = श्रुत-गणना es

दैर्घ्यम् : {A : Type} → List A → Nat
दैर्घ्यम् []       = zero
दैर्घ्यम् (_ ∷ xs) = suc (दैर्घ्यम् xs)

-- the elder's store, certified: every element warranted, erased
सिद्ध-श्रुतम् : List सिद्ध-नियमः
सिद्ध-श्रुतम् = श्रुत-गणना आगमः

-- the kernel counts the same list the binary prints: the runtime 21
-- and the checked 21 are one computation, witnessed here by refl.
एकविंशतिः : दैर्घ्यम् सिद्ध-श्रुतम् ≡ 21
एकविंशतिः = refl
