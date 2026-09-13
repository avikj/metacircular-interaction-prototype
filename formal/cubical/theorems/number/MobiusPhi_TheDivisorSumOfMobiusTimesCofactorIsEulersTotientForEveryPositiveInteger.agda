{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MobiusPhi_TheDivisorSumOfMobiusTimesCofactorIsEulersTotientForEveryPositiveInteger
--
-- CLOSES an absence stated in `TransmissionRefutations.agda`, Section
-- B.2, which checks the identification of the Möbius divisor sum with
-- Euler's totient at twelve points and says of the rest:
--
--     "SCOPE: this is the ledger's identification of the sum, checked at
--      twelve points.  The general identity Σ_{d|n} μ(d)(n/d) = φ(n) is
--      classical (Möbius inversion of n = Σ_{d|n} φ(d)) and is NOT
--      proved here; the refutation of the display does not need it."
--
-- WHAT IS PROVED.  For every n ≥ 1, in that module's OWN definitions
-- (`mobiusDivSum`, `mu`, `phi`, `spf`, `gcdN`, `_div_`, `dividesb`, all
-- fuel-bounded trial-division programs on ℕ, none of them re-defined
-- here):
--
--     mobius-divisor-sum-is-phi :
--       (n : ℕ) → 1 ≤ n → mobiusDivSum n ≡ pos (phi n)
--
-- i.e.  Σ_{d ≤ n, d ∣ n} μ(d) · ⌊n/d⌋  =  #{ k ≤ n : gcd(k, n) = 1 }.
--
-- Also proved, for every n (the companion display of the same archive
-- line, which the same module checks only to 12 as
-- `companion-display-holds-to-12`):
--
--     companion-display-holds :
--       (n : ℕ) → divSumMu n n ≡ (if eqb n 1 then pos 1 else pos 0)
--
-- i.e.  Σ_{d ∣ n} μ(d) = [n = 1], including at n = 0 where both sides
-- are 0 (`muSum-is-indicator`).
--
-- The route is not the one the scope note names (Gauss's identity plus
-- Möbius inversion) but the direct one, which needs less:
--
--   (i)   Σ_{d ∣ m} μ(d) = [m = 1]           (`muSum-is-indicator`)
--   (ii)  [gcd(k,n) = 1] = Σ_{d ≤ n} [d ∣ k][d ∣ n] μ(d)
--   (iii) exchange the two finite sums and count the multiples of d
--         in 1..n, which are ⌊n/d⌋ when d ∣ n     (`Σ≤-multiples`).
--
-- Step (i) is where the arithmetic lives.  With p the least prime
-- factor of m ≥ 2 and m = p·c, the divisors of m split into those p
-- does not divide — which are exactly the p-free divisors of c, by
-- Gauss's lemma — and those of the form p·e with e ∣ c, on which μ is
-- 0 or −μ(e) by the module's own recursion for μ.  The two halves
-- cancel.  No induction on m and no factorisation into primes is used;
-- Gauss's lemma is derived from the library's `gcd-factorʳ`.
--
-- Because every function involved is a fuel-bounded program, the bulk
-- of the module is SPECIFICATION: each program is shown to compute what
-- its name says on the range on which it is called (`divmod-spec`,
-- `spf-spec`, `mu-step`, `gcdN-isGCD`), and the module's sums are shown
-- to be instances of one summation operator `Σ≤`.
--
-- WHAT IS NOT PROVED.  Nothing about the other displays of
-- `TransmissionRefutations` (its B.3 sums, its Section A, its Section
-- C) is touched; Gauss's identity Σ_{d∣n} φ(d) = n and the general
-- Möbius inversion formula are not proved, because this route does not
-- pass through them.  No postulates, no holes, no termination pragmas;
-- the fuel of every imported program is discharged by a proof, never by
-- a range assumption.
------------------------------------------------------------------------

module MobiusPhi_TheDivisorSumOfMobiusTimesCofactorIsEulersTotientForEveryPositiveInteger where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; snotz ; znots ; injSuc
        ; +-zero ; +-suc ; +-comm ; +-assoc ; ·-suc ; ·-comm ; ·-assoc
        ; ·-identityʳ ; ·-identityˡ ; 0≡m·0 ; inj-m+ ; inj-+m ; +∸ ; isSetℕ)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
  using (isCD ; isGCD ; zeroGCD ; stepGCD ; gcd ; gcdIsGCD ; isGCD→gcd≡ ; gcd-factorʳ)
open import Cubical.Data.Fin.Properties using (_%_ ; n%k≡n[modk] ; n%sk<sk)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; -_ ; sucℤ)
  renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_ ; _·_ to _·ℤ_)
open import Cubical.Data.Int.Properties
  using (+Comm ; +Assoc ; pos0+ ; pos+ ; -Cancel ; ·Comm ; sucℤ· ; ·AnnihilR ; ·AnnihilL)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; not ; _and_ ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁) renaming (rec to ∥rec)
open import Cubical.Relation.Nullary using (¬_)

open import TransmissionRefutations
  using (addN ; sub ; leb ; ltb ; eqb ; remF ; quoF ; dividesb ; spfF ; spf
        ; muF ; mu ; negZ ; gcdF ; gcdN ; phiCount ; phi ; divSumTo ; mobiusDivSum ; divSumMu)
  renaming (_mod_ to _modN_ ; _div_ to _divN_)

------------------------------------------------------------------------
-- 0.  The module's hand-written arithmetic agrees with the library's,
--     and its Boolean tests reflect the library's relations.
------------------------------------------------------------------------

addN≡+ : (m n : ℕ) → addN m n ≡ m + n
addN≡+ zero n = refl
addN≡+ (suc m) n = cong suc (addN≡+ m n)

sub≡∸ : (m n : ℕ) → sub m n ≡ m ∸ n
sub≡∸ m zero = refl
sub≡∸ zero (suc n) = refl
sub≡∸ (suc m) (suc n) = sub≡∸ m n

-- eqb decides equality
eqb-dec : (m n : ℕ) → ((m ≡ n) × (eqb m n ≡ true)) ⊎ ((¬ m ≡ n) × (eqb m n ≡ false))
eqb-dec zero zero = inl (refl , refl)
eqb-dec zero (suc n) = inr (znots , refl)
eqb-dec (suc m) zero = inr (snotz , refl)
eqb-dec (suc m) (suc n) with eqb-dec m n
... | inl (p , q) = inl (cong suc p , q)
... | inr (p , q) = inr (p ∘ injSuc , q)

eqb-refl : (n : ℕ) → eqb n n ≡ true
eqb-refl n with eqb-dec n n
... | inl (_ , q) = q
... | inr (p , _) = ⊥rec (p refl)

eqb-≢ : (m n : ℕ) → ¬ m ≡ n → eqb m n ≡ false
eqb-≢ m n ne with eqb-dec m n
... | inl (p , _) = ⊥rec (ne p)
... | inr (_ , q) = q

-- leb decides ≤
leb-dec : (m n : ℕ) → ((m ≤ n) × (leb m n ≡ true)) ⊎ ((n < m) × (leb m n ≡ false))
leb-dec zero n = inl (zero-≤ , refl)
leb-dec (suc m) zero = inr (suc-≤-suc zero-≤ , refl)
leb-dec (suc m) (suc n) with leb-dec m n
... | inl (p , q) = inl (suc-≤-suc p , q)
... | inr (p , q) = inr (suc-≤-suc p , q)

leb-≤ : (m n : ℕ) → m ≤ n → leb m n ≡ true
leb-≤ m n h with leb-dec m n
... | inl (_ , q) = q
... | inr (p , _) = ⊥rec (<-asym p h)

ltb-≥ : (m n : ℕ) → n ≤ m → ltb m n ≡ false
ltb-≥ m n h = cong not (leb-≤ n m h)

ltb-< : (m n : ℕ) → m < n → ltb m n ≡ true
ltb-< m n h with leb-dec n m
... | inl (p , _) = ⊥rec (<-asym h p)
... | inr (_ , q) = cong not q

-- rewriting under a Boolean test
if-true : ∀ {ℓ ℓ'} {A : Type ℓ} (P : A → Type ℓ') {b : Bool} (x y : A)
        → b ≡ true → P x → P (if b then x else y)
if-true P {b} x y e px = subst (λ b → P (if b then x else y)) (sym e) px

if-false : ∀ {ℓ ℓ'} {A : Type ℓ} (P : A → Type ℓ') {b : Bool} (x y : A)
         → b ≡ false → P y → P (if b then x else y)
if-false P {b} x y e py = subst (λ b → P (if b then x else y)) (sym e) py

------------------------------------------------------------------------
-- 1.  Division with remainder: `remF`/`quoF` are exact whenever the
--     fuel is at least the dividend, and the pair is unique.
------------------------------------------------------------------------

divmod-spec : (f n d : ℕ) → n ≤ f → 0 < d
            → (quoF f n d · d + remF f n d ≡ n) × (remF f n d < d)
divmod-spec zero n d n≤0 0<d =
  subst (λ n → (quoF zero n d · d + remF zero n d ≡ n) × (remF zero n d < d))
        (sym (≤0→≡0 n≤0)) (refl , 0<d)
divmod-spec (suc f) n d n≤sf 0<d with splitℕ-< n d
... | inl n<d =
  if-true (λ q → (q · d + remF (suc f) n d ≡ n) × (remF (suc f) n d < d)) zero _ (ltb-< n d n<d)
    (if-true (λ r → (r ≡ n) × (r < d)) n _ (ltb-< n d n<d) (refl , n<d))
... | inr d≤n =
  if-false (λ q → (q · d + remF (suc f) n d ≡ n) × (remF (suc f) n d < d)) zero _ (ltb-≥ n d d≤n)
    (if-false (λ r → (d + q · d + r ≡ n) × (r < d)) n _ (ltb-≥ n d d≤n) (eqn , snd ih))
  where
  n∸d≤f : n ∸ d ≤ f
  n∸d≤f = ≤-trans (≤-∸-≥ n 1 d 0<d) (≤-∸-≤ n (suc f) 1 n≤sf)
  ih = divmod-spec f (sub n d) d (subst (_≤ f) (sym (sub≡∸ n d)) n∸d≤f) 0<d
  q = quoF f (sub n d) d
  r = remF f (sub n d) d
  eqn : d + q · d + r ≡ n
  eqn = sym (+-assoc d (q · d) r)
     ∙ cong (d +_) (fst ih ∙ sub≡∸ n d)
     ∙ +-comm d (n ∸ d)
     ∙ ≤-∸-+-cancel d≤n

divmod-unique : (q r q' r' d : ℕ) → r < d → r' < d
              → q · d + r ≡ q' · d + r' → (q ≡ q') × (r ≡ r')
divmod-unique zero r zero r' d _ _ e = refl , e
divmod-unique zero r (suc q') r' d r<d _ e =
  ⊥rec (¬m<m (<≤-trans r<d (subst (d ≤_) (sym e) (≤-trans ≤SumLeft ≤SumLeft))))
divmod-unique (suc q) r zero r' d _ r'<d e =
  ⊥rec (¬m<m (<≤-trans r'<d (subst (d ≤_) e (≤-trans ≤SumLeft ≤SumLeft))))
divmod-unique (suc q) r (suc q') r' d r<d r'<d e =
  let ih = divmod-unique q r q' r' d r<d r'<d
             (inj-m+ {m = d} (+-assoc d (q · d) r ∙ e ∙ sym (+-assoc d (q' · d) r')))
  in cong suc (fst ih) , snd ih

-- the module's `_mod_` / `_div_` are THE remainder and quotient
divN-modN : (n d : ℕ) → 0 < d → ((n divN d) · d + n modN d ≡ n) × (n modN d < d)
divN-modN n d 0<d = divmod-spec n n d ≤-refl 0<d

modN-unique : (n d q r : ℕ) → 0 < d → r < d → q · d + r ≡ n
            → (n divN d ≡ q) × (n modN d ≡ r)
modN-unique n d q r 0<d r<d e =
  divmod-unique (n divN d) (n modN d) q r d (snd (divN-modN n d 0<d)) r<d
                (fst (divN-modN n d 0<d) ∙ sym e)

modN≡% : (n k : ℕ) → n modN (suc k) ≡ n % suc k
modN≡% n k =
  snd (modN-unique n (suc k) (fst (n%k≡n[modk] n (suc k))) (n % suc k)
                   (suc-≤-suc zero-≤) (n%sk<sk n k) (snd (n%k≡n[modk] n (suc k))))

-- divisibility: the Boolean test reflects the library's `∣`
dividesb-dec : (d n : ℕ) → 0 < d
             → ((d ∣ n) × (dividesb d n ≡ true)) ⊎ ((¬ d ∣ n) × (dividesb d n ≡ false))
dividesb-dec d n 0<d with eqb-dec (n modN d) 0
... | inl (p , q) =
  inl (∣ n divN d , sym (+-zero _) ∙ cong ((n divN d) · d +_) (sym p) ∙ fst (divN-modN n d 0<d) ∣₁ , q)
... | inr (p , q) = inr (nd , q)
  where
  nd : ¬ d ∣ n
  nd h = ∥rec (λ ()) (λ { (c , e) → p (snd (modN-unique n d c 0 0<d 0<d (+-zero _ ∙ e))) }) h

dividesb-∣ : (d n : ℕ) → 0 < d → dividesb d n ≡ true → d ∣ n
dividesb-∣ d n 0<d e with dividesb-dec d n 0<d
... | inl (h , _) = h
... | inr (_ , q) = ⊥rec (true≢false (sym e ∙ q))

∣-dividesb : (d n : ℕ) → 0 < d → d ∣ n → dividesb d n ≡ true
∣-dividesb d n 0<d h with dividesb-dec d n 0<d
... | inl (_ , q) = q
... | inr (nh , _) = ⊥rec (nh h)

¬∣-dividesb : (d n : ℕ) → 0 < d → ¬ d ∣ n → dividesb d n ≡ false
¬∣-dividesb d n 0<d nh with dividesb-dec d n 0<d
... | inl (h , _) = ⊥rec (nh h)
... | inr (_ , q) = q

-- exact quotient
divN-exact : (d n : ℕ) → 0 < d → d ∣ n → (n divN d) · d ≡ n
divN-exact d n 0<d h =
  ∥rec (isSetℕ _ _)
       (λ { (c , e) → cong (_· d) (fst (modN-unique n d c 0 0<d 0<d (+-zero _ ∙ e))) ∙ e }) h

-- the quotient by d ≥ 2 of n ≥ 1 is smaller than n
twice-≤-mult : (q d : ℕ) → 2 ≤ d → q + q ≤ q · d
twice-≤-mult q d 2≤d =
  subst (q + q ≤_) (·-comm d q)
        (subst (_≤ d · q) (cong (q +_) (+-zero q)) (≤-·k {k = q} 2≤d))

divN-< : (d n : ℕ) → 2 ≤ d → 1 ≤ n → n divN d < n
divN-< d n 2≤d 1≤n with splitℕ-< (n divN d) n
... | inl less = less
... | inr n≤q = ⊥rec (¬m<m n<n)
  where
  0<d : 0 < d
  0<d = ≤-trans (suc-≤-suc zero-≤) 2≤d
  n<n : n < n
  n<n = <≤-trans (subst (_< n + n) (+-zero n) (<-k+ {k = n} 1≤n))
          (≤-trans (≤-+-≤ n≤q n≤q)
            (≤-trans (twice-≤-mult (n divN d) d 2≤d)
                     (subst ((n divN d) · d ≤_) (fst (divN-modN n d 0<d)) ≤SumLeft)))

------------------------------------------------------------------------
-- 2.  Finite sums of integers, Σ_{i=1}^{k} f i, in the shape the
--     module's own sums (`divSumTo`, `phiCount`) recurse in.
------------------------------------------------------------------------

Σ≤ : (ℕ → ℤ) → ℕ → ℤ
Σ≤ f zero = pos 0
Σ≤ f (suc k) = f (suc k) +ℤ Σ≤ f k

+ℤ-interchange : (a b c d : ℤ) → (a +ℤ b) +ℤ (c +ℤ d) ≡ (a +ℤ c) +ℤ (b +ℤ d)
+ℤ-interchange a b c d =
  sym (+Assoc a b (c +ℤ d))
  ∙ cong (a +ℤ_) (+Assoc b c d ∙ cong (_+ℤ d) (+Comm b c) ∙ sym (+Assoc c b d))
  ∙ +Assoc a c (b +ℤ d)

Σ≤-ext : (f g : ℕ → ℤ) (k : ℕ) → ((i : ℕ) → 1 ≤ i → i ≤ k → f i ≡ g i) → Σ≤ f k ≡ Σ≤ g k
Σ≤-ext f g zero h = refl
Σ≤-ext f g (suc k) h =
  cong₂ _+ℤ_ (h (suc k) (suc-≤-suc zero-≤) ≤-refl)
             (Σ≤-ext f g k (λ i 1≤i i≤k → h i 1≤i (≤-suc i≤k)))

Σ≤-const0 : (k : ℕ) → Σ≤ (λ _ → pos 0) k ≡ pos 0
Σ≤-const0 zero = refl
Σ≤-const0 (suc k) = sym (pos0+ _) ∙ Σ≤-const0 k

Σ≤-zero : (f : ℕ → ℤ) (k : ℕ) → ((i : ℕ) → 1 ≤ i → i ≤ k → f i ≡ pos 0) → Σ≤ f k ≡ pos 0
Σ≤-zero f k h = Σ≤-ext f (λ _ → pos 0) k h ∙ Σ≤-const0 k

Σ≤-add : (f g : ℕ → ℤ) (k : ℕ) → Σ≤ (λ i → f i +ℤ g i) k ≡ Σ≤ f k +ℤ Σ≤ g k
Σ≤-add f g zero = refl
Σ≤-add f g (suc k) =
  cong ((f (suc k) +ℤ g (suc k)) +ℤ_) (Σ≤-add f g k)
  ∙ +ℤ-interchange (f (suc k)) (g (suc k)) (Σ≤ f k) (Σ≤ g k)

-- exchange of two finite sums
Σ≤-swap : (f : ℕ → ℕ → ℤ) (k m : ℕ)
        → Σ≤ (λ i → Σ≤ (λ j → f i j) m) k ≡ Σ≤ (λ j → Σ≤ (λ i → f i j) k) m
Σ≤-swap f zero m = sym (Σ≤-const0 m)
Σ≤-swap f (suc k) m =
  cong (Σ≤ (f (suc k)) m +ℤ_) (Σ≤-swap f k m)
  ∙ sym (Σ≤-add (f (suc k)) (λ j → Σ≤ (λ i → f i j) k) m)

-- splitting a range
Σ≤-split : (f : ℕ → ℤ) (a b : ℕ) → Σ≤ f (a + b) ≡ Σ≤ (λ i → f (a + i)) b +ℤ Σ≤ f a
Σ≤-split f a zero = cong (Σ≤ f) (+-zero a) ∙ pos0+ (Σ≤ f a)
Σ≤-split f a (suc b) =
  cong (Σ≤ f) (+-suc a b)
  ∙ cong₂ _+ℤ_ (cong f (sym (+-suc a b))) (Σ≤-split f a b)
  ∙ +Assoc (f (a + suc b)) (Σ≤ (λ i → f (a + i)) b) (Σ≤ f a)

-- a sum whose summand vanishes above k is the sum to k
Σ≤-above : (f : ℕ → ℤ) (k m : ℕ) → k ≤ m
         → ((i : ℕ) → k < i → i ≤ m → f i ≡ pos 0) → Σ≤ f m ≡ Σ≤ f k
Σ≤-above f k m (b , e) h =
  cong (Σ≤ f) (sym e ∙ +-comm b k)
  ∙ Σ≤-split f k b
  ∙ cong (_+ℤ Σ≤ f k)
         (Σ≤-zero (λ i → f (k + i)) b
           (λ i 1≤i i≤b → h (k + i) (subst (_≤ k + i) (+-comm k 1) (≤-k+ 1≤i))
                                    (subst (k + i ≤_) (+-comm k b ∙ e) (≤-k+ i≤b))))
  ∙ sym (pos0+ (Σ≤ f k))

Σ≤-const : (c : ℤ) (k : ℕ) → Σ≤ (λ _ → c) k ≡ pos k ·ℤ c
Σ≤-const c zero = sym (·AnnihilL c)
Σ≤-const c (suc k) = cong (c +ℤ_) (Σ≤-const c k) ∙ sym (sucℤ· (pos k) c)

Σ≤-if : (b : Bool) (f : ℕ → ℤ) (k : ℕ)
      → Σ≤ (λ i → if b then f i else pos 0) k ≡ (if b then Σ≤ f k else pos 0)
Σ≤-if true f k = refl
Σ≤-if false f k = Σ≤-const0 k

-- THE COUNTING LEMMA: summing a function over the multiples of p in
-- 1..p·k is summing it along p, 2p, …, kp.
Σ≤-multiples : (p : ℕ) → 0 < p → (h : ℕ → ℤ) (k : ℕ)
             → Σ≤ (λ i → if dividesb p i then h i else pos 0) (p · k)
             ≡ Σ≤ (λ e → h (p · e)) k
Σ≤-multiples p 0<p h zero = cong (Σ≤ _) (sym (0≡m·0 p))
Σ≤-multiples zero 0<p h (suc k) = ⊥rec (¬-<-zero 0<p)
Σ≤-multiples (suc p') 0<p h (suc k) =
  cong (Σ≤ F) (·-suc (suc p') k ∙ +-comm (suc p') (suc p' · k))
  ∙ Σ≤-split F (suc p' · k) (suc p')
  ∙ cong₂ _+ℤ_ block (Σ≤-multiples (suc p') 0<p h k)
  where
  p = suc p'
  F : ℕ → ℤ
  F i = if dividesb p i then h i else pos 0
  -- in the block p·k+1 .. p·k+p only the last entry is a multiple of p
  rest : (i : ℕ) → 1 ≤ i → i ≤ p' → F (p · k + i) ≡ pos 0
  rest i 1≤i i≤p' =
    if-false (_≡ pos 0) (h (p · k + i)) (pos 0)
      (cong (λ r → eqb r 0)
            (snd (modN-unique (p · k + i) p k i 0<p (suc-≤-suc i≤p') (cong (_+ i) (·-comm k p))))
       ∙ eqb-≢ i 0 (λ i≡0 → ¬-<-zero (subst (1 ≤_) i≡0 1≤i)))
      refl
  idx : p · k + suc p' ≡ p · suc k
  idx = +-suc (p · k) p' ∙ cong suc (+-comm (p · k) p') ∙ sym (·-suc p k)
  first : F (p · k + suc p') ≡ h (p · suc k)
  first = cong F idx
        ∙ if-true (_≡ h (p · suc k)) (h (p · suc k)) (pos 0)
                  (∣-dividesb p (p · suc k) 0<p (∣-left (suc k))) refl
  block : Σ≤ (λ i → F (p · k + i)) p ≡ h (p · suc k)
  block = cong₂ _+ℤ_ first (Σ≤-zero (λ i → F (p · k + i)) p' rest)

------------------------------------------------------------------------
-- 3.  The least divisor ≥ k, and the least prime factor `spf`.
------------------------------------------------------------------------

LeastDiv : ℕ → ℕ → ℕ → Type₀
LeastDiv k n r = (k ≤ r) × ((r ∣ n) × ((d : ℕ) → k ≤ d → d ∣ n → r ≤ d))

spfF-spec : (f k n : ℕ) → 1 ≤ k → k ≤ n → n < f + k → LeastDiv k n (spfF f k n)
spfF-spec zero k n _ k≤n n<k = ⊥rec (<-asym n<k k≤n)
spfF-spec (suc f) k n 1≤k k≤n n<sf+k =
  if-false (LeastDiv k n) n _ (ltb-≥ n k k≤n) inner
  where
  inner : LeastDiv k n (if dividesb k n then k else spfF f (suc k) n)
  inner with dividesb-dec k n 1≤k
  ... | inl (k∣n , e) = if-true (LeastDiv k n) k _ e (≤-refl , k∣n , λ d k≤d _ → k≤d)
  ... | inr (¬k∣n , e) = if-false (LeastDiv k n) k _ e from-ih
    where
    sk≤n : suc k ≤ n
    sk≤n with ≤-split k≤n
    ... | inl less = less
    ... | inr k≡n = ⊥rec (¬k∣n (∣-refl k≡n))
    ih : LeastDiv (suc k) n (spfF f (suc k) n)
    ih = spfF-spec f (suc k) n (≤-suc 1≤k) sk≤n (subst (n <_) (sym (+-suc f k)) n<sf+k)
    from-ih : LeastDiv k n (spfF f (suc k) n)
    from-ih = ≤-trans ≤-sucℕ (fst ih) , fst (snd ih) ,
              λ d k≤d d∣n → snd (snd ih) d (step d k≤d d∣n) d∣n
      where
      step : (d : ℕ) → k ≤ d → d ∣ n → suc k ≤ d
      step d k≤d d∣n with ≤-split k≤d
      ... | inl less = less
      ... | inr k≡d = ⊥rec (¬k∣n (subst (_∣ n) (sym k≡d) d∣n))

spf-spec : (n : ℕ) → 2 ≤ n → LeastDiv 2 n (spf n)
spf-spec n 2≤n =
  spfF-spec n 2 n (suc-≤-suc zero-≤) 2≤n (subst (suc n ≤_) (sym (+-comm n 2)) (≤-suc ≤-refl))

2≤spf : (n : ℕ) → 2 ≤ n → 2 ≤ spf n
2≤spf n h = fst (spf-spec n h)

0<spf : (n : ℕ) → 2 ≤ n → 0 < spf n
0<spf n h = ≤-trans (suc-≤-suc zero-≤) (2≤spf n h)

spf∣ : (n : ℕ) → 2 ≤ n → spf n ∣ n
spf∣ n h = fst (snd (spf-spec n h))

spf-least : (n : ℕ) → 2 ≤ n → (d : ℕ) → 2 ≤ d → d ∣ n → spf n ≤ d
spf-least n h = snd (snd (spf-spec n h))

-- the least divisor ≥ 2 is prime: its only divisors are 1 and itself
spf-prime : (n : ℕ) → 2 ≤ n → (d : ℕ) → d ∣ spf n → (d ≡ 1) ⊎ (d ≡ spf n)
spf-prime n h zero d∣p = ⊥rec (¬-<-zero (subst (2 ≤_) (sym (∣-zeroˡ d∣p)) (2≤spf n h)))
spf-prime n h (suc zero) _ = inl refl
spf-prime n h (suc (suc d')) d∣p =
  inr (≤-antisym (m∣n→m≤n (λ p≡0 → ¬-<-zero (subst (2 ≤_) p≡0 (2≤spf n h))) d∣p)
                 (spf-least n h (suc (suc d')) (suc-≤-suc (suc-≤-suc zero-≤))
                            (∣-trans d∣p (spf∣ n h))))

------------------------------------------------------------------------
-- 4.  The Möbius program: fuel-stable, and it obeys the recursion
--     μ(n) = [p ∤ n/p] · (−μ(n/p)) for n ≥ 2, p = spf n.
------------------------------------------------------------------------

muF-zero : (g : ℕ) → muF g 0 ≡ pos 0
muF-zero zero = refl
muF-zero (suc g) = refl

muF-unfold : (f n : ℕ) → 2 ≤ n
           → muF (suc f) n ≡ (if dividesb (spf n) (n divN spf n) then pos 0 else negZ (muF f (n divN spf n)))
muF-unfold f n 2≤n =
  if-false (_≡ R) (pos 1) R (eqb-≢ n 1 n≢1) refl
  where
  R : ℤ
  R = if dividesb (spf n) (n divN spf n) then pos 0 else negZ (muF f (n divN spf n))
  n≢1 : ¬ n ≡ 1
  n≢1 n≡1 = ¬m<m (subst (2 ≤_) n≡1 2≤n)

muF-stable : (f g n : ℕ) → n ≤ f → n ≤ g → muF f n ≡ muF g n
muF-stable zero g n n≤0 _ =
  subst (λ n → muF zero n ≡ muF g n) (sym (≤0→≡0 n≤0)) (sym (muF-zero g))
muF-stable (suc f) g zero _ _ = muF-zero (suc f) ∙ sym (muF-zero g)
muF-stable (suc f) zero (suc n) _ sn≤0 = ⊥rec (¬-<-zero sn≤0)
muF-stable (suc f) (suc g) (suc zero) _ _ = refl
muF-stable (suc f) (suc g) (suc (suc n')) n≤sf n≤sg =
  muF-unfold f n 2≤n
  ∙ cong (λ z → if dividesb (spf n) q then pos 0 else negZ z)
         (muF-stable f g q (pred-≤-pred (≤-trans q<n n≤sf)) (pred-≤-pred (≤-trans q<n n≤sg)))
  ∙ sym (muF-unfold g n 2≤n)
  where
  n = suc (suc n')
  2≤n : 2 ≤ n
  2≤n = suc-≤-suc (suc-≤-suc zero-≤)
  q = n divN spf n
  q<n : q < n
  q<n = divN-< (spf n) n (2≤spf n 2≤n) (suc-≤-suc zero-≤)

mu-step : (n : ℕ) → 2 ≤ n
        → mu n ≡ (if dividesb (spf n) (n divN spf n) then pos 0 else negZ (mu (n divN spf n)))
mu-step zero h = ⊥rec (¬-<-zero h)
mu-step (suc n') h =
  muF-unfold n' (suc n') h
  ∙ cong (λ z → if dividesb (spf (suc n')) q then pos 0 else negZ z)
         (muF-stable n' q q (pred-≤-pred (divN-< (spf (suc n')) (suc n') (2≤spf (suc n') h) (suc-≤-suc zero-≤))) ≤-refl)
  where
  q = (suc n') divN spf (suc n')

-- μ on a product p·e whose every divisor ≥ 2 is ≥ p
mu-mult : (p e : ℕ) → 2 ≤ p → 1 ≤ e
        → ((d : ℕ) → 2 ≤ d → d ∣ (p · e) → p ≤ d)
        → mu (p · e) ≡ (if dividesb p e then pos 0 else negZ (mu e))
mu-mult p e 2≤p 1≤e least =
  subst (λ e' → mu m ≡ (if dividesb p e' then pos 0 else negZ (mu e'))) q≡e
    (subst (λ p' → mu m ≡ (if dividesb p' (m divN p') then pos 0 else negZ (mu (m divN p')))) spf≡p
           (mu-step m 2≤m))
  where
  m = p · e
  0<p : 0 < p
  0<p = ≤-trans (suc-≤-suc zero-≤) 2≤p
  p≤m : p ≤ m
  p≤m = subst (_≤ m) (·-identityˡ p) (subst (1 · p ≤_) (·-comm e p) (≤-·k {k = p} 1≤e))
  2≤m : 2 ≤ m
  2≤m = ≤-trans 2≤p p≤m
  spf≡p : spf m ≡ p
  spf≡p = ≤-antisym (spf-least m 2≤m p 2≤p (∣-left e))
                    (least (spf m) (2≤spf m 2≤m) (spf∣ m 2≤m))
  q≡e : m divN p ≡ e
  q≡e = fst (modN-unique m p e 0 0<p 0<p (+-zero (e · p) ∙ ·-comm e p))

------------------------------------------------------------------------
-- 5.  Σ_{d ∣ m} μ(d) = [m = 1].
--
-- For m ≥ 2 with p = spf m and m = p·c the divisors of m split into the
-- p-free ones — which are exactly the p-free divisors of c (Gauss's
-- lemma) — and the multiples p·e with e ∣ c, on which μ(p·e) is 0 when
-- p ∣ e and −μ(e) otherwise (`mu-mult`).  Summand by summand the second
-- half cancels the first.
------------------------------------------------------------------------

muSum : ℕ → ℤ
muSum m = Σ≤ (λ d → if dividesb d m then mu d else pos 0) m

muSum-0 : muSum 0 ≡ pos 0
muSum-0 = refl

muSum-1 : muSum 1 ≡ pos 1
muSum-1 = refl

-- Boolean helpers
dividesb-false→¬∣ : (d n : ℕ) → 0 < d → dividesb d n ≡ false → ¬ d ∣ n
dividesb-false→¬∣ d n 0<d e with dividesb-dec d n 0<d
... | inl (_ , e') = ⊥rec (true≢false (sym e' ∙ e))
... | inr (nh , _) = nh

bool-split : (b : Bool) (x : ℤ) → x ≡ (if b then pos 0 else x) +ℤ (if b then x else pos 0)
bool-split true x = pos0+ x
bool-split false x = refl

A-eq : (b₁ b₂ b₃ : Bool) (x : ℤ) → (b₁ ≡ false → b₂ ≡ b₃)
     → (if b₁ then pos 0 else (if b₂ then x else pos 0))
     ≡ (if b₃ then (if b₁ then pos 0 else x) else pos 0)
A-eq true b₂ true x _ = refl
A-eq true b₂ false x _ = refl
A-eq false b₂ b₃ x h = cong (λ b → if b then x else pos 0) (h refl)

cancel-bool : (b : Bool) (x : ℤ) → (if b then pos 0 else x) +ℤ (if b then pos 0 else negZ x) ≡ pos 0
cancel-bool true x = refl
cancel-bool false x = cong (x +ℤ_) (sym (pos0+ (- x))) ∙ -Cancel x

-- a positive product has positive factors; a prime's only divisors
prod-pos : (p c m : ℕ) → p · c ≡ m → 1 ≤ m → 1 ≤ c
prod-pos p zero m e 1≤m = ⊥rec (¬-<-zero (subst (1 ≤_) (sym e ∙ sym (0≡m·0 p)) 1≤m))
prod-pos p (suc c) m _ _ = suc-≤-suc zero-≤

0<· : (p e : ℕ) → 0 < p → 0 < e → 0 < p · e
0<· zero e h _ = ⊥rec (¬-<-zero h)
0<· (suc p') zero _ h = ⊥rec (¬-<-zero h)
0<· (suc p') (suc e') _ _ = suc-≤-suc zero-≤

cancel-∣ : (p e c : ℕ) → 0 < p → (p · e) ∣ (p · c) → e ∣ c
cancel-∣ zero e c 0<p _ = ⊥rec (¬-<-zero 0<p)
cancel-∣ (suc p') e c _ h =
  ∣-cancelʳ p' (subst2 _∣_ (·-comm (suc p') e) (·-comm (suc p') c) h)

-- Gauss's lemma, from the library's gcd (m·k) (n·k) ≡ gcd m n · k
coprime-of-prime : (p d : ℕ) → ((k : ℕ) → k ∣ p → (k ≡ 1) ⊎ (k ≡ p)) → ¬ p ∣ d → isGCD d p 1
coprime-of-prime p d prime ¬p∣d = (∣-oneˡ d , ∣-oneˡ p) , λ k (k∣d , k∣p) → only k k∣d k∣p
  where
  only : (k : ℕ) → k ∣ d → k ∣ p → k ∣ 1
  only k k∣d k∣p with prime k k∣p
  ... | inl k≡1 = ∣-refl k≡1
  ... | inr k≡p = ⊥rec (¬p∣d (subst (_∣ d) k≡p k∣d))

gauss : (p d c : ℕ) → isGCD d p 1 → d ∣ (p · c) → d ∣ c
gauss p d c cop d∣pc =
  subst (d ∣_) (gcd-factorʳ d p c ∙ cong (_· c) (isGCD→gcd≡ cop) ∙ ·-identityˡ c)
        (snd (gcdIsGCD (d · c) (p · c)) d (∣-left c , d∣pc))

muSum-big : (m : ℕ) → 2 ≤ m → muSum m ≡ pos 0
muSum-big m 2≤m =
  Σ≤-ext T (λ d → A d +ℤ B d) m (λ d _ _ → bool-split (dividesb p d) (T d))
  ∙ Σ≤-add A B m
  ∙ cong₂ _+ℤ_ stepA stepB
  ∙ sym (Σ≤-add A' (λ e → T (p · e)) c)
  ∙ Σ≤-zero (λ e → A' e +ℤ T (p · e)) c cancel
  where
  p = spf m
  c = m divN p
  1≤m : 1 ≤ m
  1≤m = ≤-trans (suc-≤-suc zero-≤) 2≤m
  m≢0 : ¬ m ≡ 0
  m≢0 m≡0 = ¬-<-zero (subst (1 ≤_) m≡0 1≤m)
  2≤p : 2 ≤ p
  2≤p = 2≤spf m 2≤m
  0<p : 0 < p
  0<p = 0<spf m 2≤m
  m≡pc : p · c ≡ m
  m≡pc = ·-comm p c ∙ divN-exact p m 0<p (spf∣ m 2≤m)
  1≤c : 1 ≤ c
  1≤c = prod-pos p c m m≡pc 1≤m
  c∣m : c ∣ m
  c∣m = subst (c ∣_) m≡pc (∣-right p)
  c≤m : c ≤ m
  c≤m = m∣n→m≤n m≢0 c∣m
  prime : (k : ℕ) → k ∣ p → (k ≡ 1) ⊎ (k ≡ p)
  prime = spf-prime m 2≤m

  T A B A' : ℕ → ℤ
  T d = if dividesb d m then mu d else pos 0
  A d = if dividesb p d then pos 0 else T d
  B d = if dividesb p d then T d else pos 0
  A' d = if dividesb d c then (if dividesb p d then pos 0 else mu d) else pos 0

  -- p-free divisors of m are p-free divisors of c
  d∣m→d∣c : (d : ℕ) → ¬ p ∣ d → d ∣ m → d ∣ c
  d∣m→d∣c d ¬p∣d d∣m = gauss p d c (coprime-of-prime p d prime ¬p∣d) (subst (d ∣_) (sym m≡pc) d∣m)
  d∣c→d∣m : (d : ℕ) → d ∣ c → d ∣ m
  d∣c→d∣m d d∣c = ∣-trans d∣c c∣m

  A-above : (d : ℕ) → c < d → d ≤ m → A d ≡ pos 0
  A-above d c<d _ with dividesb-dec p d 0<p
  ... | inl (_ , e) = if-true (_≡ pos 0) (pos 0) (T d) e refl
  ... | inr (¬p∣d , e) = if-false (_≡ pos 0) (pos 0) (T d) e T≡0
    where
    0<d : 0 < d
    0<d = ≤-trans (suc-≤-suc zero-≤) c<d
    T≡0 : T d ≡ pos 0
    T≡0 with dividesb-dec d m 0<d
    ... | inl (d∣m , _) = ⊥rec (<-asym c<d (m∣n→m≤n (λ c≡0 → ¬-<-zero (subst (1 ≤_) c≡0 1≤c)) (d∣m→d∣c d ¬p∣d d∣m)))
    ... | inr (_ , e') = if-false (_≡ pos 0) (mu d) (pos 0) e' refl

  A-below : (d : ℕ) → 1 ≤ d → d ≤ c → A d ≡ A' d
  A-below d 1≤d _ = A-eq (dividesb p d) (dividesb d m) (dividesb d c) (mu d) same
    where
    same : dividesb p d ≡ false → dividesb d m ≡ dividesb d c
    same e with dividesb-dec d m 1≤d
    ... | inl (d∣m , e₁) = e₁ ∙ sym (∣-dividesb d c 1≤d (d∣m→d∣c d (dividesb-false→¬∣ p d 0<p e) d∣m))
    ... | inr (¬d∣m , e₁) = e₁ ∙ sym (¬∣-dividesb d c 1≤d (λ d∣c → ¬d∣m (d∣c→d∣m d d∣c)))

  stepA : Σ≤ A m ≡ Σ≤ A' c
  stepA = Σ≤-above A c m c≤m A-above ∙ Σ≤-ext A A' c A-below

  stepB : Σ≤ B m ≡ Σ≤ (λ e → T (p · e)) c
  stepB = cong (Σ≤ B) (sym m≡pc) ∙ Σ≤-multiples p 0<p T c

  cancel : (e : ℕ) → 1 ≤ e → e ≤ c → A' e +ℤ T (p · e) ≡ pos 0
  cancel e 1≤e _ with dividesb-dec e c 1≤e
  ... | inl (e∣c , b₃) =
    cong₂ _+ℤ_ (if-true (_≡ (if dividesb p e then pos 0 else mu e)) _ (pos 0) b₃ refl)
               (if-true (_≡ mu (p · e)) (mu (p · e)) (pos 0) (∣-dividesb (p · e) m 0<pe pe∣m) refl
                ∙ mu-mult p e 2≤p 1≤e (λ d 2≤d d∣pe → spf-least m 2≤m d 2≤d (∣-trans d∣pe pe∣m)))
    ∙ cancel-bool (dividesb p e) (mu e)
    where
    pe∣m : (p · e) ∣ m
    pe∣m = subst2 _∣_ (·-comm e p) (m≡pc) (subst ((e · p) ∣_) (·-comm c p) (∣-multʳ p e∣c))
    0<pe : 0 < p · e
    0<pe = 0<· p e 0<p 1≤e
  ... | inr (¬e∣c , b₃) =
    cong₂ _+ℤ_ (if-false (_≡ pos 0) _ (pos 0) b₃ refl)
               (if-false (_≡ pos 0) (mu (p · e)) (pos 0)
                         (¬∣-dividesb (p · e) m 0<pe (λ pe∣m → ¬e∣c (cancel-∣ p e c 0<p (subst ((p · e) ∣_) (sym m≡pc) pe∣m))))
                         refl)
    where
    0<pe : 0 < p · e
    0<pe = 0<· p e 0<p 1≤e

-- THE INDICATOR: Σ_{d ∣ g} μ(d) is 1 at g = 1 and 0 elsewhere (0 included)
muSum-is-indicator : (g : ℕ) → (if eqb g 1 then pos 1 else pos 0) ≡ muSum g
muSum-is-indicator zero = refl
muSum-is-indicator (suc zero) = refl
muSum-is-indicator (suc (suc g')) = sym (muSum-big (suc (suc g')) (suc-≤-suc (suc-≤-suc zero-≤)))

------------------------------------------------------------------------
-- 6.  The gcd program is a gcd, and φ is a sum of indicators.
------------------------------------------------------------------------

gcdF-isGCD : (f a b : ℕ) → b < f → isGCD a b (gcdF f a b)
gcdF-isGCD zero a b b<0 = ⊥rec (¬-<-zero b<0)
gcdF-isGCD (suc f) a zero _ = zeroGCD a
gcdF-isGCD (suc f) a (suc b') sb<sf =
  stepGCD (subst (λ r → isGCD (suc b') r (gcdF f (suc b') (a modN suc b'))) (modN≡% a b') ih)
  where
  ih : isGCD (suc b') (a modN suc b') (gcdF f (suc b') (a modN suc b'))
  ih = gcdF-isGCD f (suc b') (a modN suc b')
         (≤-trans (snd (divN-modN a (suc b') (suc-≤-suc zero-≤))) (pred-≤-pred sb<sf))

gcdN-isGCD : (a b : ℕ) → isGCD a b (gcdN a b)
gcdN-isGCD a b =
  gcdF-isGCD (addN (addN a b) 1) a b
    (subst (b <_) (sym (addN≡+ (addN a b) 1 ∙ cong (_+ 1) (addN≡+ a b) ∙ +-comm (a + b) 1))
           (suc-≤-suc ≤SumRight))

gcdN-∣ : (d k n : ℕ) → d ∣ gcdN k n → (d ∣ k) × (d ∣ n)
gcdN-∣ d k n h = ∣-trans h (fst (fst (gcdN-isGCD k n))) , ∣-trans h (snd (fst (gcdN-isGCD k n)))

∣-gcdN : (d k n : ℕ) → d ∣ k → d ∣ n → d ∣ gcdN k n
∣-gcdN d k n a b = snd (gcdN-isGCD k n) d (a , b)

pos-if : (b : Bool) → pos (if b then 1 else 0) ≡ (if b then pos 1 else pos 0)
pos-if true = refl
pos-if false = refl

phiCount-Σ : (k n : ℕ) → pos (phiCount k n) ≡ Σ≤ (λ j → if eqb (gcdN j n) 1 then pos 1 else pos 0) k
phiCount-Σ zero n = refl
phiCount-Σ (suc k) n =
  cong pos (addN≡+ (if eqb (gcdN (suc k) n) 1 then 1 else 0) (phiCount k n))
  ∙ pos+ (if eqb (gcdN (suc k) n) 1 then 1 else 0) (phiCount k n)
  ∙ cong₂ _+ℤ_ (pos-if (eqb (gcdN (suc k) n) 1)) (phiCount-Σ k n)

divSumTo-Σ : (k n : ℕ) → divSumTo k n ≡ Σ≤ (λ d → if dividesb d n then mu d ·ℤ pos (n divN d) else pos 0) k
divSumTo-Σ zero n = refl
divSumTo-Σ (suc k) n =
  cong ((if dividesb (suc k) n then mu (suc k) ·ℤ pos (n divN suc k) else pos 0) +ℤ_) (divSumTo-Σ k n)

divSumMu-Σ : (k n : ℕ) → divSumMu k n ≡ Σ≤ (λ d → if dividesb d n then mu d else pos 0) k
divSumMu-Σ zero n = refl
divSumMu-Σ (suc k) n =
  cong ((if dividesb (suc k) n then mu (suc k) else pos 0) +ℤ_) (divSumMu-Σ k n)

------------------------------------------------------------------------
-- 7.  THE THEOREM.
------------------------------------------------------------------------

if-and : (b₁ b₂ : Bool) (x : ℤ)
       → (if (b₁ and b₂) then x else pos 0) ≡ (if b₂ then (if b₁ then x else pos 0) else pos 0)
if-and true true x = refl
if-and true false x = refl
if-and false true x = refl
if-and false false x = refl

if-cong : (b : Bool) {x y z w : ℤ} → (b ≡ true → x ≡ y) → (b ≡ false → z ≡ w)
        → (if b then x else z) ≡ (if b then y else w)
if-cong true h₁ _ = h₁ refl
if-cong false _ h₂ = h₂ refl

mobius-divisor-sum-is-phi : (n : ℕ) → 1 ≤ n → mobiusDivSum n ≡ pos (phi n)
mobius-divisor-sum-is-phi n 1≤n =
  divSumTo-Σ n n
  ∙ sym (Σ≤-ext (λ d → if dividesb d n then Σ≤ (λ j → if dividesb d j then mu d else pos 0) n else pos 0)
                 (λ d → if dividesb d n then mu d ·ℤ pos (n divN d) else pos 0) n count)
  ∙ sym (Σ≤-ext (λ d → Σ≤ (λ j → T2 d j) n) _ n
                 (λ d _ _ → Σ≤-if (dividesb d n) (λ j → if dividesb d j then mu d else pos 0) n))
  ∙ sym (Σ≤-swap (λ j d → T2 d j) n n)
  ∙ sym (Σ≤-ext (λ j → if eqb (gcdN j n) 1 then pos 1 else pos 0) (λ j → Σ≤ (λ d → T2 d j) n) n perj)
  ∙ sym (phiCount-Σ n n)
  where
  n≢0 : ¬ n ≡ 0
  n≢0 n≡0 = ¬-<-zero (subst (1 ≤_) n≡0 1≤n)

  T2 : ℕ → ℕ → ℤ
  T2 d j = if dividesb d n then (if dividesb d j then mu d else pos 0) else pos 0

  -- (ii): the indicator of gcd(j, n) = 1 as a sum over d ≤ n
  perj : (j : ℕ) → 1 ≤ j → j ≤ n
       → (if eqb (gcdN j n) 1 then pos 1 else pos 0) ≡ Σ≤ (λ d → T2 d j) n
  perj j _ _ =
    muSum-is-indicator g
    ∙ sym (Σ≤-above (λ d → if dividesb d g then mu d else pos 0) g n g≤n above)
    ∙ Σ≤-ext (λ d → if dividesb d g then mu d else pos 0) (λ d → T2 d j) n
             (λ d 1≤d _ → cong (λ b → if b then mu d else pos 0) (dividesb-gcd d 1≤d)
                          ∙ if-and (dividesb d j) (dividesb d n) (mu d))
    where
    g = gcdN j n
    g∣n : g ∣ n
    g∣n = snd (fst (gcdN-isGCD j n))
    g≢0 : ¬ g ≡ 0
    g≢0 g≡0 = n≢0 (sym (∣-zeroˡ (subst (_∣ n) g≡0 g∣n)))
    g≤n : g ≤ n
    g≤n = m∣n→m≤n n≢0 g∣n
    above : (d : ℕ) → g < d → d ≤ n → (if dividesb d g then mu d else pos 0) ≡ pos 0
    above d g<d _ =
      if-false (_≡ pos 0) (mu d) (pos 0)
               (¬∣-dividesb d g (≤-trans (suc-≤-suc zero-≤) g<d)
                            (λ d∣g → <-asym g<d (m∣n→m≤n g≢0 d∣g)))
               refl
    dividesb-gcd : (d : ℕ) → 1 ≤ d → dividesb d g ≡ (dividesb d j and dividesb d n)
    dividesb-gcd d 1≤d with dividesb-dec d g 1≤d
    ... | inl (d∣g , e) =
      e ∙ sym (cong₂ _and_ (∣-dividesb d j 1≤d (fst (gcdN-∣ d j n d∣g)))
                            (∣-dividesb d n 1≤d (snd (gcdN-∣ d j n d∣g))))
    ... | inr (¬d∣g , e) with dividesb-dec d j 1≤d
    ...   | inr (_ , e₁) = e ∙ sym (cong (_and dividesb d n) e₁)
    ...   | inl (d∣j , e₁) with dividesb-dec d n 1≤d
    ...     | inr (_ , e₂) = e ∙ sym (cong₂ _and_ e₁ e₂)
    ...     | inl (d∣n , _) = ⊥rec (¬d∣g (∣-gcdN d j n d∣j d∣n))

  -- (iii): the multiples of a divisor d of n in 1..n number n/d
  count : (d : ℕ) → 1 ≤ d → d ≤ n
        → (if dividesb d n then Σ≤ (λ j → if dividesb d j then mu d else pos 0) n else pos 0)
        ≡ (if dividesb d n then mu d ·ℤ pos (n divN d) else pos 0)
  count d 1≤d _ =
    if-cong (dividesb d n)
      (λ e → cong (Σ≤ (λ j → if dividesb d j then mu d else pos 0))
                  (sym (divN-exact d n 1≤d (dividesb-∣ d n 1≤d e)) ∙ ·-comm (n divN d) d)
             ∙ Σ≤-multiples d 1≤d (λ _ → mu d) (n divN d)
             ∙ Σ≤-const (mu d) (n divN d)
             ∙ ·Comm (pos (n divN d)) (mu d))
      (λ _ → refl)

-- the companion display of the same archive line, Σ_{δ ∣ ν} μ(δ) = [ν = 1],
-- which `TransmissionRefutations` checks to 12: now for every ν.
companion-display-holds : (n : ℕ) → divSumMu n n ≡ (if eqb n 1 then pos 1 else pos 0)
companion-display-holds n = divSumMu-Σ n n ∙ sym (muSum-is-indicator n)
