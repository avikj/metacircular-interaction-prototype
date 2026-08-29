{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SthiraBinduGanana_TheFixedPointCountIsTheConjugationCensusForS3
--
-- The nonabelian holonomy census for S₃ by fixed-point counting.
--
-- sthira-bindu = fixed point, gaṇanā = count; the Sanskrit terms are
-- used in their plain mathematical senses, and no text is claimed as a
-- source.
--
-- WHAT IS PROVED.  For S₃ = FinSymGroup 3 (the group of equivalences of
-- Cubical.Data.SumFin's Fin 3, from Cubical.Algebra.SymmetricGroup),
-- the fixed-point count
--
--     countFix g = #{ x : Fin 3 | fst g x ≡ x }
--
-- computed by decidable equality at the three points, is
--
--   * evaluated by refl on six named elements: the identity (3), the
--     three transpositions s₀₁ s₁₂ s₀₂ (1 each), and the two 3-cycles
--     ρ ρ² (0 each) — the character of the permutation representation,
--     one value per conjugacy class;
--   * conjugation invariant for ALL elements of S₃ (not merely the six
--     named ones), proved abstractly: h carries fixed points of g
--     bijectively onto fixed points of h·g·h⁻¹, rendered here as a
--     Boolean transport lemma (eqF-inj) plus a finite orbit-sum
--     rearrangement (orbitSum) discharged by exhaustion over the 27
--     value-triples of an injection Fin 3 → Fin 3;
--   * therefore closed-loop gauge invariant, by instantiating
--     closedLoopGaugeInvariant from
--     RelationalHolonomyRefinement at S₃.
--
-- ABELIAN / NONABELIAN CONTRAST.  PMGaugeCohomology is
-- the abelian census: cycleParity is 𝔽₂-linear in the edge signs and
-- descends to H¹.  Over a nonabelian structure group no linear
-- functional is available; the gauge residue of a closed loop is a
-- conjugacy class, and the observable must be a class function.
-- countFix is such a class function, and on S₃ it takes the three
-- values 3, 1, 0 on the three classes' named representatives.
--
-- SYĀT — THE CLAIM, EXACTLY.
--   * That fixed-point counting separates conjugacy classes of Sₙ in
--     general.  It does NOT for n ≥ 5: in S₅ the cycle types (2,2,1)
--     and (4,1) both fix exactly one point.  The separation here is a
--     fact about S₃ specifically.
--   * That the six named elements exhaust S₃.  Completeness of the
--     six-element enumeration (every equivalence of Fin 3 is equal to
--     one of the six) is NOT proved in this module; the per-element
--     census values are statements about the named representatives.
--     Conjugation invariance and closed-loop gauge invariance, by
--     contrast, are proved for arbitrary elements and need no
--     enumeration.
--   * No representation theory: countFix is the character of the
--     permutation representation only in the informal sense recorded
--     above; no vector spaces or traces appear.
------------------------------------------------------------------------

module SthiraBinduGanana_TheFixedPointCountIsTheConjugationCensusForS3 where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (invEq ; secEq ; retEq)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; _+_ ; +-comm ; +-assoc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Group.Base using (GroupStr)
open import Cubical.Algebra.SymmetricGroup using (FinSymGroup)

open import RelationalHolonomyRefinement
  using (ConjugationInvariant ; closedLoopGaugeInvariant ; endpointGauge)

------------------------------------------------------------------------
-- The group and the three points
------------------------------------------------------------------------

S₃ : _
S₃ = FinSymGroup 3

private
  module S3 = GroupStr (snd S₃)

f0 f1 f2 : Fin 3
f0 = fzero
f1 = fsuc fzero
f2 = fsuc (fsuc fzero)

-- Point-wise eliminator: the deep branch of SumFin's Fin 3 is ⊥.
cases3 : ∀ {ℓ} {P : Fin 3 → Type ℓ} → P f0 → P f1 → P f2 → (x : Fin 3) → P x
cases3 p0 p1 p2 fzero                  = p0
cases3 p0 p1 p2 (fsuc fzero)           = p1
cases3 p0 p1 p2 (fsuc (fsuc fzero))    = p2
cases3 p0 p1 p2 (fsuc (fsuc (fsuc t))) = Empty.rec t

------------------------------------------------------------------------
-- Decidable point equality, Bool-valued, with soundness
------------------------------------------------------------------------

eqF : Fin 3 → Fin 3 → Bool
eqF fzero           fzero           = true
eqF fzero           (fsuc _)        = false
eqF (fsuc _)        fzero           = false
eqF (fsuc fzero)    (fsuc fzero)    = true
eqF (fsuc fzero)    (fsuc (fsuc _)) = false
eqF (fsuc (fsuc _)) (fsuc fzero)    = false
eqF (fsuc (fsuc _)) (fsuc (fsuc _)) = true

eqF-refl : (x : Fin 3) → eqF x x ≡ true
eqF-refl = cases3 refl refl refl

eqF-sound : (x y : Fin 3) → eqF x y ≡ true → x ≡ y
eqF-sound = cases3
  (cases3 (λ _ → refl)
          (λ p → Empty.rec (false≢true p))
          (λ p → Empty.rec (false≢true p)))
  (cases3 (λ p → Empty.rec (false≢true p))
          (λ _ → refl)
          (λ p → Empty.rec (false≢true p)))
  (cases3 (λ p → Empty.rec (false≢true p))
          (λ p → Empty.rec (false≢true p))
          (λ _ → refl))

f0≢f1 : ¬ f0 ≡ f1
f0≢f1 p = true≢false (cong (eqF f0) p)

f0≢f2 : ¬ f0 ≡ f2
f0≢f2 p = true≢false (cong (eqF f0) p)

f1≢f2 : ¬ f1 ≡ f2
f1≢f2 p = true≢false (cong (eqF f1) p)

boolNotTrue : (b : Bool) → ¬ b ≡ true → b ≡ false
boolNotTrue false _ = refl
boolNotTrue true  k = Empty.rec (k refl)

------------------------------------------------------------------------
-- Six named elements of S₃
------------------------------------------------------------------------

swap01fun swap12fun swap02fun cycFun cycInvFun : Fin 3 → Fin 3

swap01fun fzero           = fsuc fzero
swap01fun (fsuc fzero)    = fzero
swap01fun (fsuc (fsuc x)) = fsuc (fsuc x)

swap12fun fzero           = fzero
swap12fun (fsuc fzero)    = fsuc (fsuc fzero)
swap12fun (fsuc (fsuc _)) = fsuc fzero

swap02fun fzero           = fsuc (fsuc fzero)
swap02fun (fsuc fzero)    = fsuc fzero
swap02fun (fsuc (fsuc _)) = fzero

cycFun fzero           = fsuc fzero
cycFun (fsuc fzero)    = fsuc (fsuc fzero)
cycFun (fsuc (fsuc _)) = fzero

cycInvFun fzero           = fsuc (fsuc fzero)
cycInvFun (fsuc fzero)    = fzero
cycInvFun (fsuc (fsuc _)) = fsuc fzero

s₀₁ s₁₂ s₀₂ ρ ρ² : ⟨ S₃ ⟩

s₀₁ = isoToEquiv (iso swap01fun swap01fun
        (cases3 refl refl refl) (cases3 refl refl refl))
s₁₂ = isoToEquiv (iso swap12fun swap12fun
        (cases3 refl refl refl) (cases3 refl refl refl))
s₀₂ = isoToEquiv (iso swap02fun swap02fun
        (cases3 refl refl refl) (cases3 refl refl refl))
ρ   = isoToEquiv (iso cycFun cycInvFun
        (cases3 refl refl refl) (cases3 refl refl refl))
ρ²  = isoToEquiv (iso cycInvFun cycFun
        (cases3 refl refl refl) (cases3 refl refl refl))

------------------------------------------------------------------------
-- The fixed-point count and its per-element census (all by refl)
------------------------------------------------------------------------

count1 : Bool → ℕ
count1 false = 0
count1 true  = 1

countFix : ⟨ S₃ ⟩ → ℕ
countFix g =
  (count1 (eqF f0 (fst g f0)) + count1 (eqF f1 (fst g f1)))
  + count1 (eqF f2 (fst g f2))

census-id : countFix S3.1g ≡ 3
census-id = refl

census-s₀₁ : countFix s₀₁ ≡ 1
census-s₀₁ = refl

census-s₁₂ : countFix s₁₂ ≡ 1
census-s₁₂ = refl

census-s₀₂ : countFix s₀₂ ≡ 1
census-s₀₂ = refl

census-ρ : countFix ρ ≡ 0
census-ρ = refl

census-ρ² : countFix ρ² ≡ 0
census-ρ² = refl

------------------------------------------------------------------------
-- Conjugation invariance, abstractly
------------------------------------------------------------------------

-- An equivalence is injective on points.
equivInj : (e : ⟨ S₃ ⟩) {x y : Fin 3} → fst e x ≡ fst e y → x ≡ y
equivInj e {x} {y} p = sym (retEq e x) ∙ cong (invEq e) p ∙ retEq e y

-- Boolean equality transports along any equivalence of the point set.
eqF-inj : (e : ⟨ S₃ ⟩) (x y : Fin 3) → eqF (fst e x) (fst e y) ≡ eqF x y
eqF-inj e = cases3
  (cases3 (eqF-refl (fst e f0))
          (offdiag f0 f1 f0≢f1)
          (offdiag f0 f2 f0≢f2))
  (cases3 (offdiag f1 f0 (λ p → f0≢f1 (sym p)))
          (eqF-refl (fst e f1))
          (offdiag f1 f2 f1≢f2))
  (cases3 (offdiag f2 f0 (λ p → f0≢f2 (sym p)))
          (offdiag f2 f1 (λ p → f1≢f2 (sym p)))
          (eqF-refl (fst e f2)))
  where
  offdiag : (x y : Fin 3) → ¬ x ≡ y → eqF (fst e x) (fst e y) ≡ false
  offdiag x y x≢y = boolNotTrue _
    (λ tr → x≢y (equivInj e (eqF-sound _ _ tr)))

-- Any Fin 3-indexed sum of naturals is invariant under precomposition
-- with an equivalence: exhaustion over the 27 value-triples, the 21
-- non-injective ones refuted by equivInj.
module _ (e : ⟨ S₃ ⟩) (u : Fin 3 → ℕ) where
  private
    sumLem : (a b c : Fin 3)
           → fst e f0 ≡ a → fst e f1 ≡ b → fst e f2 ≡ c
           → (u a + u b) + u c ≡ (u f0 + u f1) + u f2
    -- deep branches are empty
    sumLem (fsuc (fsuc (fsuc t))) _ _ _ _ _ = Empty.rec t
    sumLem _ (fsuc (fsuc (fsuc t))) _ _ _ _ = Empty.rec t
    sumLem _ _ (fsuc (fsuc (fsuc t))) _ _ _ = Empty.rec t
    -- the six permutations
    sumLem fzero (fsuc fzero) (fsuc (fsuc fzero)) _ _ _ = refl
    sumLem fzero (fsuc (fsuc fzero)) (fsuc fzero) _ _ _ =
      sym (+-assoc (u f0) (u f2) (u f1))
      ∙ cong (u f0 +_) (+-comm (u f2) (u f1))
      ∙ +-assoc (u f0) (u f1) (u f2)
    sumLem (fsuc fzero) fzero (fsuc (fsuc fzero)) _ _ _ =
      cong (_+ u f2) (+-comm (u f1) (u f0))
    sumLem (fsuc fzero) (fsuc (fsuc fzero)) fzero _ _ _ =
      +-comm (u f1 + u f2) (u f0) ∙ +-assoc (u f0) (u f1) (u f2)
    sumLem (fsuc (fsuc fzero)) fzero (fsuc fzero) _ _ _ =
      cong (_+ u f1) (+-comm (u f2) (u f0))
      ∙ sym (+-assoc (u f0) (u f2) (u f1))
      ∙ cong (u f0 +_) (+-comm (u f2) (u f1))
      ∙ +-assoc (u f0) (u f1) (u f2)
    sumLem (fsuc (fsuc fzero)) (fsuc fzero) fzero _ _ _ =
      cong (_+ u f0) (+-comm (u f2) (u f1))
      ∙ +-comm (u f1 + u f2) (u f0)
      ∙ +-assoc (u f0) (u f1) (u f2)
    -- repeated first and second value
    sumLem fzero fzero c pa pb _ =
      Empty.rec (f0≢f1 (equivInj e (pa ∙ sym pb)))
    sumLem (fsuc fzero) (fsuc fzero) c pa pb _ =
      Empty.rec (f0≢f1 (equivInj e (pa ∙ sym pb)))
    sumLem (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) c pa pb _ =
      Empty.rec (f0≢f1 (equivInj e (pa ∙ sym pb)))
    -- third value repeating the first
    sumLem fzero (fsuc fzero) fzero pa _ pc =
      Empty.rec (f0≢f2 (equivInj e (pa ∙ sym pc)))
    sumLem fzero (fsuc (fsuc fzero)) fzero pa _ pc =
      Empty.rec (f0≢f2 (equivInj e (pa ∙ sym pc)))
    sumLem (fsuc fzero) fzero (fsuc fzero) pa _ pc =
      Empty.rec (f0≢f2 (equivInj e (pa ∙ sym pc)))
    sumLem (fsuc fzero) (fsuc (fsuc fzero)) (fsuc fzero) pa _ pc =
      Empty.rec (f0≢f2 (equivInj e (pa ∙ sym pc)))
    sumLem (fsuc (fsuc fzero)) fzero (fsuc (fsuc fzero)) pa _ pc =
      Empty.rec (f0≢f2 (equivInj e (pa ∙ sym pc)))
    sumLem (fsuc (fsuc fzero)) (fsuc fzero) (fsuc (fsuc fzero)) pa _ pc =
      Empty.rec (f0≢f2 (equivInj e (pa ∙ sym pc)))
    -- third value repeating the second
    sumLem fzero (fsuc fzero) (fsuc fzero) _ pb pc =
      Empty.rec (f1≢f2 (equivInj e (pb ∙ sym pc)))
    sumLem fzero (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) _ pb pc =
      Empty.rec (f1≢f2 (equivInj e (pb ∙ sym pc)))
    sumLem (fsuc fzero) fzero fzero _ pb pc =
      Empty.rec (f1≢f2 (equivInj e (pb ∙ sym pc)))
    sumLem (fsuc fzero) (fsuc (fsuc fzero)) (fsuc (fsuc fzero)) _ pb pc =
      Empty.rec (f1≢f2 (equivInj e (pb ∙ sym pc)))
    sumLem (fsuc (fsuc fzero)) fzero fzero _ pb pc =
      Empty.rec (f1≢f2 (equivInj e (pb ∙ sym pc)))
    sumLem (fsuc (fsuc fzero)) (fsuc fzero) (fsuc fzero) _ pb pc =
      Empty.rec (f1≢f2 (equivInj e (pb ∙ sym pc)))

  orbitSum : (u (fst e f0) + u (fst e f1)) + u (fst e f2)
           ≡ (u f0 + u f1) + u f2
  orbitSum = sumLem (fst e f0) (fst e f1) (fst e f2) refl refl refl

-- Per-point transport: x is fixed by h·g·h⁻¹ exactly when h x is fixed
-- by g, at the level of the Boolean test.
conj-point : (h g : ⟨ S₃ ⟩) (x : Fin 3)
  → eqF x (invEq h (fst g (fst h x))) ≡ eqF (fst h x) (fst g (fst h x))
conj-point h g x =
  sym (eqF-inj h x (invEq h (fst g (fst h x))))
  ∙ cong (eqF (fst h x)) (secEq h (fst g (fst h x)))

countFix-conjugation-invariant : ConjugationInvariant S₃ countFix
countFix-conjugation-invariant h g =
  cong₂ _+_
    (cong₂ _+_ (cong count1 (conj-point h g f0))
               (cong count1 (conj-point h g f1)))
    (cong count1 (conj-point h g f2))
  ∙ orbitSum h (λ y → count1 (eqF y (fst g y)))

------------------------------------------------------------------------
-- The census observable descends through closed-loop gauge
------------------------------------------------------------------------

countFix-closed-loop-gauge-invariant : (h g : ⟨ S₃ ⟩)
  → countFix (endpointGauge S₃ (h , h) g) ≡ countFix g
countFix-closed-loop-gauge-invariant =
  closedLoopGaugeInvariant S₃ countFix countFix-conjugation-invariant
