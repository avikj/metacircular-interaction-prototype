{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������� � the verdict type, with no place in it for a bare label.
--
-- ����� ����������� �  A bare verdict is a truncation.  � A �� keeps THAT A is
-- inhabited and destroys WHICH inhabitant and every path between
-- inhabitants, and there is no section, so the loss is not repairable
-- §� ���� �������).  �������, below, is that in one line.
--
-- The four positions are the ones interactive/Obstruction.hs arrived at
-- (ANEKANTA.md §19) and this file adds the two the machine did
-- not have: �����, which carries its derivation, and �����������, which is
-- what a disagreement of standpoints returns instead of an error or an
-- average.  Each carries what makes it the verdict it is:
--
--   �����        the derivation      � � e, the two sides agree
--   �������       the assignment      � and the separation AT it
--   ��������      THE DOMAIN SEARCHED � ���������/�������� yogynupalabdhi: "I
--                found nothing" is inadmissible, "I searched this domain,
--                in which it would have appeared, and it did not" is
--                admissible, and the extent is the whole of the difference
--   �����������    which two variables failed to unify � no dharmin, no
--                predication; not a bhaga, and not forced into one
--   ��������      the symbol outside the vocabulary that silenced this naya
--   �����������    the ��� � both standpoints kept whole, and the ����� from
--                which the next naya is born
--
-- WHAT IS CLAIMED OF THE SOURCES.  ������������, ����� and ����������� are
-- Umsvti (�����������������), Siddhasena Divkara (������������), Samantabhadra,
-- Akalaka.  ���������������� � non-perception where perception was FIT to
-- occur � is the Mmsaka condition on ��������� as a prama (Kumrila,
-- �������������������, �������������).  Naming a constructor for a term does not
-- claim that its author proved anything below; the debt is the
-- distinction, which is theirs, and the theorems are this file's.
------------------------------------------------------------------------

module Nirnaya_TheVerdictCannotDropItsWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc ; snotz)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; squash₁)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- � � ������� � why none of this is a matter of taste.
--
-- Every map out of a truncation is blind to WHICH inhabitant, by squash�,
-- by cong, immediately.  A reporting layer that takes � verdict �� is this
-- function, whatever else it is called.
------------------------------------------------------------------------

अविशेषः : {A B : Type} (f : ∥ A ∥₁ → B) (x y : A) → f ∣ x ∣₁ ≡ f ∣ y ∣₁
अविशेषः f x y = cong f (squash₁ ∣ x ∣₁ ∣ y ∣₁)

-- and the loss is not repairable downstream: no section, so no later
-- layer can put back what this one dropped.  ��������� �������, �������������� �
न-प्रत्यानयनम् : {A : Type} (x y : A) → ¬ (x ≡ y)
               → ¬ (Σ[ r ∈ (∥ A ∥₁ → A) ] ((a : A) → r ∣ a ∣₁ ≡ a))
न-प्रत्यानयनम् x y x≢y (r , sec) = x≢y (sym (sec x) ∙ अविशेषः r x y ∙ sec y)

------------------------------------------------------------------------
-- � � �������� � the setting a verdict is a verdict IN.
--
--   E        the assignments the machine can evaluate at
--   �������     the fitness criterion on a searched domain: what it takes for
--            a counterexample to have been the sort of thing that WOULD
--            have shown up in it.  A parameter, not a definition, because
--            asserting a particular fitness here would assert a provenance
--            nobody checked � the criterion belongs to the vocabulary the
--            machine is searching over, and is supplied with it.
--   ���������   which symbols this naya has semantics for.
------------------------------------------------------------------------

module सन्दर्भ (E : Type) (योग्य : List E → Type) (शब्दकोश : ℕ → Type) where

  record वाद : Type where
    constructor _≐_
    field
      वाम   : E → ℕ
      दक्षिण : E → ℕ
  open वाद public

  -- every point of a list satisfies P, as data rather than as a claim
  सर्वे : (E → Type) → List E → Type
  सर्वे P []       = Unit
  सर्वे P (x ∷ xs) = P x × सर्वे P xs

  ----------------------------------------------------------------------
  -- ����� � the domain searched.  Nonempty BY CONSTRUCTION (a head and a
  -- tail, not a list plus a side condition), carrying its fitness and the
  -- verification that every point of it was actually clean.  So there is
  -- no way to write down "unrefuted over nothing"; it is not a value that
  -- was rejected, it is a value that does not exist.
  ----------------------------------------------------------------------
  record विषयः (c : वाद) : Type where
    constructor विषय
    field
      प्रथमः  : E
      शेषाः   : List E
      योग्यता : योग्य (प्रथमः ∷ शेषाः)
      शुद्धिः  : सर्वे (λ e → वाम c e ≡ दक्षिण c e) (प्रथमः ∷ शेषाः)
  open विषयः public

  ----------------------------------------------------------------------
  -- � � ������� � one standpoint's verdict.  ������� � ����������: there is
  -- nowhere in this type a bare label can sit.
  ----------------------------------------------------------------------
  data निर्णयः (c : वाद) : Type where
    सिद्धः      : ((e : E) → वाम c e ≡ दक्षिण c e) → निर्णयः c
    खण्डितः     : (e : E) → ¬ (वाम c e ≡ दक्षिण c e) → निर्णयः c
    अविरुद्धः    : विषयः c → निर्णयः c
    निर्धर्मी    : (i j : ℕ) → ¬ (i ≡ j) → निर्णयः c
    तूष्णीम्     : (चिह्नम् : ℕ) → ¬ (शब्दकोश चिह्नम्) → निर्णयः c

  ----------------------------------------------------------------------
  -- � � �������� � the label, and the ONLY way to hold one is to project it
  -- off a verdict that exists.  �������� has no field to put a witness in, so
  -- it cannot claim one; and ������� has no inverse (§�), so a report that
  -- keeps the label has not kept the verdict and cannot pretend it did.
  ----------------------------------------------------------------------
  data कोटिः : Type where
    क-सिद्धः क-खण्डितः क-अविरुद्धः क-निर्धर्मी क-तूष्णीम् : कोटिः

  भङ्गः : {c : वाद} → निर्णयः c → कोटिः
  भङ्गः (सिद्धः _)      = क-सिद्धः
  भङ्गः (खण्डितः _ _)   = क-खण्डितः
  भङ्गः (अविरुद्धः _)    = क-अविरुद्धः
  भङ्गः (निर्धर्मी _ _ _) = क-निर्धर्मी
  भङ्गः (तूष्णीम् _ _)    = क-तूष्णीम्

  ----------------------------------------------------------------------
  -- � � ����������� � what two disagreeing standpoints return.  Not an error
  -- (an error is � and has no successor) and not an average (an average
  -- keeps neither side).  It keeps BOTH verdicts whole and carries the
  -- �����: the next ���, born from the ���.
  --   ���������� ����� ���� � ����� ������, � ������ � �������� ��������� ���� ����� �
  ----------------------------------------------------------------------
  record अवक्तव्यम् (c : वाद) : Type where
    constructor अवक्तव्य
    field
      पूर्वः  : निर्णयः c
      अपरः   : निर्णयः c
      विरोधः : ¬ (भङ्गः पूर्वः ≡ भङ्गः अपरः)
      गर्भः   : वाद
  open अवक्तव्यम् public

  -- what the machine actually returns
  प्रतिवचनम् : वाद → Type
  प्रतिवचनम् c = निर्णयः c ⊎ अवक्तव्यम् c

  ----------------------------------------------------------------------
  -- � � What each position can be made to produce, on demand.
  ----------------------------------------------------------------------

  -- ��������� yields a point it ACTUALLY tested, together with the equality
  -- that held there.  This is the ���������������� clause as a term: an
  -- absence claim that cannot exhibit its extent is not one.
  अविरुद्धस्य-परीक्षितः : {c : वाद} (d : विषयः c)
                       → Σ[ e ∈ E ] (वाम c e ≡ दक्षिण c e)
  अविरुद्धस्य-परीक्षितः d = प्रथमः d , fst (शुद्धिः d)

  -- �������� yields the assignment AND the separation at it.
  खण्डितस्य-भेदः : {c : वाद} (e : E) (p : ¬ (वाम c e ≡ दक्षिण c e))
                → Σ[ e' ∈ E ] (¬ (वाम c e' ≡ दक्षिण c e'))
  खण्डितस्य-भेदः e p = e , p

  -- ����������� loses nothing: both standpoints come back out, still
  -- disagreeing.  This is the difference between a fourth position and a
  -- failure code.
  अवक्तव्यं-न-नष्टिः : {c : वाद} (a : अवक्तव्यम् c)
                    → Σ[ p ∈ (निर्णयः c × निर्णयः c) ]
                        (¬ (भङ्गः (fst p) ≡ भङ्गः (snd p)))
  अवक्तव्यं-न-नष्टिः a = (पूर्वः a , अपरः a) , विरोधः a

  -- and the ����� is a �����: a next claim, always.
  गर्भात्-अग्रिमः : {c : वाद} → अवक्तव्यम् c → वाद
  गर्भात्-अग्रिमः = गर्भः

------------------------------------------------------------------------
-- � � The reporting theorem.
--
-- Grouping by �������� is legitimate; treating the
-- �������� as if it still held the verdict is not, and this is why:
--
-- ������� HAS NO SECTION.  Two refutations at different assignments carry the
-- same label, so nothing that reads the label alone can get back to which
-- one it was.  The proof needs a claim with two distinct killing
-- assignments, so it is stated over a concrete one.
------------------------------------------------------------------------

open सन्दर्भ ℕ (λ _ → Unit) (λ _ → Unit)

-- x ≐ 0 : refuted at 1, refuted at 2, and those are different refutations.
मिथ्या : वाद
मिथ्या = (λ e → e) ≐ (λ _ → 0)

एकेन : निर्णयः मिथ्या
एकेन = खण्डितः 1 snotz

द्वाभ्याम् : निर्णयः मिथ्या
द्वाभ्याम् = खण्डितः 2 snotz

-- the assignment, read back off the verdict; every other position is not
-- being asked, and answers 0 rather than being forced into an opinion
बिन्दुः : निर्णयः मिथ्या → ℕ
बिन्दुः (खण्डितः e _) = e
बिन्दुः _             = 0

एकेन≢द्वाभ्याम् : ¬ (एकेन ≡ द्वाभ्याम्)
एकेन≢द्वाभ्याम् p = znots (injSuc (cong बिन्दुः p))

-- same label
समभङ्गौ : भङ्गः एकेन ≡ भङ्गः द्वाभ्याम्
समभङ्गौ = refl

-- THE THEOREM.  No function from labels back to verdicts is a section:
-- the label is a truncation, and §� says truncation is not repairable.
भङ्ग-न-प्रत्यानयनम् : ¬ (Σ[ g ∈ (कोटिः → निर्णयः मिथ्या) ]
                          ((v : निर्णयः मिथ्या) → g (भङ्गः v) ≡ v))
भङ्ग-न-प्रत्यानयनम् (g , sec) =
  एकेन≢द्वाभ्याम् (sym (sec एकेन) ∙ cong g समभङ्गौ ∙ sec द्वाभ्याम्)

-- the same statement for the truncation itself, so the two are visibly one
-- fact: a report that keeps only THAT a verdict was reached is blind to
-- which, and no downstream layer can undo it.
निर्णय-सङ्क्षेपोऽप्रतिकार्यः
  : ¬ (Σ[ r ∈ (∥ निर्णयः मिथ्या ∥₁ → निर्णयः मिथ्या) ]
         ((v : निर्णयः मिथ्या) → r ∣ v ∣₁ ≡ v))
निर्णय-सङ्क्षेपोऽप्रतिकार्यः = न-प्रत्यानयनम् एकेन द्वाभ्याम् एकेन≢द्वाभ्याम्

-- and one more, because it is the shape the reporting layer actually
-- takes: ANY report computed from the label alone gives the same answer to
-- two different refutations.  This is not a bug in some report; it is what
-- the type says.  A tally row that means to stay honest must therefore
-- carry a verdict, not a �������� � which is what interactive/ does.
लेखो-अन्धः : {B : Type} (f : कोटिः → B)
           → f (भङ्गः एकेन) ≡ f (भङ्गः द्वाभ्याम्)
लेखो-अन्धः f = cong f समभङ्गौ
