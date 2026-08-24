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

------------------------------------------------------------------------
-- NaturalMachine.TransportMul
--
-- MULTIPLICATION SURVIVES THE TRANSPORT.  `NaturalMachine.Transport`
-- proves that ℕ's addition, transported along `ua ℕ≃CanWord`, IS
-- schoolbook ripple-carry addition on digit words.  That is the
-- repository's central exhibit for "place value is a chart".  It stops
-- at `+`, and until now nothing said whether the phenomenon was special
-- to addition.
--
-- It is not.  The same statement holds for `·`:
--
--     transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i → ℕ≡CanWord i) _·_ ≡ _⊗_
--
-- where `_⊗_` is defined natively on canonical digit words by
-- shift-and-add and never mentions ℕ.  So the chart carries the whole
-- semiring, not just the monoid.
--
-- WHY THIS WAS WORTH DOING, beyond symmetry.  The walk
-- (`NaturalMachine.WalkBridge`) executes in the kernel and stops at
-- frontier m ≈ 8, and the reason is derived rather than measured: a walk
-- step costs Θ(cap m · (next m − m)) because a UNARY divisibility test
-- on cap m costs Θ(cap m), and cap m = e^{ψ(m)}.  The walk's storage law
-- is its naive runtime law.  So the question "how far can the natural
-- machine run" is a question about the chart, and answering it needs the
-- arithmetic the walk actually uses — `·`, then division — carried
-- across.  This module is the first of those, and it establishes that
-- the route is `valueC-inj` plus a value law, exactly as for `⊕`: no new
-- idea is needed per operation.
--
-- DESIGN NOTE (why digit×digit multiplication does not appear).  A
-- schoolbook multiplier normally needs a digit-product-with-carry
-- primitive, which is where the work usually goes.  It is avoidable:
-- the base b is fixed, so scaling a word by a single digit d < b is d
-- repeated additions (`repAdd`), which reuses the already-certified
-- `addw` and costs a constant factor.  The whole multiplier is then
-- three lines and its value law is one application of the semiring
-- solver.  Canonicity of the MULTIPLIER is never needed — only of the
-- multiplicand — which is visible in `canonical-mulw`'s signature.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-14.
-- No postulates, no holes.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.TransportMul (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List
open import Cubical.Data.Unit
open import Cubical.Data.Sigma
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import NaturalMachine.Digits k
open import NaturalMachine.Transport k
  using (addw ; value-addw ; canonical-addw ; _⊕_ ; zeroC ; valueC-⊕ ; valueC-inj)

------------------------------------------------------------------------
-- 1.  Multiplication by the base: one shift of the digit string.
------------------------------------------------------------------------

shiftw : Word → Word
shiftw []      = []
shiftw (d ∷ w) = fzero ∷ d ∷ w

value-shiftw : (w : Word) → value (shiftw w) ≡ b · value w
value-shiftw []      = 0≡m·0 b
value-shiftw (d ∷ w) = refl

canonical-shiftw : (w : Word) → Canonical w → Canonical (shiftw w)
canonical-shiftw []      c = tt
canonical-shiftw (d ∷ w) c = c

------------------------------------------------------------------------
-- 2.  Scaling by a single digit, as repeated certified addition.
--     The base is fixed, so this is a constant number of ripples.
------------------------------------------------------------------------

repAdd : ℕ → Word → Word
repAdd zero    v = []
repAdd (suc n) v = addw false v (repAdd n v)

value-repAdd : (n : ℕ) (v : Word) → value (repAdd n v) ≡ n · value v
value-repAdd zero    v = refl
value-repAdd (suc n) v =
  value-addw false v (repAdd n v) ∙ cong (value v +_) (value-repAdd n v)

canonical-repAdd : (n : ℕ) (v : Word) → Canonical v → Canonical (repAdd n v)
canonical-repAdd zero    v cv = tt
canonical-repAdd (suc n) v cv =
  canonical-addw false v (repAdd n v) cv (canonical-repAdd n v cv)

------------------------------------------------------------------------
-- 3.  Schoolbook multiplication: shift and add.
------------------------------------------------------------------------

mulw : Word → Word → Word
mulw []      v = []
mulw (d ∷ u) v = addw false (repAdd (toℕ d) v) (shiftw (mulw u v))

-- Canonicity of the MULTIPLIER is not needed.
canonical-mulw : (u v : Word) → Canonical v → Canonical (mulw u v)
canonical-mulw []      v cv = tt
canonical-mulw (d ∷ u) v cv =
  canonical-addw false (repAdd (toℕ d) v) (shiftw (mulw u v))
    (canonical-repAdd (toℕ d) v cv)
    (canonical-shiftw (mulw u v) (canonical-mulw u v cv))

-- the one place-value identity, discharged by the semiring solver
mul-lem : (D V bb U : ℕ) → D · V + bb · (U · V) ≡ (D + bb · U) · V
mul-lem D V bb U = solveℕ!

-- THE ALGORITHM IS CORRECT.
value-mulw : (u v : Word) → value (mulw u v) ≡ value u · value v
value-mulw []      v = refl
value-mulw (d ∷ u) v =
    value-addw false (repAdd (toℕ d) v) (shiftw (mulw u v))
  ∙ cong₂ _+_ (value-repAdd (toℕ d) v)
              (value-shiftw (mulw u v) ∙ cong (b ·_) (value-mulw u v))
  ∙ mul-lem (toℕ d) (value v) b (value u)

------------------------------------------------------------------------
-- 4.  Multiplication on the canonical-word presentation.
------------------------------------------------------------------------

infixl 7 _⊗_

_⊗_ : CanWord → CanWord → CanWord
(u , cu) ⊗ (v , cv) = mulw u v , canonical-mulw u v cv

valueC-⊗ : (x y : CanWord) → valueC (x ⊗ y) ≡ valueC x · valueC y
valueC-⊗ (u , _) (v , _) = value-mulw u v

oneC : CanWord
oneC = (fone ∷ []) , suc-≤-suc zero-≤

valueC-oneC : valueC oneC ≡ 1
valueC-oneC = cong (1 +_) (sym (0≡m·0 b))

------------------------------------------------------------------------
-- 5.  The semiring laws, inherited from ℕ by transport of proof.
--     Every one is `valueC-inj` applied to the corresponding ℕ law:
--     the digit algorithms need no separate verification.
------------------------------------------------------------------------

⊗-assoc : (x y z : CanWord) → x ⊗ (y ⊗ z) ≡ (x ⊗ y) ⊗ z
⊗-assoc x y z = valueC-inj _ _
  ( valueC-⊗ x (y ⊗ z)
  ∙ cong (valueC x ·_) (valueC-⊗ y z)
  ∙ ·-assoc (valueC x) (valueC y) (valueC z)
  ∙ cong (_· valueC z) (sym (valueC-⊗ x y))
  ∙ sym (valueC-⊗ (x ⊗ y) z) )

⊗-comm : (x y : CanWord) → x ⊗ y ≡ y ⊗ x
⊗-comm x y = valueC-inj _ _
  (valueC-⊗ x y ∙ ·-comm (valueC x) (valueC y) ∙ sym (valueC-⊗ y x))

⊗-idr : (x : CanWord) → x ⊗ oneC ≡ x
⊗-idr x = valueC-inj _ _
  ( valueC-⊗ x oneC
  ∙ cong (valueC x ·_) valueC-oneC
  ∙ ·-identityʳ (valueC x) )

⊗-nulr : (x : CanWord) → x ⊗ zeroC ≡ zeroC
⊗-nulr x = valueC-inj _ _ (valueC-⊗ x zeroC ∙ sym (0≡m·0 (valueC x)))

-- distributivity: the ripple and the shift-and-add cohere
⊗-distr : (x y z : CanWord) → x ⊗ (y ⊕ z) ≡ (x ⊗ y) ⊕ (x ⊗ z)
⊗-distr x y z = valueC-inj _ _
  ( valueC-⊗ x (y ⊕ z)
  ∙ cong (valueC x ·_) (valueC-⊕ y z)
  ∙ sym (·-distribˡ (valueC x) (valueC y) (valueC z))
  ∙ cong₂ _+_ (sym (valueC-⊗ x y)) (sym (valueC-⊗ x z))
  ∙ sym (valueC-⊕ (x ⊗ y) (x ⊗ z)) )

-- Any future multiplication algorithm on canonical words is the present
-- multiplier as soon as every value test sees ordinary multiplication.
-- This is the usable uniqueness boundary for replacing `mulw`: correctness
-- of values promotes to equality of operations, so every proved law above
-- transports without a second algebraic verification.
value-law→multiplication-path :
  (μ : CanWord → CanWord → CanWord) →
  ((x y : CanWord) → valueC (μ x y) ≡ valueC x · valueC y) →
  μ ≡ _⊗_
value-law→multiplication-path μ h = funExt (λ x → funExt (λ y →
  valueC-inj (μ x y) (x ⊗ y) (h x y ∙ sym (valueC-⊗ x y))))

multiplication-path→value-law :
  (μ : CanWord → CanWord → CanWord) →
  μ ≡ _⊗_ →
  (x y : CanWord) → valueC (μ x y) ≡ valueC x · valueC y
multiplication-path→value-law μ p x y =
  cong (λ op → valueC (op x y)) p ∙ valueC-⊗ x y

------------------------------------------------------------------------
-- 6.  THE TRANSPORT STATEMENT for multiplication.
--     Same three lines as `Transport.transport-+-is-⊕`; the only input
--     is the value law.  That is the point: the chart carries the
--     semiring by one uniform mechanism, not by an argument per
--     operation.
------------------------------------------------------------------------

digitsC-· : (m n : ℕ) → digitsC (m · n) ≡ digitsC m ⊗ digitsC n
digitsC-· m n = valueC-inj _ _
  ( value-digits (m · n)
  ∙ cong₂ _·_ (sym (value-digits m)) (sym (value-digits n))
  ∙ sym (valueC-⊗ (digitsC m) (digitsC n)) )

transport-·-is-⊗ :
  transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i → ℕ≡CanWord i) _·_ ≡ _⊗_
transport-·-is-⊗ = funExt (λ x → funExt (λ y →
    transportUAop₂ ℕ≃CanWord _·_ x y
  ∙ digitsC-· (valueC x) (valueC y)
  ∙ cong₂ _⊗_ (retr x) (retr y)))
  where
  retr : (x : CanWord) → digitsC (valueC x) ≡ x
  retr (w , c) = Σ≡Prop isPropCanonical (digits-value w c)
