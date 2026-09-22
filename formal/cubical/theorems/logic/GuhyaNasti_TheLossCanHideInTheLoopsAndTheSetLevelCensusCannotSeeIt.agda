{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������-������ � the concealed loss: it can hide in the loops, and the
-- set-level census cannot see it.
--
-- `WholePartialDesa`'s trichotomy � and `�����-�����������` � grade a
-- fibre by its POINTS: empty (�����������), one up to path (��������), or two
-- exhibitably distinct (���������).  In cubespace there is a fourth
-- condition of a fibre, and it defeats all three detectors at once:
--
--     the fibre of  ������ : S� � Unit  at tt  is S� itself, and S� is
--
--       inhabited                     � ����������� cannot fire;
--       merely connected: any two
--       points are ����-equal          � ��������� cannot fire, because no
--                                        exhibitably distinct pair EXISTS;
--       yet not a proposition, hence
--       not contractible               � �������� cannot fire either.
--
-- The crowding is real and it is INVISIBLE AT POINTS: it lives one
-- dimension up, in the loops, and it is not "some loss" � it is exactly
-- � (`winding`, ΩS�Iso�), the same charge `Durnaya_�` identified as what
-- every set-valued carrier-observable destroys.  The concealed ������ of
-- this fibre IS the gauge charge.
--
-- WHAT THIS MEANS FOR THE CENSUS, said exactly.  The trichotomy's
-- exhaustiveness was a SET-LEVEL theorem: for fibres that are sets, the
-- three verdicts cover.  For higher fibres the sevenfold does not
-- disappear � it RESTRATIFIES: at each h-level the same three seeds
-- reappear (here: ��-����, ��-��� with charge �).  Sydvda is graded by
-- dimension; a census that stops at points is a durnaya one storey up,
-- and this module is its checked counterexample.
--
-- The claim is that their refusal to let one standpoint exhaust the object
-- is, in cubespace, a THEOREM about which fibres a pointwise census can
-- classify.
------------------------------------------------------------------------

module GuhyaNasti_TheLossCanHideInTheLoopsAndTheSetLevelCensusCannotSeeIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Int using (ℤ ; pos ; sucℤ)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Foundations.GroupoidLaws using (rUnit)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; map ; rec ; isPropPropTrunc)
open import Cubical.HITs.S1
  using (S¹ ; base ; loop ; ΩS¹ ; winding ; intLoop ; windingℤLoop ; isConnectedS¹)

------------------------------------------------------------------------
-- � � the map, and its fibre identified: ��� ������ tt � S�.
------------------------------------------------------------------------

बिन्दु : S¹ → Unit
बिन्दु _ = tt

शेष : Unit → Type
शेष u = Σ[ s ∈ S¹ ] (बिन्दु s ≡ u)

शेष≃S¹ : शेष tt ≃ S¹
शेष≃S¹ = isoToEquiv (iso fst (λ s → s , refl)
                         (λ _ → refl)
                         (λ (s , p) i → s , isSetUnit tt tt refl p i))

------------------------------------------------------------------------
-- � � ����������� cannot fire: the fibre is inhabited.
------------------------------------------------------------------------

सत्त्वम् : शेष tt
सत्त्वम् = base , refl

------------------------------------------------------------------------
-- � � ��������� cannot fire: any two points of the fibre are MERELY equal �
-- no exhibitably distinct pair exists to name.
------------------------------------------------------------------------

मुक्त-सम्बन्धः : (x y : शेष tt) → ∥ x ≡ y ∥₁
मुक्त-सम्बन्धः (x , p) (y , q) =
  map (λ (r : x ≡ y) → Σ≡Prop (λ s → isSetUnit (बिन्दु s) tt) r)
      (सम्बद्धम् x y)
  where
    सम्बद्धम् : (x y : S¹) → ∥ x ≡ y ∥₁
    सम्बद्धम् x y =
      rec isPropPropTrunc
        (λ (px : base ≡ x) →
          map (λ (py : base ≡ y) → sym px ∙ py) (isConnectedS¹ y))
        (isConnectedS¹ x)

------------------------------------------------------------------------
-- � � �������� cannot fire either: the fibre is NOT a proposition.  If every
-- two points were (exhibitably) equal, transporting along ����S� would make
-- S� a proposition, forcing loop ≡ refl � and winding refutes that with the
-- charge: 1 � 0 in �.
------------------------------------------------------------------------

एक≢शून्य : ¬ (pos (suc zero) ≡ pos zero)
एक≢शून्य p = znots (sym (cong अङ्क p))
  where
    अङ्क : ℤ → _
    अङ्क (pos n) = n
    अङ्क _       = zero

वक्र-अनिवार्यम् : ¬ (loop ≡ refl)
वक्र-अनिवार्यम् p =
  एक≢शून्य (sym (windingℤLoop (pos (suc zero))) ∙ cong winding lem ∙ refl)
  where
    -- intLoop 1 = refl ∙ loop; with p : loop ≡ refl its winding is 0.
    lem : intLoop (pos (suc zero)) ≡ refl
    lem = (λ i → intLoop (pos zero) ∙ p i) ∙ sym (rUnit refl)

न-प्रोप् : ¬ ((x y : शेष tt) → x ≡ y)
न-प्रोप् h = वक्र-अनिवार्यम् loop≡refl
  where
    -- a prop that is inhabited is contractible; contract S� through ����S�
    prS¹ : (x y : S¹) → x ≡ y
    prS¹ x y i = fst (h (x , refl) (y , refl) i)
    loop≡refl : loop ≡ refl
    loop≡refl i j =
      hcomp (λ k → λ { (i = i0) → prS¹ base (loop j) k
                     ; (i = i1) → prS¹ base base k
                     ; (j = i0) → prS¹ base base k
                     ; (j = i1) → prS¹ base base k })
            base

------------------------------------------------------------------------
-- � � the concealed charge is exactly �: what the pointwise census cannot
-- see is not "some crowding" but the winding � identified, not bounded.
-- (The library's ΩS�Iso� is the identification; re-exported here as the
-- fibre's own loop charge through ����S�'s base point.)
------------------------------------------------------------------------

गुह्य-भारः : (सत्त्वम् ≡ सत्त्वम्) → ℤ
गुह्य-भारः p = winding (λ i → fst (p i))

गुह्य-भारः-अशून्यः : Σ[ p ∈ (सत्त्वम् ≡ सत्त्वम्) ] (¬ (गुह्य-भारः p ≡ pos zero))
गुह्य-भारः-अशून्यः =
  (λ i → loop i , refl) ,
  λ q → एक≢शून्य (sym (windingℤLoop (pos (suc zero)))
                  ∙ cong winding (sym (rUnit loop)) ∙ q)

------------------------------------------------------------------------
-- � � ���������.  This does not overturn the set-level census � for fibres
-- that are sets its trichotomy is exhaustive.
-- What it proves is the census's own SCOPE: h-level is a
-- hypothesis, not a formality, and above it the seeds restratify.
------------------------------------------------------------------------
