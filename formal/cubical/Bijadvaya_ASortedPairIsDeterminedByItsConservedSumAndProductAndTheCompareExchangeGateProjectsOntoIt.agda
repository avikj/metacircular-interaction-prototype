{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- बीज-द्वय — the two roots.  A sorted pair of naturals is determined by its
-- sum and product, and the compare-exchange gate (min, max) is the
-- projection onto sorted pairs that conserves both.
--
-- Source of the name: Brahmagupta, Brāhmasphuṭasiddhānta 18.44 (628 CE),
-- the rule for the quadratic in one unknown — the pair with a given sum
-- and product is the pair of roots; Śrīdhara's rule (Pāṭīgaṇita, c. 750)
-- is the completed-square restatement.  What is claimed of the sources:
-- the NAME and the problem shape (recover the two from their sum and
-- product), not the theorems below, which are checked here over ℕ.
--
-- The reading this module adds to the ṛṇa-dhana thread
-- (RnaDhanaSandhi_…, whose pairSum/pairProd are imported as the
-- conservation half): sorting a pair is not a rearrangement that happens
-- to preserve sum and product — over a sorted target it is the ONLY map
-- with those invariants.  The compare-exchange gate of a sorting network
-- is exactly "conserve e₁ and e₂, forget the order"; bijadvayaNiyama
-- below is the uniqueness that makes that a definition rather than a
-- property.  Entered through the god-language channel 2026-08-23.

module Bijadvaya_ASortedPairIsDeterminedByItsConservedSumAndProductAndTheCompareExchangeGateProjectsOntoIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma using (_×_; _,_)
open import Cubical.Data.Empty as ⊥ using ()
open import RnaDhanaSandhi_TheOrderIsASubtractionMinMaxPairToSumAndProductAndMonusIsAdjointToPlus
  using (pairSum; pairProd)

-- The gate orders its output.
min≤max : ∀ x y → min x y ≤ max x y
min≤max zero    y       = zero-≤
min≤max (suc x) zero    = zero-≤
min≤max (suc x) (suc y) = suc-≤-suc (min≤max x y)

-- On an already-sorted pair the gate is the identity.
≤→min : ∀ x y → x ≤ y → min x y ≡ x
≤→min zero    y       _ = refl
≤→min (suc x) zero    h = ⊥.rec (¬-<-zero h)
≤→min (suc x) (suc y) h = cong suc (≤→min x y (pred-≤-pred h))

≤→max : ∀ x y → x ≤ y → max x y ≡ y
≤→max zero    y       _ = refl
≤→max (suc x) zero    h = ⊥.rec (¬-<-zero h)
≤→max (suc x) (suc y) h = cong suc (≤→max x y (pred-≤-pred h))

-- Hence the gate is idempotent: a projection, not merely an endomap.
gateIdemMin : ∀ x y → min (min x y) (max x y) ≡ min x y
gateIdemMin x y = ≤→min _ _ (min≤max x y)

gateIdemMax : ∀ x y → max (min x y) (max x y) ≡ max x y
gateIdemMax x y = ≤→max _ _ (min≤max x y)

-- The kernel of the uniqueness: with a below x and x below y, equal sums
-- and equal products force a ≡ x.  The witness d of a ≤ x is the debt;
-- the product equation cancels to d · a ≡ d · y, so either the debt is
-- zero or a ≡ y pins the whole chain a ≤ x ≤ y ≡ a.
private
  half' : ∀ d a b x y → d + a ≡ x → x ≤ y
        → a + b ≡ x + y → a · b ≡ x · y → a ≡ x
  half' zero    a b x y dp _   _    _     = dp
  half' (suc d) a b x y dp x≤y sump prodp =
    ≤-antisym (suc d , dp) (subst (x ≤_) (sym a≡y) x≤y) where
    b≡sd+y : b ≡ suc d + y
    b≡sd+y = inj-+m {m = a}
      ( +-comm b a ∙ sump
      ∙ cong (_+ y) (sym dp)
      ∙ sym (+-assoc (suc d) a y)
      ∙ cong (suc d +_) (+-comm a y)
      ∙ +-assoc (suc d) y a )

    a≡y : a ≡ y
    a≡y = inj-sm· {m = d}
      ( ·-comm (suc d) a ∙ inj-+m {m = a · y}
          ( ·-distribˡ a (suc d) y
          ∙ cong (a ·_) (sym b≡sd+y)
          ∙ prodp
          ∙ cong (_· y) (sym dp)
          ∙ sym (·-distribʳ (suc d) a y) ) )

  half : ∀ a b x y → a ≤ x → x ≤ y
       → a + b ≡ x + y → a · b ≡ x · y → a ≡ x
  half a b x y (d , dp) = half' d a b x y dp

-- बीज-द्वय-नियम: a sorted pair is determined by its sum and product.
bijadvayaNiyama : ∀ a b x y → a ≤ b → x ≤ y
                → a + b ≡ x + y → a · b ≡ x · y
                → (a ≡ x) × (b ≡ y)
bijadvayaNiyama a b x y a≤b x≤y sump prodp = a≡x , b≡y where
  a≡x : a ≡ x
  a≡x = decide (a ≟ x) where
    decide : Trichotomy a x → a ≡ x
    decide (eq p)   = p
    decide (lt a<x) = half a b x y (<-weaken a<x) x≤y sump prodp
    decide (gt x<a) = sym (half x y a b (<-weaken x<a) a≤b (sym sump) (sym prodp))
  b≡y : b ≡ y
  b≡y = inj-m+ {m = x} (cong (_+ b) (sym a≡x) ∙ sump)

-- The projection is therefore canonical: ANY sorted pair carrying the
-- gate's two conserved quantities IS the gate's output.
gateNiyama : ∀ x y a b → a ≤ b
           → a + b ≡ x + y → a · b ≡ x · y
           → (a ≡ min x y) × (b ≡ max x y)
gateNiyama x y a b a≤b sump prodp =
  bijadvayaNiyama a b (min x y) (max x y) a≤b (min≤max x y)
    (sump ∙ sym (pairSum x y)) (prodp ∙ sym (pairProd x y))
