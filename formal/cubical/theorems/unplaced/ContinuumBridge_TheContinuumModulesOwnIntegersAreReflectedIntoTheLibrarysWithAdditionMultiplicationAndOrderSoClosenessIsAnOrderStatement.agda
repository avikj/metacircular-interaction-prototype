{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ContinuumBridge — SantataDhara builds its ℤ, ℚ, ℚ⁺ and the closeness
-- relation from scratch, with a Boolean order.  To develop analysis
-- over its continuum the arithmetic must be reasoned about, and the
-- pinned library already carries the lemmas: this module maps the
-- continuum module's integers onto the library's, shows the map
-- preserves addition and multiplication, and shows the Boolean order
-- decides the library's order.  From that the closeness relation
-- Close ε p q becomes a statement in the library's ℤ, on which the ring
-- solver and the order lemmas apply.  This is the first storey of the
-- analysis tower named in the remainder.
--
--   §1  toℤ, and toℤ (a +ℤ b) ≡ toℤ a + toℤ b, toℤ (a ·ℤ b) ≡ toℤ a · toℤ b;
--   §2  ltℕb m n ≡ true ⟺ m < n on ℕ, and ltℤb a b ≡ true ⟺ toℤ a < toℤ b;
--   §3  Close ε p q ⟺ an order statement between library integers.
--
-- SYĀT.  A bridge, nothing more: no new number, no new relation.  Every
-- statement is about the continuum module's definitions as they stand.
------------------------------------------------------------------------

module ContinuumBridge_TheContinuumModulesOwnIntegersAreReflectedIntoTheLibrarysWithAdditionMultiplicationAndOrderSoClosenessIsAnOrderStatement where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; +-zero ; +-comm ; ·-comm)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; sucℤ ; predℤ ; -_) renaming (_+_ to _+i_ ; _·_ to _·i_)
open import Cubical.Data.Int.Properties using (pos+ ; sucℤ+ ; predℤ+ ; predSuc ; sucPred ; pos·pos ; pos·negsuc ; negsuc·pos ; negsuc·negsuc)
open import Cubical.Data.Bool using (Bool ; true ; false)

import SantataDhara_TheContinuumBuiltFromTheAxiomsWithItsLimitsAsConstructors as S

------------------------------------------------------------------------
-- §1  the integers
------------------------------------------------------------------------

toℤ : S.ℤ → ℤ
toℤ (S.pos n) = pos n
toℤ (S.negsuc n) = negsuc n

-- library facts about the mixed sums, one step at a time
pos+negsuc-step : (m n : ℕ) → pos (suc m) +i negsuc (suc n) ≡ pos m +i negsuc n
pos+negsuc-step m n = cong predℤ (sym (sucℤ+ (pos m) (negsuc n))) ∙ predSuc (pos m +i negsuc n)

negsuc+pos-step : (m n : ℕ) → negsuc (suc m) +i pos (suc n) ≡ negsuc m +i pos n
negsuc+pos-step m n = cong sucℤ (sym (predℤ+ (negsuc m) (pos n))) ∙ sucPred (negsuc m +i pos n)

negsuc0+pos : (n : ℕ) → negsuc 0 +i pos n ≡ predℤ (pos n)
negsuc0+pos zero = refl
negsuc0+pos (suc n) = cong sucℤ (negsuc0+pos n) ∙ sucPred (pos n) ∙ sym (predSuc (pos n))

-- addition, by the four constructor cases; the mixed cases follow the
-- continuum module's local `diff` step by step, definitionally
toℤ-+ : (a b : S.ℤ) → toℤ (a S.+ℤ b) ≡ toℤ a +i toℤ b
toℤ-+ (S.pos m) (S.pos n) = pos+ m n
toℤ-+ (S.negsuc m) (S.negsuc n) = lemma m n
  where
    lemma : (m n : ℕ) → negsuc (suc (m + n)) ≡ negsuc m +i negsuc n
    lemma m zero = cong (λ k → negsuc (suc k)) (+-zero m)
    lemma m (suc n) = cong (λ k → negsuc (suc k)) (+-suc m n) ∙ cong predℤ (lemma m n)
toℤ-+ (S.pos m) (S.negsuc n) = mixed m n
  where
    mixed : (m n : ℕ) → toℤ (S.pos m S.+ℤ S.negsuc n) ≡ pos m +i negsuc n
    mixed zero zero = refl
    mixed zero (suc n) = cong predℤ (mixed zero n)
    mixed (suc m) zero = refl
    mixed (suc m) (suc n) = mixed m n ∙ sym (pos+negsuc-step m n)
toℤ-+ (S.negsuc m) (S.pos n) = mixed m n
  where
    mixed : (m n : ℕ) → toℤ (S.negsuc m S.+ℤ S.pos n) ≡ negsuc m +i pos n
    mixed zero zero = refl
    mixed (suc m) zero = refl
    mixed zero (suc n) = sym (negsuc0+pos (suc n))
    mixed (suc m) (suc n) = mixed m n ∙ sym (negsuc+pos-step m n)

-- multiplication
toℤ-· : (a b : S.ℤ) → toℤ (a S.·ℤ b) ≡ toℤ a ·i toℤ b
toℤ-· (S.pos m) (S.pos n) = pos·pos m n
toℤ-· (S.negsuc m) (S.negsuc n) = pos·pos (suc m) (suc n) ∙ sym (negsuc·negsuc m n)
toℤ-· (S.pos m) (S.negsuc n) = mixed ∙ sym (pos·negsuc m n)
  where
    -- the continuum module's local `neg k` is − pos k, seen by cases on k
    mixed : toℤ (S.pos m S.·ℤ S.negsuc n) ≡ - (pos m ·i pos (suc n))
    mixed with m · suc n | pos·pos m (suc n)
    ... | zero | e = cong -_ e
    ... | suc k | e = cong -_ e
toℤ-· (S.negsuc m) (S.pos n) = mixed ∙ sym (negsuc·pos m n)
  where
    mixed : toℤ (S.negsuc m S.·ℤ S.pos n) ≡ - (pos (suc m) ·i pos n)
    mixed with suc m · n | pos·pos (suc m) n
    ... | zero | e = cong -_ e
    ... | suc k | e = cong -_ e

------------------------------------------------------------------------
-- §2  the Boolean orders decide the library's orders
------------------------------------------------------------------------

open import Cubical.Data.Nat using (znots ; snotz ; injSuc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero) renaming (≤-refl to ≤ℕ-refl)
open import Cubical.Data.Int.Properties using (injPos ; pos0+)
open import Cubical.Data.Int.Order using (negsuc<pos ; ¬pos≤negsuc ; negsuc-≤-negsuc ; pos-≤-pos) renaming (_≤_ to _≤ℤ_ ; _<_ to _<ℤ_)
open import Cubical.Data.Bool using (true≢false ; false≢true)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

-- ℕ: ltℕb decides <
ltℕb-sound : (m n : ℕ) → S.ltℕb m n ≡ true → m < n
ltℕb-sound m zero e = ⊥-rec (false≢true e)
ltℕb-sound zero (suc n) _ = suc-≤-suc zero-≤
ltℕb-sound (suc m) (suc n) e = suc-≤-suc (ltℕb-sound m n e)

ltℕb-complete : (m n : ℕ) → m < n → S.ltℕb m n ≡ true
ltℕb-complete m zero m<0 = ⊥-rec (¬-<-zero m<0)
ltℕb-complete zero (suc n) _ = refl
ltℕb-complete (suc m) (suc n) m<n = ltℕb-complete m n (pred-≤-pred m<n)

-- pos k ≤ pos l on ℤ is k ≤ l on ℕ
pos≤pos→ : (k l : ℕ) → pos k ≤ℤ pos l → k ≤ l
pos≤pos→ k l (i , p) = i , (+-comm i k ∙ injPos (pos+ k i ∙ p))

→pos≤pos : (k l : ℕ) → k ≤ l → pos k ≤ℤ pos l
→pos≤pos k l (i , p) = i , (sym (pos+ k i) ∙ cong pos (+-comm k i ∙ p))

-- ℤ: ltℤb decides <
ltℤb-sound : (a b : S.ℤ) → S.ltℤb a b ≡ true → toℤ a <ℤ toℤ b
ltℤb-sound (S.pos m) (S.pos n) e = →pos≤pos (suc m) n (ltℕb-sound m n e)
ltℤb-sound (S.negsuc m) (S.pos n) _ = negsuc<pos
ltℤb-sound (S.pos m) (S.negsuc n) e = ⊥-rec (false≢true e)
ltℤb-sound (S.negsuc zero) (S.negsuc n) e = ⊥-rec (¬-<-zero (ltℕb-sound n zero e))
ltℤb-sound (S.negsuc (suc m)) (S.negsuc n) e =
  negsuc-≤-negsuc (→pos≤pos n m (pred-≤-pred (ltℕb-sound n (suc m) e)))

ltℤb-complete : (a b : S.ℤ) → toℤ a <ℤ toℤ b → S.ltℤb a b ≡ true
ltℤb-complete (S.pos m) (S.pos n) lt = ltℕb-complete m n (pos≤pos→ (suc m) n lt)
ltℤb-complete (S.negsuc m) (S.pos n) _ = refl
ltℤb-complete (S.pos m) (S.negsuc n) lt = ⊥-rec (¬pos≤negsuc lt)
ltℤb-complete (S.negsuc zero) (S.negsuc n) lt = ⊥-rec (¬pos≤negsuc lt)
ltℤb-complete (S.negsuc (suc m)) (S.negsuc n) lt =
  ltℕb-complete n (suc m) (suc-≤-suc (pos≤pos→ n m (pos-≤-pos lt)))

------------------------------------------------------------------------
-- §3  the closeness relation as an order statement in the library's ℤ
------------------------------------------------------------------------

open import Cubical.Data.Int using (abs)
open S.ℚ using (num ; den)
open S.ℚ⁺ using (num⁺ ; den⁺)

-- numerator and denominator of the absolute value
abs-num : (x : S.ℚ) → toℤ (num (S.absℚ x)) ≡ pos (abs (toℤ (num x)))
abs-num (S.pos n S./1+ d) = refl
abs-num (S.negsuc n S./1+ d) = refl

abs-den : (x : S.ℚ) → den (S.absℚ x) ≡ den x
abs-den (S.pos n S./1+ d) = refl
abs-den (S.negsuc n S./1+ d) = refl

-- the difference p − q, numerator in the library's ℤ
D : S.ℚ → S.ℚ → ℤ
D p q = toℤ (num p) ·i pos (suc (den q)) +i (- (toℤ (num q) ·i pos (suc (den p))))

-- the continuum module's local negation is seen by cases on its argument
diff-num : (p q : S.ℚ) → toℤ (num (p S.−ℚ q)) ≡ D p q
diff-num p q with num q S.·ℤ S.pos (suc (den p)) | toℤ-· (num q) (S.pos (suc (den p)))
... | S.pos zero | e = toℤ-+ _ (S.pos 0) ∙ cong₂ _+i_ (toℤ-· (num p) (S.pos (suc (den q)))) (cong -_ e)
... | S.pos (suc k) | e = toℤ-+ _ (S.negsuc k) ∙ cong₂ _+i_ (toℤ-· (num p) (S.pos (suc (den q)))) (cong -_ e)
... | S.negsuc k | e = toℤ-+ _ (S.pos (suc k)) ∙ cong₂ _+i_ (toℤ-· (num p) (S.pos (suc (den q)))) (cong -_ e)

diff-den : (p q : S.ℚ) → den (p S.−ℚ q) ≡ den p + den q + den p · den q
diff-den p q = refl

-- THE CHARACTERISATION: closeness is an order statement between library integers
closeℤ : S.ℚ⁺ → S.ℚ → S.ℚ → Type
closeℤ ε p q =
  pos (abs (D p q)) ·i pos (suc (den⁺ ε)) <ℤ pos (suc (num⁺ ε)) ·i pos (suc (den p + den q + den p · den q))

private
  lhs-path : (ε : S.ℚ⁺) (p q : S.ℚ)
           → toℤ (num (S.absℚ (p S.−ℚ q)) S.·ℤ S.pos (suc (den⁺ ε))) ≡ pos (abs (D p q)) ·i pos (suc (den⁺ ε))
  lhs-path ε p q =
    toℤ-· (num (S.absℚ (p S.−ℚ q))) (S.pos (suc (den⁺ ε)))
    ∙ cong (_·i pos (suc (den⁺ ε))) (abs-num (p S.−ℚ q) ∙ cong (λ z → pos (abs z)) (diff-num p q))

  rhs-path : (ε : S.ℚ⁺) (p q : S.ℚ)
           → toℤ (S.pos (suc (num⁺ ε)) S.·ℤ S.pos (suc (den (S.absℚ (p S.−ℚ q)))))
           ≡ pos (suc (num⁺ ε)) ·i pos (suc (den p + den q + den p · den q))
  rhs-path ε p q =
    toℤ-· (S.pos (suc (num⁺ ε))) (S.pos (suc (den (S.absℚ (p S.−ℚ q)))))
    ∙ cong (λ k → pos (suc (num⁺ ε)) ·i pos (suc k)) (abs-den (p S.−ℚ q) ∙ diff-den p q)

Close→closeℤ : (ε : S.ℚ⁺) (p q : S.ℚ) → S.Close ε p q → closeℤ ε p q
Close→closeℤ ε p q c =
  subst2 _<ℤ_ (lhs-path ε p q) (rhs-path ε p q)
    (ltℤb-sound (num (S.absℚ (p S.−ℚ q)) S.·ℤ S.pos (suc (den⁺ ε)))
                (S.pos (suc (num⁺ ε)) S.·ℤ S.pos (suc (den (S.absℚ (p S.−ℚ q))))) c)

closeℤ→Close : (ε : S.ℚ⁺) (p q : S.ℚ) → closeℤ ε p q → S.Close ε p q
closeℤ→Close ε p q c =
  ltℤb-complete (num (S.absℚ (p S.−ℚ q)) S.·ℤ S.pos (suc (den⁺ ε)))
                (S.pos (suc (num⁺ ε)) S.·ℤ S.pos (suc (den (S.absℚ (p S.−ℚ q)))))
    (subst2 _<ℤ_ (sym (lhs-path ε p q)) (sym (rhs-path ε p q)) c)

-- the concrete instance of the continuum module, read through the bridge
close-half-third-ℤ : closeℤ S.quarter⁺ S.half⁻ S.third
close-half-third-ℤ = Close→closeℤ S.quarter⁺ S.half⁻ S.third S.close-half-third
