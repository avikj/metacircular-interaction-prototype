{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रवाह — the flow.  THE FROBENIUS FLOW COUNTED, AND EVERY ZERO ON
-- THE CRITICAL CIRCLE, FOR THESE CURVES.
--
-- The Riemann Hypothesis that is PROVED is the function-field one:
-- for a curve over 𝔽_p, the zeta function's zeros lie on |α| = √p —
-- Hasse for elliptic curves, Weil in general — and there the proof
-- is topology: Frobenius is a flow on the curve, its fixed points
-- are the 𝔽_p-points, and the zeros' position is the spectral
-- statement about that flow.  This is the exact ground of the
-- number-field conjecture: Deninger's program asks for the flow
-- whose closed orbits are the primes.
--
-- This file makes the proven case kernel-exact, for the curve
-- y² = x³ + x + 1 over six fields.  The residue arithmetic is a
-- proved instrument: `mod` with its specification (`mod-spec`:
-- quotient witness and strict bound), and `on-curve-means`
-- converting residue equality into a congruence witness, so the
-- point count COUNTS POINTS, not artifacts of an encoding:
--
--     p        5    7    11   13   17   19
--     #E(𝔽_p)  9    5    14   18   18   21
--     a_p     −3    3    −2   −4    0   −1
--
-- and for each, the critical-circle certificate a² ≤ 4p — the
-- discriminant condition placing both reciprocal zeros of
-- 1 − a_p T + p T² on |α| = √p — closes by an exact inequality
-- witness.  At p = 17 the flow is supersingular: a = 0, the zeros
-- at ±i√17 exactly.
--
-- Hasse proved this for every curve; these six are the kernel's
-- signatures on the proven RH, the template the open one is
-- conjectured to follow.  The open RH enters this corpus only as
-- the Goldbach lane already carries it: through what the prime
-- field determines.
------------------------------------------------------------------------

module PravahaRH_TheFrobeniusFlowCountedAndEveryZeroOnTheCriticalCircleForTheseCurves where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ;
  +-assoc ; +-comm ; +-suc ; ·-distribʳ)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ;
         ≤-trans ; ≤<-trans ; <≤-trans ; splitℕ-≤ ; <-split ;
         ≤SumLeft ; ≤SumRight ; ≤-refl ; <-weaken ; ≤-∸-+-cancel)
open import Cubical.Data.Sum as Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; rec)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (eq?-complete)

------------------------------------------------------------------------
-- §1  Residue arithmetic, as a proved instrument.
------------------------------------------------------------------------

modAux : ℕ → ℕ → ℕ → ℕ
modAux zero       a p = a
modAux (suc fuel) a p =
  Sum.rec (λ _ → modAux fuel (a ∸ suc p) p) (λ _ → a) (splitℕ-≤ (suc p) a)

-- mod a (suc p'): the canonical residue modulo p = suc p'.
mod : ℕ → ℕ → ℕ
mod a p' = modAux a a p'

-- THE SPECIFICATION: a quotient witness, and the strict bound.  Once
-- and generically, so every residue equality below carries meaning.
mod-spec : (fuel a p' : ℕ) → a ≤ fuel →
  (Σ ℕ (λ k → k · suc p' + modAux fuel a p' ≡ a))
  × (modAux fuel a p' < suc p')
mod-spec zero a p' ha = go0 (<-split (suc-≤-suc ha))
  where
  go0 : (a < zero) ⊎ (a ≡ zero) → _
  go0 (inl a<) = Empty.rec (¬-<-zero a<)
  go0 (inr a0) =
    (0 , refl) , subst (_< suc p') (sym a0) (suc-≤-suc zero-≤)
mod-spec (suc fuel) a p' ha = g (splitℕ-≤ (suc p') a) refl
  where
  g : (s : (suc p' ≤ a) ⊎ (a < suc p')) → splitℕ-≤ (suc p') a ≡ s →
      (Σ ℕ (λ k → k · suc p' + modAux (suc fuel) a p' ≡ a))
      × (modAux (suc fuel) a p' < suc p')
  g (inl h) ps =
    subst (λ r → (Σ ℕ (λ k → k · suc p' + r ≡ a)) × (r < suc p'))
          (sym redEq)
          ((suc (fst (fst ih)) , path) , snd ih)
    where
    a' : ℕ
    a' = a ∸ suc p'

    redEq : modAux (suc fuel) a p' ≡ modAux fuel a' p'
    redEq = cong (Sum.rec (λ _ → modAux fuel a' p') (λ _ → a)) ps

    a'<a : a' < a
    a'<a = subst (a' <_) (≤-∸-+-cancel h)
             (subst (suc a' ≤_) (sym (+-suc a' p'))
               (suc-≤-suc (≤SumLeft {n = a'} {k = p'})))

    fuel-ok : a' ≤ fuel
    fuel-ok = pred-≤-pred (<≤-trans a'<a ha)

    ih : (Σ ℕ (λ k → k · suc p' + modAux fuel a' p' ≡ a'))
         × (modAux fuel a' p' < suc p')
    ih = mod-spec fuel a' p' fuel-ok

    path : suc (fst (fst ih)) · suc p' + modAux fuel a' p' ≡ a
    path =
      sym (+-assoc (suc p') (fst (fst ih) · suc p') (modAux fuel a' p'))
      ∙ cong (suc p' +_) (snd (fst ih))
      ∙ +-comm (suc p') a'
      ∙ ≤-∸-+-cancel h
  g (inr h) ps =
    subst (λ r → (Σ ℕ (λ k → k · suc p' + r ≡ a)) × (r < suc p'))
          (sym redEq)
          ((0 , refl) , h)
    where
    redEq : modAux (suc fuel) a p' ≡ a
    redEq = cong (Sum.rec (λ _ → modAux fuel (a ∸ suc p') p') (λ _ → a)) ps

mod-full-spec : (a p' : ℕ) →
  (Σ ℕ (λ k → k · suc p' + mod a p' ≡ a)) × (mod a p' < suc p')
mod-full-spec a p' = mod-spec a a p' ≤-refl

------------------------------------------------------------------------
-- §2  The curve, its points by residue equality, and the count.
------------------------------------------------------------------------

rhs : ℕ → ℕ
rhs x = x · (x · x) + x + 1

-- On the curve: the two sides agree as residues.  p is suc p'.
OnCurve : ℕ → ℕ → ℕ → Type
OnCurve p' x y = mod (y · y) p' ≡ mod (rhs x) p'

-- Residue equality carries its meaning: a congruence witness, one
-- side or the other.
on-curve-means : (p' x y : ℕ) → OnCurve p' x y →
  (Σ ℕ (λ k → y · y + k · suc p' ≡ rhs x))
  ⊎ (Σ ℕ (λ k → rhs x + k · suc p' ≡ y · y))
on-curve-means p' x y oc = go (splitℕ-≤ k₁ k₂)
  where
  sp : ℕ
  sp = suc p'

  s₁ : (Σ ℕ (λ k → k · sp + mod (y · y) p' ≡ y · y)) × _
  s₁ = mod-full-spec (y · y) p'

  s₂ : (Σ ℕ (λ k → k · sp + mod (rhs x) p' ≡ rhs x)) × _
  s₂ = mod-full-spec (rhs x) p'

  k₁ k₂ : ℕ
  k₁ = fst (fst s₁)
  k₂ = fst (fst s₂)

  r : ℕ
  r = mod (y · y) p'

  e₁ : k₁ · sp + r ≡ y · y
  e₁ = snd (fst s₁)

  e₂ : k₂ · sp + r ≡ rhs x
  e₂ = subst (λ v → k₂ · sp + v ≡ rhs x) (sym oc) (snd (fst s₂))

  common : (A B ka kb : ℕ) → ka ≤ kb →
    (ka · sp + r ≡ A) → (kb · sp + r ≡ B) →
    Σ ℕ (λ k → A + k · sp ≡ B)
  common A B ka kb hab ea eb =
    (kb ∸ ka) ,
    ( +-comm A ((kb ∸ ka) · sp)
    ∙ cong (λ v → (kb ∸ ka) · sp + v) (sym ea)
    ∙ +-assoc ((kb ∸ ka) · sp) (ka · sp) r
    ∙ cong (_+ r) (·-distribʳ (kb ∸ ka) ka sp
                   ∙ cong (_· sp) (≤-∸-+-cancel hab))
    ∙ eb )

  go : (k₁ ≤ k₂) ⊎ (k₂ < k₁) →
    (Σ ℕ (λ k → y · y + k · sp ≡ rhs x))
    ⊎ (Σ ℕ (λ k → rhs x + k · sp ≡ y · y))
  go (inl h) = inl (common (y · y) (rhs x) k₁ k₂ h e₁ e₂)
  go (inr h) = inr (common (rhs x) (y · y) k₂ k₁ (<-weaken h) e₂ e₁)

indC : ℕ → ℕ → ℕ → ℕ
indC p' x y = rec 0 (λ _ → 1) (eq? (mod (y · y) p') (mod (rhs x) p'))

cntY : ℕ → ℕ → ℕ → ℕ
cntY p' x zero    = indC p' x zero
cntY p' x (suc b) = indC p' x (suc b) + cntY p' x b

cntX : ℕ → ℕ → ℕ → ℕ
cntX p' bY zero    = cntY p' zero bY
cntX p' bY (suc b) = cntY p' (suc b) bY + cntX p' bY b

-- Affine points of y² = x³ + x + 1 over 𝔽_(suc p'), plus infinity.
#E : ℕ → ℕ
#E p' = suc (cntX p' p' p')

------------------------------------------------------------------------
-- §3  The six flows, counted, with their critical-circle
--     certificates.  a_p is carried subtraction-free: the count
--     equation and the Hasse inequality both in ℕ.
------------------------------------------------------------------------

-- p = 5 : #E = 9, a = −3 : (p+1) + 3 ≡ #E, 3² ≤ 4·5.
count-5 : #E 4 ≡ 9
count-5 = refl

trace-5 : 5 + 1 + 3 ≡ #E 4
trace-5 = refl

critical-5 : 3 · 3 ≤ 4 · 5
critical-5 = 11 , refl

-- p = 7 : #E = 5, a = 3 : #E + 3 ≡ p+1, 3² ≤ 4·7.
count-7 : #E 6 ≡ 5
count-7 = refl

trace-7 : #E 6 + 3 ≡ 7 + 1
trace-7 = refl

critical-7 : 3 · 3 ≤ 4 · 7
critical-7 = 19 , refl

-- p = 11 : #E = 14, a = −2.
count-11 : #E 10 ≡ 14
count-11 = refl

trace-11 : 11 + 1 + 2 ≡ #E 10
trace-11 = refl

critical-11 : 2 · 2 ≤ 4 · 11
critical-11 = 40 , refl

-- p = 13 : #E = 18, a = −4.
count-13 : #E 12 ≡ 18
count-13 = refl

trace-13 : 13 + 1 + 4 ≡ #E 12
trace-13 = refl

critical-13 : 4 · 4 ≤ 4 · 13
critical-13 = 36 , refl

-- p = 17 : #E = 18, a = 0 — SUPERSINGULAR: the zeros at ±i√17,
-- dead centre of the critical circle.
count-17 : #E 16 ≡ 18
count-17 = refl

trace-17 : 17 + 1 ≡ #E 16
trace-17 = refl

critical-17 : 0 · 0 ≤ 4 · 17
critical-17 = zero-≤

-- p = 19 : #E = 21, a = −1.
count-19 : #E 18 ≡ 21
count-19 = refl

trace-19 : 19 + 1 + 1 ≡ #E 18
trace-19 = refl

critical-19 : 1 · 1 ≤ 4 · 19
critical-19 = 75 , refl
