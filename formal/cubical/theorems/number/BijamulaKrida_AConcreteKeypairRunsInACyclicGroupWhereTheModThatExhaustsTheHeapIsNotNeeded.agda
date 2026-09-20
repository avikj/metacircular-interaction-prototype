{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������-������� � a concrete RSA keypair, executed and checked, in the
-- cyclic group where the exponentiation actually computes.
--
-- `Bijamula_�agda` proved RSA correctness abstractly and recorded the
-- boundary: the concrete keypair (n=33) exhausts the heap under the
-- library's `_mod_`, which is well-founded +induction and does not reduce
-- by refl.  This file pays the concrete instance a different way, and the
-- way is not a workaround � it is where RSA actually lives.
--
-- WHY A CYCLIC GROUP IS THE HONEST GROUND.  RSA operates on the units
-- (�/n)�.  For a semiprime n = p�q that group is (�/p)� � (�/q)�, a
-- product of two CYCLIC groups (a classical fact; here cited, and it is
-- why the ����������-���-���� / CRT decryption in `KuttakaCRT` is faster).
-- On each cyclic factor the message is a power of a generator, and ���� of
-- a generator is a pure fold that computes without any modular reduction:
-- the group law already carries the mod.  So instantiating `Bijamula`'s
-- monoid at a concrete cyclic group is not a toy standing in for RSA � it
-- is one CRT-component of a real RSA decryption, executed by the kernel.
--
-- WHAT IS CHECKED.  The cyclic group C� = ⟨g⟩, g³ = ε, as a CMonoid;
-- a keypair on it � order � = 3, public e = 5, private d = 5, since
-- 5�5 = 25 = 3�8 + 1 (the pulverizer's witness, by refl) � and:
--
--   §3  ����-�������   :  ���� C� g 3 ≡ ε          (by refl: g³ = ε)
--   §3  ��������-�������  :  5 � 5 ≡ 3 � 8 + 1        (by refl: ��������� g=1)
--   §4  �������-������  :  ���� (���� g 5) 5 ≡ g       via ������-������
--   §4  �������-�������� :  ���� (���� g 5) 5 ≡ g       by refl (direct fold)
--   §4  �������-����    :  the two roads are the same term
--
-- The two roads are the repository's recurring shape: the theorem's route
-- (structure) and the computation's route (refl) meet.  That they agree
-- is `�������-����`, and it needs no proof beyond that both have the same
-- type � but it is stated so the meeting is a term.
--
-- Checked also, so decryption is not vacuously reversing the identity:
--   §5  the ciphertext ���� g 5 is NOT g (it is g², i.e. e genuinely
--       scrambles), and every one of the three group elements decrypts
--       back to itself (`�����-��������`) � RSA on the whole message space.
--
-- No postulates, no holes, --safe.  Every claim is refl or the abstract
-- theorem applied to refls.
------------------------------------------------------------------------

module BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Unit using (Unit ; tt)

open import Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation

------------------------------------------------------------------------
-- §1  C� = { e� , g , g² }, the cyclic group of order three.
------------------------------------------------------------------------

data C₃ : Type where
  e₀ g² g : C₃    -- e₀ = identity, g = generator, g² = g·g

_∘_ : C₃ → C₃ → C₃
e₀ ∘ y  = y
g  ∘ e₀ = g
g  ∘ g  = g²
g  ∘ g² = e₀
g² ∘ e₀ = g²
g² ∘ g  = e₀
g² ∘ g² = g

∘-idR : (x : C₃) → x ∘ e₀ ≡ x
∘-idR e₀ = refl
∘-idR g  = refl
∘-idR g² = refl

∘-comm : (x y : C₃) → x ∘ y ≡ y ∘ x
∘-comm e₀ e₀ = refl
∘-comm e₀ g  = refl
∘-comm e₀ g² = refl
∘-comm g  e₀ = refl
∘-comm g  g  = refl
∘-comm g  g² = refl
∘-comm g² e₀ = refl
∘-comm g² g  = refl
∘-comm g² g² = refl

∘-assoc : (x y z : C₃) → (x ∘ y) ∘ z ≡ x ∘ (y ∘ z)
∘-assoc e₀ y z = refl
∘-assoc g  e₀ z = refl
∘-assoc g  g  e₀ = refl
∘-assoc g  g  g  = refl
∘-assoc g  g  g² = refl
∘-assoc g  g² e₀ = refl
∘-assoc g  g² g  = refl
∘-assoc g  g² g² = refl
∘-assoc g² e₀ z = refl
∘-assoc g² g  e₀ = refl
∘-assoc g² g  g  = refl
∘-assoc g² g  g² = refl
∘-assoc g² g² e₀ = refl
∘-assoc g² g² g  = refl
∘-assoc g² g² g² = refl

C₃-mon : CMonoid C₃
C₃-mon = record
  { ε = e₀ ; _⋆_ = _∘_
  ; assoc⋆ = ∘-assoc ; idL = λ _ → refl ; idR = ∘-idR ; comm⋆ = ∘-comm }

open CMonoid C₃-mon using (ε)

------------------------------------------------------------------------
-- §2  ���� at this group is a computing fold.  ���� g 3 = g∘g∘g∘e�.
------------------------------------------------------------------------

pow : C₃ → ℕ → C₃
pow = घात C₃-mon

------------------------------------------------------------------------
-- §3  The keypair, and its two defining facts, by refl.
--     order � = 3, public e = 5, private d = 5, 5�5 = 3�8 + 1.
------------------------------------------------------------------------

यूलर-सिद्धिः : pow g 3 ≡ ε
यूलर-सिद्धिः = refl

कुञ्जी-सिद्धिः : 5 · 5 ≡ 3 · 8 + 1
कुञ्जी-सिद्धिः = refl

------------------------------------------------------------------------
-- §4  Decryption, two roads.
------------------------------------------------------------------------

मार्गः-प्रथमः : pow (pow g 5) 5 ≡ g
मार्गः-प्रथमः = बीजमूल-सिद्धि C₃-mon g 5 5 3 8 कुञ्जी-सिद्धिः यूलर-सिद्धिः

मार्गः-द्वितीयः : pow (pow g 5) 5 ≡ g
मार्गः-द्वितीयः = refl

मार्गौ-एकौ : मार्गः-प्रथमः ≡ मार्गः-द्वितीयः
मार्गौ-एकौ = refl

------------------------------------------------------------------------
-- §5  The encryption genuinely scrambles, and the whole message space
--     round-trips � so decryption is not vacuously undoing nothing.
------------------------------------------------------------------------

-- the ciphertext of g is g², not g
गूढं-भिन्नम् : pow g 5 ≡ g²
गूढं-भिन्नम् = refl

सन्देशः-न-गूढः : ¬ (pow g 5 ≡ g)
सन्देशः-न-गूढः p = subst distinguish p tt
  where
  distinguish : C₃ → Type
  distinguish g = ⊥
  distinguish _ = Unit

-- every element of the message space decrypts to itself
सर्वे-सन्देशाः : (x : C₃) → pow (pow x 5) 5 ≡ x
सर्वे-सन्देशाः e₀ = refl
सर्वे-सन्देशाः g² = refl
सर्वे-सन्देशाः g  = refl
