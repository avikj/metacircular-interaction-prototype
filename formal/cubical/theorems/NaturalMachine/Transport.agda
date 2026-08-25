{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Transport
--
-- Charter §7 layer 2, on the presentation where it costs something:
-- "an asserted isomorphism is not transport".
--
-- Schoolbook addition-with-carry `_⊕_` on canonical digit words is
-- defined NATIVELY (ripple carry, digit by digit) --- it is emphatically
-- not defined as digits(value _ + value _).  Then:
--
--   * transport-+-is-⊕ : transporting ℕ's addition along `ua` of the
--     equivalence yields *literally* the schoolbook algorithm;
--   * ℕ-Monoid≡CanWord-Monoid : the two monoids are EQUAL, via the
--     structure identity principle (Cubical.Algebra.Monoid's MonoidPath),
--     not merely isomorphic.
--
-- The monoid laws for ⊕ are *not* re-proved by hand: they are inherited
-- from ℕ through injectivity of `value` on canonical words.  That is
-- itself the point --- transport does work here, it does not decorate.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.Transport (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List
open import Cubical.Data.Unit
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Monoid.Base
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import NaturalMachine.Digits k
open import NaturalMachine.FreeMonoid using (ℕ-Monoid)

------------------------------------------------------------------------
-- 1.  Successor transports to the odometer.
------------------------------------------------------------------------

sucC : CanWord → CanWord
sucC (w , c) = sucw w , canonical-sucw w c

transport-suc-is-sucC :
  transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i) suc ≡ sucC
transport-suc-is-sucC = funExt (λ x → transportUAop₁ ℕ≃CanWord suc x ∙ lem x)
  where
    lem : (x : CanWord) → digitsC (suc (valueC x)) ≡ sucC x
    lem (w , c) = Σ≡Prop isPropCanonical (cong sucw (digits-value w c))

------------------------------------------------------------------------
-- 2.  One digit-column of schoolbook addition, certified.
------------------------------------------------------------------------

sumOf : Bool → Digit → Digit → ℕ
sumOf c d e = carryVal c + toℕ d + toℕ e

carryBound : (c : Bool) (d : Digit) → carryVal c + toℕ d ≤ b
carryBound false d = <-weaken (snd d)
carryBound true  d = snd d

sumBound : (c : Bool) (d e : Digit) → sumOf c d e < b + b
sumBound c d e = ≤<-trans (≤-+k (carryBound c d)) (<-k+ (snd e))

addDigitΣ : (c : Bool) (d e : Digit)
          → Σ[ r ∈ Digit × Bool ] (sumOf c d e ≡ toℕ (fst r) + carryVal (snd r) · b)
addDigitΣ c d e with b ≟ sumOf c d e
... | gt p = (((sumOf c d e) , p) , false) , sym (+-zero (sumOf c d e))
... | eq p = (fzero , true) , (sym p ∙ sym (+-zero b))
... | lt p = ((suc j , bnd) , true) , spec
  where
    j : ℕ
    j = fst p

    sj : suc (j + b) ≡ sumOf c d e
    sj = sym (+-suc j b) ∙ snd p

    bnd : suc (suc j) ≤ b
    bnd = ≤-+k-cancel {m = suc (suc j)} {k = b} {n = b}
            (subst (λ z → suc z ≤ b + b) (sym sj) (sumBound c d e))

    spec : sumOf c d e ≡ suc j + (b + 0)
    spec = sym sj ∙ cong (λ z → suc (j + z)) (sym (+-zero b))

------------------------------------------------------------------------
-- 3.  Ripple carry.
------------------------------------------------------------------------

addCarry : Bool → Word → Word
addCarry false w = w
addCarry true  w = sucw w

value-addCarry : (c : Bool) (w : Word) → value (addCarry c w) ≡ carryVal c + value w
value-addCarry false w = refl
value-addCarry true  w = value-sucw w

mutual
  addw : Bool → Word → Word → Word
  addw c []      v       = addCarry c v
  addw c (d ∷ u) []      = addCarry c (d ∷ u)
  addw c (d ∷ u) (e ∷ v) = addwAux (fst (addDigitΣ c d e)) u v

  addwAux : Digit × Bool → Word → Word → Word
  addwAux (s , c') u v = s ∷ addw c' u v

------------------------------------------------------------------------
-- 4.  The algorithm is correct: pure ℕ identities via the semiring
--     solver, glued to the digit-column certificate.
------------------------------------------------------------------------

ripple-lem1 : (S bb cc' U V : ℕ)
            → S + bb · (cc' + U + V) ≡ (S + cc' · bb) + bb · U + bb · V
ripple-lem1 S bb cc' U V = solveℕ!

ripple-lem2 : (cc D E U V bb : ℕ)
            → (cc + D + E) + bb · U + bb · V ≡ cc + (D + bb · U) + (E + bb · V)
ripple-lem2 cc D E U V bb = solveℕ!

value-addw-step :
    (c : Bool) (d e : Digit) (u v : Word)
  → ((c' : Bool) → value (addw c' u v) ≡ carryVal c' + value u + value v)
  → (r : Digit × Bool)
  → sumOf c d e ≡ toℕ (fst r) + carryVal (snd r) · b
  → value (addwAux r u v) ≡ carryVal c + value (d ∷ u) + value (e ∷ v)
value-addw-step c d e u v ih (s , c') spec =
    cong (λ z → toℕ s + b · z) (ih c')
  ∙ ripple-lem1 (toℕ s) b (carryVal c') (value u) (value v)
  ∙ cong (λ z → z + b · value u + b · value v) (sym spec)
  ∙ ripple-lem2 (carryVal c) (toℕ d) (toℕ e) (value u) (value v) b

value-addw : (c : Bool) (u v : Word)
           → value (addw c u v) ≡ carryVal c + value u + value v
value-addw c [] v =
  value-addCarry c v ∙ cong (_+ value v) (sym (+-zero (carryVal c)))
value-addw c (d ∷ u) [] =
  value-addCarry c (d ∷ u) ∙ sym (+-zero (carryVal c + value (d ∷ u)))
value-addw c (d ∷ u) (e ∷ v) =
  value-addw-step c d e u v (λ c' → value-addw c' u v)
                  (fst (addDigitΣ c d e)) (snd (addDigitΣ c d e))

------------------------------------------------------------------------
-- 5.  Ripple carry preserves canonicity.
------------------------------------------------------------------------

NonEmpty : Word → Type₀
NonEmpty w = Σ[ x ∈ Digit ] Σ[ y ∈ Word ] (w ≡ x ∷ y)

addCarry-nonempty : (c : Bool) (d : Digit) (u : Word) → NonEmpty (addCarry c (d ∷ u))
addCarry-nonempty false d u = d , u , refl
addCarry-nonempty true  d u = sucw-nonempty (d ∷ u)

mutual
  addw-nonemptyL : (c : Bool) (d : Digit) (u v : Word) → NonEmpty (addw c (d ∷ u) v)
  addw-nonemptyL c d u []      = addCarry-nonempty c d u
  addw-nonemptyL c d u (e ∷ v) = aux (fst (addDigitΣ c d e))
    where
      aux : (r : Digit × Bool) → NonEmpty (addwAux r u v)
      aux (s , c') = s , addw c' u v , refl

  addw-nonemptyR : (c : Bool) (u : Word) (e : Digit) (v : Word) → NonEmpty (addw c u (e ∷ v))
  addw-nonemptyR c []      e v = addCarry-nonempty c e v
  addw-nonemptyR c (d ∷ u) e v = addw-nonemptyL c d u (e ∷ v)

canonical-addw-step :
    (c : Bool) (d e : Digit) (u v : Word)
  → ((c' : Bool) → Canonical u → Canonical v → Canonical (addw c' u v))
  → Canonical (d ∷ u) → Canonical (e ∷ v)
  → (r : Digit × Bool)
  → sumOf c d e ≡ toℕ (fst r) + carryVal (snd r) · b
  → Canonical (addwAux r u v)
canonical-addw-step c d e (d2 ∷ u2) v ih cu cv (s , c') spec =
  canonical-cons s (addw c' (d2 ∷ u2) v) (addw-nonemptyL c' d2 u2 v)
                 (ih c' (canonical-tail d (d2 ∷ u2) cu) (canonical-tail e v cv))
canonical-addw-step c d e [] (e2 ∷ v2) ih cu cv (s , c') spec =
  canonical-cons s (addw c' [] (e2 ∷ v2)) (addw-nonemptyR c' [] e2 v2)
                 (ih c' tt (canonical-tail e (e2 ∷ v2) cv))
canonical-addw-step c d e [] [] ih cu cv (s , false) spec =
  subst (0 <_) (spec ∙ +-zero (toℕ s)) positive
  where
    positive : 0 < sumOf c d e
    positive = ≤-trans cu (≤-trans (carryVal c , refl)
                                   (toℕ e , +-comm (toℕ e) (carryVal c + toℕ d)))
canonical-addw-step c d e [] [] ih cu cv (s , true) spec = suc-≤-suc zero-≤

canonical-addw : (c : Bool) (u v : Word)
               → Canonical u → Canonical v → Canonical (addw c u v)
canonical-addw false []      v cu cv = cv
canonical-addw true  []      v cu cv = canonical-sucw v cv
canonical-addw false (d ∷ u) [] cu cv = cu
canonical-addw true  (d ∷ u) [] cu cv = canonical-sucw (d ∷ u) cu
canonical-addw c (d ∷ u) (e ∷ v) cu cv =
  canonical-addw-step c d e u v (λ c' → canonical-addw c' u v) cu cv
                      (fst (addDigitΣ c d e)) (snd (addDigitΣ c d e))

------------------------------------------------------------------------
-- 6.  Schoolbook addition on the canonical-word presentation.
------------------------------------------------------------------------

infixl 6 _⊕_

_⊕_ : CanWord → CanWord → CanWord
(u , cu) ⊕ (v , cv) = addw false u v , canonical-addw false u v cu cv

zeroC : CanWord
zeroC = [] , tt

valueC-⊕ : (x y : CanWord) → valueC (x ⊕ y) ≡ valueC x + valueC y
valueC-⊕ (u , _) (v , _) = value-addw false u v

valueC-inj : (x y : CanWord) → valueC x ≡ valueC y → x ≡ y
valueC-inj (u , cu) (v , cv) p = Σ≡Prop isPropCanonical (value-inj u v cu cv p)

------------------------------------------------------------------------
-- 7.  The monoid laws for ⊕, inherited from ℕ by transport of proof.
------------------------------------------------------------------------

⊕-assoc : (x y z : CanWord) → x ⊕ (y ⊕ z) ≡ (x ⊕ y) ⊕ z
⊕-assoc x y z = valueC-inj _ _
  ( valueC-⊕ x (y ⊕ z)
  ∙ cong (valueC x +_) (valueC-⊕ y z)
  ∙ +-assoc (valueC x) (valueC y) (valueC z)
  ∙ cong (_+ valueC z) (sym (valueC-⊕ x y))
  ∙ sym (valueC-⊕ (x ⊕ y) z) )

⊕-idr : (x : CanWord) → x ⊕ zeroC ≡ x
⊕-idr x = valueC-inj _ _ (valueC-⊕ x zeroC ∙ +-zero (valueC x))

⊕-idl : (x : CanWord) → zeroC ⊕ x ≡ x
⊕-idl x = valueC-inj _ _ (valueC-⊕ zeroC x)

CanWord-Monoid : Monoid ℓ-zero
CanWord-Monoid = makeMonoid zeroC _⊕_ isSetCanWord ⊕-assoc ⊕-idr ⊕-idl

------------------------------------------------------------------------
-- 8.  Transport, and the structure identity principle.
------------------------------------------------------------------------

digitsC-+ : (m n : ℕ) → digitsC (m + n) ≡ digitsC m ⊕ digitsC n
digitsC-+ m n = valueC-inj _ _
  ( value-digits (m + n)
  ∙ cong₂ _+_ (sym (value-digits m)) (sym (value-digits n))
  ∙ sym (valueC-⊕ (digitsC m) (digitsC n)) )

-- THE TRANSPORT STATEMENT.  The transported addition is not merely
-- isomorphic to schoolbook addition; it IS schoolbook addition.
transport-+-is-⊕ :
  transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i → ℕ≡CanWord i) _+_ ≡ _⊕_
transport-+-is-⊕ = funExt (λ x → funExt (λ y →
    transportUAop₂ ℕ≃CanWord _+_ x y
  ∙ digitsC-+ (valueC x) (valueC y)
  ∙ cong₂ _⊕_ (retr x) (retr y)))
  where
    retr : (x : CanWord) → digitsC (valueC x) ≡ x
    retr (w , c) = Σ≡Prop isPropCanonical (digits-value w c)

ℕ≃CanWord-MonoidEquiv : MonoidEquiv ℕ-Monoid CanWord-Monoid
ℕ≃CanWord-MonoidEquiv = ℕ≃CanWord , monoidequiv refl digitsC-+

-- THE UNIVALENT PUNCHLINE.
ℕ-Monoid≡CanWord-Monoid : ℕ-Monoid ≡ CanWord-Monoid
ℕ-Monoid≡CanWord-Monoid =
  equivFun (MonoidPath ℕ-Monoid CanWord-Monoid) ℕ≃CanWord-MonoidEquiv

carrier-of-monoid-path : cong ⟨_⟩ ℕ-Monoid≡CanWord-Monoid ≡ ℕ≡CanWord
carrier-of-monoid-path = refl
