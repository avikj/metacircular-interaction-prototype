{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PerspectiveSymmetry
--
-- Delta 15 §§15.3, 15.4, 15.6 — the three sections
-- `NaturalMachine.StructuredDefect` does not cover.
--
-- COLLISION NOTE.  Another mind landed `StructuredDefect.agda` for
-- §§15.2/15.10/15.19/15.23/15.24 while I was writing the same file name;
-- `./sync` produced a genuine merge conflict.  I resolved it to theirs
-- and moved my complement here rather than clobbering or duplicating.
-- That is also why this module IMPORTS their `Str` and `Defect` instead
-- of redefining them — and the import turns out to pay for itself:
--
--     the stabilizer of a structure is exactly its SELF-defect.
--
--         Stab S s e  =  Defect {S = S} e s s
--
-- So T15.9 (the stabilizer is a subgroup) needs no new proofs at the
-- identity and at composition — `defect-id` and `defect-comp` already ARE
-- those two clauses, at s_A = s_B = s.  Only closure under inverses is
-- new, and it is Delta 15's own T15.2.  Symmetry breaking (§15.3) and
-- structured transport (§15.24) are not two mechanisms; the subgroup laws
-- are the functoriality of transport read on the diagonal.
--
-- CONTENTS (all checked, no postulates, no holes):
--
--   §15.3   Stab, stab-id, stab-comp, stab-inv        T15.9, C15.10
--   §15.4   Preserves, Defect-locus, both directions  T15.12–T15.14
--           SignFlip.total-defect                      Program 15.16
--   §15.6   Shift, shift-comp                          T15.22, T15.24
--
-- NOT claimed: novelty. §15.3 is the orbit–stabilizer setup, §15.4 is a
-- predicate-invariance calculation, §15.6 is grading. What is contributed
-- here is that all three are expressed against the SAME `Defect` the
-- machine's reopening test already uses, so a symmetry loss, a boundary
-- asymmetry, and a charge violation are one measurement in three places.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-14.
-- No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PerspectiveSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Transport
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.StructuredDefect
  using (Str ; Defect ; defect-id ; defect-comp)

private
  variable
    ℓ ℓS : Level

------------------------------------------------------------------------
-- §15.3  Symmetry breaking by extra structure  (D15.8, T15.9, C15.10)
--
-- G is Aut A acting by transport.  The stabilizer of s is the set of
-- automorphisms along which s transports to itself — i.e. its own defect
-- type on the diagonal.
------------------------------------------------------------------------

Stab : (S : Str ℓ ℓS) {A : Type ℓ} → S A → (A ≃ A) → Type ℓS
Stab S {A = A} s e = Defect {S = S} e s s

-- T15.9, clause 1 — already proved, as `defect-id` at s_A = s_B
stab-id : (S : Str ℓ ℓS) {A : Type ℓ} (s : S A) → Stab S s (idEquiv A)
stab-id S s = defect-id {S = S} s

-- T15.9, clause 2 — already proved, as `defect-comp` on the diagonal
stab-comp : (S : Str ℓ ℓS) {A : Type ℓ} (s : S A) (e f : A ≃ A)
          → Stab S s e → Stab S s f → Stab S s (compEquiv e f)
stab-comp S s e f = defect-comp {S = S} e f

-- T15.9, clause 3 — the only new content, and it is exactly Delta 15's
-- T15.2 (transport along the inverse undoes transport).
stab-inv : (S : Str ℓ ℓS) {A : Type ℓ} (s : S A) (e : A ≃ A)
         → Stab S s e → Stab S s (invEquiv e)
stab-inv S s e se = sym (cong (subst S (ua (invEquiv e))) se) ∙ round
  where
  collapse : ua e ∙ ua (invEquiv e) ≡ refl
  collapse = sym (uaCompEquiv e (invEquiv e))
           ∙ cong ua (invEquiv-is-rinv e)
           ∙ uaIdEquiv

  -- T15.2, in the form needed
  round : subst S (ua (invEquiv e)) (subst S (ua e) s) ≡ s
  round = sym (substComposite S (ua e) (ua (invEquiv e)) s)
        ∙ cong (λ p → subst S p s) collapse
        ∙ substRefl {B = S} s

-- C15.10, read off the three clauses: `Stab S s` is a subgroup of Aut A,
-- so adding structure can only shrink the symmetry, never enlarge it.
-- T15.11 is then the observation that an ambient equivalence conjugating
-- the actions says nothing about whether it lands inside this subgroup.

------------------------------------------------------------------------
-- §15.4  Polarization  (T15.12, D15.13, T15.14)
--
-- Delta 15 C15.15: boundary asymmetry is measurable BEFORE any spectral
-- or topological machinery — first compute the failure locus of predicate
-- invariance.  That locus is a type here, not a cardinality, so a single
-- point of it is a usable certificate.
------------------------------------------------------------------------

module Polarization {A : Type ℓ} (J : A → A) (P : A → Bool) where

  -- T15.12: J restricts to the subtype cut out by P exactly when P is
  -- J-invariant.
  Preserves : Type ℓ
  Preserves = (a : A) → P a ≡ P (J a)

  -- D15.13: the polarization defect, proof-relevantly — the witness is
  -- the point at which polarity flips.
  Locus : Type ℓ
  Locus = Σ[ a ∈ A ] ¬ (P a ≡ P (J a))

  -- T15.14, both directions.
  preserves→empty : Preserves → ¬ Locus
  preserves→empty pres (a , ¬p) = ¬p (pres a)

  inhabited→not-preserves : Locus → ¬ Preserves
  inhabited→not-preserves (a , ¬p) pres = ¬p (pres a)

-- Program 15.16.  Signed magnitudes `Bool × A`, reflection = sign flip,
-- predicate = the sign bit.  EVERY point is in the failure locus: the
-- reflection destroys positivity everywhere it is defined.
--
-- HONEST SCOPE.  Delta 15 says "all nonzero points" for ℤ.  This carrier
-- does not identify (true , z) with (false , z), so it has no zero to
-- except — the statement here is therefore about signed magnitudes, and
-- the missing exception IS the sign-of-zero identification.  Stated
-- rather than quietly matched.
module SignFlip (A : Type₀) where
  open Polarization {A = Bool × A} (λ p → (not (p .fst) , p .snd)) fst public

  total-defect : (a : A) → Locus
  total-defect a = (true , a) , true≢false

  -- and hence, by T15.14, the reflection preserves no positivity
  -- predicate on any inhabited carrier
  no-preservation : A → ¬ Preserves
  no-preservation a = inhabited→not-preserves (total-defect a)

------------------------------------------------------------------------
-- §15.6  Charge grading  (D15.21, T15.22, T15.24)
--
-- C15.25: canonical fixed-charge dynamics is closed only under degree-zero
-- operations.  Here `Shift 0` is the degree-zero part and `shift-comp`
-- shows the degrees add, so that closure is a corollary rather than a
-- convention.
------------------------------------------------------------------------

module Charge {C : Type₀} (_⊕_ : C → C → C)
              (⊕-assoc : (a b c : C) → ((a ⊕ b) ⊕ c) ≡ (a ⊕ (b ⊕ c)))
              (X : C → Type ℓ) where

  -- D15.21 and T15.24 in one: a degree-δ map IS its restriction law.
  -- There is no separate theorem that a degree-δ map restricts, because
  -- the restriction is what the type says.
  Shift : C → Type _
  Shift δ = (c : C) → X c → X (c ⊕ δ)

  -- T15.22: shifts add under composition.  Associativity of the charge
  -- monoid is exactly what is needed to NAME the target charge — which is
  -- why the monoid cannot be dropped from the definition of a grading.
  shift-comp : {δ ε : C} → Shift δ → Shift ε → Shift (δ ⊕ ε)
  shift-comp {δ = δ} {ε = ε} S T c x =
    subst X (⊕-assoc c δ ε) (T (c ⊕ δ) (S c x))
