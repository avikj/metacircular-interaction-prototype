{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एक-बीज — one pair kernel, two readers.
--
-- SOURCE (papers/hieroglyphics_ii.tex, the pair-kernel block), quoted:
--
--     P(z) := \sum_{n\ge1} \Lambda(n)e^{-nz}
--     Z(t,\theta) := P(t+\mathrm i\theta) P(t-\mathrm i\theta)
--
--     \boxed{ Z(t,\theta) = \sum_{w,r} \Lambda(w-r)\Lambda(w+r)
--                           e^{-2tw}e^{2\mathrm ir\theta} }
--     \mathcal K(w,r) := \Lambda(w-r)\Lambda(w+r)
--
--     \mathcal K \xleftrightarrow{\;\mathcal L_w\otimes\mathcal F_r\;} Z
--     \boxed{ \text{गोल्डबाखः} = [w^N]\mathcal K \qquad ; \qquad
--             \text{यमलप्राइमः} = [r^1]\mathcal K }
--
-- The claim of the block: the square of the prime series, written in
-- centre/radius coordinates m = w − r, n = w + r, is ONE kernel 𝒦(w,r);
-- Goldbach at 2N is its centre marginal (the fibre over w = N) and the
-- twin primes are its radius marginal (the fibre over r = 1).
--
-- WHAT IS PROVED HERE, exactly.  The weights are the prime INDICATOR
-- a(n) := primeb n read as ℕ (1 for prime, 0 otherwise), primeb being
-- the corpus's Goldbach tester (SamastaPrasna), and the kernel is
--
--     𝒦 w r := a (w ∸ r) · a (w + r).
--
--   §1  centre marginal is Goldbach:
--         GoldbachAt (2 · w)  ⟺  Σ_{r=0}^{w} 𝒦 w r ≢ 0        (both ways)
--   §2  radius marginal is the twin-prime indicator:
--         𝒦 w 1 ≡ 1  ⟺  primeb (w ∸ 1) ≡ true × primeb (w + 1) ≡ true
--   §3  the Cauchy identity in centre/radius coordinates, for ANY
--       f : ℕ → ℕ:
--         Σ_{m=0}^{2w} f m · f (2w ∸ m)
--           ≡ f w · f w + 2 · Σ_{r=1}^{w} f (w ∸ r) · f (w + r)
--       via a general lemma: a sum over 0..2w of a function symmetric
--       under m ↦ 2w ∸ m is the middle term plus twice the lower half.
--       Instantiated at f = a: the ordered Goldbach count of 2w is
--         𝒦 w 0 + 2 · Σ_{r=1}^{w} 𝒦 w r.
--   §4  one source, two readers:
--         primeb j ≡ true  ⟺  (1 < j) × (η j ≡ j)
--       the Goldbach tester and the RH module's η read the same spf.
--   §5  kernel checks the typechecker computes: 𝒦 50 3 (47, 53),
--       𝒦 6 1 (5, 7), the marginal at 2·50 = 100 is 6 (nonzero), and
--       the ordered count of 100 is 12 = 𝒦 50 0 + 2·6.
--
-- WHAT IS NOT CLAIMED.  Nothing analytic: no Λ(n) = log p, no e^{−nz},
-- no Laplace/Fourier/Mellin transform, no P(z), no Z(t,θ), no ζ.  The
-- weights here are the prime indicator, NOT the von Mangoldt function
-- (prime powers p^k, k ≥ 2, carry weight 0 here and log p there).  No
-- inhabitant of Goldbach or TwinPrimes is offered; §1–§2 relate fibres
-- of the two conjectures to fibres of the kernel, and §5 checks finitely
-- many instances by evaluation.
------------------------------------------------------------------------

module EkaBija_OnePairKernelTwoReadersGoldbachIsTheCentreMarginalTwinPrimesTheRadiusMarginalAndTheOrderedGoldbachCountIsTheCauchySquareInCentreRadiusCoordinates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using ( ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_
        ; +-zero ; +-suc ; +-comm ; +-assoc ; ·-comm ; 0≡m·0
        ; injSuc ; snotz ; znots ; discreteℕ ; inj-m+
        ; +∸ ; ∸+ ; ∸-cancelˡ ; m+n≡0→m≡0×n≡0 )
open import Cubical.Data.Nat.Order
  using ( _≤_ ; _<_ ; ≤-refl ; ≤-suc ; ≤-k+ ; ≤-split ; pred-≤-pred ; ≤0→≡0
        ; ≤-∸-+-cancel ; splitℕ-≤ ; <-+-< ; ¬m<m ; ¬-<-zero )
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
import Cubical.Data.Empty as E

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (spf ; eqb ; ltb ; η ; powOfF)
open import SamastaPrasna_TheOpenConstellationEntersTypedAndTheOracleAnswersEveryInstance
  using (primeb ; GoldbachAt)

------------------------------------------------------------------------
-- §0 · the indicator, the kernel, the two finite sums
------------------------------------------------------------------------

ind : Bool → ℕ
ind true  = 1
ind false = 0

a : ℕ → ℕ                      -- the prime indicator, read as ℕ
a n = ind (primeb n)

𝒦 : ℕ → ℕ → ℕ                  -- the pair kernel in centre/radius coordinates
𝒦 w r = a (w ∸ r) · a (w + r)

Σ≤ : ℕ → (ℕ → ℕ) → ℕ           -- Σ_{m=0}^{k} f m
Σ≤ zero    f = f zero
Σ≤ (suc k) f = Σ≤ k f + f (suc k)

Σ₁ : ℕ → (ℕ → ℕ) → ℕ           -- Σ_{r=1}^{k} f r
Σ₁ zero    f = zero
Σ₁ (suc k) f = Σ₁ k f + f (suc k)

-- 2 · w is definitionally w + (w + 0)
two· : (w : ℕ) → 2 · w ≡ w + w
two· w = cong (w +_) (+-zero w)

------------------------------------------------------------------------
-- indicator arithmetic
------------------------------------------------------------------------

ind-true : (b : Bool) → ¬ (ind b ≡ 0) → b ≡ true
ind-true true  _ = refl
ind-true false h = E.rec (h refl)

prod-nonzero : (m n : ℕ) → ¬ (m · n ≡ 0) → (¬ (m ≡ 0)) × (¬ (n ≡ 0))
prod-nonzero m n h = (λ e → h (cong (_· n) e)) , (λ e → h (cong (m ·_) e ∙ sym (0≡m·0 m)))

𝒦-nonzero : (w r : ℕ) → ¬ (𝒦 w r ≡ 0)
          → (primeb (w ∸ r) ≡ true) × (primeb (w + r) ≡ true)
𝒦-nonzero w r h = ind-true (primeb (w ∸ r)) (fst pn) , ind-true (primeb (w + r)) (snd pn)
  where
  pn : (¬ (a (w ∸ r) ≡ 0)) × (¬ (a (w + r) ≡ 0))
  pn = prod-nonzero (a (w ∸ r)) (a (w + r)) h

𝒦-one : (w r : ℕ) → primeb (w ∸ r) ≡ true → primeb (w + r) ≡ true → 𝒦 w r ≡ 1
𝒦-one w r e₁ e₂ = cong₂ (λ b c → ind b · ind c) e₁ e₂

ind-prod-one : (b c : Bool) → ind b · ind c ≡ 1 → (b ≡ true) × (c ≡ true)
ind-prod-one true  true  _ = refl , refl
ind-prod-one true  false e = E.rec (znots e)
ind-prod-one false c     e = E.rec (znots e)

------------------------------------------------------------------------
-- finite-sum toolkit
------------------------------------------------------------------------

-- every term of a zero sum is zero
Σ≤-zero-term : (k : ℕ) (f : ℕ → ℕ) → Σ≤ k f ≡ 0 → (r : ℕ) → r ≤ k → f r ≡ 0
Σ≤-zero-term zero f e r r≤0 = subst (λ x → f x ≡ 0) (sym (≤0→≡0 r≤0)) e
Σ≤-zero-term (suc k) f e r r≤sk with ≤-split r≤sk
... | inl r<sk = Σ≤-zero-term k f (fst (m+n≡0→m≡0×n≡0 e)) r (pred-≤-pred r<sk)
... | inr r≡sk = subst (λ x → f x ≡ 0) (sym r≡sk) (snd (m+n≡0→m≡0×n≡0 e))

-- a nonzero sum has a nonzero term
Σ≤-nonzero-term : (k : ℕ) (f : ℕ → ℕ) → ¬ (Σ≤ k f ≡ 0)
                → Σ[ r ∈ ℕ ] (r ≤ k) × (¬ (f r ≡ 0))
Σ≤-nonzero-term zero f h = zero , ≤-refl , h
Σ≤-nonzero-term (suc k) f h with discreteℕ (f (suc k)) 0
... | no ne = suc k , ≤-refl , ne
... | yes e = widen (Σ≤-nonzero-term k f (λ s → h (cong₂ _+_ s e)))
  where
  widen : Σ[ r ∈ ℕ ] (r ≤ k) × (¬ (f r ≡ 0)) → Σ[ r ∈ ℕ ] (r ≤ suc k) × (¬ (f r ≡ 0))
  widen (r , r≤k , hr) = r , ≤-suc r≤k , hr

-- split at n:  Σ_{0}^{k+n} g  =  Σ_{0}^{n} g  +  Σ_{i=1}^{k} g (n + i)
Σ≤-split : (k n : ℕ) (g : ℕ → ℕ) → Σ≤ (k + n) g ≡ Σ≤ n g + Σ₁ k (λ i → g (n + i))
Σ≤-split zero    n g = sym (+-zero (Σ≤ n g))
Σ≤-split (suc k) n g =
    cong (_+ g (suc (k + n))) (Σ≤-split k n g)
  ∙ sym (+-assoc (Σ≤ n g) (Σ₁ k (λ i → g (n + i))) (g (suc (k + n))))
  ∙ cong (λ t → Σ≤ n g + (Σ₁ k (λ i → g (n + i)) + t))
         (cong g (cong suc (+-comm k n) ∙ sym (+-suc n k)))

-- the cons form of Σ₁
Σ₁-cons : (k : ℕ) (h : ℕ → ℕ) → Σ₁ (suc k) h ≡ h 1 + Σ₁ k (λ r → h (suc r))
Σ₁-cons zero    h = sym (+-zero (h 1))
Σ₁-cons (suc k) h =
    cong (_+ h (suc (suc k))) (Σ₁-cons k h)
  ∙ sym (+-assoc (h 1) (Σ₁ k (λ r → h (suc r))) (h (suc (suc k))))

-- reversal:  Σ_{m=0}^{k} g m  =  g k + Σ_{r=1}^{k} g (k ∸ r)
Σ≤-reverse : (k : ℕ) (g : ℕ → ℕ) → Σ≤ k g ≡ g k + Σ₁ k (λ r → g (k ∸ r))
Σ≤-reverse zero    g = sym (+-zero (g zero))
Σ≤-reverse (suc k) g =
    cong (_+ g (suc k)) (Σ≤-reverse k g)
  ∙ +-comm (g k + Σ₁ k (λ r → g (k ∸ r))) (g (suc k))
  ∙ cong (g (suc k) +_) (sym (Σ₁-cons k (λ r → g (suc k ∸ r))))

-- pointwise equal summands on 1..k give equal sums
Σ₁-ext : (k : ℕ) (h h' : ℕ → ℕ) → ((r : ℕ) → r ≤ k → h r ≡ h' r) → Σ₁ k h ≡ Σ₁ k h'
Σ₁-ext zero    h h' _ = refl
Σ₁-ext (suc k) h h' e =
  cong₂ _+_ (Σ₁-ext k h h' (λ r r≤k → e r (≤-suc r≤k))) (e (suc k) ≤-refl)

-- n ∸ (n ∸ m) ≡ m for m ≤ n
∸∸ : (m n : ℕ) → m ≤ n → n ∸ (n ∸ m) ≡ m
∸∸ m n (j , j+m≡n) =
    cong (λ t → t ∸ (t ∸ m)) (sym j+m≡n)
  ∙ cong ((j + m) ∸_) (+∸ j m)
  ∙ ∸+ m j

------------------------------------------------------------------------
-- §1 · the centre marginal is Goldbach
--
--     GoldbachAt (2 · w)   ⟺   Σ_{r=0}^{w} 𝒦 w r ≢ 0
------------------------------------------------------------------------

marginal→goldbach : (w : ℕ) → ¬ (Σ≤ w (𝒦 w) ≡ 0) → GoldbachAt (2 · w)
marginal→goldbach w h with Σ≤-nonzero-term w (𝒦 w) h
... | (r , r≤w , hr) = (w ∸ r) , (w + r) , fst pq , snd pq , eq
  where
  pq : (primeb (w ∸ r) ≡ true) × (primeb (w + r) ≡ true)
  pq = 𝒦-nonzero w r hr
  eq : (w ∸ r) + (w + r) ≡ 2 · w
  eq =   cong ((w ∸ r) +_) (+-comm w r)
       ∙ +-assoc (w ∸ r) r w
       ∙ cong (_+ w) (≤-∸-+-cancel r≤w)
       ∙ sym (two· w)

-- a Goldbach pair with p ≤ w sits at radius r = w ∸ p
lower-witness : (w p q : ℕ) → primeb p ≡ true → primeb q ≡ true → p + q ≡ 2 · w
              → p ≤ w → ¬ (Σ≤ w (𝒦 w) ≡ 0)
lower-witness w p q pp pq e (j , j+p≡w) s =
  snotz (sym k1 ∙ Σ≤-zero-term w (𝒦 w) s j j≤w)
  where
  j≤w : j ≤ w
  j≤w = p , (+-comm p j ∙ j+p≡w)
  w∸j≡p : w ∸ j ≡ p
  w∸j≡p = cong (_∸ j) (sym j+p≡w) ∙ ∸+ p j
  w+j≡q : w + j ≡ q
  w+j≡q = inj-m+ {m = p}
            ( +-assoc p w j
            ∙ cong (_+ j) (+-comm p w)
            ∙ sym (+-assoc w p j)
            ∙ cong (w +_) (+-comm p j ∙ j+p≡w)
            ∙ sym (two· w)
            ∙ sym e )
  k1 : 𝒦 w j ≡ 1
  k1 = 𝒦-one w j (subst (λ x → primeb x ≡ true) (sym w∸j≡p) pp)
                 (subst (λ x → primeb x ≡ true) (sym w+j≡q) pq)

goldbach→marginal : (w : ℕ) → GoldbachAt (2 · w) → ¬ (Σ≤ w (𝒦 w) ≡ 0)
goldbach→marginal w (p , q , pp , pq , e) with splitℕ-≤ p w | splitℕ-≤ q w
... | inl p≤w | _       = lower-witness w p q pp pq e p≤w
... | inr w<p | inl q≤w = lower-witness w q p pq pp (+-comm q p ∙ e) q≤w
... | inr w<p | inr w<q =
  E.rec (¬m<m (subst (w + w <_) (e ∙ two· w) (<-+-< w<p w<q)))

centre-marginal-is-goldbach : (w : ℕ)
  → (GoldbachAt (2 · w) → ¬ (Σ≤ w (𝒦 w) ≡ 0))
  × (¬ (Σ≤ w (𝒦 w) ≡ 0) → GoldbachAt (2 · w))
centre-marginal-is-goldbach w = goldbach→marginal w , marginal→goldbach w

------------------------------------------------------------------------
-- §2 · the radius marginal is the twin-prime indicator
--
--     𝒦 w 1 ≡ 1   ⟺   primeb (w ∸ 1) ≡ true  ×  primeb (w + 1) ≡ true
------------------------------------------------------------------------

radius-marginal-is-twin : (w : ℕ)
  → (𝒦 w 1 ≡ 1 → (primeb (w ∸ 1) ≡ true) × (primeb (w + 1) ≡ true))
  × ((primeb (w ∸ 1) ≡ true) × (primeb (w + 1) ≡ true) → 𝒦 w 1 ≡ 1)
radius-marginal-is-twin w =
  ind-prod-one (primeb (w ∸ 1)) (primeb (w + 1)) , λ pr → 𝒦-one w 1 (fst pr) (snd pr)

------------------------------------------------------------------------
-- §3 · the Cauchy identity in centre/radius coordinates
------------------------------------------------------------------------

-- the general lemma: a sum over 0..2w of a function symmetric under
-- m ↦ 2w ∸ m is the middle term plus twice the lower half
symmetric-sum : (w : ℕ) (g : ℕ → ℕ)
  → ((m : ℕ) → m ≤ w + w → g m ≡ g ((w + w) ∸ m))
  → Σ≤ (w + w) g ≡ g w + 2 · Σ₁ w (λ r → g (w ∸ r))
symmetric-sum w g sym-g =
    Σ≤-split w w g
  ∙ cong₂ _+_ (Σ≤-reverse w g)
              (Σ₁-ext w (λ i → g (w + i)) (λ r → g (w ∸ r)) upper≡lower)
  ∙ sym (+-assoc (g w) S S)
  ∙ cong (λ t → g w + (S + t)) (sym (+-zero S))
  where
  S : ℕ
  S = Σ₁ w (λ r → g (w ∸ r))
  upper≡lower : (r : ℕ) → r ≤ w → g (w + r) ≡ g (w ∸ r)
  upper≡lower r r≤w = sym-g (w + r) (≤-k+ r≤w) ∙ cong g (∸-cancelˡ w w r)

-- the Cauchy square of any sequence, in centre/radius coordinates
-- (stated with w + w; the 2 · w form follows)
cauchy+ : (w : ℕ) (f : ℕ → ℕ)
  → Σ≤ (w + w) (λ m → f m · f ((w + w) ∸ m))
  ≡ f w · f w + 2 · Σ₁ w (λ r → f (w ∸ r) · f (w + r))
cauchy+ w f =
    symmetric-sum w g symg
  ∙ cong₂ (λ x y → x + 2 · y)
          (cong (λ t → f w · f t) (+∸ w w))
          (Σ₁-ext w (λ r → g (w ∸ r)) (λ r → f (w ∸ r) · f (w + r)) lowerHalf)
  where
  g : ℕ → ℕ
  g m = f m · f ((w + w) ∸ m)
  symg : (m : ℕ) → m ≤ w + w → g m ≡ g ((w + w) ∸ m)
  symg m m≤ =   ·-comm (f m) (f ((w + w) ∸ m))
              ∙ cong (λ t → f ((w + w) ∸ m) · f t) (sym (∸∸ m (w + w) m≤))
  lowerHalf : (r : ℕ) → r ≤ w → g (w ∸ r) ≡ f (w ∸ r) · f (w + r)
  lowerHalf r (j , j+r≡w) = cong (λ t → f (w ∸ r) · f t) path
    where
    path : (w + w) ∸ (w ∸ r) ≡ w + r
    path =   cong ((w + w) ∸_) (cong (_∸ r) (sym j+r≡w) ∙ +∸ j r)
           ∙ cong (_∸ j) (cong (_+ w) (sym j+r≡w) ∙ sym (+-assoc j r w))
           ∙ ∸+ (r + w) j
           ∙ +-comm r w

cauchy : (w : ℕ) (f : ℕ → ℕ)
  → Σ≤ (2 · w) (λ m → f m · f ((2 · w) ∸ m))
  ≡ f w · f w + 2 · Σ₁ w (λ r → f (w ∸ r) · f (w + r))
cauchy w f =
  subst (λ t → Σ≤ t (λ m → f m · f (t ∸ m))
             ≡ f w · f w + 2 · Σ₁ w (λ r → f (w ∸ r) · f (w + r)))
        (sym (two· w)) (cauchy+ w f)

-- at f = a: the ordered Goldbach count of 2w is 𝒦 w 0 + 2 · Σ_{r=1}^{w} 𝒦 w r
ordered-goldbach-count : (w : ℕ)
  → Σ≤ (2 · w) (λ m → a m · a ((2 · w) ∸ m)) ≡ 𝒦 w 0 + 2 · Σ₁ w (𝒦 w)
ordered-goldbach-count w =
  cauchy w a ∙ cong (λ t → a w · a t + 2 · Σ₁ w (𝒦 w)) (sym (+-zero w))

------------------------------------------------------------------------
-- §4 · one source, two readers:  primeb j ≡ true  ⟺  (1 < j) × (η j ≡ j)
------------------------------------------------------------------------

eqb-refl : (n : ℕ) → eqb n n ≡ true
eqb-refl zero    = refl
eqb-refl (suc n) = eqb-refl n

eqb-sound : (m n : ℕ) → eqb m n ≡ true → m ≡ n
eqb-sound zero    zero    e = refl
eqb-sound zero    (suc n) e = E.rec (false≢true e)
eqb-sound (suc m) zero    e = E.rec (false≢true e)
eqb-sound (suc m) (suc n) e = cong suc (eqb-sound m n e)

if-true : {A : Type} (b : Bool) → b ≡ true → (x y : A) → (if b then x else y) ≡ x
if-true b e x y = cong (λ c → if c then x else y) e

-- primeb j for j ≥ 2 IS the test eqb (spf j) j: ltb 1 j computes to true
-- once j = 2 or j ≥ 3 is visible, and the guard andb true c = c.
primeb-unfold : (k : ℕ) → primeb (suc (suc k)) ≡ eqb (spf (suc (suc k))) (suc (suc k))
primeb-unfold zero    = refl
primeb-unfold (suc k) = refl

-- powOfF (suc fuel) p p ≡ true for p ≥ 2: eqb p 1 is false, eqb p p is true
powOfF-self : (fuel k : ℕ) → powOfF (suc fuel) (suc (suc k)) (suc (suc k)) ≡ true
powOfF-self fuel k = if-true (eqb k k) (eqb-refl k) true _

prime→η : (k : ℕ) → primeb (suc (suc k)) ≡ true → η (suc (suc k)) ≡ suc (suc k)
prime→η k e =
  subst (λ s → (if powOfF (suc (suc k)) s (suc (suc k)) then s else 1) ≡ suc (suc k))
        (sym spf≡)
        (if-true _ (powOfF-self (suc k) k) (suc (suc k)) 1)
  where
  spf≡ : spf (suc (suc k)) ≡ suc (suc k)
  spf≡ = eqb-sound _ _ (sym (primeb-unfold k) ∙ e)

η→prime : (k : ℕ) → η (suc (suc k)) ≡ suc (suc k) → primeb (suc (suc k)) ≡ true
η→prime k e =
  primeb-unfold k ∙ subst (λ s → eqb s (suc (suc k)) ≡ true) (sym spf≡) (eqb-refl (suc (suc k)))
  where
  if-case : (b : Bool) (s : ℕ) → (if b then s else 1) ≡ suc (suc k) → s ≡ suc (suc k)
  if-case true  s h = h
  if-case false s h = E.rec (znots (injSuc h))
  spf≡ : spf (suc (suc k)) ≡ suc (suc k)
  spf≡ = if-case (powOfF (suc (suc k)) (spf (suc (suc k))) (suc (suc k))) (spf (suc (suc k))) e

one-source-two-readers : (j : ℕ)
  → (primeb j ≡ true → (1 < j) × (η j ≡ j))
  × ((1 < j) × (η j ≡ j) → primeb j ≡ true)
one-source-two-readers zero =
  (λ e → E.rec (false≢true e)) , (λ h → E.rec (¬-<-zero (fst h)))
one-source-two-readers (suc zero) =
  (λ e → E.rec (false≢true e)) , (λ h → E.rec (¬m<m (fst h)))
one-source-two-readers (suc (suc k)) =
  (λ e → (k , +-comm k 2) , prime→η k e) , (λ h → η→prime k (snd h))

------------------------------------------------------------------------
-- §5 · kernel checks the typechecker computes
------------------------------------------------------------------------

kernel-47-53 : 𝒦 50 3 ≡ 1                -- centre 50, radius 3: (47, 53)
kernel-47-53 = refl

kernel-5-7 : 𝒦 6 1 ≡ 1                   -- centre 6, radius 1: the twins (5, 7)
kernel-5-7 = refl

twins-5-7 : (primeb 5 ≡ true) × (primeb 7 ≡ true)
twins-5-7 = fst (radius-marginal-is-twin 6) kernel-5-7

marginal-at-100 : Σ≤ 50 (𝒦 50) ≡ 6       -- radii 3, 9, 21, 33, 39, 47
marginal-at-100 = refl

marginal-at-100-nonzero : ¬ (Σ≤ 50 (𝒦 50) ≡ 0)
marginal-at-100-nonzero e = snotz (sym marginal-at-100 ∙ e)

goldbach-100-from-kernel : GoldbachAt 100
goldbach-100-from-kernel = marginal→goldbach 50 marginal-at-100-nonzero

ordered-count-100 : Σ≤ (2 · 50) (λ m → a m · a ((2 · 50) ∸ m)) ≡ 12
ordered-count-100 = refl

ordered-count-100-by-kernel : 𝒦 50 0 + 2 · Σ₁ 50 (𝒦 50) ≡ 12
ordered-count-100-by-kernel = sym (ordered-goldbach-count 50) ∙ ordered-count-100
