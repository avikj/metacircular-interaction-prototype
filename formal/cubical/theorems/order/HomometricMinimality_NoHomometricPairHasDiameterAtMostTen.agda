{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HomometricMinimality_NoHomometricPairHasDiameterAtMostTen
--
-- THE ABSENCE THIS MODULE CLOSES.  HomometricPair.agda certifies the
-- existence half of Theorem A(ii) — the 6-element sets
--
--     A = {0,1,2,6,8,11}      B = {0,1,6,7,9,11}
--
-- are homometric and not congruent — and states its own scope thus:
--
--     "THE SCOPE, EXACTLY: minimality ("no homometric pair of diameter
--      ≤ 10", "6 distinct pairs across 12 collision events").  That is
--      a 2^14-subset sweep, a separate and larger kernel run;
--      REPORT.md's minimality clause still rests on the legacy Python
--      search.  This module discharges the existence half only."
--
-- This module discharges the first minimality clause, "no homometric
-- pair of diameter ≤ 10", as a kernel-checked theorem:
--
--   `no-homometric-pair-of-diameter-≤10`
--     for ALL finite subsets V, W ⊆ ℤ of diameter ≤ 10, given in the
--     translation-normal form min = 0 (as 0-1 vectors over {0,…,d},
--     first and last entry true), if V and W have the same interval
--     vector — `HomometricPair.iv` applied to their sorted member lists,
--     i.e. the very function of the existence half — then V and W are
--     congruent, in the sense of `HomometricPair.Congruent`: W = V + 0
--     or W = (reflection of V) + 0.
--
-- HOW.  The normal form makes the sweep small: a set of diameter d in
-- normal form is {0} ∪ U ∪ {d} for an arbitrary U ⊆ {1,…,d−1}, so the
-- sets of diameter ≤ 10 are {0} together with one set per Bool-list of
-- length ≤ 9: 1 + Σ_{e ≤ 9} 2^e = 1024 sets.  `sweep 9` (§3) tabulates
-- each with its interval vector, then for every ordered pair with equal
-- vectors checks that the indicator vectors are equal or reverses of
-- each other (reversal of the indicator over {0,…,d} IS the reflection
-- x ↦ d − x).  `sweep-ok : sweep 9 ≡ true` is `refl`: the kernel runs
-- the whole 1024 × 1024 comparison.
--
-- SOUNDNESS is proved as ordinary Agda, not computed (§4–§6):
--   * `nfUpTo-complete`  every normal form of diameter ≤ 10 occurs in
--                        the enumeration (enumeration completeness);
--   * `nf-form`          every 0-1 vector with first and last entry
--                        true is a normal form (the decomposition
--                        v = true ∷ u ++ [true], or v = [true]);
--   * `pairs-sound`, `ok-sound`, `eqL-sound`, `eqN-sound`  the Boolean
--                        tests imply the propositions they test;
--   * `congruent-bridge` "equal or reversed" gives HomometricPair's
--                        `Congruent` with translation parameter 0.
--
-- CONTROLS (§8), so that none of this is vacuous:
--   * `sweep-fails-at-11 : sweep 10 ≡ false` — the same sweep one
--     diameter further DOES find a violation; and
--   * `A-B-violate` — the violating pair is exactly HomometricPair's
--     A and B: `ok` returns false on their table entries, and their
--     indicator vectors have `support` equal to A and B (by refl).
--
-- CHECKED FACTS ABOUT THE RANGE (§7), each an exhaustion over the 1024
-- normal forms and each therefore a theorem for diameter ≤ 10 only:
--   * `iv-total`     the interval vector counts every pairwise
--                    difference (no difference escapes the window
--                    1..11), so equality of `iv` is equality of the
--                    whole difference multiset;
--   * `reflect-iv`   reflection preserves the interval vector;
--   * `reflect-support`  the support of the reversed indicator is the
--                    sorted list of d ∸ x over the support — reversal
--                    of indicators is the reflection of HomometricPair
--                    (`reflect11` there, with 11 replaced by d).
--
-- WHAT IS NOT PROVED.  (i) `reflect-iv` and `reflect-support` are
-- established by exhaustion for diameter ≤ 10, not as general lemmas
-- for all d; the minimality theorem does not depend on them — the sweep
-- compares every pair directly, without symmetry reduction — they are
-- consistency checks tying reversal to the reflection of the existence
-- half.  (ii) The reduction of ℤ-congruence to the normal-form shapes is
-- inherited from HomometricPair, where it is a definition, not a
-- theorem.  (iii) The second minimality clause ("6 distinct pairs across
-- 12 collision events", a statement about diameter 11) is not touched.
--
-- TIMINGS (Agda 2.8.0, --safe, this machine): the whole file with the
-- sweep bound at diameter ≤ 6 (64 sets) checks in about 3 s; at
-- diameter ≤ 10 (1024 sets, 2^20 ordered pairs) in about 30 s.  The
-- diameter-≤-11 control is cheap because `all` stops at the first
-- failing pair.
------------------------------------------------------------------------

module HomometricMinimality_NoHomometricPairHasDiameterAtMostTen where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; predℕ ; +-zero ; +-suc ; injSuc)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; _or_ ; false≢true)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map ; length ; rev ; rev-rev)
open import Cubical.Data.Vec using (Vec ; foldr)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import HomometricPair using (A ; B ; iv ; diffs ; eqb ; shift ; Congruent ; sumV)

------------------------------------------------------------------------
-- 1.  Sets in normal form, as 0-1 vectors
--
--   A finite subset of ℤ with least element 0 and greatest element d is
--   recorded as its indicator over {0,…,d}: a Bool-list of length d+1
--   whose first and last entries are true.  `support` recovers the
--   sorted member list, the representation of HomometricPair.
------------------------------------------------------------------------

supportFrom : ℕ → List Bool → List ℕ
supportFrom i [] = []
supportFrom i (true ∷ bs) = i ∷ supportFrom (suc i) bs
supportFrom i (false ∷ bs) = supportFrom (suc i) bs

support : List Bool → List ℕ
support = supportFrom 0

hd : List Bool → Bool
hd [] = false
hd (b ∷ _) = b

lst : List Bool → Bool
lst [] = false
lst (b ∷ []) = b
lst (_ ∷ c ∷ bs) = lst (c ∷ bs)

-- the diameter of the set with indicator v is length v − 1
diameter : List Bool → ℕ
diameter v = predℕ (length v)

-- the normal forms, by their shape: {0} alone, or {0} ∪ U ∪ {d} with
-- U ⊆ {1,…,d−1} given by its indicator u (so d = 1 + length u)
data NF : Type where
  point : NF
  span  : List Bool → NF

full : List Bool → List Bool
full u = true ∷ (u ++ (true ∷ []))

toList : NF → List Bool
toList point = true ∷ []
toList (span u) = full u

diam : NF → ℕ
diam point = 0
diam (span u) = suc (length u)

------------------------------------------------------------------------
-- 2.  Enumeration
------------------------------------------------------------------------

-- all Bool-lists of length exactly n
allLists : ℕ → List (List Bool)
allLists zero = [] ∷ []
allLists (suc n) = map (true ∷_) (allLists n) ++ map (false ∷_) (allLists n)

-- all Bool-lists of length ≤ n
allUpTo : ℕ → List (List Bool)
allUpTo zero = allLists zero
allUpTo (suc n) = allLists (suc n) ++ allUpTo n

-- all normal forms of diameter ≤ suc e
nfUpTo : ℕ → List NF
nfUpTo e = point ∷ map span (allUpTo e)

------------------------------------------------------------------------
-- 3.  The Boolean sweep
------------------------------------------------------------------------

-- HomometricPair's interval vector, as a list (foldr from the library)
vecToList : Vec ℕ 11 → List ℕ
vecToList = foldr _∷_ []

ivL : List ℕ → List ℕ
ivL s = vecToList (iv s)

Entry : Type
Entry = List Bool × List ℕ

entry : NF → Entry
entry s = toList s , ivL (support (toList s))

-- the table is passed as an argument so that the evaluator shares it
table : ℕ → List Entry
table e = map entry (nfUpTo e)

eqB : Bool → Bool → Bool
eqB true true = true
eqB false false = true
eqB true false = false
eqB false true = false

eqL : List Bool → List Bool → Bool
eqL [] [] = true
eqL [] (_ ∷ _) = false
eqL (_ ∷ _) [] = false
eqL (x ∷ xs) (y ∷ ys) = if eqB x y then eqL xs ys else false

eqN : List ℕ → List ℕ → Bool
eqN [] [] = true
eqN [] (_ ∷ _) = false
eqN (_ ∷ _) [] = false
eqN (x ∷ xs) (y ∷ ys) = if eqb x y then eqN xs ys else false

-- the test on one ordered pair: same interval vector ⇒ same indicator,
-- or reversed indicator (reversal over {0,…,d} is x ↦ d − x)
ok : Entry → Entry → Bool
ok (a , p) (b , q) = if eqN p q then (eqL a b or eqL (rev a) b) else true

all : {X : Type} → (X → Bool) → List X → Bool
all f [] = true
all f (x ∷ xs) = if f x then all f xs else false

pairs : {X : Type} → (X → X → Bool) → List X → Bool
pairs f t = all (λ p → all (f p) t) t

-- the sweep over all normal forms of diameter ≤ suc e
sweep : ℕ → Bool
sweep e = pairs ok (table e)

-- THE KERNEL RUN: all 1024 × 1024 ordered pairs of diameter ≤ 10
sweep-ok : sweep 9 ≡ true
sweep-ok = refl

------------------------------------------------------------------------
-- 4.  Soundness of the Boolean tests
------------------------------------------------------------------------

if-true : (b c : Bool) → (if b then c else false) ≡ true → (b ≡ true) × (c ≡ true)
if-true true c h = refl , h
if-true false c h = ⊥-rec (false≢true h)

or-true : (b c : Bool) → (b or c) ≡ true → (b ≡ true) ⊎ (c ≡ true)
or-true true c h = inl refl
or-true false c h = inr h

eqB-sound : (x y : Bool) → eqB x y ≡ true → x ≡ y
eqB-sound true true h = refl
eqB-sound false false h = refl
eqB-sound true false h = sym h
eqB-sound false true h = h

eqL-sound : (xs ys : List Bool) → eqL xs ys ≡ true → xs ≡ ys
eqL-sound [] [] h = refl
eqL-sound [] (_ ∷ _) h = ⊥-rec (false≢true h)
eqL-sound (_ ∷ _) [] h = ⊥-rec (false≢true h)
eqL-sound (x ∷ xs) (y ∷ ys) h =
  cong₂ _∷_ (eqB-sound x y (fst (if-true _ _ h))) (eqL-sound xs ys (snd (if-true _ _ h)))

eqb-sound : (m n : ℕ) → eqb m n ≡ true → m ≡ n
eqb-sound zero zero h = refl
eqb-sound zero (suc n) h = ⊥-rec (false≢true h)
eqb-sound (suc m) zero h = ⊥-rec (false≢true h)
eqb-sound (suc m) (suc n) h = cong suc (eqb-sound m n h)

eqN-sound : (xs ys : List ℕ) → eqN xs ys ≡ true → xs ≡ ys
eqN-sound [] [] h = refl
eqN-sound [] (_ ∷ _) h = ⊥-rec (false≢true h)
eqN-sound (_ ∷ _) [] h = ⊥-rec (false≢true h)
eqN-sound (x ∷ xs) (y ∷ ys) h =
  cong₂ _∷_ (eqb-sound x y (fst (if-true _ _ h))) (eqN-sound xs ys (snd (if-true _ _ h)))

eqb-refl : (n : ℕ) → eqb n n ≡ true
eqb-refl zero = refl
eqb-refl (suc n) = eqb-refl n

eqN-refl : (xs : List ℕ) → eqN xs xs ≡ true
eqN-refl [] = refl
eqN-refl (x ∷ xs) = cong (λ b → if b then eqN xs xs else false) (eqb-refl x) ∙ eqN-refl xs

eqN-complete : (p q : List ℕ) → p ≡ q → eqN p q ≡ true
eqN-complete p q h = subst (λ r → eqN p r ≡ true) h (eqN-refl p)

ok-sound : (a b : List Bool) (p q : List ℕ) → p ≡ q → ok (a , p) (b , q) ≡ true
        → (a ≡ b) ⊎ (rev a ≡ b)
ok-sound a b p q h k
  with or-true _ _ (subst (λ c → (if c then (eqL a b or eqL (rev a) b) else true) ≡ true)
                          (eqN-complete p q h) k)
... | inl e = inl (eqL-sound a b e)
... | inr e = inr (eqL-sound (rev a) b e)

-- list membership
Mem : {X : Type} → X → List X → Type
Mem x [] = ⊥
Mem x (y ∷ ys) = (x ≡ y) ⊎ Mem x ys

Mem-++ˡ : {X : Type} {x : X} (xs ys : List X) → Mem x xs → Mem x (xs ++ ys)
Mem-++ˡ (y ∷ ys) zs (inl p) = inl p
Mem-++ˡ (y ∷ ys) zs (inr m) = inr (Mem-++ˡ ys zs m)

Mem-++ʳ : {X : Type} {x : X} (xs ys : List X) → Mem x ys → Mem x (xs ++ ys)
Mem-++ʳ [] ys m = m
Mem-++ʳ (y ∷ ys) zs m = inr (Mem-++ʳ ys zs m)

Mem-map : {X Y : Type} (f : X → Y) {x : X} (xs : List X) → Mem x xs → Mem (f x) (map f xs)
Mem-map f (y ∷ ys) (inl p) = inl (cong f p)
Mem-map f (y ∷ ys) (inr m) = inr (Mem-map f ys m)

all-sound : {X : Type} (f : X → Bool) (xs : List X) → all f xs ≡ true
          → (x : X) → Mem x xs → f x ≡ true
all-sound f (y ∷ ys) h x (inl p) = subst (λ z → f z ≡ true) (sym p) (fst (if-true _ _ h))
all-sound f (y ∷ ys) h x (inr m) = all-sound f ys (snd (if-true _ _ h)) x m

pairs-sound : {X : Type} (f : X → X → Bool) (t : List X) → pairs f t ≡ true
            → (x y : X) → Mem x t → Mem y t → f x y ≡ true
pairs-sound f t h x y mx my = all-sound (f x) t (all-sound (λ p → all (f p) t) t h x mx) y my

------------------------------------------------------------------------
-- 5.  Completeness of the enumeration
------------------------------------------------------------------------

allLists-complete : (u : List Bool) → Mem u (allLists (length u))
allLists-complete [] = inl refl
allLists-complete (true ∷ u) = Mem-++ˡ _ _ (Mem-map (true ∷_) _ (allLists-complete u))
allLists-complete (false ∷ u) = Mem-++ʳ _ _ (Mem-map (false ∷_) _ (allLists-complete u))

allUpTo-at : (n : ℕ) (u : List Bool) → length u ≡ n → Mem u (allUpTo n)
allUpTo-at zero u p = subst (λ m → Mem u (allLists m)) p (allLists-complete u)
allUpTo-at (suc n) u p = Mem-++ˡ _ _ (subst (λ m → Mem u (allLists m)) p (allLists-complete u))

allUpTo-complete : (k : ℕ) (u : List Bool) → Mem u (allUpTo (k + length u))
allUpTo-complete zero u = allUpTo-at (length u) u refl
allUpTo-complete (suc k) u = Mem-++ʳ _ _ (allUpTo-complete k u)

-- ENUMERATION COMPLETENESS: every normal form of diameter ≤ suc e is in
-- nfUpTo e.  (m ≤ n is Σ[ k ∈ ℕ ] k + m ≡ n in the library.)
nfUpTo-complete : (e : ℕ) (s : NF) → diam s ≤ suc e → Mem s (nfUpTo e)
nfUpTo-complete e point _ = inl refl
nfUpTo-complete e (span u) (k , p) =
  inr (Mem-map span (allUpTo e)
        (subst (λ m → Mem u (allUpTo m))
               (injSuc (sym (+-suc k (length u)) ∙ p))
               (allUpTo-complete k u)))

-- every Bool-list with last entry true is u ++ [true]
snoc-form : (w : List Bool) → lst w ≡ true → Σ[ u ∈ List Bool ] w ≡ u ++ (true ∷ [])
snoc-form [] h = ⊥-rec (false≢true h)
snoc-form (b ∷ []) h = [] , cong (_∷ []) h
snoc-form (b ∷ c ∷ w) h with snoc-form (c ∷ w) h
... | u , q = (b ∷ u) , cong (b ∷_) q

-- every 0-1 vector with first and last entry true is a normal form
nf-form : (v : List Bool) → hd v ≡ true → lst v ≡ true → Σ[ s ∈ NF ] toList s ≡ v
nf-form [] h _ = ⊥-rec (false≢true h)
nf-form (b ∷ []) h _ = point , cong (_∷ []) (sym h)
nf-form (b ∷ c ∷ w) h l with snoc-form (c ∷ w) l
... | u , q = span u , cong₂ _∷_ (sym h) (sym q)

length-snoc : (u : List Bool) (b : Bool) → length (u ++ (b ∷ [])) ≡ suc (length u)
length-snoc [] b = refl
length-snoc (x ∷ u) b = cong suc (length-snoc u b)

diam-toList : (s : NF) → diam s ≡ diameter (toList s)
diam-toList point = refl
diam-toList (span u) = sym (length-snoc u true)

------------------------------------------------------------------------
-- 6.  The theorem
------------------------------------------------------------------------

-- on normal forms, with the congruence spelled out on indicators
minimality-nf : (s t : NF) → diam s ≤ 10 → diam t ≤ 10
              → iv (support (toList s)) ≡ iv (support (toList t))
              → (toList s ≡ toList t) ⊎ (rev (toList s) ≡ toList t)
minimality-nf s t hs ht h =
  ok-sound (toList s) (toList t) _ _ (cong vecToList h)
    (pairs-sound ok (table 9) sweep-ok (entry s) (entry t)
      (Mem-map entry (nfUpTo 9) (nfUpTo-complete 9 s hs))
      (Mem-map entry (nfUpTo 9) (nfUpTo-complete 9 t ht)))

-- on arbitrary 0-1 vectors with first and last entry true
minimality : (v w : List Bool)
           → hd v ≡ true → lst v ≡ true → hd w ≡ true → lst w ≡ true
           → diameter v ≤ 10 → diameter w ≤ 10
           → iv (support v) ≡ iv (support w)
           → (v ≡ w) ⊎ (rev v ≡ w)
minimality v w hv lv hw lw dv dw h with nf-form v hv lv | nf-form w hw lw
... | s , ps | t , pt =
  subst2 (λ v' w' → (v' ≡ w') ⊎ (rev v' ≡ w')) ps pt
    (minimality-nf s t
      (subst (_≤ 10) (sym (diam-toList s ∙ cong diameter ps)) dv)
      (subst (_≤ 10) (sym (diam-toList t ∙ cong diameter pt)) dw)
      (subst2 (λ v' w' → iv (support v') ≡ iv (support w')) (sym ps) (sym pt) h))

-- translation by 0 is the identity on sorted lists
shift0 : (s : List ℕ) → shift 0 s ≡ s
shift0 [] = refl
shift0 (x ∷ xs) = cong₂ _∷_ (+-zero x) (shift0 xs)

-- "equal or reversed" is HomometricPair's Congruent, with the reversed
-- indicator's support as the normalized reflection and translation 0
congruent-bridge : (v w : List Bool) → (v ≡ w) ⊎ (rev v ≡ w)
                 → Congruent (support v) (support (rev v)) (support w)
congruent-bridge v w (inl p) = inl (0 , shift0 (support v) ∙ cong support p)
congruent-bridge v w (inr p) = inr (inr (inl (0 , shift0 (support (rev v)) ∙ cong support p)))

-- THE MINIMALITY CLAUSE: no homometric pair of diameter ≤ 10
no-homometric-pair-of-diameter-≤10 :
    (v w : List Bool)
  → hd v ≡ true → lst v ≡ true → hd w ≡ true → lst w ≡ true
  → diameter v ≤ 10 → diameter w ≤ 10
  → iv (support v) ≡ iv (support w)
  → Congruent (support v) (support (rev v)) (support w)
no-homometric-pair-of-diameter-≤10 v w hv lv hw lw dv dw h =
  congruent-bridge v w (minimality v w hv lv hw lw dv dw h)

-- the congruence relation used is symmetric (reversal is an involution)
congruence-symmetric : (v w : List Bool) → (v ≡ w) ⊎ (rev v ≡ w) → (w ≡ v) ⊎ (rev w ≡ v)
congruence-symmetric v w (inl p) = inl (sym p)
congruence-symmetric v w (inr p) = inr (cong rev (sym p) ∙ rev-rev v)

------------------------------------------------------------------------
-- 7.  Checked facts about the range (exhaustion over the 1024 forms)
------------------------------------------------------------------------

-- (a) the interval vector counts every pairwise difference
total-test : NF → Bool
total-test s = eqb (sumV (iv (support (toList s)))) (length (diffs (support (toList s))))

total-sweep : all total-test (nfUpTo 9) ≡ true
total-sweep = refl

iv-total : (s : NF) → diam s ≤ 10
         → sumV (iv (support (toList s))) ≡ length (diffs (support (toList s)))
iv-total s hs = eqb-sound _ _ (all-sound total-test (nfUpTo 9) total-sweep s (nfUpTo-complete 9 s hs))

-- (b) reflection preserves the interval vector
reflect-test : NF → Bool
reflect-test s = eqN (ivL (support (rev (toList s)))) (ivL (support (toList s)))

reflect-sweep : all reflect-test (nfUpTo 9) ≡ true
reflect-sweep = refl

reflect-iv : (s : NF) → diam s ≤ 10
           → ivL (support (rev (toList s))) ≡ ivL (support (toList s))
reflect-iv s hs = eqN-sound _ _ (all-sound reflect-test (nfUpTo 9) reflect-sweep s (nfUpTo-complete 9 s hs))

-- (c) reversing the indicator is the reflection x ↦ d ∸ x of the
--     member list (listed in increasing order), as in HomometricPair
reflectL : ℕ → List ℕ → List ℕ
reflectL d xs = rev (map (λ x → d ∸ x) xs)

support-test : NF → Bool
support-test s = eqN (support (rev (toList s))) (reflectL (diam s) (support (toList s)))

support-sweep : all support-test (nfUpTo 9) ≡ true
support-sweep = refl

reflect-support : (s : NF) → diam s ≤ 10
                → support (rev (toList s)) ≡ reflectL (diam s) (support (toList s))
reflect-support s hs = eqN-sound _ _ (all-sound support-test (nfUpTo 9) support-sweep s (nfUpTo-complete 9 s hs))

------------------------------------------------------------------------
-- 8.  Controls: one diameter further, the sweep fails, and it fails at
--     exactly the pair of the existence half
------------------------------------------------------------------------

-- interiors of A = {0,1,2,6,8,11} and B = {0,1,6,7,9,11}
uA uB : List Bool
uA = true ∷ true ∷ false ∷ false ∷ false ∷ true ∷ false ∷ true ∷ false ∷ false ∷ []
uB = true ∷ false ∷ false ∷ false ∷ false ∷ true ∷ true ∷ false ∷ true ∷ false ∷ []

uA-is-A : support (full uA) ≡ A
uA-is-A = refl

uB-is-B : support (full uB) ≡ B
uB-is-B = refl

A-B-diameter-11 : (diam (span uA) ≡ 11) × (diam (span uB) ≡ 11)
A-B-diameter-11 = refl , refl

-- the pair test itself rejects (A, B): same vector, neither equal nor
-- reversed — this is what `not-congruent` in HomometricPair proves
A-B-violate : ok (entry (span uA)) (entry (span uB)) ≡ false
A-B-violate = refl

-- and the full sweep over diameter ≤ 11 reports the failure
sweep-fails-at-11 : sweep 10 ≡ false
sweep-fails-at-11 = refl
