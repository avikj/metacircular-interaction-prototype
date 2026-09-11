{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module Candidate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Fin.Base using (Fin ; toℕ ; toℕ-injective)
open import Cubical.Data.Fin.Properties using (pigeonhole)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; _or_ ; not ; _⊕_ ; false≢true ; true≢false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

------------------------------------------------------------------------
-- §1  the binary column of a rational a/(suc b): long division, kept as
--     the remainder recursion, and the digit read at each step.
------------------------------------------------------------------------

śeṣa : (a b : ℕ) → ℕ → ℕ
śeṣa a b zero    = a mod (suc b)
śeṣa a b (suc n) = (2 · śeṣa a b n) mod (suc b)

dec→bool : {A : Type} → Dec A → Bool
dec→bool (yes _) = true
dec→bool (no _)  = false

aṅka : (a b : ℕ) → ℕ → Bool
aṅka a b n = dec→bool (≤Dec (suc b) (2 · śeṣa a b n))

------------------------------------------------------------------------
-- §2  eventually periodic, with the period and the preperiod bounded by
--     the denominator: a rational column repeats.
------------------------------------------------------------------------

EventuallyPeriodic : {A : Type} → (ℕ → A) → (bound : ℕ) → Type
EventuallyPeriodic s bound =
  Σ[ p ∈ ℕ ] Σ[ N ∈ ℕ ] (0 < p) × (p ≤ bound) × (N < bound) ×
    ((n : ℕ) → N ≤ n → s (n + p) ≡ s n)

śeṣa< : (a b n : ℕ) → śeṣa a b n < suc b
śeṣa< a b zero    = mod< b a
śeṣa< a b (suc n) = mod< b (2 · śeṣa a b n)

punar : (a b i j : ℕ) → śeṣa a b i ≡ śeṣa a b j → (k : ℕ) → śeṣa a b (i + k) ≡ śeṣa a b (j + k)
punar a b i j e zero    = subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y) (sym (+-zero i)) (sym (+-zero j)) e
punar a b i j e (suc k) =
  subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y) (sym (+-suc i k)) (sym (+-suc j k))
         (cong (λ r → (2 · r) mod (suc b)) (punar a b i j e k))

sthiti : (a b : ℕ) → Fin (suc (suc b)) → Fin (suc b)
sthiti a b (k , _) = śeṣa a b k , śeṣa< a b k

krama : (a b : ℕ) (i j : Fin (suc (suc b))) → ¬ i ≡ j → sthiti a b i ≡ sthiti a b j
      → Σ[ u ∈ ℕ ] Σ[ v ∈ ℕ ] (u < v) × (v < suc (suc b)) × (śeṣa a b u ≡ śeṣa a b v)
krama a b (i , i<) (j , j<) ne e with i ≟ j
... | lt i<j = i , j , i<j , j< , cong fst e
... | gt j<i = j , i , j<i , i< , sym (cong fst e)
... | eq i≡j = E.rec (ne (toℕ-injective i≡j))

rational→periodic : (a b : ℕ) → EventuallyPeriodic (aṅka a b) (suc b)
rational→periodic a b =
  let (i , j , ne , e) = pigeonhole ≤-refl (sthiti a b)
      (u , v , (d , du) , v< , eu) = krama a b i j ne e
  in suc d , u
   , (d , +-suc d 0 ∙ cong suc (+-zero d))
   , p≤ d u v du v<
   , N< d u v du v<
   , λ n (l , lu) →
       cong (λ r → dec→bool (≤Dec (suc b) (2 · r)))
            (subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y)
                    (sym (cong (_+ l) du) ∙ sym (samīkaraṇa d u l) ∙ cong (_+ suc d) lu)
                    (+-comm u l ∙ lu)
                    (punar a b v u (sym eu) l))
  where
  samīkaraṇa : (d u l : ℕ) → (l + u) + suc d ≡ (d + suc u) + l
  samīkaraṇa d u l = solveℕ!
  -- suc d ≤ v ≤ suc b   and   u < v ≤ suc b
  p≤ : (d u v : ℕ) → d + suc u ≡ v → v < suc (suc b) → suc d ≤ suc b
  p≤ d u v du v< = ≤-trans (u , (+-suc u d ∙ cong suc (+-comm u d) ∙ sym (+-suc d u)) ∙ du) (pred-≤-pred v<)
  N< : (d u v : ℕ) → d + suc u ≡ v → v < suc (suc b) → u < suc b
  N< d u v du v< = <≤-trans (d , du) (pred-≤-pred v<)

------------------------------------------------------------------------
-- §3  Rule 30 on a finite window: the middle column to depth D
------------------------------------------------------------------------

r30 : Bool → Bool → Bool → Bool
r30 l c r = l ⊕ (c or r)

step′ : Bool → List Bool → List Bool
step′ l []           = []
step′ l (c ∷ [])     = r30 l c false ∷ []
step′ l (c ∷ r ∷ xs) = r30 l c r ∷ step′ c (r ∷ xs)

iterate : ℕ → List Bool → List Bool
iterate zero    xs = xs
iterate (suc n) xs = step′ false (iterate n xs)

replicate : ℕ → Bool → List Bool
replicate zero    b = []
replicate (suc n) b = b ∷ replicate n b

seed : ℕ → List Bool
seed W = replicate W false ++ (true ∷ replicate W false)

nth : ℕ → List Bool → Bool
nth _       []       = false
nth zero    (x ∷ _)  = x
nth (suc n) (_ ∷ xs) = nth n xs

-- the column as one list: the middle cell of every row, in one pass
columnList : (D : ℕ) → List Bool
columnList D = go D (seed D)
  where
  go : ℕ → List Bool → List Bool
  go zero    row = []
  go (suc n) row = nth D row ∷ go n (step′ false row)

------------------------------------------------------------------------
-- §4  the finite decision: for every period p ≤ P and preperiod N < P,
--     a witness k where the column at N + k + p differs from N + k,
--     found by search and checked as one boolean.
------------------------------------------------------------------------

_==b_ : Bool → Bool → Bool
true  ==b true  = true
false ==b false = true
_     ==b _     = false

_<b_ : ℕ → ℕ → Bool
_     <b zero  = false
zero  <b suc _ = true
suc m <b suc n = m <b n

-- scan k upward from 0 with `fuel` steps: the first k at which the
-- (p,N)-shift disagrees, else the last k tried.  Linear: one recursive call.
search′ : List Bool → ℕ → ℕ → ℕ → ℕ → ℕ
search′ col p N zero       k = k
search′ col p N (suc fuel) k with not (nth (N + k + p) col ==b nth (N + k) col)
... | true  = k
... | false = search′ col p N fuel (suc k)

search : List Bool → ℕ → ℕ → ℕ → ℕ
search col p N fuel = search′ col p N fuel zero

valid : (D : ℕ) → List Bool → ℕ → ℕ → Bool
valid D col p N = ((N + k + p) <b D) and not (nth (N + k + p) col ==b nth (N + k) col)
  where k = search col p N D

allBelow : ℕ → (ℕ → Bool) → Bool
allBelow zero    f = true
allBelow (suc n) f = f n and allBelow n f

checkAll : (D P : ℕ) → List Bool → Bool
checkAll D P col = allBelow P (λ p → allBelow P (λ N → valid D col (suc p) N))

-- Bool → Prop bridges
and-true : (x y : Bool) → (x and y) ≡ true → (x ≡ true) × (y ≡ true)
and-true true  true  e = refl , refl
and-true true  false e = E.rec (false≢true e)
and-true false y     e = E.rec (false≢true e)

<b-sound : (m n : ℕ) → (m <b n) ≡ true → m < n
<b-sound m       zero    e = E.rec (false≢true e)
<b-sound zero    (suc n) e = suc-≤-suc zero-≤
<b-sound (suc m) (suc n) e = suc-≤-suc (<b-sound m n e)

==b-sound : (x y : Bool) → not (x ==b y) ≡ true → ¬ x ≡ y
==b-sound true  true  e = E.rec (false≢true e)
==b-sound false false e = E.rec (false≢true e)
==b-sound true  false e = true≢false
==b-sound false true  e = false≢true

allBelow-sound : (n : ℕ) (f : ℕ → Bool) → allBelow n f ≡ true → (k : ℕ) → k < n → f k ≡ true
allBelow-sound zero    f e k k< = E.rec (¬-<-zero k<)
allBelow-sound (suc n) f e k k< with k ≟ n
... | eq k≡n = subst (λ z → f z ≡ true) (sym k≡n) (fst (and-true (f n) (allBelow n f) e))
... | lt k<n = allBelow-sound n f (snd (and-true (f n) (allBelow n f) e)) k k<n
... | gt n<k = E.rec (¬m<m (≤<-trans n<k k<))

valid-sound : (D : ℕ) (col : List Bool) (p N : ℕ) → valid D col p N ≡ true
            → Σ[ k ∈ ℕ ] ((N + k + p < D) × (¬ (nth (N + k + p) col ≡ nth (N + k) col)))
valid-sound D col p N e =
  let k = search col p N D
      (a , b) = and-true _ _ e
  in k , <b-sound _ _ a , ==b-sound _ _ b

------------------------------------------------------------------------
-- §5  the theorem: Rule 30's middle column, to depth 64, is not the
--     column of any rational with denominator ≤ 16.
------------------------------------------------------------------------

D P : ℕ
D = 128
P = 32

nirṇaya : checkAll D P (columnList D) ≡ true
nirṇaya = refl

rule30≠rational : (a b : ℕ) → b < P
                → ((n : ℕ) → n < D → nth n (columnList D) ≡ aṅka a b n) → ⊥
rule30≠rational a b b< agree =
  let (p , N , (d , dp) , p≤ , N< , per) = rational→periodic a b
      p≡ : p ≡ suc d
      p≡ = sym dp ∙ +-suc d 0 ∙ cong suc (+-zero d)
      d<P : suc d ≤ P
      d<P = ≤-trans (subst (_≤ suc b) p≡ p≤) b<
      N<P : N < P
      N<P = <≤-trans N< b<
      row = allBelow-sound P (λ q → allBelow P (λ M → valid D (columnList D) (suc q) M)) nirṇaya d d<P
      v   = allBelow-sound P (λ M → valid D (columnList D) (suc d) M) row N N<P
      (k , below , ne) = valid-sound D (columnList D) (suc d) N v
      agree-hi = agree (N + k + suc d) below
      agree-lo = agree (N + k) (<-trans (k<k+p N k d) below)
      per-here = subst (λ q → aṅka a b (N + k + q) ≡ aṅka a b (N + k)) p≡ (per (N + k) (k , +-comm k N))
  in ne (agree-hi ∙ per-here ∙ sym agree-lo)
  where
  k<k+p : (N k d : ℕ) → N + k < N + k + suc d
  k<k+p N k d = d , solveℕ!
