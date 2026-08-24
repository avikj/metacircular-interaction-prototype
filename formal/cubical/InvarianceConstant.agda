-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- InvarianceConstant
--
-- The invariance theorem of Kolmogorov complexity, and the comparison
-- rule it forces, as checked terms.
--
-- WHY THIS MODULE EXISTS.  `notes/MYSTERY_AND_DESCRIPTION_LENGTH.md`
-- adjudicates an MDL layer by repeatedly applying one fact: a complexity
-- function is defined only up to an additive constant depending on the
-- machine, so no *absolute* description length and no *narrow*
-- comparison of description lengths carries content.  The note states
-- the fact (Li–Vitányi Thm 2.1.1) and its "Uniformity Lemma" in prose
-- and uses them as a tool.  This module makes the tool a term, so that
-- any future claim of the form "this description is shorter" is checked
-- against a hypothesis rather than asserted.
--
-- WHAT IS AND IS NOT FORMALISED.  In `--safe` cubical Agda one cannot
-- build a universal machine, and no attempt is made.  What is
-- formalised is the *abstract* content of the invariance theorem, which
-- is the whole of its mathematical content once universality has done
-- its only job:
--
--     given two cost functions each of which simulates the other with
--     bounded overhead, their difference is bounded, uniformly in the
--     argument.
--
-- Universality enters exactly once in the classical proof — to produce
-- the two simulation constants — and nowhere else.  Everything after
-- that point is the arithmetic below.  So the honest division of labour
-- is: universality is the unformalised hypothesis, named as
-- `Simulates`; the theorem is the part below.
--
-- CONTENTS.
--   §1  `Within c f g`  — the two-sided bound, subtraction-free.
--   §2  `invariance`    — mutual simulation ⇒ bounded difference, with
--                         the constant `max c₁ c₂` exhibited.  Plus the
--                         groupoid structure: `Within` is reflexive at
--                         0, symmetric, transitive with the constants
--                         ADDING, and upward closed.  This is the
--                         precise sense in which a complexity function
--                         is not a function but a class.
--   §3  `within-+`      — k non-cancelling terms carry slack k·c
--                         (the note's Uniformity Lemma, additive half),
--                         and `ΔMystery-indep`, the cancellation half:
--                         a difference at fixed object does not mention
--                         the unconditional term at all.
--   §4  `absolute-not-invariant` — for any f and any c ≥ 1 there is a
--                         g within c of f with g x ≠ f x at every x.
--                         "The description length of x is n" is not a
--                         statement about x.
--   §5  `shorter-needs-margin` — THE COMPARISON RULE.  A strict
--                         comparison transfers across machines whenever
--                         the gap EXCEEDS 2c, and the threshold cannot
--                         be lowered.  `weak-margin` is the ≤ version.
--                         §5.1's `Sharp2c` and `SharpBelow2c`, bundled
--                         as `threshold-sharp`: at gap exactly 2c the
--                         strict conclusion already fails (the costs
--                         tie), and at gap 2c−1 the order REVERSES.
--                         Both witnesses are finite exhaustive
--                         verifications over Bool, which `CLAUDE.md`
--                         admits as proof.
--
-- The exact threshold is 2c, not c: the slack is spent twice, once
-- raising f x to g x and once lowering f y to g y.  The note says "sign
-- when the gap ≫ c" (§1, table row 1); §5 replaces ≫ by the constant
-- that actually works and proves it cannot be lowered.  That is this
-- module's one correction to the note, recorded in its §8.
--
-- Nothing here is new mathematics; see the note's §6 for prior art.
-- The contribution is that it is checked.
--
-- seed-kolmogorov, 2026-08-15.
------------------------------------------------------------------------

module InvarianceConstant where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Empty as ⊥
open import Cubical.Relation.Nullary

private
  variable
    ℓ : Level
    X : Type ℓ

------------------------------------------------------------------------
-- §1  Cost functions, simulation, and the two-sided bound
------------------------------------------------------------------------

-- A "complexity function" is nothing but an ℕ-valued cost on objects.
-- No computability, no universality, no machine: those are what the
-- hypothesis `Simulates` abstracts away.
Cost : Type ℓ → Type ℓ
Cost X = X → ℕ

-- `Simulates c f g`: the f-machine can run any g-description with
-- overhead at most c.  This is the ONE place universality is used in
-- the classical theorem, and here it is a hypothesis.
Simulates : ℕ → Cost X → Cost X → Type _
Simulates {X = X} c f g = (x : X) → f x ≤ g x + c

-- `Within c f g`: |f x − g x| ≤ c for every x, written without
-- subtraction so that no truncation lemma is needed.  Note the
-- quantifier order: the constant is chosen BEFORE the object.  That
-- uniformity is the content of the invariance theorem, and losing it
-- (∀ x ∃ c) would make the statement vacuous.
Within : ℕ → Cost X → Cost X → Type _
Within {X = X} c f g = (x : X) → (f x ≤ g x + c) × (g x ≤ f x + c)

------------------------------------------------------------------------
-- §2  The invariance theorem, abstractly
------------------------------------------------------------------------

-- THE THEOREM.  Mutual simulation with bounded overhead ⇒ bounded
-- difference.  The constant is exhibited, not merely asserted to exist.
invariance : {f g : Cost X} {c₁ c₂ : ℕ}
           → Simulates c₁ f g → Simulates c₂ g f
           → Within (max c₁ c₂) f g
invariance {f = f} {g} {c₁} {c₂} s₁ s₂ x =
    ≤-trans (s₁ x) (≤-k+ {k = g x} (left-≤-max {c₁} {c₂}))
  , ≤-trans (s₂ x) (≤-k+ {k = f x} (right-≤-max {c₂} {c₁}))

-- The existential form usually quoted: "there is a constant c".
invariance∃ : {f g : Cost X} {c₁ c₂ : ℕ}
            → Simulates c₁ f g → Simulates c₂ g f
            → Σ[ c ∈ ℕ ] Within c f g
invariance∃ {c₁ = c₁} {c₂ = c₂} s₁ s₂ = max c₁ c₂ , invariance s₁ s₂

-- `Within` is an equivalence relation once the constants are allowed to
-- move — and they move ADDITIVELY under composition.  This is the exact
-- reason a complexity function is a class rather than a function, and
-- the reason a chain of "up to a constant" steps has a constant that
-- grows with the chain.
within-refl : {f : Cost X} → Within 0 f f
within-refl {f = f} x = subst (f x ≤_) (sym (+-zero (f x))) ≤-refl
                      , subst (f x ≤_) (sym (+-zero (f x))) ≤-refl

within-sym : {f g : Cost X} {c : ℕ} → Within c f g → Within c g f
within-sym w x = snd (w x) , fst (w x)

within-trans : {f g h : Cost X} {c d : ℕ}
             → Within c f g → Within d g h → Within (c + d) f h
within-trans {f = f} {g} {h} {c} {d} w v x =
    subst (f x ≤_) lemma₁
      (≤-trans (fst (w x)) (≤-+k {k = c} (fst (v x))))
  , subst (h x ≤_) lemma₂
      (≤-trans (snd (v x)) (≤-+k {k = d} (snd (w x))))
  where
    lemma₁ : (h x + d) + c ≡ h x + (c + d)
    lemma₁ = sym (+-assoc (h x) d c) ∙ cong (h x +_) (+-comm d c)

    lemma₂ : (f x + c) + d ≡ f x + (c + d)
    lemma₂ = sym (+-assoc (f x) c d)

-- Upward closure: a valid constant stays valid when enlarged.  There is
-- therefore no "the" invariance constant, only a nonempty upward-closed
-- set of them; quoting one without the pair of machines it came from is
-- exactly the defect this corpus keeps catching.
within-mono : {f g : Cost X} {c d : ℕ} → c ≤ d → Within c f g → Within d f g
within-mono {f = f} {g} p w x =
    ≤-trans (fst (w x)) (≤-k+ p)
  , ≤-trans (snd (w x)) (≤-k+ p)

------------------------------------------------------------------------
-- §3  The Uniformity Lemma: terms add, cancellation is exact
------------------------------------------------------------------------

-- Additive half.  An expression with two non-cancelling cost terms
-- carries twice the slack; iterating, k terms carry k·c.  This is the
-- arithmetic behind the note's table (2c for Mystery, 3c for gain and
-- for the argmin objective).
within-+ : {f g f' g' : Cost X} {c d : ℕ}
         → Within c f g → Within d f' g'
         → Within (c + d) (λ x → f x + f' x) (λ x → g x + g' x)
within-+ {f = f} {g} {f'} {g'} {c} {d} w v x =
    subst ((f x + f' x) ≤_) (shuffle (g x) (g' x))
      (≤-+-≤ (fst (w x)) (fst (v x)))
  , subst ((g x + g' x) ≤_) (shuffle (f x) (f' x))
      (≤-+-≤ (snd (w x)) (snd (v x)))
  where
    shuffle : (a b : ℕ) → (a + c) + (b + d) ≡ (a + b) + (c + d)
    shuffle a b =
      sym (+-assoc a c (b + d))
      ∙ cong (a +_) (+-assoc c b d ∙ cong (_+ d) (+-comm c b)
                     ∙ sym (+-assoc b c d))
      ∙ +-assoc a b (c + d)

-- Cancellation half, stated so that it cannot be fudged.  The note's
-- (I1) turns on the observation that in
--
--     ΔMystery = [L(X) − L(X|𝔏')] − [L(X) − L(X|𝔏)] = L(X|𝔏) − L(X|𝔏')
--
-- the unconditional term is GONE — not small, gone.  Formalised as: the
-- comparison of two conditional costs at a fixed object does not mention
-- the unconditional cost at all, so it is literally independent of it.
-- The proof is `refl`, and that is the point: cancellation is a fact
-- about the syntax of the expression, which is why it costs 0 rather
-- than c.
module Cancellation {Obj Lang : Type ℓ}
  (cond : Obj → Lang → ℕ)     -- L(x | 𝔏)
  where

  -- "𝔏' explains x strictly better than 𝔏 does", the ΔMystery > 0 test.
  ΔMystery>0 : (uncond : Cost Obj) → Obj → Lang → Lang → Type
  ΔMystery>0 _ x l l' = cond x l' < cond x l

  ΔMystery-indep : (u u' : Cost Obj) (x : Obj) (l l' : Lang)
                 → ΔMystery>0 u x l l' ≡ ΔMystery>0 u' x l l'
  ΔMystery-indep _ _ _ _ _ = refl

  -- And its invariance: the surviving two-term expression is governed by
  -- §5 with the SAME constant as any two-term comparison — no third
  -- term, hence no third c.  (Instantiate `shorter-needs-margin` at the
  -- conditional cost with the language argument fixed.)

------------------------------------------------------------------------
-- §4  No absolute description length is invariant
------------------------------------------------------------------------

-- For any cost f and any c, the shift f + c is within c of f.  So every
-- machine has a legitimate rival that disagrees with it by exactly c
-- everywhere.
shift-Within : (f : Cost X) (c : ℕ) → Within c f (λ x → f x + c)
shift-Within f c x =
    subst (f x ≤_) (+-assoc (f x) c c) (≤SumLeft {n = f x} {k = c + c})
  , ≤-refl

n≢n+suc : (n k : ℕ) → ¬ (n ≡ n + suc k)
n≢n+suc n k p = ¬m<m {n} (subst (n <_) (sym p) n<n+suc)
  where
    n<n+suc : n < n + suc k
    n<n+suc = k , +-suc k n ∙ cong suc (+-comm k n) ∙ sym (+-suc n k)

-- THE CONSEQUENCE.  "The description length of x is n" is not a
-- statement about x: there is always a rival cost function, within the
-- invariance constant, which disagrees at every single object.
absolute-not-invariant :
    (f : Cost X) (k : ℕ)
  → Σ[ g ∈ Cost X ] (Within (suc k) f g × ((x : X) → ¬ (f x ≡ g x)))
absolute-not-invariant f k =
    (λ x → f x + suc k)
  , shift-Within f (suc k)
  , λ x → n≢n+suc (f x) k

------------------------------------------------------------------------
-- §5  The comparison rule: a gap is knowledge only above 2c
------------------------------------------------------------------------

-- THE RULE.  If f and g agree up to c, then a strict f-comparison with
-- margin greater than 2c is a strict g-comparison.  Contrapositively: a
-- claim "this description is shorter" with an unstated or insufficient
-- margin is not a claim about the objects.
--
-- This is the exact analogue, for description length, of the corpus rule
-- that a fitted constant without its error term is not knowledge.  Here
-- the "error term" is 2c and it is derivable, not measured.
shorter-needs-margin : {f g : Cost X} {c : ℕ} {x y : X}
                     → Within c f g
                     → f x + (c + c) < f y
                     → g x < g y
shorter-needs-margin {f = f} {g} {c} {x} {y} w hyp =
  ≤-+k-cancel {k = c} step
  where
    a : g x + c ≤ f x + (c + c)
    a = subst (g x + c ≤_) (sym (+-assoc (f x) c c)) (≤-+k {k = c} (snd (w x)))

    b : f x + (c + c) < g y + c
    b = <≤-trans hyp (fst (w y))

    step : suc (g x) + c ≤ g y + c
    step = ≤<-trans a b

-- Non-strict version at exactly 2c.
weak-margin : {f g : Cost X} {c : ℕ} {x y : X}
            → Within c f g
            → f x + (c + c) ≤ f y
            → g x ≤ g y
weak-margin {f = f} {g} {c} {x} {y} w hyp =
  ≤-+k-cancel {k = c}
    (≤-trans (subst (g x + c ≤_) (sym (+-assoc (f x) c c))
                    (≤-+k {k = c} (snd (w x))))
             (≤-trans hyp (fst (w y))))

------------------------------------------------------------------------
-- §5.1  Sharpness.  Both witnesses are finite exhaustive checks.
------------------------------------------------------------------------

-- Take c = 1, X = Bool.  Margin 2c = 2: the strict conclusion fails
-- (the two costs tie), so `shorter-needs-margin` cannot be weakened to
-- `≤` in its hypothesis while keeping `<` in its conclusion.
module Sharp2c where
  f g : Bool → ℕ
  f false = 0
  f true  = 2
  g false = 1
  g true  = 1

  w : Within 1 f g
  w false = (2 , refl) , (0 , refl)
  w true  = (0 , refl) , (2 , refl)

  margin : f false + (1 + 1) ≤ f true
  margin = 0 , refl

  tie : g false ≡ g true
  tie = refl

  no-strict : ¬ (g false < g true)
  no-strict p = ¬m<m {1} p

-- Margin 2c − 1 = 1: the order REVERSES.  So 2c is not merely
-- sufficient; anything below it is refuted by a two-element example.
module SharpBelow2c where
  f g : Bool → ℕ
  f false = 0
  f true  = 1
  g false = 1
  g true  = 0

  w : Within 1 f g
  w false = (2 , refl) , (0 , refl)
  w true  = (0 , refl) , (2 , refl)

  margin : f false + 1 ≤ f true
  margin = 0 , refl

  f-says-shorter : f false < f true
  f-says-shorter = 0 , refl

  g-says-longer : g true < g false
  g-says-longer = 0 , refl

-- Summary, as a single term: the threshold 2c is attained and is not
-- improvable.  `Sharp2c` shows margin = 2c gives no strict conclusion;
-- `SharpBelow2c` shows margin = 2c − 1 gives the OPPOSITE conclusion.
-- Together with `shorter-needs-margin`, the trichotomy is complete.
threshold-sharp :
    (¬ (Sharp2c.g false < Sharp2c.g true))
  × (SharpBelow2c.g true < SharpBelow2c.g false)
threshold-sharp = Sharp2c.no-strict , SharpBelow2c.g-says-longer
