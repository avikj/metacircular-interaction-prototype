{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����� � the soul's equation of motion: srava, bandha, savara, nirjar,
-- and the zero state (moka) is absorbing.  The dynamics the arena is FOR.
--
-- SOURCE.  Umsvti, *Tattvrthastra* (~2nd�5th c.).  The seven tattvas
-- (1.4): jva, ajva, srava, bandha, savara, nirjar, moka � the last
-- five are a DYNAMICS on the first two.  Precisely:
--   6.1�2  kya-v-mana-karma yoga; sa srava � activity (yoga) of
--          body/speech/mind is srava, the INFLUX of karma.
--   8.2�3  sakayatvt � pudgaln datte sa bandha � with passion the
--          jva TAKES UP karma-fit pudgala: BINDING.  Its four aspects are
--          prakti (nature), sthiti (duration), anubhga (intensity), and
--          PRADEA (the COUNT of karmic pudgala) � 8.4.  This file is the
--          pradea-bandha: karma is krmaa PUDGALA, so its count is a
--          `Pudgala` count, and its conservation is `Pudgala.������-�������`.
--   9.1    srava-nirodha savara � STOPPAGE of influx is savara.
--   9.3    (tapas) nirjar ca � and SHEDDING of bound karma is nirjar.
--   10.2�3 ktsna-karma-kayo moka � liberation is the COMPLETE
--          destruction (kaya) of karma: the zero state.
--   10.5�7 tad-anantaram rdhva gacchaty  lokntt � thereupon the jva
--          rises to the END of the loka (and no further: dharma, the
--          medium of motion, ends there � `DharmaAdharma.�����������-������`).
--
-- THE DYNAMICS, exactly.  One samaya (`Kala`) transforms the bound-count s
-- by influx a (from yoga) then shedding r (from nirjar):
--     ������-�������  s  �  (s + a) � r .
-- savara is the regime a = 0.  Two regimes and their fixed point:
--
--   §2  �����-�������� � under savara the count never grows: (s+0) � r � s.
--   §3  ����-����������-������ � under savara with nirjar (r>0), the count
--       STRICTLY drops while positive: 0 < s � (s � r) < s.
--   §4  �������-��������� � ktsna-karma-kaya is REACHED: with minimal
--       nirjar (r=1) under savara, iterating the samaya-step from s
--       reaches 0 in s samayas.  (General r � 1 reaches it no slower.)
--   §5  ��������-���� � the zero state is ABSORBING: under savara, 0 � 0.
--       na punar-vtti � the siddha does not return.
--   §6  ������ � WITHOUT savara, when influx exceeds shedding (a > r) the
--       count grows: s < (s + a) � r.  Bondage deepens � bhava-bhramaa.
--   §7  ������-������� � nirjar does not DESTROY pudgala; the karma present
--       splits into remaining + shed with nothing lost:
--         (s + a) ≡ ((s + a) � r) + (shed)   for r � s + a.
--       moka is total DISSOCIATION of matter from the jva, not
--       annihilation of matter (`Pudgala.������-�������`).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Karma_TheSoulsEquationOfMotionIsInfluxBindingStoppageSheddingAndTheZeroStateIsMoksaAbsorbing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; predℕ)
open import Cubical.Data.Nat.Properties using (zero∸ ; n∸n ; +-comm ; +-zero ; +-suc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; predℕ-≤-predℕ ; suc-≤-suc ; zero-≤ ; ≤-∸-+-cancel)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)

------------------------------------------------------------------------
-- §1  The bound-count and the one-samaya transformation.
------------------------------------------------------------------------

बद्धम् : Type          -- the pradeśa-bandha: count of bound karmic pudgala
बद्धम् = ℕ

-- one samaya: influx a (from yoga), then shedding r (from nirjar)
एकसमय-परिणामः : (a r : ℕ) → बद्धम् → बद्धम्
एकसमय-परिणामः a r s = (s + a) ∸ r

-- savara is exactly the a = 0 regime
संवरे : (r : ℕ) → बद्धम् → बद्धम्
संवरे r s = एकसमय-परिणामः 0 r s      -- = (s + 0) ∸ r

------------------------------------------------------------------------
-- helpers on � (proved here; the library gives zero�, n�n)
------------------------------------------------------------------------

∸-≤ : (m r : ℕ) → (m ∸ r) ≤ m
∸-≤ m zero        = ≤-refl
∸-≤ zero (suc r)  = zero-≤
∸-≤ (suc m) (suc r) = ≤-trans (∸-≤ m r) (1 , refl)

-- (s + 0) ≡ s, so ����� r s = s � r
संवर-रूपम् : (r s : ℕ) → संवरे r s ≡ s ∸ r
संवर-रूपम् r s = cong (_∸ r) (+-zero s)

योग-अपनयनम् : (x y : ℕ) → (x + y) ∸ x ≡ y
योग-अपनयनम् zero    y = refl
योग-अपनयनम् (suc x) y = योग-अपनयनम् x y

------------------------------------------------------------------------
-- §2  �����-�������� � under savara the count never grows.
------------------------------------------------------------------------

संवरे-अवर्धनम् : (r s : ℕ) → संवरे r s ≤ s
संवरे-अवर्धनम् r s = subst (_≤ s) (sym (संवर-रूपम् r s)) (∸-≤ s r)

------------------------------------------------------------------------
-- §3  ����-����������-������ � with nirjar (r>0), strict drop while positive.
------------------------------------------------------------------------

संवर-नैर्जर्ये-क्षयः : (k s : ℕ) → संवरे (suc k) (suc s) < suc s
संवर-नैर्जर्ये-क्षयः k s =
  subst (_< suc s) (sym (संवर-रूपम् (suc k) (suc s)))
        (suc-≤-suc (∸-≤ s k))
  -- (suc s) � (suc k) = s � k � s < suc s

------------------------------------------------------------------------
-- §4  �������-��������� � ktsna-karma-kaya is reached (minimal nirjar r=1).
--     Iterating the samaya-step (= pred�) from s reaches 0 in s samayas.
------------------------------------------------------------------------

iterate : ℕ → (ℕ → ℕ) → ℕ → ℕ
iterate zero    f x = x
iterate (suc n) f x = iterate n f (f x)

private
  ≤0→≡0 : (m : ℕ) → m ≤ 0 → m ≡ 0
  ≤0→≡0 zero    _        = refl
  ≤0→≡0 (suc m) (k , p)  = ⊥-rec (snotz (sym (+-suc k m) ∙ p))
    where open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
          open import Cubical.Data.Nat using (snotz)

  क्षय-सहायः : (n m : ℕ) → m ≤ n → iterate n predℕ m ≡ 0
  क्षय-सहायः zero    m m≤n = cong (iterate zero predℕ) (≤0→≡0 m m≤n)
  क्षय-सहायः (suc n) m m≤n = क्षय-सहायः n (predℕ m) (predℕ-≤-predℕ m≤n)

-- under savara with minimal nirjar, ����� 1 s = s � 1 = pred� s
संवर-एक-पदम् : (s : ℕ) → संवरे 1 s ≡ predℕ s
संवर-एक-पदम् zero    = refl
संवर-एक-पदम् (suc s) = संवर-रूपम् 1 (suc s)

मोक्ष-प्राप्तिः : (s : ℕ) → iterate s predℕ s ≡ 0
मोक्ष-प्राप्तिः s = क्षय-सहायः s s ≤-refl

------------------------------------------------------------------------
-- §5  ��������-���� � the zero state is absorbing: under savara, 0 � 0.
------------------------------------------------------------------------

मोक्षः-अचलः : (r : ℕ) → संवरे r 0 ≡ 0
मोक्षः-अचलः r = संवर-रूपम् r 0 ∙ zero∸ r

------------------------------------------------------------------------
-- §6  ������ � without savara, influx over shedding grows the bondage.
--     Take a = r + suc d (a > r); then (s + a) � r = s + suc d > s.
------------------------------------------------------------------------

open import Cubical.Data.Nat.Properties using (+-assoc)

संसारः : (s r d : ℕ) → s < एकसमय-परिणामः (r + suc d) r s
संसारः s r d =
  subst (s <_) (sym reduce) grows
  where
  -- (s + (r + suc d)) � r = (r + (s + suc d)) � r = s + suc d
  reduce : एकसमय-परिणामः (r + suc d) r s ≡ s + suc d
  reduce =
      cong (_∸ r) (+-assoc s r (suc d) ∙ cong (_+ suc d) (+-comm s r) ∙ sym (+-assoc r s (suc d)))
    ∙ योग-अपनयनम् r (s + suc d)
  grows : s < s + suc d
  grows = d , (+-suc d s ∙ cong suc (+-comm d s) ∙ sym (+-suc s d))

------------------------------------------------------------------------
-- §7  ������-������� � nirjar dissociates, it does not destroy: the karma
--     present splits into remaining + shed, nothing lost (r � p).
------------------------------------------------------------------------


प्रदेश-नित्यम् : (p r : ℕ) → r ≤ p → (p ∸ r) + r ≡ p
प्रदेश-नित्यम् p r r≤p = ≤-∸-+-cancel r≤p
-- the remaining ((p � r), i.e. the still-bound after nirjar) plus the shed
-- (r) equals the karma present (p): moka is total DISSOCIATION of pudgala,
-- not its annihilation (Pudgala.������-�������).
