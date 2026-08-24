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
-- योगक्षेत्र — the conserving flows of addition are exactly the shear
-- fields, so the freedom of the cut is a function space.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  `Dhruva_….agda` proves the frame (conservation acts
-- inside the fibres; lossless forces Φ ≡ id) and `YogaDhruva_….agda`
-- instantiates it (fiber योग n is a ℤ-torsor under the shears) — and its
-- own header fences that it did NOT classify the conserving
-- endomorphisms.  This module is that classification, for this
-- observable, over an ARBITRARY commutative ring:
--
--   §१  every shear FIELD — a shear whose parameter varies with the
--       point, k : R × R → R — conserves the sum;
--   §२  every conserving flow IS the shear field of its own
--       displacement क्षेत्र-मापः Φ p = fst (Φ p) − fst p;
--   §३  the two constructions are inverse, so
--
--         (Σ[ Φ ] संरक्षणम् योग Φ)  ≃  (R × R → R)
--
--       — the space of conserving flows of addition IS the function
--       space.  One parameter of R per point, no more, no less.
--
-- Read with Dhruva §२ this exhibits the two poles of one statement: a
-- LOSSLESS observable has a contractible flow space (Φ ≡ id, nothing
-- hidden, no room to move), and THIS cut — each fibre a full R-torsor —
-- has a flow space as large as a function space.  The freedom of a cut
-- is measured by its conserving flows, and here the measure is exact.
--
-- PROOF-SHAPE NOTE, following the precedent of `PraksepaTantu_….agda`
-- (landed 2026-08-22 as the shape a तपस् fst/snd emitter instantiates):
-- everything below is parametric in the CommRing, and every ring fact is
-- discharged by the solver, so this is the shape a future T-SHEAR
-- emitter would instantiate at any additive observable the census
-- meets.  The ℤ instance is taken at the end in one line.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  Nothing about a general observable f : A → B —
-- the classification is for THIS f (binary addition on R × R) and its
-- proof uses the ring structure; no Noether theorem, no Lagrangian, no
-- continuity (Dhruva's fence applies verbatim).  "Freedom" is a reading
-- made in this header; the theorems are §१–§३.  The flows here are bare
-- endomorphisms: no invertibility is assumed, and none follows — a
-- shear field with k depending on the point is in general NOT injective,
-- which is why YogaDhruva's constant-shear ℤ-action was a torsor and
-- this space is bigger.
--
-- TERM.  क्षेत्र — field — is the standard term of the gaṇita tradition
-- for a plane figure: Āryabhaṭa, आर्यभटीयम्, Gaṇitapāda (499), and the
-- क्षेत्रव्यवहार chapter of Bhāskara II's लीलावती (1150).  LIMIT: the
-- sources attest the word for a geometric figure/ground; its use here
-- for a QUANTITY ASSIGNED OVER A DOMAIN (the sense physics gives
-- "field") is this corpus's, and no text is claimed for the compound
-- योगक्षेत्र.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed version), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module YogaKsetra_TheConservingFlowsOfAdditionAreExactlyTheShearFields where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry

module क्षेत्रम् {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd)

  private
    R : Type ℓ
    R = fst R'

  -- the observable, and a shear whose parameter varies with the point
  योग : R × R → R
  योग (a , b) = a + b

  शियरक्षेत्र : (R × R → R) → R × R → R × R
  शियरक्षेत्र k (a , b) = (a + k (a , b)) , (b - k (a , b))

  -- the displacement a flow shows in the first coordinate
  क्षेत्र-मापः : (R × R → R × R) → R × R → R
  क्षेत्र-मापः Φ p = fst (Φ p) - fst p

  -- ring arithmetic, discharged by the solver over the abstract ring ---
  private
    A1 : (a x : R) → a + (x - a) ≡ x
    A1 _ _ = solve! R'
    A2a : (a b x : R) → b - (x - a) ≡ (a + b) - x
    A2a _ _ _ = solve! R'
    A2b : (x y : R) → (x + y) - x ≡ y
    A2b _ _ = solve! R'
    A3 : (a x : R) → (a + x) - a ≡ x
    A3 _ _ = solve! R'
    A4 : (a b k : R) → (a + k) + (b - k) ≡ a + b
    A4 _ _ _ = solve! R'

    -- b − (x − a) ≡ y, given that x + y and a + b agree
    A2 : (x y a b : R) → x + y ≡ a + b → b - (x - a) ≡ y
    A2 x y a b h = A2a a b x ∙ cong (_- x) (sym h) ∙ A2b x y

  ------------------------------------------------------------------
  -- §१ · every shear field conserves the sum
  ------------------------------------------------------------------

  व्यापक-संरक्षण : (k : R × R → R) → संरक्षणम् योग (शियरक्षेत्र k)
  व्यापक-संरक्षण k (a , b) = A4 a b (k (a , b))

  ------------------------------------------------------------------
  -- §२ · every conserving flow is the shear field of its displacement
  ------------------------------------------------------------------

  एकरूपता : (Φ : R × R → R × R) → संरक्षणम् योग Φ
          → (p : R × R) → शियरक्षेत्र (क्षेत्र-मापः Φ) p ≡ Φ p
  एकरूपता Φ cons p i =
    A1 (fst p) (fst (Φ p)) i ,
    A2 (fst (Φ p)) (snd (Φ p)) (fst p) (snd p) (cons p) i

  ------------------------------------------------------------------
  -- §३ · the classification: conserving flows ≃ fields
  ------------------------------------------------------------------

  समता-Iso : Iso (Σ[ Φ ∈ (R × R → R × R) ] संरक्षणम् योग Φ)
                 (R × R → R)
  Iso.fun समता-Iso (Φ , _)      = क्षेत्र-मापः Φ
  Iso.inv समता-Iso k            = शियरक्षेत्र k , व्यापक-संरक्षण k
  Iso.rightInv समता-Iso k       = funExt (λ p → A3 (fst p) (k p))
  Iso.leftInv समता-Iso (Φ , cons) =
    Σ≡Prop (λ Φ' → isPropΠ (λ p → is-set _ _))
           (funExt (एकरूपता Φ cons))

  समता : (Σ[ Φ ∈ (R × R → R × R) ] संरक्षणम् योग Φ) ≃ (R × R → R)
  समता = isoToEquiv समता-Iso

------------------------------------------------------------------------
-- The ℤ instance, one line: the conserving flows of integer addition
-- are exactly the maps ℤ × ℤ → ℤ.
------------------------------------------------------------------------

module ℤक्षेत्रम् = क्षेत्रम् ℤCommRing
