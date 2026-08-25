{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- QuadraticRefinement
--
-- The structure behind the Peres--Mermin square, in the proof language.
--
-- Over F_2 a Pauli scenario carries two data: an alternating form B
-- (which operators commute) and a *quadratic refinement* q of it
-- (which sign a chosen operator section picks up).  Concretely, for
-- V(x,z) = X^x Z^z one has V(a)^2 = (-1)^(x.z) I, so q(x,z) = x.z, and
--
--     q (a + b)  =  q a  xor  q b  xor  B a b .
--
-- Everything my Python witnesses computed about the two-qubit case is
-- downstream of two facts proved here:
--
--   * `difference-additive`: any two refinements of the *same* B differ
--     by an additive map;
--   * `shift-refines`: conversely, shifting a refinement by an additive
--     map is again a refinement.
--
-- Together these say the refinements of a fixed B form a torsor under
-- Hom(V, F_2).  For V = F_2^(2n) that is 2^(2n) refinements -- 16 for
-- two qubits, which split 10 + 6 by Arf type.  The 10 is exactly the
-- number of Mermin squares, which an exhaustive Python sweep had to
-- discover by enumeration and which this makes structural.
--
-- Also proved: the concrete one-qubit refinement q(x,z) = x AND z has
-- polarization the one-qubit symplectic form, and refinements add
-- along a direct sum.  Iterating the sum gives every n.
--
-- Scope.  This is the F_2 quadratic/symplectic bookkeeping only.  It
-- does not formalize operators, measurement, memory, or contextuality;
-- those live in machinery/pauli_context_memory.py and the notes.  See
-- notes/PAULI_MEMORY_LAGRANGIAN.md and notes/ARF_MERMIN_CLASSIFICATION.md.
------------------------------------------------------------------------

module QuadraticRefinement where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
open import Cubical.Data.Sigma

private
  variable
    ℓ ℓ′ : Level

------------------------------------------------------------------------
-- xor rearrangements, by exhaustion on Bool
------------------------------------------------------------------------

xor-cancel : (u v w : Bool) → ((u ⊕ w) ⊕ (v ⊕ w)) ≡ (u ⊕ v)
xor-cancel false false false = refl
xor-cancel false false true  = refl
xor-cancel false true  false = refl
xor-cancel false true  true  = refl
xor-cancel true  false false = refl
xor-cancel true  false true  = refl
xor-cancel true  true  false = refl
xor-cancel true  true  true  = refl

xor-rot : (p c s : Bool) → ((p ⊕ c) ⊕ s) ≡ ((p ⊕ s) ⊕ c)
xor-rot false false false = refl
xor-rot false false true  = refl
xor-rot false true  false = refl
xor-rot false true  true  = refl
xor-rot true  false false = refl
xor-rot true  false true  = refl
xor-rot true  true  false = refl
xor-rot true  true  true  = refl

xor-exchange : (u v w x : Bool) → ((u ⊕ v) ⊕ (w ⊕ x)) ≡ ((u ⊕ w) ⊕ (v ⊕ x))
xor-exchange false false false false = refl
xor-exchange false false false true  = refl
xor-exchange false false true  false = refl
xor-exchange false false true  true  = refl
xor-exchange false true  false false = refl
xor-exchange false true  false true  = refl
xor-exchange false true  true  false = refl
xor-exchange false true  true  true  = refl
xor-exchange true  false false false = refl
xor-exchange true  false false true  = refl
xor-exchange true  false true  false = refl
xor-exchange true  false true  true  = refl
xor-exchange true  true  false false = refl
xor-exchange true  true  false true  = refl
xor-exchange true  true  true  false = refl
xor-exchange true  true  true  true  = refl

------------------------------------------------------------------------
-- the two predicates
------------------------------------------------------------------------

-- `d` is F_2-linear for the given addition.
Additive : {V : Type ℓ} → (V → V → V) → (V → Bool) → Type ℓ
Additive {V = V} _+_ d = (a b : V) → d (a + b) ≡ (d a ⊕ d b)

-- `q` is a quadratic refinement of the form `B`.
Refines : {V : Type ℓ} → (V → V → V) → (V → V → Bool) → (V → Bool) → Type ℓ
Refines {V = V} _+_ B q = (a b : V) → q (a + b) ≡ ((q a ⊕ q b) ⊕ B a b)

------------------------------------------------------------------------
-- the torsor theorem
------------------------------------------------------------------------

-- Any two refinements of the *same* form differ by an additive map.
difference-additive :
  {V : Type ℓ} (_+_ : V → V → V) (B : V → V → Bool) (q q′ : V → Bool)
  → Refines _+_ B q → Refines _+_ B q′
  → Additive _+_ (λ a → q a ⊕ q′ a)
difference-additive _+_ B q q′ hq hq′ a b =
    cong₂ _⊕_ (hq a b) (hq′ a b)
  ∙ xor-cancel (q a ⊕ q b) (q′ a ⊕ q′ b) (B a b)
  ∙ xor-exchange (q a) (q b) (q′ a) (q′ b)

-- Conversely, shifting a refinement by an additive map is a refinement.
shift-refines :
  {V : Type ℓ} (_+_ : V → V → V) (B : V → V → Bool) (q d : V → Bool)
  → Refines _+_ B q → Additive _+_ d
  → Refines _+_ B (λ a → q a ⊕ d a)
shift-refines _+_ B q d hq hd a b =
    cong₂ _⊕_ (hq a b) (hd a b)
  ∙ ⊕-assoc ((q a ⊕ q b) ⊕ B a b) (d a) (d b)
  ∙ cong (_⊕ d b) (xor-rot (q a ⊕ q b) (B a b) (d a))
  ∙ xor-rot ((q a ⊕ q b) ⊕ d a) (B a b) (d b)
  ∙ cong (_⊕ B a b) ( sym (⊕-assoc (q a ⊕ q b) (d a) (d b))
                    ∙ xor-exchange (q a) (q b) (d a) (d b))

------------------------------------------------------------------------
-- refinements add along a direct sum of symplectic spaces
------------------------------------------------------------------------

module _ {V : Type ℓ} {W : Type ℓ′}
         (_+V_ : V → V → V) (_+W_ : W → W → W)
         (BV : V → V → Bool) (BW : W → W → Bool)
         (qV : V → Bool)     (qW : W → Bool)
         where

  sum-add : V × W → V × W → V × W
  sum-add (a , u) (b , v) = ((a +V b) , (u +W v))

  sum-form : V × W → V × W → Bool
  sum-form (a , u) (b , v) = BV a b ⊕ BW u v

  sum-quad : V × W → Bool
  sum-quad (a , u) = qV a ⊕ qW u

  sum-refines :
      Refines _+V_ BV qV → Refines _+W_ BW qW
    → Refines sum-add sum-form sum-quad
  sum-refines hV hW (a , u) (b , v) =
      cong₂ _⊕_ (hV a b) (hW u v)
    ∙ xor-exchange (qV a ⊕ qV b) (BV a b) (qW u ⊕ qW v) (BW u v)
    ∙ cong (_⊕ (BV a b ⊕ BW u v)) (xor-exchange (qV a) (qV b) (qW u) (qW v))

------------------------------------------------------------------------
-- the concrete one-qubit refinement
------------------------------------------------------------------------

-- A qubit's symplectic coordinate: (x , z), with V(x,z) = X^x Z^z.
Qubit : Type
Qubit = Bool × Bool

qubit-add : Qubit → Qubit → Qubit
qubit-add (x , z) (x′ , z′) = ((x ⊕ x′) , (z ⊕ z′))

-- the symplectic form: V(a) and V(b) commute exactly when this is false
qubit-form : Qubit → Qubit → Bool
qubit-form (x , z) (x′ , z′) = (x and z′) ⊕ (x′ and z)

-- V(x,z)^2 = (-1)^(x.z) I
qubit-quad : Qubit → Bool
qubit-quad (x , z) = x and z

qubit-refines : Refines qubit-add qubit-form qubit-quad
qubit-refines (false , false) (false , false) = refl
qubit-refines (false , false) (false , true) = refl
qubit-refines (false , false) (true , false) = refl
qubit-refines (false , false) (true , true) = refl
qubit-refines (false , true) (false , false) = refl
qubit-refines (false , true) (false , true) = refl
qubit-refines (false , true) (true , false) = refl
qubit-refines (false , true) (true , true) = refl
qubit-refines (true , false) (false , false) = refl
qubit-refines (true , false) (false , true) = refl
qubit-refines (true , false) (true , false) = refl
qubit-refines (true , false) (true , true) = refl
qubit-refines (true , true) (false , false) = refl
qubit-refines (true , true) (false , true) = refl
qubit-refines (true , true) (true , false) = refl
qubit-refines (true , true) (true , true) = refl

------------------------------------------------------------------------
-- two qubits: the Peres--Mermin arena
------------------------------------------------------------------------

TwoQubit : Type
TwoQubit = Qubit × Qubit

twoqubit-add : TwoQubit → TwoQubit → TwoQubit
twoqubit-add = sum-add qubit-add qubit-add qubit-form qubit-form qubit-quad qubit-quad

twoqubit-form : TwoQubit → TwoQubit → Bool
twoqubit-form = sum-form qubit-add qubit-add qubit-form qubit-form qubit-quad qubit-quad

twoqubit-quad : TwoQubit → Bool
twoqubit-quad = sum-quad qubit-add qubit-add qubit-form qubit-form qubit-quad qubit-quad

-- The two-qubit symplectic form has an explicit quadratic refinement.
twoqubit-refines : Refines twoqubit-add twoqubit-form twoqubit-quad
twoqubit-refines =
  sum-refines qubit-add qubit-add qubit-form qubit-form
              qubit-quad qubit-quad qubit-refines qubit-refines

-- Hence every other refinement of the two-qubit form is
-- `twoqubit-quad ⊕ d` for exactly one additive `d`, and conversely.
twoqubit-shift :
  (d : TwoQubit → Bool) → Additive twoqubit-add d
  → Refines twoqubit-add twoqubit-form (λ a → twoqubit-quad a ⊕ d a)
twoqubit-shift d hd =
  shift-refines twoqubit-add twoqubit-form twoqubit-quad d twoqubit-refines hd

twoqubit-difference :
  (q′ : TwoQubit → Bool) → Refines twoqubit-add twoqubit-form q′
  → Additive twoqubit-add (λ a → twoqubit-quad a ⊕ q′ a)
twoqubit-difference q′ hq′ =
  difference-additive twoqubit-add twoqubit-form twoqubit-quad q′
                      twoqubit-refines hq′
