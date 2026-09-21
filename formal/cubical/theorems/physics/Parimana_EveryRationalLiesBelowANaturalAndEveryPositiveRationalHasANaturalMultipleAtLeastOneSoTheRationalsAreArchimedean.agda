{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परिमाण — measure.  The Archimedean property of ℚ.
--
-- The finite growth theorem (Vrddhi) needs the modes to outrun every
-- bound, and that needs the Archimedean property, which the library does
-- not state.  Here it is, read off on representatives:
--
--   §1  ι n = [n/1]: the natural embedding computes to the representative.
--   §2  EVERY RATIONAL LIES BELOW A NATURAL: [a/b] < ι (1 + |a|).
--   §3  EVERY POSITIVE RATIONAL HAS A NATURAL MULTIPLE AT LEAST ONE:
--       for x = [c/d] with c > 0, 1 ≤ ι d · x.
--   §4  ARCHIMEDES: for x > 0 and any K there merely exists t with
--       K < ι t · x, namely t = n · q with the n and q of §2, §3.
--
-- The existentials are propositionally truncated: the witness is read
-- off a representative, and different representatives give different
-- witnesses.  परिमाण (parimāṇa, measure) is ordinary Sanskrit.
------------------------------------------------------------------------

module Parimana_EveryRationalLiesBelowANaturalAndEveryPositiveRationalHasANaturalMultipleAtLeastOneSoTheRationalsAreArchimedean where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; +-zero ; +-suc) renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.NatPlusOne using (ℕ₊₁ ; 1+_ ; ℕ₊₁→ℕ ; _·₊₁_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_)
import Cubical.Data.Int as ℤ
import Cubical.Data.Int.Order as ℤO
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁ ; squash₁)
open import Cubical.HITs.SetQuotients using ([]surjective)
open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-·o ; isTrans<≤)

open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (ι ; ι-anṛṇa)

open ℤ using (ℤ ; pos ; negsuc)

------------------------------------------------------------------------
-- १ · ι n computes to [n/1].
------------------------------------------------------------------------

ι-rep : (n : ℕ) → ι n ≡ [ pos n / 1 ]
ι-rep zero    = refl
ι-rep (suc n) = cong (_+ 1) (ι-rep n) ∙ eq/ _ _ sākṣī
  where
  -- (pos n · 1 + 1 · 1) · 1 ≡ pos (suc n) · 1
  sākṣī : (pos n ℤ.· pos 1 ℤ.+ pos 1 ℤ.· pos 1) ℤ.· pos 1 ≡ pos (suc n) ℤ.· pos 1
  sākṣī = ℤ.·IdR _ ∙ cong (ℤ._+ pos 1) (ℤ.·IdR (pos n)) ∙ sym (ℤ.·IdR (pos (suc n)))

------------------------------------------------------------------------
-- २ · Every rational lies below a natural.
------------------------------------------------------------------------

-- a < 1 + |a| in ℤ
abs-upari : (a : ℤ) → a ℤO.< pos (suc (ℤ.abs a))
abs-upari (pos k)    = 0 , refl
abs-upari (negsuc k) = ℤO.negsuc<pos

-- 1 ≤ pos (suc k)
eka-≤ : (k : ℕ) → pos 1 ℤO.≤ pos (suc k)
eka-≤ k = k , sym (ℤ.pos+ 1 k)

-- pos s ≤ pos s · pos (suc k)
guṇa-upari : (s k : ℕ) → pos s ℤO.≤ pos s ℤ.· pos (suc k)
guṇa-upari s k = subst2 ℤO._≤_ (ℤ.·IdL (pos s)) (ℤ.·Comm (pos (suc k)) (pos s)) (ℤO.≤-·o {k = s} (eka-≤ k))

-- [a/b] < [1 + |a| / 1], on representatives
rep-upari : (a : ℤ) (b : ℕ₊₁) → [ a / b ] < [ pos (suc (ℤ.abs a)) / 1 ]
rep-upari a (1+ b₀) =
  subst (ℤO._< pos (suc (ℤ.abs a)) ℤ.· pos (suc b₀)) (sym (ℤ.·IdR a))
    (ℤO.<≤-trans (abs-upari a) (guṇa-upari (suc (ℤ.abs a)) b₀))

upari : (K : ℚ) → ∥ Σ[ n ∈ ℕ ] K < ι n ∥₁
upari K = PT.rec squash₁
  (λ { ((a , b) , p) → ∣ suc (ℤ.abs a) , subst2 _<_ p (sym (ι-rep (suc (ℤ.abs a)))) (rep-upari a b) ∣₁ })
  ([]surjective K)

------------------------------------------------------------------------
-- ३ · Every positive rational has a natural multiple at least one.
------------------------------------------------------------------------

-- a positive integer is a successor
dhana-suc : (c : ℤ) → pos 0 ℤO.< c → Σ[ k ∈ ℕ ] c ≡ pos (suc k)
dhana-suc (pos zero)    lt = ⊥-elim (ℤO.isIrrefl< lt)
dhana-suc (pos (suc k)) _  = k , refl
dhana-suc (negsuc k)    lt = ⊥-elim (ℤO.isAsym< lt (ℤO.<-weaken ℤO.negsuc<-zero))

-- pos (suc d₀) ≤ pos (suc d₀) · c for c = pos (suc k)
rep-guṇaka : (d₀ k : ℕ) → pos 1 ℤ.· ℕ₊₁→ℤ ((1+ 0) ·₊₁ (1+ d₀)) ℤO.≤ (pos (suc d₀) ℤ.· pos (suc k)) ℤ.· pos 1
rep-guṇaka d₀ k =
  subst2 ℤO._≤_ (sym (ℤ.·IdL _ ∙ cong (λ z → pos (suc z)) (+-zero d₀)))
                (sym (ℤ.·IdR _))
    (guṇa-upari (suc d₀) k)

guṇaka : (x : ℚ) → 0 < x → ∥ Σ[ q ∈ ℕ ] 1 ≤ ι q · x ∥₁
guṇaka x 0<x = PT.rec squash₁ go ([]surjective x)
  where
  go : Σ[ r ∈ ℤ × ℕ₊₁ ] [ r ] ≡ x → ∥ Σ[ q ∈ ℕ ] 1 ≤ ι q · x ∥₁
  go ((c , 1+ d₀) , p) with dhana-suc c (subst (pos 0 ℤO.<_) (ℤ.·IdR c) (subst (0 <_) (sym p) 0<x))
  ... | (k , e) = ∣ suc d₀ , lemma ∣₁
    where
    base : 1 ≤ [ pos (suc d₀) / 1 ] · [ pos (suc k) / 1+ d₀ ]
    base = rep-guṇaka d₀ k
    base′ : 1 ≤ [ pos (suc d₀) / 1 ] · [ c / 1+ d₀ ]
    base′ = subst (λ z → 1 ≤ [ pos (suc d₀) / 1 ] · [ z / 1+ d₀ ]) (sym e) base
    lemma : 1 ≤ ι (suc d₀) · x
    lemma = subst (1 ≤_) (cong₂ _·_ (sym (ι-rep (suc d₀))) p) base′

------------------------------------------------------------------------
-- ४ · Archimedes.
------------------------------------------------------------------------

ι-yoga : (m n : ℕ) → ι (m +ℕ n) ≡ ι m + ι n
ι-yoga m zero    = cong ι (+-zero m) ∙ sym (+IdR (ι m))
ι-yoga m (suc n) = cong ι (+-suc m n) ∙ cong (_+ 1) (ι-yoga m n) ∙ sym (+Assoc (ι m) (ι n) 1)

ι-guṇa : (m n : ℕ) → ι (m ·ℕ n) ≡ ι m · ι n
ι-guṇa zero    n = sym (·AnnihilL (ι n))
ι-guṇa (suc m) n = ι-yoga n (m ·ℕ n) ∙ cong (ι n +_) (ι-guṇa m n)
                 ∙ sym (·DistR+ (ι m) 1 (ι n) ∙ cong (ι m · ι n +_) (·IdL (ι n)) ∙ +Comm (ι m · ι n) (ι n))

archimedes : (x : ℚ) → 0 < x → (K : ℚ) → ∥ Σ[ t ∈ ℕ ] K < ι t · x ∥₁
archimedes x 0<x K =
  PT.rec squash₁ (λ { (n , K<n) → PT.rec squash₁ (λ { (q , 1≤qx) →
    ∣ n ·ℕ q , isTrans<≤ K (ι n) (ι (n ·ℕ q) · x) K<n
        (subst (ι n ≤_) (sym (cong (_· x) (ι-guṇa n q) ∙ sym (·Assoc (ι n) (ι q) x)))
          (subst (_≤ ι n · (ι q · x)) (·IdR (ι n))
            (subst2 _≤_ (·Comm 1 (ι n)) (·Comm (ι q · x) (ι n))
              (≤-·o 1 (ι q · x) (ι n) (ι-anṛṇa n) 1≤qx)))) ∣₁ })
    (guṇaka x 0<x) })
  (upari K)
