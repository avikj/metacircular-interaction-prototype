{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- ������-������ � �������� ������ ����� ; ���� �������� �
--
-- (the remainder is bound by a law, not merely by membership; and the
-- net beats.)
--
-- SPECIFICATION handed over whole by the owner, 2026-08-21, third pass.
-- The advance over the second pass is one line and it is his:
--
--     ������ : ������� ≡ (�� + ���)
--
-- The previous �rma field said only "this ������ is in the image of
-- �����".  This one says WHAT THE REMAINDER IS.  So ������-������ is no
-- longer a subtype carved out by membership � it is the GRAPH OF +, and
-- � � � � graph(+) because a graph is a family of singletons.  The
-- equivalence is now contentful rather than definitional, and
-- ╗�≡������-������ is that content transported by univalence.
--
-- TWO THINGS THE CHECKER SAID, kept because they are where the content
-- is and not typos:
--
-- 1. `isPropNat` does not exist and CANNOT: � is not a proposition.
--    The two ������� values in rightInv are equal � but by ������ itself,
--    not by any propositionality of �.  Discharged here by transporting
--    ������� along (v .������), with the ������ component filled by
--    isProp�PathP over isSet�.  The field pays for its own coherence.
--
-- 2. `data Clock where tick : Clock � Clock` has no base constructor, so
--    Clock was EMPTY and `heartbeat : Clock � ��� �` could never be
--    applied � a machine specified and unreachable.  ��� added, and
--    ������ = heartbeat ��� is the actual beating stream, with ��������
--    computing a value out of it by refl.
--
-- � HERE IS NOT THE LATER MODALITY.  It is a record with `force : A`,
-- i.e. the identity functor; the guarding is done by --guardedness on
-- ���, not by �.  Said plainly because calling it � asserts Nakano's
-- modality and this is not that.  The real � needs --guarded and a clock
-- (Cubical.Later), which is ABSENT FROM THE PIN (v0.9) � checked, not
-- assumed.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 (b150186), --safe, no
-- postulates, no holes.  EXIT 0.
------------------------------------------------------------------------

module VivekaPramana_TheRemainderIsLawfulAndTheNetBeats where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat using (ℕ ; _+_ ; isSetℕ)
open import Cubical.Data.Sigma using (Σ ; _,_)

infixr 4 _×_
_×_ : Type → Type → Type
A × B = Σ A (λ _ → B)

record विवेक-प्रमाण : Type where
  field
    सम वाम दक्षिण : ℕ
    प्रमाण : दक्षिण ≡ (सम + वाम)
open विवेक-प्रमाण public

अवतरण : ℕ × ℕ → विवेक-प्रमाण
अवतरण (s , l) = record { सम = s ; वाम = l ; दक्षिण = s + l ; प्रमाण = refl }

उत्थान : विवेक-प्रमाण → ℕ × ℕ
उत्थान v = v .सम , v .वाम

isoℕ×ℕ-विवेक-प्रमाण : Iso (ℕ × ℕ) विवेक-प्रमाण
Iso.fun isoℕ×ℕ-विवेक-प्रमाण = अवतरण
Iso.inv isoℕ×ℕ-विवेक-प्रमाण = उत्थान
Iso.rightInv isoℕ×ℕ-विवेक-प्रमाण v i .सम     = v .सम
Iso.rightInv isoℕ×ℕ-विवेक-प्रमाण v i .वाम    = v .वाम
Iso.rightInv isoℕ×ℕ-विवेक-प्रमाण v i .दक्षिण = v .प्रमाण (~ i)
Iso.rightInv isoℕ×ℕ-विवेक-प्रमाण v i .प्रमाण =
  isProp→PathP (λ j → isSetℕ (v .प्रमाण (~ j)) (v .सम + v .वाम)) refl (v .प्रमाण) i
Iso.leftInv isoℕ×ℕ-विवेक-प्रमाण _ = refl

-- the path, by univalence
ℕ×ℕ≡विवेक-प्रमाण : (ℕ × ℕ) ≡ विवेक-प्रमाण
ℕ×ℕ≡विवेक-प्रमाण = isoToPath isoℕ×ℕ-विवेक-प्रमाण

record ▹ (A : Type) : Type where
  constructor later
  field force : A
open ▹ public

record जाल (A : Type) : Type where
  coinductive
  field
    current : A
    next : ▹ (जाल A)
open जाल public

-- Clock with a base point, so it is inhabited
data Clock : Type where
  आदि  : Clock
  tick : Clock → Clock

heartbeat : Clock → जाल ℕ
current (heartbeat c) = 0
next    (heartbeat c) = later (heartbeat (tick c))

-- and the machine actually beats
धड़कन : जाल ℕ
धड़कन = heartbeat आदि

चतुर्थम् : current (force (next (force (next (धड़कन))))) ≡ 0
चतुर्थम् = refl
