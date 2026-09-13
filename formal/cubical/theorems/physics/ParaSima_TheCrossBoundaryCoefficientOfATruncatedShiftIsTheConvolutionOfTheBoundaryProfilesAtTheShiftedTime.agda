{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पार-सीमा — across the boundary.
--
-- Place a profile f against the left end of the window [0, t) and a
-- profile g against the right end, J⁺g (x) = g (t − x).  A right shift
-- by a carries f toward g, and the pairing of the shifted f against the
-- right profile is
--
--     ⟨J⁺g , S_a f⟩  =  Σ_{r < t − a}  f(r) · g((t − a) − r)  =  h_{f,g}(t − a),
--
-- the convolution of the two boundary profiles at the shifted time.
-- Summed over shifts a = log n with weights Λ(n)/√n, the cross-boundary
-- block of the finite prime-translation operator is
-- Σ_n Λ(n)/√n · h_{f,g}(t − log n): the centred boundary reading B_h(t)
-- is not an invented statistic, it is this matrix coefficient.  On the
-- discrete window the identity is exact, and this file proves it.
--
--   §1  OFFSET SUMS: Σ over x from s, count n.  Splitting a range; the
--       shift law that reindexes a summand reading x − s; vanishing and
--       extensionality restricted to the range.
--   §2  THE PAIRING against the right boundary.
--   §3  THE CROSSING IDENTITY, for t = a + u: the terms x < a vanish
--       (nothing has arrived), and the terms x ≥ a reindex by x = r + a,
--       with (a + u) − x = u − r.
--
-- The weighted sum over shifts is linear bookkeeping on top of this one
-- identity.  पार (pāra, the far shore) and सीमा (sīmā, boundary) are
-- ordinary Sanskrit.
------------------------------------------------------------------------

module ParaSima_TheCrossBoundaryCoefficientOfATruncatedShiftIsTheConvolutionOfTheBoundaryProfilesAtTheShiftedTime where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; +-assoc ; +-comm ; +-zero ; +-suc ; ∸+ ; ∸-cancelˡ ; 0≡m·0)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤Dec ; ≤-refl ; ≤-trans ; ≤-∸-+-cancel ; ¬m<m ; <≤-trans)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

open import SimaSesa_OnAFiniteWindowTheTwoNetZeroShiftWordsAgreeInTheBulkAndDifferOnTheBoundaryStripsSoDisplacementDescendsAndBoundaryHistoryDoesNot
  using (S)

------------------------------------------------------------------------
-- १ · Offset sums.
------------------------------------------------------------------------

-- Σ_{i < n} F (s + i)
Σ⟨_,_⟩ : ℕ → ℕ → (ℕ → ℕ) → ℕ
Σ⟨ s , zero ⟩ F = zero
Σ⟨ s , suc n ⟩ F = F s + Σ⟨ suc s , n ⟩ F

-- a range splits at an offset
Σ-split : (s a n : ℕ) (F : ℕ → ℕ)
        → Σ⟨ s , a + n ⟩ F ≡ Σ⟨ s , a ⟩ F + Σ⟨ s + a , n ⟩ F
Σ-split s zero    n F = cong (λ z → Σ⟨ z , n ⟩ F) (sym (+-zero s))
Σ-split s (suc a) n F =
    cong (F s +_) (Σ-split (suc s) a n F)
  ∙ +-assoc (F s) (Σ⟨ suc s , a ⟩ F) (Σ⟨ suc (s + a) , n ⟩ F)
  ∙ cong (λ z → (F s + Σ⟨ suc s , a ⟩ F) + Σ⟨ z , n ⟩ F) (sym (+-suc s a))

-- a summand reading (x ∸ s), summed from s + k, is the plain sum from k
Σ-shift-gen : (s k n : ℕ) (G : ℕ → ℕ)
            → Σ⟨ s + k , n ⟩ (λ x → G (x ∸ s)) ≡ Σ⟨ k , n ⟩ G
Σ-shift-gen s k zero    G = refl
Σ-shift-gen s k (suc n) G =
  cong₂ _+_ (cong G (∸+ k s))
            ( cong (λ z → Σ⟨ z , n ⟩ (λ x → G (x ∸ s))) (sym (+-suc s k))
            ∙ Σ-shift-gen s (suc k) n G)

Σ-shift : (s n : ℕ) (G : ℕ → ℕ)
        → Σ⟨ s , n ⟩ (λ x → G (x ∸ s)) ≡ Σ⟨ zero , n ⟩ G
Σ-shift s n G =
  cong (λ z → Σ⟨ z , n ⟩ (λ x → G (x ∸ s))) (sym (+-zero s)) ∙ Σ-shift-gen s zero n G

-- the first index of a range is below its end
s<s+sucn : (s n : ℕ) → s < s + suc n
s<s+sucn s n = n , (+-suc n s ∙ cong suc (+-comm n s) ∙ sym (+-suc s n))

-- and the tail's range sits inside the range
tail-in : (s n x : ℕ) → suc s ≤ x → x < suc s + n → (s ≤ x) × (x < s + suc n)
tail-in s n x le lt = ≤-trans (1 , refl) le , subst (x <_) (sym (+-suc s n)) lt

-- a summand vanishing on the range gives a vanishing sum
Σ-vanish : (s n : ℕ) (F : ℕ → ℕ)
         → ((x : ℕ) → s ≤ x → x < s + n → F x ≡ zero)
         → Σ⟨ s , n ⟩ F ≡ zero
Σ-vanish s zero    F v = refl
Σ-vanish s (suc n) F v =
  cong₂ _+_ (v s ≤-refl (s<s+sucn s n))
            (Σ-vanish (suc s) n F (λ x le lt →
               let p = tail-in s n x le lt in v x (fst p) (snd p)))

-- summands agreeing on the range give equal sums
Σ-ext : (s n : ℕ) (F G : ℕ → ℕ)
      → ((x : ℕ) → s ≤ x → x < s + n → F x ≡ G x)
      → Σ⟨ s , n ⟩ F ≡ Σ⟨ s , n ⟩ G
Σ-ext s zero    F G e = refl
Σ-ext s (suc n) F G e =
  cong₂ _+_ (e s ≤-refl (s<s+sucn s n))
            (Σ-ext (suc s) n F G (λ x le lt →
               let p = tail-in s n x le lt in e x (fst p) (snd p)))

------------------------------------------------------------------------
-- २ · The pairing against the right boundary, and the shift's two faces.
------------------------------------------------------------------------

module _ (t a : ℕ) where

  -- ⟨J⁺g , F⟩ = Σ_{x < t} g (t ∸ x) · F x
  ⟨_∣_⟩ : (ℕ → ℕ) → (ℕ → ℕ) → ℕ
  ⟨ g ∣ F ⟩ = Σ⟨ zero , t ⟩ (λ x → g (t ∸ x) · F x)

  -- the shifted profile: nothing below a, f (x ∸ a) from a on
  S-nāsti : (f : ℕ → ℕ) (x : ℕ) → ¬ (a ≤ x) → S t a f x ≡ zero
  S-nāsti f x ¬le with ≤Dec a x
  ... | no  _  = refl
  ... | yes le = ⊥-elim (¬le le)

  S-asti : (f : ℕ → ℕ) (x : ℕ) → a ≤ x → S t a f x ≡ f (x ∸ a)
  S-asti f x le with ≤Dec a x
  ... | yes _  = refl
  ... | no ¬le = ⊥-elim (¬le le)

------------------------------------------------------------------------
-- ३ · The crossing identity.
------------------------------------------------------------------------

-- the convolution of the boundary profiles at time u
h : (ℕ → ℕ) → (ℕ → ℕ) → ℕ → ℕ
h f g u = Σ⟨ zero , u ⟩ (λ r → g (u ∸ r) · f r)

-- for t = a + u:  ⟨J⁺g , S_a f⟩ ≡ h_{f,g}(u)
pāra-sīmā : (a u : ℕ) (f g : ℕ → ℕ)
          → ⟨_∣_⟩ (a + u) a g (S (a + u) a f) ≡ h f g u
pāra-sīmā a u f g =
    Σ-split zero a u F
  ∙ cong₂ _+_ vanish (Σ-ext a u F (λ x → G (x ∸ a)) agree ∙ Σ-shift a u G)
  where
  t = a + u
  F : ℕ → ℕ
  F x = g (t ∸ x) · S t a f x
  G : ℕ → ℕ
  G r = g (u ∸ r) · f r

  -- below a nothing has arrived: each summand is g(…) · 0
  vanish : Σ⟨ zero , a ⟩ F ≡ zero
  vanish = Σ-vanish zero a F (λ x _ lt →
             cong (g (t ∸ x) ·_) (S-nāsti t a f x (λ le → ¬m<m (<≤-trans lt le)))
           ∙ sym (0≡m·0 (g (t ∸ x))))

  -- from a on, x = r + a: the summand is G (x ∸ a)
  agree : (x : ℕ) → a ≤ x → x < a + u → F x ≡ G (x ∸ a)
  agree x le _ =
    cong₂ _·_ (cong g (t∸x≡u∸r x le)) (S-asti t a f x le)
    where
    t∸x≡u∸r : (x : ℕ) → a ≤ x → (a + u) ∸ x ≡ u ∸ (x ∸ a)
    t∸x≡u∸r x le =
        cong ((a + u) ∸_) (sym (≤-∸-+-cancel le))
      ∙ cong ((a + u) ∸_) (+-comm (x ∸ a) a)
      ∙ ∸-cancelˡ a u (x ∸ a)
