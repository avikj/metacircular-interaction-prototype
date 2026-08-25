{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- StructuredDefect
--
-- Delta 15 (Univalent Perspectival Mathematics), §§15.2, 15.10, 15.19,
-- 15.23, 15.24, checked.
--
-- This module supplies the thing the natural-machine loop has been
-- missing.  The Rust loop (`natural_machine_cpu_loop_rust/`) installs a
-- compression, admits a new action, discovers the action does not
-- respect the compression, and prints a NUMBER for the damage.  A number
-- is not the object.  Delta 15 D15.83 names the object: the structured
-- defect is an identity TYPE, and the machine's "reopening" is exactly
-- the statement that this type is uninhabited.
--
--   D15.83  Def_Str(e) = (transport_Str(ua e, s_A) ≡ s_B)
--   T15.84  e upgrades to a structured equivalence iff Def_Str(e) is inhabited
--   C15.85  even when the carriers are equivalent, failure of structure
--           transport has an explicit proof-relevant defect type
--
-- and the loop's soundness condition is Delta 15 T15.40/C15.41: an
-- admitted action is sound for an installed quotient exactly when it
-- coequalizes the kernel pair.  "The kernel pair, not the quotient
-- label, is the exact set-level carrier of which distinctions must be
-- irrelevant for descent."
--
-- Contents (all proved, no holes, no postulates, --safe):
--
--   Defect, StructuredEquiv     D15.83, D15.5
--   defect→structured           T15.84 (both directions)
--   defect-id, defect-comp      transport is functorial on defects
--   Descends, descends→respects,
--   respects→descends           T15.40 / C15.41, both directions
--   reopening-is-defect         the loop's REOPEN phase, as a type
--   refute-transport            T15.70 / C15.71: no-go knowledge
--                               transports across equivalence exactly
--                               as a positive theorem does
--   refute-pullback             T15.68 / C15.69: refutations propagate
--                               contravariantly along constructions
--   emptyFiber→¬isEquiv,
--   twoPoints→¬isEquiv          T15.81 / C15.82: a failed equivalence
--                               hands you its fiber, and the fiber IS
--                               the reconstruction question
--   witness-two, witness-defect a concrete inhabited defect: a bare
--                               equivalence of carriers whose structure
--                               does not transport (Program 15.90)
--
-- NOT claimed: any novelty.  §§15.1–15.2 are the structure identity
-- principle; §15.10 is descent through a set quotient; §15.19 is
-- composition.  What this module contributes to THIS repository is that
-- the machine's residual now has a type instead of a counter.
------------------------------------------------------------------------

module StructuredDefect where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Transport
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓS : Level

------------------------------------------------------------------------
-- §15.2 / §15.24  Structured objects and the defect type
------------------------------------------------------------------------

-- A structure family, in the sense of Delta 15 §15.1: a dependent family
-- over the universe.  C15.3 is then automatic — anything of this shape
-- is representation-transportable — and P15.4 says that a structure NOT
-- of this shape is evidence that its definition depends on presentation
-- data not included in the type being equated.

Str : (ℓ ℓS : Level) → Type (ℓ-suc (ℓ-max ℓ ℓS))
Str ℓ ℓS = Type ℓ → Type ℓS

-- D15.83.  The structured defect of a bare equivalence.  This is the
-- object; `Defect` inhabited is the good case, `¬ Defect` is a reopening.
Defect : {S : Str ℓ ℓS} {A B : Type ℓ}
       → (e : A ≃ B) → S A → S B → Type ℓS
Defect {S = S} e sA sB = subst S (ua e) sA ≡ sB

-- D15.5.  A structured equivalence is a bare one together with a witness
-- that the structure transports.
StructuredEquiv : {ℓ ℓS : Level} (S : Str ℓ ℓS)
                → (A : Type ℓ) (sA : S A) (B : Type ℓ) (sB : S B) → Type _
StructuredEquiv S A sA B sB = Σ[ e ∈ (A ≃ B) ] Defect {S = S} e sA sB

-- T15.84.  `e` upgrades to a structured equivalence exactly when its
-- defect type is inhabited.  Both directions, and both are trivial by
-- construction — which is the content: the upgrade condition IS the
-- defect, not a separate side condition someone has to remember.
defect→structured : {S : Str ℓ ℓS} {A B : Type ℓ} {sA : S A} {sB : S B}
                  → (e : A ≃ B) → Defect {S = S} e sA sB
                  → StructuredEquiv S A sA B sB
defect→structured e d = e , d

structured→defect : {S : Str ℓ ℓS} {A B : Type ℓ} {sA : S A} {sB : S B}
                  → (se : StructuredEquiv S A sA B sB)
                  → Defect {S = S} (fst se) sA sB
structured→defect se = snd se

-- The identity equivalence never has a defect: transporting along
-- `ua (idEquiv A)` is the identity.  (T15.1/T15.2 specialised.)
defect-id : {S : Str ℓ ℓS} {A : Type ℓ} (sA : S A)
          → Defect {S = S} (idEquiv A) sA sA
defect-id {S = S} sA =
  cong (λ p → subst S p sA) uaIdEquiv ∙ substRefl {B = S} sA

-- Defects compose: if the structure transports along `e` and along `f`,
-- it transports along their composite.  This is T15.57 in the form the
-- machine needs — a library of sound actions is closed under composition,
-- so soundness only ever has to be checked on generators.
defect-comp : {S : Str ℓ ℓS} {A B C : Type ℓ}
              {sA : S A} {sB : S B} {sC : S C}
            → (e : A ≃ B) (f : B ≃ C)
            → Defect {S = S} e sA sB
            → Defect {S = S} f sB sC
            → Defect {S = S} (compEquiv e f) sA sC
defect-comp {S = S} {sA = sA} e f de df =
    cong (λ p → subst S p sA) (uaCompEquiv e f)
  ∙ substComposite S (ua e) (ua f) sA
  ∙ cong (subst S (ua f)) de
  ∙ df

------------------------------------------------------------------------
-- §15.10  Descent through a quotient: the loop's soundness condition
--
-- C15.41: the kernel pair, not the quotient label, is the exact carrier
-- of which distinctions must be irrelevant for descent.  In the machine:
-- an installed compression is a surjection q, an admitted action is a
-- map f, and "the action is sound" means f descends through q.
------------------------------------------------------------------------

module Descent {X : Type ℓ} {Z : Type ℓ'} (q : X → Z) where

  -- D15.39.  The kernel pair, as a relation.
  KernelPair : X → X → Type ℓ'
  KernelPair x x' = q x ≡ q x'

  -- The coequalization condition of T15.40.
  Respects : {Y : Type ℓ'} → (X → Y) → Type _
  Respects f = ∀ x x' → KernelPair x x' → f x ≡ f x'

  -- What it means for f to descend: a map on the quotient that agrees.
  Descends : {Y : Type ℓ'} → (X → Y) → Type _
  Descends {Y = Y} f = Σ[ g ∈ (Z → Y) ] (∀ x → g (q x) ≡ f x)

  -- T15.40, the easy direction and the one the machine actually uses:
  -- if the action descends, it cannot separate kernel-pair-related
  -- states.  This is why a reopening is detectable at all.
  descends→respects : {Y : Type ℓ'} (f : X → Y) → Descends f → Respects f
  descends→respects f (g , h) x x' k =
    sym (h x) ∙ cong g k ∙ h x'

  -- The converse needs the quotient to be effective; for a general q it
  -- is false, and saying so is the point of C15.41.  For a SURJECTIVE q
  -- with a chosen section the converse holds, and the section is exactly
  -- the "declared convention" the kuṭṭaka lane insists must be imported
  -- rather than derived.
  respects→descends : {Y : Type ℓ'} (f : X → Y)
                    → (s : Z → X) → (∀ z → q (s z) ≡ z)
                    → Respects f → Descends f
  respects→descends f s sect r =
    (λ z → f (s z)) , λ x → r (s (q x)) x (sect (q x))

-- The loop's REOPEN phase, named as a type rather than a counter.
-- An admitted action reopens an installed compression exactly when the
-- descent data is absent.
Reopens : {X : Type ℓ} {Z Y : Type ℓ'} (q : X → Z) (f : X → Y) → Type _
Reopens q f = ¬ (Descent.Descends q f)

-- ... and reopening is detected by a single separated pair.  This is the
-- exact object the Rust loop's "one-step correction" is counting, and
-- counting it loses which pair it was.
separatedPair→reopens :
    {X : Type ℓ} {Z Y : Type ℓ'} (q : X → Z) (f : X → Y)
  → (Σ[ x ∈ X ] Σ[ x' ∈ X ] (q x ≡ q x') × (¬ (f x ≡ f x')))
  → Reopens q f
separatedPair→reopens q f (x , x' , k , sep) d =
  sep (Descent.descends→respects q f d x x' k)

------------------------------------------------------------------------
-- §15.19  No-go knowledge as negative type information
--
-- "Executable pruning without special refutation edges."  The corpus
-- keeps a walk ledger of dead routes; this says the ledger entries are
-- terms, and that they move.
------------------------------------------------------------------------

-- T15.68 / C15.69.  Refutations propagate contravariantly: to refute B
-- it suffices to construct B → A for an already-refuted A.
refute-pullback : {A : Type ℓ} {B : Type ℓ'}
                → (A → ⊥) → (B → A) → (B → ⊥)
refute-pullback f g = λ b → f (g b)

-- T15.70 / C15.71.  A refutation transports across equivalence exactly
-- as a positive theorem does — no special machinery, just the inverse.
refute-transport : {A B : Type ℓ} → A ≃ B → (A → ⊥) → (B → ⊥)
refute-transport e f = λ b → f (invEq e b)

------------------------------------------------------------------------
-- §15.23  The equivalence–defect dichotomy
--
-- T15.81: if f is not an equivalence, some homotopy fiber is empty or
-- non-contractible.  C15.82: every failed equivalence contains a precise
-- reconstruction question in its fibers.
--
-- Stated constructively, in the direction that is usable: exhibiting a
-- bad fiber REFUTES equivalence, and the exhibited fiber is the question.
------------------------------------------------------------------------

emptyFiber→¬isEquiv : {A : Type ℓ} {B : Type ℓ'} (f : A → B)
                    → (Σ[ b ∈ B ] (fiber f b → ⊥))
                    → ¬ (isEquiv f)
emptyFiber→¬isEquiv f (b , noPre) eq = noPre (equiv-proof eq b .fst)

-- Two points in one fiber that are not equal: the fiber is inhabited but
-- not contractible, so f identifies what it should not.  In the machine
-- this is a collision, and Delta 15's reading is the operative one — the
-- collision is not a failure, it is a specification of the missing
-- distinction.
twoPoints→¬isEquiv : {A : Type ℓ} {B : Type ℓ'} (f : A → B)
                   → (Σ[ b ∈ B ] Σ[ u ∈ fiber f b ] Σ[ v ∈ fiber f b ] (¬ (u ≡ v)))
                   → ¬ (isEquiv f)
twoPoints→¬isEquiv f (b , u , v , sep) eq =
  sep (sym (equiv-proof eq b .snd u) ∙ equiv-proof eq b .snd v)

------------------------------------------------------------------------
-- Program 15.90  A finite example where bare equivalence survives but
-- structured equivalence fails.
--
-- Carrier: Bool, twice.  Bare equivalence: `not`, which is an
-- equivalence Bool ≃ Bool.  Structure: a distinguished point.  The
-- structure does NOT transport — `not` carries `true` to `false` — so
-- the defect type at (true, true) is uninhabited while the carriers are
-- equivalent.  This is C15.7 made concrete: the apparent failure of
-- univalent transport is a failure to include the structure in the
-- object.
------------------------------------------------------------------------

Pointed : Type₀ → Type₀
Pointed A = A

notEquiv : Bool ≃ Bool
notEquiv = isoToEquiv (iso not not law law)
  where
    law : (b : Bool) → not (not b) ≡ b
    law true  = refl
    law false = refl

-- Transporting the point `true` along `ua notEquiv` gives `false`.
witness-transport : subst Pointed (ua notEquiv) true ≡ false
witness-transport = uaβ notEquiv true

-- Hence the defect at (true, true) is uninhabited: the bare equivalence
-- does not upgrade.  The carriers are equivalent; the STRUCTURES are not.
witness-defect : ¬ (Defect {S = Pointed} notEquiv true true)
witness-defect d = false≢true (sym witness-transport ∙ d)

-- Positive control, so the statement above is a fact about this structure
-- and not about an always-empty type: at (true, false) the defect IS
-- inhabited, and the same bare equivalence DOES upgrade.
witness-defect-positive : Defect {S = Pointed} notEquiv true false
witness-defect-positive = witness-transport

witness-structured : StructuredEquiv Pointed Bool true Bool false
witness-structured =
  defect→structured {S = Pointed} {sA = true} {sB = false}
    notEquiv witness-defect-positive
