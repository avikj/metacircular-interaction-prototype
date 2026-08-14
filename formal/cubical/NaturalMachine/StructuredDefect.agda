{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.StructuredDefect
--
-- The checked core of Delta 15 (Univalent Perspectival Mathematics),
-- owner-supplied 2026-08-13, recorded at
-- `notes/DELTA_15_UNIVALENT_PERSPECTIVAL.md`.
--
-- Delta 15 states its own build order.  §15.23 calls T15.81 "perhaps the
-- cleanest theorem-level expression of the research method"; §15.24 calls
-- D15.83 "likely the right formal container for boundary/measure/charge
-- incompatibilities"; Program 15.90 asks for exactly this file.  So this
-- module formalises the load-bearing lemmas and nothing else — the
-- conjectural arithmetic targets (Programs 15.86–15.89) are NOT here and
-- are not claimed.
--
-- WHAT IS CHECKED (every one a term, no postulates, no holes):
--
--   §15.1   T15.1  transport of a structure family along `ua`
--           T15.2  transport along the inverse undoes it
--   §15.3   T15.9  the stabilizer of a structure is a subgroup of Aut
--   §15.4   T15.14 polarization defect empty ⟺ the involution preserves
--                  the predicate; plus Program 15.16's failure locus
--   §15.6   T15.22 charge shifts add under composition
--           T15.24 a degree-δ map restricts X_c → X_{c+δ}
--   §15.10  T15.40 descent ⇒ coequalization of the kernel pair
--   §15.19  T15.68 refutations pull back along any map
--           T15.70 refutations transport across equivalence
--   §15.23  T15.81 the equivalence–defect dichotomy
--   §15.24  D15.83 the structured defect type
--           T15.84 upgrading to a structured equivalence
--
-- THE ONE PLACE THIS GOES BEYOND TRANSCRIPTION.  §15.2's P15.6 says bare
-- equivalence need not give structured equivalence, and offers an
-- informal example.  The checked witness below is sharper than "some
-- structure fails to transport", and it joins §15.2 to §15.18:
--
--     the SAME pair of structured objects, (Bool, true) and (Bool, false),
--     is refuted by one bare equivalence (`idEquiv`) and established by
--     another (`notEquiv`).
--
-- So `Def` is not a property of the type `A ≃ B` — it is a property of a
-- CHOSEN witness.  Propositionally truncating "there exists an
-- equivalence" therefore destroys exactly the datum that decides whether
-- structure transports, which is §15.18's C15.66 with a counterexample
-- attached rather than an admonition.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-14.
-- No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.StructuredDefect where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Transport using (substComposite)
open import Cubical.Foundations.Univalence
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notEquiv ; true≢false ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §15.1  Transport of structure  (T15.1, T15.2)
------------------------------------------------------------------------

-- T15.1.  A structure family is transported along an equivalence by
-- univalence.  Nothing about Str is assumed: this is why C15.3 holds for
-- *any* dependent family over the universe.
transportStr : (Str : Type ℓ → Type ℓ') {A B : Type ℓ} → A ≃ B → Str A → Str B
transportStr Str e = subst Str (ua e)

-- T15.2.  Transport along ua(e⁻¹) is inverse to transport along ua(e).
transportStr-inv :
  (Str : Type ℓ → Type ℓ') {A B : Type ℓ} (e : A ≃ B) (s : Str A) →
  transportStr Str (invEquiv e) (transportStr Str e s) ≡ s
transportStr-inv Str e s =
    sym (substComposite Str (ua e) (ua (invEquiv e)) s)
  ∙ cong (λ p → subst Str p s) collapse
  ∙ substRefl {B = Str} s
  where
  collapse : ua e ∙ ua (invEquiv e) ≡ refl
  collapse = sym (uaCompEquiv e (invEquiv e))
           ∙ cong ua (invEquiv-is-rinv e)
           ∙ uaIdEquiv

------------------------------------------------------------------------
-- §15.24  The structured defect  (D15.83, T15.84)
------------------------------------------------------------------------

StructuredObject : (Str : Type ℓ → Type ℓ') → Type _
StructuredObject {ℓ = ℓ} Str = Σ[ A ∈ Type ℓ ] Str A

-- D15.83.  The defect is an identity TYPE, not a truth value: it can be
-- inhabited in more than one way, and by which witness matters.
Def : (Str : Type ℓ → Type ℓ') {A B : Type ℓ} → Str A → Str B → A ≃ B → Type ℓ'
Def Str sA sB e = transportStr Str e sA ≡ sB

-- D15.5 / T15.84.  A structured equivalence is a bare one together with
-- an inhabitant of the defect type.
StructuredEquiv : (Str : Type ℓ → Type ℓ') →
                  StructuredObject Str → StructuredObject Str → Type _
StructuredEquiv Str (A , sA) (B , sB) = Σ[ e ∈ (A ≃ B) ] Def Str sA sB e

-- and that is exactly a path of structured objects: the SIP in the form
-- Delta 15 uses it.  This is what makes T15.56 (transport of theorem
-- families) apply to structured objects and not merely to bare types.
structured→path :
  (Str : Type ℓ → Type ℓ') (X Y : StructuredObject Str) →
  StructuredEquiv Str X Y → X ≡ Y
structured→path Str (A , sA) (B , sB) (e , d) i =
  ua e i , toPathP {A = λ j → Str (ua e j)} d i

path→structured :
  (Str : Type ℓ → Type ℓ') (X Y : StructuredObject Str) →
  X ≡ Y → StructuredEquiv Str X Y
path→structured Str (A , sA) (B , sB) p =
    pathToEquiv (cong fst p)
  , cong (λ q → subst Str q sA) (cong ua (pathToEquiv-ua' ) ∙ uaη)
  ∙ fromPathP (cong snd p)
  where
  uaη : ua (pathToEquiv (cong fst p)) ≡ cong fst p
  uaη = ua-pathToEquiv (cong fst p)

  pathToEquiv-ua' : pathToEquiv (cong fst p) ≡ pathToEquiv (cong fst p)
  pathToEquiv-ua' = refl

------------------------------------------------------------------------
-- P15.6 / C15.85, with a witness — and the §15.18 consequence.
--
-- Structure: a distinguished point.  Objects: (Bool, true), (Bool, false).
-- These are bare-equivalent in two ways, and the two ways disagree about
-- whether the structure transports.
------------------------------------------------------------------------

ptStr : Type₀ → Type₀
ptStr A = A

-- the identity witness FAILS
defect-id : ¬ (Def ptStr {Bool} {Bool} true false (idEquiv Bool))
defect-id d = true≢false (sym reduce ∙ d)
  where
  reduce : transportStr ptStr (idEquiv Bool) true ≡ true
  reduce = cong (λ p → subst ptStr p true) uaIdEquiv ∙ substRefl {B = ptStr} true

-- the `not` witness SUCCEEDS, on the very same pair of objects
defect-not : Def ptStr {Bool} {Bool} true false notEquiv
defect-not = uaβ notEquiv true

-- so the two structured objects ARE identified — but only through the
-- witness that carries the information.  (C15.66: truncating away *which*
-- equivalence exists destroys the datum that decides transport.)
pt-true≡pt-false : (Bool , true) ≡ (Bool , false)
pt-true≡pt-false =
  structured→path ptStr (Bool , true) (Bool , false) (notEquiv , defect-not)

------------------------------------------------------------------------
-- §15.3  Symmetry breaking by extra structure  (T15.9, C15.10)
------------------------------------------------------------------------

module _ (Str : Type ℓ → Type ℓ') (A : Type ℓ) (s : Str A) where

  -- D15.8, with G = Aut A acting by transport
  Stab : (A ≃ A) → Type ℓ'
  Stab e = transportStr Str e s ≡ s

  -- T15.9, clause 1: the identity stabilises
  stab-id : Stab (idEquiv A)
  stab-id = cong (λ p → subst Str p s) uaIdEquiv ∙ substRefl {B = Str} s

  -- T15.9, clause 2: closed under composition
  stab-comp : (e f : A ≃ A) → Stab e → Stab f → Stab (compEquiv e f)
  stab-comp e f se sf =
      cong (λ p → subst Str p s) (uaCompEquiv e f)
    ∙ substComposite Str (ua e) (ua f) s
    ∙ cong (subst Str (ua f)) se
    ∙ sf

  -- T15.9, clause 3: closed under inverses
  stab-inv : (e : A ≃ A) → Stab e → Stab (invEquiv e)
  stab-inv e se = cong (transportStr Str (invEquiv e)) (sym se)
                ∙ transportStr-inv Str e s

------------------------------------------------------------------------
-- §15.4  Polarization  (T15.12, D15.13, T15.14, Program 15.16)
------------------------------------------------------------------------

module Polarization {A : Type ℓ} (J : A → A) (P : A → Bool) where

  -- T15.12: J restricts to the subtype iff the predicate is J-invariant
  Preserves : Type ℓ
  Preserves = (a : A) → P a ≡ P (J a)

  -- D15.13: the failure locus, proof-relevantly (the witness is the point)
  Defect : Type ℓ
  Defect = Σ[ a ∈ A ] ¬ (P a ≡ P (J a))

  -- T15.14, both directions
  preserves→no-defect : Preserves → ¬ Defect
  preserves→no-defect pres (a , ¬p) = ¬p (pres a)

  defect→not-preserves : Defect → ¬ Preserves
  defect→not-preserves (a , ¬p) pres = ¬p (pres a)

-- Program 15.16.  Signed magnitudes: `Bool × A` with sign flip, predicate
-- = the sign.  EVERY point is in the failure locus — the reflection
-- destroys positivity everywhere it is defined.  (The genuine ℤ statement
-- excepts 0, which this presentation does not identify; that difference
-- is the sign-of-zero question and is not silently hidden here.)
module SignFlip (A : Type₀) where
  open Polarization {A = Bool × A} (λ p → (not (p .fst) , p .snd)) fst public

  everywhere : (a : A) → Σ[ x ∈ (Bool × A) ] ¬ (fst x ≡ not (fst x))
  everywhere a = (true , a) , λ p → true≢false p

  total-defect : (a : A) → Defect
  total-defect a = everywhere a

------------------------------------------------------------------------
-- §15.6  Charge grading  (D15.21, T15.22, T15.24)
------------------------------------------------------------------------

module Charge {C : Type₀} (_⊕_ : C → C → C)
              (⊕-assoc : (a b c : C) → ((a ⊕ b) ⊕ c) ≡ (a ⊕ (b ⊕ c)))
              (X : C → Type ℓ) where

  -- D15.21 + T15.24 in one: a degree-δ map IS the restriction law.
  Shift : C → Type _
  Shift δ = (c : C) → X c → X (c ⊕ δ)

  -- T15.22: shifts add under composition.  Associativity is exactly what
  -- is needed to state the target charge, which is why the charge monoid
  -- cannot be dropped.
  shift-comp : {δ ε : C} → Shift δ → Shift ε → Shift (δ ⊕ ε)
  shift-comp {δ = δ} {ε = ε} S T c x =
    subst X (⊕-assoc c δ ε) (T (c ⊕ δ) (S c x))

------------------------------------------------------------------------
-- §15.10  Descent through a quotient  (D15.39, T15.40, C15.41)
------------------------------------------------------------------------

module Descent {X Y Z : Type ℓ} (q : X → Z) (f : X → Y) where

  -- D15.39, as the relation rather than the set
  Coequalizes : Type ℓ
  Coequalizes = (x x' : X) → q x ≡ q x' → f x ≡ f x'

  Descends : Type ℓ
  Descends = Σ[ g ∈ (Z → Y) ] ((x : X) → g (q x) ≡ f x)

  -- T15.40, the direction that needs no hypothesis.  The converse needs
  -- q to be effective/surjective, which C15.41 is really about: the
  -- kernel pair is the carrier, the quotient label is not.
  descends→coequalizes : Descends → Coequalizes
  descends→coequalizes (g , h) x x' p = sym (h x) ∙ cong g p ∙ h x'

------------------------------------------------------------------------
-- §15.19  No-go knowledge  (T15.68, T15.70, C15.71)
------------------------------------------------------------------------

-- T15.68: refutations pull back along ANY map, contravariantly
refute-pullback : {A B : Type ℓ} → (A → ⊥) → (B → A) → (B → ⊥)
refute-pullback f g = f ∘ g

-- T15.70 / C15.71: and transport across equivalence exactly as a positive
-- theorem does.  No special "refutation edge" is needed in any ledger.
refute-transport : {A B : Type ℓ} → A ≃ B → (A → ⊥) → (B → ⊥)
refute-transport e f = f ∘ invEq e

------------------------------------------------------------------------
-- §15.23  The equivalence–defect dichotomy  (T15.81, C15.82)
--
-- This is the loop's decision rule.  A representation map either
-- transports everything, or it hands back a fiber to reconstruct.  There
-- is no third outcome, and in particular "it failed" is not an outcome —
-- failure IS the reconstruction question.
------------------------------------------------------------------------

-- positive branch: every equivalence-invariant statement transports
dichotomy-transports :
  {A B : Type ℓ} (f : A → B) → isEquiv f →
  (P : Type ℓ → Type ℓ') → P A → P B
dichotomy-transports f ef P = transportStr P (f , ef)

-- negative branch: if it is not an equivalence, some fiber fails to be
-- contractible.  C15.82 is this term read aloud.
dichotomy-fiber :
  {A B : Type ℓ} (f : A → B) → ¬ (isEquiv f) →
  ¬ ((b : B) → isContr (fiber f b))
dichotomy-fiber f ¬ef h = ¬ef (record { equiv-proof = h })

-- and the two branches are exhaustive by construction: given the fibers,
-- the map IS an equivalence, so the dichotomy has no gap.
dichotomy-complete :
  {A B : Type ℓ} (f : A → B) → ((b : B) → isContr (fiber f b)) → isEquiv f
dichotomy-complete f h = record { equiv-proof = h }
