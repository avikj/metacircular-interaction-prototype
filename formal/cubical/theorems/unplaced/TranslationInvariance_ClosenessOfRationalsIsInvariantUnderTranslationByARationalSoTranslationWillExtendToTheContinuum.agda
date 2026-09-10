{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TranslationInvariance — on the continuum module's rationals,
--
--     Close ε (p + s) (q + s)  ⟺  Close ε p q,
--
-- for every ε, p, q, s.  This is the rational lemma from which
-- translation by a rational extends to the continuum ℝ: the extension
-- is by the HIIT's own recursion (the next module), and its only
-- arithmetic input is this invariance, which is what makes the map
-- respect the closeness relation and hence the path constructor.
--
-- HOW.  Through ContinuumBridge, closeness is the library-integer
-- statement |D| · (1 + den ε) < num ε · (1 + den(p − q)).  Translating
-- both p and q by s multiplies D by (1 + den s)² and multiplies the
-- denominator factor by the same square (a ring identity, by the
-- solver), and the strict order is invariant under scaling by a
-- positive integer, in both directions.
--
--   §1  addition on the continuum module's ℚ, and its numerator and
--       denominator read through the bridge;
--   §2  the scaling identity D(p+s, q+s) ≡ (1+ds)² · D(p, q);
--   §3  strict order is invariant under positive scaling (both ways),
--       and |k·z| = k·|z|;
--   §4  THE INVARIANCE, both directions.
--
-- SYĀT.  Rational arithmetic and one order lemma; the continuum itself
-- is not touched here.
------------------------------------------------------------------------

module TranslationInvariance_ClosenessOfRationalsIsInvariantUnderTranslationByARationalSoTranslationWillExtendToTheContinuum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; abs ; -_) renaming (_+_ to _+i_ ; _·_ to _·i_)
open import Cubical.Data.Int.Properties using (pos·pos ; pos·negsuc ; abs-)
open import Cubical.Data.Int.Order using (_≟_ ; lt ; eq ; gt ; <-·o ; isIrrefl< ; isTrans<) renaming (_<_ to _<ℤ_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver
open import Cubical.Tactics.NatSolver

import SantataDhara_TheContinuumBuiltFromTheAxiomsWithItsLimitsAsConstructors as S
open S.ℚ using (num ; den)
open S.ℚ⁺ using (num⁺ ; den⁺)
open import ContinuumBridge_TheContinuumModulesOwnIntegersAreReflectedIntoTheLibrarysWithAdditionMultiplicationAndOrderSoClosenessIsAnOrderStatement

------------------------------------------------------------------------
-- §1  addition on ℚ
------------------------------------------------------------------------

_+ℚ_ : S.ℚ → S.ℚ → S.ℚ
p +ℚ s = ((num p S.·ℤ S.pos (suc (den s))) S.+ℤ (num s S.·ℤ S.pos (suc (den p))))
         S./1+ (den p + den s + den p · den s)

sum-num : (p s : S.ℚ) → toℤ (num (p +ℚ s)) ≡ toℤ (num p) ·i pos (suc (den s)) +i toℤ (num s) ·i pos (suc (den p))
sum-num p s = toℤ-+ (num p S.·ℤ S.pos (suc (den s))) (num s S.·ℤ S.pos (suc (den p))) ∙ cong₂ _+i_ (toℤ-· (num p) (S.pos (suc (den s)))) (toℤ-· (num s) (S.pos (suc (den p))))

-- 1 + (a + b + a·b) = (1 + a)(1 + b)
suc-mul : (a b : ℕ) → suc (a + b + a · b) ≡ suc a · suc b
suc-mul a b = solveℕ!

sum-den : (p s : S.ℚ) → pos (suc (den (p +ℚ s))) ≡ pos (suc (den p)) ·i pos (suc (den s))
sum-den p s = cong pos (suc-mul (den p) (den s)) ∙ pos·pos (suc (den p)) (suc (den s))

------------------------------------------------------------------------
-- §2  the scaling identity
------------------------------------------------------------------------

private
  scale-id : (P Q Sn dp dq ds : ℤ)
           → (P ·i ds +i Sn ·i dp) ·i (dq ·i ds) +i (- ((Q ·i ds +i Sn ·i dq) ·i (dp ·i ds)))
           ≡ (ds ·i ds) ·i (P ·i dq +i (- (Q ·i dp)))
  scale-id P Q Sn dp dq ds = solve! ℤCommRing

D-scale : (p q s : S.ℚ) → D (p +ℚ s) (q +ℚ s) ≡ (pos (suc (den s)) ·i pos (suc (den s))) ·i D p q
D-scale p q s =
  cong₂ (λ x y → x +i (- y))
    (cong₂ _·i_ (sum-num p s) (sum-den q s))
    (cong₂ _·i_ (sum-num q s) (sum-den p s))
  ∙ scale-id (toℤ (num p)) (toℤ (num q)) (toℤ (num s)) (pos (suc (den p))) (pos (suc (den q))) (pos (suc (den s)))

------------------------------------------------------------------------
-- §3  order under positive scaling; absolute value of a scaled integer
------------------------------------------------------------------------

unscale< : (x y : ℤ) (k : ℕ) → x ·i pos (suc k) <ℤ y ·i pos (suc k) → x <ℤ y
unscale< x y k h with x ≟ y
... | lt x<y = x<y
... | eq x≡y = ⊥-rec (isIrrefl< (subst (λ z → x ·i pos (suc k) <ℤ z ·i pos (suc k)) (sym x≡y) h))
... | gt y<x = ⊥-rec (isIrrefl< (isTrans< h (<-·o {k = k} y<x)))

abs-scale : (k : ℕ) (z : ℤ) → abs (pos k ·i z) ≡ k · abs z
abs-scale k (pos n) = cong abs (sym (pos·pos k n))
abs-scale k (negsuc n) = cong abs (pos·negsuc k n) ∙ abs- (pos k ·i pos (suc n)) ∙ cong abs (sym (pos·pos k (suc n)))

------------------------------------------------------------------------
-- §4  THE INVARIANCE
------------------------------------------------------------------------

private
  -- the square (1 + ds)², as pos of a successor: definitionally
  -- suc ds · suc ds = suc (ds + ds · suc ds)
  K : ℕ → ℕ
  K ds = ds + ds · suc ds

  -- |D(p+s, q+s)| = (1+ds)² |D(p, q)|, as library integers
  absD-scale : (p q s : S.ℚ) → pos (abs (D (p +ℚ s) (q +ℚ s))) ≡ pos (suc (K (den s))) ·i pos (abs (D p q))
  absD-scale p q s =
    cong (λ z → pos (abs z)) (D-scale p q s ∙ cong (_·i D p q) (sym (pos·pos (suc (den s)) (suc (den s)))))
    ∙ cong pos (abs-scale (suc (den s) · suc (den s)) (D p q))
    ∙ pos·pos (suc (den s) · suc (den s)) (abs (D p q))

  -- the denominator factor scales by the same square
  den-scale : (p q s : S.ℚ)
            → pos (suc (den (p +ℚ s) + den (q +ℚ s) + den (p +ℚ s) · den (q +ℚ s)))
            ≡ pos (suc (K (den s))) ·i pos (suc (den p + den q + den p · den q))
  den-scale p q s =
    cong pos (suc-mul (den (p +ℚ s)) (den (q +ℚ s)))
    ∙ pos·pos (suc (den (p +ℚ s))) (suc (den (q +ℚ s)))
    ∙ cong₂ _·i_ (sum-den p s) (sum-den q s)
    ∙ regroup (pos (suc (den p))) (pos (suc (den s))) (pos (suc (den q)))
    ∙ cong₂ _·i_ (sym (pos·pos (suc (den s)) (suc (den s)))) (sym (cong pos (suc-mul (den p) (den q)) ∙ pos·pos (suc (den p)) (suc (den q))))
    where
      regroup : (a s b : ℤ) → (a ·i s) ·i (b ·i s) ≡ (s ·i s) ·i (a ·i b)
      regroup a s b = solve! ℤCommRing

  -- the two sides of closeℤ after translation, in scaled form
  lhs-scaled : (ε : S.ℚ⁺) (p q s : S.ℚ)
             → pos (abs (D (p +ℚ s) (q +ℚ s))) ·i pos (suc (den⁺ ε))
             ≡ (pos (abs (D p q)) ·i pos (suc (den⁺ ε))) ·i pos (suc (K (den s)))
  lhs-scaled ε p q s = cong (_·i pos (suc (den⁺ ε))) (absD-scale p q s) ∙ shuffle (pos (suc (K (den s)))) (pos (abs (D p q))) (pos (suc (den⁺ ε)))
    where
      shuffle : (k a e : ℤ) → (k ·i a) ·i e ≡ (a ·i e) ·i k
      shuffle k a e = solve! ℤCommRing

  rhs-scaled : (ε : S.ℚ⁺) (p q s : S.ℚ)
             → pos (suc (num⁺ ε)) ·i pos (suc (den (p +ℚ s) + den (q +ℚ s) + den (p +ℚ s) · den (q +ℚ s)))
             ≡ (pos (suc (num⁺ ε)) ·i pos (suc (den p + den q + den p · den q))) ·i pos (suc (K (den s)))
  rhs-scaled ε p q s = cong (pos (suc (num⁺ ε)) ·i_) (den-scale p q s) ∙ shuffle (pos (suc (num⁺ ε))) (pos (suc (K (den s)))) (pos (suc (den p + den q + den p · den q)))
    where
      shuffle : (n k d : ℤ) → n ·i (k ·i d) ≡ (n ·i d) ·i k
      shuffle n k d = solve! ℤCommRing

closeℤ-translate : (ε : S.ℚ⁺) (p q s : S.ℚ) → closeℤ ε p q → closeℤ ε (p +ℚ s) (q +ℚ s)
closeℤ-translate ε p q s c =
  subst2 _<ℤ_ (sym (lhs-scaled ε p q s)) (sym (rhs-scaled ε p q s)) (<-·o {k = K (den s)} c)

closeℤ-untranslate : (ε : S.ℚ⁺) (p q s : S.ℚ) → closeℤ ε (p +ℚ s) (q +ℚ s) → closeℤ ε p q
closeℤ-untranslate ε p q s c =
  unscale< _ _ (K (den s)) (subst2 _<ℤ_ (lhs-scaled ε p q s) (rhs-scaled ε p q s) c)

-- on the continuum module's own relation
Close-translate : (ε : S.ℚ⁺) (p q s : S.ℚ) → S.Close ε p q → S.Close ε (p +ℚ s) (q +ℚ s)
Close-translate ε p q s c = closeℤ→Close ε (p +ℚ s) (q +ℚ s) (closeℤ-translate ε p q s (Close→closeℤ ε p q c))

Close-untranslate : (ε : S.ℚ⁺) (p q s : S.ℚ) → S.Close ε (p +ℚ s) (q +ℚ s) → S.Close ε p q
Close-untranslate ε p q s c = closeℤ→Close ε p q (closeℤ-untranslate ε p q s (Close→closeℤ ε (p +ℚ s) (q +ℚ s) c))
