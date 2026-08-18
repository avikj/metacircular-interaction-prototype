{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Laghava
--
-- लाघव — brevity, the grammarian's governing criterion — as a measure on
-- presentations, and the theorem `notes/LAGHAVA_COST_IS_NOT_A_UNIVALENT_
-- INVARIANT.md` states in prose and proves nowhere.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CLAIM, AND WHY THE PROSE VERSION WAS TOO WEAK
--
-- That note says lāghava "is not a univalent invariant — it lives on the
-- presentation, which univalence discards."  True, and understated.  What
-- is proved below is sharper and needs no univalence at all:
--
--     laghava-is-not-semantic :
--       ¬ Σ[ f ∈ (Denotation → ℕ) ] ((e : Expr) → f (eval e) ≡ size e)
--
-- There is **no function of the denotation whatsoever** that computes the
-- size of a presentation.  Not "univalence cannot see it": nothing that
-- takes only the meaning can see it, because two presentations with the
-- SAME meaning — not merely equivalent, identical — have different sizes.
--
-- The univalence statement is then a corollary and a weak one: a univalent
-- invariant is in particular a function of the structure, and there is no
-- such function.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS PĀṆINI'S SITUATION EXACTLY
--
-- `Apavada.agda` separates two things that wear the same shape:
--
--   * अपवाद proper  — the rules DISAGREE; the generated language changes;
--   * REFORMULATION — the rules AGREE everywhere; only लाघव changes.
--
-- A reformulation is, by that module's own definition, a pair with equal
-- denotation.  So reformulations are exactly the moves invisible to every
-- semantic invariant — and lāghava is exactly the quantity that sees
-- them.  The grammarian's whole craft lives in the kernel of `eval`, and
-- `laghava-is-not-semantic` says that kernel is not empty.
--
-- `WalkFast` is a reformulation in this sense (`next-characterised`
-- proves the two descriptions agree everywhere), which is why nothing
-- semantic could ever have registered its improvement.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  That this expression language is the right
-- syntax for the walk, or for the Aṣṭādhyāyī, or that node-count is the
-- right measure — Pāṇini's own lāghava counts morae and rule-slots, not
-- nodes.  The theorem is about the SHAPE of the situation: any measure
-- that distinguishes two same-meaning presentations is non-semantic by
-- that fact alone, and one such measure is exhibited.  Sharpening the
-- measure does not weaken the theorem.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Laghava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; znots ; injSuc)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Presentations, their size, and their meaning
------------------------------------------------------------------------

data Expr : Type where
  var   : Expr
  lit   : ℕ → Expr
  plus  : Expr → Expr → Expr
  times : Expr → Expr → Expr

-- लाघव: a measure on the PRESENTATION
size : Expr → ℕ
size var         = 1
size (lit _)     = 1
size (plus  a b) = suc (size a + size b)
size (times a b) = suc (size a + size b)

Denotation : Type
Denotation = ℕ → ℕ

-- meaning: a presentation denotes a function
eval : Expr → Denotation
eval var         n = n
eval (lit k)     _ = k
eval (plus  a b) n = eval a n + eval b n
eval (times a b) n = eval a n · eval b n

------------------------------------------------------------------------
-- 2.  Two presentations, one meaning, different sizes
------------------------------------------------------------------------

short : Expr
short = plus var var

long : Expr
long = plus var (plus var (lit 0))

short-size : size short ≡ 3
short-size = refl

long-size : size long ≡ 5
long-size = refl

-- the meanings are EQUAL, not merely equivalent
same-meaning : eval short ≡ eval long
same-meaning i n = (n + (+-zero n (~ i)))

------------------------------------------------------------------------
-- 3.  THE THEOREM.  No function of the meaning computes the size.
------------------------------------------------------------------------

private
  3≢5 : ¬ (3 ≡ 5)
  3≢5 p = znots (injSuc (injSuc (injSuc p)))

laghava-is-not-semantic :
  ¬ (Σ[ f ∈ (Denotation → ℕ) ] ((e : Expr) → f (eval e) ≡ size e))
laghava-is-not-semantic (f , h) =
  3≢5 ( sym (h short ∙ short-size)
      ∙ cong f same-meaning
      ∙ (h long ∙ long-size) )

------------------------------------------------------------------------
-- 4.  The univalence corollary, which is the weaker statement
--
-- A univalent invariant of a structure is in particular a function of
-- that structure.  Here the structure IS the denotation, so any such
-- invariant factors through `eval` — and §3 says lāghava does not.
------------------------------------------------------------------------

FactorsThroughMeaning : (Expr → ℕ) → Type
FactorsThroughMeaning m =
  Σ[ f ∈ (Denotation → ℕ) ] ((e : Expr) → f (eval e) ≡ m e)

laghava-does-not-factor : ¬ (FactorsThroughMeaning size)
laghava-does-not-factor = laghava-is-not-semantic

-- and for contrast, something that DOES factor: the meaning itself,
-- evaluated anywhere.  So the non-factoring is a property of the measure,
-- not an artefact of the setup.
value-at-one : Expr → ℕ
value-at-one e = eval e 1

value-at-one-factors : FactorsThroughMeaning value-at-one
value-at-one-factors = (λ g → g 1) , (λ _ → refl)

------------------------------------------------------------------------
-- 5.  The sentence.
--
-- Reformulations — Pāṇini's, and `WalkFast`'s — are exactly the moves in
-- the kernel of `eval`.  Every semantic invariant, univalent ones
-- included, is blind to that kernel by construction.  लाघव is a measure
-- on the fibre, and `laghava-is-not-semantic` proves the fibre is not a
-- point.
--
-- That is why the grammarians needed a criterion beyond correctness, and
-- why a corpus that only checks denotations cannot tell a better
-- presentation from a worse one.
------------------------------------------------------------------------
