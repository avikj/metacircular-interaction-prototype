{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ��������� � the local crystal, complete: decidable which regime, walls
-- merging exactly when twice the center vanishes, and the census an
-- equivalence either way.
--
-- THE CHART OF THE TWO-WALL FIELD, INTERNAL TO THE RESIDUE WHEEL.
-- ���������� proved the merge criterion on the � side (p � a + a, both
-- directions); ����-����� counted survivors of abstract walls.  This module
-- closes the chart from inside Fin p with the wheel's own arithmetic
-- (+�, -� � the library's):
--
--   �������-������ : (a ≡ -� a) � (a +� a ≡ �������)
--       the walls coincide exactly when twice the center vanishes �
--       ����������'s iff, now a statement the wheel can pronounce itself;
--   ��������� : for every center a, EITHER (a +� a ≡ ������� and the survivor
--       type of the field is � Fin (p−1)) OR (a +� a � 0 and it is
--       � Fin (p−2)) � the disjunction DECIDED, not assumed, and the
--       census in both branches an identification, never a count.
--
-- With this the local layer of the program is complete as terms: the
-- centering (����������), the elision engine (����-�����), the merge
-- criterion internal (here), the regime decision (here), and the
-- charge that must survive the boundary (������������ ����� / Yamala).
--
-- ON THE NAME.  �������� � crystal, rock-crystal � ordinary ,
-- prominent in the traditions this corpus reads (the sphaika of
-- Nyya's optics examples; the owner's "local prime Fourier crystal"
-- names the same object one instrument later).
------------------------------------------------------------------------

module Sphatika_TheLocalCrystalIsDecidableTheWallsMergeExactlyWhenTwiceTheCenterVanishesAndTheCensusHoldsEitherWay where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; equivFun ; invEq)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Fin using (Fin ; fzero ; discreteFin)
open import Cubical.Data.Fin.Properties using (isSetFin)
open import Cubical.Data.Fin.Arithmetic
  using (_+ₘ_ ; -ₘ_ ; +ₘ-assoc ; +ₘ-comm ; +ₘ-lUnit ; +ₘ-rUnit ; +ₘ-lCancel)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Relation.Nullary.Properties using (isProp¬)

open import DviLopa_TheTwoWallsElideTwoResiduesAndTheSurvivorsAreExactlyCounted
  using (एक-लोपः ; द्वि-लोपः)

private
  variable
    m : ℕ

------------------------------------------------------------------------
शून्यम् : Fin (suc m)
शून्यम् = fzero

-- � � small wheel lemmas: a +� (-� a) ≡ �������, and the merge iff.
------------------------------------------------------------------------

+ₘ-rCancel' : (a : Fin (suc m)) → a +ₘ (-ₘ a) ≡ शून्यम्
+ₘ-rCancel' a = +ₘ-comm a (-ₘ a) ∙ +ₘ-lCancel a

-- the walls coincide exactly when twice the center vanishes.  Both
-- sides are propositions (Fin is a set), so an iso of implications.
सङ्गम-आन्तरः : (a : Fin (suc m)) → (a ≡ -ₘ a) ≃ ((a +ₘ a) ≡ शून्यम्)
सङ्गम-आन्तरः a =
  isoToEquiv (iso अग्रे प्रत्यागमः
                  (λ q → isSetFin _ _ _ q)
                  (λ p → isSetFin _ _ _ p))
  where
    अग्रे : a ≡ -ₘ a → (a +ₘ a) ≡ शून्यम्
    अग्रे p = cong (a +ₘ_) p ∙ +ₘ-rCancel' a

    प्रत्यागमः : (a +ₘ a) ≡ शून्यम् → a ≡ -ₘ a
    प्रत्यागमः q = sym
      ( -ₘ a
          ≡⟨ sym (+ₘ-lUnit (-ₘ a)) ⟩
        शून्यम् +ₘ (-ₘ a)
          ≡⟨ cong (_+ₘ (-ₘ a)) (sym q) ⟩
        (a +ₘ a) +ₘ (-ₘ a)
          ≡⟨ +ₘ-assoc a a (-ₘ a) ⟩
        a +ₘ (a +ₘ (-ₘ a))
          ≡⟨ cong (a +ₘ_) (+ₘ-rCancel' a) ⟩
        a +ₘ शून्यम्
          ≡⟨ +ₘ-rUnit a ⟩
        a ∎ )

------------------------------------------------------------------------
-- � � the survivor type of the centered field at center a, and the
-- merged-regime collapse: when the walls coincide, the two conditions
-- are one proposition.
------------------------------------------------------------------------

क्षेत्रम् : (a : Fin (suc m)) → Type
क्षेत्रम् {m = m} a = Σ[ y ∈ Fin (suc m) ] ((¬ a ≡ y) × (¬ (-ₘ a) ≡ y))

-- for propositions, a redundant pair is one coordinate.
युग्म-सङ्कोचः : {A : Type} → isProp A → (A × A) ≃ A
युग्म-सङ्कोचः pr =
  isoToEquiv (iso fst (λ x → x , x)
                  (λ _ → refl)
                  (λ (x , y) → ΣPathP (refl , pr x y)))

सङ्गत-गणना : (a : Fin (suc m)) → a ≡ -ₘ a → क्षेत्रम् a ≃ Fin m
सङ्गत-गणना {m = m} a p =
  compEquiv
    (isoToEquiv (iso
      (λ (y , (na , _)) → y , na)
      (λ (y , na) → y , (na , λ q → na (p ∙ q)))
      (λ _ → refl)
      (λ (y , (na , nb)) →
        ΣPathP (refl ,
          ΣPathP (refl , isProp¬ ((-ₘ a) ≡ y) _ nb)))))
    (एक-लोपः a)

------------------------------------------------------------------------
-- � � ��������� � the whole chart, decided.  Fin p for p = 2 + m, so the
-- distinct regime lands in Fin m = Fin (p−2) and the merged regime in
-- Fin (suc m) = Fin (p−1).
------------------------------------------------------------------------

स्फटिकः : (a : Fin (suc (suc m)))
       → (((a +ₘ a) ≡ शून्यम्) × (क्षेत्रम् a ≃ Fin (suc m)))
       ⊎ ((¬ (a +ₘ a) ≡ शून्यम्) × (क्षेत्रम् a ≃ Fin m))
स्फटिकः {m = m} a with discreteFin a (-ₘ a)
... | yes p = inl ( equivFun (सङ्गम-आन्तरः a) p , सङ्गत-गणना a p )
... | no ¬p = inr ( (λ q → ¬p (invEq (सङ्गम-आन्तरः a) q))
                  , द्वि-लोपः a (-ₘ a) ¬p )

------------------------------------------------------------------------
-- � � ���������.
-- ��������� decides by discreteFin on the WALLS; deciding on
-- the criterion (a +� a ≡ �������) instead is the same decision through
-- �������-������.  p = 2 + m
-- is any modulus � 2, and primality enters only at the atlas level,
-- where ����������-����� needs the charts at prime moduli.
------------------------------------------------------------------------
