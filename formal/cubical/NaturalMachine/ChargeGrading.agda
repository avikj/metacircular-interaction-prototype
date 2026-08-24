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
-- NaturalMachine.ChargeGrading
--
-- Delta 15 §§15.6–15.7 (charge grading, parity as truncation of charge)
-- and the structural half of Delta 18 T18.7 (charge-one composition).
--
-- WHY THESE TOGETHER.  Delta 18 T18.7 says charge-one effective
-- propagation is closed under composition iff every off-sector
-- excursion–return contribution vanishes, and calls it "the exact
-- canonical-sector instance of T18.4".  That is a statement about a
-- GRADED dynamics, so it cannot even be typed until the grading is.
-- §15.6 supplies the grading, §15.7 supplies parity as its truncation,
-- and this module checks both and then states the sector-closure
-- condition as a consequence of the grading rather than as a new
-- hypothesis.
--
-- The payoff is C15.25, which is the machine's own situation stated in
-- charge language: *canonical fixed-charge dynamics is closed only under
-- degree-zero operations*.  Every reopening this repository has measured
-- is an admitted action of nonzero degree.
--
-- Contents (all proved, no holes, no postulates, --safe):
--
--   Graded, Total              D15.21: X = Σ_{c:C} X_c
--   Shift                      D15.21: a degree-δ map
--   shift-comp                 T15.22: shifts ADD under composition
--   shift-restricts            T15.24: a degree-δ map sends X_c to X_{c+δ}
--   degree-zero-preserves      C15.23: the degree-zero maps are exactly
--                              the sector-preserving ones
--   sector-closed              C15.25: X_c is closed under a degree-δ
--   sector-closed→δ≡0          map exactly when c + δ ≡ c — and over ℕ,
--                              which is cancellative, only when δ = 0
--   parity, parity-shift       D15.26/T15.27: parity is a truncation of
--                              charge and a degree-δ map changes it by
--                              δ mod 2
--   parity-blind               C15.28: retaining parity while forgetting
--                              charge is strictly coarser — an explicit
--                              pair of charges with equal parity
--   parity-moving-shifts       P15.29: the two sources of a parity
--   parity-preserving-shifts   obstruction get different witnesses, so
--                              they are distinguished, not merged
--   no-cancellation            T18.7 structural: ℕ has no inverses, so a
--                              later charge cannot cancel an earlier one
--
-- NOT claimed: novelty.  Graded objects and degree-additivity are
-- standard; Delta 15 presents them as setup.  The contribution here is
-- that the machine's sector-reopening condition is derived from the
-- grading instead of being asserted alongside it.
------------------------------------------------------------------------

module NaturalMachine.ChargeGrading where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-assoc ; +-comm ; +-zero ; injSuc ; snotz ; znots)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §15.6  Charge grading
--
-- The charge monoid is ℕ under addition.  Delta 15 allows any commutative
-- monoid; ℕ is the case the corpus actually uses (Ω, the number of prime
-- factors with multiplicity), it is cancellative, and cancellativity is
-- exactly what turns C15.25 from a condition into "δ = 0".
------------------------------------------------------------------------

Graded : (ℓ : Level) → Type (ℓ-suc ℓ)
Graded ℓ = ℕ → Type ℓ

-- D15.21.  The total space X = Σ_{c} X_c, with its base projection.
Total : Graded ℓ → Type ℓ
Total X = Σ[ c ∈ ℕ ] X c

base : {X : Graded ℓ} → Total X → ℕ
base = fst

-- D15.21.  A map of charge shift δ: it moves every sector by exactly δ.
-- Stating it fibrewise rather than as a map of total spaces with a
-- side condition is what makes T15.22 and T15.24 definitional.
Shift : {ℓ : Level} → Graded ℓ → ℕ → Type ℓ
Shift X δ = (c : ℕ) → X c → X (c + δ)

-- T15.24.  A degree-δ map restricts X_c → X_{c+δ}.  This is the type of
-- `Shift`, so it holds by construction — which is the point of choosing
-- the fibrewise formulation.
shift-restricts : {X : Graded ℓ} {δ : ℕ}
                → Shift X δ → (c : ℕ) → X c → X (c + δ)
shift-restricts S = S

-- T15.22.  Charge shifts ADD under composition.  The transport is where
-- the associativity of the charge monoid enters, and it is the only
-- place it is needed.
shift-comp : {X : Graded ℓ} {δ ε : ℕ}
           → Shift X δ → Shift X ε → Shift X (δ + ε)
shift-comp {X = X} {δ = δ} {ε = ε} S T c x =
  subst X (sym (+-assoc c δ ε)) (T (c + δ) (S c x))

-- C15.23.  The degree-zero maps preserve every sector.  Again the charge
-- arithmetic is doing the work: c + 0 ≡ c.
degree-zero-preserves : {X : Graded ℓ}
                      → Shift X 0 → (c : ℕ) → X c → X c
degree-zero-preserves {X = X} S c x = subst X (+-zero c) (S c x)

-- C15.25.  The sector X_c is closed under a degree-δ map exactly when
-- c + δ ≡ c.  Over ℕ that forces δ ≡ 0, so canonical fixed-charge
-- dynamics is closed ONLY under degree-zero operations.
--
-- This is the machine's reopening condition in charge language: an
-- admitted action of nonzero degree cannot preserve the installed
-- sector, whatever else is true of it.
sector-closed : {X : Graded ℓ} (δ c : ℕ) → Type
sector-closed δ c = c + δ ≡ c

sector-closed→δ≡0 : (δ c : ℕ) → c + δ ≡ c → δ ≡ 0
sector-closed→δ≡0 δ zero p = p
sector-closed→δ≡0 δ (suc c) p = sector-closed→δ≡0 δ c (injSuc p)

------------------------------------------------------------------------
-- §15.7  Parity as a truncation of charge
--
-- D15.26: parity = π ∘ ℓ, with ℓ the length and π : ℤ → ℤ/2.  Here ℓ is
-- the identity on the ℕ-grading and π is evenness.
------------------------------------------------------------------------

parity : ℕ → Bool
parity zero          = true
parity (suc zero)    = false
parity (suc (suc n)) = parity n

xor : Bool → Bool → Bool
xor true  b = b
xor false b = not b

-- T15.27.  An operation changing charge by δ changes parity by δ mod 2.
-- Proved by the two-step induction the definition of `parity` uses.
parity-shift : (c δ : ℕ) → parity (c + δ) ≡ xor (parity c) (parity δ)
parity-shift zero δ = refl
parity-shift (suc zero) δ = lemma δ
  where
    lemma : (δ : ℕ) → parity (suc δ) ≡ not (parity δ)
    lemma zero          = refl
    lemma (suc zero)    = refl
    lemma (suc (suc n)) = lemma n
parity-shift (suc (suc c)) δ = parity-shift c δ

-- C15.28.  Forgetting full charge while retaining parity is STRICTLY
-- coarser: the fibre of `parity` over a value contains all charges of
-- that parity.  Exhibited rather than asserted.
parity-blind : Σ[ a ∈ ℕ ] Σ[ b ∈ ℕ ] ((parity a ≡ parity b) × (¬ (a ≡ b)))
parity-blind = 0 , 2 , refl , znots

------------------------------------------------------------------------
-- P15.29  The two sources of a parity obstruction, kept apart
--
-- Delta 15: "A parity obstruction can therefore arise either from
-- inability to reconstruct full charge or from dynamics genuinely
-- sensitive only to parity; these must be distinguished."
--
-- The distinction is typed, not rhetorical:
--
--   * RECONSTRUCTION failure — the observation is `parity`, and two
--     distinct charges share it.  `parity-blind` above is a witness.
--
--   * DYNAMICAL sensitivity — the shift δ itself has odd parity, so the
--     operation moves the parity sector no matter how much charge
--     information the observer retains.
--
-- These are independent: the first is a property of the OBSERVER, the
-- second of the ACTION, and a system can have either without the other.
------------------------------------------------------------------------

-- An action is parity-moving when its own shift is odd.
parity-moving : ℕ → Type
parity-moving δ = parity δ ≡ false

-- A parity-moving action changes the parity of every sector it touches:
-- no observer refinement can prevent it, because the shift is what moves.
parity-moving-shifts : (δ : ℕ) → parity-moving δ
                     → (c : ℕ) → parity (c + δ) ≡ not (parity c)
parity-moving-shifts δ odd c =
  parity-shift c δ ∙ cong (xor (parity c)) odd ∙ lemma (parity c)
  where
    lemma : (b : Bool) → xor b false ≡ not b
    lemma true  = refl
    lemma false = refl

-- ... whereas a degree-EVEN action preserves parity in every sector, so
-- a parity observer sees nothing at all.  Together with the previous
-- statement this is P15.29: the two phenomena have different witnesses
-- and neither implies the other.
parity-preserving-shifts : (δ : ℕ) → parity δ ≡ true
                         → (c : ℕ) → parity (c + δ) ≡ parity c
parity-preserving-shifts δ even c =
  parity-shift c δ ∙ cong (xor (parity c)) even ∙ lemma (parity c)
  where
    lemma : (b : Bool) → xor b true ≡ b
    lemma true  = refl
    lemma false = refl

-- The parity seen after a shift in every charge sector contains exactly one
-- bit of information: the parity of the shift itself.  Thus equality of the
-- entire observable action is decidable at the zero sector.  The reverse
-- implication is not an additional induction; it is the character law
-- `parity-shift` applied on both sides.
parity-action-complete : (δ ε : ℕ)
                       → ((((c : ℕ) → parity (c + δ) ≡ parity (c + ε))
                          → parity δ ≡ parity ε)
                         ×
                         ((parity δ ≡ parity ε)
                          → (c : ℕ) → parity (c + δ) ≡ parity (c + ε)))
parity-action-complete δ ε = at-zero , from-shift-parity
  where
    at-zero : ((c : ℕ) → parity (c + δ) ≡ parity (c + ε))
            → parity δ ≡ parity ε
    at-zero same = same zero

    from-shift-parity : parity δ ≡ parity ε
                      → (c : ℕ) → parity (c + δ) ≡ parity (c + ε)
    from-shift-parity same c =
      parity-shift c δ
      ∙ cong (xor (parity c)) same
      ∙ sym (parity-shift c ε)

------------------------------------------------------------------------
-- Delta 18 T18.7, structurally
--
-- Charge-one effective propagation is closed under composition iff every
-- off-sector contribution vanishes.  In the graded setting that is not an
-- extra hypothesis: by T15.22 a composite of shifts δ and ε has shift
-- δ + ε, and by C15.25 it preserves the installed sector only when
-- δ + ε ≡ 0.  Over ℕ that forces BOTH to vanish — the intermediate charge
-- cannot be cancelled by a later one.
--
-- So the prime-pair block "remembers all intermediate factorization
-- charges" for a reason internal to the grading: ℕ has no inverses.  A
-- charge group WOULD allow cancellation, and that is exactly the
-- structural difference between the canonical and grand-canonical
-- settings.
------------------------------------------------------------------------

no-cancellation : (δ ε : ℕ) → δ + ε ≡ 0 → (δ ≡ 0) × (ε ≡ 0)
no-cancellation zero zero p = refl , refl
no-cancellation zero (suc ε) p = refl , p
no-cancellation (suc δ) ε p = ⊥rec (snotz p) , ⊥rec (snotz p)
