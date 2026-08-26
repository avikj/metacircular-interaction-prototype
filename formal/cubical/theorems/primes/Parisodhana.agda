{-# OPTIONS --cubical --guardedness --safe #-}
module Parisodhana where
-- परिशोधन: factor pairing.  If n has any nontrivial divisor, it has one
-- with square ≤ n.  So the √-bounded search is COMPLETE — proved, and the
-- certified prime decision drops to √-cost.

open import Prakriti
open import Vada using (noNTD→prime; prime→noNTD; dec×)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary

dec≤ : (m n : ℕ) → Dec (m ≤ n)
dec≤ m n with m ≟ n
... | lt h = yes (<-weaken h)
... | eq h = yes (subst (m ≤_) h ≤-refl)
... | gt h = no λ m≤n → <-asym h m≤n

-- ═══ the pairing lemma ═══
pairing : (n : ℕ) → 1 < n → NTD n
        → Σ[ d ∈ ℕ ] (1 < d) × ((d · d ≤ n) × divides d n)
pairing n 1<n (d , (1<d , d<n) , (c , e)) = pick
  where
  cVal : (c' : ℕ) → c' · d ≡ n → 1 < c'
  cVal zero e0 = Empty.rec (¬-<-zero (subst (1 <_) (sym e0) 1<n))
  cVal (suc zero) e1 = Empty.rec (<-asym d<n
    (subst (n ≤_) (sym (sym (·-identityˡ d) ∙ e1)) ≤-refl))
  cVal (suc (suc k)) _ = suc-≤-suc (suc-≤-suc zero-≤)
  1<c : 1 < c
  1<c = cVal c e
  pick : Σ[ d ∈ ℕ ] (1 < d) × ((d · d ≤ n) × divides d n)
  pick with c ≟ d
  ... | lt c<d = c , 1<c ,
                 subst (c · c ≤_) (·-comm d c ∙ e) (≤-·k (<-weaken c<d)) ,
                 (d , ·-comm d c ∙ e)
  ... | eq c≡d = c , 1<c ,
                 subst (c · c ≤_) (cong (c ·_) c≡d ∙ e) ≤-refl ,
                 (d , ·-comm d c ∙ e)
  ... | gt d<c = d , 1<d ,
                 subst (d · d ≤_) e (≤-·k (<-weaken d<c)) ,
                 (c , e)
-- no divisor with square ≤ n  ⇒  prime
sqrtComplete : (n : ℕ) → 1 < n
             → ((d : ℕ) → 1 < d → d · d ≤ n → ¬ divides d n)
             → IsPrime n
sqrtComplete n 1<n noSmall =
  noNTD→prime n 1<n λ ntd →
    let (d , 1<d , sq , dv) = pairing n 1<n ntd
    in noSmall d 1<d sq dv

-- a small divisor is a proper divisor
small→NTD : (n d : ℕ) → 1 < n → 1 < d → d · d ≤ n → divides d n → NTD n
small→NTD n d 1<n 1<d sq dv = d , (1<d , d<n) , dv
  where
  one≤ : 1 ≤ d + 0
  one≤ = subst (1 ≤_) (sym (+-zero d)) (<-weaken 1<d)
  d<2d : suc d ≤ d + (d + 0)
  d<2d = subst (_≤ d + (d + 0)) (+-comm d 1) (≤-k+ {k = d} one≤)
  d<dd : d < d · d
  d<dd = ≤-trans d<2d (≤-·k {2} {d} {d} 1<d)
  d<n : d < n
  d<n = ≤-trans d<dd sq
-- ═══ certified primality at √-cost ═══
primeDec√ : (n : ℕ) → 1 < n → Dec (IsPrime n)
primeDec√ n 1<n with boundedDec
    (λ d → ((1 < d) × (d · d ≤ n)) × divides d n)
    (λ d → dec× (dec× (deco d) (dec≤ (d · d) n)) (decDivides d n))
    n
  where
  deco : (d : ℕ) → Dec (1 < d)
  deco d with 1 ≟ d
  ... | lt h = yes h
  ... | eq h = no λ 1<d → <-asym 1<d (subst (_≤ 1) h ≤-refl)
  ... | gt h = no λ 1<d → <-asym 1<d (<-weaken h)
... | yes (d , _ , (1<d , sq) , dv) =
      no (λ pr → prime→noNTD n pr (small→NTD n d 1<n 1<d sq dv))
... | no ¬s = yes (sqrtComplete n 1<n λ d 1<d sq dv →
      ¬s (d , divLe d n (<-trans ≤-refl 1<n) dv , (1<d , sq) , dv))

-- pressed: 97 is prime with certificate, 91 is not, at √-cost
_ : Dec (IsPrime 97)
_ = primeDec√ 97 (suc-≤-suc (suc-≤-suc zero-≤))

decide : {A : Type₀} → Dec A → ℕ
decide (yes _) = 1
decide (no _) = 0

_ : decide (primeDec√ 97 (suc-≤-suc (suc-≤-suc zero-≤))) ≡ 1
_ = refl
_ : decide (primeDec√ 91 (suc-≤-suc (suc-≤-suc zero-≤))) ≡ 0
_ = refl
