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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Chu(X,𝒯,e) and the Advance guard.
--
--   Shrink(𝒯) ⇒ δ↓        अतः  शून्यवक्रता ≠ सत्य
--   δ = 0 ⇏ Advance
--   δ_σ = 0 ⇍ δ_σ^base = 0   (गुह्यवक्रता: the base can be flat while the
--                             fibre is not, so a base-only test is not a test)
--
-- The defect of a Chu space is monotone in the test list: dropping tests can
-- only merge points.  Hence a vanishing defect is a statement about 𝒯, never
-- about X — the empty test list makes every pair agree, and separation is the
-- side condition that keeps δ = 0 informative.

module NaturalMachine.ChuAdvance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Relation.Nullary using (¬_)

private
  BoolCode : Bool → Type₀
  BoolCode true = Unit
  BoolCode false = ⊥

  true≢false : ¬ (true ≡ false)
  true≢false p = subst BoolCode p tt

--------------------------------------------------------------------------
-- e : X × 𝒯 → Q,  and agreement on a finite test list
--------------------------------------------------------------------------

Obs : Type₀ → Type₀ → Type₀
Obs X T = X → T → Bool

Agree : {X T : Type₀} → Obs X T → List T → X → X → Type₀
Agree e [] x y = Unit
Agree e (t ∷ ts) x y = (e x t ≡ e y t) × Agree e ts x y

Separates : {X T : Type₀} → Obs X T → List T → Type₀
Separates {X} e ts = (x y : X) → Agree e ts x y → x ≡ y

--------------------------------------------------------------------------
-- Shrink(𝒯) ⇒ δ↓
--------------------------------------------------------------------------

-- Dropping tests never creates a distinction.
agree-drop :
    {X T : Type₀} (e : Obs X T) (ts ss : List T) (x y : X)
  → Agree e (ts ++ ss) x y
  → Agree e ts x y × Agree e ss x y
agree-drop e [] ss x y a = tt , a
agree-drop e (t ∷ ts) ss x y (p , a) =
  (p , fst (agree-drop e ts ss x y a)) , snd (agree-drop e ts ss x y a)

-- The extreme case: no tests, no defect, for any space whatever.
no-tests-no-defect :
    {X T : Type₀} (e : Obs X T) (x y : X) → Agree e [] x y
no-tests-no-defect e x y = tt

--------------------------------------------------------------------------
-- शून्यवक्रता ≠ सत्य
--------------------------------------------------------------------------

private
  read : Obs Bool Bool
  read x _ = x

-- A Chu space with δ = 0 on its declared tests whose points are not equal:
-- vanishing defect is a property of 𝒯, and Separates is what makes it a
-- property of X.
zero-defect-is-not-truth :
    Σ[ e ∈ Obs Bool Bool ] Σ[ ts ∈ List Bool ]
      (((x y : Bool) → Agree e ts x y) × (¬ Separates e ts))
zero-defect-is-not-truth = read , [] , (λ x y → tt) , λ sep → true≢false (sep true false tt)

-- The same space separates as soon as one honest test is declared.
one-test-separates : Separates read (true ∷ [])
one-test-separates x y (p , _) = p

--------------------------------------------------------------------------
-- गुह्यवक्रता : δ^base = 0 does not lift
--------------------------------------------------------------------------

Hol : Type₀
Hol = ℕ × ℕ

unit : Hol
unit = 0 , 0

base : Hol → ℕ
base = fst

-- π𝔥_σ = 1 ∧ 𝔥̃_σ ≠ 1 : the base loop closes, the total loop does not.
hidden-curvature : Σ[ h ∈ Hol ] (base h ≡ base unit) × (¬ (h ≡ unit))
hidden-curvature = (0 , 1) , refl , λ p → snotz (cong snd p)

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
