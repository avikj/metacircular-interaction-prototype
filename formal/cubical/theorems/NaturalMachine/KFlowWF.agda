{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.KFlowWF
--
-- WHAT IS NEW, AND WHAT IS NOT.
--
-- `KFlow.decay` and `QuestionMachine.halts` both prove that a
-- contracting obstruction flow reaches 0, and both do it with a FUEL
-- argument: `decay-fuel` / `halts-fuel` recurse on an extra ℕ and carry
-- the invariant `∂ q ≤ fuel`, with the top-level wrapper supplying
-- `fuel := ∂ q`.  That is the weaker statement in two ways.  The fuel
-- has to be produced, so the measure must be ℕ-valued (there is nothing
-- to count down otherwise), and the recursion is on the fuel rather
-- than on the thing that actually decreases.
--
-- This module removes both restrictions:
--
--   `decay-wf`          same conclusion as `QuestionMachine.halts`,
--                       no fuel parameter, recursion on the
--                       accessibility of `∂ M q` under `_<_`.
--
--   `decay-wf-general`  the same theorem for a measure `μ : 𝒬 → B`
--                       into ANY type carrying a well-founded relation
--                       `_⊏_`, with an arbitrary resolution predicate
--                       `Done`.  Termination of the flow does not
--                       depend on ℕ; it depends only on `WellFounded _⊏_`.
--
--   `decay-wf-𝒦`        `KFlow.decay` recovered as the instance
--                       `M = machine (λ n → n) f`, again without fuel.
--
-- NO CLAIM OF DEPTH IS MADE.  This is textbook well-founded recursion:
-- `acc-invImage` is the standard fact that the inverse image of a
-- well-founded relation along any function is well-founded, and
-- `wf-go` is the standard `Acc`-eliminator specialised to the flow.
-- The mathematical content is entirely in the hypothesis
-- `WellFounded _⊏_`; everything below it is bookkeeping.  The point of
-- the file is that the bookkeeping is now done once, in the general
-- form, instead of being re-derived with a counter in each concrete
-- setting.
--
-- THE CONVERSE.  The naive converse is false: an orbit can reach 0 in k
-- steps while the machine is not `Contracting` (it need only contract
-- along the one orbit, and only somewhere).  The sharp true statement
-- is `reaches-zero→drops`: if `∂` is positive at `q` and vanishes at
-- `orbit M k q`, then SOME step `j < k` of that orbit strictly
-- decreases `∂`.  Contrapositive (`reaches-zero→¬-expanding`): no
-- orbit that is non-decreasing throughout its first k steps can carry a
-- positive obstruction to 0 in k steps.  This is the exact converse
-- direction — a statement about the one orbit, not about the machine.
--
-- Definitions of `Machine`, `orbit`, `Resolves`, `Contracting` are
-- imported from `NaturalMachine.QuestionMachine`, not repeated.
------------------------------------------------------------------------

module NaturalMachine.KFlowWF where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using ( _<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; ¬-<-zero ; ¬m<m
        ; ≤<-trans ; <-trans ; _≟_ ; lt ; eq ; gt ; <-wellfounded )
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Induction.WellFounded using (Acc ; acc ; WellFounded)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.QuestionMachine
  using (Machine ; machine ; ∂ ; 𝔉 ; orbit ; Resolves ; Contracting)

import NaturalMachine.KFlow as K

private
  variable
    ℓ ℓ' ℓ'' ℓ''' : Level

------------------------------------------------------------------------
-- 1.  Inverse images of well-founded relations
--
--     Standard.  If `μ : A → B` and `_⊏_` is well-founded on B, then
--     `μ x ⊏ μ y` is well-founded on A.  This is the whole mechanism by
--     which a measure justifies a recursion, and it is why no fuel is
--     needed: the recursion is on the accessibility proof itself.
------------------------------------------------------------------------

InvImage : {A : Type ℓ} {B : Type ℓ'}
         → (B → B → Type ℓ'') → (A → B) → A → A → Type ℓ''
InvImage _⊏_ μ x y = μ x ⊏ μ y

acc-invImage :
    {A : Type ℓ} {B : Type ℓ'} (_⊏_ : B → B → Type ℓ'') (μ : A → B)
  → (x : A) → Acc _⊏_ (μ x) → Acc (InvImage _⊏_ μ) x
acc-invImage _⊏_ μ x (acc r) =
  acc (λ y y≺x → acc-invImage _⊏_ μ y (r (μ y) y≺x))

wf-invImage :
    {A : Type ℓ} {B : Type ℓ'} (_⊏_ : B → B → Type ℓ'') (μ : A → B)
  → WellFounded _⊏_ → WellFounded (InvImage _⊏_ μ)
wf-invImage _⊏_ μ wf x = acc-invImage _⊏_ μ x (wf (μ x))

------------------------------------------------------------------------
-- 2.  The flow with an arbitrary measure
--
--     `iter` is `orbit` for a bare endomap (`orbit` is tied to a
--     `Machine`, hence to a ℕ-valued `∂`; the bridge is `orbit≡iter`).
--
--     `GContracting` is the honest generalisation of `Contracting`:
--     at every question, EITHER we are already done, OR the measure
--     strictly drops.  In the ℕ case this dichotomy is exactly
--     `zeroOrPos` combined with `Contracting`; in general there is no
--     "0" to compare against, so the disjunction is the hypothesis.
------------------------------------------------------------------------

iter : {A : Type ℓ} → (A → A) → ℕ → A → A
iter f zero    x = x
iter f (suc k) x = iter f k (f x)

GContracting :
    {𝒬 : Type ℓ} {B : Type ℓ'}
  → (B → B → Type ℓ'') → (𝒬 → 𝒬) → (𝒬 → B) → (𝒬 → Type ℓ''')
  → Type (ℓ-max ℓ (ℓ-max ℓ''' ℓ''))
GContracting {𝒬 = 𝒬} _⊏_ step μ Done =
  (q : 𝒬) → Done q ⊎ (μ (step q) ⊏ μ q)

GResolves : {𝒬 : Type ℓ} → (𝒬 → 𝒬) → (𝒬 → Type ℓ') → 𝒬 → Type ℓ'
GResolves step Done q = Σ[ k ∈ ℕ ] Done (iter step k q)

private
  wf-go :
      {𝒬 : Type ℓ} {B : Type ℓ'} (_⊏_ : B → B → Type ℓ'')
      (step : 𝒬 → 𝒬) (μ : 𝒬 → B) (Done : 𝒬 → Type ℓ''')
    → GContracting _⊏_ step μ Done
    → (q : 𝒬) → Acc (InvImage _⊏_ μ) q → GResolves step Done q
  wf-go _⊏_ step μ Done c q (acc r) with c q
  ... | inl done = 0 , done
  ... | inr drop =
        let rest = wf-go _⊏_ step μ Done c (step q) (r (step q) drop)
        in suc (fst rest) , snd rest

-- The general termination theorem.  No fuel, no ℕ-valued measure, no
-- ordering on the "resolved" side.
decay-wf-general :
    {𝒬 : Type ℓ} {B : Type ℓ'} (_⊏_ : B → B → Type ℓ'')
    (step : 𝒬 → 𝒬) (μ : 𝒬 → B) (Done : 𝒬 → Type ℓ''')
  → WellFounded _⊏_
  → GContracting _⊏_ step μ Done
  → (q : 𝒬) → GResolves step Done q
decay-wf-general _⊏_ step μ Done wf c q =
  wf-go _⊏_ step μ Done c q (wf-invImage _⊏_ μ wf q)

------------------------------------------------------------------------
-- 3.  The ℕ-valued case: `QuestionMachine.halts` without fuel
------------------------------------------------------------------------

orbit≡iter : {𝒬 : Type₀} (M : Machine 𝒬) (k : ℕ) (q : 𝒬)
           → orbit M k q ≡ iter (𝔉 M) k q
orbit≡iter M zero    q = refl
orbit≡iter M (suc k) q = orbit≡iter M k (𝔉 M q)

private
  zeroOrPos : (n : ℕ) → (n ≡ 0) ⊎ (0 < n)
  zeroOrPos zero    = inl refl
  zeroOrPos (suc n) = inr (suc-≤-suc zero-≤)

  dichotomy :
      {𝒬 : Type₀} (M : Machine 𝒬) → Contracting M
    → GContracting _<_ (𝔉 M) (∂ M) (λ p → ∂ M p ≡ 0)
  dichotomy M c q with zeroOrPos (∂ M q)
  ... | inl z   = inl z
  ... | inr pos = inr (c q pos)

-- विघ्नक्षयः, by well-founded recursion on ∂ M q.
decay-wf : {𝒬 : Type₀} (M : Machine 𝒬) → Contracting M → (q : 𝒬) → Resolves M q
decay-wf M c q = fst r , cong (∂ M) (orbit≡iter M (fst r) q) ∙ snd r
  where
    r : GResolves (𝔉 M) (λ p → ∂ M p ≡ 0) q
    r = decay-wf-general _<_ (𝔉 M) (∂ M) (λ p → ∂ M p ≡ 0)
          <-wellfounded (dichotomy M c) q

------------------------------------------------------------------------
-- 3'.  `KFlow.decay` is the instance ∂ = id, and needs no fuel either
------------------------------------------------------------------------

𝒦-machine : K.𝒦 → Machine ℕ
𝒦-machine f = machine (λ n → n) f

-- `KFlow.Contracting f` and `Contracting (𝒦-machine f)` are the same type.
𝒦-contracting : (f : K.𝒦) → K.Contracting f → Contracting (𝒦-machine f)
𝒦-contracting f c = c

iterate≡orbit : (f : K.𝒦) (k n : ℕ) → K.iterate f k n ≡ orbit (𝒦-machine f) k n
iterate≡orbit f zero    n = refl
iterate≡orbit f (suc k) n = iterate≡orbit f k (f n)

decay-wf-𝒦 : (f : K.𝒦) → K.Contracting f → (n : ℕ) → Σ[ k ∈ ℕ ] K.iterate f k n ≡ 0
decay-wf-𝒦 f c n = fst r , iterate≡orbit f (fst r) n ∙ snd r
  where
    r : Resolves (𝒦-machine f) n
    r = decay-wf (𝒦-machine f) (𝒦-contracting f c) n

------------------------------------------------------------------------
-- 4.  The converse direction that is actually true
--
--     From `Resolves` one cannot recover `Contracting`: the machine is
--     unconstrained off the orbit of q, and even on it need only drop
--     once.  What IS forced is a strict decrease somewhere in the first
--     k steps.  That is sharp: `reaches-zero→drops` produces exactly one
--     index, and no more can be produced, since a machine may sit still
--     for k−1 steps and then send ∂ to 0 in one.
------------------------------------------------------------------------

reaches-zero→drops :
    {𝒬 : Type₀} (M : Machine 𝒬) (k : ℕ) (q : 𝒬)
  → 0 < ∂ M q
  → ∂ M (orbit M k q) ≡ 0
  → Σ[ j ∈ ℕ ] (j < k) × (∂ M (orbit M (suc j) q) < ∂ M (orbit M j q))
reaches-zero→drops M zero q pos h = ⊥.rec (¬-<-zero (subst (0 <_) h pos))
reaches-zero→drops M (suc k) q pos h with ∂ M (𝔉 M q) ≟ ∂ M q
... | lt p = 0 , suc-≤-suc zero-≤ , p
... | eq p =
      let rest = reaches-zero→drops M k (𝔉 M q) (subst (0 <_) (sym p) pos) h
      in suc (fst rest) , suc-≤-suc (fst (snd rest)) , snd (snd rest)
... | gt p =
      let rest = reaches-zero→drops M k (𝔉 M q) (<-trans pos p) h
      in suc (fst rest) , suc-≤-suc (fst (snd rest)) , snd (snd rest)

-- Contrapositive: an orbit that never decreases in its first k steps
-- cannot carry a positive obstruction to 0 in k steps.  This is the
-- precise sense in which reaching 0 forbids expansion ALONG THE ORBIT
-- (nothing at all is claimed about the machine elsewhere).
reaches-zero→¬-expanding :
    {𝒬 : Type₀} (M : Machine 𝒬) (k : ℕ) (q : 𝒬)
  → 0 < ∂ M q
  → ∂ M (orbit M k q) ≡ 0
  → ¬ ((j : ℕ) → j < k → ∂ M (orbit M j q) ≤ ∂ M (orbit M (suc j) q))
reaches-zero→¬-expanding M k q pos h nonexp =
  ¬m<m (≤<-trans (nonexp (fst w) (fst (snd w))) (snd (snd w)))
  where
    w : Σ[ j ∈ ℕ ] (j < k) × (∂ M (orbit M (suc j) q) < ∂ M (orbit M j q))
    w = reaches-zero→drops M k q pos h

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
