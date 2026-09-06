{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TorusFourierLayer — the prime-boundary document's triangular pair
-- u^σ = (0 , a , σ v), DERIVED from its velocity field on the torus:
-- the divergence vanishes, the nonlinear term (u·∇)u is (0, 0, σ a ∂₂v)
-- and is itself divergence-free, so the Leray projection leaves it
-- fixed and the pressure gradient is zero; the coarse stress (the
-- x₁-average of u ⊗ u) and the coarse continuation P_{≤1} ∂ₜu(0) are
-- computed, and they are the document's matrix and its σ-odd e₃ term.
--
-- WHAT THIS IS.  The remainder the earlier modules left: TriangularPair
-- wrote the stress and the continuation down; this module computes
-- them.  The layer is the smallest exact Fourier calculus that carries
-- the derivation:
--
--   fields   are functions ℤ × ℤ → ℤ[i] (Fourier coefficients on the
--            modes (N k₁ , k₂), with N = 2 the fine frequency), finitely
--            supported by construction;
--   product  is convolution over the box [−2, 2]², exact because every
--            input here is supported in [−1, 1]² and the product of two
--            such is supported in [−2, 2]²;
--   ∂₁, ∂₂   multiply the coefficient at (k₁ , k₂) by i N k₁, i k₂;
--   ∂₃       is zero — nothing depends on x₃;
--   Δ        multiplies by −(N² k₁² + k₂²);
--   avg      restricts to the row k₁ = 0 (the x₁-average);
--   P_{≤1}   keeps k₁ = 0 and |k₂| ≤ 1 (every k₁ ≠ 0 mode has |N k₁| ≥ 2).
--
-- The fields: a = 2 cos(N x₁), i.e. a(±1 , 0) = 1, and v = 2 cos(N x₁ + x₂),
-- i.e. v(1 , 1) = v(−1 , −1) = 1; the factor 2 replaces the document's A
-- with 2 so that no ½ is needed, and every result below is the
-- document's with A² = 4.  Equalities of fields are decided on the box
-- by a Boolean procedure and reflected to paths (§1).
--
--   §2  div u^σ = 0;  (u^σ·∇)u^σ = (0 , 0 , σ · (a ∗ ∂₂v));  div of that = 0.
--   §3  avg(u₂u₂) = 2·δ₀,  avg(u₂u₃) = σ(δ₁ + δ₋₁) = 2σ cos x₂,
--       avg(u₃u₃) = 2·δ₀  — the document's 2R^σ = A²[[0,0,0],[0,1,σc],[0,σc,1]]
--       with A² = 4, read as coefficients.
--   §4  P_{≤1}(−(u·∇)u + ν Δu) = (0 , 0 , σ · (−i δ₁ + i δ₋₁)) = (0, 0, 2σ sin x₂)
--       for ν = 1 and for ν = 7: the viscous term lives at k₁ = ±1 and is
--       projected away — the document's (σA²/2) e₃ sin x₂ with A² = 4.
--   §5  the pair: the σ-even stress entries agree at σ = ±1, the σ-odd
--       entry and the continuation are negated.
--
-- SYĀT — THE CLAIM, EXACTLY.  Every statement is a computation at t = 0
-- over ℤ[i], decided on the box and reflected.  The time evolution
-- (a(t) = e^{−νN²t} a, v(t) solving ∂ₜv + a ∂₂v = νΔv) is the linear
-- theory the document invokes and is NOT here: the advected v(t) is not
-- a finite trigonometric polynomial for t > 0.  What the document's
-- Theorem 8 uses — the t = 0 stress, the t = 0 coarse acceleration, and
-- the constancy of the pressure — is derived, not written down.
------------------------------------------------------------------------

module TorusFourierLayer_TheTriangularPairIsDerivedFromItsVelocityFieldTheNonlinearTermIsDivergenceFreeSoThePressureIsConstantAndTheCoarseStressAndContinuationAreComputed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _+_ ; _·_ ; -_ ; _-_)
open import Cubical.Data.Int.Properties using (discreteℤ)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; Dec→Bool)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

------------------------------------------------------------------------
-- §0  Gaussian integers, fields, and the calculus
------------------------------------------------------------------------

ℤi : Type
ℤi = ℤ × ℤ

_+c_ : ℤi → ℤi → ℤi
(a , b) +c (c , d) = (a + c , b + d)

_·c_ : ℤi → ℤi → ℤi
(a , b) ·c (c , d) = (a · c - b · d , a · d + b · c)

negc : ℤi → ℤi
negc (a , b) = (- a , - b)

0c 1c i : ℤi
0c = (pos 0 , pos 0)
1c = (pos 1 , pos 0)
i  = (pos 0 , pos 1)

-- an integer as a Gaussian integer
ι : ℤ → ℤi
ι z = (z , pos 0)

infixl 20 _+c_
infixl 21 _·c_

Field : Type
Field = ℤ → ℤ → ℤi

0f : Field
0f _ _ = 0c

_+f_ : Field → Field → Field
(f +f g) k₁ k₂ = f k₁ k₂ +c g k₁ k₂

negf : Field → Field
negf f k₁ k₂ = negc (f k₁ k₂)

-- scalar multiple
_·f_ : ℤi → Field → Field
(c ·f f) k₁ k₂ = c ·c f k₁ k₂

infixl 15 _+f_
infixl 16 _·f_

-- the box of modes
box : List ℤ
box = negsuc 1 ∷ negsuc 0 ∷ pos 0 ∷ pos 1 ∷ pos 2 ∷ []

sumL : List ℤ → (ℤ → ℤi) → ℤi
sumL [] g = 0c
sumL (x ∷ xs) g = g x +c sumL xs g

-- convolution over the box: exact for inputs supported in [−1, 1]²
_∗_ : Field → Field → Field
(f ∗ g) k₁ k₂ = sumL box (λ p₁ → sumL box (λ p₂ → f p₁ p₂ ·c g (k₁ - p₁) (k₂ - p₂)))

infixl 17 _∗_

-- the fine frequency
N : ℤ
N = pos 2

∂₁ ∂₂ ∂₃ Δ : Field → Field
∂₁ f k₁ k₂ = (i ·c ι (N · k₁)) ·c f k₁ k₂
∂₂ f k₁ k₂ = (i ·c ι k₂) ·c f k₁ k₂
∂₃ f k₁ k₂ = 0c
Δ f k₁ k₂ = negc (ι (N · k₁ · (N · k₁) + k₂ · k₂)) ·c f k₁ k₂

-- x₁-average: the row k₁ = 0
avg : Field → ℤ → ℤi
avg f k₂ = f (pos 0) k₂

-- P_{≤1}: k₁ = 0 and |k₂| ≤ 1
P≤1 : Field → Field
P≤1 f (pos 0) (pos 0) = f (pos 0) (pos 0)
P≤1 f (pos 0) (pos 1) = f (pos 0) (pos 1)
P≤1 f (pos 0) (negsuc 0) = f (pos 0) (negsuc 0)
P≤1 f _ _ = 0c

-- vector fields
record Vec3 : Type where
  constructor vec
  field
    u₁ u₂ u₃ : Field
open Vec3 public

div : Vec3 → Field
div (vec f g h) = ∂₁ f +f ∂₂ g +f ∂₃ h

-- (u·∇)w componentwise: Σⱼ uⱼ ∗ ∂ⱼ w
adv : Vec3 → Field → Field
adv (vec f g h) w = f ∗ ∂₁ w +f g ∗ ∂₂ w +f h ∗ ∂₃ w

NL : Vec3 → Vec3
NL u = vec (adv u (u₁ u)) (adv u (u₂ u)) (adv u (u₃ u))

Lap : Vec3 → Vec3
Lap (vec f g h) = vec (Δ f) (Δ g) (Δ h)

_+v_ : Vec3 → Vec3 → Vec3
vec f g h +v vec f' g' h' = vec (f +f f') (g +f g') (h +f h')

negv : Vec3 → Vec3
negv (vec f g h) = vec (negf f) (negf g) (negf h)

scalev : ℤ → Vec3 → Vec3
scalev c (vec f g h) = vec (ι c ·f f) (ι c ·f g) (ι c ·f h)

P≤1v : Vec3 → Vec3
P≤1v (vec f g h) = vec (P≤1 f) (P≤1 g) (P≤1 h)

-- ∂ₜu at t = 0 with constant pressure: −(u·∇)u + νΔu
∂ₜ : ℤ → Vec3 → Vec3
∂ₜ ν u = negv (NL u) +v scalev ν (Lap u)

------------------------------------------------------------------------
-- §1  deciding field equality on the box, and reflecting it
------------------------------------------------------------------------

eqℤ : ℤ → ℤ → Bool
eqℤ x y = Dec→Bool (discreteℤ x y)

eqℤ-sound : (x y : ℤ) → eqℤ x y ≡ true → x ≡ y
eqℤ-sound x y e with discreteℤ x y
... | yes p = p
... | no _ = ⊥-rec (true≢false (sym e))
  where
    open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
    open import Cubical.Data.Bool using (true≢false)

eqc : ℤi → ℤi → Bool
eqc (a , b) (c , d) = eqℤ a c and eqℤ b d

eqc-sound : (x y : ℤi) → eqc x y ≡ true → x ≡ y
eqc-sound (a , b) (c , d) e = cong₂ _,_ (eqℤ-sound a c (and-left e)) (eqℤ-sound b d (and-right e))
  where
    open import Cubical.Data.Bool using (true≢false)
    open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
    and-left : {x y : Bool} → x and y ≡ true → x ≡ true
    and-left {true} _ = refl
    and-left {false} e = ⊥-rec (true≢false (sym e))
    and-right : {x y : Bool} → x and y ≡ true → y ≡ true
    and-right {true} e = e
    and-right {false} e = ⊥-rec (true≢false (sym e))

-- all points of a list satisfy a Boolean test
allL : List ℤ → (ℤ → Bool) → Bool
allL [] _ = true
allL (x ∷ xs) t = t x and allL xs t

-- membership in a list, as a type
_∈_ : ℤ → List ℤ → Type
x ∈ [] = ⊥
x ∈ (y ∷ ys) = (x ≡ y) ⊎' (x ∈ ys)
  where
    open import Cubical.Data.Sum using () renaming (_⊎_ to _⊎'_)

open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Bool using (true≢false)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)

allL-sound : (xs : List ℤ) (t : ℤ → Bool) → allL xs t ≡ true → (x : ℤ) → x ∈ xs → t x ≡ true
allL-sound (y ∷ ys) t e x (inl p) = cong t p ∙ and-left e
  where
    and-left : {x y : Bool} → x and y ≡ true → x ≡ true
    and-left {true} _ = refl
    and-left {false} e = ⊥-rec (true≢false (sym e))
allL-sound (y ∷ ys) t e x (inr m) = allL-sound ys t (and-right e) x m
  where
    and-right : {x y : Bool} → x and y ≡ true → y ≡ true
    and-right {true} e = e
    and-right {false} e = ⊥-rec (true≢false (sym e))

-- field equality on the box, decided
eqBox : Field → Field → Bool
eqBox f g = allL box (λ k₁ → allL box (λ k₂ → eqc (f k₁ k₂) (g k₁ k₂)))

eqBox-sound : (f g : Field) → eqBox f g ≡ true → (k₁ k₂ : ℤ) → k₁ ∈ box → k₂ ∈ box → f k₁ k₂ ≡ g k₁ k₂
eqBox-sound f g e k₁ k₂ m₁ m₂ =
  eqc-sound (f k₁ k₂) (g k₁ k₂)
    (allL-sound box (λ k₂' → eqc (f k₁ k₂') (g k₁ k₂'))
      (allL-sound box (λ k₁' → allL box (λ k₂' → eqc (f k₁' k₂') (g k₁' k₂'))) e k₁ m₁) k₂ m₂)

-- row equality (for averages), decided
eqRow : (ℤ → ℤi) → (ℤ → ℤi) → Bool
eqRow r s = allL box (λ k₂ → eqc (r k₂) (s k₂))

eqRow-sound : (r s : ℤ → ℤi) → eqRow r s ≡ true → (k₂ : ℤ) → k₂ ∈ box → r k₂ ≡ s k₂
eqRow-sound r s e k₂ m = eqc-sound (r k₂) (s k₂) (allL-sound box (λ k₂' → eqc (r k₂') (s k₂')) e k₂ m)

------------------------------------------------------------------------
-- §2  the fields, the divergence, the nonlinear term, the pressure
------------------------------------------------------------------------

-- a = 2 cos(N x₁):  a(±1, 0) = 1
a : Field
a (pos 1) (pos 0) = 1c
a (negsuc 0) (pos 0) = 1c
a _ _ = 0c

-- v = 2 cos(N x₁ + x₂):  v(1, 1) = v(−1, −1) = 1
v : Field
v (pos 1) (pos 1) = 1c
v (negsuc 0) (negsuc 0) = 1c
v _ _ = 0c

-- the pair
u : ℤ → Vec3
u σ = vec 0f a (ι σ ·f v)

-- Kronecker rows on k₂
δ : ℤ → ℤ → ℤi
δ j k₂ with discreteℤ j k₂
... | yes _ = 1c
... | no _ = 0c

-- (i) incompressible: u₁ = 0, a has no x₂-dependence, nothing depends on x₃.
--     σ never enters, so one computation covers every σ.
div-u : (σ : ℤ) → eqBox (div (u σ)) 0f ≡ true
div-u σ = refl

-- (ii) the nonlinear term is (0 , 0 , σ · (a ∗ ∂₂v))
-- the two signs of the pair
data Sign : Type where
  plus minus : Sign

σ⟨_⟩ : Sign → ℤ
σ⟨ plus ⟩ = pos 1
σ⟨ minus ⟩ = negsuc 0

nl₁ : (s : Sign) → eqBox (u₁ (NL (u σ⟨ s ⟩))) 0f ≡ true
nl₁ plus = refl
nl₁ minus = refl

nl₂ : (s : Sign) → eqBox (u₂ (NL (u σ⟨ s ⟩))) 0f ≡ true
nl₂ plus = refl
nl₂ minus = refl

nl₃ : (s : Sign) → eqBox (u₃ (NL (u σ⟨ s ⟩))) (ι σ⟨ s ⟩ ·f (a ∗ ∂₂ v)) ≡ true
nl₃ plus = refl
nl₃ minus = refl

-- (iii) the nonlinear term is divergence-free: the Leray projection is the
--       identity on it, the pressure gradient is zero — the pressure is constant.
div-NL : (s : Sign) → eqBox (div (NL (u σ⟨ s ⟩))) 0f ≡ true
div-NL plus = refl
div-NL minus = refl

-- as paths on the box
nonlinear-term : (k₁ k₂ : ℤ) → k₁ ∈ box → k₂ ∈ box → u₃ (NL (u (pos 1))) k₁ k₂ ≡ (a ∗ ∂₂ v) k₁ k₂
nonlinear-term = eqBox-sound _ _ (nl₃ plus)

pressure-constant : (s : Sign) (k₁ k₂ : ℤ) → k₁ ∈ box → k₂ ∈ box → div (NL (u σ⟨ s ⟩)) k₁ k₂ ≡ 0c
pressure-constant s = eqBox-sound _ _ (div-NL s)

------------------------------------------------------------------------
-- §3  the coarse stress: x₁-averages of u ⊗ u
------------------------------------------------------------------------

two-δ₀ : ℤ → ℤi
two-δ₀ k₂ = ι (pos 2) ·c δ (pos 0) k₂

-- δ₁ + δ₋₁ = 2 cos x₂ as coefficients
cosRow : ℤ → ℤi
cosRow k₂ = δ (pos 1) k₂ +c δ (negsuc 0) k₂

stress₂₂ : (s : Sign) → eqRow (avg (u₂ (u σ⟨ s ⟩) ∗ u₂ (u σ⟨ s ⟩))) two-δ₀ ≡ true
stress₂₂ plus = refl
stress₂₂ minus = refl

stress₂₃ : (s : Sign) → eqRow (avg (u₂ (u σ⟨ s ⟩) ∗ u₃ (u σ⟨ s ⟩))) (λ k₂ → ι σ⟨ s ⟩ ·c cosRow k₂) ≡ true
stress₂₃ plus = refl
stress₂₃ minus = refl

stress₃₃ : (s : Sign) → eqRow (avg (u₃ (u σ⟨ s ⟩) ∗ u₃ (u σ⟨ s ⟩))) two-δ₀ ≡ true
stress₃₃ plus = refl
stress₃₃ minus = refl

-- the first row and column vanish: u₁ = 0
stress₁ⱼ : (s : Sign) → eqRow (avg (u₁ (u σ⟨ s ⟩) ∗ u₃ (u σ⟨ s ⟩))) (λ _ → 0c) ≡ true
stress₁ⱼ plus = refl
stress₁ⱼ minus = refl

------------------------------------------------------------------------
-- §4  the coarse continuation: P_{≤1} ∂ₜu(0) for two viscosities
------------------------------------------------------------------------

-- −i δ₁ + i δ₋₁ = 2 sin x₂ as coefficients
sinRow : Field
sinRow (pos 0) (pos 1) = negc i
sinRow (pos 0) (negsuc 0) = i
sinRow _ _ = 0c

-- two viscosities, to exhibit that the viscous term is projected away
data Visc : Type where
  one seven : Visc

ν⟨_⟩ : Visc → ℤ
ν⟨ one ⟩ = pos 1
ν⟨ seven ⟩ = pos 7

cont₁ : (n : Visc) (s : Sign) → eqBox (u₁ (P≤1v (∂ₜ ν⟨ n ⟩ (u σ⟨ s ⟩)))) 0f ≡ true
cont₁ one plus = refl
cont₁ one minus = refl
cont₁ seven plus = refl
cont₁ seven minus = refl

cont₂ : (n : Visc) (s : Sign) → eqBox (u₂ (P≤1v (∂ₜ ν⟨ n ⟩ (u σ⟨ s ⟩)))) 0f ≡ true
cont₂ one plus = refl
cont₂ one minus = refl
cont₂ seven plus = refl
cont₂ seven minus = refl

cont₃ : (n : Visc) (s : Sign) → eqBox (u₃ (P≤1v (∂ₜ ν⟨ n ⟩ (u σ⟨ s ⟩)))) (ι σ⟨ s ⟩ ·f sinRow) ≡ true
cont₃ one plus = refl
cont₃ one minus = refl
cont₃ seven plus = refl
cont₃ seven minus = refl

coarse-continuation : (k₁ k₂ : ℤ) → k₁ ∈ box → k₂ ∈ box
                    → u₃ (P≤1v (∂ₜ (pos 1) (u (pos 1)))) k₁ k₂ ≡ sinRow k₁ k₂
coarse-continuation = eqBox-sound _ _ (cont₃ one plus)

------------------------------------------------------------------------
-- §5  the pair
------------------------------------------------------------------------

-- σ-even entries agree …
pair-stress-even : eqRow (avg (u₃ (u (pos 1)) ∗ u₃ (u (pos 1)))) (avg (u₃ (u (negsuc 0)) ∗ u₃ (u (negsuc 0)))) ≡ true
pair-stress-even = refl

-- … the σ-odd entry and the continuation are negated
pair-stress-odd : eqRow (avg (u₂ (u (negsuc 0)) ∗ u₃ (u (negsuc 0)))) (λ k₂ → negc (avg (u₂ (u (pos 1)) ∗ u₃ (u (pos 1))) k₂)) ≡ true
pair-stress-odd = refl

pair-continuation-odd : eqBox (u₃ (P≤1v (∂ₜ (pos 1) (u (negsuc 0))))) (negf (u₃ (P≤1v (∂ₜ (pos 1) (u (pos 1)))))) ≡ true
pair-continuation-odd = refl
