{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LawvereDiagonal
--
-- The diagonal engine of the Eternal Golden Braid
-- (notes/ETERNAL_GOLDEN_BRAID_DELTA24.md §9–§10, work item §19.D).
--
-- Lawvere's fixed-point theorem, constructively and in full: if
-- e : A → (A → Y) weakly enumerates the Y-valued behaviours on A, then
-- every ν : Y → Y has a fixed point.  Contrapositively, a fixed-point-
-- free ν refutes every claimed enumeration — and does so PRODUCTIVELY:
-- the diagonal behaviour d(a) = ν(e a a) is exhibited together with,
-- for each claimed index a, the exact point at which e a disagrees
-- with d.  The boundary is not mere impossibility; it constructs the
-- object the next stage must adjoin.
--
-- Weak point-surjectivity is taken untruncated (a Σ, not a ∥ Σ ∥):
-- the refutations below are then the strongest form, refuting even the
-- claim of a CHOSEN enumeration index, and no truncation machinery is
-- needed.  Since the conclusion of the fixed-point theorem is itself
-- exhibited by a term, the truncated variant follows by the usual
-- one-line recursion and is not duplicated here.
--
-- Instantiation: Y = Bool, ν = not is fixed-point-free, giving Cantor's
-- theorem — no type weakly enumerates its own Bool-observations.  This
-- is the term AchromaticToy imports to drive its reflection step.
------------------------------------------------------------------------

module Primes.PairField.LawvereDiagonal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool
open import Cubical.Relation.Nullary

private
  variable
    ℓ ℓa ℓy : Level

module _ {A : Type ℓa} {Y : Type ℓy} where

  -- e claims to enumerate, by A-indices, all Y-valued behaviours on A:
  -- every behaviour f is realized pointwise by some row e a.
  WkPtSurj : (A → A → Y) → Type (ℓ-max ℓa ℓy)
  WkPtSurj e = (f : A → Y) → Σ[ a ∈ A ] ((x : A) → e a x ≡ f x)

  FixedPoint : (Y → Y) → Type ℓy
  FixedPoint ν = Σ[ y ∈ Y ] ν y ≡ y

  -- the diagonal behaviour twisted by ν
  diag : (A → A → Y) → (Y → Y) → A → Y
  diag e ν a = ν (e a a)

  -- Lawvere's fixed-point theorem: the index a₀ claimed for the
  -- diagonal behaviour forces e a₀ a₀ to be a fixed point of ν.
  lawvere : (e : A → A → Y) → WkPtSurj e → (ν : Y → Y) → FixedPoint ν
  lawvere e surj ν = e a₀ a₀ , sym (h a₀)
    where
    a₀ : A
    a₀ = surj (diag e ν) .fst
    h : (x : A) → e a₀ x ≡ ν (e x x)
    h = surj (diag e ν) .snd

  -- Contrapositive: a fixed-point-free ν refutes enumeration.
  noFix→noEnum : (e : A → A → Y) (ν : Y → Y)
    → ((y : Y) → ¬ ν y ≡ y)
    → ¬ WkPtSurj e
  noFix→noEnum e ν noFix surj =
    noFix (lawvere e surj ν .fst) (lawvere e surj ν .snd)

  -- Productive form (§9: boundary as production rule): for ANY claimed
  -- index a of the diagonal behaviour, the exact disagreement point is
  -- a itself.  diag e ν is thereby a behaviour the stage provably does
  -- not represent — the new generator for the next stage.
  diagEscapes : (e : A → A → Y) (ν : Y → Y)
    → ((y : Y) → ¬ ν y ≡ y)
    → (a : A) → ¬ ((x : A) → e a x ≡ diag e ν x)
  diagEscapes e ν noFix a h = noFix (e a a) (sym (h a))

-- Bool negation is fixed-point-free: the canonical ν for stages whose
-- observation object is Bool.
notNoFix : (b : Bool) → ¬ not b ≡ b
notNoFix false p = true≢false p
notNoFix true  p = true≢false (sym p)

-- Cantor's theorem, as the Bool instantiation of the engine.
cantor : {A : Type ℓ} (e : A → A → Bool) → ¬ WkPtSurj e
cantor e = noFix→noEnum e not notNoFix

-- The escaping observation itself, packaged with its escape witness:
-- given any claimed enumeration e of Bool-observations on A, this is
-- the observation that provably lies outside every row of e.
cantorDefect : {A : Type ℓ} (e : A → A → Bool)
  → Σ[ d ∈ (A → Bool) ] ((a : A) → ¬ ((x : A) → e a x ≡ d x))
cantorDefect e = diag e not , λ a → diagEscapes e not notNoFix a
