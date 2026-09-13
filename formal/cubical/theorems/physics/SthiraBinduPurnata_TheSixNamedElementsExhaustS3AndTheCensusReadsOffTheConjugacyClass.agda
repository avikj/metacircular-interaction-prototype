{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SthiraBinduPurnata_TheSixNamedElementsExhaustS3AndTheCensusReadsOffTheConjugacyClass
--
-- Completeness of the six-element enumeration of S₃, and the census
-- corollary that follows from it.
--
-- pūrṇatā = completeness; sthira-bindu = fixed point.  The Sanskrit
-- terms are used in their plain mathematical senses, and no text is
-- claimed as a source.
--
-- THE ABSENCE CLOSED.
-- SthiraBinduGanana_TheFixedPointCountIsTheConjugationCensusForS3
-- says, in its SYĀT section:
--
--   * That the six named elements exhaust S₃.  Completeness of the
--     six-element enumeration (every equivalence of Fin 3 is equal to
--     one of the six) is NOT proved in this module; the per-element
--     census values are statements about the named representatives.
--
-- That module represents S₃ = FinSymGroup 3 = SymGroup (Fin 3) with
-- Cubical.Data.SumFin's Fin 3 = ⊤ ⊎ (⊤ ⊎ (⊤ ⊎ ⊥)), so an element is an
-- equivalence Fin 3 ≃ Fin 3; the six named elements are S3.1g (the
-- identity equivalence), the transpositions s₀₁ s₁₂ s₀₂ and the
-- 3-cycles ρ ρ², each built by isoToEquiv from an explicit function.
--
-- WHAT IS PROVED.
--
--   * sixComplete : every g : ⟨ S₃ ⟩ is EQUAL (as an element of the
--     carrier, i.e. as an equivalence) to one of the six named
--     elements.  Route: an equivalence is determined by its underlying
--     function (equivEq); a function Fin 3 → Fin 3 is determined by its
--     three values (funExt over the point-wise eliminator cases3); the
--     27 value-triples are split by pattern matching on SumFin's
--     inl/inr; the 6 injective triples each yield the path to the
--     matching named element, and the 21 repeating triples contradict
--     injectivity of the equivalence (equivInj, i.e. invEq/retEq).
--
--   * censusValues : on ALL of S₃ the fixed-point count takes exactly
--     the values 3, 1, 0 —
--       (σ : ⟨ S₃ ⟩) → (countFix σ ≡ 3) ⊎ ((countFix σ ≡ 1) ⊎ (countFix σ ≡ 0)).
--
--   * censusReadsOffClass : the value determines the conjugacy class,
--     in the conjugation convention of the earlier module
--     (conj h g = (h · g) · inv h, from ConjugationInvariant):
--       countFix σ ≡ 3 together with σ ≡ 1g, or
--       countFix σ ≡ 1 together with some h and σ ≡ conj h s₀₁, or
--       countFix σ ≡ 0 together with some h and σ ≡ conj h ρ.
--     The conjugators are exhibited explicitly:
--       s₁₂ = conj ρ² s₀₁,  s₀₂ = conj s₁₂ s₀₁,  ρ² = conj s₀₁ ρ.
--
--   * The three value-specific readings countFix σ ≡ 3 → σ ≡ 1g,
--     countFix σ ≡ 1 → σ is a conjugate of s₀₁,
--     countFix σ ≡ 0 → σ is a conjugate of ρ, derived from the above by
--     discriminating the natural numbers 3, 1, 0.
--
-- WHAT IS NOT PROVED.  That the six named elements are pairwise
-- distinct (the enumeration is complete; its irredundancy is not
-- stated here, although it would follow by the same census values
-- and refl computations).  Nothing about Sₙ for n ≠ 3.
------------------------------------------------------------------------

module SthiraBinduPurnata_TheSixNamedElementsExhaustS3AndTheCensusReadsOffTheConjugacyClass where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivEq)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; snotz ; znots ; injSuc)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Group.Base using (GroupStr)

open import SthiraBinduGanana_TheFixedPointCountIsTheConjugationCensusForS3
  using ( S₃ ; f0 ; f1 ; f2 ; cases3 ; f0≢f1 ; f0≢f2 ; f1≢f2
        ; s₀₁ ; s₁₂ ; s₀₂ ; ρ ; ρ²
        ; countFix ; census-id ; census-s₀₁ ; census-s₁₂ ; census-s₀₂
        ; census-ρ ; census-ρ² ; equivInj )

private
  module S3 = GroupStr (snd S₃)

------------------------------------------------------------------------
-- The statement of completeness
------------------------------------------------------------------------

-- "g is one of the six named elements", as a six-fold disjunction of
-- paths in the carrier ⟨ S₃ ⟩ = (Fin 3 ≃ Fin 3).
IsOneOfSix : ⟨ S₃ ⟩ → Type
IsOneOfSix g =
  (g ≡ S3.1g) ⊎ ((g ≡ s₀₁) ⊎ ((g ≡ s₁₂) ⊎ ((g ≡ s₀₂) ⊎ ((g ≡ ρ) ⊎ (g ≡ ρ²)))))

------------------------------------------------------------------------
-- Exhaustion over the 27 value-triples
------------------------------------------------------------------------

-- Given the three values of the underlying function, produce the path
-- to the named element with those values, or refute injectivity.
module _ (g : ⟨ S₃ ⟩) where
  private
    -- An equivalence whose function agrees with the named one at the
    -- three points is equal to it.
    byValues : (e : ⟨ S₃ ⟩)
             → fst g f0 ≡ fst e f0 → fst g f1 ≡ fst e f1 → fst g f2 ≡ fst e f2
             → g ≡ e
    byValues e p0 p1 p2 = equivEq (funExt (cases3 p0 p1 p2))

    valueLem : (a b c : Fin 3)
             → fst g f0 ≡ a → fst g f1 ≡ b → fst g f2 ≡ c
             → IsOneOfSix g
    -- deep branches are empty
    valueLem (fsuc (fsuc (fsuc t))) _ _ _ _ _ = Empty.rec t
    valueLem _ (fsuc (fsuc (fsuc t))) _ _ _ _ = Empty.rec t
    valueLem _ _ (fsuc (fsuc (fsuc t))) _ _ _ = Empty.rec t
    -- the six permutations
    valueLem fzero (fsuc fzero) (fsuc (fsuc fzero)) pa pb pc =
      inl (byValues S3.1g pa pb pc)
    valueLem (fsuc fzero) fzero (fsuc (fsuc fzero)) pa pb pc =
      inr (inl (byValues s₀₁ pa pb pc))
    valueLem fzero (fsuc (fsuc fzero)) (fsuc fzero) pa pb pc =
      inr (inr (inl (byValues s₁₂ pa pb pc)))
    valueLem (fsuc (fsuc fzero)) (fsuc fzero) fzero pa pb pc =
      inr (inr (inr (inl (byValues s₀₂ pa pb pc))))
    valueLem (fsuc fzero) (fsuc (fsuc fzero)) fzero pa pb pc =
      inr (inr (inr (inr (inl (byValues ρ pa pb pc)))))
    valueLem (fsuc (fsuc fzero)) fzero (fsuc fzero) pa pb pc =
      inr (inr (inr (inr (inr (byValues ρ² pa pb pc)))))
    -- repeated first and second value
    valueLem fzero fzero c pa pb _ =
      Empty.rec (f0≢f1 (equivInj g (pa ∙ sym pb)))
    valueLem (fsuc fzero) (fsuc fzero) c pa pb _ =
      Empty.rec (f0≢f1 (equivInj g (pa ∙ sym pb)))
    valueLem (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) c pa pb _ =
      Empty.rec (f0≢f1 (equivInj g (pa ∙ sym pb)))
    -- third value repeating the first
    valueLem fzero (fsuc fzero) fzero pa _ pc =
      Empty.rec (f0≢f2 (equivInj g (pa ∙ sym pc)))
    valueLem fzero (fsuc (fsuc fzero)) fzero pa _ pc =
      Empty.rec (f0≢f2 (equivInj g (pa ∙ sym pc)))
    valueLem (fsuc fzero) fzero (fsuc fzero) pa _ pc =
      Empty.rec (f0≢f2 (equivInj g (pa ∙ sym pc)))
    valueLem (fsuc fzero) (fsuc (fsuc fzero)) (fsuc fzero) pa _ pc =
      Empty.rec (f0≢f2 (equivInj g (pa ∙ sym pc)))
    valueLem (fsuc (fsuc fzero)) fzero (fsuc (fsuc fzero)) pa _ pc =
      Empty.rec (f0≢f2 (equivInj g (pa ∙ sym pc)))
    valueLem (fsuc (fsuc fzero)) (fsuc fzero) (fsuc (fsuc fzero)) pa _ pc =
      Empty.rec (f0≢f2 (equivInj g (pa ∙ sym pc)))
    -- third value repeating the second
    valueLem fzero (fsuc fzero) (fsuc fzero) _ pb pc =
      Empty.rec (f1≢f2 (equivInj g (pb ∙ sym pc)))
    valueLem fzero (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) _ pb pc =
      Empty.rec (f1≢f2 (equivInj g (pb ∙ sym pc)))
    valueLem (fsuc fzero) fzero fzero _ pb pc =
      Empty.rec (f1≢f2 (equivInj g (pb ∙ sym pc)))
    valueLem (fsuc fzero) (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) _ pb pc =
      Empty.rec (f1≢f2 (equivInj g (pb ∙ sym pc)))
    valueLem (fsuc (fsuc fzero)) fzero fzero _ pb pc =
      Empty.rec (f1≢f2 (equivInj g (pb ∙ sym pc)))
    valueLem (fsuc (fsuc fzero)) (fsuc fzero) (fsuc fzero) _ pb pc =
      Empty.rec (f1≢f2 (equivInj g (pb ∙ sym pc)))

  -- THE COMPLETENESS THEOREM: the six named elements exhaust S₃.
  sixComplete : IsOneOfSix g
  sixComplete = valueLem (fst g f0) (fst g f1) (fst g f2) refl refl refl

------------------------------------------------------------------------
-- Corollary 1: the census takes exactly the values 3, 1, 0 on all of S₃
------------------------------------------------------------------------

censusValues : (σ : ⟨ S₃ ⟩)
  → (countFix σ ≡ 3) ⊎ ((countFix σ ≡ 1) ⊎ (countFix σ ≡ 0))
censusValues σ = go (sixComplete σ)
  where
  go : IsOneOfSix σ → (countFix σ ≡ 3) ⊎ ((countFix σ ≡ 1) ⊎ (countFix σ ≡ 0))
  go (inl p)                               = inl (cong countFix p ∙ census-id)
  go (inr (inl p))                         = inr (inl (cong countFix p ∙ census-s₀₁))
  go (inr (inr (inl p)))                   = inr (inl (cong countFix p ∙ census-s₁₂))
  go (inr (inr (inr (inl p))))             = inr (inl (cong countFix p ∙ census-s₀₂))
  go (inr (inr (inr (inr (inl p)))))       = inr (inr (cong countFix p ∙ census-ρ))
  go (inr (inr (inr (inr (inr p)))))       = inr (inr (cong countFix p ∙ census-ρ²))

------------------------------------------------------------------------
-- Corollary 2: the census value reads off the conjugacy class
------------------------------------------------------------------------

-- Conjugation in the convention of ConjugationInvariant (and of the
-- earlier module): conj h g = (h · g) · inv h, whose underlying
-- function is x ↦ invEq h (fst g (fst h x)).
conj : ⟨ S₃ ⟩ → ⟨ S₃ ⟩ → ⟨ S₃ ⟩
conj h g = (h S3.· g) S3.· S3.inv h

IsConjugateOf : ⟨ S₃ ⟩ → ⟨ S₃ ⟩ → Type
IsConjugateOf r σ = Σ[ h ∈ ⟨ S₃ ⟩ ] σ ≡ conj h r

-- The three explicit conjugations, each checked by refl at the three
-- points after unfolding the underlying functions.
s₁₂-conj : s₁₂ ≡ conj ρ² s₀₁
s₁₂-conj = equivEq (funExt (cases3 refl refl refl))

s₀₂-conj : s₀₂ ≡ conj s₁₂ s₀₁
s₀₂-conj = equivEq (funExt (cases3 refl refl refl))

ρ²-conj : ρ² ≡ conj s₀₁ ρ
ρ²-conj = equivEq (funExt (cases3 refl refl refl))

-- A representative is conjugate to itself, by the identity.
self-conj : (r : ⟨ S₃ ⟩) → r ≡ conj S3.1g r
self-conj r = equivEq (funExt (cases3 refl refl refl))

-- The class statement: value 3 ↔ identity, value 1 ↔ the transposition
-- class, value 0 ↔ the 3-cycle class.
ClassReading : ⟨ S₃ ⟩ → Type
ClassReading σ =
    ((countFix σ ≡ 3) × (σ ≡ S3.1g))
  ⊎ ( ((countFix σ ≡ 1) × IsConjugateOf s₀₁ σ)
    ⊎ ((countFix σ ≡ 0) × IsConjugateOf ρ σ) )

censusReadsOffClass : (σ : ⟨ S₃ ⟩) → ClassReading σ
censusReadsOffClass σ = go (sixComplete σ)
  where
  go : IsOneOfSix σ → ClassReading σ
  go (inl p) =
    inl (cong countFix p ∙ census-id , p)
  go (inr (inl p)) =
    inr (inl (cong countFix p ∙ census-s₀₁ , S3.1g , p ∙ self-conj s₀₁))
  go (inr (inr (inl p))) =
    inr (inl (cong countFix p ∙ census-s₁₂ , ρ² , p ∙ s₁₂-conj))
  go (inr (inr (inr (inl p)))) =
    inr (inl (cong countFix p ∙ census-s₀₂ , s₁₂ , p ∙ s₀₂-conj))
  go (inr (inr (inr (inr (inl p))))) =
    inr (inr (cong countFix p ∙ census-ρ , S3.1g , p ∙ self-conj ρ))
  go (inr (inr (inr (inr (inr p))))) =
    inr (inr (cong countFix p ∙ census-ρ² , s₀₁ , p ∙ ρ²-conj))

------------------------------------------------------------------------
-- The value-specific readings, by discriminating 3, 1, 0 in ℕ
------------------------------------------------------------------------

private
  3≢1 : ¬ (3 ≡ 1)
  3≢1 p = snotz (injSuc p)

  3≢0 : ¬ (3 ≡ 0)
  3≢0 = snotz

  1≢0 : ¬ (1 ≡ 0)
  1≢0 = snotz

census3→identity : (σ : ⟨ S₃ ⟩) → countFix σ ≡ 3 → σ ≡ S3.1g
census3→identity σ q = go (censusReadsOffClass σ)
  where
  go : ClassReading σ → σ ≡ S3.1g
  go (inl (_ , p))       = p
  go (inr (inl (r , _))) = Empty.rec (3≢1 (sym q ∙ r))
  go (inr (inr (r , _))) = Empty.rec (3≢0 (sym q ∙ r))

census1→transposition : (σ : ⟨ S₃ ⟩) → countFix σ ≡ 1 → IsConjugateOf s₀₁ σ
census1→transposition σ q = go (censusReadsOffClass σ)
  where
  go : ClassReading σ → IsConjugateOf s₀₁ σ
  go (inl (r , _))       = Empty.rec (3≢1 (sym r ∙ q))
  go (inr (inl (_ , c))) = c
  go (inr (inr (r , _))) = Empty.rec (1≢0 (sym q ∙ r))

census0→threeCycle : (σ : ⟨ S₃ ⟩) → countFix σ ≡ 0 → IsConjugateOf ρ σ
census0→threeCycle σ q = go (censusReadsOffClass σ)
  where
  go : ClassReading σ → IsConjugateOf ρ σ
  go (inl (r , _))       = Empty.rec (3≢0 (sym r ∙ q))
  go (inr (inl (r , _))) = Empty.rec (1≢0 (sym r ∙ q))
  go (inr (inr (_ , c))) = c
