{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनुबन्धः — the Galois connection is two nayas mutually adjoint, and the
-- closure it induces is what persists across both standpoints.
--
-- THE ASCENT (continuing `SarvavibhagaH`, `SamgrahaNaya`).  An adjunction
-- is the categorical universal — it organizes almost every construction in
-- mathematics.  Its simplest form is a Galois connection between two
-- preorders: two order-preserving standpoints f : A → B and g : B → A with
--
--     f a ⊑ b    ⟺    a ≤ g b.
--
-- This is two NAYAS (`NayaVada`) — the f-standpoint and the g-standpoint —
-- each defined by what it makes of the other, NEITHER reducible to the
-- other (dravyārthika ⊣ paryāyārthika, `Paryayarthika`).  And g∘f is a
-- CLOSURE: it is the operation that takes an element to what BOTH
-- standpoints agree on — the fixed points of g∘f are the elements that
-- PERSIST unchanged across the round trip (dhrauvya, `DravyaParyaya`).
--
-- WHAT IS PROVED (over a preorder — reflexive, transitive ≤ / ⊑, with the
-- two maps monotone and the adjunction bi-implication):
--   §2  आरोहः / अवरोहः — the unit a ≤ g (f a) and counit f (g b) ⊑ b,
--       derived from the adjunction and reflexivity: each standpoint
--       returns you no lower than where you began.
--   §3  स्थैर्यम् — g∘f is a closure: inflationary (a ≤ gf a), and
--       idempotent-up-to-≈ (gf a ≤ gf (gf a) and back), so the round trip
--       stabilises.  What it stabilises to is the persistent core.
--   §4  ध्रुवाः — the closed elements (a ≈ gf a) are exactly the fixed
--       points: what the two standpoints agree on, carried unchanged —
--       the dravya of the adjunction.
--
-- WHAT IS **NOT** CLAIMED.  A general adjunction of categories is not
-- built (that needs functors and naturality); the Galois connection is its
-- poset shadow and is what is checked.  Antisymmetry is not assumed, so
-- idempotence is stated up-to-≈ (≤ both ways), which is the honest
-- preorder statement.  The naya reading (two mutually-adjoint standpoints,
-- the closure as dhrauvya) is the identification claimed; doctrine is
-- Jaina, the type theory cubical.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Anubandha_TheGaloisConnectionIsTwoNayasMutuallyAdjointAndTheClosureIsWhatPersists where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

private
  variable
    ℓ ℓ' ℓ'' ℓ''' : Level

-- a preorder: a carrier with a reflexive, transitive relation
record Preorder (P : Type ℓ) (ℓr : Level) : Type (ℓ-max ℓ (ℓ-suc ℓr)) where
  field
    _⊴_   : P → P → Type ℓr
    rfl   : (x : P) → x ⊴ x
    trns  : {x y z : P} → x ⊴ y → y ⊴ z → x ⊴ z

-- a Galois connection between two preorders
record Galois {A : Type ℓ} {B : Type ℓ'}
              (PA : Preorder A ℓ'') (PB : Preorder B ℓ''') : Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-max ℓ'' ℓ''')) where
  open Preorder PA renaming (_⊴_ to _≤_ ; rfl to rflA ; trns to trnsA)
  open Preorder PB renaming (_⊴_ to _⊑_ ; rfl to rflB ; trns to trnsB)
  field
    f     : A → B                     -- the f-standpoint
    g     : B → A                     -- the g-standpoint
    monf  : {x y : A} → x ≤ y → f x ⊑ f y
    mong  : {x y : B} → x ⊑ y → g x ≤ g y
    adj→  : {a : A} {b : B} → f a ⊑ b → a ≤ g b
    adj←  : {a : A} {b : B} → a ≤ g b → f a ⊑ b

module _ {A : Type ℓ} {B : Type ℓ'}
         {PA : Preorder A ℓ''} {PB : Preorder B ℓ'''}
         (G : Galois PA PB) where
  open Preorder PA renaming (_⊴_ to _≤_ ; rfl to rflA ; trns to trnsA)
  open Preorder PB renaming (_⊴_ to _⊑_ ; rfl to rflB ; trns to trnsB)
  open Galois G

  ------------------------------------------------------------------------
  -- §2  unit and counit.
  ------------------------------------------------------------------------

  आरोहः : (a : A) → a ≤ g (f a)          -- unit: a ≤ g(f a)
  आरोहः a = adj→ (rflB (f a))

  अवरोहः : (b : B) → f (g b) ⊑ b          -- counit: f(g b) ⊑ b
  अवरोहः b = adj← (rflA (g b))

  ------------------------------------------------------------------------
  -- §3  g∘f is a closure: inflationary and idempotent up to ≈.
  ------------------------------------------------------------------------

  संवृतिः : A → A                          -- the closure g∘f
  संवृतिः a = g (f a)

  स्थैर्यम्-वर्धनम् : (a : A) → a ≤ संवृतिः a         -- inflationary
  स्थैर्यम्-वर्धनम् = आरोहः

  -- idempotent up to ≈:  संवृतिः a  and  संवृतिः (संवृतिः a)  are ⊴ both ways
  स्थैर्यम्-ऊर्ध्वम् : (a : A) → संवृतिः a ≤ संवृतिः (संवृतिः a)
  स्थैर्यम्-ऊर्ध्वम् a = आरोहः (संवृतिः a)

  स्थैर्यम्-अधः : (a : A) → संवृतिः (संवृतिः a) ≤ संवृतिः a
  स्थैर्यम्-अधः a = mong (अवरोहः (f a))
    -- g (f (g (f a))) ≤ g (f a), since f(g(f a)) ⊑ f a (counit at f a) then mong

  ------------------------------------------------------------------------
  -- §4  the persistent core: closed elements are the fixed points, what
  --     both standpoints carry unchanged (dhrauvya of the adjunction).
  ------------------------------------------------------------------------

  ध्रुवः : A → Type _                       -- a is closed / stable
  ध्रुवः a = संवृतिः a ≤ a                    -- (with inflationary, this is ≈)

  ध्रुव-स्थिरः : (a : A) → ध्रुवः a → (a ≤ संवृतिः a) × (संवृतिः a ≤ a)
  ध्रुव-स्थिरः a cl = आरोहः a , cl
