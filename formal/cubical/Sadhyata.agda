-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- साध्यता — आर्यभटस्य शर्तः उभयतः : रेखिक-संगमः a·X ≡ b·Y + c साध्यः
-- यदि च केवलं यदि गुरुतमः g संख्यां c विभजति ।
--   पर्याप्तता (sufficiency) : Yuti.युतिः (c ≡ g·m ⟹ साधनम्) ।
--   आवश्यकता (necessity, अत्र) : यदि साधनम् अस्ति, तर्हि g ∣ c ।
-- (Āryabhaṭa's solvability condition, both directions: the linear
-- congruence is solvable iff the gcd divides c.  Sufficiency is युतिः;
-- necessity is proved here — if any solution exists, the gcd divides c.)
--
-- न्यायः : g उभौ a b विभजति (सिद्धः) ⟹ g अ·X, b·Y च विभजति ; a·X = b·Y + c
-- ⟹ g अन्तरं c विभजति (∣-अन्तरः) ।  आर्यभटस्य अन्तर-वियोजनम् एव ।
-- (g divides both a and b, hence a·X and b·Y; and a·X = b·Y + c forces
-- g ∣ c by the difference law — Āryabhaṭa's own subtraction, once more.)
------------------------------------------------------------------------

module Sadhyata where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_ ; ·-assoc ; ·-comm)
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-untrunc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import GurutamaSiddha using (∣-अन्तर ; सिद्धः)
open import Yuti using (युतिसिद्धि ; वामयुति ; दक्षिणयुति)
open import Gati using (गुरुः ; फल ; गति)

------------------------------------------------------------------------
-- ∣-गुण — विभाजकः गुणिते अपि विभजति : g ∣ n → g ∣ (n · k) ।
------------------------------------------------------------------------

∣-गुण : {g n : ℕ} → g ∣ n → (k : ℕ) → g ∣ (n · k)
∣-गुण {g} {n} p k =
  let (q , e) = ∣-untrunc p            -- q · g ≡ n
  in ∣ (q · k)
     , ( sym (·-assoc q k g)
       ∙ cong (q ·_) (·-comm k g)
       ∙ ·-assoc q g k
       ∙ cong (_· k) e )               -- (q · k) · g ≡ n · k
     ∣₁

------------------------------------------------------------------------
-- आवश्यकता — यदि साधनम् अस्ति, तर्हि गुरुतमः c विभजति ।
------------------------------------------------------------------------

आवश्यकता : (f a b g c : ℕ)
         → फल (गति f a b) ≡ गुरुः g
         → युतिसिद्धि a b c
         → g ∣ c
आवश्यकता f a b g c eq sol =
  let cd  = fst (सिद्धः f a b g eq)     -- isCD a b g  =  (g ∣ a) × (g ∣ b)
      g∣a = fst cd
      g∣b = snd cd
  in उत्तरम् sol g∣a g∣b
  where
  उत्तरम् : युतिसिद्धि a b c → g ∣ a → g ∣ b → g ∣ c
  उत्तरम् (वामयुति X Y pf) g∣a g∣b =
    -- a·X ≡ b·Y + c ; g ∣ a·X, g ∣ b·Y ⟹ g ∣ c
    ∣-अन्तर (subst (g ∣_) pf (∣-गुण g∣a X)) (∣-गुण g∣b Y)
  उत्तरम् (दक्षिणयुति X Y pf) g∣a g∣b =
    -- b·Y ≡ a·X + c ; g ∣ b·Y, g ∣ a·X ⟹ g ∣ c
    ∣-अन्तर (subst (g ∣_) pf (∣-गुण g∣b Y)) (∣-गुण g∣a X)
