{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- साधक — the prover.
--
-- Pramanika proved: A = L D Lᵀ with D ≥ 0 makes vᵀAv ≥ 0.  Its checker
-- computes in ℚ and is unary-slow.  This file runs the same check over
-- Saṅkhyā — signed integers on the builtin naturals — and carries the
-- result across toℚ into Pramanika's hypotheses.  A certificate is
-- integer-scaled (A′ = c·A, integer L′, natural D′), and the theorem
-- returned is positivity of the rational form of A′.
--
--   §1  EQUALITY on Saṅkhyā by builtin monus, sound into ℤ.
--   §2  toℚ and its homomorphisms; sums in Saṅkhyā versus sums in ℚ.
--   §3  THE CHECK and the theorem it returns.
--
-- साधक (sādhaka, the one who accomplishes/proves) is ordinary Sanskrit.
------------------------------------------------------------------------

module Sadhaka_AnIntegerLDLTCertificateCheckedAtMachineSpeedYieldsThePositivityOfTheRationalFormThroughPramanika where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _∸_ ; discreteℕ ; +-suc)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤ ; suc-≤-suc ; ≤-antisym ; ≤-refl ; ≤-suc ; ¬-<-zero ; pred-≤-pred) renaming (_<_ to _<ℕ_)
open import Cubical.Data.NatPlusOne using (1+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; false≢true)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
import Cubical.Data.Int as ℤ
import Cubical.Data.Int.Order as ℤO
open ℤ using (pos ; neg)
open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (isRefl≤) renaming (_≤_ to _≤ℚ_)

open import Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed
  using (𝕊 ; ⁺_ ; ⁻_ ; toℤ ; _⊗_ ; _⊕_ ; ⊗-sama ; ⊕-sama)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩)
import Pramanika_AnExactRationalLDLTFactorisationCertifiesThatAQuadraticFormIsNonnegativeSoAPositivityCertificateIsACheckableTerm
  as P

------------------------------------------------------------------------
-- १ · Equality by monus.
------------------------------------------------------------------------

śūnya? : ℕ → Bool
śūnya? zero    = true
śūnya? (suc _) = false

eqℕ : ℕ → ℕ → Bool
eqℕ a b = śūnya? (a ∸ b) and śūnya? (b ∸ a)

and-satya : (a b : Bool) → a and b ≡ true → (a ≡ true) × (b ≡ true)
and-satya true  true  _ = refl , refl
and-satya true  false e = ⊥-elim (false≢true e)
and-satya false true  e = ⊥-elim (false≢true e)
and-satya false false e = ⊥-elim (false≢true e)

∸-śūnya : (a b : ℕ) → śūnya? (b ∸ a) ≡ true → b ≤ a
∸-śūnya a       zero    _ = zero-≤
∸-śūnya zero    (suc b) e = ⊥-elim (false≢true e)
∸-śūnya (suc a) (suc b) e = suc-≤-suc (∸-śūnya a b e)

eqℕ-sama : (a b : ℕ) → eqℕ a b ≡ true → a ≡ b
eqℕ-sama a b e = ≤-antisym (∸-śūnya b a (fst (and-satya (śūnya? (a ∸ b)) (śūnya? (b ∸ a)) e)))
                           (∸-śūnya a b (snd (and-satya (śūnya? (a ∸ b)) (śūnya? (b ∸ a)) e)))

eq𝕊 : 𝕊 → 𝕊 → Bool
eq𝕊 (⁺ a) (⁺ b) = eqℕ a b
eq𝕊 (⁻ a) (⁻ b) = eqℕ a b
eq𝕊 (⁺ a) (⁻ b) = eqℕ a zero and eqℕ b zero
eq𝕊 (⁻ a) (⁺ b) = eqℕ a zero and eqℕ b zero

eq𝕊-sama : (x y : 𝕊) → eq𝕊 x y ≡ true → toℤ x ≡ toℤ y
eq𝕊-sama (⁺ a) (⁺ b) e = cong pos (eqℕ-sama a b e)
eq𝕊-sama (⁻ a) (⁻ b) e = cong neg (eqℕ-sama a b e)
eq𝕊-sama (⁺ a) (⁻ b) e = cong pos (eqℕ-sama a zero (fst (and-satya (eqℕ a zero) (eqℕ b zero) e))) ∙ cong neg (sym (eqℕ-sama b zero (snd (and-satya (eqℕ a zero) (eqℕ b zero) e))))
eq𝕊-sama (⁻ a) (⁺ b) e = cong neg (eqℕ-sama a zero (fst (and-satya (eqℕ a zero) (eqℕ b zero) e))) ∙ cong pos (sym (eqℕ-sama b zero (snd (and-satya (eqℕ a zero) (eqℕ b zero) e))))

------------------------------------------------------------------------
-- २ · toℚ and sums.
------------------------------------------------------------------------

toℚ : 𝕊 → ℚ
toℚ x = [ toℤ x / 1 ]

toℚ-⊗ : (x y : 𝕊) → toℚ (x ⊗ y) ≡ toℚ x · toℚ y
toℚ-⊗ x y = cong (λ z → [ z / 1 ]) (⊗-sama x y)

toℚ-⊕ : (x y : 𝕊) → toℚ (x ⊕ y) ≡ toℚ x + toℚ y
toℚ-⊕ x y = eq/ _ _ sākṣī
  where
  sākṣī : toℤ (x ⊕ y) ℤ.· pos 1 ≡ (toℤ x ℤ.· pos 1 ℤ.+ toℤ y ℤ.· pos 1) ℤ.· pos 1
  sākṣī = ℤ.·IdR _ ∙ ⊕-sama x y ∙ sym (cong₂ ℤ._+_ (ℤ.·IdR (toℤ x)) (ℤ.·IdR (toℤ y))) ∙ sym (ℤ.·IdR _)

Σ𝕊 : ℕ → (ℕ → 𝕊) → 𝕊
Σ𝕊 zero    f = ⁺ zero
Σ𝕊 (suc n) f = Σ𝕊 n f ⊕ f n

Σ-toℚ : (n : ℕ) (f : ℕ → 𝕊) → toℚ (Σ𝕊 n f) ≡ Σ⟨ n ⟩ (λ i → toℚ (f i))
Σ-toℚ zero    f = refl
Σ-toℚ (suc n) f = toℚ-⊕ (Σ𝕊 n f) (f n) ∙ cong (_+ toℚ (f n)) (Σ-toℚ n f)

-- a natural, read in ℚ, is nonnegative
toℚ-anṛṇa : (d : ℕ) → 0 ≤ℚ toℚ (⁺ d)
toℚ-anṛṇa d = subst (pos 0 ℤO.≤_) (sym (ℤ.·IdR (pos d))) ℤO.zero-≤pos

------------------------------------------------------------------------
-- ३ · The check and the theorem.
------------------------------------------------------------------------

sarva : (k : ℕ) → (ℕ → Bool) → Bool
sarva zero    f = true
sarva (suc k) f = sarva k f and f k

sarva-satya : (k : ℕ) (f : ℕ → Bool) → sarva k f ≡ true → (i : ℕ) → i <ℕ k → f i ≡ true
sarva-satya zero    f _ i lt = ⊥-elim (¬-<-zero lt)
sarva-satya (suc k) f e i lt with discreteℕ i k
... | yes p = subst (λ z → f z ≡ true) (sym p) (snd (and-satya (sarva k f) (f k) e))
... | no ¬p = sarva-satya k f (fst (and-satya (sarva k f) (f k) e)) i (suc-le i k lt ¬p)
  where
  suc-le : (i k : ℕ) → i <ℕ suc k → ¬ (i ≡ k) → i <ℕ k
  suc-le i k lt ne with pred-≤-pred lt
  ... | (zero  , q) = ⊥-elim (ne q)
  ... | (suc j , q) = j , (+-suc j i ∙ q)

module _ (n : ℕ) (A L : ℕ → ℕ → 𝕊) (D : ℕ → ℕ) where

  D𝕊 : ℕ → 𝕊
  D𝕊 k = ⁺ (D k)

  -- the check, all in builtin naturals
  sādhya : Bool
  sādhya = sarva n (λ i → sarva n (λ j → eq𝕊 (A i j) (Σ𝕊 n (λ k → (L i k ⊗ D𝕊 k) ⊗ L j k))))

  Aℚ Lℚ : ℕ → ℕ → ℚ
  Aℚ i j = toℚ (A i j)
  Lℚ i k = toℚ (L i k)
  Dℚ : ℕ → ℚ
  Dℚ k = toℚ (D𝕊 k)

  sādhya-ldl : sādhya ≡ true → P.LDLᵀ n Aℚ Lℚ Dℚ
  sādhya-ldl e i j i<n j<n =
      cong (λ z → [ z / 1 ]) (eq𝕊-sama (A i j) _ (sarva-satya n _ (sarva-satya n _ e i i<n) j j<n))
    ∙ Σ-toℚ n _
    ∙ P.Σ-ext< n _ _ (λ k _ → toℚ-⊗ (L i k ⊗ D𝕊 k) (L j k) ∙ cong (_· toℚ (L j k)) (toℚ-⊗ (L i k) (D𝕊 k)))

  -- THE THEOREM: an integer certificate that checks proves the rational form nonnegative.
  sādhaka : sādhya ≡ true → (v : ℕ → ℚ) → 0 ≤ℚ P.Q n Aℚ Lℚ Dℚ v
  sādhaka e = P.prāmāṇika n Aℚ Lℚ Dℚ (sādhya-ldl e) (λ k _ → toℚ-anṛṇa (D k))
