{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������ � the RSA private key IS the pulverizer's witness, and
-- decryption IS Pigala's exponentiation.
--
-- ��� is ryabhaa's own word for the procedure (`Bija.agda`, the
-- ����������, *ryabhaya* gaitapda 32�33, 499 CE); it is also the word
-- English borrowed nothing of when it named the thing "the private key".
-- ��� is the root/seed.  The compound is built here from ��� (ryabhaa)
-- and the ordinary ���.
--
-- WHAT RSA IS, stated so the decomposition is visible before the proof.
-- Public modulus n, public exponent e.  Encryption of a message x is
--   Pigala's ���� modulo n:  c = x^e mod n.
-- The private key d is chosen so that e�d ≡ 1 (mod �(n)).  Decryption is
-- the SAME exponentiation:  c^d mod n, and the claim is c^d ≡ x.
--
-- TWO INDIAN ALGORITHMS, ALREADY CHECKED IN THIS REPOSITORY, ARE THE
-- WHOLE OF RSA:
--
--   (1) The choice of d.  `e�d ≡ 1 (mod �)` means there is a k with
--       e�d = 1 + k��, i.e. a witness  e�d ≡ ��k + 1  � which is exactly
--       `Bija.��������� e � 1` in its ��������� form (a�x ≡ b�y + g with
--       g = 1).  The private key is the kuaka's output.  RSA keygen is
--       the pulverizer, 499 CE, and nothing else.
--
--   (2) The exponentiation.  `PingalaGhata.����2` computes 2^n by
--       square-and-multiply in log� n steps (Chandastra 8.28�31,
--       Halyudha's nya/dvi markers = the binary digits).  Both
--       encryption and decryption ARE that fold, taken modulo n.
--
-- WHAT IS PROVED HERE, and it is the exact residue once (1) and (2) are
-- named: the correctness of RSA is the EXPONENT LAWS plus ONE hypothesis.
-- Over any commutative monoid M (the theorem needs nothing more � not a
-- group, not a ring, not primality, not n):
--
--   §2  ����-������   :  pow x (a + b) ≡ pow x a � pow x b
--   §2  ����-�����   :  pow x (a � b) ≡ pow (pow x a) b
--       (Pigala's two laws, at the level of the abstract fold)
--   §3  ������-������ :  the RSA identity.  If
--         � e�d ≡ ��k + 1              (the pulverizer's witness, ���������)
--         � pow x � ≡ ε                (Euler / the order of x divides �)
--       then  pow (pow x e) d ≡ x.
--
-- The proof is four monoid facts and the two power laws:
--   pow (pow x e) d = pow x (e�d)        (����-�����, backwards)
--                   = pow x (��k + 1)    (the witness)
--                   = pow x (��k) � x    (����-������)
--                   = pow (pow x �) k � x (����-�����)
--                   = pow ε k � x        (the hypothesis)
--                   = ε � x = x.
--
-- SO THE ONLY NUMBER THEORY IN RSA IS `pow x � ≡ ε`.  Everything else is
-- Pigala's fold and ryabhaa's witness, both already checked.
--
-- AND THAT ONE FACT IS EXACTLY WHERE SHOR DRIVES THE WEDGE.  `pow x � ≡ ε`
-- holds because the ORDER of x divides �(n); Euler's theorem supplies �,
-- but the security rests on �(n) being hard to obtain without the
-- factorisation of n.  Shor computes the order r of x directly (r is the
-- least positive exponent with pow x r ≡ ε) � order-finding, the one step
-- a classical machine is not known to do in polynomial time � and once r
-- is in hand the factor of n falls out by a gcd, which is the kuaka
-- again.  §4 states the classical half of that reduction as a hypothesis
-- and takes the quantum half as a hypothesis.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Bijamula_TheRSAPrivateKeyIsThePulverizersWitnessAndDecryptionIsPingalasExponentiation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (·-suc ; 0≡m·0)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; _×_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  A commutative monoid, as a record � the only structure the RSA
--     identity uses.  (Kept local; the repository's group modules carry
--     more than is needed and the point is how LITTLE is needed.)
------------------------------------------------------------------------

record CMonoid (M : Type ℓ) : Type ℓ where
  field
    ε        : M
    _⋆_      : M → M → M
    assoc⋆   : (x y z : M) → (x ⋆ y) ⋆ z ≡ x ⋆ (y ⋆ z)
    idL      : (x : M) → ε ⋆ x ≡ x
    idR      : (x : M) → x ⋆ ε ≡ x
    comm⋆    : (x y : M) → x ⋆ y ≡ y ⋆ x

module _ {M : Type ℓ} (CM : CMonoid M) where
  open CMonoid CM

  -- Pigala's fold at the abstract level: ���� x n = x ∙ x ∙ � (n times)
  घात : M → ℕ → M
  घात x zero    = ε
  घात x (suc n) = x ⋆ घात x n

  घात-एकम् : (x : M) → घात x 1 ≡ x
  घात-एकम् x = idR x

  घात-ε : (n : ℕ) → घात ε n ≡ ε
  घात-ε zero    = refl
  घात-ε (suc n) = idL (घात ε n) ∙ घात-ε n

  ------------------------------------------------------------------------
  -- §2  Pigala's two exponent laws, abstractly.
  ------------------------------------------------------------------------

  घात-योगः : (x : M) (a b : ℕ) → घात x (a + b) ≡ घात x a ⋆ घात x b
  घात-योगः x zero    b = sym (idL (घात x b))
  घात-योगः x (suc a) b = cong (x ⋆_) (घात-योगः x a b)
                       ∙ sym (assoc⋆ x (घात x a) (घात x b))

  घात-गुणः : (x : M) (a b : ℕ) → घात x (a · b) ≡ घात (घात x a) b
  घात-गुणः x a zero    = cong (घात x) (sym (0≡m·0 a))
  घात-गुणः x a (suc b) =
      cong (घात x) (·-suc a b)
    ∙ घात-योगः x a (a · b)
    ∙ cong (घात x a ⋆_) (घात-गुणः x a b)

  ------------------------------------------------------------------------
  -- §3  The RSA identity.  Hypotheses named exactly as (1) and (2) above.
  --     witness :  e � d ≡ � � k + 1     (the pulverizer, ��������� g=1)
  --     euler   :  ���� x � ≡ ε            (order of x divides �)
  ------------------------------------------------------------------------

  बीजमूल-सिद्धि :
      (x : M) (e d φ k : ℕ)
    → e · d ≡ φ · k + 1
    → घात x φ ≡ ε
    → घात (घात x e) d ≡ x
  बीजमूल-सिद्धि x e d φ k witness euler =
      sym (घात-गुणः x e d)                       -- घात (घात x e) d ≡ घात x (e·d)
    ∙ cong (घात x) witness                        -- ≡ घात x (φ·k + 1)
    ∙ घात-योगः x (φ · k) 1                         -- ≡ घात x (φ·k) ∙ घात x 1
    ∙ cong₂ _⋆_ (घात-गुणः x φ k ∙ cong (λ z → घात z k) euler ∙ घात-ε k)
                (घात-एकम् x)                       -- ≡ ε ∙ x
    ∙ idL x                                        -- ≡ x

  ------------------------------------------------------------------------
  -- §4  Shor's classical half, as a reduction with the quantum step held
  --     as a hypothesis.  ORDER: r is an order of x when ���� x r ≡ ε.
  --     The quantum machine PRODUCES such an r (least positive); classical
  --     machines are not known to.  Given r, RSA's ���� x � ≡ ε follows for
  --     ANY � that r divides � so an attacker with the order needs no �,
  --     no factorisation.  This is the wedge: the one hypothesis §3 rests
  --     on is exactly what order-finding hands you for free.
  ------------------------------------------------------------------------

  -- if r divides � and ���� x r ≡ ε, then ���� x � ≡ ε � so the order
  -- suffices in place of Euler's �.  (� ≡ r � j is "r divides �".)
  क्रमात्-यूलरः :
      (x : M) (r φ j : ℕ)
    → φ ≡ r · j
    → घात x r ≡ ε
    → घात x φ ≡ ε
  क्रमात्-यूलरः x r φ j divis ord =
      cong (घात x) divis
    ∙ घात-गुणः x r j
    ∙ cong (λ z → घात z j) ord
    ∙ घात-ε j

  -- CONSEQUENCE: order-finding replaces Euler in §3 outright.  Whoever
  -- holds the order r of x (with r � �, automatic since ord � �) and the
  -- pulverizer witness for e against � decrypts � no � needed beyond
  -- knowing SOME multiple of the order.  The classical reduction is total
  -- once r is in hand; only obtaining r is the (quantum) frontier.
  शोर-मूलम् :
      (x : M) (e d φ r j k : ℕ)
    → φ ≡ r · j
    → घात x r ≡ ε
    → e · d ≡ φ · k + 1
    → घात (घात x e) d ≡ x
  शोर-मूलम् x e d φ r j k divis ord witness =
    बीजमूल-सिद्धि x e d φ k witness (क्रमात्-यूलरः x r φ j divis ord)
