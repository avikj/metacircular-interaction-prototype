{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गणना — the count.
--
-- Exact quantities of Rule 30's middle column on its first 4096 bits,
-- each decided by the kernel as one number or one boolean by refl:
--
--   ones            2028 of 4096;
--   first depth at which every 6-bit word has occurred   422,
--                                   every 8-bit word    1591,
--                                   every 9-bit word    2872,
--   and not one bit sooner: at depth 421 and at depth 1590 the words are
--   not all there (allWords ≡ false), at 1591 they are (≡ true).
--
-- The column, its windows and the marking table are computed once each
-- and shared; the table is forced at every step so the scan holds one
-- table and not a chain of pending updates.  Submitted to the yantra
-- (sadhana.patra) and accepted by its kernel, 2026-09-11; ~10 GB live,
-- run under `check`'s heap cap.
------------------------------------------------------------------------

module Ganana_TheFirstFourThousandNinetySixBitsOfRuleThirtysMiddleColumnHoldTwoThousandTwentyEightOnesAndEverySixEightAndNineBitWordHasOccurredByDepthFourHundredTwentyTwoFifteenNinetyOneAndTwentyEightSeventyTwoAndNotOneBitSooner where
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
-- §1  the binary column of a rational is periodic with N + p ≤ 2b + 1
------------------------------------------------------------------------

śeṣa : (a b : ℕ) → ℕ → ℕ
śeṣa a b zero    = a mod (suc b)
śeṣa a b (suc n) = (2 · śeṣa a b n) mod (suc b)

dec→bool : {A : Type} → Dec A → Bool
dec→bool (yes _) = true
dec→bool (no _)  = false

aṅka : (a b : ℕ) → ℕ → Bool
aṅka a b n = dec→bool (≤Dec (suc b) (2 · śeṣa a b n))

Periodic : (ℕ → Bool) → ℕ → ℕ → Type
Periodic s N p = (n : ℕ) → N ≤ n → s (n + p) ≡ s n

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

rational→periodic : (a b : ℕ) → Σ[ d ∈ ℕ ] Σ[ N ∈ ℕ ] (N + suc d ≤ b + suc b) × Periodic (aṅka a b) N (suc d)
rational→periodic a b =
  let (i , j , ne , e) = pigeonhole ≤-refl (sthiti a b)
      (u , v , (d , du) , v< , eu) = krama a b i j ne e
  in d , u
   , N+p≤ d u v du v<
   , λ n (l , lu) →
       cong (λ r → dec→bool (≤Dec (suc b) (2 · r)))
            (subst2 (λ x y → śeṣa a b x ≡ śeṣa a b y)
                    (sym (cong (_+ l) du) ∙ sym (samīkaraṇa d u l) ∙ cong (_+ suc d) lu)
                    (+-comm u l ∙ lu)
                    (punar a b v u (sym eu) l))
  where
  samīkaraṇa : (d u l : ℕ) → (l + u) + suc d ≡ (d + suc u) + l
  samīkaraṇa d u l = solveℕ!
  -- u + suc d ≤ u + v  (as d + suc u ≡ v)  ≤ b + suc b  (u ≤ b, v ≤ suc b)
  N+p≤ : (d u v : ℕ) → d + suc u ≡ v → v < suc (suc b) → u + suc d ≤ b + suc b
  N+p≤ d u v du v< =
    ≤-trans (u , eq1 d u ∙ cong (u +_) du)
            (≤-trans (≤-k+ {k = u} (pred-≤-pred v<))
                     (≤-+k {k = suc b} (pred-≤-pred (<≤-trans (d , du) (pred-≤-pred v<)))))
    where
    eq1 : (d u : ℕ) → u + (u + suc d) ≡ u + (d + suc u)
    eq1 d u = solveℕ!

------------------------------------------------------------------------
-- §2  Rule 30's middle column, one pass
------------------------------------------------------------------------

r30 : Bool → Bool → Bool → Bool
r30 l c r = l ⊕ (c or r)

step′ : Bool → List Bool → List Bool
step′ l []           = []
step′ l (c ∷ [])     = r30 l c false ∷ []
step′ l (c ∷ r ∷ xs) = r30 l c r ∷ step′ c (r ∷ xs)

replicate : ℕ → Bool → List Bool
replicate zero    b = []
replicate (suc n) b = b ∷ replicate n b

seed : ℕ → List Bool
seed W = replicate W false ++ (true ∷ replicate W false)

nth : ℕ → List Bool → Bool
nth _       []       = false
nth zero    (x ∷ _)  = x
nth (suc n) (_ ∷ xs) = nth n xs

-- a row is forced whole before the next is built: matching on the
-- conjunction of its cells evaluates every cell, so no row is retained
-- as a graph of thunks reaching back to the seed (the evaluator is
-- call-by-need; without this the 4096-step evolution holds the entire
-- light cone in memory)
andAll : List Bool → Bool
andAll []       = true
andAll (x ∷ xs) = x and andAll xs

colGo : (D : ℕ) → ℕ → List Bool → List Bool
colGo D zero    row = []
colGo D (suc n) row with andAll row
... | _ = nth D row ∷ colGo D n (step′ false row)

columnList : (D : ℕ) → List Bool
columnList D = colGo D D (seed D)

------------------------------------------------------------------------
-- §3  windows: the n-bit word at position i as a number < 2^n
------------------------------------------------------------------------

bit : Bool → ℕ
bit true  = 1
bit false = 0

win : (ℕ → Bool) → ℕ → ℕ → ℕ
win s i zero    = 0
win s i (suc n) = 2 · win s i n + bit (s (i + n))

win-agree : (s t : ℕ → Bool) (i n : ℕ) → ((j : ℕ) → j < i + n → s j ≡ t j) → win s i n ≡ win t i n
win-agree s t i zero    ag = refl
win-agree s t i (suc n) ag =
  cong₂ (λ x y → 2 · x + bit y)
        (win-agree s t i n (λ j j< → ag j (<≤-trans j< (subst (i + n ≤_) (sym (+-suc i n)) (≤-suc ≤-refl)))))
        (ag (i + n) (subst (i + n <_) (sym (+-suc i n)) ≤-refl))

win-shift : (s : ℕ → Bool) (N p : ℕ) → Periodic s N p → (i n : ℕ) → N ≤ i → win s (i + p) n ≡ win s i n
win-shift s N p per i zero    N≤i = refl
win-shift s N p per i (suc n) N≤i =
  cong₂ (λ x y → 2 · x + bit y)
        (win-shift s N p per i n N≤i)
        (cong s (eq2 i p n) ∙ per (i + n) (≤-trans N≤i (n , +-comm n i)))
  where
  eq2 : (i p n : ℕ) → (i + p) + n ≡ (i + n) + p
  eq2 i p n = solveℕ!

------------------------------------------------------------------------
-- §4  every position has a representative below N + p with the same windows
------------------------------------------------------------------------

module Red (s : ℕ → Bool) (N d : ℕ) (per : Periodic s N (suc d)) where

  red : (fuel i : ℕ) → i ≤ fuel → Σ[ j ∈ ℕ ] (j < N + suc d) × ((n : ℕ) → win s j n ≡ win s i n)
  red zero i i≤ = i , subst (_< N + suc d) (sym (≤0→≡0 i≤)) (subst (0 <_) (sym (+-suc N d)) (suc-≤-suc zero-≤)) , λ n → refl
  red (suc f) i i≤ with <Dec i (N + suc d)
  ... | yes q  = i , q , λ n → refl
  ... | no ¬q  =
    let (k , kp) = <-asym' ¬q                 -- k + (N + suc d) ≡ i
        i′ = k + N
        (j , j< , e) = red f i′ (pred-≤-pred (≤-trans (d , eq3 k N d) (subst (_≤ suc f) (sym kp) i≤)))
    in j , j< , λ n → e n ∙ sym (win-shift s N (suc d) per i′ n (k , refl))
                         ∙ cong (λ z → win s z n) (sym (+-assoc k N (suc d)) ∙ kp)
    where
    eq3 : (k N d : ℕ) → d + suc (k + N) ≡ k + (N + suc d)
    eq3 k N d = solveℕ!

------------------------------------------------------------------------
-- §5  the finite certificate: every n₀-bit word occurs in the first D bits
------------------------------------------------------------------------

and-true : (x y : Bool) → (x and y) ≡ true → (x ≡ true) × (y ≡ true)
and-true true  true  e = refl , refl
and-true true  false e = E.rec (false≢true e)
and-true false y     e = E.rec (false≢true e)

-- comparisons through builtin monus: one match on the result instead of
-- a unary descent through the literal (a descent costs the VALUE of the
-- number, and here the values are windows up to 2^n₀ and positions up
-- to D, compared 2^n₀ · D times)
-- (isZero is the library's, Cubical.Data.Nat.Base)

eqℕ : ℕ → ℕ → Bool
eqℕ m n = isZero (m ∸ n) and isZero (n ∸ m)

eqℕ-sound : (m n : ℕ) → eqℕ m n ≡ true → m ≡ n
eqℕ-sound zero    zero    e = refl
eqℕ-sound zero    (suc n) e = E.rec (false≢true (snd (and-true true false e)))
eqℕ-sound (suc m) zero    e = E.rec (false≢true (fst (and-true false true e)))
eqℕ-sound (suc m) (suc n) e = cong suc (eqℕ-sound m n e)

allBelow : ℕ → (ℕ → Bool) → Bool
allBelow zero    f = true
allBelow (suc n) f = f n and allBelow n f

allBelow-sound : (n : ℕ) (f : ℕ → Bool) → allBelow n f ≡ true → (k : ℕ) → k < n → f k ≡ true
allBelow-sound zero    f e k k< = E.rec (¬-<-zero k<)
allBelow-sound (suc n) f e k k< with k ≟ n
... | eq k≡n = subst (λ z → f z ≡ true) (sym k≡n) (fst (and-true (f n) (allBelow n f) e))
... | lt k<n = allBelow-sound n f (snd (and-true (f n) (allBelow n f) e)) k k<n
... | gt n<k = E.rec (¬m<m (≤<-trans n<k k<))

nthf : List Bool → ℕ → Bool
nthf col j = nth j col

-- the n-window at every position, in one pass over the list
windows : List Bool → ℕ → List ℕ
windows []       n = []
windows (x ∷ xs) n = win (nthf (x ∷ xs)) 0 n ∷ windows xs n

nthℕ : ℕ → List ℕ → ℕ
nthℕ _       []       = 0
nthℕ zero    (v ∷ _)  = v
nthℕ (suc i) (_ ∷ vs) = nthℕ i vs

length : List Bool → ℕ
length []       = 0
length (_ ∷ xs) = suc (length xs)

-- reading a window one cell further along the tail is reading it from the head
win-tail : (x : Bool) (xs : List Bool) (i n : ℕ) → win (nthf (x ∷ xs)) (suc i) n ≡ win (nthf xs) i n
win-tail x xs i zero    = refl
win-tail x xs i (suc n) = cong (λ v → 2 · v + bit (nth (i + n) xs)) (win-tail x xs i n)

windows-nth : (col : List Bool) (n i : ℕ) → i < length col → nthℕ i (windows col n) ≡ win (nthf col) i n
windows-nth []       n i       i< = E.rec (¬-<-zero i<)
windows-nth (x ∷ xs) n zero    i< = refl
windows-nth (x ∷ xs) n (suc i) i< = windows-nth xs n i (pred-≤-pred i<) ∙ sym (win-tail x xs i n)

_<b_ : ℕ → ℕ → Bool
m <b n = isZero (suc m ∸ n)

<b-sound : (m n : ℕ) → (m <b n) ≡ true → m < n
<b-sound m       zero    e = E.rec (false≢true e)
<b-sound zero    (suc n) e = suc-≤-suc zero-≤
<b-sound (suc m) (suc n) e = suc-≤-suc (<b-sound m n e)

-- the index of the first entry equal to w (scanning with fuel), else the last index tried
idxOf : List ℕ → ℕ → ℕ → ℕ
idxOf []       w k = k
idxOf (v ∷ vs) w k with eqℕ v w
... | true  = k
... | false = idxOf vs w (suc k)

-- the windows list and the length are computed ONCE, at allWords, and
-- passed in: an argument is one shared thunk for every word, where a
-- local definition inside occurs would be recomputed 2^n times
occurs : List ℕ → ℕ → ℕ → ℕ → Bool
occurs ws len n w = eqℕ (nthℕ k ws) w and ((k + n) <b suc len)
  where
  k = idxOf ws w 0

occurs-sound : (col : List Bool) (n w : ℕ) → 0 < n → occurs (windows col n) (length col) n w ≡ true
             → Σ[ k ∈ ℕ ] (win (nthf col) k n ≡ w) × (k + n ≤ length col)
occurs-sound col n w (m , mn) e =
  let k = idxOf (windows col n) w 0
      (a , b) = and-true _ _ e
      kn≤ = pred-≤-pred (<b-sound _ _ b)
  in k , sym (windows-nth col n k (k<len k kn≤)) ∙ eqℕ-sound _ _ a , kn≤
  where
  k<len : (k : ℕ) → k + n ≤ length col → k < length col
  k<len k q = ≤-trans (suc-≤-suc (m , +-comm m k)) (subst (_≤ length col) (cong (k +_) (sym mn ∙ +-comm m 1) ∙ +-suc k m) q)

-- `with` evaluates the windows list and the length to values that are
-- then passed as ARGUMENTS of the auxiliary function: one shared object
-- for all 2^n words.  Written inline as arguments of `occurs` they would
-- be closures over the same term, rebuilt and re-evaluated per word,
-- and the whole evolution with them.
allWords : List Bool → ℕ → Bool
allWords col n with windows col n | length col
... | ws | len = allBelow (2 ^ n) (occurs ws len n)

colGo-length : (D n : ℕ) (row : List Bool) → length (colGo D n row) ≡ n
colGo-length D zero    row = refl
colGo-length D (suc n) row with andAll row
... | _ = cong suc (colGo-length D n (step′ false row))

columnList-length : (D : ℕ) → length (columnList D) ≡ D
columnList-length D = colGo-length D D (seed D)


------------------------------------------------------------------------
-- §6′  computed quantities of the prefix: first depth at which every
--      n-bit word has occurred; the count of ones; the complexity p(n)
------------------------------------------------------------------------

-- a table of 2^n marks; setAt flips one to true
setAt : ℕ → List Bool → List Bool
setAt _       []       = []
setAt zero    (_ ∷ xs) = true ∷ xs
setAt (suc i) (x ∷ xs) = x ∷ setAt i xs

countTrue : List Bool → ℕ
countTrue []           = 0
countTrue (true ∷ xs)  = suc (countTrue xs)
countTrue (false ∷ xs) = countTrue xs

-- scanning the windows in order: the (1-based) number of windows read
-- when the table first fills; 0 if it never fills
firstAll′ : ℕ → List Bool → List ℕ → ℕ → ℕ
firstAll′ need table []       k = 0
firstAll′ need table (w ∷ ws) k with setAt w table
... | table′ with eqℕ (countTrue table′) need
...   | true  = suc k
...   | false = firstAll′ need table′ ws (suc k)

-- the first depth D such that every n-bit word occurs among the windows
-- of the first D bits: the number of windows read, plus n − 1
firstAll : List Bool → ℕ → ℕ
firstAll col n = firstAll′ (2 ^ n) (replicate (2 ^ n) false) (windows col n) 0 + (n ∸ 1)

ones : List Bool → ℕ
ones = countTrue

-- p(n) on the prefix: the number of distinct n-windows
-- the table is forced at every step (matching on its count), so the
-- scan holds one table and not a chain of D pending updates
mark : List Bool → List ℕ → List Bool
mark table []       = table
mark table (w ∷ ws) with setAt w table
... | table′ with countTrue table′
...   | _ = mark table′ ws

take : ℕ → List ℕ → List ℕ
take zero    _        = []
take _       []       = []
take (suc k) (w ∷ ws) = w ∷ take k ws

-- only the windows that lie inside the prefix: D − n + 1 of them (the
-- window list runs to the end of the column and pads with 0 past it,
-- which is harmless for occurrence, guarded there by k + n ≤ D, and
-- would overcount here)
distinct : List Bool → ℕ → ℕ
distinct col n = countTrue (mark (replicate (2 ^ n) false) (take (suc (length col ∸ n)) (windows col n)))

------------------------------------------------------------------------
-- §7  the quantities, each one boolean or one number by refl.  The column
--     is named once and shared.
------------------------------------------------------------------------

D₀ : ℕ
D₀ = 4096

-- the ones: 2028 of 4096
gaṇanā : ones (columnList D₀) ≡ 2028
gaṇanā = refl

-- first depth at which every n-bit word has occurred: 422, 1591, 2872
prathama₆ : firstAll (columnList D₀) 6 ≡ 422
prathama₆ = refl
prathama₈ : firstAll (columnList D₀) 8 ≡ 1591
prathama₈ = refl
prathama₉ : firstAll (columnList D₀) 9 ≡ 2872
prathama₉ = refl

-- and the complement, on the prefix one shorter: not all words yet
apūrṇa₆ : allWords (columnList 421) 6 ≡ false
apūrṇa₆ = refl
apūrṇa₈ : allWords (columnList 1590) 8 ≡ false
apūrṇa₈ = refl
pūrṇa₈ : allWords (columnList 1591) 8 ≡ true
pūrṇa₈ = refl

