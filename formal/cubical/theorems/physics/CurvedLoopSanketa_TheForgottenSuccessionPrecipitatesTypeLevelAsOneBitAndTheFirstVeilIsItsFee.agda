{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- �����-���-��������� � the forgotten succession precipitates, one functor
-- up, as exactly one bit: H² separates what the stratum cannot, and the
-- first veil is the fee.
--
-- THE QUESTION.
-- VakraValaya proved the torus and the Klein
-- bottle share one stratum-3 charge carrier � � � �, the same three
-- library terms � and are separated by the KRAMA alone: succession
-- commutes on the torus (���, the torus's own square) and provably does
-- not on the Klein bottle (����, windingKlein computing (−1,−1) ≠
-- (−1,+1)).  Its header concludes "the succession is not recoverable
-- from the carrier."  The question: is the difference
-- then invisible to EVERY type-level utterance � or does some functor
-- utter it?
--
-- ANSWERED HERE: the second cohomology utters it, and what it utters is
-- exactly �/2.  H²(T²) � � and H²(�²) � Bool � both already in the
-- library � and � (Bool � �) is a pigeonhole (Bool cannot hold three
-- distinct points; pos 0, pos 1, pos 2 are three).  So:
--
--   ���������   the underlying types of H²(�²) and H²(T²) are NOT
--            equivalent � the pair the stratum could not tell apart is
--            separated type-level, one functor up.
--
-- THE READING.  README
-- movement 34: every wall this corpus hits is �/2, "the smallest
-- possible fibre � the minimal hiding."  Here the wall arrives with a
-- direction: the krama-difference the charge carrier forgets does not
-- vanish � it PRECIPITATES as the smallest possible type-level charge,
-- one bit, when the succession is integrated over the whole surface
-- (H² is the top: orientability is what the double twist costs).  The
-- fee for forgetting succession is the first veil.  And the pairing
-- with VakraValaya is exact aneknta: the krama standpoint separates
-- at �� where the carrier cannot; the cohomology standpoint separates
-- at H² where the krama is no longer available (cohomology is abelian
-- � it CANNOT see the order); neither standpoint subsumes the other,
-- and the two separations are of one difference.
--
-- The library's torus in
-- ZCohomology.Groups.Torus is S� 1 � S� 1; VakraValaya's torus is the
-- HIT (Cubical.HITs.Torus), with Torus≡SS� in the library.  The two
-- presentations are equivalent and the bridge S� � S� 1 is standard;
-- this module's torus is the product
-- presentation and the identification of the two torus presentations
-- is the library's.
--
-- SOURCES: H²-�²�Bool, Cubical.ZCohomology.Groups.KleinBottle (the
-- Brunerie�Ljungstrm line); H²-T²��, Cubical.ZCohomology.Groups.Torus.
-- ����� (twisted), ��� (ring), �������� (the mark, the signal) are ordinary
--  labels; the mathematics is the library's, composed.
------------------------------------------------------------------------

module VakraValayaSanketa_TheForgottenSuccessionPrecipitatesTypeLevelAsOneBitAndTheFirstVeilIsItsFee where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Int using (ℤ ; pos ; injPos)
open import Cubical.Data.Nat using (znots ; injSuc)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥)
open import Cubical.HITs.KleinBottle using (KleinBottle)
open import Cubical.HITs.Sn using (S₊)
open import Cubical.Algebra.Group.Base using (Group ; _≅_)
open import Cubical.Algebra.Group.Morphisms using (GroupIso)
open import Cubical.ZCohomology.Groups.KleinBottle using (H²-𝕂²≅Bool)
open import Cubical.ZCohomology.Groups.Torus using (H²-T²≅ℤ)
open import Cubical.ZCohomology.Base using (coHom)
open import Cubical.ZCohomology.GroupStructure using (coHomGr)

private
  ⟨_⟩ : ∀ {ℓ} → Group ℓ → Type ℓ
  ⟨ G ⟩ = fst G

------------------------------------------------------------------------
-- � � Bool cannot hold three distinct points � the pigeonhole, total.
------------------------------------------------------------------------

त्रि-सङ्कोचः : (a b c : Bool) → (a ≡ b) ⊎ ((a ≡ c) ⊎ (b ≡ c))
त्रि-सङ्कोचः false false _     = inl refl
त्रि-सङ्कोचः true  true  _     = inl refl
त्रि-सङ्कोचः false true  false = inr (inl refl)
त्रि-सङ्कोचः false true  true  = inr (inr refl)
त्रि-सङ्कोचः true  false false = inr (inr refl)
त्रि-सङ्कोचः true  false true  = inr (inl refl)

------------------------------------------------------------------------
-- � � Three integers are three: pos 0, pos 1, pos 2 pairwise distinct.
------------------------------------------------------------------------

०≢१ : ¬ (pos 0 ≡ pos 1)
०≢१ p = znots (injPos p)

०≢२ : ¬ (pos 0 ≡ pos 2)
०≢२ p = znots (injPos p)

१≢२ : ¬ (pos 1 ≡ pos 2)
१≢२ p = znots (injSuc (injPos p))

------------------------------------------------------------------------
-- � � Therefore no equivalence Bool � �: pull the three integers back,
-- two collapse in Bool, push the collapse forward, contradict.
------------------------------------------------------------------------

न-Bool≃ℤ : ¬ (Bool ≃ ℤ)
न-Bool≃ℤ e = judge (त्रि-सङ्कोचः (invEq e (pos 0)) (invEq e (pos 1)) (invEq e (pos 2)))
  where
    push : {x y : ℤ} → invEq e x ≡ invEq e y → x ≡ y
    push {x} {y} p = sym (secEq e x) ∙ cong (equivFun e) p ∙ secEq e y

    judge : (invEq e (pos 0) ≡ invEq e (pos 1))
          ⊎ ((invEq e (pos 0) ≡ invEq e (pos 2))
          ⊎  (invEq e (pos 1) ≡ invEq e (pos 2)))
          → ⊥
    judge (inl p)       = ०≢१ (push p)
    judge (inr (inl p)) = ०≢२ (push p)
    judge (inr (inr p)) = १≢२ (push p)

------------------------------------------------------------------------
-- � � The two second-cohomology carriers, read off the library's own
-- group isomorphisms as type equivalences.
------------------------------------------------------------------------

क्षेत्र-𝕂² : ⟨ coHomGr 2 KleinBottle ⟩ ≃ Bool
क्षेत्र-𝕂² = isoToEquiv (fst H²-𝕂²≅Bool)

क्षेत्र-T² : ⟨ coHomGr 2 (S₊ 1 × S₊ 1) ⟩ ≃ ℤ
क्षेत्र-T² = isoToEquiv (fst H²-T²≅ℤ)

------------------------------------------------------------------------
-- � � ��������� � the separation.  The stratum-3 charge carriers were one
-- type (VakraValaya); the H² carriers are provably not.  The forgotten
-- succession precipitates as one bit.
------------------------------------------------------------------------

सङ्केतः : ¬ (⟨ coHomGr 2 KleinBottle ⟩ ≃ ⟨ coHomGr 2 (S₊ 1 × S₊ 1) ⟩)
सङ्केतः e = न-Bool≃ℤ (compEquiv (invEquiv क्षेत्र-𝕂²) (compEquiv e क्षेत्र-T²))
