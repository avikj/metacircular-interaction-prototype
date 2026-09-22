{-# OPTIONS --cubical --guardedness --safe #-}
module Kilaka where
-- कीलक: the bolt.  A square prime factor forces a duplicate in the
-- canonical factorization, so μ̂ n ≡ 0 whenever p² ∣ n.

open import Prakriti
open import Vibhajana using (Prati; product; factor)
open import Bhajaka using (Mem; pdp)
open import Shodhita using (MemV; HasDup; decDup; μ̂)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary

-- Bhajaka.Mem and Shodhita.MemV have the same shape; bridge them
mem→memV : (p : ℕ) (l : List Prati) → Mem p l → MemV p l
mem→memV p ((q , _) ∷ l) (inl e) = inl e
mem→memV p ((q , _) ∷ l) (inr m) = inr (mem→memV p l m)

remove : (p : ℕ) (l : List Prati) → MemV p l → List Prati
remove p ((q , _) ∷ l) (inl _) = l
remove p ((q , pr) ∷ l) (inr m) = (q , pr) ∷ remove p l m

productRemove : (p : ℕ) (l : List Prati) (m : MemV p l)
              → product l ≡ p · product (remove p l m)
productRemove p ((q , _) ∷ l) (inl e) = cong (_· product l) (sym e)
productRemove p ((q , pr) ∷ l) (inr m) =
  cong (q ·_) (productRemove p l m)
  ∙ ·-assoc q p (product (remove p l m))
  ∙ cong (_· product (remove p l m)) (·-comm q p)
  ∙ sym (·-assoc p q (product (remove p l m)))

memRemove→dup : (p : ℕ) (l : List Prati) (m : MemV p l)
              → MemV p (remove p l m) → HasDup l
memRemove→dup p ((q , _) ∷ l) (inl e) m' =
  inl (subst (λ z → MemV z l) e m')
memRemove→dup p ((q , pr) ∷ l) (inr m) (inl e) =
  inl (subst (λ z → MemV z l) e (mv m))
  where
  mv : MemV p l → MemV p l
  mv x = x
memRemove→dup p ((q , pr) ∷ l) (inr m) (inr m') =
  inr (memRemove→dup p l m m')

-- p prime with p² ∣ n: the canonical list must repeat p
squareDup : (p n : ℕ) → IsPrime p → divides (p · p) n → (h : 1 ≤ n)
          → HasDup (fst (factor n h))
squareDup p n prP pp∣n h = memRemove→dup p l m p∈rest
  where
  l : List Prati
  l = fst (factor n h)
  el : product l ≡ n
  el = snd (factor n h)
  p∣n : divides p (product l)
  p∣n = subst (divides p) (sym el)
              (divTrans p (p · p) n (p , refl) pp∣n)
  m : MemV p l
  m = mem→memV p l (pdp p prP l p∣n)
  rest : ℕ
  rest = product (remove p l m)
  pp∣prl : divides (p · p) (product l)
  pp∣prl = subst (divides (p · p)) (sym el) pp∣n
  p∣rest : divides p rest
  p∣rest = cancel (fst pp∣prl) (snd pp∣prl)
    where
    shape : (x : ℕ) → 1 < x → Σ[ k ∈ ℕ ] x ≡ suc k
    shape zero hx = Empty.rec (¬-<-zero hx)
    shape (suc k) _ = k , refl
    psuc : Σ[ k ∈ ℕ ] p ≡ suc k
    psuc = shape p (fst prP)
    cancel : (c : ℕ) → c · (p · p) ≡ product l → divides p rest
    cancel c e = c , inj
      where
      pe : p · (c · p) ≡ p · rest
      pe = ·-assoc p c p
           ∙ cong (_· p) (·-comm p c)
           ∙ sym (·-assoc c p p)
           ∙ e
           ∙ productRemove p l m
      inj : c · p ≡ rest
      inj = inj-sm· {m = fst psuc}
              (subst (λ z → z · (c · p) ≡ z · rest) (snd psuc) pe)
  p∈rest : MemV p (remove p l m)
  p∈rest = mem→memV p (remove p l m)
             (pdp p prP (remove p l m) p∣rest)

-- ═══ the closed bolt ═══
square→μ̂0 : (p n : ℕ) → IsPrime p → divides (p · p) n → (h : 1 ≤ n)
          → μ̂ n h ≡ 0
square→μ̂0 p n prP pp∣n h with decDup (fst (factor n h))
... | yes _ = refl
... | no ¬d = Empty.rec (¬d (squareDup p n prP pp∣n h))
