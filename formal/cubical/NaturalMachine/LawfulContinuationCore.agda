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

module NaturalMachine.LawfulContinuationCore where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Bool.Properties using (notEquiv ; true≢false ; not≢const)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Mod using (_mod_)
open import Cubical.Data.Nat.Properties using (snotz ; znots ; injSuc)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
open import NaturalMachine.CountedExecution as CE using (run)

------------------------------------------------------------------------
-- State-dependent lawful motion and counted histories
------------------------------------------------------------------------

record World {ℓ ℓ′ : Level} : Type (ℓ-suc (ℓ-max ℓ ℓ′)) where
  field
    State  : Type ℓ
    Lawful : State → Type ℓ′
    next   : (s : State) → Lawful s → State

open World public

data CountedPath {ℓ ℓ′} (W : World {ℓ} {ℓ′})
     : State W → ℕ → Type (ℓ-max ℓ ℓ′) where
  stop : (s : State W) → CountedPath W s zero
  step : {s : State W} {n : ℕ} (move : Lawful W s)
       → CountedPath W (next W s move) n
       → CountedPath W s (suc n)

endpoint : ∀ {ℓ ℓ′} {W : World {ℓ} {ℓ′}} {s : State W} {n : ℕ}
         → CountedPath W s n → State W
endpoint (stop s) = s
endpoint (step move tail) = endpoint tail

-- A displayed choice in every lawful fiber turns dependent availability into
-- one ordinary deterministic transition.  Coherence is not needed for this
-- forgetting map; it becomes relevant only when the choices must survive the
-- declared comparison edges below.
selectedStep : ∀ {ℓ ℓ′} (W : World {ℓ} {ℓ′})
             → ((s : State W) → Lawful W s) → State W → State W
selectedStep W choose s = next W s (choose s)

selectedPath : ∀ {ℓ ℓ′} (W : World {ℓ} {ℓ′})
             → (choose : (s : State W) → Lawful W s)
             → (s : State W) (n : ℕ) → CountedPath W s n
selectedPath W choose s zero = stop s
selectedPath W choose s (suc n) =
  step (choose s) (selectedPath W choose (selectedStep W choose s) n)

run-shift : {S : Type₀} (s : S) (advance : S → S) (n : ℕ)
          → run (advance s) advance n ≡ advance (run s advance n)
run-shift s advance zero = refl
run-shift s advance (suc n) = cong advance (run-shift s advance n)

selectedPath-endpoint : ∀ {ℓ′} (W : World {ℓ-zero} {ℓ′})
                      → (choose : (s : State W) → Lawful W s)
                      → (s : State W) (n : ℕ)
                      → endpoint (selectedPath W choose s n)
                      ≡ run s (selectedStep W choose) n
selectedPath-endpoint W choose s zero = refl
selectedPath-endpoint W choose s (suc n) =
    selectedPath-endpoint W choose (selectedStep W choose s) n
  ∙ run-shift s (selectedStep W choose) n

------------------------------------------------------------------------
-- Fiber shapes are evidence, not an assumed global trichotomy.
------------------------------------------------------------------------

EmptyFiber : ∀ {ℓ} → Type ℓ → Type ℓ
EmptyFiber A = A → ⊥

UniqueFiber : ∀ {ℓ} → Type ℓ → Type ℓ
UniqueFiber A = Σ[ center ∈ A ] ((x : A) → x ≡ center)

BranchingFiber : ∀ {ℓ} → Type ℓ → Type ℓ
BranchingFiber A = Σ[ left ∈ A ] Σ[ right ∈ A ] ¬ left ≡ right

unique-not-branching : ∀ {ℓ} {A : Type ℓ}
                     → UniqueFiber A → EmptyFiber (BranchingFiber A)
unique-not-branching (center , all≡) (left , right , different) =
  different (all≡ left ∙ sym (all≡ right))

data ControlState : Type₀ where
  blocked forced branching : ControlState

ControlFiber : ControlState → Type₀
ControlFiber blocked = ⊥
ControlFiber forced  = Unit
ControlFiber branching = Bool

blocked-is-empty : EmptyFiber (ControlFiber blocked)
blocked-is-empty ()

forced-is-unique : UniqueFiber (ControlFiber forced)
forced-is-unique = tt , λ { tt → refl }

open-is-branching : BranchingFiber (ControlFiber branching)
open-is-branching = false , true , λ p → true≢false (sym p)

------------------------------------------------------------------------
-- Raw inhabitants are not yet a global continuation.
--
-- Edges say which local views must be compared.  `transport` is the actual
-- comparison map.  A coherent section must choose in every fiber and survive
-- every transport.  Counting components of the raw fibers forgets this law.
------------------------------------------------------------------------

record ContinuationFamily {ℓ ℓe ℓf : Level} (S : Type ℓ)
    : Type (ℓ-suc (ℓ-max ℓ (ℓ-max ℓe ℓf))) where
  field
    Fiber     : S → Type ℓf
    Edge      : S → S → Type ℓe
    carry     : {s t : S} → Edge s t → Fiber s ≃ Fiber t

open ContinuationFamily public

LocallyInhabited : ∀ {ℓ ℓe ℓf} {S : Type ℓ}
                 → ContinuationFamily {ℓe = ℓe} {ℓf = ℓf} S
                 → Type (ℓ-max ℓ ℓf)
LocallyInhabited {S = S} F = (s : S) → Fiber F s

record CoherentSection {ℓ ℓe ℓf} {S : Type ℓ}
    (F : ContinuationFamily {ℓe = ℓe} {ℓf = ℓf} S)
    : Type (ℓ-max ℓ (ℓ-max ℓe ℓf)) where
  field
    choose   : (s : S) → Fiber F s
    coherent : {s t : S} (edge : Edge F s t)
             → equivFun (carry F edge) (choose s) ≡ choose t

------------------------------------------------------------------------
-- C₂ flip holonomy: every local fiber is inhabited (and has two points),
-- but the loop transport flips them, so no coherent section exists.
------------------------------------------------------------------------

flipFamily : ContinuationFamily Unit
Fiber flipFamily _ = Bool
Edge flipFamily _ _ = Unit
carry flipFamily _ = notEquiv

flip-locally-inhabited : LocallyInhabited flipFamily
flip-locally-inhabited _ = false

flip-fibers-branch : (s : Unit) → BranchingFiber (Fiber flipFamily s)
flip-fibers-branch _ = false , true , λ p → true≢false (sym p)

flip-has-no-coherent-section : EmptyFiber (CoherentSection flipFamily)
flip-has-no-coherent-section section =
  not≢const (CoherentSection.choose section tt)
    (CoherentSection.coherent section tt)

------------------------------------------------------------------------
-- Arithmetic witness: the admissible modulus fiber at period L consists of
-- moduli with nonzero remainder.  The displayed finite evidence at L = 6
-- uses only reduction of `mod`; no equality decision is assumed elsewhere.
------------------------------------------------------------------------

AdmissibleModulus : ℕ → Type₀
AdmissibleModulus L = Σ[ q ∈ ℕ ] ¬ (L mod q ≡ zero)

four-at-six : AdmissibleModulus 6
four-at-six = 4 , snotz

five-at-six : AdmissibleModulus 6
five-at-six = 5 , snotz

admissible-six-branches : BranchingFiber (AdmissibleModulus 6)
admissible-six-branches = four-at-six , five-at-six , different
  where
  different : ¬ four-at-six ≡ five-at-six
  different p = znots (injSuc (injSuc (injSuc (injSuc (cong fst p)))))

modulusWorld : World
State modulusWorld = ℕ
Lawful modulusWorld = AdmissibleModulus
next modulusWorld _ q = fst q

install-four-at-six : CountedPath modulusWorld 6 1
install-four-at-six = step four-at-six (stop 4)

install-five-at-six : CountedPath modulusWorld 6 1
install-five-at-six = step five-at-six (stop 5)
