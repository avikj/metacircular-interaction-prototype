{-# OPTIONS --safe #-}

module TheoremCompiledSymmetry where

open import Agda.Builtin.Equality
open import Agda.Builtin.Bool
open import Agda.Builtin.Unit

import TheoremCompiledObservation as TC

open TC.Sufficient
open TC.DescendingAction

------------------------------------------------------------------------
-- Equality and function primitives (kept local to the executable lane)
------------------------------------------------------------------------

sym : {A : Set} {x y : A} → x ≡ y → y ≡ x
sym refl = refl

trans : {A : Set} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
trans refl q = q

cong : {A B : Set} (f : A → B) {x y : A} → x ≡ y → f x ≡ f y
cong f refl = refl

infixr 9 _∘_

_∘_ : {A B C : Set} → (B → C) → (A → B) → A → C
(f ∘ g) x = f (g x)

------------------------------------------------------------------------
-- Descended actions compose
------------------------------------------------------------------------

-- The order is execution order: B runs first, then A.  The descended
-- small actions run in the same order.  This is the semiconjugacy law
-- composed, not a second induction over execution time.
composeDescending :
    {X Q O : Set} {S : TC.Sufficient X Q O}
  → TC.DescendingAction S → TC.DescendingAction S
  → TC.DescendingAction S
composeDescending A B = TC.descending
  (largeStep A ∘ largeStep B)
  (smallStep A ∘ smallStep B)
  (λ x → trans
    (descends A (largeStep B x))
    (cong (smallStep A) (descends B x)))

identityDescending :
    {X Q O : Set} (S : TC.Sufficient X Q O)
  → TC.DescendingAction S
identityDescending S = TC.descending (λ x → x) (λ q → q) (λ x → refl)

------------------------------------------------------------------------
-- Coherence is forced on the realized quotient image
------------------------------------------------------------------------

-- Two small actions descending the same large action must agree wherever
-- the quotient is realized.  They can still differ away from that image.
descended-unique-on-image :
    {X Q O : Set} (S : TC.Sufficient X Q O)
  → (A B : TC.DescendingAction S)
  → ((x : X) → largeStep A x ≡ largeStep B x)
  → (x : X)
  → smallStep A (quotient S x)
    ≡ smallStep B (quotient S x)
descended-unique-on-image S A B sameLarge x =
  trans (sym (descends A x))
    (trans (cong (quotient S) (sameLarge x)) (descends B x))

-- In particular, an independently supplied descent of the identity is the
-- identity on every quotient state that actually comes from X.
identity-unique-on-image :
    {X Q O : Set} (S : TC.Sufficient X Q O)
  → (A : TC.DescendingAction S)
  → ((x : X) → largeStep A x ≡ x)
  → (x : X)
  → smallStep A (quotient S x) ≡ quotient S x
identity-unique-on-image S A sameIdentity =
  descended-unique-on-image S A (identityDescending S) sameIdentity

-- Likewise, an independently supplied descent C of the composite large
-- action agrees, on the image, with the composite of the supplied descents.
composition-unique-on-image :
    {X Q O : Set} (S : TC.Sufficient X Q O)
  → (A B C : TC.DescendingAction S)
  → ((x : X) →
      largeStep C x ≡ largeStep A (largeStep B x))
  → (x : X)
  → smallStep C (quotient S x)
    ≡ smallStep A (smallStep B (quotient S x))
composition-unique-on-image S A B C sameComposite =
  descended-unique-on-image S C (composeDescending A B) sameComposite

------------------------------------------------------------------------
-- A declared split cover globalizes image coherence
------------------------------------------------------------------------

record SplitCover {X Q : Set} (q : X → Q) : Set where
  constructor splitCover
  field
    section : Q → X
    covers : (z : Q) → q (section z) ≡ z

open SplitCover

-- This is the load-bearing step.  A law known only at q x becomes a law at
-- arbitrary z : Q precisely because the declared section realizes z.
split-cover-globalizes :
    {X Q A : Set} {q : X → Q}
  → SplitCover q
  → (f g : Q → A)
  → ((x : X) → f (q x) ≡ g (q x))
  → (z : Q) → f z ≡ g z
split-cover-globalizes cover f g onImage z =
  trans (sym (cong f (covers cover z)))
    (trans (onImage (section cover z)) (cong g (covers cover z)))

identity-unique-global :
    {X Q O : Set} (S : TC.Sufficient X Q O)
  → SplitCover (quotient S)
  → (A : TC.DescendingAction S)
  → ((x : X) → largeStep A x ≡ x)
  → (z : Q) → smallStep A z ≡ z
identity-unique-global S cover A sameIdentity =
  split-cover-globalizes cover (smallStep A) (λ z → z)
    (identity-unique-on-image S A sameIdentity)

composition-unique-global :
    {X Q O : Set} (S : TC.Sufficient X Q O)
  → SplitCover (quotient S)
  → (A B C : TC.DescendingAction S)
  → ((x : X) →
      largeStep C x ≡ largeStep A (largeStep B x))
  → (z : Q)
  → smallStep C z ≡ smallStep A (smallStep B z)
composition-unique-global S cover A B C sameComposite =
  split-cover-globalizes cover (smallStep C)
    (smallStep A ∘ smallStep B)
    (composition-unique-on-image S A B C sameComposite)

------------------------------------------------------------------------
-- C2 control: valid descent squares need not be a global group action
------------------------------------------------------------------------

data ⊥ : Set where

false≠true : false ≡ true → ⊥
false≠true ()

true≠false : true ≡ false → ⊥
true≠false ()

-- The quotient image is the singleton {false}; true is an ambient state
-- with no large-state representative.
oneQuotient : ⊤ → Bool
oneQuotient _ = false

oneSufficient : TC.Sufficient ⊤ Bool Bool
oneSufficient = TC.sufficient oneQuotient (λ _ → false) (λ b → b) (λ _ → refl)

constantFalse : Bool → Bool
constantFalse _ = false

-- false is the neutral C2 element and true is the generator.
xor : Bool → Bool → Bool
xor false b = b
xor true false = true
xor true true = false

-- The four-entry multiplication table is the usual cyclic group of order
-- two; its algebra is checked here so the control does not rely on the name.
xor-id-left : (g : Bool) → xor false g ≡ g
xor-id-left g = refl

xor-id-right : (g : Bool) → xor g false ≡ g
xor-id-right false = refl
xor-id-right true = refl

xor-assoc : (g h k : Bool) → xor (xor g h) k ≡ xor g (xor h k)
xor-assoc false h k = refl
xor-assoc true false k = refl
xor-assoc true true false = refl
xor-assoc true true true = refl

xor-self : (g : Bool) → xor g g ≡ false
xor-self false = refl
xor-self true = refl

largeC2 : Bool → ⊤ → ⊤
largeC2 _ x = x

large-c2-law : (g h : Bool) (x : ⊤)
  → largeC2 (xor g h) x ≡ largeC2 g (largeC2 h x)
large-c2-law g h x = refl

smallC2 : Bool → Bool → Bool
smallC2 false b = b
smallC2 true b = constantFalse b

-- Every group element separately has a valid descended action: both small
-- actions fix the only realized quotient point false.
c2-commutes : (g : Bool) (x : ⊤)
  → oneQuotient (largeC2 g x) ≡ smallC2 g (oneQuotient x)
c2-commutes false _ = refl
c2-commutes true _ = refl

c2Descends : (g : Bool) → TC.DescendingAction oneSufficient
c2Descends g = TC.descending (largeC2 g) (smallC2 g) (c2-commutes g)

-- The C2 composition law is nevertheless forced on every realized point.
c2-law-on-image : (g h : Bool) (x : ⊤)
  → smallC2 (xor g h) (oneQuotient x)
    ≡ smallC2 g (smallC2 h (oneQuotient x))
c2-law-on-image g h = composition-unique-on-image oneSufficient
  (c2Descends g) (c2Descends h) (c2Descends (xor g h)) (large-c2-law g h)

-- But it is not a C2 action on all of ambient Bool: at the unreachable true,
-- the generator squared is constant false rather than the identity.
AmbientC2Law : Set
AmbientC2Law = (g h z : Bool)
  → smallC2 (xor g h) z ≡ smallC2 g (smallC2 h z)

no-ambient-c2-law : AmbientC2Law → ⊥
no-ambient-c2-law law = true≠false (law true true true)

-- The failed globalization is exactly explained by lack of a split cover.
oneQuotient-not-split : SplitCover oneQuotient → ⊥
oneQuotient-not-split cover = false≠true (covers cover true)
