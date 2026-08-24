-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.RewriteCertificate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)

data Tm : Type₀ where
  var yvar zvar uvar vvar wvar : Tm
  zero : Tm
  suc  : Tm → Tm
  add  : Tm → Tm → Tm

data Step : Tm → Tm → Type₀ where
  add-zero : (x : Tm) → Step (add x zero) x
  add-suc  : (x y : Tm) → Step (add x (suc y)) (suc (add x y))
  suc-step : {x y : Tm} → Step x y → Step (suc x) (suc y)
  add-left : {x y : Tm} → Step x y → (z : Tm) → Step (add x z) (add y z)
  add-right : (z : Tm) → {x y : Tm} → Step x y → Step (add z x) (add z y)
  reverse : {x y : Tm} → Step x y → Step y x

data Derivation : Tm → Tm → Type₀ where
  done : (x : Tm) → Derivation x x
  then-step : {x y z : Tm} → Step x y → Derivation y z → Derivation x z

subVar : Tm → Tm → Tm
subVar u var = u
subVar u yvar = yvar
subVar u zvar = zvar
subVar u uvar = uvar
subVar u vvar = vvar
subVar u wvar = wvar
subVar u zero = zero
subVar u (suc t) = suc (subVar u t)
subVar u (add l r) = add (subVar u l) (subVar u r)

-- A rewrite system parameterized by exactly one induction hypothesis.
-- The hypothesis is conclusion-indexed and may be used under contexts.
data HypStep (ihL ihR : Tm) : Tm → Tm → Type₀ where
  lift-step : {x y : Tm} → Step x y → HypStep ihL ihR x y
  hypothesis : HypStep ihL ihR ihL ihR
  reverse-hypothesis : HypStep ihL ihR ihR ihL
  hyp-suc : {x y : Tm} → HypStep ihL ihR x y
          → HypStep ihL ihR (suc x) (suc y)
  hyp-add-left : {x y : Tm} → HypStep ihL ihR x y → (z : Tm)
               → HypStep ihL ihR (add x z) (add y z)
  hyp-add-right : (z : Tm) → {x y : Tm} → HypStep ihL ihR x y
                → HypStep ihL ihR (add z x) (add z y)

data HypDerivation (ihL ihR : Tm) : Tm → Tm → Type₀ where
  hyp-done : (x : Tm) → HypDerivation ihL ihR x x
  hyp-then : {x y z : Tm} → HypStep ihL ihR x y
           → HypDerivation ihL ihR y z → HypDerivation ihL ihR x z

record InductionCertificate (lhs rhs : Tm) : Type₀ where
  field
    base : Derivation (subVar zero lhs) (subVar zero rhs)
    step : HypDerivation lhs rhs
      (subVar (suc var) lhs) (subVar (suc var) rhs)

-- The executable meaning of the syntax.  `var` is interpreted by one
-- environment; the remaining constructors are the actual natural zero,
-- successor, and addition.  Keeping all six coordinates distinct matters:
-- identifying them would prove only equality on the diagonal.
record Env : Type₀ where
  constructor env
  field x y z u v w : ℕ

open Env

eval : Tm → Env → ℕ
eval var       ρ = x ρ
eval yvar      ρ = y ρ
eval zvar      ρ = z ρ
eval uvar      ρ = u ρ
eval vvar      ρ = v ρ
eval wvar      ρ = w ρ
eval zero      ρ = 0
eval (suc t)   ρ = suc (eval t ρ)
eval (add l r) ρ = eval l ρ + eval r ρ

-- Every certificate step preserves that meaning.  Therefore the Haskell
-- gate cannot install a rule merely because it inhabits an uninterpreted
-- rewrite calculus: its exact checked endpoints are pointwise equal on ℕ.
step-sound : {a b : Tm} → Step a b → (ρ : Env) → eval a ρ ≡ eval b ρ
step-sound (add-zero t)    ρ = +-zero (eval t ρ)
step-sound (add-suc l r)   ρ = +-suc (eval l ρ) (eval r ρ)
step-sound (suc-step p)    ρ = cong suc (step-sound p ρ)
step-sound (add-left p t)  ρ = cong (_+ eval t ρ) (step-sound p ρ)
step-sound (add-right t p) ρ = cong (eval t ρ +_) (step-sound p ρ)
step-sound (reverse p)     ρ = sym (step-sound p ρ)

derivation-sound : {a b : Tm} → Derivation a b → (ρ : Env) → eval a ρ ≡ eval b ρ
derivation-sound (done t)        ρ = refl
derivation-sound (then-step p d) ρ = step-sound p ρ ∙ derivation-sound d ρ

setX : ℕ → Env → Env
setX n ρ = env n (y ρ) (z ρ) (u ρ) (v ρ) (w ρ)

eval-subVar : (t body : Tm) (ρ : Env) →
  eval (subVar t body) ρ ≡ eval body (setX (eval t ρ) ρ)
eval-subVar t var       ρ = refl
eval-subVar t yvar      ρ = refl
eval-subVar t zvar      ρ = refl
eval-subVar t uvar      ρ = refl
eval-subVar t vvar      ρ = refl
eval-subVar t wvar      ρ = refl
eval-subVar t zero      ρ = refl
eval-subVar t (suc b)   ρ = cong suc (eval-subVar t b ρ)
eval-subVar t (add l r) ρ = cong₂ _+_ (eval-subVar t l ρ) (eval-subVar t r ρ)

hyp-step-sound : {ihL ihR a b : Tm} → HypStep ihL ihR a b →
  (ρ : Env) → eval ihL ρ ≡ eval ihR ρ → eval a ρ ≡ eval b ρ
hyp-step-sound (lift-step p)          ρ ih = step-sound p ρ
hyp-step-sound hypothesis             ρ ih = ih
hyp-step-sound reverse-hypothesis     ρ ih = sym ih
hyp-step-sound (hyp-suc p)            ρ ih = cong suc (hyp-step-sound p ρ ih)
hyp-step-sound (hyp-add-left p t)     ρ ih =
  cong (_+ eval t ρ) (hyp-step-sound p ρ ih)
hyp-step-sound (hyp-add-right t p)    ρ ih =
  cong (eval t ρ +_) (hyp-step-sound p ρ ih)

hyp-derivation-sound : {ihL ihR a b : Tm} → HypDerivation ihL ihR a b →
  (ρ : Env) → eval ihL ρ ≡ eval ihR ρ → eval a ρ ≡ eval b ρ
hyp-derivation-sound (hyp-done t)     ρ ih = refl
hyp-derivation-sound (hyp-then p d)   ρ ih =
  hyp-step-sound p ρ ih ∙ hyp-derivation-sound d ρ ih

-- A checked base trace and checked successor trace, with the hypothesis
-- available only at the predecessor, entail the advertised equation for
-- every environment.  This is the semantic reason an accepted induction
-- certificate may become an executable rewrite rule.
induction-sound : {lhs rhs : Tm} → InductionCertificate lhs rhs →
  (ρ : Env) → eval lhs ρ ≡ eval rhs ρ
induction-sound {lhs} {rhs} cert (env n y₀ z₀ u₀ v₀ w₀) = go n
  where
  ρ : ℕ → Env
  ρ k = env k y₀ z₀ u₀ v₀ w₀

  go : (k : ℕ) → eval lhs (ρ k) ≡ eval rhs (ρ k)
  go zero =
    sym (eval-subVar zero lhs (ρ zero))
    ∙ derivation-sound (InductionCertificate.base cert) (ρ zero)
    ∙ eval-subVar zero rhs (ρ zero)
  go (suc k) =
    sym (eval-subVar (suc var) lhs (ρ k))
    ∙ hyp-derivation-sound (InductionCertificate.step cert) (ρ k) (go k)
    ∙ eval-subVar (suc var) rhs (ρ k)

accepted : Derivation (add var (suc zero)) (suc var)
accepted =
  then-step (add-suc var zero)
    (then-step (suc-step (add-zero var)) (done (suc var)))

accepted-sound : (ρ : Env) → eval (add var (suc zero)) ρ ≡ eval (suc var) ρ
accepted-sound = derivation-sound accepted
