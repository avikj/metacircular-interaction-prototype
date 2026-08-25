{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ResponseCharacterKickback
--
-- The exact algebraic boundary behind response-register phase kickback.
-- A response group acts by translations on a state space.  If one returned
-- response state is a simultaneous eigenstate for every translation, with a
-- faithful ±1 phase action, then the induced phase map is a character.
--
-- Consequences checked below:
--
--   * Z/2 has the nontrivial sign character used by Boolean phase kickback;
--   * every sign character of Z/3 is trivial;
--   * therefore additive-trit response translation has no clean one-query
--     character-state realization of a nonconstant ±1 threshold phase.
--
-- This is the algebraic interface theorem, not a Hilbert-space library.  A
-- nonzero complex response vector supplies the faithful sign action, and the
-- usual translation operators supply the representation laws.  That standard
-- quantum realization is cited and scoped in
-- notes/RESPONSE_CHARACTER_KICKBACK_BOUNDARY.md.
------------------------------------------------------------------------

module ResponseCharacterKickback where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty using (⊥ ; elim)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1. The sign group {+1,-1}.
------------------------------------------------------------------------

data Sign : Type₀ where
  plus minus : Sign

_·s_ : Sign → Sign → Sign
plus  ·s b     = b
minus ·s plus  = minus
minus ·s minus = plus

infixl 7 _·s_

·s-unitˡ : (a : Sign) → plus ·s a ≡ a
·s-unitˡ a = refl

·s-comm : (a b : Sign) → a ·s b ≡ b ·s a
·s-comm plus  plus  = refl
·s-comm plus  minus = refl
·s-comm minus plus  = refl
·s-comm minus minus = refl

·s-cube : (a : Sign) → (a ·s a) ·s a ≡ a
·s-cube plus  = refl
·s-cube minus = refl

sign-code : Sign → Bool
sign-code plus  = true
sign-code minus = false

plus≢minus : ¬ (plus ≡ minus)
plus≢minus p = true≢false (cong sign-code p)

------------------------------------------------------------------------
-- 2. A phase space and a response-translation representation.
--
-- `faithful-at` is the exact nonzero-state hypothesis used in the familiar
-- Hilbert-space proof: +η = -η implies η = 0, so a nonzero η distinguishes
-- the two signs.  Keeping it as a field avoids importing an undeclared scalar
-- or norm structure.
------------------------------------------------------------------------

record PhaseSpace (S : Type₀) : Type₀ where
  field
    scale       : Sign → S → S
    scale-plus  : (x : S) → scale plus x ≡ x
    scale-mul   : (a b : Sign) (x : S)
                → scale (a ·s b) x ≡ scale a (scale b x)

record TranslationRepresentation
  (G S : Type₀) (_∙_ : G → G → G) (e : G)
  (P : PhaseSpace S) : Type₀ where
  open PhaseSpace P
  field
    move        : G → S → S
    move-unit   : (x : S) → move e x ≡ x
    move-mul    : (g h : G) (x : S)
                → move (g ∙ h) x ≡ move g (move h x)
    move-scale  : (g : G) (a : Sign) (x : S)
                → move g (scale a x) ≡ scale a (move g x)

record CleanKickback
  (G S : Type₀) (_∙_ : G → G → G) (e : G)
  (P : PhaseSpace S)
  (R : TranslationRepresentation G S _∙_ e P) : Type₀ where
  open PhaseSpace P
  open TranslationRepresentation R
  field
    response-state : S
    phase          : G → Sign
    eigen          : (g : G)
                   → move g response-state ≡ scale (phase g) response-state
    faithful-at    : (a b : Sign)
                   → scale a response-state ≡ scale b response-state
                   → a ≡ b

record Character (G : Type₀) (_∙_ : G → G → G) (e : G) : Type₀ where
  field
    char      : G → Sign
    char-unit : char e ≡ plus
    char-mul  : (g h : G) → char (g ∙ h) ≡ char g ·s char h

------------------------------------------------------------------------
-- 3. Returned clean kickback phases are characters.
------------------------------------------------------------------------

clean-kickback-character :
  {G S : Type₀} {_∙_ : G → G → G} {e : G}
  {P : PhaseSpace S}
  {R : TranslationRepresentation G S _∙_ e P}
  → CleanKickback G S _∙_ e P R
  → Character G _∙_ e
clean-kickback-character
  {G = G} {S = S} {_∙_ = op} {e = e} {P = P} {R = R} K = record
  { char      = phase
  ; char-unit = unit-law
  ; char-mul  = mul-law
  }
  where
  open PhaseSpace P
  open TranslationRepresentation R
  open CleanKickback K

  unit-scaled : scale (phase e) response-state ≡ scale plus response-state
  unit-scaled =
      sym (eigen e)
    ∙ move-unit response-state
    ∙ sym (scale-plus response-state)

  unit-law : phase e ≡ plus
  unit-law = faithful-at (phase e) plus unit-scaled

  mul-scaled : (g h : G) →
    scale (phase (op g h)) response-state
      ≡ scale (phase g ·s phase h) response-state
  mul-scaled g h =
      sym (eigen (op g h))
    ∙ move-mul g h response-state
    ∙ cong (move g) (eigen h)
    ∙ move-scale g (phase h) response-state
    ∙ cong (scale (phase h)) (eigen g)
    ∙ sym (scale-mul (phase h) (phase g) response-state)
    ∙ cong (λ a → scale a response-state) (·s-comm (phase h) (phase g))

  mul-law : (g h : G) → phase (op g h) ≡ phase g ·s phase h
  mul-law g h = faithful-at _ _ (mul-scaled g h)

------------------------------------------------------------------------
-- 4. Boolean response: the nontrivial character exists.
------------------------------------------------------------------------

data Z2 : Type₀ where
  b0 b1 : Z2

_+₂_ : Z2 → Z2 → Z2
b0 +₂ y  = y
b1 +₂ b0 = b1
b1 +₂ b1 = b0

bit-phase : Z2 → Sign
bit-phase b0 = plus
bit-phase b1 = minus

bit-phase-mul : (a b : Z2) → bit-phase (a +₂ b) ≡ bit-phase a ·s bit-phase b
bit-phase-mul b0 b0 = refl
bit-phase-mul b0 b1 = refl
bit-phase-mul b1 b0 = refl
bit-phase-mul b1 b1 = refl

bit-character : Character Z2 _+₂_ b0
bit-character = record
  { char      = bit-phase
  ; char-unit = refl
  ; char-mul  = bit-phase-mul
  }

bit-character-is-nontrivial : Character.char bit-character b1 ≡ minus
bit-character-is-nontrivial = refl

------------------------------------------------------------------------
-- 5. Additive trit response: every sign character is trivial.
------------------------------------------------------------------------

data Z3 : Type₀ where
  t0 t1 t2 : Z3

_+₃_ : Z3 → Z3 → Z3
t0 +₃ y  = y
t1 +₃ t0 = t1
t1 +₃ t1 = t2
t1 +₃ t2 = t0
t2 +₃ t0 = t2
t2 +₃ t1 = t0
t2 +₃ t2 = t1

trit-one-plus : (χ : Character Z3 _+₃_ t0)
              → Character.char χ t1 ≡ plus
trit-one-plus χ = sym
  (  sym (Character.char-unit χ)
   ∙ Character.char-mul χ t2 t1
   ∙ cong (λ a → a ·s Character.char χ t1)
          (Character.char-mul χ t1 t1)
   ∙ ·s-cube (Character.char χ t1))

trit-two-plus : (χ : Character Z3 _+₃_ t0)
              → Character.char χ t2 ≡ plus
trit-two-plus χ =
    Character.char-mul χ t1 t1
  ∙ cong₂ _·s_ (trit-one-plus χ) (trit-one-plus χ)

trit-character-trivial : (χ : Character Z3 _+₃_ t0) (t : Z3)
                       → Character.char χ t ≡ plus
trit-character-trivial χ t0 = Character.char-unit χ
trit-character-trivial χ t1 = trit-one-plus χ
trit-character-trivial χ t2 = trit-two-plus χ

NonconstantSign : Character Z3 _+₃_ t0 → Type₀
NonconstantSign χ = Σ[ t ∈ Z3 ] Character.char χ t ≡ minus

no-nonconstant-trit-sign : (χ : Character Z3 _+₃_ t0)
                         → ¬ (NonconstantSign χ)
no-nonconstant-trit-sign χ (t , marked) =
  plus≢minus (sym (trit-character-trivial χ t) ∙ marked)

-- Directly on a clean adapter: any nonconstant sign phase is impossible.
no-clean-trit-threshold :
  {S : Type₀} {P : PhaseSpace S}
  {R : TranslationRepresentation Z3 S _+₃_ t0 P}
  (K : CleanKickback Z3 S _+₃_ t0 P R)
  → ¬ (NonconstantSign (clean-kickback-character K))
no-clean-trit-threshold K =
  no-nonconstant-trit-sign (clean-kickback-character K)
