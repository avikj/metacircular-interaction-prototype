{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- कातलान-सीमा — the Catalan bound.
--
-- Handoff §40 ([S18]): the hidden-history equation  q = g + C(q,q)
-- expands in causal trees, q = Σ qₙ with  qₙ₊₁ = Σ_{a+c=n} C(qₐ, q_c),
-- and the Catalan majorant controls it.  The exact finite control:
--
--   for any ℕ-valued sequence x with  x₀ ≤ g  and
--       x_{n+1} ≤ b · Σ_{a+c=n} xₐ x_c,
--   one has   xₙ ≤ bⁿ · Catₙ · gⁿ⁺¹   for every n,
--
-- where Cat₀ = 1, Catₙ₊₁ = Σ_{a+c=n} Catₐ Cat_c  (1, 1, 2, 5, 14, 42, …).
-- The convergence when 4bg < 1 is the analytic statement; the majorant
-- itself is this theorem, proved by strong induction over the pair sum.
------------------------------------------------------------------------
module KatalanaSima_AQuadraticallyMajorizedSequenceIsBoundedByCatalanNumbersTimesPowersSoTheTreeExpansionOfTheHiddenHistoryHasAnExplicitMajorant where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using () renaming (elim to ⊥-elim)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; decRec ; isPropDec)

-- the sum over all pairs (a , c) with a + c = n
D : (n : ℕ) → (ℕ → ℕ → ℕ) → ℕ
D zero    f = f zero zero
D (suc n) f = f zero (suc n) + D n (λ a c → f (suc a) c)

-- D respects pointwise equality on the pairs it sums
D-ext : (n : ℕ) {f g : ℕ → ℕ → ℕ} → ((a c : ℕ) → a + c ≡ n → f a c ≡ g a c) → D n f ≡ D n g
D-ext zero    h = h zero zero refl
D-ext (suc n) h = cong₂ _+_ (h zero (suc n) refl) (D-ext n (λ a c p → h (suc a) c (cong suc p)))

pow : ℕ → ℕ → ℕ
pow b zero    = 1
pow b (suc n) = b · pow b n

private
  pow-+ : (b m n : ℕ) → pow b (m + n) ≡ pow b m · pow b n
  pow-+ b zero    n = sym (+-zero (pow b n))
  pow-+ b (suc m) n = cong (b ·_) (pow-+ b m n) ∙ ·-assoc b (pow b m) (pow b n)

  -- D respects pointwise ≤ on the pairs it sums
  D-mono : (n : ℕ) {f g : ℕ → ℕ → ℕ} → ((a c : ℕ) → a + c ≡ n → f a c ≤ g a c) → D n f ≤ D n g
  D-mono zero    h = h zero zero refl
  D-mono (suc n) h = ≤-+-≤ (h zero (suc n) refl) (D-mono n (λ a c p → h (suc a) c (cong suc p)))

  -- constants pull out of D
  D-scale : (n k : ℕ) (f : ℕ → ℕ → ℕ) → D n (λ a c → k · f a c) ≡ k · D n f
  D-scale zero    k f = refl
  D-scale (suc n) k f = cong (k · f zero (suc n) +_) (D-scale n k (λ a c → f (suc a) c)) ∙ ·-distribˡ k (f zero (suc n)) (D n (λ a c → f (suc a) c))

  -- k ≤ suc n splits
  ≤-split′ : (k n : ℕ) → k ≤ suc n → (k ≤ n) ⊎ (k ≡ suc n)
  ≤-split′ k n (zero  , p) = inr p
  ≤-split′ k n (suc d , p) = inl (d , injSuc p)

  ≤-·-≤ : {m n l k : ℕ} → m ≤ n → l ≤ k → m · l ≤ n · k
  ≤-·-≤ {m} {n} {l} {k} p q = ≤-trans (≤-·k p) (subst2 _≤_ (·-comm l n) (·-comm k n) (≤-·k q))

-- the Catalan numbers through a memo table (structural in the table size):
-- catTab n k = Cat k for k ≤ n
catTab : ℕ → ℕ → ℕ
catTab zero    k = 1
catTab (suc n) k = decRec (λ _ → D n (λ a c → catTab n a · catTab n c)) (λ _ → catTab n k) (discreteℕ k (suc n))

cat : ℕ → ℕ
cat k = catTab k k

_ : cat 3 ≡ 5
_ = refl
_ : cat 5 ≡ 42
_ = refl

private
  -- the table is stable below its size
  stable : (m k : ℕ) → k ≤ m → catTab m k ≡ cat k
  stable zero    k k≤0 = subst (λ j → catTab zero j ≡ catTab j j) (sym (≤0→≡0 k≤0)) refl
  stable (suc n) k k≤sn = lemma (discreteℕ k (suc n)) refl
    where
      lemma : (d : Dec (k ≡ suc n)) → discreteℕ k (suc n) ≡ d → catTab (suc n) k ≡ cat k
      lemma (yes p) _ = cong₂ catTab (sym p) refl
      lemma (no  q) e = cong (decRec _ _) e ∙ stable n k (drop (≤-split′ k n k≤sn))
        where
          drop : (k ≤ n) ⊎ (k ≡ suc n) → k ≤ n
          drop (inl r) = r
          drop (inr r) = ⊥-elim (q r)

-- the recurrence
cat-zero : cat 0 ≡ 1
cat-zero = refl

cat-suc : (n : ℕ) → cat (suc n) ≡ D n (λ a c → cat a · cat c)
cat-suc n =
    cong (decRec _ _) (isPropDec (isSetℕ (suc n) (suc n)) (discreteℕ (suc n) (suc n)) (yes refl))
  ∙ D-ext n (λ a c p → cong₂ _·_ (stable n a (c , +-comm c a ∙ p)) (stable n c (a , p)))

------------------------------------------------------------------------
module Majorant (x : ℕ → ℕ) (b g : ℕ)
                (x₀ : x 0 ≤ g)
                (step : (n : ℕ) → x (suc n) ≤ b · D n (λ a c → x a · x c))
                where

  bound : ℕ → ℕ
  bound n = pow b n · (cat n · pow g (suc n))

  private
    -- the product of two bounds at a + c = n is the common scalar times cat a · cat c
    product-of-bounds : (n a c : ℕ) → a + c ≡ n
      → bound a · bound c ≡ (pow b n · pow g (suc (suc n))) · (cat a · cat c)
    product-of-bounds n a c h =
        shape (pow b a) (cat a) (pow g (suc a)) (pow b c) (cat c) (pow g (suc c))
      ∙ cong₂ (λ u v → (u · v) · (cat a · cat c))
              (sym (pow-+ b a c) ∙ cong (pow b) h)
              (sym (pow-+ g (suc a) (suc c)) ∙ cong (pow g) (cong suc (+-suc a c) ∙ cong (suc ∘ suc) h))
      where
        shape : (Ba Ca Ga Bc Cc Gc : ℕ) → (Ba · (Ca · Ga)) · (Bc · (Cc · Gc)) ≡ ((Ba · Bc) · (Ga · Gc)) · (Ca · Cc)
        shape Ba Ca Ga Bc Cc Gc = solveℕ!

    below : (n : ℕ) (k : ℕ) → k ≤ n → x k ≤ bound k
    below zero k k≤0 = subst (λ k → x k ≤ bound k) (sym (≤0→≡0 k≤0)) (subst (x 0 ≤_) (sym base) x₀)
      where
        base : 1 · (1 · (g · 1)) ≡ g
        base = solveℕ!
    below (suc n) k k≤sn with ≤-split′ k n k≤sn
    ... | inl k≤n = below n k k≤n
    ... | inr k≡sn = subst (λ k → x k ≤ bound k) (sym k≡sn) top
      where
        top : x (suc n) ≤ bound (suc n)
        top = ≤-trans (step n)
                (subst (b · D n (λ a c → x a · x c) ≤_) closed
                       (≤-·-≤ (≤-refl {b}) (D-mono n (λ a c p → ≤-·-≤ (below n a (≤-of a c p)) (below n c (≤-of' a c p))))))
          where
            ≤-of : (a c : ℕ) → a + c ≡ n → a ≤ n
            ≤-of a c p = c , +-comm c a ∙ p
            ≤-of' : (a c : ℕ) → a + c ≡ n → c ≤ n
            ≤-of' a c p = a , p
            closed : b · D n (λ a c → bound a · bound c) ≡ bound (suc n)
            closed = cong (b ·_) (D-ext n (product-of-bounds n) ∙ D-scale n (pow b n · pow g (suc (suc n))) (λ a c → cat a · cat c)
                                  ∙ cong ((pow b n · pow g (suc (suc n))) ·_) (sym (cat-suc n)))
                   ∙ shape (pow b n) (pow g (suc (suc n))) (cat (suc n))
              where
                shape : (P G C : ℕ) → b · ((P · G) · C) ≡ (b · P) · (C · G)
                shape P G C = solveℕ!

  -- THE MAJORANT:  xₙ ≤ bⁿ · Catₙ · gⁿ⁺¹
  catalan-majorant : (n : ℕ) → x n ≤ pow b n · (cat n · pow g (suc n))
  catalan-majorant n = below n n ≤-refl
