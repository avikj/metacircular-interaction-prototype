{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnswerGrading
--
-- Two claims from `papers/hieroglyphics_iii.tex`, proved rather than
-- restated.
--
--   A.  `D_X ⇏ एकमेव कारणम्` -- a defect does not determine its cause, and so
--       `Class(D)` is genuinely extra data.  The same defect admits repairs
--       that are not interchangeable; the classification is a decision, not a
--       computation performed on the defect.
--
--   B.  `अस्तित्व < एकत्व < प्राकृतिकता < सार्वत्रिकता`, with
--       `श्रेष्ठउत्तरम् = सार्वत्रिकगुणधर्मयुक्त उत्तरम्`.  The sign repair of
--       not merely *a* map resolving the defect -- `crush` is that too -- it
--       is the universal sign-blind map, and every sign-blind observation
--       factors through it, uniquely on representatives.
--
-- This answers something the earlier modules left open.  `RepairGrading` and
-- `ObstructionCalculus` established `Γ^ → Γ∅` with no converse, so `Γ^`
-- retains strictly more; neither said what makes `Γ^` the *right* repair
-- rather than merely a larger one.  The universal property is what makes it
-- right, and it is why the document puts `सार्वत्रिकता` above `अस्तित्व` in a
-- chain rather than beside it in a list.
------------------------------------------------------------------------

module AnswerGrading where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; abs ; -_ ; abs- ; injPos)
open import Cubical.Relation.Nullary using (¬_)

open import SmithSignNormal using (absℤ)

private
  variable
    A : Type₀

------------------------------------------------------------------------
-- A.  The defect does not determine the cause.

-- A repair of the pair `x , y` is any observation that stops distinguishing
-- them.
Resolves : {X : Type₀} (x y : X) → (X → A) → Type₀
Resolves x y f = f x ≡ f y

-- `absℤ` resolves the sign defect by choosing the nonnegative representative.
absℤ-resolves : Resolves (pos 6) (negsuc 5) absℤ
absℤ-resolves = refl

-- The constant map resolves it too, by choosing nothing at all: `Γ∅` in its
-- crudest form, and a perfectly valid repair of this defect.
crush : ℤ → ℤ
crush _ = pos 0

crush-resolves : Resolves (pos 6) (negsuc 5) crush
crush-resolves = refl

-- The two repairs disagree, so the defect did not select one of them.
repairs-differ : ¬ (absℤ (pos 6) ≡ crush (pos 6))
repairs-differ p = snotz (injPos p)

-- `Class` is therefore extra data, exactly as the document says.
Class-is-extra :
  Σ[ f ∈ (ℤ → ℤ) ] Σ[ g ∈ (ℤ → ℤ) ]
    ( Resolves (pos 6) (negsuc 5) f
    × Resolves (pos 6) (negsuc 5) g
    × (¬ (f (pos 6) ≡ g (pos 6))) )
Class-is-extra = absℤ , crush , absℤ-resolves , crush-resolves , repairs-differ

------------------------------------------------------------------------
-- B.  The ladder, and where the sign repair sits on it.

-- An observation that cannot see the sign.
SignBlind : (ℤ → A) → Type₀
SignBlind f = (x : ℤ) → f (- x) ≡ f x

-- Both candidate repairs are sign-blind, so this property does not separate
-- them either.  Existence is cheap.
absℤ-signBlind : SignBlind absℤ
absℤ-signBlind x = cong pos (abs- x)

crush-signBlind : SignBlind crush
crush-signBlind _ = refl

-- Every integer is its own nonnegative representative, up to sign.  Three
-- cases, and the only computation in the file.
absℤ-rep : (x : ℤ) → (x ≡ absℤ x) ⊎ (x ≡ - absℤ x)
absℤ-rep (pos n) = inl refl
absℤ-rep (negsuc n) = inr refl

-- **The universal property.**  Every sign-blind observation is already its own
-- factorization through `absℤ`: nothing that cannot see the sign can see the
-- difference between an integer and its representative.
absℤ-factors : (f : ℤ → A) → SignBlind f → (x : ℤ) → f x ≡ f (absℤ x)
absℤ-factors f sb x with absℤ-rep x
... | inl p = cong f p
... | inr p = cong f p ∙ sb (absℤ x)

absℤ-universal : (f : ℤ → A) → SignBlind f
               → Σ[ g ∈ (ℤ → A) ] ((x : ℤ) → f x ≡ g (absℤ x))
absℤ-universal f sb = f , absℤ-factors f sb

-- And the factorization is forced on representatives, which is the `एकत्व`
-- rung: two factorizations of the same observation agree wherever `absℤ`
-- lands.
absℤ-factor-unique :
    (f g h : ℤ → A)
  → ((x : ℤ) → f x ≡ g (absℤ x))
  → ((x : ℤ) → f x ≡ h (absℤ x))
  → (n : ℕ) → g (pos n) ≡ h (pos n)
absℤ-factor-unique f g h pg ph n = sym (pg (pos n)) ∙ ph (pos n)

-- **The crude repair has no such property.**  `crush` resolves the defect and
-- is sign-blind, but sign-blind observations do not factor through it: it
-- discarded information they still need.  This is the gap between `अस्तित्व`
-- and `सार्वत्रिकता`, exhibited rather than asserted.
crush-not-universal :
  ¬ (Σ[ g ∈ (ℤ → ℤ) ] ((x : ℤ) → absℤ x ≡ g (crush x)))
crush-not-universal (g , p) =
  snotz (injPos (p (pos 1) ∙ sym (p (pos 0))))

-- So on this defect the ladder is strict: both repairs exist, only one is
-- universal, and the classification `Γ^` rather than `Γ∅` is what reaches it.
sign-repair-is-best :
    (Σ[ g ∈ (ℤ → ℤ) ] ((x : ℤ) → absℤ x ≡ g (absℤ x)))
  × (¬ (Σ[ g ∈ (ℤ → ℤ) ] ((x : ℤ) → absℤ x ≡ g (crush x))))
sign-repair-is-best =
  absℤ-universal absℤ absℤ-signBlind , crush-not-universal
