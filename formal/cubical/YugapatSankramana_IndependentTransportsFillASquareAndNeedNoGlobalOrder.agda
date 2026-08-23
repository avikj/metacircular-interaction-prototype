{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- युगपत्सङ्क्रमणम् — independent transports fill a square, so their
-- relative order is not semantic.
--
-- WHY THIS FILE.  The coordination writings say that an antichain must
-- remain an antichain: independent work must not be flattened into one
-- sovereign sequence.  The cubical lane already contains the opposite
-- boundary (`NaturalMachine.FiniteNonabelianHolonomy.noncommuting`): two
-- transports acting on ONE shared state may have observable order.  What
-- was not standing as one term is the positive half:
--
--   transports acting on INDEPENDENT COORDINATES form the two dimensions
--   of a square, and the two sequential boundary routes are one program.
--
-- Independence is therefore not inferred from silence, timestamps, or a
-- conflict detector.  It is supplied as structure: one equivalence acts
-- on the left factor and leaves the right factor unchanged; the other acts
-- on the right factor and leaves the left unchanged.  That structure
-- produces the square.
--
-- THE CHECKABLE CONTENT.
--
--   §1  lift an equivalence on either coordinate of a product;
--   §2  compose left-then-right and right-then-left;
--   §3  the two composites are equal AS EQUIVALENCES, because their
--       underlying compiler maps are judgmentally the same;
--   §4  `cong ua` lifts that equality into an equality between the two
--       universe paths — the two compilation routes are one path;
--   §5  the square itself is the two-dimensional family
--
--           (i , j) ↦ ua e i × ua f j .
--
-- The result is stronger than endpoint agreement and weaker than a claim
-- that arbitrary programs commute.  It identifies exactly the case in
-- which global serialization has no semantic content: separate factors,
-- separate dimensions, a filled square.
--
-- RELATION TO क्रम / सह.  क्रम is either boundary traversal, first one
-- coordinate and then the other.  सह / युगपत् is the square retaining
-- both dimensions before choosing a boundary order.  The terms are carried
-- from this repository's Jaina क्रम-सह distinction; NO historical text is
-- claimed to state anything about products of equivalences or cubical
-- concurrency.  The mathematics below is cubical type theory.
--
-- WHAT IS NOT CLAIMED.
--
--   * Not that every pair of equivalences commutes.  Shared-state S₃
--     transports in `NaturalMachine.FiniteNonabelianHolonomy` do not.
--   * Not that every causal antichain is definitionally a product.  A
--     factorisation is the receipt of independence and must be supplied.
--   * No distributed protocol, scheduler, runtime, or physical concurrency
--     theorem is implemented here.  This is its semantic kernel only.
--   * No novelty claim for the product functoriality.  The contribution is
--     locating it as the positive cubical counterpart to the repo's
--     noncommuting boundary and to its no-global-order architecture.
--
-- STATUS.  Authored through the GitHub connector in an environment with no
-- Agda executable.  THIS MODULE IS A PROPOSAL, NOT A KERNEL VERDICT.  It is
-- deliberately not wired into `Everything.agda`; merge only after Agda
-- 2.8.0 + cubical v0.9 checks this file and the aggregate root.
------------------------------------------------------------------------

module YugapatSankramana_IndependentTransportsFillASquareAndNeedNoGlobalOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; secEq ; retEq ; equivEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; ΣPathP)

private
  variable
    ℓ : Level
    A B C D : Type ℓ

------------------------------------------------------------------------
-- १ · Each receipt acts on one coordinate and carries the other unchanged.
------------------------------------------------------------------------

वाम-सङ्क्रमणम् : {A B : Type ℓ} → A ≃ B → (C : Type ℓ)
               → (A × C) ≃ (B × C)
वाम-सङ्क्रमणम् e C = isoToEquiv is
  where
  is : Iso (A × C) (B × C)
  Iso.fun is (a , c) = equivFun e a , c
  Iso.inv is (b , c) = invEq e b , c
  Iso.rightInv is (b , c) = ΣPathP (secEq e b , refl)
  Iso.leftInv  is (a , c) = ΣPathP (retEq e a , refl)

दक्षिण-सङ्क्रमणम् : (A : Type ℓ) → {C D : Type ℓ} → C ≃ D
                  → (A × C) ≃ (A × D)
दक्षिण-सङ्क्रमणम् A e = isoToEquiv is
  where
  is : Iso (A × C) (A × D)
  Iso.fun is (a , c) = a , equivFun e c
  Iso.inv is (a , d) = a , invEq e d
  Iso.rightInv is (a , d) = ΣPathP (refl , secEq e d)
  Iso.leftInv  is (a , c) = ΣPathP (refl , retEq e c)

------------------------------------------------------------------------
-- २ · The two क्रम routes around the boundary.
------------------------------------------------------------------------

वामतः-दक्षिणम् : A ≃ B → C ≃ D → (A × C) ≃ (B × D)
वामतः-दक्षिणम् e f =
  compEquiv (वाम-सङ्क्रमणम् e C) (दक्षिण-सङ्क्रमणम् B f)

दक्षिणतः-वामम् : A ≃ B → C ≃ D → (A × C) ≃ (B × D)
दक्षिणतः-वामम् e f =
  compEquiv (दक्षिण-सङ्क्रमणम् A f) (वाम-सङ्क्रमणम् e D)

------------------------------------------------------------------------
-- ३ · Independent sequencing has no semantic order.
--
-- Both compiler routes send (a,c) to (e a,f c).  The equality is between
-- the EQUIVALENCE RECORDS, not only their endpoint values.
------------------------------------------------------------------------

युगपत् : (e : A ≃ B) (f : C ≃ D)
       → वामतः-दक्षिणम् e f ≡ दक्षिणतः-वामम् e f
युगपत् e f = equivEq (funExt λ { (a , c) → refl })

-- Every execution sees the same result, derived from the program equality.
चालन-युगपत् : (e : A ≃ B) (f : C ≃ D) (x : A × C)
             → equivFun (वामतः-दक्षिणम् e f) x
             ≡ equivFun (दक्षिणतः-वामम् e f) x
चालन-युगपत् e f x = cong (λ h → equivFun h x) (युगपत् e f)

------------------------------------------------------------------------
-- ४ · The two universe-level compilation paths are themselves one path.
------------------------------------------------------------------------

मार्ग-युगपत् : (e : A ≃ B) (f : C ≃ D)
              → ua (वामतः-दक्षिणम् e f)
              ≡ ua (दक्षिणतः-वामम् e f)
मार्ग-युगपत् e f = cong ua (युगपत् e f)

------------------------------------------------------------------------
-- ५ · The square retained before either क्रम is selected.
--
-- Its horizontal coordinate is the path `ua e`; its vertical coordinate
-- is `ua f`.  The four corners reduce to A×C, B×C, A×D, B×D.  A linear
-- scheduler sees one boundary route.  Cubical transport keeps the square.
------------------------------------------------------------------------

वर्गः : (e : A ≃ B) (f : C ≃ D) → I → I → Type ℓ
वर्गः e f i j = ua e i × ua f j

वर्ग-आरम्भः : (e : A ≃ B) (f : C ≃ D)
             → वर्गः e f i0 i0 ≡ (A × C)
वर्ग-आरम्भः e f = refl

वर्ग-वाम-अन्तः : (e : A ≃ B) (f : C ≃ D)
                → वर्गः e f i1 i0 ≡ (B × C)
वर्ग-वाम-अन्तः e f = refl

वर्ग-दक्षिण-अन्तः : (e : A ≃ B) (f : C ≃ D)
                   → वर्गः e f i0 i1 ≡ (A × D)
वर्ग-दक्षिण-अन्तः e f = refl

वर्ग-समाप्तिः : (e : A ≃ B) (f : C ≃ D)
              → वर्गः e f i1 i1 ≡ (B × D)
वर्ग-समाप्तिः e f = refl
