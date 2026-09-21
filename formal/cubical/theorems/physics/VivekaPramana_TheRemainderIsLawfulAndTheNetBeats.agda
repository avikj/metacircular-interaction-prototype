{-# OPTIONS --cubical --guardedness --safe #-}

------------------------------------------------------------------------
-- ������-������ � �������� ������ ����� ; ���� �������� �
--
-- (the remainder is bound by a law, not merely by membership; and the
-- net beats.)
--
-- THE ONE LINE THAT CARRIES THE CONTENT:
--
--     ������ : ������� ≡ (�� + ���)
--
-- The field says WHAT THE REMAINDER IS.  So ������-������ is
-- the GRAPH OF +, and
-- � � � � graph(+) because a graph is a family of singletons.  The
-- equivalence is contentful rather than definitional, and
-- ╗�≡������-������ is that content transported by univalence.
--
--    The two ������� values in rightInv are equal � but by ������ itself,
--    not by any propositionality of �.  Discharged here by transporting
--    ������� along (v .������), with the ������ component filled by
--    isProp�PathP over isSet�.  The field pays for its own coherence.
--
-- � HERE IS NOT THE LATER MODALITY.  It is a record with `force : A`,
-- i.e. the identity functor; the guarding is done by --guardedness on
-- ���, not by �.
-- The real � needs --guarded and a clock
-- (Cubical.Later), which is ABSENT FROM THE PIN (v0.9).
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
