{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सोपान — the ladder.  EVERY STRATUM OF THE HASSE LADDER IS DECIDED,
-- WITH ITS EVIDENCE, FOR EVERY PRIME AND EVERY CURVE.
--
-- Asked with no approach assumed, the machine's garbha.dhara birthed
-- a stream: at every stratum, syād-asti-nāsti in succession — the
-- arithmetic affirms where it has looked, the pervasion stays
-- unestablished — and the totality avaktavya.  The construction that
-- stream names is not a pile of cases and not a descent: it is the
-- LADDER AS ONE THEOREM, universally quantified over the stratum:
--
--   `stratum-decided` — for EVERY modulus p = suc p' and EVERY curve
--     y² = x³ + Ax + B, the Hasse stratum is decided with evidence
--     in hand either way: the point count (meaning secured by the
--     residue instrument), the trace presented subtraction-free on
--     whichever side it falls, and the verdict — critical-circle
--     certificate trace² ≤ 4p, or the explicit crossing 4p < trace².
--     No stratum can be cherry-picked and none can hide: a defeater
--     of the pervasion, if one existed, would surface at its own
--     stratum as the right branch, constructed.
--
--   `HassePervasion` — the universal claim (the right branch never
--     inhabited at prime p) as a TYPE; `restrict` takes it to each
--     stratum's left branch; no term runs backwards.  For prime
--     moduli the pervasion is Hasse's theorem (1933); for composite
--     moduli it can genuinely fail, and the ladder does not care:
--     it decides every stratum and lets the pervasion be exactly as
--     established as it is.
--
-- The residue instrument (mod with its full specification, residue
-- equality carrying a congruence witness) returns here inside a
-- universally quantified result — its only legitimate home.
------------------------------------------------------------------------

module Sopana_EveryStratumOfTheHasseLadderIsDecidedWithItsEvidenceForEveryPrimeAndEveryCurve where

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
  using (le? ; eq?-complete)

------------------------------------------------------------------------
-- §1  The residue instrument (restored inside a universal).
------------------------------------------------------------------------

modAux : ℕ → ℕ → ℕ → ℕ
modAux zero       a p = a
modAux (suc fuel) a p =
  Sum.rec (λ _ → modAux fuel (a ∸ suc p) p) (λ _ → a) (splitℕ-≤ (suc p) a)

mod : ℕ → ℕ → ℕ
mod a p' = modAux a a p'

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
-- §2  Every curve, every modulus: the points and the count.
------------------------------------------------------------------------

rhs : ℕ → ℕ → ℕ → ℕ
rhs A B x = x · (x · x) + A · x + B

OnCurve : ℕ → ℕ → ℕ → ℕ → ℕ → Type
OnCurve p' A B x y = mod (y · y) p' ≡ mod (rhs A B x) p'

-- Residue equality carries its congruence witness, either side.
on-curve-means : (p' A B x y : ℕ) → OnCurve p' A B x y →
  (Σ ℕ (λ k → y · y + k · suc p' ≡ rhs A B x))
  ⊎ (Σ ℕ (λ k → rhs A B x + k · suc p' ≡ y · y))
on-curve-means p' A B x y oc = go (splitℕ-≤ k₁ k₂)
  where
  sp : ℕ
  sp = suc p'

  s₁ : (Σ ℕ (λ k → k · sp + mod (y · y) p' ≡ y · y)) × _
  s₁ = mod-full-spec (y · y) p'

  s₂ : (Σ ℕ (λ k → k · sp + mod (rhs A B x) p' ≡ rhs A B x)) × _
  s₂ = mod-full-spec (rhs A B x) p'

  k₁ k₂ : ℕ
  k₁ = fst (fst s₁)
  k₂ = fst (fst s₂)

  r : ℕ
  r = mod (y · y) p'

  e₁ : k₁ · sp + r ≡ y · y
  e₁ = snd (fst s₁)

  e₂ : k₂ · sp + r ≡ rhs A B x
  e₂ = subst (λ v → k₂ · sp + v ≡ rhs A B x) (sym oc) (snd (fst s₂))

  common : (X Y ka kb : ℕ) → ka ≤ kb →
    (ka · sp + r ≡ X) → (kb · sp + r ≡ Y) →
    Σ ℕ (λ k → X + k · sp ≡ Y)
  common X Y ka kb hab ea eb =
    (kb ∸ ka) ,
    ( +-comm X ((kb ∸ ka) · sp)
    ∙ cong (λ v → (kb ∸ ka) · sp + v) (sym ea)
    ∙ +-assoc ((kb ∸ ka) · sp) (ka · sp) r
    ∙ cong (_+ r) (·-distribʳ (kb ∸ ka) ka sp
                   ∙ cong (_· sp) (≤-∸-+-cancel hab))
    ∙ eb )

  go : (k₁ ≤ k₂) ⊎ (k₂ < k₁) → _
  go (inl h) = inl (common (y · y) (rhs A B x) k₁ k₂ h e₁ e₂)
  go (inr h) = inr (common (rhs A B x) (y · y) k₂ k₁ (<-weaken h) e₂ e₁)

indC : ℕ → ℕ → ℕ → ℕ → ℕ → ℕ
indC p' A B x y =
  rec 0 (λ _ → 1) (eq? (mod (y · y) p') (mod (rhs A B x) p'))

cntY : ℕ → ℕ → ℕ → ℕ → ℕ → ℕ
cntY p' A B x zero    = indC p' A B x zero
cntY p' A B x (suc b) = indC p' A B x (suc b) + cntY p' A B x b

cntX : ℕ → ℕ → ℕ → ℕ → ℕ
cntX p' A B zero    = cntY p' A B zero p'
cntX p' A B (suc b) = cntY p' A B (suc b) p' + cntX p' A B b

-- Points of y² = x³ + Ax + B over ℤ/(suc p'), affine plus infinity.
#E : ℕ → ℕ → ℕ → ℕ
#E p' A B = suc (cntX p' A B p')

------------------------------------------------------------------------
-- §3  THE LADDER, DECIDED AT EVERY STRATUM.
------------------------------------------------------------------------

-- The trace, subtraction-free: whichever side of p+1 the count
-- falls, the exact difference is carried with its equation.
Trace : ℕ → ℕ → ℕ → Type
Trace p' A B =
  Σ ℕ (λ t →
    ((suc (suc p') + t ≡ #E p' A B) ⊎ (#E p' A B + t ≡ suc (suc p'))))

trace-of : (p' A B : ℕ) → Trace p' A B
trace-of p' A B = go (splitℕ-≤ (suc (suc p')) (#E p' A B))
  where
  go : (suc (suc p') ≤ #E p' A B) ⊎ (#E p' A B < suc (suc p')) →
       Trace p' A B
  go (inl h) =
    (#E p' A B ∸ suc (suc p')) ,
    inl (+-comm (suc (suc p')) (#E p' A B ∸ suc (suc p'))
         ∙ ≤-∸-+-cancel h)
  go (inr h) =
    (suc (suc p') ∸ #E p' A B) ,
    inr (+-comm (#E p' A B) (suc (suc p') ∸ #E p' A B)
         ∙ ≤-∸-+-cancel (<-weaken h))

-- One stratum's verdict: the critical certificate, or the crossing —
-- with the trace's defining equation carried either way.
Verdict : ℕ → ℕ → ℕ → Type
Verdict p' A B =
  Σ (Trace p' A B) (λ tr →
    (fst tr · fst tr ≤ 4 · suc p') ⊎ (4 · suc p' < fst tr · fst tr))

-- THE THEOREM.  Every stratum decided, for every modulus and every
-- curve: no case chosen, no case hidden.
stratum-decided : (p' A B : ℕ) → Verdict p' A B
stratum-decided p' A B = tr , go (splitℕ-≤ (fst tr · fst tr) (4 · suc p'))
  where
  tr : Trace p' A B
  tr = trace-of p' A B

  go : (fst tr · fst tr ≤ 4 · suc p') ⊎ (4 · suc p' < fst tr · fst tr) →
       (fst tr · fst tr ≤ 4 · suc p') ⊎ (4 · suc p' < fst tr · fst tr)
  go v = v

------------------------------------------------------------------------
-- §4  The pervasion, as a type; the restriction; no converse.
------------------------------------------------------------------------

-- The universal claim at a modulus: the crossing never happens.
-- For prime moduli this is Hasse's theorem, by other instruments;
-- for composite moduli it can fail, and this file does not care:
-- it decides, and lets the pervasion be as established as it is.
HassePervasion : ℕ → Type
HassePervasion p' =
  (A B : ℕ) (tr : Trace p' A B) → fst tr · fst tr ≤ 4 · suc p'

restrict : (p' : ℕ) → HassePervasion p' →
  (A B : ℕ) → fst (trace-of p' A B) · fst (trace-of p' A B) ≤ 4 · suc p'
restrict p' hp A B = hp A B (trace-of p' A B)
