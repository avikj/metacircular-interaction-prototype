/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An exact higher-arity boundary for the binary cancellation observable.
Individual p-adic depths together with every labeled pairwise cancellation
residual need not determine cancellation in the full three-term sum.
-/
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Tactic

namespace Pairfield

namespace TernaryCancellationFormation

/-- A labeled positive-natural triple.  Positivity is not built into the
carrier because the checked event below supplies concrete positive entries. -/
structure Triple where
  first : ℕ
  second : ℕ
  third : ℕ
deriving Repr, DecidableEq

/-- The finite binary cancellation residual used by the landed observable.
The zero-sum/infinity branch is outside this concrete positive event. -/
def cancellationResidual (p a b : ℕ) : ℕ :=
  padicValNat p (a + b) - min (padicValNat p a) (padicValNat p b)

/-- All old labeled information: three input depths and the residual on every
two-coordinate sub-sum. -/
structure PairwiseLedger where
  firstDepth : ℕ
  secondDepth : ℕ
  thirdDepth : ℕ
  firstSecond : ℕ
  firstThird : ℕ
  secondThird : ℕ
deriving Repr, DecidableEq

def pairwiseLedger (p : ℕ) (triple : Triple) : PairwiseLedger where
  firstDepth := padicValNat p triple.first
  secondDepth := padicValNat p triple.second
  thirdDepth := padicValNat p triple.third
  firstSecond := cancellationResidual p triple.first triple.second
  firstThird := cancellationResidual p triple.first triple.third
  secondThird := cancellationResidual p triple.second triple.third

/-- The genuinely ternary residual after removing the least input depth. -/
def ternaryResidual (p : ℕ) (triple : Triple) : ℕ :=
  padicValNat p (triple.first + triple.second + triple.third) -
    min (padicValNat p triple.first)
      (min (padicValNat p triple.second) (padicValNat p triple.third))

/-- The two formed states.  Their pairwise ledgers coincide at `p=5`, while
their total sums are respectively five and three. -/
def deepTriple : Triple := ⟨1, 1, 3⟩
def shallowTriple : Triple := ⟨1, 1, 1⟩

/-- The old observable genuinely collides even though it retains all labeled
input depths and all three labeled pairwise residuals. -/
theorem pairwise_ledger_collision :
    pairwiseLedger 5 deepTriple = pairwiseLedger 5 shallowTriple := by
  simp [pairwiseLedger, cancellationResidual, deepTriple, shallowTriple,
    padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 2 by decide),
    padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 3 by decide),
    padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 4 by decide)]

theorem deep_ternary_residual_eq_one : ternaryResidual 5 deepTriple = 1 := by
  simp [ternaryResidual, deepTriple,
    padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 3 by decide)]

theorem shallow_ternary_residual_eq_zero :
    ternaryResidual 5 shallowTriple = 0 := by
  simp [ternaryResidual, shallowTriple,
    padicValNat.eq_zero_of_not_dvd (show ¬ (5:ℕ) ∣ 3 by decide)]

/-- The full three-term response separates the old observational collision. -/
theorem ternary_residual_separates :
    ternaryResidual 5 deepTriple ≠ ternaryResidual 5 shallowTriple := by
  rw [deep_ternary_residual_eq_one, shallow_ternary_residual_eq_zero]
  decide

/-- The declared two-point formation world; no ambient perturbation is used. -/
def formedTriple : Fin 2 → Triple
  | ⟨0, _⟩ => deepTriple
  | ⟨1, _⟩ => shallowTriple

def oldObservable (state : Fin 2) : PairwiseLedger :=
  pairwiseLedger 5 (formedTriple state)

/-- The forced repair retains the complete old ledger and adjoins exactly the
ternary coordinate that failed to descend through it. -/
def repairedObservable (state : Fin 2) : PairwiseLedger × ℕ :=
  (oldObservable state, ternaryResidual 5 (formedTriple state))

theorem repairedObservable_retains_old (state : Fin 2) :
    (repairedObservable state).1 = oldObservable state := rfl

theorem oldObservable_collision : oldObservable 0 = oldObservable 1 :=
  pairwise_ledger_collision

/-- On the declared formed locus the new coordinate is strict: it makes the
two-point observable injective.  This is an executable formation event, not an
ambient minimality inference. -/
theorem repairedObservable_injective :
    Function.Injective repairedObservable := by
  intro left right heq
  fin_cases left <;> fin_cases right
  · rfl
  · exact False.elim (ternary_residual_separates
      (congrArg Prod.snd heq))
  · exact False.elim (ternary_residual_separates
      (congrArg Prod.snd heq).symm)
  · rfl

end TernaryCancellationFormation

end Pairfield
