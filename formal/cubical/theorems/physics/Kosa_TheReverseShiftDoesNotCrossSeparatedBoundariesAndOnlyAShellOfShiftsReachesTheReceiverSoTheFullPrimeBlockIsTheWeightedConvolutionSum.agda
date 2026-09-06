{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कोश — the shell.
--
-- The finite prime-translation operator is P_t = Σ w(a)(S_a + S_a*).
-- PrasthaKhanda read the S_a half against the boundary profiles.  Two
-- support facts finish the block identity as stated:
--
--   §1  THE REVERSE SHIFT DOES NOT CROSS.  With f supported below F and
--       g supported below G, and the window at least F + G long, the
--       pairing of S_a* f against the right profile vanishes for every
--       shift: a summand needs x + a < F and t − x < G at once, which
--       puts t below F + G.  The boundaries are separated.
--
--   §2  ONLY A SHELL REACHES THE RECEIVER.  The convolution h_{f,g}(u)
--       vanishes once u ≥ F + G, so the weighted sum Σ_a w(a) h(t − a)
--       only sees shifts with t − a < F + G: at each time the reading
--       is determined by a finite shell of prime powers, and by the
--       finite quantitative pair-field prefix that reconstructs their
--       weights.
--
--   §3  THE FULL BLOCK.  ⟨J⁺g , Σ_a w(a)(S_a + S_a*) f⟩
--         = Σ_a w(a) · h_{f,g}(t − a),  for t ≥ F + G.
--
-- On the arithmetic side, with f = e^{-s}(q*q)(s − ½) at both ends,
-- h = f*f and this coefficient minus its rank-one pole term is B(t).
-- कोश (kośa, shell/sheath) is ordinary Sanskrit.
------------------------------------------------------------------------

module Kosa_TheReverseShiftDoesNotCrossSeparatedBoundariesAndOnlyAShellOfShiftsReachesTheReceiverSoTheFullPrimeBlockIsTheWeightedConvolutionSum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; +-comm ; +-zero ; ·-distribˡ ; ·-assoc ; ·-comm ; 0≡m·0)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; <Dec ; _≟_ ; lt ; eq ; gt ; ¬m<m ; <-weaken ; <-trans ; <-+k ; <-k+ ; ≤-k+
       ; ≤SumLeft ; ≤-∸-+-cancel ; <≤-trans ; ≤<-trans ; ≤-refl)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

open import SimaSesa_OnAFiniteWindowTheTwoNetZeroShiftWordsAgreeInTheBulkAndDifferOnTheBoundaryStripsSoDisplacementDescendsAndBoundaryHistoryDoesNot
  using (S ; S*)
open import ParaSima_TheCrossBoundaryCoefficientOfATruncatedShiftIsTheConvolutionOfTheBoundaryProfilesAtTheShiftedTime
  using (Σ⟨_,_⟩ ; ⟨_∣_⟩ ; h ; Σ-vanish ; Σ-ext)
open import PrasthaKhanda_TheCrossBoundaryBlockOfTheWeightedShiftOperatorIsTheWeightedSumOfBoundaryConvolutionsAtTheShiftedTimes
  using (Σ-scale ; Σ-add ; Σ-parivarta ; P ; prastha-khaṇḍa)

-- supported below F
Adhaḥ : ℕ → (ℕ → ℕ) → Type₀
Adhaḥ F f = (r : ℕ) → F ≤ r → f r ≡ zero

-- two strict bounds add
<-+-< : {m n o p : ℕ} → m < n → o < p → m + o < n + p
<-+-< mn op = <-trans (<-+k mn) (<-k+ op)

-- the reverse shift's two faces
S*-asti : (t a : ℕ) (f : ℕ → ℕ) (x : ℕ) → x + a < t → S* t a f x ≡ f (x + a)
S*-asti t a f x lt′ with <Dec (x + a) t
... | yes _   = refl
... | no ¬lt  = ⊥-elim (¬lt lt′)

S*-nāsti : (t a : ℕ) (f : ℕ → ℕ) (x : ℕ) → ¬ (x + a < t) → S* t a f x ≡ zero
S*-nāsti t a f x ¬lt with <Dec (x + a) t
... | no  _   = refl
... | yes lt′ = ⊥-elim (¬lt lt′)

-- a value bounded above by its own support bound is zero: F ≤ r from a
-- trichotomy that is not `lt`
adhaḥ-śūnya : (F : ℕ) (f : ℕ → ℕ) → Adhaḥ F f → (r : ℕ) → ¬ (r < F) → f r ≡ zero
adhaḥ-śūnya F f fF r ¬r<F with r ≟ F
... | lt r<F = ⊥-elim (¬r<F r<F)
... | eq p   = fF r (zero , sym p)
... | gt F<r = fF r (<-weaken F<r)

------------------------------------------------------------------------
-- १ · The reverse shift does not cross separated boundaries.
------------------------------------------------------------------------

viparīta-śūnya : (t a F G : ℕ) (f g : ℕ → ℕ) → Adhaḥ F f → Adhaḥ G g → F + G ≤ t
               → ⟨_∣_⟩ t a g (S* t a f) ≡ zero
viparīta-śūnya t a F G f g fF gG sep =
  Σ-vanish zero t (λ x → g (t ∸ x) · S* t a f x) pada
  where
  pada : (x : ℕ) → zero ≤ x → x < zero + t → g (t ∸ x) · S* t a f x ≡ zero
  pada x _ x<t with <Dec (x + a) t
  ... | no ¬lt = sym (0≡m·0 (g (t ∸ x)))
  ... | yes lt′ with (x + a) ≟ F
  ...   | eq p    = cong (g (t ∸ x) ·_) (fF (x + a) (zero , sym p)) ∙ sym (0≡m·0 (g (t ∸ x)))
  ...   | gt F<   = cong (g (t ∸ x) ·_) (fF (x + a) (<-weaken F<)) ∙ sym (0≡m·0 (g (t ∸ x)))
  ...   | lt x+a<F with (t ∸ x) ≟ G
  ...     | eq q    = cong (_· f (x + a)) (gG (t ∸ x) (zero , sym q))
  ...     | gt G<   = cong (_· f (x + a)) (gG (t ∸ x) (<-weaken G<))
  ...     | lt t∸x<G = ⊥-elim (¬m<m t<t)
    where
    -- t = (t ∸ x) + x ≤ (t ∸ x) + (x + a) < G + F = F + G ≤ t
    t≤ : t ≤ (t ∸ x) + (x + a)
    t≤ = subst (_≤ (t ∸ x) + (x + a)) (≤-∸-+-cancel (<-weaken x<t))
               (≤-k+ {m = x} {n = x + a} {k = t ∸ x} (≤SumLeft {n = x} {k = a}))
    t<t : t < t
    t<t = <≤-trans (≤<-trans t≤ (<-+-< t∸x<G x+a<F)) (subst (_≤ t) (+-comm F G) sep)

------------------------------------------------------------------------
-- २ · Only a shell of shifts reaches the receiver.
------------------------------------------------------------------------

kośa : (u F G : ℕ) (f g : ℕ → ℕ) → Adhaḥ F f → Adhaḥ G g → F + G ≤ u → h f g u ≡ zero
kośa u F G f g fF gG sep = Σ-vanish zero u (λ r → g (u ∸ r) · f r) pada
  where
  pada : (r : ℕ) → zero ≤ r → r < zero + u → g (u ∸ r) · f r ≡ zero
  pada r _ r<u with r ≟ F
  ... | eq p   = cong (g (u ∸ r) ·_) (fF r (zero , sym p)) ∙ sym (0≡m·0 (g (u ∸ r)))
  ... | gt F<r = cong (g (u ∸ r) ·_) (fF r (<-weaken F<r)) ∙ sym (0≡m·0 (g (u ∸ r)))
  ... | lt r<F with (u ∸ r) ≟ G
  ...   | eq q    = cong (_· f r) (gG (u ∸ r) (zero , sym q))
  ...   | gt G<   = cong (_· f r) (gG (u ∸ r) (<-weaken G<))
  ...   | lt u∸r<G = ⊥-elim (¬m<m u<u)
    where
    u≤ : u ≤ (u ∸ r) + r
    u≤ = subst (_≤ (u ∸ r) + r) (≤-∸-+-cancel (<-weaken r<u)) ≤-refl
    u<u : u < u
    u<u = <≤-trans (≤<-trans u≤ (<-+-< u∸r<G r<F)) (subst (_≤ u) (+-comm F G) sep)

-- so a shift whose shifted time is outside the shell contributes nothing
kośa-pada : (t a F G : ℕ) (w : ℕ → ℕ) (f g : ℕ → ℕ) → Adhaḥ F f → Adhaḥ G g
          → F + G ≤ t ∸ a → w a · h f g (t ∸ a) ≡ zero
kośa-pada t a F G w f g fF gG far =
  cong (w a ·_) (kośa (t ∸ a) F G f g fF gG far) ∙ sym (0≡m·0 (w a))

------------------------------------------------------------------------
-- ३ · The full block: both halves of the prime operator.
------------------------------------------------------------------------

-- the full weighted shift operator
P̃ : (t n : ℕ) (w : ℕ → ℕ) → (ℕ → ℕ) → ℕ → ℕ
P̃ t n w f x = Σ⟨ zero , n ⟩ (λ a → w a · (S t a f x + S* t a f x))

-- the reverse half
P* : (t n : ℕ) (w : ℕ → ℕ) → (ℕ → ℕ) → ℕ → ℕ
P* t n w f x = Σ⟨ zero , n ⟩ (λ a → w a · S* t a f x)

private
  vyatyāsa : (p q r : ℕ) → p · (q · r) ≡ q · (p · r)
  vyatyāsa p q r = ·-assoc p q r ∙ cong (_· r) (·-comm p q) ∙ sym (·-assoc q p r)

  Σ-zero : (n : ℕ) → Σ⟨ zero , n ⟩ (λ _ → zero) ≡ zero
  Σ-zero = go zero
    where
    go : (s n : ℕ) → Σ⟨ s , n ⟩ (λ _ → zero) ≡ zero
    go s zero    = refl
    go s (suc n) = go (suc s) n

-- the reverse half of the block vanishes on a long enough window
viparīta-khaṇḍa : (t n F G : ℕ) (w f g : ℕ → ℕ) → Adhaḥ F f → Adhaḥ G g → F + G ≤ t
                → ⟨_∣_⟩ t zero g (P* t n w f) ≡ zero
viparīta-khaṇḍa t n F G w f g fF gG sep =
    cong (Σ⟨ zero , t ⟩) (funExt λ x → sym (Σ-scale zero n (g (t ∸ x)) (λ a → w a · S* t a f x)))
  ∙ sym (Σ-parivarta zero n t (λ a x → g (t ∸ x) · (w a · S* t a f x)))
  ∙ cong (Σ⟨ zero , n ⟩) (funExt λ a →
        cong (Σ⟨ zero , t ⟩) (funExt λ x → vyatyāsa (g (t ∸ x)) (w a) (S* t a f x))
      ∙ Σ-scale zero t (w a) (λ x → g (t ∸ x) · S* t a f x)
      ∙ cong (w a ·_) (viparīta-śūnya t a F G f g fF gG sep)
      ∙ sym (0≡m·0 (w a)))
  ∙ Σ-zero n

-- the full block is the weighted convolution sum
pūrṇa-khaṇḍa : (t n F G : ℕ) (w f g : ℕ → ℕ) → Adhaḥ F f → Adhaḥ G g → F + G ≤ t
             → ((a : ℕ) → a ≤ t)
             → ⟨_∣_⟩ t zero g (P̃ t n w f) ≡ Σ⟨ zero , n ⟩ (λ a → w a · h f g (t ∸ a))
pūrṇa-khaṇḍa t n F G w f g fF gG sep bounded =
    -- split each x's inner sum into the S half and the S* half
    cong (Σ⟨ zero , t ⟩) (funExt λ x →
        cong (g (t ∸ x) ·_)
          ( Σ-ext zero n (λ a → w a · (S t a f x + S* t a f x))
                         (λ a → w a · S t a f x + w a · S* t a f x)
                         (λ a _ _ → sym (·-distribˡ (w a) (S t a f x) (S* t a f x)))
          ∙ Σ-add zero n (λ a → w a · S t a f x) (λ a → w a · S* t a f x))
      ∙ sym (·-distribˡ (g (t ∸ x)) (P t n w f x) (P* t n w f x)))
    -- the outer sum splits
  ∙ Σ-add zero t (λ x → g (t ∸ x) · P t n w f x) (λ x → g (t ∸ x) · P* t n w f x)
    -- the S half is PrasthaKhanda, the S* half vanishes
  ∙ cong₂ _+_ (prastha-khaṇḍa t n w f g bounded) (viparīta-khaṇḍa t n F G w f g fF gG sep)
  ∙ +-zero _
