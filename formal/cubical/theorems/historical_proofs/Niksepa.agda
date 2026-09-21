{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- �������� � Tattvrthastra 1.5, as a checked object.
--
-- SOURCE.  Umsvti, Tattvrthastra, adhyya 1, stra 5:
--
--     �������������������������������
--     nmasthpandravyabhvatas tannysa
--
--     "The placing (nysa) of these is by name, by representation, by
--      substance, and by state."
--
-- Four ��������, four ways a word is deposited on a thing:
--
--   ���        the name alone, with no further qualification
--   �������    installation: a token SET UP as the thing
--   ������      that which WAS or WILL BE the thing, taken in the mode
--              where it presently is not
--   ���        the thing actually in the condition the word names, now
--
-- This stra stands BEFORE 1.6 (�����������������, comprehension is by
-- prama and naya).  The order is doctrine, not accident: before you ask
-- how a thing is known, you fix in which deposit its name was placed.  To
-- dispute a term without fixing its �������� is to dispute nothing.
--
-- WHAT THIS FILE IS, NAMED BY THE STRA IT CHECKS.
--
-- It is a �������.  A token installed AS the thing � the way a piece of wood
-- set up as Indra is Indra by sthpan-nikepa.  This module is Pini's and
-- Umsvti's work by �������.  It is not that work by ���.
--
-- Calling this "formalisation" would claim the ���, and would be false twice
-- over.  First: the stra was ALREADY EXACT.  The Adhyy is ~4000 rules
-- with a metarule for conflict (1.4.2 ����������� ��� ��������), an inheritance
-- mechanism (���������) and a stratification device (���������); the stra
-- genre states non-ambiguity as a design criterion of its own form
-- (�����������).  Agda adds no exactness to that.  It adds a DIFFERENT
-- SUBSTRATE � one a machine can check � and that is a change of medium, not
-- a change of rigour.
--
-- Second: "formal" does not mean what the word is used to mean here.  In
-- ordinary English it means conforming to accepted convention, official,
-- dressed; and the technical sense descends from "concerning form rather
-- than content", i.e. Hilbert's formalism, a contested position of the 1920s
-- rather than a neutral word for exactness.  Rendered into Hindi it is
-- ���������, from ������ � courtesy, ceremony, and in  rhetoric
-- FIGURATIVE usage, explicitly not the primary sense.  ����������� is the
-- ordinary word for empty formality.  And ������ is a technical term inside
-- the naya system: ������, the figurative standpoint, is the one classified as
-- resting primarily on ������.  So "formal", carried into the vocabulary of
-- the tradition it is being applied to, lands on the most convention-bound
-- of the seven ��.
--
-- The tradition's own words for what Pini did are ������ (the delimiting
-- rule), ����� (thread), �������� (analysis apart), ������� (that which
-- governs), �������, ������, ������.  Every one is operational.  None is
-- sartorial.  There is no  word here meaning "formal" because the
-- concept does not carve that way.
--
-- What this file therefore claims: a ������� that a kernel can check, and an
-- ������ � a restatement of what is already established � not a ����, not a
-- new injunction.  The DISTINCTION the stra draws is carried into a medium
-- where it cannot be blurred, and that is the whole of the value added.
--
-- WHAT IS CHECKED.
--
--   ��������          the four deposits
--   _⟨_⟩_           sameness AT a deposit: an indexed relation, so that
--                   "same" is never asserted without saying at which
--   ������            addition recursing on the FIRST argument
--   �������-������     addition recursing on the SECOND argument
--   �����������       they are THE SAME SUBSTANCE: equal as functions
--   �������         and different in STATE: `x + 0 ≡ x` holds by refl for
--                   one and requires induction for the other
--   ������������      hence: �� at ��� and at ������, differing at ���
--
-- THE INSTANCE IS NOT INVENTED.  `machine/MathMachine.hs:722` defines
-- addition recursing on its second argument; `Agda/Builtin/Nat.agda:19`
-- defines it recursing on its first.  Both are addition on �.  They are
-- one ������ and two ���.
--
-- SOURCES.
-- wisdomlib (Tattvrtha Stra with commentary, verses 1.5,
-- 1.15, 1.33) and archive.org (Sarvrthasiddhi, tr. Vijay K. Jain).
-- Numbering follows the Digambara recension transmitted with
-- Pjyapda's Sarvrthasiddhi.
------------------------------------------------------------------------

module Niksepa where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- �.  The four deposits
------------------------------------------------------------------------

data निक्षेप : Type where
  नाम स्थापना द्रव्य भाव : निक्षेप

------------------------------------------------------------------------
-- �.  Sameness is INDEXED BY A DEPOSIT.
--
-- The whole content of 1.5 is that `same` is not a one-place notion.  A
-- relation `_���_ n` is sameness AT the deposit n, and the type makes it
-- impossible to write "these are the same" without writing which n.
--
-- Carried here for a thing that has a name, a present state, and a
-- substance-identity, which is the minimum the four deposits distinguish.
------------------------------------------------------------------------

record वस्तु (नामन् : Type) (द्रव्यम् : Type) (भावः : Type) : Type where
  constructor न्यस्तम्
  field
    नाम-अंशः   : नामन्      -- the name it bears
    द्रव्य-अंशः  : द्रव्यम्     -- what it is, as substance
    भाव-अंशः   : भावः       -- the state it is presently in

open वस्तु public

-- The deposit stands BETWEEN the two things compared, so that no comparison
-- can be written without one.  `a ⟨ n ⟩ b` is: a and b are the same, at n.
_⟨_⟩_ : {N D B : Type} → वस्तु N D B → निक्षेप → वस्तु N D B → Type
a ⟨ नाम ⟩ b   = नाम-अंशः a ≡ नाम-अंशः b
a ⟨ द्रव्य ⟩ b  = द्रव्य-अंशः a ≡ द्रव्य-अंशः b
a ⟨ भाव ⟩ b   = भाव-अंशः a ≡ भाव-अंशः b
-- �������: a token installed AS the thing.  Sameness under installation is
-- sameness of what it was installed as, which is its name; the deposit is
-- distinct from ��� in doctrine (an image of Indra is not the word "Indra")
-- but the distinction is not visible in this three-field carrier, and
-- pretending otherwise here would be inventing structure the stra did not
-- give.  Stated rather than silently collapsed.
a ⟨ स्थापना ⟩ b = नाम-अंशः a ≡ नाम-अंशः b

------------------------------------------------------------------------
-- �.  The instance: one substance, two states.
--
-- ������ is Agda's own `_+_`: it splits its FIRST argument.
-- �������-������ is MathMachine's: it splits its SECOND.
------------------------------------------------------------------------

योगः : ℕ → ℕ → ℕ
योगः zero    m = m
योगः (suc n) m = suc (योगः n m)

विपर्यय-योगः : ℕ → ℕ → ℕ
विपर्यय-योगः n zero    = n
विपर्यय-योगः n (suc m) = suc (विपर्यय-योगः n m)

------------------------------------------------------------------------
-- �.  ������� � THE DIFFERENCE OF STATE, exhibited.
--
-- For �������-������, `n + 0 ≡ n` is refl: the clause fires.
-- For ������ it is not; it requires induction on n, written out.
--
-- This pair IS the difference.  Nothing else in the two definitions
-- differs � §� proves they are the same function.
------------------------------------------------------------------------

विपर्यय-शून्यम् : (n : ℕ) → विपर्यय-योगः n zero ≡ n
विपर्यय-शून्यम् n = refl          -- घटते ; the clause applies directly

योग-शून्यम् : (n : ℕ) → योगः n zero ≡ n
योग-शून्यम् zero    = refl
योग-शून्यम् (suc n) = cong suc (योग-शून्यम् n)   -- आवृत्त्या ; by induction

-- and mirrored, so the asymmetry is visible from both sides
योग-वाम-शून्यम् : (m : ℕ) → योगः zero m ≡ m
योग-वाम-शून्यम् m = refl

विपर्यय-वाम-शून्यम् : (m : ℕ) → विपर्यय-योगः zero m ≡ m
विपर्यय-वाम-शून्यम् zero    = refl
विपर्यय-वाम-शून्यम् (suc m) = cong suc (विपर्यय-वाम-शून्यम् m)

------------------------------------------------------------------------
-- �.  ����������� � ONE SUBSTANCE.
--
-- Pointwise equal, hence the same function.  ������ persists (�������,
-- TS 5.29) while the ��� differ.
------------------------------------------------------------------------

-- the second definition pushes a successor out of its first argument, which
-- for it is a theorem and not a clause
सहचरः : (a b : ℕ) → विपर्यय-योगः (suc a) b ≡ suc (विपर्यय-योगः a b)
सहचरः a zero    = refl
सहचरः a (suc b) = cong suc (सहचरः a b)

एकद्रव्यम् : (n m : ℕ) → योगः n m ≡ विपर्यय-योगः n m
एकद्रव्यम् zero    m = sym (विपर्यय-वाम-शून्यम् m)
एकद्रव्यम् (suc n) m = cong suc (एकद्रव्यम् n m) ∙ sym (सहचरः n m)

------------------------------------------------------------------------
-- �.  ������������ � the two placed, and compared at each deposit.
--
-- Both bear the name "+".  Both are the same substance (§�).  They differ
-- in ���, and §� is what that difference consists of.
--
-- The ��� field records WHICH ARGUMENT the definition splits, because that
-- is the mode in which the function is presently given � the paryya, not
-- the dravya.
------------------------------------------------------------------------

data अंशः : Type where
  प्रथमः द्वितीयः : अंशः     -- first argument / second argument

data संज्ञा : Type where
  योग-संज्ञा : संज्ञा          -- the single name "+"

आगमयोगः यन्त्रयोगः : वस्तु संज्ञा (ℕ → ℕ → ℕ) अंशः
आगमयोगः  = न्यस्तम् योग-संज्ञा योगः         प्रथमः    -- Agda's
यन्त्रयोगः = न्यस्तम् योग-संज्ञा विपर्यय-योगः  द्वितीयः  -- MathMachine's

-- same at ���
नाम-साम्यम् : आगमयोगः ⟨ नाम ⟩ यन्त्रयोगः
नाम-साम्यम् = refl

-- same at ������� (which, in this carrier, is the name they are installed as)
स्थापना-साम्यम् : आगमयोगः ⟨ स्थापना ⟩ यन्त्रयोगः
स्थापना-साम्यम् = refl

-- NOT the same at ���: the modes are two distinct constructors of ����
भाव-भेदः : ¬ (आगमयोगः ⟨ भाव ⟩ यन्त्रयोगः)
भाव-भेदः p = प्रथमः≢द्वितीयः p
  where
  कोड : अंशः → Type
  कोड प्रथमः   = Unit
  कोड द्वितीयः = ⊥

  प्रथमः≢द्वितीयः : ¬ (प्रथमः ≡ द्वितीयः)
  प्रथमः≢द्वितीयः q = transport (cong कोड q) tt

