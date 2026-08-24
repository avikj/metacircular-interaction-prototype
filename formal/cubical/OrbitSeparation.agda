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

{-# OPTIONS --cubical --safe #-}

{-
  OrbitSeparation
  ===============

  The kernel-checked core of the "singleton + orbit" condition described in
  `notes/SEPARATING_POINT_COLLAPSE.md` (genius-13 / Sophie Germain block,
  2026-08-14).

  Setting.  A type `X` of states, an *invertible* admitted action `α : X ≃ X`,
  and an observation `P : X → C` whose fibres are the installed compression.
  The relation

      x ~ y  :=  (n : ℕ) → P (αⁿ x) ≡ P (αⁿ y)

  is the coarsest α-invariant relation refining the fibres of `P`; that is the
  Myhill–Nerode / persistent-carrier relation which
  `notes/NATURAL_MACHINE_CPU_LOOP.md` §4 computes by Moore refinement and
  `notes/UNASSEMBLED_RESULTS_HARVEST.md` E1 studies for divisibility crystals.
  `~-refines`, `~-invariant` and `~-coarsest` below prove that characterisation,
  so the object is defined rather than asserted.

  The result.  `orbit-separates` : if some observation fibre is a **singleton**
  `{x₀}`, then every state that α eventually carries to `x₀` is a `~`-singleton.
  `discrete-of-transitive` : if in addition α reaches `x₀` from everywhere
  (⟨α⟩ transitive), `~` is the identity — the compression is destroyed
  completely and the persistent correction cost is maximal.

  `sound-collapses` is the opposite pole: if `P` is already an α-congruence the
  closure is `P` itself, i.e. cost zero.

  Nothing here is new mathematics.  For a group acting transitively this is the
  classical block/imprimitivity correspondence (invariant partitions of a
  transitive G-set ↔ subgroups between the point stabiliser and G).  What is new
  is only that the corpus proves instances of it one modulus at a time.

  This module is deliberately NOT imported by `NaturalMachine.agda`; it is
  standalone and self-contained (Prelude + Equiv + ℕ + Σ only).
-}

module OrbitSeparation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Sigma using (Σ; _,_; fst; snd)

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ {X : Type ℓ} {C : Type ℓ'} (α : X ≃ X) (P : X → C) where

  act : X → X
  act = equivFun α

  -- αⁿ, written so that `step (suc n) x` is `step n (act x)`.
  step : ℕ → X → X
  step zero    x = x
  step (suc n) x = step n (act x)

  ------------------------------------------------------------------
  -- the persistent carrier relation
  ------------------------------------------------------------------

  _~_ : X → X → Type ℓ'
  x ~ y = (n : ℕ) → P (step n x) ≡ P (step n y)

  -- (i) it refines the observation
  ~-refines : (x y : X) → x ~ y → P x ≡ P y
  ~-refines x y h = h zero

  -- (ii) it is α-invariant
  ~-invariant : (x y : X) → x ~ y → act x ~ act y
  ~-invariant x y h n = h (suc n)

  -- (iii) it is the coarsest such: any α-invariant relation refining P
  --       is contained in it.
  ~-coarsest : (R : X → X → Type ℓ'')
    → ((u v : X) → R u v → P u ≡ P v)
    → ((u v : X) → R u v → R (act u) (act v))
    → (x y : X) → R x y → x ~ y
  ~-coarsest R ref inv x y r zero    = ref x y r
  ~-coarsest R ref inv x y r (suc n) =
    ~-coarsest R ref inv (act x) (act y) (inv x y r) n

  ------------------------------------------------------------------
  -- invertibility of the action
  ------------------------------------------------------------------

  act-inj : {x y : X} → act x ≡ act y → x ≡ y
  act-inj {x} {y} p =
    sym (retEq α x) ∙ cong (invEq α) p ∙ retEq α y

  step-inj : (n : ℕ) {x y : X} → step n x ≡ step n y → x ≡ y
  step-inj zero    p = p
  step-inj (suc n) p = act-inj (step-inj n p)

  ------------------------------------------------------------------
  -- the separating-point condition
  ------------------------------------------------------------------

  -- "{x₀} is a singleton class of P"
  isSeparating : X → Type (ℓ-max ℓ ℓ')
  isSeparating x₀ = (x : X) → P x ≡ P x₀ → x ≡ x₀

  -- Theorem G′.  Every state whose α-orbit meets a separating point is a
  -- ~-singleton.  No transitivity, no finiteness, no decidability.
  orbit-separates :
      (x₀ : X) → isSeparating x₀
    → (x y : X) → x ~ y
    → (n : ℕ) → step n x ≡ x₀
    → x ≡ y
  orbit-separates x₀ sing x y x~y n hit =
    step-inj n (hit ∙ sym (sing (step n y) (sym (x~y n) ∙ cong P hit)))

  -- "⟨α⟩ reaches x₀ from every state" — for a bijection of a finite set this
  -- is exactly transitivity of the cyclic group ⟨α⟩.
  reaches : X → Type ℓ
  reaches x₀ = (x : X) → Σ ℕ (λ n → step n x ≡ x₀)

  -- Corollary.  Singleton class + transitive invertible action ⇒ the
  -- persistent carrier is discrete: maximal correction cost.
  discrete-of-transitive :
      (x₀ : X) → isSeparating x₀ → reaches x₀
    → (x y : X) → x ~ y → x ≡ y
  discrete-of-transitive x₀ sing tr x y x~y =
    orbit-separates x₀ sing x y x~y (fst (tr x)) (snd (tr x))

  ------------------------------------------------------------------
  -- the opposite pole: cost zero
  ------------------------------------------------------------------

  -- If P is already an α-congruence ("α is sound"), the closure is P.
  sound-collapses :
      ((u v : X) → P u ≡ P v → P (act u) ≡ P (act v))
    → (x y : X) → P x ≡ P y → x ~ y
  sound-collapses h x y p zero    = p
  sound-collapses h x y p (suc n) =
    sound-collapses h (act x) (act y) (h x y p) n
