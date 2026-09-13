{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- द्वि-स्थान — the two places.
--
-- For a nonfixed reflection orbit the generator in the J-eigenbasis is
--     G = −iγ·I − σ·X,        X = [[0,1],[1,0]],  X² = I.
-- Everything below lives in the commutative algebra of blocks
-- α·I + β·X, represented as pairs (α , β) with the product forced by
-- X² = I.  With  d = λ + iγ  the resolvent block is  (d , σ)  and:
--
--   १  (d , σ) ⊗ (d , −σ) = (d² − σ² , 0):  the full inverse is
--      (d , −σ)/(d² − σ²), so  R₊₊ = d/(d² − σ²);
--   २  any inverse (ρ , τ) of (d , σ) has  ρ·(d² − σ²) = d  and
--      τ·(d² − σ²) = −σ  — the resolved entries are forced;
--   ३  the Schur pivot:  with  Σ·d = σ²  (Σ = σ²/d),
--      (d − Σ)·d = d² − σ²: the self-energy is SUBTRACTED in the
--      resolved denominator, and its pole at d = 0 is removable:
--   ४  at d = 0 with σ invertible the block (0 , σ) has inverse
--      (0 , 1/σ) = X/σ;
--   ५  the genuine poles are d = ±σ with residue ½ each:
--      (d − σ) + (d + σ) = 2d, i.e. d/((d−σ)(d+σ)) = ½/(d−σ) + ½/(d+σ);
--   ६  the time evolution: with  ∂e = −g·e,  ∂c = σ·s,  ∂s = σ·c
--      (e = e^{−iγt}, c = cosh σt, s = sinh σt) the block
--      K = (e·c , −e·s)  satisfies  ∂K = G ⊗ K  and  K₊₊ = e·c is the
--      damped cosh  e^{−iγt} cosh σt;  K = I at t = 0.
--
-- Handoff §64, [S17–S18].  "Σ(1) = 0 ⇔ RH" is the analytic statement
-- across all orbits and is not touched here.
------------------------------------------------------------------------
module DviSthana_TheTwoSectorReflectionBlockResolvesExactlyThePivotPoleOfTheSelfEnergyIsRemovableTheGenuinePolesSitAtPlusMinusSigmaWithResidueOneHalfAndTheRetainedChannelIsADampedCosh where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  -- the block algebra  α·I + β·X  with  X² = I
  Blk : Type ℓ
  Blk = A × A

  _⊗_ : Blk → Blk → Blk
  (a , b) ⊗ (a' , b') = (a · a' + b · b' , a · b' + b · a')

  𝟙 : Blk
  𝟙 = (1r , 0r)

  X : Blk
  X = (0r , 1r)

  X-squares-to-𝟙 : X ⊗ X ≡ 𝟙
  X-squares-to-𝟙 = cong₂ _,_ p q
    where
      p : 0r · 0r + 1r · 1r ≡ 1r
      p = solve! R
      q : 0r · 1r + 1r · 0r ≡ 0r
      q = solve! R

  module _ (d σ : A) where

    ----------------------------------------------------------------
    -- १ · the resolvent block factors against its conjugate
    ----------------------------------------------------------------
    resolvent-factor : (d , σ) ⊗ (d , - σ) ≡ (d · d + (- (σ · σ)) , 0r)
    resolvent-factor = cong₂ _,_ p q
      where
        p : d · d + σ · (- σ) ≡ d · d + (- (σ · σ))
        p = solve! R
        q : d · (- σ) + σ · d ≡ 0r
        q = solve! R

    ----------------------------------------------------------------
    -- २ · the resolved entries are forced by any inverse
    ----------------------------------------------------------------
    module _ (ρ τ : A) (inv : (d , σ) ⊗ (ρ , τ) ≡ 𝟙) where
      private
        h1 : d · ρ + σ · τ ≡ 1r
        h1 = cong fst inv
        h2 : d · τ + σ · ρ ≡ 0r
        h2 = cong snd inv

      resolved-plus-plus : ρ · (d · d + (- (σ · σ))) ≡ d
      resolved-plus-plus =
          shape ∙ cong₂ (λ u v → d · u + (- (σ · v))) h1 h2 ∙ finish
        where
          shape : ρ · (d · d + (- (σ · σ))) ≡ d · (d · ρ + σ · τ) + (- (σ · (d · τ + σ · ρ)))
          shape = solve! R
          finish : d · 1r + (- (σ · 0r)) ≡ d
          finish = solve! R

      resolved-plus-minus : τ · (d · d + (- (σ · σ))) ≡ - σ
      resolved-plus-minus =
          shape ∙ cong₂ (λ u v → d · v + (- (σ · u))) h1 h2 ∙ finish
        where
          shape : τ · (d · d + (- (σ · σ))) ≡ d · (d · τ + σ · ρ) + (- (σ · (d · ρ + σ · τ)))
          shape = solve! R
          finish : d · 0r + (- (σ · 1r)) ≡ - σ
          finish = solve! R

    ----------------------------------------------------------------
    -- ३ · the Schur pivot: the self-energy is subtracted
    ----------------------------------------------------------------
    schur-denominator : (Σ : A) → Σ · d ≡ σ · σ → (d + (- Σ)) · d ≡ d · d + (- (σ · σ))
    schur-denominator Σ h = shape ∙ cong (λ w → d · d + (- w)) h
      where
        shape : (d + (- Σ)) · d ≡ d · d + (- (Σ · d))
        shape = solve! R

    ----------------------------------------------------------------
    -- ५ · the genuine poles carry residue ½ each
    ----------------------------------------------------------------
    residues-are-halves : (d + (- σ)) + (d + σ) ≡ d + d
    residues-are-halves = solve! R

  ----------------------------------------------------------------
  -- ४ · the pivot pole is removable: at d = 0 the block is X/σ
  ----------------------------------------------------------------
  pivot-inverse : (σ s : A) → σ · s ≡ 1r → (0r , σ) ⊗ (0r , s) ≡ 𝟙
  pivot-inverse σ s h = cong₂ _,_ (p ∙ h) q
    where
      p : 0r · 0r + σ · s ≡ σ · s
      p = solve! R
      q : 0r · s + σ · 0r ≡ 0r
      q = solve! R

  ----------------------------------------------------------------
  -- ६ · the time evolution of the block is the damped cosh / sinh pair
  ----------------------------------------------------------------
  module _ (∂ : A → A)
           (∂-add  : (x y : A) → ∂ (x + y) ≡ ∂ x + ∂ y)
           (∂-leib : (x y : A) → ∂ (x · y) ≡ ∂ x · y + x · ∂ y)
           (g σ e c s : A)
           (∂e : ∂ e ≡ - (g · e))
           (∂c : ∂ c ≡ σ · s)
           (∂s : ∂ s ≡ σ · c)
           where

    private
      ∂-zero : ∂ 0r ≡ 0r
      ∂-zero = sym ( sym (+InvR (∂ 0r)) ∙ cong (_+ (- (∂ 0r))) h ∙ cancelR (∂ 0r) (∂ 0r) )
        where
          h : ∂ 0r ≡ ∂ 0r + ∂ 0r
          h = cong ∂ (sym (+IdR 0r)) ∙ ∂-add 0r 0r
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = solve! R

      ∂-neg : (x : A) → ∂ (- x) ≡ - ∂ x
      ∂-neg x = negOf (∂ x) (∂ (- x)) (sym (∂-add x (- x)) ∙ cong ∂ (+InvR x) ∙ ∂-zero)
        where
          negOf : (a b : A) → a + b ≡ 0r → b ≡ - a
          negOf a b h = sym (+IdL b) ∙ cong (_+ b) (sym (+InvL a)) ∙ sym (+Assoc (- a) a b) ∙ cong ((- a) +_) h ∙ +IdR (- a)

    G : Blk
    G = (- g , - σ)

    K : Blk
    K = (e · c , - (e · s))

    ∂Blk : Blk → Blk
    ∂Blk (a , b) = (∂ a , ∂ b)

    -- ∂K = G ⊗ K
    evolves : ∂Blk K ≡ G ⊗ K
    evolves = cong₂ _,_ p q
      where
        p : ∂ (e · c) ≡ (- g) · (e · c) + (- σ) · (- (e · s))
        p = ∂-leib e c ∙ cong₂ (λ u v → u · c + e · v) ∂e ∂c ∙ shape
          where
            shape : (- (g · e)) · c + e · (σ · s) ≡ (- g) · (e · c) + (- σ) · (- (e · s))
            shape = solve! R
        q : ∂ (- (e · s)) ≡ (- g) · (- (e · s)) + (- σ) · (e · c)
        q = ∂-neg (e · s) ∙ cong -_ (∂-leib e s ∙ cong₂ (λ u v → u · s + e · v) ∂e ∂s) ∙ shape
          where
            shape : - ((- (g · e)) · s + e · (σ · c)) ≡ (- g) · (- (e · s)) + (- σ) · (e · c)
            shape = solve! R

    -- the retained (++) channel is the damped cosh, and starts at 1
    retained-channel : fst K ≡ e · c
    retained-channel = refl

    module _ (ev : A → A) (ev-mul : (x y : A) → ev (x · y) ≡ ev x · ev y)
             (e₀ : ev e ≡ 1r) (c₀ : ev c ≡ 1r) where
      starts-at-one : ev (fst K) ≡ 1r
      starts-at-one = ev-mul e c ∙ cong₂ _·_ e₀ c₀ ∙ ·IdR 1r
