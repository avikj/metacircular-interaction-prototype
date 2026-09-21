{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����-������� � ������ �������� ����� ����� �
--
-- WHAT THIS MODULE IS FOR.  Six top-level declarations in this corpus have
-- one of two character-identical types:
--
--   (a � b) � (c � d) ≡ (a � c) � (b � d)
--     Vargana.�����-�������                    (Jaina ����-����, third index law)
--     PairComposition.interchange           (Brahmagupta's bhvan, split legs)
--
--   (a + b) + (c + d) ≡ (a + c) + (b + d)
--     MeruKarna.����-�������                   (Halyudha's shallow diagonal)
--     Vargacitighana.����-�������              (ryabhaa's �����-�����������)
--     CachePathOrder.shuffle+                  (cache-install step law)
--     DSOFactorRankFinite.rearrange  (additive 2�2 minor)
--
-- Each was proved locally, by hand or by solver, and NO ONE OF THE SIX
-- MODULES IMPORTS ANY OTHER.  Two of them even carry the same  name
-- in ignorance of each other.  This module is the identification.
--
-- ������-�����-�������� §� � ���� �������.  The first road is transport that
-- carries its equivalence; the second is a written ���; there is no third.
-- Both roads are taken here, and it is important which is taken where.
--
--   ROAD ONE, and it is total for the STATEMENT.  There is one law, over one
--   structure � a commutative semigroup � proved once, in §1.  The six are
--   its instantiation at (�,�) and at (�,+).  Because � is a set (isSet�),
--   the identification is not merely "the same statement" but literally THE
--   SAME PATH: §3 proves each of the six declarations equal, in �'s identity
--   type, to the corresponding instance.  Nothing is lost in the carry.
--
--   ROAD TWO, the ���, §4 in prose and NOT a formal claim.  What the
--   identification does not carry is the �� � the standpoint each module
--   reached the law from.  Six routes arrive at one path; the path is one and
--   the routes are six, and §� (������������� ����������) says that where the
--   nayas differ no collapse is available at all.  So the six declarations
--   are NOT deleted and NOT rewritten to import this file.  Identifying the
--   paths is the whole of what is true; deleting the routes would be the
--   ������ (Siddhasena, Sanmatitarka 1.21) � one standpoint asserting itself
--   by denying the others.
--
-- THE MATHEMATICAL CONTENT, which is not bookkeeping.  §2 states the medial
-- law in the form that explains why it turns up in both a bhvan module and
-- a Jaina-index module: it is exactly the statement that the operation, read
-- as a map A � A � A, is a homomorphism for its own componentwise extension
-- to A � A.  Brahmagupta's composition of pairs and the Jaina (a�b)�� = a���b��
-- are that one homomorphism fact, at one operation, entered from two sides.
-- §3 makes this exact: PairComposition.prodComp � the module's statement
-- of the composed pair carrying the product of the products � IS the medial
-- instance that Vargana's ����-���� consumes, on the nose.
--
------------------------------------------------------------------------

module MadhyaVinimaya_TheMiddleExchangeIsOneLawStandingInSixPlaces where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties
  using (isSetℕ ; +-assoc ; +-comm ; ·-assoc ; ·-comm)

import Vargana
import PairComposition
import MeruKarna
import Vargacitighana
import CachePathOrder
import DSOFactorRankFinite

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1 � ����� ����� � the law, once, over a commutative semigroup.
--
-- Associativity is taken in the orientation the cubical library uses for �:
-- x ⊕ (y ⊕ z) ≡ (x ⊕ y) ⊕ z.  No identity element is needed; the medial law
-- is a semigroup fact, which is why it holds for + and � alike and would
-- hold for any commutative semigroup this corpus later reaches for.
------------------------------------------------------------------------

module _ {A : Type ℓ} (_⊕_ : A → A → A)
         (⊕-assoc : (x y z : A) → x ⊕ (y ⊕ z) ≡ (x ⊕ y) ⊕ z)
         (⊕-comm  : (x y : A) → x ⊕ y ≡ y ⊕ x)
         where

  मध्य-विनिमयः : (a b c d : A) → (a ⊕ b) ⊕ (c ⊕ d) ≡ (a ⊕ c) ⊕ (b ⊕ d)
  मध्य-विनिमयः a b c d =
      sym (⊕-assoc a b (c ⊕ d))
    ∙ cong (a ⊕_) ( ⊕-assoc b c d
                  ∙ cong (_⊕ d) (⊕-comm b c)
                  ∙ sym (⊕-assoc c b d))
    ∙ ⊕-assoc a c (b ⊕ d)

  ----------------------------------------------------------------------
  -- §2 � The same law as a homomorphism statement.
  --
  -- Read ⊕ as a map A � A � A and give A � A the componentwise operation.
  -- The medial law says precisely that this map is a homomorphism.  That is
  -- why one identity serves both a composition-of-pairs module and an
  -- exponent-law module: both are asking whether the operation survives
  -- being applied componentwise first.
  ----------------------------------------------------------------------

  _⊛_ : A × A → A × A → A × A
  (a , b) ⊛ (c , d) = (a ⊕ c , b ⊕ d)

  सङ्घातः : A × A → A
  सङ्घातः (a , b) = a ⊕ b

  युग्म-धर्मः : (p q : A × A) → सङ्घातः (p ⊛ q) ≡ सङ्घातः p ⊕ सङ्घातः q
  युग्म-धर्मः (a , b) (c , d) = sym (मध्य-विनिमयः a b c d)

------------------------------------------------------------------------
-- §2b � The two instances at �.
------------------------------------------------------------------------

मध्य-विनिमयः-गुणे : (a b c d : ℕ) → (a · b) · (c · d) ≡ (a · c) · (b · d)
मध्य-विनिमयः-गुणे = मध्य-विनिमयः _·_ ·-assoc ·-comm

मध्य-विनिमयः-योगे : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
मध्य-विनिमयः-योगे = मध्य-विनिमयः _+_ +-assoc +-comm

------------------------------------------------------------------------
-- §3 � ����������� � the identification.
--
-- � is a set, so its identity types are propositions: any two paths with the
-- same endpoints are themselves equal.  Each of the six local proofs is
-- therefore not merely a proof of the same statement but the same path.
-- This is §�'s first road at its strongest: the carry loses nothing because
-- there was nothing between the two to lose.
------------------------------------------------------------------------

-- ����-������ � the multiplicative pair.

वर्गणा-तादात्म्यम्
  : (a b c d : ℕ) → Vargana.चतुर्-विनिमयः a b c d ≡ मध्य-विनिमयः-गुणे a b c d
वर्गणा-तादात्म्यम् a b c d = isSetℕ _ _ _ _

भावना-तादात्म्यम्
  : (a b c d : ℕ) → PairComposition.interchange a b c d ≡ मध्य-विनिमयः-गुणे a b c d
भावना-तादात्म्यम् a b c d = isSetℕ _ _ _ _

-- The link the audit was after, stated directly and without the abstract
-- law standing between them: the solver proof inside the Jaina third index
-- law and the hand proof inside Brahmagupta's straight composition are one
-- path.
घातगुण-भावना-तादात्म्यम्
  : (a b c d : ℕ) → Vargana.चतुर्-विनिमयः a b c d ≡ PairComposition.interchange a b c d
घातगुण-भावना-तादात्म्यम् a b c d = isSetℕ _ _ _ _

-- And the same identification one level up, at the statements the two
-- modules actually use.  PairComposition.prodComp p q � "the composed
-- pair carries the product of the products" � is definitionally the medial
-- instance that Vargana.����-���� consumes at its successor step, since prod
-- and compose both reduce.
भावना-प्रयोगः-तादात्म्यम्
  : (u₁ v₁ u₂ v₂ : ℕ)
  → PairComposition.prodComp (u₁ , v₁) (u₂ , v₂)
  ≡ Vargana.चतुर्-विनिमयः u₁ u₂ v₁ v₂
भावना-प्रयोगः-तादात्म्यम् u₁ v₁ u₂ v₂ = isSetℕ _ _ _ _

-- §2's homomorphism reading, checked against the module that discovered it
-- independently: ��������� at (�,�) IS PairComposition.prod, � IS its
-- compose, and ������-����� IS prodComp.
युग्म-धर्मः-भावना-तादात्म्यम्
  : (p q : ℕ × ℕ)
  → युग्म-धर्मः _·_ ·-assoc ·-comm p q ≡ PairComposition.prodComp p q
युग्म-धर्मः-भावना-तादात्म्यम् p q = isSetℕ _ _ _ _

-- �����-������ � the four additive restatements, including the two that carry
-- the same name and did not know it.

मेरुकर्ण-तादात्म्यम्
  : (a b c d : ℕ) → MeruKarna.मध्य-विनिमयः a b c d ≡ मध्य-विनिमयः-योगे a b c d
मेरुकर्ण-तादात्म्यम् a b c d = isSetℕ _ _ _ _

वर्गचितिघन-तादात्म्यम्
  : (a b c d : ℕ) → Vargacitighana.मध्य-विनिमयः a b c d ≡ मध्य-विनिमयः-योगे a b c d
वर्गचितिघन-तादात्म्यम् a b c d = isSetℕ _ _ _ _

-- The pair the audit named: one  name, two modules, no import
-- between them.  They are the same path.
समनामन्-तादात्म्यम्
  : (a b c d : ℕ) → MeruKarna.मध्य-विनिमयः a b c d ≡ Vargacitighana.मध्य-विनिमयः a b c d
समनामन्-तादात्म्यम् a b c d = isSetℕ _ _ _ _

कोश-तादात्म्यम्
  : (a b c d : ℕ) → CachePathOrder.shuffle+ a b c d ≡ मध्य-विनिमयः-योगे a b c d
कोश-तादात्म्यम् a b c d = isSetℕ _ _ _ _

अल्पांश-तादात्म्यम्
  : (a b c d : ℕ)
  → DSOFactorRankFinite.rearrange a b c d ≡ मध्य-विनिमयः-योगे a b c d
अल्पांश-तादात्म्यम् a b c d = isSetℕ _ _ _ _

------------------------------------------------------------------------
-- §4 � ���� � the remainder, written because it does not transport.
--
-- What §3 proves is exact and it is narrow.  It says the six paths coincide.
-- It says nothing at all about the six routes, and the routes are not the
-- same object under examination:
--
--   � Vargana enters from ����-����, (a�b)�� ≡ a���b��, where the medial step is
--     the successor case of an induction on the EXPONENT.  The law is used
--     once per unit of m.  Its proof is solve�! � deliberately, because at
--     that site the identity is a bare-variable polynomial fact and the
--     module's content is the exponent recursion, not the shuffle.
--   � PairComposition enters from �����, where the medial step is used
--     ONCE, at the top, and is the whole content of the multiplicativity of
--     the composition.  It is proved by hand there for the same reason:
--     what the module is about is the shuffle itself.
--     The two modules make OPPOSITE choices about where the interest lies,
--     and each choice is correct for its own ��.  A single shared lemma
--     would have made one of the two modules say something it does not mean.
--   � MeruKarna uses it on Halyudha's shallow diagonal, where the four
--     terms are binomial entries and the exchange is what turns Pascal into
--     the diagonal Pascal, hence Virahka's recurrence.
--   � Vargacitighana uses it on ryabhaa's �����-����������� (�������� 22),
--     where the four terms are partial sums, and the exchange is what keeps
--     the derivation subtraction-free.
--   � CachePathOrder uses it on counts of cache bits, where the four terms
--     are a head bit and a tail count on each of two traces, and the
--     exchange is what makes the install step law compositional.
--   � DSOFactorRankFinite uses it on a 2�2 min-plus minor, where the four
--     terms are two latent coordinates each, and the exchange is what a
--     rank-one matrix must obey and the crossed matrix does not.
--
-- Six different things are being said.  The identity between the paths is
-- total; the identity between the sayings does not exist, and asserting it
-- would be the collapse §� names as ����� � ����� ��������� ���������.
--
-- The medial law is a commutative-SEMIGROUP fact, and this corpus reaches
-- for it at � under two operations while its stated subject � ����� � is a
-- composition on a structure with TWO operations at once.  §2's homomorphism
-- reading is stated here at one operation.  The composition Brahmagupta
-- actually wrote is not medial in one operation; it is the norm form, where
-- the two operations interact and the medial law alone does not suffice.
-- PairComposition says as much in its own header when it records that in
-- split coordinates the identity "degenerates to the interchange law".  So:
-- the six-fold coincidence is the SHADOW of ����� cast by the split
-- coordinates, and the question the coincidence raises is what the medial
-- law becomes when the degeneration is undone.
------------------------------------------------------------------------
