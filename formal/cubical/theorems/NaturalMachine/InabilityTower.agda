{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.InabilityTower
--
-- `असमर्थता →^Γ विस्तृतलोकः` -- inability, under Γ, is an extended world.
--
-- The received corpus states the number tower as the canonical instance of
-- the machine's own loop:
--
--     3-5 ∉ ℵ      ⇝  -2 ∈ ζ
--     1÷2 ∉ ζ      ⇝  ½ ∈ ϑ
--     ξ²=2         ⇝  √2 ∈ ϱ
--     ξ²=-1        ⇝  ι ∈ χ
--
-- Each rung is `∂ → δ → Γ`: pose an equation, find no solution, adjoin one.
-- This module proves the first rung outright and states the pattern it
-- instantiates, so that the tower is a theorem of the machine rather than an
-- illustration beside it.
--
-- It also encodes two things the corpus asks for by name:
--
--   * **अपोह** -- `⟦गो⟧ = ¬⟦अगो⟧`, meaning as exclusion, with its closure
--     `α ↦ α^⊥⊥`.  This is the two-sided evaluation `ε : χ⁺ × χ⁻ → ϑ` of
--     `॥७॥` and the Galois connection it generates.  Proved general, for any
--     evaluation whatsoever.
--
--   * **अनेकान्तवाद** -- `ν ⊩ φ`, `ν' ⊩ ¬φ`, `⇏ ⊥`.  Standpoint-relative
--     assertion without contradiction.  This is *already* the theorem of
--     `NaturalMachine.ObstructionCalculus`: the two standpoints are two
--     observation fields, and the pair they disagree about is `6 , -6`.  The
--     corollary is one line and it is recorded here because naming the
--     identification is the point.
------------------------------------------------------------------------

module NaturalMachine.InabilityTower where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; injSuc ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; posNotnegsuc)
  renaming (_+_ to _+ℤ_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.ObstructionCalculus
  using (Obs ; Sep ; Blind ; absField ; signField ; sign-blind ; sign-seen)

private
  variable
    A B : Type₀

------------------------------------------------------------------------
-- A.  Inability, and the extension it forces.

-- `∂`: a question posed inside a structure.  `δ`: it has no answer there.
Unsolvable : (A : Type₀) (P : A → Type₀) → Type₀
Unsolvable A P = ¬ (Σ A P)

-- `Γ`: a larger structure, an embedding, and an answer.
record Adjoins (A B : Type₀) (ι : A → B) (P : A → Type₀) (Q : B → Type₀)
       : Type₀ where
  constructor adjoins
  field
    unsolvable : Unsolvable A P
    solution : Σ B Q
    fresh : ¬ (Σ[ a ∈ A ] ι a ≡ solution .fst)

-- The content of `Γ` is the third field: the witness that answers the question
-- is *not* in the old world.  Without it, `Adjoins` would be satisfied by any
-- structure that merely restates the question, and `विस्तृतलोकः` would be
-- decoration.  With it, the extension is forced to be strict.

------------------------------------------------------------------------
-- B.  The first rung, proved.  `3-5 ∉ ℵ ⇝ -2 ∈ ζ`.

-- The question: what must be added to 5 to give 3?
SubDefect : ℕ → Type₀
SubDefect n = 5 + n ≡ 3

-- `δ ≠ 0`: nothing in ℕ answers it.  Three peels of `suc`, then `znots`.
sub-unsolvable : Unsolvable ℕ SubDefect
sub-unsolvable (n , p) = snotz (injSuc (injSuc (injSuc p)))

-- The same question in ℤ.
SubSolved : ℤ → Type₀
SubSolved z = pos 5 +ℤ z ≡ pos 3

-- `Γ⟨δ⟩`: the answer is `-2`, and it is new -- no natural number maps to it.
sub-solution : Σ ℤ SubSolved
sub-solution = negsuc 1 , refl

sub-fresh : ¬ (Σ[ n ∈ ℕ ] pos n ≡ negsuc 1)
sub-fresh (n , p) = posNotnegsuc n 1 p

-- The rung, assembled.  This is `∂ → δ → Γ` on the oldest example there is.
ℕ⊂ℤ : Adjoins ℕ ℤ pos SubDefect SubSolved
ℕ⊂ℤ = adjoins sub-unsolvable sub-solution sub-fresh

------------------------------------------------------------------------
-- C.  अपोह: meaning as exclusion, and its closure.
--
-- `ε : χ⁺ × χ⁻ → ϑ` is a two-sided evaluation -- witnesses against
-- counter-witnesses, terms against contexts, states against experiments.  Any
-- such evaluation generates a Galois connection, and the closure `α ↦ α^⊥⊥`
-- is the apoha operator: a term means the set of things that fail to exclude
-- everything it fails to exclude.
--
-- Nothing is assumed about `ε`.  This is the general fact.

-- PRIOR ART, found after writing this and kept because the overlap is the
-- point.  `Swarm.S04Apoha` already carries apoha as *witnessed separation*:
-- `Ind` (every observation agrees) against `Sep` (some observation excludes,
-- and you hold it), with the constructive gap between them located exactly --
-- the negative forms always agree, the witnessed one needs finiteness or MP.
-- That is the deeper half and it was there first.
--
-- What is below is the other half and does not appear there: the *closure*.
-- `S04Apoha` asks when a separating observation can be produced;
-- `Apoha` below asks what a set of witnesses means once produced, and answers
-- that the exclusion operator is a Galois connection whose double dual is
-- idempotent.  The two compose: S04 supplies the witness, this closes on it.

module Apoha {X Y : Type₀} (ε : X → Y → Type₀) where

  -- What every member of `α` passes.
  _⁺ : (X → Type₀) → (Y → Type₀)
  α ⁺ = λ y → (x : X) → α x → ε x y

  -- What passes every member of `β`.
  _⁻ : (Y → Type₀) → (X → Type₀)
  β ⁻ = λ x → (y : Y) → β y → ε x y

  -- `α ⊆ α^⊥⊥`: the closure only ever adds.
  unit : (α : X → Type₀) (x : X) → α x → ((α ⁺) ⁻) x
  unit α x ax y βy = βy x ax

  -- Dually on the other side.
  counit : (β : Y → Type₀) (y : Y) → β y → ((β ⁻) ⁺) y
  counit β y by x αx = αx y by

  -- Order-reversal, both directions.
  ⁺-anti : (α α′ : X → Type₀) → ((x : X) → α x → α′ x)
         → (y : Y) → (α′ ⁺) y → (α ⁺) y
  ⁺-anti α α′ sub y h x ax = h x (sub x ax)

  ⁻-anti : (β β′ : Y → Type₀) → ((y : Y) → β y → β′ y)
         → (x : X) → (β′ ⁻) x → (β ⁻) x
  ⁻-anti β β′ sub x h y by = h y (sub y by)

  -- Idempotence: `α^⊥⊥⊥ = α^⊥`, so the closure closes.  This is why apoha is
  -- a *meaning* and not merely a step -- iterating exclusion stabilizes after
  -- one round.
  ⁺-idem-to : (α : X → Type₀) (y : Y) → (α ⁺) y → ((((α ⁺) ⁻) ⁺)) y
  ⁺-idem-to α = counit (α ⁺)

  ⁺-idem-from : (α : X → Type₀) (y : Y) → ((((α ⁺) ⁻) ⁺)) y → (α ⁺) y
  ⁺-idem-from α y h = ⁺-anti α (((α ⁺) ⁻)) (unit α) y h

------------------------------------------------------------------------
-- D.  अनेकान्तवाद, as a corollary of the observation-field theorem.
--
-- `ν ⊩ φ` and `ν′ ⊩ ¬φ` without `⊥`: two standpoints assign opposite verdicts
-- to one pair, and nothing breaks, because a verdict is relative to the field
-- that issues it.  `ObstructionCalculus` proved the general form; here it is
-- named.

standpoint-relative :
    Blind absField (pos 6) (negsuc 5)
  × Sep signField (pos 6) (negsuc 5)
standpoint-relative = sign-blind , sign-seen

-- The corpus's own gloss, `वस्तु ≠ एकनयपूर्णनिर्णयः` -- the object is not the
-- complete verdict of one standpoint -- is exactly `break-blindness`: no field
-- is final, so no field's verdict is the object's.
