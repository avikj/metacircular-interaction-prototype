{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- व्यर्थ-चक्र — the vacuous cycle.
--
-- THE DESCENT DEFECT OF AN INVOLUTION SATISFIES ITS COCYCLE IDENTITY
-- FOR EVERY FEATURE WHATSOEVER.  So that identity separates nothing,
-- and the statement with content is the strictly stronger POINTWISE
-- VANISHING.
--
-- This is a fence, and it is worth putting up before an attractive
-- shortcut is taken.  Given an involution θ and any feature F, the
-- difference
--
--     defect F z  =  F (θ z)  -  F z
--
-- is a coboundary by construction.  Its cocycle identity is therefore
-- automatic — it holds for the constant feature, for the identity, for
-- anything at all — so "the class vanishes" is not a hypothesis about F.
-- Descent is `defect ≡ 0`, and nothing weaker.
--
--   §1  THE COCYCLE IDENTITY IS AUTOMATIC:
--
--         defect F z  +  defect F (θ z)  ≡  0 ,
--
--       for every F and every z, using only θ ∘ θ ≡ id.  Nothing about F
--       is assumed and nothing about F can be concluded.
--
--   §2  WHEREAS VANISHING IS INVARIANCE:  defect F z ≡ 0 ⟺ F (θ z) ≡ F z.
--
--   §3  AND THE TWO ARE GENUINELY DIFFERENT.  For any F not invariant at
--       z, §1 still holds and §2 fails — both at once, exhibited as one
--       pair.  §4 inhabits the hypothesis with a two-point example over
--       ℤ, so the gap is not vacuous for want of a witness.
--
-- THE OTHER HALF — WHY A POSITIVE AGGREGATE IS EQUIVALENT TO POINTWISE
-- VANISHING, which is what lets a single number stand in for the whole
-- family of defects:
--
--   §5  in ℕ a vanishing sum has vanishing summands — `AvarohaNisedha`'s
--       lemma, imported rather than restated — and a product with a
--       positive factor vanishes only if the other factor does.
--
--   §6  hence a POSITIVELY WEIGHTED SUM OF SQUARES vanishes exactly when
--       every entry does, at every index below the fold's depth.  The
--       weights are arbitrary apart from being positive.
--
--   §7  and two aggregates differing by a positive factor vanish
--       together, in both directions.  So a transport that multiplies
--       one defect functional into another by a positive constant does
--       not change what its vanishing says.
--
-- WHAT §§5–7 DO AND DO NOT LICENSE.  They say a positive weighted
-- aggregate is a faithful stand-in for the family of pointwise defects,
-- and that a positive rescaling between two such aggregates is
-- information-preserving.  They say nothing about the SIZE of a nonzero
-- aggregate, and nothing about a supremum: the ℓ^∞ reading of a defect
-- family is a different functional from the weighted sum and is not
-- treated here.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–3 in any ring, for any involution on
-- any type and any feature into it.  §4 at ℤ on the booleans.  §§5–7 in
-- ℕ, for every finite depth and every positive weight family.  NOT
-- claimed: anything about cohomology as such — no H¹ is constructed
-- below, and §1 is the reason none is needed; that any particular
-- feature IS or IS NOT invariant; that a weighted sum over an INFINITE
-- family behaves this way — §6 is at finite depth and no limit is taken;
-- anything about norms, Hilbert–Schmidt or otherwise, or about
-- suprema; and no arithmetic input of any kind.
------------------------------------------------------------------------

module VyarthaCakra_TheDescentDefectSatisfiesItsCocycleIdentityForEveryFeatureSoTheClassSeparatesNothingAndOnlyPointwiseVanishingDoes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Algebra.CommRing using (CommRing→Ring)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notnot)
open import Cubical.Data.Int using (ℤ ; pos ; injPos) renaming (_+_ to _+ℤ_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz ; +-comm) renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Nat.Order
  using (_<_ ; ¬-<-zero ; ≤-split ; pred-≤-pred ; suc-≤-suc ; zero-≤)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; Σ-syntax)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

open import AvarohaNisedha_AnInvertibleArrowAdmitsNoNonzeroAdditiveCostSoNoCostSurvivesAnyGroupValuedReceiver
  using (sum≡0→left≡0)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- PART ONE · The cocycle identity carries no information.
------------------------------------------------------------------------

module _ (M : Ring ℓ) where
  open RingStr (snd M)
  open RingTheory M

  private
    A : Type ℓ
    A = ⟨ M ⟩

    sub-cancel : (x y : A) → (x + (- y)) + y ≡ x
    sub-cancel x y =
        sym (+Assoc x (- y) y) ∙ cong (x +_) (+InvL y) ∙ +IdR x

    fromDiff : (x y : A) → x + (- y) ≡ 0r → x ≡ y
    fromDiff x y h = sym (sub-cancel x y) ∙ cong (_+ y) h ∙ +IdL y

  module _ (Z : Type ℓ') (θ : Z → Z) (θθ : (z : Z) → θ (θ z) ≡ z) where

    defect : (Z → A) → Z → A
    defect F z = F (θ z) + (- F z)

    ------------------------------------------------------------------
    -- १ · AUTOMATIC, FOR EVERY FEATURE.
    ------------------------------------------------------------------

    cocycle-is-automatic : (F : Z → A) (z : Z)
      → defect F z + defect F (θ z) ≡ 0r
    cocycle-is-automatic F z =
        (F (θ z) + (- F z)) + (F (θ (θ z)) + (- F (θ z)))
      ≡⟨ cong (λ w → (F (θ z) + (- F z)) + (F w + (- F (θ z)))) (θθ z) ⟩
        (F (θ z) + (- F z)) + (F z + (- F (θ z)))
      ≡⟨ shape (F (θ z)) (F z) ⟩
        0r ∎
      where
        shape : (p q : A) → (p + (- q)) + (q + (- p)) ≡ 0r
        shape p q =
            sym (+Assoc p (- q) (q + (- p)))
          ∙ cong (p +_) (+Assoc (- q) q (- p))
          ∙ cong (λ w → p + (w + (- p))) (+InvL q)
          ∙ cong (p +_) (+IdL (- p))
          ∙ +InvR p

    ------------------------------------------------------------------
    -- २ · WHEREAS VANISHING IS INVARIANCE.
    ------------------------------------------------------------------

    defect-zero→invariant : (F : Z → A) (z : Z)
      → defect F z ≡ 0r → F (θ z) ≡ F z
    defect-zero→invariant F z h = fromDiff (F (θ z)) (F z) h

    invariant→defect-zero : (F : Z → A) (z : Z)
      → F (θ z) ≡ F z → defect F z ≡ 0r
    invariant→defect-zero F z h = cong (_+ (- F z)) h ∙ +InvR (F z)

    ------------------------------------------------------------------
    -- ३ · AND THE GAP, EXHIBITED AS ONE PAIR.
    ------------------------------------------------------------------

    cocycle-does-not-separate : (F : Z → A) (z : Z)
      → ¬ (F (θ z) ≡ F z)
      → (defect F z + defect F (θ z) ≡ 0r) × (¬ (defect F z ≡ 0r))
    cocycle-does-not-separate F z nz =
      cocycle-is-automatic F z , (λ h → nz (defect-zero→invariant F z h))

------------------------------------------------------------------------
-- ४ · THE HYPOTHESIS IS INHABITED: two points and ℤ.
------------------------------------------------------------------------

private
  ℤR : Ring ℓ-zero
  ℤR = CommRing→Ring ℤCommRing

  mark : Bool → ℤ
  mark true  = pos 1
  mark false = pos 0

not-invariant : ¬ (mark (not false) ≡ mark false)
not-invariant p = snotz (injPos p)

a-nonvanishing-defect :
    (defect ℤR Bool not notnot mark false
       +ℤ defect ℤR Bool not notnot mark (not false) ≡ pos 0)
  × (¬ (defect ℤR Bool not notnot mark false ≡ pos 0))
a-nonvanishing-defect =
  cocycle-does-not-separate ℤR Bool not notnot mark false not-invariant

------------------------------------------------------------------------
-- PART TWO · A positive aggregate is a faithful stand-in.
------------------------------------------------------------------------

private
  sum≡0→right≡0 : (m n : ℕ) → m +ℕ n ≡ 0 → n ≡ 0
  sum≡0→right≡0 m n p = sum≡0→left≡0 n m (+-comm n m ∙ p)

------------------------------------------------------------------------
-- ५ · A PRODUCT WITH A POSITIVE FACTOR VANISHES ONLY IF THE OTHER DOES.
------------------------------------------------------------------------

positive-factor-cancels : (m n : ℕ) → 0 < m → m ·ℕ n ≡ 0 → n ≡ 0
positive-factor-cancels zero    n p q = ⊥-rec (¬-<-zero p)
positive-factor-cancels (suc m) n p q = sum≡0→left≡0 n (m ·ℕ n) q

square-vanishes : (a : ℕ) → a ·ℕ a ≡ 0 → a ≡ 0
square-vanishes zero    _ = refl
square-vanishes (suc a) q = ⊥-rec (snotz (sum≡0→left≡0 (suc a) (a ·ℕ suc a) q))

------------------------------------------------------------------------
-- ६ · SO A POSITIVELY WEIGHTED SUM OF SQUARES IS POINTWISE VANISHING.
------------------------------------------------------------------------

sumℕ : ℕ → (ℕ → ℕ) → ℕ
sumℕ zero    f = 0
sumℕ (suc k) f = f k +ℕ sumℕ k f

sum-head : (k : ℕ) (f : ℕ → ℕ) → sumℕ (suc k) f ≡ 0 → f k ≡ 0
sum-head k f p = sum≡0→left≡0 (f k) (sumℕ k f) p

sum-tail : (k : ℕ) (f : ℕ → ℕ) → sumℕ (suc k) f ≡ 0 → sumℕ k f ≡ 0
sum-tail k f p = sum≡0→right≡0 (f k) (sumℕ k f) p

aggregate-vanishes→pointwise :
    (k : ℕ) (w a : ℕ → ℕ)
  → ((j : ℕ) → 0 < w j)
  → sumℕ k (λ j → w j ·ℕ (a j ·ℕ a j)) ≡ 0
  → (j : ℕ) → j < k → a j ≡ 0
aggregate-vanishes→pointwise zero w a pw p j lt = ⊥-rec (¬-<-zero lt)
aggregate-vanishes→pointwise (suc k) w a pw p j lt with ≤-split (pred-≤-pred lt)
... | inl j<k = aggregate-vanishes→pointwise k w a pw
                  (sum-tail k (λ i → w i ·ℕ (a i ·ℕ a i)) p) j j<k
... | inr j≡k =
  subst (λ i → a i ≡ 0) (sym j≡k)
    (square-vanishes (a k)
      (positive-factor-cancels (w k) (a k ·ℕ a k) (pw k)
        (sum-head k (λ i → w i ·ℕ (a i ·ℕ a i)) p)))

------------------------------------------------------------------------
-- ७ · AND A POSITIVE RESCALING BETWEEN TWO AGGREGATES CHANGES NOTHING.
------------------------------------------------------------------------

rescaling-preserves-vanishing :
    (c X Y : ℕ) → 0 < c → X ≡ c ·ℕ Y
  → (X ≡ 0 → Y ≡ 0) × (Y ≡ 0 → X ≡ 0)
rescaling-preserves-vanishing c X Y pc e =
    (λ h → positive-factor-cancels c Y pc (sym e ∙ h))
  , (λ h → e ∙ cong (c ·ℕ_) h ∙ zeroR c)
  where
    zeroR : (m : ℕ) → m ·ℕ 0 ≡ 0
    zeroR zero    = refl
    zeroR (suc m) = zeroR m
