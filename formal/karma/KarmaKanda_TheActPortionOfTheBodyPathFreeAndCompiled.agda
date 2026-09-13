{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कर्मकाण्डम् — the act-portion.  The division is the tradition's own:
-- the Veda's karmakāṇḍa (acts) against its jñānakāṇḍa (knowledge),
-- the split Pūrva- and Uttara-Mīmāṃsā stand on.  Here it is the
-- compilation boundary measured on this habitat (Agda 2.8.0): proofs
-- may cross into erased-cubical only erased, values not at all — so
-- the ACTS (the machine's vocabulary, its evaluator, its normalizer,
-- its boolean tests: everything path-free) live on this side and
-- compile, while the knowledge-portion (the witnesses, the paths)
-- lives in the --cubical body and rides across as @0 certificates.
-- The definitions are EkaBhasha's, verbatim; the boolean equality is
-- the act-side mirror of ≟T, whose reflection theorem is the
-- jñānakāṇḍa's to prove.
------------------------------------------------------------------------

module KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_ ; _*_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)

_×_ : Type → Type → Type
A × B = Σ A (λ _ → B)

data Tm : Type where
  var        : Nat → Tm
  ze         : Tm
  su         : Tm → Tm
  _⊕_ _⊗_ _⊖_ : Tm → Tm → Tm
  mx lq gc   : Tm → Tm → Tm

Eq' : Type
Eq' = Tm × Tm

mxℕ : Nat → Nat → Nat
mxℕ x       zero    = x
mxℕ zero    y       = y
mxℕ (suc x) (suc y) = suc (mxℕ x y)

lqℕ : Nat → Nat → Nat
lqℕ zero    _       = suc zero
lqℕ (suc _) zero    = zero
lqℕ (suc x) (suc y) = lqℕ x y

sbℕ : Nat → Nat → Nat
sbℕ x       zero    = x
sbℕ zero    (suc _) = zero
sbℕ (suc x) (suc y) = sbℕ x y

-- the kuṭṭaka's own operator, admitted 2026-08-24 so the elder's gcd
-- lines can cross: subtraction-Euclid ("keep the remainder and recurse"
-- — Āryabhaṭa, Āryabhaṭīya, kuṭṭaka, 499 CE; the descent, not this
-- code, is what is claimed of the source), made structural by an exact
-- fuel: each step strictly shrinks the pair's sum, so fuel a+b always
-- suffices and the answer is standard gcd.
गच्छ : Nat → Nat → Nat → Nat
गच्छ zero    a       b       = a
गच्छ (suc f) zero    b       = b
गच्छ (suc f) (suc a) zero    = suc a
गच्छ (suc f) (suc a) (suc b) = शाखा (lqℕ a b)
  where
  शाखा : Nat → Nat
  शाखा zero    = गच्छ f (sbℕ a b) (suc b)      -- b < a: recurse on a−b, b+1...
  शाखा (suc _) = गच्छ f (suc a) (sbℕ b a)      -- a ≤ b: recurse on a+1, b−a

गच्छℕ : Nat → Nat → Nat
गच्छℕ a b = गच्छ (a + b) a b

eval : Tm → (Nat → Nat) → Nat
eval (var i) ρ = ρ i
eval ze      ρ = zero
eval (su t)  ρ = suc (eval t ρ)
eval (a ⊕ b) ρ = eval a ρ + eval b ρ
eval (a ⊗ b) ρ = eval a ρ * eval b ρ
eval (a ⊖ b) ρ = sbℕ (eval a ρ) (eval b ρ)
eval (mx a b) ρ = mxℕ (eval a ρ) (eval b ρ)
eval (lq a b) ρ = lqℕ (eval a ρ) (eval b ρ)
eval (gc a b) ρ = गच्छℕ (eval a ρ) (eval b ρ)

plus' : Tm → Tm → Tm
plus' a ze     = a
plus' a (su b) = su (plus' a b)
plus' a b      = a ⊕ b

times' : Tm → Tm → Tm
times' a ze     = ze
times' a (su b) = plus' (times' a b) a
times' a b      = a ⊗ b

sub' : Tm → Tm → Tm
sub' a      ze     = a
sub' ze     (su _) = ze
sub' (su a) (su b) = sub' a b
sub' a      b      = a ⊖ b

mx' : Tm → Tm → Tm
mx' a      ze     = a
mx' ze     b      = b
mx' (su a) (su b) = su (mx' a b)
mx' a      b      = mx a b

lq' : Tm → Tm → Tm
lq' ze     _      = su ze
lq' (su _) ze     = ze
lq' (su a) (su b) = lq' a b
lq' a      b      = lq a b

gc' : Tm → Tm → Tm
gc' a  ze = a
gc' ze b  = b
gc' a  b  = gc a b

norm : Tm → Tm
norm (var i)  = var i
norm ze       = ze
norm (su t)   = su (norm t)
norm (a ⊕ b)  = plus'  (norm a) (norm b)
norm (a ⊗ b)  = times' (norm a) (norm b)
norm (a ⊖ b)  = sub'   (norm a) (norm b)
norm (mx a b) = mx'    (norm a) (norm b)
norm (lq a b) = lq'    (norm a) (norm b)
norm (gc a b) = gc'    (norm a) (norm b)

_∧_ : Bool → Bool → Bool
true  ∧ b = b
false ∧ _ = false

समℕ : Nat → Nat → Bool
समℕ zero    zero    = true
समℕ zero    (suc _) = false
समℕ (suc _) zero    = false
समℕ (suc a) (suc b) = समℕ a b

-- the act-side mirror of ≟T: decides, hands no path; the reflection
-- theorem connecting it to the knowledge-portion is the body's.
समः : Tm → Tm → Bool
समः (var i)  (var j)  = समℕ i j
समः ze       ze       = true
समः (su a)   (su b)   = समः a b
समः (a ⊕ b)  (c ⊕ d)  = समः a c ∧ समः b d
समः (a ⊗ b)  (c ⊗ d)  = समः a c ∧ समः b d
समः (a ⊖ b)  (c ⊖ d)  = समः a c ∧ समः b d
समः (mx a b) (mx c d) = समः a c ∧ समः b d
समः (lq a b) (lq c d) = समः a c ∧ समः b d
समः (gc a b) (gc c d) = समः a c ∧ समः b d
समः _        _        = false
